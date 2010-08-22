package Functions;

use strict;
use warnings;

use base 'Exporter';
use vars qw/ @EXPORT_OK /;
use Cell;
use Carp;
use List::Util qw/ reduce /;

BEGIN{
    @EXPORT_OK = qw/
        cons
        car
        cdr
        atom
        equal
        cond
        lambda
        list
        list_string
        nil
        t
    /;
}

our $NIL = Cell->new(is_nil => 1);
sub nil
{
    return $NIL;
}

our $T = "t";
sub t
{
    return $T;
}

sub equal
{
    my ($a, $b) = @_;
    return t if $a eq $b;
    return nil;
}

sub cons
{
    my ($thing, $list) = @_;
    return Cell->new(car => $thing, cdr => $list);
}

sub car
{
    my $thing = shift;
    confess "Argument to car must be a list" unless ref($thing) && ref($thing) eq 'Cell';
    return defined($thing->car()) ? $thing->car() : nil;
}

sub cdr
{
    my $thing = shift;
    confess "Argument to cdr must be a list" unless ref($thing) && ref($thing) eq 'Cell';
    return defined($thing->cdr()) ? $thing->cdr() : nil;
}

sub atom
{
    my $thing = shift;
    return nil if ref($thing) && ref($thing) eq 'Cell';
    return nil if equal($thing, nil);
    return t;
}

sub cond
{
    my @conditions = @_;
    for my $condition ( @conditions ) {
        if (equal(car($condition), nil)) {
            next;
        }
        return cons($condition);
    }
    return nil;
}

sub mapcar
{
    my ($list, $code) = @_;

    while (not equal(car($list), nil))
    {
        {
            local $_ = car($list);
            $code->();
            $list->car($_);
        }

        $list = cdr($list);
    }
}

sub maptree
{
    my ($tree, $code) = @_;
    mapcar($tree, sub {
        if (atom($_)) {
            $code->($_);
        } else {
            maptree($_, $code);
        }
    });
}

sub list_string
{
    my $list = shift;
    my @tokens;

    mapcar($list, sub {
        if(atom($_)) {
            push @tokens, $_;
        } else {
            push @tokens, list_string($_);
        }
    });

    return "(" . join(" ", @tokens) . ")";
}

sub lambda
{
    my ($arg_list, $expression) = @_;

    my %args;
    my $i = 0;
    mapcar($arg_list, sub { $args{$_} = $i++ });

    return sub {
        my $values = shift;
        my @values;
        mapcar($values, sub { push @values, $_ });

        maptree($expression, sub {
            if (defined $args{$_}) {
                $_ = $values[$args{$_}];
            }
        });
        return $expression;
    };
}

sub list
{
    reduce { cons($b, $a) } (nil, reverse @_);
}

1;
