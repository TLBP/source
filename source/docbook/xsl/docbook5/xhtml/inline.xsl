<?xml version="1.0" encoding="utf-8"?>
<!--This file was created automatically by html2xhtml-->
<!--from the HTML stylesheets.-->
<xsl:stylesheet
xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
xmlns:d="http://docbook.org/ns/docbook"
xmlns:xl="http://www.w3.org/1999/xlink"
xmlns:suwl="http://nwalsh.com/xslt/ext/com.nwalsh.saxon.UnwrapLinks" xmlns="http://www.w3.org/1999/xhtml"
exclude-result-prefixes="xl suwl d" version="1.0">

<!-- ********************************************************************
     $Id: inline.xsl 9963 2015-05-20 18:37:42Z bobstayton $
     ********************************************************************

     This file is part of the XSL DocBook Stylesheet distribution.
     See ../README or http://docbook.sf.net/release/xsl/current/ for
     copyright and other information.

     ******************************************************************** -->

<xsl:key name="glossentries" match="d:glossentry" use="normalize-space(d:glossterm)"/>
<xsl:key name="glossentries" match="d:glossentry" use="normalize-space(d:glossterm/@baseform)"/>

<xsl:template name="simple.xlink">
  <xsl:param name="node" select="."/>
  <xsl:param name="content">
    <xsl:apply-templates/>
  </xsl:param>
  <xsl:param name="linkend" select="$node/@linkend"/>
  <xsl:param name="xhref" select="$node/@xl:href"/>

  <!-- check for nested links, which are undefined in the output -->
  <xsl:if test="($linkend or $xhref) and $node/ancestor::*[@xl:href or @linkend]">
    <xsl:message>
      <xsl:text>WARNING: nested link may be undefined in output: </xsl:text>
      <xsl:text>&lt;</xsl:text>
      <xsl:value-of select="name($node)"/>
      <xsl:text> </xsl:text>
      <xsl:choose>
        <xsl:when test="$linkend">
          <xsl:text>@linkend = '</xsl:text>
          <xsl:value-of select="$linkend"/>
          <xsl:text>'&gt;</xsl:text>
        </xsl:when>
        <xsl:when test="$xhref">
          <xsl:text>@xl:href = '</xsl:text>
          <xsl:value-of select="$xhref"/>
          <xsl:text>'&gt;</xsl:text>
        </xsl:when>
      </xsl:choose>
      <xsl:text> nested inside parent element </xsl:text>
      <xsl:value-of select="name($node/parent::*)"/>
    </xsl:message>
  </xsl:if>

  <!-- Support for @xl:show -->
  <xsl:variable name="target.show">
    <xsl:choose>
      <xsl:when test="$node/@xl:show = 'new'">_blank</xsl:when>
      <xsl:when test="$node/@xl:show = 'replace'">_top</xsl:when>
      <xsl:otherwise/>
    </xsl:choose>
  </xsl:variable>

  <xsl:variable name="link">
    <xsl:choose>
      <xsl:when test="$xhref and                        (not($node/@xl:type) or                             $node/@xl:type='simple')">

        <!-- Is it a local idref or a uri? -->
        <xsl:variable name="is.idref">
          <xsl:choose>
            <!-- if the href starts with # and does not contain an "(" -->
            <!-- or if the href starts with #xpointer(id(, it's just an ID -->
            <xsl:when test="starts-with($xhref,'#')                             and (not(contains($xhref,'('))                             or starts-with($xhref,                                        '#xpointer(id('))">1</xsl:when>
            <xsl:otherwise>0</xsl:otherwise>
          </xsl:choose>
        </xsl:variable>

        <!-- Is it an olink ? -->
        <xsl:variable name="is.olink">
          <xsl:choose>
            <!-- If xl:role="http://docbook.org/xlink/role/olink" -->
            <!-- and if the href contains # -->
            <xsl:when test="contains($xhref,'#') and                  @xl:role = $xolink.role">1</xsl:when>
            <xsl:otherwise>0</xsl:otherwise>
          </xsl:choose>
        </xsl:variable>

        <xsl:choose>
          <xsl:when test="$is.olink = 1">
            <xsl:call-template name="olink">
              <xsl:with-param name="content" select="$content"/>
            </xsl:call-template>
          </xsl:when>

          <xsl:when test="$is.idref = 1">

            <xsl:variable name="idref">
              <xsl:call-template name="xpointer.idref">
                <xsl:with-param name="xpointer" select="$xhref"/>
              </xsl:call-template>
            </xsl:variable>

            <xsl:variable name="targets" select="key('id',$idref)"/>
            <xsl:variable name="target" select="$targets[1]"/>

            <xsl:call-template name="check.id.unique">
              <xsl:with-param name="linkend" select="$idref"/>
            </xsl:call-template>

            <xsl:choose>
              <xsl:when test="count($target) = 0">
                <xsl:message>
                  <xsl:text>XLink to nonexistent id: </xsl:text>
                  <xsl:value-of select="$idref"/>
                </xsl:message>
                <xsl:copy-of select="$content"/>
              </xsl:when>

              <xsl:otherwise>
                <a>
                  <xsl:apply-templates select="." mode="common.html.attributes"/>
                  <!-- id attribute goes on the element calling
                  simple.xlink, not on the anchor element, so
                  this is commented out:
                  <xsl:call-template name="id.attribute"/>
                  -->

                  <xsl:attribute name="href">
                    <xsl:call-template name="href.target">
                      <xsl:with-param name="object" select="$target"/>
                    </xsl:call-template>
                  </xsl:attribute>

                  <xsl:choose>
                    <xsl:when test="$node/@xl:title">
                      <xsl:attribute name="title">
                        <xsl:value-of select="$node/@xl:title"/>
                      </xsl:attribute>
                    </xsl:when>
                    <xsl:otherwise>
                      <xsl:apply-templates select="$target" mode="html.title.attribute"/>
                    </xsl:otherwise>
                  </xsl:choose>

                  <xsl:if test="$target.show !=''">
                    <xsl:attribute name="target">
                      <xsl:value-of select="$target.show"/>
                    </xsl:attribute>
                  </xsl:if>

                  <xsl:copy-of select="$content"/>

                </a>
              </xsl:otherwise>
            </xsl:choose>
          </xsl:when>

          <!-- otherwise it's a URI -->
          <xsl:otherwise>
            <a>
              <xsl:apply-templates select="." mode="common.html.attributes"/>
              <xsl:call-template name="id.attribute"/>
              <xsl:attribute name="href">
                <xsl:value-of select="$xhref"/>
              </xsl:attribute>
              <xsl:if test="$node/@xl:title">
                <xsl:attribute name="title">
                  <xsl:value-of select="$node/@xl:title"/>
                </xsl:attribute>
              </xsl:if>

              <!-- For URIs, use @xl:show if defined, otherwise use ulink.target -->
              <xsl:choose>
                <xsl:when test="$target.show !=''">
                  <xsl:attribute name="target">
                    <xsl:value-of select="$target.show"/>
                  </xsl:attribute>
                </xsl:when>
                <xsl:when test="$ulink.target !=''">
                  <xsl:attribute name="target">
                    <xsl:value-of select="$ulink.target"/>
                  </xsl:attribute>
                </xsl:when>
              </xsl:choose>

              <xsl:copy-of select="$content"/>
            </a>
          </xsl:otherwise>
        </xsl:choose>
      </xsl:when>

      <xsl:when test="$linkend">
        <xsl:variable name="targets" select="key('id',$linkend)"/>
        <xsl:variable name="target" select="$targets[1]"/>

        <xsl:call-template name="check.id.unique">
          <xsl:with-param name="linkend" select="$linkend"/>
        </xsl:call-template>

        <a>
          <xsl:apply-templates select="." mode="common.html.attributes"/>
          <xsl:call-template name="id.attribute"/>
          <xsl:attribute name="href">
            <xsl:call-template name="href.target">
              <xsl:with-param name="object" select="$target"/>
            </xsl:call-template>
          </xsl:attribute>

          <xsl:apply-templates select="$target" mode="html.title.attribute"/>

          <xsl:copy-of select="$content"/>

        </a>
      </xsl:when>
      <xsl:otherwise>
        <xsl:copy-of select="$content"/>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:variable>

  <xsl:choose>
    <xsl:when test="function-available('suwl:unwrapLinks')">
      <xsl:copy-of select="suwl:unwrapLinks($link)"/>
    </xsl:when>
    <xsl:otherwise>
      <xsl:copy-of select="$link"/>
    </xsl:otherwise>
  </xsl:choose>
