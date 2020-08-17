#Include "Protheus.ch"
#Include "Topconn.ch"

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณPROR0004  บAutor  ณTotvs               บ Data ณ             บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณFuncao para impressao dos documentos DIMP.                  บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ AP - Prodam.                                               บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

User Function PROR0004()

Private cPerg := "PROR0004"
Private cCadastro	:= "Impressao da DIMP"
Private aSays		:= {}
Private aButtons	:= {}
Private nOpca 		:= 0
Private oPrint

// Funcao para criacao das perguntas.
fCriaSx1()

Pergunte(cPerg,.F.)

AADD(aSays,"Este programa ira realizar a impressใo da DIMP - " )
AADD(aSays,"Documento de Identifica็ใo e Movimenta็ใo de Bem Patrimonial." )

AADD(aButtons, { 5,.T.,{|| Pergunte(cPerg,.T. )}})
AADD(aButtons, { 1,.T.,{|o| nOpca := 1,FechaBatch()}})
AADD(aButtons, { 2,.T.,{|o| FechaBatch() }} )

FormBatch( cCadastro, aSays, aButtons )

If nOpca == 1
	Processa({|| fimprime()})
EndIf

Return



/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณfImprime  บAutor  ณTotvs               บ Data ณ             บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ Funcao de impressao do relatorio.                          บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ AP - Prodam                                                บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
Static Function fImprime()

Private cQ	:= ""
Private cLocalOri := ""
Private nRegs := 0
Private cChave := ""
Private nFolha := 0
//Private nFolhas := 0
Private oCour08N 	:= TFont():New("Courier New",08,08,.T.,.T.,5,.T.,5,.T.,.F.)
Private oCour09N 	:= TFont():New("Courier New",09,09,.T.,.T.,5,.T.,5,.T.,.F.)
Private oCour10N 	:= TFont():New("Courier New",10,10,.T.,.T.,5,.T.,5,.T.,.F.)
Private oCour12N 	:= TFont():New("Courier New",12,12,.T.,.T.,5,.T.,5,.T.,.F.)
Private oCour14N 	:= TFont():New("Courier New",14,14,.T.,.T.,5,.T.,5,.T.,.F.)
Private oFont8		:= TFont():New("Arial",08,08,.T.,.F.,5,.T.,5,.T.,.F.)
Private oArial08N	:= TFont():New("Arial",08,08,.T.,.T.,5,.T.,5,.T.,.F.)
Private oArial10N	:= TFont():New("Arial",10,10,.T.,.T.,5,.T.,5,.T.,.F.)
Private oArial12N	:= TFont():New("Arial",10,12,.T.,.T.,5,.T.,5,.T.,.F.)
Private oArial14N	:= TFont():New("Arial",13,14,.T.,.T.,5,.T.,5,.T.,.F.)
Private oArial16N	:= TFont():New("Arial",14,16,.T.,.T.,5,.T.,5,.T.,.F.)
Private oArial20N	:= TFont():New("Arial",18,20,.T.,.T.,5,.T.,5,.T.,.F.)
Private oArial21N	:= TFont():New("Arial",19,21,.T.,.T.,5,.T.,5,.T.,.F.)
Private oTime08N	:= TFont():New("Time New Roman",08,08,.T.,.T.,5,.T.,5,.T.,.F.)
Private oTime09N	:= TFont():New("Time New Roman",09,09,.T.,.T.,5,.T.,5,.T.,.F.)
Private oTime10N	:= TFont():New("Time New Roman",10,10,.T.,.T.,5,.T.,5,.T.,.F.)
Private oTime12N	:= TFont():New("Time New Roman",12,12,.T.,.T.,5,.T.,5,.T.,.F.)
Private oTime14N	:= TFont():New("Time New Roman",14,14,.T.,.T.,5,.T.,5,.T.,.F.)
Private oTime16N	:= TFont():New("Time New Roman",16,16,.T.,.T.,5,.T.,5,.T.,.F.)
Private nRowIni := 50
Private nColIni := 50
Private nColFim := 2300
Private nRowFim := 3250
Private nRow := 0
Private nPulo := 50
Private lItens := .F.
Private nRowIniItens := 0 
Private lFirstItem := .T.

