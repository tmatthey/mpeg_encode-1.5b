/*
 * djpeg.c
 *
 * Copyright (C) 1991-1994, Thomas G. Lane.
 * This file is part of the Independent JPEG Group's software.
 * For conditions of distribution and use, see the accompanying README file.
 *
 * This file contains a command-line user interface for the JPEG decompressor.
 * It should work on any system with Unix- or MS-DOS-style command lines.
 *
 * Two different command line styles are permitted, depending on the
 * compile-time switch TWO_FILE_COMMANDLINE:
 *	djpeg [options]  inputfile outputfile
 *	djpeg [options]  [inputfile]
 * In the second style, output is always to standard output, which you'd
 * normally redirect to a file or pipe to some other program.  Input is
 * either from a named file or from standard input (typically redirected).
 * The second style is convenient on Unix but is unhelpful on systems that
 * don't support pipes.  Also, you MUST use the first style if your system
 * doesn't do binary I/O to stdin/stdout.
 * To simplify script writing, the "-outfile" switch is provided.  The syntax
 *	djpeg [options]  -outfile outputfile  inputfile
 * works regardless of which command line style is used.
 */

#include "cdjpeg.h"		/* Common decls for cjpeg/djpeg applications */
#define JMAKE_MSG_TABLE
#include "cderror.h"		/* create message string table */
#include "jversion.h"		/* for version message */

#ifdef HAVE_STDLIB_H
#include <stdlib.h>		/* to declare exit() */
#endif
#include <ctype.h>		/* to declare isupper(), tolower() */
#ifdef NEED_SIGNAL_CATCHER
#include <signal.h>		/* to declare signal() */
#endif
#ifdef USE_SETMODE
#include <fcntl.h>		/* to declare setmode() */
#endif

#ifdef THINK_C
#include <console.h>		/* command-line reader for Macintosh */
#endif

#ifdef DONT_USE_B_MODE		/* define mode parameters for fopen() */
#define READ_BINARY	"r"
#define WRITE_BINARY	"w"
#else
#define READ_BINARY	"rb"
#define WRITE_BINARY	"wb"
#endif

#ifndef EXIT_FAILURE		/* define exit() codes if not provided */
#define EXIT_FAILURE  1
#endif
#ifndef EXIT_SUCCESS
#ifdef VMS
#define EXIT_SUCCESS  1		/* VMS is very nonstandard */
#else
#define EXIT_SUCCESS  0
#endif
#endif
#ifndef EXIT_WARNING
#ifdef VMS
#define EXIT_WARNING  1		/* VMS is very nonstandard */
#else
#define EXIT_WARNING  2
#endif
#endif


/*
 * This list defines the known output image formats
 * (not all of which need be supported by a given version).
 * You can change the default output format by defining DEFAULT_FMT;
 * indeed, you had better do so if you undefine PPM_SUPPORTED.
 */

typedef enum {
	FMT_GIF,		/* GIF format */
	FMT_PPM,		/* PPM/PGM (PBMPLUS formats) */
	FMT_RLE,		/* RLE format */
	FMT_TARGA,		/* Targa format */
	FMT_TIFF,		/* TIFF format */
        FMT_RAW                 /* RAW YCbCr subsampled 4:2:2*/
} IMAGE_FORMATS;

#ifndef DEFAULT_FMT		/* so can override from CFLAGS in Makefile */
#define DEFAULT_FMT	FMT_PPM
#endif

static IMAGE_FORMATS requested_fmt;


/*
 * Signal catcher to ensure that temporary files are removed before aborting.
 * NB: for Amiga Manx C this is actually a global routine named _abort();
 * see -Dsignal_catcher=_abort in CFLAGS.  Talk about bogus...
 */

#ifdef NEED_SIGNAL_CATCHER

static j_common_ptr sig_cinfo;

GLOBAL void
signal_catcher (int signum)
{
  if (sig_cinfo != NULL) {
    if (sig_cinfo->err != NULL) /* turn off trace output */
      sig_cinfo->err->trace_level = 0;
    jpeg_destroy(sig_cinfo);	/* clean up memory allocation & temp files */
  }
  exit(EXIT_FAILURE);
}

#endif


/*
 * Argument-parsing code.
 * The switch parser is designed to be useful with DOS-style command line
 * syntax, ie, intermixed switches and file names, where only the switches
 * to the left of a given file name affect processing of that file.
 * The main program in this file doesn't actually use this capability...
 */


static char * progname;		/* program name for error messages */
static char * outfilename;	/* for -outfile switch */


