#Include "Protheus.ch"
#Include "TopConn.ch"

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³FICDVA02  ºAutor  ³Felipe Alves        º Data ³  21/11/13   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³                                                            º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ FIESP                                                      º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

User Function FICDVA02(_nOpcao)
Local _aArea := {}
Local _aAreaCR := {}
Local _cDoc := ""
Local _nTamDoc := TamSX3("Z1_NUM")[1]

Private lCopia := .F.

If (_nOpcao == 1)
	_aArea := GetArea()
	_aAreaCR := SCR->(GetArea())
	_cDoc := Left(SCR->CR_NUM, _nTamDoc)
	
	SZ1->(DbSetOrder(1))
	If (SZ1->(DbSeek(xFilial("SZ1") + _cDoc)))
		DbSelectArea("SZ1")
//		AxVisual('SZ1',SZ1->(Recno()),2) //A105Visual("SZ1", RecNo(), 2)
		U_FICDVINC(2)
	Endif
	RestArea(_aAreaCR)
	RestArea(_aArea)
Elseif (_nOpcao == 2)
	fLibCV("SCR", RecNo(), _nOpcao)
Elseif (_nOpcao == 3)
	fEstCV()
Elseif (_nOpcao == 4)
	_aArea := GetArea()
	_aAreaCR := SCR->(GetArea())
	fPosic("SZ1", RecNo(), 2, "CV")
	RestArea(_aAreaCR)
	RestArea(_aArea)
Endif
Return()

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³FICDVA02  ºAutor  ³Felipe Alves        º Data ³  21/11/13   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³                                                            º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ FIESP                                                      º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

Static Function fLibCV(cAlias,nReg,nOpcx)
Local _cCodUser	:= ""  //Codigo do usuario de retorno
Local _lEnvMail := .T.
Local _aArea	:= GetArea()
Local _aAreaSC	:= SZ1->(GetArea())
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
local _nTamDoc 	:= TamSx3("Z1_NUM")[1]
Local cName		:= ""
Local nOpc		:= 0
Local lLiberou	:= .F.                  
Local cGrupo	:= ""
Local _cNumCt   := ""
Local cAliasZ0  := {}

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
SZ1->(DbSetOrder(1))
SZ1->(DbSeek(xFilial("SZ1")+_cDoc))
cGrupo	:= SZ1->Z1_GRPAPRV

DEFINE MSDIALOG oDlg FROM 0,0 TO aSize[1],aSize[2] TITLE OemToAnsi("Liberacao de CV") PIXEL
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
@ 19,45  MSGET SZ1->Z1_CCUSTO  When .F. SIZE 155,9 OF oDlg PIXEL
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
	SZ1->(DbSetOrder(1))
	If SZ1->(DbSeek(xFilial("SZ1")+_cDoc))         
		
        dbSelectArea("SZ1")
		
		Begin Transaction
			
		lLiberou := MaAlcDoc({cDocto,cTipo,nTotal,cCodLiber,,cGrupo,,,,,cObs},dRefer,If(nOpc==2,4,6))

		If lLiberou
		
			// Se liberou total
			SZ1->(DbSetOrder(1))
			SZ1->(DbSeek(xFilial("SZ1")+_cDoc))
			While !Eof("SZ1") .and. SZ1->Z1_NUM == _cDoc
				RecLock("SZ1",.F.)
				SZ1->Z1_STATUS := "Y"
				SZ1->(MsUnLock())                      
				dbSkip()
			Enddo
		EndIf
		
		If nOpc == 3
			// Se Bloqueou
			SZ1->(DbSetOrder(1))
			SZ1->(DbSeek(xFilial("SZ1")+_cDoc))
			While !Eof("SZ1") .and. SZ1->Z1_NUM == _cDoc			
				RecLock("SZ1",.F.)
				SZ1->Z1_STATUS := "R"
				SZ1->(MsUnLock())
				dbSkip()
			EndDo
			
			DbSelectArea("SZ0")
			SZ0->(DbSetOrder(1))
			If (SZ0->(DbSeek(xFilial("SZ0") + _cDoc)))
				While ((SZ0->(!Eof())) .And. (SZ0->Z0_FILIAL == xFilial("SZ0")) .And. (SZ0->Z0_NUMSV == _cDoc))
					_cNumCt := SZ0->Z0_CODCONT
					
					cAliasZ0 := SZ0->(GetArea())
					
					If !(Empty(_cNumCt))
						SZ0->(DbSetOrder(2))
						If !(SZ0->(DbSeek(xFilial("SZ0") + _cNumCt)))
							Return()
						Endif
						
						DbSelectArea("ALJ")
						ALJ->(DbSetOrder(1))
						ALJ->(DbSeek(xFilial("ALJ") + _cNumCt))
						
						While ((ALJ->(!Eof())) .And. (ALJ->ALJ_FILIAL == xFilial("ALJ")) .And. (ALJ->ALJ_CDCNTG == _cNumCt))
							PcoIniLan("000356")
							PcoDetLan("000356","01","PCOA530",.T.) // Deleta Empenho caso exista
							PcoDetLan("000356","02","PCOA530",.T.) // Deleta Empenho caso exista
							PcoFinLan("000356")
				
							ALJ->(DbSkip())
						Enddo
						
						SZ1->(DbSetOrder(1))
						SZ1->(DbSeek(xFilial("SZ1")+_cDoc))
						While !Eof("SZ1") .and. SZ1->Z1_NUM == _cDoc
							PcoIniLan("900002")
							PcoDetLan("900002", "01", "FICDVA01", .T.)
							PcoFinLan("900002")
				
							dbSkip()
						EndDo
					Endif
					
					RestArea(cAliasZ0)

					SZ0->(DbSkip())
				Enddo
			Endif
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
		ApMsgStop("CV " + _cDoc + " nao localizado !!!","Verifique")
	EndIf
