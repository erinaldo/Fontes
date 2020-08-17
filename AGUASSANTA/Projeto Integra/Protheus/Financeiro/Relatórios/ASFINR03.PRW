#INCLUDE "RWMAKE.CH"
#INCLUDE "PROTHEUS.CH" 
#INCLUDE "TOPCONN.CH"
Static cTMPSEL := "TMPMOVVIN"
//-----------------------------------------------------------------------
/*/{Protheus.doc} ASFINR03()

Extração dos movimentos de baixas do financeiro
@param		Nenhum
@return		Nenhum
@author 	Zema
@since 		19/10/2017
@version 	1.0
@project	MAN0000001 - Aguassanta - Integra
/*/
User Function ASFINR03
Local oReport
oReport := ReportDef()
oReport:PrintDialog()
Return

//------------------------------------------------------------------------------------------
/*/{Protheus.doc} ReportDef

Definição da estrutura do relatório
	Dados dos títulos
@author    Zema
@version   12.1.17
@since     19/10/17

@return oReport - Objeto de Relatório
/*/
//------------------------------------------------------------------------------------------
Static Function ReportDef()
Local oSecTit
Local oReport
oReport:= TReport():New("ASFINR03","Carteira Financeira por Natureza e Centro de Custos","ASFINR03",{|oReport| ReportPrint(oReport)},"Carteira Financeira por Natureza e Centro de Custos") 
oReport:SetLandscape(.T.)
/*
GESTAO - inicio */
oReport:SetUseGC(.F.)
/* GESTAO - fim
*/
dbSelectArea("SE2")

oSecTit := TRSection():New(oReport,"Movimentos")

oSecTit:SetHeaderSection(.T.)

TRCell():New(oSecTit,"EMPRESA"	,,"Empresa"							,PesqPict("SE5","E5_FILIAL")	,TamSX3("E5_FILIAL")[1],.F.,,,,,,,.F.)
TRCell():New(oSecTit,"NOMEEMP"	,,"Nome Empresa"					,"@!"							,30						,.F.,,,,,,,.F.)
TRCell():New(oSecTit,"CCUSTO"	,,"Centro de Custos"				,PesqPict("CTT","CTT_CUSTO")	,TamSX3("CTT_CUSTO")[1],.F.,,,,,,,.F.)
TRCell():New(oSecTit,"DCUSTO"	,,"Descrição"						,PesqPict("CTT","CTT_DESC01")	,TamSX3("CTT_DESC01")[1],.F.,,,,,,,.F.)
TRCell():New(oSecTit,"NATUREZA"	,,"Natureza"						,PesqPict("SED","ED_CODIGO")	,TamSX3("ED_CODIGO")[1],.F.,,,,,,,.F.)
TRCell():New(oSecTit,"DNATUREZ"	,,"Descrição"						,PesqPict("SED","ED_DESCRIC")	,TamSX3("ED_DESCRIC")[1],.F.,,,,,,,.F.)
TRCell():New(oSecTit,"FORCLI"	,,"Fornecedor/Cliente"				,"@!"							,TamSX3("A2_NOME")[1],.F.,,,,,,,.F.)
TRCell():New(oSecTit,"HISTORICO",,"Histórico"						,PesqPict("SE5","E5_HISTOR")	,TamSX3("E5_HISTOR")[1],.F.,,,,,,,.F.)
TRCell():New(oSecTit,"PREFIXO"	,,"Prefixo"		  					,"@!"							,TamSX3("E1_PREFIXO")[1],.F.,,,,,,,.F.)
TRCell():New(oSecTit,"DOCUMENTO",,"Documento"						,"@!"							,TamSX3("E1_NUM")[1],.F.,,,,,,,.F.)
TRCell():New(oSecTit,"PARCELA"	,,"Parc."							,"@!"							,TamSX3("E1_PARCELA")[1],.F.,,,,,,,.F.)
TRCell():New(oSecTit,"TIPO"		,,"Tipo"							,"@!"							,TamSX3("E1_TIPO")[1],.F.,,,,,,,.F.)
TRCell():New(oSecTit,"DATAMOV"	,,"Pagamento" 						,PesqPict("SE5","E5_DATA")		,8,.F.,,,,,,,.F.)
TRCell():New(oSecTit,"VLPRIN"	,,"Valor Principal"					,PesqPict("SE5","E5_VALOR")		,TamSX3("E5_VALOR")[1],.F.,,,,,,,.F.)
TRCell():New(oSecTit,"VLCORR"	,,"(+)Juros(+)Multa(+)Acre(-)Desc"	,PesqPict("SE5","E5_VALOR")		,TamSX3("E5_VALOR")[1],.F.,,,,,,,.F.)
TRCell():New(oSecTit,"VLPAGO"	,,"Valor "							,PesqPict("SE5","E5_VALOR")		,TamSX3("E5_VALOR")[1],.F.,,,,,,,.F.)
TRCell():New(oSecTit,"MOEDA"	,,"Moeda"							,PesqPict("SE2","E2_MOEDA")		,TamSX3("E2_MOEDA")[1],.F.,,,,,,,.F.)
TRCell():New(oSecTit,"BANCO"	,,"Banco"							,"@!"							,TamSX3("E5_BANCO")[1],.F.,,,,,,,.F.)
TRCell():New(oSecTit,"AGENCIA"	,,"Agencia"							,"@!"							,TamSX3("E5_AGENCIA")[1],.F.,,,,,,,.F.)
TRCell():New(oSecTit,"CONTA"	,,"Conta"							,"@!"							,TamSX3("E5_CONTA")[1],.F.,,,,,,,.F.)
TRCell():New(oSecTit,"OPERACAO"	,,"Operação"						,"@!"							,1,.F.,,,,,,,.F.)
TRCell():New(oSecTit,"ORIGEM"	,,"Origem Mov."						,"@!"							,TamSX3("E5_ORIGEM")[1],.F.,,,,,,,.F.)

