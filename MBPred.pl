#!/usr/bin/perl
use strict;
use warnings;
#use 5.010;
#use Data::Dumper qw(Dumper);
#use Array::Utils qw(:all);
no warnings 'uninitialized'; 

my $input = $ARGV[0]; #open fasta file
my $addition = $ARGV[1]; #time signature

#system "find /srv/www/htdocs/bioinformatics/MBPpred/results/ -mtime +8 -exec rm -rf {} \;"; # execute this chunk of code to delete files older than a week

##############################
#         First Part         #
##############################
open(FAS, "<", $input) || die ("Error opening file FAS");
open (NFAS, ">", "results/$addition.20headerfasta") || die ("Error opening file NFAS");
my @title = '';
my @seqs = '';
my @wholetitle = '';
my $seq = '';

while (<FAS>)
{
	if($_=~/^(>.+)/){
		my $wholetitl = $1;
		my $sub=substr($1,0,20); #se auth th fash 8elw na krataw mono tous 20 prwtous xarakthres gia na diavazei to hmmer
		$sub=~s/\s//g; #na fugoun oi space characters an uparxoun gia na doulepsei to eq sto part 4
		push(@wholetitle, $wholetitl);
		push(@title,$sub);
		push(@seqs,$seq); # Sprwxnei edw thn akolou8ia afou prwta thn exei diavasei oloklhrh Thn prwth fora 8a einai undef
		$seq=''; # kai meta thn adeiazei
	}
	else {
		$seq.=$_;
		$seq=~s/\s//g;
	}
}
push(@seqs,$seq); # gia na mpei kai h 3h akolou8ia afou den 8a 3anampei sto prwto if
shift(@seqs); # diagrafei thn prwth timh pou einai undef, opote kai erxontai ta index se swsth seira

#print join "\n", @seqs;
#print join "\n", @wholetitle;
#print join "\n", @title;

for(my $i=1;$i<=$#seqs;$i++){
	print NFAS $title[$i]."\n".$seqs[$i]."\n";
}


close NFAS;

##############################
#        Second Part         #
##############################

open (HMMIN, "<", "results/$addition.20headerfasta") || die ("Error opening file HMMIN");
open (HMMOUT, ">", "results/$addition.hmmerout") || die ("Error opening file HMMOUT");
open (HMMOUT2, ">", "results/".$addition."_hmmeroutput.txt") || die ("Error opening file HMMOUT2");

system "hmmsearch --domtblout results/$addition.hmmerout --cut_ga 40pHMMslib.hmm results/$addition.20headerfasta >results/".$addition."_hmmeroutput.txt";

close HMMIN;
close HMMOUT;
close HMMOUT2;

##############################
#         Third Part         #
##############################

open (IN, "<", "results/$addition.hmmerout") || die ("Error opening file IN");
open (OUT, ">", "results/$addition.output1") || die ("Error opening file OUT");

my @targetName = '';
my @domainName = '';
my @domainScore = '';
my @domainNumber = '';
my @alignmentStart = '';
my @alignmentEnd = '';
my @targetLength = '';

while (<IN>){
	if($_!~/^\#/){
#	tr|Q16QE7|Q16QE7_AEDAE -            325 Annexin              PF00191.15    66   1.1e-96  316.9   5.9   1   4   1.8e-26   2.4e-23   81.9   0.2     1    66    25    90    25    90 0.98 Annexin OS=Aedes aegypti GN=AAEL011302 PE=3 SV=1
		if ($_=~/^(\S+)\s+\S+\s+(\S+)\s+(\S+)\s+\S+\s+\S+\s+\S+\s+\S+\s+\S+\s+(\S+)\s+(\S+)\s+\S+\s+\S+\s+(\S+)\s+\S+\s+\S+\s+\S+\s+(\S+)\s+(\S+)\s+\S+\s+\S+\s+(\S+)\s+\S+/){
				  # ID     AC    tlen    nam     AC    qln   E    sco    bias    #      of     c-E  i-E    sco   bias  hmmf  hmmt  alifr   alito   envf  envt   acc    des
			push(@targetName,$1);
			push(@targetLength,$2);
			push(@domainName,$3);
			push(@domainNumber,$4);
			push(@domainScore,$6);
			push(@alignmentStart,$7);
			push(@alignmentEnd,$8);
#			push(@alignmentAccuracy,$9);
		}
	}
}

# dhmiourgia hash of arrays pou vazei ola ta domains gia ka8e eggrafh
my %domains;
for (my $i=1;$i<=$#targetName;$i++){
	if($domainName[$i] ne "PH" && $domainName[$i] ne "C1_1"){
		$domains{$targetName[$i]}[$i] = $domainName[$i].':'.$alignmentStart[$i].'-'.$alignmentEnd[$i].' (score: '.$domainScore[$i].')'."; ";
	}
	elsif($domainName[$i] eq "PH"){
		if($domainScore[$i] >=25.10){
			$domains{$targetName[$i]}[$i] = $domainName[$i].':'.$alignmentStart[$i].'-'.$alignmentEnd[$i].' (score: '.$domainScore[$i].')'."; ";
		}
	}
	elsif($domainName[$i] eq "C1_1"){
		if($domainScore[$i] >=26.00){
			$domains{$targetName[$i]}[$i] = $domainName[$i].':'.$alignmentStart[$i].'-'.$alignmentEnd[$i].' (score: '.$domainScore[$i].')'."; ";
		}
	}
}


# sortarei kai tupwnei to ID kai apo katw ta domains 
#(prosoxh ta undefined values emfanizontai san kena)
for my $keys ( sort { @{$domains{$b}} <=> @{$domains{$a}} } keys %domains ) {
    print OUT "ID:\t$keys\n Domain(Position):@{$domains{$keys}}\n//\n";
}
# print OUT Dumper \%domains;
close IN;
close OUT;

#anoigoume to prohgoumeno arxeio gia na tou ftia3oume th morfopoihsh sto tupwma
#kai na diw3oumw ta kena apo ta undef
open (IN2, "<", "results/$addition.output1") || die ("Error opening file IN2");
open (OUT2, ">", "results/$addition.output2") || die ("Error opening file OUT2");

while (<IN2>){
	$_=~s/ //g;
	print OUT2 $_;
	}

close IN2;
close OUT2;

#anoigoume to arxeio gia na tupwsoume sequence length kai score gia ta domains
open (IN3, "<", "results/$addition.output2") || die ("Error opening file IN3");
open (OUT3, ">", "results/$addition.output3") || die ("Error opening file OUT3");
#open (NEG, ">", "results/".$addition."_negres.txt") || die ("Error opening file NEG");
open (LIST1, ">", "results/".$addition."_poslist.txt") || die ("Error opening file LIST1");
open (LIST3, ">", "results/".$addition.".poslist") || die ("Error opening file LIST1");
#open (LIST2, ">", "results/".$addition."_neglist.txt") || die ("Error opening file LIST2");
open (FASPRED, ">", "results/$addition.predclassfasta") || die ("Error opening file FASPRED");
#open (TAB, ">", "results/$addition.tab") || die ("Error opening file TAB");

$/="//\n";
#print $/;
my @id='';
my @domain='';
my @titl='';
my $tit='';
while (<IN3>){
	if ($_=~/^(ID:\t(\S+))\n(Domain.*)/m){
#		print OUT3 "ID:\t$1";
		push(@id,$1);
		push(@domain,$3);
#		print OUT3 "\n$3";
		$tit = ">$2";
		push(@titl, $tit);
#		print "$tit\n";
#		print OUT3 "\nSequence: ";
#		print OUT3 "\n//\n";
	}
}
#print "@id";

for(my $m=1; $m<=$#title; $m++){
	for (my $n=1; $n<=$#titl+1; $n++){
		if($title[$m] eq $titl[$n]){
			print LIST1 "$wholetitle[$m]\n";
			print LIST3 "$wholetitle[$m]\n";
			print OUT3 "$id[$n]\n";
			print OUT3 "$domain[$n]\n";
#			print "$id[$m]\n";
#			print "$id[$n]\n";
#			print "$title[$m]\n";
#			print "$titl[$n]\n//\n";
			print OUT3 "Sequence: $seqs[$m]\nSequence length:";
			print FASPRED "$title[$m]\n$seqs[$m]\n";
			my $mikos=length($seqs[$m]);
			print OUT3 "\t$mikos";
			print OUT3 "\n//\n";
#			if ($id[$n]=~/^ID:\t(\S+)/){
#				print TAB "$1\t$mikos\tYes\n";
#			}
		}
	}
}
#create a negative list
#my @minus = array_minus( @title, @titl );
#for(my $p=0; $p<=$#minus; $p++){
#	for (my $q=1; $q<=$#title; $q++){
#		if($minus[$p] eq $title[$q]){
#			if ($title[$q]=~/^>(\S+)/){
#				print NEG "ID: $1\n";
#				print LIST2 "$wholetitle[$q]\n";
#				print TAB "$1\t";
#			}
#			print NEG "Sequence: $seqs[$q]\nSequence length:";
#			my $mikos=length($seqs[$q]);
#			print NEG "\t$mikos";
#			print NEG "\n//\n";	
#			print TAB "$mikos\tNo\n";
#		}
#	}
#}

close FAS;
close IN3;
close OUT3;
#close NEG;
close LIST1;
close LIST3;
#close LIST2;
close FASPRED;
#close TAB;


##############################
#        Fourth Part         #
##############################

open (PREDIN, "<", "results/$addition.predclassfasta") || die ("Error opening file PREDIN");
open (PREDOUT, ">", "results/$addition.outputpredclass") || die ("Error opening file PREDOUT");

system "java -classpath classes/ preds.MassPreds -c ./results/$addition.predclassfasta > results/$addition.outputpredclass";

close PREDIN;
close PREDOUT;


##############################
#         Fifth Part         #
##############################


open (IN4, "<", "results/$addition.outputpredclass") || die ("Error opening file IN4");
open (IN5, "<", "results/$addition.output3") || die ("Error opening file IN5");;
open (OUT4, ">", "results/".$addition."_output4.txt") || die ("Error opening file OUT4");
open (LISTPER, ">", "results/".$addition."_peripherallist.txt") || die ("Error opening file LISTPER");
open (LISTTM, ">", "results/".$addition."_tmlist.txt") || die ("Error opening file LISTTM");
open (LIST2, "<", "results/".$addition.".poslist") || die ("Error opening file LIST2");

my @titlepred = '';
my @pospred = '';

$/="\n";
while (<IN4>)
{
	if($_=~/^>(\S+)\s+(MIXED\sPROTEIN|GLOBULAR\sPROTEIN|MEMBRANE\sPROTEIN|FIBROUS\sPROTEIN)/){
		push(@titlepred,$1);
		if ($2 eq "MIXED PROTEIN" || $2 eq "GLOBULAR PROTEIN"){
			push(@pospred,"peripheral protein");	
		}
		elsif($2 eq "MEMBRANE PROTEIN"){
			push(@pospred,"transmembrane protein");
		}	 
		elsif($2 eq "FIBROUS PROTEIN"){
			push(@pospred,"unknown");
		}
	}
}
my @tmtitle = '';
my @pertitle = '';
my @postitles = '';
my @choppedtitle = '';
$/="//\n";
while (<IN5>){
# print "$_\n\n";
	if ($_=~/^(ID:\t(\S+)\n(.*)\n(.*)\n(.*))/m){  
		print OUT4 "$1";
#		print "$1\n";
		print OUT4 "\nPosition in Membrane: ";
		for(my $n=0; $n<=$#titlepred;$n++){
			if($titlepred[$n] eq $2){
				print OUT4 "\t$pospred[$n]";
				if($pospred[$n] eq "peripheral protein")
				{
					my $periptitle=">".$titlepred[$n];
					push(@pertitle, $periptitle);
#					print "per $titlepred[$n]\n";
				}
				elsif($pospred[$n] eq "transmembrane protein")
				{
					my $transmemtitle=">".$titlepred[$n];
					push(@tmtitle, $transmemtitle);
#					print "tm $titlepred[$n]\n";
				}
			}
		}
		print OUT4 "\n//\n";

	}
}
$/="\n";
while (<LIST2>){
if($_=~/^>/) {
	my $grammi= $_;
	chomp $grammi;
	push(@postitles,$grammi);
#	print "$grammi\n";
	my $sub2=substr($grammi,0,20); #se auth th fash 8elw na krataw mono tous 20 prwtous xarakthres gia na diavazei to hmmer
	$sub2=~s/\s//g;
	push(@choppedtitle,$sub2);
#	print "$sub2\n";
}
}
for(my $o=1; $o<=$#choppedtitle; $o++){
	for (my $p=1; $p<=$#pertitle+1; $p++){
		if($choppedtitle[$o] eq $pertitle[$p]){
			print LISTPER "$postitles[$o]\n";
#			print "per $postitles[$o]\n";
		}
	}
}
for(my $q=1; $q<=$#choppedtitle; $q++){
	for (my $r=1; $r<=$#tmtitle+1; $r++){
		if($choppedtitle[$q] eq $tmtitle[$r]){
			print LISTTM "$postitles[$q]\n";
#			print "tm $postitles[$q]\n";
		}
	}
}
close IN4;
close IN5;
close OUT4;
close LIST2;
close LISTPER;
close LISTTM;

##############################
#         Sixth Part         #     clans
##############################
### I wrote a program to write this code, had no knowledge of subroutines in Perl then
### Tried to make one later never had the time to get around to finish it though
### The code still works it is just very very bad

