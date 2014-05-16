#!/bin/bash
Repo=$1
before=$2
patched=$3
if [ "$#" -ne 3 ]
then
  echo "Please pass parameters for valid Patch directory, eg. OpenPetraPatchSomething before patched"
  exit 1
fi
if [ -d $Repo/patch ]
then
  mv $Repo/patch $Repo/patchOld
fi
mkdir -p $Repo/patch
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
      filename=$path.patch
      mkdir -p `dirname $Repo/patch/$filename`
      diff -uNr $before/$path $patched/$path > $Repo/patch/$filename
      if [ -f $Repo/patchOld/$filename ]
      then
         linesDifferent=`diff $Repo/patch/$filename $Repo/patchOld/$filename | wc -l`
         if [ $linesDifferent -eq 6 -o $linesDifferent -eq 0 ]
         then
           mv $Repo/patchOld/$filename $Repo/patch/$filename
         else
           echo $filename
         fi
      else
        echo $filename
      fi
    fi
  elif [[ "${line:0:12}" == "Binary files" ]]
  then
    splitBySpace=( $line )
    len="${#splitBySpace[@]}"
    path=${splitBySpace[$len-2]}
    #remove patched/ from path
    strlen=${#patched}
    filename=${path:$strlen+1}
    mkdir -p `dirname $Repo/patch/$filename`
    if [ -f $path ]
    then
      cp $path $Repo/patch/$filename.binary
      if [ -f $Repo/patchOld/$filename.binary ]
      then
        linesDifferent=`diff $Repo/patch/$filename.binary $Repo/patchOld/$filename.binary | wc -l`
        if [ $linesDifferent -eq 6 -o $linesDifferent -eq 0 ]
        then
          mv $Repo/patchOld/$filename.binary $Repo/patch/$filename.binary
        else
          echo $filename.binary
        fi
      else
        echo $filename.binary
      fi 
    elif [ -f $Repo/patchOld/$filename.delete ]
    then
      mv $Repo/patchOld/$filename.delete $Repo/patch/$filename.delete
    else
      echo "removing $path"
      touch $Repo/patch/$filename.delete
    fi
  fi
done < <(diff -uNr -x .bzr -x .git $before $patched )
rm -Rf $Repo/patchOld
