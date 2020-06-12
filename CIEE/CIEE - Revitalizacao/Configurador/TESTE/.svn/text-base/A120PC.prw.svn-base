#include "PROTHEUS.CH"
#INCLUDE "TOPCONN.CH"
#INCLUDE "FWPrintSetup.ch"

User Function A120PC()
Local oOk   		:= LoadBitmap( GetResources(), "LBOK" )
Local oNo   		:= LoadBitmap( GetResources(), "LBNO" )
Local lOk			:= .F.
Local cGrupo		:= "000001"
Local oBold
//Local cParams		:= ""

Local cVias		:= ""

//Local cOpcoes		:= "1;0;1;Autorização de Fornecimento"

Private cLocalSP	:= Spac(100)
Private cLocalRJ	:= Spac(100)
Private cOBS 	 	:= Spac(100) + Chr(13) + Chr(10) + Spac(100) + Chr(13) + Chr(10)
Private nUsado		:= 1
Private nCobranca	:= 1
Private nEntrega	:= 1
Private oUsado, oCobranca, oEntrega, oLocal
Private aPags 		:= {}
Private aPessoas	:= {}

//cLocalSP := "Rua Tabapua, 540 - CEP 04533-001"
cLocalSP := "Rua Tabapua, 684 - CEP 04533-001"
cLocalRJ := "Rua da Constituicao, 67 - CEP 20060-010"

aSize(aPessoas,5)                                         

DBSelectArea("SX5")
DbSetOrder(1)
Dbseek(xFilial("SX5")+"Z2")

While !EOF() .AND. X5_TABELA == "Z2"
	aAdd(aPags,{.T.,SX5->X5_DESCRI})
	SX5->(DBSKip())
End

IF TYPE("cA120Num") <> "U"
	DBSelectArea("SC7")
	DBSetOrder(1)
	DBSeek(xFilial("SC7")+ca120Num)
ENDIF

_cQuery := " SELECT "
_cQuery += " SUM(C7_TOTAL-C7_VLDESC) C7_TOTAL"
_cQuery += " FROM " + RetSqlName("SC7") + " SC7"
_cQuery += " WHERE C7_FILIAL = '" + xFilial("SC7") + "'"
_cQuery += " AND   C7_NUM    = '" + SC7->C7_NUM    + "'"
_cQuery += " AND SC7.D_E_L_E_T_ = ' '"

TcQuery _cQuery New Alias "TMP"
DBSelectArea("TMP")
DBGotop()

nTotal := TMP->C7_TOTAL

TMP->(DBCloseArea())

DBSelectArea("SZH")
DBSetOrder(1)
IF DBSeek(xFilial("SZH")+SC7->C7_NUM)
	aPessoas[1] := PADR(SZH->ZH_PESSOA1,40)
	aPessoas[2] := PADR(SZH->ZH_PESSOA2,40)
	aPessoas[3] := PADR(SZH->ZH_PESSOA3,40)
	aPessoas[4] := PADR(SZH->ZH_PESSOA4,40)
	aPessoas[5] := PADR(SZH->ZH_PESSOA5,40)
  	
	cObs		:= SZH->ZH_OBS
ELSE
	
	aPessoas[1] := SPACE(40)
	aPessoas[2] := SPACE(40)
	aPessoas[3] := SPACE(40)
	aPessoas[4] := SPACE(40)
	aPessoas[5] := SPACE(40)

	VldCodGrupo("000001")
ENDIF

DEFINE FONT oBold NAME "Arial" SIZE 0, -13 BOLD

DEFINE MSDIALOG oDlg FROM  31,58 TO 500,578 TITLE "Impressão do Pedido de Compra " + SC7->C7_NUM  + " Total R$ " + TRANSFORM(nTotal,"@E 999,999,999.99" ) PIXEL

@ 05,05 Say OemToAnsi("Selecione a sua opção :") OF oDlg PIXEL 
@ 13,05 LISTBOX oLbx1 FIELDS HEADER "","Via" SIZE 170, 55 OF oDlg PIXEL ;
ON DBLCLICK (SelItem())

oLbx1:SetArray(aPags)
oLbx1:bLine := { || {If(aPags[oLbx1:nAt,1],oOk,oNo),aPags[oLbx1:nAt,2]} }
oLbx1:nFreeze  := 1

@ 77,01 TO 163,150 LABEL "                                      " OF oDlg PIXEL
@ 75, 05 SAY "Aprovadores : " FONT oBold PIXEL
@ 75,50 MSGET cGrupo F3 "SAL" SIZE 30,9 OF oDlg PIXEL Picture "@!" Valid VldCodGrupo(cGrupo)

@ 90,05 Say OemToAnsi("Comprador") OF oDlg PIXEL 
@ 90,50 MSGET aPessoas[1] SIZE 70,9 OF oDlg PIXEL

@105,05 Say OemToAnsi("Supervisor") OF oDlg PIXEL 
@105,50 MSGET aPessoas[2] SIZE 70,9 OF oDlg PIXEL

@120,05 Say OemToAnsi("Gerência"  ) OF oDlg PIXEL 
@120,50 MSGET aPessoas[3] SIZE 70,9 OF oDlg PIXEL

@135,05 Say OemToAnsi("Superintendência") OF oDlg PIXEL 
@135,50 MSGET aPessoas[4] SIZE 70,9 OF oDlg PIXEL

@150,05 Say OemToAnsi("Presidência") OF oDlg PIXEL 
@150,50 MSGET aPessoas[5] SIZE 70,9 OF oDlg PIXEL