</xsl:template>

<xsl:template name="inline.charseq">
  <xsl:param name="content">
    <xsl:apply-templates/>
  </xsl:param>

  <xsl:param name="contentwithlink">
    <xsl:call-template name="anchor"/>
    <xsl:call-template name="simple.xlink">
      <xsl:with-param name="content" select="$content"/>
    </xsl:call-template>
  </xsl:param>

  <!-- * if you want output from the inline.charseq template wrapped in -->
  <!-- * something other than a Span, call the template with some value -->
  <!-- * for the 'wrapper-name' param -->
  <xsl:param name="wrapper-name">span</xsl:param>
  <xsl:element name="{$wrapper-name}" namespace="http://www.w3.org/1999/xhtml">
    <xsl:call-template name="common.html.attributes"/>
    <xsl:call-template name="id.attribute"/>
    <xsl:call-template name="generate.html.title"/>
    <xsl:copy-of select="$contentwithlink"/>
    <xsl:call-template name="apply-annotations"/>
  </xsl:element>
</xsl:template>

<xsl:template name="inline.monoseq">
  <xsl:param name="content">
    <xsl:apply-templates/>
  </xsl:param>

  <xsl:param name="contentwithlink">
    <xsl:call-template name="anchor"/>
    <xsl:call-template name="simple.xlink">
      <xsl:with-param name="content" select="$content"/>
    </xsl:call-template>
  </xsl:param>

  <code>
    <xsl:apply-templates select="." mode="common.html.attributes"/>
    <xsl:call-template name="id.attribute"/>
    <xsl:copy-of select="$contentwithlink"/>
    <xsl:call-template name="apply-annotations"/>
  </code>
</xsl:template>

<xsl:template name="inline.boldseq">
  <xsl:param name="content">
    <xsl:apply-templates/>
  </xsl:param>

  <xsl:param name="contentwithlink">
    <xsl:call-template name="anchor"/>
    <xsl:call-template name="simple.xlink">
      <xsl:with-param name="content" select="$content"/>
    </xsl:call-template>
  </xsl:param>

  <span>
    <xsl:apply-templates select="." mode="common.html.attributes"/>
    <xsl:call-template name="id.attribute"/>

    <!-- don't put <strong> inside figure, example, or table titles -->
    <xsl:choose>
      <xsl:when test="local-name(..) = 'title'                       and (local-name(../..) = 'figure'                       or local-name(../..) = 'example'                       or local-name(../..) = 'table')">
        <xsl:copy-of select="$contentwithlink"/>
      </xsl:when>
      <xsl:otherwise>
        <strong>
          <xsl:copy-of select="$contentwithlink"/>
        </strong>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:call-template name="apply-annotations"/>
  </span>
</xsl:template>

<xsl:template name="inline.italicseq">
  <xsl:param name="content">
    <xsl:apply-templates/>
  </xsl:param>

  <xsl:param name="contentwithlink">
    <xsl:call-template name="anchor"/>
    <xsl:call-template name="simple.xlink">
      <xsl:with-param name="content" select="$content"/>
    </xsl:call-template>
  </xsl:param>

  <em>
    <xsl:call-template name="common.html.attributes"/>
    <xsl:call-template name="id.attribute"/>
    <xsl:copy-of select="$contentwithlink"/>
    <xsl:call-template name="apply-annotations"/>
  </em>
</xsl:template>

<xsl:template name="inline.boldmonoseq">
  <xsl:param name="content">
    <xsl:apply-templates/>
  </xsl:param>

  <xsl:param name="contentwithlink">
    <xsl:call-template name="anchor"/>
    <xsl:call-template name="simple.xlink">
      <xsl:with-param name="content" select="$content"/>
    </xsl:call-template>
  </xsl:param>

  <!-- don't put <strong> inside figure, example, or table titles -->
  <!-- or other titles that may already be represented with <strong>'s. -->
  <xsl:choose>
    <xsl:when test="local-name(..) = 'title'                     and (local-name(../..) = 'figure'                          or local-name(../..) = 'example'                          or local-name(../..) = 'table'                          or local-name(../..) = 'formalpara')">
      <code>
        <xsl:call-template name="common.html.attributes"/>
        <xsl:call-template name="id.attribute"/>
        <xsl:copy-of select="$contentwithlink"/>
        <xsl:call-template name="apply-annotations"/>
      </code>
    </xsl:when>
    <xsl:otherwise>
      <strong>
        <xsl:call-template name="common.html.attributes"/>
        <xsl:call-template name="id.attribute"/>
        <code>
          <xsl:call-template name="generate.html.title"/>
          <xsl:call-template name="dir"/>
          <xsl:copy-of select="$contentwithlink"/>
        </code>
        <xsl:call-template name="apply-annotations"/>
      </strong>
    </xsl:otherwise>
  </xsl:choose>
</xsl:template>

<xsl:template name="inline.italicmonoseq">
  <xsl:param name="content">
    <xsl:apply-templates/>
  </xsl:param>

  <xsl:param name="contentwithlink">
    <xsl:call-template name="anchor"/>
    <xsl:call-template name="simple.xlink">
      <xsl:with-param name="content" select="$content"/>
    </xsl:call-template>
  </xsl:param>

  <em>
    <xsl:call-template name="common.html.attributes"/>
    <xsl:call-template name="id.attribute"/>
    <code>
      <xsl:call-template name="generate.html.title"/>
      <xsl:call-template name="dir"/>
      <xsl:copy-of select="$contentwithlink"/>
      <xsl:call-template name="apply-annotations"/>
    </code>
  </em>
