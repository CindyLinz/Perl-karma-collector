#!/usr/bin/perl

use strict;
use warnings;

my($log_path, $out_file) = @ARGV;

my @name_map = (
    [lanfon72 => 'lanf0n'],
    [aokman => 'a0kman'],
);

my $pisg_cfg_nick_alias = <<'.';
<user nick="Jedi" alias="Jedi*">
<user nick="mindos" alias="MindosC* mindos_*">
<user nick="Sorry" alias="Sorry*">
<user nick="Wush" alias="*Wush978*">
<user nick="ca" alias="ca_* ca^*">
<user nick="chhsiao1981" alias="smileshou">
<user nick="chihchun" alias="*chihchun">
<user nick="clkao" alias="clkao*">
<user nick="hychen" alias="hychen*">
<user nick="jftsai" alias="jftsai*">
<user nick="kanru" alias="kanru*">
<user nick="kcwu" alias="kcwu*">
<user nick="knight" alias="KN16H7">
<user nick="logbot" alias="logbot*">
<user nick="macpaul" alias="macpaul*">
<user nick="medicalwei" alias="medicalw1i">
<user nick="mhsin" alias="mhsin* mhs1n*">
<user nick="mikimoto" alias="mikimoto*">
<user nick="momizi" alias="momizi* momiz1*">
<user nick="opop" alias="opop_*">
<user nick="pingooo" alias="*pingooo">
<user nick="shawnwang" alias="shawnwan*">
<user nick="thschee" alias="thschee* zz*thschee">
<user nick="tkirby" alias="tkirby*">
<user nick="wHisKy" alias="wHisKy*">
<user nick="walkingice" alias="walkingice* *walkingice">
<user nick="yllan" alias="yllan*">
<user nick="yurenju" alias="yurenju*">
<user nick="zealancer" alias="zealancer* zeal_bsd*">
<user nick="ipa" alias="ipa_*">
<user nick="GitHub" alias="GitHub*">
<user nick="billy3321" alias="billy332*">
<user nick="miaout17" alias="miaout17*">
<user nick="tka" alias="tka_*">
<user nick="hlb" alias="hlb_*">
<user nick="ronnywang" alias="ronnywan1">
<user nick="nchild" alias="nchild_*">
<user nick="lijung" alias="lijung_*">
<user nick="juanna" alias="juanna_*">
<user nick="caasih" alias="caasiHuang CAA51">
<user nick="iamblue" alias="iamblue_*">
<user nick="pm5" alias="pm5cloud pm5_*">
<user nick="kcliu" alias="kcliu_* KCLiu">
<user nick="Jedi" alias="Jedi_*">
<user nick="pofeng" alias="pofeng_*">
<user nick="LCfunPlay" alias="LCfunPlay_*">
<user nick="S3p_lin" alias="S3p_lin*">
.

for my $map_entry ( split /\n/, $pisg_cfg_nick_alias ) {
    if( $map_entry =~ /nick="([^"]+)"\s+alias="([^"]+)"/ ) {
        my($nick, $alias) = ($1, $2);
        while( $alias =~ /(\S+)/g ) {
            my $alias_entry = $1;
            $alias_entry =~ s/\*/.*/;
            push @name_map, [$alias_entry, $nick];
        }
    }
}

{
    my %score;

    while( my $entry = glob $log_path ) {
        open my $f, $entry;
        while( my $line = <$f>) {
            while( $line =~ /([a-zA-Z0-9_^-]+?)[_ :,^-]*\+\+/g ) {
                my $name = $1;
                for my $map_entry ( @name_map ) {
                    if( $name =~ /^$map_entry->[0]$/i ) {
                        $name = $map_entry->[1];
                        last;
                    }
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
    sleep 30;
    redo;
}
