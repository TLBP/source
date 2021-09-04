#!/bin/bash
#
xsl="docbook/xsl/belgeler/singledoc.xsl"
cd ../..
ln sss/derle.xml derlenecek.xml
LANG="C" xsltproc $xsl derlenecek.xml
rm -f derlenecek.xml
cd -
