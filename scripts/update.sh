#!/bin/bash

zip=$(get_build_var XTENDED_VERSION).zip
device=$(echo $TARGET_PRODUCT | cut -d '_' -f2)
buildprop=$OUT/system/build.prop
linen=$(grep -n "ro.xtended.build.type" $buildprop | cut -d ':' -f1)
romtype=$(sed -n $linen'p' < $buildprop | cut -d '=' -f2)
variant=$(echo $zip | cut -d '-' -f4)
name=$device'_'$variant.json

if [ "$romtype" != "OFFICIAL" ]; then
	return 0
fi

if [ -f $OUT/$name ]; then
	rm $OUT/$name
fi

linenr=$(grep -n "ro.system.build.date.utc" $buildprop | cut -d ':' -f1)
datetime=$(sed -n $linenr'p' < $buildprop | cut -d '=' -f2)
id=$(md5sum "$OUT/$zip" | cut -d ' ' -f1)
size=$(stat -c "%s" "$OUT/$zip")
version=$(echo "$zip" | cut -d '-' -f3)
echo '{
	"response": [
		{
			"datetime": '$datetime',
			"filename": "'$zip'",
			"id": "'$id'",
			"romtype": "'$romtype'",
			"size": '$size',
			"url": "https:\/\/downloads.project-xtended.org\/'$device'\/'$zip'",
			"version": "'$version'"
		}
	]
}' >> $OUT/$name
