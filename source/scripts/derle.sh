#!/bin/bash
# Kitaplığın id'si belirtilen bölümünü derler.

cd ..

xsl="docbook/xsl/belgeler/multipage-start.xsl"
xml="belgeler.xml"

xsltproc --xinclude --stringparam rootid $1  $xsl $xml &> scripts/derle-output

cd -
