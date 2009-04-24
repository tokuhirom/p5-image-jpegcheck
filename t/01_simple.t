use strict;
use warnings;
use Test::More tests => 8;
use Image::JpegCheck;

ok is_jpeg('t/foo.jpg');
ok is_jpeg('t/bar.jpg');
ok ! is_jpeg('t/01_simple.t');
test_fh('t/foo.jpg', 1);
test_fh('t/01_simple.t', 0);
test_scalarref('t/foo.jpg', 1);
test_scalarref('t/01_simple.t', 0);

{
    local $@;
    eval { is_jpeg([]) };
    like $@, qr/is_jpeg requires file-glob or filename/;
}

sub test_fh {
    my ($fname, $expected) = @_;

    open my $fh, '<', $fname or die;
    is((is_jpeg($fh) ? 1 : 0), $expected);
    close $fh;
}

sub test_scalarref {
    my ($fname, $expected) = @_;

    open my $fh, '<', $fname or die "$fname: $!";
    my $src = do { local $/; <$fh> };
    close $fh;

    is((is_jpeg(\$src) ? 1 : 0), $expected);
}

