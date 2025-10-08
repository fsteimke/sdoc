<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns="http://docbook.org/ns/docbook"
  xmlns:f="http://docbook.org/ns/docbook/function" xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
  xmlns:xs="http://www.w3.org/2001/XMLSchema" xmlns:its="http://www.w3.org/2005/11/its"
  xmlns:dm="urn:x-suse:ns:docmanager" xmlns:xi="http://www.w3.org/2001/XInclude"
  xmlns:xlink="http://www.w3.org/1999/xlink" xmlns:err="http://www.w3.org/2005/xqt-errors"
  xmlns:math="http://www.w3.org/2005/xpath-functions/math"
  xmlns:xd="http://www.oxygenxml.com/ns/doc/xsl"
  xpath-default-namespace="http://docbook.org/ns/docbook"
  exclude-result-prefixes="xs math its dm xd err f" version="3.0">

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

  <xsl:key name="k_id" match="*" use="@xml:id"/>

  <xd:doc>
    <xd:desc>
      <xd:p>The element where $xref points to</xd:p>
    </xd:desc>
    <xd:param name="xref">a cross reference</xd:param>
    <xd:return>the crossref target element</xd:return>
  </xd:doc>
  <xsl:function name="f:xref-target" as="element()?">
    <xsl:param name="xref" as="element(xref)"/>
    <xsl:variable name="refid" as="xs:string" select="
        if ($xref/@linkend) then
          $xref/@linkend
        else
          substring-after($xref/@xlink:href, '#')"/>
    
    <xsl:sequence select="key('k_id', $refid, root($xref))"/>
  </xsl:function>

  <!-- DocBook @version ======================================================================= -->
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

  <xd:doc>
    <xd:desc>
      <xd:p>Generated sources expect images in the media directory</xd:p>
    </xd:desc>
  </xd:doc>
  <xsl:template match="@fileref" as="attribute(fileref)">
    <xsl:attribute name="fileref" select="'media/' || ."/>
  </xsl:template>


  <!-- File layout and @xml:base ============================================================== -->
  <xd:doc>
    <xd:desc>
      <xd:p>Remove @xml:base Attribute. If it indicates a new file, add a PI:</xd:p>
      <xd:ul>
        <xd:li><xd:b>file: </xd:b>If it represents a file which will be written and included</xd:li>
        <xd:li><xd:b>include: </xd:b>If it represents a file which will only be included, since it
          was already written before (re-used content e. g. "Documentation conventions")</xd:li>
      </xd:ul>
    </xd:desc>
  </xd:doc>
  <xsl:template match="*[@xml:base]" as="node()+">
    <xsl:variable name="base" as="xs:string" select="tokenize(@xml:base, '/')[last()]"/>
    <xsl:variable name="instruction" as="xs:string?">
      <xsl:choose>
        <xsl:when test="exists(preceding::*[tokenize(@xml:base, '/')[last()] eq $base])">
          <xsl:sequence select="'include'"/>
        </xsl:when>
        <xsl:when test="not($base eq tokenize(parent::*/@xml:base, '/')[last()])">
          <xsl:sequence select="'file'"/>
        </xsl:when>
      </xsl:choose>
    </xsl:variable>
    <xsl:copy copy-namespaces="no">
      <xsl:apply-templates select="@* except @xml:base"/>
      <xsl:if test="$instruction">
        <xsl:processing-instruction name="{$instruction}" select="tokenize(@xml:base, '/')[last()]"/>
      </xsl:if>
      <xsl:apply-templates select="node()"/>
    </xsl:copy>
  </xsl:template>

  <!-- xref to co ============================================================================= -->

  <xd:doc>
    <xd:desc>
      <xd:p>SUSE DocBook sometimes uses xref to indicate that the callout appears semantically in
        more than one place. <xd:a href="https://tdg.docbook.org/tdg/5.2/coref"><xd:i>"Use one co
            and one or more coref elements when you want to indicate that the same callout should
            appear in several places."</xd:i></xd:a></xd:p>
    </xd:desc>
  </xd:doc>
  <xsl:template match="screen/xref[f:xref-target(.)/self::co]" as="element(coref)" priority="10">
    <coref linkend="{f:xref-target(.)/@xml:id}"/>
  </xsl:template>
  
  <!-- Hack to manage cross reference from one book to a different book ======================= -->
  <xsl:template match="book//xref" as="item()+" xmlns:l="http://docbook.org/ns/docbook/l10n">
    <xsl:variable name="lang" as="xs:string" select="((ancestor::*/@xml:lang)[last()], 'en')[1]"/>
    <xsl:variable name="local-href" select="'https://xsltng.docbook.org/locale/' || $lang || '.xml'"/>
    <xsl:variable name="locale" select="
      if (doc-available($local-href)) then
      doc($local-href)
      else
      ()"/>
    <xsl:variable name="my-document" as="element()" select="(ancestor::book | ancestor::article)[1]"/>
    <xsl:variable name="idref" as="xs:string" select="
      if (@xlink:href) then
      substring-after(@xlink:href, '#')
      else
      @linkend"/>
    <xsl:variable name="target" as="element()?" select="root()//*[@xml:id eq $idref]"/>
    <xsl:variable name="target-document" as="element(book)?" select="$target/ancestor::*[local-name() eq local-name($my-document)]"/>
    <xsl:if test="not($locale)">
      <xsl:message select="'Warning: no locale found for ' || $local-href"/>
    </xsl:if>
    <xsl:choose>
      <xsl:when test="exists($target-document) and not($target-document is $my-document)">
        <!-- cross reference to a different book or article -->
        <xsl:variable name="title" as="xs:string"
          select="normalize-space($target-document/info/title)"/>
        <xsl:variable name="token" as="element()?"
          select="($locale//l:token[@key eq local-name($target-document)])[1]"/>
        <phrase role='document-xref'>
          <xsl:if test="$token">
            <xsl:value-of select="$token || ' '"/>
          </xsl:if>
          <quote>
            <xsl:sequence select="$title"/>
          </quote>
          <xsl:text>, </xsl:text>
        </phrase>
        <xsl:copy>
          <xsl:copy-of select="@xlink:href | @linkend"/>
          <xsl:attribute name="xrefstyle">%label &quot;%c&quot;</xsl:attribute>
        </xsl:copy>
      </xsl:when>
      <xsl:otherwise>
        <!-- regular cross reference -->
        <xsl:copy>
          <xsl:apply-templates select="@*, node()"/>
        </xsl:copy>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:template>
  
  <!-- Modifikation xref/@xrefstyle =========================================================== -->
  <xsl:template match="@xrefstyle" as="attribute(xrefstyle)?">
    <xsl:variable name="style" as="xs:string" select="normalize-space()"/>
    <xsl:attribute name="xrefstyle">
      <xsl:choose>
        <xsl:when test="$style = ('select:title', 'select:title nopage')">
          <xsl:sequence select="'%c'"/>
        </xsl:when>
        <xsl:when test="$style = ('select:label', 'select:label nopage', 'select:label number')">
          <xsl:sequence select="'%label'"/>
        </xsl:when>
        <xsl:when test="$style eq 'select:label quotedtitle nopage'">
          <xsl:sequence select="'%label &amp;%c&amp;'"/>
        </xsl:when>
        <xsl:when test="$style eq 'select:label title nopage'">
          <xsl:sequence select="'%label %c'"/>
        </xsl:when>
        <xsl:when test="$style eq 'HeadingOnPaqge'">
          <xsl:sequence select="'%label, &amp;%c&amp;'"/>
        </xsl:when>
        <xsl:otherwise>
          <xsl:if test="not(starts-with($style, '%'))">
            <xsl:message select="'Warning: unknown @xrefstyle ' || $style"/>
          </xsl:if>
          <xsl:sequence select="$style"/>
        </xsl:otherwise>
      </xsl:choose>
    </xsl:attribute>
  </xsl:template>
  

</xsl:stylesheet>
