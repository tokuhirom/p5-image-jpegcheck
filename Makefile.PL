use inc::Module::Install;
name 'Image-JpegCheck';
all_from 'lib/Image/JpegCheck.pm';

my $no_xs;
for (@ARGV) {
    /^--pm/ and $no_xs = 1;
    /^--xs/ and $no_xs = 0;
}
if ($no_xs) {
    makemaker_args( CONFIGURE => sub {
        my $hash = $_[1];
        if ($no_xs) {
            @{ $hash }{ 'XS', 'C' } = ( {}, [] );
        }
        $hash;
    });
}

tests 't/*.t';
author_tests 'xt';

build_requires 'Test::More';
auto_include;
WriteAll;
