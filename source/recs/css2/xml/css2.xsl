<?xml version="1.0" encoding="UTF-8"?>
<!DOCTYPE xsl:stylesheet [

<!ENTITY legal "http://www.w3.org/Consortium/Legal">
<!ENTITY orig "http://www.w3.org/TR/1998/REC-CSS2-19980512/">
<!ENTITY rec "css2">
]>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
                xmlns="http://www.w3.org/1999/xhtml" version="1.1">

<!--xsl:import href="../xmlspec-tr.xsl"/-->
<xsl:import href="../../chunkspec.xsl"/>
<xsl:import href="../../singleindex.xsl"/>

<xsl:variable name="global.targetdir" select="'../'"/>

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
    <sup><small>®</small></sup>
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
    <xsl:text> ve </xsl:text>
    <a href="&legal;/copyright-documents">belge kullanımı</a>
    <xsl:text> kuralları uygulanır.</xsl:text>
  </p>
</xsl:template>

<xsl:template name="spec-copyright-en">
  <p class="translationinfo">About this translation:</p>
  <ol><li>Appendices are not translated; and</li><li>there is a newer version of the standard
in English:<br/><a href="http://www.w3.org/TR/2007/CR-CSS21-20070719/">http://www.w3.org/TR/2007/CR-CSS21-20070719/</a></li></ol>
  <p class="copyright">
    <a href="&legal;/ipr-notice#Copyright">Copyright</a>
    <xsl:text> © </xsl:text>
    <xsl:apply-templates select="pubdate/year"/>
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
    >trademark</a><xsl:text> and </xsl:text><a href="http://www.w3.org/Consortium/Legal/copyright-documents"
    >document use</a><xsl:text> rules apply.</xsl:text>
  </p>
</xsl:template>

<xsl:template name="translation.info">
  <dl><dt>
    <xsl:text>Bu çeviri:</xsl:text>
  </dt>
  <dd><a href="xml/">XML</a> ve  <a href=".">HTML</a>
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
    Türkçe olan Genel Ağ kullanıcılarının bu belirtim hakkında fikir
    edinebilmelerini sağlamak amacıyla Türkçeye çevrilmiştir. Bu belirtimin
    belirleyici tek sürümü W3C tarafından yayımlanan  </xsl:text><a href="&orig;">İngilizce sürümüdür.</a>
  </p><p class="translationinfo">Bu çeviri, çevirmenin çevirinin bitimine yakın bu çeviriyi yapma isteğinin kaybolması nedeniyle tamamlanamamıştır. Çevrilmemiş olan ek bölümlere rağmen, mevcut çevirinin okuyucuya yine de yararlı olacağına duyulan inanç nedeniyle çeviri bu haliyle yayınlanmıştır. Çevirinin gönüllüler tarafından tamamlanacağı umulmaktadır. </p>
  <p class="translationinfo">Ek bölümleri henüz çevrilmemiş olan bu önergenin çok fazla değişiklik arzetmeyen daha yeni bir sürümü de vardır. CSS-2.1 sürümünü (bu çeviri yapıldığında önerge adayı durumunda olan İngilizce sürümü) <a href="http://www.w3.org/TR/2007/CR-CSS21-20070719/">http://www.w3.org/TR/2007/CR-CSS21-20070719/</a> adresinde bulabilirsiniz. 14 Kasım 2007, belgeler.org</p>
  <xsl:call-template name="spec-copyright-tr"/>
</xsl:template>

<!-- ================================================================= -->

