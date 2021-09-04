# kullanim: manpdf dizinno belgeismi
./xml2tex.sh tr-man$1-$2
echo -e "Listelenen dosya isimleri varsa, bunlarda dosya eklentisini başlatan nokta dışındaki noktaları - ile değiştirilmiş dosya isimleriyle bu dosyalara sembolik bağlar oluştur"
echo -e "`stat -c%s man$1-$2.tex` bayt yazıldı"
