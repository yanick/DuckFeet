package DuckFeet;

use strict;
use warnings;

use Moose;

use DuckFeet::Schema;

has importer => (
    is => 'ro',
);

with 'MooseX::Role::BuildInstanceOf' => {
    target => '::Schema',
    constructor => 'connect',
};



__PACKAGE__->meta->make_immutable;

1;
