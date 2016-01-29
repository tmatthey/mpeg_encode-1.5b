/*
 * cdjpeg.h
 *
 * Copyright (C) 1994, Thomas G. Lane.
 * This file is part of the Independent JPEG Group's software.
 * For conditions of distribution and use, see the accompanying README file.
 *
 * This file contains common declarations for the sample applications
 * cjpeg and djpeg.  It is NOT used by the core JPEG library.
 */

#define JPEG_CJPEG_DJPEG
#include "jinclude.h"
#include "jpeglib.h"		/* not jpegint.h; these are not core modules */
#include "jerror.h"		/* get library error codes too */
#include "cderror.h"		/* get application-specific error codes */


/*
 * Object interface for cjpeg's source file decoding modules
 */

typedef struct cjpeg_source_struct * cjpeg_source_ptr;

struct cjpeg_source_struct {
  JMETHOD(void, start_input, (j_compress_ptr cinfo,
			      cjpeg_source_ptr sinfo));
  JMETHOD(JDIMENSION, get_pixel_rows, (j_compress_ptr cinfo,
				       cjpeg_source_ptr sinfo));
  JMETHOD(void, finish_input, (j_compress_ptr cinfo,
			       cjpeg_source_ptr sinfo));

  FILE *input_file;

  JSAMPARRAY buffer;
  JDIMENSION buffer_height;
};


/*
 * Object interface for djpeg's output file encoding modules
 */

typedef struct djpeg_dest_struct * djpeg_dest_ptr;

struct djpeg_dest_struct {
  /* start_output is called after jpeg_start_decompress finishes.
   * The color map will be ready at this time, if one is needed.
   */
  JMETHOD(void, start_output, (j_decompress_ptr cinfo,
			       djpeg_dest_ptr dinfo));
  /* Emit the specified number of pixel rows from the buffer. */
  JMETHOD(void, put_pixel_rows, (j_decompress_ptr cinfo,
				 djpeg_dest_ptr dinfo,
				 JDIMENSION rows_supplied));
  /* Finish up at the end of the image. */
  JMETHOD(void, finish_output, (j_decompress_ptr cinfo,
				djpeg_dest_ptr dinfo));

  /* Target file spec; filled in by djpeg.c after object is created. */
  FILE * output_file;

  /* Output pixel-row buffer.  Created by module init or start_output.
   * Width is cinfo->output_width * cinfo->output_components;
   * height is buffer_height.
   */
  JSAMPARRAY buffer;
  JDIMENSION buffer_height;
  JSAMPARRAY image_buffer[MAX_COMPONENTS];


};


/* Short forms of external names for systems with brain-damaged linkers. */

#ifdef NEED_SHORT_EXTERNAL_NAMES
#define jinit_read_gif		jIRdGIF
#define jinit_write_gif		jIWrGIF
#define jinit_read_ppm		jIRdPPM
#define jinit_write_ppm		jIWrPPM
#define jinit_read_raw		jIRdRAW
#define jinit_write_raw		jIWrRAW
#define jinit_read_rle		jIRdRLE
#define jinit_write_rle		jIWrRLE
#define jinit_read_targa	jIRdTarga
#define jinit_write_targa	jIWrTarga
#endif /* NEED_SHORT_EXTERNAL_NAMES */

/* Module selection routines for I/O modules. */

EXTERN cjpeg_source_ptr jinit_read_gif JPP((j_compress_ptr cinfo));
EXTERN djpeg_dest_ptr jinit_write_gif JPP((j_decompress_ptr cinfo));
EXTERN cjpeg_source_ptr jinit_read_ppm JPP((j_compress_ptr cinfo));
EXTERN djpeg_dest_ptr jinit_write_ppm JPP((j_decompress_ptr cinfo));
EXTERN cjpeg_source_ptr jinit_read_raw JPP((j_compress_ptr cinfo));
EXTERN djpeg_dest_ptr jinit_write_raw JPP((j_decompress_ptr cinfo));
EXTERN cjpeg_source_ptr jinit_read_rle JPP((j_compress_ptr cinfo));
EXTERN djpeg_dest_ptr jinit_write_rle JPP((j_decompress_ptr cinfo));
EXTERN cjpeg_source_ptr jinit_read_targa JPP((j_compress_ptr cinfo));
EXTERN djpeg_dest_ptr jinit_write_targa JPP((j_decompress_ptr cinfo));
