#INCLUDE "RWMAKE.Ch"                                                                                                                              
#include "TOPCONN.ch"

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ºPrograma  ³AAJ0037   ºAutor  ³ALEXANDRE SOUZA   º Data ³  18/06/07                          º±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ºDesc.     ³ RELATORIO DE ETIQUETA DE PERÍODO DE EXPERIENCIA (GRAFICA)                       º±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ºUso       ³  Texto                                                                          º±±
±±------------------------------------------------------------------------------------------------
±± 18/06/07 |  Específico CSU - Programa Adaptado para uso da CSU                              º±±
±±------------------------------------------------------------------------------------------------
±± 13/02/08 |  Alterado por Alexandre Souza, conforme chamado numero 3516, a partir desta alte-º±±
±±          |  o relatório de etiquetas passa a imprimir conforme a ordem selecionada.         º±±
±±------------------------------------------------------------------------------------------------
±±          |                                                                                  º±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

USER FUNCTION AAJ0037()

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Define variaveis                                                                                        ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
cDesc1   := "Específico CSU - Este relatorio tem o objetivo"
cDesc2   := "de imprimir etiqueta de periodo de experiencia "
cDesc3   := ""
cString  := 'SRA'
cTamanho := 'P'
Titulo   := 'ETIQUETA DE PERIODO DE EXPERIENCIA'
wnRel    := 'AAJ0037'
limite   := 80
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Variaveis utilizadas para montar Get.                        ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

Private aReturn         := { "Zebrado", 1,"Administracao", 2, 2, 1,"",1 }
Private cPerg           := PADR("GPR320",LEN(SX1->X1_GRUPO))
Private aOrd       // Alterado em 13/02/2008, passa a imprimir por ordem
Private nOrdem       // Alterado em 13/02/2008, passa a imprimir por ordem

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Janela Principal                                             ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
cTitulo:="Etiqueta de periodo de experiencia"
cText1:="Neste relatorio serao impressas etiquetas de periodo de experiencia, conforme configuracao dos parametros"
aOrd    := {"Filial + Matricula","Filial + Nome"}       // Alterado em 13/02/2008, passa a imprimir por ordem

Pergunte(cPerg,.f.)

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Envia controle para a funcao SETPRINT                        ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
wnRel := SetPrint(cString, wnRel, cPerg, Titulo, cDesc1, cDesc2, cDesc3, .F.,aOrd, .F.,cTamanho)       // Alterado em 13/02/2008, passa a imprimir por ordem
nView    := 1

If nLastKey == 27
	Set Filter To
	Return Nil
Endif

SetDefault(aReturn, cString)

If nLastKey == 27
	Set Filter To
	Return Nil
Endif

RptStatus({|lEnd| AAJ37Imp(@lEnd, wnRel,cTamanho, Titulo)}, Titulo)

Set Filter To

Return(Nil)

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
Static Function AAJ37Imp(lEnd, wnRel, cTamanho, Titulo)

Local lImpAug :=.T.
Local cTxtFoot := Space(10)
Local cNomAudLid
Local cNomeAud
Local nOrdem     := aReturn[8]   // Alterado em 13/02/2008, passa a imprimir por ordem

Private nLin :=01
Private nREG := 0
Private m_pag   := 1
Private cCabec1 := ""
Private cCabec2 :=  ""
Private nPag    := 1
Private lPagPrint := .T.
Private lInicial := .F.
Private nEspLarg := GetMv("MV_ETCEL") // espaçamento entre etiquetas na largura (em pixels)
Private nEspAlt  := GetMv("MV_ETCEA") // espaçamento entre etiquetas na altura  (em pixels)
Private nVertMax := GetMv("MV_ETCQL") // Qtde vertical de etiquetas por página
Private nVertical:= 1
Private nHorizMax:= mv_par13
Private nHorizont:= 1
Private cEmpEtiq := SM0->M0_CODIGO


oFont1    := TFont():New( "Arial",,08,,.F.,,,,,.f. )
oFont2    := TFont():New( "Arial",,10,,.t.,,,,,.f. )
oFont3    := TFont():New( "Arial",,12,,.t.,,,,.T.,.f. )

If !lInicial
	lInicial := .T.
	oprn:=TMSPrinter():New( Titulo )
Endif
                                                             
// DBSELECTAREA("SM0") - ADAPTADO POR ALEXANDRE
DBSELECTAREA("SRA")
nRecM0 := recno()