@ 77,160 TO 105,255 LABEL "Imprime Especificação Produto :" OF oDlg PIXEL
@ 82,175 RADIO oUsado VAR nUsado 3D SIZE 30,10 PROMPT "Sim","Não" OF oDlg PIXEL

@ 108,160 TO 135,255 LABEL "Cobrança :" OF oDlg PIXEL
@ 113,175 RADIO oCobranca VAR nCobranca 3D SIZE 30,10 PROMPT "Matriz","Unidade" OF oDlg PIXEL

@ 138,160 TO 173,255 LABEL "Local de Entrega :" OF oDlg PIXEL
@ 142,175 RADIO oEntrega VAR nEntrega 3D SIZE 30,10 PROMPT "Matriz","Unidade","Outros" OF oDlg on change AtuEntrega() PIXEL

If cEmpant == '01'
	@175,05 Say OemToAnsi("Local de Entrega") OF oDlg PIXEL 
	@175,50 GET oLocal VAR cLocalSP OF oDlg PIXEL SIZE 160,9 WHEN nEntrega == 3
Else
	@175,05 Say OemToAnsi("Local de Entrega") OF oDlg PIXEL 
	@175,50 GET oLocal VAR cLocalRJ OF oDlg PIXEL SIZE 160,9 WHEN nEntrega == 3
EndIf

@190,05 Say OemToAnsi("Observação") OF oDlg PIXEL
@190,50 GET oOBS 	VAR cOBS OF oDlg MEMO PIXEL SIZE 160,25 
	
DEFINE SBUTTON FROM 05, 220 TYPE 1  ENABLE OF oDlg ACTION (lOk :=.T.,oDlg:End())
DEFINE SBUTTON FROM 25, 220 TYPE 2  ENABLE OF oDlg ACTION (lOk :=.F.,oDlg:End())
	
ACTIVATE MSDIALOG oDlg CENTERED

IF lOk

	DBSelectArea("SZH")
	DBSetOrder(1)
	IF DBSeek(xFilial("SZH")+SC7->C7_NUM)
		RECLOCK("SZH",.F.)
	ELSE
		RECLOCK("SZH",.T.)
		SZH->ZH_FILIAL	:= xFILIAL("SZH")
		SZH->ZH_NUM		:= SC7->C7_NUM
	END
	          
	SZH->ZH_PESSOA1	:= aPessoas[1]
	SZH->ZH_PESSOA2	:= aPessoas[2]
	SZH->ZH_PESSOA3	:= aPessoas[3]
	SZH->ZH_PESSOA4	:= aPessoas[4]
	SZH->ZH_PESSOA5	:= aPessoas[5]
    
	If cEmpant == '01'
		SZH->ZH_LOCAL  	:= OemToAnsi(cLocalSP)
		SZH->ZH_OBS    	:= OemToAnsi(cObs)
		MSUNLOCK()
	Else
		SZH->ZH_LOCAL  	:= OemToAnsi(cLocalRJ)
		SZH->ZH_OBS    	:= OemToAnsi(cObs)
		MSUNLOCK()	
	EndIf	

	//cParams	:= xFilial("SC7") + ";" + SC7->C7_NUM + ";" +  SC7->C7_NUM 

	IF aPags[1,1] 
		cVias += "01"
	ELSE
		cVias += "00"
	ENDIF

	IF aPags[2,1] 
		cVias += ";02"
	ELSE
		cVias += ";00"
	ENDIF

	IF aPags[3,1] 
		cVias += ";03"
	ELSE
		cVias += ";00"
	ENDIF

	IF aPags[4,1] 
		cVias += ";04"
	ELSE
		cVias += ";00"
	ENDIF
	
	/*
	IF nUsado == 1
		cParams += ";S"
	ELSE
		cParams += ";N"
	ENDIF
  
	IF nCobranca == 1
		cParams += ";"
		cParams += ";"
		cParams += ";"
		cParams += ";"
		cParams += ";"
		If cEmpant == '01'            
			cLocalSP	:= 	SPace(100)
			cPedido		:= SC7->C7_NUM
		Else
			cLocalRJ	:= 	SPace(100)
			cPedido		:= SC7->C7_NUM			
		EndIf
	Else
		cPedido	:= SC7->C7_NUM		
		DBSelectArea("SC7")
		DBSetOrder(1)
		DBSeek(xFilial("SC7")+cPedido)
		
		DBSelectArea("CTT")
		DBSetOrder(1)
		DBSeek(xFilial("CTT")+SC7->C7_CC)
		
		
		//Devido ao tamanho muito grande da string de parâmetros, foi feita a divisão do
		//endereco em dois parâmetros. Felipe, em 12/08/04  
		
//	Retirado string abaixo conforme solicitacao OS.10/0240 pelo analista Emerson Natali dia 25/11/2010.
//		cParams += ";" + Alltrim(Substr(CTT->CTT_END,1,38)) + "," + ALLTRIM(CTT->CTT_NUMEND)
		cParams += ";" + Alltrim(CTT->CTT_END)
		cParams += ";" + ALLTRIM(CTT->CTT_MUN) + " - " + CTT->CTT_EST + " - CEP " + TRANSFORM(CTT->CTT_CEP, "@R 99999-999")
		cParams += ";PABX(" + CTT->CTT_DDD + ") " + alltrim(CTT->CTT_TEL) + " - Fax " + alltrim(CTT->CTT_FAX )
		cParams += ";CNPJ " + TRANSFORM(CTT->CTT_CGC, "@R 99.999.999/9999-99") + " - Inscr. Est. Isento"
	EndIf
	Commit
	
	
	If cEmpant == '01'      
		CALLCRYS("CRYAF", cParams, cOpcoes)	
	Else
		CALLCRYS("CRYAF_RJ", cParams, cOpcoes)
	EndIf
	*/
	
	IMPGRF(SC7->C7_NUM,cVias,nUsado,nCobranca,nTotal)

