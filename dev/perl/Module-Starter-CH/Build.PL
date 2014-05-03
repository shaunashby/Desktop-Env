use strict;
use warnings;
use Module::Build;

my $builder = Module::Build->new(
    module_name         => 'Module::Starter::CH',
    license             => 'perl',
    dist_author         => 'Shaun Ashby <shaun@ashby.ch>',
    dist_version_from   => 'lib/Module/Starter/CH.pm',
    requires => {
        'Test::More' => 0,
        'version'    => 0,
    },
    add_to_cleanup      => [ 'Module-Starter-CH-*' ],
);

$builder->create_build_script();
