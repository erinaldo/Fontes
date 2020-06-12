#Include "Protheus.ch"
#Include "Topconn.ch"

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³ FIESTA01 ºAutor  ³TOTVS               º Data ³  28/11/11   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³Funcao para Liberacao de documentos.                        º±±
±±º          ³Funcao vem do programa FICOMA01                             º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ FIESP                                                      º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

User Function FIESTA01(_nOpcao)
// _nOpcao = 1 / Consulta
// _nOpcao = 2 / Liberacao
// _nOpcao = 3 / Estornar
// _nOpcao = 4 / Consulta Aprovacao
Local _aArea	:= {}
Local _aAreaCR	:= {}
Local _cDoc		:= ""
Local _nTamDoc 	:= TamSx3("CP_NUM")[1]           
Private lCopia 	:= .F.

If _nOpcao == 1 // Consulta
	
	_aArea := GetArea()
	_aAreaCR := SCR->(GetArea())
	_cDoc := Left(SCR->CR_NUM,_nTamDoc)
	SCP->(DbSetOrder(1))
	If SCP->(DbSeek(xFilial("SCP")+_cDoc))
		DbSelectArea("SCP")
		A105Visual("SCP",RecNo(),2)
	EndIf
	RestArea(_aAreaCR)
	RestArea(_aArea)
	
ElseIf _nOpcao == 2 // Liberacao
	
	fLibSA("SCR",RecNo(),_nOpcao)
	
ElseIf _nOpcao == 3 // Estornar
	
	fEstSA()
	
ElseIf _nOpcao == 4 // Consulta Aprovacao
	
	_aArea := GetArea()
	_aAreaCR := SCR->(GetArea())
	fPosic("SCP",Recno(),2,"SA")
	RestArea(_aAreaCR)
	RestArea(_aArea)
	
EndIf

Return

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³fLibSA    ºAutor  ³TOTVS               º Data ³  20/07/11   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³Funcao para Liberacao de edital.                            º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ FIESP                                                      º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
Static Function fLibSA(cAlias,nReg,nOpcx)
Local _cCodUser	:= ""  //Codigo do usuario de retorno
Local _lEnvMail := .T.
Local _aArea	:= GetArea()
Local _aAreaSC	:= SCP->(GetArea())
Local cCodLiber := SCR->CR_APROV
Local cDocto    := SCR->CR_NUM
Local cTipo     := SCR->CR_TIPO
Local aSize		:= {290,410}
Local cObs 		:= IIF(!Empty(SCR->CR_OBS),SCR->CR_OBS,CriaVar("CR_OBS"))
Local ca097User := RetCodUsr()
Local dRefer 	:= dDataBase
Local aRetSaldo	:= {}
Local nSaldo	:= 0
Local CRoeda	:= ""
Local nTotal	:= 0
Local nSalDif	:= 0
Local _cDoc		:= ""
local _nTamDoc 	:= TamSx3("CP_NUM")[1]
Local cName		:= ""
Local nOpc		:= 0
Local lLiberou	:= .F.                  
Local cGrupo	:= ""

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Inicializa as variaveis utilizadas no Display.               ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
aRetSaldo 	:= MaSalAlc(cCodLiber,dRefer)
nSaldo 	  	:= aRetSaldo[1]
CRoeda 	  	:= A097Moeda(aRetSaldo[2])
cName  	  	:= UsrRetName(ca097User)
nTotal    	:= xMoeda(SCR->CR_TOTAL,SCR->CR_MOEDA,aRetSaldo[2],SCR->CR_EMISSAO,,SCR->CR_TXMOEDA)
nSalDif		:= nSaldo - nTotal

Do Case
	Case SAK->AK_TIPO == "D"
		cTipoLim :=OemToAnsi("Diario")
	Case  SAK->AK_TIPO == "S"
		cTipoLim := OemToAnsi("Semanal")
	Case  SAK->AK_TIPO == "M"
		cTipoLim := OemToAnsi("Mensal")
	Case  SAK->AK_TIPO == "A"
		cTipoLim := OemToAnsi("Anual")
