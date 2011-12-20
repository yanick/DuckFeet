package DuckFeet::Schema::Result::Uri;

use DBIx::Class::Candy -autotable => v1;

use strict;
use warnings;

primary_column uri_id => {
    data_type => 'int',
    is_auto_increment => 1,
};

column method => {
    data_type => 'varchar',
    size => 4,
    is_nullable => 0,
};

column path => {
    data_type => 'varchar',
    size => 50,
    is_nullable => 0,
};

column protocol => {
    data_type => 'varchar',
    size => 5,
    is_nullable => 0,
};


1;


