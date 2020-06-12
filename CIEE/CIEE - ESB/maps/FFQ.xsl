<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:esb="com.totvs.esb.XSLFunctions" xmlns:uuid="java:java.util.UUID" version="2.0" exclude-result-prefixes="esb" extension-element-prefixes="esb">
	<xsl:output method="xml" encoding="utf-8" indent="yes" />
	<xsl:template match="/">
		<xsl:element name="TOTVSIntegrator">
			<xsl:element name="GlobalProduct">
				<xsl:text disable-output-escaping="yes">PROTHEUS</xsl:text>
			</xsl:element>
			<xsl:element name="GlobalFunctionCode">
				<xsl:text disable-output-escaping="yes">EAI</xsl:text>
			</xsl:element>
			<xsl:element name="GlobalDocumentFunctionCode">
				<xsl:text disable-output-escaping="yes">CEAIA34</xsl:text>
			</xsl:element>
			<xsl:element name="GlobalDocumentFunctionDescription">
				<xsl:text disable-output-escaping="yes">Integracao FFQ</xsl:text>
			</xsl:element>
			<xsl:element name="DocVersion">
				<xsl:text disable-output-escaping="yes">1.0</xsl:text>
			</xsl:element>
			<xsl:element name="DocDateTime">
				<xsl:value-of select="current-dateTime()" />
			</xsl:element>   
			<xsl:element name="DocIdentifier"> 
				<xsl:value-of select="uuid:randomUUID()" />    
			</xsl:element>      
			<xsl:element name="DocCompany">
				<xsl:value-of select="/ROOT/FFQ/DocCompany" />
			</xsl:element>
			<xsl:element name="DocBranch">
				<xsl:value-of select="/ROOT/FFQ/DocBranch" />
			</xsl:element>
			<xsl:element name="DocName" />
			<xsl:element name="DocFederalID" />      
			<xsl:element name="DocType">
				<xsl:text disable-output-escaping="yes">2</xsl:text>
			</xsl:element>
			<xsl:element name="Message">
				<xsl:element name="Layouts">
					<xsl:element name="Identifier">
						<xsl:value-of select="/ROOT/FFQ/Identifier" />
						<xsl:text disable-output-escaping="yes">CEAIA34</xsl:text>
					</xsl:element>
					<xsl:element name="Version">
						<xsl:text disable-output-escaping="yes">1.0</xsl:text>
					</xsl:element>
					<xsl:element name="FunctionCode">
						<xsl:value-of select="/ROOT/FFQ/FunctionCode" />
					</xsl:element>  
					<xsl:element name="Content">
						<xsl:element name="CEAIA34">
							<xsl:attribute name="Operation">
								<xsl:value-of select="/ROOT/FFQ/Operation" />
							</xsl:attribute>
							<xsl:attribute name="version">
								<xsl:text disable-output-escaping="yes">1.01</xsl:text>
							</xsl:attribute>
							<xsl:for-each select="/ROOT/FFQ">
								<xsl:element name="SE2MASTER">
									<xsl:attribute name="modeltype">
										<xsl:text disable-output-escaping="yes">FIELDS</xsl:text>
									</xsl:attribute>
									<xsl:element name="A2_CGC">
										<xsl:element name="value">
											<xsl:value-of select="A2_CGC" />
										</xsl:element>
									</xsl:element>
									<xsl:element name="A2_NOME">
										<xsl:element name="value">
											<xsl:value-of select="A2_NOME" />
										</xsl:element>
									</xsl:element>
									<xsl:element name="E2_CCD">
										<xsl:element name="value">
											<xsl:value-of select="E2_CCD" />
										</xsl:element>
									</xsl:element>
									<xsl:element name="E2_NUM">
										<xsl:element name="value">
											<xsl:value-of select="E2_NUM" />
										</xsl:element>
									</xsl:element>
									<xsl:element name="E2_VALOR">
										<xsl:element name="value">
											<xsl:value-of select="E2_VALOR" />
										</xsl:element>
									</xsl:element>
									<xsl:element name="E2_XCTKM">
										<xsl:element name="value">
											<xsl:value-of select="E2_XCTKM" />
										</xsl:element>
									</xsl:element>
									<xsl:element name="E2_XVLRKM">
										<xsl:element name="value">
											<xsl:value-of select="E2_XVLRKM" />
										</xsl:element>
									</xsl:element>
									<xsl:element name="E2_XCTTX">
										<xsl:element name="value">
											<xsl:value-of select="E2_XCTTX" />
										</xsl:element>
									</xsl:element>
									<xsl:element name="E2_XVLRTX">
										<xsl:element name="value">
											<xsl:value-of select="E2_XVLRTX" />
										</xsl:element>
									</xsl:element>
									<xsl:element name="E2_XCTRF">
										<xsl:element name="value">
											<xsl:value-of select="E2_XCTRF" />
										</xsl:element>
									</xsl:element>
									<xsl:element name="E2_XVLRRF">
										<xsl:element name="value">
											<xsl:value-of select="E2_XVLRRF" />
										</xsl:element>
									</xsl:element>
									<xsl:element name="E2_XCTEST">
										<xsl:element name="value">
											<xsl:value-of select="E2_XCTEST" />
										</xsl:element>
									</xsl:element>
									<xsl:element name="E2_XVLEST">
										<xsl:element name="value">
											<xsl:value-of select="E2_XVLEST" />
										</xsl:element>
									</xsl:element>
									<xsl:element name="E2_XCDPED">
										<xsl:element name="value">
											<xsl:value-of select="E2_XCDPED" />
										</xsl:element>
									</xsl:element>
									<xsl:element name="E2_XVRPED">
										<xsl:element name="value">
											<xsl:value-of select="E2_XVRPED" />
										</xsl:element>
									</xsl:element>								
								</xsl:element>
							</xsl:for-each>
						</xsl:element>
					</xsl:element>
				</xsl:element>
			</xsl:element>
		</xsl:element>
	</xsl:template>
</xsl:stylesheet>
