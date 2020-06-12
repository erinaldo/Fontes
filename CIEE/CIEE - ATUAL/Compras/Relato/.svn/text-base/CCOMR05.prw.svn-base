#INCLUDE "TOTVS.CH" 
#INCLUDE "REPORT.CH"
#INCLUDE "TOPCONN.CH" 
//---------------------------------------------------------------------------------------
/*/{Protheus.doc} CCOMR01
Relatorio Gerencial de autorização de fornecimento
@author     Cristiano
@since     	25/06/2007
@version  	P.11.8      
@param 		Nenhum
@return    	Nenhum
@obs        Nenhum
Alterações Realizadas desde a Estruturação Inicial
------------+-----------------+----------------------------------------------------------
Data       	|Desenvolvedor    |Motivo                                                                                                                 
------------+-----------------+----------------------------------------------------------
		  	|				  | 
------------+-----------------+----------------------------------------------------------
/*/
//---------------------------------------------------------------------------------------
User Function CCOMR05()
LOCAL oReport   := NIL 
Local oSection01:= NIL
Local oBreak	:= NIL 
Local oFuncTot	:= NIL
Local oFuncCont	:= NIL
LOCAL cPerg		:= "CRYAF2"
Private lFirst	:= .t.

//CCOMR05SX1(cPerg) // criar grupo de perguntas na revitalização
Pergunte(cPerg,.F.)
oReport := TReport():New("CCOMR05","RELATÓRIO GERENCIAL DE AUTORIZAÇÕES DE FORNECIMENTO",cPerg,{|oReport| C2R05IMP(oReport)},"Este relatório irá imprimir o relatorio Gerencial de autorização de fornecimento.")
oReport:lParamPage := .F.
oReport:lEdit := .F.
oReport:SetLandScape(.T.)
oReport:SetTotalInLine(.F.) 
oReport:lEndReport:= .t.
oReport:lFooterVisible:= .f. 
oReport:SetCustomText( {|| C2R05CAB(oReport) } )
oReport:SetDynamic()
oReport:PageTotalBefore(.T.) 
oReport:bTotalCanPrint:= {|| }


DEFINE SECTION oSection01 OF oReport TITLE "Autorização de fornecimento" 
DEFINE CELL NAME "C7_NUM" OF oSection01 TITLE "NUM AF" 
DEFINE CELL NAME "A2_NOME" OF oSection01 TITLE "FORNECEDOR"
DEFINE CELL NAME "C7_DESCRI" OF oSection01 TITLE "DESCRIÇÃO DO MATERIAL"
DEFINE CELL NAME "I3_DESC" OF oSection01 TITLE "REQUISITANTE"
DEFINE CELL NAME "C7_QUANT" OF oSection01 TITLE "QUANT"
DEFINE CELL NAME "C7_UM" OF oSection01 TITLE "UM"
DEFINE CELL NAME "C7_TOTAL" OF oSection01 TITLE "R$ ITEM"
DEFINE CELL NAME "TOTALAF" OF oSection01 TITLE "R$ TOT AF" size 20
oSection01:Cell("C7_DESCRI"):lLineBreak:=.t.  
oSection01:SetTotalInLine(.f.)
oSection01:SetCols(8)     
oSection01:SetAutoSize(.T.)         
oSection01:SetTotalText('Total Geral R$')
oSection01:Cell("TOTALAF"):nAlign := 3       
oSection01:Cell("TOTALAF"):nHeaderAlign := 3 
oReport:PrintDialog()

/*
Local cParams	:= ""
Local cOpcoes	:= ""

If cEmpant == '01'
	Pergunte("CRYAF2    ",.T.)
	cParams := mv_par01+";"+mv_par02+";"+mv_par03+";"+mv_par04+";"+dtoc(mv_par05)+";"+dtoc(mv_par06)+";"+dtoc(mv_par07)+";"+dtoc(mv_par08)+";"+Str(mv_par09,1)+";"+mv_par10+";"+mv_par11+";"+Alltrim(mv_par12)+";"+Alltrim(mv_par13)+";"
	cOpcoes := "1;0;1;Relatorio Gerencial de Autorizacao de Fornecimento"
	CALLCRYS("CRYAF2", cParams, cOpcoes)
Else
	Pergunte("CRYAF3    ",.T.)
	cParams := mv_par01+";"+mv_par02+";"+mv_par03+";"+mv_par04+";"+dtoc(mv_par05)+";"+dtoc(mv_par06)+";"+dtoc(mv_par07)+";"+dtoc(mv_par08)+";"+Str(mv_par09,1)+";"+mv_par10+";"+mv_par11+";"+Alltrim(mv_par12)+";"+Alltrim(mv_par13)+";"
	cOpcoes := "1;0;1;Relatorio Gerencial de Autorizacao de Fornecimento"
	CALLCRYS("CRYAF3", cParams, cOpcoes)
EndIf
*/

