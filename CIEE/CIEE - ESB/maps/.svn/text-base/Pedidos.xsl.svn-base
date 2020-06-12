<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:esb="com.totvs.esb.XSLFunctions" xmlns:uuid="java:java.util.UUID" version="1.0" exclude-result-prefixes="esb" extension-element-prefixes="esb">
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
				<xsl:text disable-output-escaping="yes">CEAIA07</xsl:text>
			</xsl:element>
			<xsl:element name="GlobalDocumentFunctionDescription">
				<xsl:text disable-output-escaping="yes">Pedido de venda</xsl:text>
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
				<xsl:value-of select="/ROOT/CABECALHO/DocCompany" />
			</xsl:element>
			<xsl:element name="DocBranch">
				<xsl:value-of select="/ROOT/CABECALHO/DocBranch" />
			</xsl:element>
			<xsl:element name="DocName" />
			<xsl:element name="DocFederalID" />      
			<xsl:element name="DocType">
				<xsl:text disable-output-escaping="yes">2</xsl:text>
			</xsl:element>		
			<xsl:element name="Message">
				<xsl:element name="Layouts">
					<xsl:element name="Identifier">
						<xsl:value-of select="/ROOT/CABECALHO/Identifier" />
						<xsl:text disable-output-escaping="yes">CEAIA07</xsl:text>
					</xsl:element>
					<xsl:element name="Version">
						<xsl:text disable-output-escaping="yes">1.0</xsl:text>
					</xsl:element>
					<xsl:element name="FunctionCode">
						<xsl:value-of select="/ROOT/CABECALHO/FunctionCode" />
					</xsl:element>  
					<xsl:element name="Content">
						<xsl:element name="CEAIA07">
							<xsl:attribute name="Operation">
								<xsl:value-of select="/ROOT/CABECALHO/Operation" />
							</xsl:attribute>
							<xsl:attribute name="version">
								<xsl:text disable-output-escaping="yes">1.01</xsl:text>
							</xsl:attribute>
							<xsl:for-each select="/ROOT/CABECALHO">
								<xsl:element name="SC5MASTER">              
									<xsl:attribute name="modeltype">
										<xsl:text disable-output-escaping="yes">FIELDS</xsl:text>
									</xsl:attribute>
									<xsl:if test="/ROOT/Cliente/A1_CGC">
										<xsl:element name="SA1MASTER">
											<xsl:attribute name="modeltype">
												<xsl:text disable-output-escaping="yes">FIELDS</xsl:text>
											</xsl:attribute>
											<xsl:element name="A1_CGC">
												<xsl:element name="value">
													<xsl:value-of select="/ROOT/Cliente/A1_CGC" />
												</xsl:element>
											</xsl:element>
											<xsl:element name="A1_NOME">
												<xsl:element name="value">
													<xsl:value-of select="/ROOT/Cliente/A1_NOME" />
												</xsl:element>
											</xsl:element>
											<xsl:element name="A1_PESSOA">
												<xsl:element name="value">
													<xsl:value-of select="/ROOT/Cliente/A1_PESSOA" />
												</xsl:element>
											</xsl:element>                
											<xsl:element name="A1_NREDUZ">
												<xsl:element name="value">
													<xsl:value-of select="/ROOT/Cliente/A1_NREDUZ" />
												</xsl:element>
											</xsl:element>
											<xsl:element name="A1_TIPO">
												<xsl:element name="value">
													<xsl:value-of select="/ROOT/Cliente/A1_TIPO" />
												</xsl:element>
											</xsl:element>                                                                 
											<xsl:element name="A1_END">
												<xsl:element name="value">
													<xsl:value-of select="/ROOT/Cliente/A1_END" />
												</xsl:element>
											</xsl:element> 	                
											<xsl:element name="A1_EST">
												<xsl:element name="value">
													<xsl:value-of select="/ROOT/Cliente/A1_EST" />
												</xsl:element>
											</xsl:element>
											<xsl:element name="A1_COD_MUN">
												<xsl:element name="value">
													<xsl:value-of select="/ROOT/Cliente/A1_COD_MUN" />
												</xsl:element>
											</xsl:element>                
											<xsl:element name="A1_COMPLEM">
												<xsl:element name="value">
													<xsl:value-of select="/ROOT/Cliente/A1_COMPLEM" />
												</xsl:element>
											</xsl:element>               
											<xsl:element name="A1_BAIRRO">
												<xsl:element name="value">
													<xsl:value-of select="/ROOT/Cliente/A1_BAIRRO" />
												</xsl:element>
											</xsl:element> 
											<xsl:element name="A1_CODPAIS">
												<xsl:element name="value">
													<xsl:value-of select="/ROOT/Cliente/A1_CODPAIS" />
												</xsl:element>
											</xsl:element>
											<xsl:element name="A1_DDD">
												<xsl:element name="value">
													<xsl:value-of select="/ROOT/Cliente/A1_DDD" />
												</xsl:element>
											</xsl:element>
											<xsl:element name="A1_TEL">
												<xsl:element name="value">
													<xsl:value-of select="/ROOT/Cliente/A1_TEL" />
												</xsl:element>
											</xsl:element>               
											<xsl:element name="A1_INSCR">
												<xsl:element name="value">
													<xsl:value-of select="/ROOT/Cliente/A1_INSCR" />
												</xsl:element>
											</xsl:element>                
											<xsl:element name="A1_INSCRM">
												<xsl:element name="value">
													<xsl:value-of select="/ROOT/Cliente/A1_INSCRM" />
												</xsl:element>
											</xsl:element>
											<xsl:element name="A1_CEP">
												<xsl:element name="value">
													<xsl:value-of select="/ROOT/Cliente/A1_CEP" />
												</xsl:element>
											</xsl:element>
											<xsl:element name="A1_XCODSOE">
												<xsl:element name="value">
													<xsl:value-of select="/ROOT/Cliente/A1_XCODSOE" />
												</xsl:element>
											</xsl:element>
										</xsl:element>
									</xsl:if>              
									<xsl:element name="A1_XCODSOE">
										<xsl:element name="value">
											<xsl:value-of select="/ROOT/CABECALHO/A1_XCODSOE" />
										</xsl:element>
									</xsl:element>                
									<xsl:element name="C5_MENNOTA">
										<xsl:element name="value">
											<xsl:value-of select="/ROOT/CABECALHO/C5_MENNOTA" />
										</xsl:element>
									</xsl:element>
									<xsl:element name="C5_XRPSSOC">
										<xsl:element name="value">
											<xsl:value-of select="/ROOT/CABECALHO/C5_XRPSSOC" />
										</xsl:element>
									</xsl:element>
									<xsl:element name="C5_DATA1">
										<xsl:element name="value">
											<xsl:value-of select="/ROOT/CABECALHO/C5_DATA1" />
										</xsl:element>
									</xsl:element>                                                
									<xsl:element name="SC6DETAIL">
										<xsl:attribute name="modeltype">
											<xsl:text disable-output-escaping="yes">GRID</xsl:text>
										</xsl:attribute>
										<xsl:element name="items">
											<xsl:for-each select="ITEM">
												<xsl:element name="item">
													<xsl:variable name="count" select="position()" />
													<xsl:attribute name="id">
														<xsl:value-of select="format-number($count,'000')" />
													</xsl:attribute>
													<xsl:element name="C6_QTDVEN">
														<xsl:element name="value">
															<xsl:value-of select="C6_QTDVEN" />
														</xsl:element>
													</xsl:element>
													<xsl:element name="C6_PRCVEN">
														<xsl:element name="value">
															<xsl:value-of select="C6_PRUNIT" />
														</xsl:element>
													</xsl:element>
													<xsl:element name="C6_PRUNIT">
														<xsl:element name="value">
															<xsl:value-of select="C6_PRUNIT" />
														</xsl:element>
													</xsl:element>
													<xsl:element name="C6_VALOR">
														<xsl:element name="value">
															<xsl:value-of select="C6_VALOR" />
														</xsl:element>
													</xsl:element>
													<xsl:element name="C6_QTDLIB">
														<xsl:element name="value">
															<xsl:value-of select="C6_QTDVEN" />
														</xsl:element>
													</xsl:element>
												</xsl:element>
											</xsl:for-each>
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
