package DuckFeet::Importer;

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

method import_file ( $filename, :$only_new = 0 ) {

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

    my $db = $self->schema;

    my $log = Logfile::Access->new;

    open my $log_fh, '<', $filename;

    while ( <$log_fh> ) {
        $log->parse($_);

        my $uri = $db->resultset('Uri')->find_or_create({
            protocol => $log->protocol,
            method   => $log->method,
            path     => $log->path
        });

        my $host = $db->resultset('Host')->find_or_create({
                host_identifier  => $log->remote_host 
        });

        my $hit = $db->resultset('Hit')->new_result({ uri_id => $uri->id });

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
}


__PACKAGE__->meta->make_immutable;
1;
