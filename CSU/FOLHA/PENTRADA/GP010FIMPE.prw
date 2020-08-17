#INCLUDE "RWMAKE.Ch"
#INCLUDE "Protheus.ch"
/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³GP010FIMPEº Autor ³Isamu K.            º Data ³ 07/01/2015  º±±                     '
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDescricao ³Ponto de entrada para verificar cadastramento de Beneficios º±±
±±º          ³apos cadastrar um funcionário no SRA                        º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ CSU                                                        º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
User Function GP010FIMPE

cCpoFil := ( "SRA->RA_FILIAL" )
nLoops := Len( aSraHeader )
cKeySeek:= ( &(cCpoFil) + SRA->RA_MAT )


If Inclui 
	If MsgYesNo('Deseja incluir os beneficios: Vale Transporte, Vale Refeição, Vale Alimentação, Assistência Medica e Odontológica ?')
		
		DEFINE MSDIALOG oDlg2 TITLE OemtoAnsi('Escolha de Plano de Saúde') FROM  200, 060 TO 400,600 //165,060 TO 320,400 PIXEL
		
		cPlano  :=space(2)
		cPlanoOd:=space(2)
		cFasMed := "   "
		cFasOdo := "   "
		cMeio1  := space(2)
		nQtd1   := 0
		cMeio2  := space(2)
		nQtd2   := 0
		cMeio3  := space(2)
		nQtd3   := 0
		cMeio4  := space(2)
		nQtd4   := 0
		cMeio5  := space(2)
		nQtd5   := 0
		cAlim   := space(3)
		dAlim   := Ctod("//")
		dfAlim  := Ctod("//")
		cRef    := space(3)
		dRef    := Ctod("//")
		cIniAm  := space(7)
		cIniAO  := space(7)
		
		@ 007,010 SAY OemToAnsi('Fornecedor Ass Medica:') SIZE 200, 8 OF oDlg2 PIXEL
		@ 005,080 MSGET oGet012 VAR cFAsMed F3 'CS016'     SIZE 030,9  OF oDlg2 PIXEL
		
		@ 023,010 SAY OemToAnsi('Plano Saude:')           SIZE 200, 8 OF oDlg2 PIXEL
		@ 021,080 MSGET oGet012 VAR cPlano F3 'CS008'      SIZE 030,9  OF oDlg2 PIXEL
		
		@ 043,010 SAY OemToAnsi('Mês/Ano Inicio:') SIZE 200, 8 OF oDlg2 PIXEL
		@ 041,080 MSGET oGet013 VAR cIniAm Picture "@E 99/9999"     SIZE 030,9  OF oDlg2 PIXEL
		
		@ 063,010 SAY OemToAnsi('Fornecedor Ass Odonto:') SIZE 200, 8 OF oDlg2 PIXEL
		@ 061,080 MSGET oGet014 VAR cFAsOdo F3 'CS017'     SIZE 030,9  OF oDlg2 PIXEL
		
		@ 083,010 SAY OemToAnsi('Plano Odonto:')          SIZE 200, 8 OF oDlg2 PIXEL
		@ 081,080 MSGET oGet015 VAR cPlanoOd F3 'CS031'    SIZE 030,9  OF oDlg2 PIXEL
		
		@ 103,010 SAY OemToAnsi('Mês/Ano Inicio:') SIZE 200, 8 OF oDlg2 PIXEL
		@ 101,080 MSGET oGet016 VAR cIniAo Picture "@E 99/9999"     SIZE 030,9  OF oDlg2 PIXEL
		
		@ 123,010 SAY OemToAnsi('VT-1o Meio Transporte:')          SIZE 100, 8 OF oDlg2 PIXEL
		@ 121,080 MSGET oGet017 VAR cMeio1 F3 'SRN'        SIZE 030,9  OF oDlg2 PIXEL
		
		@ 143,010 SAY OemToAnsi('Qt.diaria V.T.-1o Meio Transp.:')          SIZE 100, 8 OF oDlg2 PIXEL
		@ 141,080 MSGET oGet018 VAR nQtd1 Picture "@E 99"        SIZE 030,9  OF oDlg2 PIXEL
		
		@ 163,010 SAY OemToAnsi('VT-2o Meio Transporte:')          SIZE 100, 8 OF oDlg2 PIXEL
		@ 161,080 MSGET oGet019 VAR cMeio2 F3 'SRN'        SIZE 030,9  OF oDlg2 PIXEL
		
		@ 183,010 SAY OemToAnsi('Qt.diaria V.T.-2o Meio Transp.:')          SIZE 100, 8 OF oDlg2 PIXEL
		@ 181,080 MSGET oGet020 VAR nQtd2 Picture "@E 99"        SIZE 030,9  OF oDlg2 PIXEL
		
		@ 203,010 SAY OemToAnsi('VT-3o Meio Transporte:')          SIZE 100, 8 OF oDlg2 PIXEL
		@ 201,080 MSGET oGet021 VAR cMeio3 F3 'SRN'        SIZE 030,9  OF oDlg2 PIXEL
		
		@ 223,010 SAY OemToAnsi('Qt.diaria V.T.-3o Meio Transp.:')          SIZE 100, 8 OF oDlg2 PIXEL
		@ 221,080 MSGET oGet022 VAR nQtd3 Picture "@E 99"        SIZE 030,9  OF oDlg2 PIXEL
		
		@ 243,010 SAY OemToAnsi('VT-4o Meio Transporte:')          SIZE 100, 8 OF oDlg2 PIXEL
		@ 241,080 MSGET oGet023 VAR cMeio4 F3 'SRN'        SIZE 030,9  OF oDlg2 PIXEL
		
		@ 263,010 SAY OemToAnsi('Qt.diaria V.T.-4o Meio Transp.:')          SIZE 100, 8 OF oDlg2 PIXEL
		@ 261,080 MSGET oGet024 VAR nQtd4 Picture "@E 99"        SIZE 030,9  OF oDlg2 PIXEL
		
		@ 283,010 SAY OemToAnsi('VT-5o Meio Transporte:')          SIZE 100, 8 OF oDlg2 PIXEL
		@ 281,080 MSGET oGet025 VAR cMeio5 F3 'SRN'        SIZE 030,9  OF oDlg2 PIXEL
		
		@ 303,010 SAY OemToAnsi('Qt.diaria V.T.-5o Meio Transp.:')          SIZE 100, 8 OF oDlg2 PIXEL
		@ 301,080 MSGET oGet026 VAR nQtd5 Picture "@E 99"        SIZE 030,9  OF oDlg2 PIXEL
		
		@ 323,010 SAY OemToAnsi('Código VAlimentação:')          SIZE 100, 8 OF oDlg2 PIXEL
		@ 321,080 MSGET oGet027 VAR cAlim F3 'ZT8001' SIZE 030,9  OF oDlg2 PIXEL
		
		@ 343,010 SAY OemToAnsi('Inicio VAlimentação:')          SIZE 100, 8 OF oDlg2 PIXEL
		@ 341,080 MSGET oGet028 VAR dAlim Picture "@R 99/99/9999" SIZE 030,9  OF oDlg2 PIXEL
		
		@ 363,010 SAY OemToAnsi('Fim VAlimentação:')          SIZE 100, 8 OF oDlg2 PIXEL
		@ 361,080 MSGET oGet029 VAR dFAlim Picture "@R 99/99/9999" SIZE 030,9  OF oDlg2 PIXEL

		@ 383,010 SAY OemToAnsi('Código VRefeição:')          SIZE 100, 8 OF oDlg2 PIXEL
		@ 381,080 MSGET oGet030 VAR cRef F3 'ZT8001'  SIZE 030,9  OF oDlg2 PIXEL
		
		@ 403,010 SAY OemToAnsi('Inicio VRefeição:')          SIZE 100, 8 OF oDlg2 PIXEL
		@ 401,080 MSGET oGet031 VAR dRef Picture "@R 99/99/9999" SIZE 030,9  OF oDlg2 PIXEL

		//DEFINE SBUTTON FROM 60, 113 TYPE 1 ACTION (nOpca:=1,oDlg2:End()) ENABLE OF oDlg2
		//DEFINE SBUTTON FROM 60, 143 TYPE 2 ACTION (oDlg2:End())  ENABLE OF oDlg2
		DEFINE SBUTTON FROM 423, 010 TYPE 1 ACTION (nOpca:=1,oDlg2:End()) ENABLE OF oDlg2
		DEFINE SBUTTON FROM 423, 080 TYPE 2 ACTION (oDlg2:End())  ENABLE OF oDlg2
		ACTIVATE MSDIALOG oDlg2
		
		If Empty(cPlanoOd) .and. Empty(cPlano) .and. Empty(cMeio1) .and. Empty(cMeio2) .and. Empty(cMeio3) .and. Empty(cMeio4) .and.;
		Empty(cMeio5) .and. Empty(cAlim) .and. Empty(cRef) 
				MsgStop('Você não incluiu os beneficios. Faça manualmente depois!')
			Return
		EndIf
		
		If !Empty(cPlanoOd) .and. !Empty(cFAsOdo)
			//ODONTO
			RHK->(RecLock('RHK',.T.))
			RHK->RHK_FILIAL := SRA->RA_FILIAL
			RHK->RHK_MAT    := SRA->RA_MAT
			RHK->RHK_TPFORN := '2'
			RHK->RHK_CODFOR := cFAsOdo
			RHK->RHK_TPPLAN := '4'
			RHK->RHK_PLANO  := cPlanoOd
			RHK->RHK_PD     := '549'
			RHK->RHK_PDDAGR := '652'
			RHK->RHK_PERINI := Subs(cIniAo,1,2)+Subs(cIniAo,4)
			RHK->(MsUnLock())
		End If
		
		If !Empty(cPlano).and. !Empty(cFAsMed)
			//MEDICO
			RHK->(RecLock('RHK',.T.))
			RHK->RHK_FILIAL := SRA->RA_FILIAL
			RHK->RHK_MAT    := SRA->RA_MAT
			RHK->RHK_TPFORN := '1'
			RHK->RHK_CODFOR := cFAsMed
			RHK->RHK_TPPLAN := '1'
			RHK->RHK_PLANO  := cPlano
			RHK->RHK_PD     := '506'
			RHK->RHK_PDDAGR := '651'
			RHK->RHK_PERINI := Subs(cIniAm,1,2)+Subs(cIniAm,4)
			RHK->(MsUnLock())
			
		End If
		
		If !Empty(cMeio1) .and. nQtd1 > 0
			ZTA->(RecLock('ZTA',.T.))
			ZTA->ZTA_FILIAL := SRA->RA_FILIAL
			ZTA->ZTA_MAT    := SRA->RA_MAT
			ZTA->ZTA_COD    := cMeio1
			ZTA->ZTA_DESC   := Alltrim(Posicione("SRN",1,XFILIAL("SRN")+cMeio1,"RN_DESC"))
			ZTA->ZTA_QDEDIA := nQtd1
			ZTA->ZTA_CC     := SRA->RA_CC
			ZTA->(MsUnLock())
		Endif
		
		If !Empty(cMeio2) .and. nQtd2 > 0
			ZTA->(RecLock('ZTA',.T.))
			ZTA->ZTA_FILIAL := SRA->RA_FILIAL
			ZTA->ZTA_MAT    := SRA->RA_MAT
			ZTA->ZTA_COD    := cMeio2
			ZTA->ZTA_DESC   := Alltrim(Posicione("SRN",1,XFILIAL("SRN")+cMeio2,"RN_DESC"))
			ZTA->ZTA_QDEDIA := nQtd2
			ZTA->ZTA_CC     := SRA->RA_CC
			ZTA->(MsUnLock())
		Endif
		
		If !Empty(cMeio3) .and. nQtd3 > 0
			ZTA->(RecLock('ZTA',.T.))
			ZTA->ZTA_FILIAL := SRA->RA_FILIAL
			ZTA->ZTA_MAT    := SRA->RA_MAT
			ZTA->ZTA_COD    := cMeio3
			ZTA->ZTA_DESC   := Alltrim(Posicione("SRN",1,XFILIAL("SRN")+cMeio3,"RN_DESC"))
			ZTA->ZTA_QDEDIA := nQtd3
			ZTA->ZTA_CC     := SRA->RA_CC
			ZTA->(MsUnLock())
		Endif
		
		If !Empty(cMeio4) .and. nQtd4 > 0
			ZTA->(RecLock('ZTA',.T.))
			ZTA->ZTA_FILIAL := SRA->RA_FILIAL
			ZTA->ZTA_MAT    := SRA->RA_MAT
			ZTA->ZTA_COD    := cMeio4
			ZTA->ZTA_DESC   := Alltrim(Posicione("SRN",1,XFILIAL("SRN")+cMeio4,"RN_DESC"))
			ZTA->ZTA_QDEDIA := nQtd4
			ZTA->ZTA_CC     := SRA->RA_CC
			ZTA->(MsUnLock())
		Endif
		
		If !Empty(cMeio5) .and. nQtd5 > 0
			ZTA->(RecLock('ZTA',.T.))
			ZTA->ZTA_FILIAL := SRA->RA_FILIAL
			ZTA->ZTA_MAT    := SRA->RA_MAT
			ZTA->ZTA_COD    := cMeio5
			ZTA->ZTA_DESC   := Alltrim(Posicione("SRN",1,XFILIAL("SRN")+cMeio5,"RN_DESC"))
			ZTA->ZTA_QDEDIA := nQtd5
			ZTA->ZTA_CC     := SRA->RA_CC
			ZTA->(MsUnLock())
		Endif
		
		If !Empty(cAlim) .and. !Empty(dAlim)
			ZT6->(RecLock('ZT6',.T.))
			ZT6->ZT6_FILIAL := SRA->RA_FILIAL
			ZT6->ZT6_MAT    := SRA->RA_MAT
			ZT6->ZT6_COD 	:= cAlim
			ZT6->ZT6_DESC   := Alltrim(Posicione("ZT8",1,xFilial("ZT8")+cAlim,"ZT8_DESC"))
			ZT6->ZT6_TIPO   := Alltrim(Posicione("ZT8",1,xFilial("ZT8")+cAlim,"ZT8_TIPO"))
			ZT6->ZT6_DTINI  := dAlim
			ZT6->ZT6_DTFIM  := dFAlim
			ZT6->ZT6_CC     := SRA->RA_CC
			ZT6->(MsUnLock())
		Endif
		
		If !Empty(cRef) .and. !Empty(dRef)
			ZT6->(RecLock('ZT6',.T.))
			ZT6->ZT6_FILIAL := SRA->RA_FILIAL
			ZT6->ZT6_MAT    := SRA->RA_MAT
			ZT6->ZT6_COD 	:= cRef
			ZT6->ZT6_DESC   := Alltrim(Posicione("ZT8",1,xFilial("ZT8")+cRef,"ZT8_DESC"))
			ZT6->ZT6_TIPO   := Alltrim(Posicione("ZT8",1,xFilial("ZT8")+cRef,"ZT8_TIPO"))
			ZT6->ZT6_DTINI  := dRef
			ZT6->ZT6_CC     := SRA->RA_CC
			ZT6->(MsUnLock())
		Endif
		
		MsgAlert("BENEFÍCIOS DO TITULAR CADASTRADOS. APÓS INCLUIR OS DEPENDENTES, NÃO ESQUEÇA DE CADASTRAR OS RESPECTIVOS PLANOS DE SAUDE !!!")
		
	End If
Endif
Return
