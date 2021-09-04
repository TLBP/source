<?xml version="1.0" encoding="UTF-8"?>
<!DOCTYPE xsl:stylesheet [

<!ENTITY legal "http://www.w3.org/Consortium/Legal">
<!ENTITY orig "http://www.w3.org/TR/1999/REC-xslt-19991116">
<!ENTITY rec "xslt">
<!ENTITY translation.date "Mayıs 2007">
]>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
                    xmlns="http://www.w3.org/1999/xhtml"
                  version="1.0">

<xsl:include href="../w3cspec.xsl"/>
<xsl:include href="../esyntax.xsl"/>

<xsl:template name="spec-copyright">
  <p class="copyright">
    <a href="&legal;/ipr-notice#Copyright">
      <xsl:text>Telif Hakkı</xsl:text>
    </a>
    <xsl:text> © </xsl:text>
    <xsl:apply-templates select="pubdate/year"/>
    <xsl:text> </xsl:text>
    <a href="http://www.w3.org/">
      <acronym title="World Wide Web Consortium">W3C</acronym>
    </a>
    <sup>®</sup>
    <xsl:text> (</xsl:text>
    <a href="http://www.csail.mit.edu/">
      <acronym title="Massachusetts Institute of Technology">MIT</acronym>
    </a>
    <xsl:text>, </xsl:text>
    <a href="http://www.inria.fr/">INRIA</a>
    <xsl:text>, </xsl:text>
    <a href="http://www.keio.ac.jp/">Keio</a>
    <xsl:text>), Tüm hakları saklıdır. W3C </xsl:text>
    <a href="&legal;/ipr-notice#Legal_Disclaimer">sorumluluk reddi</a>
    <xsl:text>, </xsl:text>
    <a href="&legal;/ipr-notice#W3C_Trademarks">ticari marka</a>
    <xsl:text>, </xsl:text>
    <a href="&legal;/copyright-documents">belge kullanımı</a>
    <xsl:text> ve </xsl:text>
    <a href="&legal;/copyright-software.html">yazılım lisanslama</a>
    <xsl:text> kuralları uygulanır.</xsl:text>
  </p>
</xsl:template>

<xsl:template name="traslator.info">
  <dt>
    <xsl:text>Bu çeviri:</xsl:text>
  </dt>
  <dd><a href="&rec;.xml">XML</a> ve  <a href="&rec;.html">HTML</a>
  <xsl:text> biçimleri mevcuttur.</xsl:text></dd>
  <dt class="traslatorinfo">
    <xsl:text>Çeviren:</xsl:text>
  </dt>
  <dd><xsl:text>Nilgün Belma Bugüner &lt;</xsl:text>
  <span class="email"><xsl:text>nilgun (at) belgeler·org</xsl:text></span>
  <xsl:text>>, &translation.date;</xsl:text></dd>
</xsl:template>

<xsl:template name="traslation.info">
  <p class="traslationinfo">
    <xsl:text>Bu çeviri de diğer belirtim çevirileri gibi  bilgilendirici
    mahiyettedir, hiçbir bağlamda belirleyici değildir. Bu belge anadili
    Türkçe olan Genel ağ kullanıcılarının bu belirtim hakkında fikir
    edinebilmelerini sağlamak amacıyla Türkçeye çevrilmiştir. Bu belirtimin
    belirleyici tek sürümü W3C tarafından yayımlanan  </xsl:text><a href="&orig;">İngilizce sürümüdür.</a>
  </p>
</xsl:template>

<!-- ================================================================= -->

<!-- ================================================================= -->

</xsl:stylesheet>