LOCAL void
usage (void)
/* complain about bad command line */
{
  fprintf(stderr, "usage: %s [switches] ", progname);
#ifdef TWO_FILE_COMMANDLINE
  fprintf(stderr, "inputfile outputfile\n");
#else
  fprintf(stderr, "[inputfile]\n");
#endif

  fprintf(stderr, "Switches (names may be abbreviated):\n");
  fprintf(stderr, "  -colors N      Reduce image to no more than N colors\n");
#ifdef GIF_SUPPORTED
  fprintf(stderr, "  -gif           Select GIF output format\n");
#endif
#ifdef PPM_SUPPORTED
  fprintf(stderr, "  -pnm           Select PBMPLUS (PPM/PGM) output format (default)\n");
#endif
  fprintf(stderr, "  -quantize N    Same as -colors N\n");
#ifdef RLE_SUPPORTED
  fprintf(stderr, "  -rle           Select Utah RLE output format\n");
#endif
#ifdef TARGA_SUPPORTED
  fprintf(stderr, "  -targa         Select Targa output format\n");
#endif
#ifdef RAW_SUPPORTED
  fprintf(stderr, "  -raw           Select raw output format\n");
#endif
  fprintf(stderr, "Switches for advanced users:\n");
#ifdef BLOCK_SMOOTHING_SUPPORTED
  fprintf(stderr, "  -blocksmooth   Apply cross-block smoothing\n");
#endif
  fprintf(stderr, "  -grayscale     Force grayscale output\n");
  fprintf(stderr, "  -nodither      Don't use dithering in quantization\n");
  fprintf(stderr, "  -nosmooth      Don't use high-quality upsampling\n");
#ifdef QUANT_1PASS_SUPPORTED
  fprintf(stderr, "  -onepass       Use 1-pass quantization (fast, low quality)\n");
#endif
  fprintf(stderr, "  -maxmemory N   Maximum memory to use (in kbytes)\n");
  fprintf(stderr, "  -verbose  or  -debug   Emit debug output\n");
  exit(EXIT_FAILURE);
}


LOCAL boolean
keymatch (char * arg, const char * keyword, int minchars)
/* Case-insensitive matching of (possibly abbreviated) keyword switches. */
/* keyword is the constant keyword (must be lower case already), */
/* minchars is length of minimum legal abbreviation. */
{
  register int ca, ck;
  register int nmatched = 0;

  while ((ca = *arg++) != '\0') {
    if ((ck = *keyword++) == '\0')
      return FALSE;		/* arg longer than keyword, no good */
    if (isupper(ca))		/* force arg to lcase (assume ck is already) */
      ca = tolower(ca);
    if (ca != ck)
      return FALSE;		/* no good */
    nmatched++;			/* count matched characters */
  }
  /* reached end of argument; fail if it's too short for unique abbrev */
  if (nmatched < minchars)
    return FALSE;
  return TRUE;			/* A-OK */
}


LOCAL int
parse_switches (j_decompress_ptr cinfo, int last_file_arg_seen,
		int argc, char **argv)
