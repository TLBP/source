#! /bin/bash
# Bu betik bulunduğu dizinde çalıştırılır ve kılavuz sayfalarını groff
# biçemine dönüştürüp manpages-tr deposunun yerel kopyasında dosyaları
# ilgili dizinin altına gzipli olarak yazar.
# Bunun çalışması için manpages-tr ve source depolarını
# $HOME/github/belgeler dizininin altına klonlamak gerekmektedir.
prefix="$HOME/github/belgeler/manpages-tr/source"
mandirs=(1 2 3 4 5 6 7 8)

for i in ${mandirs[@]};
do
  rm $prefix/man$i/*
done

# Dosyaları derle (xsltproc)
xsltproc --xinclude -o $prefix/beni.sil \
         manderle.xsl manpages-tr.xml

# XML ağacının çıktılanmayan bölümlerinin yazılamadığı dosyayı sil
rm -f $prefix/beni.sil

for i in ${mandirs[@]};
do
  for j in $prefix/man$i/*;
  do
# Boş satırları sil (grep)
# Groff'a özel ascii karakterleri UTF-8 benzerleriyle değiştir (sed)
# Bu tek tırnak karakterleri genelde satır başında sorun çıkarıyor.
    cat $j | grep . | sed \
	-e "s/'/\\\\\\&'/g" > $j.tmp;
#	-e "s/\`/\\\\\\&'/g" > $j.tmp;
    rm $j;
    mv $j.tmp $j;
  done
done