</xsl:template>

<xsl:template name="inline.superscriptseq">
  <xsl:param name="content">
    <xsl:apply-templates/>
  </xsl:param>

  <xsl:param name="contentwithlink">
    <xsl:call-template name="anchor"/>
    <xsl:call-template name="simple.xlink">
      <xsl:with-param name="content" select="$content"/>
    </xsl:call-template>
  </xsl:param>

  <sup>
    <xsl:call-template name="generate.html.title"/>
    <xsl:call-template name="id.attribute"/>
    <xsl:call-template name="dir"/>
    <xsl:copy-of select="$contentwithlink"/>
    <xsl:call-template name="apply-annotations"/>
  </sup>
</xsl:template>

<xsl:template name="inline.subscriptseq">
  <xsl:param name="content">
    <xsl:apply-templates/>
  </xsl:param>

  <xsl:param name="contentwithlink">
    <xsl:call-template name="anchor"/>
    <xsl:call-template name="simple.xlink">
      <xsl:with-param name="content" select="$content"/>
    </xsl:call-template>
  </xsl:param>

  <sub>
    <xsl:call-template name="generate.html.title"/>
    <xsl:call-template name="id.attribute"/>
    <xsl:call-template name="dir"/>
    <xsl:copy-of select="$contentwithlink"/>
    <xsl:call-template name="apply-annotations"/>
  </sub>
</xsl:template>

<!-- ==================================================================== -->
<!-- some special cases -->

<xsl:template match="d:author">
  <xsl:param name="content">
    <xsl:call-template name="person.name"/>
  </xsl:param>

  <xsl:param name="contentwithlink">
    <xsl:call-template name="anchor"/>
    <xsl:call-template name="simple.xlink">
      <xsl:with-param name="content" select="$content"/>
    </xsl:call-template>
    <xsl:call-template name="apply-annotations"/>
  </xsl:param>

  <span>
    <xsl:call-template name="common.html.attributes"/>
    <xsl:call-template name="id.attribute"/>
    <xsl:copy-of select="$contentwithlink"/>
  </span>
</xsl:template>

<xsl:template match="d:editor">
  <xsl:param name="content">
    <xsl:call-template name="person.name"/>
  </xsl:param>

  <xsl:param name="contentwithlink">
    <xsl:call-template name="anchor"/>
    <xsl:call-template name="simple.xlink">
      <xsl:with-param name="content" select="$content"/>
    </xsl:call-template>
    <xsl:call-template name="apply-annotations"/>
  </xsl:param>

  <span>
    <xsl:call-template name="common.html.attributes"/>
    <xsl:call-template name="id.attribute"/>
    <xsl:copy-of select="$contentwithlink"/>
  </span>
</xsl:template>

<xsl:template match="d:othercredit">
  <xsl:param name="content">
    <xsl:call-template name="person.name"/>
  </xsl:param>

  <xsl:param name="contentwithlink">
    <xsl:call-template name="anchor"/>
    <xsl:call-template name="simple.xlink">
      <xsl:with-param name="content" select="$content"/>
    </xsl:call-template>
    <xsl:call-template name="apply-annotations"/>
  </xsl:param>

  <span>
    <xsl:call-template name="common.html.attributes"/>
    <xsl:call-template name="id.attribute"/>
    <xsl:copy-of select="$contentwithlink"/>
  </span>
</xsl:template>

<xsl:template match="d:authorinitials">
  <xsl:call-template name="inline.charseq"/>
</xsl:template>

<!-- ==================================================================== -->

<xsl:template match="d:accel">
  <xsl:call-template name="inline.charseq"/>
</xsl:template>

<xsl:template match="d:action">
  <xsl:call-template name="inline.charseq"/>
</xsl:template>

<xsl:template match="d:application">
  <xsl:call-template name="inline.charseq"/>
</xsl:template>

<xsl:template match="d:classname">
  <xsl:call-template name="inline.monoseq"/>
</xsl:template>

<xsl:template match="d:exceptionname">
  <xsl:call-template name="inline.monoseq"/>
</xsl:template>

<xsl:template match="d:interfacename">
  <xsl:call-template name="inline.monoseq"/>
</xsl:template>

<xsl:template match="d:methodname">
  <xsl:call-template name="inline.monoseq"/>
</xsl:template>

<xsl:template match="d:command">
  <xsl:call-template name="inline.boldseq"/>
</xsl:template>

<xsl:template match="d:computeroutput">
  <xsl:call-template name="inline.monoseq"/>
</xsl:template>

<xsl:template match="d:constant">
  <xsl:call-template name="inline.monoseq"/>
</xsl:template>

<xsl:template match="d:database">
  <xsl:call-template name="inline.charseq"/>
</xsl:template>

<xsl:template match="d:date">
  <!-- should this support locale-specific formatting? how? -->
  <xsl:call-template name="inline.charseq"/>
</xsl:template>

<xsl:template match="d:errorcode">
  <xsl:call-template name="inline.charseq"/>
</xsl:template>

<xsl:template match="d:errorname">
  <xsl:call-template name="inline.charseq"/>
</xsl:template>

<xsl:template match="d:errortype">
  <xsl:call-template name="inline.charseq"/>
</xsl:template>

<xsl:template match="d:errortext">
  <xsl:call-template name="inline.charseq"/>
</xsl:template>

<xsl:template match="d:envar">
  <xsl:call-template name="inline.monoseq"/>
</xsl:template>

<xsl:template match="d:filename">
  <xsl:call-template name="inline.monoseq"/>
</xsl:template>

<xsl:template match="d:function">
  <xsl:choose>
    <xsl:when test="$function.parens != '0'                     and (d:parameter or d:function or d:replaceable)">
      <xsl:variable name="nodes" select="text()|*"/>
      <xsl:call-template name="inline.monoseq">
        <xsl:with-param name="content">
          <xsl:call-template name="simple.xlink">
            <xsl:with-param name="content">
              <xsl:apply-templates select="$nodes[1]"/>
            </xsl:with-param>
          </xsl:call-template>
        </xsl:with-param>
      </xsl:call-template>
      <xsl:text>(</xsl:text>
      <xsl:apply-templates select="$nodes[position()&gt;1]"/>
      <xsl:text>)</xsl:text>
    </xsl:when>
    <xsl:otherwise>
     <xsl:call-template name="inline.monoseq"/>
    </xsl:otherwise>
  </xsl:choose>
</xsl:template>

<xsl:template match="d:function/d:parameter" priority="2">
  <xsl:call-template name="inline.italicmonoseq"/>
  <xsl:if test="$function.parens != 0 and following-sibling::*">
    <xsl:text>, </xsl:text>
  </xsl:if>
</xsl:template>

<xsl:template match="d:function/d:replaceable" priority="2">
  <xsl:call-template name="inline.italicmonoseq"/>
  <xsl:if test="$function.parens != 0 and following-sibling::*">
    <xsl:text>, </xsl:text>
  </xsl:if>
</xsl:template>

