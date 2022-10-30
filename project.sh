
#!/bin/bash

if [[ $1 == "add" ]];then
    perl project.pl add
elif [[ $1 == "del" ]];then
    perl project.pl del 
elif [[ $1 == "list" ]];then
    perl project.pl list 
elif [[ $1 == "cd" ]];then
    perl project.pl cd 
fi

