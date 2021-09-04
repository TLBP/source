#!/bin/bash
#
srcdir="docbook/xsl/belgeler"
cd ..
xsltproc -o ../moc/menu.html $srcdir/content-tree.xsl belgeler.xml
cd -