/* Initialize cinfo with default switch settings, then parse option switches.
 * Returns argv[] index of first file-name argument (== argc if none).
 * Any file names with indexes <= last_file_arg_seen are ignored;
 * they have presumably been processed in a previous iteration.
 * (Pass 0 for last_file_arg_seen on the first or only iteration.)
 */
{
  int argn;
  char * arg;

  /* Set up default JPEG parameters. */
  requested_fmt = DEFAULT_FMT;	/* set default output file format */
  outfilename = NULL;
  cinfo->err->trace_level = 0;

  /* Scan command line options, adjust parameters */

  for (argn = 1; argn < argc; argn++) {
    arg = argv[argn];
    if (*arg != '-') {
      /* Not a switch, must be a file name argument */
      if (argn <= last_file_arg_seen) {
	outfilename = NULL;	/* -outfile applies to just one input file */
	continue;		/* ignore this name if previously processed */
      }
      break;			/* else done parsing switches */
    }
    arg++;			/* advance past switch marker character */

    if (keymatch(arg, "blocksmooth", 1)) {
      /* Enable cross-block smoothing. */
      cinfo->do_block_smoothing = TRUE;

    } else if (keymatch(arg, "colors", 1) || keymatch(arg, "colours", 1) ||
	       keymatch(arg, "quantize", 1) || keymatch(arg, "quantise", 1)) {
      /* Do color quantization. */
      int val;

      if (++argn >= argc)	/* advance to next argument */
	usage();
      if (sscanf(argv[argn], "%d", &val) != 1)
	usage();
      cinfo->desired_number_of_colors = val;
      cinfo->quantize_colors = TRUE;

    } else if (keymatch(arg, "debug", 1) || keymatch(arg, "verbose", 1)) {
      /* Enable debug printouts. */
      /* On first -d, print version identification */
      static boolean printed_version = FALSE;

      if (! printed_version) {
	fprintf(stderr, "Independent JPEG Group's DJPEG, version %s\n%s\n",
		JVERSION, JCOPYRIGHT);
	printed_version = TRUE;
      }
      cinfo->err->trace_level++;

    } else if (keymatch(arg, "gif", 1)) {
      /* GIF output format. */
      requested_fmt = FMT_GIF;

    } else if (keymatch(arg, "grayscale", 2) || keymatch(arg, "greyscale",2)) {
      /* Force monochrome output. */
      cinfo->out_color_space = JCS_GRAYSCALE;

    } else if (keymatch(arg, "maxmemory", 1)) {
      /* Maximum memory in Kb (or Mb with 'm'). */
      long lval;
      char ch = 'x';

      if (++argn >= argc)	/* advance to next argument */
	usage();
      if (sscanf(argv[argn], "%ld%c", &lval, &ch) < 1)
	usage();
      if (ch == 'm' || ch == 'M')
	lval *= 1000L;
      cinfo->mem->max_memory_to_use = lval * 1000L;

    } else if (keymatch(arg, "nodither", 3)) {
      /* Suppress dithering in color quantization. */
      cinfo->use_dithering = FALSE;

    } else if (keymatch(arg, "nosmooth", 3)) {
      /* Suppress fancy upsampling */
      cinfo->do_fancy_upsampling = FALSE;

    } else if (keymatch(arg, "onepass", 1)) {
      /* Use fast one-pass quantization. */
      cinfo->two_pass_quantize = FALSE;

    } else if (keymatch(arg, "outfile", 3)) {
      /* Set output file name. */
      if (++argn >= argc)	/* advance to next argument */
	usage();
      outfilename = argv[argn];	/* save it away for later use */

    } else if (keymatch(arg, "pnm", 1) || keymatch(arg, "ppm", 1)) {
      /* PPM/PGM output format. */
      requested_fmt = FMT_PPM;

    } else if (keymatch(arg, "rle", 1)) {
      /* RLE output format. */
      requested_fmt = FMT_RLE;

    } else if (keymatch(arg, "targa", 1)) {
      /* Targa output format. */
      requested_fmt = FMT_TARGA;

    } else if (keymatch(arg, "raw", 1)) {
      /* raw output format. */
      requested_fmt = FMT_RAW;

    } else {
      usage();			/* bogus switch */
    }
  }

  return argn;			/* return index of next arg (file name) */
}


/*
 * The main program.
 */

