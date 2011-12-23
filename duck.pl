#!/usr/bin/perl 

use strict;
use warnings;

use DuckFeet;

my $duck = DuckFeet->new(
    schema_args => [ 'dbi:SQLite:duck.db' ],
);

$duck->deploy_schema;

$duck->import_file( 't/data/access_log', only_new => 1 );