EndCase

_cDoc := Left(SCR->CR_NUM,_nTamDoc)
SCP->(DbSetOrder(1))
SCP->(DbSeek(xFilial("SCP")+_cDoc))
cGrupo	:= SCP->CP_XAPROV

DEFINE MSDIALOG oDlg FROM 0,0 TO aSize[1],aSize[2] TITLE OemToAnsi("Liberacao de SA") PIXEL
@ 0.5,01 TO 44,204 LABEL "" OF oDlg PIXEL
@ 45,01  TO 128,204 LABEL "" OF oDlg PIXEL
@ 07,06  Say OemToAnsi("Numero do Docto.") OF oDlg PIXEL
@ 07,120 Say OemToAnsi("Emissao") OF oDlg SIZE 50,9 PIXEL
@ 19,06  Say OemToAnsi("Centro de Custo") OF oDlg PIXEL
@ 31,06  Say OemToAnsi("Aprovador") OF oDlg PIXEL SIZE 30,9
@ 31,120 Say OemToAnsi("Data de ref. ") SIZE 60,9 OF oDlg PIXEL
@ 53,06  Say OemToAnsi("Limite min.  ") +CRoeda OF oDlg PIXEL
@ 53,110 Say OemToAnsi("Limite max. ")+CRoeda SIZE 60,9 OF oDlg PIXEL
@ 65,06  Say OemToAnsi("Limite  ")+CRoeda  OF oDlg PIXEL
@ 65,110 Say OemToAnsi("Tipo lim.") OF oDlg PIXEL
@ 77,06  Say OemToAnsi("Saldo na data  ")+CRoeda OF oDlg PIXEL
If SCR->CR_MOEDA == aRetSaldo[2]
	@ 89,06 Say OemToAnsi("Total do documento ")+CRoeda OF oDlg PIXEL
Else
	@ 89,06 Say OemToAnsi("Total do documento, convertido em ")+CRoeda OF oDlg PIXEL
EndIf
@ 101,06 Say OemToAnsi("Saldo disponivel apos liberacao  ") +CRoeda SIZE 130,10 OF oDlg PIXEL
@ 113,06 Say OemToAnsi("Observa‡äes ") SIZE 100,10 OF oDlg PIXEL
@ 07,58  MSGET SCR->CR_NUM     When .F. SIZE 28 ,9 OF oDlg PIXEL
@ 07,155 MSGET SCR->CR_EMISSAO When .F. SIZE 45 ,9 OF oDlg PIXEL
@ 19,45  MSGET SCP->CP_CC      When .F. SIZE 155,9 OF oDlg PIXEL
@ 31,45  MSGET cName           When .F. SIZE 50 ,9 OF oDlg PIXEL
@ 31,155 MSGET oDataRef VAR dRefer When .F. SIZE 45 ,9 OF oDlg PIXEL
@ 53,50  MSGET SAK->AK_LIMMIN Picture "@E 999,999,999.99" When .F. SIZE 55,9 OF oDlg PIXEL RIGHT
@ 53,155 MSGET SAK->AK_LIMMAX Picture "@E 999,999,999.99" When .F. SIZE 45,9 OF oDlg PIXEL RIGHT
@ 65,50  MSGET SAK->AK_LIMITE Picture "@E 999,999,999.99" When .F. SIZE 55,9 OF oDlg PIXEL RIGHT
@ 65,155 MSGET cTipoLim When .F. SIZE 45,9 OF oDlg PIXEL CENTERED
@ 77,115 MSGET oSaldo VAR nSaldo Picture "@E 999,999,999.99" When .F. SIZE 85,9 OF oDlg PIXEL RIGHT
@ 89,115 MSGET nTotal Picture "@E 999,999,999.99" When .F. SIZE 85,9 OF oDlg PIXEL RIGHT
@ 101,115 MSGET oSaldif VAR nSalDif Picture "@E 999,999,999.99" When .F. SIZE 85,9 OF oDlg PIXEL RIGHT
@ 113,115 MSGET cObs Picture "@!" SIZE 85,9 OF oDlg PIXEL

