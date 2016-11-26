#!/usr/bin/env perl

# ashnazg - Black Speech based names and text generator.

# Copyright (C) 2016 Konstantin Shakhnov

# This program is free software: you can redistribute it and/or modify
# it under the terms of the GNU General Public License as published by
# the Free Software Foundation, either version 3 of the License, or
# (at your option) any later version.

# This program is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
# GNU General Public License for more details.

# You should have received a copy of the GNU General Public License
# along with this program.  If not, see <http://www.gnu.org/licenses/>.

# Based on Craig Daniel's "A SECOND OPINION ON THE BLACK SPEECH"
# (http://folk.uib.no/hnohf/blackspeech.htm)

# TODO:
# - check --*-size options to empty arg
# TODO OPTIONS:
# -??                    define beginning of paragraph [ default "    "]
# -t  --times=N1-N2	 generate TARGET from N1 to N2 times
#     --haiku (5-7-5)
#     --tanka (5-7-5-7-7, The 5-7-5 is called the kami-no-ku ("upper phrase"),
#          and the 7-7 is called the shimo-no-ku ("lower phrase").)

use strict;
use warnings;
use Getopt::Long qw(:config bundling no_auto_abbrev);

my $program = "ashnazg";
my $version = "0.95";
my $year    = "2016";
my $author  = "Konstantin Shakhnov";
my $mail    = "kastian\@mail.ru";
my $url     = "https://github.com/kastian/ashnazg/";

my $target = undef;
my $times = 10;
my $sentence_min_words = 3;
my $sentence_max_words = 8;
my $paragraph_min_size = 5;
my $paragraph_max_size = 15;

my @vovel                     = qw (a i o u â û);
my @diphthong                 = qw (ai au);
my @consonant                 = qw (b d g h k l m n p r s t z);
my @consonant_cluster         = qw (gh sh th);
my @consonant_initial_cluster = qw (gl kr sk thr);
my @consonant_final_cluster   = qw (mb mp nk rz zg);

my @final_vovel               = (@vovel, @diphthong);
my @initial_consonant         = (@consonant_initial_cluster,
				 @consonant_cluster,
				 @consonant);
my @final_consonant           = (@consonant_final_cluster,
				 @consonant_cluster,
				 @consonant);

sub random {
    my $array_ref = shift;
    my $random = $$array_ref[int(rand(scalar(@$array_ref)))];
    return (not ref($random)) ? $random : join("", map($_->(), @$random));
}

sub vovel {
    return random(\@vovel);
}

sub final_vovel {
    return random(\@final_vovel);
}

sub initial_consonant {
    return random(\@initial_consonant)
}

sub final_consonant {
    return random(\@final_consonant)
}

sub vc {
    return sprintf("%s%s", vovel(), final_consonant());
}

sub cv {
    return sprintf("%s%s", initial_consonant(), final_vovel());
}

sub cvc {
    return sprintf("%s%s%s", initial_consonant(), vovel(), final_consonant());
}

sub syllable {
    return random([[ \&vc, ],
    		   [ \&cv, ],
    		   [ \&cvc, ]]);
}

sub word {
    return random([[ \&cvc, ],
		   [ \&cvc, \&vc, ],
		   [ \&cvc, \&vc, \&vc, ], ]);
}

sub name {
    return ucfirst(random([[ \&vovel, \&cvc, ],
			   [ \&cv, \&cvc, ],
			   [ \&vc, \&cvc, ],
			   [ \&cvc, \&vc, ],
			   [ \&cvc, \&cvc,], ]));
}

sub end_of_sentence {
    return sprintf("%s ", random([".", ".", ".", ".", "?", "!","...",]));
}

sub list {
    my ($min, $max) = @_;
    return (1 ..  $min + int(rand($max - $min)));
}

sub sentence {
    return sprintf("%s%s",
		   ucfirst(join(" ", map(word(),
					 list($sentence_min_words,
					      $sentence_max_words)))),
		   end_of_sentence());
}

sub paragraph {
    return sprintf("    %s",
		   join("", map(sentence(),
				list($paragraph_min_size,
				     $paragraph_max_size))));
}

sub print_help {
    print <<"END";
$program - Black Speech based names and text generator.
Usage: $program TARGET [OPTIONS]

TARGETS:
      --syllable	 generate syllable
  -n  --name		 generate name
  -w  --word		 generate word
  -s  --sentence	 generate sentence
  -p  --paragraph	 generate paragraph

OPTIONS:
  -t  --times=N		 generate TARGET N times
                         [default: 10]
  --sentence-size=N1     N words in sentence.
  --sentence-size=N1-N2  from N1 to N2 words in sentence.
                         [default: $sentence_min_words-$sentence_max_words]
  --paragraph-size=N     N sentences in paragraph
  --paragraph-size=N1-N2 from N1 to N2 sentences in paragraph.
                         [default: $paragraph_min_size-$paragraph_max_size]

  -o  --no-o		 do not use 'o'
  -a  --no-a		 do not use 'â'
  -u  --no-u		 do not use 'û'
  -c  --no-circumflex	 do not use 'â' and 'û' (equals -au)

  -h  --help		 display this text and exit
  -v  --version		 display version information and exit

Report bugs to: $mail
$program home page: <$url>
END
    exit 0;
}

sub print_version {
    print <<"END";
$program $version
Copyright (C) $year $author
License GPLv3+: GNU GPL version 3 or later <http://gnu.org/licenses/gpl.html>
This is free software: you are free to change and redistribute it.
There is NO WARRANTY, to the extent permitted by law.
END
    exit 0;
}

sub print_error {
    printf "%s: %s\n", $program, shift;
    printf "Try '%s --help' for more information.\n", $program;
    exit 1;
}

sub set_target {
    print_error("TARGET is already defined as '$target'") if defined($target);
    $target = shift;
}

sub parse_size {
    my ($opt, $value) = @_;
    my ($min, $max) = $value =~ m/(\d+)(?:-([\d]+))?/;
    print_error("option '$opt': min value ($min) > max value ($max)") if defined($max) and $min > $max;
    return (not defined($max)) ? ($min, $min) : ($min, $max);
}

GetOptions(
    'syllable'         => sub { set_target \&syllable; },
    'n|name'           => sub { set_target \&name; },
    'w|word'           => sub { set_target \&word; },
    's|sentence'       => sub { set_target \&sentence; },
    'p|paragraph'      => sub { set_target \&paragraph; },
    'sentence-size=s'  => sub { ($sentence_min_words, $sentence_max_words) = parse_size(@_); },
    'paragraph-size=s' => sub { ($paragraph_min_size, $paragraph_max_size) = parse_size(@_); },
    't|times=i'        => \$times,
    'o|no-o'           => sub { @vovel = grep(/[^o]/, @vovel); @final_vovel = grep(/[^o]/, @final_vovel); },
    'a|no-a'           => sub { @vovel = grep(/[^â]/, @vovel); @final_vovel = grep(/[^â]/, @final_vovel); },
    'u|no-u'           => sub { @vovel = grep(/[^û]/, @vovel); @final_vovel = grep(/[^û]/, @final_vovel); },
    'c|no-circumflex!' => sub { @vovel = grep(/[^âû]/, @vovel); @final_vovel = grep(/[^âû]/, @final_vovel); },
    'h|?|help'         => \&print_help,
    'v|version'        => \&print_version,
    ) || print_error("error in command line arguments");

$target = \&name if not defined($target);
printf "%s\n", &$target while ($times-- > 0);