ENDIF
Return
                  

Static Function AtuEntrega()

If cEmpant == '01'
	IF nEntrega == 1 
//		cLocalSP := "Rua Tabapua, 540 - CEP 04533-001"
		cLocalSP := "Rua Tabapua, 684 - CEP 04533-001"
	ELSEIF nEntrega == 2
  		cLocalSP	:= 	SPace(100)
		cPedido		:= SC7->C7_NUM
		DBSelectArea("SC7")
		DBSetOrder(1)
		DBSeek(xFilial("SC7")+cPedido,.T.)
		IF SC7->C7_NUM == cPedido
			DBSelectArea("CTT")
			DBSetOrder(1)
			IF DBSeek(xFilial("CTT")+SC7->C7_CC)
				cLocalSP  := OEMTOANSI(ALLTRIM(CTT->CTT_END) + "," + ALLTRIM(CTT->CTT_NUMEND) + " - CEP " + TRANSFORM(CTT->CTT_CEP, "@E 99999-999"))
			ENDIF
		ENDIF
	ELSE
		cLocalSP := SPace(100)
	ENDIF
Else
	IF nEntrega == 1 
		cLocalRJ := "Rua da Constituicao, 67 - CEP 20060-010"
	ELSEIF nEntrega == 2
  		cLocalRJ	:= 	SPace(100)
		cPedido		:= SC7->C7_NUM
		DBSelectArea("SC7")
		DBSetOrder(1)
		DBSeek(xFilial("SC7")+cPedido,.T.)
		IF SC7->C7_NUM == cPedido
			DBSelectArea("CTT")
			DBSetOrder(1)
			IF DBSeek(xFilial("CTT")+SC7->C7_CC)
				cLocalRJ  := OEMTOANSI(ALLTRIM(CTT->CTT_END) + "," + ALLTRIM(CTT->CTT_NUMEND) + " - CEP " + TRANSFORM(CTT->CTT_CEP, "@E 99999-999"))
			ENDIF
		ENDIF
	ELSE
		cLocalRJ := SPace(100)
	ENDIF
EndIf

oLocal:SetFocus()
oLocal:Refresh(.t.)
oEntrega:SetFocus()

RETURN Nil

Static Function SelItem()
If aPags[oLbx1:nAt,1]
	aPags[oLbx1:nAt,1] := .F.
Else
	aPags[oLbx1:nAt,1] := .T.
EndIf
oLbx1:Refresh(.T.)
Return

Static Function VldCodGrupo(cCodGrupo)
        
DBSelectArea("SAL")
DBSetOrder(1)
DBSeek(xFilial("SAL")+cCodGrupo)

While !EOF() .AND. AL_FILIAL == xFilial('SAL') .AND. AL_COD == cCodGrupo
           
	IF MaAlcLim(SAL->AL_APROV,nTotal,1,0)            
		IF SAL->AL_NIVEL == '01'
			aPessoas[2] := PADR(UsrFullName(SAL->AL_USER),40)
		ENDIF
		IF SAL->AL_NIVEL == '02'
			aPessoas[3] := PADR(UsrFullName(SAL->AL_USER),40)
		ENDIF
		IF SAL->AL_NIVEL == '03'
			aPessoas[4] := PADR(UsrFullName(SAL->AL_USER),40)
		ENDIF
		IF SAL->AL_NIVEL == '04'
			aPessoas[5] := PADR(UsrFullName(SAL->AL_USER),40)
		ENDIF
	ENDIF
	SAL->(DBSkip())	
End
          
aPessoas[1]	:= PADR(UsrFullName(SC7->C7_USER),40)

RETURN .T.  

STATIC FUNCTION IMPGRF(cNumped,cVias,nUsado,nCobranca,nTotal)               
LOCAL oPrint	:= NIL
LOCAL cTab		:= ""
LOCAL cQry		:= ""          
LOCAL nCnt		:= 0                   
LOCAL nItens	:= 0 
LOCAL aDados	:= {}
LOCAL aBloq1	:= {}
LOCAL aBloq2	:= {}
LOCAL aBloq3	:= {}
LOCAL aCab		:= {} 
LOCAL aRod		:= {}
LOCAL aItens	:= {} 
LOCAL aTexto	:= {}
LOCAL aTxtEsp1	:= {}      
LOCAL aTxtEsp2	:= {}
LOCAL cDescri	:= ""
LOCAL cDescri	:= ""  
LOCAL nLenDesc	:= 40 
LOCAL nLenObs	:= 130 
LOCAL nTotItens	:= 19  
LOCAL cCnta		:= 0
LOCAL cCntb		:= 0
local cViaAux	:= ""  
local cPtPdf	:= "C:\spool\"  

IF !FILE(cPtPdf)             
	MontaDir(cPtPdf)
ENDIF	
       
DBSelectArea("SM0")
DBSetOrder(1)
DBSeek(cEmpAnt+cFilAnt)

