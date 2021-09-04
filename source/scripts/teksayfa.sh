#!/bin/bash
#
xsl="docbook/xsl/belgeler/teksayfa.xsl"
fname=`basename $1 .xml`;
cd ..
rm -f derlenecek.xml
ln $1 derlenecek.xml
LANG="C" xsltproc -o $fname.html $xsl derlenecek.xml
rm -f derlenecek.xml
