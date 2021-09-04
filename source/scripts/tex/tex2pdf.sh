# kullanim: ./tex2pdf doc_id
export TEXINPUTS=".:../htdocs/source/docbook/xsl/tex:"
latex -interaction=scrollmode $1
latex -interaction=scrollmode $1
latex -interaction=scrollmode $1
dvipdfmx -V5 -o belge/$1.pdf $1
rm -f *.log
rm -f *.dvi
rm -f *.aux
rm -f *.tmp
#rm -f *.tex