oSecTit:Cell("VLPRIN"):SetAlign("RIGHT")
oSecTit:Cell("VLCORR"):SetAlign("RIGHT")
oSecTit:Cell("VLPAGO"):SetAlign("RIGHT")
                                        
oSecTit:Cell("VLPRIN"):SetHeaderAlign("RIGHT")
oSecTit:Cell("VLCORR"):SetHeaderAlign("RIGHT")
oSecTit:Cell("VLPAGO"):SetHeaderAlign("RIGHT")

oSecTit:Cell("VLPRIN"):SetNegative("PARENTHESES")
oSecTit:Cell("VLCORR"):SetNegative("PARENTHESES")
oSecTit:Cell("VLPAGO"):SetNegative("PARENTHESES")
	
Return oReport

//------------------------------------------------------------------------------------------
/*/{Protheus.doc} ReportPrint

Impressão do relatório

@author    Zema
@version   12.1.17
@since     19/10/2017

@param oReport - Objeto de Relatório

/*/
//------------------------------------------------------------------------------------------
Static Function ReportPrint(oReport)
Local nRegSM0	:= 0
Local lGestao   	:= FWSizeFilial() > 2	// Indica se usa Gestao Corporativa
Local aSelFil		:= {}
Local oSecTit 	:= oReport:Section(1)
Local lTit		:= .T.

/* GESTAO - fim */
//Força preenchimento dos parametros mv_parXX
Pergunte("ASFINR03",.F.)

/* GESTAO - inicio */
If MV_PAR01 == 1
	nRegSM0 := SM0->(Recno())
	aSelFil := AdmGetFil(.F.,.F.,"SE5")
	SM0->(DBGOTO(nRegSM0))

Endif

If Empty(aSelFil)
	Aadd(aSelFil,cFilAnt)
Endif

/* GESTAO - fim 	*/
//Alimenta o arquivo temporário
SelMov(@aSelFil)		
/* GESTAO */

//Impressão dos dados
dbSelectArea("cTMPSEL")
cTMPSEL->(dbGoTop())        
	
//Seta os valores nas colunas 
oSecTit:Cell("EMPRESA"):SetBlock({|| 	cTMPSEL->EMPRESA })
oSecTit:Cell("NOMEEMP"):SetBlock({|| 	POSICIONE("SM0",1,"01"+ALLTRIM(cTMPSEL->EMPRESA),"M0_NOMECOM") })
oSecTit:Cell("CCUSTO"):SetBlock({|| 	cTMPSEL->CCUSTO })
oSecTit:Cell("DCUSTO"):SetBlock({|| 	cTMPSEL->DCUSTO })
oSecTit:Cell("NATUREZA"):SetBlock({|| 	cTMPSEL->NATUREZA })
oSecTit:Cell("DNATUREZ"):SetBlock({|| 	cTMPSEL->DNATUREZA })
oSecTit:Cell("FORCLI"):SetBlock({|| 	cTMPSEL->NOMECLIFOR })
oSecTit:Cell("HISTORICO"):SetBlock({|| 	cTMPSEL->HISTORICO })
oSecTit:Cell("PREFIXO"):SetBlock({|| 	cTMPSEL->DOCUMENTO })
oSecTit:Cell("DOCUMENTO"):SetBlock({|| 	cTMPSEL->DOCUMENTO })
oSecTit:Cell("PARCELA"):SetBlock({|| 	cTMPSEL->PARCELA })
oSecTit:Cell("TIPO"):SetBlock({|| 		cTMPSEL->TIPO })
oSecTit:Cell("DATAMOV"):SetBlock({|| 	cTMPSEL->DATAMOV })
oSecTit:Cell("VLPRIN"):SetBlock({|| 	cTMPSEL->VLPRIN })
oSecTit:Cell("VLCORR"):SetBlock({|| 	cTMPSEL->VLCORR })
oSecTit:Cell("VLPAGO"):SetBlock({|| 	cTMPSEL->VLPAGO })
oSecTit:Cell("MOEDA"):SetBlock({|| 		cTMPSEL->MOEDA })
oSecTit:Cell("BANCO"):SetBlock({|| 		cTMPSEL->BANCO })
oSecTit:Cell("AGENCIA"):SetBlock({||	cTMPSEL->AGENCIA })
oSecTit:Cell("CONTA"):SetBlock({|| 		cTMPSEL->CONTA })
oSecTit:Cell("OPERACAO"):SetBlock({|| 	cTMPSEL->OPERACAO })
oSecTit:Cell("ORIGEM"):SetBlock({|| 	cTMPSEL->ORIGEM })

oReport:SetTotalInLine(.F.)

lTit := .T.	
While !cTMPSEL->(Eof())
	oSecTit:Init()
	oSecTit:PrintLine()
	IF lTit
		oSecTit:SetHeaderSection(.F.)
		lTit := .F.
	ENDIF
	oReport:IncMeter()
	cTMPSEL->(dbSkip())
EndDo
	
oSecTit:Finish()

cTMPSEL->(DBCLOSEAREA())
MsErase(cTMPSEL)
SM0->(DBGOTO(nRegSM0))
Return

//------------------------------------------------------------------------------------------
/*/{Protheus.doc} SelMov

Gera o arquivo temporário

@author    Zema
@version   12.1.17
@since     19/10/2017

@param oReport - Objeto de Relatório

/*/
//------------------------------------------------------------------------------------------
Static Function SelMov(aSelFil)
Local cTipo 	:= ""
Local cCposQry	:= ""
Local nValor	:= 0
Local dData		:= CTOD(SPACE(8))         
Local nValPrin	:= 0
Local cTmpFil		:= ""                                                 
Private dBaixa		:= dDataBase
Private nAbatim		:= 0 
Private nJuros		:= 0
Private nMulta 	:= 0