Return(.T.) 
/*
ÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³ C2R05CAB   ºAutor  ³ Totvs       	   º Data ³01/01/2015 º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ Imprime o cabeçalho							              º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ CIEE                                                       º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛ
*/
STATIC FUNCTION C2R05CAB(oReport)
Local cChar	 := chr(160) 
Local cLogo  := FisxLogo("1")
local nRowAtu:= oReport:nRow
Local aCabec := {	""; 
			        , "                     ";
			        + "         " + cChar + AllTrim(oReport:CTITLE) ;
			        + "         " + cChar;					
					, cChar + "                   "  ;
		  			+ "         " + cChar; 
			        , "      CENTRO DE INTEGRAÇÃO EMPRESA-ESCOLA" +cChar+"                                                      Periodo de "+Dtoc(MV_PAR05)+" até "+Dtoc(MV_PAR06) ;
          			+ "         " + cChar;
          			, "                 "  ;
          			+ cChar + "Impresso em " + Dtoc(dDataBase)+" - "+time() } 
          			       			       

oReport:SayBitmap(10,105,cLogo,200,100) 

oReport:nRow:=2300
oReport:PrtRight("Página: "+ trim(TRANSFORM(oReport:Page(),'999999'))+"  ")
oReport:nRow:=nRowAtu

return aCabec
/*
ÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³ C2R05IMP   ºAutor  ³ Totvs       	   º Data ³01/01/2015 º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ Imprime o relatório							              º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ CIEE                                                       º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛ
*/ 
STATIC FUNCTION C2R05IMP(oReport) 
LOCAL oSection01:= oReport:Section(1) 
LOCAL cQry		:= ""     
LOCAL nTot		:= 0 
LOCAL cTab		:= GetNextAlias()
local cNumOld	:= ""
local nTotAf	:= 0  
local nTotGerAf	:= 0
local nItem		:= 0
local aDados	:= {}
PRIVATE cQbr	:= "" 
PRIVATE nCntAf	:= 0  

cQry+= "SELECT 	C7_NUM"+CRLF
cQry+= "    	,C7_FORNECE"+CRLF
cQry+= "    	,A2_NOME"+CRLF
cQry+= "    	,B1_DESC"+CRLF
cQry+= "     	,COALESCE(CONVERT(VARCHAR(8000),CONVERT(VARBINARY(8000),C7_ESPEC )),'') B1_ESPEC"+CRLF
cQry+= "    	,C7_CC"+CRLF
cQry+= "    	,CASE WHEN C7_CC = '' THEN 'Almoxarifado' ELSE I3_DESC END AS I3_DESC"+CRLF
cQry+= "    	,C7_QUANT"+CRLF
cQry+= "    	,C7_UM"+CRLF
cQry+= "    	,C7_PRECO"+CRLF
cQry+= "    	,(C7_TOTAL-C7_VLDESC) as C7_TOTAL"+CRLF
cQry+= "    	,B1_GRUPO"+CRLF
cQry+= "    	,B1_COD"+CRLF
cQry+= "    	,C7_DESCRI"+CRLF
cQry+= "FROM "+RETSQLNAME("SC7")+" SC7"+CRLF
cQry+= "    LEFT OUTER JOIN "+RETSQLNAME("SB1")+" SB1 ON (B1_FILIAL = C7_FILIAL AND B1_COD = C7_PRODUTO  AND SB1.D_E_L_E_T_ = ' ')"+CRLF
cQry+= "    LEFT OUTER JOIN "+RETSQLNAME("SA2")+" SA2 ON (A2_FILIAL = '  '      AND A2_COD = C7_FORNECE  AND A2_LOJA = C7_LOJA AND SA2.D_E_L_E_T_ = ' ')"+CRLF
cQry+= "    LEFT OUTER JOIN "+RETSQLNAME("SI3")+" SI3 ON (I3_FILIAL = C7_FILIAL AND I3_CUSTO = C7_CC  AND I3_CONTA = '' AND SI3.D_E_L_E_T_ = ' ')"+CRLF
cQry+= "WHERE C7_FILIAL = '"+XFILIAL("SC7")+"'"+CRLF
cQry+= "    AND C7_PRODUTO BETWEEN '"+MV_PAR01+"' AND '"+MV_PAR02+"'"+CRLF
cQry+= "    AND C7_NUM BETWEEN '"+MV_PAR03+"' AND '"+MV_PAR04+"'"+CRLF
cQry+= "    AND C7_EMISSAO BETWEEN '"+DTOS(MV_PAR05)+"' AND '"+DTOS(MV_PAR06)+"'"+CRLF
cQry+= "    AND C7_DATPRF  BETWEEN '"+DTOS(MV_PAR07)+"' AND '"+DTOS(MV_PAR08)+"'"+CRLF
cQry+= "    AND B1_GRUPO BETWEEN '"+MV_PAR10+"' AND '"+MV_PAR11+"'"+CRLF
cQry+= "    AND SC7.D_E_L_E_T_ = ' '"+CRLF
cQry+= "ORDER BY C7_NUM, C7_PRODUTO"+CRLF

