#!/bin/bash
# "Tek" bir Kılavuz sayfasını bölüm ve ad belirtilirse derler.
prefix="$HOME/github/belgeler/manpages-tr/source"
rm -f $prefix/man$1/$2.$1.gz
echo "<?xml version='1.0' encoding=\"UTF-8\"?><?xml-stylesheet type=\"text/xsl\" href=\"#xslss\"?><!DOCTYPE belge [ <!ATTLIST xsl:stylesheet id ID #IMPLIED> ]><belge><xsl:stylesheet id=\"xslss\"  version='1.0' xmlns:xsl=\"http://www.w3.org/1999/XSL/Transform\"><xsl:output method=\"text\" encoding=\"UTF-8\" omit-xml-declaration=\"yes\" standalone=\"yes\" indent=\"no\"/><xsl:include href=\"manderle.xsl\"/><xsl:template match=\"/\"><xsl:variable name=\"node\" select=\"document('manpages-tr.xml')//*[@xml:id='man$1-$2']\"/><xsl:choose><xsl:when test=\"name(\$node)!=''\"><xsl:apply-templates select=\"\$node\"/></xsl:when><xsl:otherwise><xsl:message  terminate=\"yes\"><xsl:text>Boyle bir belge yok</xsl:text></xsl:message></xsl:otherwise></xsl:choose></xsl:template><xsl:template match=\"xsl:stylesheet\"/></xsl:stylesheet></belge>" | xsltproc --maxdepth 50000 -o $prefix/beni.sil  - &> err

err=$(< err)

if [ "${err: -10:${#err}}" != "yazılıyor." ];
then
    echo "Hatalar err dosyasına yazıldı";
    exit;
fi

echo "$err"

cat $prefix/man$1/$2.$1 | grep . | sed  -e "s/'/\\\\\\&'/g" > $prefix/man$1/$2.$1.tmp
# -e "s/\`/\\\\\\&'/g" \    Bunu yapmamak lazım. Komut ikamesi tırnağını değiştiremeyiz. 
# Ubuntu bug listesinde kopyala yapıştır ile ilgili sorunlar bildirilmiş. 
# Hiçbiri bizimle ilgili değil. Ancak bizimle ilgili olma olasılığı hiç olmamalı.


rm $prefix/man$1/$2.$1
mv $prefix/man$1/$2.$1.tmp $prefix/man$1/$2.$1
#gzip $prefix/man$1/$2.$1
