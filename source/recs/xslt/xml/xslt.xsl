<?xml version="1.0" encoding="UTF-8"?>
<!DOCTYPE xsl:stylesheet [

<!ENTITY legal "http://www.w3.org/Consortium/Legal">
<!ENTITY orig "http://www.w3.org/TR/1999/REC-xslt-19991116">
<!ENTITY rec "xslt">
]>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
                    xmlns="http://www.w3.org/1999/xhtml"
                  version="1.0">

<xsl:include href="../../esyntax.xsl"/>

<xsl:template name="spec-copyright-tr">
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

<xsl:template name="spec-copyright-en">
  <p class="copyright">
    <a href="&legal;/ipr-notice#Copyright">Copyright</a>
    <xsl:text> © </xsl:text><xsl:apply-templates select="pubdate/year"/>
    <a href="http://www.w3.org/">
      <acronym title="World Wide Web Consortium"> W3C</acronym>
    </a><sup>®</sup><xsl:text> (</xsl:text>
    <a href="http://www.csail.mit.edu/">
      <acronym title="Massachusetts Institute of Technology">MIT</acronym>
    </a><xsl:text>, </xsl:text>
    <a href="http://www.inria.fr/">INRIA</a>
   <!--a href="http://www.ercim.org/">
    <acronym title="European Research Consortium for Informatics and Mathematics">ERCIM</acronym>
   </a-->
    <xsl:text>, </xsl:text>
    <a href="http://www.keio.ac.jp/">Keio</a>
    <xsl:text>), All Rights Reserved. W3C </xsl:text>
    <a href="http://www.w3.org/Consortium/Legal/ipr-notice#Legal_Disclaimer"
    >liability</a><xsl:text>, </xsl:text><a href="http://www.w3.org/Consortium/Legal/ipr-notice#W3C_Trademarks"
    >trademark</a><xsl:text>, </xsl:text><a href="http://www.w3.org/Consortium/Legal/copyright-documents"
    >document use</a><xsl:text> and </xsl:text><a href="http://www.w3.org/Consortium/Legal/copyright-software.html"
    >software licensing</a><xsl:text> rules apply.</xsl:text>
  </p>
</xsl:template>

<xsl:template name="translation.info">
  <dl><dt>
    <xsl:text>Bu çeviri:</xsl:text>
  </dt>
  <dd><a href="&rec;.html">Tek sayfalık HTML</a>,  <a href="index.html">çok sayfalı HTML</a> ve <a href="xml">XML</a>
  <xsl:text> biçimleri mevcuttur.</xsl:text></dd>
  <dt class="translatorinfo">
    <xsl:text>Çeviren:</xsl:text>
  </dt>
  <dd><xsl:value-of select="concat(authlist/@translator-name, ' &lt;')"/>
  <span class="email"><xsl:value-of select="authlist/@translator-email"/></span>
  <xsl:value-of select="concat('>, ', authlist/@translation-date)"/></dd>
  </dl>
  <p class="translationinfo">
    <xsl:text>Bu çeviri de diğer belirtim çevirileri gibi  bilgilendirici
    mahiyettedir, hiçbir bağlamda belirleyici değildir. Bu belge anadili
    Türkçe olan Genel ağ kullanıcılarının bu belirtim hakkında fikir
    edinebilmelerini sağlamak amacıyla Türkçeye çevrilmiştir. Bu belirtimin
    belirleyici tek sürümü W3C tarafından yayımlanan  </xsl:text><a href="&orig;">İngilizce sürümüdür.</a>
  </p>
  <xsl:call-template name="spec-copyright-tr"/>
</xsl:template>

<!-- ================================================================= -->

<!-- ================================================================= -->

</xsl:stylesheet>