/**************************************** 
mv_par01 - seleciona filiais ?
mv_par02 - Da Data  ?
mv_par03 - Ate a Data ?
mv_par04 - Operação ?                     
****************************************/

cTipo := Iif(mv_par04 = 1,"P","M")

/*****************************
 Seleção de Movimentos
******************************/
IF TCCANOPEN(cTMPSEL)
	MsErase(cTMPSEL)
EndIf

cCposQry := "SELECT "

IF cTipo == "P"             
                   
	// Contas a Receber

	cCposQry += "EZ_FILIAL 		AS EMPRESA"
	cCposQry += ",EZ_CCUSTO 	AS CCUSTO"
	cCposQry += ",CTT_DESC01 	AS DCUSTO"	
	cCposQry += ",EZ_NATUREZ 	AS NATUREZA"	
	cCposQry += ",ED_DESCRIC 	AS DNATUREZA"			
	cCposQry += ",EZ_CLIFOR+'|'+EZ_LOJA	AS FORCLI"		
	cCposQry += ",A1_NOME 		AS NOMECLIFOR"			
	cCposQry += ",E1_HIST  		AS HISTORICO"			
	cCposQry += ",E1_PREFIXO	AS PREFIXO"
	cCposQry += ",E1_NUM 		AS DOCUMENTO"
	cCposQry += ",E1_PARCELA 	AS PARCELA"			
	cCposQry += ",E1_TIPO       AS TIPO"
	cCposQry += ",E1_VENCTO  	AS DATAMOV"			
	cCposQry += ",E1_MOEDA 		AS MOEDA"			
	cCposQry += ",' ' 			AS BANCO"			
	cCposQry += ",EZ_RECPAG 	AS OPERACAO"			
	cCposQry += ",SE1.R_E_C_N_O_  	AS REGSE5"
	cCposQry += ",SEZ.R_E_C_N_O_  	AS REGSEZ"										
	cCposQry += ",'AREC'	  	AS TIPOREG"										
	cCposQry += ",SE1.E1_ORIGEM	AS ORIGEM"										
	cCposQry += " FROM "+RetSqlName("SEZ")+" SEZ "	

	cCposQry += "INNER JOIN "+ RetSqlName("SE1") +" SE1 ON "
	cCposQry += "( SE1.E1_FILIAL = SEZ.EZ_FILIAL AND "
	cCposQry += "	SE1.E1_PREFIXO = SEZ.EZ_PREFIXO AND " 
	cCposQry += "	SE1.E1_NUM = SEZ.EZ_NUM AND "
	cCposQry += "	SE1.E1_PARCELA = SEZ.EZ_PARCELA AND "
	cCposQry += "	SE1.E1_TIPO = SEZ.EZ_TIPO AND "
	cCposQry += "	SE1.E1_CLIENTE = SEZ.EZ_CLIFOR AND " 
	cCposQry += "	SE1.E1_LOJA = SEZ.EZ_LOJA AND "   
	cCposQry += "	SE1.E1_VENCTO BETWEEN '"+DTOS(mv_par02)+"' AND '"+DTOS(mv_par03)+"' AND "   	
	cCposQry += "	SE1.E1_SALDO > 0  AND "   		
	cCposQry += "	SE1.E1_TIPO <> 'PR ' AND "   		
	cCposQry += " 	SE1.D_E_L_E_T_ = ' '"
	cCposQry += ") "

	cCposQry +=	"LEFT OUTER JOIN "+ RetSqlName("SED") +" SED ON "
	cCposQry +=	"(SED.ED_CODIGO = SEZ.EZ_NATUREZ " 
	cCposQry +=	"AND SED.D_E_L_E_T_ = ' ') "                                      

	cCposQry += "LEFT OUTER JOIN "+ RetSqlName("SA1") +" SA1 ON "
	cCposQry += "( SA1.A1_COD   = SEZ.EZ_CLIFOR AND "
	cCposQry += "	SA1.A1_LOJA = SEZ.EZ_LOJA AND "     
	cCposQry += " SA1.D_E_L_E_T_ = ' '"
	cCposQry += ") "

	cCposQry += "LEFT OUTER JOIN "+ RetSqlName("CTT") +" CTT ON "
	cCposQry += "( CTT.CTT_CUSTO   = SEZ.EZ_CCUSTO AND "
	cCposQry += " CTT.D_E_L_E_T_ = ' '"
	cCposQry += ") "

                                       
	cCposQry += " WHERE "
	cCposQry += "(SEZ.EZ_FILIAL " + GetRngFil(aSelFil,"SE5",.T., @cTmpFil) + ") AND "
	cCposQry += "	SEZ.EZ_RECPAG = 'R' AND "  	 			
	cCposQry += "	SEZ.EZ_IDENT = '1' AND "  	 				
	cCposQry += " SEZ.D_E_L_E_T_ = ' '"
		               
		
	// Contas a Pagar
		
		
	cCposQry += " UNION ALL SELECT "

	cCposQry += "EZ_FILIAL 		AS EMPRESA"
	cCposQry += ",EZ_CCUSTO 	AS CCUSTO"
	cCposQry += ",CTT_DESC01 	AS DCUSTO"	
	cCposQry += ",EZ_NATUREZ 	AS NATUREZA"	
	cCposQry += ",ED_DESCRIC 	AS DNATUREZA"			
	cCposQry += ",EZ_CLIFOR+'|'+EZ_LOJA 	AS FORCLI"		
	cCposQry += ",A2_NOME 		AS NOMECLIFOR"			
	cCposQry += ",E2_HIST  		AS HISTORICO"			
	cCposQry += ",E2_PREFIXO 	AS PREFIXO"	
	cCposQry += ",E2_NUM 		AS DOCUMENTO"			
	cCposQry += ",E2_PARCELA 	AS PARCELA"
	cCposQry += ",E2_TIPO 		AS TIPO"
	cCposQry += ",E2_VENCTO  	AS DATAMOV"			
	cCposQry += ",E2_MOEDA 		AS MOEDA"			
	cCposQry += ",' ' 			AS BANCO"			
	cCposQry += ",EZ_RECPAG 	AS OPERACAO"			
	cCposQry += ",SE2.R_E_C_N_O_  	AS REGSE5"
	cCposQry += ",SEZ.R_E_C_N_O_  	AS REGSEZ"									
	cCposQry += ",'APAG'	  	AS TIPOREG"										
	cCposQry += ",SE2.E2_ORIGEM	AS ORIGEM"													
	cCposQry += " FROM "+RetSqlName("SEZ")+" SEZ "	

	cCposQry += "INNER JOIN "+ RetSqlName("SE2") +" SE2 ON "
	cCposQry += "( SE2.E2_FILIAL = SEZ.EZ_FILIAL AND "
	cCposQry += "	SE2.E2_PREFIXO = SEZ.EZ_PREFIXO AND " 
	cCposQry += "	SE2.E2_NUM = SEZ.EZ_NUM AND "
	cCposQry += "	SE2.E2_PARCELA = SEZ.EZ_PARCELA AND "
	cCposQry += "	SE2.E2_TIPO = SEZ.EZ_TIPO AND "
	cCposQry += "	SE2.E2_FORNECE = SEZ.EZ_CLIFOR AND " 
	cCposQry += "	SE2.E2_LOJA = SEZ.EZ_LOJA AND "   
	cCposQry += "	SE2.E2_VENCTO BETWEEN '"+DTOS(mv_par02)+"' AND '"+DTOS(mv_par03)+"' AND "   	
	cCposQry += "	SE2.E2_SALDO > 0  AND "   		
	cCposQry += "	SE2.E2_TIPO <> 'PR ' AND "   		
	cCposQry += " 	SE2.D_E_L_E_T_ = ' '"
	cCposQry += ") "

	cCposQry +=	"LEFT OUTER JOIN "+ RetSqlName("SED") +" SED ON "
	cCposQry +=	"(SED.ED_CODIGO = SEZ.EZ_NATUREZ " 
	cCposQry +=	"AND SED.D_E_L_E_T_ = ' ') "                                      

	cCposQry += "LEFT OUTER JOIN "+ RetSqlName("SA2") +" SA2 ON "
	cCposQry += "( SA2.A2_COD   = SEZ.EZ_CLIFOR AND "
	cCposQry += "	SA2.A2_LOJA = SEZ.EZ_LOJA AND "     
	cCposQry += " SA2.D_E_L_E_T_ = ' '"
	cCposQry += ") "

	cCposQry += "LEFT OUTER JOIN "+ RetSqlName("CTT") +" CTT ON "
	cCposQry += "( CTT.CTT_CUSTO   = SEZ.EZ_CCUSTO AND "
	cCposQry += " CTT.D_E_L_E_T_ = ' '"
	cCposQry += ") "

	cCposQry += " WHERE "
	cCposQry += "(SEZ.EZ_FILIAL " + GetRngFil(aSelFil,"SE5",.T., @cTmpFil) + ") AND "
	cCposQry += "	SEZ.EZ_RECPAG = 'P' AND "  	 			    
	cCposQry += "	SEZ.EZ_IDENT = '1' AND "  	 					
	cCposQry += " SEZ.D_E_L_E_T_ = ' '"
		
