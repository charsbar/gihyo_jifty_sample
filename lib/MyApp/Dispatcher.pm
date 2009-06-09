package MyApp::Dispatcher;

use strict;
use warnings;
use Jifty::Dispatcher -base;

on '/' => run {
  if (my $user_id = Jifty->web->current_user->id) {
    redirect "/home";
  }
  else {
    show '/login';
  }
};

on 'home' => run {
  if (my $user_id = Jifty->web->current_user->id) {
    set user => Jifty->web->current_user->user_object;
    show '/list';
  }
  else {
    tangent '/login';
  }
};

under 'user/*' => [
  run {
    my ($name) = ($1);

    my $user = MyApp::Model::User->load_by_cols(name => $name);

    unless ($user) {
      show '/user_not_found';
      abort 404;
    }

    set user => $user;
  },

  on qr/(\d+)/ => run {
    my ($epoch) = ($1);

    my $user = get('user');

    my $entry = MyApp::Model::Entry->load_by_cols(
      user_id => $user->id,
      epoch   => $epoch,
    );

    unless ($entry) {
      show '/page_not_found';
      abort 404;
    }

    set entry => $entry;

    show '/entry';
  },

  on '' => show '/list',
];

1;

