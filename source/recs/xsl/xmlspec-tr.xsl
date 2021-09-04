<?xml version="1.0" encoding='UTF-8'?>
<!-- ====================================================================== -->
<!-- xmlspec-tr.xsl: An HTML XSL[1] Stylesheet for XML Spec V2.1[2] markup
      The file xmlspec.xsl has been modified by
      Nilgün Belma Bugüner <nilgun (at) belgeler·org>
      as xmlspec-tr.xsl, to transform into HTML format the Turkish
      translations of spec XML documents related to the W3C specifications.
-->
<!-- ====================================================================== -->
<!-- xmlspec.xsl: An HTML XSL[1] Stylesheet for XML Spec V2.1[2] markup

     Version: $Id: xmlspec.xsl,v 1.54 2005/10/13 15:44:48 NormanWalsh Exp $

     URI:     http://dev.w3.org/cvsweb/spec-prod/html/xmlspec.xsl

     Authors: Norman Walsh (norman.walsh@sun.com)
              Chris Maden (crism@lexica.net)
              Ben Trafford (ben@legendary.org)
              Eve Maler (eve.maler@sun.com)
              Henry S. Thompson (ht@cogsci.ed.ac.uk)

     Date:    Created 07 September 1999
              Last updated $Date: 2005/10/13 15:44:48 $ by $Author: NormanWalsh $

     Copyright (C) 2000, 2001, 2002 Sun Microsystems, Inc. All Rights Reserved.
     This document is governed by the W3C Software License[3] as
     described in the FAQ[4].

       [1] http://www.w3.org/TR/xslt
       [2] http://www.w3.org/XML/1998/06/xmlspec-report-v21.htm
       [3] http://www.w3.org/Consortium/Legal/copyright-software-19980720
       [4] http://www.w3.org/Consortium/Legal/IPR-FAQ-20000620.html#DTD

     Notes:

     This stylesheet attempts to implement the XML Specification V2.1
     DTD.  Documents conforming to earlier DTDs may not be correctly
     transformed.

     ChangeLog: (See also: CVS ChangeLog)

     15 August 2002: Norman Walsh, <Norman.Walsh@Sun.COM>
       - Version 1.3 released at http://www.w3.org/2002/xmlspec/html/1.3/xmlspec.xsl
         There have never been any "official" releases before, so the version number
         is arbitrary.

     15 August 2001: Hugo Haas <hugo@w3.org>
       - Slightly modified the status sentence introducing editors'
         copies.
       - Now using role to distinguish editors' copies: e.g.
         <spec w3c-doctype="wd" role="editors-copy">

     14 August 2001: Hugo Haas <hugo@w3.org>
       - If w3c-doctype is not a W3C TR, do not use a Note style
         sheet, use <http://www.w3.org/StyleSheets/TR/base.css>
         instead.
       - If the other-doctype is "editors-copy", do not use the W3C
         logo and mark the document as such in the status section.

     12 Jun 2001: (Norman.Walsh@Sun.COM)
       - Support non-tabular examples. If tabular.examples is non-zero,
         tables will be used for examples, otherwise nested divs and
         CSS will be used. tabular.examples is *zero* by default.

     06 Jun 2001: (Norman.Walsh@Sun.COM)
       - Support copyright element in header; use the content of that
         element if it is present, otherwise use the auto-generated
         copyright statement.

     15 May 2001: (Norman.Walsh@Sun.COM)
       - Changed copyright link to point to dated IPR statement:
         http://www.w3.org/Consortium/Legal/ipr-notice-20000612

     25 Sep 2000: (Norman.Walsh@East.Sun.COM)
       - Sync'd with Eve's version:
         o Concatenated each inline element's output all on one line
           to avoid spurious spaces in the output. (This is really an
           IE bug, but...) (15 Sep 2000)
         o Updated crism's email address in header (7 Sep 2000)
         o Changed handling of affiliation to use comma instead of
           parentheses (9 Aug 2000)

     14 Aug 2000: (Norman.Walsh@East.Sun.COM)

       - Added additional.title param (for diffspec.xsl to change)
       - Fixed URI of W3C home icon
       - Made CSS stylesheet selection depend on the w3c-doctype attribute
         of spec instead of the w3c-doctype element in the header

     26 Jul 2000: (Norman.Walsh@East.Sun.COM)

       - Improved semantics of specref. Added xsl:message for unsupported
         cases. (I'm by no means confident that I've covered the whole
         list.)
       - Support @role on author.
       - Make lhs/rhs "code" in EBNF.
       - Fixed bug in ID/IDREF linking.
       - More effectively disabled special markup for showing @diffed
         versions

     21 Jul 2000: (Norman.Walsh@East.Sun.COM)

       - Added support for @diff change tracking, primarily through
         the auxiliary stylesheet diffspec.xsl. However, it was
         impractical to handle some constructions, such as DLs and TABLEs,
         in a completely out-of-band manner. So there is some inline
         support for @diff markup.

       - Added $additional.css to allow downstream stylesheets to add
         new markup to the <style> element.

       - Added required "type" attribute to the <style> element.

       - Fixed pervasive problem with nested <a> elements.

       - Added doctype-public to xsl:output.

       - Added $validity.hacks. If "1", then additional disable-output-escaping
         markup may be inserted in some places to attempt to get proper,
         valid HTML. For example, if a <glist> appears inside a <p> in the
         xmlspec source, this creates a nested <dl> inside a <p> in the
         HTML, which is not valid. If $validity.hacks is "1", then an
         extra </p>, <p> pair is inserted around the <dl>.

   5 June 2001, Henry S. Thompson (ht@cogsci.ed.ac.uk)

       - Fixed a link in copyright boilerplate to be dated

  -->
<!-- ====================================================================== -->

<xsl:transform xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
               xmlns="http://www.w3.org/1999/xhtml"
               version="1.0">

<xsl:preserve-space elements="*"/>

<xsl:strip-space elements="
abstract arg attribute authlist author back bibref blist body case col
colgroup component constant constraint constraintnote copyright def
definitions descr div div1 div2 div3 div4 div5 ednote enum enumerator
example exception footnote front gitem glist graphic group header
htable htbody inform-div1 interface issue item itemizedlist langusage
listitem member method module note notice ol olist orderedlist orglist
param parameters prod prodgroup prodrecap proto pubdate pubstmt raises
reference resolution returns revisiondesc scrap sequence slist
sourcedesc spec specref status struct table tbody tfoot thead tr
typedef ul ulist union varlist vc vcnote wfc wfcnote"/>

<xsl:param name="validity.hacks" select="1"/>
<xsl:param name="show.diff.markup" select="0"/>
<xsl:param name="additional.css"/>
<xsl:param name="additional.title"/>
<xsl:param name="called.by.diffspec" select="0"/>
<xsl:param name="show.ednotes" select="1"/>
<xsl:param name="tabular.examples" select="0"/>
<xsl:param name="toc.level" select="5"/>

<xsl:key name="ids" match="*" use="@id"/>
<xsl:key name="specrefs" match="specref" use="@ref"/>

  <xsl:output method="xml"
       omit-xml-declaration="no"
       encoding="UTF-8"
       doctype-public="-//W3C//DTD XHTML 1.0 Transitional//EN"
       doctype-system="http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd"
       indent="no"/>

<xsl:template match="*">
  <xsl:message>
    <xsl:text>No template matches </xsl:text>
    <xsl:value-of select="name(.)"/>
    <xsl:text>.</xsl:text>
  </xsl:message>
</xsl:template>

<xsl:template match="/">
  <xsl:apply-templates/>
</xsl:template>

<xsl:template match="spec">
  <html>
    <xsl:if test="header/langusage/language">
      <xsl:attribute name="lang">
        <xsl:value-of select="header/langusage/language/@id"/>
      </xsl:attribute>
    </xsl:if>
    <head>
      <meta http-equiv="Content-Type" content="text/html; charset=UTF-8"/>
      <meta name="viewport" content="width=device-width, initial-scale=1.0">
      <title>
        <xsl:apply-templates select="header/title"/>
        <xsl:if test="header/version">
          <xsl:text> </xsl:text>
          <xsl:apply-templates select="header/version"/>
        </xsl:if>
        <xsl:if test="$additional.title != ''">
          <xsl:text> -- </xsl:text>
          <xsl:value-of select="$additional.title"/>
        </xsl:if>
      </title>
      <link rel="stylesheet" type="text/css" href="../recs.css" />
      <xsl:call-template name="css"/>
      <xsl:call-template name="additional-head"/>
    </head>
    <body>
      <xsl:apply-templates/>
      <xsl:if test="//footnote[not(ancestor::table)]">
        <hr/>
        <div class="endnotes">
          <h3>
            <xsl:call-template name="anchor">
              <xsl:with-param name="conditional" select="0"/>
              <xsl:with-param name="default.id" select="'endnotes'"/>
            </xsl:call-template>
            <xsl:text>Son Notlar</xsl:text>
          </h3>
          <dl>
            <xsl:apply-templates select="//footnote[not(ancestor::table)]" mode="notes"/>
          </dl>
        </div>
      </xsl:if>
    </body>
  </html>
</xsl:template>

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
    <xsl:apply-templates select="errataloc"/>
    <xsl:apply-templates select="preverrataloc"/>
    <xsl:apply-templates select="translationloc"/>
    <xsl:apply-templates select="altlocs"/>
    <xsl:call-template name="spec-copyright-en"/>
    <hr />
    <xsl:call-template name="translation.info"/>
  </div>
  <hr/>
  <xsl:apply-templates select="notice"/>
  <xsl:apply-templates select="abstract"/>
  <xsl:apply-templates select="status"/>
  <xsl:apply-templates select="revisiondesc"/>
</xsl:template>

<xsl:template match="body">
  <xsl:if test="$toc.level &gt; 0">
    <div class="toc">
      <xsl:if test="(/spec/@id)">
        <a name="{../@id}-toc" id="{../@id}-toc"/>
      </xsl:if>
      <h2>
        <xsl:call-template name="anchor">
          <xsl:with-param name="conditional" select="0"/>
          <xsl:with-param name="default.id" select="'contents'"/>
        </xsl:call-template>
        <xsl:text>İçindekiler</xsl:text>
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
          <xsl:if test="count(../back/div1 | ../back/inform-div1) &gt; 1">
            <xsl:text>ler</xsl:text>
          </xsl:if>
        </h3>
        <p class="toc">
          <xsl:apply-templates mode="toc" select="../back/div1 | ../back/inform-div1"/>
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
    <hr/>
  </xsl:if>
  <div class="body">
    <xsl:apply-templates/>
  </div>
</xsl:template>

<xsl:template match="back">
  <div class="back">
    <xsl:apply-templates/>
    <xsl:call-template name="autogenerated-appendices"/>
  </div>
</xsl:template>

<!-- ================================================================= -->

<xsl:template match="abstract">
  <div>
    <h2>
      <xsl:call-template name="anchor">
        <xsl:with-param name="conditional" select="0"/>
        <xsl:with-param name="default.id" select="'abstract'"/>
      </xsl:call-template>
      <xsl:text>Özet</xsl:text>
    </h2>
    <xsl:apply-templates/>
  </div>
</xsl:template>

<xsl:template match="affiliation">
  <xsl:text>, </xsl:text>
  <xsl:apply-templates/>
</xsl:template>

<xsl:template match="altlocs">
  <p>
    <xsl:text>Belgenin ayrıca bilgilendirici mahiyette bu biçimleri de var: </xsl:text>
    <xsl:apply-templates/>
  </p>
</xsl:template>

<xsl:template match="anchor">
  <a id="{@id}" name="{@id}"/>
</xsl:template>

<xsl:template match="arg">
  <xsl:if test="preceding-sibling::arg">
    <xsl:text>, </xsl:text>
  </xsl:if>
  <var>
    <xsl:value-of select="@type"/>
  </var>
  <xsl:choose>
    <xsl:when test="@occur='rep'">
      <xsl:text>*</xsl:text>
    </xsl:when>
    <xsl:when test="@occur='opt'">
      <xsl:text>?</xsl:text>
    </xsl:when>
  </xsl:choose>
</xsl:template>

<xsl:template match="att">
  <code><xsl:apply-templates/></code>
</xsl:template>

<xsl:template match="attval">
  <xsl:text>"</xsl:text>
  <xsl:apply-templates/>
  <xsl:text>"</xsl:text>
</xsl:template>

<xsl:template match="authlist">
  <dt>
    <xsl:text>Yayına hazırlayan</xsl:text>
    <xsl:if test="count(author) &gt; 1">
      <xsl:text>lar</xsl:text>
    </xsl:if>
    <xsl:text>:</xsl:text>
  </dt>
  <xsl:apply-templates/>
</xsl:template>

<xsl:template match="author">
  <dd>
    <xsl:apply-templates/>
    <xsl:if test="@role = '2e'">
      <xsl:text> - Second Edition</xsl:text>
    </xsl:if>
    <xsl:if test="@role = '3e'">
      <xsl:text> - Third Edition</xsl:text>
    </xsl:if>
    <xsl:if test="@role = '4e'">
      <xsl:text> - Fourth Edition</xsl:text>
    </xsl:if>
  </dd>
</xsl:template>

<xsl:template match="bibl">
  <dt class="label">
    <xsl:if test="@id">
      <a name="{@id}" id="{@id}"/>
    </xsl:if>
    <xsl:choose>
      <xsl:when test="@key">
        <xsl:value-of select="@key"/>
      </xsl:when>
      <xsl:otherwise>
        <xsl:value-of select="@id"/>
      </xsl:otherwise>
    </xsl:choose>
  </dt>
  <dd>
    <xsl:apply-templates/>
  </dd>
</xsl:template>

<xsl:template match="bibref">
  <xsl:text>[</xsl:text>
  <a>
    <xsl:attribute name="href">
      <xsl:call-template name="href.target">
        <xsl:with-param name="target" select="key('ids', @ref)"/>
      </xsl:call-template>
    </xsl:attribute>
    <xsl:choose>
      <xsl:when test="key('ids', @ref)/@key">
        <xsl:value-of select="key('ids', @ref)/@key"/>
      </xsl:when>
      <xsl:otherwise>
        <xsl:value-of select="@ref"/>
      </xsl:otherwise>
    </xsl:choose>
  </a>
  <xsl:text>]</xsl:text>
</xsl:template>

<xsl:template match="blist">
  <dl>
    <xsl:apply-templates/>
  </dl>
</xsl:template>

<xsl:template match="bnf">
  <tbody>
    <tr>
      <td>
        <pre>
          <xsl:apply-templates/>
        </pre>
      </td>
    </tr>
  </tbody>
</xsl:template>

<xsl:template match="bquote">
  <blockquote>
    <xsl:apply-templates/>
  </blockquote>
</xsl:template>

<xsl:template match="br">
  <br />
</xsl:template>

<xsl:template name="autogenerated-appendices"/>

<xsl:template name="autogenerated-appendices-toc"/>

<xsl:template match="code">
  <xsl:if test="(@role='axis')">
    <xsl:variable name="axes">
      <xsl:value-of select="concat('axis-', text())"/>
    </xsl:variable>
    <a name="{$axes}" id="{$axes}"/>
  </xsl:if>
  <code><xsl:apply-templates/></code>
</xsl:template>

<xsl:template match="com">
  <xsl:choose>
    <xsl:when test="preceding-sibling::*[1][name()='rhs']">
      <td width="25%">
        <i>
          <xsl:text>/* </xsl:text>
          <xsl:apply-templates/>
          <xsl:text> */</xsl:text>
        </i>
      </td>
    </xsl:when>
    <xsl:otherwise>
      <tr valign="baseline">
        <td width="5%"/><td width="5%"/><td width="5%"/>
        <td width="*"/>
        <td width="25%">
          <i>
            <xsl:text>/* </xsl:text>
            <xsl:apply-templates/>
            <xsl:text> */</xsl:text>
          </i>
        </td>
      </tr>
    </xsl:otherwise>
  </xsl:choose>
</xsl:template>

<xsl:template match="rhs/com">
  <i>
    <xsl:text>/* </xsl:text>
    <xsl:apply-templates/>
    <xsl:text> */</xsl:text>
  </i>
</xsl:template>

