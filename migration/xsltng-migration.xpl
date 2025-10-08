<?xml version="1.0" encoding="UTF-8"?>
<p:declare-step xmlns:p="http://www.w3.org/ns/xproc" xmlns:c="http://www.w3.org/ns/xproc-step"
  xmlns:db="http://docbook.org/ns/docbook" xmlns:xs="http://www.w3.org/2001/XMLSchema" version="3.0">

  <p:documentation xmlns="http://www.w3.org/1999/xhtml">
    <p>Migration steps of DocBook 5.x with XSL 1.0 Stylesheets to DocBook 5.2 and xslTNG Stylesheets
      for <em>"SUSE Linux Enterprise Desktop (SLED) 15 SP7"</em> Books and Articles</p>
  </p:documentation>

  <p:option name="project-dir" as="xs:string" select="'file:/c:/Users/Frank.Steimke/sdoc/'"/>

  <!-- Set variables -->
  <p:variable name="main-filename" as="xs:string" select="'MAIN.SLEDS.xml'"/>
  <p:variable name="original-dir" as="xs:string"
    select="string-join(($project-dir,'doc-sle-15SP7'),'/')"/>
  <p:variable name="main-input" as="xs:string"
    select="string-join(($original-dir,'xml',$main-filename),'/')"/>
  <p:variable name="output-dir" as="xs:string" select="string-join(($project-dir,'src'),'/')"/>
  <p:variable name="main-output" as="xs:string"
    select="string-join(($output-dir, $main-filename),'/')"/>
  <p:variable name="monolith-output" as="xs:string"
    select="let $bn:=tokenize($main-filename,'\.')[position() lt last()],
    $fn:=string-join(($bn, 'MONOLITH.xml'),'.')
    return string-join(($output-dir,$fn),'/')"/>
  <p:variable name="test-output" as="xs:string"
    select="let $bn:=tokenize($main-filename,'\.')[position() lt last()],
    $fn:=string-join(($bn, 'TEST.xml'),'.')
    return string-join(($output-dir,$fn),'/')"/>

  <!-- Serialization of generated XML source files: intended with exceptions for DocBook
       linespecific environment -->
  <p:variable name="suppress-indentation"
    select="let $e:='address literallayout programlisting programlistingco screen screenco screensho synopsis',
    $qe:= tokenize($e,'\s+') ! concat('Q{http://docbook.org/ns/docbook}',.)
    return string-join($qe, ' ')"/>
  <p:variable name="xml-format" select="map{
    'method':'xml',
    'indent':true(),
    'suppress-indentation':$suppress-indentation
    }"/>

  <p:group name="load-modular-docbook">
    <p:documentation xmlns="http://www.w3.org/1999/xhtml">
      <p>Input file is modular DocBook using <em>xi:include</em> mechanism. The <em>xml:base</em>
        attribute is important, because we want to retain the file structure for the generetad
        sources.</p>
    </p:documentation>
    <p:output port="result" primary="true"/>

    <p:load href="{$main-input}"/>
    <p:xinclude fixup-xml-base="{true()}"/>
  </p:group>

  <p:group name="prepare-for-migration">
    <p:output port="result" primary="true"/>

    <p:documentation xmlns="http://www.w3.org/1999/xhtml">
      <ol>
        <li><p>Correction of errors in the DocBook sources</p></li>
        <li><p>Check profiling parameters against effectivity attribute</p></li>
        <p><li>Remove empty elements and useless <em>phrase</em> elements, leftover from profiling</li></p>
        <li><p>Normalize text nodes, except within linespecific environment</p></li>
      </ol>
    </p:documentation>
    <p:xslt>
      <p:with-input port="stylesheet" href="corrections.xsl"/>
    </p:xslt>
    <p:xslt>
      <p:with-input port="stylesheet" href="profiling.xsl"/>
    </p:xslt>
    <p:xslt>
      <p:with-input port="stylesheet" href="cleanup-structure.xsl"/>
    </p:xslt>
    <p:xslt>
      <p:with-input port="stylesheet" href="normalize-text-nodes.xsl"/>
    </p:xslt>
  </p:group>

  <p:group name="migration-to-xsltng">
    <p:documentation xmlns="http://www.w3.org/1999/xhtml">
      <p>Change DocBook Sources to DocBook 5.2 optimized for xslTNG Stylesheets</p>
    </p:documentation>
    <p:output port="result" primary="true"/>

    <p:xslt>
      <p:documentation xmlns="http://www.w3.org/1999/xhtml">
        <p>Basic migration steps to prepare for xslTNG Stylesheets</p></p:documentation>
      <p:with-input port="stylesheet" href="basic-migration.xsl"/>
    </p:xslt>

  </p:group>

  <p:group name="store-monolith">
    <p:documentation xmlns="http://www.w3.org/1999/xhtml">
      <p>Stores the generadted source and an excerpt as single, non-modular DocBook documents</p>
      <p>For test and comparison purpose, not necessary for production</p>
    </p:documentation>
    <p:output port="result" primary="true"/>

    <p:store href="{$monolith-output}">
      <p:documentation xmlns="http://www.w3.org/1999/xhtml">
        <p>Store the whole Document in a single, huge file</p>
      </p:documentation>
      <p:with-option name="serialization" select="$xml-format"/>
    </p:store>

    <p:group name="testfile">
      <p:documentation xmlns="http://www.w3.org/1999/xhtml">
        <p>Generate an excerpt with a few small books for testing purposes (since it takes more than
          20 minutes to render the complete document to PDF with my machine).</p>
        <ul>
          <li><p>Delete all books but two</p></li>
          <li><p>Delete all parts but the first</p></li>
        </ul>
        <p>Time to render this excerpt (which has lots of unresolved cross references) with about
          350 pages in PDF and HTML with xslTNG within my framework on my machine: about 2
          minutes</p>
      </p:documentation>
      <p:delete match="db:book[not(@xml:id = ('book-administration', 'book-virtualization'))]"/>
      <p:delete match="db:part[exists(preceding-sibling::db:part)]"/>
      <p:store href="{$test-output}">
        <p:with-option name="serialization" select="$xml-format"/>
      </p:store>
    </p:group>
  </p:group>

  <p:group name="store-modular-files">
    <p:documentation xmlns="http://www.w3.org/1999/xhtml">
      <p>Write modular DocBook files to disk.</p>
      <p>The root file on <em>primary</em> port, and every file from the <em>secondary</em> port of
        preceding step</p>
    </p:documentation>

    <p:xslt name="prepare-storing">
      <p:documentation xmlns="http://www.w3.org/1999/xhtml">
        <p>Prepare for modular DocBook whit the original file structure.</p>
        <p>Write file content to the <em>secondary</em> port, and generate <em>xi:incluce</em>
          Elements</p>
      </p:documentation>
      <p:with-input port="source" pipe="result@migration-to-xsltng"/>
      <p:with-input port="stylesheet" href="store-files.xsl"/>
      <p:with-option name="parameters" select="map{'output-directory':$output-dir}"/>
    </p:xslt>

    <p:store href="{$main-output}">
      <p:with-option name="serialization" select="$xml-format"/>
    </p:store>

    <p:for-each>
      <p:with-input select="/">
        <p:pipe port="secondary" step="prepare-storing"/>
      </p:with-input>
      <p:store href="{base-uri(.)}">
        <p:with-option name="serialization" select="$xml-format"/>
      </p:store>
    </p:for-each>
  </p:group>

  <p:for-each name="copy-images">
    <p:documentation xmlns="http://www.w3.org/1999/xhtml">
      <p>Try to copy image files to the place where the generated sources expect them</p>
    </p:documentation>
    <p:with-input select="//db:imagedata">
      <p:pipe step="migration-to-xsltng" port="result"/>
    </p:with-input>
    <p:variable name="fileref" as="xs:string" select="/db:imagedata/@fileref"/>
    <p:variable name="basename" as="xs:string" select="tokenize($fileref,'/')[last()]"/>
    <p:variable name="type" select="tokenize($fileref,'\.')[last()]"/>
    <p:variable name="source"
      select="string-join(($original-dir,'images/src',$type,$basename),'/')"/>
    <p:variable name="dest" as="xs:string"
      select="string-join(($output-dir,$fileref),'/')"/>
    <p:try>
      <p:file-copy href="{$source}" target="{$dest}"/>
      <p:catch>
        <p:identity message="Missing {$fileref}"/>
      </p:catch>
    </p:try>
  </p:for-each>

</p:declare-step>
