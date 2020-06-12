#INCLUDE "FINXFUN.CH"
#Include "PROTHEUS.CH"

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³F050BUT   ºAutor  ³Claudio Barros      º Data ³  20/07/06   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³Ponto de Entrada para visualizacao do rateio financeiro no  º±±
±±º          ³SE2                                                         º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ SIGAFIN - CIEE - Protheus 8                                º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/


User Function F050BUT()


Local aBut050 := {}

//Private aHeader := {}
//Private aCols := {}
//Private aRegs := {}

If	INCLUI == .F. .and. ALTERA == .F. .AND. SE2->E2_MULNATU == "1"
  Aadd(aBut050, {'S4WB013N',{||	MultNat("SE2",0,M->E2_VALOR,"",.F.,2) },"Rateio das Naturezas do titulo","Rateio"} ) //"Rateio das Naturezas do titulo"###"Rateio das Naturezas do titulo"
ElseIf	ALTERA == .T. .AND. SE2->E2_MULNATU == "1" // Incluido pelo analista Emerson para permitir a alteracao das Naturezas (somente) no processo de Multi Naturezas (17/01/07)
	If FUNNAME() == "CFINA10"
//		Nao sei porque estava sendo usado a funcao u_MultNat_1 customizada. Coloquei para pegar a padrao MultNat pois com a anterior nao estava trazendo
//		o campo customizaco XCOMPET.
//		Esta alteracao foi realizada dia 16/06/11 pelo analista Emerson
//		Aadd(aBut050, {'S4WB013N',{||	u_MultNat_1("SE2",0,M->E2_VALOR,"",.F.,4) },"Rateio das Naturezas do titulo","Rateio"} ) //"Rateio das Naturezas do titulo"###"Rateio das Naturezas do titulo"
		Aadd(aBut050, {'S4WB013N',{||	MultNat("SE2",0,M->E2_VALOR,"",.F.,4) },"Rateio das Naturezas do titulo","Rateio"} ) //"Rateio das Naturezas do titulo"###"Rateio das Naturezas do titulo"
	EndIf
EndIf

Return(aBut050)


/*/
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡…o	 ³MultNat	³ Autor ³ Claudio Donizete Souza³ Data ³ 22/05/01 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³Distribui o valor do titulo em varias naturezas     		  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Sintaxe	 ³MultNat(cAlias)                 							  ³±±
±±³       	 ³cAlias -> Alias do Arquivo (SE1 ou SE2)					  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso		 ³ FINA040,FINA050											  ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±³ Alteracao³ Alterado pelo analista Emerson na linha 799 acrescentando  ³±±
±±³       	 ³ a funcao DBSELECTAREA na tabela SEV pois ao deletar itens  ³±±
±±³       	 ³ na Multi-Natureza o sistema esta se perdendo e baguncando  ³±±
±±³       	 ³ os registros alterados.                                    ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
User Function MultNat_1(	cAlias,nHdlPrv,nTotal,cArquivo,lContabiliza,nOpc,nImpostos,;
							lRatImpostos, aColsM, aHeaderM, aRegs, lGrava, lMostraTela, lRotAuto)

LOCAL aCampos	:= { 	"EV_NATUREZ",;
						"EV_VALOR"  ,;
						"EV_PERC" ,;
						"EV_RATEICC" } 	// Indica quais campos serao
							 	    	// exbididos na GetDados
										// e na ordem que devem aparecer
LOCAL cCampo    := Right(cAlias,2) 
LOCAL nX
LOCAL bTit      := { |cChave| SX3->(DbSeek(cChave)), X3Titulo() } 
LOCAL oDlg
LOCAL oGet
LOCAL aArea  	:= GetArea()
LOCAL aArea1 	:= (cAlias)->(GetArea())
LOCAL cPic  	:= PesqPict("SE2","E2_VALOR",19)
LOCAL cPadrao 	:= If(cAlias=="SE1","500","510")
LOCAL lPadrao 	:= VerPadrao(cPadrao)  
LOCAL cPadraoCC := If(cAlias=="SE1","506","508")
LOCAL lPadraoCC := VerPadrao(cPadraoCC), aButton := {}
LOCAL lCtbRatCC := .F.  // Controle de contabilizacao por Rateio C.Custo
Local lGrvSev	:= ExistBlock("MULTSEV")
Local lGrvSez	:= ExistBlock("MULTSEZ"), lInclui
Local cChaveIrf	:= 	If(cAlias = "SE2" .And. M->E2_IRRF > 0, SE2->E2_PREFIXO +;
	 				SE2->E2_NUM + SE2->E2_PARCIR +;
	 				Iif(SE2->E2_TIPO $ MVPAGANT+"/"+MV_CPNEG,MVTXA,MVTAXA), "")
Local cChaveIns	:= 	If(cAlias = "SE2" .And. M->E2_INSS > 0,;
					SE2->E2_PREFIXO + SE2->E2_NUM + SE2->E2_PARCINS + MVINSS, "")
Local cChaveIss	:= 	If(cAlias = "SE2" .And. M->E2_ISS > 0,;
					SE2->E2_PREFIXO + SE2->E2_NUM + SE2->E2_PARCISS + MVISS, "")
Local nRecno	:= (cAlias)->(Recno())
Local aRatIrf	:= {}, aRatIns := {}, aRatIss := {}
Local nRatIrf1	:= nRatIns1 := nRatIss1 := nPos := 0
Local nRatIrf2	:= nRatIns2 := nRatIss2 := nCont := nCont1 := nCont2 := nCont3 := 0
Local nTotSev	:= nTotSez := nPerSev := nPerSez := 0
Local cChave	:= 	If(lGrvSez .Or. lGrvSev,;
					(cAlias)->&(cCampo + "_PREFIXO") +;
					(cAlias)->&(cCampo + "_NUM") +;
					(cAlias)->&(cCampo + "_PARCELA") +;
					(cAlias)->&(cCampo + "_TIPO") +;
					(cAlias)->&(cCampo + If(cAlias == "SE1", "_CLIENTE","_FORNECE")) +;
					(cAlias)->&(cCampo + "_LOJA"), "")
Local nDiff := 0
Local nPosDiff := 0
Local cOrigem := If(cAlias=="SE1","FINA040","FINA050")
Local lRtNattel := Existblock("RTNATTEL")

Local cChavePis	:= If(cAlias = "SE2" .And. M->E2_PIS > 0, SE2->E2_PREFIXO +;
	 				SE2->E2_NUM + SE2->E2_PARCPIS +;
	 				Iif(SE2->E2_TIPO $ MVPAGANT+"/"+MV_CPNEG,MVTXA,MVTAXA), "")

Local cChaveCof	:=	If(cAlias = "SE2" .And. M->E2_COFINS > 0, SE2->E2_PREFIXO +;
	 				SE2->E2_NUM + SE2->E2_PARCCOF +;
	 				Iif(SE2->E2_TIPO $ MVPAGANT+"/"+MV_CPNEG,MVTXA,MVTAXA), "")

Local cChaveCsl	:=	If(cAlias = "SE2" .And. M->E2_CSLL > 0, SE2->E2_PREFIXO +;
	 				SE2->E2_NUM + SE2->E2_PARCSLL +;
	 				Iif(SE2->E2_TIPO $ MVPAGANT+"/"+MV_CPNEG,MVTXA,MVTAXA), "")

Local aRatPis	:= {}, aRatCof := {}, aRatCsl := {}
Local nRatPis1	:= nRatCof1 := nRatCsl1 := 0
Local nRatPis2	:= nRatCof2 := nRatCsl2 := 0
Local nCont4 := nCont5 := nCont6 := 0

PRIVATE oValDist  
PRIVATE nValDist  := 0
PRIVATE nVlTit
PRIVATE aTit      := {}
PRIVATE nOpcA 	   := 0
PRIVATE oValFal
PRIVATE oPerFal   
PRIVATE nValFal	:= 0   
PRIVATE nPerFal	:= 100   

/*
DEFAULT nOpc	 	:= 3
DEFAULT nImpostos	:= 0
DEFAULT lRatImpostos	:= .F.
DEFAULT lGrava		:= .T.
DEFAULT aColsM		:= {}
DEFAULT aHeaderM	:= {}
DEFAULT lMostraTela	:= .T.
DEFAULT aRegs		:= {}
DEFAULT lRotAuto  := .F.
*/

PRIVATE nImpostos	:= 0
PRIVATE lRatImpostos	:= .F.
PRIVATE lGrava		:= .T.
PRIVATE aColsM		:= {}
PRIVATE aHeaderM	:= {}
PRIVATE lMostraTela	:= .T.
PRIVATE aRegs		:= {}
PRIVATE lRotAuto  := .F.


If !lRotAuto
	PRIVATE aCols		:= {}
	PRIVATE aHeader	:= {}
EndIf

If ! Empty(cChaveIrf)
	cChaveIrf += GetMV("MV_UNIAO") + Space(Len(SE2->E2_FORNECE) - Len(GetMV("MV_UNIAO"))) + "00"
Endif

If ! Empty(cChaveIns)
	cChaveIns += GetMV("MV_FORINSS") + Space(Len(SE2->E2_FORNECE) - Len(GetMV("MV_FORINSS"))) + "00"
Endif

If ! Empty(cChaveIss)
	cChaveIss += GetMV("MV_MUNIC") + Space(Len(SE2->E2_FORNECE) - Len(GetMV("MV_MUNIC"))) + "00"
Endif

If ! Empty(cChavePis)
	cChavePis += GetMV("MV_UNIAO") + Space(Len(SE2->E2_FORNECE) - Len(GetMV("MV_UNIAO"))) + "00"
Endif

If ! Empty(cChaveCof)
	cChaveCof += GetMV("MV_UNIAO") + Space(Len(SE2->E2_FORNECE) - Len(GetMV("MV_UNIAO"))) + "00"
Endif

If ! Empty(cChaveCsl)
	cChaveCsl += GetMV("MV_UNIAO") + Space(Len(SE2->E2_FORNECE) - Len(GetMV("MV_UNIAO"))) + "00"
Endif

If nOpc # 3
	Aadd(aButton, {'S4WB013N',{||MulNatCC(nOpc) },STR0080,STR0081} ) //"Rateio Centro de Custo"
	nVlTit	:= M->&(cCampo + "_VALOR") + nImpostos // Valor do titulo
Else
	nVlTit	:= (cAlias)->&(cCampo + "_VALOR") + nImpostos // Valor do titulo
Endif
nValFal 	:= M->&(cCampo + "_VALOR") + nImpostos // Valor do titulo

__OPC 	:= nOpc

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Montagem da matriz aHeader e aCampos						 ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

dbSelectArea("SX3")
dbSetOrder(2)

