package DuckFeet::Schema::Result::Hit;

use DBIx::Class::Candy -autotable => v1;

use strict;
use warnings;

__PACKAGE__->load_components( qw/ InflateColumn::DateTime / );

primary_column hit_id => {
    data_type => 'int',
    is_auto_increment => 1,
};

column uri_id => {
    data_type => 'int',
    is_nullable => 0,
};

column timestamp => {
    data_type => 'datetime',
    is_nullable => 0,
};

column host_id => {
    data_type => 'int',
    is_nullable => 0,
};

column referer_id => {
    data_type => 'int',
    is_nullable => 1,
};

column agent_id => {
    data_type => 'int',
    is_nullable => 1,
};

belongs_to referer => 'DuckFeet::Schema::Result::Referer', 'referer_id';
belongs_to host => 'DuckFeet::Schema::Result::Host', 'host_id';
belongs_to agent => 'DuckFeet::Schema::Result::Agent', 'agent_id';

1;


