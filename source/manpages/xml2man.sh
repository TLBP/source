#! /bin/sh
# Dosyayı derle (xsltproc)
# Boş satırları sil (grep)
# Groff'a özel ascii karakterleri öncele (sed)
#
# Artık ISO-8859-9 kullanımdan kalktığından UTF-8 karakterlerle
# sorun yaşayan kalmadığından hareketle dönüşüm basitleştirildi.

LANG=C xsltproc xmltoman.xsl man$1/$2.$1.xml | grep . | sed \
-e "s/'/\\\\\\&'/g" \
-e "s/\`/\\\\\\&'/g" \
 > tr/man$1/$2.$1
