<?xml version="1.0" encoding="UTF-8"?>
<!DOCTYPE xsl:stylesheet [

<!-- Bir title'ı olanlar -->
<!ENTITY section    '(ancestor-or-self::set
                     |ancestor-or-self::book
                     |ancestor-or-self::part
                     |ancestor-or-self::reference
                     |ancestor-or-self::chapter
                     |ancestor-or-self::appendix
                     |ancestor-or-self::preface
                     |ancestor-or-self::section
                     |ancestor-or-self::sect1
                     |ancestor-or-self::sect2[(@chunkthis)]
                     |ancestor-or-self::bibliography
                     |ancestor-or-self::glossary)[last()]'>

<!ENTITY section.id 'generate-id(&section;)'>

]>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
 xmlns:d="http://docbook.org/ns/docbook"
 exclude-result-prefixes="d" version='1.0'>

<xsl:key name="item"
         match="d:itemizedlist"
         use="@role"/>

<xsl:template name="generate-item-index">
  <xsl:param name="target"></xsl:param>
  <xsl:variable name="subjects" select="key('item', $target)"/>
  <!--xsl:message>
    <xsl:value-of select="$target"/>;<xsl:value-of select="count($subjects)"/>
  </xsl:message-->
  <xsl:apply-templates select="$subjects" mode="index-list">
    <xsl:with-param name="target" select="$target"/>
  </xsl:apply-templates>
</xsl:template>

<xsl:template match="d:itemizedlist" mode="index-list">
  <xsl:param name="target"/>
  <xsl:if test="@role = $target">
    <!--xsl:variable name="targets" select="key('id',@role)"/>
    <xsl:variable name="this" select="$targets[1]"/>
    <xsl:variable name="title">
      <xsl:apply-templates select="&section;" mode="title.markup"/>
    </xsl:variable>

    <xsl:variable name="sect.url">
      <xsl:call-template name="href.target">
        <xsl:with-param name="object" select="&section;"/>
        <xsl:with-param name="ownerobject" select="$this"/>
        <xsl:with-param name="owner" select="'indexterm'"/>
      </xsl:call-template>
    </xsl:variable>
    <a>
      <xsl:attribute name="href">
        <xsl:value-of select="$sect.url"/>
      </xsl:attribute>
      <xsl:value-of select="$title"/>
    </a-->
    <xsl:apply-templates select="."/>
  </xsl:if>
</xsl:template>

<xsl:template name="generate-abstract-index">
  <xsl:choose>
    <xsl:when test="name(..)='d:book' or name(..)='d:part' or name(..)='d:reference'">
      <xsl:variable name="nodes" select="../d:part
                                        |../d:reference
                                        |../d:preface
                                        |../d:chapter
                                        |../d:article
                                        |../d:bibliography
                                        |../d:glossary
                                        |../d:bridgehead"/>
      <xsl:if test="$nodes">
        <div class="toc">
          <xsl:element name="dt">
            <xsl:apply-templates select="$nodes" mode="toc">
              <xsl:with-param name="owner" select="'division.toc'"/>
              <xsl:with-param name="object" select=".."/>
              <xsl:with-param name="role" select="'abstracts'"/>
            </xsl:apply-templates>
          </xsl:element>
        </div>
      </xsl:if>
    </xsl:when>
    <!-- Bundan sonrakiler lazım olursa yazılacak -->
    <xsl:when test="name(..)='d:chapter' or name(..)='d:article'">
      <xsl:call-template name="component.toc">
        <xsl:with-param name="role" select="'abstracts'"/>
      </xsl:call-template>
    </xsl:when>
    <xsl:otherwise>
      <xsl:call-template name="section.toc">
        <xsl:with-param name="role" select="'abstracts'"/>
      </xsl:call-template>
    </xsl:otherwise>
  </xsl:choose>
</xsl:template>

<xsl:template name="generate-tip-index">
  <xsl:choose>
    <xsl:when test="name(..)='d:book' or name(..)='d:part' or name(..)='d:reference'">
      <xsl:variable name="nodes" select="../d:part
                                        |../d:reference
                                        |../d:preface
                                        |../d:chapter
                                        |../d:article
                                        |../d:bibliography
                                        |../d:glossary
                                        |../d:bridgehead"/>
      <xsl:if test="$nodes">
        <div class="toc">
          <xsl:element name="dt">
            <xsl:apply-templates select="$nodes" mode="toc">
              <xsl:with-param name="owner" select="'division.toc'"/>
              <xsl:with-param name="object" select=".."/>
              <xsl:with-param name="role" select="'tips'"/>
            </xsl:apply-templates>
          </xsl:element>
        </div>
      </xsl:if>
    </xsl:when>
    <!-- Bundan sonrakiler lazım olursa yazılacak -->
    <xsl:when test="name(..)='d:chapter' or name(..)='d:article'">
      <xsl:call-template name="component.toc">
        <xsl:with-param name="role" select="'tips'"/>
      </xsl:call-template>
    </xsl:when>
    <xsl:otherwise>
      <xsl:call-template name="section.toc">
        <xsl:with-param name="role" select="'tips'"/>
      </xsl:call-template>
    </xsl:otherwise>
  </xsl:choose>
</xsl:template>

<xsl:template name="generate-example-index">
  <xsl:variable name="subjects" select="..//d:example"/>
  <!--xsl:message>
    <xsl:value-of select="$target"/>;<xsl:value-of select="count($subjects)"/>
  </xsl:message-->
  <dl>
    <xsl:apply-templates select="$subjects" mode="index-list">
      <xsl:with-param name="ownerobject" select="."/>
    </xsl:apply-templates>
  </dl>
</xsl:template>

<xsl:template match="d:example" mode="index-list">
  <xsl:param name="this"/>
  <xsl:variable name="sect.url">
    <xsl:call-template name="href.target">
      <xsl:with-param name="object" select="&section;"/>
      <xsl:with-param name="ownerobject" select="$this"/>
      <xsl:with-param name="owner" select="'d:indexterm'"/>
    </xsl:call-template>
  </xsl:variable>
  <dt><a>
    <xsl:attribute name="href">
      <xsl:value-of select="concat($sect.url, '#')"/>
      <xsl:call-template name="example.id"/>
    </xsl:attribute>
    <xsl:apply-templates select="." mode="object.title.markup">
      <xsl:with-param name="allow-anchors" select="1"/>
    </xsl:apply-templates>
  </a></dt>
</xsl:template>

<xsl:template match="*" mode="subtoc.abstracts"/>

<xsl:template match="d:abstract" mode="subtoc.abstracts">
  <xsl:apply-templates/>
</xsl:template>


</xsl:stylesheet>
