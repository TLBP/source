<?xml version='1.0' encoding="UTF-8"?>
<!-- ********************************************************************
     $Id:xtmakale.xsl,v 1.10 2003/07/10 20:27:40 nilgun Exp $
     ******************************************************************** -->

<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
                xmlns:doc="http://exslt.org/common"
                extension-element-prefixes="doc"
                version='1.0'>



<xsl:template name="numbered.lines">
  <xsl:param name="string"></xsl:param>
  <xsl:param name="target"></xsl:param>
  <xsl:param name="linenum"></xsl:param>
  <xsl:choose>
    <xsl:when test="contains($string,$target)">
      <xsl:value-of select="concat(substring-before($string,$target),'\\&#10;', string($linenum), ' &amp; ')"/>
      <xsl:call-template name="string.replace">
        <xsl:with-param name="string" select="substring-after($string,$target)"/>
        <xsl:with-param name="target" select="$target"/>
        <xsl:with-param name="linenum" select="$linenum + 1"/>
      </xsl:call-template>
    </xsl:when>
    <xsl:otherwise>
      <xsl:value-of select="$string"/>
    </xsl:otherwise>
  </xsl:choose>
</xsl:template>

<xsl:template name="trimleft">
  <xsl:param name="string"></xsl:param>
  <xsl:choose>
    <xsl:when test="contains($string, '&#10; ')">
      <xsl:call-template name="trimleft">
        <xsl:with-param name="string" select="concat(substring-before($string, '&#10; '), '&#10;', substring-after($string,'&#10; '))"/>
      </xsl:call-template>
    </xsl:when>
    <xsl:otherwise>
      <xsl:value-of select="$string"/>
    </xsl:otherwise>
  </xsl:choose>
</xsl:template>


<xsl:template match="set|book|part|reference|article">
  <xsl:choose>
    <xsl:when test="@id=$mainid">
      <xsl:call-template name="belge"/>
      <!--xsl:message>
        <xsl:text>Hepsi: </xsl:text>
        <xsl:value-of select="count(.//indexterm)"/>
        <xsl:text>ilki: </xsl:text>
        <xsl:apply-templates select=".//indexterm[1]"/>
        <xsl:text>sonuncusu: </xsl:text>
        <xsl:apply-templates select=".//indexterm[last()]"/>
      </xsl:message-->
    </xsl:when>
    <xsl:otherwise>
      <xsl:variable name="title">
        <xsl:apply-templates select="." mode="xref-to"/>
      </xsl:variable>
      <xsl:variable name="label">
        <xsl:apply-templates select="." mode="label.markup"/>
      </xsl:variable>
      <xsl:choose>
        <xsl:when test="name(.) = 'part' and $node.proclevel != 'part'">
          <xsl:variable name="pos"><xsl:number/></xsl:variable>
<xsl:text>
\newpage\global\indentwdt0pt
\global\indentedwdt\linewidth
</xsl:text>
          <xsl:call-template name="anchor"/>
          <xsl:value-of select="concat('&#10;\chpter[', normalize-space($title),'][', $label,']')"/>
          <xsl:call-template name="anchor.label"/>
          <xsl:if test="(subtitle) or (partinfo/subtitle)">
            <xsl:text>&#10;\sectone[\itshape </xsl:text>
              <xsl:apply-templates select="." mode="subtitle"/>
            <xsl:text>]</xsl:text>
          </xsl:if>
          <xsl:apply-templates mode="abstract"/>
          <xsl:call-template name="book.toc"/>
          <xsl:if test="$node.proclevel = ''">
            <xsl:apply-templates/>
          </xsl:if>
        </xsl:when>
        <xsl:when test="name(.) = 'reference' and $node.proclevel != 'reference'">
