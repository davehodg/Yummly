
use strict;

use Test::More;
use JSON;
use Data::Dumper;
use_ok('WebService::Yummly');

if (defined $ENV{APP_KEY}) {

  ok(my $y = WebService::Yummly->new($ENV{APP_KEY}), "new yummly object");
  ok(my $recipes = $y->search("lamb shank"),"search") ;

  print Dumper($recipes);

  #foreach my $r ( @{ $recipes->{matches} } ) {
  #  diag $r->{recipeName};
  #  ok($r->{recipeName}, $r->{recipeName}) ;
  #}
}

done_testing;

