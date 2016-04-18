
#!/usr/bin/perl
use strict;
use warnings;

use GD::Graph::bars;
use GD::Graph::Data;

use Cwd;
my $pwd = getcwd;
chomp(my $perl = `which perl`);
system ("$perl $pwd/Lev_final_project.pl");

# Make a hash of all the states and their initials

my %init_states = ('AL','alabama','AK','alaska','AZ','arizona','AR','arkansas','CA','california','CO','colorado','CT','connecticut','DC','district-of-columbia','DE','delaware','FL','florida','GA','georgia','HI','hawaii','ID','idaho','IL','illinois','IN','indiana','IA','iowa','KS','kansas','KY','kentucky','LA','louisiana','ME','maine','MD','maryland', 'MA','massachusetts','MI','michigan','MN','minnesota','MS','mississippi','MO','missouri','MT','montana','NE','nebraska', 'NV','nevada','NH','new-hampshire','NJ','new-jersey', 'NM','new-mexico','NY','new-york','NC','north-carolina','ND','north-dakota','OH','ohio','OK','oklahoma','OR','oregon','PA','pennsylvania','RI','rhode-island','SC','south-carolina','SD','south-dakota','TN','tennessee','TX','texas','UT','utah','VT','Vermont','VA','virginia','WA','washington','WV','west-virginia','WI','wisconsin','WY','wyoming','US','national');

system ("clear");

# Have the menu running

while(1){


print "\n";
print "2016 Republican Candidates Polling Data\n";
print "Please write out the 2-letter state abbreviation/code.\n";
print "For Washington, D.C type in DC. For national data, type in US\n";
print "Select a polling state: ";
chomp (my $state = <STDIN>);
$state = uc $state;
my $state_graph_data = "$state.png";
if ($init_states{$state}){
	my $state_fullname = $init_states{$state};
	$state_fullname = uc $state_fullname;
	# Send three variables over to the get_data subroutine
	# Send initals of state, send name of graph, send fullname of the state.
	get_data ("$init_states{$state}.csv" , $state_graph_data, $state_fullname);
	print "Do another state (y|n)? ";
	chomp (my $do_again = <STDIN>);
	exit if $do_again !~ /^y$/i;
	system ("clear");
	}

else {

	print "ERROR: Invalid state code.\n";
	print "Try again!\n";
	system ("clear");
	}
}


