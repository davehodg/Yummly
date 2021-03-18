package WebService::Yummly;

# ABSTRACT: get search and get a recipe from Yummly

use strict;
use warnings;

use JSON;
use URL::Encode;
use LWP::UserAgent ;
use Data::Dumper;

our $VERSION = '0.04';

sub new {
    my ($class, $APP_KEY, $id) = @_ ;
    my $obj = bless {}, $class ;

    my $string = "" ;
    if (defined $id) {
      $string = "recipe/$id" ;
    }

    my $ua = LWP::UserAgent->new;
    $obj->{ua} = $ua;
    $ua->agent("perl-Webservice::Yummly");

    # Simple use case
    $obj->{req} = HTTP::Request->new
      (
       GET   => "https://yummly2.p.rapidapi.com/feeds/search/" . $string # . "&maxResult=1",
      );
    $obj->{req}->header("X-RapidAPI-Key" => $ENV{APP_KEY});
    return $obj ;
}

sub search {
  my ($self, $search) = @_;

  my $req = $self->{req};
  $req->content("q=$search&maxResult=1");
  my $res = $self->{ua}->request($req) ;

  my $json;
  if ($res->is_success) {
     warn "success";
     $json = decode_json $res->content;
  } else {
      warn "fail";
      print $res->content;
      exit;
  }
  return $json;
}


sub get_recipe {
  my $self = shift;
  my $wss = $self->{wss};
  my $ret = $wss->get() ;
  my $json = $ret->parse_response;
  return $json;
}

1;

=pod

=head1 NAME

WebService::Yummly - Simple interface to the search and recipe interface to Yummly

=head1 SYNOPSIS

  use WebService::Yummly;

  # use your ID/key here
  my $APP_KEY = "a3cec319936cdf2fb03f4b0f5dfdaf4e";
  my $y = WebService::Yummly->new($APP_KEY);
  my $recipes = $y->search("lamb shank");

  my $r = WebService::Yummly->new($APP_KEY, "Sunday-Supper_-Curried-Lamb-Shanks-Serious-Eats-42000");
  ok($r,"new yummly");

  my $recipe = $r->get_recipe ;

=head1 DESCRIPTION

  Search and retrieve recipe from Yummly

=head1 FUNCTIONS

=head2 new

  my $y = WebService::Yummly->new($APP_KEY);

Create a new Yummly object passing in credentials.

=head2 search

  $recipes = $y->search("lamb shank") ;

Return a JSON structure containing matching recipes.

=head2 get_recipe

  my $r = WebService::Yummly->new($APP_KEY, "Sunday-Supper_-Curried-Lamb-Shanks-Serious-Eats-42000");
  my $recipe = $r->get_recipe ;

Return a JSON data structure with recipe information.

=head1 DIAGNOSTICS

=head1 SUPPORT

=head2 BUGS

Please report any bugs by email to C<bug-webservice-yummly at rt.cpan.org>, or
through the web interface at L<http://rt.cpan.org/Public/Dist/Display.html?Name=WebService-Yummly>.
You will be automatically notified of any progress on the request by the system.

=head2 SOURCE CODE

This is open source software. The code repository is available for public
review and contribution under the terms of the license.

L<https://github.com/davehodg/Webservice-Yummly/>

    git clone https://github.com/davehodg/Webservice-Yummly

=head1 AUTHOR

Dave Hodgkinson C<davehodg@cpan.org>

=head1 COPYRIGHT

Copyright 2014 by Dave Hodgkinson

This library is under the Artistic License.

