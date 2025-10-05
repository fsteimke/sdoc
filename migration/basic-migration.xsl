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

  <!-- effectitvity and profiling parameters ================================================== -->
  <xsl:param name="profile-os">sled</xsl:param>
  <xsl:param name="profile-arch">x86_64;zseries;power;aarch64</xsl:param>
  <xsl:param name="profile-condition">suse-product</xsl:param>

  <!-- Misc. Parameters ======================================================================= -->
  <xsl:param name="docbook-version">5.2</xsl:param>

  <xsl:param name="normalize-text" as="xs:boolean" static="yes" select="true()"/>

  <xd:doc>
    <xd:desc>
      <xd:p>remove SUSE specific Elements and attributes, comments and some PIs</xd:p>
    </xd:desc>
  </xd:doc>
  <xsl:template match="
      dm:* | its:* | @dm:* | @its:*
      | comment()
      | processing-instruction('xml-stylesheet')
      | processing-instruction('xml-model')
      | processing-instruction('dbhtml')
      | processing-instruction('filename')"/>

  <xd:doc>
    <xd:desc>
      <xd:p>Remove empty elements</xd:p>
    </xd:desc>
  </xd:doc>
  <xsl:template match="info | phrase | productname | textobject">
    <xsl:where-populated>
      <xsl:copy>
        <xsl:apply-templates select="@*, node()"/>
      </xsl:copy>
    </xsl:where-populated>
  </xsl:template>

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
      <xd:p> For applicable values <xd:i>print</xd:i> and <xd:i>online</xd:i> see Table 2.1 Common
        DocBook effectivity attributes in xslTNG Reference</xd:p>
    </xd:desc>
  </xd:doc>
  <xsl:template match="imageobject[@role = ('fo', 'html')]" as="element(imageobject)">
    <xsl:copy copy-namespaces="no">
      <xsl:choose>
        <xsl:when test="@role eq 'fo'">
          <xsl:attribute name="outputformat" select="'print'"/>
        </xsl:when>
        <xsl:otherwise>
          <xsl:attribute name="outputformat" select="'online'"/>
        </xsl:otherwise>
      </xsl:choose>
      <xsl:apply-templates select="@* except @role, *"/>
    </xsl:copy>
  </xsl:template>

  <xsl:template match="@fileref" as="attribute(fileref)">
    <xsl:attribute name="fileref" select="'media/' || ."/>
  </xsl:template>


  <!-- effectivity attributes and profiling =================================================== -->

  <xd:doc>
    <xd:desc>
      <xd:p>Check elements with <xd:b>effectivity attribute(s)</xd:b> against corresponding
        parameters</xd:p>
      <xd:p>SUSE uses <xd:i>@os, @arch</xd:i> and <xd:i>@condition</xd:i></xd:p>
    </xd:desc>
  </xd:doc>
  <xsl:template match="*[@os | @arch | @condition]" as="element()?" priority="10">
    <xsl:variable name="os" as="xs:boolean"
      select="tokenize(@os, ';') = tokenize($profile-os, ';') or not(@os)"/>
    <xsl:variable name="arch" as="xs:boolean"
      select="tokenize(@arch, ';') = tokenize($profile-arch, ';') or not(@arch)"/>
    <xsl:variable name="condition" as="xs:boolean"
      select="tokenize(@condition, ';') = tokenize($profile-condition, ';') or not(@condition)"/>
    <xsl:if test="$os and $arch and $condition">
      <xsl:copy copy-namespaces="no">
        <xsl:apply-templates select="@* except (@os | @arch | @condition), node()"/>
      </xsl:copy>
    </xsl:if>
  </xsl:template>

  <!-- text() Normalization when $text-normalization is true() ================================ -->

  <xd:doc>
    <xd:desc>
      <xd:p>copy text nodes in linespecific elements if <xd:ref name="normalize-text"
          type="parameter"/> is <xd:i>true()</xd:i>.</xd:p>
      <xd:p>See 3.6.4. Line-specific environments in DocBook 5.2 Reference Guide</xd:p>
    </xd:desc>
  </xd:doc>
  <xsl:template match="
      address//text()
      | literallayout//text()
      | programlisting//text() | programlistingco//text()
      | screen/text() | screenco//text()
      | screenshot//text()
      | synopsis//text()" as="text()" priority="10" use-when="$normalize-text">
    <xsl:copy copy-namespaces="no"/>
  </xsl:template>

  <xd:doc>
    <xd:desc>
      <xd:p>Normalize text that is not in a linespecific element if <xd:ref name="normalize-text"
          type="parameter"/> is <xd:i>true()</xd:i>.</xd:p>
    </xd:desc>
  </xd:doc>
  <xsl:template match="text()" as="text()" use-when="$normalize-text">
    <xsl:variable name="space" as="xs:string" select="'&#x20;'"/>
    <xsl:variable name="content" as="xs:string*">
      <xsl:if test="exists(preceding-sibling::node()) and matches(., '^\s')">
        <xsl:sequence select="$space"/>
      </xsl:if>
      <xsl:sequence select="normalize-space()"/>
      <xsl:if test="exists(following-sibling::node()) and matches(., '\s$')">
        <xsl:sequence select="$space"/>
      </xsl:if>
    </xsl:variable>
    <xsl:value-of select="string-join($content)"/>
  </xsl:template>

</xsl:stylesheet>
