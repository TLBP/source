<?xml version="1.0" encoding="UTF-8"?>
<!DOCTYPE xsl:stylesheet [

<!ENTITY lowercase "'abcçdefgğhıijklmnoöpqrsştuüvwxyz'">
<!ENTITY uppercase "'ABCÇDEFGĞHIİJKLMNOÖPQRSŞTUÜVWXYZ'">
<!ENTITY allcases "'abcçdefgğhıijklmnoöpqrsştuüvwxyzABCÇDEFGĞHIİJKLMNOÖPQRSŞTUÜVWXYZ'">
<!ENTITY sortcases "'ABCCDEFGGHIIJKLMNOOPQRSSTUUVWXYZABCCDEFGGHIIJKLMNOOPQRSSTUUVWXYZ'">

<!ENTITY primary   'concat(primary/@sortas, primary, see/@sortas, see)'>
<!ENTITY scope     'concat($target, primary/@sortas, primary, see/@sortas, see)'>
<!ENTITY secondary 'concat(secondary/@sortas, secondary)'>
<!ENTITY tertiary  'concat(tertiary/@sortas, tertiary)'>
<!ENTITY fourth    'concat(fourth/@sortas, fourth)'>

<!-- Ayrı bir dosya oluşturabilenler -->
<!ENTITY section   '(ancestor-or-self::set
                     |ancestor-or-self::book
                     |ancestor-or-self::part
                     |ancestor-or-self::reference
                     |ancestor-or-self::chapter
                     |ancestor-or-self::appendix
                     |ancestor-or-self::preface
                     |ancestor-or-self::sect1
                     |ancestor-or-self::sect2[@chunkthis="1"]
                     |ancestor-or-self::refentry
                     |ancestor-or-self::bibliography
                     |ancestor-or-self::glossary
                     |ancestor-or-self::index)[last()]'>

<!-- Bir title'ı olanlar -->
<!ENTITY section.t  '(ancestor-or-self::set
                     |ancestor-or-self::book
                     |ancestor-or-self::part
                     |ancestor-or-self::reference
                     |ancestor-or-self::chapter
                     |ancestor-or-self::appendix
                     |ancestor-or-self::preface
                     |ancestor-or-self::section
                     |ancestor-or-self::sect1
                     |ancestor-or-self::sect2
                     |ancestor-or-self::sect3
                     |ancestor-or-self::sect4
                     |ancestor-or-self::sect5
                     |ancestor-or-self::refsect1
                     |ancestor-or-self::refsect2
                     |ancestor-or-self::refsect3
                     |ancestor-or-self::simplesect
                     |ancestor-or-self::bibliography
                     |ancestor-or-self::glossary
                     |ancestor-or-self::index)[last()]'>

<!ENTITY sep '" "'>
]>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
                version="1.0">

<!-- ==================================================================== -->
<!-- Jeni Tennison gets all the credit for what follows.
     I think I understand it :-) Anyway, I've hacked it a bit, so the
     bugs are mine. -->
<xsl:key name="letter"
         match="indexterm"
         use="translate(substring(&primary;, 1, 1),&lowercase;,&uppercase;)"/>

<xsl:key name="primary"
         match="indexterm"
         use="&primary;"/>

<xsl:key name="secondary"
         match="indexterm"
         use="concat(&primary;, &sep;, &secondary;)"/>

<xsl:key name="tertiary"
         match="indexterm"
         use="concat(&primary;, &sep;, &secondary;, &sep;, &tertiary;)"/>

<xsl:key name="fourth"
         match="indexterm"
         use="concat(&primary;, &sep;, &secondary;, &sep;, &tertiary;, &sep;, &fourth;)"/>

<xsl:key name="see-also"
         match="indexterm[seealso]"
         use="concat(&primary;, &sep;, &secondary;, &sep;, &tertiary;, &sep;, &fourth;, &sep;, seealso)"/>

<xsl:key name="sections" match="*[@id]" use="@id"/>