<xsl:template match="header">
  <div class="head">
    <p>
      <a href="http://www.w3.org/">
        <img width="72" height="48" src="../w3c_home.png" alt="W3C"/>
      </a>
    </p>
    <h1>
      <xsl:call-template name="anchor">
        <xsl:with-param name="node" select="title[1]"/>
        <xsl:with-param name="conditional" select="0"/>
        <xsl:with-param name="default.id" select="'title'"/>
      </xsl:call-template>

      <xsl:apply-templates select="title"/>
      <xsl:if test="version">
        <xsl:text> </xsl:text>
        <xsl:apply-templates select="version"/>
      </xsl:if>
      <xsl:if test="(subtitle)">
        <br />
        <xsl:apply-templates select="subtitle"/>
      </xsl:if>
    </h1>
    <h2>
      <xsl:call-template name="anchor">
        <xsl:with-param name="node" select="w3c-doctype[1]"/>
        <xsl:with-param name="conditional" select="0"/>
        <xsl:with-param name="default.id" select="'w3c-doctype'"/>
      </xsl:call-template>

      <xsl:value-of select="w3c-doctype[1]"/>
      <xsl:text> </xsl:text>
      <xsl:if test="pubdate/day">
        <xsl:apply-templates select="pubdate/day"/>
        <xsl:text> </xsl:text>
      </xsl:if>
      <xsl:apply-templates select="pubdate/month"/>
      <xsl:text> </xsl:text>
      <xsl:apply-templates select="pubdate/year"/>
    </h2>
    <dl>
      <xsl:apply-templates select="publoc"/>
      <xsl:apply-templates select="latestloc"/>
      <xsl:apply-templates select="prevlocs"/>
      <xsl:apply-templates select="authlist"/>
    </dl>
    <xsl:call-template name="spec-copyright-en"/>
    <hr />
    <xsl:call-template name="translation.info"/>
  </div>
  <hr/>
  <xsl:apply-templates select="notice"/>
  <xsl:apply-templates select="abstract"/>
  <xsl:apply-templates select="status"/>
  <xsl:call-template name="avail.formats"/>
  <xsl:call-template name="avail.langs"/>
</xsl:template>

<xsl:template name="avail.formats">
<h2>Mevcut Biçimler</h2>

<p>CSS2 belirtiminin İngilizcesinin şu biçimleri de mevcuttur:</p>

<dl>
<dt>HTML:</dt>
<dd><a href="&orig;Overview.html">&orig;</a></dd>
<dt>Salt metin olarak:</dt>
<dd><a href="&orig;css2.txt">&orig;css2.txt</a>,</dd>
<dt>HTML biçiminin gzipli tar paketi olarak:</dt>
<dd><a href="&orig;css2.tgz">&orig;css2.tgz</a>,</dd>
<dt>HTML biçiminin zip paketi olarak (bir '.exe' değil):</dt>
<dd><a href="&orig;css2.zip">&orig;css2.zip</a>,</dd>
<dt>PostScript biçiminin gziplisi olarak:</dt>
<dd><a href="&orig;css2.ps.gz">&orig;css2.ps.gz</a>,</dd>
<dt>PDF:</dt>
<dd><a href="&orig;css2.pdf">&orig;css2.pdf</a>.</dd>
</dl>

<p>Belirtimin çeşitli biçimleri arasında farklılıklar bulunması durumunda, <a href="http://www.w3.org/TR/1998/REC-CSS2-19980512/">http://www.w3.org/TR/1998/REC-CSS2-19980512</a> sonucu tayin eder.</p>
</xsl:template>

<xsl:template name="avail.langs">
<h3>Mevcut çeviriler</h3>
<p>Bu belirtimin İngilizce sürümü uyulması gerekli tek sürümdür. Bununla birlikte, başka dillere çevirileri de olabilir; <a
href="http://www.w3.org/Style/css2-updates/translations.html">http://www.w3.org/Style/css2-updates/translations.html</a> adresine bir bakın.</p>

<h3>Hata Raporları</h3>
<p>Bu belirtimle ilgili bilinen hataların bir listesi <a
href="http://www.w3.org/Style/css2-updates/REC-CSS2-19980512-errata.html">http://www.w3.org/Style/css2-updates/REC-CSS2-19980512-errata.html</a> adresinde mevcuttur. Bu belgenin İngilizce sürümünde bulduğunuz hataları lütfen <a
href="mailto:css2-editors@w3.org">css2-editors@w3.org</a> adresine bildiriniz. <strong>Belirtimin çevrildiği tarihte mevcut olan hata raporlarından belirtimin "Önerge" olma vasfını bozmayan düzeltmeler çeviriye yansıtılmıştır</strong>.</p>
</xsl:template>

