package Kwiki::IRCMode;
our $VERSION = '0.20';

=head1 NAME

Kwiki::IRCMode - colorized IRC conversations in your Kwiki

=head1 VERSION

version 0.20

=head1 SYNOPSIS

 $ cpan Kwiki::IRCMode
 $ cd /path/to/kwiki
 $ kwiki -add Kwiki::IRCMode

=head1 DESCRIPTION

This module registers a ".irc" block, which will format IRC conversations like
the following:

 .irc
 <rjbs> Hey, is there an IRC block for Kwiki?
 <z00s> No.  Why don't you shut up and write one?
 <rjbs> Maybe I will!
 <z00s> Maybe you should!
 <rjbs> FINE!
 .irc

=cut

use strict;
use warnings;
use Kwiki::Plugin '-Base';
use Kwiki::Installer '-Base';

const class_id => 'irc';
const css_file => 'irc.css';
const class_title => 'Kwiki IRC Log Waffle';

sub register {
  my $registry = shift;
  $registry->add(wafl => irc => 'Kwiki::IRCMode::Wafl' );
}

package Kwiki::IRCMode::Wafl;
use base qw(Spoon::Formatter::WaflBlock);

sub to_html {
  my (@msgs, %nicks);
  my $nicks = 0;
  for (split("\n", $self->block_text)) {
    next unless my ($nick, $text) = $_ =~ /^<(\w+)> (.*)/;
    $nicks{$nick} ||= $nicks++;
    push @msgs, [ $nick, $self->escape_html($text) ];
  }

  "<blockquote class='irc'>\n"
  . join("\n",map({
      "<p>&lt;<span class='u$nicks{$_->[0]}'>$_->[0]</span>&gt; $_->[1]</p>\n"
    } @msgs))
  . "</blockquote>\n";
}

=head1 TODO

Use Parse::IRCLog to allow more matching of more styles and IRC events.

=head1 AUTHOR

Ricardo SIGNES, <C<rjbs@cpan.org>>

=head1 COPYRIGHT

This code is Copyright 2004, Ricardo SIGNES.  It is licensed under the same
terms as Perl itself.

=cut

package Kwiki::IRCMode;

__DATA__
__css/irc.css__
blockquote.irc {
  background-color: #ddd;
}
blockquote.irc span.u0 { color: red; }
blockquote.irc span.u1 { color: blue; }
blockquote.irc span.u2 { color: green; }
blockquote.irc span.u3 { color: yellow; }
blockquote.irc p { margin-bottom: 0; margin-bottom: 0; }