cAliasTrb := GetNextAlias()

cQ := "SELECT FNR.*,FN9.* "
cQ += "FROM "+RetSqlName("FNR")+" FNR, "
cQ += RetSqlName("FN9")+" FN9, "
cQ += RetSqlName("SN1")+" SN1 "
cQ += "WHERE FNR_FILIAL = '"+xFilial("FNR")+"' "
cQ += "AND FNR_DATA BETWEEN '"+dTos(mv_par01)+"' AND '"+dTos(mv_par02)+"' "
cQ += "AND FNR_CBAORI BETWEEN '"+mv_par03+"' AND '"+mv_par05+"' "
cQ += "AND FNR_CBADES BETWEEN '"+mv_par03+"' AND '"+mv_par05+"' "
cQ += "AND FNR_ITEORI BETWEEN '"+mv_par04+"' AND '"+mv_par06+"' "
cQ += "AND FNR_ITEDES BETWEEN '"+mv_par04+"' AND '"+mv_par06+"' "
cQ += "AND FNR.D_E_L_E_T_ = ' ' "
cQ += "AND FN9_FILIAL = '"+xFilial("FN9")+"' "
cQ += "AND FNR_IDMOV = FN9_IDMOV "
cQ += "AND FN9.D_E_L_E_T_ = ' ' "
cQ += "AND N1_FILIAL = '"+xFilial("SN1")+"' "
cQ += "AND N1_CBASE = FNR_CBAORI "
cQ += "AND N1_ITEM = FNR_ITEORI "
cQ += "AND SN1.D_E_L_E_T_ = ' ' "
cQ += "ORDER BY FNR_DATA,FNR_IDMOV,N1_CHAPA "

cQ := ChangeQuery(cQ)

TcQuery cQ New Alias (cAliasTrb)

aEval(FNR->(dbStruct()),{|e| If(e[2]!="C",tcSetField(cAliasTrb,e[1],e[2],e[3],e[4]),Nil)})
dbEval({|x| nRegs++ },,{|| (cAliasTrb)->(!EOF())})

dbGotop()

// cabem 64 linhas na folha
// tem que deixar 18 linhas para o cabecalho
// tem que deixar 19 linhas para o rodape
//nLinhasFol := 64
//nLinhasCab := 18
//nLinhasRod := 19

_lPrimeiro := .t.

SN1->(dbSetOrder(1))
While (cAliasTrb)->(!Eof())
	cLocalOri := (cAliasTrb)->FNR_LOCORI
	ImpCabec()

	cChave := dTos((cAliasTrb)->(FNR_DATA))+(cAliasTrb)->FNR_IDMOV
	aRoda := {}
	nFolha := 0

	While (cAliasTrb)->(!Eof()) .and. cChave == dtos((cAliasTrb)->(FNR_DATA))+(cAliasTrb)->FNR_IDMOV	
		If SN1->(!dbSeek(xFilial("SN1")+(cAliasTrb)->FNR_CBAORI+(cAliasTrb)->FNR_ITEORI))
			(cAliasTrb)->(dbSkip())
			Loop
		Endif
		
		If lFirstItem
			nRowIniItens := nRow
			lFirstItem := .F.
			aRoda := {(cAliasTrb)->FN9_XMOTIV,(cAliasTrb)->FN9_XOS,(cAliasTrb)->FN9_XOBS}
		Endif	 
		lItens := .T.
		ImpItens()
				
		(cAliasTrb)->(DbSkip())
	Enddo	
	
	oPrint:Box(nRowIniItens,nColIni,nRow,nColFim)
	
	lItens := .F.
	lFirstItem := .T.
	ImpRoda()

	oPrint:EndPage()
EndDo

(cAliasTrb)->(DbCloseArea())

