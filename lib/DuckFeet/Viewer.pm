package DuckFeet::Viewer;

use Dancer ':syntax';
use Dancer::Plugin::DBIC;

our $VERSION = '0.1';

get '/pages' => sub {
    my @pages;

    my $rs = schema->resultset('Uri')->search(undef,{
        columns => [ qw/ method path protocol / ],
        distinct => 1,
        join => 'hits',
        select => [ { count => 'hit_id' } ],
        as => [ 'nbr_hits' ],
    });

    while ( my $uri = $rs->next ) {
        push @pages, { map { $_ => $uri->get_column( $_ ) } 
            qw/ method path protocol nbr_hits / };
    }

    template 'pages.mason', {
        pages => \@pages,
    };
};

true;
