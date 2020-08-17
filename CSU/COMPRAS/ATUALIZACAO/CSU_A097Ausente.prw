#Include "Protheus.ch"
#Include "RwMake.ch"
#Include "TOPCONN.CH"

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±± Funcao: CSU_A097Ausente 	Autor: Tatiana A. Barbosa     Data: 25/03/11   ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±	Descricao: 															   ±± 
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±				Uso:  CSU CardSystem S.A								   ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

User Function CSU_A097Ausente()

Local aArea		:= GetArea()
Local aCpos     := {" ", "CR_NUM","CR_TIPO","CR_USER","CR_APROV","CR_STATUS","CR_TOTAL","CR_EMISSAO"}
Local aHeadCpos := {}
Local aHeadSize := {}
Local _aArraySCR:= {}
Local aCampos   := {}
Local aCombo    := {}
Local cAliasSCR := "SCR"
Local cAprov    := ""
Local cUserName := ""
Local cUsrApvSup:= "" 
Local cUser     := RetCodUsr()
Local nX        := 0   
Local nY		:= 1
Local nOpc      := 0
Local nOk       := 0               
Local nHeadCpos	:= 0

Local oDlg
Local oQual         
Local cLine      := ""               

Private oOk        := LoadBitmap(GetResources(),'lbok.png')
Private oNo        := LoadBitmap(GetResources(),'lbno.png')
//Local bLine      := {}

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Finaliza o uso da funcao FilBrowse e retorna os indices padroes.       ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ	
#IFDEF TOP
If	TcSrvType()=="AS/400"	
	dbClearFilter()
Else			
#ENDIF
	EndFilBrw("SCR",aIndexSCR)
#IFDEF TOP
EndIf 		
#ENDIF 		

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Monta o Header com os titulos do TWBrowse             ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
dbSelectArea("SX3")
dbSetOrder(2)
For nx	:= 1 to Len(aCpos)
	If !MsSeek(aCpos[nx])
		AADD(aHeadCpos," ")          
		AADD(aHeadSize, 20) 
		AADD(aCampos,{" ","L"," ","@!"})
	ELse 
		AADD(aHeadCpos,AllTrim(X3Titulo()))
		AADD(aHeadSize,CalcFieldSize(SX3->X3_TIPO,SX3->X3_TAMANHO,SX3->X3_DECIMAL,SX3->X3_PICTURE,X3Titulo()))
		AADD(aCampos,{SX3->X3_CAMPO,SX3->X3_TIPO,SX3->X3_CONTEXT,SX3->X3_PICTURE})
	EndIf                     	
Next

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Pega o Codigo do usuario Aprovador no cadastro de Aprov³
//³adores. ( O usuario logado e o Aprovador Superior )    ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
dbSelectArea("SAK")
dbSetOrder(2)
dbSeek(xFilial("SAK")+cUser)
cUsrApvSup := SAK->AK_COD
cUserName  := cUsrApvSup +" - "+UsrFullName(cUser)

dbGotop()
While ( !Eof().And. SAK->AK_FILIAL == xFilial("SAK") )

    If SAK->AK_APROSUP == cUsrApvSup
    	AADD(aCombo,SAK->AK_COD+" - "+SAK->AK_NOME)
    EndIf
    
	SAK->(dbSkip())
EndDo     
                          
