#!/bin/bash
#
xsl="docbook/xsl/belgeler/singledoc.xsl"
cd ../..
ln workgroup/derle.xml derlenecek.xml
LANG="C" xsltproc $xsl derlenecek.xml
rm -f derlenecek.xml
cd -