<xsl:template match="body">
  <xsl:if test="$toc.level &gt; 0">
    <div class="toc">
      <a name="{../@id}-toc" id="{../@id}-toc"/>
      <h2>
        <xsl:text>İçindekiler (Kısa Liste)</xsl:text>
      </h2>
      <p class="toc">
        <xsl:apply-templates select="div1" mode="toc">
          <xsl:with-param name="toc.type" select="'quick'"/>
        </xsl:apply-templates>
        <xsl:apply-templates mode="toc" select="../back/div1 | ../back/inform-div1 | ../back/index">
          <xsl:with-param name="toc.type" select="'quick'"/>
        </xsl:apply-templates>
      </p>
    </div>
    <div class="toc">
      <h2>
        <xsl:call-template name="anchor">
          <xsl:with-param name="conditional" select="0"/>
          <xsl:with-param name="default.id" select="'contents'"/>
        </xsl:call-template>
        <xsl:text>İçindekiler (Tam Liste)</xsl:text>
      </h2>
      <p class="toc">
        <xsl:apply-templates select="div1" mode="toc"/>
      </p>
      <xsl:if test="../back">
        <h3>
          <xsl:call-template name="anchor">
            <xsl:with-param name="conditional" select="0"/>
            <xsl:with-param name="default.id" select="'appendices'"/>
          </xsl:call-template>

          <xsl:text>Ek</xsl:text>
          <xsl:if test="count(../back/div1 | ../back/inform-div1 | ../back/index) &gt; 1">
            <xsl:text>ler</xsl:text>
          </xsl:if>
        </h3>
        <p class="toc">
          <xsl:apply-templates mode="toc" select="../back/div1 | ../back/inform-div1 | ../back/index"/>
          <xsl:call-template name="autogenerated-appendices-toc"/>
        </p>
      </xsl:if>
      <xsl:if test="//footnote[not(ancestor::table)]">
        <p class="toc">
          <a href="#endnotes">
            <xsl:text>Son Notlar</xsl:text>
          </a>
        </p>
      </xsl:if>
    </div>
  </xsl:if>
  <div class="body">
    <xsl:apply-templates/>
  </div>
</xsl:template>
<!-- ================================================================= -->

<xsl:key name="dscrs" match="descinfo" use="@name"/>

<xsl:template match="descriptor">
  <xsl:variable name="targets" select="key('dscrs', text())"/>

  <a>
    <xsl:attribute name="href">
      <xsl:call-template name="fname.target">
        <xsl:with-param name="target" select="$targets[1]"/>
      </xsl:call-template>
      <xsl:value-of select="concat('#descdef-', text())"/>
    </xsl:attribute>
  <!--a href="#{concat(@href, text())}"-->
    <tt><b><xsl:apply-templates/></b></tt>
  </a>
</xsl:template>

<xsl:template match="htmltag">
  <code><xsl:text>&lt;</xsl:text>
  <xsl:apply-templates/>
  <xsl:text>></xsl:text></code>
</xsl:template>

<xsl:template match="literal">
  <xsl:variable name="idx" select="concat('value-def-', text())"/>
  <xsl:variable name="targets" select="key('ids', $idx)"/>

  <xsl:choose>
    <xsl:when test="count($targets) > 0">
    <a>
      <xsl:attribute name="href">
        <xsl:call-template name="fname.target">
          <xsl:with-param name="target" select="$targets[1]"/>
        </xsl:call-template>
        <xsl:value-of select="concat('#', $idx)"/>
      </xsl:attribute>
      <!--a href="#{$idx}"-->
        <code><xsl:apply-templates/></code>
      </a>
    </xsl:when>
    <xsl:otherwise>
      <tt><xsl:apply-templates/></tt>
    </xsl:otherwise>
  </xsl:choose>
</xsl:template>

<xsl:key name="props" match="propname" use="text()"/>

<xsl:template match="property">
  <xsl:variable name="targets" select="key('props', text())"/>
  <a>
    <xsl:attribute name="href">
      <xsl:call-template name="fname.target">
        <xsl:with-param name="target" select="$targets[1]"/>
      </xsl:call-template>
      <xsl:value-of select="concat('#', @href, text())"/>
    </xsl:attribute>
    <code><b><xsl:apply-templates/></b></code>
  </a>
</xsl:template>

