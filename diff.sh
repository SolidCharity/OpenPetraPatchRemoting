#!/bin/bash
Repo=$1
if [ -z $Repo ]
then
  echo "Please pass parameter for valid Patch directory, eg. OpenPetraPatchRemoting"
  exit 1
fi
rm -Rf $Repo/patch
mkdir -p $Repo/patch
rm -Rf $Repo/binary
mkdir -p $Repo/binary
rm -Rf $Repo/delete
mkdir -p $Repo/delete
filename=
while read line; do
  if [[ "${line:0:9}" == "diff -uNr" ]]
  then
    #echo $line
    splitBySpace=( $line )
    len="${#splitBySpace[@]}"
    path=${splitBySpace[$len-1]}
    #remove remoting/ from path
    path=${path:9}
    filename=`echo $path | sed "s#/#_#g"`.patch
    echo $filename
    diff -uNr trunk/$path remoting/$path > $Repo/patch/$filename
  fi
  if [[ "${line:0:12}" == "Binary files" ]]
  then
    splitBySpace=( $line )
    len="${#splitBySpace[@]}"
    path=${splitBySpace[$len-2]}
    #remove remoting/ from path
    filename=${path:9}
    filename=`echo $filename | sed "s#/#__#g"`
    if [ -f $path ]
    then
      echo "binary file $path"
      cp $path $Repo/binary/$filename
    else
      echo "removing $path"
      touch $Repo/delete/$filename
    fi
  fi
done < <(diff -uNr -x .bzr trunk remoting )
