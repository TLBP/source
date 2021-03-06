<?xml version="1.0" encoding="utf-8"?>
<xsl:stylesheet
  xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
  xmlns:d="http://docbook.org/ns/docbook"
xmlns:exsl="http://exslt.org/common"
  xmlns="http://www.w3.org/1999/xhtml"
  exclude-result-prefixes="exsl d"
  version="1.0">

<!-- $Id: chunk.xsl,v 1.1 2011-09-16 21:43:59 bobs Exp $ -->

<!-- This is the main driver stylesheet file.  It imports or
includes all the components that it needs. -->

<!-- Import the module that customizes docbook elements -->
<!-- Put any customizations of element content in this module. -->
<xsl:import href="../docbook5/xhtml5/docbook.xsl"/>

<xsl:import href="tlbp-chunk-common.xsl"/>

<xsl:include href="../docbook5/xhtml/chunk-code.xsl"/>

<!-- The following module has templates that override the stock
     xhtml templates for HTML5 output.
     It contains match templates with priority="1" attributes,
     and named templates.  These override any templates that
     handle chunking behavior -->
<xsl:include href="tlbp-html5-chunk-mods.xsl"/>

</xsl:stylesheet>
