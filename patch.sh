#!/bin/bash

curDir=`pwd`
TrunkRepo=$1
PatchRepo=$2
if [ -z $PatchRepo -o -z $TrunkRepo ]
then
  echo "Please pass parameter for Trunk and Patch directory, eg. trunkhosted OpenPetraPatchSomething"
  exit 1
fi

cd $curDir/$TrunkRepo
for f in `find $curDir/$PatchRepo/patch -name *.patch`
do 
  patch -p1 < $f
done

for f in `find $curDir/$PatchRepo/patch -name *.binary`
do
  path=$curDir/$PatchRepo/patch/
  strlenPath=${#path}
  filename=${f:$strlenPath}
  # remove .binary, 7 characters
  filename=${filename:0:${#filename}-7}
  echo "patching binary file $filename"
  cp $f $filename
done

for f in `find $curDir/$PatchRepo/patch -name *.delete`
do
  path=$curDir/$PatchRepo/patch/
  strlenPath=${#path}
  filename=${f:$strlenPath}
  # remove .delete, 7 characters
  filename=${filename:0:${#filename}-7}
  echo "deleting binary file $filename"
  rm -f $filename
done

