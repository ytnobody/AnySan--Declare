use inc::Module::Install;
name 'AnySan-Declare';
all_from 'lib/AnySan/Declare.pm';

# requires '';

tests 't/*.t';
author_tests 'xt';

test_requires 'Test::More';
auto_set_repository;
auto_include;
WriteAll;
