use strict;
use warnings;

package MyApp::Action::CreateEntry;
use base qw/MyApp::Action MyApp::Action::Record::Create/;

use Jifty::Param::Schema;
use Jifty::Action schema {

  param body =>
    label is '',
    type is 'text',
    display_length is 40,
    max_length is 255,
    sticky is 0;

};

sub moniker { 'create_entry' }
sub sticky_on_failure { 0 }
sub sticky_on_success { 0 }

sub take_action {
  my $self = shift;

  my $body = $self->argument_value('body');

  return 1 unless defined $body && $body ne '';

  my $entry = MyApp::Model::Entry->new;

  $entry->create(
    body    => $body,
    epoch   => time,
    user_id => $self->current_user->id,
  );

  Jifty->web->next_page("/home");

  $self->report_success if not $self->result->failure;
  return 1;
}

sub report_success {
    my $self = shift;
    $self->result->message('Tweeted');
}

1;