//cQuery := "Select RA_FILIAL,RA_MAT,RJ_DESC,RA_ADMISSA,RA_SALARIO,RJ_CODCBO,RA_CATFUNC,RA_SINDICA,RA_SITFOLH " -> ADAPTADO POR ALEXANDRE
cQuery := "Select RA_FILIAL,RA_MAT,RA_NOME,RJ_DESC,RA_ADMISSA,RA_SALARIO,RJ_CODCBO,RA_CATFUNC,RA_SINDICA,RA_SITFOLH,RA_VCTOEXP,RA_VCTEXP2 "
cQuery += "FROM "+retsqlname("SRA")+","+retsqlname("SRJ")+" "
cQuery += "WHERE RA_CODFUNC=RJ_FUNCAO AND "+retsqlname("SRA")+".D_E_L_E_T_<>'*' AND "
cQuery += "RA_FILIAL  >= '" + MV_PAR01 + "' AND "
cQuery += "RA_FILIAL  <= '" + MV_PAR02 + "' AND "
cQuery += "RA_CC      >= '" + MV_PAR03 + "' AND "
cQuery += "RA_CC      <= '" + MV_PAR04 + "' AND "
cQuery += "RA_MAT     >= '" + MV_PAR05 + "' AND "
cQuery += "RA_MAT     <= '" + MV_PAR06 + "' AND "
cQuery += "RA_NOME    >= '" + MV_PAR07 + "' AND "
cQuery += "RA_NOME    <= '" + MV_PAR08 + "' AND "
cQuery += "RA_ADMISSA >= '" + DTOS(MV_PAR10) + "' AND "
cQuery += "RA_ADMISSA <= '" + DTOS(MV_PAR11) + "' "
// Alterado em 13/02/2008, passa a imprimir por ordem
if nOrdem == 2
	cQuery += "ORDER BY RA_FILIAL, RA_NOME"
Else
	cQuery += "ORDER BY RA_FILIAL, RA_MAT"
Endif


If Select("AJ37") > 0
	DbSelectArea("AJ37")
	DbCloseArea()
Endif
TCQUERY cQuery NEW ALIAS "AJ37"
DbSelectArea("AJ37")
DBGOTOP()


lPagPrint := .T.
oprn:StartPage() // Inicia uma nova pagina


do while !eof()
	if mv_par12 != '99'
		if RA_SINDICA != MV_PAR12
			DBSKIP()
			LOOP
		ENDIF
	ENDIF
	IF !(RA_CATFUNC $ MV_PAR09)
		DBSKIP()
		LOOP
	ENDIF
	IF !(RA_SITFOLH $ MV_PAR16)
		DBSKIP()
		LOOP
	ENDIF
	
	nREG++
	
	*-----------\/----lógica da impressão
	SRA->(dbseek(cEmpEtiq+AJ37->RA_FILIAL))
	
	nLP := ((nVertical-1)*nEspAlt ) + 170
	nCP := ((nHorizont-1)*nEspLarg) + 50
		
	oprn:Say(nLP,nCP,RA_FILIAL+'-'+RA_MAT,oFont3,100)
	
	cDias1  := If(!Empty(Ra_VctoExp),StrZero((Stod(Ra_VctoExp)-Stod(Ra_Admissa))+1,2),"45")
	cDias2  := If(!Empty(Ra_VctExp2),StrZero(Stod(Ra_VctExp2)-Stod(Ra_VctoExp),2),"45")

    cLinhaA := "Contrato de Experiência de "+cDias1+" dias, no"
    cLinhaB := "período de "+ DTOC(StoD(RA_ADMISSA)) +" à " + DTOC(StoD(RA_VCTOEXP)) + ", ficando "
    cLinhaC := "automaticamente prorrogado por mais "+cDias2+ " 
    cLinhaD := "dias, até "  + DTOC(StoD(RA_VCTEXP2)) + " se nenhuma das partes "
    cLinhaE := "manifestar interesse de encerramento no"
    cLinhaF := "1º periodo (Art.443 $ 2ºletra 'C' da CLT)."
   	cLinhaG := " " 
   	cLinhaH := ''
                                                                                        


    		

	oprn:Say(nLP+0100,nCP,cLinhaA,oFont1,100)
	oprn:Say(nLP+0150,nCP,cLinhaB,oFont1,100)
	oprn:Say(nLP+0200,nCP,cLinhaC,oFont1,100)
	oprn:Say(nLP+0250,nCP,cLinhaD,oFont1,100)
	oprn:Say(nLP+0300,nCP,cLinhaE,oFont1,100)
	oprn:Say(nLP+0350,nCP,cLinhaF,oFont1,100)
	oprn:Say(nLP+0400,nCP,cLinhaG,oFont1,100)
	oprn:Say(nLP+0450,nCP,cLinhaH,oFont1,100)

	oprn:Say(nLP+0650,nCP+300,SM0->M0_NOMECOM,oFont1,100)	

	nHorizont++

	if nHorizont >  nHorizMax
		nHorizont := 1
		nVertical++
	endif
	if nVertical > 	nVertMax
		nVertical := 1
		oprn:EndPage()
		oprn:StartPage()
	endif
		
	*-----------/\----lógica da impressão
	
	
	
	dbselectarea("AJ37")
	dbskip()
enddo







//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Devolve a condicao original do arquivo principal                  ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

Set device to Screen
IF nREG <= 0
	Msginfo("Nao ha registro validos para Relatorio")
	dbSelectArea("AJ37")
	DBCLOSEAREA()
	RETURN
ENDIF
dbSelectArea("AJ37")
DBCLOSEAREA()
IF nView == 1
	oprn:Preview()  // Visualiza antes de imprimir
Else
	oprn:Print() // Imprime direto na impressora default Protheus
Endif



MS_FLUSH()

DBSELECTAREA("SRA")
dbgoto(nRecM0)

Return(nil)