<xsl:template name="generate-index">
  <xsl:variable name="others" select="key('primary',&primary;)[not(contains(&allcases;, substring(&primary;, 1, 1)))]"/>
  <xsl:message><xsl:text>aloo</xsl:text>
  <xsl:value-of select="count(//indexterm)"/>;
  </xsl:message>
  <!-- Bu kod iptal -->
  <div class="index">
    <xsl:if test="$others">
      <div class="indexdiv">
        <h3>
          <xsl:call-template name="gentext">
            <xsl:with-param name="key" select="'index symbols'"/>
          </xsl:call-template>
        </h3>
        <dl>
          <xsl:apply-templates select="$others[count(.|key('primary',
                                       &primary;)[1]) = 1]"
                               mode="index-primary">
            <xsl:sort select="&primary;"/>
            <xsl:with-param name="is.first" select="1"/>
          </xsl:apply-templates>
        </dl>
      </div>
    </xsl:if>
    <xsl:call-template name="alphabetical-index"/>
  </div>
</xsl:template>


<xsl:template name="alphabetical-index">
  <xsl:param name="letternum" select="0"/>

  <xsl:if test="string-length(&uppercase;) > $letternum">
    <xsl:variable name="letter"
                select="substring(&uppercase;,$letternum + 1,1)"/>

    <xsl:if test="count(key('letter', $letter)) > 0">
      <div class="indexdiv">
        <h3><xsl:value-of select="$letter"/></h3>
        <dl>
<xsl:message><xsl:text>aloo</xsl:text>
<xsl:value-of select="$letter"/>;
<xsl:value-of select="count(.|key('primary', &primary;)[1])"/>;
</xsl:message>
              <xsl:apply-templates select="key('letter', $letter)[count(.|key('primary', &primary;)[1]) = 1]"
                                      mode="index-primary">
                <xsl:with-param name="is.first" select="1"/>
                <xsl:sort select="translate(&primary;,&allcases;,&sortcases;)"/>
              </xsl:apply-templates>
        </dl>
      </div>
    </xsl:if>

    <xsl:call-template name="alphabetical-index">
      <xsl:with-param name="letternum" select="$letternum + 1"/>
    </xsl:call-template>
  </xsl:if>
</xsl:template>

<xsl:template match="indexterm" mode="index-primary">
  <xsl:param name="is.first" select="0"/>

     <!--xsl:message>
      <xsl:value-of select="primary"/>; <xsl:value-of select="&section.t;/title"/>
    </xsl:message-->

  <xsl:variable name="key" select="&primary;"/>
  <xsl:variable name="refs" select="key('primary', $key)"/>

<!--
  <xsl:message>
    <xsl:value-of select="count($refs)"/>; <xsl:value-of select="primary"/>
  </xsl:message>
-->
  <dt>
    <xsl:apply-templates mode="alphabetic-index"/>

    <xsl:for-each select="$refs">
      <xsl:if test="not(./secondary) and not(see)">
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
      <xsl:if test="not(primary)">
        <xsl:if test="position()=1">
          <xsl:text> - Bakınız: </xsl:text>
        </xsl:if>
        <xsl:if test="position()>1">
          <xsl:text>,   </xsl:text>
        </xsl:if>
          <xsl:apply-templates select="." mode="reference-b"/>
      </xsl:if>
    </xsl:for-each>
  </dt>
  <xsl:if test="$refs/secondary or $refs[not(secondary)]/*[self::see or self::seealso]">
    <dd>
      <dl>
        <xsl:apply-templates select="$refs[generate-id() = generate-id(key('see', concat(&primary;, &sep;, &sep;, &sep;, see))[1])]"
                             mode="index-see">
          <xsl:sort select="see"/>
        </xsl:apply-templates>
        <xsl:apply-templates select="$refs[generate-id() = generate-id(key('see-also', concat(&primary;, &sep;, &sep;, &sep;, seealso))[1])]"
                             mode="index-seealso">
          <xsl:sort select="seealso"/>
        </xsl:apply-templates>
        <xsl:apply-templates select="$refs[secondary and count(.|key('secondary', concat(&primary;, &sep;, &secondary;))[1]) = 1]"
                             mode="index-secondary">
          <xsl:with-param name="target" select="$target"/>
          <xsl:sort select="translate(&secondary;,&allcases;,&sortcases;)"/>
        </xsl:apply-templates>
      </dl>
    </dd>
  </xsl:if>
