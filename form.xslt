<?xml version="1.0" encoding="utf-8"?>

<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">
	<xsl:output method="xml"/>
	
	<!-- ==================== -->
	<!-- NAMED TEMPLATES      -->
	<!-- ==================== -->
	
	<xsl:variable name="validCharacters_apos" select='"&apos;"' />
	<xsl:variable name="validCharacters" select="concat($validCharacters_apos, ' !&quot;#$%&amp;()*+,-./0123456789:;&lt;=&gt;?@ABCDEFGHIJKLMNOPQRSTUVWXYZ[\]^_`abcdefghijklmnopqrstuvwxyz{|}~&#xA0;¡¢£¤¥¦§¨©ª«¬&#xAD;®¯°±²³´µ¶·¸¹º»¼½¾¿ÀÁÂÃÄÅÆÇÈÉÊËÌÍÎÏÐÑÒÓÔÕÖ×ØÙÚÛÜÝÞßàáâãäåæçèéêëìíîïðñòóôõö÷øùúûüýþÿ€‚ƒ„…†‡ˆ‰Š‹ŒŽ‘’“”•–—˜™š›œžŸ')" />
	
	<!-- SANITIZER -->
	<xsl:template name="sanitizer">
		<xsl:param name="value" select="''" />
		<xsl:param name="invalid" select="''" />
		<xsl:param name="indicator" select="''" />
		
		<xsl:if test="string-length($value) > 0 ">
			<xsl:choose>
				<xsl:when test="contains($invalid,substring($value,1,1))">
					<xsl:value-of select="$indicator"/>
				</xsl:when>
				
				<xsl:otherwise>
					<xsl:value-of select="substring($value,1,1)"/>
				</xsl:otherwise>
			</xsl:choose>
			
			<xsl:call-template name="sanitizer">
				<xsl:with-param name="value" select="substring($value,2,string-length($value)-1)"/>
				<xsl:with-param name="invalid" select="$invalid"/>
				<xsl:with-param name="indicator" select="$indicator"/>
			</xsl:call-template>
		</xsl:if>
	</xsl:template>
	
	<!-- SANITIZE -->
	<xsl:template name="sanitize">
		<xsl:param name="value" />
		<xsl:param name="indicator" select="''" />
		
		<xsl:variable name="normvalue" select="normalize-space($value)" />
		<xsl:variable name="invalid" select="translate($normvalue, $validCharacters, '')" />
	
		<xsl:choose>
			<xsl:when test="string-length($invalid) > 0 ">
				<xsl:call-template name="sanitizer">
					<xsl:with-param name="value" select="$normvalue"/>
					<xsl:with-param name="invalid" select="$invalid"/>
					<xsl:with-param name="indicator" select="$indicator"/>
				</xsl:call-template>
			</xsl:when>
	
			<xsl:otherwise>
				<xsl:value-of select="$normvalue"/>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template>
	
	<!-- ==================== -->
	<!-- NAMED KEY            -->
	<!-- ==================== -->
	
	<xsl:key name="DATABY_ID" match="//data" use="property[@name='1']/@value"/>
	
	<!-- ==================== -->
	<!-- MATCHED TEMPLATES    -->
	<!-- ==================== -->
	
	<!-- MATCH ROOT -->
	
	<xsl:template match="/">
		
		<xsl:element name="root_element">
			
			<xsl:apply-templates select="//data[property[@name='3']/@value = 'null']"/>
			
		</xsl:element>
		
	</xsl:template>
	
	
	<!-- MATCH DATA -->
	
	<xsl:template match="//data">
		
		<xsl:variable name="ID" select="property[@name='1']/@value"/>
		
		<xsl:if test="count(. | key('DATABY_ID', $ID)[1]) = 1">
			
			<xsl:variable name="PARENTID" select="property[@name='1']/@value"/>
			
			<xsl:element name="element">
				
				<xsl:attribute name="id">
					<xsl:value-of select="property[@name=$ID]/@value"/>
				</xsl:attribute>
				
				<xsl:attribute name="type">
					<xsl:value-of select="property[@name='2']/@value"/>
				</xsl:attribute>
				
				<!-- MODS BEGINS -->
				<xsl:element name="mods">
					<xsl:for-each select="key('DATABY_ID', $ID)">
						<xsl:element name="mod">
							<xsl:value-of select="property[@name='4']/@value"/>
						</xsl:element>
					</xsl:for-each>
				</xsl:element>
				<!-- END OF MODS -->
				
				<!-- ELEMENTS BEGIN -->
				<xsl:element name="elements">
					<xsl:apply-templates select="//data[property[@name='3']/@value = $PARENTID]"/>
				</xsl:element>
				<!-- END OF ELEMENTS -->
				
			</xsl:element>
			
		</xsl:if>
		
	</xsl:template>
	
</xsl:stylesheet>