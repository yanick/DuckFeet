#!/usr/bin/perl 

use 5.10.0;

use strict;
use warnings;
use Logfile::Access;
use DuckFeet::Schema;
use Cache::MemoryCache;
use DateTime;

my $log = Logfile::Access->new;

open my $lh, '<', '/var/log/apache2/access.log.1';

my $db = DuckFeet::Schema->connect( 'dbi:SQLite:duck.db',
);

$db->deploy;

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

while ( <$lh> ) {
    warn "parsing $_";
    $log->parse($_);

    my $uri_id = uri_id( map { $log->$_ } qw/ protocol method object / );

    state %host;
    my $host = $host{$log->remote_host} ||= $db->resultset('Host')->find_or_create({
                host_identifier  => $log->remote_host 
    });

    my $hit = $db->resultset('Hit')->new_result({ uri_id => $uri_id });

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

sub add_hit {
    my ( $uri_id, $date ) = @_;

    return $db->resultset('Hit')->find_or_create({
            uri_id => $uri_id,
            timestamp => $date,
        });
}

sub uri_id {
    my ( $protocol, $method, $path ) = @_;
    state %cache;

    return $cache{$protocol}{$method}{$path} ||= $db->resultset('Uri')->find_or_create({
            protocol => $protocol,
            method   => $method,
            path     => $path
    })->uri_id;
}




