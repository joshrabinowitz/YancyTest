test this with 

    plackup yancytest.pl

which will run a server at port 5000 as per plackup docs

We want to implement preaction's suggestion at 
    https://gist.github.com/preaction/edcd513769cb61a1e08637d881626f1b
which is:

    my $schema = $app->yancy->schema;
    for my $key ( keys %$schema ) {
        my $props = $schema->{ $key }{ properties };
        $schema->{ $key }{ 'x-list-columns' } = [ grep { $props->{$_}{format} ne 'textarea' } keys %$props ];
    } 

