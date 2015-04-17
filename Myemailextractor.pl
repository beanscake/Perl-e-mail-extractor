#i have 20G text containing emails with some html strings in it i begin looking for way to extract it all softwares i bought for that purpose could not open and read out the emails, i even split the 20G to 100MB and the one that could read through the splited 100MB directory took 24 hrs to extract 300,000 from only 2 files that was a waste of time, so i decided to write scipt that will do that for me php could not, ofcourse camel did the hard work. This scipt scans for emails containing .txt in a given directory and loop entirely through the sub directories. the Argument can go from perl myprogram ./ or perl myprogram ./ saveresult.txt or perl myprogram ./ savemyrsult.txt yes(the yes ARG will delete each files after extracting) enjoy
use Cwd;
use Data::Dumper qw(Dumper);
use POSIX qw(strftime);
my $Directory = $ARGV[0]; #Directory to scan for emails
my $dirrr =cwd;
my $whereto =$dirrr.'/';
my $random_number = int(rand(99)) + 9999 .'-'.strftime("%d%m%Y%H%M%S", gmtime(time));
my $Filnamed =$whereto.'emails-'.$random_number.'.txt';
my $Filename ="$ARGV[1]" =~ /\.txt$/i ? $dirrr.'/'.$ARGV[1] : $Filnamed; #if false or true
my $deletefiles = "@ARGV" =~ /yes/i;
my $success   = "\n [+] $0 is Scanning For E-mails\n\n";
my $tryagain    = "\n [?] perl $0 Directory to scan ../fileto.txt Delete_AfterEx_tract_yes/no?\n\n";
if (@ARGV < 1) { print $tryagain; exit(); } else { print $success; }
sub uniq {  #and this to handle the duplicated emails
    return keys %{{ map { $_ => 1 } @_ }};
}
#sub uniq { 
 # my %seen;
  #grep !$seen{$_}++, @_;
#}
my $total_filesscanned = 0;
my $total_email = 0;
my $total_dir = 0;
my $did = dloopDir($Directory, "");
sub dloopDir {
   local($dir, $margin) = @_;
   chdir($dir) || die "Cannot chdir to $dir\n";
   local(*DIR);
   opendir(DIR, ".");
   while (my $f=readdir(DIR)) {
      next if ($f eq "." || $f eq "..");
     my $dirnow = cwd;
my @files = $dirnow.'/'.$f;
open(my $fh, '>>', $Filename); #ready to write
 foreach my $file (@files) {
 next if ($file !~ /\.txt$/i || $file eq "$Filename"); #next if it's not .txt or equal my file 
$total_filesscanned++;  # begin to count numbers of file to be scanned
open my $openfile, '<', $file or die $!;
    while (my $reademail=<$openfile>) {
		chomp($reademail);
		my @findemails = split(' ',$reademail);
       my @filtered = uniq(@findemails);
       foreach my $emails (@filtered) {  
	  
  if($emails =~ /^\w+\@([\da-zA-Z\-]{1,}\.){1,}[\da-zA-Z-]{2,6}$/) { #grab the emails
	$total_email++;   # begin to count emails
 print $fh "$emails\n"; # write the emails to file
print "$file:$emails\n"; # print the emails to my screen
         } 
		}
        }	 
	close $file; # close file
	unlink $deletefiles ? $file : ""; #if true
    }
    close $fh; # close the file to write
	      if (-d $f) {
         &dloopDir($f,$margin."   ");
		 $total_dir++;
      }
   }
   closedir(DIR);
   chdir("..");
 
}
print "Saved to: $Filename\n";
print "Files Scanned: $total_filesscanned Directory: $total_dir\n";
print "E-mail Found: $total_email\n";
print "done\n";