If !_lPrimeiro
	//oPrint:EndPage()
	oPrint:Preview()     // Visualiza antes de imprimir
EndIf

Return


Static Function PulaLinha()

nRow += nPulo
If lItens
	// fecha box dos itens
	If nRow >= nRowFim
		oPrint:Box(nRowIniItens,nColIni,nRow,nColFim)
	Endif
Endif		

If nRow >= nRowFim
	nRow := nRowIni
	nFolha++
	oPrint:Say(nRowFim+50,1600,dToc(dDataBase)+" / "+Time()+" - "+"FOLHA: "+Alltrim(Str(nFolha)),oCour10N)	
	oPrint:EndPage()
	oPrint:StartPage()
	If lItens
		oPrint:Box(nRow,nColIni,nRow+(nPulo*1),nColFim)
		oPrint:Say(nRow,nColIni+0020,"CHAPA",oCour10N)
		oPrint:Say(nRow,nColIni+0400,"SERIE",oCour10N)
		oPrint:Say(nRow,nColIni+0950,"DESCRIวรO",oCour10N)
		lItens := .F.
		nRowIniItens := nRow+nPulo	
		PulaLinha()
	Endif	
Endif	

Return()


Static Function ImpCabec()

If _lPrimeiro
	oPrint:= TMSPrinter():New()
	oPrint:SetPortrait()
	_lPrimeiro := .f.
EndIf
	
oPrint:StartPage()
nRow:= nRowIni

oPrint:Box(nRow,nColIni,nRow+(nPulo*4),nColFim)
oPrint:Say(nRow,nColIni+0020,Alltrim(SM0->M0_NOMECOM),oCour10N)
PulaLinha()
oPrint:Say(nRow,nColIni+0020,"CNPJ: "+SM0->M0_CGC,oCour10N)
oPrint:Say(nRow,nColIni+0500,"CCM: "+SM0->M0_INSCM,oCour10N)
PulaLinha()
oPrint:Say(nRow,nColIni+0020,Alltrim(SM0->M0_ENDCOB)+" - "+Alltrim(SM0->M0_BAIRCOB)+" - "+Alltrim(SM0->M0_CIDCOB)+" - "+Alltrim(SM0->M0_ESTCOB),oCour10N)
PulaLinha()
oPrint:Say(nRow,nColIni+0020,"CEP: "+Alltrim(SM0->M0_CEPCOB)+" - "+"HTTP://WWW.PRODAM.SP.GOV.BR",oCour10N)
PulaLinha()
oPrint:Box(nRow,nColIni,nRow+(nPulo*1),nColFim)
oPrint:Say(nRow,nColIni+0020,"ISENTO DE INSCRIวรO ESTADUAL CONFORME PROCESSO DRT. 1 NUM.: 28099/75",oCour10N)
PulaLinha()
oPrint:Box(nRow,nColIni,nRow+(nPulo*3),nColFim-700)
oPrint:Box(nRow,nColFim-0700,nRow+(nPulo*3),nColFim)
oPrint:Say(nRow,nColFim-650,"NUM: "+(cAliasTrb)->FNR_IDMOV,oCour10N)
PulaLinha()
oPrint:Say(nRow,nColIni+0020,"DOCUMENTO DE IDENTIFICAวรO E MOVIMENTAวรO DE BEM PATRIMONIAL",oCour10N)
PulaLinha()
oPrint:Say(nRow,nColFim-650,"DATA: "+dToc((cAliasTrb)->FNR_DATA),oCour10N)
PulaLinha()	
oPrint:Box(nRow,nColIni,nRow+(nPulo*10),nColFim)
oPrint:Say(nRow,nColIni+0020,"DESTINATมRIO",oCour10N)
PulaLinha()
oPrint:Say(nRow,nColIni+0020,"CำDIGO DO LOCAL: "+(cAliasTrb)->FNR_LOCDES,oCour10N)
PulaLinha()
oPrint:Say(nRow,nColIni+0020,"DESCRIวรO DO LOCAL: "+Posicione("SNL",1,xFilial("SNL")+(cAliasTrb)->FNR_LOCDES,"NL_DESCRIC"),oCour10N)
PulaLinha()
oPrint:Say(nRow,nColIni+0020,"ENDEREวO: "+Posicione("SNL",1,xFilial("SNL")+(cAliasTrb)->FNR_LOCDES,"NL_XEND"),oCour10N)
PulaLinha()
PulaLinha()
oPrint:Say(nRow,nColIni+0020,"REMETENTE",oCour10N)
PulaLinha()
oPrint:Say(nRow,nColIni+0020,"CำDIGO DO LOCAL: "+cLocalOri,oCour10N)
PulaLinha()
oPrint:Say(nRow,nColIni+0020,"DESCRIวรO DO LOCAL: "+Posicione("SNL",1,xFilial("SNL")+cLocalOri,"NL_DESCRIC"),oCour10N)
PulaLinha()
oPrint:Say(nRow,nColIni+0020,"ENDEREวO: "+Posicione("SNL",1,xFilial("SNL")+cLocalOri,"NL_XEND"),oCour10N)
PulaLinha()
oPrint:Box(nRow,nColIni,nRow+(nPulo*1),nColFim)
oPrint:Say(nRow,nColIni+0900,"DESCRIวรO DO BEM PATRIMONIAL",oCour10N)
PulaLinha()
oPrint:Box(nRow,nColIni,nRow+(nPulo*1),nColFim)
oPrint:Say(nRow,nColIni+0020,"CHAPA",oCour10N)
oPrint:Say(nRow,nColIni+0400,"SERIE",oCour10N)
oPrint:Say(nRow,nColIni+0950,"DESCRIวรO",oCour10N)
PulaLinha()

