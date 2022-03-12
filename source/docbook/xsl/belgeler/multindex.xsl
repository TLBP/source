<?xml version="1.0" encoding="UTF-8"?>
<!DOCTYPE xsl:stylesheet [

<!ENTITY lowercase "'abcçdefgğhıijklmnoöpqrsştuüvwxyz'">
<!ENTITY uppercase "'ABCÇDEFGĞHIİJKLMNOÖPQRSŞTUÜVWXYZ'">
<!ENTITY allcases  "'abcçdefgğhıijklmnoöpqrsştuüvwxyzABCÇDEFGĞHIİJKLMNOÖPQRSŞTUÜVWXYZ'">
<!ENTITY sortcases "'ABCCDEFGGHIIJKLMNOOPQRSSTUUVWXYZABCCDEFGGHIIJKLMNOOPQRSSTUUVWXYZ'">

<!ENTITY primary   'concat(d:primary/@sortas, d:primary, d:see/@sortas, d:see)'>
<!ENTITY scope     'concat($target, d:primary/@sortas, d:primary, d:see/@sortas, d:see)'>
<!ENTITY secondary 'concat(d:secondary/@sortas, d:secondary)'>
<!ENTITY tertiary  'concat(d:tertiary/@sortas, d:tertiary)'>
<!ENTITY fourth    'concat(d:fourth/@sortas, d:fourth)'>

<!-- Ayrı bir dosya oluşturabilenler -->
<!ENTITY section   '(ancestor-or-self::d:set
                     |ancestor-or-self::d:book
                     |ancestor-or-self::d:part
                     |ancestor-or-self::d:reference
                     |ancestor-or-self::d:chapter
                     |ancestor-or-self::d:appendix
                     |ancestor-or-self::d:preface
                     |ancestor-or-self::d:sect1
                     |ancestor-or-self::d:sect2[@userlevel="chunkthis"]
                     |ancestor-or-self::d:refentry
                     |ancestor-or-self::d:bibliography
                     |ancestor-or-self::d:glossary
                     |ancestor-or-self::d:index)[last()]'>

<!-- Bir title'ı olanlar -->
<!ENTITY section.t  '(ancestor-or-self::d:set
                     |ancestor-or-self::d:book
                     |ancestor-or-self::d:part
                     |ancestor-or-self::d:reference
                     |ancestor-or-self::d:chapter
                     |ancestor-or-self::d:appendix
                     |ancestor-or-self::d:preface
                     |ancestor-or-self::d:section
                     |ancestor-or-self::d:sect1
                     |ancestor-or-self::d:sect2
                     |ancestor-or-self::d:sect3
                     |ancestor-or-self::d:sect4
                     |ancestor-or-self::d:sect5
                     |ancestor-or-self::d:refsect1
                     |ancestor-or-self::d:refsect2
                     |ancestor-or-self::d:refsect3
                     |ancestor-or-self::d:simplesect
                     |ancestor-or-self::d:bibliography
                     |ancestor-or-self::d:glossary
                     |ancestor-or-self::d:index)[last()]'>

<!ENTITY sep '" "'>
]>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:d="http://docbook.org/ns/docbook"
xmlns:exslt="http://exslt.org/common"
xmlns:xlink="http://www.w3.org/1999/xlink"
xmlns="http://www.w3.org/1999/xhtml"
extension-element-prefixes="exslt"
exclude-result-prefixes="xlink exslt d"
version="1.0">

<!-- ==================================================================== -->
<!-- Jeni Tennison gets all the credit for what follows.
     I think I understand it :-) Anyway, I've hacked it a bit, so the
     bugs are mine. -->
<xsl:key name="term"
         match="d:indexterm"
         use="@linkend"/>

<xsl:key name="letter"
         match="d:indexterm"
         use="translate(substring(&primary;, 1, 1),&lowercase;,&uppercase;)"/>

<xsl:key name="scope"
         match="d:indexterm"
         use="concat(@linkend, &primary;)"/>

<xsl:key name="primary"
         match="d:indexterm"
         use="&primary;"/>

<xsl:key name="secondary"
         match="d:indexterm"
         use="concat(&primary;, &sep;, &secondary;)"/>

<xsl:key name="tertiary"
         match="indexterm"
         use="concat(&primary;, &sep;, &secondary;, &sep;, &tertiary;)"/>

