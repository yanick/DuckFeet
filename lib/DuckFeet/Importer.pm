package DuckFeet::Importer;

use 5.10.0;

use strict;
use warnings;

use autodie;

use Moose;
use Method::Signatures;
use Logfile::Access;
use DateTime;
use DateTime::Functions;

has schema => (
    is => 'ro',
    required => 1,
    isa => 'DuckFeet::Schema',
);

has logger => (
    isa => 'Log::Dispatchouli',
    is => 'ro',
    handles => [ qw/ log debug / ],
);

has parser => (
    isa => 'Logfile::Access',
    is => 'ro',
    default => sub { Logfile::Access->new },
);

my %month = (
    Jan => 1,
    Feb => 2,
    Mar => 3,
    Apr => 4,
    May => 5,
    Jun => 6,
    Jul => 7,
    Aug => 8,
    Sep => 9,
    Oct => 10,
    Nov => 11,
    Dec => 12,
);

method uri_id ( :$protocol, :$method, :$path ) {
    state %cache;

    my $key = join ':', $protocol, $method, $path;

    return $cache{$key} ||= $self->schema->resultset('Uri')->find_or_create({
        protocol => $protocol,
        method   => $method,
        path     => $path
    })->uri_id;
}

method import_entry ( $line ) {

    my $log = $self->parser;

    $log->parse($line);

    my $db = $self->schema;

    my $uri_id = $self->uri_id(
        protocol => $log->protocol,
        method   => $log->method,
        path     => $log->path
    );


    my $host = $db->resultset('Host')->find_or_create({
            host_identifier  => $log->remote_host 
    });

    my $hit = $db->resultset('Hit')->new_result({});
    
    $hit->uri_id($uri_id);

    $hit->host( $host );
    $hit->timestamp( 
        DateTime->new( 
            year => $log->year,
            month => $month{$log->month},
            day => $log->mday,
            hour => $log->hour,
            minute => $log->minute,
            second => $log->second,
            time_zone => $log->offset,
        ) 
    );

    if ( my $ref = $log->http_referer ) {
        $hit->referer( 
            $db->resultset('Referer')->find_or_create({ 
                url => $ref
            })
        );
    }

    if ( my $agent = $log->http_user_agent ) {
        $hit->agent( 
            $db->resultset('Agent')->find_or_create({ 
                signature => $agent
            })
        );
    }

    $hit->insert;

}

method import_file ( $filename, :$only_new = 0 ) {
    my $db = $self->schema;

    my $log = $self->parser;

    open my $log_fh, '<', $filename;

    my $start = time;
    my $nbr_entries;

    while ( <$log_fh> ) {
        $self->debug( [ "%s entries in %s seconds (%s eps)", ++$nbr_entries,
            time - $start, $nbr_entries / ( time - $start or 1 ) ] );

        $self->import_entry( $_ );
    }
}


__PACKAGE__->meta->make_immutable;
1;
