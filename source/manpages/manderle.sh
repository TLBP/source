#! /bin/sh
mandirs=(1 2 3 4 5 6 7 8)
for i in ${mandirs[@]};
do
  mkdir ../tr/man$i;
  for j in man$i/*;
  do
    manfile=`basename $j .$i.xml`;
    echo man$i/$manfile.$i derleniyor;
    ./xml2man.sh  $i $manfile;
  done
#  gzip tr/man$i/*;
done
