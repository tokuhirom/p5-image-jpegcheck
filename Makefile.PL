use inc::Module::Install;
name 'Image-JpegCheck';
all_from 'lib/Image/JpegCheck.pm';

tests 't/*.t';
author_tests 'xt';

build_requires 'Test::More';
use_test_base;
auto_include;
WriteAll;
