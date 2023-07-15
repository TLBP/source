#!/bin/bash
# Kitaplığın kitaplarını değil yalnızca ilk birkaç sayfasını derler.

cd ..

xsl="scripts/bookless.xsl"
xml="belgeler.xml"

xsltproc --xinclude $xsl $xml

cd -

