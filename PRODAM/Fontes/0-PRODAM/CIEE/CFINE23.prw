#Include 'Protheus.ch'
//---------------------------------------------------------------------------------------
/*/{Protheus.doc} CFINE23
Monta tela de consulta da aprovação do bordero
@author  	Totvs
@since     	01/01/2015
@version  	P.11.8      
@return   	Nenhum 
/*/
//---------------------------------------------------------------------------------------
User Function CFINE23() 
LOCAL oDlg		:= NIL 
LOCAL oGetD	:= NIL
LOCAL nAcols 	:= 0
LOCAL cSituaca:= ""
LOCAL lBloq 	:= .F.
LOCAL cStatus	:= SE2->E2_XSTSAPV
LOCAL oBold  	:= NIL                             
LOCAL nUsado	:=	0
LOCAL lContinua:= .T.  
LOCAL cUsuario:= UsrRetName(SE2->E2_XSOLAPV)   
LOCAL cChave 	:= xFilial("SCR")+"BP"+SE2->E2_NUMBOR
LOCAL aCols 	:= {}
LOCAL aHeader	:= {}   
LOCAL cTitulo	:= "Bordero de pagamento"

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Abre o arquivo SCR sem filtros    ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
ChkFile("SCR",.F.,"TMP")

dbSelectArea("TMP")
dbSetOrder(1)
dbSeek(cChave,.F.)

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Faz a montagem do aHeader com os campos fixos.               ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
dbSelectArea("SX3")
dbSetOrder(1)
dbSeek("SCR")
While !EOF() .And. (x3_arquivo == "SCR")
	IF AllTrim(x3_campo)$"CR_NIVEL/CR_OBS/CR_DATALIB"
		nUsado++
		AADD(aHeader,{ TRIM(x3titulo()), x3_campo, x3_picture,;
			       x3_tamanho, x3_decimal, x3_valid,;
			       x3_usado, x3_tipo, x3_arquivo, x3_context } )
		If AllTrim(x3_campo) == "CR_NIVEL"
			AADD(aHeader,{"Usuario","bCR_NOME", "@",;    
			     15, 0, "","","C","",""} )
			nUsado++		
			AADD(aHeader,{"Situacao","bCR_SITUACA", "@",;    
			     20, 0, "","","C","",""} )
			nUsado++						
			AADD(aHeader,{"Usuario Lib.","bCR_NOMELIB", "@",;    
			     15, 0, "","","C","",""} )
			nUsado++						
		EndIf					 
	Endif
dbSkip()
End          
    
IF !EMPTY(cStatus)
	dbSelectArea("TMP")
	While !Eof() .And. cChave$CR_FILIAL+CR_TIPO+Alltrim(CR_NUM)
		aadd(aCols,Array(nUsado+1))
		nAcols ++
		For nCntFor := 1 To nUsado
			If aHeader[nCntFor][02] == "bCR_NOME"
				aCols[nAcols][nCntFor] := UsrRetName(TMP->CR_USER)
			ElseIf aHeader[nCntFor][02] == "bCR_SITUACA"
			   Do Case
					Case TMP->CR_STATUS == "01"
						cSituaca   := IIF(lBloq,"Bloqueado","Aguardando Lib") 
					Case TMP->CR_STATUS == "02"
						cSituaca := "Em Aprovacao"
					Case TMP->CR_STATUS == "03"
						cSituaca := "Aprovado"
					Case TMP->CR_STATUS == "04"
						cSituaca := "Bloqueado"
						lBloq := .T.
					Case TMP->CR_STATUS == "05"
						cSituaca := "Nivel Liberado "
					EndCase
				aCols[nAcols][nCntFor] := cSituaca
			ElseIf aHeader[nCntFor][02] == "bCR_NOMELIB"
				aCols[nAcols][nCntFor] := UsrRetName(TMP->CR_USERLIB)			
			ElseIf ( aHeader[nCntFor][10] != "V")
				aCols[nAcols][nCntFor] := FieldGet(FieldPos(aHeader[nCntFor][2]))
			EndIf
		Next nCntFor
		aCols[nAcols][nUsado+1] := .F.
	dbSkip()
	EndDo          
ENDIF

If Empty(aCols)
	Aviso("Atencao","Este titulo não possui "+cTitulo+" em aprovação.",{"Voltar"})
	lContinua := .F.
EndIf
    
If lBloq
	cStatus := cTitulo+" BLOQUEADA" 
EndIf

IF lContinua
	DEFINE FONT oBold NAME "Arial" SIZE 0, -12 BOLD
	DEFINE MSDIALOG oDlg TITLE cCadastro From 109,95 To 400,600 OF oMainWnd PIXEL	
		@ 5,3 TO 32,250 LABEL "" OF oDlg PIXEL
		@ 15,7 SAY "Bordero:" Of oDlg FONT oBold PIXEL SIZE 46,9  
		@ 14,32 MSGET SE2->E2_NUMBOR Picture "@"  When .F. PIXEL SIZE 38,9 Of oDlg FONT oBold
		@ 15,103 SAY "Usuário:" Of oDlg PIXEL SIZE 33,9 FONT oBold 
		@ 14,138 MSGET cUsuario Picture "@" When .F. of oDlg PIXEL SIZE 103,9 FONT oBold
		@ 132,8 SAY "Situação:" Of oDlg PIXEL SIZE 52,9 
		@ 132,38 SAY cSituaca Of oDlg PIXEL SIZE 120,9 FONT oBold
		@ 132,205 BUTTON "Fechar" SIZE 35 ,10  FONT oDlg:oFont ACTION (oDlg:End()) Of oDlg PIXEL  
		oGetD:=MsNewGetDados():New(38,3,120,250,1,"AllwaysTrue","AllwaysTrue",,,,999,,,,oDlg,aHeader,aCols)	
	   @ 126,2   TO 127,250 LABEL '' OF oDlg PIXEL
	ACTIVATE MSDIALOG oDlg CENTERED
ENDIF

dbSelectArea("TMP")
dbCloseArea("TMP")

RETURN