ELSE
                 
    // Movimento Bancário     
     
	cCposQry += "E5_FILIAL 		AS EMPRESA"
	cCposQry += ",E5_CCUSTO 	AS CCUSTO"
	cCposQry += ",CTT_DESC01 	AS DCUSTO"	
	cCposQry += ",E5_NATUREZ 	AS NATUREZA"	
	cCposQry += ",ED_DESCRIC 	AS DNATUREZA"			
	cCposQry += ",E5_CLIFOR+'|'+E5_LOJA 	AS FORCLI"		
	cCposQry += ",'' 			AS NOMECLIFOR"			
	cCposQry += ",E5_HISTOR 	AS HISTORICO"
	cCposQry += ",' '			AS PREFIXO"				
	cCposQry += ",' '			AS DOCUMENTO"
	cCposQry += ",' '			AS PARCELA"
	cCposQry += ",' '			AS TIPO"	
	cCposQry += ",E5_DATA 		AS DATAMOV"			
	cCposQry += ",E5_MOEDA   	AS MOEDA"			
	cCposQry += ",E5_BANCO 		AS BANCO"			
	cCposQry += ",E5_AGENCIA 	AS AGENCIA"			
	cCposQry += ",E5_CONTA 		AS CONTA"			
	cCposQry += ",E5_RECPAG 	AS OPERACAO"			
	cCposQry += ",SE5.R_E_C_N_O_  	AS REGSE5"
	cCposQry += ",0			  	AS REGSEZ"										
	cCposQry += ",'MBCO'	  	AS TIPOREG"											
	cCposQry += ",SE5.E5_ORIGEM	AS ORIGEM"											
	cCposQry += " FROM "+RetSqlName("SE5")+" SE5 "

	cCposQry +=	"LEFT OUTER JOIN "+ RetSqlName("SED") +" SED ON "
	cCposQry +=	"(SED.ED_CODIGO = SE5.E5_NATUREZ " 
	cCposQry +=	"AND SED.D_E_L_E_T_ = ' ') "                                      

	cCposQry += "LEFT OUTER JOIN "+ RetSqlName("CTT") +" CTT ON "
	cCposQry += "( CTT.CTT_CUSTO   = SE5.E5_CCUSTO AND "
	cCposQry += " CTT.D_E_L_E_T_ = ' '"
	cCposQry += ") "
                                        
	cCposQry += " WHERE "
	cCposQry += "(SE5.E5_FILIAL " + GetRngFil(aSelFil,"SE5",.T., @cTmpFil) + ") AND "
	cCposQry += "	SE5.E5_TABORI = 'FK5' AND "  	 
	cCposQry +=	"SE5.E5_TIPODOC NOT IN ('DC','D2','JR','J2','TL','MT','M2','CM','C2','TR','TE','E2','VA','PA','RA','CH','CP','ES') AND "
	cCposQry +=	"SE5.E5_SITUACA NOT IN ('E','X', 'C') AND "
	cCposQry += "	SE5.E5_DATA BETWEEN '"+DTOS(mv_par02)+"' AND '"+DTOS(mv_par03)+"' AND "   					
	cCposQry += " SE5.D_E_L_E_T_ = ' '"
		                            
	cCposQry += " UNION ALL SELECT "		
		
	// Recebimento de titulos
	
	cCposQry += "E5_FILIAL 		AS EMPRESA"
	cCposQry += ",EZ_CCUSTO 	AS CCUSTO"
	cCposQry += ",CTT_DESC01 	AS DCUSTO"	
	cCposQry += ",EZ_NATUREZ 	AS NATUREZA"	
	cCposQry += ",ED_DESCRIC 	AS DNATUREZA"			
	cCposQry += ",E5_CLIFOR+'|'+E5_LOJA 	AS FORCLI"		
	cCposQry += ",A1_NOME		AS NOMECLIFOR"			
	cCposQry += ",E5_HISTOR 	AS HISTORICO"			
	cCposQry += ",EZ_PREFIXO 	AS PREFIXO"			
	cCposQry += ",EZ_NUM 		AS DOCUMENTO"
	cCposQry += ",EZ_PARCELA 	AS PARCELA"
	cCposQry += ",EZ_TIPO 		AS TIPO"
	cCposQry += ",E5_DATA 		AS DATAMOV"			
	cCposQry += ",E5_MOEDA   	AS MOEDA"			
	cCposQry += ",E5_BANCO 		AS BANCO"			
	cCposQry += ",E5_AGENCIA 	AS AGENCIA"			
	cCposQry += ",E5_CONTA 		AS CONTA"			
	cCposQry += ",E5_RECPAG 	AS OPERACAO"			    
	cCposQry += ",SE5.R_E_C_N_O_  	AS REGSE5"
	cCposQry += ",SEZ.R_E_C_N_O_  	AS REGSEZ"										
	cCposQry += ",'BREC'	  	AS TIPOREG"											
	cCposQry += ",SE5.E5_ORIGEM	AS ORIGEM"											
	cCposQry += " FROM "+RetSqlName("SE5")+" SE5 "

	cCposQry += "INNER JOIN "+ RetSqlName("SEZ") +" SEZ ON "
	cCposQry += "( SEZ.EZ_FILIAL = SE5.E5_FILIAL AND "
	cCposQry += "	SEZ.EZ_PREFIXO = SE5.E5_PREFIXO AND " 
	cCposQry += "	SEZ.EZ_NUM = SE5.E5_NUMERO AND "
	cCposQry += "	SEZ.EZ_PARCELA = SE5.E5_PARCELA AND "
	cCposQry += "	SEZ.EZ_TIPO = SE5.E5_TIPO AND "
	cCposQry += "	SEZ.EZ_CLIFOR = SE5.E5_CLIFOR AND " 
	cCposQry += "	SEZ.EZ_LOJA = SE5.E5_LOJA AND "   
	cCposQry += "	SEZ.EZ_IDENT = '1' AND "  	 				
	cCposQry += " 	SEZ.D_E_L_E_T_ = ' '"
	cCposQry += ") "

	cCposQry +=	"LEFT OUTER JOIN "+ RetSqlName("SED") +" SED ON "
	cCposQry +=	"(SED.ED_CODIGO = SEZ.EZ_NATUREZ " 
	cCposQry +=	"AND SED.D_E_L_E_T_ = ' ') "                                      

	cCposQry += "LEFT OUTER JOIN "+ RetSqlName("CTT") +" CTT ON "
	cCposQry += "( CTT.CTT_CUSTO   = SEZ.EZ_CCUSTO AND "
	cCposQry += " CTT.D_E_L_E_T_ = ' '"
	cCposQry += ") "
                                        
	cCposQry += "LEFT OUTER JOIN "+ RetSqlName("SA1") +" SA1 ON "
	cCposQry += "( SA1.A1_COD   = SEZ.EZ_CLIFOR AND "
	cCposQry += "	SA1.A1_LOJA = SEZ.EZ_LOJA AND "     
	cCposQry += "	SEZ.EZ_RECPAG = 'R' AND "  	 			
	cCposQry += " SA1.D_E_L_E_T_ = ' '"
	cCposQry += ") "
                                        
                                        
	cCposQry += " WHERE "
	cCposQry += "(SE5.E5_FILIAL " + GetRngFil(aSelFil,"SE5",.T., @cTmpFil) + ") AND "
	cCposQry += "	SE5.E5_TABORI = 'FK1' AND "  	 			
	cCposQry +=	"SE5.E5_TIPODOC NOT IN ('DC','D2','JR','J2','TL','MT','M2','CM','C2','TR','TE','E2','VA','CH') AND "
	cCposQry +=	"((SE5.E5_RECPAG = 'R' AND SE5.E5_TIPODOC <> 'ES') OR " 
	cCposQry +=	" (SE5.E5_RECPAG = 'P' AND SE5.E5_TIPODOC = 'ES')) AND "   
	cCposQry +=	" SE5.E5_MOTBX <> 'TIN' AND "   	
	cCposQry +=	" SE5.E5_TIPO <> 'PR' AND "   		
	cCposQry +=	" SE5.E5_NUMERO <>  ' ' AND "   			

	cCposQry +=	"SE5.E5_SITUACA NOT IN ('E','X', 'C') AND "
	cCposQry += "	SE5.E5_DATA BETWEEN '"+DTOS(mv_par02)+"' AND '"+DTOS(mv_par03)+"' AND "   					
	cCposQry += " SE5.D_E_L_E_T_ = ' '"
	                                
	cCposQry += " UNION ALL SELECT "	
	
	// Pagamento de titulos	
	
	cCposQry += "E5_FILIAL 		AS EMPRESA"
	cCposQry += ",EZ_CCUSTO 	AS CCUSTO"
	cCposQry += ",CTT_DESC01 	AS DCUSTO"	
	cCposQry += ",EZ_NATUREZ 	AS NATUREZA"	
	cCposQry += ",ED_DESCRIC 	AS DNATUREZA"			
	cCposQry += ",E5_CLIFOR+'|'+E5_LOJA 	AS FORCLI"		
	cCposQry += ",A2_NOME		AS NOMECLIFOR"			
	cCposQry += ",E5_HISTOR 	AS HISTORICO"			
	cCposQry += ",EZ_PREFIXO 	AS PREFIXO"			
	cCposQry += ",EZ_NUM 		AS DOCUMENTO"
	cCposQry += ",EZ_PARCELA 	AS PARCELA"
	cCposQry += ",EZ_TIPO 		AS TIPO"
	cCposQry += ",E5_DATA 		AS DATAMOV"			
	cCposQry += ",E5_MOEDA   	AS MOEDA"			
	cCposQry += ",E5_BANCO 		AS BANCO"			
	cCposQry += ",E5_AGENCIA 	AS AGENCIA"			
	cCposQry += ",E5_CONTA 		AS CONTA"			
	cCposQry += ",E5_RECPAG 	AS OPERACAO"			
	cCposQry += ",SE5.R_E_C_N_O_  	AS REGSE5"
	cCposQry += ",SEZ.R_E_C_N_O_  	AS REGSEZ"										
	cCposQry += ",'BPAG'	  	AS TIPOREG"												
	cCposQry += ",SE5.E5_ORIGEM	AS ORIGEM"											
	cCposQry += " FROM "+RetSqlName("SE5")+" SE5 "

	cCposQry += "INNER JOIN "+ RetSqlName("SEZ") +" SEZ ON "
	cCposQry += "( SEZ.EZ_FILIAL = SE5.E5_FILIAL AND "
	cCposQry += "	SEZ.EZ_PREFIXO = SE5.E5_PREFIXO AND " 
	cCposQry += "	SEZ.EZ_NUM = SE5.E5_NUMERO AND "
	cCposQry += "	SEZ.EZ_PARCELA = SE5.E5_PARCELA AND "
	cCposQry += "	SEZ.EZ_TIPO = SE5.E5_TIPO AND "
	cCposQry += "	SEZ.EZ_CLIFOR = SE5.E5_CLIFOR AND " 
	cCposQry += "	SEZ.EZ_LOJA = SE5.E5_LOJA AND "   
	cCposQry += "	SEZ.EZ_IDENT = '1' AND "  	 				
	cCposQry += " 	SEZ.D_E_L_E_T_ = ' '"
	cCposQry += ") "

	cCposQry +=	"LEFT OUTER JOIN "+ RetSqlName("SED") +" SED ON "
	cCposQry +=	"(SED.ED_CODIGO = SEZ.EZ_NATUREZ " 
	cCposQry +=	"AND SED.D_E_L_E_T_ = ' ') "                                      

	cCposQry += "LEFT OUTER JOIN "+ RetSqlName("CTT") +" CTT ON "
	cCposQry += "( CTT.CTT_CUSTO   = SEZ.EZ_CCUSTO AND "
	cCposQry += " CTT.D_E_L_E_T_ = ' '"
	cCposQry += ") "
                                        
	cCposQry += "LEFT OUTER JOIN "+ RetSqlName("SA2") +" SA2 ON "
	cCposQry += "( SA2.A2_COD   = SEZ.EZ_CLIFOR AND "
	cCposQry += "	SA2.A2_LOJA = SEZ.EZ_LOJA AND "     
	cCposQry += "	SEZ.EZ_RECPAG = 'P' AND "  	 			
	cCposQry += " SA2.D_E_L_E_T_ = ' '"
	cCposQry += ") "
                                        
                                        
	cCposQry += " WHERE "
	cCposQry += "(SE5.E5_FILIAL " + GetRngFil(aSelFil,"SE5",.T., @cTmpFil) + ") AND "
	cCposQry += "	SE5.E5_TABORI = 'FK2' AND "  	 			
	cCposQry +=	"SE5.E5_TIPODOC NOT IN ('DC','D2','JR','J2','TL','MT','M2','CM','C2','TR','TE','E2','VA','CH') AND "
	cCposQry +=	"((SE5.E5_RECPAG = 'P' AND SE5.E5_TIPODOC <> 'ES') OR " 
	cCposQry +=	" (SE5.E5_RECPAG = 'R' AND SE5.E5_TIPODOC = 'ES')) AND "   
	cCposQry +=	" SE5.E5_MOTBX <> 'TIN' AND "   	
	cCposQry +=	" SE5.E5_TIPO <> 'PR' AND "   		
	cCposQry +=	" SE5.E5_NUMERO <>  ' ' AND "   			

	cCposQry +=	"SE5.E5_SITUACA NOT IN ('E','X', 'C') AND "
	cCposQry += "	SE5.E5_DATA BETWEEN '"+DTOS(mv_par02)+"' AND '"+DTOS(mv_par03)+"' AND "   					
	cCposQry += " SE5.D_E_L_E_T_ = ' '"

