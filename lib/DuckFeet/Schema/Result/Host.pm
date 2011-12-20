package DuckFeet::Schema::Result::Host;

use DBIx::Class::Candy -autotable => v1;

use strict;
use warnings;

__PACKAGE__->load_components( qw/ InflateColumn::DateTime / );

primary_column host_id => {
    data_type => 'int',
    is_auto_increment => 1,
};

column host_identifier => {
    data_type => 'varchar',
    size => 50,
    is_nullable => 0,
};

unique_constraint unique_host_identifier => [ 'host_identifier' ];

1;


