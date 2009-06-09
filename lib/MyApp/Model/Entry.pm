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

1;

