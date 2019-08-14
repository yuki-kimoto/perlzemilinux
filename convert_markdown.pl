=pod

perl convert.pl perlcodesample.original.xml > output.html

rsync -a templates/* ~/labo/Giblog/mysitezemi/templates/blog/

=cut

use strict;
use warnings;
use utf8;

use Encode 'encode', 'decode';
my $table_start;
my $ul_start;
my $ol_start;

my $comments_start;

my $current_date;
my $current_entry_id;


my $content;

my $remove_xml_desc;
my $remove_diary;

my $pre_start;

while (my $line = <>) {
  
  $line = decode('UTF-8', $line);

  $line =~ s#^\#\#\#(.+)#<h4>$1</h4>#;
  $line =~ s#^\#\#(.+)#<h3>$1</h3>#;
  $line =~ s#^\#(.+)#<h3>$1</h3>#;

  $line =~ s#\[(.+?)]\((.+?)\)#<a href="$2">$1</a>#g;

  $line =~ s#^\+ (.+)#<li>$1</li>#;

  $line =~ s#\Qhttp://d.hatena.ne.jp/perlcodesample/\E(\d+)/(\d{6})(\d{4})#/blog/$1$2.html#g;
  $line =~ s#href="/(\d+)/(\d{6})(\d{4})#/blog/href="/blog/$1$2.html#g;
  $line =~ s#"http://d.hatena.ne.jp/perlcodesample"#"/"#g;
  
  if ($line =~ /^```/) {
    if (!$pre_start) {
      $line =~ s#^```(.*)#<pre>#;
      $pre_start = 1;
    }
    else {
      $line =~ s#^```#</pre>#;
      $pre_start = 0;
    }
  }
  $content .= $line;
}

print encode('UTF-8', $content);
