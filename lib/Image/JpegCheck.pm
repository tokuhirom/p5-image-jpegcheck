package Image::JpegCheck;
use strict;
use warnings;
use bytes;
use Fcntl ':seek';
our $VERSION = '0.01';
our @ISA = qw/Exporter/;
our @EXPORT = ('is_jpeg');

sub is_jpeg {
    my ($file, ) = @_;
    if (ref $file) {
        return Image::JpegCheck::_is_jpeg($file);
    } else {
        open my $fh, '<', $file or die $!;
        binmode $fh;
        my $ret = Image::JpegCheck::_is_jpeg($fh);
        close $fh;
        return $ret;
    }
}

sub _is_jpeg {
    my $fh = $_[0];
    my ($buf, $code, $marker, $len);

    read($fh, $buf, 2);
    return 0 if $buf ne "\xFF\xD8";

    my $SIZE_FIRST  = 0xC0;         # Range of segment identifier codes
    my $SIZE_LAST   = 0xC3;         #  that hold size info.

    while (1) {
        read($fh, $buf, 4);
        ($marker, $code, $len) = unpack("a a n", $buf); # read segment header
        $code = ord($code);

        if ($marker ne "\xFF") {
            return 0; # invalid marker
        } elsif (($code >= $SIZE_FIRST) && ($code <= $SIZE_LAST)) {
            return 1; # got a size info
        } else {
            seek $fh, $len-2, SEEK_CUR; # skip segment body
        }
    }
    die "should not reach here";
}

1;
__END__

=head1 NAME

Image::JpegCheck -

=head1 SYNOPSIS

  use Image::JpegCheck;
  is_jpeg('foo.jpg'); # => return 1 when this is jpeg

=head1 DESCRIPTION

Image::JpegCheck is

=head1 AUTHOR

Tokuhiro Matsuno E<lt>tokuhirom ah! gmail.comE<gt>

=head1 SEE ALSO

=head1 LICENSE

This library is free software; you can redistribute it and/or modify
it under the same terms as Perl itself.

=cut
