#!/usr/bin/perl 

use strict;
use warnings;

use DuckFeet;

my $duck = DuckFeet->new(
    schema_args => [ 'dbi:SQLite:duck.db' ],
);

$duck->deploy_schema;

# we have a need for speed
$duck->schema->storage->dbh->do( 'PRAGMA journal_mode=WAL' );
$duck->schema->storage->dbh->do( 'PRAGMA synchronous = OFF' );

$duck->import_file( 't/data/access_log' );