SEV->(dbSetOrder(2))
If (nOpc # 3 .And. 	Len(aColsM) = 0 .and. ;
		SEV->(MsSeek(xFilial()+;
				(cAlias)->&(cCampo + "_PREFIXO")+;
		      (cAlias)->&(cCampo + "_NUM")+;
	  	     	(cAlias)->&(cCampo + "_PARCELA")+;
				(cAlias)->&(cCampo + "_TIPO")+;
				(cAlias)->&(cCampo + If(cAlias == "SE1", "_CLIENTE","_FORNECE"))+;
				(cAlias)->&(cCampo + "_LOJA")+;
				"1")))		//1=Inclusao

	// Crio aHeader
	// Adiciona os campos na ordem em que devem aparecer
	For nX := 1 To Len(aCampos)
		SX3->(DbSetOrder(2))
		SX3->(MsSeek(Pad(aCampos[nX],10)))
		If Ascan(aHeader, {|e| AllTrim(e[2]) == AllTrim(SX3->X3_CAMPO) } )  == 0
			Aadd(aHeader,{ AllTrim(X3Titulo()),SX3->X3_CAMPO,SX3->X3_PICTURE,SX3->X3_TAMANHO,SX3->X3_DECIMAL,SX3->X3_VALID,SX3->X3_USADO,SX3->X3_TIPO,SX3->X3_ARQUIVO,SX3->X3_CONTEXT } )
		Endif
	Next
	SX3->(dbSetOrder(1))
	SX3->(dbSeek("SEV"))
	// Adiciono demais campos
	While ! SX3->(EOF()) .And. (SX3->X3_Arquivo == "SEV")
		If X3USO(SX3->X3_Usado) .And. cNivel >= SX3->X3_NIVEL
			If Ascan(aHeader, {|e| AllTrim(e[2]) == AllTrim(SX3->X3_CAMPO) } )  == 0
				Aadd(aHeader,{ AllTrim(X3Titulo()),SX3->X3_CAMPO,SX3->X3_PICTURE,SX3->X3_TAMANHO,SX3->X3_DECIMAL,SX3->X3_VALID,SX3->X3_USADO,SX3->X3_TIPO,SX3->X3_ARQUIVO,SX3->X3_CONTEXT } )
			Endif
		Endif
		SX3->(DbSkip())
	EndDo
			
	While SEV->EV_FILIAL + SEV->EV_PREFIXO + SEV->EV_NUM +;
		  	SEV->EV_PARCELA + SEV->EV_TIPO + SEV->EV_CLIFOR +;
			SEV->EV_LOJA+SEV->EV_IDENT == xFilial("SEV")+;
			(cAlias)->&(cCampo + "_PREFIXO")+;
			(cAlias)->&(cCampo + "_NUM")+;
		  	(cAlias)->&(cCampo + "_PARCELA")+;
			(cAlias)->&(cCampo + "_TIPO")+;
			(cAlias)->&(cCampo + If(cAlias == "SE1", "_CLIENTE","_FORNECE"))+;
			(cAlias)->&(cCampo + "_LOJA")+;
			"1"	//1 = Inclusao

		SX3->(DbSetOrder(2))
		Aadd(aCols,Array(Len(aHeader)))

		For nX := 1 To Len(aHeader)
			SX3->(MsSeek(Pad(aHeader[nX][2],10)))
			If Alltrim(SX3->X3_CAMPO) == "EV_PERC" // Percentual
				aHeader[nX][6] := "MNatCalcV()"
				// Inclui em aCols como caracter para ser possivel a visualizacao na 
				// tela, por ser a ultima coluna da getdados
				aHeader[nX][8]	:= "C" 
				aHeader[nX][5]	:= 2
				aCols[Len(aCols)][nX]	:=  Trans(CriaVar("EV_PERC"), "@E 999.99")
			ElseIf Alltrim(SX3->X3_CAMPO) == "EV_VALOR"
				aCols[Len(aCols)][nX] := CriaVar("EV_VALOR")
				aHeader[nX][6] := "MNatCalcP()"
			ElseIf Alltrim(SX3->X3_CAMPO) == "EV_NATUREZ"  
				aCols[Len(aCols)][nX] := CriaVar("EV_NATUREZ")
				aHeader[nX][6] := 'ExistCpo("SED") .And. MNatAltN()'
			Else
				aCols[Len(aCols)][nX] := CriaVar(SX3->X3_CAMPO)
			Endif	
		Next

		aCols[Len(aCols)][1] := SEV->EV_NATUREZ
		aCols[Len(aCols)][2] := Round(NoRound(nVlTit * SEV->EV_PERC, 3), 2)
		aCols[Len(aCols)][3] := Trans(SEV->EV_PERC * 100, "@E 999.99")
		aCols[Len(aCols)][4] := SEV->EV_RATEICC
		Aadd(aCols[Len(aCols)], .F.)
	
		nTotSev += aCols[Len(aCols)][2]
		nPerSev += SEV->EV_PERC * 100
					
		Aadd(aRegs, SEV->(Recno()))
		nValDist := nVlTit
		nValFal	:= 0
		nPerFal	:= 0

		SEV->(DbSkip())
		
	EndDo
	
	If nTotSev # nVlTit .Or. nPerSev # 100
		aCols[Len(aCols)][2] += nVlTit - nTotSev
		aCols[Len(aCols)][3] := Trans(Val(aCols[Len(aCols)][3]) +;
								 100 - nPerSev, "@E 999.99")
	Endif

	If Select("SEZTMP") = 0
		aCposDb := {}
		aadd(aCposDB,{"EZ_NATUREZ","C",10,0})
		aadd(aCposDB,{"EZ_CCUSTO","C",TamSx3("CTT_CUSTO")[1],0})
		aadd(aCposDB,{"EZ_ITEMCTA","C",TamSx3("CTD_ITEM")[1],0})
		aadd(aCposDB,{"EZ_CLVL","C",TamSx3("CTH_CLVL")[1],0})
		aadd(aCposDB,{"EZ_VALOR","N",17,2})
		aadd(aCposDB,{"EZ_PERC","N",11,7})	
		aadd(aCposDB,{"EZ_FLAG","L",1,0})	
		aadd(aCposDB,{"EZ_RECNO","N",6,0})	
		cArqSez := CriaTrab(aCposDB,.T.) // Nome do arquivo temporario do SEZ
		dbUseArea(.T.,__LocalDriver,cArqSez,"SEZTMP",.F.)
	
		cIndice := "EZ_NATUREZ+EZ_CCUSTO"
		dbSelectArea("SEZTMP")
		IndRegua ("SEZTMP",cArqSez,cIndice,,,STR0057) //"Selecionando Registros..."
		#IFNDEF TOP
			dbSetIndex(cArqSez+OrdBagExt())
		#ENDIF
		dbSetOrder(1)
		SEZ->(dbSetOrder(1))	
		SEZ->(MsSeek(xFilial("SEZ")+;
						(cAlias)->&(cCampo + "_PREFIXO")+;
						(cAlias)->&(cCampo + "_NUM")+;
						(cAlias)->&(cCampo + "_PARCELA")+;
						(cAlias)->&(cCampo + "_TIPO")+;
						(cAlias)->&(cCampo + If(cAlias == "SE1", "_CLIENTE","_FORNECE"))+;
						(cAlias)->&(cCampo + "_LOJA")))
						
		While 	SEZ->EZ_FILIAL + SEZ->EZ_PREFIXO + SEZ->EZ_NUM +;
			  	SEZ->EZ_PARCELA + SEZ->EZ_TIPO + SEZ->EZ_CLIFOR +;
				SEZ->EZ_LOJA == xFilial("SEZ")+;
				(cAlias)->&(cCampo + "_PREFIXO")+;
				(cAlias)->&(cCampo + "_NUM")+;
			  	(cAlias)->&(cCampo + "_PARCELA")+;
				(cAlias)->&(cCampo + "_TIPO")+;
				(cAlias)->&(cCampo + If(cAlias == "SE1", "_CLIENTE","_FORNECE"))+;
				(cAlias)->&(cCampo + "_LOJA")

			//Descarto rateios que nao sao de inclusao
			If SEZ->EZ_IDENT != "1"
				SEZ->(dbskip())
				Loop
			Endif				

			RecLock("SEZTMP", .T.)
			nPos := Ascan(aCols, { |x| x[1] = SEZ->EZ_NATUREZ })
			SEZTMP->EZ_NATUREZ	:= SEZ->EZ_NATUREZ
			SEZTMP->EZ_CCUSTO		:= SEZ->EZ_CCUSTO
			SEZTMP->EZ_ITEMCTA	:= SEZ->EZ_ITEMCTA
			SEZTMP->EZ_CLVL   	:= SEZ->EZ_CLVL
			SEZTMP->EZ_VALOR		:= Round(NoRound(aCols[nPos][2] * SEZ->EZ_PERC, 3), 2)
			SEZTMP->EZ_PERC		:= SEZ->EZ_PERC
			SEZTMP->EZ_RECNO		:= SEZ->(Recno())
			nTotSez += SEZTMP->EZ_VALOR
			nPerSez += SEZTMP->EZ_PERC
			MsUnLock()
			SEZ->(DbSkip())
		Enddo
	Endif

ElseIf nOpc # 3
	aCols 	:= AClone(aColsM)
	aHeader := AClone(aHeaderM)
Endif

If (nOpc = 3 .Or. Len(aCols) = 0) .And. !lRotAuto
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Adiciona mais um elemento em aCOLS, indicando se a   ³
	//³ a linha esta ou nao deletada						 ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	Aadd(aCols,Array(Len(aCampos)+1))

	For nX := 1 To Len(aCampos)
		dbSeek(Pad(aCampos[nX],10))
		Aadd(aHeader,{ AllTrim(X3Titulo()),SX3->X3_CAMPO,SX3->X3_PICTURE,SX3->X3_TAMANHO,SX3->X3_DECIMAL,SX3->X3_VALID,SX3->X3_USADO,SX3->X3_TIPO,SX3->X3_ARQUIVO,SX3->X3_CONTEXT } )
		If aHeader[nX][8] == "C"
			aCols[1][nX] := CriaVar(aHeader[nX][2])
		Else
			If Alltrim(aHeader[nX][2]) == "EV_PERC" // Percentual
				aHeader[nX][6] := "MNatCalcV()"
				// Inclui em aCols como caracter para ser possivel a visualizacao na 
				// tela, por ser a ultima coluna da getdados
				aHeader[nX][8] := "C" 
				aHeader[nX][5] := 2
				aCols[1][nX] := Trans(CriaVar("EV_PERC"), "@E 999.99")
			ElseIf Alltrim(aHeader[nX][2]) == "EV_VALOR"
				aCols[1][nX] := CriaVar("EV_VALOR")
				aHeader[nX][6] := "MNatCalcP()"
			Else
				aCols[1][nX] := CriaVar(aHeader[nX][2])
			Endif	
		EndIf
	Next

	// Indica que a linha nao esta deletada
	aCols[1][nX] := .F.
Endif

IF lRtNattel
	Execblock("RTNATTEL",.f.,.f.)
Endif

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Mostra o corpo da rateio 									 ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
nOpca := 0
dbSelectArea("SX3")
dbSetOrder(2)
// Cria os titulos do dialogo
Aadd( aTit, Eval(bTit, cCampo + If(cAlias == "SE1", "_CLIENTE","_FORNECE")))
Aadd( aTit, Eval(bTit, cCampo + "_LOJA"))
Aadd( aTit, Eval(bTit, cCampo + "_PREFIXO"))
Aadd( aTit, Eval(bTit, cCampo + "_NUM"))
Aadd( aTit, Eval(bTit, cCampo + "_PARCELA"))
Aadd( aTit, Eval(bTit, cCampo + "_VALOR" ))
Aadd( aTit, cAlias)	

