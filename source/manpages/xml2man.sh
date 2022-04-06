#! /bin/sh
# Dosyayı derle (xsltproc)
# Boş satırları sil (grep)
# Özel ascii karakterleri öncele (sed)
#
# Artık ISO-8859-9 kullanımdan kalktığından UTF-8 karakterlerle
# sorun yaşayan kalmadığından hareketle dönüşüm basitleştirildi.
# Debian UTF-8 dosyalarımıza hala, paketlerken ISO-8859-9
# ekranda gösterirken UTF-8 dönüşümü uygulamasın, lütfen.
# Çünkü dosyalarda UTF-8 semboller (> U+2000) kullanılmaktadır.
# (Örneğin, bullet olarak U+2055 kullanılıyor)

LANG=C xsltproc xmltoman.xsl man$1/$2.$1.xml | grep . | sed \
-e "s/'/\\\\\\&'/g" \
-e "s/\`/\\\\\\&'/g" \
 > tr/man$1/$2.$1