@ 132, 80 BUTTON OemToAnsi("Libera Docto")   SIZE 40 ,11  FONT oDlg:oFont ACTION (nOpc:=2,oDlg:End())  OF oDlg PIXEL
@ 132,121 BUTTON OemToAnsi("Cancela")        SIZE 40 ,11  FONT oDlg:oFont ACTION (nOpc:=1,oDlg:End())  OF oDlg PIXEL
@ 132,162 BUTTON OemToAnsi("Bloqueia Docto") SIZE 40 ,11  FONT oDlg:oFont ACTION (nOpc:=3,oDlg:End())  OF oDlg PIXEL

ACTIVATE MSDIALOG oDlg CENTERED


If nOpc == 2 .Or. nOpc == 3               
                       
	SCR->(dbClearFilter())
	SCR->(dbGoTo(nReg))
                                   
	_cDoc := Left(SCR->CR_NUM,_nTamDoc)
	SCP->(DbSetOrder(1))
	If SCP->(DbSeek(xFilial("SCP")+_cDoc))         
		
        dbSelectArea("SCP")
		
		Begin Transaction
			
		lLiberou := MaAlcDoc({cDocto,cTipo,nTotal,cCodLiber,,cGrupo,,,,,cObs},dRefer,If(nOpc==2,4,6))

		// Envio de e-mail de aprovação/reprovação
//		IF !Empty(_cCodUser) .and. !Empty( _cEMail := Alltrim(UsrRetMail( SCP->CP_SOLICIT )) )
		IF !Empty( _cEMail := Alltrim(UsrRetMail( SCP->CP_XUSER )) )
		    _lEnvMail := .t.
		ENDIF

		If lLiberou
		
			// Envio de e-mail para solicitante
			IF _lEnvMail
				_cBody  := "Prezado(a) "+SCP->CP_SOLICIT+Chr(13)+Chr(10)+Chr(13)+Chr(10)
				_cBody  += "Informamos que sua Solicitação ao Armazém Nr. "+SCP->CP_NUM+" foi aprovada."
				_cBody  += Chr(13)+Chr(10)+Chr(13)+Chr(10)
				_cBody  += "Obs: "+cObs
				ACSendMail( ,,,,_cEMail,"SA "+_cDoc+" APROVADA",_cBody)
			ENDIF
		
			// Se liberou total
			SCP->(DbSetOrder(1))
			SCP->(DbSeek(xFilial("SCP")+_cDoc))
			While !Eof("SCP") .and. SCP->CP_NUM == _cDoc
				RecLock("SCP",.F.)
				SCP->CP_STATSA := "L"
				SCP->(MsUnLock())                      
				dbSkip()
			Enddo
		EndIf
		
		If nOpc == 3

			// Envio de e-mail para solicitante
			IF _lEnvMail
				_cBody  := "Prezado(a) "+SCP->CP_SOLICIT+Chr(13)+Chr(10)+Chr(13)+Chr(10)
				_cBody  += "Informamos que sua Solicitação ao Armazém Nr. "+SCP->CP_NUM+" foi reprovada."
				_cBody  += Chr(13)+Chr(10)+Chr(13)+Chr(10)
				_cBody  += "Obs: "+cObs
				ACSendMail( ,,,,_cEMail,"SA "+_cDoc+" REPROVADA",_cBody)
			ENDIF
			
			// Se Bloqueou
			SCP->(DbSetOrder(1))
			SCP->(DbSeek(xFilial("SCP")+_cDoc))
			While !Eof("SCP") .and. SCP->CP_NUM == _cDoc			
				RecLock("SCP",.F.)
				SCP->CP_STATSA := "B"
				SCP->(MsUnLock())
				dbSkip()
			EndDo
		EndIf
		
		End Transaction
		
	#IFDEF TOP
		If TcSrvType() == "AS/400"
			set filter to  &(cXFiltraSCR)
		Else	
	#ENDIF
			SCR->(Eval(bFilSCRBrw))
	#IFDEF TOP
		EndIf 		
	#ENDIF

	Else
		ApMsgStop("SA " + _cDoc + " nao localizado !!!","Verifique")
	EndIf
