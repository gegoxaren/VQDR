#!/usr/bin/env bash

# Get the directory of this script.

CWD_SOURCE="${BASH_SOURCE[0]}"
while [ -h "$CWD_SOURCE" ]; do # resolve $SOURCE until the file is no longer a symlink
  DIR="$( cd -P "$( dirname "$CWD_SOURCE" )" >/dev/null 2>&1 && pwd )"
  CWD_SOURCE="$(readlink "$CWD_SOURCE")"
  [[ $SCWD_OURCE != /* ]] && CWD_SOURCE="$DIR/$CWD_SOURCE" # if $SOURCE was a relative symlink, we need to resolve it relative to the path where the symlink file was located
done
CWD="$( cd -P "$( dirname "$CWD_SOURCE" )" >/dev/null 2>&1 && pwd )"

declare -a SOURCES_DIRS=(
  "src/"
  "src/libvqdr/"
  "src/libvqdr/utils/"
  "build/libvqdr.so.p/"
  "build/libvqdr.so.p/src/"
  "build/libvqdr.so.p/src/libvqdr/"
  "build/libvqdr.so.p/src/libvqdr/untils/"
  "build/tests/"
  "build/tests/test1.p/"
  "build/tests/utils/"
)

declare -a SOURCES_DIRS2=()

# build param string
PARAM_STR=""

for str in "${SOURCES_DIRS[@]}"; do
  PARAM_STR+=" --directory "
  PARAM_STR+="${str}"
done


for val in "${SOURCES_DIRS[@]}"
do
  SOURCES_DIRS2+=("$CWD/$val")
done

# for val in "${SOURCES_DIRS2[@]}"
# do
#  echo $val
#  if [ ! -d $val ]
#  then
#    echo "could not find it."
#  fi
# done

gdb $PARAM_STR $@
