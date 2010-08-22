package Cell;

use Moose;
use overload
    'bool' => sub { return !shift->is_nil() },
    'fallback' => 1
;

has 'car'    => (is => 'rw', predicate => 'has_car');
has 'cdr'    => (is => 'rw', predicate => 'has_cdr');
has 'is_nil' => (is => 'ro', default => 0);

1;
