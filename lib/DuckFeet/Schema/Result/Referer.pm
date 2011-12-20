package DuckFeet::Schema::Result::Referer;

use DBIx::Class::Candy -autotable => v1;

use strict;
use warnings;

__PACKAGE__->load_components( qw/ InflateColumn::DateTime / );

primary_column referer_id => {
    data_type => 'int',
    is_auto_increment => 1,
};

column url => {
    data_type => 'text',
    size => '100',
    is_nullable => 0,
};

unique_constraint unique_referer_identifier => [ 'url' ];

has_many hits => 'DuckFeet::Schema::Result::Hit', 'referer_id';

1;