<xsl:template match="d:guibutton">
  <xsl:call-template name="inline.charseq"/>
</xsl:template>

<xsl:template match="d:guiicon">
  <xsl:call-template name="inline.charseq"/>
</xsl:template>

<xsl:template match="d:guilabel">
  <xsl:call-template name="inline.charseq"/>
</xsl:template>

<xsl:template match="d:guimenu">
  <xsl:call-template name="inline.charseq"/>
</xsl:template>

<xsl:template match="d:guimenuitem">
  <xsl:call-template name="inline.charseq"/>
</xsl:template>

<xsl:template match="d:guisubmenu">
  <xsl:call-template name="inline.charseq"/>
</xsl:template>

<xsl:template match="d:hardware">
  <xsl:call-template name="inline.charseq"/>
</xsl:template>

<xsl:template match="d:interface">
  <xsl:call-template name="inline.charseq"/>
</xsl:template>

<xsl:template match="d:interfacedefinition">
  <xsl:call-template name="inline.charseq"/>
</xsl:template>

<xsl:template match="d:keycap">
  <xsl:choose>
    <xsl:when test="@function and normalize-space(.) = ''">
      <xsl:call-template name="inline.boldseq">
        <xsl:with-param name="content">
          <xsl:call-template name="gentext.template">
            <xsl:with-param name="context" select="'keycap'"/>
            <xsl:with-param name="name" select="@function"/>
          </xsl:call-template>
        </xsl:with-param>
      </xsl:call-template>
    </xsl:when>
    <xsl:otherwise>
      <xsl:call-template name="inline.boldseq"/>
    </xsl:otherwise>
  </xsl:choose>
</xsl:template>

<xsl:template match="d:keycode">
  <xsl:call-template name="inline.charseq"/>
</xsl:template>

<xsl:template match="d:keysym">
  <xsl:call-template name="inline.charseq"/>
</xsl:template>

<xsl:template match="d:literal">
  <xsl:call-template name="inline.monoseq"/>
</xsl:template>

<xsl:template match="d:code">
  <xsl:call-template name="inline.monoseq"/>
</xsl:template>

<xsl:template match="d:medialabel">
  <xsl:call-template name="inline.italicseq"/>
</xsl:template>

<xsl:template match="d:shortcut">
  <xsl:call-template name="inline.boldseq"/>
</xsl:template>

<xsl:template match="d:mousebutton">
  <xsl:call-template name="inline.charseq"/>
</xsl:template>

<xsl:template match="d:option">
  <xsl:call-template name="inline.monoseq"/>
</xsl:template>

<xsl:template match="d:package">
  <xsl:call-template name="inline.charseq"/>
</xsl:template>

<xsl:template match="d:parameter">
  <xsl:call-template name="inline.italicmonoseq"/>
</xsl:template>

<xsl:template match="d:property">
  <xsl:call-template name="inline.charseq"/>
</xsl:template>

<xsl:template match="d:prompt">
  <xsl:call-template name="inline.monoseq"/>
</xsl:template>

<xsl:template match="d:replaceable" priority="1">
  <xsl:call-template name="inline.italicmonoseq"/>
</xsl:template>

<xsl:template match="d:returnvalue">
  <xsl:call-template name="inline.charseq"/>
</xsl:template>

<xsl:template match="d:structfield">
  <xsl:call-template name="inline.italicmonoseq"/>
</xsl:template>

<xsl:template match="d:structname">
  <xsl:call-template name="inline.charseq"/>
</xsl:template>

<xsl:template match="d:symbol">
  <xsl:call-template name="inline.charseq"/>
</xsl:template>

<xsl:template match="d:systemitem">
  <xsl:call-template name="inline.monoseq"/>
</xsl:template>

<xsl:template match="d:token">
  <xsl:call-template name="inline.charseq"/>
</xsl:template>

<xsl:template match="d:type">
  <xsl:call-template name="inline.charseq"/>
</xsl:template>

<xsl:template match="d:userinput">
  <xsl:call-template name="inline.boldmonoseq"/>
</xsl:template>

<xsl:template match="d:abbrev">
  <xsl:call-template name="inline.charseq">
    <xsl:with-param name="wrapper-name">abbr</xsl:with-param>
  </xsl:call-template>
</xsl:template>

<xsl:template match="d:acronym">
  <xsl:call-template name="inline.charseq">
    <xsl:with-param name="wrapper-name">acronym</xsl:with-param>
  </xsl:call-template>
</xsl:template>

<xsl:template match="d:citerefentry">
  <xsl:choose>
    <xsl:when test="$citerefentry.link != '0'">
      <a>
        <xsl:apply-templates select="." mode="common.html.attributes"/>
        <xsl:attribute name="href">
          <xsl:call-template name="generate.citerefentry.link"/>
        </xsl:attribute>
        <xsl:call-template name="inline.charseq"/>
      </a>
    </xsl:when>
    <xsl:otherwise>
      <xsl:call-template name="inline.charseq"/>
    </xsl:otherwise>
  </xsl:choose>
</xsl:template>

<xsl:template name="generate.citerefentry.link">
  <!-- nop -->
</xsl:template>

<xsl:template name="x.generate.citerefentry.link">
  <xsl:text>http://example.com/cgi-bin/man.cgi?</xsl:text>
  <xsl:value-of select="d:refentrytitle"/>
  <xsl:text>(</xsl:text>
  <xsl:value-of select="d:manvolnum"/>
  <xsl:text>)</xsl:text>
</xsl:template>

<xsl:template match="d:citetitle">
  <xsl:choose>
    <xsl:when test="@pubwork = 'article'">
      <xsl:call-template name="gentext.startquote"/>
      <xsl:call-template name="inline.charseq"/>
      <xsl:call-template name="gentext.endquote"/>
    </xsl:when>
    <xsl:otherwise>
      <xsl:call-template name="inline.italicseq"/>
    </xsl:otherwise>
  </xsl:choose>
</xsl:template>

<xsl:template match="d:emphasis">
  <span>
    <xsl:call-template name="id.attribute"/>
    <xsl:choose>
      <!-- We don't want empty @class values, so do not propagate empty @roles -->
      <xsl:when test="@role  and                       normalize-space(@role) != '' and                       $emphasis.propagates.style != 0">
        <xsl:apply-templates select="." mode="common.html.attributes">
          <xsl:with-param name="class" select="@role"/>
        </xsl:apply-templates>
      </xsl:when>
      <xsl:otherwise>
        <xsl:apply-templates select="." mode="common.html.attributes"/>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:call-template name="anchor"/>

    <xsl:call-template name="simple.xlink">
      <xsl:with-param name="content">
        <xsl:choose>
          <xsl:when test="@role = 'bold' or @role='strong'">
            <!-- backwards compatibility: make bold into b elements, but -->
            <!-- don't put bold inside figure, example, or table titles -->
            <xsl:choose>
              <xsl:when test="local-name(..) = 'title'                               and (local-name(../..) = 'figure'                               or local-name(../..) = 'example'                               or local-name(../..) = 'table')">
                <xsl:apply-templates/>
              </xsl:when>
              <xsl:otherwise>
                <strong><xsl:apply-templates/></strong>
              </xsl:otherwise>
            </xsl:choose>
          </xsl:when>
          <xsl:when test="@role and $emphasis.propagates.style != 0">
            <xsl:apply-templates/>
          </xsl:when>
          <xsl:otherwise>
            <em><xsl:apply-templates/></em>
          </xsl:otherwise>
        </xsl:choose>
      </xsl:with-param>
    </xsl:call-template>
  </span>
