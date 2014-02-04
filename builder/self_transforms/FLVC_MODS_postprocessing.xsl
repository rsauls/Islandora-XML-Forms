<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="1.0" xmlns="http://www.loc.gov/mods/v3"
    xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
    xmlns:mods="http://www.loc.gov/mods/v3"
    xmlns:flvc="info:flvc/manifest/v1"
    xmlns:marc="http://www.loc.gov/MARC21/slim"
    xmlns:dc="http://purl.org/dc/elements/1.1/"
    xmlns:dcterms="http://purl.org/dc/terms/"
    exclude-result-prefixes="mods dc marc">


    <!-- FLVC cleanup_mods.xsl
         removes empty attributes, empty elements, and elements containing only attributes
         from MODS XML generated by Form Builder
         3.0 (July 26, 2013) - edited PURL addition to check for <extension>
         2.0 (July 3rd, 2013) - edited to add PURL to MODS after "save"
         1.0 (June 7, 2013) - Caitlin Nelson -->

    <xsl:output method="xml" version="1.0" encoding="UTF-8" indent="yes" media-type="text/xml"/>
    <xsl:strip-space elements="*"/>
    
    <xsl:variable name="smallcase" select="'abcdefghijklmnopqrstuvwxyz'" />
    <xsl:variable name="uppercase" select="'ABCDEFGHIJKLMNOPQRSTUVWXYZ'" />
    
    <xsl:template match="node()|@*">
        <xsl:copy>
            <xsl:apply-templates select="node()[normalize-space()]|@*[normalize-space()]"/>
        </xsl:copy>
    </xsl:template>

    <xsl:template match="mods:mods">
        <mods:mods xmlns:mods="http://www.loc.gov/mods/v3" xmlns="http://www.loc.gov/mods/v3"
            xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
            xmlns:xlink="http://www.w3.org/1999/xlink"
            xsi:schemaLocation="http://www.loc.gov/mods/v3 http://www.loc.gov/standards/mods/v3/mods-3-4.xsd"
            xmlns:flvc="info:flvc/manifest/v1">
            <xsl:apply-templates select="node()[normalize-space()]|@*[normalize-space()]"/>
            <xsl:call-template name="newPurl"/>
            <xsl:call-template name="typeOfResource_DTconversion"/>
        </mods:mods>
    </xsl:template>

    <xsl:template
        match="*[not(node())] | *[not(node()[2]) and node()/self::text() and not(normalize-space())]"/>

    <xsl:template name="newPurl">
        <xsl:choose>
            <xsl:when test="//mods:location[@displayLabel='purl']"/>
            <xsl:otherwise>
                <xsl:choose>
                    <xsl:when test="mods:extension/flvc:flvc/flvc:owningInstitution">
                        <location displayLabel="purl">
                            <url>
                                <xsl:text>http://purl.flvc.org/</xsl:text>
                                <xsl:value-of
                                    select="translate(mods:extension/flvc:flvc/flvc:owningInstitution, $uppercase, $smallcase)"/>
                                <xsl:text>/fd/</xsl:text>
                                <xsl:value-of select="mods:identifier[@type='IID']"/>
                            </url>
                        </location>
                    </xsl:when>
                    <xsl:otherwise>
                        <location displayLabel="purl">
                            <url>
                                <xsl:text>http://purl.flvc.org/</xsl:text>
                                <xsl:value-of select="translate((document('info.xml')/root/owner_inst), $uppercase, $smallcase)"/>
                                <xsl:text>/fd/</xsl:text>
                                <xsl:value-of select="mods:identifier[@type='IID']"/>
                            </url>
                        </location>
                    </xsl:otherwise>
                </xsl:choose>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:template>
    
    <xsl:template name="typeOfResource_DTconversion">
        <xsl:choose>
            <xsl:when test="//mods:typeOfResource" />
            <xsl:otherwise>
                <xsl:if test="document('info.xml')/root/typeOfResource">
                    <typeOfResource>
                        <xsl:value-of select="document('info.xml')/root/typeOfResource"/>
                    </typeOfResource>
                </xsl:if>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:template>
    
</xsl:stylesheet>