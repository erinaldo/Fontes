/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณPROR0003  บAutor  ณTotvs               บ Data ณ             บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณFuncao para impressao dos documentos de termo de responsabi-บฑฑ
ฑฑบ          ณlidade do ativo fixo.                                       บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ AP - Prodam.                                               บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
#Include "Protheus.ch"
#Include "Topconn.ch"

User Function PROR0003()

Private cPerg := "PROR0003"
Private cCadastro	:= "Impressao de Termo de Responsabilidade do Ativo Fixo"
Private aSays		:= {}
Private aButtons	:= {}
Private nOpca 		:= 0
Private oPrint

// Funcao para criacao das perguntas.
fCriaSx1()

// Forca o usuario a preencher as perguntas.
//If ! Pergunte(cPerg,.t.)
//	Return
//EndIf
Pergunte(cPerg,.F.)

AADD(aSays,"Este programa ira realizar a impressใo dos Termos," )
AADD(aSays,"de responsabilidade Ativo Fixo." )


AADD(aButtons, { 5,.T.,{|| Pergunte(cPerg,.T. )}})
AADD(aButtons, { 1,.T.,{|o| nOpca := 1,FechaBatch()}})
AADD(aButtons, { 2,.T.,{|o| FechaBatch() }} )

FormBatch( cCadastro, aSays, aButtons )

If nOpca == 1
	//If ApMsgYesNo("Confirma impressao do Termo ?","Confirmar")
		Processa({|| fimprime()})
	//EndIf
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

Local _cQuery	:= ""

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
Private nRowIni := 010
Private nColIni := 050
Private nColFim := 2300
Private nRowFim := 3250
Private nRowAtu := 0

nRowAtu := nRowIni

_cAlias := GetNextAlias()

_cQuery := "SELECT ND_CBASE, ND_ITEM, ND_CODRESP, RD0_NOME, RD0_TIPO "  //  -- 1 = Interno / 2 = Externo
_cQuery += "       FROM " + RetSqlName("SND") + " SND "
_cQuery += "       INNER JOIN " + RetSqlName("RD0") + " RD0 "
_cQuery += "        ON RD0_FILIAL = '" + xFilial("RD0") + "' AND RD0_CODIGO = ND_CODRESP "
_cQuery += "           AND RD0.D_E_L_E_T_ = ' ' "
_cQuery += "WHERE ND_FILIAL = '" + xFilial("SND") + "' "
_cQuery += "      AND ND_CODRESP BETWEEN '" + MV_PAR01 + "' AND '" + MV_PAR02 + "' "
_cQuery += "      AND ND_CBASE || ND_ITEM BETWEEN '" + MV_PAR03+MV_PAR04 + "' AND '" + MV_PAR05+MV_PAR06 + "' "
_cQuery += "      AND ND_STATUS = '1' AND SND.D_E_L_E_T_ = ' ' "
_cQuery += "ORDER BY ND_CODRESP "

_cQuery := ChangeQuery(_cQuery)

TcQuery _cQuery New Alias (_cAlias)

(_cAlias)->(DbGoTop())


_lPrimeiro := .t.

SN1->(DbSetOrder(1))
// N1_FILIAL, N1_CBASE, N1_ITEM, R_E_C_N_O_, D_E_L_E_T_

Do While ! (_cAlias)->(Eof())
	
	If _lPrimeiro
		oPrint:= TMSPrinter():New( "Termo de responsabilidade" )
		oPrint:SetPortrait()
		_lPrimeiro := .f.
	EndIf
	
	_cCodResp := (_cAlias)->ND_CODRESP
	
	fForm()
	
	Do While ! (_cAlias)->(Eof()) .And. (_cAlias)->ND_CODRESP == _cCodResp
		SN1->(DbSeek(xFilial("SN1")+(_cAlias)->ND_CBASE+(_cAlias)->ND_ITEM))
		If nRowAtu > (nRowFim-0250)
			oPrint:EndPage()
			fForm()
		EndIf
		
		oPrint:Say(nRowAtu,nColIni+0010,(_cAlias)->ND_CBASE,oCour08N)
		oPrint:Say(nRowAtu,nColIni+0300,(_cAlias)->ND_ITEM,oCour08N)
		oPrint:Say(nRowAtu,nColIni+0500,SN1->N1_DESCRIC,oCour08N)
		oPrint:Say(nRowAtu,nColIni+1100,Transform(SN1->N1_QUANTD,PesqPict("SN1","N1_QUANTD")),oCour08N)
		oPrint:Say(nRowAtu,nColIni+1400,SN1->N1_CHAPA,oCour08N)
		oPrint:Say(nRowAtu,nColIni+1700,SN1->N1_LOCAL,oCour08N)
		nRowAtu+=0050
		
		(_cAlias)->(DbSkip())
	EndDo
	oPrint:EndPage()
	
EndDo

(_cAlias)->(DbCloseArea())

If ! _lPrimeiro
	oPrint:EndPage()
	oPrint:Preview()     // Visualiza antes de imprimir
EndIf

Return


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณfForm     บAutor  ณTotvs               บ Data ณ             บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณFuncao de montagem do formulario.                           บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ AP - Prodam                                                บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
Static Function fForm()

oPrint:StartPage()