# Subroutine starts here
#-------------------------------------------------------------------------------------------------------------------------------
sub get_data {

# open .csv file to parse info out of.
open (FHIN, $_[0]) or die;
#my @candidates = "Trump", "Cruz", "Kasich";
my (@data_trump, @data_cruz, @data_kasich);
my ($col_trump, $col_cruz, $col_kasich);
my ($latest_trump, $latest_cruz, $latest_kasich);
my $name_of_state = $_[2];
my $file_avg = "avg".$_[1];
my $file_latest = "latest".$_[1];

#divide information from csv into data, and header of columns
chomp (my $headers = <FHIN>);
chomp (my @lines = <FHIN>);

close FHIN;

# Check for NO DATA states
if ($headers =~ /(NO DATA)/){

print "There is no data for $name_of_state. Please select another state.\n"

}

# Run proccessing for data states
else {
my @headers = split (/,/ , $headers);



# Find out column numbers for all the candidates
for (my $i = 0; $i < @headers; $i++){

	if ($headers[$i] =~ /Trump/){
		$col_trump = $i;
	}

	elsif ($headers[$i] =~ /Cruz/){
		$col_cruz = $i;
	}

	elsif ($headers[$i] =~ /Kasich/){
		$col_kasich = $i;
	}
}

	# Get the LATEST polling data 	
 	
	my @tmp_a = split (/,/, $lines[0]);
	$latest_trump = $tmp_a[$col_trump];
	$latest_cruz = $tmp_a[$col_cruz];
	$latest_kasich =  $tmp_a[$col_kasich];

#split up the polling data based on candidates
foreach (@lines) {

	my @tmp = split (/,/, $_);
	push (@data_trump, $tmp[$col_trump]);
	push (@data_cruz, $tmp[$col_cruz]);
	push (@data_kasich, $tmp[$col_kasich]);
}


my ($sum_trump, $sum_cruz, $sum_kasich) = (0,0,0);
my ($n_trump, $n_cruz, $n_kasich) = (0,0,0);

# Start process of averaging out the data
# Take out all data excluding empty fields

for (my $i=0; $i < @data_trump; $i++){

	if ($data_trump[$i] =~ /(\d\d)/ || $data_trump[$i] =~ /(\d)/){
	
	$sum_trump = $sum_trump + $data_trump[$i];
	$n_trump++;
	}
	
	if ($data_cruz[$i] =~ /(\d\d)/ || $data_cruz[$i] =~ /(\d)/){
	
	$sum_cruz =  $sum_cruz + $data_cruz[$i];
	$n_cruz++;
	}
	
	if ($data_kasich[$i] =~ /(\d\d)/ || $data_kasich[$i] =~ /(\d)/){
	
	$sum_kasich = $sum_kasich + $data_kasich[$i];
	$n_kasich++;
	}
}
# Calculate the averages for all
my $avg_trump = $sum_trump / $n_trump;
my $avg_cruz = $sum_cruz / $n_cruz;
my $avg_kasich;

# Run testing for Kasich

if ($n_kasich == 0) {
	
	$avg_kasich = 0;
}

else {
	
$avg_kasich = $sum_kasich / $n_kasich;
}

# Print out latest polling data for all

print "  Latest Polling Data for $name_of_state:\n";
print "  Trump = $latest_trump\n";
print "  Cruz = $latest_cruz\n";
print "  Kasich = $latest_kasich\n";


print "\n";
print "\n";

#print out average data.

print  "  Average Polling Numbers\n";
printf "  Trump AVG - %.0f\n", $avg_trump;

printf "  Cruz AVG - %.0f\n", $avg_cruz;

printf "  Kasich AVG - %.0f\n", $avg_kasich;

#Find out if user wants to graph the data.

print "Do you want to graph the data?(y|n) ";
chomp (my $graph_reply = <>);
	
	if ($graph_reply =~ /^y$/i){
		
	#ask user for which data they want on the graph
	print "Which graph do you want? (avg|latest|both) ";
	chomp (my $graph_choice = <>);
		
		if ($graph_choice =~ /^avg$/i) {
			
			
			# Graph the average data.

			my $data = GD::Graph::Data->new([
			    ["Trump", "Cruz", "Kasich"],
			    [    $avg_trump, $avg_cruz, $avg_kasich],
			]) or die GD::Graph::Data->error;
			 
			 
			my $graph = GD::Graph::bars->new;
			 
			$graph->set( 
			    x_label         => 'Candidates',
			    y_label         => 'Polling Numbers',
			    title           => "$name_of_state Average Polling Numbers",
			 
			    y_max_value     => 60,
			    y_tick_number   => 12,
			    #y_label_skip    => 3,
			    
			 
			    bar_spacing     => 20,
			    shadow_depth    => 4,
			    #shadowclr       => 'dred',
			 
			    transparent     => 0,
			) or die $graph->error;
			 
			$graph->plot($data) or die $graph->error;
			 
			# Export graph for avg to .png file with state inital as the name
			open(my $out, '>', $file_avg) or die "Cannot open '$file_avg' for write: $!";
			binmode $out;
			print $out $graph->gd->png;
			close $out;

			# find out if user wants to see the data for the average data
			print "Do you want to see a graph for the data (y|n)? ";
			chomp (my $graph_data = <>);
			if ($graph_data =~ /^y$/i){
	
			system("xdg-open $file_avg");
			}
			else {
			}

		}
		#run graph for latest data
		if ($graph_choice =~ /^latest$/i) {
			
			
			# Graph the latest data.

			my $data = GD::Graph::Data->new([
			    ["Trump", "Cruz", "Kasich"],
			    [    $latest_trump, $latest_cruz, $latest_kasich],
			]) or die GD::Graph::Data->error;
			 
			 
			my $graph = GD::Graph::bars->new;
			 
			$graph->set( 
			    x_label         => 'Candidates',
			    y_label         => 'Polling Numbers',
			    title           => "$name_of_state Latest Polling Numbers",
			 
			    y_max_value     => 60,
			    y_tick_number   => 12,
			    #y_label_skip    => 3,
			    
			 
			    bar_spacing     => 20,
			    shadow_depth    => 4,
			    #shadowclr       => 'dred',
			 
			    transparent     => 0,
			) or die $graph->error;
			 
			$graph->plot($data) or die $graph->error;
			 
			# Export graph for avg to .png file with state inital as the name
			open(my $out, '>', $file_latest) or die "Cannot open '$file_latest' for write: $!";
			binmode $out;
			print $out $graph->gd->png;
			close $out;

			# find out if user wants to see the data for the average data
			print "Do you want to see a graph for the data (y|n)? ";
			chomp (my $graph_data = <>);
			if ($graph_data =~ /^y$/i){
	
			system("xdg-open $file_latest");
			}
			else {
			}

		}


		if ($graph_choice =~ /^both$/i) {
			
			
			# Graph the latest data.

			my $data_latest = GD::Graph::Data->new([
			    ["Trump", "Cruz", "Kasich"],
			    [    $latest_trump, $latest_cruz, $latest_kasich],
			]) or die GD::Graph::Data->error;
			 
			 
			my $graph_latest = GD::Graph::bars->new;
			 
			$graph_latest->set( 
			    x_label         => 'Candidates',
			    y_label         => 'Polling Numbers',
			    title           => "$name_of_state Latest Polling Numbers",
			 
			    y_max_value     => 60,
			    y_tick_number   => 12,
			    #y_label_skip    => 3,
			    
			 
			    bar_spacing     => 20,
			    shadow_depth    => 4,
			    #shadowclr       => 'dred',
			 
			    transparent     => 0,
			) or die $graph_latest->error;
			 
			$graph_latest->plot($data_latest) or die $graph_latest->error;
			 
			# Export graph for avg to .png file with state inital as the name
			open(my $out_latest, '>', $file_latest) or die "Cannot open '$file_latest' for write: $!";
			binmode $out_latest;
			print $out_latest $graph_latest->gd->png;
			close $out_latest;

			
			# Graph the average data
			my $data = GD::Graph::Data->new([
			    ["Trump", "Cruz", "Kasich"],
			    [    $avg_trump, $avg_cruz, $avg_kasich],
			]) or die GD::Graph::Data->error;
			 
			 
			my $graph = GD::Graph::bars->new;
			 
			$graph->set( 
			    x_label         => 'Candidates',
			    y_label         => 'Polling Numbers',
			    title           => "$name_of_state Average Polling Numbers",
			 
			    y_max_value     => 60,
			    y_tick_number   => 12,
			    #y_label_skip    => 3,
			    
			 
			    bar_spacing     => 20,
			    shadow_depth    => 4,
			    #shadowclr       => 'dred',
			 
			    transparent     => 0,
			) or die $graph->error;
			 
			$graph->plot($data) or die $graph->error;
			 
			# Export graph for avg to .png file with state inital as the name
			open(my $out, '>', $file_avg) or die "Cannot open '$file_avg' for write: $!";
			binmode $out;
			print $out $graph->gd->png;
			close $out;

			# find out if user wants to see the data for the average data
			print "Do you want to see the graph for the data (y|n)? ";
			chomp (my $graph_data = <>);
			if ($graph_data =~ /^y$/i){
			
				print "Which data do you wish to see? (avg|latest|both) ";
				chomp (my $graph_data_reply = <>);
				
				if ($graph_data_reply =~ /^avg$/i){
				
				system("xdg-open $file_avg");		
				}
				
				if ($graph_data_reply =~ /^latest$/i){
				
				system("xdg-open $file_latest");		
				}			
				if ($graph_data_reply =~ /^both$/i){
				
				system("xdg-open $file_latest");
				system("xdg-open $file_avg");		
				}			

			}
			else {
			}

			
		}


}
	
# end of with data else statement
	}

# end of subroutine
}

exit;
