package AnySan::Declare;
use strict;
use warnings;
use AnySan;
use Class::Load ':all';
use Exporter 'import';

our $VERSION = '0.01';
our @EXPORT = qw( set_provider provider rule start );
our $PROVIDER;
our %MAPPER;

sub set_provider (%) {
    my ( $provider_class, $server, %opts ) = @_;
    my $klass = "AnySan::Provider::$provider_class";
    my $loader_function = lc($provider_class);
    unless ( is_class_loaded($klass) ) {
        load_class($klass);
    }
    {
        no strict 'refs';
        $PROVIDER = &{join( '::', $klass, $loader_function )}( $server, %opts );
    }
}

sub provider () {
    return $PROVIDER;
}

sub rule ($&) {
    my ( $matcher, $code ) = @_;
    $MAPPER{$matcher} = $code;
}

sub start () {
    AnySan->register_listener(
        echo => {
            cb => sub {
                my $receive = shift;
                for my $key ( keys %MAPPER ) {
                    if ( my @matched = $receive->message =~ $key ) {
                        my $code = $MAPPER{$key};
                        $code->( $receive, @matched );
                    }
                }
            },
        }
    );
    AnySan->run;
}

1;
__END__

=head1 NAME

AnySan::Declare -

=head1 SYNOPSIS

  use AnySan::Declare;

=head1 DESCRIPTION

AnySan::Declare is

=head1 AUTHOR

ytnobody E<lt>ytnobody@gmail.comE<gt>

=head1 SEE ALSO

=head1 LICENSE

This library is free software; you can redistribute it and/or modify
it under the same terms as Perl itself.

=cut
