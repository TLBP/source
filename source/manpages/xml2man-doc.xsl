<?xml version='1.0' encoding="UTF-8"?>
<!DOCTYPE xsl:stylesheet [
<!-- DİKKAT: Bunlar ASCII (Komut isimleri dönüşümü için) -->
<!ENTITY allcases  "'abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ'">
<!ENTITY uppercases "'ABCDEFGHIJKLMNOPQRSTUVWXYZABCDEFGHIJKLMNOPQRSTUVWXYZ'">
]>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
                xmlns:d="http://docbook.org/ns/docbook"
                xmlns:doc="http://exslt.org/common"
                xmlns:date="http://exslt.org/dates-and-times"
                xmlns:t="http://tlbp.gen.tr/ns/tlbp"
                extension-element-prefixes="d doc date t"
                version='1.0'>

<xsl:template match="d:refentry">
  <xsl:variable name="remark">
    <xsl:value-of select="d:info/t:pageinfo/t:remark"/>
  </xsl:variable>
  <xsl:if test="$remark != ''">
    <xsl:value-of select="concat($remark, '&#10;')"/>
  </xsl:if>
<xsl:text>.ig
Bu kılavuz sayfası Türkçe Linux Belgelendirme Projesi (TLBP) tarafından
XML belgelerden derlenmiş olup manpages-tr paketinin parçasıdır:
https://github.com/TLBP/manpages-tr
İngilizce kılavuz sayfasında varsa, lisans ve telif hakkı bilgileri
korunmuştur. Lisans bilgisi içermeyen belgelerin türkçe çevirileri için
GNU AGPL (http://gnu.org/licenses/agpl.html) lisansı geçerlidir.
Bu çevirinin telif hakları belgenin çevirmenlerine aittir.
Bu bir özgür yazılımdır: Yazılımı değiştirmek ve dağıtmakta özgürsünüz.
Yasaların izin verdiği ölçüde HİÇBİR GARANTİ YOKTUR.
..
.\" Derlenme zamanı: </xsl:text>
  <xsl:value-of select="date:date-time()"/>
  <xsl:variable name="p">
    <xsl:text>.TH "</xsl:text>
    <xsl:value-of select="translate(normalize-space(d:info/t:pageinfo/t:name/text()), &allcases;, &uppercases;)"/>
    <xsl:text>" </xsl:text>
    <xsl:value-of select="d:info/t:pageinfo/t:volnum"/>
    <xsl:text> "</xsl:text>
    <xsl:value-of select="d:info/t:pageinfo/t:date"/>
    <xsl:text>" "</xsl:text>
    <xsl:value-of select="d:info/t:pageinfo/t:source"/>
    <xsl:text>" "</xsl:text>
    <xsl:value-of select="d:info/t:pageinfo/t:section"/>
    <xsl:text>"</xsl:text>
  </xsl:variable>
<xsl:value-of select="concat('&#10;', normalize-space($p))"/>
<xsl:text>
.\" Sözcükleri ilgisiz yerlerden bölme (disable hyphenation)
.nh
.\" Sözcükleri yayma, sadece sola yanaştır (disable justification)
.ad l</xsl:text>
  <xsl:apply-templates/>
</xsl:template>

<xsl:template match="d:info"/>

<xsl:template name="linkme">

  <xsl:variable name="dizge">
    <xsl:value-of select="d:refname/text()"/>
  </xsl:variable>

  <xsl:variable name="thisbase">
    <xsl:choose>
      <xsl:when test="contains($dizge, ' ')">
        <xsl:call-template name="string.replace">
          <xsl:with-param name="string" select="$dizge"/>
          <xsl:with-param name="target" select="' '"/>
          <xsl:with-param name="replace" select="'_'"/>
        </xsl:call-template>
      </xsl:when>
      <xsl:otherwise>
        <xsl:value-of select="$dizge"/>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:variable>

  <xsl:variable name="dizge2">
    <xsl:value-of select="../d:info/t:pageinfo/t:name/text()"/>
  </xsl:variable>

  <xsl:variable name="mainbase">
    <xsl:choose>
      <xsl:when test="contains($dizge2, ' ')">
        <xsl:call-template name="string.replace">
          <xsl:with-param name="string" select="$dizge2"/>
          <xsl:with-param name="target" select="'_'"/>
          <xsl:with-param name="replace" select="' '"/>
        </xsl:call-template>
      </xsl:when>
      <xsl:otherwise>
        <xsl:value-of select="$dizge2"/>
     </xsl:otherwise>
    </xsl:choose>
  </xsl:variable>

  <xsl:variable name="ext">
    <xsl:value-of select="../d:info/t:pageinfo/t:volnum/text()"/>
  </xsl:variable>

  <doc:document href="{concat('tr/man', $ext, '/', $thisbase, '.', $ext)}" omit-xml-declaration="yes">
    <xsl:value-of select="concat('.so ', $mainbase, '.', $ext, '.gz&#10;')"/>
  </doc:document>
</xsl:template>

</xsl:stylesheet>
