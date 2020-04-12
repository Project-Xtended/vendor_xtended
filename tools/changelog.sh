#!/bin/sh

export Changelog=$PWD/Changelog.txt

if [ -f $Changelog ];
then
    rm -f $Changelog
fi

touch $Changelog

for i in $(seq 14);
do
export After_Date=`date --date="$i days ago" +%F`
k=$(expr $i - 1)
export Until_Date=`date --date="$k days ago" +%F`
echo "====================" >> $Changelog;
echo "     $Until_Date    " >> $Changelog;
echo "====================" >> $Changelog;
# Cycle through every repo to find commits between 2 dates
while read path;
        do
    CLOG=$(git --git-dir ./${path}/.git log --oneline --after=$After_Date --until=$Until_Date);
    if [ -n "$CLOG" ]; then
       echo project $path >> $Changelog
       git --git-dir ./${path}/.git log --oneline --after=$After_Date --until=$Until_Date >> $Changelog
    fi
done < ./.repo/project.list;
echo "" >> $Changelog;
done

sed -i 's/project/ */g' $Changelog
sed -i 's/[/]$//' $Changelog

cp $Changelog $OUT/
