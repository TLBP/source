#!/bin/bash
# Bu betiğin ve bağlı betiklerin sisteminizde çalışması için
# depolarımızın kopyalarının
# $HOME/github/belgeler/manpages-tr
# $HOME/github/belgeler/source
# dizinlerinde bulunması gerekir.
mandirs=(1 2 3 4 5 6 7 8)

for i in ${mandirs[@]};
do
  ./manlist.sh $i
  rm $HOME/github/belgeler/manpages-tr/tr/man$i/*
  . ./tr/man$i.lst
  gzip $HOME/github/belgeler/manpages-tr/tr/man$i/*
done