<xsl:template match="selector">
  <xsl:variable name="idx" select="concat('seldef-', translate(text(), ':', ''))"/>
  <xsl:variable name="targets" select="key('ids', $idx)"/>

  <a>
    <xsl:attribute name="href">
      <xsl:call-template name="fname.target">
        <xsl:with-param name="target" select="$targets[1]"/>
      </xsl:call-template>
      <xsl:value-of select="concat('#', $idx)"/>
    </xsl:attribute>
  <!--a href="#{concat(@href, translate(text(), ':', ''))}"-->
    <code><xsl:apply-templates/></code>
  </a>
</xsl:template>

<xsl:template match="valueref">
  <xsl:variable name="vals" select="key('ids', concat(@href, text()))"/>
  <xsl:variable name="pros" select="key('props', text())"/>
  <xsl:variable name="targets" select="$pros | $vals"/>
  <a>
    <xsl:attribute name="href">
      <xsl:call-template name="fname.target">
        <xsl:with-param name="target" select="$targets[1]"/>
      </xsl:call-template>
      <xsl:value-of select="concat('#', @href, text())"/>
    </xsl:attribute>
  <!--a href="#{concat(@href, text())}"-->
    <var><xsl:apply-templates/></var>
  </a>
</xsl:template>

<xsl:template match="propinfo">
  <xsl:for-each select=".//propname">
    <xsl:variable name="prop" select="concat('propdef-', text())"/>
    <a id="{$prop}" name="{$prop}"/>
    <xsl:if test="../@role='asvalue'">
      <xsl:variable name="val" select="concat('value-def-', text())"/>
      <a id="{$val}" name="{$val}"/>
    </xsl:if>
  </xsl:for-each>
  <table class="propinfoheader" width="100%" cellspacing="0" cellpadding="0">
    <tr>
      <td>
        <xsl:for-each select=".//propname">
          <code><b><xsl:value-of select="."/></b></code>
          <xsl:if test="position()!=last()">
            <xsl:text>, </xsl:text>
          </xsl:if>
        </xsl:for-each>
      </td>
      <td align="right"><em class="rfc2119">NİTELİK</em></td>
    </tr>
  </table>
  <table class="propinfo" width="100%" cellspacing="0" cellpadding="0">
    <colgroup>
      <col width="5%"/>
      <col width="*"/>
    </colgroup>
    <xsl:apply-templates/>
  </table>
</xsl:template>

<xsl:template match="descinfo">
  <xsl:variable name="prop" select="concat('descdef-', @name)"/>
  <a id="{$prop}" name="{$prop}"/>
  <xsl:if test="@role='asvalue'">
    <xsl:variable name="val" select="concat('value-def-', @name)"/>
    <a id="{$val}" name="{$val}"/>
  </xsl:if>
  <table class="propinfoheader" width="100%" cellspacing="0" cellpadding="0">
    <tr>
      <td><code><b><xsl:value-of select="@name"></xsl:value-of></b></code></td>
      <td align="right"><em class="rfc2119">TANIMLAYICI</em></td>
    </tr>
  </table>
  <table class="propinfo" width="100%" cellspacing="0" cellpadding="0">
    <colgroup>
      <col width="5%"/>
      <col width="*"/>
    </colgroup>
    <xsl:apply-templates/>
  </table>
</xsl:template>

<xsl:template match="value">
  <tr valign="top">
    <td align="right" style="font-size: 90%"><em>Değer:</em></td>
    <td><xsl:apply-templates/></td>
  </tr>
</xsl:template>

<xsl:template match="initial">
  <tr valign="top">
    <td align="right" style="font-size: 90%"><em>İlk&#160;değer:</em></td>
    <td><xsl:apply-templates/></td>
  </tr>
</xsl:template>

<xsl:template match="applies-to">
  <tr valign="top">
    <td align="right" style="font-size: 90%"><em>Uygulama yeri:</em></td>
    <td>
      <xsl:apply-templates/>
      <xsl:if test="string()=''">
        <xsl:text>tüm elemanlar</xsl:text>
      </xsl:if>
    </td>
  </tr>
</xsl:template>

<xsl:template match="inherited">
  <tr valign="top">
    <td align="right" style="font-size: 90%"><em>Kalıtsallık:</em></td>
    <td><xsl:apply-templates/></td>
  </tr>
