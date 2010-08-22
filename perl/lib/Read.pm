package Read;

use strict;
use warnings;

use base 'Exporter';
use vars qw/ @EXPORT_OK /;
use Cell;
use Functions qw/ nil cons /;
use IO::Scalar;

BEGIN {
    @EXPORT_OK = qw/
        read_string
        read_stream
    /;
}

sub read_string
{
    my $string = shift;
    my @symbols = split(//, $string);
    return read_stream(\@symbols);
}

sub read_stream
{
    my $stream = shift;

    while (defined(my $char = shift @$stream)) {
        if ($char =~ /\d/) {
            return read_number($char, $stream)
        } elsif ($char eq '"') {
            return read_string_literal($stream);
        } elsif ($char =~ /[a-zA-Z]/) {
            return read_symbol($char, $stream);
        } elsif ($char eq '(') {
            return read_list($char, $stream);
        } elsif ($char =~ /\s/) {
            next;
        }
    }

    die "Encounted unexpected end of stream";
}

sub read_number
{
    my ($number, $stream) = @_;

    while (my $char = shift @$stream) {
        if ($char =~ /[0-9.]/) {
            $number .= $char;
        } elsif ($char =~ /\s/) {
            return $number;
        } else {
            die "Encountered a non-number character in stream";
        }
    }

    return $number;
}

sub read_symbol
{
    my ($symbol, $stream) = @_;
    while (my $char = shift @$stream) {
        if ($char =~ /[a-zA-Z0-9_:-]/) {
            $symbol .= $char;
        } elsif ($char =~ /\s/) {
            return $symbol;
        } elsif ($char eq ')') {
            unshift @$stream, $char;
            return $symbol;
        } else {
            die "Encountered a non-symbol character in stream: '$char'";
        }
    }

    return $symbol;
}

sub read_string_literal
{
    my $stream = shift;

    my $string = "";
    while (defined(my $char = shift @$stream)) {
        if ($char ne '"') {
            $string .= $char;
        } else {
            return $string;
        }
    }

    die "Encountered unexpected end of stream";
}

sub read_list
{
    my ($start, $stream) = @_;

    my $list = nil;

    do {
        $list = cons(read_stream($stream), $list);
    } while ($stream->[0] ne ")");

    return $list;
}

1;