Return()


Static Function ImpItens()

oPrint:Say(nRow,nColIni+0020,SN1->N1_CHAPA,oCour10N)
oPrint:Say(nRow,nColIni+0400,IIf(SN1->(FieldPos("N1_XNSERIE"))>0,SN1->N1_XNSERIE,""),oCour10N)
oPrint:Say(nRow,nColIni+0950,SN1->N1_DESCRIC,oCour10N)
PulaLinha()

Return()


Static Function ImpRoda()

oPrint:Box(nRow,nColIni,nRow+(nPulo*2),nColFim)
oPrint:Say(nRow,nColIni+0020,"MOTIVO DA MOVIMENTAวรO: "+aRoda[1],oCour10N)
PulaLinha()
PulaLinha()
oPrint:Box(nRow,nColIni,nRow+(nPulo*2),nColFim)
oPrint:Say(nRow,nColIni+0020,"O.S. N.: "+aRoda[2],oCour10N)
oPrint:Box(nRow,nColIni,nRow+0100,nColFim)
PulaLinha()
PulaLinha()
oPrint:Box(nRow,nColIni,nRow+(nPulo*2),nColFim)
oPrint:Say(nRow,nColIni+0020,"OBS: "+aRoda[3],oCour10N)
PulaLinha()
PulaLinha()
oPrint:Box(nRow,nColIni,nRow+0100,nColIni+0500)
oPrint:Box(nRow,nColIni+0500,nRow+0100,nColIni+1100)
oPrint:Box(nRow,nColIni+1100,nRow+0100,nColIni+1700)
oPrint:Box(nRow,nColIni+1700,nRow+0100,nColFim)
oPrint:Say(nRow,nColIni+0520,"REMETENTE",oCour10N)
oPrint:Say(nRow,nColIni+1120,"DESTINATมRIO",oCour10N)
oPrint:Say(nRow,nColIni+1720,"PORTARIA",oCour10N)
PulaLinha()
PulaLinha()
oPrint:Box(nRow,nColIni,nRow+0100,nColIni+0500)
oPrint:Box(nRow,nColIni+0500,nRow+0100,nColIni+1100)
oPrint:Box(nRow,nColIni+1100,nRow+0100,nColIni+1700)
oPrint:Box(nRow,nColIni+1700,nRow+0100,nColFim)
oPrint:Say(nRow,nColIni+0020,"NOME",oCour10N)
PulaLinha()
PulaLinha()
oPrint:Box(nRow,nColIni,nRow+0100,nColIni+0500)
oPrint:Box(nRow,nColIni+0500,nRow+0100,nColIni+1100)
oPrint:Box(nRow,nColIni+1100,nRow+0100,nColIni+1700)
oPrint:Box(nRow,nColIni+1700,nRow+0100,nColFim)
oPrint:Say(nRow,nColIni+0020,"VISTO",oCour10N)
PulaLinha()
PulaLinha()
oPrint:Box(nRow,nColIni,nRow+0100,nColIni+0500)
oPrint:Box(nRow,nColIni+0500,nRow+0100,nColIni+1100)
oPrint:Box(nRow,nColIni+1100,nRow+0100,nColIni+1700)
oPrint:Box(nRow,nColIni+1700,nRow+0100,nColFim)
oPrint:Say(nRow,nColIni+0020,"CARIMBO RF/RG",oCour10N)
PulaLinha()
PulaLinha()
oPrint:Box(nRow,nColIni,nRow+0100,nColIni+0500)
oPrint:Box(nRow,nColIni+0500,nRow+0100,nColIni+1100)
oPrint:Box(nRow,nColIni+1100,nRow+0100,nColIni+1700)
oPrint:Box(nRow,nColIni+1700,nRow+0100,nColFim)
oPrint:Say(nRow,nColIni+0020,"DATA",oCour10N)
PulaLinha()
PulaLinha()
oPrint:Box(nRow,nColIni,nRow+(nPulo*2),nColFim)
oPrint:Say(nRow,nColIni+0020,"EMITENTE: "+cUserName,oCour10N)
PulaLinha()
PulaLinha()
nFolha++
oPrint:Say(nRowFim+50,1600,dToc(dDataBase)+" / "+Time()+" - "+"FOLHA: "+Alltrim(Str(nFolha)),oCour10N)