ENDIF

cCposQry +=		"ORDER BY DATAMOV "

MEMOWRITE("ZEMA",cCposQry)

cAliasQry 	:= GetNextAlias()
cCposQry := ChangeQuery(cCposQry)
dbUseArea(.T.,"TOPCONN",TCGenQry(,,cCposQry),cAliasQry,.F.,.T.)
                     
//Gera o arquivo temporário
aStruct := {}
                                                        
aAdd(aStruct,{"EMPRESA"		,"C",TamSx3("E2_FILIAL")[1]	,0} 							)
aAdd(aStruct,{"CCUSTO"		,"C",TamSx3("CTT_CUSTO")[1]	,0} 							)
aAdd(aStruct,{"DCUSTO"		,"C",TamSx3("CTT_DESC01")[1],0}								)
aAdd(aStruct,{"NATUREZA"	,"C",TamSx3("E2_NATUREZ")[1],0}								)
aAdd(aStruct,{"DNATUREZA"	,"C",TamSx3("ED_DESCRIC")[1],0}								)
aAdd(aStruct,{"FORCLI"		,"C",TamSx3("E1_CLIENTE")[1]+TamSx3("E1_LOJA")[1],0}		)
aAdd(aStruct,{"NOMECLIFOR"	,"C",TamSx3("A1_NOME")[1],0}								)
aAdd(aStruct,{"HISTORICO"	,"C",TamSx3("E5_HISTOR")[1],0}								)
aAdd(aStruct,{"PREFIXO"		,"C",TamSx3("E1_PREFIXO")[1],0}							)
aAdd(aStruct,{"DOCUMENTO"	,"C",TamSx3("E1_NUM")[1],0}							)
aAdd(aStruct,{"PARCELA"		,"C",TamSx3("E1_PARCELA")[1],0}							)
aAdd(aStruct,{"TIPO"		,"C",TamSx3("E1_TIPO")[1],0}							)
aAdd(aStruct,{"DATAMOV"		,"D",8	,0}							)
aAdd(aStruct,{"VLPRIN"		,"N",TamSx3("E1_VALOR")[1],TamSx3("E1_VALOR")[2]}			)
aAdd(aStruct,{"VLCORR"		,"N",TamSx3("E1_VALOR")[1],TamSx3("E1_VALOR")[2]}			)
aAdd(aStruct,{"VLPAGO"		,"N",TamSx3("E1_VALOR")[1],TamSx3("E1_VALOR")[2]}			)
aAdd(aStruct,{"MOEDA"		,"N",TamSx3("E2_MOEDA")[1],0}								)
aAdd(aStruct,{"BANCO"		,"C",TamSx3("E5_BANCO")[1],0}							)
aAdd(aStruct,{"AGENCIA"		,"C",TamSx3("E5_AGENCIA")[1],0}							)
aAdd(aStruct,{"CONTA"		,"C",TamSx3("E5_CONTA")[1],0}							)
aAdd(aStruct,{"OPERACAO"	,"C",TamSx3("E5_RECPAG")[1],0}							)
aAdd(aStruct,{"REGSE5"		,"N",10,0}							)
aAdd(aStruct,{"REGSEZ"		,"N",10,0}							)
aAdd(aStruct,{"TIPOREG"		,"C",04,0}							)
aAdd(aStruct,{"ORIGEM"		,"C",TamSx3("E5_ORIGEM")[1],0}							)

