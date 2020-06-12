	//Inicio - Emerson Natali - 25/11/09
	_x1Area := GetArea()
	If SEA->EA_PORTADO <> "341"
		msgbox("Existem Borderos quer não pertencem ao ITAU!!!", "ATENCAO")
		Return(.F.)
	EndIf

	ChkFile("SE5")
	DbSelectArea("SE5")
	DbSetOrder(7)
	If DbSeek(xFilial("SE5")+ SEA->(EA_PREFIXO+EA_NUM+EA_PARCELA+EA_TIPO+EA_FORNECE+EA_LOJA))
		If !Empty(SE5->E5_RECONC)
			msgbox("Alguns titulos do Borderos encontram-se Conciliados!!!", "ATENCAO")
			Return(.F.)
		EndIf
	EndIf

	ChkFile("SE2")
	DbSelectArea("SE2")
	DbSetOrder(1)
	If DbSeek(xFilial("SE2")+ SEA->(EA_PREFIXO+EA_NUM+EA_PARCELA+EA_TIPO+EA_FORNECE+EA_LOJA))
		If Empty(SE2->E2_BAIXA)
			msgbox("Alguns titulos do Borderos não foram baixados!!!", "ATENCAO")
			Return(.F.)
		EndIf
		If !Empty(SE2->E2_PAGFOR)
			_nOpc := Aviso(OemToAnsi("Atenção"),OemToAnsi("Este bordero já foi Gerado. Deseja re-gerar??? (")+SE2->E2_PAGFOR+")",{"Sim","Não"})
			If _nOpc == 1
				mv_par04 := ALLTRIM(SZL->ZL_PATH) + SUBSTR(DTOC(DDATABASE),1,2)+SUBSTR(DTOC(DDATABASE),4,2)+SUBSTR(DTOC(DDATABASE),7,2)+  "0"
				_lVerdade := .T.
				Do While _lVerdade
					If File(mv_par04+".REM")
						_nPos 		:= len(mv_par04)
						_nvar 		:= str(val(right(alltrim(mv_par04),1))+1,1)
						mv_par04 	:= substr(mv_par04,1,_nPos-1)+_nvar
					Else
						_lVerdade 	:= .F.
					EndIf
				EndDo
			Else
				RestArea(_x1Area)
				Return(.F.)
			EndIf
		EndIf
	EndIf

	RestArea(_x1Area)
	//Fim - Emerson Natali - 25/11/09





/*
_aRelBord[1] - NUMERO BORDERO
_aRelBord[2] - LOGICO BANCO DIFERENTE
_aRelBord[3] - LOGICO BORDERO CONCILIADO
_aRelBord[4] - LOGICO TITULOS NAO BAIXADOS
_aRelBord[5] - ARQ JA GERADO

*/
_aRelBord 	:= {}
_PosAnt 	:= 0
dbSelectArea("SEA")
dbSeek(xFilial("SEA")+mv_par01,.T.)
While SEA->(!Eof()) .And. SEA->EA_NUMBOR <= mv_par02 .and. SEA->EA_FILIAL == xFilial("SEA")

	If SEA->EA_PORTADO <> "341"
		_PosAnt := ascan(_aRelBord,{|x| x[1] == SE2->E2_NUMBOR })
		If _PosAnt == 0
			AADD(_aRelBord,{SE2->E2_NUMBOR,.T.,.F.,.F.,.F.})
		EndIf
		DbSelectArea("SEA")
		SEA->(DbSkip())
		Loop
	EndIf

	ChkFile("SE2")
	DbSelectArea("SE2")
	DbSetOrder(1)
	If DbSeek(xFilial("SE2")+ SEA->(EA_PREFIXO+EA_NUM+EA_PARCELA+EA_TIPO+EA_FORNECE+EA_LOJA))
		While !SE2->( Eof() ) .And. SE2->E2_FILIAL == cFilial .And.;
				SE2->E2_NUMBOR>=mv_par01 .and. SE2->E2_NUMBOR <=mv_par02
		
				IncProc()
		
				If Empty(SE2->E2_BAIXA)
					_PosAnt := ascan(_aRelBord,{|x| x[1] == SE2->E2_NUMBOR })
					If _PosAnt == 0
						AADD(_aRelBord,{SE2->E2_NUMBOR,.F.,.T.,.F.,.F.})
					Else
						_aRelBord[_PosAnt][3] := .T.
					EndIf
					DbSelectArea("SEA")
					SEA->(DbSkip())
					Loop
		        Else
					ChkFile("SE5")		
					DbSelectArea("SE5")
					SE5->(DbSetOrder(10))
					IF SE5->(DBSEEK(xFILIAL("SE5")+SE2->E2_NUMBOR))
					   IF !Empty(SE5->E5_RECONC)
							_PosAnt := ascan(_aRelBord,{|x| x[1] == SE2->E2_NUMBOR })
							If _PosAnt == 0
								AADD(_aRelBord,{SE2->E2_NUMBOR,.F.,.F.,.T.,.F.})
							Else
								_aRelBord[_PosAnt][4] := .T.
							EndIf
							DbSelectArea("SEA")
							SEA->(DbSkip())
							Loop
						EndIf
					EndIf
				EndIf

				If !Empty(SE2->E2_PAGFOR)
					_PosAnt := ascan(_aRelBord,{|x| x[1] == SE2->E2_NUMBOR })
					If _PosAnt == 0
						AADD(_aRelBord,{SE2->E2_NUMBOR,.F.,.F.,.F.,.T.})
					Else
						_aRelBord[_PosAnt][5] := .T.
					EndIf				
				EndIf
				
				DbSelectArea("SE2")
				SE2->(DbSkip())
			EndDo
		EndIf
EndDo