<xsl:text>
\newpage\global\indentwdt0pt
\global\indentedwdt\linewidth
</xsl:text>
          <xsl:call-template name="anchor"/>
          <xsl:value-of select="concat('&#10;\chpter[', normalize-space($title),'][', $label,']')"/>
          <xsl:call-template name="anchor.label"/>
          <xsl:if test="(subtitle) or (referenceinfo/subtitle)">
            <xsl:text>&#10;\sectone[\itshape </xsl:text>
              <xsl:apply-templates select="." mode="subtitle"/>
            <xsl:text>]</xsl:text>
          </xsl:if>
          <xsl:apply-templates mode="abstract"/>
          <xsl:call-template name="refentry.toc">
            <xsl:with-param name="volnum">
              <xsl:value-of select="refnum"/>
            </xsl:with-param>
          </xsl:call-template>
        </xsl:when>
        <xsl:when test="name(.) = 'article' and $node.proclevel != 'article'">
          <xsl:call-template name="article"/>
        </xsl:when>
      </xsl:choose>
    </xsl:otherwise>
  </xsl:choose>
</xsl:template>

<xsl:template match="partintro">
  <xsl:if test="name(./*[1])='para'"><xsl:text>\strut</xsl:text></xsl:if>
  <xsl:apply-templates/>
</xsl:template>

<xsl:template match="refentry">
  <xsl:if test="@id=$mainid">
    <xsl:call-template name="manpage"/>
  </xsl:if>
</xsl:template>

<xsl:template match="preface|dedication">
<xsl:text>
\global\indentwdt0pt
\global\indentedwdt\linewidth</xsl:text>
  <xsl:variable name="makro">
    <xsl:choose>
      <xsl:when test="name(.) = 'preface'"><xsl:text>\chpter</xsl:text></xsl:when>
      <xsl:otherwise><xsl:text>\sectone</xsl:text></xsl:otherwise>
    </xsl:choose>
  </xsl:variable>
  <xsl:variable name="title">
    <xsl:apply-templates mode="titlemode"/>
  </xsl:variable>
  <xsl:call-template name="anchor"/>
  <xsl:value-of select="concat('&#10;', $makro, '[', normalize-space($title),']')"/>
  <xsl:if test="(@id)">
    <xsl:call-template name="anchor.label"/>
  </xsl:if>
  <xsl:if test="(subtitle)">
    <xsl:text>&#10;\secttwo[\itshape </xsl:text>
      <xsl:apply-templates select="." mode="subtitle"/>
    <xsl:text>]</xsl:text>
  </xsl:if>
  <xsl:if test="name(./*[1])='para'"><xsl:text>\strut</xsl:text></xsl:if>
  <xsl:apply-templates/>
</xsl:template>

<xsl:template match="chapter" name="article">
<xsl:if test="name(.) = 'article'">
<xsl:text>
\newpage</xsl:text>
</xsl:if>
<xsl:text>\global\indentwdt0pt
\global\indentedwdt\linewidth
</xsl:text>
  <xsl:variable name="makro">
    <xsl:choose>
      <xsl:when test="name(..)= 'book' or
                      (name($mainnode) = 'part' and name(..)='part')">
        <xsl:text>\chpter</xsl:text>
      </xsl:when>
      <xsl:when test="name($mainnode) = 'book' and name(..)='part'">
        <xsl:text>\sectone</xsl:text>
      </xsl:when>
    </xsl:choose>
  </xsl:variable>
  <xsl:variable name="title">
    <xsl:apply-templates mode="titlemode"/>
  </xsl:variable>
  <xsl:variable name="label">
    <xsl:apply-templates select="." mode="label.markup"/>
  </xsl:variable>
  <xsl:call-template name="anchor"/>
  <xsl:call-template name="anchor.label"/>
  <xsl:value-of select="concat('&#10;', $makro, '[', normalize-space($title),'][', $label,']')"/>
  <xsl:if test="(subtitle)">
    <xsl:text>&#10;\secttwo[\itshape </xsl:text>
      <xsl:apply-templates mode="subtitle"/>
    <xsl:text>]</xsl:text>
  </xsl:if>
  <xsl:if test="name(./*[1])='para'"><xsl:text>\strut</xsl:text></xsl:if>
  <xsl:apply-templates/>
</xsl:template>

