<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns="http://docbook.org/ns/docbook"
  xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:xs="http://www.w3.org/2001/XMLSchema"
  xmlns:xd="http://www.oxygenxml.com/ns/doc/xsl" exclude-result-prefixes="xs xd"
  xpath-default-namespace="http://docbook.org/ns/docbook" version="3.0">

  <xd:doc scope="stylesheet">
    <xd:desc>Normalize text nodes, except DocBook linespecific environment</xd:desc>
  </xd:doc>

  <xsl:mode on-no-match="shallow-copy"/>

  <xsl:strip-space elements="*"/>

  <xsl:param name="normalize-text" as="xs:boolean" static="yes" select="true()"/>

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
