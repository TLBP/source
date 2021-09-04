<?xml version='1.0' encoding="UTF-8"?>
<!-- ********************************************************************
     $Id: xttitlepage.xsl,v 1.10 2003/07/10 20:27:40 nilgun Exp $
     ******************************************************************** -->

<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version='1.0'>

<xsl:variable name="authorlabel">Yazan:\\</xsl:variable>
<xsl:variable name="translatorlabel">Çeviren:\\</xsl:variable>
<xsl:variable name="preplabel">Hazırlayan:\\</xsl:variable>
<xsl:variable name="compilelabel">Derleyen:\\</xsl:variable>
<xsl:variable name="editorlabel">Düzenleyen:\\</xsl:variable>
<xsl:variable name="updatelabel">Güncelleyen:\\</xsl:variable>

<xsl:template name="nospam">
  <xsl:param name="p" select="''"/>
  <xsl:call-template name="string.replace">
    <xsl:with-param name="string" select="concat('&lt;', $p, '>')"/>
    <xsl:with-param name="target" select="'@'"/>
    <xsl:with-param name="replace" select="' (at) '"/>
  </xsl:call-template>
</xsl:template>

<xsl:template name="person.name">
  <!-- Return a formatted string representation of the contents of
       the specified node (by default, the current element).
       Handles Honorific, FirstName, SurName, and Lineage.
       If %author-othername-in-middle% is #t, also OtherName
       Handles *only* the first of each.
       Format is "Honorific. FirstName [OtherName] SurName, Lineage"
  -->
  <xsl:param name="node" select="."/>

  <xsl:variable name="h_nl" select="$node//honorific[1]"/>
  <xsl:variable name="f_nl" select="$node//firstname[1]"/>
  <xsl:variable name="o_nl" select="$node//othername[1]"/>
  <xsl:variable name="s_nl" select="$node//surname[1]"/>
  <xsl:variable name="l_nl" select="$node//lineage[1]"/>

  <xsl:variable name="has_h" select="$h_nl"/>
  <xsl:variable name="has_f" select="$f_nl"/>
  <xsl:variable name="has_o" select="$o_nl"/>
  <xsl:variable name="has_s" select="$s_nl"/>
  <xsl:variable name="has_l" select="$l_nl"/>

  <xsl:if test="$has_h">
    <xsl:value-of select="$h_nl"/>
  </xsl:if>

  <xsl:if test="$has_f">
    <xsl:if test="$has_h"><xsl:text> </xsl:text></xsl:if>
    <xsl:value-of select="$f_nl"/>
  </xsl:if>

  <xsl:if test="$has_o">
    <xsl:if test="$has_h or $has_f"><xsl:text> </xsl:text></xsl:if>
    <xsl:value-of select="$o_nl"/>
  </xsl:if>

  <xsl:if test="$has_s">
    <xsl:if test="$has_h or $has_f or $has_o">
      <xsl:text> </xsl:text>
    </xsl:if>
    <xsl:value-of select="$s_nl"/>
  </xsl:if>

  <xsl:if test="$has_l">
    <xsl:text>,{\large </xsl:text>
    <xsl:value-of select="$l_nl"/>
    <xsl:text>}</xsl:text>
  </xsl:if>
</xsl:template> <!-- person.name -->

<xsl:template match="abstract" mode="abstract">
  <xsl:text>&#10;\begin{abstract}</xsl:text>
  <xsl:apply-templates/>
  <xsl:text>&#10;\end{abstract}</xsl:text>
</xsl:template>

<xsl:template match="authorgroup" mode="titlepage">
  <xsl:apply-templates mode="titlepage"/>
</xsl:template>

<xsl:template match="author" mode="titlepage">
  <xsl:text>\and </xsl:text>
  <xsl:call-template name="author.content"/>
</xsl:template>

<xsl:template match="author[1]" mode="titlepage">
<xsl:text>
\author{</xsl:text>
  <xsl:call-template name="author.content"/>
  <xsl:if test="count(..//author) = 1">
    <xsl:text>}</xsl:text>
  </xsl:if>
</xsl:template>

<xsl:template match="author[last()]" mode="titlepage">
  <xsl:if test="count(..//author) = 1">
    <xsl:text>\author{</xsl:text>
  </xsl:if>
  <xsl:if test="count(..//author) > 1">
    <xsl:text>\and </xsl:text>
  </xsl:if>
  <xsl:call-template name="author.content"/>
  <xsl:text>}</xsl:text>
