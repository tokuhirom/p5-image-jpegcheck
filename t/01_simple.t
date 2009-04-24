use strict;
use warnings;
use Test::More tests => 4;
use Image::JpegCheck;

ok is_jpeg('t/foo.jpg');
ok ! is_jpeg('t/01_simple.t');
test_fh('t/foo.jpg', 1);
test_fh('t/01_simple.t', 0);

sub test_fh {
    my ($fname, $expected) = @_;

    open my $fh, '<', $fname or die;
    is((is_jpeg($fh) ? 1 : 0), $expected);
    close $fh;
}
