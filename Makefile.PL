use inc::Module::Install;
name 'Image-JpegCheck';
all_from 'lib/Image/JpegCheck.pm';

tests 't/*.t';
author_tests 'xt';

auto_set_repository;
build_requires 'Test::More';
auto_include;
WriteAll;
