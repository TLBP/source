LANG=C gcc -Wall -lz -o xml2man xml2man.c
mandirs=(1 2 3 4 5 6 7 8)

# FIXME: man7/*.7pg.xml files

for i in ${mandirs[@]};
do 
    mkdir ../tr/man$i;
  for j in man$i/*; 
  do 
    manfile=`basename $j .$i.xml`;
    echo man$i/$manfile.$i derleniyor;    
    ./xml2man $1 $j > tr/man$i/$manfile.$i; 
  done 
#  gzip tr/man$i/*;
done
