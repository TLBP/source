<?xml version='1.0' encoding="UTF-8"?>
<!-- ********************************************************************
     $Id:belgetex.xsl,v 1.10 2003/07/10 20:27:40 nilgun Exp $
     ******************************************************************** -->

<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version='1.0'>

<xsl:param name="mainnode" select="document('../../../belgeler.xml')//*[@id=$mainid]"/>

<xsl:include href="xtpi.xsl"/>
<xsl:include href="xttoc.xsl"/>
<xsl:include href="xtdiv.xsl"/>
<xsl:include href="xtref.xsl"/>
<xsl:include href="xtindex.xsl"/>
<xsl:include href="xtxref.xsl"/>
<xsl:include href="xtinline.xsl"/>
<xsl:include href="xttitlepage.xsl"/>
<xsl:include href="xtblock.xsl"/>
<xsl:include href="xtlists.xsl"/>
<xsl:include href="xttable.xsl"/>

<xsl:key name="id" match="*" use="@id"/>

<xsl:variable name="iconprefix"
    select="concat($clsprefix, 'images/')"/>

<xsl:variable name="node.pdf">
  <xsl:call-template name="pi-attribute">
    <xsl:with-param name="pis" select="$mainnode/processing-instruction('dbpdf')"/>
    <xsl:with-param name="attribute">pdf</xsl:with-param>
  </xsl:call-template>
</xsl:variable>

<xsl:variable name="node.proclevel">
  <xsl:call-template name="pi-attribute">
    <xsl:with-param name="pis" select="$mainnode/processing-instruction('dbpdf')"/>
    <xsl:with-param name="attribute">stoplevel</xsl:with-param>
  </xsl:call-template>
</xsl:variable>

<xsl:variable name="node.toclimit">
  <xsl:call-template name="pi-attribute">
    <xsl:with-param name="pis" select="$mainnode/processing-instruction('dbpdf')"/>
    <xsl:with-param name="attribute">toclevel</xsl:with-param>
  </xsl:call-template>
</xsl:variable>

<xsl:template match="*">
  <xsl:message>
    <xsl:text>
İşlemsiz etiket: </xsl:text><xsl:value-of select="name(.)"/>
<!-- [colspec] -->
  </xsl:message>
</xsl:template>
<xsl:template match="atomEntry|articleinfo|authorinitials|
  bookinfo|colspec|date|dicterm|dictionary|partinfo|refmeta|remark|
  revnumber|revremark|setinfo|subtitle|textobject|
  title|titleabbrev"/>

<xsl:template match="*" mode="man-ozel"/>
<xsl:template match="*" mode="doctitle"/>
<xsl:template match="*" mode="titlemode"/>
<xsl:template match="*" mode="titlepage"/>
<xsl:template match="*" mode="abstract"/>
<xsl:template match="*" mode="secondpage"/>
<xsl:template match="*" mode="copyright"/>
<xsl:template match="*" mode="legal"/>
<xsl:template match="*" mode="article.mode"/>
<xsl:template match="*" mode="biblio"/>

<xsl:template match="/">
<!--xsl:message><xsl:text>aloo </xsl:text><xsl:value-of select="$mainid"/>=<xsl:value-of select="count(./*/*)"/></xsl:message-->
  <xsl:if test="$node.pdf != 'no'">
    <xsl:variable name="node" select="$mainnode"/>
    <xsl:apply-templates select="$node"/>
  </xsl:if>
</xsl:template>

<xsl:template name="belge">
  <xsl:variable name="rfctitle">
    <xsl:if test="name(.) = 'article' and starts-with(@id, 'rfc')">
      <xsl:apply-templates select="." mode="subtitle"/>
    </xsl:if>
  </xsl:variable>
  <xsl:variable name="subtitle">
    <xsl:if test="not (name(.) = 'article' and starts-with(@id, 'rfc'))">
      <xsl:apply-templates select="." mode="subtitle"/>
    </xsl:if>
  </xsl:variable>
  <xsl:variable name="title">
    <xsl:apply-templates select="." mode="xref-to"/>
  </xsl:variable>
