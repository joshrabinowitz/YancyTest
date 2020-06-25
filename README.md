YancyTest README.md

This is a test of Yancy

You can test this with 

    mysql -e 'create database yancytest'
    mysql yancytest < tables.sql
    cat "$your_connectstring_here" > $/.yancytest-connectstring.txt
        # example connect string looks like: 'mysql://username:password@hostname/test;mysql_ssl=1'
    plackup yancytest.pl

OR just set up ~/.yancytest-connectstring.txt to connect to your existing database and run:

    plackup yancytest.pl

This will run a server at port 5000 as per plackup docs.

This poroject implements preaction's suggestion at 
    https://gist.github.com/preaction/edcd513769cb61a1e08637d881626f1b
which is:

    my $schema = $app->yancy->schema;
    for my $key ( keys %$schema ) {
        my $props = $schema->{ $key }{ properties };
        $schema->{ $key }{ 'x-list-columns' } = [ grep { $props->{$_}{format} ne 'textarea' } keys %$props ];
    } 


See also https://github.com/preaction/Yancy/issues/46, "Better default x-list-columns"