</xsl:template>

<xsl:template match="d:foreignphrase">
  <span>
    <xsl:apply-templates select="." mode="common.html.attributes"/>
    <xsl:call-template name="inline.italicseq"/>
  </span>
</xsl:template>

<xsl:template match="d:markup">
  <xsl:call-template name="inline.charseq"/>
</xsl:template>

<xsl:template match="d:phrase">
  <span>
    <xsl:call-template name="id.attribute"/>
    <xsl:call-template name="locale.html.attributes"/>
    <!-- We don't want empty @class values, so do not propagate empty @roles -->
    <xsl:choose>
      <xsl:when test="@role and                       normalize-space(@role) != '' and                      $phrase.propagates.style != 0">
        <xsl:apply-templates select="." mode="class.attribute">
          <xsl:with-param name="class" select="@role"/>
        </xsl:apply-templates>
      </xsl:when>
      <xsl:otherwise>
        <xsl:apply-templates select="." mode="class.attribute"/>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:call-template name="dir"/>
    <xsl:call-template name="anchor"/>
    <xsl:call-template name="simple.xlink">
      <xsl:with-param name="content">
        <xsl:apply-templates/>
      </xsl:with-param>
    </xsl:call-template>
    <xsl:call-template name="apply-annotations"/>
  </span>
</xsl:template>

<xsl:template match="d:quote">
  <xsl:variable name="depth">
    <xsl:call-template name="dot.count">
      <xsl:with-param name="string">
        <xsl:number level="multiple"/>
      </xsl:with-param>
    </xsl:call-template>
  </xsl:variable>
  <span>
    <xsl:apply-templates select="." mode="common.html.attributes"/>
    <xsl:choose>
      <xsl:when test="$depth mod 2 = 0">
        <xsl:call-template name="gentext.startquote"/>
        <xsl:call-template name="inline.charseq"/>
        <xsl:call-template name="gentext.endquote"/>
      </xsl:when>
      <xsl:otherwise>
        <xsl:call-template name="gentext.nestedstartquote"/>
        <xsl:call-template name="inline.charseq"/>
        <xsl:call-template name="gentext.nestedendquote"/>
      </xsl:otherwise>
    </xsl:choose>
  </span>
</xsl:template>

<xsl:template match="d:varname">
  <xsl:call-template name="inline.monoseq"/>
</xsl:template>

<xsl:template match="d:wordasword">
  <xsl:call-template name="inline.italicseq"/>
</xsl:template>

<xsl:template match="d:lineannotation">
  <em>
    <xsl:apply-templates select="." mode="common.html.attributes"/>
    <xsl:call-template name="inline.charseq"/>
  </em>
</xsl:template>

<xsl:template match="d:superscript">
  <xsl:call-template name="inline.superscriptseq"/>
</xsl:template>

<xsl:template match="d:subscript">
  <xsl:call-template name="inline.subscriptseq"/>
</xsl:template>

<xsl:template match="d:trademark">
  <xsl:call-template name="inline.charseq"/>
  <xsl:choose>
    <xsl:when test="@class = 'copyright'                     or @class = 'registered'">
      <xsl:call-template name="dingbat">
        <xsl:with-param name="dingbat" select="@class"/>
      </xsl:call-template>
    </xsl:when>
    <xsl:when test="@class = 'service'">
      <sup>SM</sup>
    </xsl:when>
    <xsl:otherwise>
      <xsl:call-template name="dingbat">
        <xsl:with-param name="dingbat" select="'trademark'"/>
      </xsl:call-template>
    </xsl:otherwise>
  </xsl:choose>
</xsl:template>

<xsl:template match="d:firstterm">
  <xsl:call-template name="glossterm">
    <xsl:with-param name="firstterm" select="1"/>
  </xsl:call-template>
</xsl:template>

