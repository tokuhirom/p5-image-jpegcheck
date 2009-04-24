use strict;
use warnings;
use Test::More tests => 9;
use Image::JpegCheck;

test_whole('t/foo.jpg',     1);
test_whole('t/bar.jpg',     1);
test_whole('t/01_simple.t', 0);

sub test_whole {
    my ($src, $expected) = @_;
    test($src, $expected);
    test_fh($src, $expected);
    test_scalarref($src, $expected);
}

sub test_fh {
    my ($fname, $expected) = @_;

    open my $fh, '<', $fname or die;
    test($fh, $expected);
    close $fh;
}

sub test_scalarref {
    my ($fname, $expected) = @_;

    open my $fh, '<', $fname or die "$fname: $!";
    my $src = do { local $/; <$fh> };
    close $fh;

    test(\$src, $expected);
}

sub test {
    my ($src, $expected) = @_;
    is((is_jpeg($src) ? 1 : 0), $expected);
}

