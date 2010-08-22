use Test::More tests => 14;

BEGIN {
    use_ok('Cell');
    use_ok('Functions', qw/ cons car cdr nil list_string lambda list/);
}

my $a = Cell->new();
my $b = cons('b', $a);
my $c = cons(Cell->new(car => 'foo'), $b);

is $b->cdr(), $a,    "cdr";
is $b->car(), "b",   "car";
is $c->car()->car(), "foo", "another car";

is car($b), 'b', "car";
is car(car($c)), 'foo', "car car";

is cdr($b), $a, "cdr";
is cdr($c), $b, "cdr again";

is car(cons('b', 'c')), 'b';

is list_string(cons('a', cons('b', cons('c', nil)))), "(a b c)";
is list_string(cons(cons('a', cons('d')), cons('b', cons('c', nil)))), "((a d) b c)";

is list_string(list('a', 'b', 'c', 'd')), "(a b c d)";

my $l = lambda(list('x', 'y'), list('times', 'x', 'y'));
is list_string($l->(list(1, 2))), "(times 1 2)";