<xsl:key name="fourth"
         match="d:indexterm"
         use="concat(&primary;, &sep;, &secondary;, &sep;, &tertiary;, &sep;, &fourth;)"/>

<xsl:key name="primary-section"
         match="d:indexterm[not(d:secondary) and not(d:see)]"
         use="concat(&primary;, &sep;, &section;/@xml:id)"/>

<xsl:key name="secondary-section"
         match="d:indexterm[not(d:tertiary) and not(d:see)]"
         use="concat(&primary;, &sep;, &secondary;, &sep;, &section;/@xml:id)"/>

<xsl:key name="tertiary-section"
         match="d:indexterm[not(d:fourth) and not(d:see)]"
         use="concat(&primary;, &sep;, &secondary;, &sep;, &tertiary;, &sep;, &section;/@xml:id)"/>

<xsl:key name="fourth-section"
         match="d:indexterm[not(d:see)]"
         use="concat(&primary;, &sep;, &secondary;, &sep;, &tertiary;, &sep;, &fourth;, &sep;, &section;/@xml:id)"/>

<xsl:key name="see-also"
         match="d:indexterm[d:seealso]"
         use="concat(&primary;, &sep;, &secondary;, &sep;, &tertiary;, &sep;, &fourth;, &sep;, d:seealso)"/>

<xsl:key name="sections" match="*[@id or @xml:id]" use="@id|@xml:id"/>


<xsl:template name="generate-multi-index">
  <xsl:param name="target"></xsl:param>
  <xsl:variable name="others"
    select="key('term', $target)[not(contains(&allcases;, substring(&primary;, 1, 1)))]"/>

  <div class="index">
    <xsl:if test="$others">
      <div class="indexdiv">
        <h3>
          <xsl:call-template name="gentext">
            <xsl:with-param name="key" select="'index symbols'"/>
          </xsl:call-template>
        </h3>
        <dl>
          <xsl:apply-templates select="$others[count(.|key('primary', &primary;)[1]) = 1]"
                               mode="index-primary">

            <xsl:with-param name="is.first" select="1"/>
            <xsl:with-param name="target" select="$target"/>
            <xsl:sort select="&primary;"/>
          </xsl:apply-templates>
        </dl>
      </div>
    </xsl:if>
    <xsl:call-template name="alphabetical-index">
      <xsl:with-param name="target" select="$target"/>
    </xsl:call-template>
  </div>
</xsl:template>

<xsl:template name="alphabetical-index">
  <xsl:param name="target"></xsl:param>
  <xsl:param name="letternum" select="0"/>

  <xsl:if test="string-length(&uppercase;) > $letternum">
    <xsl:variable name="letter"
                select="substring(&uppercase;,$letternum + 1,1)"/>
    <xsl:variable name="burdakiler" select="key('term', $target)"/>
    <xsl:variable name="harftekiler" select="$burdakiler[translate(substring(&primary;, 1, 1),&lowercase;,&uppercase;)=$letter]"/>

    <xsl:if test="count($harftekiler) > 0">
      <div class="indexdiv">
        <h3><xsl:value-of select="$letter"/></h3>
        <dl>
<!--xsl:message>
<xsl:value-of select="$letter"/>; <xsl:value-of select="count($burdakiler)"/>; <xsl:value-of select="count($harftekiler)"/>;
</xsl:message-->
              <xsl:apply-templates select="$harftekiler[count(.|key('scope', &scope;)[1]) = 1]"
                                      mode="index-primary">
                <xsl:with-param name="is.first" select="1"/>
                <xsl:with-param name="target" select="$target"/>
                <xsl:sort select="translate(&primary;,&allcases;,&sortcases;)"/>
              </xsl:apply-templates>
        </dl>
      </div>
    </xsl:if>

    <xsl:call-template name="alphabetical-index">
      <xsl:with-param name="target" select="$target"/>
      <xsl:with-param name="letternum" select="$letternum + 1"/>
    </xsl:call-template>
  </xsl:if>
</xsl:template>


<xsl:template match="d:indexterm" mode="index-primary">
  <xsl:param name="is.first" select="0"/>
  <xsl:param name="target"/>

  <xsl:if test="@linkend = $target">

    <!--xsl:message>
      <xsl:value-of select="primary"/>; <xsl:value-of select="&section.t;/title"/>
    </xsl:message-->

  <xsl:variable name="key" select="concat($target, &primary;)"/>
  <xsl:variable name="refs" select="key('scope', $key)"/>

