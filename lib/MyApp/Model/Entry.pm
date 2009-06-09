use strict;
use warnings;

package MyApp::Model::Entry;
use Jifty::DBI::Schema;

use MyApp::Record schema {

  column body =>
    type is 'text';

  column user_id =>
    type is 'integer',
    refers_to MyApp::Model::User;

  column epoch =>
    type is 'integer',
    default is defer { time() },
    is mandatory;

};

# Your model-specific methods go here.

sub since { '0.0.2' }

sub current_user_can {
  my ($self, $right, %args) = @_;

  return 1 if $right eq 'read';
  return 1 if $args{user_id} && $self->current_user->id == $args{user_id};
  return 1 if $self->user_id && $self->current_user->id == $self->user_id;

  return $self->SUPER::current_user_can($right, %args);
}

1;

