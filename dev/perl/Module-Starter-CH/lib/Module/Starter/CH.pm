#____________________________________________________________________
#
# Author: Shaun Ashby <shaun@ashby.ch>
# Created: 2014-04-19 17:30:56+0200 (Time-stamp: <2014-04-19 17:38:45 sashby>)
# Revision: $Id$
#
# Copyright (C) 2014 Shaun Ashby
#
#--------------------------------------------------------------------
package Module::Starter::CH;

use warnings;
use strict;
use Carp;

use version; our $VERSION = qv('0.0.1');

# Other recommended modules (uncomment to use):
#  use IO::Prompt;
#  use Perl6::Export;
#  use Perl6::Slurp;
#  use Perl6::Say;


# Module implementation here


1; #
__END__

=head1 NAME

Module::Starter::CH - Custom module for use with the Module::Starter framework and the module-starter tool.


=head1 VERSION

This document describes Module::Starter::CH version 0.0.1


=head1 SYNOPSIS

    use Module::Starter::CH;

=head1 DESCRIPTION

This is a plugin to be used with the Module::Starter framework and the module-starter command-line tool.

=head1 INTERFACE 


=head1 DIAGNOSTICS


=over

=item C<< Error message here, perhaps with %s placeholders >>

[Description of error here]

=item C<< Another error message here >>

[Description of error here]

[Et cetera, et cetera]

=back


=head1 CONFIGURATION AND ENVIRONMENT
  
Module::Starter::CH requires no environment variables. To use the module with the module-starter tool,
create a configuration file $HOME/.module-starter/config with contents like


  author:  <Your Name>
  email:   <your@email.addr>
  plugins: Module::Starter::CH
  template_dir: </absolute/path/name/to/templates>

Then run module-starter to create your module:
     
    > module-starter --module=Your::New::Module
 
The config file setup can also be run using
 
    > perl -MModule::Starter::CH=setup


=head1 DEPENDENCIES

Mainly Module::Starter and any additional modules in this namespace.

=head1 INCOMPATIBILITIES

None reported.

=head1 BUGS AND LIMITATIONS

No bugs have been reported.

Please report any bugs or feature requests to
C<bug-module-starter-ch@rt.cpan.org>, or through the web interface at
L<http://rt.cpan.org>.

=head1 AUTHOR

Shaun Ashby  C<< <shaun@ashby.ch> >>


=head1 LICENCE AND COPYRIGHT

Copyright (c) 2014, Shaun Ashby C<< <shaun@ashby.ch> >>. All rights reserved.

This module is free software; you can redistribute it and/or
modify it under the same terms as Perl itself. See L<perlartistic>.


=head1 DISCLAIMER OF WARRANTY

BECAUSE THIS SOFTWARE IS LICENSED FREE OF CHARGE, THERE IS NO WARRANTY
FOR THE SOFTWARE, TO THE EXTENT PERMITTED BY APPLICABLE LAW. EXCEPT WHEN
OTHERWISE STATED IN WRITING THE COPYRIGHT HOLDERS AND/OR OTHER PARTIES
PROVIDE THE SOFTWARE "AS IS" WITHOUT WARRANTY OF ANY KIND, EITHER
EXPRESSED OR IMPLIED, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED
WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE. THE
ENTIRE RISK AS TO THE QUALITY AND PERFORMANCE OF THE SOFTWARE IS WITH
YOU. SHOULD THE SOFTWARE PROVE DEFECTIVE, YOU ASSUME THE COST OF ALL
NECESSARY SERVICING, REPAIR, OR CORRECTION.

IN NO EVENT UNLESS REQUIRED BY APPLICABLE LAW OR AGREED TO IN WRITING
WILL ANY COPYRIGHT HOLDER, OR ANY OTHER PARTY WHO MAY MODIFY AND/OR
REDISTRIBUTE THE SOFTWARE AS PERMITTED BY THE ABOVE LICENCE, BE
LIABLE TO YOU FOR DAMAGES, INCLUDING ANY GENERAL, SPECIAL, INCIDENTAL,
OR CONSEQUENTIAL DAMAGES ARISING OUT OF THE USE OR INABILITY TO USE
THE SOFTWARE (INCLUDING BUT NOT LIMITED TO LOSS OF DATA OR DATA BEING
RENDERED INACCURATE OR LOSSES SUSTAINED BY YOU OR THIRD PARTIES OR A
FAILURE OF THE SOFTWARE TO OPERATE WITH ANY OTHER SOFTWARE), EVEN IF
SUCH HOLDER OR OTHER PARTY HAS BEEN ADVISED OF THE POSSIBILITY OF
SUCH DAMAGES.
