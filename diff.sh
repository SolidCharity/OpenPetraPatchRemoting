#!/bin/bash
Repo=$1
before=$2
patched=$3
if [ "$#" -ne 3 ]
then
  echo "Please pass parameters for valid Patch directory, eg. OpenPetraPatchSomething before patched"
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
    if [[ "${path:(-5)}" != ".orig" ]]
    then 
      #remove patched/ from path
      strlen=${#patched}
      path=${path:$strlen+1}
      filename=`echo $path | sed "s#/#_#g"`.patch
      echo $filename
      diff -uNr $before/$path $patched/$path > $Repo/patch/$filename
    fi
  else if [[ "${line:0:12}" == "Binary files" ]]
   then
    splitBySpace=( $line )
    len="${#splitBySpace[@]}"
    path=${splitBySpace[$len-2]}
    #remove patched/ from path
    strlen=${#patched}
    filename=${path:$strlen+1}
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
  fi
done < <(diff -uNr -x .bzr -x .git $before $patched )
