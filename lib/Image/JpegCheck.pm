package Image::JpegCheck;
use strict;
use warnings;
our $VERSION = '0.01';
our @ISA = qw/Exporter/;
our @EXPORT = ('is_jpeg');

eval {
    require XSLoader;
    XSLoader::load(__PACKAGE__, $VERSION);
    1;
} or do {
    require DynaLoader;
    push @ISA, 'DynaLoader';
    __PACKAGE__->bootstrap($VERSION);
};

sub is_jpeg {
    my ($file, ) = @_;
    if (ref $file) {
        return Image::JpegCheck::_is_jpeg($file);
    } else {
        open my $fh, '<', $file or die $!;
        my $ret = Image::JpegCheck::_is_jpeg($fh);
        close $fh;
        return $ret;
    }
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