open (IN6, "<", "results/".$addition."_output4.txt") || die ("Error opening file IN6");
open (OUT6, ">", "results/".$addition."_finaloutput.txt") || die ("Error opening file OUT6");
my $domains ='';
my $anth = '';
my $anthscore = '';
my $enth = '';
my $enthscore = '';
my $bar = '';
my $barscore ='';
my $bar2 = '';
my $bar2score ='';
my $bar3 = '';
my $bar3score ='';
my $c1 = '';
my $c1score ='';
my $c1_2 = '';
my $c1_2score ='';
my $c1_3 = '';
my $c1_3score ='';
my $c2='';
my $c2score = "";
my $dock='';
my $dockscore = "";
my $pi3k='';
my $pi3kscore = "";
my $pten='';
my $ptenscore = "";
my $fyve='';
my $fyvescore = "";
my $fyve2='';
my $fyve2score = "";
my $ph='';
my $phscore = "";
my $ph2='';
my $ph2score = "";
my $ph3='';
my $ph3score = "";
my $ph4='';
my $ph4score = "";
my $ph5='';
my $ph5score = "";
my $ph6='';
my $ph6score = "";
my $ph8='';
my $ph8score = "";
my $ph9='';
my $ph9score = "";
my $ph10='';
my $ph10score = "";
my $ph11='';
my $ph11score = "";
my $ph12='';
my $ph12score = "";
my $ph13='';
my $ph13score = "";
my $phbeach='';
my $phbeachscore = "";
my $sequence = '';
my $sequence_length = '';
my $position_in_membrane = '';
$/="//\n";
while (<IN6>){
# print "$_\n\n";
	if ($_=~/^((ID:\t\S+)\nDomain\(Position\)\:(.*)\n(Sequence\:\s.*)\n(Sequence length\:\t.*)\n(Position in Membrane\:\s\t.*))/m){
		print OUT6 $2;
		print OUT6 "\n";
		print OUT6 "Domain(Position\):";
		$domains=$3;
		$sequence = $4;
		$sequence_length = $5;
		$position_in_membrane = $6;
		if($domains=~/(ANTH\:\d+\-\d+\(score\:(\d+)\.\d+\)\;)/){ 
			$anth = $1;
			$anthscore = $2;
			if($domains=~/(ENTH\:\d+\-\d+\(score\:(\d+)\.\d+\)\;)/){
				$enth = $1;
				$enthscore = $2;
				if($anthscore>$enthscore){
					print OUT6 $anth;
					print OUT6 "\n";
					print OUT6 $sequence;
					print OUT6 "\n";
					print OUT6 $sequence_length;
					print OUT6 "\n";
					print OUT6 $position_in_membrane;
					print OUT6 "\n";
					print OUT6 "//\n";
					}
				elsif($anthscore<$enthscore){
					print OUT6 $enth;
					print OUT6 "\n";
					print OUT6 $sequence;
					print OUT6 "\n";
					print OUT6 $sequence_length;
					print OUT6 "\n";
					print OUT6 $position_in_membrane;
					print OUT6 "\n";
					print OUT6 "//\n";
					}				
				}				
			else{
				print OUT6 $domains;
				print OUT6 "\n";
				print OUT6 $sequence;
				print OUT6 "\n";
				print OUT6 $sequence_length;
				print OUT6 "\n";
				print OUT6 $position_in_membrane;
				print OUT6 "\n";
				print OUT6 "//\n";
				}
		}
		elsif($domains=~/(BAR\:\d+\-\d+\(score\:(\d+)\.\d+\)\;)/){ 
			$bar = $1;
			$barscore = $2;
			if($domains=~/(BAR\_2\:\d+\-\d+\(score\:(\d+)\.\d+\)\;)/){
				$bar2 = $1;
				$bar2score = $2;
				if($barscore>$bar2score){
					print OUT6 $bar;
					print OUT6 "\n";
					print OUT6 $sequence;
					print OUT6 "\n";
					print OUT6 $sequence_length;
					print OUT6 "\n";
					print OUT6 $position_in_membrane;
					print OUT6 "\n";
					print OUT6 "//\n";
					}
				elsif($barscore<$bar2score){
					print OUT6 $bar2;
					print OUT6 "\n";
					print OUT6 $sequence;
					print OUT6 "\n";
					print OUT6 $sequence_length;
					print OUT6 "\n";
					print OUT6 $position_in_membrane;
					print OUT6 "\n";
					print OUT6 "//\n";
					}
				}
			elsif($domains=~/(BAR\_3\:\d+\-\d+\(score\:(\d+)\.\d+\)\;)/){
				$bar3 = $1;
				$bar3score = $2;
				if($barscore>$bar3score){
					print OUT6 $bar;
					print OUT6 "\n";
					print OUT6 $sequence;
					print OUT6 "\n";
					print OUT6 $sequence_length;
					print OUT6 "\n";
					print OUT6 $position_in_membrane;
					print OUT6 "\n";
					print OUT6 "//\n";
					}
				elsif($barscore<$bar3score){
					print OUT6 $bar3;
					print OUT6 "\n";
					print OUT6 $sequence;
					print OUT6 "\n";
					print OUT6 $sequence_length;
					print OUT6 "\n";
					print OUT6 $position_in_membrane;
					print OUT6 "\n";
					print OUT6 "//\n";
					}
				}
			else{
				print OUT6 $domains;
				print OUT6 "\n";
				print OUT6 $sequence;
				print OUT6 "\n";
				print OUT6 $sequence_length;
				print OUT6 "\n";
				print OUT6 $position_in_membrane;
				print OUT6 "\n";
				print OUT6 "//\n";
				}
		}
		elsif($domains=~/(BAR\_2\:\d+\-\d+\(score\:(\d+)\.\d+\)\;)/){ 
			$bar2 = $1;
			$bar2score = $2;
			if($domains=~/(BAR\_3\:\d+\-\d+\(score\:(\d+)\.\d+\)\;)/){
				$bar3 = $1;
				$bar3score = $2;
				if($bar2score>$bar3score){
					print OUT6 $bar2;
					print OUT6 "\n";
					print OUT6 $sequence;
					print OUT6 "\n";
					print OUT6 $sequence_length;
					print OUT6 "\n";
					print OUT6 $position_in_membrane;
					print OUT6 "\n";
					print OUT6 "//\n";
					}
				elsif($bar2score<$bar3score){
					print OUT6 $bar3;
					print OUT6 "\n";
					print OUT6 $sequence;
					print OUT6 "\n";
					print OUT6 $sequence_length;
					print OUT6 "\n";
					print OUT6 $position_in_membrane;
					print OUT6 "\n";
					print OUT6 "//\n";
					}
				}
			else{
				print OUT6 $domains;
				print OUT6 "\n";
				print OUT6 $sequence;
				print OUT6 "\n";
				print OUT6 $sequence_length;
				print OUT6 "\n";
				print OUT6 $position_in_membrane;
				print OUT6 "\n";
				print OUT6 "//\n";
				}
		}
		elsif($domains=~/(C1\_1\:\d+\-\d+\(score\:(\d+)\.\d+\)\;)/){ 
			$c1 = $1;
			$c1score = $2;
			if($domains=~/(C1\_2\:\d+\-\d+\(score\:(\d+)\.\d+\)\;)/){
				$c1_2 = $1;
				$c1_2score = $2;
				if($c1score>$c1_2score){
					print OUT6 $c1;
					print OUT6 "\n";
					print OUT6 $sequence;
					print OUT6 "\n";
					print OUT6 $sequence_length;
					print OUT6 "\n";
					print OUT6 $position_in_membrane;
					print OUT6 "\n";
					print OUT6 "//\n";
					}
				elsif($c1score<$c1_2score){
					print OUT6 $c1_2;
					print OUT6 "\n";
					print OUT6 $sequence;
					print OUT6 "\n";
					print OUT6 $sequence_length;
					print OUT6 "\n";
					print OUT6 $position_in_membrane;
					print OUT6 "\n";
					print OUT6 "//\n";
					}
				}
			elsif($domains=~/(C1\_3\:\d+\-\d+\(score\:(\d+)\.\d+\)\;)/){
				$c1_3 = $1;
				$c1_3score = $2;
				if($c1score>$c1_3score){
					print OUT6 $c1;
					print OUT6 "\n";
					print OUT6 $sequence;
					print OUT6 "\n";
					print OUT6 $sequence_length;
					print OUT6 "\n";
					print OUT6 $position_in_membrane;
					print OUT6 "\n";
					print OUT6 "//\n";
					}
				elsif($c1score<$c1_3score){
					print OUT6 $c1_3;
					print OUT6 "\n";
					print OUT6 $sequence;
					print OUT6 "\n";
					print OUT6 $sequence_length;
					print OUT6 "\n";
					print OUT6 $position_in_membrane;
					print OUT6 "\n";
					print OUT6 "//\n";
					}
				}
			else{
				print OUT6 $domains;
				print OUT6 "\n";
				print OUT6 $sequence;
				print OUT6 "\n";
				print OUT6 $sequence_length;
				print OUT6 "\n";
				print OUT6 $position_in_membrane;
				print OUT6 "\n";
				print OUT6 "//\n";
				}
		}
		elsif($domains=~/(C1\_2\:\d+\-\d+\(score\:(\d+)\.\d+\)\;)/){ 
			$c1_2 = $1;
			$c1_2score = $2;
			if($domains=~/(C1\_3\:\d+\-\d+\(score\:(\d+)\.\d+\)\;)/){
				$c1_3 = $1;
				$c1_3score = $2;
				if($c1_2score>$c1_3score){
					print OUT6 $c1_2;
					print OUT6 "\n";
					print OUT6 $sequence;
					print OUT6 "\n";
					print OUT6 $sequence_length;
					print OUT6 "\n";
					print OUT6 $position_in_membrane;
					print OUT6 "\n";
					print OUT6 "//\n";
					}
				elsif($c1_2score<$c1_3score){
					print OUT6 $c1_3;
					print OUT6 "\n";
					print OUT6 $sequence;
					print OUT6 "\n";
					print OUT6 $sequence_length;
					print OUT6 "\n";
					print OUT6 $position_in_membrane;
					print OUT6 "\n";
					print OUT6 "//\n";
					}
				}
			else{
				print OUT6 $domains;
				print OUT6 "\n";
				print OUT6 $sequence;
				print OUT6 "\n";
				print OUT6 $sequence_length;
				print OUT6 "\n";
				print OUT6 $position_in_membrane;
				print OUT6 "\n";
				print OUT6 "//\n";
				}
			}	
		elsif($domains=~/^(C2\:\d+\-\d+\(score\:(\d+)\.\d+\)\;)/){ 
			$c2 = $1;
			$c2score = $2;
			if($domains=~/(DOCK\-C2\:\d+\-\d+\(score\:(\d+)\.\d+\)\;)/){
				$dock = $1;
				$dockscore = $2;
				if($c2score>$dockscore){
					print OUT6 $c2;
					print OUT6 "\n";
					print OUT6 $sequence;
					print OUT6 "\n";
					print OUT6 $sequence_length;
					print OUT6 "\n";
					print OUT6 $position_in_membrane;
					print OUT6 "\n";
					print OUT6 "//\n";
					}
				elsif($c2score<$dockscore){
					print OUT6 $dock;
					print OUT6 "\n";
					print OUT6 $sequence;
					print OUT6 "\n";
					print OUT6 $sequence_length;
					print OUT6 "\n";
					print OUT6 $position_in_membrane;
					print OUT6 "\n";
					print OUT6 "//\n";
					}				
			}
			elsif($domains=~/(PI3K\_C2\:\d+\-\d+\(score\:(\d+)\.\d+\)\;)/){
				$pi3k = $1;
				$pi3kscore = $2;
				if($c2score>$pi3kscore){
					print OUT6 $c2;
					print OUT6 "\n";
					print OUT6 $sequence;
					print OUT6 "\n";
					print OUT6 $sequence_length;
					print OUT6 "\n";
					print OUT6 $position_in_membrane;
					print OUT6 "\n";
					print OUT6 "//\n";
					}
				elsif($c2score<$pi3kscore){
					print OUT6 $pi3k;
					print OUT6 "\n";
					print OUT6 $sequence;
					print OUT6 "\n";
					print OUT6 $sequence_length;
					print OUT6 "\n";
					print OUT6 $position_in_membrane;
					print OUT6 "\n";
					print OUT6 "//\n";
					}				
			}
			elsif($domains=~/(PTEN\_C2\:\d+\-\d+\(score\:(\d+)\.\d+\)\;)/){
				$pten = $1;
				$ptenscore = $2;
				if($c2score>$ptenscore){
					print OUT6 $c2;
					print OUT6 "\n";
					print OUT6 $sequence;
					print OUT6 "\n";
					print OUT6 $sequence_length;
					print OUT6 "\n";
					print OUT6 $position_in_membrane;
					print OUT6 "\n";
					print OUT6 "//\n";
					}
				elsif($c2score<$ptenscore){
					print OUT6 $pten;
					print OUT6 "\n";
					print OUT6 $sequence;
					print OUT6 "\n";
					print OUT6 $sequence_length;
					print OUT6 "\n";
					print OUT6 $position_in_membrane;
					print OUT6 "\n";
					print OUT6 "//\n";
					}				
			}
			else{
				print OUT6 $domains;
				print OUT6 "\n";
				print OUT6 $sequence;
				print OUT6 "\n";
				print OUT6 $sequence_length;
				print OUT6 "\n";
				print OUT6 $position_in_membrane;
				print OUT6 "\n";
				print OUT6 "//\n";
				}
		}
		elsif($domains=~/(DOCK\-C2\:\d+\-\d+\(score\:(\d+)\.\d+\)\;)/){ 
			$dock = $1;
			$dockscore = $2;
			if($domains=~/(PI3K\_C2\:\d+\-\d+\(score\:(\d+)\.\d+\)\;)/){
				$pi3k = $1;
				$pi3kscore = $2;
				if($dockscore>$pi3kscore){
					print OUT6 $dock;
					print OUT6 "\n";
					print OUT6 $sequence;
					print OUT6 "\n";
					print OUT6 $sequence_length;
					print OUT6 "\n";
					print OUT6 $position_in_membrane;
					print OUT6 "\n";
					print OUT6 "//\n";
					}
				elsif($dockscore<$pi3kscore){
					print OUT6 $pi3k;
					print OUT6 "\n";
					print OUT6 $sequence;
					print OUT6 "\n";
					print OUT6 $sequence_length;
					print OUT6 "\n";
					print OUT6 $position_in_membrane;
					print OUT6 "\n";
					print OUT6 "//\n";
					}				
				}
			elsif($domains=~/(PTEN\_C2\:\d+\-\d+\(score\:(\d+)\.\d+\)\;)/){
				$pten = $1;
				$ptenscore = $2;
				if($dockscore>$ptenscore){
					print OUT6 $dock;
					print OUT6 "\n";
					print OUT6 $sequence;
					print OUT6 "\n";
					print OUT6 $sequence_length;
					print OUT6 "\n";
					print OUT6 $position_in_membrane;
					print OUT6 "\n";
					print OUT6 "//\n";
					}
				elsif($dockscore<$ptenscore){
					print OUT6 $pten;
					print OUT6 "\n";
					print OUT6 $sequence;
					print OUT6 "\n";
					print OUT6 $sequence_length;
					print OUT6 "\n";
					print OUT6 $position_in_membrane;
					print OUT6 "\n";
					print OUT6 "//\n";
					}				
			}
			else{
				print OUT6 $domains;
				print OUT6 "\n";
				print OUT6 $sequence;
				print OUT6 "\n";
				print OUT6 $sequence_length;
				print OUT6 "\n";
				print OUT6 $position_in_membrane;
				print OUT6 "\n";
				print OUT6 "//\n";
				}
		}
 		elsif($domains=~/(PI3K\_C2\:\d+\-\d+\(score\:(\d+)\.\d+\)\;)/){ 
			$pi3k = $1;
			$pi3kscore = $2;
			if($domains=~/(PTEN\_C2\:\d+\-\d+\(score\:(\d+)\.\d+\)\;)/){
				$pten = $1;
				$ptenscore = $2;
				if($pi3kscore>$ptenscore){
					print OUT6 $pi3k;
					print OUT6 "\n";
					print OUT6 $sequence;
					print OUT6 "\n";
					print OUT6 $sequence_length;
					print OUT6 "\n";
					print OUT6 $position_in_membrane;
					print OUT6 "\n";
					print OUT6 "//\n";
					}
				elsif($pi3kscore<$ptenscore){
					print OUT6 $pten;
					print OUT6 "\n";
					print OUT6 $sequence;
					print OUT6 "\n";
					print OUT6 $sequence_length;
					print OUT6 "\n";
					print OUT6 $position_in_membrane;
					print OUT6 "\n";
					print OUT6 "//\n";
					}
				}
			else{
				print OUT6 $domains;
				print OUT6 "\n";
				print OUT6 $sequence;
				print OUT6 "\n";
				print OUT6 $sequence_length;
				print OUT6 "\n";
				print OUT6 $position_in_membrane;
				print OUT6 "\n";
				print OUT6 "//\n";
				}
		}
		elsif($domains=~/(FYVE\:\d+\-\d+\(score\:(\d+)\.\d+\)\;)/){ 
			$fyve = $1;
			$fyvescore = $2;
			if($domains=~/(FYVE\_2\:\d+\-\d+\(score\:(\d+)\.\d+\)\;)/){
				$fyve2 = $1;
				$fyve2score = $2;
				if($fyvescore>$fyve2score){
					print OUT6 $fyve;
					print OUT6 "\n";
					print OUT6 $sequence;
					print OUT6 "\n";
					print OUT6 $sequence_length;
					print OUT6 "\n";
					print OUT6 $position_in_membrane;
					print OUT6 "\n";
					print OUT6 "//\n";
					}
				elsif($fyvescore<$fyve2score){
					print OUT6 $fyve2;
					print OUT6 "\n";
					print OUT6 $sequence;
					print OUT6 "\n";
					print OUT6 $sequence_length;
					print OUT6 "\n";
					print OUT6 $position_in_membrane;
					print OUT6 "\n";
					print OUT6 "//\n";
					}
				}
			else{
				print OUT6 $domains;
				print OUT6 "\n";
				print OUT6 $sequence;
				print OUT6 "\n";
				print OUT6 $sequence_length;
				print OUT6 "\n";
				print OUT6 $position_in_membrane;
				print OUT6 "\n";
				print OUT6 "//\n";
				}
		} 
 		elsif($domains=~/(PH\:\d+\-\d+\(score\:(\d+)\.\d+\)\;)/){ 
			$ph = $1;
			$phscore = $2;
			if($domains=~/(PH\_2\:\d+\-\d+\(score\:(\d+)\.\d+\)\;)/){
				$ph2 = $1;
				$ph2score = $2;
				if($phscore>$ph2score){
					print OUT6 $ph;
					print OUT6 "\n";
					print OUT6 $sequence;
					print OUT6 "\n";
					print OUT6 $sequence_length;
					print OUT6 "\n";
					print OUT6 $position_in_membrane;
					print OUT6 "\n";
					print OUT6 "//\n";
					}
				elsif($phscore<$ph2score){
					print OUT6 $ph2;
					print OUT6 "\n";
					print OUT6 $sequence;
					print OUT6 "\n";
					print OUT6 $sequence_length;
					print OUT6 "\n";
					print OUT6 $position_in_membrane;
					print OUT6 "\n";
					print OUT6 "//\n";
					}
				}
			elsif($domains=~/(PH\_3\:\d+\-\d+\(score\:(\d+)\.\d+\)\;)/){
				$ph3 = $1;
				$ph3score = $2;
				if($phscore>$ph3score){
					print OUT6 $ph;
					print OUT6 "\n";
					print OUT6 $sequence;
					print OUT6 "\n";
					print OUT6 $sequence_length;
					print OUT6 "\n";
					print OUT6 $position_in_membrane;
					print OUT6 "\n";
					print OUT6 "//\n";
					}
				elsif($phscore<$ph3score){
					print OUT6 $ph3;
					print OUT6 "\n";
					print OUT6 $sequence;
					print OUT6 "\n";
					print OUT6 $sequence_length;
					print OUT6 "\n";
					print OUT6 $position_in_membrane;
					print OUT6 "\n";
					print OUT6 "//\n";
					}
				}
			elsif($domains=~/(PH\_4\:\d+\-\d+\(score\:(\d+)\.\d+\)\;)/){
				$ph4 = $1;
				$ph4score = $2;
				if($phscore>$ph4score){
					print OUT6 $ph;
					print OUT6 "\n";
					print OUT6 $sequence;
					print OUT6 "\n";
					print OUT6 $sequence_length;
					print OUT6 "\n";
					print OUT6 $position_in_membrane;
					print OUT6 "\n";
					print OUT6 "//\n";
					}
				elsif($phscore<$ph4score){
					print OUT6 $ph4;
					print OUT6 "\n";
					print OUT6 $sequence;
					print OUT6 "\n";
					print OUT6 $sequence_length;
					print OUT6 "\n";
					print OUT6 $position_in_membrane;
					print OUT6 "\n";
					print OUT6 "//\n";
					}
				}
			elsif($domains=~/(PH\_5\:\d+\-\d+\(score\:(\d+)\.\d+\)\;)/){
				$ph5 = $1;
				$ph5score = $2;
				if($phscore>$ph5score){
					print OUT6 $ph;
					print OUT6 "\n";
					print OUT6 $sequence;
					print OUT6 "\n";
					print OUT6 $sequence_length;
					print OUT6 "\n";
					print OUT6 $position_in_membrane;
					print OUT6 "\n";
					print OUT6 "//\n";
					}
				elsif($phscore<$ph5score){
					print OUT6 $ph5;
					print OUT6 "\n";
					print OUT6 $sequence;
					print OUT6 "\n";
					print OUT6 $sequence_length;
					print OUT6 "\n";
					print OUT6 $position_in_membrane;
					print OUT6 "\n";
					print OUT6 "//\n";
					}
				}
			elsif($domains=~/(PH\_6\:\d+\-\d+\(score\:(\d+)\.\d+\)\;)/){
				$ph6 = $1;
				$ph6score = $2;
				if($phscore>$ph6score){
					print OUT6 $ph;
					print OUT6 "\n";
					print OUT6 $sequence;
					print OUT6 "\n";
					print OUT6 $sequence_length;
					print OUT6 "\n";
					print OUT6 $position_in_membrane;
					print OUT6 "\n";
					print OUT6 "//\n";
					}
				elsif($phscore<$ph6score){
					print OUT6 $ph6;
					print OUT6 "\n";
					print OUT6 $sequence;
					print OUT6 "\n";
					print OUT6 $sequence_length;
					print OUT6 "\n";
					print OUT6 $position_in_membrane;
					print OUT6 "\n";
					print OUT6 "//\n";
					}
				}
			elsif($domains=~/(PH\_8\:\d+\-\d+\(score\:(\d+)\.\d+\)\;)/){
				$ph8 = $1;
				$ph8score = $2;
				if($phscore>$ph8score){
					print OUT6 $ph;
					print OUT6 "\n";
					print OUT6 $sequence;
					print OUT6 "\n";
					print OUT6 $sequence_length;
					print OUT6 "\n";
					print OUT6 $position_in_membrane;
					print OUT6 "\n";
					print OUT6 "//\n";
					}
				elsif($phscore<$ph8score){
					print OUT6 $ph8;
					print OUT6 "\n";
					print OUT6 $sequence;
					print OUT6 "\n";
					print OUT6 $sequence_length;
					print OUT6 "\n";
					print OUT6 $position_in_membrane;
					print OUT6 "\n";
					print OUT6 "//\n";
					}
				}
			elsif($domains=~/(PH\_9\:\d+\-\d+\(score\:(\d+)\.\d+\)\;)/){
				$ph9 = $1;
				$ph9score = $2;
				if($phscore>$ph9score){
					print OUT6 $ph;
					print OUT6 "\n";
					print OUT6 $sequence;
					print OUT6 "\n";
					print OUT6 $sequence_length;
					print OUT6 "\n";
					print OUT6 $position_in_membrane;
					print OUT6 "\n";
					print OUT6 "//\n";
					}
				elsif($phscore<$ph9score){
					print OUT6 $ph9;
					print OUT6 "\n";
					print OUT6 $sequence;
					print OUT6 "\n";
					print OUT6 $sequence_length;
					print OUT6 "\n";
					print OUT6 $position_in_membrane;
					print OUT6 "\n";
					print OUT6 "//\n";
					}
				}
			elsif($domains=~/(PH\_10\:\d+\-\d+\(score\:(\d+)\.\d+\)\;)/){
				$ph10 = $1;
				$ph10score = $2;
				if($phscore>$ph10score){
					print OUT6 $ph;
					print OUT6 "\n";
					print OUT6 $sequence;
					print OUT6 "\n";
					print OUT6 $sequence_length;
					print OUT6 "\n";
					print OUT6 $position_in_membrane;
					print OUT6 "\n";
					print OUT6 "//\n";
					}
				elsif($phscore<$ph10score){
					print OUT6 $ph10;
					print OUT6 "\n";
					print OUT6 $sequence;
					print OUT6 "\n";
					print OUT6 $sequence_length;
					print OUT6 "\n";
					print OUT6 $position_in_membrane;
					print OUT6 "\n";
					print OUT6 "//\n";
					}
				}
			elsif($domains=~/(PH\_11\:\d+\-\d+\(score\:(\d+)\.\d+\)\;)/){
				$ph11 = $1;
				$ph11score = $2;
				if($phscore>$ph11score){
					print OUT6 $ph;
					print OUT6 "\n";
					print OUT6 $sequence;
					print OUT6 "\n";
					print OUT6 $sequence_length;
					print OUT6 "\n";
					print OUT6 $position_in_membrane;
					print OUT6 "\n";
					print OUT6 "//\n";
					}
				elsif($phscore<$ph11score){
					print OUT6 $ph11;
					print OUT6 "\n";
					print OUT6 $sequence;
					print OUT6 "\n";
					print OUT6 $sequence_length;
					print OUT6 "\n";
					print OUT6 $position_in_membrane;
					print OUT6 "\n";
					print OUT6 "//\n";
					}
				}
			elsif($domains=~/(PH\_12\:\d+\-\d+\(score\:(\d+)\.\d+\)\;)/){
				$ph12 = $1;
				$ph12score = $2;
				if($phscore>$ph12score){
					print OUT6 $ph;
					print OUT6 "\n";
					print OUT6 $sequence;
					print OUT6 "\n";
					print OUT6 $sequence_length;
					print OUT6 "\n";
					print OUT6 $position_in_membrane;
					print OUT6 "\n";
					print OUT6 "//\n";
					}
				elsif($phscore<$ph12score){
					print OUT6 $ph12;
					print OUT6 "\n";
					print OUT6 $sequence;
					print OUT6 "\n";
					print OUT6 $sequence_length;
					print OUT6 "\n";
					print OUT6 $position_in_membrane;
					print OUT6 "\n";
					print OUT6 "//\n";
					}
				}	
			elsif($domains=~/(PH\_13\:\d+\-\d+\(score\:(\d+)\.\d+\)\;)/){
				$ph13 = $1;
				$ph13score = $2;
				if($phscore>$ph13score){
					print OUT6 $ph;
					print OUT6 "\n";
					print OUT6 $sequence;
					print OUT6 "\n";
					print OUT6 $sequence_length;
					print OUT6 "\n";
					print OUT6 $position_in_membrane;
					print OUT6 "\n";
					print OUT6 "//\n";
					}
				elsif($phscore<$ph13score){
					print OUT6 $ph13;
					print OUT6 "\n";
					print OUT6 $sequence;
					print OUT6 "\n";
					print OUT6 $sequence_length;
					print OUT6 "\n";
					print OUT6 $position_in_membrane;
					print OUT6 "\n";
					print OUT6 "//\n";
					}
				}
			elsif($domains=~/(PH\_BEACH\:\d+\-\d+\(score\:(\d+)\.\d+\)\;)/){
				$phbeach = $1;
				$phbeachscore = $2;
				if($phscore>$phbeachscore){
					print OUT6 $ph;
					print OUT6 "\n";
					print OUT6 $sequence;
					print OUT6 "\n";
					print OUT6 $sequence_length;
					print OUT6 "\n";
					print OUT6 $position_in_membrane;
					print OUT6 "\n";
					print OUT6 "//\n";
					}
				elsif($phscore<$phbeachscore){
					print OUT6 $phbeach;
					print OUT6 "\n";
					print OUT6 $sequence;
					print OUT6 "\n";
					print OUT6 $sequence_length;
					print OUT6 "\n";
					print OUT6 $position_in_membrane;
					print OUT6 "\n";
					print OUT6 "//\n";
					}
				}				
			else{
				print OUT6 $domains;
				print OUT6 "\n";
				print OUT6 $sequence;
				print OUT6 "\n";
				print OUT6 $sequence_length;
				print OUT6 "\n";
				print OUT6 $position_in_membrane;
				print OUT6 "\n";
				print OUT6 "//\n";
				}
		}
		elsif($domains=~/(PH\_2\:\d+\-\d+\(score\:(\d+)\.\d+\)\;)/){ 
			$ph2 = $1;
			$ph2score = $2;
			if($domains=~/(PH\_3\:\d+\-\d+\(score\:(\d+)\.\d+\)\;)/){
				$ph3 = $1;
				$ph3score = $2;
				if($ph2score>$ph3score){
					print OUT6 $ph2;
					print OUT6 "\n";
					print OUT6 $sequence;
					print OUT6 "\n";
					print OUT6 $sequence_length;
					print OUT6 "\n";
					print OUT6 $position_in_membrane;
					print OUT6 "\n";
					print OUT6 "//\n";
					}
				elsif($ph2score<$ph3score){
					print OUT6 $ph3;
					print OUT6 "\n";
					print OUT6 $sequence;
					print OUT6 "\n";
					print OUT6 $sequence_length;
					print OUT6 "\n";
					print OUT6 $position_in_membrane;
					print OUT6 "\n";
					print OUT6 "//\n";
					}
				}
			elsif($domains=~/(PH\_4\:\d+\-\d+\(score\:(\d+)\.\d+\)\;)/){
				$ph4 = $1;
				$ph4score = $2;
				if($ph2score>$ph4score){
					print OUT6 $ph2;
					print OUT6 "\n";
					print OUT6 $sequence;
					print OUT6 "\n";
					print OUT6 $sequence_length;
					print OUT6 "\n";
					print OUT6 $position_in_membrane;
					print OUT6 "\n";
					print OUT6 "//\n";
					}
				elsif($ph2score<$ph4score){
					print OUT6 $ph4;
					print OUT6 "\n";
					print OUT6 $sequence;
					print OUT6 "\n";
					print OUT6 $sequence_length;
					print OUT6 "\n";
					print OUT6 $position_in_membrane;
					print OUT6 "\n";
					print OUT6 "//\n";
					}
				}
			elsif($domains=~/(PH\_5\:\d+\-\d+\(score\:(\d+)\.\d+\)\;)/){
				$ph5 = $1;
				$ph5score = $2;
				if($ph2score>$ph5score){
					print OUT6 $ph2;
					print OUT6 "\n";
					print OUT6 $sequence;
					print OUT6 "\n";
					print OUT6 $sequence_length;
					print OUT6 "\n";
					print OUT6 $position_in_membrane;
					print OUT6 "\n";
					print OUT6 "//\n";
					}
				elsif($ph2score<$ph5score){
					print OUT6 $ph5;
					print OUT6 "\n";
					print OUT6 $sequence;
					print OUT6 "\n";
					print OUT6 $sequence_length;
					print OUT6 "\n";
					print OUT6 $position_in_membrane;
					print OUT6 "\n";
					print OUT6 "//\n";
					}
				}
			elsif($domains=~/(PH\_6\:\d+\-\d+\(score\:(\d+)\.\d+\)\;)/){
				$ph6 = $1;
				$ph6score = $2;
				if($ph2score>$ph6score){
					print OUT6 $ph2;
					print OUT6 "\n";
					print OUT6 $sequence;
					print OUT6 "\n";
					print OUT6 $sequence_length;
					print OUT6 "\n";
					print OUT6 $position_in_membrane;
					print OUT6 "\n";
					print OUT6 "//\n";
					}
				elsif($ph2score<$ph6score){
					print OUT6 $ph6;
					print OUT6 "\n";
					print OUT6 $sequence;
					print OUT6 "\n";
					print OUT6 $sequence_length;
					print OUT6 "\n";
					print OUT6 $position_in_membrane;
					print OUT6 "\n";
					print OUT6 "//\n";
					}
				}
			elsif($domains=~/(PH\_8\:\d+\-\d+\(score\:(\d+)\.\d+\)\;)/){
				$ph8 = $1;
				$ph8score = $2;
				if($ph2score>$ph8score){
					print OUT6 $ph2;
					print OUT6 "\n";
					print OUT6 $sequence;
					print OUT6 "\n";
					print OUT6 $sequence_length;
					print OUT6 "\n";
					print OUT6 $position_in_membrane;
					print OUT6 "\n";
					print OUT6 "//\n";
					}
				elsif($ph2score<$ph8score){
					print OUT6 $ph8;
					print OUT6 "\n";
					print OUT6 $sequence;
					print OUT6 "\n";
					print OUT6 $sequence_length;
					print OUT6 "\n";
					print OUT6 $position_in_membrane;
					print OUT6 "\n";
					print OUT6 "//\n";
					}
				}
			elsif($domains=~/(PH\_9\:\d+\-\d+\(score\:(\d+)\.\d+\)\;)/){
				$ph9 = $1;
				$ph9score = $2;
				if($ph2score>$ph9score){
					print OUT6 $ph2;
					print OUT6 "\n";
					print OUT6 $sequence;
					print OUT6 "\n";
					print OUT6 $sequence_length;
					print OUT6 "\n";
					print OUT6 $position_in_membrane;
					print OUT6 "\n";
					print OUT6 "//\n";
					}
				elsif($ph2score<$ph9score){
					print OUT6 $ph9;
					print OUT6 "\n";
					print OUT6 $sequence;
					print OUT6 "\n";
					print OUT6 $sequence_length;
					print OUT6 "\n";
					print OUT6 $position_in_membrane;
					print OUT6 "\n";
					print OUT6 "//\n";
					}
				}
			elsif($domains=~/(PH\_10\:\d+\-\d+\(score\:(\d+)\.\d+\)\;)/){
				$ph10 = $1;
				$ph10score = $2;
				if($ph2score>$ph10score){
					print OUT6 $ph2;
					print OUT6 "\n";
					print OUT6 $sequence;
					print OUT6 "\n";
					print OUT6 $sequence_length;
					print OUT6 "\n";
					print OUT6 $position_in_membrane;
					print OUT6 "\n";
					print OUT6 "//\n";
					}
				elsif($ph2score<$ph10score){
					print OUT6 $ph10;
					print OUT6 "\n";
					print OUT6 $sequence;
					print OUT6 "\n";
					print OUT6 $sequence_length;
					print OUT6 "\n";
					print OUT6 $position_in_membrane;
					print OUT6 "\n";
					print OUT6 "//\n";
					}
				}
			elsif($domains=~/(PH\_11\:\d+\-\d+\(score\:(\d+)\.\d+\)\;)/){
				$ph11 = $1;
				$ph11score = $2;
				if($ph2score>$ph11score){
					print OUT6 $ph2;
					print OUT6 "\n";
					print OUT6 $sequence;
					print OUT6 "\n";
					print OUT6 $sequence_length;
					print OUT6 "\n";
					print OUT6 $position_in_membrane;
					print OUT6 "\n";
					print OUT6 "//\n";
					}
				elsif($ph2score<$ph11score){
					print OUT6 $ph11;
					print OUT6 "\n";
					print OUT6 $sequence;
					print OUT6 "\n";
					print OUT6 $sequence_length;
					print OUT6 "\n";
					print OUT6 $position_in_membrane;
					print OUT6 "\n";
					print OUT6 "//\n";
					}
				}
			elsif($domains=~/(PH\_12\:\d+\-\d+\(score\:(\d+)\.\d+\)\;)/){
				$ph12 = $1;
				$ph12score = $2;
				if($ph2score>$ph12score){
					print OUT6 $ph2;
					print OUT6 "\n";
					print OUT6 $sequence;
					print OUT6 "\n";
					print OUT6 $sequence_length;
					print OUT6 "\n";
					print OUT6 $position_in_membrane;
					print OUT6 "\n";
					print OUT6 "//\n";
					}
				elsif($ph2score<$ph12score){
					print OUT6 $ph12;
					print OUT6 "\n";
					print OUT6 $sequence;
					print OUT6 "\n";
					print OUT6 $sequence_length;
					print OUT6 "\n";
					print OUT6 $position_in_membrane;
					print OUT6 "\n";
					print OUT6 "//\n";
					}
				}	
			elsif($domains=~/(PH\_13\:\d+\-\d+\(score\:(\d+)\.\d+\)\;)/){
				$ph13 = $1;
				$ph13score = $2;
				if($ph2score>$ph13score){
					print OUT6 $ph2;
					print OUT6 "\n";
					print OUT6 $sequence;
					print OUT6 "\n";
					print OUT6 $sequence_length;
					print OUT6 "\n";
					print OUT6 $position_in_membrane;
					print OUT6 "\n";
					print OUT6 "//\n";
					}
				elsif($ph2score<$ph13score){
					print OUT6 $ph13;
					print OUT6 "\n";
					print OUT6 $sequence;
					print OUT6 "\n";
					print OUT6 $sequence_length;
					print OUT6 "\n";
					print OUT6 $position_in_membrane;
					print OUT6 "\n";
					print OUT6 "//\n";
					}
				}
			elsif($domains=~/(PH\_BEACH\:\d+\-\d+\(score\:(\d+)\.\d+\)\;)/){
				$phbeach = $1;
				$phbeachscore = $2;
				if($ph2score>$phbeachscore){
					print OUT6 $ph2;
					print OUT6 "\n";
					print OUT6 $sequence;
					print OUT6 "\n";
					print OUT6 $sequence_length;
					print OUT6 "\n";
					print OUT6 $position_in_membrane;
					print OUT6 "\n";
					print OUT6 "//\n";
					}
				elsif($ph2score<$phbeachscore){
					print OUT6 $phbeach;
					print OUT6 "\n";
					print OUT6 $sequence;
					print OUT6 "\n";
					print OUT6 $sequence_length;
					print OUT6 "\n";
					print OUT6 $position_in_membrane;
					print OUT6 "\n";
					print OUT6 "//\n";
					}
				}		
			else{
				print OUT6 $domains;
				print OUT6 "\n";
				print OUT6 $sequence;
				print OUT6 "\n";
				print OUT6 $sequence_length;
				print OUT6 "\n";
				print OUT6 $position_in_membrane;
				print OUT6 "\n";
				print OUT6 "//\n";
				}
		}
		elsif($domains=~/(PH\_3\:\d+\-\d+\(score\:(\d+)\.\d+\)\;)/){ 
			$ph3 = $1;
			$ph3score = $2;
			if($domains=~/(PH\_4\:\d+\-\d+\(score\:(\d+)\.\d+\)\;)/){
				$ph4 = $1;
				$ph4score = $2;
				if($ph3score>$ph4score){
					print OUT6 $ph3;
					print OUT6 "\n";
					print OUT6 $sequence;
					print OUT6 "\n";
					print OUT6 $sequence_length;
					print OUT6 "\n";
					print OUT6 $position_in_membrane;
					print OUT6 "\n";
					print OUT6 "//\n";
					}
				elsif($ph3score<$ph4score){
					print OUT6 $ph4;
					print OUT6 "\n";
					print OUT6 $sequence;
					print OUT6 "\n";
					print OUT6 $sequence_length;
					print OUT6 "\n";
					print OUT6 $position_in_membrane;
					print OUT6 "\n";
					print OUT6 "//\n";
					}
				}
			elsif($domains=~/(PH\_5\:\d+\-\d+\(score\:(\d+)\.\d+\)\;)/){
				$ph5 = $1;
				$ph5score = $2;
				if($ph3score>$ph5score){
					print OUT6 $ph3;
					print OUT6 "\n";
					print OUT6 $sequence;
					print OUT6 "\n";
					print OUT6 $sequence_length;
					print OUT6 "\n";
					print OUT6 $position_in_membrane;
					print OUT6 "\n";
					print OUT6 "//\n";
					}
				elsif($ph3score<$ph5score){
					print OUT6 $ph5;
					print OUT6 "\n";
					print OUT6 $sequence;
					print OUT6 "\n";
					print OUT6 $sequence_length;
					print OUT6 "\n";
					print OUT6 $position_in_membrane;
					print OUT6 "\n";
					print OUT6 "//\n";
					}
				}
			elsif($domains=~/(PH\_6\:\d+\-\d+\(score\:(\d+)\.\d+\)\;)/){
				$ph6 = $1;
				$ph6score = $2;
				if($ph3score>$ph6score){
					print OUT6 $ph3;
					print OUT6 "\n";
					print OUT6 $sequence;
					print OUT6 "\n";
					print OUT6 $sequence_length;
					print OUT6 "\n";
					print OUT6 $position_in_membrane;
					print OUT6 "\n";
					print OUT6 "//\n";
					}
				elsif($ph3score<$ph6score){
					print OUT6 $ph6;
					print OUT6 "\n";
					print OUT6 $sequence;
					print OUT6 "\n";
					print OUT6 $sequence_length;
					print OUT6 "\n";
					print OUT6 $position_in_membrane;
					print OUT6 "\n";
					print OUT6 "//\n";
					}
				}
			elsif($domains=~/(PH\_8\:\d+\-\d+\(score\:(\d+)\.\d+\)\;)/){
				$ph8 = $1;
				$ph8score = $2;
				if($ph3score>$ph8score){
					print OUT6 $ph3;
					print OUT6 "\n";
					print OUT6 $sequence;
					print OUT6 "\n";
					print OUT6 $sequence_length;
					print OUT6 "\n";
					print OUT6 $position_in_membrane;
					print OUT6 "\n";
					print OUT6 "//\n";
					}
				elsif($ph3score<$ph8score){
					print OUT6 $ph8;
					print OUT6 "\n";
					print OUT6 $sequence;
					print OUT6 "\n";
					print OUT6 $sequence_length;
					print OUT6 "\n";
					print OUT6 $position_in_membrane;
					print OUT6 "\n";
					print OUT6 "//\n";
					}
				}
			elsif($domains=~/(PH\_9\:\d+\-\d+\(score\:(\d+)\.\d+\)\;)/){
				$ph9 = $1;
				$ph9score = $2;
				if($ph3score>$ph9score){
					print OUT6 $ph3;
					print OUT6 "\n";
					print OUT6 $sequence;
					print OUT6 "\n";
					print OUT6 $sequence_length;
					print OUT6 "\n";
					print OUT6 $position_in_membrane;
					print OUT6 "\n";
					print OUT6 "//\n";
					}
				elsif($ph3score<$ph9score){
					print OUT6 $ph9;
					print OUT6 "\n";
					print OUT6 $sequence;
					print OUT6 "\n";
					print OUT6 $sequence_length;
					print OUT6 "\n";
					print OUT6 $position_in_membrane;
					print OUT6 "\n";
					print OUT6 "//\n";
					}
				}
			elsif($domains=~/(PH\_10\:\d+\-\d+\(score\:(\d+)\.\d+\)\;)/){
				$ph10 = $1;
				$ph10score = $2;
				if($ph3score>$ph10score){
					print OUT6 $ph3;
					print OUT6 "\n";
					print OUT6 $sequence;
					print OUT6 "\n";
					print OUT6 $sequence_length;
					print OUT6 "\n";
					print OUT6 $position_in_membrane;
					print OUT6 "\n";
					print OUT6 "//\n";
					}
				elsif($ph3score<$ph10score){
					print OUT6 $ph10;
					print OUT6 "\n";
					print OUT6 $sequence;
					print OUT6 "\n";
					print OUT6 $sequence_length;
					print OUT6 "\n";
					print OUT6 $position_in_membrane;
					print OUT6 "\n";
					print OUT6 "//\n";
					}
				}
			elsif($domains=~/(PH\_11\:\d+\-\d+\(score\:(\d+)\.\d+\)\;)/){
				$ph11 = $1;
				$ph11score = $2;
				if($ph3score>$ph11score){
					print OUT6 $ph3;
					print OUT6 "\n";
					print OUT6 $sequence;
					print OUT6 "\n";
					print OUT6 $sequence_length;
					print OUT6 "\n";
					print OUT6 $position_in_membrane;
					print OUT6 "\n";
					print OUT6 "//\n";
					}
				elsif($ph3score<$ph11score){
					print OUT6 $ph11;
					print OUT6 "\n";
					print OUT6 $sequence;
					print OUT6 "\n";
					print OUT6 $sequence_length;
					print OUT6 "\n";
					print OUT6 $position_in_membrane;
					print OUT6 "\n";
					print OUT6 "//\n";
					}
				}
			elsif($domains=~/(PH\_12\:\d+\-\d+\(score\:(\d+)\.\d+\)\;)/){
				$ph12 = $1;
				$ph12score = $2;
				if($ph3score>$ph12score){
					print OUT6 $ph3;
					print OUT6 "\n";
					print OUT6 $sequence;
					print OUT6 "\n";
					print OUT6 $sequence_length;
					print OUT6 "\n";
					print OUT6 $position_in_membrane;
					print OUT6 "\n";
					print OUT6 "//\n";
					}
				elsif($ph3score<$ph12score){
					print OUT6 $ph12;
					print OUT6 "\n";
					print OUT6 $sequence;
					print OUT6 "\n";
					print OUT6 $sequence_length;
					print OUT6 "\n";
					print OUT6 $position_in_membrane;
					print OUT6 "\n";
					print OUT6 "//\n";
					}
				}	
			elsif($domains=~/(PH\_13\:\d+\-\d+\(score\:(\d+)\.\d+\)\;)/){
				$ph13 = $1;
				$ph13score = $2;
				if($ph3score>$ph13score){
					print OUT6 $ph3;
					print OUT6 "\n";
					print OUT6 $sequence;
					print OUT6 "\n";
					print OUT6 $sequence_length;
					print OUT6 "\n";
					print OUT6 $position_in_membrane;
					print OUT6 "\n";
					print OUT6 "//\n";
					}
				elsif($ph3score<$ph13score){
					print OUT6 $ph13;
					print OUT6 "\n";
					print OUT6 $sequence;
					print OUT6 "\n";
					print OUT6 $sequence_length;
					print OUT6 "\n";
					print OUT6 $position_in_membrane;
					print OUT6 "\n";
					print OUT6 "//\n";
					}
				}
			elsif($domains=~/(PH\_BEACH\:\d+\-\d+\(score\:(\d+)\.\d+\)\;)/){
				$phbeach = $1;
				$phbeachscore = $2;
				if($ph3score>$phbeachscore){
					print OUT6 $ph3;
					print OUT6 "\n";
					print OUT6 $sequence;
					print OUT6 "\n";
					print OUT6 $sequence_length;
					print OUT6 "\n";
					print OUT6 $position_in_membrane;
					print OUT6 "\n";
					print OUT6 "//\n";
					}
				elsif($ph3score<$phbeachscore){
					print OUT6 $phbeach;
					print OUT6 "\n";
					print OUT6 $sequence;
					print OUT6 "\n";
					print OUT6 $sequence_length;
					print OUT6 "\n";
					print OUT6 $position_in_membrane;
					print OUT6 "\n";
					print OUT6 "//\n";
					}
				}				
			else{
				print OUT6 $domains;
				print OUT6 "\n";
				print OUT6 $sequence;
				print OUT6 "\n";
				print OUT6 $sequence_length;
				print OUT6 "\n";
				print OUT6 $position_in_membrane;
				print OUT6 "\n";
				print OUT6 "//\n";
				}
		}
		elsif($domains=~/(PH\_4\:\d+\-\d+\(score\:(\d+)\.\d+\)\;)/){ 
			$ph4 = $1;
			$ph4score = $2;
			if($domains=~/(PH\_5\:\d+\-\d+\(score\:(\d+)\.\d+\)\;)/){
				$ph5 = $1;
				$ph5score = $2;
				if($ph4score>$ph5score){
					print OUT6 $ph4;
					print OUT6 "\n";
					print OUT6 $sequence;
					print OUT6 "\n";
					print OUT6 $sequence_length;
					print OUT6 "\n";
					print OUT6 $position_in_membrane;
					print OUT6 "\n";
					print OUT6 "//\n";
					}
				elsif($ph4score<$ph5score){
					print OUT6 $ph5;
					print OUT6 "\n";
					print OUT6 $sequence;
					print OUT6 "\n";
					print OUT6 $sequence_length;
					print OUT6 "\n";
					print OUT6 $position_in_membrane;
					print OUT6 "\n";
					print OUT6 "//\n";
					}
				}
			elsif($domains=~/(PH\_6\:\d+\-\d+\(score\:(\d+)\.\d+\)\;)/){
				$ph6 = $1;
				$ph6score = $2;
				if($ph4score>$ph6score){
					print OUT6 $ph4;
					print OUT6 "\n";
					print OUT6 $sequence;
					print OUT6 "\n";
					print OUT6 $sequence_length;
					print OUT6 "\n";
					print OUT6 $position_in_membrane;
					print OUT6 "\n";
					print OUT6 "//\n";
					}
				elsif($ph4score<$ph6score){
					print OUT6 $ph6;
					print OUT6 "\n";
					print OUT6 $sequence;
					print OUT6 "\n";
					print OUT6 $sequence_length;
					print OUT6 "\n";
					print OUT6 $position_in_membrane;
					print OUT6 "\n";
					print OUT6 "//\n";
					}
				}
			elsif($domains=~/(PH\_8\:\d+\-\d+\(score\:(\d+)\.\d+\)\;)/){
				$ph8 = $1;
				$ph8score = $2;
				if($ph4score>$ph8score){
					print OUT6 $ph4;
					print OUT6 "\n";
					print OUT6 $sequence;
					print OUT6 "\n";
					print OUT6 $sequence_length;
					print OUT6 "\n";
					print OUT6 $position_in_membrane;
					print OUT6 "\n";
					print OUT6 "//\n";
					}
				elsif($ph4score<$ph8score){
					print OUT6 $ph8;
					print OUT6 "\n";
					print OUT6 $sequence;
					print OUT6 "\n";
					print OUT6 $sequence_length;
					print OUT6 "\n";
					print OUT6 $position_in_membrane;
					print OUT6 "\n";
					print OUT6 "//\n";
					}
				}
			elsif($domains=~/(PH\_9\:\d+\-\d+\(score\:(\d+)\.\d+\)\;)/){
				$ph9 = $1;
				$ph9score = $2;
				if($ph4score>$ph9score){
					print OUT6 $ph4;
					print OUT6 "\n";
					print OUT6 $sequence;
					print OUT6 "\n";
					print OUT6 $sequence_length;
					print OUT6 "\n";
					print OUT6 $position_in_membrane;
					print OUT6 "\n";
					print OUT6 "//\n";
					}
				elsif($ph4score<$ph9score){
					print OUT6 $ph9;
					print OUT6 "\n";
					print OUT6 $sequence;
					print OUT6 "\n";
					print OUT6 $sequence_length;
					print OUT6 "\n";
					print OUT6 $position_in_membrane;
					print OUT6 "\n";
					print OUT6 "//\n";
					}
				}
			elsif($domains=~/(PH\_10\:\d+\-\d+\(score\:(\d+)\.\d+\)\;)/){
				$ph10 = $1;
				$ph10score = $2;
				if($ph4score>$ph10score){
					print OUT6 $ph4;
					print OUT6 "\n";
					print OUT6 $sequence;
					print OUT6 "\n";
					print OUT6 $sequence_length;
					print OUT6 "\n";
					print OUT6 $position_in_membrane;
					print OUT6 "\n";
					print OUT6 "//\n";
					}
				elsif($ph4score<$ph10score){
					print OUT6 $ph10;
					print OUT6 "\n";
					print OUT6 $sequence;
					print OUT6 "\n";
					print OUT6 $sequence_length;
					print OUT6 "\n";
					print OUT6 $position_in_membrane;
					print OUT6 "\n";
					print OUT6 "//\n";
					}
				}
			elsif($domains=~/(PH\_11\:\d+\-\d+\(score\:(\d+)\.\d+\)\;)/){
				$ph11 = $1;
				$ph11score = $2;
				if($ph4score>$ph11score){
					print OUT6 $ph4;
					print OUT6 "\n";
					print OUT6 $sequence;
					print OUT6 "\n";
					print OUT6 $sequence_length;
					print OUT6 "\n";
					print OUT6 $position_in_membrane;
					print OUT6 "\n";
					print OUT6 "//\n";
					}
				elsif($ph4score<$ph11score){
					print OUT6 $ph11;
					print OUT6 "\n";
					print OUT6 $sequence;
					print OUT6 "\n";
					print OUT6 $sequence_length;
					print OUT6 "\n";
					print OUT6 $position_in_membrane;
					print OUT6 "\n";
					print OUT6 "//\n";
					}
				}
			elsif($domains=~/(PH\_12\:\d+\-\d+\(score\:(\d+)\.\d+\)\;)/){
				$ph12 = $1;
				$ph12score = $2;
				if($ph4score>$ph12score){
					print OUT6 $ph4;
					print OUT6 "\n";
					print OUT6 $sequence;
					print OUT6 "\n";
					print OUT6 $sequence_length;
					print OUT6 "\n";
					print OUT6 $position_in_membrane;
					print OUT6 "\n";
					print OUT6 "//\n";
					}
				elsif($ph4score<$ph12score){
					print OUT6 $ph12;
					print OUT6 "\n";
					print OUT6 $sequence;
					print OUT6 "\n";
					print OUT6 $sequence_length;
					print OUT6 "\n";
					print OUT6 $position_in_membrane;
					print OUT6 "\n";
					print OUT6 "//\n";
					}
				}	
			elsif($domains=~/(PH\_13\:\d+\-\d+\(score\:(\d+)\.\d+\)\;)/){
				$ph13 = $1;
				$ph13score = $2;
				if($ph4score>$ph13score){
					print OUT6 $ph4;
					print OUT6 "\n";
					print OUT6 $sequence;
					print OUT6 "\n";
					print OUT6 $sequence_length;
					print OUT6 "\n";
					print OUT6 $position_in_membrane;
					print OUT6 "\n";
					print OUT6 "//\n";
					}
				elsif($ph4score<$ph13score){
					print OUT6 $ph13;
					print OUT6 "\n";
					print OUT6 $sequence;
					print OUT6 "\n";
					print OUT6 $sequence_length;
					print OUT6 "\n";
					print OUT6 $position_in_membrane;
					print OUT6 "\n";
					print OUT6 "//\n";
					}
				}
			elsif($domains=~/(PH\_BEACH\:\d+\-\d+\(score\:(\d+)\.\d+\)\;)/){
				$phbeach = $1;
				$phbeachscore = $2;
				if($ph4score>$phbeachscore){
					print OUT6 $ph4;
					print OUT6 "\n";
					print OUT6 $sequence;
					print OUT6 "\n";
					print OUT6 $sequence_length;
					print OUT6 "\n";
					print OUT6 $position_in_membrane;
					print OUT6 "\n";
					print OUT6 "//\n";
					}
				elsif($ph4score<$phbeachscore){
					print OUT6 $phbeach;
					print OUT6 "\n";
					print OUT6 $sequence;
					print OUT6 "\n";
					print OUT6 $sequence_length;
					print OUT6 "\n";
					print OUT6 $position_in_membrane;
					print OUT6 "\n";
					print OUT6 "//\n";
					}
				}					
			else{
				print OUT6 $domains;
				print OUT6 "\n";
				print OUT6 $sequence;
				print OUT6 "\n";
				print OUT6 $sequence_length;
				print OUT6 "\n";
				print OUT6 $position_in_membrane;
				print OUT6 "\n";
				print OUT6 "//\n";
				}
		}
		elsif($domains=~/(PH\_5\:\d+\-\d+\(score\:(\d+)\.\d+\)\;)/){ 
			$ph5 = $1;
			$ph5score = $2;
			if($domains=~/(PH\_6\:\d+\-\d+\(score\:(\d+)\.\d+\)\;)/){
				$ph6 = $1;
				$ph6score = $2;
				if($ph5score>$ph6score){
					print OUT6 $ph5;
					print OUT6 "\n";
					print OUT6 $sequence;
					print OUT6 "\n";
					print OUT6 $sequence_length;
					print OUT6 "\n";
					print OUT6 $position_in_membrane;
					print OUT6 "\n";
					print OUT6 "//\n";
					}
				elsif($ph5score<$ph6score){
					print OUT6 $ph6;
					print OUT6 "\n";
					print OUT6 $sequence;
					print OUT6 "\n";
					print OUT6 $sequence_length;
					print OUT6 "\n";
					print OUT6 $position_in_membrane;
					print OUT6 "\n";
					print OUT6 "//\n";
					}
				}
			elsif($domains=~/(PH\_8\:\d+\-\d+\(score\:(\d+)\.\d+\)\;)/){
				$ph8 = $1;
				$ph8score = $2;
				if($ph5score>$ph8score){
					print OUT6 $ph5;
					print OUT6 "\n";
					print OUT6 $sequence;
					print OUT6 "\n";
					print OUT6 $sequence_length;
					print OUT6 "\n";
					print OUT6 $position_in_membrane;
					print OUT6 "\n";
					print OUT6 "//\n";
					}
				elsif($ph5score<$ph8score){
					print OUT6 $ph8;
					print OUT6 "\n";
					print OUT6 $sequence;
					print OUT6 "\n";
					print OUT6 $sequence_length;
					print OUT6 "\n";
					print OUT6 $position_in_membrane;
					print OUT6 "\n";
					print OUT6 "//\n";
					}
				}
			elsif($domains=~/(PH\_9\:\d+\-\d+\(score\:(\d+)\.\d+\)\;)/){
				$ph9 = $1;
				$ph9score = $2;
				if($ph5score>$ph9score){
					print OUT6 $ph5;
					print OUT6 "\n";
					print OUT6 $sequence;
					print OUT6 "\n";
					print OUT6 $sequence_length;
					print OUT6 "\n";
					print OUT6 $position_in_membrane;
					print OUT6 "\n";
					print OUT6 "//\n";
					}
				elsif($ph5score<$ph9score){
					print OUT6 $ph9;
					print OUT6 "\n";
					print OUT6 $sequence;
					print OUT6 "\n";
					print OUT6 $sequence_length;
					print OUT6 "\n";
					print OUT6 $position_in_membrane;
					print OUT6 "\n";
					print OUT6 "//\n";
					}
				}
			elsif($domains=~/(PH\_10\:\d+\-\d+\(score\:(\d+)\.\d+\)\;)/){
				$ph10 = $1;
				$ph10score = $2;
				if($ph5score>$ph10score){
					print OUT6 $ph5;
					print OUT6 "\n";
					print OUT6 $sequence;
					print OUT6 "\n";
					print OUT6 $sequence_length;
					print OUT6 "\n";
					print OUT6 $position_in_membrane;
					print OUT6 "\n";
					print OUT6 "//\n";
					}
				elsif($ph5score<$ph10score){
					print OUT6 $ph10;
					print OUT6 "\n";
					print OUT6 $sequence;
					print OUT6 "\n";
					print OUT6 $sequence_length;
					print OUT6 "\n";
					print OUT6 $position_in_membrane;
					print OUT6 "\n";
					print OUT6 "//\n";
					}
				}
			elsif($domains=~/(PH\_11\:\d+\-\d+\(score\:(\d+)\.\d+\)\;)/){
				$ph11 = $1;
				$ph11score = $2;
				if($ph5score>$ph11score){
					print OUT6 $ph5;
					print OUT6 "\n";
					print OUT6 $sequence;
					print OUT6 "\n";
					print OUT6 $sequence_length;
					print OUT6 "\n";
					print OUT6 $position_in_membrane;
					print OUT6 "\n";
					print OUT6 "//\n";
					}
				elsif($ph5score<$ph11score){
					print OUT6 $ph11;
					print OUT6 "\n";
					print OUT6 $sequence;
					print OUT6 "\n";
					print OUT6 $sequence_length;
					print OUT6 "\n";
					print OUT6 $position_in_membrane;
					print OUT6 "\n";
					print OUT6 "//\n";
					}
				}
			elsif($domains=~/(PH\_12\:\d+\-\d+\(score\:(\d+)\.\d+\)\;)/){
				$ph12 = $1;
				$ph12score = $2;
				if($ph5score>$ph12score){
					print OUT6 $ph5;
					print OUT6 "\n";
					print OUT6 $sequence;
					print OUT6 "\n";
					print OUT6 $sequence_length;
					print OUT6 "\n";
					print OUT6 $position_in_membrane;
					print OUT6 "\n";
					print OUT6 "//\n";
					}
				elsif($ph5score<$ph12score){
					print OUT6 $ph12;
					print OUT6 "\n";
					print OUT6 $sequence;
					print OUT6 "\n";
					print OUT6 $sequence_length;
					print OUT6 "\n";
					print OUT6 $position_in_membrane;
					print OUT6 "\n";
					print OUT6 "//\n";
					}
				}	
			elsif($domains=~/(PH\_13\:\d+\-\d+\(score\:(\d+)\.\d+\)\;)/){
				$ph13 = $1;
				$ph13score = $2;
				if($ph5score>$ph13score){
					print OUT6 $ph5;
					print OUT6 "\n";
					print OUT6 $sequence;
					print OUT6 "\n";
					print OUT6 $sequence_length;
					print OUT6 "\n";
					print OUT6 $position_in_membrane;
					print OUT6 "\n";
					print OUT6 "//\n";
					}
				elsif($ph5score<$ph13score){
					print OUT6 $ph13;
					print OUT6 "\n";
					print OUT6 $sequence;
					print OUT6 "\n";
					print OUT6 $sequence_length;
					print OUT6 "\n";
					print OUT6 $position_in_membrane;
					print OUT6 "\n";
					print OUT6 "//\n";
					}
				}
			elsif($domains=~/(PH\_BEACH\:\d+\-\d+\(score\:(\d+)\.\d+\)\;)/){
				$phbeach = $1;
				$phbeachscore = $2;
				if($ph5score>$phbeachscore){
					print OUT6 $ph5;
					print OUT6 "\n";
					print OUT6 $sequence;
					print OUT6 "\n";
					print OUT6 $sequence_length;
					print OUT6 "\n";
					print OUT6 $position_in_membrane;
					print OUT6 "\n";
					print OUT6 "//\n";
					}
				elsif($ph5score<$phbeachscore){
					print OUT6 $phbeach;
					print OUT6 "\n";
					print OUT6 $sequence;
					print OUT6 "\n";
					print OUT6 $sequence_length;
					print OUT6 "\n";
					print OUT6 $position_in_membrane;
					print OUT6 "\n";
					print OUT6 "//\n";
					}
				}					
			else{
				print OUT6 $domains;
				print OUT6 "\n";
				print OUT6 $sequence;
				print OUT6 "\n";
				print OUT6 $sequence_length;
				print OUT6 "\n";
				print OUT6 $position_in_membrane;
				print OUT6 "\n";
				print OUT6 "//\n";
				}
		}
		elsif($domains=~/(PH\_6\:\d+\-\d+\(score\:(\d+)\.\d+\)\;)/){ 
			$ph6 = $1;
			$ph6score = $2;
			if($domains=~/(PH\_8\:\d+\-\d+\(score\:(\d+)\.\d+\)\;)/){
				$ph8 = $1;
				$ph8score = $2;
				if($ph6score>$ph8score){
					print OUT6 $ph6;
					print OUT6 "\n";
					print OUT6 $sequence;
					print OUT6 "\n";
					print OUT6 $sequence_length;
					print OUT6 "\n";
					print OUT6 $position_in_membrane;
					print OUT6 "\n";
					print OUT6 "//\n";
					}
				elsif($ph6score<$ph8score){
					print OUT6 $ph8;
					print OUT6 "\n";
					print OUT6 $sequence;
					print OUT6 "\n";
					print OUT6 $sequence_length;
					print OUT6 "\n";
					print OUT6 $position_in_membrane;
					print OUT6 "\n";
					print OUT6 "//\n";
					}
				}
			elsif($domains=~/(PH\_9\:\d+\-\d+\(score\:(\d+)\.\d+\)\;)/){
				$ph9 = $1;
				$ph9score = $2;
				if($ph6score>$ph9score){
					print OUT6 $ph6;
					print OUT6 "\n";
					print OUT6 $sequence;
					print OUT6 "\n";
					print OUT6 $sequence_length;
					print OUT6 "\n";
					print OUT6 $position_in_membrane;
					print OUT6 "\n";
					print OUT6 "//\n";
					}
				elsif($ph6score<$ph9score){
					print OUT6 $ph9;
					print OUT6 "\n";
					print OUT6 $sequence;
					print OUT6 "\n";
					print OUT6 $sequence_length;
					print OUT6 "\n";
					print OUT6 $position_in_membrane;
					print OUT6 "\n";
					print OUT6 "//\n";
					}
				}
			elsif($domains=~/(PH\_10\:\d+\-\d+\(score\:(\d+)\.\d+\)\;)/){
				$ph10 = $1;
				$ph10score = $2;
				if($ph6score>$ph10score){
					print OUT6 $ph6;
					print OUT6 "\n";
					print OUT6 $sequence;
					print OUT6 "\n";
					print OUT6 $sequence_length;
					print OUT6 "\n";
					print OUT6 $position_in_membrane;
					print OUT6 "\n";
					print OUT6 "//\n";
					}
				elsif($ph6score<$ph10score){
					print OUT6 $ph10;
					print OUT6 "\n";
					print OUT6 $sequence;
					print OUT6 "\n";
					print OUT6 $sequence_length;
					print OUT6 "\n";
					print OUT6 $position_in_membrane;
					print OUT6 "\n";
					print OUT6 "//\n";
					}
				}
			elsif($domains=~/(PH\_11\:\d+\-\d+\(score\:(\d+)\.\d+\)\;)/){
				$ph11 = $1;
				$ph11score = $2;
				if($ph6score>$ph11score){
					print OUT6 $ph6;
					print OUT6 "\n";
					print OUT6 $sequence;
					print OUT6 "\n";
					print OUT6 $sequence_length;
					print OUT6 "\n";
					print OUT6 $position_in_membrane;
					print OUT6 "\n";
					print OUT6 "//\n";
					}
				elsif($ph6score<$ph11score){
					print OUT6 $ph11;
					print OUT6 "\n";
					print OUT6 $sequence;
					print OUT6 "\n";
					print OUT6 $sequence_length;
					print OUT6 "\n";
					print OUT6 $position_in_membrane;
					print OUT6 "\n";
					print OUT6 "//\n";
					}
				}
			elsif($domains=~/(PH\_12\:\d+\-\d+\(score\:(\d+)\.\d+\)\;)/){
				$ph12 = $1;
				$ph12score = $2;
				if($ph6score>$ph12score){
					print OUT6 $ph6;
					print OUT6 "\n";
					print OUT6 $sequence;
					print OUT6 "\n";
					print OUT6 $sequence_length;
					print OUT6 "\n";
					print OUT6 $position_in_membrane;
					print OUT6 "\n";
					print OUT6 "//\n";
					}
				elsif($ph6score<$ph12score){
					print OUT6 $ph12;
					print OUT6 "\n";
					print OUT6 $sequence;
					print OUT6 "\n";
					print OUT6 $sequence_length;
					print OUT6 "\n";
					print OUT6 $position_in_membrane;
					print OUT6 "\n";
					print OUT6 "//\n";
					}
				}	
			elsif($domains=~/(PH\_13\:\d+\-\d+\(score\:(\d+)\.\d+\)\;)/){
				$ph13 = $1;
				$ph13score = $2;
				if($ph6score>$ph13score){
					print OUT6 $ph6;
					print OUT6 "\n";
					print OUT6 $sequence;
					print OUT6 "\n";
					print OUT6 $sequence_length;
					print OUT6 "\n";
					print OUT6 $position_in_membrane;
					print OUT6 "\n";
					print OUT6 "//\n";
					}
				elsif($ph6score<$ph13score){
					print OUT6 $ph13;
					print OUT6 "\n";
					print OUT6 $sequence;
					print OUT6 "\n";
					print OUT6 $sequence_length;
					print OUT6 "\n";
					print OUT6 $position_in_membrane;
					print OUT6 "\n";
					print OUT6 "//\n";
					}
				}
			elsif($domains=~/(PH\_BEACH\:\d+\-\d+\(score\:(\d+)\.\d+\)\;)/){
				$phbeach = $1;
				$phbeachscore = $2;
				if($ph6score>$phbeachscore){
					print OUT6 $ph6;
					print OUT6 "\n";
					print OUT6 $sequence;
					print OUT6 "\n";
					print OUT6 $sequence_length;
					print OUT6 "\n";
					print OUT6 $position_in_membrane;
					print OUT6 "\n";
					print OUT6 "//\n";
					}
				elsif($ph6score<$phbeachscore){
					print OUT6 $phbeach;
					print OUT6 "\n";
					print OUT6 $sequence;
					print OUT6 "\n";
					print OUT6 $sequence_length;
					print OUT6 "\n";
					print OUT6 $position_in_membrane;
					print OUT6 "\n";
					print OUT6 "//\n";
					}
				}					
			else{
				print OUT6 $domains;
				print OUT6 "\n";
				print OUT6 $sequence;
				print OUT6 "\n";
				print OUT6 $sequence_length;
				print OUT6 "\n";
				print OUT6 $position_in_membrane;
				print OUT6 "\n";
				print OUT6 "//\n";
				}
		}
		elsif($domains=~/(PH\_8\:\d+\-\d+\(score\:(\d+)\.\d+\)\;)/){ 
			$ph8 = $1;
			$ph8score = $2;
			if($domains=~/(PH\_9\:\d+\-\d+\(score\:(\d+)\.\d+\)\;)/){
				$ph9 = $1;
				$ph9score = $2;
				if($ph8score>$ph9score){
					print OUT6 $ph8;
					print OUT6 "\n";
					print OUT6 $sequence;
					print OUT6 "\n";
					print OUT6 $sequence_length;
					print OUT6 "\n";
					print OUT6 $position_in_membrane;
					print OUT6 "\n";
					print OUT6 "//\n";
					}
				elsif($ph8score<$ph9score){
					print OUT6 $ph9;
					print OUT6 "\n";
					print OUT6 $sequence;
					print OUT6 "\n";
					print OUT6 $sequence_length;
					print OUT6 "\n";
					print OUT6 $position_in_membrane;
					print OUT6 "\n";
					print OUT6 "//\n";
					}
				}
			elsif($domains=~/(PH\_10\:\d+\-\d+\(score\:(\d+)\.\d+\)\;)/){
				$ph10 = $1;
				$ph10score = $2;
				if($ph8score>$ph10score){
					print OUT6 $ph8;
					print OUT6 "\n";
					print OUT6 $sequence;
					print OUT6 "\n";
					print OUT6 $sequence_length;
					print OUT6 "\n";
					print OUT6 $position_in_membrane;
					print OUT6 "\n";
					print OUT6 "//\n";
					}
				elsif($ph8score<$ph10score){
					print OUT6 $ph10;
					print OUT6 "\n";
					print OUT6 $sequence;
					print OUT6 "\n";
					print OUT6 $sequence_length;
					print OUT6 "\n";
					print OUT6 $position_in_membrane;
					print OUT6 "\n";
					print OUT6 "//\n";
					}
				}
			elsif($domains=~/(PH\_11\:\d+\-\d+\(score\:(\d+)\.\d+\)\;)/){
				$ph11 = $1;
				$ph11score = $2;
				if($ph8score>$ph11score){
					print OUT6 $ph8;
					print OUT6 "\n";
					print OUT6 $sequence;
					print OUT6 "\n";
					print OUT6 $sequence_length;
					print OUT6 "\n";
					print OUT6 $position_in_membrane;
					print OUT6 "\n";
					print OUT6 "//\n";
					}
				elsif($ph8score<$ph11score){
					print OUT6 $ph11;
					print OUT6 "\n";
					print OUT6 $sequence;
					print OUT6 "\n";
					print OUT6 $sequence_length;
					print OUT6 "\n";
					print OUT6 $position_in_membrane;
					print OUT6 "\n";
					print OUT6 "//\n";
					}
				}
			elsif($domains=~/(PH\_12\:\d+\-\d+\(score\:(\d+)\.\d+\)\;)/){
				$ph12 = $1;
				$ph12score = $2;
				if($ph8score>$ph12score){
					print OUT6 $ph8;
					print OUT6 "\n";
					print OUT6 $sequence;
					print OUT6 "\n";
					print OUT6 $sequence_length;
					print OUT6 "\n";
					print OUT6 $position_in_membrane;
					print OUT6 "\n";
					print OUT6 "//\n";
					}
				elsif($ph8score<$ph12score){
					print OUT6 $ph12;
					print OUT6 "\n";
					print OUT6 $sequence;
					print OUT6 "\n";
					print OUT6 $sequence_length;
					print OUT6 "\n";
					print OUT6 $position_in_membrane;
					print OUT6 "\n";
					print OUT6 "//\n";
					}
				}	
			elsif($domains=~/(PH\_13\:\d+\-\d+\(score\:(\d+)\.\d+\)\;)/){
				$ph13 = $1;
				$ph13score = $2;
				if($ph8score>$ph13score){
					print OUT6 $ph8;
					print OUT6 "\n";
					print OUT6 $sequence;
					print OUT6 "\n";
					print OUT6 $sequence_length;
					print OUT6 "\n";
					print OUT6 $position_in_membrane;
					print OUT6 "\n";
					print OUT6 "//\n";
					}
				elsif($ph8score<$ph13score){
					print OUT6 $ph13;
					print OUT6 "\n";
					print OUT6 $sequence;
					print OUT6 "\n";
					print OUT6 $sequence_length;
					print OUT6 "\n";
					print OUT6 $position_in_membrane;
					print OUT6 "\n";
					print OUT6 "//\n";
					}
				}
			elsif($domains=~/(PH\_BEACH\:\d+\-\d+\(score\:(\d+)\.\d+\)\;)/){
				$phbeach = $1;
				$phbeachscore = $2;
				if($ph8score>$phbeachscore){
					print OUT6 $ph8;
					print OUT6 "\n";
					print OUT6 $sequence;
					print OUT6 "\n";
					print OUT6 $sequence_length;
					print OUT6 "\n";
					print OUT6 $position_in_membrane;
					print OUT6 "\n";
					print OUT6 "//\n";
					}
				elsif($ph8score<$phbeachscore){
					print OUT6 $phbeach;
					print OUT6 "\n";
					print OUT6 $sequence;
					print OUT6 "\n";
					print OUT6 $sequence_length;
					print OUT6 "\n";
					print OUT6 $position_in_membrane;
					print OUT6 "\n";
					print OUT6 "//\n";
					}
				}					
			else{
				print OUT6 $domains;
				print OUT6 "\n";
				print OUT6 $sequence;
				print OUT6 "\n";
				print OUT6 $sequence_length;
				print OUT6 "\n";
				print OUT6 $position_in_membrane;
				print OUT6 "\n";
				print OUT6 "//\n";
				}
		}
		elsif($domains=~/(PH\_9\:\d+\-\d+\(score\:(\d+)\.\d+\)\;)/){ 
			$ph9 = $1;
			$ph9score = $2;
			if($domains=~/(PH\_10\:\d+\-\d+\(score\:(\d+)\.\d+\)\;)/){
				$ph10 = $1;
				$ph10score = $2;
				if($ph9score>$ph10score){
					print OUT6 $ph9;
					print OUT6 "\n";
					print OUT6 $sequence;
					print OUT6 "\n";
					print OUT6 $sequence_length;
					print OUT6 "\n";
					print OUT6 $position_in_membrane;
					print OUT6 "\n";
					print OUT6 "//\n";
					}
				elsif($ph9score<$ph10score){
					print OUT6 $ph10;
					print OUT6 "\n";
					print OUT6 $sequence;
					print OUT6 "\n";
					print OUT6 $sequence_length;
					print OUT6 "\n";
					print OUT6 $position_in_membrane;
					print OUT6 "\n";
					print OUT6 "//\n";
					}
				}
			elsif($domains=~/(PH\_11\:\d+\-\d+\(score\:(\d+)\.\d+\)\;)/){
				$ph11 = $1;
				$ph11score = $2;
				if($ph9score>$ph11score){
					print OUT6 $ph9;
					print OUT6 "\n";
					print OUT6 $sequence;
					print OUT6 "\n";
					print OUT6 $sequence_length;
					print OUT6 "\n";
					print OUT6 $position_in_membrane;
					print OUT6 "\n";
					print OUT6 "//\n";
					}
				elsif($ph9score<$ph11score){
					print OUT6 $ph11;
					print OUT6 "\n";
					print OUT6 $sequence;
					print OUT6 "\n";
					print OUT6 $sequence_length;
					print OUT6 "\n";
					print OUT6 $position_in_membrane;
					print OUT6 "\n";
					print OUT6 "//\n";
					}
				}
			elsif($domains=~/(PH\_12\:\d+\-\d+\(score\:(\d+)\.\d+\)\;)/){
				$ph12 = $1;
				$ph12score = $2;
				if($ph9score>$ph12score){
					print OUT6 $ph9;
					print OUT6 "\n";
					print OUT6 $sequence;
					print OUT6 "\n";
					print OUT6 $sequence_length;
					print OUT6 "\n";
					print OUT6 $position_in_membrane;
					print OUT6 "\n";
					print OUT6 "//\n";
					}
				elsif($ph9score<$ph12score){
					print OUT6 $ph12;
					print OUT6 "\n";
					print OUT6 $sequence;
					print OUT6 "\n";
					print OUT6 $sequence_length;
					print OUT6 "\n";
					print OUT6 $position_in_membrane;
					print OUT6 "\n";
					print OUT6 "//\n";
					}
				}	
			elsif($domains=~/(PH\_13\:\d+\-\d+\(score\:(\d+)\.\d+\)\;)/){
				$ph13 = $1;
				$ph13score = $2;
				if($ph9score>$ph13score){
					print OUT6 $ph9;
					print OUT6 "\n";
					print OUT6 $sequence;
					print OUT6 "\n";
					print OUT6 $sequence_length;
					print OUT6 "\n";
					print OUT6 $position_in_membrane;
					print OUT6 "\n";
					print OUT6 "//\n";
					}
				elsif($ph9score<$ph13score){
					print OUT6 $ph13;
					print OUT6 "\n";
					print OUT6 $sequence;
					print OUT6 "\n";
					print OUT6 $sequence_length;
					print OUT6 "\n";
					print OUT6 $position_in_membrane;
					print OUT6 "\n";
					print OUT6 "//\n";
					}
				}
			elsif($domains=~/(PH\_BEACH\:\d+\-\d+\(score\:(\d+)\.\d+\)\;)/){
				$phbeach = $1;
				$phbeachscore = $2;
				if($ph9score>$phbeachscore){
					print OUT6 $ph9;
					print OUT6 "\n";
					print OUT6 $sequence;
					print OUT6 "\n";
					print OUT6 $sequence_length;
					print OUT6 "\n";
					print OUT6 $position_in_membrane;
					print OUT6 "\n";
					print OUT6 "//\n";
					}
				elsif($ph9score<$phbeachscore){
					print OUT6 $phbeach;
					print OUT6 "\n";
					print OUT6 $sequence;
					print OUT6 "\n";
					print OUT6 $sequence_length;
					print OUT6 "\n";
					print OUT6 $position_in_membrane;
					print OUT6 "\n";
					print OUT6 "//\n";
					}
				}					
			else{
				print OUT6 $domains;
				print OUT6 "\n";
				print OUT6 $sequence;
				print OUT6 "\n";
				print OUT6 $sequence_length;
				print OUT6 "\n";
				print OUT6 $position_in_membrane;
				print OUT6 "\n";
				print OUT6 "//\n";
				}
		}
		elsif($domains=~/(PH\_10\:\d+\-\d+\(score\:(\d+)\.\d+\)\;)/){ 
			$ph10 = $1;
			$ph10score = $2;
			if($domains=~/(PH\_11\:\d+\-\d+\(score\:(\d+)\.\d+\)\;)/){
				$ph11 = $1;
				$ph11score = $2;
				if($ph10score>$ph11score){
					print OUT6 $ph10;
					print OUT6 "\n";
					print OUT6 $sequence;
					print OUT6 "\n";
					print OUT6 $sequence_length;
					print OUT6 "\n";
					print OUT6 $position_in_membrane;
					print OUT6 "\n";
					print OUT6 "//\n";
					}
				elsif($ph10score<$ph11score){
					print OUT6 $ph11;
					print OUT6 "\n";
					print OUT6 $sequence;
					print OUT6 "\n";
					print OUT6 $sequence_length;
					print OUT6 "\n";
					print OUT6 $position_in_membrane;
					print OUT6 "\n";
					print OUT6 "//\n";
					}
				}
			elsif($domains=~/(PH\_12\:\d+\-\d+\(score\:(\d+)\.\d+\)\;)/){
				$ph12 = $1;
				$ph12score = $2;
				if($ph10score>$ph12score){
					print OUT6 $ph10;
					print OUT6 "\n";
					print OUT6 $sequence;
					print OUT6 "\n";
					print OUT6 $sequence_length;
					print OUT6 "\n";
					print OUT6 $position_in_membrane;
					print OUT6 "\n";
					print OUT6 "//\n";
					}
				elsif($ph10score<$ph12score){
					print OUT6 $ph12;
					print OUT6 "\n";
					print OUT6 $sequence;
					print OUT6 "\n";
					print OUT6 $sequence_length;
					print OUT6 "\n";
					print OUT6 $position_in_membrane;
					print OUT6 "\n";
					print OUT6 "//\n";
					}
				}	
			elsif($domains=~/(PH\_13\:\d+\-\d+\(score\:(\d+)\.\d+\)\;)/){
				$ph13 = $1;
				$ph13score = $2;
				if($ph10score>$ph13score){
					print OUT6 $ph10;
					print OUT6 "\n";
					print OUT6 $sequence;
					print OUT6 "\n";
					print OUT6 $sequence_length;
					print OUT6 "\n";
					print OUT6 $position_in_membrane;
					print OUT6 "\n";
					print OUT6 "//\n";
					}
				elsif($ph10score<$ph13score){
					print OUT6 $ph13;
					print OUT6 "\n";
					print OUT6 $sequence;
					print OUT6 "\n";
					print OUT6 $sequence_length;
					print OUT6 "\n";
					print OUT6 $position_in_membrane;
					print OUT6 "\n";
					print OUT6 "//\n";
					}
				}
			elsif($domains=~/(PH\_BEACH\:\d+\-\d+\(score\:(\d+)\.\d+\)\;)/){
				$phbeach = $1;
				$phbeachscore = $2;
				if($ph10score>$phbeachscore){
					print OUT6 $ph10;
					print OUT6 "\n";
					print OUT6 $sequence;
					print OUT6 "\n";
					print OUT6 $sequence_length;
					print OUT6 "\n";
					print OUT6 $position_in_membrane;
					print OUT6 "\n";
					print OUT6 "//\n";
					}
				elsif($ph10score<$phbeachscore){
					print OUT6 $phbeach;
					print OUT6 "\n";
					print OUT6 $sequence;
					print OUT6 "\n";
					print OUT6 $sequence_length;
					print OUT6 "\n";
					print OUT6 $position_in_membrane;
					print OUT6 "\n";
					print OUT6 "//\n";
					}
				}					
			else{
				print OUT6 $domains;
				print OUT6 "\n";
				print OUT6 $sequence;
				print OUT6 "\n";
				print OUT6 $sequence_length;
				print OUT6 "\n";
				print OUT6 $position_in_membrane;
				print OUT6 "\n";
				print OUT6 "//\n";
				}
		}
		elsif($domains=~/(PH\_11\:\d+\-\d+\(score\:(\d+)\.\d+\)\;)/){ 
			$ph11 = $1;
			$ph11score = $2;
			if($domains=~/(PH\_12\:\d+\-\d+\(score\:(\d+)\.\d+\)\;)/){
				$ph12 = $1;
				$ph12score = $2;
				if($ph11score>$ph12score){
					print OUT6 $ph11;
					print OUT6 "\n";
					print OUT6 $sequence;
					print OUT6 "\n";
					print OUT6 $sequence_length;
					print OUT6 "\n";
					print OUT6 $position_in_membrane;
					print OUT6 "\n";
					print OUT6 "//\n";
					}
				elsif($ph11score<$ph12score){
					print OUT6 $ph12;
					print OUT6 "\n";
					print OUT6 $sequence;
					print OUT6 "\n";
					print OUT6 $sequence_length;
					print OUT6 "\n";
					print OUT6 $position_in_membrane;
					print OUT6 "\n";
					print OUT6 "//\n";
					}
				}	
			elsif($domains=~/(PH\_13\:\d+\-\d+\(score\:(\d+)\.\d+\)\;)/){
				$ph13 = $1;
				$ph13score = $2;
				if($ph11score>$ph13score){
					print OUT6 $ph11;
					print OUT6 "\n";
					print OUT6 $sequence;
					print OUT6 "\n";
					print OUT6 $sequence_length;
					print OUT6 "\n";
					print OUT6 $position_in_membrane;
					print OUT6 "\n";
					print OUT6 "//\n";
					}
				elsif($ph11score<$ph13score){
					print OUT6 $ph13;
					print OUT6 "\n";
					print OUT6 $sequence;
					print OUT6 "\n";
					print OUT6 $sequence_length;
					print OUT6 "\n";
					print OUT6 $position_in_membrane;
					print OUT6 "\n";
					print OUT6 "//\n";
					}
				}
			elsif($domains=~/(PH\_BEACH\:\d+\-\d+\(score\:(\d+)\.\d+\)\;)/){
				$phbeach = $1;
				$phbeachscore = $2;
				if($ph11score>$phbeachscore){
					print OUT6 $ph11;
					print OUT6 "\n";
					print OUT6 $sequence;
					print OUT6 "\n";
					print OUT6 $sequence_length;
					print OUT6 "\n";
					print OUT6 $position_in_membrane;
					print OUT6 "\n";
					print OUT6 "//\n";
					}
				elsif($ph11score<$phbeachscore){
					print OUT6 $phbeach;
					print OUT6 "\n";
					print OUT6 $sequence;
					print OUT6 "\n";
					print OUT6 $sequence_length;
					print OUT6 "\n";
					print OUT6 $position_in_membrane;
					print OUT6 "\n";
					print OUT6 "//\n";
					}
				}					
			else{
				print OUT6 $domains;
				print OUT6 "\n";
				print OUT6 $sequence;
				print OUT6 "\n";
				print OUT6 $sequence_length;
				print OUT6 "\n";
				print OUT6 $position_in_membrane;
				print OUT6 "\n";
				print OUT6 "//\n";
				}
		}
		elsif($domains=~/(PH\_12\:\d+\-\d+\(score\:(\d+)\.\d+\)\;)/){ 
			$ph12 = $1;
			$ph12score = $2;
			if($domains=~/(PH\_13\:\d+\-\d+\(score\:(\d+)\.\d+\)\;)/){
				$ph13 = $1;
				$ph13score = $2;
				if($ph12score>$ph13score){
					print OUT6 $ph12;
					print OUT6 "\n";
					print OUT6 $sequence;
					print OUT6 "\n";
					print OUT6 $sequence_length;
					print OUT6 "\n";
					print OUT6 $position_in_membrane;
					print OUT6 "\n";
					print OUT6 "//\n";
					}
				elsif($ph12score<$ph13score){
					print OUT6 $ph13;
					print OUT6 "\n";
					print OUT6 $sequence;
					print OUT6 "\n";
					print OUT6 $sequence_length;
					print OUT6 "\n";
					print OUT6 $position_in_membrane;
					print OUT6 "\n";
					print OUT6 "//\n";
					}
				}
			elsif($domains=~/(PH\_BEACH\:\d+\-\d+\(score\:(\d+)\.\d+\)\;)/){
				$phbeach = $1;
				$phbeachscore = $2;
				if($ph12score>$phbeachscore){
					print OUT6 $ph12;
					print OUT6 "\n";
					print OUT6 $sequence;
					print OUT6 "\n";
					print OUT6 $sequence_length;
					print OUT6 "\n";
					print OUT6 $position_in_membrane;
					print OUT6 "\n";
					print OUT6 "//\n";
					}
				elsif($ph12score<$phbeachscore){
					print OUT6 $phbeach;
					print OUT6 "\n";
					print OUT6 $sequence;
					print OUT6 "\n";
					print OUT6 $sequence_length;
					print OUT6 "\n";
					print OUT6 $position_in_membrane;
					print OUT6 "\n";
					print OUT6 "//\n";
					}
				}					
			else{
				print OUT6 $domains;
				print OUT6 "\n";
				print OUT6 $sequence;
				print OUT6 "\n";
				print OUT6 $sequence_length;
				print OUT6 "\n";
				print OUT6 $position_in_membrane;
				print OUT6 "\n";
				print OUT6 "//\n";
				}
		}
		elsif($domains=~/(PH\_13\:\d+\-\d+\(score\:(\d+)\.\d+\)\;)/){ 
			$ph13 = $1;
			$ph13score = $2;
			if($domains=~/(PH\_BEACH\:\d+\-\d+\(score\:(\d+)\.\d+\)\;)/){
				$phbeach = $1;
				$phbeachscore = $2;
				if($ph13score>$phbeachscore){
					print OUT6 $ph13;
					print OUT6 "\n";
					print OUT6 $sequence;
					print OUT6 "\n";
					print OUT6 $sequence_length;
					print OUT6 "\n";
					print OUT6 $position_in_membrane;
					print OUT6 "\n";
					print OUT6 "//\n";
					}
				elsif($ph13score<$phbeachscore){
					print OUT6 $phbeach;
					print OUT6 "\n";
					print OUT6 $sequence;
					print OUT6 "\n";
					print OUT6 $sequence_length;
					print OUT6 "\n";
					print OUT6 $position_in_membrane;
					print OUT6 "\n";
					print OUT6 "//\n";
					}
				}				
			else{
				print OUT6 $domains;
				print OUT6 "\n";
				print OUT6 $sequence;
				print OUT6 "\n";
				print OUT6 $sequence_length;
				print OUT6 "\n";
				print OUT6 $position_in_membrane;
				print OUT6 "\n";
				print OUT6 "//\n";
				}
		}
		else{
			print OUT6 $domains;
			print OUT6 "\n";
			print OUT6 $sequence;
			print OUT6 "\n";
			print OUT6 $sequence_length;
			print OUT6 "\n";
			print OUT6 $position_in_membrane;
			print OUT6 "\n";
			print OUT6 "//\n";
			}
		}
	}