Return()


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณfCriaSx1  บAutor  ณTotvs               บ Data ณ             บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ Funcao para criacao das perguntas.                         บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ AP - Prodam                                                บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
Static Function fCriaSx1()

//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
//ณMV_PAR01  Data de           ณ
//ณMV_PAR02  Data ate          ณ
//ณMV_PAR03  Codigo do Bem de  ณ
//ณMV_PAR04  Item do bem de    ณ
//ณMV_PAR05  Codigo do Bem ate ณ
//ณMV_PAR06  Item do bem ate   ณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู

PutSx1( cPerg, "01","Data de  ","","","mv_ch1","D",08,0,0,"G","","","","","mv_par01","","","","","","","","","","","","","","","","",{},{},{})
PutSx1( cPerg, "02","Data ate ","","","mv_ch2","D",08,0,0,"G","","","","","mv_par02","","","","","","","","","","","","","","","","",{},{},{})
PutSx1( cPerg, "03","Codigo Bem de","","","mv_ch3","C",TamSX3("N1_CBASE")[1]		,0,0,"G","","SN1APT"		,"","","mv_par03","","","","","","","","","","","","","","","","",{},{},{})
PutSx1( cPerg, "04","Item de","","","mv_ch4","C",TamSX3("N1_ITEM")[1]		,0,0,"G","",""		,"","","mv_par04","","","","","","","","","","","","","","","","",{},{},{})
PutSx1( cPerg, "05","Codigo Bem ate","","","mv_ch5","C",TamSX3("N1_CBASE")[1]	,0,0,"G","","SN1APT"	,"","","mv_par05","","","","","","","","","","","","","","","","",{},{},{})
PutSx1( cPerg, "06","Item ate       ","","","mv_ch6","C",TamSX3("N1_ITEM")[1]		,0,0,"G","",""		,"","","mv_par06","","","","","","","","","","","","","","","","",{},{},{})

Return
