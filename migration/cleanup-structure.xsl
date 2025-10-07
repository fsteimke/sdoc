<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns="http://docbook.org/ns/docbook"
  xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:xs="http://www.w3.org/2001/XMLSchema"
  xmlns:its="http://www.w3.org/2005/11/its" xmlns:dm="urn:x-suse:ns:docmanager"
  xmlns:xd="http://www.oxygenxml.com/ns/doc/xsl" exclude-result-prefixes="xs xd its dm"
  xpath-default-namespace="http://docbook.org/ns/docbook" version="3.0">

  <xsl:mode on-no-match="shallow-copy"/>
  
  <xd:doc>
    <xd:desc>
      <xd:p>remove SUSE specific Elements and attributes, comments and some PIs</xd:p>
    </xd:desc>
  </xd:doc>
  <xsl:template match="
    dm:* | its:* | @dm:* | @its:*
    | processing-instruction('xml-stylesheet')
    | processing-instruction('xml-model')
    | processing-instruction('dbhtml')
    | processing-instruction('filename')" priority="10"/>

  <xsl:template match="phrase[not(@*)]" as="node()*" priority="10">
    <xsl:apply-templates select="node()"/>
  </xsl:template>
  
  <!-- Don't delete empty entry element -->
  <xsl:template match="entry" as="element(entry)" priority="10">
    <xsl:copy>
      <xsl:apply-templates select="@*, node()"/>
    </xsl:copy>
  </xsl:template>

  <xsl:template match="*" as="element()*">
    <xsl:variable name="attributes" as="attribute()*">
      <xsl:apply-templates select="@*"/>
    </xsl:variable>
    <xsl:variable name="nodes" as="node()*">
      <xsl:apply-templates select="node()"/>
    </xsl:variable>

    <xsl:if test="exists($attributes) or exists($nodes)">
      <xsl:copy>
        <xsl:sequence select="$attributes, $nodes"/>
      </xsl:copy>
    </xsl:if>
  </xsl:template>

</xsl:stylesheet>
