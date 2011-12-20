#!/usr/bin/perl 

use strict;
use warnings;

use 5.12.0;

while( <> ) {
    next unless /
        ^
        (?<remote_host>\S+)
        \s
        \S+
        \s
        \S+
        \s
        \[ (?<timestamp>.*?) \]
        \s
        "(?<method>\w+) \s (?<uri>\S+) \s (?<protocol>\S+)"
        \s
        (?<status>\d+)
        \s
        (?<size>\d+)
        \s
        "(?<referer>\S+)"
        \s
        "(?<agent>\S+)"
    /x;       

    use XXX;
    die XXX \%+;
}




