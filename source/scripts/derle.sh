#!/bin/bash
#
srcdir=".."
xsl="../docbook/xsl/belgeler/site.xsl"

case "$1" in
    arsiv)
      xml="archive/derle.xml"
      ;;
  bashref)
      xml="BashRef/derle.xml"
      ;;
    bgnet)
      xml="derle-bgnet.xml"
      ;;
   cdersi)
      xml="c-dersi/derle.xml"
      ;;
  elkitabi)
      xml="workgroup/derle.xml"
      ;;
    embed)
      xml="howtos/derle-embed.xml"
      ;;
    gettext)
      xml="gettext/derle.xml"
      ;;
    howto)
      xml="howtos/derle.xml"
      ;;
      hpm)
      xml="derle-hpm.xml"
      ;;
      lis)
      xml="arsiv/derle-lis.xml"
      ;;
      man)
      xml="manpages/derle.xml"
      ;;
      sag)
      xml="derle-sag.xml"
      ;;
   sozluk)
      xml="xmldict/derle.xml"
      ;;
      sss)
      xml="sss/derle.xml"
      ;;
      app)
      xml="applications/derle.xml"
      ;;
    regex)
      xml="derle-regex.xml"
      ;;
      std)
      xml="derle-std.xml"
      ;;
  termcap)
      xml="derle-termcap.xml"
      ;;
  autoconf)
      xml="autoconf/derle.xml"
      ;;
  autobook)
      xml="autobook/derle.xml"
      ;;
      plg)
      xml="plg/derle.xml"
      ;;
 kitaplik)
      xml="belgeler.xml"
      xsl="../docbook/xsl/belgeler/index.xsl"
      ;;
     dict)
      xml="library.xml"
      xsl="../docbook/xsl/belgeler/index.xsl"
      ;; 
 kitaplik-all)
      xml="belgeler.xml"
      xsl="../docbook/xsl/belgeler/site.xsl"
      ;;  
  tefrika)
      xml="tefrika.xml"
      xsl="../docbook/xsl/belgeler/index.xsl"
      ;;
        *)
      echo "derle.sh [ app | arsiv | bashref | bgnet | cdersi | elkitabi"
      echo "           embed | howto | hpm | lis | man | sag | sozluk | sss"
      echo "           autoconf | autobook | termcap "
      echo "           dict | regex | kitaplik | kitaplik-all | tefrika ]"
      exit
      ;;
esac
  
LANG="C" xsltproc -o ../mindex.html $xsl $srcdir/$xml
echo "$1 derlendi"
