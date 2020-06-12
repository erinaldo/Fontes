#include "PROTHEUS.CH"
#INCLUDE "TOPCONN.CH"

User Function A120PC()
Local oOk   		:= LoadBitmap( GetResources(), "LBOK" )
Local oNo   		:= LoadBitmap( GetResources(), "LBNO" )
Local lOk			:= .F.
Local cGrupo		:= "000001"
Local oBold
Local cParams		:= ""
Local cOpcoes		:= "1;0;1;Autorização de Fornecimento"

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
_cQuery += " SUM(C7_TOTAL) C7_TOTAL"
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

	cParams	:= xFilial("SC7") + ";" + SC7->C7_NUM + ";" +  SC7->C7_NUM 

	IF aPags[1,1] 
		cParams += ";01"
	ELSE
		cParams += ";00"
	ENDIF

	IF aPags[2,1] 
		cParams += ";02"
	ELSE
		cParams += ";00"
	ENDIF

	IF aPags[3,1] 
		cParams += ";03"
	ELSE
		cParams += ";00"
	ENDIF

	IF aPags[4,1] 
		cParams += ";04"
	ELSE
		cParams += ";00"
	ENDIF

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
		
		/*
		Devido ao tamanho muito grande da string de parâmetros, foi feita a divisão do
		endereco em dois parâmetros. Felipe, em 12/08/04  
		*/
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