</xsl:template>

<xsl:template match="percentages">
  <tr valign="top">
    <td align="right" style="font-size: 90%"><em>Yüzdelik&#160;değerler:</em></td>
    <td>
      <xsl:apply-templates/>
      <xsl:if test="string()=''">
        <xsl:text>Elverişsiz</xsl:text>
      </xsl:if>
    </td>
  </tr>
</xsl:template>

<xsl:template match="media">
  <tr valign="top">
    <td align="right" style="font-size: 90%"><em>Ortam:</em></td>
    <td><xsl:apply-templates/></td>
  </tr>
</xsl:template>

<xsl:variable name="additional.css">
<xsl:text>
table.propinfoheader,
table.propinfo {  width: 100%; background-color: #e5f0e3;
                  border:1px dotted #999999;
                  padding: 4px 1em; margin: 0em 0em 1em; }

table.propinfo tr td { padding: 0px 10px;}
table.propinfoheader {  margin: 0em;  }
</xsl:text>
</xsl:variable>

<!-- ================================================================= -->

<xsl:template match="p[@role='descriptor-index']">
  <table border="1" width="100%" cellpadding="0" cellspacing="0">
    <colgroup>
      <col width="5%"/>
      <col width="*"/>
      <col width="5%"/>
    </colgroup>
    <thead><tr align="center">
      <th>İsim</th><th>Değer</th><th>İlk Değer</th><th>Ortam</th></tr>
    </thead><tbody>
      <xsl:apply-templates select="//descinfo" mode="propindex">
        <xsl:sort select="@name"/>
      </xsl:apply-templates>
    </tbody>
  </table>
</xsl:template>

<xsl:template match="p[@role='property-index']">
  <table border="1" width="100%" cellpadding="0" cellspacing="0">
    <colgroup>
      <col width="5%"/>
      <col width="*"/>
      <col width="5%"/>
      <col width="5%"/>
      <col width="5%"/>
      <col width="5%"/>
      <col width="5%"/>
    </colgroup>
    <thead><tr align="center">
      <th>İsim</th><th>Değer</th><th>İlk Değer</th><th>Uygulama yeri (Öntanımlı: hepsi)</th><th>Miras alınır mı?</th><th>Yüzdelik değerler (Öntanımlı: Elverişsiz)</th><th>Ortam</th></tr>
    </thead><tbody>
      <xsl:apply-templates select="//propinfo" mode="propindex">
        <xsl:sort select="propname[1]"/>
      </xsl:apply-templates>
    </tbody>
  </table>
</xsl:template>

<!-- ================================================================= -->
<xsl:template match="*" mode="propindex"/>

<xsl:template match="descinfo" mode="propindex">
  <xsl:variable name="fname">
    <xsl:call-template name="fname.target">
      <xsl:with-param name="target" select="."/>
    </xsl:call-template>
  </xsl:variable>
  <tr>
    <td>
    <a href="{concat($fname, '#descdef-', @name)}">
      <code><b><xsl:value-of select="@name"/></b></code>
    </a></td>
    <xsl:apply-templates mode="propindex"/>
  </tr>
</xsl:template>

<xsl:template match="propinfo[not (@role='none')]" mode="propindex">
  <xsl:variable name="fname">
    <xsl:call-template name="fname.target">
      <xsl:with-param name="target" select="."/>
    </xsl:call-template>
  </xsl:variable>
  <tr>
    <td>
        <xsl:for-each select=".//propname">
          <a href="{concat($fname, '#propdef-', text())}">
            <code><b><xsl:value-of select="."/></b></code>
          </a>
          <xsl:if test="position()!=last()">
            <xsl:text>, </xsl:text>
          </xsl:if>
        </xsl:for-each>
      </td>
    <xsl:apply-templates mode="propindex"/>
  </tr>
</xsl:template>

<xsl:template match="value|initial|applies-to|inherited|percentages|media" mode="propindex">
  <td><xsl:apply-templates/></td>
</xsl:template>

<xsl:template match="propname"/>
<!--
for html, command line:
xsltproc css2.xml
-->
</xsl:stylesheet>
