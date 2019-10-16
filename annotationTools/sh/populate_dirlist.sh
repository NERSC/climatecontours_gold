#!/bin/bash

# Populates list of images to label ("dirlist").  This list is stored
# inside "/path/to/LabelMe/annotationCache/DirLists/".
#
# Make sure to run this script from "annotationTools/sh/" folder.  
# Otherwise, it will be necessary to modify HOMEIMAGES and HOMEDIRLIST 
# below.
#
# Example 1: Populate entire image database
# $ cd /path/to/LabelMe/annotationTools/sh
# $ ./populate_dirlist.sh
#
# Example 2: Create a new collection called "labelme2" and populate 
# subfolder "folder1":
# $ cd /path/to/LabelMe/annotationTools/sh
# $ ./populate_dirlist.sh labelme2.txt folder1


# populate_dirlist.sh [dirlist.txt] [folder]
#
# dirlist.txt - Dirlist filename
# folder - Sub-folder under root folder

# Pointer to Images/ and DirLists/ directories:
LM_HOME="/var/www/html/climatecontours_gold/"
HOMEIMAGES="${LM_HOME}Images"
HOMEDIRLIST="${LM_HOME}annotationCache/DirLists"
HOMEVIDEOS="${LM_HOME}VLMFrame"

# Inputs:
dirlist=$1
folder=$2
videodirlist='labelmevideo.txt'
# Handle empty input argument cases:
if [ "$dirlist" == "" ]; then
    dirlist='labelme.txt';
    
fi

if [ "$folder" == "" ]; then
   ImageDir=$HOMEIMAGES;
   VideoDir=$HOMEVIDEOS;
else
   ImageDir="$HOMEIMAGES/$folder";
   VideoDir="$HOMEVIDEOS/$folder";
fi

# adapted from https://stackoverflow.com/questions/3685970/check-if-a-bash-array-contains-a-value
containsElement () {
  local e match="$1"
  shift
  for e; do [[ "$e" == "$match" ]] && echo 0 && return 0; done
  echo 1
}

# below setting only generates labels for the TMQ channel
toggle_arr=("tmq")


# Populate dirlist:
find $ImageDir | sort -R | while read i; do
    if [[ $i =~ ^.*\.jpg$ ]]; then
#	echo $i
		dname=$(dirname $i | sed -e s=$HOMEIMAGES/==);
		iname=$(basename $i);

        contains=$(containsElement "$dname" "${toggle_arr[@]}");
        echo $contains
		if [[ $contains -ne 0 ]]; then

            echo "$dname,$iname";
            echo "$dname,$iname" >> $HOMEDIRLIST/$dirlist;

        fi
    fi
done

# Populate dirlist:
ls $VideoDir | while read i; do
	idname=$VideoDir$i;
	ls $idname | while read j; do
		dirn=$idname/$j;
		dname=$i/$j;
		ls $dirn | while read na; do
			videoname=$(basename $na);
			echo "$dname,$videoname";
			echo "$dname,$videoname" >> $HOMEDIRLIST/$videodirlist;
		done
	done
done



