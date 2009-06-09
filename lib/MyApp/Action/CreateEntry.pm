use strict;
use warnings;

=head1 NAME

MyApp::Action::CreateEntry

=cut

package MyApp::Action::CreateEntry;
use base qw/MyApp::Action MyApp::Action::Record::Create/;

use Jifty::Param::Schema;
use Jifty::Action schema {

};

=head2 take_action

=cut

sub take_action {
    my $self = shift;
    
    # Custom action code
    
    $self->report_success if not $self->result->failure;
    
    return 1;
}

=head2 report_success

=cut

sub report_success {
    my $self = shift;
    # Your success message here
    $self->result->message('Success');
}

1;

