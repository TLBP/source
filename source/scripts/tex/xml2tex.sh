# usage: xml2tex.sh doc_id 
# Bu dosya belgetex.xml ile aynı dizinde olmalıdır.

# xslpath değeri ile belgetex.xml dosyasındaki clsprefix değeri
# aynı olmalıdır.
xslpath="../htdocs/source/docbook/xsl/tex"
xsltproc --stringparam mainid $1 -o $1.tmp belgetex.xml
$xslpath/filter $1.tmp  `stat -c%s $1.tmp` > $1.tex
echo -e "`stat -c%s $1.tex` bayt yazıldı"
echo -e "Listelenen dosya isimleri varsa, bunlarda dosya eklentisini başlatan nokta dışındaki noktaları - ile değiştirilmiş dosya isimleriyle bu dosyalara sembolik bağlar oluştur"
