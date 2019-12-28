<?xml version="1.0" encoding="utf-8"?>

<!--
    MakeBS is a build system for UNIX development environments.
    Copyright 2019 Bogdan Barbu

    This file is part of MakeBS.

    MakeBS is free software: you can redistribute it and/or modify
    it under the terms of the GNU General Public License as published by
    the Free Software Foundation, either version 3 of the License, or
    (at your option) any later version.

    MakeBS is distributed in the hope that it will be useful,
    but WITHOUT ANY WARRANTY; without even the implied warranty of
    MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
    GNU General Public License for more details.

    You should have received a copy of the GNU General Public License
    along with MakeBS.  If not, see <https://www.gnu.org/licenses/>.
-->

<xsl:stylesheet version="2.0"
    xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:xs="http://www.w3.org/2001/XMLSchema"
    xmlns:xi="http://www.w3.org/2001/XInclude"
    exclude-result-prefixes="xs">
    <xsl:output method="text" encoding="utf-8"/>

    <xsl:param name="path" as="xs:string" required="yes"/>
    <xsl:param name="docext" as="xs:integer" required="yes"/>

    <xsl:template match="/">
        <xsl:variable name="base" select="replace(base-uri(.), '^(.*/)[^/]+$', '$1')"/>
        <xsl:variable name="source" select="substring-after(base-uri(.), $base)"/>
        <xsl:variable name="destination" select="concat(substring-before($source, '.'), '.', $docext)"/>
        <xsl:value-of select="concat($path, '/', $destination, ': ', substring-after(base-uri(.), 'file:'))"/>
        <xsl:apply-templates select="/" mode="process-xincludes">
            <xsl:with-param name="base" select="$base"/>
        </xsl:apply-templates>
    </xsl:template>

    <xsl:template match="/" mode="process-xincludes">
        <xsl:param name="base" as="xs:string" required="yes"/>

        <xsl:variable name="dependents" as="xs:string*">
            <xsl:for-each select=".//xi:include">
                <xsl:variable name="doc" select="resolve-uri(@href, base-uri(.))"/>
                <xsl:variable name="file" select="substring-after($doc, 'file:')"/>
                <xsl:value-of select="$file"/>
            </xsl:for-each>
        </xsl:variable>

        <xsl:if test="exists($dependents)">
            <xsl:text> </xsl:text>
            <xsl:for-each select="$dependents">
                <xsl:if test="position() gt 1">
                    <xsl:text> </xsl:text>
                </xsl:if>
            </xsl:for-each>
            <xsl:text>&#10;&#10;</xsl:text>
        </xsl:if>

        <xsl:for-each select=".//xi:include">
            <xsl:variable name="doc" select="resolve-uri(@href, base-uri(.))"/>
            <xsl:apply-templates select="doc($doc)" mode="process-xincludes">
                <xsl:with-param name="base" select="$base"/>
            </xsl:apply-templates>
        </xsl:for-each>
    </xsl:template>
</xsl:stylesheet>