If Len(aCombo) > 0

	U_CSUA097Aprov(cAliasSCR,Substr(aCombo[1],1,6),@_aArraySCR,aCampos,aCombo) 

	DEFINE MSDIALOG oDlg FROM 000,000 TO 400,780 TITLE "Transferencia por Ausencia Temporaria de Aprovadores" PIXEL
	@ 001,001  TO 050,425 LABEL "" OF oDlg PIXEL
	
	@ 012,006 Say "Aprovador Ausente " OF oDlg PIXEL SIZE 080,009
	@ 012,058 MSCOMBOBOX cAprov ITEMS aCombo SIZE 150,090 WHEN .T. VALID U_CSUA097Aprov(cAliasSCR,cAprov,@_aArraySCR,aCampos,aCombo,oQual) OF oDlg PIXEL
		
	@ 030,006 Say "Aprovador Superior" OF oDlg PIXEL SIZE 080,009  
	@ 030,058 MSGET cUserName When .F. SIZE 150,009 OF oDlg PIXEL
	                                                                     
	oQual:= TWBrowse():New( 051,001,389,133,,aHeadCpos,aHeadSize,oDlg,,,,,{||},,,,,,,.F.,,.T.,,.F.,,,)
	oQual:SetArray(_aArraySCR)
	oQual:bLine := {||{If(_aArraySCR[oQual:nAt,01],oOK,oNO),_aArraySCR[oQual:nAT,02],_aArraySCR[oQual:nAt,03],_aArraySCR[oQual:nAt,04],_aArraySCR[oQual:nAt,05],_aArraySCR[oQual:nAt,06],_aArraySCR[oQual:nAt,07],_aArraySCR[oQual:nAt,08] } }
	// Troca a imagem no duplo click do mouse
	oQual:bLDblClick := {|| _aArraySCR[oQual:nAt][1] := !_aArraySCR[oQual:nAt][1],oQual:DrawSelect()}                                                                                  

	@ 187,278 BUTTON "Transferir Marcados" 	SIZE 060,011 FONT oDlg:oFont ACTION (nOpc:=1,oDlg:End())  OF oDlg PIXEL // "Transferir Marcados"
	@ 187,340 BUTTON "Cancelar"				SIZE 040,011 FONT oDlg:oFont ACTION (nOpc:=2,oDlg:End())  OF oDlg PIXEL // "Cancelar  "
	
	ACTIVATE MSDIALOG oDlg CENTERED

	If nOpc == 1 

	    If !Empty(_aArraySCR[1][2])
	 
		    nOk := Aviso("Atencao!","Ao confirmar este processo as aprovações pendentes selecionadas do aprovador serão transferidas ao aprovador superior. Confirma a Transferência ? ",{"Cancelar","Confirma"},2)
	
	        If  nOk == 2  // Confirma a transferencia
	
		        For nX := 1 To Len(_aArraySCR)        
		        	If _aArraySCR[nX][1]
						dbSelectArea("SCR")                
						dbSetOrder(2)
						dbSeek(xFilial("SCR")+_aArraySCR[nX][3]+_aArraySCR[nX][2]+_aArraySCR[nX][4])
				
						Begin Transaction
						
						MaAlcDoc({SCR->CR_NUM,SCR->CR_TIPO,,cUsrApvSup,,,,,,,"Tranferido por Ausencia"},,2)
						
						// - Inicio - OS 2900-11
						If SCR->CR_TIPO $ 'SC' 
							dbSelectArea("SC1")                
							dbSetOrder(1)
							DbGotop()
							If SC1->(dbSeek(xFilial("SC1")+Alltrim(SCR->CR_NUM)))
							   While Alltrim(SC1->C1_NUM) == Alltrim(SCR->CR_NUM)
							   		RecLock('SC1',.F.)
							   			SC1->C1_XAPROV := Alltrim(cUser)
							   		MsUnlock()
							   		SC1->(DbSkip())
							   EndDo	
							EndIf
						EndIf
						// - Fim
						End Transaction	
					EndIf
		        Next nX
		
	        EndIf 
	        
	 	Else
			Aviso("A097NOSCR","Não existem registros para serem transferidos",{"OK"})          
        EndIf
        
	EndIf	
Else
	Aviso("A097NOSUP","Para utilizar esta opção é necessario que exista no minimo um aprovador com um superior cadastrado",{"OK"})
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

RestArea(aArea)	
	
Return Nil   
/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±± Funcao: CSUA097Aprov 	Autor: Tatiana A. Barbosa     Data: 15/04/11   ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±	Descricao: Acessa as liberacoes dos Aprovadores que possuem o usuario  ±± 
±±			logado cadastrado como Superior no cadastro de Aprovadores.    ±± 
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±± 
±±	Sintaxe: CSUA097Aprov(ExpC1,ExpC2,ExpA1,ExpA2,ExpA3,ExpO1)			   ±± 
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±  Parametros	ExpC1 = Alias do SCR                                       ±±
±±	          	ExpC2 = cod.do aprovador                                   ±±
±±          	ExpA1 = array dos campos de SCR		                       ±±
±±          	ExpA2 = array dos campos de SCR e outro(s)                 ±±
±±          	ExpA3 =                                                    ±±
±±          	ExpO1 = objeto do SCR                                      ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±				Uso:  CSU CardSystem S.A								   ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

User Function CSUA097Aprov(cAliasSCR,cAprov,_aArraySCR,aCampos,aCombo,oQual)

