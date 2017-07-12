#!/usr/bin/perl
use WWW::Mechanize::Firefox;
use utf8;

my ( $url_f, $out_txt ) = @ARGV;
open my $fhr, '<', $url_f;
my @url_list = <$fhr>;
close $fhr;

my $mech = WWW::Mechanize::Firefox->new();

open my $fh, '>:utf8', $out_txt;
for my $url ( @url_list ) {
  chomp( $url );
  print "$url\n";
  $mech->get( $url );

  my ( $title ) = $mech->xpath( '//div[@class="title"]' );
  my $t = $title->{innerHTML};
  $t =~ s#\x{200B}##g;
  $t =~ s/^\d+/$& /g;
  $t =~ s/&nbsp;/ /g;

  my ( $x ) = $mech->xpath( '//div[@class="WB_editor_iframe"]' );
  my $c = $x->{innerHTML};
  $c =~ s#<h2>.+?</h2>##s;
  $c =~ s#<[^>]+>#\n#sg;
  $c =~ s#\n+#\n#sg;

  print $fh "$t\n\n$c\n\n";
} ## end for my $url ( @url_list)
close $fh;
