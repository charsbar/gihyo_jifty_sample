package MyApp::View;

use strict;
use warnings;
use Jifty::View::Declare -base;
use Time::Piece;

template 'list' => page {
  my $user = get('user');
  my $name = $user->name;

  if (Jifty->web->current_user->id == $user->id) {
    h1 { "Your tweets" };
    show 'form';
  }
  else {
    h1 { "Tweets by $name..." };
  }

  my $entries = MyApp::Model::EntryCollection->new(
    current_user => Jifty->web->current_user
  );

  $entries->order_by( column => 'epoch', order => 'DESC' );
  $entries->rows_per_page(15);
  $entries->limit( column => 'user_id', value => $user->id );

  while (my $entry = $entries->next) {
    show('_entry' => $entry);
  }
};

template 'entry' => page {
  my $user  = get('user');
  my $entry = get('entry');
  h1 { "Tweet by " . $user->name }

  show('_entry', $entry);
};

private template '_entry' => sub {
  my ($self, $entry) = @_;

  div { $entry->body };
  p {
    my $time = localtime($entry->epoch);
    span { outs "by " . $entry->user->name .
                " at " . $time->date . ' ' . $time->time };
    span {
      my $url = join '/', "/user", 
                          $entry->user->name,
                          $entry->epoch;
      hyperlink( url => $url, label => 'permalink' );
    }
  };
};

private template 'form' => sub {
  my $user = get('user');
  my $name = $user->name;

  my $action = new_action(
    class   => 'MyApp::Action::CreateEntry',
    moniker => 'create_entry',
  );

  div { attr { class => 'Form' };
    Jifty->web->form->start(submit_to => "/user/$name/post");
    div {
      render_param( $action => 'body', focus => 1 );
      return(
        submit    => $action,
        label     => 'Tweet',
        as_button => 1,
      );
    };
    Jifty->web->form->end;
  };
};

template 'entry_not_found' => page { h1 { "entry not found" } };
template 'user_not_found'  => page { h1 { "user not found" } };
template 'page_not_found'  => page { h1 { "page not found" } };

1;
