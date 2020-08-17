#!/usr/bin/env perl

use strict;
use warnings;
use Getopt::Long; 
use File::Basename;
use File::Slurper qw(read_lines);
use Mojolicious::Lite;
use Mojo::mysql; 
use Data::Dump qw(dump);

my ($connectstring) = read_lines( "/home/$ENV{USER}/.yancytest-connectstring.txt" );
chomp($connectstring);
#print "$0: mojo mysql connectstring is: $connectstring\n";

plugin Yancy => {
    # example connect string looks like: 'mysql://username:password@hostname/test;mysql_ssl=1'
    backend => { mysql => Mojo::mysql->new( $connectstring ) },
    read_schema => 1,
    editor => {
        #require_user => undef
    },
};

my $schema = app->yancy->schema;
$schema->{user_roles}{properties}{user_id}{'x-foreign-key'} = "users";
$schema->{user_roles}{properties}{user_id}{'x-display-field'} = "email";
#print dump($schema);
app->start;

__END__

# this is the dump of the schema from 
# YancyTest's tables.sql
# do {
  my $a = {
    action_queue => {
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
    admin_stats => {
      properties => {
        data_date => { "format" => "date", "type" => "string", "x-order" => 2 },
        id => { "readOnly" => 'fix', "type" => "integer", "x-order" => 1 },
        type => { "type" => "string", "x-order" => 3 },
        value => { "type" => "number", "x-order" => 4 },
      },
      required => ["data_date", "type", "value"],
      type => "object",
    },
    roles => {
      properties => {
        id => { "readOnly" => 'fix', "type" => "integer", "x-order" => 1 },
        role => { "type" => "string", "x-order" => 2 },
      },
      required => ["role"],
      type => "object",
    },
    user_roles => {
      properties => {
        id => { "readOnly" => 'fix', "type" => "integer", "x-order" => 1 },
        role_id => { "type" => "integer", "x-foreign-key" => "roles", "x-order" => 3 },
        user_id => { "type" => "integer", "x-foreign-key" => "users", "x-display-field" => "email", "x-order" => 2 },
      },
      required => ["user_id", "role_id"],
      type => "object",
    },
    users => {
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
  $a->{roles}{properties}{id}{"readOnly"} = \${$a->{action_queue}{properties}{id}{"readOnly"}};
  $a->{user_roles}{properties}{id}{"readOnly"} = \${$a->{action_queue}{properties}{id}{"readOnly"}};
  $a->{users}{"properties"}{id}{"readOnly"} = \${$a->{action_queue}{properties}{id}{"readOnly"}};
  $a;
} at ./yancytest.pl line 25.