<xsl:template match="sect1">
<xsl:text>
\global\indentwdt0pt
\global\indentedwdt\linewidth</xsl:text>
  <xsl:variable name="makro">
    <xsl:choose>
      <xsl:when test="(ancestor::appendix) or
                                 (ancestor::preface) or
                                 name($mainnode) = 'part' or
           (name($mainnode) = 'book' and name(../..) = 'book')">
        <xsl:text>\sectone</xsl:text>
      </xsl:when>
      <xsl:when test="name($mainnode) = 'article'">
        <xsl:text>\chpter</xsl:text>
      </xsl:when>
      <xsl:when test="name($mainnode) = 'book' and name(../..) = 'part'">
        <xsl:text>\secttwo</xsl:text>
      </xsl:when>
    </xsl:choose>
  </xsl:variable>
  <xsl:variable name="title">
    <xsl:apply-templates mode="titlemode"/>
  </xsl:variable>
  <xsl:variable name="label">
    <xsl:apply-templates select="." mode="label.markup"/>
  </xsl:variable>
  <xsl:call-template name="anchor"/>
  <xsl:call-template name="anchor.label"/>
  <xsl:value-of select="concat('&#10;', $makro, '[', normalize-space($title),'][', $label,']')"/>
  <xsl:if test="(subtitle)">
    <xsl:text>&#10;\sectthree[\itshape </xsl:text>
      <xsl:apply-templates select="." mode="subtitle"/>
    <xsl:text>]</xsl:text>
  </xsl:if>
  <xsl:if test="name(./*[1])='para'"><xsl:text>\strut</xsl:text></xsl:if>
  <xsl:apply-templates/>
</xsl:template>

<xsl:template match="sect2">
<xsl:text>
\global\indentwdt0pt
\global\indentedwdt\linewidth</xsl:text>
  <xsl:variable name="makro">
    <xsl:choose>
      <xsl:when test="(ancestor::appendix) or
                      (ancestor::preface) or
                       name($mainnode) = 'part' or
                (name($mainnode) = 'book' and name(../../..) = 'book')">
        <xsl:text>\secttwo</xsl:text>
      </xsl:when>
      <xsl:when test="name($mainnode) = 'article'">
        <xsl:text>\sectone</xsl:text>
      </xsl:when>
      <xsl:when test="name($mainnode) = 'book' and name(../../..) = 'part'">
        <xsl:text>\sectthree</xsl:text>
      </xsl:when>
    </xsl:choose>
  </xsl:variable>
  <xsl:variable name="title">
    <xsl:apply-templates mode="titlemode"/>
  </xsl:variable>
  <xsl:variable name="label">
    <xsl:apply-templates select="." mode="label.markup"/>
  </xsl:variable>
  <xsl:call-template name="anchor"/>
  <xsl:call-template name="anchor.label"/>
  <xsl:value-of select="concat('&#10;', $makro, '[', normalize-space($title),'][', $label,']')"/>
  <xsl:if test="(subtitle)">
    <xsl:text>&#10;\sectfour[\itshape </xsl:text>
      <xsl:apply-templates select="." mode="subtitle"/>
    <xsl:text>]</xsl:text>
  </xsl:if>
  <xsl:if test="name(./*[1])='para'"><xsl:text>\strut</xsl:text></xsl:if>
  <xsl:apply-templates/>
</xsl:template>

<xsl:template match="sect3">
  <xsl:variable name="makro">
    <xsl:choose>
      <xsl:when test="(ancestor::appendix) or
                      (ancestor::preface) or
                       name($mainnode) = 'part' or
           (name($mainnode) = 'book' and name(../../../..) = 'book')">
        <xsl:text>\sectthree</xsl:text>
      </xsl:when>
      <xsl:when test="name($mainnode) = 'article'">
        <xsl:text>\secttwo</xsl:text>
      </xsl:when>
      <xsl:when test="name($mainnode) = 'book' and name(../../../..) = 'part'">
        <xsl:text>\sectfour</xsl:text>
      </xsl:when>
    </xsl:choose>
  </xsl:variable>
  <xsl:variable name="title">
    <xsl:apply-templates mode="titlemode"/>
  </xsl:variable>
  <xsl:variable name="label">
    <xsl:apply-templates select="." mode="label.markup"/>
  </xsl:variable>
  <xsl:call-template name="anchor"/>
  <xsl:call-template name="anchor.label"/>
  <xsl:value-of select="concat('&#10;', $makro, '[', normalize-space($title),'][', $label,']')"/>
  <xsl:if test="(subtitle)">
    <xsl:text>&#10;\sectfive[\itshape </xsl:text>
      <xsl:apply-templates select="." mode="subtitle"/>
    <xsl:text>]</xsl:text>
  </xsl:if>
  <xsl:if test="name(./*[1])='para'"><xsl:text>\strut</xsl:text></xsl:if>
  <xsl:apply-templates/>
