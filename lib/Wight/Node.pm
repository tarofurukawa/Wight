package Wight::Node;
use strict;
use warnings;
use Sub::Name;
use Class::Accessor::Lite (
    new => 1,
    ro  => [
        'wight',
        'page_id',
        'id',
    ]
);

our @METHODS = qw(
    click set text visible attribute value
    tag_name drag select trigger select_file
);

foreach my $method (@METHODS) {
    my $code = sub {
        my ($self, @args) = @_;
        return $self->wight->call($method => $self->page_id, $self->id, @args);
    };
    no strict 'refs';
    *$method = subname $method, $code;
}

*is_visible = \&visible;

sub find {
    my ($self, $selector) = @_;
    my $class = ref $self;
    my $xpath = $selector =~ m!^(?:/|id\()! ? $selector : HTML::Selector::XPath::selector_to_xpath($selector);
    my $id = $self->wight->call(find_within => $self->page_id, $self->id, $xpath) or return;
    return $class->new(%$self, id => $id);
}

1