EndIf

RestArea(_aAreaSC)
RestArea(_aArea)

Return

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³fEstSC    ºAutor  ³TOTVS               º Data ³  21/07/11   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ Funcao de estorno de liberacao.                            º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ FIESO                                                      º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
Static Function fEstSA()
Local lEstorna	:= .f.
Local _cDoc		:= ""
local _nTamDoc 	:= TamSx3("CP_NUM")[1]        
Local cGrupo 	:= ""
Local nTot		:= 0
Local dEmissao        
Local nReg		:= SCR->(Recno())

If ApMsgYesNo("Confirma estorno da liberação?","Confirmar")
	_cDoc := Left(SCR->CR_NUM,_nTamDoc)
		
	SCP->(DbSetOrder(1))
	If SCP->(DbSeek(xFilial("SCP")+_cDoc))
		cGrupo		:= SCP->CP_XAPROV
		dEmissao	:= SCR->CR_EMISSAO
	
		dbSelectArea("SCP")   		
		While !Eof() .and. SCP->CP_NUM == _cDoc                                          
			nTot += SCP->CP_XVLRTOT			
			dbSkip()		
		Enddo
		                         
		SCR->(dbClearFilter())
		SCR->(dbGoTo(nReg))

		MaAlcDoc({_cDoc,"SA",nTot,,,,,1,0,},dEmissao,3)
		
		SCP->(DbSetOrder(1))
		IF SCP->(dbSeek(XFilial("SCP")+_cDoc)) .and. !Empty(cGrupo)
			MaAlcDoc({_cDoc,"SA",nTot,,,cGrupo,,1,1,dEmissao},,1)
		EndIf
		SCR->(dbSetOrder(1))        
		
		// Se gerou SCR, bloqueia solicitacao novamente.
		IF SCR->(dbSeek(xFilial("SCR")+"SA"+_cDoc))   
		    dbSelectArea("SCP")
		    While !Eof() .and. CP_FILIAL == xFilial("SCP") .and. CP_NUM == _cDoc		
				RecLock("SCP",.F.)
				SCP->CP_STATSA := "E"
				SCP->(MsUnLock())                                          
				dbSkip()
			Enddo
		EndIf
	Else
		ApMsgStop("SA " + _cDoc + " nao localizada!","Verifique")
	EndIf
EndIf
                                      
#IFDEF TOP
	If TcSrvType() == "AS/400"
		set filter to  &(cXFiltraSCR)
	Else	
#ENDIF
		SCR->(Eval(bFilSCRBrw))
#IFDEF TOP
	EndIf 		
#ENDIF

Return                                

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡…o    ³A120Posic ³Revisao³TOTVS                  ³Data  ³05/05/2006³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³ Consulta do status das Aprovacoes Documentos               ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Sintaxe e ³ Void A120Posic(ExpC1,ExpN1,ExpN2,ExpC2)                    ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Parametros³ ExpC1 = Alias do arquivo                                   ³±±
±±³          ³ ExpN1 = Numero do registro                                 ³±±
±±³          ³ ExpN2 = Opcao selecionada                                  ³±±
±±³          ³ ExpC2 = Tipo do Documento                                  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³ MATA120 / MATA125 / MATA103                                ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
Static Function fPosic(cAlias,nReg,nOpcx,cTipoDoc)

Local aSavCols  := aClone(aCols)
Local aSavHead  := aClone(aHeader)
Local aArea		:= GetArea()

Local cHelpApv  := OemToAnsi("Este documento nao possui controle de aprovacao.")
Local cAliasSCR := "TMP"
Local cComprador:= ""
Local cSituaca  := ""
Local cNumDoc   := ""
Local cStatus   := ""
Local cTitle    := ""
Local cTitDoc   := ""

