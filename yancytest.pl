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

plugin Yancy => {
    # our MySQL connector
    # example connect string looks like: 'mysql://username:password@hostname/test;mysql_ssl=1'
    backend => { mysql => Mojo::MySQL->new( $mojo_mysql_connectstring ) },
    read_schema => 1,
};

# this gives "Useless use of anonymous hash ({}) in void context at YancyTest/yancytest.pl line 21." 
get( '/*path' ) => {
    path=>"index", # default    
    controller => "yancy",
    action=> 'get', 
    template => 'index'
};
app->start;