close IN6;
close OUT6;


##############################
#         Seventh Part       #    Create tab-delimited file
##############################

open (IN7, "<", "results/".$addition."_finaloutput.txt") || die ("Error opening file IN7");
open (OUT7, ">", "results/".$addition."_finaltab.txt") || die ("Error opening file OUT7");
$/="//\n";
print OUT7 "Title\tDomains(Score)\tSequence\tSequence length\tPosition in Membrane\n";
while (<IN7>){
	if ($_=~/^(ID:\t(\S+)\nDomain\(Position\)\:(.*)\nSequence\:\s(.*)\nSequence length\:\t(.*)\nPosition in Membrane\:\s\t(.*))/m){
#		print "$1\n";
				print OUT7 "$2\t$3\t$4\t$5\t$6\n";
		}
}

close IN7;
close OUT7;



###############################
##         Subroutine         #    Print higher scoring domain for proteins in same clan
###############################
#
#sub domain_score {
#	my $score1=$_[0];
#	my $score2=$_[1];
#	my $name1=$_[2];
#	my $name2=$_[3];
#	my $sequence=$_[4];
#	my $sequence_length=$_[5];
#	my $position_in_membrane=$_[6];
#		if($score1>$score2){
#			print OUT6 $name1;
#			print OUT6 "\n";
#			print OUT6 $sequence;
#			print OUT6 "\n";
#			print OUT6 $sequence_length;
#			print OUT6 "\n";
#			print OUT6 $position_in_membrane;
#			print OUT6 "\n";
#			print OUT6 "//\n";
#			}
#		elsif($score1<$score2){
#			print OUT6 $name2;
#			print OUT6 "\n";
#			print OUT6 $sequence;
#			print OUT6 "\n";
#			print OUT6 $sequence_length;
#			print OUT6 "\n";
#			print OUT6 $position_in_membrane;
#			print OUT6 "\n";
#			print OUT6 "//\n";
#			}
#}



