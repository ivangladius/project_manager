#!/usr/bin/perl


#use strict;
use warnings;

use Fcntl;

my $helper_text = "Please use one of the following options: \n\n

project add
project del\n\n";

sub list_project {
    print "Projects: \n\n";
    system("cat $ENV{HOME}/.projects");
    print "\n";
}

sub main {

    my $action = $_[0];

    if ("$action" eq "add") {
        add_project();
    } elsif ("$action" eq "del" ) {
        del_project();
    } elsif ("$action" eq "list" ) {
        list_project();
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

sub del_project {

    my $to_delete = `cat $ENV{HOME}/.projects | fzf --height 40%`;

	open(FH, "+<$ENV{HOME}/.projects") or die $!;

    my $buffer = "";

    while (<FH>) {
        $buffer .= $_ if ($_ ne "$to_delete");
    }

	open(FH, ">$ENV{HOME}/.projects") or die $!;

    print FH $buffer;

    print $buffer;

    close(FH);
}

main($ARGV[0]);
