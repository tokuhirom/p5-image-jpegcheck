#include "EXTERN.h"
#include "perl.h"
#include "XSUB.h"
#include "ppport.h"

#define SIZE_FIRST  0xC0
#define SIZE_LAST   0xC3

#define RET(n) XSRETURN_IV((n));goto end

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
        RET(0);
    }

    /* validate segments */
    while (1) {
        if (PerlIO_read(fp, buf, 4) != 4) {
            RET(0);
        }

        if (buf[0] != 0xFF) {
            RET(0); /* invalid marker */
        }
        if ((buf[1] >= SIZE_FIRST) && (buf[1] <= SIZE_LAST)) {
            RET(1);
        }

        /* skip segment body */
        len = (buf[2]<<8) | buf[3]; /* network byte order */
        if (PerlIO_seek(fp, len-2, SEEK_CUR) != 0) {
            RET(0);
        }
    }
    end:

