<?xml version="1.0" encoding="UTF-8"?>
<p:declare-step
	xmlns:c="http://www.w3.org/ns/xproc-step"
    xmlns:err="http://www.w3.org/ns/xproc-error"
    xmlns:gt="urn:uuid:dcebd429-ed94-465a-a0a0-66e47def2454"
    xmlns:p="http://www.w3.org/ns/xproc"
    name="generate-uuid"
    type="gt:generate-uuid"
    version="3.1">
    
    <p:documentation>This step produces a c:result document containing a newly generated UUID.
    </p:documentation>
    
    <p:output
        port="result"
        primary="true"
        content-types="application/xml">
    </p:output>

    <p:uuid
        name="generate-uuid"
        message="Generate new UUID"
        match="/c:result/text()">
        <p:with-input port="source">
            <!-- The c:result element in the document below must be non-empty as the selection pattern needs a text node to match.
            This step replaces the Nil UUID value in the document below with a newly generated UUID. -->
            <p:inline>
                <c:result>00000000-0000-0000-0000-000000000000</c:result>
            </p:inline>
        </p:with-input>
    </p:uuid>
    
</p:declare-step>