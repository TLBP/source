#!/bin/bash
#
xsl="docbook/xsl/belgeler/chapterless.xsl"
cd ..
ln $1 derlenecek.xml
LANG="C" xsltproc $xsl derlenecek.xml
rm -f derlenecek.xml
