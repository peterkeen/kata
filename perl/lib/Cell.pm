package Cell;

use Moose;
use overload
    'bool' => sub { return !shift->is_nil() },
    'fallback' => 1
;

has 'car'    => (is => 'rw');
has 'cdr'    => (is => 'rw');
has 'is_nil' => (is => 'ro', default => 0);

1;
