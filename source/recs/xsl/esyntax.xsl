<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
                  xmlns:e="http://www.w3.org/1999/XSL/Spec/ElementSyntax"
                    xmlns="http://www.w3.org/1999/xhtml"
  exclude-result-prefixes="e"
                  version="1.0">

<xsl:strip-space elements="e:sequence e:*"/>
<xsl:template match="e:empty"/>
<xsl:key name="eltnames" match="e:element-syntax" use="@name"/>
<xsl:template match="e:element-syntax-summary">
  <xsl:variable name="elts" select="//e:element-syntax"/>

  <xsl:apply-templates select="$elts">
    <xsl:with-param name="listing" select="'yes'"/>
    <xsl:sort select="@name"/>
  </xsl:apply-templates>
</xsl:template>

<xsl:template match="e:element-syntax">
  <xsl:param name="listing" select="'no'"/>

  <xsl:if test="$listing='no'">
    <xsl:variable name="anchor" select="concat('element-', @name)"/>
    <a id="{$anchor}" name="{$anchor}"/>
  </xsl:if>
  <table class="proto" width="100%" cellpadding="0" cellspacing="0" border="0">
    <tr>
      <td>
        <pre class="proto">
          <xsl:apply-templates select="e:in-category"/>
          <span class="element">
            <xsl:choose>
              <xsl:when test="$listing='no'">
                <xsl:value-of select="concat('&lt;xsl:', @name)"/>
              </xsl:when>
              <xsl:otherwise>
                <xsl:text>&lt;</xsl:text>
                <a>
                  <xsl:attribute name="href">
                    <xsl:call-template name="fname.target">
                      <xsl:with-param name="target" select="key('eltnames', @name)"/>
                    </xsl:call-template>
                    <xsl:value-of select="concat('#element-', @name)"/>
                  </xsl:attribute>
                <!--a class="elisting" href="{concat('#element-', @name)}"-->
                  <xsl:value-of select="concat('xsl:', @name)"/>
                </a>
              </xsl:otherwise>
            </xsl:choose>
            <xsl:choose>
              <xsl:when test="(e:empty) and not (e:attribute)">
                <xsl:text> /></xsl:text>
              </xsl:when>
              <xsl:when test="not (e:attribute)">
                <xsl:text>></xsl:text>
              </xsl:when>
            </xsl:choose>
          </span>
          <xsl:text>&#10;</xsl:text>
          <xsl:apply-templates select="*[not (self::e:in-category)]"/>
          <xsl:if test="not (e:empty)">
            <span class="element">
              <xsl:value-of select="concat('&lt;/xsl:', @name, '>&#10;')"/>
            </span>
          </xsl:if>
        </pre>
      </td>
      <td align="right" valign="top" style="font-variant: small-caps;">eleman</td>
    </tr>
  </table>
</xsl:template>

<!-- ================================================================= -->

<xsl:template match="e:attribute">
  <xsl:text>  </xsl:text>
  <xsl:choose>
    <xsl:when test="@required = 'yes'">
      <b><xsl:value-of select="@name"/></b>
    </xsl:when>
    <xsl:otherwise>
      <code><xsl:value-of select="@name"/></code>
    </xsl:otherwise>
  </xsl:choose>
  <xsl:text> = </xsl:text>
  <xsl:for-each select="*">
    <xsl:apply-templates select="."/>
    <xsl:if test="position() != last()">
      <xsl:text> | </xsl:text>
    </xsl:if>
  </xsl:for-each>

  <xsl:if test="not (following-sibling::e:attribute)">
    <span class="element">
      <xsl:text> </xsl:text>
      <xsl:if test="(following-sibling::e:empty)">
        <xsl:text>/</xsl:text>
      </xsl:if>
      <xsl:text>></xsl:text>
    </span>
  </xsl:if>
  <xsl:text>&#10;</xsl:text>
</xsl:template>

<xsl:template match="e:attribute-value-template">
<xsl:text>{ </xsl:text>
  <xsl:for-each select="*">
    <xsl:apply-templates select="."/>
    <xsl:if test="position() != last()">
      <xsl:text> | </xsl:text>
    </xsl:if>
  </xsl:for-each>
<xsl:text> }</xsl:text>
</xsl:template>

