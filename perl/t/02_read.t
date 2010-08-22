use Test::More tests => 11;

BEGIN {
    use_ok('Cell');
    use_ok('Read', qw/ read_string /);
    use_ok('Functions', qw/ list /);
}

is read_string('zero'), 'zero';
is read_string("a"), 'a';
is read_string('0.1'), '0.1';
is read_string('"this is a string"'), 'this is a string';
is read_string('(a b c)'), list('a', 'b', 'c');
is read_string('(a b (c d))'), list('a', 'b', list('c', 'd'));

is read_string('(car (cdr (a b c)))'), list('car', list('cdr', list('a', 'b', 'c')));
is read_string('(foo "bar baz")'), list('foo', 'bar baz');
