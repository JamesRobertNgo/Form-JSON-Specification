<?xml version="1.0" encoding="utf-8"?>

<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">
	<xsl:output method="text" omit-xml-declaration="yes"/>
	
	<!-- ==================== -->
	<!-- NAMED TEMPLATES      -->
	<!-- ==================== -->
	
	<!-- ** JS ESCAPE TEMPLATE ** -->
	<xsl:template name="js-escape">
		<xsl:param name="text"/>
		
		<xsl:variable name="APOS" select='"&apos;"'/>
		
		<xsl:if test="string-length($text) > 0">
			<xsl:value-of select="substring-before(concat($text, '$APOS'), '$APOS')"/>
			
			<xsl:if test="contains($text, '$APOS')">
				<xsl:text>\&apos;</xsl:text>

				<xsl:call-template name="js-escape">
					<xsl:with-param name="text" select="substring-after($text, '$APOS')"/>
				</xsl:call-template>
			</xsl:if>
		</xsl:if>
	</xsl:template>
	
	<!-- ** JS STRING TEMPLATE ** -->
	<xsl:template name="js-string">
		<xsl:param name="text"/>
		
		<xsl:text>&apos;</xsl:text>
		
		<xsl:call-template name="js-escape">
			<xsl:with-param name="text" select="normalize-space($text)" />
		</xsl:call-template>
		
		<xsl:text>&apos;</xsl:text>
	</xsl:template>
	
	<!-- ==================== -->
	<!-- MATCHED TEMPLATES    -->
	<!-- ==================== -->
	
	<!-- ** MATCH ROOT ** -->
	<xsl:template match="/">
		<xsl:text>(function(){ </xsl:text>
		
		<xsl:apply-templates select="//data[property[@name='1']/@value='ELEMENTTYPE']"/>
		
		<xsl:apply-templates select="//data[property[@name='1']/@value='MODIFIERTYPE']"/>
		
		<xsl:apply-templates select="//data[property[@name='1']/@value='PARAMETER']"/>
		
		<xsl:apply-templates select="//data[property[@name='1']/@value='FORM']"/>
		
		<xsl:text>})();</xsl:text>
	</xsl:template>
	
	<!-- ** MATCH PARAMETER DATA ** -->
	<xsl:template match="//data[property[@name='1']/@value='PARAMETER']">
		<xsl:text>var placeholder = document.getElementById(</xsl:text>
		<xsl:choose>
			<xsl:when test="property[@name='3']/@value != 'null'">
				<xsl:call-template name="js-string">
					<xsl:with-param name="text" select="property[@name='3']/@value"/>
				</xsl:call-template>
			</xsl:when>
			<xsl:otherwise>
				<xsl:text>null</xsl:text>
			</xsl:otherwise>
		</xsl:choose>
		<xsl:text>); </xsl:text>
	</xsl:template>
	
	<!-- ** MATCH FORM DATA ** -->
	<xsl:template match="//data[property[@name='1']/@value='FORM']">
		<xsl:text>var form = document.createElement('form'); </xsl:text>
		
		<xsl:choose>
			<xsl:when test="property[@name='2']/@value!='null'">
				<xsl:text>form.setAttribute('id', </xsl:text>
				<xsl:call-template name="js-string">
					<xsl:with-param name="text" select="concat('form_', property[@name='2']/@value)"/>
				</xsl:call-template>
				<xsl:text>); </xsl:text>
			</xsl:when>
		</xsl:choose>
		
		<xsl:choose>
			<xsl:when test="property[@name='3']/@value!='null'">
				<xsl:text>form.setAttribute('action', </xsl:text>
				<xsl:call-template name="js-string">
					<xsl:with-param name="text" select="property[@name='3']/@value"/>
				</xsl:call-template>
				<xsl:text>); </xsl:text>
			</xsl:when>
		</xsl:choose>
		
		<xsl:choose>
			<xsl:when test="property[@name='4']/@value!='null'">
				<xsl:text>form.setAttribute('method', </xsl:text>
				<xsl:call-template name="js-string">
					<xsl:with-param name="text" select="property[@name='4']/@value"/>
				</xsl:call-template>
				<xsl:text>); </xsl:text>
			</xsl:when>
		</xsl:choose>
		
		<xsl:apply-templates select="//data[property[@name='1']/@value='ELEMENT' and property[@name='6']/@value='null']"/>
		
		<xsl:apply-templates select="//data[property[@name='1']/@value='MODIFIER' and property[@name='5']/@value='null']"/>
		
		<xsl:choose>
			<xsl:when test="property[@name='5']/@value!='null' or property[@name='6']/@value!='null'">
				<xsl:text>var p = document.createElement('P'); </xsl:text>
				
				<xsl:choose>
					<xsl:when test="property[@name='5']/@value!='null'">
						<xsl:text>var reset = document.createElement('input'); </xsl:text>
						<xsl:text>reset.setAttribute('type', 'reset'); </xsl:text>
						<xsl:text>reset.setAttribute('value', </xsl:text>
						<xsl:call-template name="js-string">
							<xsl:with-param name="text" select="property[@name='5']/@value"/>
						</xsl:call-template>
						<xsl:text>); </xsl:text>
						
						<xsl:text>p.appendChild(reset);  </xsl:text>
					</xsl:when>
				</xsl:choose>
				
				<xsl:choose>
					<xsl:when test="property[@name='6']/@value!='null'">
						<xsl:text>var reset = document.createElement('input'); </xsl:text>
						<xsl:text>reset.setAttribute('type', 'submit'); </xsl:text>
						<xsl:text>reset.setAttribute('value', </xsl:text>
						<xsl:call-template name="js-string">
							<xsl:with-param name="text" select="property[@name='6']/@value"/>
						</xsl:call-template>
						<xsl:text>); </xsl:text>
						
						<xsl:text>p.appendChild(reset);  </xsl:text>
					</xsl:when>
				</xsl:choose>
				
				<xsl:text>form.appendChild(p);  </xsl:text>
			</xsl:when>
		</xsl:choose>
		
		
		
		<xsl:text>placeholder.appendChild(form); </xsl:text>
	</xsl:template>
	
	<!-- ** MATCH ELEMENTTYPES DATA ** -->
	<xsl:template match="//data[property[@name='1']/@value='ELEMENTTYPE']">
		<xsl:text>function build</xsl:text>
		<xsl:value-of select="property[@name='2']/@value"/>
		<xsl:text>(data, parent, form) {</xsl:text>
		<xsl:value-of select="normalize-space(property[@name='3']/@value)"/>
		<xsl:text>};</xsl:text>
	</xsl:template>
	
	<!-- ** MATCH ELEMENT DATA ** -->
	<xsl:template match="//data[property[@name='1']/@value='ELEMENT']">
		<xsl:text>(function(parent, form) { </xsl:text>
		
		<xsl:text>var data = { </xsl:text>
		
		<xsl:text>"id": </xsl:text>
		<xsl:choose>
			<xsl:when test="property[@name='2']/@value!='null'">
				<xsl:call-template name="js-string">
					<xsl:with-param name="text" select="property[@name='2']/@value"/>
				</xsl:call-template>
			</xsl:when>
			<xsl:otherwise>
				<xsl:text>null</xsl:text>
			</xsl:otherwise>
		</xsl:choose>
		
		<xsl:text>, </xsl:text>
		
		<xsl:text>"name": </xsl:text>
		<xsl:choose>
			<xsl:when test="property[@name='3']/@value!='null'">
				<xsl:call-template name="js-string">
					<xsl:with-param name="text" select="property[@name='3']/@value"/>
				</xsl:call-template>
			</xsl:when>
			<xsl:otherwise>
				<xsl:text>null</xsl:text>
			</xsl:otherwise>
		</xsl:choose>
		
		<xsl:text>, </xsl:text>
		
		<xsl:text>"label": </xsl:text>
		<xsl:choose>
			<xsl:when test="property[@name='4']/@value!='null'">
				<xsl:call-template name="js-string">
					<xsl:with-param name="text" select="property[@name='4']/@value"/>
				</xsl:call-template>
			</xsl:when>
			<xsl:otherwise>
				<xsl:text>null</xsl:text>
			</xsl:otherwise>
		</xsl:choose>
		
		<xsl:text>, </xsl:text>
		
		<xsl:text>"typeCd": </xsl:text>
		<xsl:choose>
			<xsl:when test="property[@name='5']/@value!='null'">
				<xsl:call-template name="js-string">
					<xsl:with-param name="text" select="property[@name='5']/@value"/>
				</xsl:call-template>
			</xsl:when>
			<xsl:otherwise>
				<xsl:text>null</xsl:text>
			</xsl:otherwise>
		</xsl:choose>
		
		<xsl:text>, </xsl:text>
		
		<xsl:text>"parentElementId": </xsl:text>
		<xsl:choose>
			<xsl:when test="property[@name='6']/@value!='null'">
				<xsl:call-template name="js-string">
					<xsl:with-param name="text" select="property[@name='6']/@value"/>
				</xsl:call-template>
			</xsl:when>
			<xsl:otherwise>
				<xsl:text>null</xsl:text>
			</xsl:otherwise>
		</xsl:choose>
		
		<xsl:text>}; </xsl:text>
		
		<xsl:text>var buildResult = build</xsl:text>
		<xsl:value-of select="property[@name='5']/@value"/>
		<xsl:text>(data, parent, form); </xsl:text>
		
		<xsl:variable name="ID" select="property[@name='2']/@value"/>
		<xsl:apply-templates select="//data[property[@name='1']/@value='ELEMENT' and property[@name='6']/@value=$ID]"/>
		
		<xsl:apply-templates select="//data[property[@name='1']/@value='MODIFIER' and property[@name='5']/@value=$ID]"/>
		
		<xsl:text>}) </xsl:text>
		
		<xsl:text>(</xsl:text>
		<xsl:choose>
			<xsl:when test="property[@name='6']/@value != 'null'">
				<xsl:text>buildResult.parent</xsl:text>
			</xsl:when>
			<xsl:otherwise>
				<xsl:text>form</xsl:text>
			</xsl:otherwise>
		</xsl:choose>
		<xsl:text>, form); </xsl:text>
	</xsl:template>
	
	<!-- ** MATCH MODIFIERTYPE DATA ** -->
	<xsl:template match="//data[property[@name='1']/@value='MODIFIERTYPE']">
		<xsl:text>function modify</xsl:text>
		<xsl:value-of select="property[@name='2']/@value"/>
		<xsl:text>(data, element, form) {</xsl:text>
		<xsl:value-of select="normalize-space(property[@name='3']/@value)"/>
		<xsl:text>};</xsl:text>
	</xsl:template>
	
	<!-- ** MATCH MODIFIER DATA ** -->
	<xsl:template match="//data[property[@name='1']/@value='MODIFIER']">
		<xsl:text>(function(element, form) { </xsl:text>
		
		<xsl:text>var data = { </xsl:text>
		
		<xsl:text>"id": </xsl:text>
		<xsl:choose>
			<xsl:when test="property[@name='2']/@value!='null'">
				<xsl:call-template name="js-string">
					<xsl:with-param name="text" select="property[@name='2']/@value"/>
				</xsl:call-template>
			</xsl:when>
			<xsl:otherwise>
				<xsl:text>null</xsl:text>
			</xsl:otherwise>
		</xsl:choose>
		
		<xsl:text>, </xsl:text>
		
		<xsl:text>"value": </xsl:text>
		<xsl:choose>
			<xsl:when test="property[@name='3']/@value!='null'">
				<xsl:call-template name="js-string">
					<xsl:with-param name="text" select="property[@name='3']/@value"/>
				</xsl:call-template>
			</xsl:when>
			<xsl:otherwise>
				<xsl:text>null</xsl:text>
			</xsl:otherwise>
		</xsl:choose>
		
		<xsl:text>, </xsl:text>
		
		<xsl:text>"typeCd": </xsl:text>
		<xsl:choose>
			<xsl:when test="property[@name='4']/@value!='null'">
				<xsl:call-template name="js-string">
					<xsl:with-param name="text" select="property[@name='4']/@value"/>
				</xsl:call-template>
			</xsl:when>
			<xsl:otherwise>
				<xsl:text>null</xsl:text>
			</xsl:otherwise>
		</xsl:choose>
		
		<xsl:text>, </xsl:text>
		
		<xsl:text>"elementId": </xsl:text>
		<xsl:choose>
			<xsl:when test="property[@name='5']/@value!='null'">
				<xsl:call-template name="js-string">
					<xsl:with-param name="text" select="property[@name='5']/@value"/>
				</xsl:call-template>
			</xsl:when>
			<xsl:otherwise>
				<xsl:text>null</xsl:text>
			</xsl:otherwise>
		</xsl:choose>
		
		<xsl:text>}; </xsl:text>
		
		<xsl:text>modify</xsl:text>
		<xsl:value-of select="property[@name='4']/@value"/>
		<xsl:text>(data, element, form); </xsl:text>
		
		<xsl:text>}) </xsl:text>
		
		<xsl:text>(</xsl:text>
		<xsl:choose>
			<xsl:when test="property[@name='5']/@value != 'null'">
				<xsl:text>buildResult.element</xsl:text>
			</xsl:when>
			<xsl:otherwise>
				<xsl:text>form</xsl:text>
			</xsl:otherwise>
		</xsl:choose>
		<xsl:text>, form); </xsl:text>
	</xsl:template>
</xsl:stylesheet>