Local lBloq     := .F.
Local lQuery    := .F.

Local nSavN		:= N
Local nX   		:= 0
Local nY        := 0

Local oDlg
Local oGet
Local oBold

#IFDEF TOP
	Local cQuery   := ""
	Local aStruSCR := {}
#ENDIF

DEFAULT cTipoDoc := "SA"

dbSelectArea(cAlias)
dbGoto(nReg)


//If !Empty(CO1->CO1_XGRLIB)
	cTitle    := OemToAnsi("Aprovacao de SA")
	cTitDoc   := OemToAnsi("SA")
	cHelpApv  := OemToAnsi("Esta SA nao possui controle de aprovacao.")
	cNumDoc   := SCP->CP_NUM
	cStatus   := IIF(SCP->CP_STATSA=="L",OemToAnsi("SA LIBERADA"),OemToAnsi("AGUARDANDO LIB."))
//EndIf

If !Empty(cNumDoc)
	
	aHeader:= {}
	aCols  := {}
	
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Faz a montagem do aHeader com os campos fixos.               ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	dbSelectArea("SX3")
	dbSetOrder(1)
	MsSeek("SCR")
	While !Eof() .And. (SX3->X3_ARQUIVO == "SCR")
		IF AllTrim(X3_CAMPO)$"CR_NIVEL/CR_OBS/CR_DATALIB"
			AADD(aHeader,{	TRIM(X3Titulo()),;
			SX3->X3_CAMPO,;
			SX3->X3_PICTURE,;
			SX3->X3_TAMANHO,;
			SX3->X3_DECIMAL,;
			SX3->X3_VALID,;
			SX3->X3_USADO,;
			SX3->X3_TIPO,;
			SX3->X3_ARQUIVO,;
			SX3->X3_CONTEXT } )
			
			If AllTrim(x3_campo) == "CR_NIVEL"
				AADD(aHeader,{ OemToAnsi("Usuário"),"bCR_NOME",   "",15,0,"","","C","",""} )
				AADD(aHeader,{ OemToAnsi("Situação"),"bCR_SITUACA","",20,0,"","","C","",""} )
				AADD(aHeader,{ OemToAnsi("Usuário Lib."),"bCR_NOMELIB","",15,0,"","","C","",""} )
			EndIf
			
		Endif
		
		dbSelectArea("SX3")
		dbSkip()
	EndDo
	
	ADHeadRec("SCR",aHeader)
	
	#IFDEF TOP
		lQuery     := .T.
		
		
		aStruSCR := SCR->(dbStruct())
		cTipoDoc := "SA"
		cAliasSCR := GetNextAlias()
		cQuery    := "SELECT SCR.*,SCR.R_E_C_N_O_ SCRRECNO FROM "+RetSqlName("SCR")+" SCR "
		cQuery    += "WHERE SCR.CR_FILIAL='"+xFilial("SCR")+"' AND "
		cQuery    += "SCR.CR_NUM = '"+Padr(SCP->CP_NUM,Len(SCR->CR_NUM))+"' AND "
		cQuery    += "SCR.CR_TIPO = 'SA' AND "
		cQuery    += "SCR.D_E_L_E_T_=' ' "
		cQuery := ChangeQuery(cQuery)
		dbUseArea(.T.,"TOPCONN",TcGenQry(,,cQuery),cAliasSCR)
		
		For nX := 1 To Len(aStruSCR)
			If aStruSCR[nX][2]<>"C"
				TcSetField(cAliasSCR,aStruSCR[nX][1],aStruSCR[nX][2],aStruSCR[nX][3],aStruSCR[nX][4])
			EndIf
		Next nX
	#ELSE
		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³ Abre o arquivo SCR sem filtros    ³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		ChkFile("SCR",.F.,"TMP")
		
		dbSelectArea(cAliasSCR)
		dbSetOrder(1)
		MsSeek(xFilial("SCR")+cTipoDoc+Padr(SCP->CP_NUM,Len(SCR->CR_NUM)))
		
	#ENDIF
	
	dbSelectArea(cAliasSCR)
	
	While !Eof() .And.(cAliasSCR)->CR_FILIAL+(cAliasSCR)->CR_TIPO+Substr((cAliasSCR)->CR_NUM,1,len(SCP->CP_NUM))== xFilial("SCR") + cTipoDoc + cNumDoc
		
		aadd(aCols,Array(Len(aHeader)+1))
		nY++
		For nX := 1 to Len(aHeader)
			If IsHeadRec(aHeader[nX][2])
				aCols[nY][nX] := IIf(lQuery , (cAliasSCR)->SCRRECNO , SCR->(Recno())  )
			ElseIf IsHeadAlias(aHeader[nX][2])
				aCols[nY][nX] := "SCR"
			ElseIf aHeader[nX][02] == "bCR_NOME"
				aCols[nY][nX] := UsrRetName((cAliasSCR)->CR_USER)
			ElseIf aHeader[nX][02] == "bCR_SITUACA"
				Do Case
					Case (cAliasSCR)->CR_STATUS == "01"
						cSituaca := OemToAnsi("Nivel Bloqueado")
					Case (cAliasSCR)->CR_STATUS == "02"
						cSituaca := OemToAnsi("Aguarando Liberação")
					Case (cAliasSCR)->CR_STATUS == "03"
						cSituaca := OemToAnsi("SA Aprovada")
					Case (cAliasSCR)->CR_STATUS == "04"
						cSituaca := OemToAnsi("SA Bloqueada")
						lBloq := .T.
					Case (cAliasSCR)->CR_STATUS == "05"
						cSituaca := OemToAnsi("Nivel Liberado ")
				EndCase
				aCols[nY][nX] := cSituaca
			ElseIf aHeader[nX][02] == "bCR_NOMELIB"
				aCols[nY][nX] := UsrRetName((cAliasSCR)->CR_USERLIB)
			ElseIf ( aHeader[nX][10] != "V")
				aCols[nY][nX] := FieldGet(FieldPos(aHeader[nX][2]))
			EndIf
		Next nX
		aCols[nY][Len(aHeader)+1] := .F.
		dbSkip()
	EndDo
	
	If !Empty(aCols)
		If lBloq
			cStatus := OemToAnsi("BLOQUEADO")
		EndIf
		DEFINE FONT oBold NAME "Arial" SIZE 0, -12 BOLD
		DEFINE MSDIALOG oDlg TITLE cTitle From 109,095 To 400,600 OF oMainWnd PIXEL
		@ 005,003 TO 032,250 LABEL "" OF oDlg PIXEL
		@ 015,007 SAY cTitDoc OF oDlg FONT oBold PIXEL SIZE 046,009
		@ 014,041 MSGET cNumDoc PICTURE "" WHEN .F. PIXEL SIZE 050,009 OF oDlg FONT oBold
		@ 132,008 SAY "Situacao :" OF oDlg PIXEL SIZE 052,009 //'Situacao :'
		@ 132,038 SAY cStatus OF oDlg PIXEL SIZE 120,009 FONT oBold
		@ 132,205 BUTTON "Fechar" SIZE 035 ,010  FONT oDlg:oFont ACTION (oDlg:End()) OF oDlg PIXEL  //'Fechar'
		oGet:= MSGetDados():New(038,003,120,250,nOpcx,,,"")
		oGet:Refresh()
		@ 126,002 TO 127,250 LABEL "" OF oDlg PIXEL
		ACTIVATE MSDIALOG oDlg CENTERED
	Else
		Aviso("Atencao",cHelpApv,{"Voltar"})
	EndIf
	
	dbSelectArea(cAliasSCR)
	dbCloseArea()
	aHeader	:= aClone(aSavHead)
	aCols	:= aClone(aSavCols)
	N		:= nSavN
Else
	Aviso("Atencao",cHelpApv,{"Voltar"})
EndIf

dbSelectArea(cAlias)
RestArea(aArea)

Return