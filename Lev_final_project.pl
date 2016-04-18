#!/usr/bin/perl

use strict;
use warnings;
my @states_pr = ('arizona',  'connecticut',  'florida',  'illinois', 'indiana', 'maryland', 'michigan',  'mississippi', 'missouri', 'new-hampshire', 'new-york', 'south-carolina', 'west-virginia', 'wisconsin');
my @states_rp = ('alabama', 'louisiana', 'georgia', 'virginia', 'tennessee', 'arkansas', 'oklahoma', 'ohio', 'pennsylvania', 'louisiana', 'texas', 'massachusetts','california', 'vermont','rhode-island', 'new-jersey', 'north-carolina' );
my @states_nd = ('idaho', 'montana', 'nebraska', 'utah', 'hawaii', 'oregon', 'wyoming', 'maine', 'colorado', 'minnesota', 'delaware', 'district-of-columbia','new-mexico', 'north-dakota', 'south-dakota', 'washington');
my @states_caucus = ('kentucky', 'nevada', 'kansas',);
##my @states = ('Alabama', 'Alaska', 'Arizona', 'Arkansas', 'California', 'Colorado', 'Connecticut', 'Delaware', 'District of Columbia', 'Florida', 'Georgia', 'Hawaii', 'Idaho', 'Illinois', 'Indiana', 'Iowa', 'Kansas', 'Kentucky', 'Louisiana', 'Maine', 'Maryland', 'Massachusetts', 'Michigan', 'Minnesota', 'Mississippi', 'Missouri', 'Montana', 'Nebraska', 'Nevada', 'New Hampshire', 'New Jersey', 'New Mexico', 'New York', 'North Carolina', 'North Dakota', 'Ohio', 'Oklahoma', 'Oregon', 'Pennsylvania', 'Rhode Island', 'South Carolina', 'South Dakota', 'Tennessee', 'Texas', 'Utah', 'Vermont', 'Virginia', 'Washington', 'West Virginia', 'Wisconsin', 'Wyoming');
my %states_pr_DataReceived;
foreach(@states_pr) {
	$states_pr_DataReceived{$_}=0;
}
my %states_rp_DataReceived;
foreach(@states_rp) {
	$states_rp_DataReceived{$_}=0;
}
my %states_nd_DataReceived;
foreach(@states_nd) {
	$states_nd_DataReceived{$_}=0;

}

my %states_caucus_DataReceived;
foreach(@states_caucus) {
	$states_caucus_DataReceived{$_}=0;
}


   foreach( keys %states_pr_DataReceived ) {
 	# print "1==========================\n";
	my $file = "2016-$_-presidential-republican-primary.csv";
	my $url = "http://elections.huffingtonpost.com/pollster/$file";
	my $retval = `curl -s -o "$_.csv" $url`;
	unless ($retval) {
		$states_pr_DataReceived{$_} = 1;
	}
	#print "retval=[$retval]n";
}


   foreach( keys %states_rp_DataReceived ) {
 	# print "2==========================\n";
	my $file = "2016-$_-republican-presidential-primary.csv";
	my $url = "http://elections.huffingtonpost.com/pollster/$file";
	my $retval = `curl -s -o "$_.csv" $url`;
	unless ($retval) {
		$states_rp_DataReceived{$_} = 1;
	}
	#print "retval=[$retval]n";
}

   foreach( keys %states_caucus_DataReceived ) {
 	#print "3==========================\n";
	my $file = "2016-$_-republican-presidential-caucus.csv";
	my $url = "http://elections.huffingtonpost.com/pollster/$file";

	my $ia_file = "2016-iowa-presidential-republican-caucus.csv";
	my $ia_url = "http://elections.huffingtonpost.com/pollster/$ia_file";
	my $ia_retval = `curl -s -o "iowa.csv" $ia_url`;
	#print "ia retval = $ia_retval\n";
	my $ak_file = "2016-alaska-presidential-republican-caucus.csv";
	my $ak_url = "http://elections.huffingtonpost.com/pollster/$ak_file";
	my $ak_retval = `curl -s -o "alaska.csv" $ak_url`;

	my $retval = `curl -s -o "$_.csv" $url`;
	unless ($retval) {
		$states_caucus_DataReceived{$_} = 1;
	}
	#print "retval=[$retval]n";
}
   foreach( keys %states_nd_DataReceived ) {
 	#print "4==========================\n";
	open (FHOUT,">" , "$_.csv") or die;
	print FHOUT "NO DATA FOR $_!\n";
	close FHOUT;



	#print "retval=[$retval]n";
}

my $us_poll = "http://elections.huffingtonpost.com/pollster/2016-national-gop-primary.csv";
my $us_retval = `curl -s -o "national.csv" $us_poll`;

exit;