GLOBAL int
main (int argc, char **argv)
{
  struct jpeg_decompress_struct cinfo;
  struct jpeg_error_mgr jerr;
  int file_index;
  djpeg_dest_ptr dest_mgr = NULL;
  FILE * input_file;
  FILE * output_file;
  JDIMENSION num_scanlines;

  /* On Mac, fetch a command line. */
#ifdef THINK_C
  argc = ccommand(&argv);
#endif

  progname = argv[0];

  /* Initialize the JPEG decompression object with default error handling. */
  cinfo.err = jpeg_std_error(&jerr);
  jpeg_create_decompress(&cinfo);
  /* Add some application-specific error messages (from cderror.h) */
  jerr.addon_message_table = addon_message_table;
  jerr.first_addon_message = JMSG_FIRSTADDONCODE;
  jerr.last_addon_message = JMSG_LASTADDONCODE;

  /* Now safe to enable signal catcher. */
#ifdef NEED_SIGNAL_CATCHER
  sig_cinfo = (j_common_ptr) cinfo;
  signal(SIGINT, signal_catcher);
#ifdef SIGTERM			/* not all systems have SIGTERM */
  signal(SIGTERM, signal_catcher);
#endif
#endif

  /* Scan command line to find file names. */
  /* It is convenient to use just one switch-parsing routine, but the switch
   * values read here are ignored; we will rescan the switches after opening
   * the input file.
   */

  file_index = parse_switches(&cinfo, 0, argc, argv);

#ifdef TWO_FILE_COMMANDLINE
  /* Must have either -outfile switch or explicit output file name */
  if (outfilename == NULL) {
    if (file_index != argc-2) {
      fprintf(stderr, "%s: must name one input and one output file\n",
	      progname);
      usage();
    }
    outfilename = argv[file_index+1];
  } else {
    if (file_index != argc-1) {
      fprintf(stderr, "%s: must name one input and one output file\n",
	      progname);
      usage();
    }
  }
#else
  /* Unix style: expect zero or one file name */
  if (file_index < argc-1) {
    fprintf(stderr, "%s: only one input file\n", progname);
    usage();
  }
#endif /* TWO_FILE_COMMANDLINE */

  /* Open the input file. */
  if (file_index < argc) {
    if ((input_file = fopen(argv[file_index], READ_BINARY)) == NULL) {
      fprintf(stderr, "%s: can't open %s\n", progname, argv[file_index]);
      exit(EXIT_FAILURE);
    }
  } else {
    /* default input file is stdin */
#ifdef USE_SETMODE		/* need to hack file mode? */
    setmode(fileno(stdin), O_BINARY);
#endif
#ifdef USE_FDOPEN		/* need to re-open in binary mode? */
    if ((input_file = fdopen(fileno(stdin), READ_BINARY)) == NULL) {
      fprintf(stderr, "%s: can't open stdin\n", progname);
      exit(EXIT_FAILURE);
    }
#else
    input_file = stdin;
#endif
  }

  /* Open the output file. */
  if (outfilename != NULL) {
    if ((output_file = fopen(outfilename, WRITE_BINARY)) == NULL) {
      fprintf(stderr, "%s: can't open %s\n", progname, outfilename);
      exit(EXIT_FAILURE);
    }
  } else {
    /* default output file is stdout */
#ifdef USE_SETMODE		/* need to hack file mode? */
    setmode(fileno(stdout), O_BINARY);
#endif
#ifdef USE_FDOPEN		/* need to re-open in binary mode? */
    if ((output_file = fdopen(fileno(stdout), WRITE_BINARY)) == NULL) {
      fprintf(stderr, "%s: can't open stdout\n", progname);
      exit(EXIT_FAILURE);
    }
#else
    output_file = stdout;
#endif
  }

#ifdef PROGRESS_REPORT
  /* Enable progress display, unless trace output is on */
  if (jerr.trace_level == 0)
    dc_methods.progress_monitor = progress_monitor;
#endif

  /* Specify data source for decompression */
  jpeg_stdio_src(&cinfo, input_file);

  /* Read file header, set default decompression parameters */
  (void) jpeg_read_header(&cinfo, TRUE);

  /* Adjust default decompression parameters by re-parsing the options */
  file_index = parse_switches(&cinfo, 0, argc, argv);

  /* Initialize the output module now to let it override any crucial
   * option settings (for instance, GIF wants to force color quantization).
   */
  switch (requested_fmt) {
#ifdef GIF_SUPPORTED
  case FMT_GIF:
    dest_mgr = jinit_write_gif(&cinfo);
    break;
#endif
#ifdef PPM_SUPPORTED
  case FMT_PPM:
    dest_mgr = jinit_write_ppm(&cinfo);
    break;
#endif
#ifdef RAW_SUPPORTED
  case FMT_RAW:
    dest_mgr = jinit_write_raw(&cinfo);
    break;
#endif
#ifdef RLE_SUPPORTED
  case FMT_RLE:
    dest_mgr = jinit_write_rle(&cinfo);
    break;
#endif
#ifdef TARGA_SUPPORTED
  case FMT_TARGA:
    dest_mgr = jinit_write_targa(&cinfo);
    break;
#endif
  default:
    ERREXIT(&cinfo, JERR_UNSUPPORTED_FORMAT);
    break;
  }
  dest_mgr->output_file = output_file;

  /* Start decompressor */
  jpeg_start_decompress(&cinfo);

  /* Write output file header */
  (*dest_mgr->start_output) (&cinfo, dest_mgr);

  /* Process data */
  while (cinfo.output_scanline < cinfo.output_height) {
   if(!cinfo.want_raw_output ){
    num_scanlines = jpeg_read_scanlines(&cinfo, dest_mgr->buffer,
					dest_mgr->buffer_height);
  }else{
    num_scanlines = jpeg_read_raw_scanlines(&cinfo, dest_mgr->image_buffer,
                                        dest_mgr->buffer_height);
  }
    (*dest_mgr->put_pixel_rows) (&cinfo, dest_mgr, num_scanlines);
  }

  /* Finish decompression and release memory */
  (*dest_mgr->finish_output) (&cinfo, dest_mgr);
  jpeg_finish_decompress(&cinfo);
  jpeg_destroy_decompress(&cinfo);

#ifdef PROGRESS_REPORT
  /* Clear away progress display */
  if (jerr.trace_level == 0) {
    fprintf(stderr, "\r                \r");
    fflush(stderr);
  }
#endif

  /* All done. */
  exit(jerr.num_warnings ? EXIT_WARNING : EXIT_SUCCESS);
  return 0;			/* suppress no-return-value warnings */
}