</xsl:template>

<xsl:template match="sect4">
  <xsl:variable name="makro">
    <xsl:choose>
      <xsl:when test="(ancestor::appendix) or
                      (ancestor::preface) or
                       name($mainnode) = 'part' or
           (name($mainnode) = 'book' and name(../../../../..) = 'book')">
        <xsl:text>\sectfour</xsl:text>
      </xsl:when>
      <xsl:when test="name($mainnode) = 'article'">
        <xsl:text>\sectthree</xsl:text>
      </xsl:when>
      <xsl:when test="name($mainnode) = 'book' and
                      name(../../../../..) = 'part'">
        <xsl:text>\sectfive</xsl:text>
      </xsl:when>
    </xsl:choose>
  </xsl:variable>
  <xsl:variable name="title">
    <xsl:apply-templates mode="titlemode"/>
  </xsl:variable>
  <xsl:variable name="label">
    <xsl:apply-templates select="." mode="label.markup"/>
  </xsl:variable>
  <xsl:call-template name="anchor"/>
  <xsl:call-template name="anchor.label"/>
  <xsl:value-of select="concat('&#10;', $makro, '[', normalize-space($title),'][', $label,']')"/>
  <xsl:if test="(subtitle)">
    <xsl:text>&#10;\sectfive[\itshape </xsl:text>
      <xsl:apply-templates select="." mode="subtitle"/>
    <xsl:text>]</xsl:text>
  </xsl:if>
  <xsl:if test="name(./*[1])='para'"><xsl:text>\strut</xsl:text></xsl:if>
  <xsl:apply-templates/>
</xsl:template>

<xsl:template match="sect5">
  <xsl:variable name="makro">
    <xsl:choose>
      <xsl:when test="name($mainnode) = 'article'">
        <xsl:text>\sectfour</xsl:text>
      </xsl:when><xsl:otherwise>
        <xsl:text>\sectfive</xsl:text>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:variable>
  <xsl:variable name="title">
    <xsl:apply-templates mode="titlemode"/>
  </xsl:variable>
  <xsl:variable name="label">
    <xsl:apply-templates select="." mode="label.markup"/>
  </xsl:variable>
  <xsl:call-template name="anchor"/>
  <xsl:call-template name="anchor.label"/>
  <xsl:value-of select="concat('&#10;', $makro, '[', normalize-space($title),'][', $label,']')"/>
  <xsl:if test="(subtitle)">
    <xsl:text>&#10;\sectfive[\itshape </xsl:text>
      <xsl:apply-templates select="." mode="subtitle"/>
    <xsl:text>]</xsl:text>
  </xsl:if>
  <xsl:if test="name(./*[1])='para'"><xsl:text>\strut</xsl:text></xsl:if>
  <xsl:apply-templates/>
</xsl:template>

<xsl:template match="appendix|bibliography|glossary">
<xsl:text>
\global\indentwdt0pt
\global\indentedwdt\linewidth</xsl:text>
  <xsl:if test="not (preceding-sibling::appendix or
                     preceding-sibling::bibliography or
                     preceding-sibling::glossary)">
<xsl:text>
\newpage</xsl:text>
  </xsl:if>
  <xsl:variable name="title">
    <xsl:apply-templates mode="titlemode"/>
  </xsl:variable>
  <xsl:variable name="label">
    <xsl:apply-templates select="." mode="label.markup"/>
  </xsl:variable>
  <xsl:call-template name="anchor"/>
  <xsl:call-template name="anchor.label"/>
  <xsl:value-of select="concat('&#10;\apendix[', normalize-space($title),'][', $label,']')"/>
  <xsl:if test="name(./*[1])='para'"><xsl:text>\strut</xsl:text></xsl:if>
  <xsl:apply-templates/>