EndIf

RestArea(_aAreaSC)
RestArea(_aArea)

Return

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³FICDVA02  ºAutor  ³Felipe Alves        º Data ³  21/11/13   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³                                                            º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ FIESP                                                      º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

Static Function fEstCV()
Local lEstorna	:= .f.
Local _cDoc		:= ""
local _nTamDoc 	:= TamSx3("Z1_NUM")[1]
Local cGrupo 	:= ""
Local nTot		:= 0
Local dEmissao
Local nReg		:= SCR->(Recno())

If ApMsgYesNo("Confirma estorno da liberação?","Confirmar")
	_cDoc := Left(SCR->CR_NUM,_nTamDoc)
		
	SZ1->(DbSetOrder(1))
	If SZ1->(DbSeek(xFilial("SZ1")+_cDoc))
		cGrupo		:= SZ1->Z1_GRPAPRV
		dEmissao	:= SCR->CR_EMISSAO
	
		dbSelectArea("SZ1")   		
		While !Eof() .and. SZ1->Z1_NUM == _cDoc                                          
			nTot += SZ1->Z1_TOTAL
			dbSkip()		
		Enddo
		                         
		SCR->(dbClearFilter())
		SCR->(dbGoTo(nReg))

		MaAlcDoc({_cDoc,"CV",nTot,,,,,1,0,},dEmissao,3)
		
		SZ1->(DbSetOrder(1))
		IF SZ1->(dbSeek(XFilial("SZ1")+_cDoc)) .and. !Empty(cGrupo)
			MaAlcDoc({_cDoc,"CV",nTot,,,cGrupo,,1,1,dEmissao},,1)
		EndIf
		SCR->(dbSetOrder(1))        
		
		// Se gerou SCR, bloqueia solicitacao novamente.
		IF SCR->(dbSeek(xFilial("SCR")+"CV"+_cDoc))   
		    dbSelectArea("SZ1")
		    While !Eof() .and. Z1_FILIAL == xFilial("SZ1") .and. Z1_NUM == _cDoc		
				RecLock("SZ1",.F.)
				SZ1->Z1_STATUS := "Q"
				SZ1->(MsUnLock())                                          
				dbSkip()
			Enddo
		EndIf
	Else
		ApMsgStop("CV " + _cDoc + " nao localizado!","Verifique")
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
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³FICDVA02  ºAutor  ³Felipe Alves        º Data ³  21/11/13   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³                                                            º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ FIESP                                                      º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
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

DEFAULT cTipoDoc := "CV"

dbSelectArea(cAlias)
dbGoto(nReg)


//If !Empty(CO1->CO1_XGRLIB)
	cTitle    := OemToAnsi("Aprovacao de CV")
	cTitDoc   := OemToAnsi("CV")
	cHelpApv  := OemToAnsi("Esta CV nao possui controle de aprovacao.")
	cNumDoc   := SZ1->Z1_NUM
	cStatus   := IIF(SZ1->Z1_STATUS=="L",OemToAnsi("CV LIBERADO"),OemToAnsi("AGUARDANDO LIB."))
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
		cTipoDoc := "CV"
		cAliasSCR := GetNextAlias()
		cQuery    := "SELECT SCR.*,SCR.R_E_C_N_O_ SCRRECNO FROM "+RetSqlName("SCR")+" SCR "
		cQuery    += "WHERE SCR.CR_FILIAL='"+xFilial("SCR")+"' AND "
		cQuery    += "SCR.CR_NUM = '"+Padr(SZ1->Z1_NUM,Len(SCR->CR_NUM))+"' AND "
		cQuery    += "SCR.CR_TIPO = 'CV' AND "
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
		MsSeek(xFilial("SCR")+cTipoDoc+Padr(SZ1->Z1_NUM,Len(SCR->CR_NUM)))
		
	#ENDIF
	
	dbSelectArea(cAliasSCR)
	
	While !Eof() .And.(cAliasSCR)->CR_FILIAL+(cAliasSCR)->CR_TIPO+Substr((cAliasSCR)->CR_NUM,1,len(SZ1->Z1_NUM))== xFilial("SCR") + cTipoDoc + cNumDoc
		
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
						cSituaca := OemToAnsi("CV Aprovado")
					Case (cAliasSCR)->CR_STATUS == "04"
						cSituaca := OemToAnsi("CV Bloqueado")
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