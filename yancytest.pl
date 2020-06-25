#!/usr/bin/env perl

use strict;
use warnings;
use Getopt::Long; 
use File::Basename;
use File::Slurper qw(read_lines);
use Mojolicious::Lite;
use Mojo::MySQL; # Supported backends: Pg, MySQL, SQLite, DBIx::Class

my ($mojo_mysql_connectstring) = read_lines( "/home/$ENV{USER}/.mojo-mysql-connectstring.txt" );
chomp($mojo_mysql_connectstring);
#print "$0: mojo mysql connectstring is: $mojo_mysql_connectstring\n";

plugin Yancy => {
    # our MySQL connector
    # example connect string looks like: 'mysql://username:password@hostname/test;mysql_ssl=1'
    backend => { mysql => Mojo::MySQL->new( $mojo_mysql_connectstring ) },
    read_schema => 1,
};

if (0) {
    my $schema = app->yancy->schema;
    for my $key ( keys %$schema ) {
        my $props = $schema->{ $key }{ properties };
        $schema->{ $key }{ 'x-list-columns' } = [ grep { my $f = $props->{$_}{format}; !defined $f || $f ne 'textarea' } keys %$props ];
    } 
}

app->start;