<xsl:template match="e:choice">
<xsl:text>  &lt;!-- İçeriği: (</xsl:text>
<xsl:apply-templates/>
<xsl:text>) -->&#10;</xsl:text>
</xsl:template>

<xsl:template match="e:constant">
  <xsl:value-of select="concat('&#34;', @value, '&#34;')"/>
</xsl:template>

<xsl:template match="e:data-type|e:model">
<var><xsl:value-of select="@name"/></var>
</xsl:template>

<xsl:template match="e:element">
  <xsl:if test="(parent::e:element-syntax)">
    <xsl:text>  &lt;!-- İçeriği: </xsl:text>
  </xsl:if>
  <xsl:variable name="repeat">
    <xsl:choose>
      <xsl:when test="@repeat = 'zero-or-one'">
        <xsl:text>?</xsl:text>
      </xsl:when>
      <xsl:when test="@repeat = 'zero-or-more'">
        <xsl:text>*</xsl:text>
      </xsl:when>
      <xsl:when test="@repeat = 'one-or-more'">
        <xsl:text>+</xsl:text>
      </xsl:when>
    </xsl:choose>
  </xsl:variable>
  <a>
    <xsl:attribute name="href">
      <xsl:call-template name="fname.target">
        <xsl:with-param name="target" select="key('eltnames', @name)"/>
      </xsl:call-template>
       <xsl:value-of select="concat('#element-', @name)"/>
    </xsl:attribute>
  <!--a href="{concat('#element-', @name)}"-->
    <xsl:value-of select="concat('&lt;xsl:', @name, '>')"/>
  </a><xsl:value-of select="$repeat"/>
  <xsl:choose>
    <xsl:when test="(following-sibling::e:element)">
      <xsl:text> | </xsl:text>
    </xsl:when>
    <xsl:when test="(following-sibling::e:model)">
      <xsl:text>, </xsl:text>
    </xsl:when>
  </xsl:choose>
  <xsl:if test="(parent::e:element-syntax)">
    <xsl:text> -->&#10;</xsl:text>
  </xsl:if>
</xsl:template>

<xsl:template match="e:in-category">
<xsl:text>&lt;!-- Grubu: </xsl:text>
<xsl:value-of select="@name"/>
<xsl:text> -->&#10;</xsl:text>
</xsl:template>

<xsl:template match="e:model[(parent::e:element-syntax)]">
<xsl:text>  &lt;!-- İçeriği: </xsl:text>
<var><xsl:value-of select="@name"/></var>
<xsl:text> -->&#10;</xsl:text>
</xsl:template>

<xsl:template match="e:sequence">
  <xsl:variable name="repeat">
    <xsl:choose>
      <xsl:when test="@repeat = 'zero-or-one'">
        <xsl:text>?</xsl:text>
      </xsl:when>
      <xsl:when test="@repeat = 'zero-or-more'">
        <xsl:text>*</xsl:text>
      </xsl:when>
      <xsl:when test="@repeat = 'one-or-more'">
        <xsl:text>+</xsl:text>
      </xsl:when>
    </xsl:choose>
  </xsl:variable>
<xsl:text>  &lt;!-- İçeriği: (</xsl:text>
<xsl:apply-templates/>
<xsl:text>)</xsl:text>
<xsl:value-of select="$repeat"/>
<xsl:text> -->&#10;</xsl:text>
</xsl:template>

<xsl:template match="e:text">
<xsl:text>  &lt;!-- İçeriği: #PCDATA -->&#10;</xsl:text>
</xsl:template>

<xsl:template match="xfunction">
  <a href="{concat(@href, '#function-', text())}">
    <b><code><xsl:apply-templates/></code></b>
  </a>
</xsl:template>

<xsl:template match="code[count(key('eltnames', substring-after(text(), 'xsl:')))>0]">
  <a>
    <xsl:attribute name="href">
      <xsl:call-template name="fname.target">
        <xsl:with-param name="target" select="key('eltnames', substring-after(text(), 'xsl:'))"/>
      </xsl:call-template>
      <xsl:value-of select="concat('#element-', substring-after(text(), 'xsl:'))"/>
    </xsl:attribute>
  <!--a href="{concat('#element-', substring-after(text(), 'xsl:'))}"-->
    <span class="elemref"><tt><xsl:apply-templates/></tt></span>
  </a>
</xsl:template>

<!-- ================================================================= -->

</xsl:stylesheet>