<xsl:template match="d:glossterm" name="glossterm">
  <xsl:param name="firstterm" select="0"/>

  <!-- To avoid extra <a name=""> anchor from inline.italicseq -->
  <xsl:variable name="content">
    <xsl:apply-templates/>
  </xsl:variable>

  <xsl:choose>
    <xsl:when test="($firstterm.only.link = 0 or $firstterm = 1) and @linkend">
      <xsl:variable name="targets" select="key('id',@linkend)"/>
      <xsl:variable name="target" select="$targets[1]"/>

      <xsl:call-template name="check.id.unique">
        <xsl:with-param name="linkend" select="@linkend"/>
      </xsl:call-template>

      <xsl:choose>
        <xsl:when test="$target">
          <a>
            <xsl:apply-templates select="." mode="common.html.attributes"/>

            <xsl:attribute name="href">
              <xsl:call-template name="href.target">
                <xsl:with-param name="object" select="$target"/>
              </xsl:call-template>
            </xsl:attribute>

            <xsl:call-template name="inline.italicseq">
              <xsl:with-param name="content" select="$content"/>
            </xsl:call-template>
          </a>
        </xsl:when>
        <xsl:otherwise>
          <xsl:call-template name="inline.italicseq">
            <xsl:with-param name="content" select="$content"/>
          </xsl:call-template>
        </xsl:otherwise>
      </xsl:choose>
    </xsl:when>

    <xsl:when test="not(@linkend)                     and ($firstterm.only.link = 0 or $firstterm = 1)                     and ($glossterm.auto.link != 0)                     and $glossary.collection != ''">
      <xsl:variable name="term">
        <xsl:choose>
          <xsl:when test="@baseform"><xsl:value-of select="@baseform"/></xsl:when>
          <xsl:otherwise><xsl:value-of select="."/></xsl:otherwise>
        </xsl:choose>
      </xsl:variable>

      <xsl:variable name="cterm" select="(document($glossary.collection,.)//d:glossentry[d:glossterm=$term])[1]"/>

      <!-- HACK HACK HACK! But it works... -->
      <!-- You'd need to do more work if you wanted to chunk on glossdiv, though -->

      <xsl:variable name="glossary" select="//d:glossary[@role='auto']"/>

      <xsl:if test="count($glossary) != 1">
        <xsl:message>
          <xsl:text>Warning: glossary.collection specified, but there are </xsl:text>
          <xsl:value-of select="count($glossary)"/>
          <xsl:text> automatic glossaries</xsl:text>
        </xsl:message>
      </xsl:if>

      <xsl:variable name="glosschunk">
        <xsl:call-template name="href.target">
          <xsl:with-param name="object" select="$glossary"/>
        </xsl:call-template>
      </xsl:variable>

      <xsl:variable name="chunkbase">
        <xsl:choose>
          <xsl:when test="contains($glosschunk, '#')">
            <xsl:value-of select="substring-before($glosschunk, '#')"/>
          </xsl:when>
          <xsl:otherwise>
            <xsl:value-of select="$glosschunk"/>
          </xsl:otherwise>
        </xsl:choose>
      </xsl:variable>

      <xsl:choose>
        <xsl:when test="not($cterm)">
          <xsl:message>
            <xsl:text>There's no entry for </xsl:text>
            <xsl:value-of select="$term"/>
            <xsl:text> in </xsl:text>
            <xsl:value-of select="$glossary.collection"/>
          </xsl:message>
          <xsl:call-template name="inline.italicseq"/>
        </xsl:when>
        <xsl:otherwise>
          <xsl:variable name="id">
            <xsl:call-template name="object.id">
              <xsl:with-param name="object" select="$cterm"/>
            </xsl:call-template>
          </xsl:variable>
          <a href="{$chunkbase}#{$id}">
            <xsl:apply-templates select="." mode="common.html.attributes"/>
            <xsl:call-template name="inline.italicseq">
              <xsl:with-param name="content" select="$content"/>
            </xsl:call-template>
          </a>
        </xsl:otherwise>
      </xsl:choose>
    </xsl:when>

    <xsl:when test="not(@linkend)                     and ($firstterm.only.link = 0 or $firstterm = 1)                     and $glossterm.auto.link != 0">
      <xsl:variable name="term">
        <xsl:choose>
          <xsl:when test="@baseform">
            <xsl:value-of select="normalize-space(@baseform)"/>
          </xsl:when>
          <xsl:otherwise>
            <xsl:value-of select="normalize-space(.)"/>
          </xsl:otherwise>
        </xsl:choose>
      </xsl:variable>
      <xsl:variable name="targets" select="key('glossentries', $term)"/>
      <xsl:variable name="target" select="$targets[1]"/>

      <xsl:choose>
        <xsl:when test="count($targets)=0">
          <xsl:message>
            <xsl:text>Error: no glossentry for glossterm: </xsl:text>
            <xsl:value-of select="."/>
            <xsl:text>.</xsl:text>
          </xsl:message>
          <xsl:call-template name="inline.italicseq"/>
        </xsl:when>
        <xsl:otherwise>
          <a>
            <xsl:apply-templates select="." mode="common.html.attributes"/>
            <xsl:if test="@id or @xml:id">
              <xsl:attribute name="id">
                <xsl:value-of select="(@id|@xml:id)[1]"/>
              </xsl:attribute>
            </xsl:if>

            <xsl:attribute name="href">
              <xsl:call-template name="href.target">
                <xsl:with-param name="object" select="$target"/>
              </xsl:call-template>
            </xsl:attribute>

            <xsl:call-template name="inline.italicseq">
              <xsl:with-param name="content" select="$content"/>
            </xsl:call-template>
          </a>
        </xsl:otherwise>
      </xsl:choose>
    </xsl:when>

    <xsl:otherwise>
      <xsl:call-template name="inline.italicseq"/>
    </xsl:otherwise>
  </xsl:choose>
</xsl:template>

<xsl:template match="d:termdef">
  <span>
    <xsl:apply-templates select="." mode="common.html.attributes"/>
    <xsl:call-template name="gentext.template">
      <xsl:with-param name="context" select="'termdef'"/>
      <xsl:with-param name="name" select="'prefix'"/>
    </xsl:call-template>
    <xsl:apply-templates/>
    <xsl:call-template name="gentext.template">
      <xsl:with-param name="context" select="'termdef'"/>
      <xsl:with-param name="name" select="'suffix'"/>
    </xsl:call-template>
  </span>
</xsl:template>

<xsl:template match="d:sgmltag|d:tag">
  <xsl:call-template name="format.sgmltag"/>
</xsl:template>

<xsl:template name="format.sgmltag">
  <xsl:param name="class">
    <xsl:choose>
      <xsl:when test="@class">
        <xsl:value-of select="@class"/>
      </xsl:when>
      <xsl:otherwise>element</xsl:otherwise>
    </xsl:choose>
  </xsl:param>

  <xsl:variable name="content">
    <xsl:choose>
      <xsl:when test="$class='attribute'">
        <xsl:apply-templates/>
      </xsl:when>
      <xsl:when test="$class='attvalue'">
        <xsl:apply-templates/>
      </xsl:when>
      <xsl:when test="$class='element'">
        <xsl:apply-templates/>
      </xsl:when>
      <xsl:when test="$class='endtag'">
        <xsl:text>&lt;/</xsl:text>
        <xsl:apply-templates/>
        <xsl:text>&gt;</xsl:text>
      </xsl:when>
      <xsl:when test="$class='genentity'">
        <xsl:text>&amp;</xsl:text>
        <xsl:apply-templates/>
        <xsl:text>;</xsl:text>
      </xsl:when>
      <xsl:when test="$class='numcharref'">
        <xsl:text>&amp;#</xsl:text>
        <xsl:apply-templates/>
        <xsl:text>;</xsl:text>
      </xsl:when>
      <xsl:when test="$class='paramentity'">
        <xsl:text>%</xsl:text>
        <xsl:apply-templates/>
        <xsl:text>;</xsl:text>
      </xsl:when>
      <xsl:when test="$class='pi'">
        <xsl:text>&lt;?</xsl:text>
        <xsl:apply-templates/>
        <xsl:text>&gt;</xsl:text>
      </xsl:when>
      <xsl:when test="$class='xmlpi'">
        <xsl:text>&lt;?</xsl:text>
        <xsl:apply-templates/>
        <xsl:text>?&gt;</xsl:text>
      </xsl:when>
      <xsl:when test="$class='starttag'">
        <xsl:text>&lt;</xsl:text>
        <xsl:apply-templates/>
        <xsl:text>&gt;</xsl:text>
      </xsl:when>
      <xsl:when test="$class='emptytag'">
        <xsl:text>&lt;</xsl:text>
        <xsl:apply-templates/>
        <xsl:text>/&gt;</xsl:text>
      </xsl:when>
      <xsl:when test="$class='sgmlcomment' or $class='comment'">
        <xsl:text>&lt;!--</xsl:text>
        <xsl:apply-templates/>
        <xsl:text>--&gt;</xsl:text>
      </xsl:when>
      <xsl:otherwise>
        <xsl:apply-templates/>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:variable>

  <code>
    <xsl:apply-templates select="." mode="common.html.attributes">
      <xsl:with-param name="class" select="concat('sgmltag-', $class)"/>
    </xsl:apply-templates>
    <xsl:call-template name="simple.xlink">
      <xsl:with-param name="content" select="$content"/>
    </xsl:call-template>
  </code>
</xsl:template>

