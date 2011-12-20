package DuckFeet::Schema::Result::Agent;

use DBIx::Class::Candy -autotable => v1;

use strict;
use warnings;

__PACKAGE__->load_components( qw/ InflateColumn::DateTime / );

primary_column agent_id => {
    data_type => 'int',
    is_auto_increment => 1,
};

column signature => {
    data_type => 'text',
    size => '100',
    is_nullable => 0,
};

unique_constraint unique_agent_string => [ 'signature' ];

has_many hits => 'DuckFeet::Schema::Result::Hit', 'agent_id';

1;
