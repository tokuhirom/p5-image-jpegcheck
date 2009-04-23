use strict;
use warnings;
use Test::More tests => 4;
use Image::JpegCheck;

is is_jpeg('t/foo.jpg'), 1;
is is_jpeg('t/01_simple.t'), 0;
test_fh('t/foo.jpg', 1);
test_fh('t/01_simple.t', 0);

sub test_fh {
    my ($fname, $expected) = @_;

    open my $fh, '<', $fname or die;
    is is_jpeg($fh), $expected;
    close $fh;
}