//Cria o arquivo temporário
lCreate := MsCreate(cTMPSEL,aStruct,"TOPCONN")		
If lCreate
	dbUseArea(.T.,"TOPCONN",cTMPSEL,"cTMPSEL",.T.,.F.)
	dbSelectArea("cTMPSEL")
	
	//Grava o retorno no arquivo temporário
	dbSelectArea(cAliasQry)
	(cAliasQry)->(dbGoTop())
	
	While !(cAliasQry)->(Eof())
	    nValPrin	:= 0
        nValor 		:= 0          
		dData 		:= CTOD(SPACE(8))
        nMulta		:= 0
        nJuros		:= 0                         
        nMoeda		:= 0
        
		IF (cAliasQry)->TIPOREG == "AREC"
			SE1->(DBGOTO((cAliasQry)->REGSE5))
			SEZ->(DBGOTO((cAliasQry)->REGSEZ))
			
			IF SE1->E1_TIPO $ MVABATIM	+"/"+MVFUABT
				(cAliasQry)->(DBSKIP())
				LOOP
			ENDIF			
			
			nValPrin	:= Round(SE1->E1_SALDO * SEZ->EZ_PERC,2)
			nValor 		:= SE1->E1_SALDO - SumAbatRec(SE1->E1_PREFIXO,SE1->E1_NUM,SE1->E1_PARCELA,SE1->E1_MOEDA,"S",dDataBase,,,,,,,SE1->E1_FILIAL) + SE1->E1_SDACRES - SE1->E1_SDDECRE
			nMulta := ( SE1->E1_PORCJUR / 100 ) * nValor 
			nJuros := fa070Juros(SE1->E1_MOEDA,nValor ,"SE1",SE1->E1_BAIXA)
		    nValor := nValor + nJuros + nMulta
			nValor 		:= Round(nValor * SEZ->EZ_PERC,2)
			dData  := SE1->E1_VENCTO
			nMoeda := SE1->E1_MOEDA                 
		ENDIF	

		IF (cAliasQry)->TIPOREG == "APAG"
			SE2->(DBGOTO((cAliasQry)->REGSE5))
			SEZ->(DBGOTO((cAliasQry)->REGSEZ))

			IF SE2->E2_TIPO $ MVABATIM	+"/"+MVFUABT
				(cAliasQry)->(DBSKIP())
				LOOP
			ENDIF	

			nValPrin	:= Round(SE2->E2_SALDO * SEZ->EZ_PERC,2)
			nValor 		:= SE2->E2_SALDO - SomaAbat(SE2->E2_PREFIXO,SE2->E2_NUM,SE2->E2_PARCELA,"P",SE2->E2_MOEDA,dDataBase,SE2->E2_FORNECE,SE2->E2_LOJA)  + SE2->E2_SDACRES - SE2->E2_SDDECRE
			nJuros 		:= fa080Juros(SE2->E2_MOEDA,nValor,"SE2",SE2->E2_BAIXA)
		    nValor 		:= nValor + nJuros
			nValor 		:= Round(nValor * SEZ->EZ_PERC,2)
			dData  		:= SE2->E2_VENCTO
			nMoeda 		:= SE2->E2_MOEDA			
		ENDIF	

		IF (cAliasQry)->TIPOREG == "MBCO"
			SE5->(DBGOTO((cAliasQry)->REGSE5))
			nValPrin	:= SE5->(E5_VALOR-E5_VLMULTA-E5_VLJUROS+E5_VLDESCO)
			nValor 		:= SE5->E5_VALOR
			dData  		:= SE5->E5_DATA
			nMoeda 		:= VAL(SE5->E5_MOEDA)
		ENDIF	

		IF (cAliasQry)->TIPOREG == "BREC"
			SE5->(DBGOTO((cAliasQry)->REGSE5))
			SEZ->(DBGOTO((cAliasQry)->REGSEZ))			
			nValPrin	:= SE5->(E5_VALOR-E5_VLMULTA-E5_VLJUROS+E5_VLDESCO)
			nValPrin 	:= Round(nValPrin * SEZ->EZ_PERC,2)
			nValor 		:= SE5->E5_VALOR
			nValor 		:= Round(nValor * SEZ->EZ_PERC,2)
			dData  		:= SE5->E5_DATA
			nMoeda 		:= VAL(SE5->E5_MOEDA)
		ENDIF	

		IF (cAliasQry)->TIPOREG == "BPAG"
			SE5->(DBGOTO((cAliasQry)->REGSE5))
			SEZ->(DBGOTO((cAliasQry)->REGSEZ))			
			nValPrin	:= SE5->(E5_VALOR-E5_VLMULTA-E5_VLJUROS+E5_VLDESCO)
			nValPrin 	:= Round(nValPrin * SEZ->EZ_PERC,2)
			nValor 		:= SE5->E5_VALOR
			nValor 		:= Round(nValor * SEZ->EZ_PERC,2)
			dData  		:= SE5->E5_DATA
			nMoeda 		:= VAL(SE5->E5_MOEDA)
		ENDIF	

		xHist := ""
		IF ALLTRIM( UPPER( (cAliasQry)->HISTORICO ) ) == "VALOR PAGO S/ TITULO"
			xHist := "PAGAMENTO DA FATURA "+ALLTRIM( (cAliasQry)->DOCUMENTO )+" NESTA DATA."		
		ELSEIF ALLTRIM( UPPER( (cAliasQry)->HISTORICO ) ) =="VALOR RECEBIDO S/ TITULO"
			xHist := "RECEBIMENTO DA FATURA "+ALLTRIM( (cAliasQry)->DOCUMENTO )+" NESTA DATA."
		ELSE
			xHist := ALLTRIM( UPPER( (cAliasQry)->HISTORICO ) )
		ENDIF			

		//Grava o registro 
		RECLOCK("cTMPSEL",.T.)
		cTMPSEL->EMPRESA	:= (cAliasQry)->EMPRESA
		cTMPSEL->CCUSTO		:= (cAliasQry)->CCUSTO
		cTMPSEL->DCUSTO		:= (cAliasQry)->DCUSTO
		cTMPSEL->NATUREZA	:= (cAliasQry)->NATUREZA
		cTMPSEL->DNATUREZA	:= (cAliasQry)->DNATUREZA
		cTMPSEL->FORCLI		:= (cAliasQry)->FORCLI
		cTMPSEL->NOMECLIFOR	:= (cAliasQry)->NOMECLIFOR
		cTMPSEL->HISTORICO	:= xHist
		cTMPSEL->PREFIXO	:= (cAliasQry)->PREFIXO
		cTMPSEL->DOCUMENTO	:= (cAliasQry)->DOCUMENTO
		cTMPSEL->PARCELA	:= (cAliasQry)->PARCELA
		cTMPSEL->TIPO		:= (cAliasQry)->TIPO
		cTMPSEL->DATAMOV	:= dData
		cTMPSEL->VLPRIN		:= nValPrin
		cTMPSEL->VLCORR		:= ABS(nValor - nValPrin)
		cTMPSEL->VLPAGO		:= nValor
		cTMPSEL->MOEDA		:= nMoeda
		cTMPSEL->BANCO		:= (cAliasQry)->BANCO
		cTMPSEL->AGENCIA	:= (cAliasQry)->AGENCIA
		cTMPSEL->CONTA		:= (cAliasQry)->CONTA
		cTMPSEL->OPERACAO	:= (cAliasQry)->OPERACAO
		cTMPSEL->ORIGEM		:= (cAliasQry)->ORIGEM
		MsUnlock()
		
		(cAliasQry)->(DBSKIP())
	END
	(cAliasQry)->(dbCloseArea()) 
	MsErase(cAliasQry)

EndIf                    

	/*
	GESTAO - inicio */
	If !Empty(cTmpFil)
		CtbTmpErase(cTmpFil)
	Endif
	/* GESTAO - fim
	*/

Return