#!/usr/bin/perl

use strict;
use warnings;



# Creates a Krunker mod (.zip) that replaces the blue beanie (hat_13.obj) with
# a given .obj file.
# This script is highly unportable.

# perl krunker_test_hats.pl C:\Users\corra\Documents\art\krunker\diving_helmet\diving_helmet.obj

if ($0 =~ /([^\\]*)$/ && @ARGV != 1) {
    print "Usage: $1 <.obj path>";
    exit;
}

my $sevenzip_cmd_line_path = "C:\\Program Files\\7-Zip\\7z.exe";
my $modding_template_path = "C:\\Users\\corra\\Documents\\programs\\Krunker Expanded Assets\\Krunker Expanded Assets\\5) Tools & Guides\\modding_template";
my $models_path = "$modding_template_path\\models";
my $dest_path = "$modding_template_path\\models\\hats\\hat_13.obj";
my $obj_path = shift @ARGV;



open my $fh1, "<", "$obj_path" or die "Couldn't open '$obj_path'\n";
my $contents = join "", <$fh1>;
close $fh1;

open my $fh2, ">", "$dest_path" or die "Couldn't open '$dest_path'\n";
print $fh2 "$contents";
close $fh2;

my $zip_name;
for (my $i = 0; -e ($zip_name = "$modding_template_path\\hat_replaced$i.zip"); $i++) {
    ;
}

my @args = ($sevenzip_cmd_line_path, "a", "-tzip", $zip_name, $models_path);
(system @args) == 0 or die "Failed syscall\n";

print "\n";
print "Mod path: '$zip_name'\n";


