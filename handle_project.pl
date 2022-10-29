#!/usr/bin/perl


use strict;
use warnings;

use Switch;

my $helper_text = "Please use one of the following options: \n\n

project add
project del\n\n";

sub main {

    my $action = $_[0];

    switch ($action) {
        case "add" { add_project(); }
        case "del" { del_project(); }
        else { print $helper_text;exit(0); }
    }
}

sub add_to_project_config {
    my $project_path = $_[0];
    my $project_config_path = "$ENV{HOME}/.projects";

    system("touch $project_config_path");

    if ( -e $project_config_path && -w $project_config_path) {
        system("echo $project_path >> $project_config_path");
    } else {
        print "could not write to file $project_config_path\n
        please check the write permission and try again\n";
        exit(0);
    }

}

sub add_project {
    my $project_location;
    my $project_name;

    # get location to create project
    chomp($project_location = `find ~ -type d | fzf --prompt=\"where to create: \"`);

    print "\nName of project: ";
    chomp($project_name = <STDIN>);

    my $project_path = "$project_location/$project_name";

    mkdir("$project_path")
        or add_to_project_config($project_path) 
        and print "already existing Project added to config"
        and exit(0);

    add_to_project_config($project_path);


    if ( -f $project_path || -d $project_path) {
        print "\nproject $project_name created!\n";
    }

}

main($ARGV[0]);
