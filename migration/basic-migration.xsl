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

  <xsl:param name="docbook-version">5.2</xsl:param>

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
  <xsl:template match="para | info | phrase | productname | textobject">
    <xsl:where-populated>
      <xsl:copy>
        <xsl:apply-templates select="@*, node()"/>
      </xsl:copy>
    </xsl:where-populated>
  </xsl:template>

  <xd:doc>
    <xd:desc>
      <xd:p>Change DocBook version Attribute</xd:p>
    </xd:desc>
  </xd:doc>
  <xsl:template match="@version" as="attribute(version)">
    <xsl:attribute name="version" select="$docbook-version"/>
  </xsl:template>

  <xd:doc>
    <xd:desc>
      <xd:p>Remove @xml:base Attribute. If it indicates a new file, add a PI:</xd:p>
      <xd:ul>
        <xd:li><xd:b>file: </xd:b>If it represents a file which will be written and included</xd:li>
        <xd:li><xd:b>include: </xd:b>If it represents a file which will only be included, since it
          war already written before</xd:li>
      </xd:ul>
    </xd:desc>
  </xd:doc>
  <xsl:template match="*[@xml:base ne parent::*/@xml:base]" as="node()+">
    <xsl:variable name="base" as="xs:string" select="tokenize(@xml:base, '/')[last()]"/>
    <xsl:variable name="instruction" as="xs:string" select="
        if (exists(preceding::*[tokenize(@xml:base, '/') eq $base])) then
          'include'
        else
          'file'"/>
    <xsl:copy copy-namespaces="no">
      <xsl:apply-templates select="@* except @xml:base"/>
      <xsl:processing-instruction name="{$instruction}" select="tokenize(@xml:base, '/')[last()]"/>
      <xsl:apply-templates select="node()"/>
    </xsl:copy>
  </xsl:template>

  <!-- Images ================================================================================= -->

  <xd:doc>
    <xd:desc>
      <xd:p>Change imamgeobject/@role to @outputformat. See Table 2.1 Common DocBook effectivity
        attributes in xslTNG Reference</xd:p>
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

  <!-- text() Normalization =================================================================== -->

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
    <xsl:copy copy-namespaces="no"/>
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
