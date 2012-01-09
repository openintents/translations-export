#!/bin/bash

# Export translations for all applications
# Jan 8, 2011, Peli

# Jan 29, 2011: Peli: read list of apps from central place.
# Feb 10, 2011: Peli: Omit creating tar file, as modifications are pulled 
#                     directly from the trunk from Launchpad.
# Feb 12, 2011: Peli: Implement "STOP" command.
# Jan 9, 2012: Peli: Handle DOS file ending

# Suppress generation of .po file:
nopo=
#nopo="--nopo"

# Remove timestamp in po and pot files:
notimestamp="--notimestamp"

# $1..translation file name
# $2..main path
function execute
{
	translationfilename=$1
    mainpath=$2
    scriptpath=../../$mainpath/translations
	translationspath=translations_$translationfilename
    echo "Translating $mainpath"
    mkdir translations_$translationfilename
    rm translations_$translationfilename/*.po
    rm translations_$translationfilename/*.pot
	echo "$nopo"
    ../scripts/androidxml2po.bash -lp "../import_all/translations/export_all/translations_$translationfilename" -a "../../$mainpath" -n "$translationfilename" -ex "translations_$translationfilename" $nopo $notimestamp -e
}

# Delete all existing output directories:
#rm -r translations_*/*.po
#rm -r translations_*/*.pot

# Read all apps that should be translated.
# sed:
# - Convert DOS line ending to UNIX line ending using: sed 's///'
# - Remove comment lines starting with "#"
# - Remove empty lines
# apps=( `cat "../applications.txt" | sed -e "s/#.*$//" -e "/^$/d"`)
apps=( `cat "../applications.txt" | sed -e "s///" -e "s/#.*$//" -e "/^$/d"`)

for (( i = 0 ; i < ${#apps[@]} ; i+=2 ))
do
	if [ "${apps[$i]}" == "STOP" ] ; then
		break
	fi
	execute ${apps[$i]} ${apps[$i+1]}
done


#echo "Creating tar.gz file for upload..."
#tar -cvvzf launchpad-upload.tar.gz translations_*
