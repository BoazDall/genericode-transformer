<?xml version="1.0" encoding="UTF-8"?>
<p:declare-step
    xmlns:gc="http://docs.oasis-open.org/codelist/ns/genericode/1.0/"
    xmlns:c="http://www.w3.org/ns/xproc-step"
    xmlns:err="http://www.w3.org/ns/xproc-error"
    xmlns:gt="urn:uuid:dcebd429-ed94-465a-a0a0-66e47def2454"
    xmlns:p="http://www.w3.org/ns/xproc"
    xmlns:xsd="http://www.w3.org/2001/XMLSchema"
    name="create-first-code-list-version"
    version="3.1">

    <p:documentation>This step creates the first version of a code list, intended as the starting point for further editing.
        New UUIDs for the code list and the first version are generated.
    </p:documentation>

    <p:import href="generate-uuid.xpl" />

    <p:option
        name="gc-file-directory"
        as="xsd:string"
        required="true" />

    <p:option
        name="code-list-short-name"
        as="xsd:string"
        required="true" />

    <p:option
        name="code-list-version-number"
        as="xsd:string"
        required="false"
        select="'1.0.0'" />

    <p:option
        name="debug"
        as="xsd:boolean"
        select="false()"
        static="true" />

    <p:variable
        name="gc-file-directory-urified"
        select="p:urify($gc-file-directory)" />

    <gt:generate-uuid
        name="generate-uuid-code-list"
        p:message="Generate new UUID for code list" />

    <p:variable
        name="code-list-uuid"
        select="/c:result/text()" />

    <gt:generate-uuid
        name="generate-uuid-code-list-version"
        p:message="Generate new UUID for code list version" />

    <p:variable
        name="code-list-version-uuid"
        select="/c:result/text()" />

    <p:xslt
        name="transform-code-list-version"
        message="Create first version {$code-list-version-number} of code list {$code-list-short-name} with code list version UUID {$code-list-version-uuid} and code list UUID {$code-list-uuid}"
        version="3.0">
        <p:with-input port="source">
            <p:empty />
        </p:with-input>
        <p:with-input
            port="stylesheet"
            href="../xslt/create-first-code-list-version.xsl" />
        <p:with-option
            name="template-name"
            select="QName('http://www.w3.org/1999/XSL/Transform', 'initial-template')" />
        <p:with-option
            name="parameters"
            select="map {'codeListShortName'     : $code-list-short-name,
                         'codeListVersionNumber' : $code-list-version-number,
                         'codeListUuid'          : $code-list-uuid,
                         'codeListVersionUuid'   : $code-list-version-uuid }" />
    </p:xslt>

    <p:variable
        name="gc-file-path"
        select="$gc-file-directory-urified || '/v' || $code-list-version-number || '.' || $code-list-short-name || '.gc'" />

    <p:store
        name="store-gc-file"
        message="Store {$gc-file-path}"
        href="{$gc-file-path}" />

</p:declare-step>