<xsl:template match="constraint|vc|wfc">
  <xsl:variable name="def">
    <xsl:choose>
      <xsl:when test="(self::constraint[@role='ns'])">
        <xsl:text>[İAK: </xsl:text>
      </xsl:when>
      <xsl:when test="name(.) = 'vc'">
        <xsl:text>[GK: </xsl:text>
      </xsl:when>
      <xsl:when test="name(.) = 'wfc'">
        <xsl:text>[İBK: </xsl:text>
      </xsl:when>
      <xsl:otherwise>
        <xsl:text>[Kısıt: </xsl:text>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:variable>
  <xsl:choose>
    <xsl:when test="preceding-sibling::*[1][name()='rhs']">
      <td width="25%">
        <a>
          <xsl:attribute name="href">
            <xsl:call-template name="href.target">
              <xsl:with-param name="target" select="key('ids', @def)"/>
            </xsl:call-template>
          </xsl:attribute>
          <xsl:value-of select="$def"/>
          <xsl:apply-templates select="key('ids', @def)/head" mode="text"/>
          <xsl:text>]</xsl:text>
        </a>
      </td>
    </xsl:when>
    <xsl:otherwise>
      <tr valign="baseline">
        <td width="5%"/><td width="5%"/><td width="5%"/>
        <td width="*"/>
        <td width="25%">
          <a>
            <xsl:attribute name="href">
              <xsl:call-template name="href.target">
                <xsl:with-param name="target" select="key('ids', @def)"/>
              </xsl:call-template>
            </xsl:attribute>
            <xsl:value-of select="$def"/>
            <xsl:apply-templates select="key('ids', @def)/head" mode="text"/>
            <xsl:text>]</xsl:text>
          </a>
        </td>
      </tr>
    </xsl:otherwise>
  </xsl:choose>
</xsl:template>

<xsl:template match="constraintnote
                   | vcnote
                   | wfcnote">
  <dl class="constraint">
    <dt><xsl:apply-templates select="head"/></dt>
    <dd><xsl:apply-templates select="*[not (self::head)]"/></dd>
  </dl>
</xsl:template>

<xsl:template match="constraintnote/head
                   | vcnote/head
                   | wfcnote/head">
  <xsl:if test="../@id">
    <a name="{../@id}" id="{../@id}"/>
  </xsl:if>
  <b>
    <xsl:choose>
      <xsl:when test="(parent::constraintnote[@type='ns'])">
        <xsl:text>İsim-alanı kuralı: </xsl:text>
      </xsl:when>
      <xsl:when test="name(..) = 'vcnote'">
        <xsl:text>Geçerlilik kuralı: </xsl:text>
      </xsl:when>
      <xsl:when test="name(..) = 'wfcnote'">
        <xsl:text>İyi biçimlilik kuralı: </xsl:text>
      </xsl:when>
      <xsl:otherwise>
        <xsl:text>Kural: </xsl:text>
      </xsl:otherwise>
    </xsl:choose>
  </b>
  <big><xsl:apply-templates/></big>
</xsl:template>

<xsl:template match="copyright">
  <xsl:apply-templates/>
</xsl:template>

<xsl:template match="copyright/p">
  <p class="copyright">
    <xsl:apply-templates/>
  </p>
</xsl:template>

<xsl:template match="day
                   | date
                   | month
                   | year">
  <xsl:apply-templates/>
</xsl:template>

<xsl:template match="def">
  <dd>
    <xsl:apply-templates/>
  </dd>
</xsl:template>

<xsl:template match="div1 | inform-div1">
  <div class="div1">
    <xsl:apply-templates/>
  </div>
</xsl:template>

<xsl:template match="div2">
  <div class="div2">
    <xsl:apply-templates/>
  </div>
</xsl:template>

<xsl:template match="div3">
  <div class="div3">
    <xsl:apply-templates/>
  </div>
</xsl:template>

<xsl:template match="div4">
  <div class="div4">
    <xsl:apply-templates/>
  </div>
</xsl:template>

<xsl:template match="div5">
  <div class="div5">
    <xsl:apply-templates/>
  </div>
</xsl:template>

<xsl:template match="ednote">
  <dl class="note">
    <dt class="prefix"><b>Çevirmenin notu: </b></dt>
    <dd>
      <xsl:apply-templates/>
    </dd>
  </dl>
</xsl:template>

<xsl:template match="edtext">
  <xsl:apply-templates/>
</xsl:template>

<xsl:template match="el">
  <code><xsl:apply-templates/></code>
</xsl:template>

<xsl:template match="eg">
  <xsl:variable name="content">
    <xsl:call-template name="anchor"/>
    <pre>
      <xsl:if test="(@role)">
        <xsl:attribute name="class">
          <xsl:value-of select="@role"/>
        </xsl:attribute>
      </xsl:if>
      <xsl:apply-templates/>
    </pre>
  </xsl:variable>
  <xsl:choose>
    <xsl:when test="@role = 'error'">
      <xsl:copy-of select="$content"/>
    </xsl:when>
    <xsl:when test="name(..)!='example'">
      <div class="example">
        <xsl:copy-of select="$content"/>
      </div>
    </xsl:when>
    <xsl:otherwise>
      <xsl:copy-of select="$content"/>
    </xsl:otherwise>
  </xsl:choose>
  <xsl:if test="not (following-sibling::*[1][self::p])">
    <p />
  </xsl:if>
</xsl:template>

<xsl:template match="email">
  <xsl:text> </xsl:text>
  <a href="{translate(@href, '.', '·')}">
    <xsl:text>&lt;</xsl:text>
    <xsl:choose>
      <xsl:when test="count(child::node())=0">
        <xsl:value-of select="translate(substring-after(@href, 'mailto:'), '.', '·')"/>
      </xsl:when>
      <xsl:otherwise>
        <xsl:apply-templates/>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:text>&gt;</xsl:text>
  </a>
</xsl:template>

<xsl:template match="emph">
  <em>
    <xsl:call-template name="anchor">
      <xsl:with-param name="conditional" select="1"/>
    </xsl:call-template>
    <xsl:apply-templates/>
  </em>
</xsl:template>

<xsl:template match="emph[@role='infoset-property']">
  <b><i>
    <xsl:call-template name="anchor">
      <xsl:with-param name="conditional" select="1"/>
    </xsl:call-template>
    <xsl:apply-templates/>
  </i></b>
</xsl:template>

<xsl:template match="emph[@role='infoset-item']">
  <b>
    <xsl:call-template name="anchor">
      <xsl:with-param name="conditional" select="1"/>
    </xsl:call-template>
    <xsl:apply-templates/>
  </b>
</xsl:template>

<xsl:template match="example">
  <xsl:call-template name="anchor">
    <xsl:with-param name="conditional" select="0"/>
  </xsl:call-template>
  <dl class="example">
    <dt><b>
      <xsl:text>Örnek: </xsl:text>
      <xsl:apply-templates select="head"/>
    </b></dt>
    <dd><xsl:apply-templates select="*[not(self::head)]"/></dd>
  </dl>
</xsl:template>

<xsl:template match="example/head">
  <xsl:apply-templates/>
</xsl:template>

<xsl:template match="figure">
  <div class="figure">
    <xsl:if test="@id">
      <a id="{@id}" name="{@id}"/>
    </xsl:if>
    <xsl:apply-templates/>
  </div>
</xsl:template>

<xsl:template match="figure/head">
  <xsl:choose>
    <xsl:when test="$tabular.examples = 0">
      <div class="exampleHeader">
        <xsl:call-template name="anchor">
          <xsl:with-param name="node" select=".."/>
          <xsl:with-param name="conditional" select="0"/>
        </xsl:call-template>
        <xsl:text>Şekil: </xsl:text>
        <xsl:apply-templates/>
      </div>
    </xsl:when>
    <xsl:otherwise>
      <h5>
        <xsl:call-template name="anchor">
          <xsl:with-param name="node" select=".."/>
          <xsl:with-param name="conditional" select="0"/>
        </xsl:call-template>

        <xsl:text>Şekil: </xsl:text>
        <xsl:apply-templates/>
      </h5>
    </xsl:otherwise>
  </xsl:choose>
</xsl:template>

<xsl:template match="figure/caption">
  <div class="figcaption">
    <xsl:apply-templates/>
  </div>
</xsl:template>

<xsl:template match="footnote">
  <xsl:variable name="this-note-id">
    <xsl:choose>
      <xsl:when test="@id">
        <xsl:value-of select="@id"/>
      </xsl:when>
      <xsl:otherwise>
        <xsl:value-of select="generate-id(.)"/>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:variable>
  <sup>
    <xsl:text>[</xsl:text>
    <a name="FN-ANCH-{$this-note-id}" id="FN-ANCH-{$this-note-id}" href="#{$this-note-id}">
      <xsl:apply-templates select="." mode="number-simple"/>
    </a>
    <xsl:text>]</xsl:text>
  </sup>
</xsl:template>

<xsl:template match="front">
  <div class="front">
    <xsl:apply-templates/>
  </div>
</xsl:template>

<xsl:key name="protos" match="proto" use="@name"/>

<xsl:template match="function">
  <xsl:variable name="fname">
    <xsl:apply-templates/>
  </xsl:variable>
  <xsl:choose>
    <xsl:when test="(//proto[@name=$fname])">
      <a>
        <xsl:attribute name="href">
          <xsl:call-template name="fname.target">
            <xsl:with-param name="target" select="key('protos', $fname)"/>
          </xsl:call-template>
          <xsl:value-of select="concat('#function-', $fname)"/>
        </xsl:attribute>
      <!--a href="{concat('#function-', $fname)}"-->
        <code class="function">
          <xsl:value-of select="$fname"/>
        </code>
      </a>
    </xsl:when>
    <xsl:otherwise>
      <code class="function">
        <xsl:value-of select="$fname"/>
      </code>
    </xsl:otherwise>
  </xsl:choose>
</xsl:template>

<xsl:template match="gitem">
  <xsl:apply-templates/>
</xsl:template>

<xsl:template match="glist|varlist">
  <xsl:if test="$validity.hacks = 1 and local-name(..) = 'p'">
    <xsl:text disable-output-escaping="yes">&lt;/p&gt;</xsl:text>
  </xsl:if>
  <dl class="{name(.)}">
    <xsl:apply-templates/>
  </dl>
  <xsl:if test="$validity.hacks = 1 and local-name(..) = 'p'">
    <xsl:text disable-output-escaping="yes">&lt;p&gt;</xsl:text>
  </xsl:if>
</xsl:template>

<xsl:template match="graphic">
  <img src="{@src|@source}">
    <xsl:if test="(parent::example)">
      <xsl:attribute name="style">
        <xsl:text>position: relative; left: 40px;</xsl:text>
      </xsl:attribute>
    </xsl:if>
    <xsl:attribute name="alt">
      <xsl:value-of select="@alt|@title"/>
    </xsl:attribute>
    <xsl:attribute name="title">
      <xsl:value-of select="@alt|@title"/>
    </xsl:attribute>
  </img>
  <xsl:if test="name(..)='figure'">
    <br />
  </xsl:if>
</xsl:template>

<xsl:template match="div1/head">
  <h2>
    <xsl:call-template name="anchor">
      <xsl:with-param name="conditional" select="0"/>
      <xsl:with-param name="node" select=".."/>
    </xsl:call-template>
    <xsl:apply-templates select=".." mode="divnum"/>
    <xsl:apply-templates/>
  </h2>
  <xsl:call-template name="chunk-toc"/>
</xsl:template>

<xsl:template match="div2/head">
  <h3>
    <xsl:call-template name="anchor">
      <xsl:with-param name="conditional" select="0"/>
      <xsl:with-param name="node" select=".."/>
    </xsl:call-template>
    <xsl:apply-templates select=".." mode="divnum"/>
    <xsl:apply-templates/>
  </h3>
</xsl:template>

<xsl:template match="div3/head">
  <h4>
    <xsl:call-template name="anchor">
      <xsl:with-param name="conditional" select="0"/>
      <xsl:with-param name="node" select=".."/>
    </xsl:call-template>
    <xsl:apply-templates select=".." mode="divnum"/>
    <xsl:apply-templates/>
  </h4>
</xsl:template>

<xsl:template match="div4/head">
  <h5>
    <xsl:call-template name="anchor">
      <xsl:with-param name="conditional" select="0"/>
      <xsl:with-param name="node" select=".."/>
    </xsl:call-template>
    <xsl:apply-templates select=".." mode="divnum"/>
    <xsl:apply-templates/>
  </h5>
</xsl:template>

<xsl:template match="div5/head">
  <h6>
    <xsl:call-template name="anchor">
      <xsl:with-param name="conditional" select="0"/>
      <xsl:with-param name="node" select=".."/>
    </xsl:call-template>
    <xsl:apply-templates select=".." mode="divnum"/>
    <xsl:apply-templates/>
  </h6>
</xsl:template>

<xsl:template match="inform-div1/head">
  <h2>
    <xsl:call-template name="anchor">
      <xsl:with-param name="conditional" select="0"/>
      <xsl:with-param name="node" select=".."/>
    </xsl:call-template>
    <xsl:apply-templates select=".." mode="divnum"/>
    <xsl:apply-templates/>
    <xsl:text> (Bilgilendirici)</xsl:text>
  </h2>
  <xsl:call-template name="chunk-toc"/>
</xsl:template>

<xsl:template name="chunk-toc"/>

<xsl:template match="scrap/head">
  <b><i>
    <xsl:call-template name="anchor">
      <xsl:with-param name="node" select=".."/>
      <xsl:with-param name="conditional" select="0"/>
    </xsl:call-template>

    <xsl:apply-templates/>
  </i></b>
</xsl:template>

<xsl:template match="indexterm">
  <xsl:variable name="idx">
    <xsl:call-template name="indexterm.id"/>
  </xsl:variable>
  <a id="{$idx}" name="{$idx}"/>
</xsl:template>

<xsl:template match="item">
    <li>
      <xsl:if test="@id">
        <xsl:attribute name="id">
          <xsl:value-of select="@id"/>
        </xsl:attribute>
      </xsl:if>
      <xsl:apply-templates/>
    </li>
</xsl:template>

<xsl:template match="kw">
  <b><xsl:apply-templates/></b>
</xsl:template>

<xsl:template match="label">
  <dt class="label">
    <xsl:call-template name="anchor">
      <xsl:with-param name="node" select=".."/>
    </xsl:call-template>
    <xsl:call-template name="anchor"/>

    <xsl:apply-templates/>
  </dt>
</xsl:template>

<xsl:template match="latestloc">
  <xsl:choose>
    <xsl:when test="count(loc) &gt; 1">
      <xsl:for-each select="loc">
        <dt>
          <xsl:apply-templates select="node()"/>
        </dt>
        <dd>
          <a href="{@href}">
            <xsl:value-of select="@href"/>
          </a>
        </dd>
      </xsl:for-each>
    </xsl:when>
    <xsl:otherwise>
      <dt>Son sürüm:</dt>
      <dd>
        <xsl:apply-templates/>
      </dd>
    </xsl:otherwise>
  </xsl:choose>
</xsl:template>

<xsl:template match="loc">
  <a href="{@href}">
    <xsl:if test="@title">
      <xsl:attribute name="title">
        <xsl:value-of select="@title"/>
      </xsl:attribute>
    </xsl:if>
    <xsl:choose>
      <xsl:when test="count(child::node())=0">
        <xsl:value-of select="@href"/>
      </xsl:when>
      <xsl:otherwise>
        <xsl:apply-templates/>
      </xsl:otherwise>
    </xsl:choose>
  </a>
  <xsl:if test="((ancestor::publoc) or (ancestor::latestloc) or (ancestor::prevlocs)) and (following-sibling::loc)">
    <br />
  </xsl:if>
</xsl:template>

<xsl:template match="loc[(ancestor::altlocs)]">
  <xsl:choose>
    <xsl:when test="not (preceding-sibling::loc)"/>
    <xsl:when test="(following-sibling::loc)">
      <xsl:text>, </xsl:text>
    </xsl:when>
    <xsl:otherwise>
      <xsl:text> ve </xsl:text>
    </xsl:otherwise>
  </xsl:choose>
  <a href="{@href}">
    <xsl:choose>
      <xsl:when test="count(child::node())=0">
        <xsl:value-of select="@href"/>
      </xsl:when>
      <xsl:otherwise>
        <xsl:apply-templates/>
      </xsl:otherwise>
    </xsl:choose>
  </a>

</xsl:template>

<xsl:template match="loc[@role='available-format']">
  <xsl:choose>
    <xsl:when test="not (preceding-sibling::loc[@role='available-format'])">
      <xsl:text>(</xsl:text>
    </xsl:when>
    <xsl:when test="(following-sibling::loc[@role='available-format'])">
      <br /><xsl:text>, </xsl:text>
    </xsl:when>
    <xsl:otherwise>
      <xsl:text> ve </xsl:text>
    </xsl:otherwise>
  </xsl:choose>
  <a href="{@href}">
    <xsl:choose>
      <xsl:when test="count(child::node())=0">
        <xsl:value-of select="@href"/>
      </xsl:when>
      <xsl:otherwise>
        <xsl:apply-templates/>
      </xsl:otherwise>
    </xsl:choose>
  </a>
  <xsl:if test="not (following-sibling::loc[@role='available-format'])">
    <xsl:text> biçimleri mevcuttur.)</xsl:text>
  </xsl:if>
</xsl:template>

<xsl:template match="lhs">
  <tr valign="baseline">
    <td width="5%">
      <xsl:if test="../@id">
        <a name="{../@id}" id="{../@id}"/>
      </xsl:if>
      <tt><xsl:apply-templates select="ancestor::prod" mode="number"/></tt>
      <xsl:text>   </xsl:text>
    </td>
    <td width="5%">
      <code><xsl:apply-templates/></code>
    </td>
    <td width="5%">
      <xsl:text>   ::=   </xsl:text>
    </td>
    <xsl:apply-templates select="following-sibling::*[1][self::rhs]"/>
  </tr>
</xsl:template>

<xsl:template match="member">
  <li>
    <xsl:apply-templates/>
  </li>
</xsl:template>

<xsl:template match="name">
  <xsl:apply-templates/>
</xsl:template>

<xsl:template match="note">
  <dl class="note">
    <dt class="prefix"><b>Not:</b></dt>
    <dd><xsl:apply-templates/></dd>
  </dl>
  <xsl:if test="not (following-sibling::*[1][self::p])">
    <p />
  </xsl:if>
</xsl:template>

<xsl:template match="notice">
  <div class="notice">
    <p class="prefix">
      <b>UYARI:</b>
    </p>
    <xsl:apply-templates/>
  </div>
</xsl:template>

<xsl:template match="nt">
  <a>
    <xsl:attribute name="href">
      <xsl:call-template name="href.target">
        <xsl:with-param name="target" select="key('ids', @def)"/>
      </xsl:call-template>
    </xsl:attribute>
    <code><xsl:apply-templates/></code>
  </a>
</xsl:template>

<xsl:template match="olist">
  <xsl:variable name="numeration">
    <xsl:call-template name="list.numeration"/>
  </xsl:variable>

  <ol class="enum{$numeration}">
    <xsl:apply-templates/>
  </ol>
</xsl:template>

<xsl:template match="orglist">
  <ul>
    <xsl:apply-templates/>
  </ul>
</xsl:template>

<!-- ================================================================= -->

<xsl:template match="p">
  <p>
    <xsl:if test="@id">
      <xsl:attribute name="id">
        <xsl:value-of select="@id"/>
      </xsl:attribute>
    </xsl:if>
    <xsl:if test="@role">
      <xsl:attribute name="class">
        <xsl:value-of select="@role"/>
      </xsl:attribute>
    </xsl:if>
    <xsl:apply-templates/>
  </p>
</xsl:template>

<xsl:template match="p[(ancestor::gitem) or
                       (ancestor::example) or
                       (ancestor::note)][not (preceding-sibling::*)]">
    <xsl:if test="@id">
    <xsl:attribute name="id">
      <xsl:value-of select="@id"/>
    </xsl:attribute>
  </xsl:if>
  <xsl:if test="@role">
    <xsl:attribute name="class">
      <xsl:value-of select="@role"/>
    </xsl:attribute>
  </xsl:if>
  <xsl:apply-templates/>
  <xsl:if test="not (following-sibling::*[1][self::p])">
    <p />
  </xsl:if>
</xsl:template>

<xsl:template match="p[@role='general-index']">
  <div class="index">
    <xsl:call-template name="generate-index"/>
  </div>
</xsl:template>

<!-- ================================================================= -->

<xsl:template match="phrase">
  <span>
    <xsl:if test="@role">
      <xsl:attribute name="class">
        <xsl:value-of select="@role"/>
      </xsl:attribute>
    </xsl:if>
    <xsl:apply-templates/>
  </span>
</xsl:template>

<xsl:template match="prevlocs">
  <dt>
    <xsl:text>Önceki Sürüm</xsl:text>
    <xsl:if test="count(loc) &gt; 1">ler</xsl:if>
    <xsl:text>:</xsl:text>
  </dt>
  <dd>
    <xsl:apply-templates/>
  </dd>
</xsl:template>

<xsl:template match="prod">
  <tbody>
    <xsl:apply-templates select="lhs |                 rhs[preceding-sibling::*[1][name()!='lhs']] |                 com[preceding-sibling::*[1][name()!='rhs']] |                 constraint[preceding-sibling::*[1][name()!='rhs']] |                vc[preceding-sibling::*[1][name()!='rhs']] |                 wfc[preceding-sibling::*[1][name()!='rhs']]"/>
  </tbody>
</xsl:template>

<xsl:template match="prodgroup/prod">
  <xsl:apply-templates select="lhs |               rhs[preceding-sibling::*[1][name()!='lhs']] |               com[preceding-sibling::*[1][name()!='rhs']] |               constraint[preceding-sibling::*[1][name()!='rhs']] |             vc[preceding-sibling::*[1][name()!='rhs']] |               wfc[preceding-sibling::*[1][name()!='rhs']]"/>
</xsl:template>

<xsl:template match="prodgroup">
  <tbody>
    <xsl:apply-templates/>
  </tbody>
</xsl:template>

<xsl:template match="prodrecap">
  <tbody>
    <xsl:apply-templates select="key('ids', @ref)" mode="ref"/>
  </tbody>
</xsl:template>

<xsl:template match="processing-instruction('specprod')">
  <xsl:if test="contains(., 'production-recap')"/>
  <table class="scrap" summary="Scrap">
    <tbody>
      <xsl:apply-templates select="//prod" mode="ref"/>
    </tbody>
  </table>
</xsl:template>

<xsl:template match="proto">
  <xsl:variable name="anchor" select="concat('function-', @name)"/>
  <a name="{$anchor}" id="{$anchor}"/>
  <table class="proto" width="100%" cellpadding="0" cellspacing="0" border="0">
    <tr>
      <td>
        <pre class="proto">
          <em><xsl:value-of select="@return-type"/></em>
          <xsl:text> </xsl:text>
          <b><xsl:value-of select="@name"/></b>
          <xsl:text>(</xsl:text>
          <xsl:apply-templates/>
          <xsl:text>)</xsl:text>
        </pre>
      </td>
      <td align="right" valign="top" style="font-variant: small-caps;">İşlev</td>
    </tr>
  </table>
</xsl:template>

<xsl:template match="publoc">
  <dt>Bu sürüm:</dt>
  <dd>
    <xsl:apply-templates/>
  </dd>
</xsl:template>

<xsl:template match="errataloc">
  <p>
    <xsl:text>Lütfen bu belgenin </xsl:text>
    <a href="{@href}">hata raporları</a>
    <xsl:text>na da bakın, aralarında uyulması gereken düzeltmeler bulunabilir.</xsl:text>
  </p>
</xsl:template>

<xsl:template match="preverrataloc">
  <p>
    <xsl:text>Bu belgenin bir de </xsl:text>
    <a href="{@href}">eski hata raporları</a>
    <xsl:text> var.</xsl:text>
  </p>
</xsl:template>

<xsl:template match="translationloc">
  <p>
    <xsl:text>Belgenin başka dillere </xsl:text>
    <a href="{@href}"><strong>çeviriler</strong></a>
    <xsl:text>i de olabilir.</xsl:text>
  </p>
</xsl:template>

<xsl:template match="quote">
  <xsl:text>"</xsl:text>
  <xsl:apply-templates/>
  <xsl:text>"</xsl:text>
</xsl:template>

<xsl:template match="revisiondesc"/>

<xsl:template match="rfc2119">
  <xsl:choose>
    <xsl:when test="(must|rec|opt)">
      <xsl:apply-templates/>
    </xsl:when>
    <xsl:otherwise>
      <em class="rfc2119" title="{concat('RFC 2119 bağlamında ', text())}">
        <xsl:apply-templates/>
      </em>
    </xsl:otherwise>
  </xsl:choose>
</xsl:template>

<xsl:template match="must">
  <em class="must" title="RFC 2119 bağlamında ZORUNLU">
    <xsl:apply-templates/>
  </em>
  <em class="rfc2119" title="RFC 2119 bağlamında ZORUNLU"> ZORUNLU</em>
</xsl:template>

<xsl:template match="rec">
  <em class="rec" title="RFC 2119 bağlamında ÖNERİ">
    <xsl:apply-templates/>
  </em>
  <em class="rfc2119" title="RFC 2119 bağlamında ÖNERİ"> ÖNERİ</em>
</xsl:template>

<xsl:template match="opt">
  <em class="opt" title="RFC 2119 bağlamında SEÇİMLiK">
    <xsl:apply-templates/>
  </em>
  <em class="rfc2119" title="RFC 2119 bağlamında SEÇİMLiK"> SEÇİMLiK</em>
</xsl:template>

<xsl:template match="rhs">
  <xsl:choose>
    <xsl:when test="preceding-sibling::*[1][name()='lhs']">
      <td width="*">
        <code><xsl:apply-templates/></code>
      </td>
      <xsl:apply-templates select="following-sibling::*[1][(self::com) or           (self::constraint) or (self::vc) or (self::wfc)]"/>
    </xsl:when>
    <xsl:otherwise>
      <tr valign="baseline">
        <td width="%5"/><td width="%5"/><td width="%5"/>
        <td width="*">
          <code><xsl:apply-templates/></code>
        </td>
        <xsl:apply-templates select="following-sibling::*[1][(self::com) or           (self::constraint) or (self::vc) or (self::wfc)]"/>
      </tr>
    </xsl:otherwise>
  </xsl:choose>
</xsl:template>

<xsl:template match="role">
  <xsl:text> (</xsl:text>
  <i><xsl:apply-templates/></i>
  <xsl:text>) </xsl:text>
</xsl:template>

<xsl:template match="scrap">
  <xsl:apply-templates select="head | indexterm"/>
  <table class="scrap" summary="Scrap">
    <xsl:apply-templates select="bnf | prod | prodgroup"/>
  </table>
</xsl:template>

<xsl:template match="sitem">
  <li><xsl:apply-templates/>
  <xsl:if test="(ancestor::item) and not (following-sibling::sitem)">
    <p />
  </xsl:if></li>
</xsl:template>

<xsl:template match="slist">
  <ul>
    <xsl:apply-templates/>
  </ul>
</xsl:template>

<xsl:template match="specref">
  <xsl:param name="target" select="key('ids', @ref)[1]"/>

  <xsl:choose>
    <xsl:when test="not($target)">
      <xsl:message>
        <xsl:text>specref to non-existent ID: </xsl:text>
        <xsl:value-of select="@ref"/>
      </xsl:message>
    </xsl:when>
    <xsl:when test="local-name($target)='issue' or
                    starts-with(local-name($target), 'div') or
                    starts-with(local-name($target), 'inform-div') or
                    local-name($target) = 'vcnote' or
                    local-name($target) = 'wfcnote' or
                    local-name($target) = 'prod' or
                    local-name($target) = 'example' or
                    local-name($target) = 'label' or
                    $target/self::item[parent::olist]">
      <xsl:apply-templates select="$target" mode="specref"/>
    </xsl:when>
    <xsl:when test="local-name($target) = 'head' and
                    starts-with(local-name($target/parent::*[1]), 'div') or
                    starts-with(local-name($target/parent::*[1]), 'inform-div')">
      <xsl:apply-templates select="$target/parent::*[1]" mode="specref"/>
    </xsl:when>
    <xsl:otherwise>
      <xsl:message>
        <xsl:text>Unsupported specref to </xsl:text>
        <xsl:value-of select="local-name($target)"/>
        <xsl:text> [$target/@id= </xsl:text>
        <xsl:value-of select="@ref"/>
        <xsl:text>] </xsl:text>
        <xsl:text> (Contact stylesheet maintainer).</xsl:text>
      </xsl:message>
      <b>
        <a>
          <xsl:attribute name="href">
            <xsl:call-template name="href.target">
              <xsl:with-param name="target" select="key('ids', @ref)"/>
            </xsl:call-template>
          </xsl:attribute>
          <xsl:text>???</xsl:text>
        </a>
      </b>
    </xsl:otherwise>
  </xsl:choose>
</xsl:template>

<xsl:template match="item" mode="specref">
  <xsl:variable name="items" select="ancestor-or-self::item[parent::olist]"/>
  <a>
    <xsl:attribute name="href">
      <xsl:call-template name="href.target"/>
    </xsl:attribute>
    <xsl:for-each select="$items">
      <xsl:variable name="number" select="count(preceding-sibling::item)+1"/>
  <!-- this is related to, but not the same as, list.numeration -->
      <xsl:choose>
        <xsl:when test="count(ancestor::olist) mod 5 = 2">
          <xsl:number value="$number" format="a"/>
        </xsl:when>
        <xsl:when test="count(ancestor::olist) mod 5 = 3">
          <xsl:number value="$number" format="i"/>
        </xsl:when>
        <xsl:when test="count(ancestor::olist) mod 5 = 4">
          <xsl:number value="$number" format="A"/>
        </xsl:when>
        <xsl:when test="count(ancestor::olist) mod 5 = 0">
          <xsl:number value="$number" format="I"/>
        </xsl:when>
        <xsl:otherwise>
          <xsl:value-of select="$number"/>
        </xsl:otherwise>
      </xsl:choose>
      <xsl:text>.</xsl:text>
    </xsl:for-each>
  </a>
</xsl:template>

<xsl:template match="div1|inform-div1|div2|div3|div4|div5" mode="specref">
  <a>
    <xsl:attribute name="href">
      <xsl:call-template name="href.target"/>
    </xsl:attribute>
    <b>
      <!--xsl:apply-templates select="." mode="divnum"/-->
      <xsl:apply-templates select="head" mode="text"/>
    </b>
  </a>
</xsl:template>

<xsl:template match="vcnote|wfcnote|constraintnote" mode="specref">
  <b>
    <xsl:choose>
      <xsl:when test="(self::constraintnote[@type='ns'])">
        <xsl:text>[İAK: </xsl:text>
      </xsl:when>
      <xsl:when test="(self::vcnote)">
        <xsl:text>[GK: </xsl:text>
      </xsl:when>
      <xsl:when test="(self::wfcnote)">
        <xsl:text>[İBK: </xsl:text>
      </xsl:when>
      <xsl:otherwise>
        <xsl:text>[Kısıt: </xsl:text>
      </xsl:otherwise>
    </xsl:choose>
    <a>
      <xsl:attribute name="href">
        <xsl:call-template name="href.target"/>
      </xsl:attribute>
      <xsl:apply-templates select="head" mode="text"/>
    </a>
    <xsl:text>]</xsl:text>
  </b>
</xsl:template>


<xsl:template match="prod" mode="specref">
  <b>
    <xsl:text>[SDT: </xsl:text>
    <a>
      <xsl:attribute name="href">
        <xsl:call-template name="href.target"/>
      </xsl:attribute>
      <xsl:apply-templates select="." mode="number-simple"/>
    </a>
    <xsl:text>]</xsl:text>
  </b>
</xsl:template>

<xsl:template match="label" mode="specref">
  <b>
    <xsl:text>[</xsl:text>
    <a>
      <xsl:attribute name="href">
        <xsl:call-template name="href.target"/>
      </xsl:attribute>
      <xsl:value-of select="."/>
    </a>
    <xsl:text>]</xsl:text>
  </b>
</xsl:template>

<xsl:template match="example" mode="specref">
  <xsl:apply-templates select="head" mode="specref"/>
</xsl:template>

<xsl:template match="example/head" mode="specref">
  <xsl:variable name="id">
    <xsl:call-template name="object.id">
      <xsl:with-param name="node" select=".."/>
    </xsl:call-template>
  </xsl:variable>

  <a href="#{$id}">
    <xsl:text>Örnek</xsl:text>
  </a>
</xsl:template>

<xsl:template match="status">
  <div>
    <h2>
      <xsl:call-template name="anchor">
        <xsl:with-param name="conditional" select="0"/>
        <xsl:with-param name="default.id" select="'status'"/>
      </xsl:call-template>
      <xsl:text>Belgenin Durumu</xsl:text>
    </h2>
    <xsl:apply-templates/>
  </div>
</xsl:template>

<xsl:template match="sub">
  <sub>
    <xsl:apply-templates/>
  </sub>
</xsl:template>

<xsl:template match="sup">
  <sup>
    <xsl:apply-templates/>
  </sup>
</xsl:template>

<xsl:template match="table/caption|col|colgroup|tfoot|thead|tr|tbody">
  <xsl:element name="{local-name(.)}">
    <xsl:for-each select="@*">
      <!-- Wait: some of these aren't HTML attributes after all... -->
      <xsl:choose>
        <xsl:when test="local-name(.) = 'role'">
          <xsl:attribute name="class">
            <xsl:value-of select="."/>
          </xsl:attribute>
        </xsl:when>
        <xsl:when test="local-name(.) = 'diff'"/>
        <xsl:otherwise>
          <xsl:copy>
            <xsl:apply-templates/>
          </xsl:copy>
        </xsl:otherwise>
      </xsl:choose>
    </xsl:for-each>
    <xsl:apply-templates/>
  </xsl:element>
</xsl:template>

<xsl:template match="td|th">
  <xsl:element name="{local-name(.)}">
    <xsl:for-each select="@*">
      <!-- Wait: some of these aren't HTML attributes after all... -->
      <xsl:choose>
        <xsl:when test="local-name(.) = 'role'">
          <xsl:attribute name="class">
            <xsl:value-of select="."/>
          </xsl:attribute>
        </xsl:when>
        <xsl:when test="local-name(.) = 'diff'"/>
        <xsl:when test="local-name(.) = 'colspan' and . = 1"/>
        <xsl:when test="local-name(.) = 'rowspan' and . = 1"/>
        <xsl:otherwise>
          <xsl:copy-of select="."/>
        </xsl:otherwise>
      </xsl:choose>
    </xsl:for-each>
    <xsl:apply-templates/>
  </xsl:element>
</xsl:template>

<xsl:template match="table">
  <xsl:call-template name="anchor"/>
  <table>
    <xsl:for-each select="@*">
      <!-- Wait: some of these aren't HTML attributes after all... -->
      <xsl:choose>
        <xsl:when test="local-name(.) = 'role'">
          <xsl:attribute name="class">
            <xsl:value-of select="."/>
          </xsl:attribute>
        </xsl:when>
        <xsl:when test="local-name(.) = 'diff' or local-name(.) = 'id'"/>
        <xsl:otherwise>
          <xsl:copy-of select="."/>
        </xsl:otherwise>
      </xsl:choose>
    </xsl:for-each>
    <xsl:apply-templates/>

    <xsl:if test=".//footnote">
      <tbody>
        <tr>
          <td>
            <xsl:apply-templates select=".//footnote" mode="table.notes"/>
          </td>
        </tr>
      </tbody>
    </xsl:if>
  </table>
  <xsl:if test="not (following-sibling::*[1][self::p])">
    <p />
  </xsl:if>
</xsl:template>

<xsl:template match="term">
  <b><xsl:apply-templates/></b>
</xsl:template>

<xsl:template match="termdef">
  <a name="{@id}" id="{@id}" title="{@term}"/>
  <span title="{concat(@term,' tanımı')}" class="termdef">
    <xsl:apply-templates/>
  </span>
</xsl:template>

<xsl:template match="termref">
  <xsl:variable name="termof" select="key('ids', @def)"/>
  <xsl:variable name="term">
    <xsl:if test="$termof/@term">
      <xsl:value-of select="$termof/@term"/>
    </xsl:if>
    <xsl:if test="$termof[self::label]">
      <xsl:value-of select="string($termof)"/>
    </xsl:if>
  </xsl:variable>
  <a title="{$term} tanımı">
    <xsl:attribute name="href">
      <xsl:call-template name="href.target">
        <xsl:with-param name="target" select="$termof"/>
      </xsl:call-template>
    </xsl:attribute>
    <xsl:apply-templates/>
  </a>
</xsl:template>

<xsl:template match="titleref">
  <xsl:choose>
    <xsl:when test="(@ref)">
      <a>
        <xsl:attribute name="href">
          <xsl:call-template name="href.target">
            <xsl:with-param name="target" select="key('ids', @ref)"/>
          </xsl:call-template>
        </xsl:attribute>
        <xsl:apply-templates/>
      </a>
    </xsl:when>
    <xsl:when test="(@href)">
      <a href="{@href}">
        <xsl:apply-templates/>
      </a>
    </xsl:when>
    <xsl:when test="(ancestor::bibl/@href)">
      <a href="{ancestor::bibl/@href}">
        <xsl:apply-templates/>
      </a>
    </xsl:when>
    <xsl:otherwise>
      <cite>
        <xsl:apply-templates/>
      </cite>
    </xsl:otherwise>
  </xsl:choose>
</xsl:template>

<xsl:template match="tt">
  <tt><xsl:apply-templates/></tt>
</xsl:template>

<xsl:template match="ulist">
  <ul>
    <xsl:apply-templates/>
  </ul>
  <xsl:if test="not (following-sibling::*[1][self::p])">
    <p />
  </xsl:if>
</xsl:template>

<xsl:template match="var">
  <var>
    <xsl:apply-templates/>
  </var>
</xsl:template>

<xsl:template match="xnt">
  <code><a href="{@href}">
    <xsl:apply-templates/>
  </a></code>
</xsl:template>

<xsl:template match="xspecref | xtermref">
  <a href="{@href}">
    <xsl:apply-templates/>
  </a>
</xsl:template>

<xsl:template match="a|div|em|h1|h2|h3|h4|h5|h6|li|ol|pre|ul">
  <xsl:element name="{local-name(.)}">
    <xsl:copy-of select="@*"/>
    <xsl:apply-templates/>
  </xsl:element>
</xsl:template>

<xsl:template match="subtitle|title|version">
  <xsl:apply-templates/>
</xsl:template>

<!-- ================================================================= -->

  <!-- mode: divnum -->
<xsl:template mode="divnum" match="div1">
  <xsl:number format="1 "/>
</xsl:template>

<xsl:template mode="divnum" match="back/div1 | inform-div1">
  <xsl:number count="div1 | inform-div1" format="A "/>
</xsl:template>

<xsl:template mode="divnum" match="front/div1 | front//div2 | front//div3 | front//div4 | front//div5"/>

<xsl:template mode="divnum" match="div2">
  <xsl:number level="multiple" count="div1 | div2" format="1.1 "/>
</xsl:template>

<xsl:template mode="divnum" match="back//div2">
  <xsl:number level="multiple" count="div1 | div2 | inform-div1" format="A.1 "/>
</xsl:template>

<xsl:template mode="divnum" match="div3">
  <xsl:number level="multiple" count="div1 | div2 | div3" format="1.1.1 "/>
</xsl:template>

<xsl:template mode="divnum" match="back//div3">
  <xsl:number level="multiple" count="div1 | div2 | div3 | inform-div1" format="A.1.1 "/>
</xsl:template>

<xsl:template mode="divnum" match="div4">
  <xsl:number level="multiple" count="div1 | div2 | div3 | div4" format="1.1.1.1 "/>
</xsl:template>

<xsl:template mode="divnum" match="back//div4">
  <xsl:number level="multiple" count="div1 | div2 | div3 | div4 | inform-div1" format="A.1.1.1 "/>
</xsl:template>

<xsl:template mode="divnum" match="div5">
  <xsl:number level="multiple" count="div1 | div2 | div3 | div4 | div5" format="1.1.1.1.1 "/>
</xsl:template>

<xsl:template mode="divnum" match="back//div5">
  <xsl:number level="multiple" count="div1 | div2 | div3 | div4 | div5 | inform-div1" format="A.1.1.1.1 "/>
</xsl:template>

<!-- ================================================================= -->
  <!-- mode: notes -->
<xsl:template mode="notes" match="footnote">
  <xsl:variable name="this-note-id">
    <xsl:choose>
      <xsl:when test="@id">
        <xsl:value-of select="@id"/>
      </xsl:when>
      <xsl:otherwise>
        <xsl:value-of select="generate-id(.)"/>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:variable>
  <dt>
    <xsl:text>[</xsl:text>
    <a name="{$this-note-id}" id="{$this-note-id}" href="#FN-ANCH-{$this-note-id}">
      <xsl:apply-templates select="." mode="number-simple"/>
    </a>
    <xsl:text>]</xsl:text>
  </dt>
  <dd>
    <xsl:apply-templates/>
  </dd>
</xsl:template>

<!-- mode: table.notes -->
<xsl:template match="footnote" mode="table.notes">
  <xsl:apply-templates mode="table.notes"/>
</xsl:template>

<xsl:template match="footnote/p[1]" mode="table.notes">
  <xsl:variable name="this-note-id">
    <xsl:choose>
      <xsl:when test="../@id">
        <xsl:value-of select="../@id"/>
      </xsl:when>
      <xsl:otherwise>
        <xsl:value-of select="generate-id(parent::*)"/>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:variable>
  <p class="table.footnote">
    <sup>
      <a name="{$this-note-id}" id="{$this-note-id}" href="#FN-ANCH-{$this-note-id}">
        <xsl:apply-templates select="parent::footnote" mode="number-simple"/>
        <xsl:text>.</xsl:text>
      </a>
    </sup>
    <xsl:text> </xsl:text>
    <xsl:apply-templates/>
  </p>
</xsl:template>

<!-- ================================================================= -->
  <!-- mode: number -->
<xsl:template mode="number" match="prod">
  <xsl:text>[</xsl:text>
  <xsl:apply-templates select="." mode="number-simple"/>
  <xsl:text>]</xsl:text>
</xsl:template>

<!-- mode: number-simple -->
<xsl:template mode="number-simple" match="prod">
  <xsl:choose>
    <xsl:when test="@num">
      <xsl:value-of select="@num"/>
    </xsl:when>
    <xsl:otherwise>
      <xsl:number level="any" count="prod"/>
    </xsl:otherwise>
  </xsl:choose>
</xsl:template>

<xsl:template mode="number-simple" match="footnote">
  <xsl:number level="any" format="1"/>
</xsl:template>

<!-- ================================================================= -->
  <!-- mode: ref -->
<xsl:template match="lhs" mode="ref">
  <tr valign="baseline">
    <td>
      <xsl:apply-templates select="ancestor::prod" mode="number"/>
      <xsl:text>   </xsl:text>
    </td>
    <td>
      <xsl:choose>
        <xsl:when test="../@id">
          <a href="#{../@id}">
            <code><xsl:apply-templates/></code>
          </a>
        </xsl:when>
        <xsl:otherwise>
          <code><xsl:apply-templates/></code>
        </xsl:otherwise>
      </xsl:choose>
    </td>
    <td>
      <xsl:text>   ::=   </xsl:text>
    </td>
    <xsl:apply-templates select="following-sibling::*[1][self::rhs]"/>
  </tr>
</xsl:template>

<xsl:template mode="ref" match="prod">
  <xsl:apply-templates select="lhs" mode="ref"/>
  <xsl:apply-templates select="rhs[preceding-sibling::*[1][not (self::lhs)]] |
                 com[preceding-sibling::*[1][not (self::rhs)]] |
                 constraint[preceding-sibling::*[1][not (self::rhs)]] |
                 vc[preceding-sibling::*[1][not (self::rhs)]] |
                 wfc[preceding-sibling::*[1][not (self::rhs)]]"/>
</xsl:template>

<!-- mode: text -->
<!-- most stuff processes just as text here, but some things should
      be hidden -->
<xsl:template mode="text" match="ednote | footnote"/>

<!-- ================================================================= -->

  <!-- mode: toc -->
<xsl:template mode="toc" match="div1">
  <xsl:param name="toc.type" select="'full'"/>
  <xsl:apply-templates select="." mode="divnum"/>
  <a>
    <xsl:attribute name="href">
      <xsl:call-template name="href.target">
        <xsl:with-param name="target" select="."/>
      </xsl:call-template>
    </xsl:attribute>
    <xsl:apply-templates select="head" mode="text"/>
  </a>
  <br/>
  <xsl:if test="$toc.type='full' and $toc.level &gt; 1">
    <xsl:apply-templates select="div2" mode="toc"/>
  </xsl:if>
</xsl:template>

<xsl:template mode="toc" match="div2">
  <xsl:text>    </xsl:text>
  <xsl:apply-templates select="." mode="divnum"/>
  <a>
    <xsl:attribute name="href">
      <xsl:call-template name="href.target">
        <xsl:with-param name="target" select="."/>
      </xsl:call-template>
    </xsl:attribute>
    <xsl:apply-templates select="head" mode="text"/>
  </a>
  <br/>
  <xsl:if test="$toc.level &gt; 2">
    <xsl:apply-templates select="div3" mode="toc"/>
  </xsl:if>
</xsl:template>

<xsl:template mode="toc" match="div3">
  <xsl:text>          </xsl:text>
  <xsl:apply-templates select="." mode="divnum"/>
  <a>
    <xsl:attribute name="href">
      <xsl:call-template name="href.target">
        <xsl:with-param name="target" select="."/>
      </xsl:call-template>
    </xsl:attribute>
    <xsl:apply-templates select="head" mode="text"/>
  </a>
  <br/>
  <xsl:if test="$toc.level &gt; 3">
    <xsl:apply-templates select="div4" mode="toc"/>
  </xsl:if>
</xsl:template>

<xsl:template mode="toc" match="div4">
  <xsl:text>               </xsl:text>
  <xsl:apply-templates select="." mode="divnum"/>
  <a>
    <xsl:attribute name="href">
      <xsl:call-template name="href.target">
        <xsl:with-param name="target" select="."/>
      </xsl:call-template>
    </xsl:attribute>
    <xsl:apply-templates select="head" mode="text"/>
  </a>
  <br/>
  <xsl:if test="$toc.level &gt; 4">
    <xsl:apply-templates select="div5" mode="toc"/>
  </xsl:if>
</xsl:template>

<xsl:template mode="toc" match="div5">
  <xsl:text>                </xsl:text>
  <xsl:apply-templates select="." mode="divnum"/>
  <a>
    <xsl:attribute name="href">
      <xsl:call-template name="href.target">
        <xsl:with-param name="target" select="."/>
      </xsl:call-template>
    </xsl:attribute>
    <xsl:apply-templates select="head" mode="text"/>
  </a>
  <br/>
</xsl:template>

<xsl:template mode="toc" match="inform-div1">
  <xsl:param name="toc.type" select="'full'"/>
  <xsl:apply-templates select="." mode="divnum"/>
  <a>
    <xsl:attribute name="href">
      <xsl:call-template name="href.target">
        <xsl:with-param name="target" select="."/>
      </xsl:call-template>
    </xsl:attribute>
    <xsl:apply-templates select="head" mode="text"/>
  </a>
  <xsl:text> (Bilgilendirici)</xsl:text>
  <br/>
  <xsl:if test="$toc.type='full' and $toc.level &gt; 2">
    <xsl:apply-templates select="div2" mode="toc"/>
  </xsl:if>
</xsl:template>

<!-- ================================================================= -->

<xsl:template name="css">
  <style type="text/css">
    <xsl:value-of select="$additional.css"/>
    <xsl:text>/* Belgeye özel bir CSS yoksa burası boş olabilir. */</xsl:text>
  </style>
</xsl:template>

<xsl:template name="additional-head"/>

<xsl:template name="href.target">
  <xsl:param name="target" select="."/>

  <xsl:variable name="base">
    <xsl:call-template name="fname.target">
      <xsl:with-param name="target" select="$target"/>
    </xsl:call-template>
  </xsl:variable>
  <xsl:value-of select="$base"/>

  <xsl:if test="$base = '' or $base != concat($target/@id, '.html')">
    <xsl:text>#</xsl:text>
    <xsl:choose>
      <xsl:when test="$target/@id">
        <xsl:value-of select="$target/@id"/>
      </xsl:when>
      <xsl:otherwise>
        <xsl:value-of select="generate-id($target)"/>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:if>
</xsl:template>

<xsl:template name="fname.target"/>
<!-- ================================================================= -->
  <!-- OrderedList Numeration -->

<xsl:template name="list.numeration">
  <xsl:variable name="depth" select="count(ancestor::olist)"/>
  <xsl:choose>
    <xsl:when test="$depth mod 5 = 0">ar</xsl:when>
    <xsl:when test="$depth mod 5 = 1">la</xsl:when>
    <xsl:when test="$depth mod 5 = 2">lr</xsl:when>
    <xsl:when test="$depth mod 5 = 3">ua</xsl:when>
    <xsl:when test="$depth mod 5 = 4">ur</xsl:when>
  </xsl:choose>
</xsl:template>

<xsl:template name="object.id">
  <xsl:param name="node" select="."/>
  <xsl:param name="default.id" select="''"/>

  <xsl:choose>
    <!-- can't use the default ID if it's used somewhere else in the document! -->
    <xsl:when test="$default.id != '' and not(key('ids', $default.id))">
      <xsl:value-of select="$default.id"/>
    </xsl:when>
    <xsl:when test="$node/@id">
      <xsl:value-of select="$node/@id"/>
    </xsl:when>
    <xsl:otherwise>
      <xsl:value-of select="generate-id($node)"/>
    </xsl:otherwise>
  </xsl:choose>
</xsl:template>

<xsl:template name="anchor">
  <xsl:param name="node" select="."/>
  <xsl:param name="conditional" select="1"/>
  <xsl:param name="default.id" select="''"/>

  <xsl:variable name="id">
    <xsl:call-template name="object.id">
      <xsl:with-param name="node" select="$node"/>
      <xsl:with-param name="default.id" select="$default.id"/>
    </xsl:call-template>
  </xsl:variable>
  <xsl:if test="$conditional = 0 or $node/@id">
    <a name="{$id}" id="{$id}"/>
  </xsl:if>
</xsl:template>

<xsl:template name="indexterm.id">
  <xsl:text>idx</xsl:text>
  <xsl:number from="spec" level="any" format="1"/>
</xsl:template>

<!-- ================================================================= -->

</xsl:transform>