<!--
  <xsl:message>
    <xsl:value-of select="count($refs)"/>; <xsl:value-of select="primary"/>
  </xsl:message>
-->
  <dt>
    <xsl:apply-templates mode="alphabetic-index"/>

    <xsl:for-each select="$refs">
      <xsl:if test="not(./d:secondary) and not(d:see)">
        <xsl:if test="position()=1">
          <xsl:text>:   </xsl:text>
        </xsl:if>
        <xsl:if test="position()>1">
          <xsl:text>,   </xsl:text>
        </xsl:if>
        <xsl:apply-templates select="." mode="reference-b">
            <xsl:with-param name="target" select="$target"/>
          </xsl:apply-templates>
      </xsl:if>
      <xsl:if test="not(d:primary)">
        <xsl:if test="position()=1">
          <xsl:text> - Bakınız: </xsl:text>
        </xsl:if>
        <xsl:if test="position()>1">
          <xsl:text>,   </xsl:text>
        </xsl:if>
          <xsl:apply-templates select="." mode="reference-b">
            <xsl:with-param name="target" select="$target"/>
          </xsl:apply-templates>
      </xsl:if>
    </xsl:for-each>
  </dt>
  <xsl:if test="$refs/d:secondary or $refs[not(d:secondary)]/*[self::d:see or self::d:seealso]">
    <dd>
      <dl>
        <xsl:apply-templates select="$refs[generate-id() = generate-id(key('see', concat(&primary;, &sep;, &sep;, &sep;, d:see))[1])]"
                             mode="index-see">
          <xsl:sort select="d:see"/>
        </xsl:apply-templates>
        <xsl:apply-templates select="$refs[generate-id() = generate-id(key('see-also', concat(&primary;, &sep;, &sep;, &sep;, d:seealso))[1])]"
                             mode="index-seealso">
          <xsl:sort select="d:seealso"/>
        </xsl:apply-templates>
        <xsl:apply-templates select="$refs[d:secondary and count(.|key('secondary', concat(&primary;, &sep;, &secondary;))[1]) = 1]"
                             mode="index-secondary">
          <xsl:with-param name="target" select="$target"/>
          <xsl:sort select="translate(&secondary;,&allcases;,&sortcases;)"/>
        </xsl:apply-templates>
      </dl>
    </dd>
  </xsl:if>
  </xsl:if>
</xsl:template>

<xsl:template match="*" mode="alphabetic-index"/>
<xsl:template match="*" mode="alphabetic-index-s"/>
<xsl:template match="*" mode="alphabetic-index-t"/>
<xsl:template match="*" mode="alphabetic-index-f"/>

<xsl:template match="d:primary|d:see" mode="alphabetic-index">
  <span name="{.}" class="indexterm">
    <xsl:apply-templates/>
  </span>
</xsl:template>

<xsl:template match="d:secondary" mode="alphabetic-index-s">
  <span class="indexterm">
    <xsl:apply-templates/>
  </span>
</xsl:template>

<xsl:template match="d:tertiary" mode="alphabetic-index-t">
  <span class="indexterm">
    <xsl:apply-templates/>
  </span>
</xsl:template>

<xsl:template match="d:fourth" mode="alphabetic-index-f">
  <span class="indexterm">
    <xsl:apply-templates/>
  </span>
</xsl:template>

