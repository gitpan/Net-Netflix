package Net::Netflix;

use WWW::Mechanize;

sub new {
  my $ref = shift;
  my $class = ref( $ref ) || $ref;

  my $self = bless {
    u => undef,
    p => undef,
    www => new WWW::Mechanize(),
    @_
  }, $class;

  die "Netflix requires a username and password" unless 
    ( $self->{u} && $self->{p} );

  $self->{www}->get('http://www.netflix.com/Login');
  $self->{www}->set_fields(
    email => $self->{u},
    password1 => $self->{p}
  );
  $self->{www}->submit();

  return $self;
}

sub getRatings {
  my ( $self ) = @_;

  my %ret;
  my $body = 'alt="Next"';
  my $cur = 0;

  while ( $body =~ /alt="Next"/i ) {
    $self->{www}->get( "http://www.netflix.com/MoviesYouveSeen?title_sort=t&pageNum=$cur" );
    $body = $self->{www}->content();
    while ( $body =~ /trkid=\d+">([^<]+).*?2,(\d)/gs ) {
      $ret{ $1 } = $2;
      #print "$1 $2\n";
    }
    ++$cur;
  }

  return \%ret;
}
1;

__END__
=pod

=head1 NAME

Net-Netflix - Get all ratings from your Netflix account.

=head1 DESCRIPTION

This module is designed to pull down every movie you've ever rated using your Netflix account. It would be a good idea to use this if you were looking to move your ratings to another web site.

Eventually, it would be good to have a variety of functions for people to perform against their Netflix data.

=head1 SYNOPSIS

    use Net::Netflix;
    use Data::Dumper;

    my $netflix = new Net:Netflix( u => 'USERNAME', p => 'PASSWORD' );
    
    print Dumper( $dvd->getRatings() );
    
=over 4

=item B<new>

    my $netflix = new Net::Netflix( u => 'USERNAME', p => 'PASSWORD' );
    
Instantiates an object with which to perform further requests. Username and password are required, as in order to retreive the ratings you must log in to your account.

=item B<getRatings>

    $netflix->getRatings();
    
Returns a hash reference containing DVD Titles (as the key) and the rating (as the value). It may take a little while as it has to scrape quite a few pages in order to acheive the final result.

=back

=head1 AUTHOR

<a href="http://ejohn.org/">John Resig</a> E<lt>jeresig@gmail.comE<gt>

=head1 DISCLAIMER

This application utilitizes screen-scraping techniques, which are very fickle and susceptable to changes.

=head1 DISCLAIMER

This application utilitizes screen-scraping techniques, which are very fickle and susceptable to changes.

=head1 COPYRIGHT

Copyright 2005 John Resig.

=cut