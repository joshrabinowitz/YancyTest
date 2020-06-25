#!/usr/bin/env perl

use strict;
use warnings;
use Getopt::Long; 
use File::Basename;
use File::Slurper qw(read_lines);
use Mojolicious::Lite;
use Mojo::mysql; # Supported backends: Pg, Mysql, SQLite, DBIx::Class
                # note: don't use ancient "Mojo::MySQL"

my ($connectstring) = read_lines( "/home/$ENV{USER}/.yancytest-connectstring.txt" );
chomp($connectstring);
#print "$0: mojo mysql connectstring is: $connectstring\n";

plugin Yancy => {
    # our MySQL connector
    # example connect string looks like: 'mysql://username:password@hostname/test;mysql_ssl=1'
    backend => { mysql => Mojo::mysql->new( $connectstring ) },
    read_schema => 1,
};

if (1) {
    my $schema = app->yancy->schema;
    for my $key ( keys %$schema ) {
        my $props = $schema->{ $key }{ properties };
        $schema->{ $key }{ 'x-list-columns' } = [ 
            grep { my $f = $props->{$_}{format}; !defined $f || $f ne 'textarea' } 
            sort { $props->{$a}{"x-order"} <=> $props->{$b}{"x-order"} } keys %$props 
        ];
    } 
}

app->start;

__END__