<xsl:template match="d:indexterm" mode="index-secondary">
  <xsl:param name="target"/>
  <xsl:if test="@linkend = $target">
    <xsl:variable name="key" select="concat(&primary;, &sep;, &secondary;)"/>
    <xsl:variable name="refs" select="key('secondary', $key)"/>
    <dt>
      <xsl:apply-templates mode="alphabetic-index-s"/>
      <xsl:for-each select="$refs">
        <xsl:if test="not (./d:tertiary)">
          <xsl:if test="position()=1">
            <xsl:text>:   </xsl:text>
          </xsl:if>
          <xsl:if test="position()>1">
            <xsl:text>,   </xsl:text>
          </xsl:if>
          <xsl:apply-templates select="." mode="reference-b">
            <xsl:with-param name="target" select="$target"/>
          </xsl:apply-templates>
        </xsl:if>
      </xsl:for-each>
   </dt>
   <xsl:if test="$refs/d:tertiary or $refs[not(d:tertiary)]/*[self::d:see or self::d:seealso]">
    <dd>
      <dl>
        <xsl:apply-templates select="$refs[generate-id() = generate-id(key('see', concat(&primary;, &sep;, &secondary;, &sep;, &sep;, d:see))[1])]"
                             mode="index-see">
          <xsl:sort select="d:see"/>
        </xsl:apply-templates>
        <xsl:apply-templates select="$refs[generate-id() = generate-id(key('see-also', concat(&primary;, &sep;, &secondary;, &sep;, &sep;, d:seealso))[1])]"
                             mode="index-seealso">
          <xsl:sort select="d:seealso"/>
        </xsl:apply-templates>
        <xsl:apply-templates select="$refs[d:tertiary and count(.|key('tertiary', concat($key, &sep;, &tertiary;))[1]) = 1]"
                             mode="index-tertiary">
          <xsl:with-param name="target" select="$target"/>
          <xsl:sort select="translate(&tertiary;,&allcases;,&sortcases;)"/>
        </xsl:apply-templates>
      </dl>
    </dd>
  </xsl:if>
  </xsl:if>
</xsl:template>

<xsl:template match="d:indexterm" mode="index-tertiary">
  <xsl:param name="target"/>
  <xsl:if test="@linkend = $target">
    <xsl:variable name="key" select="concat(&primary;, &sep;, &secondary;, &sep;, &tertiary;)"/>
    <xsl:variable name="refs" select="key('tertiary', $key)"/>
    <dt>
      <xsl:apply-templates mode="alphabetic-index-t"/>
      <xsl:for-each select="$refs">
        <xsl:if test="not (./d:fourth)">
          <xsl:if test="position()=1">
            <xsl:text>:   </xsl:text>
          </xsl:if>
          <xsl:if test="position()>1">
            <xsl:text>,   </xsl:text>
          </xsl:if>
          <xsl:apply-templates select="." mode="reference-b">
            <xsl:with-param name="target" select="$target"/>
          </xsl:apply-templates>
        </xsl:if>
      </xsl:for-each>
  </dt>
  <xsl:variable name="see" select="$refs/d:see | $refs/d:seealso"/>
  <xsl:if test="$refs/d:fourth or $refs[not(d:fourth)]/*[self::d:see or self::d:seealso]">
    <dd>
      <dl>
        <xsl:apply-templates select="$refs[generate-id() = generate-id(key('see', concat(&primary;, &sep;, &secondary;, &sep;, &tertiary;, &sep;, d:see))[1])]"
                             mode="index-see">
          <xsl:sort select="d:see"/>
        </xsl:apply-templates>
        <xsl:apply-templates select="$refs[generate-id() = generate-id(key('see-also', concat(&primary;, &sep;, &secondary;, &sep;, &tertiary;, &sep;, d:seealso))[1])]"
                             mode="index-seealso">
          <xsl:sort select="d:seealso"/>
        </xsl:apply-templates>
        <xsl:apply-templates select="$refs[d:fourth and count(.|key('fourth', concat($key, &sep;, &fourth;))[1]) = 1]"
                             mode="index-fourth">
          <xsl:with-param name="target" select="$target"/>
          <xsl:sort select="translate(&fourth;,&allcases;,&sortcases;)"/>
        </xsl:apply-templates>
      </dl>
    </dd>
  </xsl:if>
  </xsl:if>
</xsl:template>

