package DuckFeet;

use strict;
use warnings;

use Moose;

use DuckFeet::Schema;

with 'MooseX::Role::BuildInstanceOf' => {
    target => '::Importer',
    inherited_args => [ 'schema' ],
};

has '+importer' => ( 
    handles => [ qw/ import_file /],
);

with 'MooseX::Role::BuildInstanceOf' => {
    target => '::Schema',
    constructor => 'connect',
};

has '+schema' => (
    handles => {
        deploy_schema => 'deploy',
    },
);



__PACKAGE__->meta->make_immutable;

1;
