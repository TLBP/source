#!/bin/sh
# İlk argüman olarak belgenin belgeler.xml ağacındaki id'si,
# ikinci argüman olarak derleme türü verilirse belgeyi derler.
# Derleme türü için verilebilecek degerler:
# 1. Hiçbir şey vermezsiniz: id'si verilen düğümün altında ne varsa derlenir 
# 2. head: id'si verilen belgenin sadece başsayfaları derlenir.
# Derleme türü olarak head değeri verileblecek id'ler:
# index, apps, aik, howtos, manpages, bashref, glibc
# 
xsltproc --stringparam mainid $1 --stringparam onlyhead $2 belgeler-xslt.xml
