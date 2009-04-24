#include "EXTERN.h"
#include "perl.h"
#include "XSUB.h"
#include "ppport.h"

#define SIZE_FIRST  0xC0
#define SIZE_LAST   0xC3

#define RET(n) XSRETURN_IV((n))

MODULE = Image::JpegCheck   PACKAGE = Image::JpegCheck

PROTOTYPES: DISABLE

void
_is_jpeg(PerlIO * fp)
PREINIT:
    unsigned char buf[4];
    long len;
PPCODE:
    /* jpeg magick */
    if (PerlIO_getc(fp) != 0xFF || PerlIO_getc(fp) != 0xD8) {
        XSRETURN_NO;
    }

    /* validate segments */
    while (1) {
        if (PerlIO_read(fp, buf, 4) != 4) {
            XSRETURN_NO;
        }

        if (buf[0] != 0xFF) {
            XSRETURN_NO; /* invalid marker */
        }
        if ((buf[1] >= SIZE_FIRST) && (buf[1] <= SIZE_LAST)) {
            XSRETURN_YES;
        }

        /* skip segment body */
        len = (buf[2]<<8) | buf[3]; /* network byte order */
        if (PerlIO_seek(fp, len-2, SEEK_CUR) != 0) {
            XSRETURN_NO;
        }
    }