</xsl:template>

<xsl:template name="author.content">
  <xsl:variable name="type">
  <xsl:choose>
    <xsl:when test="@role='translator'">
      <xsl:value-of select="$translatorlabel"/>
    </xsl:when>
    <xsl:when test="@role='prep'">
      <xsl:value-of select="$preplabel"/>
    </xsl:when>
    <xsl:when test="@role='compile'">
      <xsl:value-of select="$compilelabel"/>
    </xsl:when>
    <xsl:when test="@role='editor'">
      <xsl:value-of select="$editorlabel"/>
    </xsl:when>
    <xsl:when test="@role='update'">
      <xsl:value-of select="$updatelabel"/>
    </xsl:when>
    <xsl:otherwise>
      <xsl:value-of select="$authorlabel"/>
    </xsl:otherwise>
  </xsl:choose>
  </xsl:variable>
  <xsl:value-of select="$type"/>
  <xsl:text>\authorname{</xsl:text>
  <xsl:call-template name="person.name"/>
  <xsl:text>}\\ </xsl:text>
  <xsl:apply-templates mode="titlepage" select="./contrib"/>
  <xsl:apply-templates mode="titlepage" select="./affiliation"/>
</xsl:template>

<xsl:template match="affiliation" mode="titlepage">
  <xsl:apply-templates mode="titlepage"/>
</xsl:template>

<xsl:template match="contrib" mode="titlepage">
  <!--xsl:variable name="content">
    <xsl:apply-templates mode="titlepage"/>
  </xsl:variable>
  <xsl:call-template name="texize">
    <xsl:with-param name="t" select="$content"/>
  </xsl:call-template-->
  <xsl:apply-templates mode="titlepage"/>
  <xsl:text>\\</xsl:text>
</xsl:template>

<xsl:template match="address" mode="titlepage">
  <xsl:apply-templates mode="titlepage"/>
</xsl:template>

<xsl:template match="otheraddr|orgdiv|orgname" mode="titlepage">
  <xsl:apply-templates/><xsl:text>\\</xsl:text>
</xsl:template>

<xsl:template match="email" mode="titlepage">
  <xsl:variable name="adres">
    <xsl:call-template name="texize"/>
  </xsl:variable>
  <xsl:text>\authoremail{</xsl:text>
  <xsl:call-template name="nospam">
    <xsl:with-param name="p" select="$adres"/>
  </xsl:call-template>
  <xsl:text>}\\</xsl:text>
</xsl:template>

<xsl:template match="sbr" mode="titlepage">
  <xsl:text>\vskip.1pt </xsl:text>
</xsl:template>

<xsl:template match="pubdate" mode="titlepage">
<xsl:text>
\date{</xsl:text><xsl:apply-templates/><xsl:text>}
</xsl:text>
</xsl:template>

<xsl:template match="othercredit[1]" mode="copyright">
<xsl:text>
\par\addvspace{1ex}
{\large \bfseries Destekleyenler:}\par
\enhanceindent\vspace{-6pt}\indentedpar{</xsl:text>
<xsl:apply-templates mode="copyright"/>
<xsl:text>}\vspace{-6pt}</xsl:text>
<xsl:if test="count(..//othercredit) = 1">
<xsl:text>\reduceindent
</xsl:text>
</xsl:if>
</xsl:template>

<xsl:template match="othercredit" mode="copyright">
<xsl:text>\vspace{-12pt}\indentedpar{</xsl:text>
<xsl:apply-templates mode="copyright"/>
<xsl:text>}\vspace{-6pt}
</xsl:text>
</xsl:template>

<xsl:template match="othercredit[last()]" mode="copyright">
<xsl:text>\vspace{-12pt}\indentedpar{</xsl:text>
<xsl:apply-templates mode="copyright"/>
<xsl:text>}\vspace{-6pt}\reduceindent
</xsl:text>
</xsl:template>

<xsl:template match="contrib" mode="copyright">
<xsl:apply-templates/>
<xsl:text>\\ </xsl:text>
</xsl:template>

<xsl:template match="copyright" mode="copyright">
  <xsl:text>&#10;\leftline{Telif Hakkı © </xsl:text>
  <xsl:apply-templates select="year" mode="copyright"/>
  <xsl:text> </xsl:text>
  <xsl:apply-templates select="holder" mode="copyright"/>
  <xsl:text>}</xsl:text>