oPrint:Box(nRowIni,nColIni,nRowFim-0250,nColFim)
oPrint:Line(nRowIni+0200,nColIni,nRowIni+0200,nColFim)
oPrint:Say(nRowIni+0070,nColIni+0700,"TERMO DE RESPONSABILIDADE",oArial14N)
oPrint:Line(nRowIni+0400,nColIni,nRowIni+0400,nColFim)
oPrint:Say(nRowIni+0210,nColIni+0010,"Declaro, pelo presente, que recebi da empresa -" +  Alltrim(SM0->M0_NOMECOM)+" os bens abaixo",oCour08N)
oPrint:Say(nRowIni+0250,nColIni+0010,"especificados:",oCour08N)

oPrint:Say(nRowIni+0290,nColIni+0010,"C๓digo do Responsแvel:" + (_cAlias)->ND_CODRESP,oCour08N)
oPrint:Say(nRowIni+0330,nColIni+0010,"Nome:" + (_cAlias)->RD0_NOME, oCour08N)
oPrint:Say(nRowIni+0370,nColIni+0010,"Tipo:" + iif((_cAlias)->RD0_TIPO=="1","Interno","Externo"),oCour08N)
oPrint:Line(nRowIni+0440,nColIni,nRowIni+0440,nColFim)
oPrint:Say(nRowIni+0405,nColIni+0010,"CำDIGO DO BEM",oArial08N)
oPrint:Say(nRowIni+0405,nColIni+0300,"ITEM",oArial08N)
oPrint:Say(nRowIni+0405,nColIni+0500,"DESCRIวรO",oArial08N)
oPrint:Say(nRowIni+0405,nColIni+1100,"QUANT",oArial08N)
oPrint:Say(nRowIni+0405,nColIni+1400,"PLAQUETA",oArial08N)
oPrint:Say(nRowIni+0405,nColIni+1700,"LOCALIZAวรO",oArial08N)

_nFinal := (nRowFim-0220)

For _nZ := nRowIni+440 To _nFinal Step 50
	oPrint:Line(_nZ,nColIni,_nZ,nColFim)
Next _nZ

oPrint:Line(nRowIni+0400,nColIni+0290,nRowFim-0250,nColIni+0290)
oPrint:Line(nRowIni+0400,nColIni+0490,nRowFim-0250,nColIni+0490)
oPrint:Line(nRowIni+0400,nColIni+1090,nRowFim-0250,nColIni+1090)
oPrint:Line(nRowIni+0400,nColIni+1390,nRowFim-0250,nColIni+1390)
oPrint:Line(nRowIni+0400,nColIni+1690,nRowFim-0250,nColIni+1690)


oPrint:Box(nRowFim-0200,nColIni,nRowFim,(nColFim/2)-0010)
oPrint:Say(nRowFim-0190,nColIni+0010,"ENTREGADOR",oArial10N)
oPrint:Say(nRowFim-0110,nColIni+0010,"Nome:___________________________________________________",oArial08N)
oPrint:Say(nRowFim-0040,ncolIni+0010,"Em:____/____/____   Assinatura:____________________________",oArial08N)


oPrint:Box(nRowFim-0200,(nColFim/2)+0010,nRowFim,nColFim)
oPrint:Say(nRowFim-0190,(nColFim/2)+0020,"RECEBEDOR",oArial10N)
oPrint:Say(nRowFim-0110,(nColFim/2)+0020,"Nome:" + (_cAlias)->RD0_NOME,oArial08N)
oPrint:Say(nRowFim-0040,(nColFim/2)+0020,"Em:____/____/____   Assinatura:____________________________",oArial08N)

nRowAtu := nRowIni+0450

Return

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
//ณMV_PAR01  Responsavel de    ณ
//ณMV_PAR02  Responsavel ate   ณ
//ณMV_PAR03  Codigo do Bem de  ณ
//ณMV_PAR04  Item do bem de    ณ
//ณMV_PAR05  Codigo do Bem ate ณ
//ณMV_PAR06  Item do bem ate   ณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู

PutSx1( cPerg, "01","Responsavel de  ","","","mv_ch1","C",TamSX3("RD0_CODIGO")[1]	,0,0,"G","","RD0"		,"","","mv_par01","","","","","","","","","","","","","","","","",{},{},{})
PutSx1( cPerg, "02","Responsavel ate ","","","mv_ch2","C",TamSX3("RD0_CODIGO")[1]	,0,0,"G","","RD0"		,"","","mv_par02","","","","","","","","","","","","","","","","",{},{},{})
PutSx1( cPerg, "03","Codigo Bem de","","","mv_ch3","C",TamSX3("N1_CBASE")[1]		,0,0,"G","","SN1APT"		,"","","mv_par03","","","","","","","","","","","","","","","","",{},{},{})
PutSx1( cPerg, "04","Item de","","","mv_ch4","C",TamSX3("N1_ITEM")[1]		,0,0,"G","",""		,"","","mv_par04","","","","","","","","","","","","","","","","",{},{},{})
PutSx1( cPerg, "05","Codigo Bem ate","","","mv_ch5","C",TamSX3("N1_CBASE")[1]	,0,0,"G","","SN1APT"	,"","","mv_par05","","","","","","","","","","","","","","","","",{},{},{})
PutSx1( cPerg, "06","Item ate       ","","","mv_ch6","C",TamSX3("N1_ITEM")[1]		,0,0,"G","",""		,"","","mv_par06","","","","","","","","","","","","","","","","",{},{},{})

Return
