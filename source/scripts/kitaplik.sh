#!/bin/bash
#

xsl="docbook/xsl/belgeler/bookless.xsl"
xml="belgeler.xml"
cd ..
LANG="C" xsltproc $xsl $xml
cd -