<xsl:template match="d:indexterm" mode="index-fourth">
  <xsl:param name="target"/>
  <xsl:if test="@linkend = $target">
    <xsl:variable name="key" select="concat(&primary;, &sep;, &secondary;, &sep;, &tertiary;, &sep;, &fourth;)"/>
    <xsl:variable name="refs" select="key('fourth', $key)"/>
    <dt>
      <xsl:apply-templates mode="alphabetic-index-f"/>
      <xsl:for-each select="$refs">
        <xsl:if test="position()=1">
          <xsl:text>:   </xsl:text>
        </xsl:if>
        <xsl:if test="position()>1">
          <xsl:text>,   </xsl:text>
        </xsl:if>
          <xsl:apply-templates select="." mode="reference-b">
            <xsl:with-param name="target" select="$target"/>
          </xsl:apply-templates>
      </xsl:for-each>
 </dt>
  <xsl:if test="$refs/d:see or $refs/d:seealso">
    <dd>
      <dl>
        <xsl:apply-templates select="$refs[generate-id() = generate-id(key('see', concat(&primary;, &sep;, &secondary;, &sep;, &tertiary;, &sep;, &fourth;, &sep;, d:see))[1])]"
                             mode="index-see">
          <xsl:sort select="d:see"/>
        </xsl:apply-templates>
        <xsl:apply-templates select="$refs[generate-id() = generate-id(key('see-also', concat(&primary;, &sep;, &secondary;, &sep;, &tertiary;, &sep;, &fourth;, &sep;, d:seealso))[1])]"
                             mode="index-seealso">
          <xsl:sort select="d:seealso"/>
        </xsl:apply-templates>
      </dl>
    </dd>
  </xsl:if>
  </xsl:if>
</xsl:template>


<xsl:template match="d:indexterm" mode="reference-b">
  <xsl:param name="target"/>
  <xsl:if test="@linkend = $target">
  <xsl:variable name="targets" select="key('id',@linkend)"/>
  <xsl:variable name="this" select="$targets[1]"/>
  <xsl:variable name="title">
    <xsl:apply-templates select="&section.t;" mode="title.markup"/>
  </xsl:variable>

  <xsl:variable name="basename">
    <xsl:apply-templates mode="chunk-filename" select="&section;"/>
  </xsl:variable>

  <a>
    <xsl:attribute name="href">
      <xsl:value-of select="concat($basename, '#')"/>
      <xsl:call-template name="object.id">
        <xsl:with-param name="object" select="."/>
      </xsl:call-template>
    </xsl:attribute>
    <xsl:value-of select="$title"/> <!-- text only -->
  </a>
  </xsl:if>
</xsl:template>
<!--
<xsl:template match="indexterm" mode="reference">
  <xsl:choose>
    <xsl:when test="@zone and string(@zone)">
      <xsl:call-template name="reference">
        <xsl:with-param name="zones" select="normalize-space(@zone)"/>
      </xsl:call-template>
    </xsl:when>
    <xsl:otherwise>
      <xsl:if test="not (./secondary)">
        <dd><xsl:apply-templates select="." mode="reference-b"/></dd>
      </xsl:if>
    </xsl:otherwise>
  </xsl:choose>

</xsl:template>

<xsl:template name="reference">
  <xsl:param name="zones"/>
  <xsl:choose>
    <xsl:when test="contains($zones, ' ')">
      <xsl:variable name="zone" select="substring-before($zones, ' ')"/>
      <xsl:variable name="target" select="key('sections', $zone)"/>

      <a>
        <xsl:attribute name="href">
          <xsl:call-template name="href.target">
            <xsl:with-param name="object" select="$target[1]"/>
          </xsl:call-template>
        </xsl:attribute>
        <xsl:apply-templates select="$target[1]" mode="index-title-content"/>
      </a>
      <xsl:text>, </xsl:text>
      <xsl:call-template name="reference">
        <xsl:with-param name="zones" select="substring-after($zones, ' ')"/>
      </xsl:call-template>
    </xsl:when>
    <xsl:otherwise>
      <xsl:variable name="zone" select="$zones"/>
      <xsl:variable name="target" select="key('sections', $zone)"/>

      <a>
        <xsl:attribute name="href">
          <xsl:call-template name="href.target">
            <xsl:with-param name="object" select="$target[1]"/>
          </xsl:call-template>
        </xsl:attribute>
        <xsl:apply-templates select="$target[1]" mode="index-title-content"/>
      </a>
    </xsl:otherwise>
  </xsl:choose>
</xsl:template>
-->
<xsl:template match="d:indexterm" mode="index-see">
   <dt><xsl:value-of select="d:see"/></dt>
</xsl:template>

<xsl:template match="d:indexterm" mode="index-seealso">
   <dt><xsl:value-of select="d:seealso"/></dt>
</xsl:template>

<xsl:template match="*" mode="index-title-content">
    <xsl:apply-templates select="&section;" mode="title.markup"/>
</xsl:template>

</xsl:stylesheet>
