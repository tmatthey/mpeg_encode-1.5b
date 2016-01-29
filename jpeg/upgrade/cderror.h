/*
 * cderror.h
 *
 * Copyright (C) 1994, Thomas G. Lane.
 * This file is part of the Independent JPEG Group's software.
 * For conditions of distribution and use, see the accompanying README file.
 *
 * This file defines the error and message codes for the cjpeg/djpeg
 * applications.  These strings are not needed as part of the JPEG library
 * proper.
 * Edit this file to add new codes, or to translate the message strings to
 * some other language.
 */


/* To define the enum list of message codes, include this file without
 * defining JMAKE_MSG_TABLE.  To create the message string table, include it
 * again with JMAKE_MSG_TABLE defined (this should be done in just one module).
 */

#ifdef JMAKE_MSG_TABLE

const char * const addon_message_table[] = {

#define JMESSAGE(code,string)	string ,

#else /* not JMAKE_MSG_TABLE */

typedef enum {

#define JMESSAGE(code,string)	code ,

#endif /* JMAKE_MSG_TABLE */

JMESSAGE(JMSG_FIRSTADDONCODE=1000, NULL) /* Must be first entry! */

#ifdef GIF_SUPPORTED
JMESSAGE(JERR_GIF_BUG, "GIF output got confused")
JMESSAGE(JERR_GIF_CODESIZE, "Bogus GIF codesize %d")
JMESSAGE(JERR_GIF_COLORSPACE, "GIF output must be grayscale or RGB")
JMESSAGE(JERR_GIF_IMAGENOTFOUND, "Too few images in GIF file")
JMESSAGE(JERR_GIF_NOT, "Not a GIF file")
JMESSAGE(JTRC_GIF, "%ux%ux%d GIF image")
JMESSAGE(JTRC_GIF_BADVERSION,
	 "Warning: unexpected GIF version number '%c%c%c'")
JMESSAGE(JTRC_GIF_EXTENSION, "Ignoring GIF extension block of type 0x%02x")
JMESSAGE(JTRC_GIF_NONSQUARE, "Caution: nonsquare pixels in input")
JMESSAGE(JWRN_GIF_BADDATA, "Corrupt data in GIF file")
JMESSAGE(JWRN_GIF_CHAR, "Bogus char 0x%02x in GIF file, ignoring")
JMESSAGE(JWRN_GIF_ENDCODE, "Premature end of GIF image")
JMESSAGE(JWRN_GIF_NOMOREDATA, "Ran out of GIF bits")
#endif /* GIF_SUPPORTED */

#ifdef PPM_SUPPORTED
JMESSAGE(JERR_PPM_SAMPLESIZE, "PPM code requires 8-bit JSAMPLEs")
JMESSAGE(JERR_PPM_COLORSPACE, "PPM output must be grayscale or RGB")
JMESSAGE(JERR_PPM_NONNUMERIC, "Nonnumeric data in PPM file")
JMESSAGE(JERR_PPM_NOT, "Not a PPM file")
JMESSAGE(JTRC_PGM, "%ux%u PGM image")
JMESSAGE(JTRC_PGM_TEXT, "%ux%u text PGM image")
JMESSAGE(JTRC_PPM, "%ux%u PPM image")
JMESSAGE(JTRC_PPM_TEXT, "%ux%u text PPM image")
#endif /* PPM_SUPPORTED */

#ifdef RAW_SUPPORTED
JMESSAGE(JERR_RAW_SAMPLESIZE, "raw code requires 8-bit JSAMPLEs")
JMESSAGE(JERR_RAW_COLORSPACE, "raw output must be YCbCr")
JMESSAGE(JERR_RAW_NONNUMERIC, "Nonnumeric data in raw file")
JMESSAGE(JERR_RAW_NOT, "Not a YCC file")
JMESSAGE(JTRC_RAW, "%ux%u YCC image")
JMESSAGE(JTRC_RAW_TEXT, "%ux%u text YCC image")
JMESSAGE(JERR_RAW_PPR, "put_pixel_row called")
JMESSAGE(JTRC_RAW_INIT, "init_write_raw called")
JMESSAGE(JTRC_RAW_IEND, "init_write_raw end")
JMESSAGE(JTRC_RAW_MAINCT, "process_data_raw_main called")
JMESSAGE(JTRC_RAW_MCTEND, "process_data_raw_main end")
JMESSAGE(JTRC_RAW_PUTEND, "put_pixel_row end")
JMESSAGE(JTRC_RAW_PUTROW, "row %u to be put")
#endif /* RAW_SUPPORTED */

#ifdef RLE_SUPPORTED
JMESSAGE(JERR_RLE_BADERROR, "Bogus error code from RLE library")
JMESSAGE(JERR_RLE_MEM, "Insufficient memory for RLE header")
JMESSAGE(JERR_RLE_NOT, "Not an RLE file")
JMESSAGE(JERR_RLE_TOOMANYCHANNELS, "Cannot handle %d output channels for RLE")
JMESSAGE(JERR_RLE_UNSUPPORTED, "Cannot handle this RLE setup")
JMESSAGE(JTRC_RLE, "%ux%u full-color RLE file")
JMESSAGE(JTRC_RLE_FULLMAP, "%ux%u full-color RLE file with map of length %d")
JMESSAGE(JTRC_RLE_GRAY, "%ux%u grayscale RLE file")
JMESSAGE(JTRC_RLE_MAPPED, "%ux%u colormapped RLE file with map of length %d")
#endif /* RLE_SUPPORTED */

#ifdef TARGA_SUPPORTED
JMESSAGE(JERR_TGA_BADCMAP, "Unsupported Targa colormap format")
JMESSAGE(JERR_TGA_BADPARMS, "Invalid or unsupported Targa file")
JMESSAGE(JERR_TGA_COLORSPACE, "Targa output must be grayscale or RGB")
JMESSAGE(JTRC_TGA, "%ux%u RGB Targa image")
JMESSAGE(JTRC_TGA_GRAY, "%ux%u grayscale Targa image")
JMESSAGE(JTRC_TGA_MAPPED, "%ux%u colormapped Targa image")
#else
JMESSAGE(JERR_TGA_NOTCOMP, "Targa support was not compiled")
#endif /* TARGA_SUPPORTED */

JMESSAGE(JERR_TOO_MANY_COLORS,
	 "Output file format cannot handle %d colormap entries")
JMESSAGE(JERR_UNGETC_FAILED, "ungetc failed")
#ifdef TARGA_SUPPORTED
JMESSAGE(JERR_UNKNOWN_FORMAT,
	 "Unrecognized input file format --- perhaps you need -targa")
#else
JMESSAGE(JERR_UNKNOWN_FORMAT, "Unrecognized input file format")
#endif
JMESSAGE(JERR_UNSUPPORTED_FORMAT, "Unsupported output file format")

#ifdef JMAKE_MSG_TABLE

  NULL
};

#else /* not JMAKE_MSG_TABLE */

  JMSG_LASTADDONCODE
} ADDON_MESSAGE_CODE;

#endif /* JMAKE_MSG_TABLE */

#undef JMESSAGE