TcQuery cQry NEW ALIAS (cTab) 
Count To nTot      

oReport:SetMeter(nTot*2)
nTot:= 0			                                                   
(cTab)->(dbSelectArea((cTab)))                    
(cTab)->(dbGoTop())                               	
WHILE (cTab)->(!EOF()) .AND. !oReport:Cancel()	 
	oReport:IncMeter() 
	
	cQbr:= (cTab)->C7_NUM         
	
	IF cNumOld!=(cTab)->C7_NUM
		nTot++  
		
		if nItem > 0  
			aDados[nItem][8]:= trim(transform(nTotAf,pesqpict("SC7","C7_TOTAL")))
			nTotAf:= 0
		endif	
		
	endif	             
	
	nTotAf+= (cTab)->C7_TOTAL	
	nTotGerAf+= (cTab)->C7_TOTAL	
	
	aadd(aDados,array(8)) 
	nItem:= len(aDados)
	
	aDados[nItem][1]:= IIF(cNumOld!=(cTab)->C7_NUM,(cTab)->C7_NUM,"")
	aDados[nItem][2]:= IIF(cNumOld!=(cTab)->C7_NUM,(cTab)->A2_NOME,"") 
	aDados[nItem][3]:= IIF(MV_PAR09==1,(cTab)->C7_DESCRI+CRLF+strTran(strTran((cTab)->B1_ESPEC,"’","'"),"–","|"),(cTab)->C7_DESCRI) 
	aDados[nItem][4]:= (cTab)->I3_DESC
	aDados[nItem][5]:= (cTab)->C7_QUANT
	aDados[nItem][6]:= (cTab)->C7_UM
	aDados[nItem][7]:= (cTab)->C7_TOTAL 
	aDados[nItem][8]:= "" 	  
	
	cNumOld:=(cTab)->C7_NUM
				
(cTab)->(dbSkip())	
ENDDO  
(cTab)->(dbCloseArea()) 

if !empty(aDados) .and. nItem > 0  
	aDados[nItem][8]:= alltrim(transform(nTotAf,pesqpict("SC7","C7_TOTAL")))
endif 

for nCnt:=1 to len(aDados)  

	oReport:IncMeter()
	
	oSection01:Init()  
	oSection01:Cell("C7_NUM"):SetBlock({|| aDados[nCnt][1]	})
	oSection01:Cell("A2_NOME"):SetBlock({|| aDados[nCnt][2] })
	oSection01:Cell("C7_DESCRI"):SetBlock({|| aDados[nCnt][3] })	
	oSection01:Cell("I3_DESC"):SetBlock({|| aDados[nCnt][4] })
	oSection01:Cell("C7_QUANT"):SetBlock({|| aDados[nCnt][5] })
	oSection01:Cell("C7_UM"):SetBlock({|| aDados[nCnt][6] })
	oSection01:Cell("C7_TOTAL"):SetBlock({|| aDados[nCnt][7] }) 
	oSection01:Cell("TOTALAF"):SetBlock({|| aDados[nCnt][8] })	
	oSection01:PrintLine()                                     
	
	if !empty(aDados[nCnt][8]) 
		oReport:SkipLine(1)
		oReport:FatLine()  
		oReport:SkipLine(1)
	endif
next nCnt 

nCntAf := nTot
oSection01:Finish() 

oReport:PrtRight("Total de AF´s:     "+alltrim(cvaltochar(nCntAf))+"                 Total Geral R$:     "+alltrim(transform(nTotGerAf,pesqpict("SC7","C7_TOTAL"))) )

RETURN   