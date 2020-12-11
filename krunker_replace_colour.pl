#!/usr/bin/perl

use strict;
use warnings;



# Takes a Krunker map file and:
# 1st IF: changes the texture and emission colours;
# 2nd IF: changes the texture;
# of all objects except those specified to ignore.

# perl krunker_replace_colour.pl "C:\Users\corra\Downloads\untitled_export (55).txt" 80d4d9 71cade 30
# perl krunker_replace_colour.pl "C:\Users\corra\Downloads\untitled_export (29).txt" 71cade 71d1de 30

if ($0 =~ /([^\\]*)$/ && @ARGV < 3) {
    print "Usage: $1 <.txt path> <from> <to> <space-separated IDs of objects to ignore>";
    exit;
}

my $map = shift @ARGV;
my $from = shift @ARGV;
my $to = shift @ARGV;
my @ignore_ids = @ARGV;

if ($from eq $to) {
    print "Redundant";
    exit;
}

open my $fh1, "<", $map or die;
my @contents = split "{", <$fh1>;
close $fh1;



my $i;

# Moves $i to reference the start of the objects
for ($i = 0; $i < @contents; $i++) {
    if ($contents[$i] =~ /"objects":/) {
        $i++;
        last;
    }
}

die "Invalid map file" if ($i == @contents);



my $n_obj = 0;
my $n_obj_changed = 0;

for (; $i < @contents; $i++) {
    $n_obj++;


    # Ignores specified IDs
    my $id = ($contents[$i] =~ /"i":(\d+)/) ? $1 : "0";
    my $next_flag = 0;

    foreach (@ignore_ids) {
        if ($id eq $_) {
            $next_flag = 1;
            last;
        }
    }
    
    next if ($next_flag == 1);

    
    my $original = $contents[$i];
    print "$original\n";


    if (1) {
        $contents[$i] =~ s/#$from/#$to/g;

        if (($from eq "ffffff") && !($contents[$i] =~ /"c":"#......"/)) {
            $contents[$i] =~ s/}/,"c":"#$to"}/g;
        }

        if (($from eq "000000") && !($contents[$i] =~ /"e":"#......"/)) {
            $contents[$i] =~ s/}/,"e":"#$to"}/g;
        }
    }

    if (0) {
        if ($contents[$i] =~ /"t":$from\D/) {
            $contents[$i] =~ s/"t":$from/"t":$to/g;
        } elsif (($contents[$i] =~ /"t":/) && ($from eq "0")) {
            $contents[$i] =~ s/}/,"t":$to}/g
        }
    }


    $n_obj_changed += ($contents[$i] eq $original) ? 0 : 1;

    # Ends if the objects array has ended
    my @open_sq = ($contents[$i] =~ /\[/g);
    my @close_sq = ($contents[$i] =~ /\]/g);
    last if (@close_sq > @open_sq);
}

die "Invalid map file" if ($i == @contents);



my $new_contents = join "{", @contents;

open my $fh2, ">", ("$map"."_new.txt") or die;
print $fh2 $new_contents;
close $fh2;

print "Changed $n_obj_changed/$n_obj objects\n";