oPrint:=FWMSPrinter():New(cNumPed,6,.F.,"\spool\",.t.,.F.,,,.T.,,,.T.)
oPrint:SetLandscape()
oPrint:cPathPDF:= cPtPdf       
		          
cTab:= GetNextAlias() 

cQry:= " SELECT C7_FILIAL,"+CRLF
cQry+= "     C7_NUM,"+CRLF
cQry+= "     SX5_Z2.X5_DESCRI,"+CRLF
cQry+= "     C7_FORNECE,"+CRLF
cQry+= "     A2_NOME,"+CRLF
cQry+= "     A2_END,"+CRLF
cQry+= "     A2_BAIRRO,"+CRLF
cQry+= "     A2_MUN,"+CRLF
cQry+= "     A2_EST,"+CRLF
cQry+= "     A2_CEP,"+CRLF
cQry+= "     A2_TEL,"+CRLF
cQry+= "     A2_FAX,"+CRLF
cQry+= "     A2_CONTATO,"+CRLF
cQry+= "     A2_CGC,"+CRLF
cQry+= "     C7_EMISSAO,"+CRLF
cQry+= "     C7_ITEM,"+CRLF
cQry+= "     (CASE WHEN SUBSTRING(C7_PRODUTO,4,1)='0' THEN C7_PRODUTO ELSE '' END) C7_PRODUTO,"+CRLF
cQry+= "     B1_DESC,"+CRLF
cQry+= "     COALESCE(CONVERT(VARCHAR(8000),CONVERT(VARBINARY(8000),C7_ESPEC )),'') B1_ESPEC,"+CRLF
cQry+= "     C7_QUANT,"+CRLF
cQry+= "     C7_UM,"+CRLF
cQry+= "     C7_PRECO,"+CRLF
cQry+= "     C7_TOTAL-C7_VLDESC C7_TOTAL,"+CRLF
cQry+= "     C7_NUMSC,"+CRLF
cQry+= "     COALESCE(C1_NUMCIEE,'') C1_NUMCIEE,"+CRLF
cQry+= "     C7_DESC,"+CRLF
cQry+= " 	 C7_DESCRI,"+CRLF
cQry+= "     C7_VLDESC,"+CRLF
cQry+= "     C7_DATPRF,"+CRLF
cQry+= "     C7_CC,"+CRLF
cQry+= "     C7_COND,"+CRLF
cQry+= "     COALESCE(E4_DESCRI, '') E4_DESCRI,"+CRLF
cQry+= "     COALESCE(ZH_PESSOA1, '') ZH_PESSOA1,"+CRLF
cQry+= "     COALESCE(ZH_PESSOA2, '') ZH_PESSOA2,"+CRLF
cQry+= "     COALESCE(ZH_PESSOA3, '') ZH_PESSOA3,"+CRLF
cQry+= "     COALESCE(ZH_PESSOA4, '') ZH_PESSOA4,"+CRLF
cQry+= "     COALESCE(ZH_PESSOA5, '') ZH_PESSOA5,"+CRLF
cQry+= "     COALESCE(ZH_LOCAL, '') ZH_LOCAL,"+CRLF
cQry+= "     COALESCE(CONVERT(VARCHAR(8000),CONVERT(VARBINARY(8000),ZH_OBS )),'') ZH_OBS"+CRLF
cQry+= "FROM "+RETSQLNAME("SC7")+" SC7"+CRLF
cQry+= "     JOIN "+RETSQLNAME("SB1")+" SB1 ON (B1_FILIAL = C7_FILIAL AND B1_COD = C7_PRODUTO  AND SB1.D_E_L_E_T_ = ' ')"+CRLF
cQry+= "     JOIN "+RETSQLNAME("SA2")+" SA2 ON (A2_FILIAL = '  ' AND A2_COD = C7_FORNECE  AND A2_LOJA = C7_LOJA AND SA2.D_E_L_E_T_ = ' ')"+CRLF
cQry+= "     LEFT OUTER JOIN "+RETSQLNAME("SE4")+" SE4 ON (E4_FILIAL = C7_FILIAL AND E4_CODIGO = C7_COND  AND SE4.D_E_L_E_T_ = ' ')"+CRLF
cQry+= "     LEFT OUTER JOIN "+RETSQLNAME("SZH")+" SZH  ON (ZH_FILIAL = C7_FILIAL AND ZH_NUM    = C7_NUM   AND SZH.D_E_L_E_T_ = ' ')"+CRLF
cQry+= "     LEFT OUTER JOIN "+RETSQLNAME("SC8")+" SC8 ON (C8_FILIAL = C7_FILIAL AND C8_NUMPED = C7_NUM AND C8_ITEMPED = C7_ITEM AND C8_PRODUTO = C7_PRODUTO AND C8_FORNECE = C7_FORNECE AND C8_LOJA = C7_LOJA AND SC8.D_E_L_E_T_ = ' ')"+CRLF
cQry+= "     LEFT OUTER JOIN (SELECT DISTINCT C1_FILIAL, C1_NUM, C1_ITEM, C1_NUMCIEE, D_E_L_E_T_ FROM "+RETSQLNAME("SC1")+" AS SC1V WHERE SC1V.D_E_L_E_T_ = ' ') SC1 ON (C1_FILIAL = C7_FILIAL AND C1_NUM    = C7_NUMSC AND C1_ITEM = C7_ITEMSC AND SC1.D_E_L_E_T_ = ' ')"+CRLF
cQry+= "     JOIN "+RETSQLNAME("SX5")+" SX5_Z2 ON (SX5_Z2.X5_TABELA = 'Z2' AND LEFT(SX5_Z2.X5_CHAVE,2) IN "+formatin(cVias,";")+" AND SX5_Z2.D_E_L_E_T_ = ' ')"+CRLF
cQry+= "WHERE   C7_FILIAL='"+xFilial("SC7")+"'"+CRLF
cQry+= "     AND C7_NUM='"+cNumped+"'"+CRLF
cQry+= "     AND SC7.D_E_L_E_T_ = ' '"+CRLF
cQry+= "ORDER BY C7_FILIAL,C7_NUM,SX5_Z2.X5_DESCRI,C7_ITEM"+CRLF 

TcQuery cQry NEW ALIAS (cTab)
TcSetField(cTab,"C7_DATPRF","D")
TcSetField(cTab,"C7_EMISSAO","D")
     
(cTab)->(dbSelectArea((cTab))) 

cViaAux:= TRIM((cTab)->X5_DESCRI)
                   
(cTab)->(dbGoTop())                               	
WHILE (cTab)->(!EOF())  
	
	IF cViaAux != TRIM((cTab)->X5_DESCRI) 
		cViaAux := TRIM((cTab)->X5_DESCRI)  
		AADD(aDados,{aCab,aItens,aRod})				
		aItens	:= {}
		aCab	:= {}
		aRod	:= {}
		nItens	:= 0	
	ENDIF 
	
	IF nItens > nTotItens 
		AADD(aDados,{aCab,aItens,aRod})				
		aItens:= {}
		nItens:= 0	
	ENDIF
	
	IF EMPTY(aCab)                 
		IF !EMPTY((cTab)->C7_CC) .AND. nCobranca == 2
			DBSelectArea("CTT")
			DBSetOrder(1)
			IF DBSeek(xFilial("CTT")+(cTab)->C7_CC) 					
						
		    	aBloq1:= {	LEFT(SM0->M0_NOMECOM,AT("-",SM0->M0_NOMECOM)-1) ,;
		    				Alltrim(Substr(CTT->CTT_END,1,38)) + "," + ALLTRIM(CTT->CTT_NUMEND),;
		    				TRIM(CTT->CTT_MUN)+" - "+TRIM(CTT->CTT_EST)+" - CEP " + TRANSFORM(CTT->CTT_CEP, "@R 99999-999"),;
		    				"PABX("+TRIM(CTT->CTT_DDD)+") " + alltrim(CTT->CTT_TEL) + " - Fax " + alltrim(CTT->CTT_FAX ),;
		    				"CNPJ " + TRANSFORM(CTT->CTT_CGC, "@R 99.999.999/9999-99") + " - Inscr. Est. Isento"}			
			ENDIF
    	ENDIF
    	
    	IF EMPTY(aBloq1)
    	 
	    	aBloq1:= {	LEFT(SM0->M0_NOMECOM,AT("-",SM0->M0_NOMECOM)-1) ,;
	    				LEFT(SM0->M0_ENDENT,AT("-",SM0->M0_ENDENT)-1)+" - "+TRIM(SM0->M0_CIDENT)+" - "+TRIM(SM0->M0_ESTENT)+" - CEP "+TRIM(SM0->M0_CEPENT),;
	    				"PABX(11) 3040-9487 / 9914 - Fax " + TRANSFORM(alltrim(SM0->M0_FAX ), "@R 9999-9999"),;
	    				"CNPJ " + TRANSFORM(SM0->M0_CGC, "@R 99.999.999/9999-99") + " - Inscr. Est. "+TRANSFORM(SM0->M0_INSC, "@R 999.999.999.999"),;
	    				""}
    	ENDIF			
    	
		//Bloco fornecedor  
		aTexto := GRFQBRA(0,(cTab)->A2_NOME,30)		 
    	
    	aBloq2:= {	"Fornecedor:",;
    				aTexto,;
    				(cTab)->A2_END,;
    				TRIM((cTab)->A2_BAIRRO)+"  "+TRIM((cTab)->A2_MUN)+" - "+(cTab)->A2_EST,;
    				"Tel :"+TRIM((cTab)->A2_TEL)+" Fax :"+TRIM((cTab)->A2_FAX),;
    				"CNPJ :"+ TRANSFORM((cTab)->A2_CGC, "@R 99.999.999/9999-99"),;
    				"Contato :"+TRIM((cTab)->A2_CONTATO)}   
    				
		//Bloco pedido     
    	aBloq3:= {	"AUTORIZAÇÃO DE FORNECIMENTO",;
    				"No.  "+strtran(LTRIM(TRANSFORM(VAL((cTab)->C7_NUM), "@R 999,999")),",","."),;
    				TRIM(SM0->M0_CIDENT)+", "+cvaltochar(day((cTab)->C7_EMISSAO))+" de "+MesExtenso(Month((cTab)->C7_EMISSAO))+" de "+cvaltochar(year((cTab)->C7_EMISSAO))}      				    				  				    				
    				
    	aCab:= {aBloq1,aBloq2,aBloq3} 
    	
    	aTexto := {}
    	aTexto := StrTokArr(UPPER((cTab)->ZH_OBS),CRLF,.T.)   
	  		                    
		aRod:= {"Condição de Pagamento",; 
				SUBSTR(TRIM((cTab)->E4_DESCRI),1,25),;
				"Comprador:",;
				TRIM((cTab)->ZH_PESSOA1),;
				"Local de Entrega",;
				SUBSTR(TRIM(UPPER((cTab)->ZH_LOCAL)),1,80),;
				aTexto,;   
				"Supervisão",;
				TRIM((cTab)->ZH_PESSOA2),;
				"Valores em Reais",;
				"TOTAL",;
				TRANSFORM(nTotal,PESQPICT("SC7","C7_TOTAL")),;   
				"Gerencia",;
				TRIM((cTab)->ZH_PESSOA3),;
				"Superintendência",;
				TRIM((cTab)->ZH_PESSOA4),;  
				"Presidência",; 
				TRIM((cTab)->ZH_PESSOA5),; 
				TRIM((cTab)->X5_DESCRI),;
				""}
				    	
	ENDIF
     
	aTexto	:={}
	aTxtEsp1:= StrTokArr(SUBCARAC(1,(cTab)->C7_DESCRI),CRLF,.T.) 
	
  	FOR cCnta:= 1 TO LEN(aTxtEsp1) 
  		
  		IF LEN(aTxtEsp1[cCnta]) <= nLenDesc
  			AADD(aTexto,{1,aTxtEsp1[cCnta]})
  		ELSE 
	  		aTxtEsp2:= StrTokArr(aTxtEsp1[cCnta]," ",.T.)
	  		cDescri := ""
	  		FOR cCntb:= 1 TO LEN(aTxtEsp2)
	  			IF LEN(cDescri) <= nLenDesc
	  				cDescri+= aTxtEsp2[cCntb]+" " 
	  				IF cCntb == LEN(aTxtEsp2)
		  				AADD(aTexto,{1,cDescri})
	  				ENDIF		  				
	  			ELSE    
	  				AADD(aTexto,{1,cDescri})
	  				cDescri := ""  
	  				cDescri+= aTxtEsp2[cCntb]+" "
	  				IF cCntb == LEN(aTxtEsp2)
	  					AADD(aTexto,{1,cDescri})	
	  				Endif 
	  			ENDIF		  		
	  		NEXT cCntb  
  		ENDIF
  	NEXT cCnta  
  	
  	IF nUsado == 1 
  		aTxtEsp1 := StrTokArr(SUBCARAC(2,UPPER((cTab)->B1_ESPEC)),CRLF,.T.) // StrTokArr(strTran(strTran((cTab)->B1_ESPEC,"’","'"),"–","|"),CRLF,.T.)
  		
	  	FOR cCnta:= 1 TO LEN(aTxtEsp1) 
	  		
	  		IF LEN(aTxtEsp1[cCnta]) <= nLenDesc
	  			AADD(aTexto,{2,aTxtEsp1[cCnta]})
	  		ELSE 
		  		aTxtEsp2:= StrTokArr(aTxtEsp1[cCnta]," ",.T.)
		  		cDescri := ""
		  		FOR cCntb:= 1 TO LEN(aTxtEsp2)
		  			IF LEN(cDescri) <= nLenDesc
		  				cDescri+= aTxtEsp2[cCntb]+" " 
		  				IF cCntb == LEN(aTxtEsp2)
			  				AADD(aTexto,{2,cDescri})
		  				ENDIF		  				
		  			ELSE    
		  				AADD(aTexto,{2,cDescri})
		  				cDescri := ""  
		  				cDescri+= aTxtEsp2[cCntb]+" "
		  				IF cCntb == LEN(aTxtEsp2)
		  					AADD(aTexto,{1,cDescri})	
		  				Endif 		  				
		  			ENDIF		  		
		  		NEXT cCntb  
	  		ENDIF	  		
	  	NEXT cCnta
  	ENDIF
  	
  	FOR cCnta:= 1 TO LEN(aTexto)
		IF nItens == nTotItens 
			AADD(aDados,{aCab,aItens,aRod})				
			aItens:= {}
			nItens:= 0 
			cCnta:= cCnta - 1				
		ELSEIF cCnta == 1
			aadd(aItens,{ 	(cTab)->C7_ITEM ,;
							(cTab)->C7_NUMSC ,;
							(cTab)->C7_CC ,;
							(cTab)->C7_PRODUTO,;
							aTexto[cCnta][2] ,;
							IIF((cTab)->C7_QUANT>0,cvaltochar((cTab)->C7_QUANT),"")  ,;
							(cTab)->C7_UM ,;
							TRANSFORM((cTab)->C7_PRECO,PESQPICT("SC7","C7_PRECO")) ,;
							IIF((cTab)->C7_VLDESC>0,TRANSFORM((cTab)->C7_VLDESC,PESQPICT("SC7","C7_VLDESC")),"") ,;
							IIF((cTab)->C7_QUANT>0,TRANSFORM((cTab)->C7_TOTAL,PESQPICT("SC7","C7_TOTAL")),"")  ,;
							dtoc((cTab)->C7_DATPRF),;
							aTexto[cCnta][1]}) 
			nItens++				 
		ELSE
			aadd(aItens,{ 	"" ,;
							"" ,;
							"" ,;
							"" ,;
							aTexto[cCnta][2] ,;
							"" ,;
							"" ,;
							"" ,;
							"" ,;
							"" ,;
							"",;
							aTexto[cCnta][1]}) 											
			nItens++
		ENDIF	  	
  	NEXT cCnta	       	     
	
(cTab)->(dbSkip())	
ENDDO  
(cTab)->(dbCloseArea())                                                   

IF nItens > 0 .and. LEN(aItens) > 0
	AADD(aDados,{aCab,aItens,aRod})
ENDIF                         
    
IF !EMPTY(aDados)
	
	FOR nX:= 1 TO LEN(aDados)
		aDados[nX][3][20]:= "Página "+cvaltochar(nX)+" de "+cvaltochar(LEN(aDados))
		oPrint:StartPage()
		GRFLAY(oPrint,aDados[nX][1],aDados[nX][2],aDados[nX][3])     
		oPrint:EndPage()	
	NEXT nX
	                 
	oPrint:Print() 	    
ENDIF                

FreeObj(oPrint)

                               
RETURN                  

STATIC FUNCTION GRFLAY(oPrint,aCab,aItens,aRod)     
LOCAL nLin		:= 0  
LOCAL nLin2		:= 0 
LOCAL nItem		:= 0
LOCAL oFont1 	:= TFont():New('Times New Roman',,-12,.T.)
LOCAL oFont2 	:= TFont():New('Times New Roman',,-14,.T.)
LOCAL oFont3 	:= TFont():New('Times New Roman',,-14,.T.,.T.)  
LOCAL oFont4 	:= TFont():New('Times New Roman',,-11,.T.)
Local cLogo     := FisxLogo("1")             

oPrint:Line(20,15,20,820,,"+1") 
oPrint:Line(140,15,140,820,,"+1")
oPrint:Line(20,15,140,15,,"+1")
oPrint:Line(20,820,140,820,,"+1")         

//Bloco empresa                
oPrint:SayBitmap(30,130,cLogo,50,30) 

oPrint:SayAlign(65,30, aCab[1][1] ,oFont1,250, , , 2, 0 )
oPrint:SayAlign(85,30, aCab[1][2] ,oFont1,250, , , 2, 0 )
oPrint:SayAlign(95,30, aCab[1][3] ,oFont1,250, , , 2, 0 )
oPrint:SayAlign(105,30, aCab[1][4] ,oFont1,250, , , 2, 0 )
oPrint:SayAlign(115,30, aCab[1][5] ,oFont1,250, , , 2, 0 )


oPrint:Line(20,300,150,300,,"+1")   

//Bloco fornecedor
oPrint:SAY(40,305,aCab[2][1],oFont1) 
//oPrint:SAY(55,305,aCab[2][2],oFont1) 

FOR nItem:= 1 TO LEN(aCab[2][2])
	if nItem == 1  
		IF LEN(aCab[2][2]) == 1   
			oPrint:SAY(55,305,aCab[2][2][nItem][2],oFont1)			 
		ELSE 
			oPrint:SAY(40,355,aCab[2][2][nItem][2],oFont1)
		ENDIF	
	elseif nItem == 2
		oPrint:SAY(55,305,aCab[2][2][nItem][2],oFont1) 
		exit	
	endif	
NEXT nItem 

oPrint:SAY(70,305,aCab[2][3],oFont1)
oPrint:SAY(85,305,aCab[2][4],oFont1)
oPrint:SAY(100,305,aCab[2][5],oFont1)
oPrint:SAY(115,305,aCab[2][6],oFont1)
oPrint:SAY(130,305,aCab[2][7],oFont1)

//Bloco pedido     
oPrint:Line(20,600,150,600,,"+1")
oPrint:Line(95,600,95,820,,"+1")
oPrint:SAY(45,612,aCab[3][1],oFont3)
oPrint:SAY(65,680,aCab[3][2],oFont3)
oPrint:SAY(115,640,aCab[3][3],oFont1)
 
//Bloco autorizacao    
oPrint:Box(140,15,152,820,"+1")  
oPrint:SAY(149,220,"Autorizamos o fornecimento de acordo com as necessidades abaixo e Condições Gerais de Fornecimento",oFont1)

//Bloco itens
oPrint:Box(152,15,165,820,"+1")
oPrint:SAY(161,18,"Item",oFont1) 
oPrint:SAY(161,53,"SC",oFont1) 
oPrint:SAY(161,100,"CR",oFont1)
oPrint:SAY(161,163,"Código",oFont1)
oPrint:SAY(161,330,"Discriminação",oFont1) 
oPrint:SAY(161,528,"Quant.",oFont1)
oPrint:SAY(161,570,"Un.",oFont1) 
oPrint:SAY(161,595,"Preço Unitário",oFont1) 
oPrint:SAY(161,660,"Desconto",oFont1)
oPrint:SAY(161,730,"Total",oFont1) 
oPrint:SAY(161,782,"Entrega",oFont1) 
oPrint:Box(165,15,568,820,"+1")
oPrint:Line(152,40,458,40,,"+1")
oPrint:Line(152,75,458,75,,"+1")
oPrint:Line(152,140,458,140,,"+1")

oPrint:Line(152,215,458,215,,"+1")


oPrint:Line(152,510,458,510,,"+1")
oPrint:Line(152,565,458,565,,"+1")
oPrint:Line(152,590,458,590,,"+1")
oPrint:Line(152,650,458,650,,"+1")
oPrint:Line(152,705,458,705,,"+1")  
oPrint:Line(152,773,458,773,,"+1")
oPrint:Line(458,15,458,820,,"+1")

nLin:= 175
FOR nItem:= 1 TO LEN(aItens)
	
	
	if aItens[nItem][12] == 2
	   	oPrint:SAY(nLin,18			, aItens[nItem][1]			,oFont4)
		oPrint:SAY(nLin,43			, aItens[nItem][2]			,oFont4)
		oPrint:SAY(nLin,78			, aItens[nItem][3] 			,oFont4)
		oPrint:SAY(nLin,143			, aItens[nItem][4]			,oFont4)
		oPrint:SAY(nLin,218			, aItens[nItem][5]			,oFont4)
		oPrint:SayAlign(nLin-10,480	, aItens[nItem][6]			,oFont4,80, , , 1, 0 )
		oPrint:SAY(nLin,570			, aItens[nItem][7] 			,oFont4)
		oPrint:SayAlign(nLin-10,565	, aItens[nItem][8]			,oFont4,80, , , 1, 0 )
		oPrint:SayAlign(nLin-10,620	, aItens[nItem][9]			,oFont4,80,,,1)
		oPrint:SayAlign(nLin-10,690	, aItens[nItem][10]			,oFont4,80,,,1)
		oPrint:SAY(nLin,774			, aItens[nItem][11]			,oFont4)
	     
		nLin+= 10
	
	ELSE 
		
		IF nItem > 1
			IF aItens[nItem-1][12] == 2
				nLin+= 5
			ENDIF		
		ENDIF
		
	   	oPrint:SAY(nLin,18			, aItens[nItem][1]			,oFont1)
		oPrint:SAY(nLin,43			, aItens[nItem][2]			,oFont1)
		oPrint:SAY(nLin,78			, aItens[nItem][3] 			,oFont1)
		oPrint:SAY(nLin,143			, aItens[nItem][4]			,oFont1)
		oPrint:SAY(nLin,218			, aItens[nItem][5]			,oFont1)
		oPrint:SayAlign(nLin-10,480	, aItens[nItem][6]			,oFont1,80, , , 1, 0 )
		oPrint:SAY(nLin,570			, aItens[nItem][7] 			,oFont1)
		oPrint:SayAlign(nLin-10,565	, aItens[nItem][8]			,oFont1,80, , , 1, 0 )
		oPrint:SayAlign(nLin-10,620	, aItens[nItem][9]			,oFont1,80,,,1)
		oPrint:SayAlign(nLin-10,690	, aItens[nItem][10]			,oFont1,80,,,1)
		oPrint:SAY(nLin,774			, aItens[nItem][11]			,oFont1)
	     
		nLin+= 15	
	endif	        
	
NEXT nItem                                          
                
nLin:= -10                   				
oPrint:SAY(nLin+478,20,aRod[1],oFont1)
oPrint:SAY(nLin+493,20,aRod[2],oFont1)


oPrint:SAY(nLin+478,198,aRod[5],oFont1)
oPrint:SAY(nLin+490,198,aRod[6],oFont1)

nLin2:= 499      
oPrint:SayAlign(nLin+nLin2,198	, "Obs.: ",oFont1,650,,,0)
FOR nItem:= 1 TO LEN(aRod[7])
	oPrint:SayAlign(nLin+nLin2,230	, TRIM(aRod[7][nItem]) ,oFont1,650,,,0)			 
	nLin2+= 15
NEXT nItem

oPrint:SAY(nLin+485,525,aRod[10],oFont1)

oPrint:Line(nLin+468,620,nLin+496,620,,"+1")
oPrint:SAY(nLin+485,635,aRod[11],oFont3)
oPrint:SayAlign(nLin+475,700, aRod[12] ,oFont3,80,,,1) 
oPrint:Line(nLin+496,195,nLin+496,820,,"+1")
oPrint:Line(nLin+468,510,nLin+496,510,,"+1")

nLin+= 30                            

oPrint:Line(nLin+438,195,nLin+548,195,,"+1")
oPrint:Line(nLin+514,15,nLin+514,820,,"+1")
oPrint:SAY(nLin+524,20,aRod[3],oFont1)
oPrint:SAY(nLin+539,20,aRod[4],oFont1)

oPrint:SAY(nLin+524,198,aRod[8],oFont1) 
oPrint:SAY(nLin+539,198,aRod[9],oFont1)

/////


oPrint:Line(nLin+514,343,nLin+548,343,,"+1")
oPrint:SAY(nLin+524,346,aRod[13],oFont1)
oPrint:SAY(nLin+539,346,aRod[14],oFont1)

oPrint:Line(nLin+514,510,nLin+548,510,,"+1")
oPrint:SAY(nLin+524,513,aRod[15],oFont1)
oPrint:SAY(nLin+539,513,aRod[16],oFont1)

oPrint:Line(nLin+514,670,nLin+548,670,,"+1")
oPrint:SAY(nLin+524,673,aRod[17],oFont1)
oPrint:SAY(nLin+539,673,aRod[18],oFont1)

oPrint:SAY(nLin+556,50,aRod[19],oFont1)
oPrint:SAY(nLin+556,710,aRod[20],oFont1)

RETURN   

static function GRFQBRA(nIdent,cDescri,nLenDesc)
LOCAL aTexto	:= {}
LOCAL aTxtEsp1	:= {}      
LOCAL aTxtEsp2	:= {}
LOCAL cDesAux	:= ""

aTxtEsp1:= StrTokArr(cDescri,CRLF,.T.) 

FOR cCnta:= 1 TO LEN(aTxtEsp1) 
  		
	IF LEN(aTxtEsp1[cCnta]) <= nLenDesc
  		AADD(aTexto,{nIdent,aTxtEsp1[cCnta]})
 	ELSE 
  		aTxtEsp2:= StrTokArr(aTxtEsp1[cCnta]," ",.T.)
  		cDesAux := ""
  		FOR cCntb:= 1 TO LEN(aTxtEsp2)
  			IF LEN(cDesAux) <= nLenDesc
  				cDesAux+= aTxtEsp2[cCntb]+" " 
  				IF cCntb == LEN(aTxtEsp2)
  					AADD(aTexto,{nIdent,cDesAux})
  				ENDIF		  				
  			ELSE    
  				AADD(aTexto,{1,cDesAux})
  				cDesAux := ""  
  				cDesAux+= aTxtEsp2[cCntb]+" "
  			ENDIF		  		
  		NEXT cCntb  
	ENDIF
NEXT cCnta 
  	
return aTexto    

static function SUBCARAC(nTipo,cDescri)
local nCnt		:= 0
local aCharDe 	:= {}
local aCharPara := {}  

if nTipo == 1  // Descrição do produto

	aCharDe 	:= {"/"	  ,'“','”'} 
	aCharPara 	:= {" / " ,'"','"'}

elseif nTipo == 2 // Especificação do produto

	aCharDe 	:= {'’','–'}  
	aCharPara 	:= {"'",'|'}  

endif

// O tamanho do array tem que ser igual
if len(aCharDe) == len(aCharPara)                
	for nCnt:= 1 to len(aCharDe)
		cDescri:= strTran(cDescri,aCharDe[nCnt],aCharPara[nCnt])
	next nCnt    	
endif

return cDescri