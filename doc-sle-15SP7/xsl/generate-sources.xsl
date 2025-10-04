<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns="http://docbook.org/ns/docbook"
  xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:xs="http://www.w3.org/2001/XMLSchema"
  xmlns:its="http://www.w3.org/2005/11/its" xmlns:dm="urn:x-suse:ns:docmanager"
  xmlns:xi="http://www.w3.org/2001/XInclude" xmlns:xlink="http://www.w3.org/1999/xlink"
  xmlns:err="http://www.w3.org/2005/xqt-errors"
  xmlns:math="http://www.w3.org/2005/xpath-functions/math"
  xmlns:xd="http://www.oxygenxml.com/ns/doc/xsl"
  xpath-default-namespace="http://docbook.org/ns/docbook" exclude-result-prefixes="xs math its xd"
  version="3.0">

  <xd:doc scope="stylesheet">
    <xd:desc>
      <xd:p><xd:b>Created on:</xd:b> Oct 3, 2025</xd:p>
      <xd:p><xd:b>Author:</xd:b> Frank.Steimke</xd:p>
      <xd:p>Erstellt aus dem Original DocBook Sources von SUSE die Sources mit denen ich arbeiten
        werde.</xd:p>
    </xd:desc>
  </xd:doc>

  <xsl:mode on-no-match="shallow-copy"/>

  <xsl:strip-space elements="*"/>
  <xsl:output method="xml" indent="yes"
    suppress-indentation="address literallayout programlisting programlistingco screen screenco screenshot synopsis"/>

  <xsl:param name="profile-os">sled</xsl:param>
  <xsl:param name="profile-arch">x86_64;zseries;power;aarch64</xsl:param>
  <xsl:param name="profile-condition">suse-product</xsl:param>

  <!-- remove SUSE specific Elements and attributes ========================================== -->

  <xsl:template match="dm:* | its:* | @dm:* | @its:*"/>

  <!-- effectivity attributes and profiling =================================================== -->

  <xsl:template match="*[@os | @arch | @condition]" as="element()?" priority="10">
    <xsl:variable name="os" as="xs:boolean" select="
        if (@os) then
          tokenize(@os, ';') = tokenize($profile-os, ';')
        else
          true()"/>
    <xsl:variable name="arch" as="xs:boolean" select="
        if (@arch) then
          tokenize(@arch, ';') = tokenize($profile-arch, ';')
        else
          true()"/>
    <xsl:variable name="condition" as="xs:boolean" select="
        if (@condition) then
          tokenize(@condition, ';') = tokenize($profile-condition, ';')
        else
          true()"/>
    <xsl:if test="$os and $arch and $condition">
      <xsl:next-match/>
    </xsl:if>
  </xsl:template>

  <!-- text() Normalisierung ================================================================== -->

  <xd:doc>
    <xd:desc>
      <xd:p>copy text nodes in linespecific elements (see 3.6.4. Line-specific environments)</xd:p>
    </xd:desc>
  </xd:doc>
  <xsl:template match="
      address//text()
      | literallayout//text()
      | programlisting//text() | programlistingco//text()
      | screen/text() | screenco//text()
      | screenshot//text()
      | synopsis//text()" as="text()" priority="10">
    <xsl:copy/>
  </xsl:template>

  <xd:doc>
    <xd:desc>
      <xd:p>Normalize text that is not in a linespecific element</xd:p>
    </xd:desc>
  </xd:doc>
  <xsl:template match="text()" as="text()">
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
