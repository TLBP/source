<?xml version='1.0' encoding="UTF-8"?>
<!DOCTYPE xsl:stylesheet [
<!-- DİKKAT: Bunlar ASCII (Komut isimleri dönüşümü için) -->
<!ENTITY allcases  "'abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ'">
<!ENTITY uppercases "'ABCDEFGHIJKLMNOPQRSTUVWXYZABCDEFGHIJKLMNOPQRSTUVWXYZ'">
]>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
                xmlns:d="http://docbook.org/ns/docbook"
                xmlns:doc="http://exslt.org/common"
                extension-element-prefixes="d doc"
                version='1.0'>

<xsl:template match="d:book">
 <xsl:apply-templates select="d:reference"/>
</xsl:template>

<xsl:template match="d:reference">
  <doc:document href="{concat('tr/', @xml:id, '.lst')}" omit-xml-declaration="yes">
   <xsl:apply-templates select="d:refentry"/>
  </doc:document>
</xsl:template>

<xsl:template match="d:refentry">
  <xsl:variable name="ext">
    <xsl:value-of select="d:refmeta/d:manvolnum"/>
  </xsl:variable>
  <xsl:variable name="name">
    <xsl:value-of select="normalize-space(d:refmeta/d:refentrytitle)"/>
  </xsl:variable>
  <xsl:value-of select="concat('./xml2man.sh ', $ext, ' ', $name, '&#10;')"/>
</xsl:template>


</xsl:stylesheet>
