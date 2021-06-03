#!/bin/bash

zip=$(get_build_var XTENDED_VERSION).zip
device=$(echo $TARGET_PRODUCT | cut -d '_' -f2)
buildprop=$OUT/system/build.prop
romtype="OFFICIAL"

if [ -f $OUT/$device.json ]; then
	rm $OUT/$device.json
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
			"url": "https:\/\/downloads.msmxtended.org\/'$device'\/'$zip'",
			"version": "'$version'"
		}
	]
}' >> $device.json
