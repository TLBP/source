<?xml version="1.0" encoding='UTF-8'?>
<!DOCTYPE xsl:stylesheet [
<!ENTITY section   '($target/ancestor-or-self::spec
                    |$target/ancestor-or-self::div1
                    |$target/ancestor-or-self::inform-div1)[last()]'>
]>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
                xmlns:date="http://exslt.org/dates-and-times"
                xmlns="http://www.w3.org/1999/xhtml"
                extension-element-prefixes="date" version="1.1">

<xsl:import href="xmlspec-tr.xsl"/>

<xsl:template match="spec|div1|inform-div1">
  <xsl:variable name="this" select="."/>
  <xsl:variable name="prev"
     select="preceding-sibling::*[1]
             |../preceding-sibling::body/*[not ($this/preceding-sibling::*)][last()]
             |/*[($this/parent::body) and not ($this/preceding-sibling::*)][1]"/>

  <xsl:variable name="next"
     select="descendant::div1[1]
             |following-sibling::*[1]
             |../following-sibling::back/*[1]
              [not ($this/following-sibling::*)]"/>

  <xsl:variable name="filename" select="concat($global.targetdir, @id, '.html')"/>

  <xsl:call-template name="write.chunk">
    <xsl:with-param name="fname" select="$filename"/>
    <xsl:with-param name="content">
      <xsl:call-template name="chunk-element-content">
        <xsl:with-param name="prev" select="$prev"/>
        <xsl:with-param name="next" select="$next"/>
      </xsl:call-template>
    </xsl:with-param>
  </xsl:call-template>
</xsl:template>

<xsl:template name="chunk-element-content">
  <xsl:param name="prev"></xsl:param>
  <xsl:param name="next"></xsl:param>

  <xsl:variable name="homeheader">
    <xsl:apply-templates select="/spec/header/title"/>
    <xsl:if test="/spec/header/version">
      <xsl:text> </xsl:text>
      <xsl:apply-templates select="/spec/header/version"/>
    </xsl:if>
  </xsl:variable>

  <html lang="tr" xml:lang="tr"><head>
    <meta name="viewport" content="width=device-width, initial-scale=1.0" />
    <meta name="date">
      <xsl:attribute name="content">
        <xsl:value-of select="date:date-time()"/>
      </xsl:attribute>
    </meta>
    <link rel="start" href=".." title="W3C Önergeleri"/>
    <xsl:if test="not (self::spec)">
      <link rel="up" href="{/spec/@id}.html#{/spec/@id}-toc" title="{$homeheader}"/>
    </xsl:if>
    <xsl:if test="$prev">
      <link rel="previous">
        <xsl:attribute name="href">
          <xsl:call-template name="href.target">
            <xsl:with-param name="target" select="$prev"/>
          </xsl:call-template>
        </xsl:attribute>
        <xsl:attribute name="title">
          <xsl:choose>
            <xsl:when test="name($prev) = 'spec'">
              <xsl:value-of select="$homeheader"/>
            </xsl:when>
            <xsl:otherwise>
              <xsl:value-of select="string($prev/head)"/>
            </xsl:otherwise>
          </xsl:choose>
        </xsl:attribute>
      </link>
    </xsl:if>
    <xsl:if test="$next">
      <link rel="next">
        <xsl:attribute name="href">
          <xsl:call-template name="href.target">
            <xsl:with-param name="target" select="$next"/>
          </xsl:call-template>
        </xsl:attribute>
        <xsl:attribute name="title">
          <xsl:value-of select="string($next/head)"/>
        </xsl:attribute>
      </link>
    </xsl:if>
    <link rel="stylesheet" type="text/css" href="../recs.css" />
    <xsl:call-template name="css"/>
    <title>
      <xsl:choose>
        <xsl:when test="name(.) = 'spec'">
          <xsl:value-of select="$homeheader"/>
        </xsl:when>
        <xsl:otherwise>
          <xsl:value-of select="string(head)"/>
        </xsl:otherwise>
      </xsl:choose>
    </title>
  </head><body>
    <xsl:call-template name="header.navigation">
        <xsl:with-param name="prev" select="$prev"/>
        <xsl:with-param name="next" select="$next"/>
        <xsl:with-param name="home" select="$homeheader"/>
    </xsl:call-template>
    <xsl:choose>
      <xsl:when test="name(.) = 'spec'">
        <xsl:apply-templates/>
      </xsl:when>
      <xsl:otherwise>
        <xsl:apply-imports/>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:call-template name="footer.navigation">
        <xsl:with-param name="prev" select="$prev"/>
        <xsl:with-param name="next" select="$next"/>
    </xsl:call-template>
  </body></html>
</xsl:template>

<xsl:template name="header.navigation">
  <xsl:param name="prev"/>
  <xsl:param name="next"/>
  <xsl:param name="home" select="''"/>

  <table width="100%" summary="Gezinme Çubuğu" cellpadding="1" cellspacing="0" style="border:1px dotted #999999">
    <tr><th colspan="3" align="center">
      <xsl:value-of select="$home"/>
    </th></tr>
    <tr><td width="5%">
          <xsl:if test="$prev">
            <a href="{$prev/@id}.html">Önceki</a>
          </xsl:if>
        </td>
        <td width="*" align="center">
          <xsl:if test="not (self::spec)">
            <a href="{/spec/@id}.html#{/spec/@id}-toc">Yukarı</a>
          </xsl:if>
        </td>
        <td width="5%" align="right">
          <xsl:if test="$next">
            <a href="{$next/@id}.html">Sonraki</a>
          </xsl:if>
        </td>
    </tr>
  </table>
</xsl:template>

<xsl:template name="footer.navigation">
  <xsl:param name="prev"/>
  <xsl:param name="next"/>
  <p/>
  <table width="100%" summary="Gezinme Çubuğu" cellpadding="1" cellspacing="0" style="border:1px dotted #999999">
    <tr><td width="30%">
          <xsl:if test="$prev">
            <a href="{$prev/@id}.html">Önceki</a>
          </xsl:if>
        </td>
        <td width="*" align="center">
          <xsl:if test="not (self::spec)">
            <a href="{/spec/@id}.html#{/spec/@id}-toc">Yukarı</a>
          </xsl:if>
        </td>
        <td width="30%" align="right">
          <xsl:if test="$next">
            <a href="{$next/@id}.html">Sonraki</a>
          </xsl:if>
        </td>
    </tr>
    <tr><td width="30%">
          <xsl:if test="$prev">
            <xsl:value-of select="string($prev/head)"/>
          </xsl:if>
        </td>
        <td width="*" align="center">Bir <a href="http://belgeler.org">Linux Kitaplığı</a> Sayfası</td>
        <td width="30%" align="right">
          <xsl:if test="$next">
            <xsl:value-of select="string($next/head)"/>
          </xsl:if>
        </td>
    </tr>
  </table>
</xsl:template>

<xsl:template name="write.chunk">
  <xsl:param name="fname" select="''"/>
  <xsl:param name="content" select="''"/>

  <xsl:message>
    <xsl:text>Writing </xsl:text>
    <xsl:value-of select="$fname"/>
    <xsl:if test="name(.) != ''">
      <xsl:text> for </xsl:text>
      <xsl:value-of select="name(.)"/>
      <xsl:if test="@id">
        <xsl:text>(</xsl:text>
        <xsl:value-of select="@id"/>
        <xsl:text>)</xsl:text>
      </xsl:if>
    </xsl:if>
  </xsl:message>
  <xsl:document href="{$fname}"
    method="xml"
    doctype-public="-//W3C//DTD XHTML 1.0 Transitional//EN"
    doctype-system="http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd"
    encoding="UTF-8">
    <xsl:copy-of select="$content"/>
  </xsl:document>
</xsl:template>

<xsl:template name="chunk-toc">
  <xsl:if test="count(../div2)">
    <b>İçindekiler</b>
    <p class="toc">
      <xsl:apply-templates select="../div2" mode="toc"/>
    </p>
  </xsl:if>
</xsl:template>

<xsl:template name="fname.target">
  <xsl:param name="target" select="."/>

  <xsl:value-of select="&section;/@id"/>
  <xsl:text>.html</xsl:text>
</xsl:template>
<!-- ================================================================= -->
</xsl:stylesheet>
