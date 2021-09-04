#!/bin/bash
#
xsl="docbook/xsl/belgeler/singledoc.xsl"
cd ..
rm -f derlenecek.xml
ln $1 derlenecek.xml
LANG="C" xsltproc $xsl derlenecek.xml
rm -f derlenecek.xml
