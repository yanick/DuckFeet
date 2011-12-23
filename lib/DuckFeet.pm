package DuckFeet;

use strict;
use warnings;

use Moose;

use DuckFeet::Schema;
use Log::Dispatchouli;

with 'MooseX::Role::BuildInstanceOf' => {
    target => '::Importer',
    inherited_args => [ qw/ schema logger / ],
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

has logger => (
    isa => 'Log::Dispatchouli',
    is => 'ro',
    default => sub {
        Log::Dispatchouli->new({
            ident     => 'duckfeet',
            to_stderr => 1,
            debug => 1,
        });
    },
);

__PACKAGE__->meta->make_immutable;

1;
