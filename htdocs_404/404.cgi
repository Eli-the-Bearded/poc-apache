#!/usr/bin/perl
my %redirs = (
  '/google' => 'https://www.google.com/',
  '/imdb'   => 'https://www.imdb.com/',
  '/ddg'    => 'https://www.duckduckgo.com/',
);

my $ask = '';

if(defined($ask = $ENV{REDIRECT_URL})) {
  $ask = lc($ask);
  if(defined($redirs{$ask})) {
    print qq*Status: 302 Found\n*;
    print qq*Location: $redirs{$ask}\n\n*;
    exit;
  }
}

print qq*Content-Type: text/plain; charset="utf-8"\n\n*;

print "Debug info\n";
print "----------\n\n";

for (sort { $a cmp $b } (keys %ENV)) {
  if (/^REDIRECT_/) {
    print "$_ = '$ENV{$_}'\n\n";
  }
}

