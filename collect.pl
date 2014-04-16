#!/usr/bin/perl

use strict;
use warnings;

my($log_path, $out_file) = @ARGV;

my %name_map = (
    lanfon72 => 'lanf0n',
    aokman => 'a0kman',
);

{
    my %score;

    while( my $entry = glob $log_path ) {
        open my $f, $entry;
        while( my $line = <$f>) {
            while( $line =~ /(\w+)[ :,]*\+\+/g ) {
                my $name = $1;
                $name =~ s/[_^]*$//;
                if( exists $name_map{$name} ) {
                    $name = $name_map{$name};
                }
                ++$score{$name};
            }
        }
        close $f;
    }

    open my $outf, ">$out_file";
    my($sec,$min,$hour,$mday,$mon,$year,$wday,$yday,$isdst) = localtime;
    printf "Update: %d.%d.%d %02d:%02d:%02d\n", $year+1900, $mon+1, $mday, $hour, $min, $sec;
    printf $outf "Update: %d.%d.%d %02d:%02d:%02d\n", $year+1900, $mon+1, $mday, $hour, $min, $sec;
    for my $name ( sort { $score{$b} <=> $score{$a} || $a cmp $b } keys %score ) {
        print $outf "$name: $score{$name}\n";
    }
    close $outf;
    sleep 10;
    redo;
}