Local aStruSCR  := {}
Local cIndSCR	:= ""
Local cQuery    := ""
Local nX        := 0  
Local nZ		:= 1
Local nOrderSCR := 0 
Local lQuery    := .F.

dbSelectArea("SCR")
dbSetOrder(1)

#IFDEF TOP
    If TcSrvType()<>"AS/400"
	    lQuery := .T.
		cAliasSCR := "QRYSCR"
		aStruSCR  := SCR->(dbStruct())
		cQuery := "SELECT * "
		cQuery += "FROM "+RetSqlName("SCR")+" "
		cQuery += "WHERE CR_FILIAL='"+xFilial("SCR")+"' AND "
		cQuery += "CR_APROV='"+Substr(cAprov,1,6)+"' AND ( CR_STATUS='02' OR CR_STATUS='04' ) AND "
		cQuery += "CR_X_RES = ''" //OS 2925/17
		cQuery += "AND D_E_L_E_T_ = ' ' "
		cQuery += "ORDER BY "+SqlOrder(SCR->(IndexKey()))
	
		cQuery := ChangeQuery(cQuery)
		dbUseArea(.T.,"TOPCONN",TcGenQry(,,cQuery),cAliasSCR)
	
		For nX := 1 To len(aStruSCR)
			If aStruSCR[nX][2] <> "C" .And. FieldPos(aStruSCR[nX][1])<>0
				TcSetField(cAliasSCR,aStruSCR[nX][1],aStruSCR[nX][2],aStruSCR[nX][3],aStruSCR[nX][4])
			EndIf
		Next nX
		dbSelectArea(cAliasSCR)	
	Else
#ENDIF
	cIndSCR	:= CriaTrab(Nil,.F.)
	IndRegua(cAliasSCR,cIndSCR,SCR->(IndexKey()),,'CR_APROV == "'+Substr(cAprov,1,6)+'" .And.(CR_STATUS=="02".OR.CR_STATUS=="04")')
	nOrderSCR := RetIndex("SCR")
	#IFNDEF TOP
		dbSetIndex(cIndSCR+OrdBagExt())
	#ENDIF
	dbSelectArea("SCR")
	dbSetOrder(nOrderSCR+1)	
	dbSelectArea(cAliasSCR)
	dbGoTop()
#IFDEF TOP
	Endif    
#ENDIF

If Eof()
	_aArraySCR := {{.T.,"","","","","",0,""}}
Else
	_aArraySCR := {}
EndIf

While ( !(cAliasSCR)->(Eof()) .And. (cAliasSCR)->CR_FILIAL == xFilial("SCR") )
	
	Aadd(_aArraySCR,Array(Len(aCampos)))

	For nX := 1 to Len(aCampos)	
		If Substr(aCampos[nX][1],1,2) == "CR"
			If aCampos[nX][2] == "N"
				_aArraySCR[Len(_aArraySCR)][nX] := Transform((cAliasSCR)->(FieldGet(FieldPos(aCampos[nX][1]))),PesqPict("SCR",aCampos[nX][1]))
			Else
				_aArraySCR[Len(_aArraySCR)][nX] := (cAliasSCR)->(FieldGet(FieldPos(aCampos[nX][1])))
			Endif  		
		Else
			_aArraySCR[nZ][1] := (.T.)
		EndIf
	Next nX
	
	(cAliasSCR)->(dbSkip())
	
    nZ++
    
EndDo

If oQual <> Nil
	oQual:SetArray(_aArraySCR)
	oQual:bLine := {||{If(_aArraySCR[oQual:nAt,01],oOK,oNO),_aArraySCR[oQual:nAT,02],_aArraySCR[oQual:nAt,03],_aArraySCR[oQual:nAt,04],_aArraySCR[oQual:nAt,05],_aArraySCR[oQual:nAt,06],_aArraySCR[oQual:nAt,07],_aArraySCR[oQual:nAt,08] } }
	oQual:Refresh()
EndIf                


//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Apaga os arquivos de trabalho, cancela os filtros e restabelece as ordens originais.|
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
If lQuery
	dbSelectArea(cAliasSCR)
	dbCloseArea()
Else
  	dbSelectArea("SCR")
	RetIndex("SCR")
	dbClearFilter()
	Ferase(cIndSCR+OrdBagExt())
EndIf

Return Nil