</xsl:template>

<xsl:template match="*" mode="alphabetic-index"/>
<xsl:template match="*" mode="alphabetic-index-s"/>
<xsl:template match="*" mode="alphabetic-index-t"/>
<xsl:template match="*" mode="alphabetic-index-f"/>

<xsl:template match="primary|see" mode="alphabetic-index">
  <a name="{.}"/><span class="indexterm">
    <xsl:apply-templates/>
  </span>
</xsl:template>

<xsl:template match="secondary" mode="alphabetic-index-s">
  <span class="indexterm">
    <xsl:apply-templates/>
  </span>
</xsl:template>

<xsl:template match="tertiary" mode="alphabetic-index-t">
  <span class="indexterm">
    <xsl:apply-templates/>
  </span>
</xsl:template>

<xsl:template match="fourth" mode="alphabetic-index-f">
  <span class="indexterm">
    <xsl:apply-templates/>
  </span>
</xsl:template>

<xsl:template match="indexterm" mode="index-secondary">
    <xsl:variable name="key" select="concat(&primary;, &sep;, &secondary;)"/>
    <xsl:variable name="refs" select="key('secondary', $key)"/>
    <dt>
      <xsl:apply-templates mode="alphabetic-index-s"/>
      <xsl:for-each select="$refs">
        <xsl:if test="not (./tertiary)">
          <xsl:if test="position()=1">
            <xsl:text>:   </xsl:text>
          </xsl:if>
          <xsl:if test="position()>1">
            <xsl:text>,   </xsl:text>
          </xsl:if>
          <xsl:apply-templates select="." mode="reference-b"/>
        </xsl:if>
      </xsl:for-each>
   </dt>
   <xsl:if test="$refs/tertiary or $refs[not(tertiary)]/*[self::see or self::seealso]">
    <dd>
      <dl>
        <xsl:apply-templates select="$refs[generate-id() = generate-id(key('see', concat(&primary;, &sep;, &secondary;, &sep;, &sep;, see))[1])]"
                             mode="index-see">
          <xsl:sort select="see"/>
        </xsl:apply-templates>
        <xsl:apply-templates select="$refs[generate-id() = generate-id(key('see-also', concat(&primary;, &sep;, &secondary;, &sep;, &sep;, seealso))[1])]"
                             mode="index-seealso">
          <xsl:sort select="seealso"/>
        </xsl:apply-templates>
        <xsl:apply-templates select="$refs[tertiary and count(.|key('tertiary', concat($key, &sep;, &tertiary;))[1]) = 1]"
                             mode="index-tertiary">
          <xsl:with-param name="target" select="$target"/>
          <xsl:sort select="translate(&tertiary;,&allcases;,&sortcases;)"/>
        </xsl:apply-templates>
      </dl>
    </dd>
  </xsl:if>
</xsl:template>

<xsl:template match="indexterm" mode="index-tertiary">
    <xsl:variable name="key" select="concat(&primary;, &sep;, &secondary;, &sep;, &tertiary;)"/>
    <xsl:variable name="refs" select="key('tertiary', $key)"/>
    <dt>
      <xsl:apply-templates mode="alphabetic-index-t"/>
      <xsl:for-each select="$refs">
        <xsl:if test="not (./fourth)">
          <xsl:if test="position()=1">
            <xsl:text>:   </xsl:text>
          </xsl:if>
          <xsl:if test="position()>1">
            <xsl:text>,   </xsl:text>
          </xsl:if>
          <xsl:apply-templates select="." mode="reference-b"/>
        </xsl:if>
      </xsl:for-each>
  </dt>
  <xsl:variable name="see" select="$refs/see | $refs/seealso"/>
  <xsl:if test="$refs/fourth or $refs[not(fourth)]/*[self::see or self::seealso]">
    <dd>
      <dl>
        <xsl:apply-templates select="$refs[generate-id() = generate-id(key('see', concat(&primary;, &sep;, &secondary;, &sep;, &tertiary;, &sep;, see))[1])]"
                             mode="index-see">
          <xsl:sort select="see"/>
        </xsl:apply-templates>
        <xsl:apply-templates select="$refs[generate-id() = generate-id(key('see-also', concat(&primary;, &sep;, &secondary;, &sep;, &tertiary;, &sep;, seealso))[1])]"
                             mode="index-seealso">
          <xsl:sort select="seealso"/>
        </xsl:apply-templates>
        <xsl:apply-templates select="$refs[fourth and count(.|key('fourth', concat($key, &sep;, &fourth;))[1]) = 1]"
                             mode="index-fourth">
          <xsl:sort select="translate(&fourth;,&allcases;,&sortcases;)"/>
        </xsl:apply-templates>
      </dl>
    </dd>
  </xsl:if>
