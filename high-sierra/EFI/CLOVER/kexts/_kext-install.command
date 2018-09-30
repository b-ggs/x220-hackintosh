#!/bin/bash

export PATH="/bin:/usr/bin:/usr/sbin"
#dir=$( pwd )
f=$0
dir=${f%/*}

vol="$@"
if [[ "$vol" == "" ]];
then
echo The target volume is: /
echo If target volume is not /, then start this script with the volume name as the script argument
echo Usage: $0 \"/Volume/Macintosh HD\"

dest="/Library/Extensions"
odest="/System/Library/Extensions"

else

echo The target volume is: $vol
export PATH="$PATH:$vol/bin:$vol/usr/bin:$vol/usr/sbin"
dest="$vol/Library/Extensions"
odest="$vol/System/Library/Extensions"
fi

productVersion=$( /usr/libexec/PlistBuddy -c print $vol/System/Library/CoreServices/SystemVersion.plist|grep ProductVersion )
OSXv=${productVersion#*= }
if [[ $OSXv == *"10.10"* ]]; then ver=10.10 ; fi
if [[ $OSXv == *"10.11"* ]]; then ver=10.11 ; fi

echo The target OS is: $ver "($OSXv)"

orig=../kexts-orig

cd "$dir"
test -d $orig || sudo mkdir -p $orig
#
# install all kexts to $dest
#
echo Installing kexts in $dest
for kp in Other/*.kext ${ver}*/*.kext; 
do
k=${kp##*/}
echo "---------------- $k ----------------"
#remove old kexts
   if [ -e  $dest/$k ]; then sudo mv 	 "$dest/$k" $orig/${k}_1_$$ ;fi
   if [ -e $odest/$k ]; then sudo mv 	"$odest/$k" $orig/${k}_2_$$ ;fi
#copy new kext 
   sudo rsync -a --delete $kp 		"$dest"
#fix owner and perms 
   sudo chown -R root:wheel 		"$dest/$k"
   sudo chmod -R go-w 			"$dest/$k"
done

# disable old kext - using IntelMausiEthernet now
echo "------------------------------------"
k=AppleIntelE1000e.kext
echo Looking for obsolete kext $k
if [ -e "$dest/IntelMausiEthernet.kext" ];
then
   if [ -e  "$dest/$k" ]; then sudo mv  "$dest/$k" "$dest/${k}.NU" ;fi
   if [ -e "$odest/$k" ]; then sudo mv "$odest/$k" "$dest/${k}.NU" ;fi
   if [ -e "$odest/IONetworkingFamily.kext/Contents/PlugIns/$k" ]; then sudo mv "$odest/IONetworkingFamily.kext/Contents/PlugIns/$k" "$dest/${k}.NU"; fi
fi

echo "------------------------------------"
k=ACPIBacklight.kext
echo Looking for obsolete kext $k
if [ -e  "$dest/$k" ]; then sudo mv  "$dest/$k" "$dest/${k}.NU" ;fi
if [ -e "$odest/$k" ]; then sudo mv "$odest/$k" "$dest/${k}.NU" ;fi

echo "------------------------------------------------------------------------"
k=IntelBacklight.kext
echo Looking for obsolete kext $k
if [ -e  "$dest/$k" ]; then sudo mv  "$dest/$k" "$dest/${k}.NU" ;fi
if [ -e "$odest/$k" ]; then sudo mv "$odest/$k" "$dest/${k}.NU" ;fi

echo "------------------------------------"
#fix sym links in wrapper kexts

cd "$dest/AppleHDA_20672.kext/Contents/MacOS"
sudo rm -rf AppleHDA
sudo ln -s /System/Library/Extensions/AppleHDA.kext/Contents/MacOS/AppleHDA

# report
cd "$dir"
echo 
m=$( shopt -s nullglob; echo $orig/* )
if [ "$m" != "" ]; then echo "Note: Previous/old kexts are here: $dir/$orig" ; fi
echo 
m=$( shopt -s nullglob; echo $odest/*.NU $dest/*.NU )
if [ "$m" != "" ]; then echo "Note: Obsolete/unused kexts are here: $m" ;fi

#wait for rebuild of cache
echo
echo "------------------------------------"
echo "Sleeping for 20 seconds before rebuild of kext cache - wait … "
sleep 20

# rebuild kext caches one more time
sudo touch "$odest"
sudo kextcache -i /
sudo nvram -d intel-backlight-level
echo "… done!"
