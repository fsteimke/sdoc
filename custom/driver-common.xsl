<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns="http://docbook.org/ns/docbook"
  xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:h="http://www.w3.org/1999/xhtml"
  xmlns:xi="http://www.w3.org/2001/XInclude" xmlns:db="http://docbook.org/ns/docbook"
  xmlns:m="http://docbook.org/ns/docbook/modes" xmlns:v="http://docbook.org/ns/docbook/variables"
  xmlns:mp="http://docbook.org/ns/docbook/modes/private" xmlns:xs="http://www.w3.org/2001/XMLSchema"
  xmlns:math="http://www.w3.org/2005/xpath-functions/math"
  xpath-default-namespace="http://docbook.org/ns/docbook" exclude-result-prefixes="#all"
  version="3.0">

  <!-- Gemeinsamer Bestandteil der Treiber für pdf, chunk und office -->

  <!-- controlling numeration -->
  <xsl:param name="section-numbers" select="true()"/>
  <xsl:param name="section-toc-depth" select="2"/>

  <!-- restart number for co  -->
  <xsl:template match="db:co" mode="m:callout-bug">
    <xsl:variable name="conum">
      <xsl:variable name="from" as="element()">
        <xsl:choose>
          <xsl:when test="ancestor::db:screen">
            <xsl:sequence select="ancestor::db:screen"/>
          </xsl:when>
          <xsl:when test="ancestor::db:screenco">
            <xsl:sequence select="ancestor::db:screenco"/>
          </xsl:when>
          <xsl:when test="ancestor::programlisting">
            <xsl:sequence select="ancestor::db:programlisting"/>
          </xsl:when>
          <xsl:when test="ancestor::programlistingco">
            <xsl:sequence select="ancestor::db:programlistingco"/>
          </xsl:when>
          <xsl:when test="ancestor::db:section">
            <xsl:sequence select="(ancestor::db:section)[last()]"/>
          </xsl:when>
          <xsl:when test="ancestor::db:sect6">
            <xsl:sequence select="ancestor::db:sect6"/>
          </xsl:when>
          <xsl:when test="ancestor::db:sect5">
            <xsl:sequence select="ancestor::db:sect5"/>
          </xsl:when>
          <xsl:when test="ancestor::db:sect4">
            <xsl:sequence select="ancestor::db:sect4"/>
          </xsl:when>
          <xsl:when test="ancestor::db:sect3">
            <xsl:sequence select="ancestor::db:sect3"/>
          </xsl:when>
          <xsl:when test="ancestor::db:sect2">
            <xsl:sequence select="ancestor::db:sect2"/>
          </xsl:when>
          <xsl:when test="ancestor::db:sect1">
            <xsl:sequence select="ancestor::db:sect1"/>
          </xsl:when>
          <xsl:when test="ancestor::db:preface">
            <xsl:sequence select="ancestor::db:preface"/>
          </xsl:when>
          <xsl:when test="ancestor::db:appendix">
            <xsl:sequence select="ancestor::db:appendix"/>
          </xsl:when>
          <xsl:otherwise>
            <xsl:sequence select="root()"/>
          </xsl:otherwise>
        </xsl:choose>
      </xsl:variable>
      <xsl:choose>
        <xsl:when test="@label and @label castable as xs:decimal">
          <xsl:sequence select="@label"/>
        </xsl:when>
        <xsl:otherwise>
          <xsl:number count="db:co" level="single" from="$from" format="1"/>
        </xsl:otherwise>
      </xsl:choose>
    </xsl:variable>
    <xsl:value-of select="codepoints-to-string($callout-unicode-start + xs:integer($conum))"/>
  </xsl:template>

  <!-- Admonition Symbols -->
  <xsl:variable name="v:admonition-icons">
    <important>
      <mediaobject><imageobject><imagedata fileref='../src/icon/icon-important.svg'/></imageobject></mediaobject>
    </important>
    <warning>
      <mediaobject><imageobject><imagedata fileref='../src/icon/icon-warning.svg'/></imageobject></mediaobject>
    </warning>
    <note>
      <mediaobject><imageobject><imagedata fileref='../src/icon/icon-note.svg'/></imageobject></mediaobject>
    </note>
    <tip>
      <mediaobject><imageobject><imagedata fileref='../src/icon/icon-tip.svg'/></imageobject></mediaobject>
    </tip>

    <caution>
      <mediaobject><imageobject><imagedata fileref='../src/icon/icon-caution.svg'/></imageobject></mediaobject>
    </caution>
  </xsl:variable>

</xsl:stylesheet>
