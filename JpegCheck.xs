#ifdef __cplusplus
extern "C" {
#endif

#include "EXTERN.h"
#include "perl.h"
#include "XSUB.h"
#include "ppport.h"

#include <jpeglib.h>
#include <setjmp.h>

#ifdef __cplusplus
}
#endif

struct my_error_mgr {
    struct jpeg_error_mgr pub;
    jmp_buf setjmp_buffer;
};

METHODDEF(void)
my_error_exit (j_common_ptr cinfo) {
    struct my_error_mgr * myerr = (struct my_error_mgr *) cinfo->err; /* black magick... */
    longjmp(myerr->setjmp_buffer, 1);
}

MODULE = Image::JpegCheck  PACKAGE = Image::JpegCheck

int
_is_jpeg(FILE *infile)
PREINIT:
    struct jpeg_decompress_struct cinfo;
    struct my_error_mgr jerr;
CODE:
    cinfo.err = jpeg_std_error(&jerr.pub);
    jerr.pub.error_exit = my_error_exit;
    if (setjmp(jerr.setjmp_buffer)) {
        jpeg_destroy_decompress(&cinfo);

        RETVAL = 0;
    } else {
        jpeg_create_decompress(&cinfo);
        jpeg_stdio_src(&cinfo, infile);
        jpeg_read_header(&cinfo, TRUE);
        jpeg_destroy_decompress(&cinfo);

        RETVAL = 1;
    }
OUTPUT:
    RETVAL

