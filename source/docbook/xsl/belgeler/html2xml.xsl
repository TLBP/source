<?xml version='1.0' encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version='1.0'>

<xsl:output method="text" encoding="UTF-8" omit-xml-declaration="no" standalone="yes" indent="no"/>

<xsl:template match="*">
    <xsl:apply-templates/>
</xsl:template>

<xsl:template match="HTML|html">
  <xsl:text>&lt;?xml version='1.0' encoding="UTF-8"?>&#10;&lt;article>&#10;</xsl:text>
  <xsl:apply-templates/>
  <xsl:text>&lt;/article>&#10;</xsl:text>
</xsl:template>

<xsl:template match="TITLE|title">
  <xsl:text>  &lt;articleinfo>&#10;    &lt;title></xsl:text>
  <xsl:apply-templates/>
  <xsl:text>&lt;/title>&#10;  &lt;/articleinfo>&#10;&#10;</xsl:text>
</xsl:template>

<xsl:template match="BODY|body">
  <xsl:apply-templates/>
</xsl:template>

<xsl:template match="H1|H2|H3|H4|H5|H6|h1|h2|h3|h4|h5|h6">
  <xsl:variable name="tag">
    <xsl:value-of select="concat('sect', substring(name(.),2,1), '>')"/>
  </xsl:variable>
  <xsl:value-of select="concat('&lt;/', $tag, '&lt;', $tag, '&lt;title>')"/>
  <xsl:apply-templates/>
  <xsl:text>&lt;/title>&#10;</xsl:text>
</xsl:template>

<xsl:template match="TABLE|table">
  <xsl:text>  &lt;informaltable>&lt;tbody>&#10;</xsl:text>
    <xsl:apply-templates/>
  <xsl:text>&#10;  &lt;/tbody>&lt;/informaltable>&#10;</xsl:text>
</xsl:template>

<xsl:template match="TR|tr">
  <xsl:text>    &lt;row>&#10;</xsl:text>
    <xsl:apply-templates/>
  <xsl:text>&#10;  &lt;/row>&#10;</xsl:text>
</xsl:template>

<xsl:template match="TD|td">
  <xsl:text>    &lt;entry></xsl:text>
    <xsl:apply-templates/>
  <xsl:text>&lt;/entry>&#10;</xsl:text>
</xsl:template>

<xsl:template match="IMG|img">
  <xsl:text>    &lt;mediaobject>&#10;      &lt;imageobject>&#10;        &lt;imagedata align="center" fileref="</xsl:text>
    <xsl:value-of select="@src"/>
  <xsl:text>"/>&#10;      &lt;/imageobject>&#10;    &lt;/mediaobject>&#10;</xsl:text>
</xsl:template>

<xsl:template match="P|p">
  <xsl:text>  &lt;para>&#10;</xsl:text>
    <xsl:apply-templates/>
  <xsl:text>&#10;  &lt;/para>&#10;</xsl:text>
</xsl:template>

<xsl:template match="BR|br">
  <xsl:text>&lt;sbr/>&#10;</xsl:text>
</xsl:template>

<xsl:template match="OL|ol">
  <xsl:text>  &lt;orderedlist>&#10;</xsl:text>
    <xsl:apply-templates/>
  <xsl:text>&#10;  &lt;/orderedlist>&#10;</xsl:text>
</xsl:template>

<xsl:template match="UL|ul">
  <xsl:text>  &lt;itemizedlist>&#10;</xsl:text>
    <xsl:apply-templates/>
  <xsl:text>&#10;  &lt;/itemizedlist>&#10;</xsl:text>
</xsl:template>

<xsl:template match="LI|li">
  <xsl:text>  &lt;listitem>&#10;</xsl:text>
    <xsl:apply-templates/>
  <xsl:text>&#10;  &lt;/listitem>&#10;</xsl:text>
</xsl:template>

<xsl:template match="DU|du">
  <xsl:text>  &lt;glosslist>&#10;</xsl:text>
    <xsl:apply-templates/>
  <xsl:text>&#10;  &lt;/glosslist>&#10;</xsl:text>
</xsl:template>

<xsl:template match="DT|dt">
  <xsl:text>  &lt;glossterm>&#10;</xsl:text>
    <xsl:apply-templates/>
  <xsl:text>&#10;  &lt;/glossterm>&#10;</xsl:text>
</xsl:template>

<xsl:template match="DD|dd">
  <xsl:text>  &lt;glossdef>&#10;</xsl:text>
    <xsl:apply-templates/>
  <xsl:text>&#10;  &lt;/glossdef>&#10;</xsl:text>
</xsl:template>

<xsl:template match="a|A">
  <xsl:choose>
    <xsl:when test="(name)">
      <xsl:text> &lt;anchor id="</xsl:text>
       <xsl:value-of select="@name"/><xsl:text>"/></xsl:text>
    </xsl:when>
    <xsl:otherwise>
      <xsl:text> &lt;ulink url="</xsl:text>
        <xsl:value-of select="@href"/><xsl:text>"></xsl:text>
        <xsl:apply-templates/>
      <xsl:text>&lt;/ulink></xsl:text>
    </xsl:otherwise>
  </xsl:choose>
</xsl:template>

<xsl:template match="pre|PRE">
  <xsl:text> &lt;screen>&#10;</xsl:text>
    <xsl:apply-templates/>
  <xsl:text>&lt;/screen>&#10;</xsl:text>
</xsl:template>

<xsl:template match="b|B|strong|STRONG">
  <xsl:text> &lt;command></xsl:text>
    <xsl:apply-templates/>
  <xsl:text>&lt;/command> </xsl:text>
</xsl:template>

<xsl:template match="i|I">
  <xsl:text> &lt;emphasis></xsl:text>
    <xsl:apply-templates/>
  <xsl:text>&lt;/emphasis> </xsl:text>
</xsl:template>

<xsl:template match="TT|tt">
  <xsl:text> &lt;literal></xsl:text>
    <xsl:apply-templates/>
  <xsl:text>&lt;/literal> </xsl:text>
</xsl:template>

<xsl:template match="text()">
  <xsl:value-of select="."/>
</xsl:template>

</xsl:stylesheet>