<xsl:template match="d:email">
  <xsl:call-template name="inline.monoseq">
    <xsl:with-param name="content">
      <xsl:if test="not($email.delimiters.enabled = 0)">
        <xsl:text>&lt;</xsl:text>
      </xsl:if>
      <a>
        <xsl:apply-templates select="." mode="common.html.attributes"/>
        <xsl:call-template name="id.attribute"/>
        <xsl:attribute name="href">
          <xsl:text>mailto:</xsl:text>
          <xsl:value-of select="."/>
        </xsl:attribute>
        <xsl:apply-templates/>
      </a>
      <xsl:if test="not($email.delimiters.enabled = 0)">
        <xsl:text>&gt;</xsl:text>
      </xsl:if>
    </xsl:with-param>
  </xsl:call-template>
</xsl:template>

<xsl:template match="d:keycombo">
  <xsl:variable name="action" select="@action"/>
  <xsl:variable name="joinchar">
    <xsl:choose>
      <xsl:when test="$action='seq'"><xsl:text> </xsl:text></xsl:when>
      <xsl:when test="$action='simul'">+</xsl:when>
      <xsl:when test="$action='press'">-</xsl:when>
      <xsl:when test="$action='click'">-</xsl:when>
      <xsl:when test="$action='double-click'">-</xsl:when>
      <xsl:when test="$action='other'"/>
      <xsl:otherwise>+</xsl:otherwise>
    </xsl:choose>
  </xsl:variable>
  <xsl:for-each select="*">
    <xsl:if test="position()&gt;1"><xsl:value-of select="$joinchar"/></xsl:if>
    <xsl:apply-templates select="."/>
  </xsl:for-each>
</xsl:template>

<xsl:template match="d:uri">
  <xsl:call-template name="inline.monoseq"/>
</xsl:template>

<!-- ==================================================================== -->

<xsl:template match="d:menuchoice">
  <xsl:variable name="shortcut" select="./d:shortcut"/>
  <xsl:call-template name="process.menuchoice"/>
  <xsl:if test="$shortcut">
    <xsl:text> (</xsl:text>
    <xsl:apply-templates select="$shortcut"/>
    <xsl:text>)</xsl:text>
  </xsl:if>
</xsl:template>

<xsl:template name="process.menuchoice">
  <xsl:param name="nodelist" select="d:guibutton|d:guiicon|d:guilabel|d:guimenu|d:guimenuitem|d:guisubmenu|d:interface"/><!-- not(shortcut) -->
  <xsl:param name="count" select="1"/>

  <xsl:choose>
    <xsl:when test="$count&gt;count($nodelist)"/>
    <xsl:when test="$count=1">
      <xsl:apply-templates select="$nodelist[$count=position()]"/>
      <xsl:call-template name="process.menuchoice">
        <xsl:with-param name="nodelist" select="$nodelist"/>
        <xsl:with-param name="count" select="$count+1"/>
      </xsl:call-template>
    </xsl:when>
    <xsl:otherwise>
      <xsl:variable name="node" select="$nodelist[$count=position()]"/>
      <xsl:choose>
        <xsl:when test="local-name($node)='guimenuitem'                         or local-name($node)='guisubmenu'">
          <xsl:value-of select="$menuchoice.menu.separator"/>
        </xsl:when>
        <xsl:otherwise>
          <xsl:value-of select="$menuchoice.separator"/>
        </xsl:otherwise>
      </xsl:choose>
      <xsl:apply-templates select="$node"/>
      <xsl:call-template name="process.menuchoice">
        <xsl:with-param name="nodelist" select="$nodelist"/>
        <xsl:with-param name="count" select="$count+1"/>
      </xsl:call-template>
    </xsl:otherwise>
  </xsl:choose>
</xsl:template>

<!-- ==================================================================== -->

<xsl:template match="d:optional">
  <xsl:value-of select="$arg.choice.opt.open.str"/>
  <xsl:call-template name="inline.charseq"/>
  <xsl:value-of select="$arg.choice.opt.close.str"/>
</xsl:template>

<xsl:template match="d:citation">
  <!-- todo: integrate with bibliography collection -->
  <xsl:variable name="targets" select="(//d:biblioentry | //d:bibliomixed)[d:abbrev = string(current())]"/>
  <xsl:variable name="target" select="$targets[1]"/>

  <xsl:choose>
    <!-- try automatic linking based on match to abbrev -->
    <xsl:when test="$target and not(d:xref) and not(d:link)">

      <xsl:text>[</xsl:text>
      <a>
        <xsl:apply-templates select="." mode="common.html.attributes"/>
        <xsl:attribute name="href">
          <xsl:call-template name="href.target">
            <xsl:with-param name="object" select="$target"/>
          </xsl:call-template>
        </xsl:attribute>

        <xsl:choose>
          <xsl:when test="$bibliography.numbered != 0">
            <xsl:call-template name="id.attribute"/>
            <xsl:apply-templates select="$target" mode="citation"/>
          </xsl:when>
          <xsl:otherwise>
            <xsl:call-template name="inline.charseq"/>
          </xsl:otherwise>
        </xsl:choose>

      </a>
      <xsl:text>]</xsl:text>
    </xsl:when>
    <xsl:otherwise>
      <xsl:text>[</xsl:text>
      <xsl:call-template name="inline.charseq"/>
      <xsl:text>]</xsl:text>
    </xsl:otherwise>
  </xsl:choose>
</xsl:template>

<xsl:template match="d:citebiblioid">
  <xsl:variable name="targets" select="//*[d:biblioid = string(current())]"/>
  <xsl:variable name="target" select="$targets[1]"/>

  <xsl:choose>
    <!-- try automatic linking based on match to parent of biblioid -->
    <xsl:when test="$target and not(d:xref) and not(d:link)">

      <xsl:text>[</xsl:text>
      <a>
        <xsl:apply-templates select="." mode="common.html.attributes"/>
        <xsl:attribute name="href">
          <xsl:call-template name="href.target">
            <xsl:with-param name="object" select="$target"/>
          </xsl:call-template>
        </xsl:attribute>

        <xsl:call-template name="inline.charseq"/>

      </a>
      <xsl:text>]</xsl:text>
    </xsl:when>
    <xsl:otherwise>
      <xsl:text>[</xsl:text>
      <xsl:call-template name="inline.charseq"/>
      <xsl:text>]</xsl:text>
    </xsl:otherwise>
  </xsl:choose>
</xsl:template>

<xsl:template match="d:biblioentry|d:bibliomixed" mode="citation">
  <xsl:number from="d:bibliography" count="d:biblioentry|d:bibliomixed" level="any" format="1"/>
</xsl:template>

<!-- ==================================================================== -->

