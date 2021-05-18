#!/bin/sh

export Changelog=Changelog.txt

if [ -f $Changelog ];
then
	rm -f $Changelog
fi

touch $Changelog

echo "Generating changelog..."

for i in $(seq 14);
do
export After_Date=`date --date="$i days ago" +%Y/%m/%d`
k=$(expr $i - 1)
      export Until_Date=`date --date="$k days ago" +%Y/%m/%d`

	# Line with after --- until was too long for a small ListView
	echo '=======================' >> $Changelog;
	echo  "     "$Until_Date       >> $Changelog;
	echo '=======================' >> $Changelog;
	echo >> $Changelog;

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

sed -i 's/project/   */g' $Changelog

cp $Changelog $OUT/system/etc/
cp $Changelog $OUT/
rm -rf $Changelog
