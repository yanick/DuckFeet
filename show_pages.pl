#!/usr/bin/perl 

use strict;
use warnings;

use 5.10.0;
use DuckFeet::Schema;

my $schema = DuckFeet::Schema->connect( 'dbi:SQLite:duck.db' );

my $rs = $schema->resultset('Uri')->search(undef,{
    columns => [ qw/ method path protocol / ],
    distinct => 1,
    join => 'hits',
    select => [ { count => 'hit_id' } ],
    as => [ 'nbr_hits' ],
});

while ( my $uri = $rs->next ) {
    say $uri->method, $uri->path, $uri->get_column('nbr_hits');
}


