#!/usr/bin/perl
################################################################
# ODM Procedures Hourly
# @author: Scott Smith, Collin Bode
# @date:  2017-03-28
#
# Purpose: simple launch of the hourly aggregation functions.
#
################################################################ 
use DBI;

# Connect to database
$dbh = DBI->connect("dbi:mysql:$database:gall.bnhm.berkeley.edu","collin","Kanalani99");
if ( !defined $dbh ) { die "Cannot connect to mysql server: $DBI::errstr\n"; }

# run 
$query = "call usp_run_hourly";
$sth = $dbh->prepare( $query ) or die "Can't prepare statement: $DBI::errstr\n";
$sth->execute;

# clean up
$sth->finish;
$dbh->disconnect;
