<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns="http://docbook.org/ns/docbook"
  xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:xs="http://www.w3.org/2001/XMLSchema"
  xmlns:its="http://www.w3.org/2005/11/its" xmlns:dm="urn:x-suse:ns:docmanager"
  xmlns:xi="http://www.w3.org/2001/XInclude" xmlns:xlink="http://www.w3.org/1999/xlink"
  xmlns:err="http://www.w3.org/2005/xqt-errors"
  xmlns:math="http://www.w3.org/2005/xpath-functions/math"
  xmlns:xd="http://www.oxygenxml.com/ns/doc/xsl"
  xpath-default-namespace="http://docbook.org/ns/docbook"
  exclude-result-prefixes="xs math its dm xd" version="3.0">

  <xd:doc scope="stylesheet">
    <xd:desc>
      <xd:p><xd:b>Created on:</xd:b> Oct 3, 2025</xd:p>
      <xd:p><xd:b>Author:</xd:b> Frank Steimke, Bremen</xd:p>
      <xd:p>Basic Migration steps of DocBook 5.x with XSL 1.0 Stylesheets to DocBook 5.2 and xslTNG
        Stylesheets for <xd:i>"SUSE Linux Enterprise Desktop (SLED) 15 SP7"</xd:i> Books and
        Articles</xd:p>
      <xd:p><xd:b>Input: </xd:b>DocBook Source file from <xd:a
          href="https://github.com/SUSE/doc-sle">Official SUSE Linux Enterprise Documentation
          Repository</xd:a>. The main file is <xd:i>MAIN.SLEDS.xml</xd:i>, a DocBook
          <xd:i>set</xd:i>. The file is <xd:i>not valid</xd:i> because it contains repeated
        fragements distinguished by effectivity / profiling attributes <xd:i>@os, @arch</xd:i> and
          <xd:i>@condition</xd:i>.</xd:p>
      <xd:p>
        <xd:b>Output: </xd:b>DocBook source file, valid with respect to DocBook 5.2, profiled with
        the <xd:i>effectitvity and profiling parameters</xd:i>, optimized for xslTNG
        Stylesheets.</xd:p>
    </xd:desc>
  </xd:doc>

  <xsl:mode on-no-match="shallow-copy"/>

  <xsl:strip-space elements="*"/>

  <xsl:param name="docbook-version">5.2</xsl:param>

  <xd:doc>
    <xd:desc>
      <xd:p>Change DocBook version Attribute value to <xd:ref name="docbook-version"
          type="parameter"/>.</xd:p>
    </xd:desc>
  </xd:doc>
  <xsl:template match="@version" as="attribute(version)">
    <xsl:attribute name="version" select="$docbook-version"/>
  </xsl:template>

  <!-- Images ================================================================================= -->

  <xd:doc>
    <xd:desc>
      <xd:p>Change <xd:i>imageobject/@role</xd:i> (which is <xd:i>fo</xd:i> or <xd:i>html</xd:i>) to
          <xd:i>@outputformat</xd:i>.</xd:p>
      <xd:p>Applicable values are <xd:i>print</xd:i> and <xd:i>screen</xd:i> (for the latter see the
        default value in <xd:i>params.xsl</xd:i></xd:p>
    </xd:desc>
  </xd:doc>
  <xsl:template match="imageobject[@role = ('fo', 'html')]" as="element(imageobject)">
    <xsl:copy copy-namespaces="no">
      <xsl:choose>
        <xsl:when test="@role eq 'fo'">
          <xsl:attribute name="outputformat" select="'print'"/>
        </xsl:when>
        <xsl:otherwise>
          <xsl:attribute name="outputformat" select="'screen'"/>
        </xsl:otherwise>
      </xsl:choose>
      <xsl:apply-templates select="@* except @role, *"/>
    </xsl:copy>
  </xsl:template>

  <xsl:template match="@fileref" as="attribute(fileref)">
    <xsl:attribute name="fileref" select="'media/' || ."/>
  </xsl:template>

 

</xsl:stylesheet>
