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
    is mandatory;

};

# Your model-specific methods go here.

1;