</xsl:template>

<xsl:template match="indexterm" mode="index-tertiary">
    <xsl:variable name="key" select="concat(&primary;, &sep;, &secondary;, &sep;, &tertiary;)"/>
    <xsl:variable name="refs" select="key('tertiary', $key)"/>
    <dt>
      <xsl:apply-templates mode="alphabetic-index-t"/>
      <xsl:for-each select="$refs">
        <xsl:if test="not (./fourth)">
          <xsl:if test="position()=1">
            <xsl:text>:   </xsl:text>
          </xsl:if>
          <xsl:if test="position()>1">
            <xsl:text>,   </xsl:text>
          </xsl:if>
          <xsl:apply-templates select="." mode="reference-b"/>
        </xsl:if>
      </xsl:for-each>
  </dt>
  <xsl:variable name="see" select="$refs/see | $refs/seealso"/>
  <xsl:if test="$refs/fourth or $refs[not(fourth)]/*[self::see or self::seealso]">
    <dd>
      <dl>
        <xsl:apply-templates select="$refs[generate-id() = generate-id(key('see', concat(&primary;, &sep;, &secondary;, &sep;, &tertiary;, &sep;, see))[1])]"
                             mode="index-see">
          <xsl:sort select="see"/>
        </xsl:apply-templates>
        <xsl:apply-templates select="$refs[generate-id() = generate-id(key('see-also', concat(&primary;, &sep;, &secondary;, &sep;, &tertiary;, &sep;, seealso))[1])]"
                             mode="index-seealso">
          <xsl:sort select="seealso"/>
        </xsl:apply-templates>
        <xsl:apply-templates select="$refs[fourth and count(.|key('fourth', concat($key, &sep;, &fourth;))[1]) = 1]"
                             mode="index-fourth">
          <xsl:sort select="translate(&fourth;,&allcases;,&sortcases;)"/>
        </xsl:apply-templates>
      </dl>
    </dd>
  </xsl:if>
</xsl:template>


<xsl:template match="indexterm" mode="reference-b">
  <xsl:variable name="targets" select="key('id',@scope)"/>
  <xsl:variable name="this" select="$targets[1]"/>
  <xsl:variable name="title">
    <xsl:apply-templates select="&section.t;" mode="title.markup"/>
  </xsl:variable>

  <xsl:variable name="basename">
    <xsl:call-template name="href.target">
      <xsl:with-param name="object" select="&section;"/>
      <xsl:with-param name="ownerobject" select="."/>
      <xsl:with-param name="owner" select="'indexterm'"/>
    </xsl:call-template>
  </xsl:variable>

  <a>
    <xsl:attribute name="href">
      <xsl:value-of select="concat($basename, '#')"/>
      <xsl:call-template name="indexterm.id"/>
    </xsl:attribute>
    <xsl:value-of select="$title"/> <!-- text only -->
  </a>
</xsl:template>

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

<xsl:template match="indexterm" mode="index-see">
   <dt><xsl:value-of select="see"/></dt>
</xsl:template>

<xsl:template match="indexterm" mode="index-seealso">
   <dt><xsl:value-of select="seealso"/></dt>
</xsl:template>

<xsl:template match="*" mode="index-title-content">
  <xsl:variable name="title">
    <xsl:apply-templates select="&section;" mode="title.markup"/>
  </xsl:variable>

  <xsl:value-of select="$title"/>
</xsl:template>

</xsl:stylesheet>