</xsl:template>

<xsl:template match="holder|year" mode="copyright">
  <xsl:apply-templates/>
</xsl:template>

<xsl:template match="legalnotice" mode="legal">
  <xsl:apply-templates mode="copyright"/>
  <xsl:variable name="title0">
    <xsl:apply-templates mode="titlemode"/>
  </xsl:variable>
  <xsl:variable name="title">
    <xsl:choose>
      <xsl:when test="(title)">
        <xsl:value-of select="$title0"/>
      </xsl:when>
      <xsl:otherwise>
        <xsl:text>Yasal Uyarı</xsl:text>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:variable>
<xsl:text>
\par\addvspace{1ex}</xsl:text>
<xsl:value-of select="concat('{\large \bfseries ', normalize-space($title), '}\par')"/>
<xsl:text>
\enhanceindent\vspace{-6pt}
</xsl:text>
  <xsl:apply-templates/>
<xsl:text>
\reduceindent
</xsl:text>
</xsl:template>

<xsl:template match="releaseinfo" mode="secondpage">
<xsl:text>
\par\addvspace{1ex}{\large \bfseries Sürüm Bilgileri}\par
\enhanceindent\vspace{-6pt}
\indentedpar{</xsl:text>
  <xsl:apply-templates/>
<xsl:text>}
\reduceindent
</xsl:text>
</xsl:template>

<xsl:template match="revhistory" mode="secondpage">
  <xsl:choose>
    <xsl:when test="(para) or (title)">
      <xsl:text>&#10;\secttwo[</xsl:text>
      <xsl:value-of select="para|title"/>
      <xsl:text>]</xsl:text>
    </xsl:when>
    <xsl:otherwise>
      <xsl:text>&#10;\secttwo[Geçmiş]</xsl:text>
    </xsl:otherwise>
  </xsl:choose>
  <xsl:text>&#10;\vspace{1ex}\hrule</xsl:text>
  <xsl:apply-templates mode="secondpage"/>
  <xsl:text>\vskip2em </xsl:text>
</xsl:template>

<xsl:template match="revision" mode="secondpage">
  <xsl:text>&#10;</xsl:text>
  <xsl:value-of select="revnumber"/>
  <xsl:text>\hspace{\stretch{1}}</xsl:text>
  <xsl:value-of select="date"/>
  <xsl:text>\hspace{\stretch{1}}</xsl:text>
  <xsl:value-of select="authorinitials"/>
  <xsl:text>\\</xsl:text>
  <xsl:apply-templates mode="secondpage"/>
  <xsl:text>&#10;\vspace{.5ex}\hrule</xsl:text>
  <xsl:apply-templates/>
</xsl:template>

<xsl:template match="revremark" mode="secondpage">
  <xsl:variable name="p">
    <xsl:apply-templates/>
  </xsl:variable>
  <xsl:variable name="p1">
    <xsl:choose>
      <xsl:when test="not(starts-with($p, '&#10;'))">
        <xsl:value-of select="concat('&#10;', $p)"/>
      </xsl:when>
      <xsl:otherwise>
        <xsl:value-of select="$p"/>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:variable>
  <xsl:call-template name="trimleft">
    <xsl:with-param name="string" select="$p1"/>
  </xsl:call-template>
</xsl:template>

<xsl:template mode="titlepage" match="setinfo|bookinfo|partinfo|articleinfo">
  <xsl:apply-templates mode="titlepage"/>
</xsl:template>

<xsl:template mode="abstract" match="articleinfo|bookinfo|partinfo|setinfo|referenceinfo">
  <xsl:apply-templates mode="abstract"/>
</xsl:template>

<xsl:template mode="legal" match="setinfo|bookinfo|partinfo|articleinfo">
  <xsl:apply-templates mode="legal"/>
</xsl:template>

<xsl:template mode="copyright" match="setinfo|bookinfo|partinfo|articleinfo">
  <xsl:apply-templates mode="copyright"/>
</xsl:template>

<xsl:template mode="secondpage" match="setinfo|bookinfo|partinfo|articleinfo">
  <xsl:apply-templates mode="secondpage"/>
</xsl:template>

</xsl:stylesheet>