# this is the dump of the schema from 
# YancyTest's tables.sql
my $a = {
    action_queue     => {
       properties => {
         action => { "type" => "string", "x-order" => 3 },
         end_date => { "format" => "date-time", "type" => "string", "x-order" => 6 },
         id => {
           "readOnly" => bless(do{\(my $o = 1)}, "JSON::PP::Boolean"),
           "type"     => "integer",
           "x-order"  => 1,
         },
         start_date => { "format" => "date-time", "type" => "string", "x-order" => 5 },
         state => { "type" => "string", "x-order" => 4 },
         symbol => { "type" => "string", "x-order" => 2 },
       },
       required => ["symbol", "action", "state", "start_date", "end_date"],
       type => "object",
     },
    admin_stats      => {
       properties => {
         data_date => { "format" => "date", "type" => "string", "x-order" => 2 },
         id => { "readOnly" => 'fix', "type" => "integer", "x-order" => 1 },
         type => { "type" => "string", "x-order" => 3 },
         value => { "type" => "number", "x-order" => 4 },
       },
       required => ["data_date", "type", "value"],
       type => "object",
     },
    articles         => {
       properties => {
         category => { "default" => "news", "type" => "string", "x-order" => 7 },
         content => { "type" => "string", "x-order" => 10 },
         creation_date => { "format" => "date-time", "type" => "string", "x-order" => 3 },
         html_title => { "type" => "string", "x-order" => 8 },
         id => { "readOnly" => 'fix', "type" => "integer", "x-order" => 1 },
         image_file_id => { "default" => 1, "type" => "integer", "x-order" => 12 },
         is_public => { "default" => 0, "type" => "integer", "x-order" => 11 },
         publish_date => { "format" => "date-time", "type" => "string", "x-order" => 4 },
         subtitle => { "type" => "string", "x-order" => 9 },
         title => { "type" => "string", "x-order" => 6 },
         update_date => {
           "default" => "now",
           "format"  => "date-time",
           "type"    => "string",
           "x-order" => 5,
         },
         url => { "default" => "filename", "type" => "string", "x-order" => 13 },
         user_id => { "type" => "integer", "x-order" => 2 },
       },
       required => [
         "user_id",
         "creation_date",
         "publish_date",
         "title",
         "html_title",
         "subtitle",
         "content",
       ],
       type => "object",
     },
    articles_archive => {
       properties => {
         article_id => { "type" => "integer", "x-order" => 2 },
         category => { "default" => "news", "type" => "string", "x-order" => 9 },
         content => { "type" => "string", "x-order" => 12 },
         creation_date => { "format" => "date-time", "type" => "string", "x-order" => 5 },
         html_title => { "type" => "string", "x-order" => 10 },
         id => { "readOnly" => 'fix', "type" => "integer", "x-order" => 1 },
         image_file_id => { "default" => 1, "type" => "integer", "x-order" => 14 },
         is_public => { "default" => 0, "type" => "integer", "x-order" => 13 },
         publish_date => { "format" => "date-time", "type" => "string", "x-order" => 6 },
         subtitle => { "type" => "string", "x-order" => 11 },
         title => { "type" => "string", "x-order" => 8 },
         update_date => { "format" => "date-time", "type" => "string", "x-order" => 7 },
         url => { "default" => "", "type" => "string", "x-order" => 15 },
         user_id => { "type" => "integer", "x-order" => 4 },
         version => { "type" => "integer", "x-order" => 3 },
       },
       required => [
         "article_id",
         "version",
         "user_id",
         "creation_date",
         "publish_date",
         "update_date",
         "title",
         "html_title",
         "subtitle",
         "content",
       ],
       type => "object",
     },
    datacache        => {
       "properties" => {
                         expire_time => {
                           "default" => "0000-00-00 00:00:00",
                           "format"  => "date-time",
                           "type"    => "string",
                           "x-order" => 2,
                         },
                         name => { "type" => "string", "x-order" => 3 },
                         update_time => {
                           "default" => "now",
                           "format"  => "date-time",
                           "type"    => "string",
                           "x-order" => 1,
                         },
                         value => { "type" => "string", "x-order" => 4 },
                       },
       "required"   => ["name", "value"],
       "type"       => "object",
       "x-id-field" => "name",
     },
    files            => {
       "properties" => {
                         filename => { "type" => "string", "x-order" => 2 },
                         filesize => { "type" => "integer", "x-order" => 3 },
                         id => { "readOnly" => 'fix', "type" => "integer", "x-order" => 1 },
                         md5 => { "type" => "string", "x-order" => 4 },
                         update_time => {
                           "default" => "now",
                           "format"  => "date-time",
                           "type"    => "string",
                           "x-order" => 5,
                         },
                         user_id => { "type" => "integer", "x-order" => 6 },
                       },
       "required"   => ["filename", "filesize", "md5", "user_id"],
       "type"       => "object",
       "x-id-field" => "filename",
     },
    files_archive    => {
       properties => {
         file_id => { "type" => "integer", "x-order" => 2 },
         filename => { "type" => "string", "x-order" => 4 },
         filesize => { "type" => "integer", "x-order" => 5 },
         id => { "readOnly" => 'fix', "type" => "integer", "x-order" => 1 },
         md5 => { "type" => "string", "x-order" => 6 },
         update_time => {
           "default" => "now",
           "format"  => "date-time",
           "type"    => "string",
           "x-order" => 7,
    #!/usr/bin/env perl
         },
         user_id => { "type" => "integer", "x-order" => 8 },
         version => { "type" => "integer", "x-order" => 3 },
       },
       required => ["file_id", "version", "filename", "filesize", "md5", "user_id"],
       type => "object",
     },
    roles            => {
       properties => {
         id => { "readOnly" => 'fix', "type" => "integer", "x-order" => 1 },
         role => { "type" => "string", "x-order" => 2 },
       },
       required => ["role"],
       type => "object",
     },
    user_roles       => {
       properties => {
         id => { "readOnly" => 'fix', "type" => "integer", "x-order" => 1 },
         role_id => { "type" => "integer", "x-foreign-key" => "roles", "x-order" => 3 },
         user_id => { "type" => "integer", "x-order" => 2 },
       },
       required => ["user_id", "role_id"],
       type => "object",
     },
    users            => {
       "properties" => {
                         email => { "type" => "string", "x-order" => 2 },
                         id => { "readOnly" => 'fix', "type" => "integer", "x-order" => 1 },
                         password => { "type" => "string", "x-order" => 3 },
                       },
       "required"   => ["email", "password"],
       "type"       => "object",
       "x-id-field" => "email",
     },
    };
    $a->{admin_stats}{properties}{id}{"readOnly"} = \${$a->{action_queue}{properties}{id}{"readOnly"}};
    $a->{articles}{properties}{id}{"readOnly"} = \${$a->{action_queue}{properties}{id}{"readOnly"}};
    $a->{articles_archive}{properties}{id}{"readOnly"} = \${$a->{action_queue}{properties}{id}{"readOnly"}};
    $a->{files}{"properties"}{id}{"readOnly"} = \${$a->{action_queue}{properties}{id}{"readOnly"}};
    $a->{files_archive}{properties}{id}{"readOnly"} = \${$a->{action_queue}{properties}{id}{"readOnly"}};
    $a->{roles}{properties}{id}{"readOnly"} = \${$a->{action_queue}{properties}{id}{"readOnly"}};
    $a->{user_roles}{properties}{id}{"readOnly"} = \${$a->{action_queue}{properties}{id}{"readOnly"}};
    $a->{users}{"properties"}{id}{"readOnly"} = \${$a->{action_queue}{properties}{id}{"readOnly"}};
    $a;
}
