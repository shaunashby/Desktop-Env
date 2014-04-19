use strict;
use warnings;
use ExtUtils::MakeMaker;

WriteMakefile(
    NAME                => 'Module::Starter::CH',
    AUTHOR              => 'Shaun Ashby <shaun@ashby.ch>',
    VERSION_FROM        => 'lib/Module/Starter/CH.pm',
    ABSTRACT_FROM       => 'lib/Module/Starter/CH.pm',
    PL_FILES            => {},
    PREREQ_PM => {
        'Test::More' => 0,
        'version'    => 0,
	'Module::Starter' => 0,
    },
    dist                => { COMPRESS => 'gzip -9f', SUFFIX => 'gz', },
    clean               => { FILES => 'Module-Starter-CH-*' },
);