<!-- ,baseurl=http://belgeler.org/ -->
<xsl:text>\documentclass[oneside,dvipdfm]{belgeler}
\usepackage{anysize,array,lastpage,fancyhdr}
\usepackage[unicode,bookmarks=false,linkbordercolor=0 0 0,filebordercolor=0 0 0,urlbordercolor=0 0 0,pdfstartview=FitH]{hyperref}
\marginsize{2.54cm}{1.27cm}{1.27cm}{1.27cm}
\renewcommand{\familydefault}{\sfdefault}
\pagestyle{fancy}
\linespread{1.05}
\fancyhead{}
\fancyfoot[RO]{\thepage\ /\ \pageref{LastPage}}
\fancyfoot[LO]{\URL{http://belgeler.org}}
\fancyfoot[CO]{Linux Kitaplığı}
\renewcommand{\headrulewidth}{1pt}
\renewcommand{\footrulewidth}{1pt}</xsl:text>
  <xsl:if test="$rfctitle = ''">
<xsl:text>
\fancyhead[CO]{\nouppercase{\boldface{</xsl:text>
    <xsl:value-of select="$title"/>
    <xsl:text>}}}</xsl:text>
  </xsl:if>
  <xsl:if test="$rfctitle != ''">
<xsl:text>
\fancyhead[LO]{\nouppercase{\boldface{</xsl:text>
    <xsl:value-of select="$rfctitle"/>
<xsl:text>}}}
\fancyhead[RO]{\nouppercase{\boldface{</xsl:text>
    <xsl:value-of select="$rfctitle"/>
    <xsl:text>}}}</xsl:text>
  </xsl:if>
<xsl:text>
\input epsf.tex

\begin{document}
\global\indentwdt0pt
\global\indentedwdt\linewidth</xsl:text>
<xsl:value-of select="concat('&#10;\title{\titleface{', normalize-space($rfctitle), '\\', normalize-space($title), '}\vskip6pt\subtitleface{', normalize-space($subtitle), '}}')"/>
<xsl:apply-templates mode="titlepage"/>
<xsl:text>
\maketitle
\thispagestyle{empty}</xsl:text>
  <xsl:apply-templates mode="abstract"/>
  <xsl:variable name="toc">
    <xsl:call-template name="toc"/>
  </xsl:variable>
  <xsl:if test="$toc != ''">
    <xsl:value-of select="$toc"/>
    <xsl:if test="(.//ulink[@url='fdl.html'])
                and not (name(.) = 'set' or name(.) = 'book')">
<xsl:text>
\dottedtocline{0em}{\innerURL{\hyperlink{gfdl}{GNU Free Documentation License}}}{\pageref*{gfdl}}</xsl:text>
    </xsl:if>
<xsl:text>
\newpage</xsl:text>
  </xsl:if>
  <xsl:apply-templates mode="secondpage"/>
  <xsl:apply-templates mode="copyright"/>
  <xsl:apply-templates mode="legal"/>
  <xsl:if test="$toc != ''">
<xsl:text>
\newpage</xsl:text>
  </xsl:if>
  <xsl:apply-templates/>
  <xsl:if test="(.//ulink[@url='fdl.html'])
                and not (name(.) = 'set' or name(.) = 'book')">
<xsl:text>
\input gfdl.ltx</xsl:text>
  </xsl:if>
<xsl:call-template name="backnotes"/>
<xsl:text>
\indentwdt.5\linewidth\indentedpar{\small\rm Bu dosya (</xsl:text>
    <xsl:call-template name="texize">
      <xsl:with-param name="t"  select="$mainid"/>
    </xsl:call-template>
<xsl:text>.pdf), belgenin XML biçiminin \TeX Live ve belgeler-xsl paketlerindeki araçlar kullanılarak PDF biçimine dönüştürülmesiyle elde edilmiştir.}
\rightline{\rm\today}
\end{document}
</xsl:text>
</xsl:template>

<xsl:template name="manpage">
<xsl:text>\documentclass[oneside,dvipdfm]{belgeler}
\usepackage{anysize,array,lastpage,fancyhdr}
\usepackage[unicode,bookmarks=false,linkbordercolor=0 0 0,filebordercolor=0 0 0,urlbordercolor=0 0 0,pdfstartview=FitH]{hyperref}
\marginsize{2.54cm}{1.27cm}{1.27cm}{1.27cm}
\renewcommand{\familydefault}{\sfdefault}
\pagestyle{fancy}
\linespread{1.05}
\fancyhead{}
\fancyfoot{}
\renewcommand{\headrulewidth}{.2pt}
\renewcommand{\footrulewidth}{.2pt}
\fancyfoot[RO]{\thepage\ /\ \pageref{LastPage}}
\fancyfoot[LO]{\URL{http://belgeler.org}}
\fancyfoot[CO]{Linux Kitaplığı}
\fancyhead[CO]{</xsl:text>
<xsl:value-of select="refmeta/refmiscinfo[@class='header']"/>
<xsl:text>}
\fancyhead[LO]{\boldface{</xsl:text>
<xsl:value-of select="refmeta/refentrytitle"/>
<xsl:text>(</xsl:text>
<xsl:value-of select="refmeta/manvolnum"/>
<xsl:text>)}}
\fancyhead[RO]{\boldface{</xsl:text>
<xsl:value-of select="refmeta/refentrytitle"/>
<xsl:text>(</xsl:text>
<xsl:value-of select="refmeta/manvolnum"/>
<xsl:text>)}}\input epsf.tex

\begin{document}
\global\indentedwdt\linewidth

\newpage
</xsl:text>
  <xsl:apply-templates/>
<xsl:text>
\refsectone{YASAL UYARI}
\enhanceindent\vspace{-9pt}
\indentedpar{Bu çevirinin telif hakkı yukarıda belirtilen çevirmen(ler)e aittir. Özgün belgenin telif hakkı ve lisans bilgileri varsa ve belge içinde belirtilmemişse belge sonunda belirtilmiş olacaktır. Bu çevirinin lisansı, özgün belge için belirtilmiş bir lisans varsa ve bu lisans çevirinin de aynı lisansa sahip olmasını gerektiriyorsa onunla aynıdır, yoksa GNU GPL lisansı ve her iki durumda da ek olarak aşağıdaki koşullar geçerlidir. GNU GPL lisansı &lt;\URLtext{http://www.gnu.org/licenses/gpl.html}> adresinden edinilebilir.}
\indentedpar{BU BELGE ÜCRETSİZ OLARAK RUHSATLANDIĞI İÇİN, BELGENİN İÇERDİĞİ BİLGİLERİN VEYA KODLARIN NİTELİKLERİ İÇİN İLGİLİ KANUNLARIN İZİN VERDİĞİ ÖLÇÜDE HERHANGİ BİR GARANTİ VERİLMEMEKTEDİR. AKSİ YAZILI OLARAK BELİRTİLMEDİĞİ MÜDDETÇE TELİF HAKKI SAHİPLERİ VE/VEYA BAŞKA ŞAHISLAR BELGELERİ "OLDUĞU GİBİ", AŞİKAR VEYA ZIMNEN, SATILABİLİRLİĞİ VEYA HERHANGİ BİR AMACA UYGUNLUĞU DA DAHİL OLMAK ÜZERE HİÇBİR GARANTİ VERMEKSİZİN DAĞITMAKTADIRLAR. BELGELERİN KALİTESİ VEYA PERFORMANSI İLE İLGİLİ TÜM SORUNLAR SİZE AİTTİR. HERHANGİ BİR HATA VEYA EKSİKLİKTEN DOLAYI DOĞABİLECEK OLAN BÜTÜN SERVİS, TAMİR VEYA DÜZELTME MASRAFLARI SİZE AİTTİR.}
\indentedpar{İLGİLİ KANUNUN İCBAR ETTİĞİ DURUMLAR VEYA YAZILI ANLAŞMA HARİCİNDE HERHANGİ BİR ŞEKİLDE TELİF HAKKI SAHİBİ VEYA YUKARIDA İZİN VERİLDİĞİ ŞEKİLDE BELGEYİ DEĞİŞTİREN VEYA YENİDEN DAĞITAN HERHANGİ BİR KİŞİ, BELGENİN İÇERDİĞİ BİLGİNİN KULLANIMI VEYA KULLANILAMAMASI (VEYA VERİ KAYBI OLUŞMASI, VERİNİN YANLIŞ HALE GELMESİ, SİZİN VEYA ÜÇÜNCÜ ŞAHISLARIN ZARARA UĞRAMASI VEYA BİLGİNİN BAŞKA BİLGİLERLE UYUMSUZ OLMASI) YÜZÜNDEN OLUŞAN GENEL, ÖZEL, DOĞRUDAN YA DA DOLAYLI HERHANGİ BİR ZARARDAN, BÖYLE BİR TAZMİNAT TALEBİ TELİF HAKKI SAHİBİ VEYA İLGİLİ KİŞİYE BİLDİRİLMİŞ OLSA DAHİ, SORUMLU DEĞİLDİR.}
</xsl:text>
  <xsl:variable name="volnum">
    <xsl:value-of select="refmeta/manvolnum"/>
  </xsl:variable>
  <xsl:variable name="im">
    <xsl:value-of select="concat('man', $volnum, '-')"/>
  </xsl:variable>
  <xsl:variable name="fname">
    <xsl:call-template name="texize">
      <xsl:with-param name="t"  select="substring-after($mainid, $im)"/>
    </xsl:call-template>
  </xsl:variable>
<xsl:variable name="comm">
  <xsl:apply-templates mode="man-ozel"/>
</xsl:variable>
<xsl:if test="normalize-space($comm) != ''">
<xsl:text>
\reduceindent
\refsectone{Özgün belgedeki telif hakkı beyanı}
\enhanceindent\vspace{-9pt}\indentedpar{
</xsl:text>
  <xsl:value-of select="normalize-space($comm)"/>
<xsl:text>}</xsl:text>
</xsl:if>
<xsl:text>
\reduceindent
\vspace{24pt}\hrule
\leftline{</xsl:text>
<xsl:value-of select="refmeta/refmiscinfo[@class='domain']"/>
<xsl:text>\strut\hspace{\stretch{1}}</xsl:text>
<xsl:value-of select="refmeta/refmiscinfo[@class='date']"/>
<xsl:text>\strut\hspace{\stretch{1}}</xsl:text>
<xsl:value-of select="refmeta/refentrytitle"/>
<xsl:text>(</xsl:text>
<xsl:value-of select="refmeta/manvolnum"/>
<xsl:text>)}
\indentwdt.5\linewidth\indentedpar{\small\rm Bu dosya (</xsl:text>
<xsl:value-of select="concat($im, $fname, '.pdf')"/><xsl:text>), belgenin XML biçiminin \TeX Live ve belgeler-xsl paketlerindeki araçlar kullanılarak PDF biçimine dönüştürülmesiyle elde edilmiştir.}
\indentedpar{\small\rm Konsol görüntüsünü temsil eden sarı zeminli alanlarda metin genişliğine sığmayan satırların sığmayan kısmı \tuserinput{¬} karakteri kullanılarak bir alt satıra indirilmiştir. Sarı zeminli alanlarda \tuserinput{¬} karakteri ile başlayan satırlar bir önceki satırın devamı olarak ele alınmalıdır.}
\rightline{\rm\today}
\end{document}
</xsl:text>
</xsl:template>

<xsl:template match="text()" name="texize">
  <xsl:param name="t" select="."/>

  <xsl:variable name="t1"> <!-- \ => a -->
    <xsl:call-template name="string.replace">
      <xsl:with-param name="string" select="$t"/>
      <xsl:with-param name="target" select="'\'"/>
      <xsl:with-param name="replace" select="'&lt;a/>'"/>
    </xsl:call-template>
  </xsl:variable>
  <xsl:variable name="t2"> <!-- % => b -->
    <xsl:call-template name="string.replace">
      <xsl:with-param name="string" select="$t1"/>
      <xsl:with-param name="target" select="'%'"/>
      <xsl:with-param name="replace" select="'&lt;b/>'"/>
    </xsl:call-template>
  </xsl:variable>
  <xsl:variable name="t3"> <!-- # => c -->
    <xsl:call-template name="string.replace">
      <xsl:with-param name="string" select="$t2"/>
      <xsl:with-param name="target" select="'#'"/>
      <xsl:with-param name="replace" select="'&lt;c/>'"/>
    </xsl:call-template>
  </xsl:variable>
  <xsl:variable name="t4"> <!-- _ => d -->
    <xsl:call-template name="string.replace">
      <xsl:with-param name="string" select="$t3"/>
      <xsl:with-param name="target" select="'_'"/>
      <xsl:with-param name="replace" select="'&lt;d/>'"/>
    </xsl:call-template>
  </xsl:variable>
  <xsl:variable name="t5"> <!-- { => e -->
    <xsl:call-template name="string.replace">
      <xsl:with-param name="string" select="$t4"/>
      <xsl:with-param name="target" select="'{'"/>
      <xsl:with-param name="replace" select="'&lt;e/>'"/>
    </xsl:call-template>
  </xsl:variable>
  <xsl:variable name="t6"> <!-- } => f -->
    <xsl:call-template name="string.replace">
      <xsl:with-param name="string" select="$t5"/>
      <xsl:with-param name="target" select="'}'"/>
      <xsl:with-param name="replace" select="'&lt;f/>'"/>
    </xsl:call-template>
  </xsl:variable>
  <xsl:variable name="t7"> <!-- &amp; => g -->
    <xsl:call-template name="string.replace">
      <xsl:with-param name="string" select="$t6"/>
      <xsl:with-param name="target" select="'&amp;'"/>
      <xsl:with-param name="replace" select="'&lt;g/>'"/>
    </xsl:call-template>
  </xsl:variable>
  <xsl:variable name="t8"> <!-- $ => h -->
    <xsl:call-template name="string.replace">
      <xsl:with-param name="string" select="$t7"/>
      <xsl:with-param name="target" select="'$'"/>
      <xsl:with-param name="replace" select="'&lt;h/>'"/>
    </xsl:call-template>
  </xsl:variable>
  <xsl:variable name="t9"> <!-- - => i -->
    <xsl:call-template name="string.replace">
      <xsl:with-param name="string" select="$t8"/>
      <xsl:with-param name="target" select="'-'"/>
      <xsl:with-param name="replace" select="'&lt;i/>'"/>
    </xsl:call-template>
  </xsl:variable>
  <xsl:variable name="ta"> <!-- ~ => j -->
    <xsl:call-template name="string.replace">
      <xsl:with-param name="string" select="$t9"/>
      <xsl:with-param name="target" select="'~'"/>
      <xsl:with-param name="replace" select="'&lt;j/>'"/>
    </xsl:call-template>
  </xsl:variable>
  <xsl:variable name="tb"> <!-- ^ => k -->
    <xsl:call-template name="string.replace">
      <xsl:with-param name="string" select="$ta"/>
      <xsl:with-param name="target" select="'^'"/>
      <xsl:with-param name="replace" select="'&lt;k/>{}'"/>
    </xsl:call-template>
  </xsl:variable>
  <xsl:variable name="tc"> <!-- ´ => ''' -->
    <xsl:call-template name="string.replace">
      <xsl:with-param name="string" select="$tb"/>
      <xsl:with-param name="target" select="'´'"/>
      <xsl:with-param name="replace" select="'&lt;l/>{}'"/>
    </xsl:call-template>
  </xsl:variable>
  <xsl:value-of select="$tc"/>
</xsl:template>

<xsl:template name="url.texize">
  <xsl:param name="t" select="@url"/>
  <xsl:variable name="adres4">
    <xsl:call-template name="texize">
      <xsl:with-param name="t" select="$t"/>
    </xsl:call-template>
  </xsl:variable>
  <xsl:variable name="adres3">
    <xsl:call-template name="string.replace">
      <xsl:with-param name="string" select="$adres4"/>
      <xsl:with-param name="target" select="'&lt;e/>'"/>
      <xsl:with-param name="replace" select="'{'"/>
    </xsl:call-template>
  </xsl:variable>
  <xsl:variable name="adres2">
    <xsl:call-template name="string.replace">
      <xsl:with-param name="string" select="$adres3"/>
      <xsl:with-param name="target" select="'&lt;f/>'"/>
      <xsl:with-param name="replace" select="'}'"/>
    </xsl:call-template>
  </xsl:variable>
  <xsl:variable name="adres1">
    <xsl:call-template name="string.replace">
      <xsl:with-param name="string" select="$adres2"/>
      <xsl:with-param name="target" select="'&lt;i/>'"/>
      <xsl:with-param name="replace" select="'-'"/>
    </xsl:call-template>
  </xsl:variable>
  <xsl:variable name="adres0">
    <xsl:call-template name="string.replace">
      <xsl:with-param name="string" select="$adres1"/>
      <xsl:with-param name="target" select="'&lt;j/>'"/>
      <xsl:with-param name="replace" select="'\~'"/>
    </xsl:call-template>
  </xsl:variable>
  <xsl:call-template name="string.replace">
    <xsl:with-param name="string" select="$adres0"/>
    <xsl:with-param name="target" select="'&lt;g/>'"/>
    <xsl:with-param name="replace" select="'&amp;'"/>
  </xsl:call-template>
</xsl:template>

<xsl:template name="string.replace">
  <xsl:param name="string"></xsl:param>
  <xsl:param name="target"></xsl:param>
  <xsl:param name="replace"></xsl:param>
  <xsl:choose>
    <xsl:when test="contains($string,$target)">
      <xsl:value-of select="concat(substring-before($string,$target),$replace)"/>
      <xsl:call-template name="string.replace">
        <xsl:with-param name="string" select="substring-after($string,$target)"/>
        <xsl:with-param name="target" select="$target"/>
        <xsl:with-param name="replace" select="$replace"/>
      </xsl:call-template>
    </xsl:when>
    <xsl:otherwise>
      <xsl:value-of select="$string"/>
    </xsl:otherwise>
  </xsl:choose>
</xsl:template>

<xsl:template name="make.spcstr">
  <xsl:param name="length"></xsl:param>
  <xsl:param name="spcstr" select="'~'"/>
  <xsl:choose>
    <xsl:when test="string-length($spcstr) &lt; $length">
      <xsl:call-template name="make.spcstr">
        <xsl:with-param name="length" select="$length"/>
        <xsl:with-param name="spcstr" select="concat($spcstr, '~')"/>
      </xsl:call-template>
    </xsl:when>
    <xsl:otherwise>
      <xsl:value-of select="$spcstr"/>
    </xsl:otherwise>
  </xsl:choose>
</xsl:template>

<xsl:template name="object.id">
  <xsl:param name="object" select="."/>
  <xsl:choose>
    <xsl:when test="$object/@id">
      <xsl:value-of select="$object/@id"/>
    </xsl:when>
    <xsl:otherwise>
      <xsl:variable name="objid1">
        <xsl:text>id</xsl:text>
        <xsl:if test="($object/ancestor-or-self::indexterm)">
          <xsl:number level="any" count="indexterm" format="1"/>
        </xsl:if>
        <xsl:if test="($object/ancestor-or-self::production)">
          <xsl:number level="any" count="production" format="1"/>
        </xsl:if>
        <xsl:if test="($object/ancestor-or-self::qandaentry)">
          <xsl:number level="any" count="qandaentry" format="1"/>
        </xsl:if>
      </xsl:variable>
      <xsl:variable name="objid0">
        <xsl:value-of select="concat($objid1, 'a')"/>
        <xsl:if test="string-length($objid1) &lt; 3">
          <xsl:if test="($object/ancestor-or-self::formalpara)">
            <xsl:number level="any" count="formalpara" format="1"/>
          </xsl:if>
          <xsl:if test="($object/ancestor-or-self::simplesect)">
            <xsl:number level="any" count="simplesect" format="1"/>
          </xsl:if>
          <xsl:if test="($object/ancestor-or-self::section)">
            <xsl:number level="any" count="section" format="1"/>
            <!-- Linux Kitaplığında ardışık section kullanılmıyor
                  Kullanırsak bakarız çaresine... -->
          </xsl:if>
          <xsl:if test="($object/ancestor-or-self::bridgehead)">
            <xsl:number level="any" count="bridgehead" format="1"/>
          </xsl:if>
          <xsl:if test="($object/ancestor-or-self::sect5)">
            <xsl:number level="any" count="sect5" format="1"/>
          </xsl:if>
          <xsl:if test="($object/ancestor-or-self::sect4)">
            <xsl:number level="any" count="sect4" format="1"/>
          </xsl:if>
          <xsl:if test="($object/ancestor-or-self::sect3)">
            <xsl:number level="any" count="sect3" format="1"/>
          </xsl:if>
          <xsl:if test="($object/ancestor-or-self::sect2)">
            <xsl:number level="any" count="sect2" format="1"/>
          </xsl:if>
          <xsl:if test="($object/ancestor-or-self::sect1)">
            <xsl:number level="any" count="sect1" format="1"/>
          </xsl:if>
          <xsl:if test="($object/ancestor-or-self::refsect3)">
            <xsl:number level="any" count="refsect3" format="1"/>
          </xsl:if>
          <xsl:if test="($object/ancestor-or-self::refsect2)">
            <xsl:number level="any" count="refsect2" format="1"/>
          </xsl:if>
          <xsl:if test="($object/ancestor-or-self::refsect1)">
            <xsl:number level="any" count="refsect1" format="1"/>
          </xsl:if>
        </xsl:if>
      </xsl:variable>
      <xsl:variable name="objid">
        <xsl:value-of select="concat($objid0, 'b')"/>
        <xsl:if test="string-length($objid0) &lt; 4">
          <xsl:if test="($object/ancestor-or-self::refentry)">
            <xsl:number level="any" count="refentry" format="1"/>
          </xsl:if>
          <xsl:if test="($object/ancestor::glossary)">
            <xsl:number level="any" count="glossary" format="1"/>
          </xsl:if>
          <xsl:if test="($object/ancestor::colophon)">
            <xsl:number level="any" count="colophon" format="1"/>
          </xsl:if>
          <xsl:if test="($object/ancestor::bibliography)">
            <xsl:number level="any" count="bibliography" format="1"/>
          </xsl:if>
          <xsl:if test="($object/ancestor::index)">
            <xsl:number level="any" count="index" format="1"/>
          </xsl:if>
          <xsl:if test="($object/ancestor::preface)">
            <xsl:number level="any" count="preface" format="1"/>
          </xsl:if>
          <xsl:if test="($object/ancestor::appendix)">
            <xsl:number level="any" count="appendix" format="1"/>
          </xsl:if>
          <xsl:if test="($object/ancestor::setindex)">
            <xsl:number level="any" count="setindex" format="1"/>
          </xsl:if>
          <xsl:if test="($object/ancestor::dictionary)">
            <xsl:number level="any" count="dictionary" format="1"/>
          </xsl:if>
          <xsl:if test="($object/ancestor::dictionary)">
            <xsl:number level="any" count="dictionary" format="1"/>
          </xsl:if>
          <xsl:if test="($object/ancestor-or-self::chapter)">
            <xsl:number level="any" count="chapter" format="1"/>
          </xsl:if>
          <xsl:if test="($object/ancestor-or-self::article)">
            <xsl:number level="any" count="article" format="1"/>
          </xsl:if>
          <xsl:if test="($object/ancestor-or-self::reference)">
            <xsl:number level="any" count="reference" format="1"/>
          </xsl:if>
          <xsl:if test="($object/ancestor-or-self::part)">
            <xsl:number level="any" count="part" format="1"/>
          </xsl:if>
          <xsl:if test="($object/ancestor-or-self::book)">
            <xsl:number level="any" count="book" format="1"/>
          </xsl:if>
        </xsl:if>
      </xsl:variable>
      <xsl:value-of select="$objid"/>
    </xsl:otherwise>
  </xsl:choose>
</xsl:template>

<xsl:template name="fn.id">
  <xsl:param name="object" select="."/>
  <xsl:if test="($object/ancestor-or-self::footnote)">
    <xsl:choose>
      <xsl:when test="name($mainnode) = 'book'">
        <xsl:number from="book" level="any" count="footnote" format="1"/>
      </xsl:when>
      <xsl:when test="name($mainnode) = 'part'">
        <xsl:number from="part" level="any" count="footnote" format="1"/>
      </xsl:when>
      <xsl:when test="name($mainnode) = 'article'">
        <xsl:number from="article" level="any" count="footnote" format="1"/>
      </xsl:when>
    </xsl:choose>
  </xsl:if>
</xsl:template>

<xsl:template name="link.id">
  <xsl:choose>
    <xsl:when test="name($mainnode) = 'set'">
      <xsl:number from="set" level="any" count="link|ulink|xref"/>
    </xsl:when>
    <xsl:when test="name($mainnode) = 'book'">
      <xsl:number from="book" level="any" count="link|ulink|xref"/>
    </xsl:when>
    <xsl:when test="name($mainnode) = 'part'">
      <xsl:number from="part" level="any" count="link|ulink|xref"/>
    </xsl:when>
    <xsl:when test="name($mainnode) = 'article'">
      <xsl:number from="article" level="any" count="link|ulink|xref"/>
    </xsl:when>
  </xsl:choose>
</xsl:template>

</xsl:stylesheet>