<xsl:template match="d:comment[parent::d:answer|parent::d:appendix|parent::d:article|parent::d:bibliodiv|                                 parent::d:bibliography|parent::d:blockquote|parent::d:caution|parent::d:chapter|                                 parent::d:glossary|parent::d:glossdiv|parent::d:important|parent::d:index|                                 parent::d:indexdiv|parent::d:listitem|parent::d:note|parent::d:orderedlist|                                 parent::d:partintro|parent::d:preface|parent::d:procedure|parent::d:qandadiv|                                 parent::d:qandaset|parent::d:question|parent::d:refentry|parent::d:refnamediv|                                 parent::d:refsect1|parent::d:refsect2|parent::d:refsect3|parent::d:refsection|                                 parent::d:refsynopsisdiv|parent::d:sect1|parent::d:sect2|parent::d:sect3|parent::d:sect4|                                 parent::d:sect5|parent::d:section|parent::d:setindex|parent::d:sidebar|                                 parent::d:simplesect|parent::d:taskprerequisites|parent::d:taskrelated|                                 parent::d:tasksummary|parent::d:warning|parent::d:topic]|d:remark[parent::d:answer|parent::d:appendix|parent::d:article|parent::d:bibliodiv|                                 parent::d:bibliography|parent::d:blockquote|parent::d:caution|parent::d:chapter|                                 parent::d:glossary|parent::d:glossdiv|parent::d:important|parent::d:index|                                 parent::d:indexdiv|parent::d:listitem|parent::d:note|parent::d:orderedlist|                                 parent::d:partintro|parent::d:preface|parent::d:procedure|parent::d:qandadiv|                                 parent::d:qandaset|parent::d:question|parent::d:refentry|parent::d:refnamediv|                                 parent::d:refsect1|parent::d:refsect2|parent::d:refsect3|parent::d:refsection|                                 parent::d:refsynopsisdiv|parent::d:sect1|parent::d:sect2|parent::d:sect3|parent::d:sect4|                                 parent::d:sect5|parent::d:section|parent::d:setindex|parent::d:sidebar|                                 parent::d:simplesect|parent::d:taskprerequisites|parent::d:taskrelated|                                 parent::d:tasksummary|parent::d:warning|parent::d:topic]">
  <xsl:if test="$show.comments != 0">
    <p class="remark"><em><xsl:call-template name="inline.charseq"/></em></p>
  </xsl:if>
</xsl:template>

<xsl:template match="d:comment|d:remark">
  <xsl:if test="$show.comments != 0">
    <em><xsl:call-template name="inline.charseq"/></em>
  </xsl:if>
</xsl:template>

<!-- ==================================================================== -->

<xsl:template match="d:productname">
  <xsl:call-template name="inline.charseq"/>
  <xsl:if test="@class">
    <xsl:call-template name="dingbat">
      <xsl:with-param name="dingbat" select="@class"/>
    </xsl:call-template>
  </xsl:if>
</xsl:template>

<xsl:template match="d:productnumber">
  <xsl:call-template name="inline.charseq"/>
</xsl:template>

<!-- ==================================================================== -->

<xsl:template match="d:pob|d:street|d:city|d:state|d:postcode|d:country|d:otheraddr">
  <xsl:call-template name="inline.charseq"/>
</xsl:template>

<xsl:template match="d:phone|d:fax">
  <xsl:call-template name="inline.charseq"/>
</xsl:template>

<!-- in Addresses, for example -->
<xsl:template match="d:honorific|d:firstname|d:surname|d:lineage|d:othername">
  <xsl:call-template name="inline.charseq"/>
</xsl:template>

<!-- ==================================================================== -->

<xsl:template match="d:person">
  <xsl:param name="content">
    <xsl:apply-templates select="d:personname"/>
  </xsl:param>

  <xsl:param name="contentwithlink">
    <xsl:call-template name="anchor"/>
    <xsl:call-template name="simple.xlink">
      <xsl:with-param name="content" select="$content"/>
    </xsl:call-template>
    <xsl:call-template name="apply-annotations"/>
  </xsl:param>

  <span>
    <xsl:apply-templates select="." mode="common.html.attributes"/>
    <xsl:call-template name="id.attribute"/>
    <xsl:copy-of select="$contentwithlink"/>
  </span>
</xsl:template>

<xsl:template match="d:personname">
  <xsl:param name="content">
    <xsl:call-template name="person.name"/>
  </xsl:param>

  <xsl:param name="contentwithlink">
    <xsl:call-template name="anchor"/>
    <xsl:call-template name="simple.xlink">
      <xsl:with-param name="content" select="$content"/>
    </xsl:call-template>
    <xsl:call-template name="apply-annotations"/>
  </xsl:param>

  <span>
    <xsl:apply-templates select="." mode="common.html.attributes"/>
    <xsl:call-template name="id.attribute"/>
    <xsl:copy-of select="$contentwithlink"/>
  </span>
</xsl:template>

<!-- ==================================================================== -->

<xsl:template match="d:org">
  <xsl:param name="content">
    <xsl:apply-templates/>
  </xsl:param>

  <xsl:param name="contentwithlink">
    <xsl:call-template name="anchor"/>
    <xsl:call-template name="simple.xlink">
      <xsl:with-param name="content" select="$content"/>
    </xsl:call-template>
    <xsl:call-template name="apply-annotations"/>
  </xsl:param>

  <span>
    <xsl:apply-templates select="." mode="common.html.attributes"/>
    <xsl:call-template name="id.attribute"/>
    <xsl:copy-of select="$contentwithlink"/>
  </span>
</xsl:template>

<xsl:template match="d:orgname">
  <xsl:param name="content">
    <xsl:apply-templates/>
  </xsl:param>

  <xsl:param name="contentwithlink">
    <xsl:call-template name="anchor"/>
    <xsl:call-template name="simple.xlink">
      <xsl:with-param name="content" select="$content"/>
    </xsl:call-template>
    <xsl:call-template name="apply-annotations"/>
  </xsl:param>

  <span>
    <xsl:apply-templates select="." mode="common.html.attributes"/>
    <xsl:call-template name="id.attribute"/>
    <xsl:copy-of select="$contentwithlink"/>
  </span>
</xsl:template>

<xsl:template match="d:orgdiv">
  <xsl:param name="content">
    <xsl:apply-templates/>
  </xsl:param>

  <xsl:param name="contentwithlink">
    <xsl:call-template name="anchor"/>
    <xsl:call-template name="simple.xlink">
      <xsl:with-param name="content" select="$content"/>
    </xsl:call-template>
    <xsl:call-template name="apply-annotations"/>
  </xsl:param>

  <span>
    <xsl:apply-templates select="." mode="common.html.attributes"/>
    <xsl:call-template name="id.attribute"/>
    <xsl:copy-of select="$contentwithlink"/>
  </span>
</xsl:template>

<xsl:template match="d:affiliation">
  <xsl:param name="content">
    <xsl:call-template name="person.name"/>
  </xsl:param>

  <xsl:param name="contentwithlink">
    <xsl:call-template name="anchor"/>
    <xsl:call-template name="simple.xlink">
      <xsl:with-param name="content" select="$content"/>
    </xsl:call-template>
    <xsl:call-template name="apply-annotations"/>
  </xsl:param>

  <span>
    <xsl:apply-templates select="." mode="common.html.attributes"/>
    <xsl:call-template name="id.attribute"/>
    <xsl:copy-of select="$contentwithlink"/>
  </span>
</xsl:template>

<!-- ==================================================================== -->

<xsl:template match="d:beginpage">
  <!-- does nothing; this *is not* markup to force a page break. -->
</xsl:template>

</xsl:stylesheet>