</xsl:template>

<xsl:template match="index">
<xsl:text>
\global\indentwdt0pt
\global\indentedwdt\linewidth
\global\addindwdt14pt
\twocolumn</xsl:text>
  <xsl:variable name="content">
    <xsl:apply-templates mode="titlemode"/>
  </xsl:variable>
  <xsl:call-template name="anchor"/>
  <xsl:value-of select="concat('\sectone[', normalize-space($content),']')"/>
  <xsl:if test="(@id)">
    <xsl:call-template name="anchor.label"/>
  </xsl:if>
  <xsl:call-template name="generate-index">
    <xsl:with-param name="target" select="@id"/>
  </xsl:call-template>
<xsl:text>
\global\indentwdt0pt
\global\indentedwdt\linewidth
\onecolumn\global\addindwdt26pt</xsl:text>
</xsl:template>

<xsl:template match="bridgehead">
  <xsl:variable name="container"
                select="(ancestor::appendix
                        |ancestor::article
                        |ancestor::bibliography
                        |ancestor::glossary
                        |ancestor::index
                        |ancestor::sect1
                        |ancestor::sect2
                        |ancestor::sect3
                        |ancestor::sect4
                        |ancestor::sect5
                        |ancestor::simplesect)[last()]"/>

  <xsl:variable name="sname">
    <xsl:choose>
      <xsl:when test="local-name($container) = 'article'
                      or @renderas='sect1'">
        <xsl:text>\chpter</xsl:text>
      </xsl:when>
      <xsl:when test="local-name($container) = 'appendix'
                      or local-name($container) = 'sect1'
                      or local-name($container) = 'bibliography'
                      or local-name($container) = 'glossary'
                      or local-name($container) = 'index'
                      or @renderas='sect2'">
        <xsl:text>\sectone</xsl:text>
      </xsl:when>
      <xsl:when test="local-name($container) = 'sect2'
                      or @renderas='sect3'">
        <xsl:text>\secttwo</xsl:text>
      </xsl:when>
      <xsl:when test="local-name($container) = 'sect3'
                      or @renderas='sect4'">
        <xsl:text>\sectthree</xsl:text>
      </xsl:when>
      <xsl:when test="local-name($container) = 'sect4'
                      or @renderas='sect5'">
        <xsl:text>\sectfour</xsl:text>
      </xsl:when>
      <xsl:when test="local-name($container) = 'sect5'
           or local-name($container) = 'simplesect'">
        <xsl:text>\sectfive</xsl:text>
      </xsl:when>
    </xsl:choose>
  </xsl:variable>
  <xsl:variable name="title">
    <xsl:apply-templates/>
  </xsl:variable>
  <xsl:call-template name="anchor"/>
  <xsl:value-of select="concat('&#10;', $sname, '[\textcolor{hlcolor}{', normalize-space($title),'}]')"/>
  <xsl:if test="(@id)">
    <xsl:call-template name="anchor.label"/>
  </xsl:if>
  <xsl:if test="name(./*[1])='para'"><xsl:text>\strut</xsl:text></xsl:if>
</xsl:template>

<xsl:template name="backnotes">
<xsltext>
\chpter[Notlar]
\setcounter{backnote}{0}
\enhanceindent
\itempar{a) }{Belge içinde dipnotlar ve dış bağlantılar varsa, bunlarla ilgili bilgiler bulundukları sayfanın sonunda dipnot olarak verilmeyip, hepsi toplu olarak burada listelenmiş olacaktır.}
\itempar{b) }{Konsol görüntüsünü temsil eden sarı zeminli alanlarda metin genişliğine sığmayan satırların sığmayan kısmı \tuserinput{¬} karakteri kullanılarak bir alt satıra indirilmiştir. Sarı zeminli alanlarda \tuserinput{¬} karakteri ile başlayan satırlar bir önceki satırın devamı olarak ele alınmalıdır.}
</xsltext>
  <xsl:variable name="notes" select=".//ulink|.//link|.//xref|.//footnote"/>
  <xsl:apply-templates select="$notes" mode="back.notes"/>
<xsl:text>
\reduceindent
</xsl:text>
</xsl:template>