If lMostraTela	.And. !lRotAuto
	DEFINE MSDIALOG oDlg TITLE OemToAnsi(STR0030) From 9,0 To 32.2,80 OF oMainWnd  //	"Naturezas do titulo"
	@  1.6 ,  1.4 Say aTit[1] + (cAlias)->&(cCampo + If(cAlias == "SE1", "_CLIENTE","_FORNECE"))	FONT oDlg:oFont
	@  1.6 , 13   Say aTit[2] + (cAlias)->&(cCampo + "_LOJA")    	FONT oDlg:oFont	
	@  1.6 , 19   Say aTit[3] + (cAlias)->&(cCampo + "_PREFIXO") 	FONT oDlg:oFont
	@  1.6 , 24   Say aTit[4] + (cAlias)->&(cCampo + "_NUM")	 	FONT oDlg:oFont
	@  1.6 , 41   Say aTit[5] + (cAlias)->&(cCampo + "_PARCELA") 	FONT oDlg:oFont

	@  9.4, 0.5 To 11.8,18 OF oDlg
	@  9.4,18.6 To 11.8,39 OF oDlg
	
	@ 10.6 , 1.4  Say aTit[6] FONT oDlg:oFont 
	@ 10.6 , 7.6  Say nVlTit	PICTURE cPic FONT oDlg:oFont
		
	@ 11.6 , 1.4  Say OemToAnsi(STR0031)  				FONT oDlg:oFont // "Total Distribuido: "
	@ 11.6 , 7.6  Say oValDist VAR nValDist PICTURE cPic	FONT oDlg:oFont 
		
	@ 10.6 , 19  Say STR0082				FONT oDlg:oFont //"Valor a Distribuir"
	@ 10.6 , 28  Say oValFal VAR nValFal PICTURE cPic	FONT oDlg:oFont 

	@ 11.6 , 19  Say STR0083				FONT oDlg:oFont //"Percentual a Distribuir"
	@ 11.6 , 30  Say oPerFal VAR nPerFal PICTURE "@E 999.99"	FONT oDlg:oFont 
		
	@  1.0, 0.5 To  2.35,18 OF oDlg
	@  1.0,18.6 To  2.35,39 OF oDlg
	
	oGet := MSGetDados():New(34,5,128,315,nOpc,"MNatLinOk", "AllwaysTrue",,nOpc # 2)
	
	ACTIVATE 	MSDIALOG oDlg ON INIT EnchoiceBar(oDlg,{||nOpca:=1,If(oGet:TudoOk() .And. FaMNatOk(),;
				oDlg:End(),nOpca := 0)},{||nOpca:=0,oDlg:End()},,aButton) CENTER
Else
	nOpcA := 1
Endif
				
If nOpca == 1 .And. lGrava .And. nOpc # 2
	DbSelectArea(cAlias)
	SE2->(DbSetOrder(1))

	//IRRF
	If ! Empty(cChaveIrf) .And. SE2->(DbSeek(xFilial() + cChaveIrf))
		Reclock(cAlias)
		Replace (cAlias)->&(cCampo + "_MULTNAT") With If(lRatImpostos, "1", "2")
		MsUnlock()

      If lRatImpostos
			// Armazeno o valor do rateio para os impostos ja arredondado no ultimo        
        
			nDiff := nPosDiff := 0
			For nX := 1 To Len(aCols)
			   // Se a linha de aCols nao estiver deletada e o registro nao for 
				// encontrado no SEV
				If !aCols[nX][Len(aCols[nX])]
					Aadd(aRatIrf, { M->E2_IRRF * (Val(aCols[nX][3]) / 100), {} })	// Grava o valor informado
					nRatIrf1 += aRatIrf[Len(aRatIrf)][1]
		        	nCont := 0

					If Select("SEZTMP") > 0 .And. aCols[nX][4] == "1"

						dbSelectArea("SEZTMP")
						// busca natureza no arquivo TMP de Mult Nat C.Custo
						If dbSeek(aCols[nX][1]) 
							While !Eof() .and. SEZTMP->EZ_NATUREZ == aCols[nX][1]
								Aadd(aRatIrf[Len(aRatIrf)][2], Round(NoRound((M->E2_IRRF * (Val(aCols[nX][3]) / 100)) * SEZTMP->EZ_PERC, 2), 3)) // Grava o valor informado								
								nCont ++
								nRatIrf2 += aRatIrf[Len(aRatIrf)][2][nCont]
								DbSkip()
							EndDo
							nDiff 		:= nCont
							nPosDiff    := Len(aRatIrf)
						Endif
					Endif
				Endif
			Next

			If Len(aRatIrf) > 0 .And. nRatIrf1 <> M->E2_IRRF
				If nRatIrf1 > M->E2_IRRF
					aRatIrf[Len(aRatIrf)][1] -= nRatIrf1 - M->E2_IRRF
				Else
					aRatIrf[Len(aRatIrf)][1] += M->E2_IRRF - nRatIrf1
				Endif
			Endif

			If nDiff > 0 .And. Len(aRatIrf) > 0 .And. nRatIrf2 <> M->E2_IRRF .And. nRatIrf2 > 0
				If nRatIrf2 > M->E2_IRRF
					aRatIrf[nPosDiff][2][nDiff] -= nRatIrf2 - M->E2_IRRF
				Else
					aRatIrf[nPosDiff][2][nDiff] += M->E2_IRRF - nRatIrf2
				Endif
			Endif
		Endif
	Endif
	
	//Pis
	If ! Empty(cChavePis) .And. SE2->(DbSeek(xFilial() + cChavePis))
		Reclock(cAlias)
		Replace (cAlias)->&(cCampo + "_MULTNAT") With If(lRatImpostos, "1", "2")
		MsUnlock()

      If lRatImpostos
			// Armazeno o valor do rateio para os impostos ja arredondado no ultimo        
        
			nDiff := nPosDiff := 0
			For nX := 1 To Len(aCols)
			   // Se a linha de aCols nao estiver deletada e o registro nao for 
				// encontrado no SEV
				If !aCols[nX][Len(aCols[nX])]
					Aadd(aRatPis, { M->E2_PIS * (Val(aCols[nX][3]) / 100), {} })	// Grava o valor informado
					nRatPis1 += aRatPis[Len(aRatPis)][1]
		        	nCont := 0

					If Select("SEZTMP") > 0 .And. aCols[nX][4] == "1"

						dbSelectArea("SEZTMP")
						// busca natureza no arquivo TMP de Mult Nat C.Custo
						If dbSeek(aCols[nX][1]) 
							While !Eof() .and. SEZTMP->EZ_NATUREZ == aCols[nX][1]
								Aadd(aRatPis[Len(aRatPis)][2], Round(NoRound((M->E2_PIS * (Val(aCols[nX][3]) / 100)) * SEZTMP->EZ_PERC, 2), 3)) // Grava o valor informado								
								nCont ++
								nRatPis2 += aRatPis[Len(aRatPis)][2][nCont]
								DbSkip()
							EndDo
							nDiff 		:= nCont
							nPosDiff    := Len(aRatPis)
						Endif
					Endif
				Endif
			Next

			If Len(aRatPis) > 0 .And. nRatPis1 <> M->E2_PIS
				If nRatPis1 > M->E2_PIS
					aRatPis[Len(aRatPis)][1] -= nRatPis1 - M->E2_PIS
				Else
					aRatPis[Len(aRatPis)][1] += M->E2_PIS - nRatPis1
				Endif
			Endif

			If nDiff > 0 .And. Len(aRatPis) > 0 .And. nRatPis2 <> M->E2_PIS .And. nRatPis2 > 0
				If nRatPis2 > M->E2_PIS
					aRatPis[nPosDiff][2][nDiff] -= nRatPis2 - M->E2_PIS
				Else
					aRatPis[nPosDiff][2][nDiff] += M->E2_PIS - nRatPis2
				Endif
			Endif
		Endif
	Endif


	//COFINS
	If ! Empty(cChaveCof) .And. SE2->(DbSeek(xFilial() + cChaveCof))
		Reclock(cAlias)
		Replace (cAlias)->&(cCampo + "_MULTNAT") With If(lRatImpostos, "1", "2")
		MsUnlock()

      If lRatImpostos
			// Armazeno o valor do rateio para os impostos ja arredondado no ultimo        
        
			nDiff := nPosDiff := 0
			For nX := 1 To Len(aCols)
			   // Se a linha de aCols nao estiver deletada e o registro nao for 
				// encontrado no SEV
				If !aCols[nX][Len(aCols[nX])]
					Aadd(aRatCof, { M->E2_COFINS * (Val(aCols[nX][3]) / 100), {} })	// Grava o valor informado
					nRatCof1 += aRatCof[Len(aRatCof)][1]
		        	nCont := 0

					If Select("SEZTMP") > 0 .And. aCols[nX][4] == "1"

						dbSelectArea("SEZTMP")
						// busca natureza no arquivo TMP de Mult Nat C.Custo
						If dbSeek(aCols[nX][1]) 
							While !Eof() .and. SEZTMP->EZ_NATUREZ == aCols[nX][1]
								Aadd(aRatCof[Len(aRatCof)][2], Round(NoRound((M->E2_COFINS * (Val(aCols[nX][3]) / 100)) * SEZTMP->EZ_PERC, 2), 3)) // Grava o valor informado								
								nCont ++
								nRatCof2 += aRatCof[Len(aRatCof)][2][nCont]
								DbSkip()
							EndDo
							nDiff 		:= nCont
							nPosDiff    := Len(aRatCof)
						Endif
					Endif
				Endif
			Next

			If Len(aRatCof) > 0 .And. nRatCof1 <> M->E2_COFINS
				If nRatCof1 > M->E2_COFINS
					aRatCof[Len(aRatCof)][1] -= nRatCof1 - M->E2_COFINS
				Else
					aRatCof[Len(aRatCof)][1] += M->E2_COFINS - nRatCof1
				Endif
			Endif

			If nDiff > 0 .And. Len(aRatCof) > 0 .And. nRatCof2 <> M->E2_COFINS .And. nRatCof2 > 0
				If nRatCof2 > M->E2_COFINS
					aRatCof[nPosDiff][2][nDiff] -= nRatCof2 - M->E2_COFINS
				Else
					aRatCof[nPosDiff][2][nDiff] += M->E2_COFINS - nRatCof2
				Endif
			Endif
		Endif
	Endif
	
	
	//Csll
	If ! Empty(cChaveCsl) .And. SE2->(DbSeek(xFilial() + cChaveCsl))
		Reclock(cAlias)
		Replace (cAlias)->&(cCampo + "_MULTNAT") With If(lRatImpostos, "1", "2")
		MsUnlock()

      If lRatImpostos
			// Armazeno o valor do rateio para os impostos ja arredondado no ultimo        
        
			nDiff := nPosDiff := 0
			For nX := 1 To Len(aCols)
			   // Se a linha de aCols nao estiver deletada e o registro nao for 
				// encontrado no SEV
				If !aCols[nX][Len(aCols[nX])]
					Aadd(aRatCsl, { M->E2_CSLL * (Val(aCols[nX][3]) / 100), {} })	// Grava o valor informado
					nRatCsl1 += aRatCsl[Len(aRatCsl)][1]
		        	nCont := 0

					If Select("SEZTMP") > 0 .And. aCols[nX][4] == "1"

						dbSelectArea("SEZTMP")
						// busca natureza no arquivo TMP de Mult Nat C.Custo
						If dbSeek(aCols[nX][1]) 
							While !Eof() .and. SEZTMP->EZ_NATUREZ == aCols[nX][1]
								Aadd(aRatCsl[Len(aRatCsl)][2], Round(NoRound((M->E2_CSLL * (Val(aCols[nX][3]) / 100)) * SEZTMP->EZ_PERC, 2), 3)) // Grava o valor informado								
								nCont ++
								nRatCsl2 += aRatCsl[Len(aRatCsl)][2][nCont]
								DbSkip()
							EndDo
							nDiff 		:= nCont
							nPosDiff    := Len(aRatCsl)
						Endif
					Endif
				Endif
			Next

			If Len(aRatCsl) > 0 .And. nRatCsl1 <> M->E2_CSLL
				If nRatCsl1 > M->E2_CSLL
					aRatCsl[Len(aRatCsl)][1] -= nRatCsl1 - M->E2_CSLL
				Else
					aRatCsl[Len(aRatCsl)][1] += M->E2_CSLL - nRatCsl1
				Endif
			Endif

			If nDiff > 0 .And. Len(aRatCsl) > 0 .And. nRatCsl2 <> M->E2_CSLL .And. nRatCSL2 > 0
				If nRatCsl2 > M->E2_CSLL
					aRatCsl[nPosDiff][2][nDiff] -= nRatCsl2 - M->E2_CSLL
				Else
					aRatCsl[nPosDiff][2][nDiff] += M->E2_CSLL - nRatCsl2
				Endif
			Endif
		Endif
	Endif

	If ! Empty(cChaveIns) .And. SE2->(DbSeek(xFilial() + cChaveIns))
		// Armazeno o valor do rateio para os impostos ja arredondado no ultimo                
		Reclock(cAlias)
		Replace (cAlias)->&(cCampo + "_MULTNAT") With If(lRatImpostos, "1", "2")
		MsUnlock()

      If lRatImpostos
			nDiff := nPosDiff := 0
			For nX := 1 To Len(aCols)
			   // Se a linha de aCols nao estiver deletada e o registro nao for 
				// encontrado no SEV
				If 	!aCols[nX][Len(aCols[nX])]
					Aadd(aRatIns, { M->E2_INSS * (Val(aCols[nX][3]) / 100), {} })	// Grava o valor informado
					nRatIns1 += aRatIns[Len(aRatIns)][1]
					
					If Select("SEZTMP") > 0 .And. aCols[nX][4] == "1"

						dbSelectArea("SEZTMP")
	
			        	nCont := 0
						// busca natureza no arquivo TMP de Mult Nat C.Custo
						If dbSeek(aCols[nX][1]) 
							While !Eof() .and. SEZTMP->EZ_NATUREZ == aCols[nX][1]
								Aadd(aRatIns[Len(aRatIns)][2], Round(NoRound((M->E2_INSS * (Val(aCols[nX][3]) / 100)) * SEZTMP->EZ_PERC, 3), 2)) // Grava o valor informado
								nCont ++
								nRatIns2 += aRatIns[Len(aRatIns)][2][nCont]
								DbSkip()
							EndDo
							nDiff 		:= nCont
							nPosDiff    := Len(aRatIns)
						Endif
					Endif
				Endif
			Next

			If Len(aRatIns) > 0 .And. nRatIns1 <> M->E2_INSS
				If nRatIns1 > M->E2_INSS
					aRatIns[Len(aRatIns)][1] -= nRatIns1 - M->E2_INSS
				Else
					aRatIns[Len(aRatIns)][1] += M->E2_INSS - nRatIns1
				Endif
			Endif

			If nDiff > 0 .And. Len(aRatIns) > 0 .And. nRatIns2 <> M->E2_INSS .And. nRatIns2 > 0
				If nRatIns2 > M->E2_INSS
					aRatIns[nPosDiff][2][nDiff] -= nRatIns2 - M->E2_INSS
				Else
					aRatIns[nPosDiff][2][nDiff] += M->E2_INSS - nRatIns2
				Endif
			Endif
		Endif
	Endif
	
	If ! Empty(cChaveIss) .And. SE2->(DbSeek(xFilial() + cChaveIss))
		// Armazeno o valor do rateio para os impostos ja arredondado no ultimo        
        
		Reclock(cAlias)
		Replace (cAlias)->&(cCampo + "_MULTNAT") With If(lRatImpostos, "1", "2")
		MsUnlock()

      If lRatImpostos
			nDiff := nPosDiff := 0
			For nX := 1 To Len(aCols)
			   // Se a linha de aCols nao estiver deletada e o registro nao for 
				// encontrado no SEV
				If 	!aCols[nX][Len(aCols[nX])]
					Aadd(aRatIss, { M->E2_ISS * (Val(aCols[nX][3]) / 100), {} })	// Grava o valor informado
					nRatIss1 += aRatIss[Len(aRatIss)][1]

					If 	Select("SEZTMP") > 0 .And. aCols[nX][4] == "1"

						dbSelectArea("SEZTMP")
			        	nCont := 0
						// busca natureza no arquivo TMP de Mult Nat C.Custo
						If dbSeek(aCols[nX][1]) 
							While !Eof() .and. SEZTMP->EZ_NATUREZ == aCols[nX][1]
								Aadd(aRatIss[Len(aRatIss)][2], Round(NoRound((M->E2_ISS * (Val(aCols[nX][3]) / 100)) * SEZTMP->EZ_PERC, 3), 2)) // Grava o valor informado
								nCont ++
								nRatIss2 += aRatIss[Len(aRatIss)][2][nCont]
								DbSkip()
							EndDo
							nDiff 		:= nCont
							nPosDiff    := Len(aRatIss)
						Endif
					Endif
				Endif
			Next

			If Len(aRatIss) > 0 .And. nRatIss1 <> M->E2_ISS
				If nRatIss1 > M->E2_ISS
					aRatIss[Len(aRatIss)][1] -= nRatIss1 - M->E2_ISS
				Else
					aRatIss[Len(aRatIss)][1] += M->E2_ISS - nRatIss1
				Endif
			Endif
	
			If nDiff > 0 .And. Len(aRatIss) > 0 .And. nRatIss2 <> M->E2_ISS .And. nRatIss2 > 0
				If nRatIss2 > M->E2_ISS
					aRatIss[nPosDiff][2][nDiff] -= nRatIss2 - M->E2_ISS
				Else
					aRatIss[nPosDiff][2][nDiff] += M->E2_ISS - nRatIss2
				Endif
			Endif
		Endif
	Endif
	
	(cAlias)->(DbGoto(nRecno))
   If nOpc = 4
		DelMultNat(cAlias,@nHdlPrv,@nTotal,@cArquivo,.T.,aCols) // Apaga as naturezas geradas para o titulo
	Endif
	
	// Grava todas as naturezas e valores informados
	DbSelectArea("SEV")
	// Marca que ja foi contabilizado para nao contabilizar duas vezes, pois eh utilizado
	// o mesmo lancamento padrao

	If Len(aCols) > 1 .And. lContabiliza
		Reclock(cAlias)
		Replace (cAlias)->&(cCampo + "_LA") With "S"
		MsUnlock()
		DbSelectArea("SEV")
	Endif

	nCont := 0
	For nX := 1 To Len(aCols)
	   // Se a linha de aCols nao estiver deletada e o registro nao for 
		// encontrado no SEV
		lCtbRatCC := .F.
		If	!aCols[nX][Len(aCols[nX])]
			If lGrvSev
				ExecBlock("MULTSEV", .F., .F., { 	nX, cChave, aCols[nX][2],;
													(aCols[nX][2] / nVlTit),;
													aCols[nX][1]  })
				DbSelectArea("SEV")
			Endif
			DbSelectArea("SEV")
			If Len(aRegs) >= nX
				DbGoTo(aRegs[nX])
				RecLock("SEV", .F. )
				lInclui := .F.
			Else
				RecLock("SEV", .T. )
				lInclui := .T.
			Endif
			SEV->EV_FILIAL   := xFilial("SEV")
			SEV->EV_PREFIXO  := (cAlias)->&(cCampo + "_PREFIXO")
			SEV->EV_NUM      := (cAlias)->&(cCampo + "_NUM")
			SEV->EV_PARCELA  := (cAlias)->&(cCampo + "_PARCELA")
			SEV->EV_CLIFOR   := (cAlias)->&(cCampo + If(cAlias == "SE1", "_CLIENTE","_FORNECE"))
			SEV->EV_LOJA     := (cAlias)->&(cCampo + "_LOJA")
			SEV->EV_TIPO     := (cAlias)->&(cCampo + "_TIPO")
			SEV->EV_NATUREZ  := aCols[nX][1] // Grava a natureza
			SEV->EV_VALOR    := aCols[nX][2] // Grava o valor informado
			// Grava o percentual (Como indice multiplicador, por esta razao nao
			// multiplica por 100 na gravacao, apenas na exibicao)
			SEV->EV_PERC     := (aCols[nX][2] / nVlTit) 
			SEV->EV_RECPAG   := If(cAlias=="SE1", "R", "P" ) // Grava a Carteira
			SEV->EV_RATEICC  := aCols[nX][4]  // Identificador de Rateio C Custo
			SEV->EV_IDENT	:= "1"   //rateio de inclusao
			MsUnLock()
			FKCOMMIT()
			                      
			//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
			//³ Gera o lancamento no PCO com os dados do lancamento de multi-natureza (05) ³
			//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ			
			If (cAlias)->&(cCampo + "_MULTNAT") == "1"	// Campo multi-natureza igual a "Sim"
				If cAlias == "SE1"
					PCODetLan( "000001", "04", "FINA040" )	// Contas a Receber
				Else
					PCODetLan( "000002", "04", "FINA050" )	// Contas a Pagar
				EndIf	
			EndIf

			SEZ->(dbSetOrder(4))
			If Select("SEZTMP") > 0 .And. aCols[nX][4] == "1" .and.;   // Possui rateio c.Custo
        		(nOpc # 3 .Or. !SEZ->(MsSeek(xFilial("SEZ")+;
				(cAlias)->&(cCampo + "_PREFIXO")+;
				(cAlias)->&(cCampo + "_NUM")+;
				(cAlias)->&(cCampo + "_PARCELA")+;
				(cAlias)->&(cCampo + "_TIPO")+;
				(cAlias)->&(cCampo + If(cAlias == "SE1", "_CLIENTE","_FORNECE"))+;
				(cAlias)->&(cCampo + "_LOJA")+;
				aCols[nX][1]+"1")))

				//Gravacao dos dados do rateio C.custo
				dbSelectArea("SEZTMP")

				// busca natureza no arquivo TMP de Mult Nat C.Custo
				If dbSeek(aCols[nX][1]) 
					nCont ++
					nCont1 := nCont2 := nCont3 := nCont4 := nCont5 := nCont6 := 0
					While !Eof() .and. SEZTMP->EZ_NATUREZ == aCols[nX][1]
						VALOR 	:= SEZ->EZ_VALOR		// Valor Principal
						VALOR2	:= 0		// Irf
						VALOR3	:= 0		// Inss
						VALOR4	:= 0		// Iss
						VALOR5	:= 0		// Pis
						VALOR6	:= 0		// Cofins
						VALOR7	:= 0		// Csll

						// Verifica se não foi um movimento deletado no acols Mult Nat C.Custo e
						If !(SEZTMP->EZ_FLAG)
							If lGrvSez
								If SEZTMP->EZ_RECNO = 0
									SEZ->(DbGoBottom())
									SEZ->(DbSkip())
								Else
									SEZ->(DbGoto(SEZTMP->EZ_RECNO))
								Endif
								ExecBlock("MULTSEZ", .F., .F., { nOpc, cChave })
								DbSelectArea("SEZ")
							Endif
							If SEZTMP->EZ_RECNO = 0
								SEZ->(RecLock("SEZ",.T.))
							Else
								SEZ->(DbGoto(SEZTMP->EZ_RECNO))
								If SEZ->(Deleted())			// Alteracao de natureza
									SEZ->(RecLock("SEZ",.T.))
								Else
									SEZ->(RecLock("SEZ",.F.))
								Endif
							Endif
							SEZ->EZ_FILIAL		:= xFilial("SEZ")
							SEZ->EZ_PREFIXO	:= (cAlias)->&(cCampo + "_PREFIXO")
							SEZ->EZ_NUM			:= (cAlias)->&(cCampo + "_NUM")
							SEZ->EZ_PARCELA	:= (cAlias)->&(cCampo + "_PARCELA")
							SEZ->EZ_CLIFOR		:= (cAlias)->&(cCampo + If(cAlias == "SE1", "_CLIENTE","_FORNECE"))
							SEZ->EZ_LOJA		:= (cAlias)->&(cCampo + "_LOJA")
							SEZ->EZ_TIPO		:= (cAlias)->&(cCampo + "_TIPO")
							SEZ->EZ_NATUREZ	:= aCols[nX][1] // Grava a natureza
							SEZ->EZ_VALOR		:= SEZTMP->EZ_VALOR // Grava o valor informado
							SEZ->EZ_PERC		:= SEZTMP->EZ_PERC 
							SEZ->EZ_RECPAG		:= If(cAlias=="SE1", "R", "P" ) // Grava a Carteira
							SEZ->EZ_CCUSTO		:= SEZTMP->EZ_CCUSTO  // Centro de Custo
							SEZ->EZ_ITEMCTA	:= SEZTMP->EZ_ITEMCTA  // Item
							SEZ->EZ_CLVL   	:= SEZTMP->EZ_CLVL     // Classe de Valor
							SEZ->EZ_IDENT	:= "1"   //rateio de inclusao
							MsUnlock()
                     FKCOMMIT()             
							//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
							//³ Gera o lancamento no PCO com os dados do lancamento de C.C. por natureza (06) ³
							//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
							If cAlias == "SE1"
								PCODetLan( "000001", "05", "FINA040" )
							Else
								PCODetLan( "000002", "05", "FINA050" )
							EndIf	

							// Contabilizacao das MultiNat com Rateio C.Custo
							// Somente sera contabilizado se existir o LP 500/510 e o 506/508 ou
							// LP 520/530 e 536/537 se for baixa
							If lPadrao .and. lPadraoCC .And. aCols[nX][4] == "1" .And. lContabiliza
								VALOR 	:= SEZ->EZ_VALOR		// Valor Principal
								VALOR2	:= 0					// Irf
								VALOR3	:= 0					// Inss
								VALOR4	:= 0					// Iss
								VALOR5	:= 0					// Pis
								VALOR6	:= 0					// Cofins
								VALOR7	:= 0					// Csll
		
								// Contabiliza pelo SEZ
								If nHdlPrv <= 0
									nHdlPrv:=HeadProva(cLote,cOrigem,Substr(cUsuario,7,6),@cArquivo)
								Endif
								dbSelectArea( "SED" )
								MsSeek( xFilial("SED")+SEZ->EZ_NATUREZ ) // Posiciona na natureza, pois a conta pode estar la.
								dbSelectArea("SEZ")
								If nHdlPrv > 0
									nTotal+=DetProva(nHdlPrv,cPadraoCC,cOrigem,cLote)
								Endif	
								SEZ->(RecLock("SEZ"))
								SEZ->EZ_LA    := "S"
								MsUnlock()
								lCtbRatCC := .T.
							Endif

							If cAlias = "SE2" .And. lRatImpostos
								//Irrf
								If M->E2_IRRF > 0
									nCont1 ++
									If lGrvSez
										SEZTMP->EZ_NATUREZ		:= aCols[nX][1] // Grava a natureza
										SEZTMP->EZ_VALOR		:= aRatIrf[nCont][2][nCont1] // Grava o valor informado
										SEZTMP->EZ_PERC			:= SEZTMP->EZ_PERC 
										ExecBlock("MULTSEZ", .F., .F., { nOpc, cChaveIrf })
										DbSelectArea("SEZ")
									Endif
									SEZ->(RecLock("SEZ",.T.))
									SEZ->EZ_FILIAL		:= xFilial("SEZ")
									SEZ->EZ_PREFIXO		:= (cAlias)->&(cCampo + "_PREFIXO")
									SEZ->EZ_NUM			:= (cAlias)->&(cCampo + "_NUM")
									SEZ->EZ_PARCELA		:= SE2->E2_PARCIR
									SEZ->EZ_CLIFOR		:= GetMV("MV_UNIAO")
									SEZ->EZ_LOJA		:= "00"
									SEZ->EZ_TIPO		:= Iif(SE2->E2_TIPO $ MVPAGANT+"/"+MV_CPNEG,MVTXA,MVTAXA)
									SEZ->EZ_NATUREZ		:= aCols[nX][1] // Grava a natureza
									SEZ->EZ_VALOR		:= aRatIrf[nCont][2][nCont1] // Grava o valor informado
									SEZ->EZ_PERC		:= SEZTMP->EZ_PERC 
									SEZ->EZ_RECPAG		:= If(cAlias=="SE1", "R", "P" ) // Grava a Carteira
									SEZ->EZ_CCUSTO		:= SEZTMP->EZ_CCUSTO  // Centro de Custo
									SEZ->EZ_ITEMCTA		:= SEZTMP->EZ_ITEMCTA  // Item
									SEZ->EZ_CLVL   		:= SEZTMP->EZ_CLVL     // Classe de Valor
									SEZ->EZ_IDENT		:= "1"  //Rateio de inclusao
									MsUnlock()
									FKCOMMIT()
									// Contabilizacao das MultiNat com Rateio C.Custo
									If lPadraoCC .And. aCols[nX][4] == "1" .And. lContabiliza
										// Contabiliza pelo SEZ
										dbSelectArea( "SED" )
										MsSeek( xFilial("SED")+SEZ->EZ_NATUREZ ) // Posiciona na natureza, pois a conta pode estar la.
										dbSelectArea("SEZ")
										If nHdlPrv > 0
											VALOR		:= 0					// Valor Principal
											VALOR2	:= SEZ->EZ_VALOR		// Irf
											VALOR3	:= 0					// Inss
											VALOR4	:= 0					// Iss
											VALOR5	:= 0					// Pis
											VALOR6	:= 0					// Cofins
											VALOR7	:= 0					// Csll
											nTotal+=DetProva(nHdlPrv,cPadraoCC,cOrigem,cLote)
										Endif	
										SEZ->(RecLock("SEZ"))
										SEZ->EZ_LA    := "S"
										MsUnlock()
									Endif
								Endif

								//Pis
								If M->E2_PIS > 0
									nCont4 ++
									If lGrvSez
										SEZTMP->EZ_NATUREZ		:= aCols[nX][1] // Grava a natureza
										SEZTMP->EZ_VALOR		:= aRatPis[nCont][2][nCont4] // Grava o valor informado
										SEZTMP->EZ_PERC			:= SEZTMP->EZ_PERC 
										ExecBlock("MULTSEZ", .F., .F., { nOpc, cChavePis })
										DbSelectArea("SEZ")
									Endif
									SEZ->(RecLock("SEZ",.T.))
									SEZ->EZ_FILIAL		:= xFilial("SEZ")
									SEZ->EZ_PREFIXO	:= (cAlias)->&(cCampo + "_PREFIXO")
									SEZ->EZ_NUM			:= (cAlias)->&(cCampo + "_NUM")
									SEZ->EZ_PARCELA	:= SE2->E2_PARCPIS
									SEZ->EZ_CLIFOR		:= GetMV("MV_UNIAO")
									SEZ->EZ_LOJA		:= "00"
									SEZ->EZ_TIPO		:= Iif(SE2->E2_TIPO $ MVPAGANT+"/"+MV_CPNEG,MVTXA,MVTAXA)
									SEZ->EZ_NATUREZ	:= aCols[nX][1] // Grava a natureza
									SEZ->EZ_VALOR		:= aRatPis[nCont][2][nCont4] // Grava o valor informado
									SEZ->EZ_PERC		:= SEZTMP->EZ_PERC 
									SEZ->EZ_RECPAG		:= If(cAlias=="SE1", "R", "P" ) // Grava a Carteira
									SEZ->EZ_CCUSTO		:= SEZTMP->EZ_CCUSTO  // Centro de Custo
									SEZ->EZ_ITEMCTA	:= SEZTMP->EZ_ITEMCTA  // Item
									SEZ->EZ_CLVL		:= SEZTMP->EZ_CLVL     // Classe de Valor
									SEZ->EZ_IDENT		:= "1"  //Rateio de inclusao
									MsUnlock()
									FKCOMMIT()
									// Contabilizacao das MultiNat com Rateio C.Custo
									If lPadraoCC .And. aCols[nX][4] == "1" .And. lContabiliza
										// Contabiliza pelo SEZ
										dbSelectArea( "SED" )
										MsSeek( xFilial("SED")+SEZ->EZ_NATUREZ ) // Posiciona na natureza, pois a conta pode estar la.
										dbSelectArea("SEZ")
										If nHdlPrv > 0
											VALOR		:= 0					// Valor Principal
											VALOR2	:= 0					// Irf
											VALOR3	:= 0					// Inss
											VALOR4	:= 0					// Iss
											VALOR5	:= SEZ->EZ_VALOR	// Pis
											VALOR6	:= 0					// Cofins
											VALOR7	:= 0					// Csll
											nTotal+=DetProva(nHdlPrv,cPadraoCC,cOrigem,cLote)
										Endif	
										SEZ->(RecLock("SEZ"))
										SEZ->EZ_LA    := "S"
										MsUnlock()
									Endif
								Endif

								//Cofins
								If M->E2_COFINS > 0
									nCont5 ++
									If lGrvSez
										SEZTMP->EZ_NATUREZ	:= aCols[nX][1] // Grava a natureza
										SEZTMP->EZ_VALOR		:= aRatCof[nCont][2][nCont5] // Grava o valor informado
										SEZTMP->EZ_PERC		:= SEZTMP->EZ_PERC 
										ExecBlock("MULTSEZ", .F., .F., { nOpc, cChaveCof })
										DbSelectArea("SEZ")
									Endif
									SEZ->(RecLock("SEZ",.T.))
									SEZ->EZ_FILIAL		:= xFilial("SEZ")
									SEZ->EZ_PREFIXO	:= (cAlias)->&(cCampo + "_PREFIXO")
									SEZ->EZ_NUM			:= (cAlias)->&(cCampo + "_NUM")
									SEZ->EZ_PARCELA	:= SE2->E2_PARCCOF
									SEZ->EZ_CLIFOR		:= GetMV("MV_UNIAO")
									SEZ->EZ_LOJA		:= "00"
									SEZ->EZ_TIPO		:= Iif(SE2->E2_TIPO $ MVPAGANT+"/"+MV_CPNEG,MVTXA,MVTAXA)
									SEZ->EZ_NATUREZ	:= aCols[nX][1] // Grava a natureza
									SEZ->EZ_VALOR		:= aRatCof[nCont][2][nCont5] // Grava o valor informado
									SEZ->EZ_PERC		:= SEZTMP->EZ_PERC 
									SEZ->EZ_RECPAG		:= If(cAlias=="SE1", "R", "P" ) // Grava a Carteira
									SEZ->EZ_CCUSTO		:= SEZTMP->EZ_CCUSTO  // Centro de Custo
									SEZ->EZ_ITEMCTA	:= SEZTMP->EZ_ITEMCTA  // Item
									SEZ->EZ_CLVL		:= SEZTMP->EZ_CLVL     // Classe de Valor
									SEZ->EZ_IDENT		:= "1"  //Rateio de inclusao
									MsUnlock()
									FKCOMMIT()
									// Contabilizacao das MultiNat com Rateio C.Custo
									If lPadraoCC .And. aCols[nX][4] == "1" .And. lContabiliza
										// Contabiliza pelo SEZ
										dbSelectArea( "SED" )
										MsSeek( xFilial("SED")+SEZ->EZ_NATUREZ ) // Posiciona na natureza, pois a conta pode estar la.
										dbSelectArea("SEZ")
										If nHdlPrv > 0
											VALOR		:= 0					// Valor Principal
											VALOR2	:= 0					// Irf
											VALOR3	:= 0					// Inss
											VALOR4	:= 0					// Iss
											VALOR5	:= 0					// Pis
											VALOR6	:= SEZ->EZ_VALOR // Cofins
											VALOR7	:= 0					// Csll
											nTotal+=DetProva(nHdlPrv,cPadraoCC,cOrigem,cLote)
										Endif	
										SEZ->(RecLock("SEZ"))
										SEZ->EZ_LA    := "S"
										MsUnlock()
									Endif
								Endif

								//CSLL
								If M->E2_CSLL > 0
									nCont6 ++
									If lGrvSez
										SEZTMP->EZ_NATUREZ	:= aCols[nX][1] // Grava a natureza
										SEZTMP->EZ_VALOR		:= aRatIrf[nCont][2][nCont6] // Grava o valor informado
										SEZTMP->EZ_PERC		:= SEZTMP->EZ_PERC 
										ExecBlock("MULTSEZ", .F., .F., { nOpc, cChaveCsl })
										DbSelectArea("SEZ")
									Endif
									SEZ->(RecLock("SEZ",.T.))
									SEZ->EZ_FILIAL		:= xFilial("SEZ")
									SEZ->EZ_PREFIXO	:= (cAlias)->&(cCampo + "_PREFIXO")
									SEZ->EZ_NUM			:= (cAlias)->&(cCampo + "_NUM")
									SEZ->EZ_PARCELA	:= SE2->E2_PARCSLL
									SEZ->EZ_CLIFOR		:= GetMV("MV_UNIAO")
									SEZ->EZ_LOJA		:= "00"
									SEZ->EZ_TIPO		:= Iif(SE2->E2_TIPO $ MVPAGANT+"/"+MV_CPNEG,MVTXA,MVTAXA)
									SEZ->EZ_NATUREZ	:= aCols[nX][1] // Grava a natureza
									SEZ->EZ_VALOR		:= aRatCsl[nCont][2][nCont6] // Grava o valor informado
									SEZ->EZ_PERC		:= SEZTMP->EZ_PERC 
									SEZ->EZ_RECPAG		:= If(cAlias=="SE1", "R", "P" ) // Grava a Carteira
									SEZ->EZ_CCUSTO		:= SEZTMP->EZ_CCUSTO  // Centro de Custo
									SEZ->EZ_ITEMCTA	:= SEZTMP->EZ_ITEMCTA  // Item
									SEZ->EZ_CLVL		:= SEZTMP->EZ_CLVL     // Classe de Valor
									SEZ->EZ_IDENT		:= "1"  //Rateio de inclusao
									MsUnlock()

									// Contabilizacao das MultiNat com Rateio C.Custo
									If lPadraoCC .And. aCols[nX][4] == "1" .And. lContabiliza
										// Contabiliza pelo SEZ
										dbSelectArea( "SED" )
										MsSeek( xFilial("SED")+SEZ->EZ_NATUREZ ) // Posiciona na natureza, pois a conta pode estar la.
										dbSelectArea("SEZ")
										If nHdlPrv > 0
											VALOR		:= 0					// Valor Principal
											VALOR2	:= 0					// Irf
											VALOR3	:= 0					// Inss
											VALOR4	:= 0					// Iss
											VALOR5	:= 0					// Pis
											VALOR6	:= 0					// Cofins
											VALOR7	:= SEZ->EZ_VALOR	// Csll
											nTotal+=DetProva(nHdlPrv,cPadraoCC,cOrigem,cLote)
										Endif	
										SEZ->(RecLock("SEZ"))
										SEZ->EZ_LA    := "S"
										MsUnlock()
									Endif
								Endif

								If M->E2_INSS > 0
									nCont2 ++
									If lGrvSez
										SEZTMP->EZ_NATUREZ		:= aCols[nX][1] // Grava a natureza
										SEZTMP->EZ_VALOR		:= aRatIns[nCont][2][nCont2] // Grava o valor informado
										SEZTMP->EZ_PERC		:= SEZTMP->EZ_PERC 
										ExecBlock("MULTSEZ", .F., .F., { nOpc, cChaveIns })
										DbSelectArea("SEZ")
									Endif

									SEZ->(RecLock("SEZ",.T.))
									SEZ->EZ_FILIAL		:= xFilial("SEZ")
									SEZ->EZ_PREFIXO		:= (cAlias)->&(cCampo + "_PREFIXO")
									SEZ->EZ_NUM			:= (cAlias)->&(cCampo + "_NUM")
									SEZ->EZ_PARCELA		:= SE2->E2_PARCINS
									SEZ->EZ_CLIFOR		:= GetMv("MV_FORINSS")
									SEZ->EZ_LOJA		:= "00"
									SEZ->EZ_TIPO		:= MVINSS
									SEZ->EZ_NATUREZ		:= aCols[nX][1] // Grava a natureza
									SEZ->EZ_VALOR		:= aRatIns[nCont][2][nCont2] // Grava o valor informado
									SEZ->EZ_PERC		:= SEZTMP->EZ_PERC 
									SEZ->EZ_RECPAG		:= If(cAlias=="SE1", "R", "P" ) // Grava a Carteira
									SEZ->EZ_CCUSTO		:= SEZTMP->EZ_CCUSTO  // Centro de Custo
									SEZ->EZ_ITEMCTA		:= SEZTMP->EZ_ITEMCTA  // Item
									SEZ->EZ_CLVL   		:= SEZTMP->EZ_CLVL     // Classe de Valor
									SEZ->EZ_IDENT		:= "1"  //Rateio de inclusao
									MsUnlock()

									// Contabilizacao das MultiNat com Rateio C.Custo
									If lPadraoCC .And. aCols[nX][4] == "1" .And. lContabiliza
										// Contabiliza pelo SEZ
										dbSelectArea( "SED" )
										MsSeek( xFilial("SED")+SEZ->EZ_NATUREZ ) // Posiciona na natureza, pois a conta pode estar la.
										dbSelectArea("SEZ")
										If nHdlPrv > 0
											VALOR 	:= 0					// Valor Principal
											VALOR2  := 0					// Irf
											VALOR3  := SEZ->EZ_VALOR		// Inss
											VALOR4  := 0					// Iss
											VALOR5	:= 0					// Pis
											VALOR6	:= 0					// Cofins
											VALOR7	:= 0					// Csll
											nTotal+=DetProva(nHdlPrv,cPadraoCC,cOrigem,cLote)
										Endif	
										SEZ->(RecLock("SEZ"))
										SEZ->EZ_LA    := "S"
										MsUnlock()
									Endif
								Endif
								If M->E2_ISS > 0
									nCont3 ++
									If lGrvSez
										SEZTMP->EZ_NATUREZ		:= aCols[nX][1] // Grava a natureza
										SEZTMP->EZ_VALOR		:= aRatIss[nCont][2][nCont3] // Grava o valor informado
										SEZTMP->EZ_PERC		:= SEZTMP->EZ_PERC 
										ExecBlock("MULTSEZ", .F., .F., { nOpc, cChaveIss })
										DbSelectArea("SEZ")
									Endif
									
									SEZ->(RecLock("SEZ",.T.))
									SEZ->EZ_FILIAL		:= xFilial("SEZ")
									SEZ->EZ_PREFIXO		:= (cAlias)->&(cCampo + "_PREFIXO")
									SEZ->EZ_NUM			:= (cAlias)->&(cCampo + "_NUM")
									SEZ->EZ_PARCELA		:= SE2->E2_PARCISS
									SEZ->EZ_CLIFOR		:= GetMV("MV_MUNIC")
									SEZ->EZ_LOJA		:= "00"
									SEZ->EZ_TIPO		:= MVISS
									SEZ->EZ_NATUREZ		:= aCols[nX][1] // Grava a natureza
									SEZ->EZ_VALOR		:= aRatIss[nCont][2][nCont3] // Grava o valor informado
									SEZ->EZ_PERC		:= SEZTMP->EZ_PERC 
									SEZ->EZ_RECPAG		:= If(cAlias=="SE1", "R", "P" ) // Grava a Carteira
									SEZ->EZ_CCUSTO		:= SEZTMP->EZ_CCUSTO  // Centro de Custo
									SEZ->EZ_ITEMCTA		:= SEZTMP->EZ_ITEMCTA  // Item
									SEZ->EZ_CLVL   		:= SEZTMP->EZ_CLVL     // Classe de Valor
									SEZ->EZ_IDENT		:= "1"  //Rateio de inclusao
									MsUnlock()

									// Contabilizacao das MultiNat com Rateio C.Custo
									If lPadraoCC .And. aCols[nX][4] == "1" .And. lContabiliza
										// Contabiliza pelo SEZ
										dbSelectArea( "SED" )
										MsSeek( xFilial("SED")+SEZ->EZ_NATUREZ ) // Posiciona na natureza, pois a conta pode estar la.
										dbSelectArea("SEZ")
										If nHdlPrv > 0
											VALOR 	:= 0					// Valor Principal
											VALOR2  := 0					// Irf
											VALOR3  := 0					// Inss
											VALOR4  := SEZ->EZ_VALOR		// Iss
											VALOR5	:= 0					// Pis
											VALOR6	:= 0					// Cofins
											VALOR7	:= 0					// Csll
											nTotal+=DetProva(nHdlPrv,cPadraoCC,cOrigem,cLote)
										Endif	
										SEZ->(RecLock("SEZ"))
										SEZ->EZ_LA    := "S"
										MsUnlock()
									Endif
								Endif
							Endif
						ElseIf SEZTMP->EZ_RECNO > 0

							SEZ->(DbGoto(SEZTMP->EZ_RECNO))

							//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
							//³ Apaga o lancamento no PCO com os dados de multi-natureza x centro de custo (05) ³
							//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
							If cAlias == "SE1"
								PCODetLan( "000001", "05", "FINA040", .T. )
							Else	
								PCODetLan( "000002", "05", "FINA050", .T. )	
							EndIf	

							SEZ->(RecLock("SEZ",.F.))
							SEZ->(DbDelete())
							SEZ->(MsUnlock())

							If lGrvSez
								ExecBlock("MULTSEZ", .F., .F., { nOpc, SEZ->EZ_PREFIXO +;
								SEZ->EZ_NUM + SEZ->EZ_PARCELA + SEZ->EZ_TIPO + SEZ->EZ_CLIFOR +;
								SEZ->EZ_LOJA })
								DbSelectArea("SEZ")
							Endif
						Endif
						
						dbSelectArea("SEZTMP")
						DbSkip()								
               Enddo
      		Endif
				//Informo contabilizacao para SEV - Multi Naturezas
				dbSelectArea("SEV")
				If nTotal > 0
					RecLock("SEV")
					SEV->EV_LA    := "S"
					MsUnlock()
				Endif
				(cAlias)->(RestArea(aArea1))				
			Endif
			// Contabilizacao das MultiNat sem Rateio C.Custo
			If lPadrao .And. !lCtbRatCC .And. lContabiliza
				// Desposiciona para nao contabilizar pelo SE1/SE2, para nao duplicar o
				// LP caso utilize SE1/SE2->Valor
				// A sintaxe do LP deve ser: 
				// If(Se1/Se2->E2/E2_Multnat#"2",SEV->EV_VALOR,Se1/S22->_E1/E2_Valor)
				// ou SE1/SE2->E1/E2_Valor.
				DbSelectArea(cAlias)
				DbGoBottom()
				DbSkip()
				// Contabiliza pelo SEV
				If nHdlPrv <= 0
					nHdlPrv:=HeadProva(cLote,cOrigem,Substr(cUsuario,7,6),@cArquivo)
				Endif
				dbSelectArea( "SED" )
				MsSeek( xFilial("SED")+SEV->EV_NATUREZ ) // Posiciona na natureza, pois a conta pode estar la.
				dbSelectArea("SEV")
				If nHdlPrv > 0
					VALOR 	:= SEV->EV_VALOR		// Valor Principal
					VALOR2	:= 0					// Irf
					VALOR3	:= 0					// Inss
					VALOR4	:= 0					// Iss
					VALOR5	:= 0					// Pis
					VALOR6	:= 0					// Cofins
					VALOR7	:= 0					// Csll

					nTotal+=DetProva(nHdlPrv,cPadrao,cOrigem,cLote)
				Endif	
            If nTotal > 0
					RecLock("SEV")
					SEV->EV_LA    := "S"
					MsUnlock()
				Endif
				(cAlias)->(RestArea(aArea1))
			Endif
			If cAlias = "SE2" .And. lRatImpostos
				//Irrf
				If M->E2_IRRF > 0
					If lGrvSev
						ExecBlock("MULTSEV", .F., .F., { 	nX, cChaveIrf,;
															aRatIrf[nX][1],;
															Val(aCols[nX][3]) / 100,;
															aCols[nX][1] })
						DbSelectArea("SEV")
					Endif
					SEV->(RecLock("SEV", .T.))
					SEV->EV_FILIAL   := xFilial("SEV")
					SEV->EV_PREFIXO  := (cAlias)->&(cCampo + "_PREFIXO")
					SEV->EV_NUM      := (cAlias)->&(cCampo + "_NUM")
					SEV->EV_PARCELA  := SE2->E2_PARCIR
					SEV->EV_CLIFOR   := GetMV("MV_UNIAO")
					SEV->EV_LOJA     := "00"
					SEV->EV_TIPO     := Iif(SE2->E2_TIPO $ MVPAGANT+"/"+MV_CPNEG,MVTXA,MVTAXA)
					SEV->EV_NATUREZ  := aCols[nX][1] // Grava a natureza
					SEV->EV_VALOR    := aRatIrf[nX][1]	// Grava o valor informado
					// Grava o percentual (Como indice multiplicador, por esta razao nao
					// multiplica por 100 na gravacao, apenas na exibicao)
					SEV->EV_PERC     := Val(aCols[nX][3]) / 100
					SEV->EV_RECPAG   := If(cAlias=="SE1", "R", "P" ) // Grava a Carteira
					SEV->EV_RATEICC  := aCols[nX][4]  // Identificador de Rateio C Custo
					SEV->EV_IDENT		:= "1"  //Rateio de inclusao

					If lPadrao .And. !lCtbRatCC .And. aCols[nX][4] != "1" .And. lContabiliza
						dbSelectArea( "SED" )
						MsSeek( xFilial("SED")+SEV->EV_NATUREZ ) // Posiciona na natureza, pois a conta pode estar la.
						dbSelectArea("SEV")
						If nHdlPrv > 0
							VALOR 	:= 0					// Valor Principal
							VALOR2	:= SEV->EV_VALOR	// Irf
							VALOR3	:= 0					// Inss
							VALOR4	:= 0					// Iss
							VALOR5	:= 0					// Pis
							VALOR6	:= 0					// Cofins
							VALOR7	:= 0					// Csll
							nTotal+=DetProva(nHdlPrv,cPadrao,cOrigem,cLote)
						Endif	
		            If nTotal > 0
							SEV->EV_LA    := "S"
						Endif
						(cAlias)->(RestArea(aArea1))
					Endif
					SEV->(MsUnlock())
					FKCOMMIT()
				Endif

				//Pis
				If M->E2_PIS > 0
					If lGrvSev
						ExecBlock("MULTSEV", .F., .F., { 	nX, cChavePis,;
															aRatIrf[nX][1],;
															Val(aCols[nX][3]) / 100,;
															aCols[nX][1] })
						DbSelectArea("SEV")
					Endif
					SEV->(RecLock("SEV", .T.))
					SEV->EV_FILIAL   := xFilial("SEV")
					SEV->EV_PREFIXO  := (cAlias)->&(cCampo + "_PREFIXO")
					SEV->EV_NUM      := (cAlias)->&(cCampo + "_NUM")
					SEV->EV_PARCELA  := SE2->E2_PARCPIS
					SEV->EV_CLIFOR   := GetMV("MV_UNIAO")
					SEV->EV_LOJA     := "00"
					SEV->EV_TIPO     := Iif(SE2->E2_TIPO $ MVPAGANT+"/"+MV_CPNEG,MVTXA,MVTAXA)
					SEV->EV_NATUREZ  := aCols[nX][1] // Grava a natureza
					SEV->EV_VALOR    := aRatPIS[nX][1]	// Grava o valor informado
					// Grava o percentual (Como indice multiplicador, por esta razao nao
					// multiplica por 100 na gravacao, apenas na exibicao)
					SEV->EV_PERC     := Val(aCols[nX][3]) / 100
					SEV->EV_RECPAG   := If(cAlias=="SE1", "R", "P" ) // Grava a Carteira
					SEV->EV_RATEICC  := aCols[nX][4]  // Identificador de Rateio C Custo
					SEV->EV_IDENT		:= "1"  //Rateio de inclusao

					If lPadrao .And. !lCtbRatCC .And. aCols[nX][4] != "1" .And. lContabiliza
						dbSelectArea( "SED" )
						MsSeek( xFilial("SED")+SEV->EV_NATUREZ ) // Posiciona na natureza, pois a conta pode estar la.
						dbSelectArea("SEV")
						If nHdlPrv > 0
							VALOR 	:= 0					// Valor Principal
							VALOR2	:= 0					// Irf
							VALOR3	:= 0					// Inss
							VALOR4	:= 0					// Iss
							VALOR5	:= SEV->EV_VALOR	// Pis
							VALOR6	:= 0					// Cofins
							VALOR7	:= 0					// Csll
							nTotal+=DetProva(nHdlPrv,cPadrao,cOrigem,cLote)
						Endif	
		            If nTotal > 0
							SEV->EV_LA    := "S"
						Endif
						(cAlias)->(RestArea(aArea1))
					Endif
					SEV->(MsUnlock())
					FKCOMMIT()
				Endif

				//Cofins
				If M->E2_COFINS > 0
					If lGrvSev
						ExecBlock("MULTSEV", .F., .F., { 	nX, cChaveCof,;
															aRatIrf[nX][1],;
															Val(aCols[nX][3]) / 100,;
															aCols[nX][1] })
						DbSelectArea("SEV")
					Endif
					SEV->(RecLock("SEV", .T.))
					SEV->EV_FILIAL   := xFilial("SEV")
					SEV->EV_PREFIXO  := (cAlias)->&(cCampo + "_PREFIXO")
					SEV->EV_NUM      := (cAlias)->&(cCampo + "_NUM")
					SEV->EV_PARCELA  := SE2->E2_PARCCOF
					SEV->EV_CLIFOR   := GetMV("MV_UNIAO")
					SEV->EV_LOJA     := "00"
					SEV->EV_TIPO     := Iif(SE2->E2_TIPO $ MVPAGANT+"/"+MV_CPNEG,MVTXA,MVTAXA)
					SEV->EV_NATUREZ  := aCols[nX][1] // Grava a natureza
					SEV->EV_VALOR    := aRatCOF[nX][1]	// Grava o valor informado
					// Grava o percentual (Como indice multiplicador, por esta razao nao
					// multiplica por 100 na gravacao, apenas na exibicao)
					SEV->EV_PERC     := Val(aCols[nX][3]) / 100
					SEV->EV_RECPAG   := If(cAlias=="SE1", "R", "P" ) // Grava a Carteira
					SEV->EV_RATEICC  := aCols[nX][4]  // Identificador de Rateio C Custo
					SEV->EV_IDENT		:= "1"  //Rateio de inclusao

					If lPadrao .And. !lCtbRatCC .And. aCols[nX][4] != "1" .And. lContabiliza
						dbSelectArea( "SED" )
						MsSeek( xFilial("SED")+SEV->EV_NATUREZ ) // Posiciona na natureza, pois a conta pode estar la.
						dbSelectArea("SEV")
						If nHdlPrv > 0
							VALOR		:= 0					// Valor Principal
							VALOR2	:= 0					// Irf
							VALOR3	:= 0					// Inss
							VALOR4	:= 0					// Iss
							VALOR5	:= 0					// Pis
							VALOR6	:= SEV->EV_VALOR	// Cofins
							VALOR7	:= 0					// Csll
							nTotal+=DetProva(nHdlPrv,cPadrao,cOrigem,cLote)
						Endif	
		            If nTotal > 0
							SEV->EV_LA    := "S"
						Endif
						(cAlias)->(RestArea(aArea1))
					Endif
					SEV->(MsUnlock())
					FKCOMMIT()
				Endif

				//CSLL
				If M->E2_CSLL > 0
					If lGrvSev
						ExecBlock("MULTSEV", .F., .F., { 	nX, cChaveCSL,;
															aRatIrf[nX][1],;
															Val(aCols[nX][3]) / 100,;
															aCols[nX][1] })
						DbSelectArea("SEV")
					Endif
					SEV->(RecLock("SEV", .T.))
					SEV->EV_FILIAL   := xFilial("SEV")
					SEV->EV_PREFIXO  := (cAlias)->&(cCampo + "_PREFIXO")
					SEV->EV_NUM      := (cAlias)->&(cCampo + "_NUM")
					SEV->EV_PARCELA  := SE2->E2_PARCSLL
					SEV->EV_CLIFOR   := GetMV("MV_UNIAO")
					SEV->EV_LOJA     := "00"
					SEV->EV_TIPO     := Iif(SE2->E2_TIPO $ MVPAGANT+"/"+MV_CPNEG,MVTXA,MVTAXA)
					SEV->EV_NATUREZ  := aCols[nX][1] // Grava a natureza
					SEV->EV_VALOR    := aRatCSL[nX][1]	// Grava o valor informado
					// Grava o percentual (Como indice multiplicador, por esta razao nao
					// multiplica por 100 na gravacao, apenas na exibicao)
					SEV->EV_PERC     := Val(aCols[nX][3]) / 100
					SEV->EV_RECPAG   := If(cAlias=="SE1", "R", "P" ) // Grava a Carteira
					SEV->EV_RATEICC  := aCols[nX][4]  // Identificador de Rateio C Custo
					SEV->EV_IDENT		:= "1"  //Rateio de inclusao

					If lPadrao .And. !lCtbRatCC .And. aCols[nX][4] != "1" .And. lContabiliza
						dbSelectArea( "SED" )
						MsSeek( xFilial("SED")+SEV->EV_NATUREZ ) // Posiciona na natureza, pois a conta pode estar la.
						dbSelectArea("SEV")
						If nHdlPrv > 0
							VALOR 	:= 0					// Valor Principal
							VALOR2	:= 0					// Irf
							VALOR3	:= 0					// Inss
							VALOR4	:= 0					// Iss
							VALOR5	:= 0					// Pis
							VALOR6	:= 0					// Cofins
							VALOR7	:= SEV->EV_VALOR	// Csll
							nTotal+=DetProva(nHdlPrv,cPadrao,cOrigem,cLote)
						Endif	
		            If nTotal > 0
							SEV->EV_LA    := "S"
						Endif
						(cAlias)->(RestArea(aArea1))
					Endif
					SEV->(MsUnlock())
					FKCOMMIT()
				Endif

				If M->E2_INSS > 0
					If lGrvSev
						ExecBlock("MULTSEV", .F., .F., { 	nX, cChaveIns,;
															aRatIns[nX][1],;
															Val(aCols[nX][3]) / 100,;
															aCols[nX][1] })
						DbSelectArea("SEV")
					Endif
					
					SEV->(RecLock("SEV", .T.))
					SEV->EV_FILIAL   := xFilial("SEV")
					SEV->EV_PREFIXO  := (cAlias)->&(cCampo + "_PREFIXO")
					SEV->EV_NUM      := (cAlias)->&(cCampo + "_NUM")
					SEV->EV_PARCELA  := SE2->E2_PARCINS
					SEV->EV_CLIFOR   := GetMv("MV_FORINSS")
					SEV->EV_LOJA     := "00"
					SEV->EV_TIPO     := MVINSS
					SEV->EV_NATUREZ  := aCols[nX][1] // Grava a natureza
					SEV->EV_VALOR    := aRatIns[nX][1]	// Grava o valor informado
					// Grava o percentual (Como indice multiplicador, por esta razao nao
					// multiplica por 100 na gravacao, apenas na exibicao)
					SEV->EV_PERC     := Val(aCols[nX][3]) / 100
					SEV->EV_RECPAG   := If(cAlias=="SE1", "R", "P" ) // Grava a Carteira
					SEV->EV_RATEICC  := aCols[nX][4]  // Identificador de Rateio C Custo
					SEV->EV_IDENT		:= "1"  //Rateio de inclusao
					
					If lPadrao .And. !lCtbRatCC .And. aCols[nX][4] != "1" .And. lContabiliza
						dbSelectArea( "SED" )
						MsSeek( xFilial("SED")+SEV->EV_NATUREZ ) // Posiciona na natureza, pois a conta pode estar la.
						dbSelectArea("SEV")
						If nHdlPrv > 0
							VALOR 	:= 0					// Valor Principal
							VALOR2  := 0					// Irf
							VALOR3  := SEV->EV_VALOR		// Inss
							VALOR4  := 0					// Iss
							VALOR5	:= 0					// Pis
							VALOR6	:= 0					// Cofins
							VALOR7	:= 0					// Csll
							nTotal+=DetProva(nHdlPrv,cPadrao,cOrigem,cLote)
						Endif	
		            If nTotal > 0
							SEV->EV_LA    := "S"
						Endif
						(cAlias)->(RestArea(aArea1))
					Endif
					SEV->(MsUnlock())
					FKCOMMIT()
				Endif
				If M->E2_ISS > 0
					If lGrvSev
						ExecBlock("MULTSEV", .F., .F., { 	nX, cChaveIss,;
															aRatIss[nX][1],;
															Val(aCols[nX][3]) / 100,;
															aCols[nX][1] })
						DbSelectArea("SEV")
					Endif
					
					SEV->(RecLock("SEV", .T.))
					SEV->EV_FILIAL   := xFilial("SEV")
					SEV->EV_PREFIXO  := (cAlias)->&(cCampo + "_PREFIXO")
					SEV->EV_NUM      := (cAlias)->&(cCampo + "_NUM")
					SEV->EV_PARCELA  := SE2->E2_PARCISS
					SEV->EV_CLIFOR   := GetMV("MV_MUNIC")
					SEV->EV_LOJA     := "00"
					SEV->EV_TIPO     := MVISS
					SEV->EV_NATUREZ  := aCols[nX][1] // Grava a natureza
					SEV->EV_VALOR    := aRatIss[nX][1]	// Grava o valor informado
					// Grava o percentual (Como indice multiplicador, por esta razao nao
					// multiplica por 100 na gravacao, apenas na exibicao)
					SEV->EV_PERC     := Val(aCols[nX][3]) / 100
					SEV->EV_RECPAG   := If(cAlias=="SE1", "R", "P" ) // Grava a Carteira
					SEV->EV_RATEICC  := aCols[nX][4]  // Identificador de Rateio C Custo
					SEV->EV_IDENT		:= "1"  //Rateio de inclusao
					
					If lPadrao .And. !lCtbRatCC .And. aCols[nX][4] != "1" .And. lContabiliza
						dbSelectArea( "SED" )
						MsSeek( xFilial("SED")+SEV->EV_NATUREZ ) // Posiciona na natureza, pois a conta pode estar la.
						dbSelectArea("SEV")
						If nHdlPrv > 0
							VALOR 	:= 0					// Valor Principal
							VALOR2  := 0					// Irf
							VALOR3  := 0					// Inss
							VALOR4  := SEV->EV_VALOR		// Iss
							VALOR5	:= 0					// Pis
							VALOR6	:= 0					// Cofins
							VALOR7	:= 0					// Csll
							nTotal+=DetProva(nHdlPrv,cPadrao,cOrigem,cLote)
						Endif	
		            If nTotal > 0
							SEV->EV_LA    := "S"
						Endif
						(cAlias)->(RestArea(aArea1))
					Endif
					SEV->(MsUnlock())
					FKCOMMIT()
				Endif
			Endif
		ElseIf Len(aRegs) >= nX
			DbGoto(aRegs[nX])

			//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
			//³ Apaga os lancamentos gerados no PCO a partir do rateio por multi-natureza (05) ³
			//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
			If (cAlias)-> &(cCampo + "_MULTNAT") == "1"	// Campo multi-natureza igual a "Sim"
				If cAlias == "SE1"
					PCODetLan( "000001", "04", "FINA040", .T. )
				Else
					PCODetLan( "000002", "04", "FINA050", .T. )	
				EndIf
    		EndIf
    		
			RecLock("SEV", .F. )
			DbDelete()
			MsUnLock()			
			If lGrvSev
				ExecBlock("MULTSEV", .F., .F., { 	nX, SEV->EV_PREFIXO +;
													SEV->EV_NUM + SEV->EV_PARCELA +; 
													SEV->EV_TIPO + SEV->EV_CLIFOR + SEV->EV_LOJA, 0, 0, "" })
				DbSelectArea("SEV")
			Endif

			dbSelectArea("SEZTMP")

			// busca natureza no arquivo TMP de Mult Nat C.Custo
			If dbSeek(aCols[nX][1]) 
				While !Eof() .and. SEZTMP->EZ_NATUREZ == aCols[nX][1]
					If SEZTMP->EZ_RECNO > 0
						SEZ->(DbGoto(SEZTMP->EZ_RECNO))
						//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
						//³ Apaga o lancamento no PCO com os dados do lancamento de multi-natureza (05) ³
						//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
				    	If cAlias == "SE1"
							PCODetLan( "000001", "05", "FINA040", .T. )
						Else
							PCODetLan( "000002", "05", "FINA050", .T. )	
						EndIf
						SEZ->(RecLock("SEZ",.F.))
						SEZ->(DbDelete())
						SEZ->(MsUnlock())
						If lGrvSez
							ExecBlock("MULTSEZ", .F., .F., { nOpc, SEZ->EZ_PREFIXO +;
							SEZ->EZ_NUM + SEZ->EZ_PARCELA +;
							SEZ->EZ_TIPO + SEZ->EZ_CLIFOR + SEZ->EZ_LOJA } )
							DbSelectArea("SEZ")
						Endif
                  	Endif
					dbSelectArea("SEZTMP")
					DbSkip()								
          		Enddo
     		Endif
     		
		EndIf	
	Next	
	DbSelectArea("SEV")
	DbGoBottom()
	DbSkip()

ElseIf nOpc = 3
	Reclock(cAlias)
	Replace (cAlias)->&(cCampo + "_MULTNAT") With "2"
	MsUnlock()
Endif

//Se ezistir temporario para rateio c. custo, deleta
If lGrava .And. Select("SEZTMP") > 0
	If cArqSez <> Nil
		dbSelectArea("SEZTMP")
		dbCloseArea()
		Ferase(cArqSez+GetDBExtension())
		Ferase(cArqSez+OrdBagExt())
	EndIf
Endif	

SX3->(DbSetOrder(1))
RestArea(aArea)
(cAlias)->(RestArea(aArea1))
aColsM 	 := AClone(aCols)
aHeaderM := AClone(aHeader)
// Zera as variaveis de contabilizacao para nao ocorrer duplicidade em outra chamada a DetProva
VALOR	 := 0
VALOR2 := 0
VALOR3 := 0
VALOR4 := 0
VALOR5 := 0					// Pis
VALOR6 := 0					// Cofins
VALOR7 := 0					// Csll

Return .T.