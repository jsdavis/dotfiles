#!/bin/bash

which apt &> /dev/null
if [ $? -eq 0 ]
then
    echo -e "UPDATE\n\n"
    apt update

    echo -e "\n\nUPGRADE\n\n"
    apt upgrade -y

    echo -e "\n\nAUTOREMOVE\n\n"
    apt autoremove -y
else
    echo "NOPE"
fi