<xsl:template mode="back.notes" match="*"/>

<xsl:template mode="back.notes" match="footnote">
  <xsl:variable name="is.outernode">
    <xsl:call-template name="is_outernode"/>
  </xsl:variable>
  <xsl:if test="$is.outernode != 'yes'">
    <xsl:variable name="is.innerURL">
      <xsl:call-template name="fn.id"/>
    </xsl:variable>
    <xsl:variable name="objid">
      <xsl:call-template name="fn.id"/>
    </xsl:variable>
    <xsl:value-of select="concat('\hypertarget{bn', $objid,'}{}\label{bn', $objid,'}')"/>
    <xsl:choose>
      <xsl:when test="(para)">
        <xsl:value-of select="concat('&#10;\itempar{\backnotetarget{', $objid, '}}')"/>
        <xsl:apply-templates/>
      </xsl:when>
      <xsl:otherwise>
        <xsl:value-of select="concat('&#10;\vspace{-3pt}\itempar{\backnotetarget{', $objid, '}}{')"/>
        <xsl:apply-templates/><xsl:text>}</xsl:text>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:text>\footnoterule</xsl:text>
  </xsl:if>
</xsl:template>

<xsl:template mode="back.notes" match="ulink">
  <xsl:variable name="is.outernode">
    <xsl:call-template name="is_outernode"/>
  </xsl:variable>
  <xsl:if test="$is.outernode != 'yes'">
    <xsl:if test="(count(child::node())!=0)  and
                  not (contains(@url,'fdl.html')) and
                  not (contains(@url,'mailto:'))">
      <xsl:variable name="objid">
        <xsl:call-template name="link.id"/>
      </xsl:variable>
      <xsl:variable name="adres">
        <xsl:call-template name="url.texize"/>
      </xsl:variable>
      <xsl:value-of select="concat('\hypertarget{obn', $objid,'}{}\label{obn', $objid,'}')"/>
      <xsl:value-of select="concat('&#10;\vspace{-3pt}\itempar{\otherbacknotetarget{', $objid, '}}{\URL{', $adres, '}}')"/>
      <xsl:text>\footnoterule</xsl:text>
    </xsl:if>
  </xsl:if>
</xsl:template>

<xsl:template mode="back.notes" match="link|xref">
  <xsl:variable name="is.outernode">
    <xsl:call-template name="is_outernode"/>
  </xsl:variable>
  <xsl:if test="$is.outernode != 'yes'">
    <xsl:variable name="targets" select="key('id',@linkend)"/>
    <xsl:variable name="target" select="$targets[1]"/>
    <xsl:variable name="is.innerURL">
      <xsl:call-template name="is_innerURL"/>
    </xsl:variable>

    <xsl:if test="(count($target) > 0) and ($is.innerURL != 'yes')">
      <xsl:variable name="adres">
        <xsl:call-template name="href.target">
          <xsl:with-param name="object" select="$target"/>
        </xsl:call-template>
      </xsl:variable>
      <xsl:variable name="objid">
        <xsl:call-template name="link.id"/>
      </xsl:variable>
      <xsl:value-of select="concat('\hypertarget{obn', $objid,'}{}\label{obn', $objid,'}')"/>
      <xsl:value-of select="concat('&#10;\vspace{-3pt}\itempar{\otherbacknotetarget{', $objid, '}}{\URL{', $adres, '}}')"/>
      <xsl:text>\footnoterule</xsl:text>
    </xsl:if>
  </xsl:if>
</xsl:template>

<xsl:template name="is_outernode">
  <xsl:if test="$node.proclevel != ''">
    <xsl:if test="(((ancestor::book) and $node.proclevel = 'book') or
            ((ancestor::part) and $node.proclevel = 'part') or
            ((ancestor::reference) and $node.proclevel = 'reference') or
            ((ancestor::refentry) and $node.proclevel = 'refentry') or
            ((ancestor::article) and $node.proclevel = 'article'))">
      <xsl:text>yes</xsl:text>
    </xsl:if>
  </xsl:if>
</xsl:template>

<xsl:template mode="titlemode" match="title">
  <xsl:apply-templates/>
</xsl:template>

</xsl:stylesheet>
