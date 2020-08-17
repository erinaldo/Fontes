#include "protheus.ch"
#include "Topconn.ch" 
#include "Fwmbrowse.ch"
#include "Parmtype.ch"
#include "Tbiconn.ch"
#include "Fwmvcdef.ch"
#include 'Fwmvcdef.ch'
#include "Fweventviewconsts.ch"


#DEFINE VALMERC 	1  // Valor total do mercadoria
#DEFINE VALDESC 	2  // Valor total do desconto
#DEFINE VALIPI  	3  // Valor total do IPI
#DEFINE VALICM  	4  // Valor total do ICMS
#DEFINE FRETE   	5  // Valor total do Frete
#DEFINE VALDESP 	6  // Valor total da despesa
#DEFINE TOTF1		7  // Total de Despesas Folder 1
#DEFINE TOTPED		8  // Total do Pedido
#DEFINE BASEIPI 	9  // Base de IPI
#DEFINE BASEICM     10 // Base de ICMS
#DEFINE BASESOL     11 // Base do ICMS Sol.
#DEFINE VALSOL		12 // Valor do ICMS Sol.
#DEFINE VALCOMP 	13 // Valor do ICMS Com.
#DEFINE SEGURO		14 // Valor total do seguro
#DEFINE TOTF3		15 // Total utilizado no Folder 3

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัอออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณ GJP130Cot บ Autor ณ Carlos A. Queiroz  บ Data ณ  19/05/15   บฑฑ
ฑฑฬออออออออออุอออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ Interface que engloba todas as funcionalidades envolvendo   บฑฑ
ฑฑบ          ณ o processo de Cotacoes.                                     บฑฑ
ฑฑฬออออออออออุอออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ GJP Hotels & Resorts                                        บฑฑ
ฑฑศออออออออออฯอออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
User Function GJP130Cot(nFolder)

Local aInfo     := {}
Local aPosObj   := {}
Local aObjects  := {}
Local aSize     := MsAdvSize()
Local oMsGet
Local nOpcA     := 0
Local aButtons  := {}
Local aArea		 := GetArea()
Local aIndexSC1	 := {}
Local aCores     := {}
Local aCores2    := {}
Local aCoresNew  := {}
Local aGrupo	 := {}
Local cGrupComp  := ""
//Local cFiltroSC1 := ""
Local cQueryGrp	 := ""
Local cAuxFil    := ""
Local cFilQry    := ""
Local ca130User  := RetCodUsr()
Local nCntFor	 := 0 
Local nX         := 0
Local lFiltra	 := .F.
//Local lContinua  := A130CHKCPO()  //Verifica tamanho dos campos de prazo de entrega
Local lContinua  := A131CHKCPO()  //Verifica tamanho dos campos de prazo de entrega
Local lPrjCni := FindFunction("ValidaCNI") .And. ValidaCNI()
Local cTpCto     := IIf( lPrjCni, GETMV("MV_TPSCCT"), '')
Local aFiltra    := {}
Local aCampos	 := {"C1_OK"}
Local aCpos	     := {}
Local cCotACC	  := "(SC8->(FieldPos('C8_ACCNUM'))>0 .And. !Empty(SC8->C8_ACCNUM) .And. Empty(SC8->C8_NUMPED))"
Local _lExist     := .F.
Local aValFornec  := {}
Local _cXfilial   := ""
Local _cXnum      := ""
Local _cXfornec   := ""
Local _cXloja     := ""
Local _nXpreco    := 0
Local _nXCond     := ""
Local _cXitem     := ""
Local _cXmotivo   := ""
Local _cMotivo    := ""
Local _nCount     := 0
Local _cX3Usado   := ""
Local _lGrpCom    := .F.     

Local _cGrpUser   := ""
Local _cGrpUser2  := ""
Local _cGrpUser3  := ""

Private cFiltroSC1 := ""
Private cQuerySC1	 := ""
Private cNumCot   := ""
Private nVlrCotac := 0
Private cFornEsc  := ""
Private nMelhorPrc:= 0
Private aBestPrc    := {}
Private  aCombo   := {}
Private _cFornec    := ""
Private _cNumBox    := ""
Private aFornec   := {}
Private aHeader7  := {}
Private aHeader2  := {}
Private aColsAux  := {}
Private oDlgCotac
Private oOk 	   := LoadBitmap( GetResources(),"LBOK")
Private oNo 	   := LoadBitmap( GetResources(),"LBNO")
Private lExecuta      := .F.
Private oSlcAll       := .F.
Private oChkAll
Private oLegAmar	:= LoadBitmap(GetResources(),"BR_AMARELO")
Private oLegVerm	:= LoadBitmap(GetResources(),"BR_VERMELHO")
Private oLegVerd	:= LoadBitmap(GetResources(),"BR_VERDE")
Private oLegBran	:= LoadBitmap(GetResources(),"BR_BRANCO")
Private oLegAzul	:= LoadBitmap(GetResources(),"BR_AZUL")
Private oFolder
Private aFolder := {"Solicita็๕es", "Cota็๕es"}
Private oF1Layer	:= Nil
Private oF2Layer	:= Nil
Private oGetDad      := Nil
Private oPesqGetD    //  := Nil
Private aRotina   := MenuDef()
Private aRecMark  := {}
Private bFiltraBrw:= {|| {"","","",""}}
Private cCadastro := "Solicitacoes"
Private cMarca    := GetMark()
Private lInverte  := .F.
Private lMultCot  := GetNewPar("MV_MULTCOT",.F.) // Ativa o Uso da Cotacao MultUsuario permitindo que mais de um usuario utilize a rotina simultaneamente
Private lCotSI    := .F.
Private oMark
Private oMrkAll
Private aLegenda  := {	{"ENABLE","Cotacao em aberto"},{"DISABLE","Cotacao Baixada"},{"BR_AMARELO","Cotacao nao digitada"}, {"BR_AZUL","Cotacao em compra atraves do portal ACC"} } //"Legenda"

PRIVATE CHORAINI  := TIME()
PRIVATE CLOG      := ""

Default nFolder := -1

Public _nSavFolder := nFolder
Public aCotMark  := {}

If _nSavFolder == -1
	nFolder := 0
	Processa({|lEnd| U_GJP130Cot(nFolder)})
	SetKey( VK_F2,{||NIL} )
	SetKey( VK_F4,{||NIL} )
	U_GJP130Process(2)
	Return Nil
EndIf

DbSelectArea("SA5")
DbCloseArea()

If ExistBlock("MT130SI")
	lCotSI := ExecBlock("MT130SI",.F.,.F.,{1})//Parametro 1 indica que o ponto esta na geraรงรฃo de cotaรงรฃo
	If ValType(lCotSI) <> "L"
		lCotSI := .F.
	EndIf
EndIf

CLOG := ('[ ' + DtoC(Date()) + ' ] - [ Cotacao 01] - Antes de montar filtro da SC - [ ' + ElapTime(cHoraIni,Time()) + ' ]' )+CHR(13)+CHR(10)+CHR(13)+CHR(10)
CHORAINI  := TIME()

If lContinua
	
	//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
	//ณEspecifico para Integracao com modulo de Gestao de Contratosณ
	//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
	aAdd(aCores,{'C1_FLAGGCT=="1"' , 'LIGHTBLU'})	//SC Totalmente Atendida pelo SIGAGCT
	
	aAdd(aCores,{'!Empty(C1_RESIDUO)'													 ,'BR_PRETO'  })//SC Eliminada por Residuo
	aAdd(aCores,{'C1_QUJE==0.And.C1_COTACAO==Space(Len(C1_COTACAO)).And.C1_APROV$" ,L"'	 ,'ENABLE'	  })//SC em Aberto
	aAdd(aCores,{'C1_QUJE==0.And.C1_COTACAO==Space(Len(C1_COTACAO)).And.C1_APROV="R"' 	 ,'BR_LARANJA'})//SC Rejeitada
	aAdd(aCores,{'C1_QUJE==0.And.C1_COTACAO==Space(Len(C1_COTACAO)).And.C1_APROV="B"' 	 ,'BR_CINZA'  })//SC Bloqueada
	aAdd(aCores,{'C1_QUJE==C1_QUANT'													 ,'DISABLE'	  })//SC com Pedido Colocado
	aAdd(aCores,{'C1_QUJE>0'															 ,'BR_AMARELO'})//SC com Pedido Colocado Parcial
	aAdd(aCores,{'C1_QUJE==0.And.C1_COTACAO<>Space(Len(C1_COTACAO)).And. C1_IMPORT <>"S"','BR_AZUL'	  })//SC em Processo de Cotacao
	If !lCotSI
		aAdd(aCores,{'C1_QUJE==0.And.C1_COTACAO<>Space(Len(C1_COTACAO)).And. C1_IMPORT =="S"','BR_PINK'	  })//SC com Produto Importado
	Else
		aAdd(aCores,{'C1_QUJE==0.And.C1_COTACAO=="IMPORT"+Space(Len(C1_COTACAO)-6).And. C1_IMPORT =="S"','BR_PINK'	  })//SC com Produto Importado
		aAdd(aCores,{'C1_QUJE==0.And.C1_COTACAO<>"IMPORT"+Space(Len(C1_COTACAO)-6).And. C1_IMPORT =="S"','BR_BRANCO'	  })//SC de Import em processo de Cotacao
	EndIf
	
	//Ponto de Entrada para alterar cores do Browse do Cadastroณ
	If ExistBlock("MT130COR")
		aCoresNew := ExecBlock("MT130COR",.F.,.F.,{aCores})
		If ValType(aCoresNew) == "A"
			aCores := aCoresNew
		EndIf
	EndIf
	
	//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
	//ณCarrega as perguntas selecionadas                            ณ
	//ณ                                                             ณ
	//ณmv_par01 // Filtra por data   (S/N)                          ณ
	//ณmv_par02 // data de emissao inicial                          ณ
	//ณmv_par03 // data de emissao final                            ณ
	//ณmv_par04 // dias uteis para calcular data de validade        ณ
	//ณmv_par05 // Filtra Solicitacoes ja Geradas (S/N)             ณ
	//ณmv_par06 // Amarracao por Produto ou Grupo                   ณ
	//ณmv_par07 // Imprime Cotacao (S/N)                            ณ
	//ณmv_par08 // Tipo de Cotacao (Aberta/Fechada)                 ณ
	//ณmv_par12 // C.Custo inicial                                  ณ
	//ณmv_par13 // C.Custo final                                    ณ
	//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
	StaticCall(MATA130,AjustaSx1)
	
	( Pergunte("MTA130",.F.) )
	If _nSavFolder <> 3
		MV_PAR01 := 1
		MV_PAR02 := stod("20100101")
		MV_PAR03 := stod("20491231")
		MV_PAR04 := 99
		MV_PAR05 := 1
		MV_PAR06 := 3
		MV_PAR07 := 2
		MV_PAR08 := 1
		MV_PAR09 := ""
		MV_PAR10 := "ZZZZZZ"
		MV_PAR11 := 1
		MV_PAR12 := ""
		MV_PAR13 := "ZZZZZZZZZ"
		MV_PAR14 := 2
	EndIf
	
	//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
	//ณAvalia Ponto de Entradaณ
	//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
	If ( ExistBlock("M130FIL") )
		cAuxFil := AllTrim(ExecBlock("M130FIL",.F.,.F.))
		If ValType(cAuxFil)#"C"
			cAuxFil := ""
		EndIf
		If ( !Empty(cAuxFil) )
			cFiltroSC1 := ".And."+cAuxFil
		EndIf
	EndIf
	
	//Avalia se ha necessidade de Filtrar Grupo de Compradores	
/*	If ( SuperGetMv("MV_RESTCOM",.F.,"N")=="S")
		aGrupo := UsrGrComp(RetCodUsr())
		If ( Ascan(aGrupo,"*") == 0 )
			cGrupComp  := ".And.(C1_GRUPCOM=='"+Space(Len(SC1->C1_GRUPCOM))+"'"
			cQueryGrp  += " AND (C1_GRUPCOM='" +Space(Len(SC1->C1_GRUPCOM))+"'"
			For nCntFor := 1 To Len(aGrupo)
				If nCntFor == 1
					cGrupComp += ".Or.C1_GRUPCOM $ '"+aGrupo[nCntFor]+""
					cQueryGrp += " OR C1_GRUPCOM IN ('"+aGrupo[nCntFor]+"'"
				Else
					cGrupComp += ","+aGrupo[nCntFor]
					cQueryGrp += ",'"+aGrupo[nCntFor]+"'"
				Endif
			Next nCntFor
			If Len(aGrupo) > 0
				cGrupComp  += "'"
				cQueryGrp  += ")"
			Endif
			cGrupComp  += ")"
			cQueryGrp  += ")"
		EndIf
	EndIf
*/	
	//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
	//ณVerifica se havera necessidade de Filtragem dos Registros para a MarkBrowseณ
	//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
	lFiltra := ( MV_PAR05==1 .Or. MV_PAR01==1 .Or. !Empty(cFiltroSC1) .Or. !Empty(cGrupComp) .Or. lTrm )
	
	dbSelectArea("SC1")
	dbSetOrder(1)
	
	If ( lFiltra )
		cFiltroSC1+= ".And.C1_FILIAL=='"+xFilial("SC1")+"'"
		cQuerySC1 += " AND C1_FILIAL='"+xFilial("SC1")+"'"
		
		If SC1->(FieldPos("C1_ACCPROC")) > 0
			cFiltroSC1+= ".And.C1_ACCPROC<>'1'"
			cQuerySC1 += " AND C1_ACCPROC<>'1'"
		EndIf
		
		//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
		//ณATENCAO!!!Se for EXPRESS retira o filtro Solicitacao de /ateณ
		//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
		If !__lPyme
			cFiltroSC1+= ".And.C1_NUM >= '"+MV_PAR09+"'"
			cQuerySC1 += " AND C1_NUM >= '"+MV_PAR09+"'"
			cFiltroSC1+= ".And.C1_NUM <= '"+MV_PAR10+"'"
			cQuerySC1 += " AND C1_NUM <= '"+MV_PAR10+"'"
		EndIf
		
		If ( MV_PAR01==1 ) // Filtra por Data
			cFiltroSC1+= ".And.Dtos(C1_EMISSAO)>='"+Dtos(MV_PAR02)+"'"
			cQuerySC1 += " AND C1_EMISSAO >= '"+Dtos(MV_PAR02)+"'"
			cFiltroSC1+= ".And.Dtos(C1_EMISSAO)<='"+Dtos(MV_PAR03)+"'"
			cQuerySC1 += " AND C1_EMISSAO <= '"+Dtos(MV_PAR03)+"'"
		EndIf
		If ( MV_PAR05==1 )
			If lCotSI
				cFiltroSC1+= ".And.C1_COTACAO=='IMPORT"+Space(Len(SC1->C1_COTACAO)-6)+"'.And.C1_QUJE<C1_QUANT.And.C1_TPOP<>'P'.And.C1_APROV$' ,L'"
				cQuerySC1 += " AND C1_COTACAO= 'IMPORT"+Space(Len(SC1->C1_COTACAO)-6)+"' AND C1_QUJE<C1_QUANT AND C1_TPOP<>'P' AND C1_APROV IN(' ','L') "
			Else
				cFiltroSC1+= ".And.C1_COTACAO=='"+Space(Len(SC1->C1_COTACAO))+"'.And.C1_QUJE<C1_QUANT.And.C1_TPOP<>'P'.And.C1_APROV$' ,L'"
				cQuerySC1 += " AND C1_COTACAO= '"+Space(Len(SC1->C1_COTACAO))+"' AND C1_QUJE<C1_QUANT AND C1_TPOP<>'P' AND C1_APROV IN(' ','L') "
			EndIf
		EndIf
		If !Empty(MV_PAR12)
			cFiltroSC1+= ".And.C1_CC>='"+MV_PAR12+"'"
			cQuerySC1 += " AND C1_CC >= '"+MV_PAR12+"'"
		EndIf
		If !Empty(MV_PAR13)
			cFiltroSC1+= ".And. C1_CC<='"+MV_PAR13+"'"
			cQuerySC1 += " AND  C1_CC<='"+MV_PAR13+"'"
		EndIf
//		cFiltroSC1 += cGrupComp
//		cQuerySC1  += cQueryGrp
		
		/*If lTrm
		cFiltroSC1 += ".And. C1_ORIGEM == 'TRM     ' "
		cQuerySC1  += " AND C1_ORIGEM='TRM     ' "
		EndIf
		*/
		If lPrjCni
			cFiltroSC1 += ".And. C1_XTIPOSC <> '"+cTpCto+"' " // TIPO DE SC ADITIVO CONTRATO
			cQuerySC1  += " AND C1_XTIPOSC <> '"+cTpCto+"' " // TIPO DE SC ADITIVO CONTRATO
			If ExistBlock("MT130IFC")
				aFiltra := ExecBlock("MT130IFC",.F.,.F.)
				cFiltroSC1 += aFiltra[1]
				cQuerySC1  += aFiltra[2]
			EndIf
		EndIf
		
		//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
		//ณRetira o Primeiro .And. ณ
		//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
		cFiltroSc1:=SubStr(cFiltroSC1,6)
		cQuerySc1 :=SubStr(cQuerySC1,6)
	Else
		dbSelectArea("SC1")
		MsSeek(xFilial("SC1"))
		
		If lPrjCni
			cFiltroSC1 = "C1_XTIPOSC <> '"+cTpCto+"' " // TIPO DE SC ADITIVO CONTRATO
			cQuerySC1  = "C1_XTIPOSC <> '"+cTpCto+"' " // TIPO DE SC ADITIVO CONTRATO
			If ExistBlock("MT130IFR")
				aFiltra := ExecBlock("MT130IFR",.F.,.F.)
				cFiltroSC1 += aFiltra[1]
				cQuerySC1  += aFiltra[2]
			EndIf
		EndIf
		
	EndIf
	
	
	//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
	//ณFiltra SC's do tipo Licitacaoณ
	//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
	If SC1->(FieldPos("C1_TPSC")) > 0
		cFiltroSC1 += IIf(Empty(cFiltroSC1),"C1_TPSC <> '2'",".And. C1_TPSC <> '2'")
		cQuerySC1 += IIf(Empty(cQuerySC1),"C1_TPSC <> '2'"," AND  C1_TPSC <> '2'")
	EndIf
	
	
	//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
	//ณRealiza a Filtragem de todas as SC's empenhadas pelo Modulo do SIGAGCTณ
	//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
	cFiltroSC1 += IIF(Empty(cFiltroSC1),"C1_FLAGGCT<>'1'",".And.C1_FLAGGCT<>'1'")
	cQuerySC1  += IIF(Empty(cFiltroSC1),"C1_FLAGGCT<>'1'"," AND C1_FLAGGCT<>'1'")
	bFiltraBrw := {|x| IIf(x==Nil,FilBrowse("SC1",@aIndexSC1,@cFiltroSC1),{cFiltroSC1,cQuerySC1,cAuxFil,aIndexSC1}) }
	Eval(bFiltraBrw)
	dbGotop()
	
EndIf
RestArea(aArea)

CLOG += ('[ ' + DtoC(Date()) + ' ] - [ Cotacao 02] - Depois do filtro SC - [ ' + ElapTime(cHoraIni,Time()) + ' ]' )+CHR(13)+CHR(10)+CHR(13)+CHR(10)
CHORAINI  := TIME()

AjustaSx1()
If _nSavFolder == 0  
	Pergunte("COT130",.F.)
    
	dbSelectArea("SX1")
	SX1->(dbSetOrder(1))
	If MsSeek("COT130")
		While SX1->(!EOF()) .and. alltrim(upper(SX1->X1_GRUPO)) == "COT130" 
		If alltrim(UPPER(SX1->X1_VAR01)) == "MV_PAR06"
			RecLock("SX1",.F.)
			SX1->X1_CNT01 := __cUserId
			SX1->(msunlock())
        EndIf
        SX1->(dbskip()) 
        EndDo
	Endif
    
	( Pergunte("MTA130",.F.) )

	If !(Pergunte("COT130",.T.) )
	   Return .T.
	EndIf
Else
	(Pergunte("COT130",.F.) )
EndIf

if !empty(MV_PAR06)
	dbselectarea("SAJ")
	dbsetorder(2)
	If dbseek(xFilial("SAJ")+MV_PAR06)
		
		While SAJ->(!EOF()) .and. xFilial("SAJ")+MV_PAR06 == SAJ->AJ_FILIAL+SAJ->AJ_USER
		    _cGrpUser2 += SAJ->AJ_GRCOM+"|"
			SAJ->(dbskip())
		EndDo
		
	EndIf
Endif

DbSelectArea("SC8")
DbGoTop()
DbSetOrder(1)
If DbSeek(xFilial("SC8")/*+SC5->C5_NUM*/)
	While !Eof() .And. AllTrim(SC8->C8_FILIAL) == xFilial("SC8")
		
		(Pergunte("COT130",.F.) )
		If !(SC8->C8_NUM >= MV_PAR01 .and. SC8->C8_NUM <= MV_PAR02)
			SC8->(DbSkip())
			loop
		EndIf

		If !(SC8->C8_NUMSC >= MV_PAR04 .and. SC8->C8_NUMSC <= MV_PAR05)
			SC8->(DbSkip())
			loop
		EndIf
		// inserir regra do c8_grupcom
		If !empty(MV_PAR06)
		If !(SC8->C8_GRUPCOM $ _cGrpUser2)
			SC8->(DbSkip())
			loop
		EndIf
		If Empty(_cGrpUser2)
			SC8->(DbSkip())
			loop
		EndIf
		EndIf
		If MV_PAR03 == 2
			If !EMPTY(SC8->C8_NUMPED)
				SC8->(DbSkip())
				loop
			EndIf
		EndIf
		
		For i:=1 to len(aFornec)
			If aFornec[i][1] == SC8->C8_FORNECE .and. aFornec[i][2] == SC8->C8_LOJA
				_lExist := .T.
			EndIf
		Next i
		
		If !_lExist
			Aadd(aFornec,{SC8->C8_FORNECE,SC8->C8_LOJA})
		EndIf
		
		_lExist := .F.
		
		DbSelectArea("SC8")
		SC8->(DbSkip())
	Enddo
EndIf

CLOG += ('[ ' + DtoC(Date()) + ' ] - [ Cotacao 03] - Filtro cotacao por grupo de usuแrio e todos os fornecedores envolvidos - [ ' + ElapTime(cHoraIni,Time()) + ' ]' )+CHR(13)+CHR(10)+CHR(13)+CHR(10)
CHORAINI  := TIME()

DbSelectArea("SC8")
DbGoTop()
DbSetOrder(1)
If DbSeek(xFilial("SC8")/*+SC5->C5_NUM*/)
	_cXfilial := SC8->C8_FILIAL
	_cXnum    := SC8->C8_NUM
	_cXfornec := SC8->C8_FORNECE
	_cXloja   := SC8->C8_LOJA
	_cXitem   := SC8->C8_ITEM
	_nXpreco  := 0
	_nXcond   := ""
	
	While !Eof() .And. AllTrim(SC8->C8_FILIAL) == xFilial("SC8")
		
		(Pergunte("COT130",.F.) )
		If !(SC8->C8_NUM >= MV_PAR01 .and. SC8->C8_NUM <= MV_PAR02)
			SC8->(DbSkip())
			loop
		EndIf
		
		If !(SC8->C8_NUMSC >= MV_PAR04 .and. SC8->C8_NUMSC <= MV_PAR05)
			SC8->(DbSkip())
			loop
		EndIf

        //inserir regra c8_grupcom 
		If !empty(MV_PAR06)        
		If !(SC8->C8_GRUPCOM $ _cGrpUser2)
			SC8->(DbSkip())
			loop
		EndIf 
		If Empty(_cGrpUser2)
			SC8->(DbSkip())
			loop
		EndIf

		EndIf
        
   		If MV_PAR03 == 2
			If !EMPTY(SC8->C8_NUMPED)
				SC8->(DbSkip())
				loop
			EndIf
		EndIf
		
		If _cXfilial == SC8->C8_FILIAL .and. _cXnum == SC8->C8_NUM .and. _cXfornec == SC8->C8_FORNECE .and. _cXloja == SC8->C8_LOJA .and. _cXitem == SC8->C8_ITEM
			_nXpreco := SC8->C8_PRECO
			_nXcond  := SC8->C8_COND
		Else
			Aadd(aValFornec,{_cXfilial,_cXnum,_cXfornec,_cXloja,_nXpreco,_nXcond,_cXitem})
			_cXfilial := SC8->C8_FILIAL
			_cXnum    := SC8->C8_NUM
			_cXfornec := SC8->C8_FORNECE
			_cXloja   := SC8->C8_LOJA
			_cXitem   := SC8->C8_ITEM
			_nXpreco  := SC8->C8_PRECO
			_nXcond   := SC8->C8_COND
			loop
		EndIf
		
		DbSelectArea("SC8")
		SC8->(DbSkip())
	Enddo
	Aadd(aValFornec,{_cXfilial,_cXnum,_cXfornec,_cXloja,_nXpreco,_nXcond,_cXitem})
EndIf

CLOG += ('[ ' + DtoC(Date()) + ' ] - [ Cotacao 04] - Filtro Cotacao por usuario e armazena dados dos fornecedores - [ ' + ElapTime(cHoraIni,Time()) + ' ]' )+CHR(13)+CHR(10)+CHR(13)+CHR(10)
CHORAINI  := TIME()

//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
//ณ Monta o aHeader da GetDados ณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
aHeader2 := {}

DbSelectArea("SX3")
DbSetOrder(2)
If DbSeek("C6_UM")
	
	Aadd(aHeader2,{	"",;
	"MARCA",;
	"@BMP",;
	2,;
	0,;
	"",;
	SX3->X3_USADO,;
	"C",;
	"",;
	SX3->X3_CONTEXT,;
	"",;
	"",;
	"",;
	"A",;
	"",;
	"",;
	""})
	
	Aadd(aHeader2,{	" ",;
	"LEGENDA",;
	"@BMP",;
	1,;
	0,;
	"",;
	SX3->X3_USADO,;
	"C",;
	"",;
	SX3->X3_CONTEXT,;
	"",;
	"",;
	"",;
	"V",;
	"",;
	"",;
	""})
EndIf

DbSelectArea("SX3")
DbSetOrder(2)
If DbSeek("C8_FILIAL")
	Aadd(aHeader2,{	AllTrim("Filial"),;
	"FILIAL",;
	SX3->X3_PICTURE,;
	SX3->X3_TAMANHO,;
	SX3->X3_DECIMAL,;
	SX3->X3_VALID,;
	SX3->X3_USADO,;
	SX3->X3_TIPO,;
	SX3->X3_F3,;
	SX3->X3_CONTEXT,;
	SX3->X3_CBOX,;
	SX3->X3_RELACAO,;
	SX3->X3_WHEN,;
	"V",;
	SX3->X3_VLDUSER,;
	SX3->X3_PICTVAR,;
	SX3->X3_OBRIGAT})
EndIf

DbSelectArea("SX3")
DbSetOrder(2)
If DbSeek("C8_NUM")
	Aadd(aHeader2,{	AllTrim("Cota็ใo"),;
	"COTACAO",;
	SX3->X3_PICTURE,;
	SX3->X3_TAMANHO,;
	SX3->X3_DECIMAL,;
	SX3->X3_VALID,;
	SX3->X3_USADO,;
	SX3->X3_TIPO,;
	SX3->X3_F3,;
	SX3->X3_CONTEXT,;
	SX3->X3_CBOX,;
	SX3->X3_RELACAO,;
	SX3->X3_WHEN,;
	"V",;
	SX3->X3_VLDUSER,;
	SX3->X3_PICTVAR,;
	SX3->X3_OBRIGAT})
EndIf

DbSelectArea("SX3")
DbSetOrder(2)
If DbSeek("C8_ITEM")
	Aadd(aHeader2,{	AllTrim("Item"),;
	"ITEM",;
	SX3->X3_PICTURE,;
	SX3->X3_TAMANHO,;
	SX3->X3_DECIMAL,;
	SX3->X3_VALID,;
	SX3->X3_USADO,;
	SX3->X3_TIPO,;
	SX3->X3_F3,;
	SX3->X3_CONTEXT,;
	SX3->X3_CBOX,;
	SX3->X3_RELACAO,;
	SX3->X3_WHEN,;
	"V",;
	SX3->X3_VLDUSER,;
	SX3->X3_PICTVAR,;
	SX3->X3_OBRIGAT})
EndIf

DbSelectArea("SX3")
DbSetOrder(2)
If DbSeek("C8_PRODUTO")
	Aadd(aHeader2,{	AllTrim("Produto"),;
	"PRODUTO",;
	SX3->X3_PICTURE,;
	SX3->X3_TAMANHO,;
	SX3->X3_DECIMAL,;
	SX3->X3_VALID,;
	SX3->X3_USADO,;
	SX3->X3_TIPO,;
	SX3->X3_F3,;
	SX3->X3_CONTEXT,;
	SX3->X3_CBOX,;
	SX3->X3_RELACAO,;
	SX3->X3_WHEN,;
	"V",;
	SX3->X3_VLDUSER,;
	SX3->X3_PICTVAR,;
	SX3->X3_OBRIGAT})
EndIf

DbSelectArea("SX3")
DbSetOrder(2)
If DbSeek("B1_DESC")
	Aadd(aHeader2,{	AllTrim("Descri็ใo"),;
	"DESCRICAO",;
	SX3->X3_PICTURE,;
	30,;
	SX3->X3_DECIMAL,;
	SX3->X3_VALID,;
	SX3->X3_USADO,;
	SX3->X3_TIPO,;
	SX3->X3_F3,;
	SX3->X3_CONTEXT,;
	SX3->X3_CBOX,;
	SX3->X3_RELACAO,;
	SX3->X3_WHEN,;
	"V",;
	SX3->X3_VLDUSER,;
	SX3->X3_PICTVAR,;
	SX3->X3_OBRIGAT})
EndIf

DbSelectArea("SX3")
DbSetOrder(2)
If DbSeek("C8_UM")
	Aadd(aHeader2,{	AllTrim("Unid.Medida"),;
	"UNIDADE",;
	SX3->X3_PICTURE,;
	SX3->X3_TAMANHO,;
	SX3->X3_DECIMAL,;
	SX3->X3_VALID,;
	SX3->X3_USADO,;
	SX3->X3_TIPO,;
	SX3->X3_F3,;
	SX3->X3_CONTEXT,;
	SX3->X3_CBOX,;
	SX3->X3_RELACAO,;
	SX3->X3_WHEN,;
	"V",;
	SX3->X3_VLDUSER,;
	SX3->X3_PICTVAR,;
	SX3->X3_OBRIGAT})
EndIf

DbSelectArea("SX3")
DbSetOrder(2)
If DbSeek("C8_NUMSC")
	Aadd(aHeader2,{	AllTrim("N๚mero SC"),;
	SX3->X3_CAMPO,;
	SX3->X3_PICTURE,;
	SX3->X3_TAMANHO,;
	SX3->X3_DECIMAL,;
	SX3->X3_VALID,;
	SX3->X3_USADO,;
	SX3->X3_TIPO,;
	SX3->X3_F3,;
	SX3->X3_CONTEXT,;
	SX3->X3_CBOX,;
	SX3->X3_RELACAO,;
	SX3->X3_WHEN,;
	"V",;
	SX3->X3_VLDUSER,;
	SX3->X3_PICTVAR,;
	SX3->X3_OBRIGAT})
EndIf

DbSelectArea("SX3")
DbSetOrder(2)
If DbSeek("C8_QUANT")
	Aadd(aHeader2,{	AllTrim("Quantidade"),;
	"QUANTIDADE",;
	SX3->X3_PICTURE,;
	SX3->X3_TAMANHO,;
	SX3->X3_DECIMAL,;
	SX3->X3_VALID,;
	SX3->X3_USADO,;
	SX3->X3_TIPO,;
	SX3->X3_F3,;
	SX3->X3_CONTEXT,;
	SX3->X3_CBOX,;
	SX3->X3_RELACAO,;
	SX3->X3_WHEN,;
	SX3->X3_VISUAL,;
	SX3->X3_VLDUSER,;
	SX3->X3_PICTVAR,;
	SX3->X3_OBRIGAT})
EndIf

For i:=1 to len(aFornec)
	DbSelectArea("SX3")
	DbSetOrder(2)
	If DbSeek("C8_PRECO")
		Aadd(aHeader2,{(aFornec[i][1])+" - "+(aFornec[i][2])+chr(13)+chr(10)+AllTrim(Posicione("SA2",1,xFilial("SA2")+aFornec[i][1]+aFornec[i][2],"A2_NREDUZ")),;
		SX3->X3_CAMPO,;
		SX3->X3_PICTURE,;
		SX3->X3_TAMANHO,;
		SX3->X3_DECIMAL,;
		"Positivo() .and. U_SC8Refresh()",;
		SX3->X3_USADO,;
		SX3->X3_TIPO,;
		SX3->X3_F3,;
		SX3->X3_CONTEXT,;
		SX3->X3_CBOX,;
		SX3->X3_RELACAO,;
		SX3->X3_WHEN,;
		SX3->X3_VISUAL,;
		SX3->X3_VLDUSER,;
		SX3->X3_PICTVAR,;
		SX3->X3_OBRIGAT})
	EndIf
	/*
	DbSelectArea("SX3")
	DbSetOrder(2)
	If DbSeek("C8_COND")
		Aadd(aHeader2,{	"Cond.Pagto"+chr(13)+chr(10)+AllTrim(Posicione("SA2",1,xFilial("SA2")+aFornec[i][1]+aFornec[i][2],"A2_NREDUZ")),;
		SX3->X3_CAMPO,;
		SX3->X3_PICTURE,;
		SX3->X3_TAMANHO,;
		SX3->X3_DECIMAL,;
		"U_SC8Refresh()",;
		SX3->X3_USADO,;
		SX3->X3_TIPO,;
		SX3->X3_F3,;
		SX3->X3_CONTEXT,;
		SX3->X3_CBOX,;
		SX3->X3_RELACAO,;
		SX3->X3_WHEN,;
		SX3->X3_VISUAL,;
		SX3->X3_VLDUSER,;
		SX3->X3_PICTVAR,;
		SX3->X3_OBRIGAT})
	EndIf
	       */
Next i

DbSelectArea("SX3")
DbSetOrder(2)
If DbSeek("C8_PRECO")
	Aadd(aHeader2,{	AllTrim("Melhor Pre็o"),;
	SX3->X3_CAMPO,;
	SX3->X3_PICTURE,;
	SX3->X3_TAMANHO,;
	SX3->X3_DECIMAL,;
	SX3->X3_VALID,;
	SX3->X3_USADO,;
	SX3->X3_TIPO,;
	SX3->X3_F3,;
	SX3->X3_CONTEXT,;
	SX3->X3_CBOX,;
	SX3->X3_RELACAO,;
	SX3->X3_WHEN,;
	"V",;
	SX3->X3_VLDUSER,;
	SX3->X3_PICTVAR,;
	SX3->X3_OBRIGAT})
EndIf

DbSelectArea("SX3")
DbSetOrder(2)
If DbSeek("C8_PRECO")
	Aadd(aHeader2,{	AllTrim("Pre็o Total"),;
	SX3->X3_CAMPO,;
	SX3->X3_PICTURE,;
	SX3->X3_TAMANHO,;
	SX3->X3_DECIMAL,;
	SX3->X3_VALID,;
	SX3->X3_USADO,;
	SX3->X3_TIPO,;
	SX3->X3_F3,;
	SX3->X3_CONTEXT,;
	SX3->X3_CBOX,;
	SX3->X3_RELACAO,;
	SX3->X3_WHEN,;
	"V",;
	SX3->X3_VLDUSER,;
	SX3->X3_PICTVAR,;
	SX3->X3_OBRIGAT})
EndIf

DbSelectArea("SX3")
DbSetOrder(2)
If DbSeek("A2_NOME")
	Aadd(aHeader2,{	AllTrim("Fornecedor Sugerido" ),;
	"A2_NOME",;
	SX3->X3_PICTURE,;
	30,;
	SX3->X3_DECIMAL,;
	SX3->X3_VALID,;
	SX3->X3_USADO,;
	SX3->X3_TIPO,;
	SX3->X3_F3,;
	SX3->X3_CONTEXT,;
	SX3->X3_CBOX,;
	SX3->X3_RELACAO,;
	SX3->X3_WHEN,;
	"V",;
	SX3->X3_VLDUSER,;
	SX3->X3_PICTVAR,;
	SX3->X3_OBRIGAT})
EndIf

DbSelectArea("SX3")
DbSetOrder(2)
If DbSeek("C8_PRAZO")
	Aadd(aHeader2,{	AllTrim("Prazo"),;
	"C8_PRAZO",;
	SX3->X3_PICTURE,;
	SX3->X3_TAMANHO,;
	SX3->X3_DECIMAL,;
	"U_SC8Refresh()",;
	SX3->X3_USADO,;
	SX3->X3_TIPO,;
	SX3->X3_F3,;
	SX3->X3_CONTEXT,;
	SX3->X3_CBOX,;
	SX3->X3_RELACAO,;
	SX3->X3_WHEN,;
	"A",;
	SX3->X3_VLDUSER,;
	SX3->X3_PICTVAR,;
	SX3->X3_OBRIGAT})
EndIf


DbSelectArea("SX3")
DbSetOrder(2)
If DbSeek("C8_XVENCED")
	Aadd(aHeader2,{	AllTrim("Escolher Vencedor"+chr(13)+chr(10)+"Tecla F4"),;
	SX3->X3_CAMPO,;
	SX3->X3_PICTURE,;
	SX3->X3_TAMANHO,;
	SX3->X3_DECIMAL,;
	"U_SC8Refresh()",;
	SX3->X3_USADO,;
	SX3->X3_TIPO,;
	SX3->X3_F3,;
	SX3->X3_CONTEXT,;
	SX3->X3_CBOX,;
	SX3->X3_RELACAO,;
	SX3->X3_WHEN,;
	SX3->X3_VISUAL,;
	SX3->X3_VLDUSER,;
	SX3->X3_PICTVAR,;
	SX3->X3_OBRIGAT})
EndIf

DbSelectArea("SX3")
DbSetOrder(2)
If DbSeek("C8_XPEDCON")
	Aadd(aHeader2,{	AllTrim("Gerar PC/Contrato"),;
	SX3->X3_CAMPO,;
	SX3->X3_PICTURE,;
	SX3->X3_TAMANHO,;
	SX3->X3_DECIMAL,;
	"U_SC8Refresh()",;
	SX3->X3_USADO,;
	SX3->X3_TIPO,;
	SX3->X3_F3,;
	SX3->X3_CONTEXT,;
	SX3->X3_CBOX,;
	SX3->X3_RELACAO,;
	SX3->X3_WHEN,;
	SX3->X3_VISUAL,;
	SX3->X3_VLDUSER,;
	SX3->X3_PICTVAR,;
	SX3->X3_OBRIGAT})
EndIf

For i:=1 to len(aFornec)
	_cNumBox := alltrim(SOMA1(alltrim(str(i-1))))
	_cFornec += _cNumBox+"="+AllTrim(Posicione("SA2",1,xFilial("SA2")+aFornec[i][1]+aFornec[i][2],"A2_NREDUZ"))
	aAdd(aCombo,{_cNumBox,aFornec[i][1],aFornec[i][2], AllTrim(Posicione("SA2",1,xFilial("SA2")+aFornec[i][1]+aFornec[i][2],"A2_NREDUZ")) })
	If i <> len(aFornec)
		_cFornec += ";"
	EndIf
Next i

DbSelectArea("SX3")
DbSetOrder(2)
If DbSeek("C8_MOTIVO")
	Aadd(aHeader2,{	AllTrim("Auditoria"),;
	SX3->X3_CAMPO,;
	"",;
	45,;
	SX3->X3_DECIMAL,;
	SX3->X3_VALID,;
	SX3->X3_USADO,;
	SX3->X3_TIPO,;
	SX3->X3_F3,;
	SX3->X3_CONTEXT,;
	SX3->X3_CBOX,;
	SX3->X3_RELACAO,;
	SX3->X3_WHEN,;
	SX3->X3_VISUAL,;
	SX3->X3_VLDUSER,;
	SX3->X3_PICTVAR,;
	SX3->X3_OBRIGAT})
EndIf

DbSelectArea("SX3")
DbSetOrder(2)
If DbSeek("B1_DESC")
	Aadd(aHeader2,{	AllTrim("Observa็ใo"),;
	"B1_DESC",;
	SX3->X3_PICTURE,;
	150,;
	SX3->X3_DECIMAL,;
	"U_SC8Refresh()",;
	SX3->X3_USADO,;
	SX3->X3_TIPO,;
	SX3->X3_F3,;
	SX3->X3_CONTEXT,;
	SX3->X3_CBOX,;
	SX3->X3_RELACAO,;
	SX3->X3_WHEN,;
	SX3->X3_VISUAL,;
	SX3->X3_VLDUSER,;
	SX3->X3_PICTVAR,;
	SX3->X3_OBRIGAT})
EndIf

DbSelectArea("SX3")
DbSetOrder(2)
If DbSeek("C8_XJUST")
	Aadd(aHeader2,{	AllTrim("Justificativa"),;
	SX3->X3_CAMPO,;
	SX3->X3_PICTURE,;
	SX3->X3_TAMANHO,;
	SX3->X3_DECIMAL,;
	"U_SC8Refresh()",;
	SX3->X3_USADO,;
	SX3->X3_TIPO,;
	SX3->X3_F3,;
	SX3->X3_CONTEXT,;
	SX3->X3_CBOX,;
	SX3->X3_RELACAO,;
	SX3->X3_WHEN,;
	SX3->X3_VISUAL,;
	SX3->X3_VLDUSER,;
	SX3->X3_PICTVAR,;
	SX3->X3_OBRIGAT})
EndIf

CLOG += ('[ ' + DtoC(Date()) + ' ] - [ Cotacao 05] - Monta o aHeader baseado em todos fornecedores filtrados- [ ' + ElapTime(cHoraIni,Time()) + ' ]' )+CHR(13)+CHR(10)+CHR(13)+CHR(10)
CHORAINI  := TIME()

//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
//ณ Monta o aCols da GetDados ณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
//-- Adiciona cores do usuario
If ExistBlock("MT150LEG")
	aCorUsr := ExecBlock("MT150LEG",.F.,.F., { 1 })
	If ValType(aCorUsr) <> "A"
		aCorUsr := {}
	EndIf
	For nCnt := 1 To Len(aCorUsr)
		Aadd( aCores2 , { aCorUsr[nCnt,1],aCorUsr[nCnt,2] } )
	Next nCnt
EndIf

Aadd( aCores2 , { cCotACC,'BR_AZUL'})  													//Cotacao em compra atraves do portal ACC
Aadd( aCores2 , { "!" +cCotACC +".And.Empty(C8_NUMPED).And.C8_PRECO<>0",'ENABLE' } )    //Cotacao em aberto
Aadd( aCores2 , { "!Empty(C8_NUMPED)",'DISABLE'} )				    				 	//Cotacao Baixada
Aadd( aCores2 , { '!' +cCotACC +'.And.C8_PRECO==0.And.Empty(C8_NUMPED)','BR_AMARELO'})  //Cotacao nao digitada

DbSelectArea("SC8")
DbGoTop()
SC8->(dbOrderNickName("COTACNEW"))
If DbSeek(xFilial("SC8")/*+SC5->C5_NUM*/)
	While !Eof() .And. AllTrim(SC8->C8_FILIAL) == xFilial("SC8")
		
		(Pergunte("COT130",.F.) )
		If !(SC8->C8_NUM >= MV_PAR01 .and. SC8->C8_NUM <= MV_PAR02)
			SC8->(DbSkip())
			loop
		EndIf

		If !(SC8->C8_NUMSC >= MV_PAR04 .and. SC8->C8_NUMSC <= MV_PAR05)
			SC8->(DbSkip())
			loop
		EndIf

		// inserir regra do c8_grupcom
		If !empty(MV_PAR06)		 
		If !(SC8->C8_GRUPCOM $ _cGrpUser2)
			SC8->(DbSkip())
			loop
		EndIf
		If Empty(_cGrpUser2)
			SC8->(DbSkip())
			loop
		EndIf

		EndIf
		
		If MV_PAR03 == 2
			If !EMPTY(SC8->C8_NUMPED)
				SC8->(DbSkip())
				loop
			EndIf
		EndIf
		
		Aadd(aColsAux,Array(Len(aHeader2)+1))
		For i := 1 To Len(aHeader2)
			If i==1
				aColsAux[Len(aColsAux)][1] := oNo
			Elseif i==2
				If (SC8->(FieldPos('C8_ACCNUM'))>0 .And. !Empty(SC8->C8_ACCNUM) .And. Empty(SC8->C8_NUMPED))
					aColsAux[Len(aColsAux)][2] := oLegAzul
				ElseIf !(SC8->(FieldPos('C8_ACCNUM'))>0 .And. !Empty(SC8->C8_ACCNUM) .And. Empty(SC8->C8_NUMPED)) .And. Empty(SC8->C8_NUMPED) .And. SC8->C8_PRECO<>0
					aColsAux[Len(aColsAux)][2] := oLegVerd
				ElseIf !Empty(SC8->C8_NUMPED)
					aColsAux[Len(aColsAux)][2] := oLegVerm
				ElseIf !(SC8->(FieldPos('C8_ACCNUM'))>0 .And. !Empty(SC8->C8_ACCNUM) .And. Empty(SC8->C8_NUMPED)) .And. SC8->C8_PRECO==0 .And. Empty(SC8->C8_NUMPED)
					aColsAux[Len(aColsAux)][2] := oLegAmar
				EndIf
			Elseif i==3
				aColsAux[Len(aColsAux)][3] := SC8->C8_FILIAL
			Elseif i==4
				aColsAux[Len(aColsAux)][4] := SC8->C8_NUM
			Elseif i==5
				aColsAux[Len(aColsAux)][5] := SC8->C8_ITEM
			Elseif i==6
				aColsAux[Len(aColsAux)][6] := SC8->C8_PRODUTO
			Elseif i==7
				aColsAux[Len(aColsAux)][7] := substr(AllTrim(Posicione("SB1",1,xFilial("SB1")+SC8->C8_PRODUTO,"B1_DESC")),1,30)
			Elseif i==8
				aColsAux[Len(aColsAux)][8] := SC8->C8_UM
			Elseif i==9
				aColsAux[Len(aColsAux)][9] := SC8->C8_NUMSC
			Elseif i==10
				aColsAux[Len(aColsAux)][10] := SC8->C8_QUANT
			Else
				aColsAux[Len(aColsAux)][i] := Criavar(aHeader2[i][2],.F.)
			EndIf
		Next i
		
		aColsAux[Len(aColsAux)][Len(aHeader2)+1] := .F.
		
		For i:=11 To Len(aHeader2)
			For j:=1 to len(aValFornec)
				If aColsAux[Len(aColsAux)][3] == aValFornec[j][1] .and. aColsAux[Len(aColsAux)][4] == aValFornec[j][2] .and. ;
					substr(aHeader2[i][1],1,TamSX3("C8_FORNECE")[1]) == aValFornec[j][3] .and.  substr(aHeader2[i][1],(TamSX3("C8_FORNECE")[1])+4,TamSX3("C8_LOJA")[1]) == aValFornec[j][4] .and.  aColsAux[Len(aColsAux)][5] == aValFornec[j][7]
					
					aColsAux[Len(aColsAux)][i]  := aValFornec[j][5]
//					i++
//					aColsAux[Len(aColsAux)][i] := aValFornec[j][6]
					j:=len(aValFornec)
					
				EndIf
			Next j
		Next i
		
		For i:=11 To Len(aHeader2)
			If alltrim(aHeader2[i][2]) == "C8_PRECO" .and. alltrim(aHeader2[i][1]) <> AllTrim("Melhor Pre็o") .and. alltrim(aHeader2[i][1]) <> AllTrim("Pre็o Total")
				If aColsAux[Len(aColsAux)][i] > 0
					aAdd(aBestPrc,{aColsAux[Len(aColsAux)][i],substr(aHeader2[i][1],1,TamSX3("C8_FORNECE")[1]), substr(aHeader2[i][1],(TamSX3("C8_FORNECE")[1])+4,TamSX3("C8_LOJA")[1]) })
				EndIf
			EndIf
		Next i
		
		If empty(aBestPrc)
			aAdd(aBestPrc,{0,"",""})
		Else
			aSort( aBestPrc,,,{|x,y| x[1] < y[1] })
		EndIf
		
		For i:=11 To Len(aHeader2)
			If alltrim(aHeader2[i][1]) == AllTrim("Melhor Pre็o")
				aColsAux[Len(aColsAux)][i]  := aBestPrc[1][1]
			ElseIf alltrim(aHeader2[i][1]) == AllTrim("Pre็o Total")
				aColsAux[Len(aColsAux)][i]  := aBestPrc[1][1] * aColsAux[Len(aColsAux)][10]
			ElseIf alltrim(aHeader2[i][2]) == AllTrim("A2_NOME")
//				aColsAux[Len(aColsAux)][i]  := iif (!empty(aBestPrc[1][2]),substr(AllTrim(Posicione("SA2",1,xFilial("SA2")+aBestPrc[1][2]+aBestPrc[1][3],"A2_NOME")),1,30),"")
				aColsAux[Len(aColsAux)][i]  := iif((aBestPrc[1][1] * aColsAux[Len(aColsAux)][10]) > 0, iif (!empty(aBestPrc[1][2]),substr(AllTrim(Posicione("SA2",1,xFilial("SA2")+aBestPrc[1][2]+aBestPrc[1][3],"A2_NOME")),1,30),""),"")
			ElseIf alltrim(aHeader2[i][2]) == AllTrim("C8_PRAZO")
				aColsAux[Len(aColsAux)][i]  :=  SC8->C8_PRAZO
			ElseIf alltrim(aHeader2[i][2]) == AllTrim("B1_DESC")
				If !Empty(SC8->C8_OBS)
					aColsAux[Len(aColsAux)][i]  := SC8->C8_OBS
				Else
					dbselectarea("SC1")
					dbsetorder(1)
					If dbseek(xFilial("SC1")+SC8->C8_NUMSC+SC8->C8_ITEMSC)
						aColsAux[Len(aColsAux)][i]  := SC1->C1_OBS
					EndIf
				EndIf
			ElseIf alltrim(aHeader2[i][1]) == Alltrim("Auditoria")
				If aColsAux[Len(aColsAux)][2] == oLegVerm
					If select("QRYAUD") > 0
						QRYAUD->(dbclosearea())
					EndIf
					cQuery := " Select SC8.* from "+RetSqlName("SC8")+" SC8 "
					cQuery += " Where SC8.D_E_L_E_T_ <> '*' AND SC8.C8_FILIAL = '"+SC8->C8_FILIAL+"' AND SC8.C8_NUM = '"+SC8->C8_NUM+"' "
					cQuery += " AND SC8.C8_ITEM = '"+SC8->C8_ITEM+"' AND SC8.C8_PRODUTO = '"+SC8->C8_PRODUTO+"'"
					cQuery += " ORDER BY SC8.C8_FILIAL, SC8.C8_NUM, SC8.C8_ITEM, SC8.C8_PRODUTO
					cQuery := ChangeQuery(cQuery)
					dbUseArea(.T., "TOPCONN", TCGenQry(,,cQuery), "QRYAUD", .F., .T.)
					
					QRYAUD->(dbgotop())
					While QRYAUD->(!EOF())
						
						If !Empty(QRYAUD->C8_NUMPED) .and.  QRYAUD->C8_NUMPED <> "XXXXXX"
							dbselectarea("SC7")
							dbsetorder(1)
							If dbseek(xFilial("SC7")+QRYAUD->C8_NUMPED+QRYAUD->C8_ITEMPED)
								If alltrim(aBestPrc[1][2]) == alltrim(SC7->C7_FORNECE) .and. alltrim(aBestPrc[1][3]) == alltrim(SC7->C7_LOJA)
									aColsAux[Len(aColsAux)][i] := "Escolhido Fornecedor Sugerido c/ Melhor Pre็o"
								Else
									aColsAux[Len(aColsAux)][i] := "Escolha de Fornecedor Manual - "+AllTrim(Posicione("SA2",1,xFilial("SA2")+SC7->C7_FORNECE+SC7->C7_LOJA,"A2_NREDUZ"))
								EndIf
							EndIf
						EndIf
						
						If !Empty(QRYAUD->C8_NUMCON) .and. QRYAUD->C8_NUMCON <> "XXXXXXXXXXXXXXX"
							aColsAux[Len(aColsAux)][i] := "Contrato gerado - Fornecedor: "+AllTrim(Posicione("SA2",1,xFilial("SA2")+QRYAUD->C8_FORNECE+QRYAUD->C8_LOJA,"A2_NREDUZ"))
						EndIf
						
						QRYAUD->(dbskip())
					EndDo
					QRYAUD->(dbclosearea())
				Else
					aColsAux[Len(aColsAux)][i] := ""
				EndIf
				
		/*	xElseIf alltrim(aHeader2[i][2]) == AllTrim("C8_MOTIVO")
			    dbselectarea("SCE")
			    dbsetorder(1)
			    xIf dbseek(aColsAux[Len(aColsAux)][3]+aColsAux[Len(aColsAux)][4]+aColsAux[Len(aColsAux)][5]+aColsAux[Len(aColsAux)][6])
					aColsAux[Len(aColsAux)][i]  := alltrim(SCE->CE_MOTIVO)
				xElse
					aColsAux[Len(aColsAux)][i]  := alltrim(SC8->C8_MOTIVO)
				xEndIf */                                          
			ElseIf alltrim(aHeader2[i][2]) == AllTrim("C8_XVENCED")	
				aColsAux[Len(aColsAux)][i]  :=  SC8->C8_XVENCED
				If Empty(SC8->C8_XVENCED)
					aColsAux[Len(aColsAux)][i]  := aBestPrc[1][2]+" "+aBestPrc[1][3]+" - "+iif (!empty(aBestPrc[1][2]),substr(AllTrim(Posicione("SA2",1,xFilial("SA2")+aBestPrc[1][2]+aBestPrc[1][3],"A2_NREDUZ")),1,28),"")						
				EndIf					
			ElseIf alltrim(aHeader2[i][2]) == AllTrim("C8_XPEDCON")	
				aColsAux[Len(aColsAux)][i]  :=  iIf(Empty(SC8->C8_XPEDCON),"1",SC8->C8_XPEDCON)
			ElseIf alltrim(aHeader2[i][2]) == AllTrim("C8_XJUST")	
				aColsAux[Len(aColsAux)][i]  :=  SC8->C8_XJUST
			EndIf 
		Next i
		
		aBestPrc := {}
		
		DbSelectArea("SC8")
		SC8->(dbOrderNickName("COTACNEW"))
		
		While SC8->(!EOF()) .and. SC8->C8_FILIAL == aColsAux[Len(aColsAux)][3] .and. SC8->C8_NUM == aColsAux[Len(aColsAux)][4] .and. SC8->C8_ITEM == aColsAux[Len(aColsAux)][5]
			SC8->(DbSkip())
		EndDo
		
	Enddo
	
Else
	
	Aadd(aColsAux,Array(Len(aHeader2)+1))
	For i := 1 To Len(aHeader2)
		aColsAux[Len(aColsAux)][i] := " "//Criavar(aHeader2[i][2],.F.)
	Next i
	aColsAux[Len(aColsAux)][Len(aHeader2)+1] := .F.
	aColsAux[Len(aColsAux)][1] := oNo
EndIf


If Empty(aColsAux)
	Aadd(aColsAux,Array(Len(aHeader2)+1))
	For i := 1 To Len(aHeader2)
		aColsAux[Len(aColsAux)][i] := " "//Criavar(aHeader2[i][2],.F.)
	Next i
	aColsAux[Len(aColsAux)][Len(aHeader2)+1] := .F.
	aColsAux[Len(aColsAux)][1] := oNo
EndIf

CLOG += ('[ ' + DtoC(Date()) + ' ] - [ Cotacao 06] - Filtra dados e popula o aCols - [ ' + ElapTime(cHoraIni,Time()) + ' ]' )+CHR(13)+CHR(10)+CHR(13)+CHR(10)
CHORAINI  := TIME()

//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
//ณ Monta o Header com os titulos do MsSelect             ณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
dbSelectArea("SX3")
dbSetOrder(2)
For nX := 1 to Len(aCampos)
	If MsSeek(aCampos[nX])
		If AllTrim(aCampos[nX])$"C1_OK"
			AADD(aCpos,{aCampos[nX],""," ",X3_PICTURE})
		Else
			AADD(aCpos,{aCampos[nX],"",AllTrim(X3Titulo()),X3_PICTURE})
		EndIf
	EndIf
Next nX

dbSelectArea("SX3")
dbSetOrder(1)
MsSeek("SC1")
While !Eof() .And. SX3->X3_ARQUIVO == "SC1"
	IF ( SX3->X3_BROWSE=="S".And.SX3->X3_CONTEXT <> "V" .And. Ascan(aCpos,{|x| Alltrim(x[1]) == Alltrim(SX3->X3_CAMPO)})==0 ) .and. Alltrim(SX3->X3_CAMPO) <> "C1_OK"
		Aadd(aCpos,{SX3->X3_CAMPO,"",AllTrim(X3Titulo()),X3_PICTURE})
	EndIf
	dbSkip()
Enddo

aAdd( aObjects, { 315, 20, .T., .T. } )
aInfo := { aSize[ 1 ], aSize[ 2 ], aSize[ 3 ], aSize[ 4 ], 3, 3 }
aPosObj := MsObjSize( aInfo, aObjects)

oF1Layer := FWLayer():New()
oF2Layer := FWLayer():New()

If _nSavFolder == 3
	MV_PAR04 := "     "
	MV_PAR05 := "ZZZZZZ"
EndIf

SC1->(dbClearFilter())
cFiltroSC1 += IIF(Empty(cFiltroSC1)," (C1_NUM >= '"+alltrim(MV_PAR04)+"' .And. C1_NUM <= '"+alltrim(MV_PAR05)+"') ",".And. (C1_NUM >= '"+alltrim(MV_PAR04)+"' .And. C1_NUM <= '"+alltrim(MV_PAR05)+"')")
cQuerySC1  += IIF(Empty(cFiltroSC1)," (C1_NUM >= '"+alltrim(MV_PAR04)+"' AND C1_NUM <= '"+alltrim(MV_PAR05)+"') "," AND (C1_NUM >= '"+alltrim(MV_PAR04)+"' AND C1_NUM <= '"+alltrim(MV_PAR05)+"')")

if !empty(MV_PAR06)
	dbselectarea("SAJ")
	dbsetorder(2)
	If dbseek(xFilial("SAJ")+MV_PAR06)
		_cGrpUser := "(C1_GRUPCOM == '"+SAJ->AJ_GRCOM+"' "
		_cGrpUser3 := "(C1_GRUPCOM = '"+SAJ->AJ_GRCOM+"' "
		While SAJ->(!EOF()) .and. xFilial("SAJ")+MV_PAR06 == SAJ->AJ_FILIAL+SAJ->AJ_USER
			if _lGrpCom
				_cGrpUser  += " .or. C1_GRUPCOM == '"+SAJ->AJ_GRCOM+"' "
				_cGrpUser3 += " OR C1_GRUPCOM = '"+SAJ->AJ_GRCOM+"' "
			endif
			_lGrpCom:= .T.
			SAJ->(dbskip())
		EndDo
		_cGrpUser += ")"
		
		cFiltroSC1 += IIF(Empty(cFiltroSC1),_cGrpUser," .And. "+_cGrpUser+"")
		cQuerySC1  += IIF(Empty(cFiltroSC1),_cGrpUser3," AND "+_cGrpUser3+"")
	EndIf
Endif
	
Eval(bFiltraBrw)
dbGotop()

CLOG += ('[ ' + DtoC(Date()) + ' ] - [ Cotacao 06] - Filtra dados e popula o aCols - [ ' + ElapTime(cHoraIni,Time()) + ' ]' )+CHR(13)+CHR(10)+CHR(13)+CHR(10)
CHORAINI  := TIME()

DEFINE MSDIALOG oDlgCotac TITLE "GJP Hotels & Resorts" From aSize[7],0 to aSize[6],aSize[5] of oMainWnd PIXEL Style DS_MODALFRAME

oFolder := TFolder():New(aPosObj[1,1]*0.10, aPosObj[1,2], aFolder, , oDlgCotac, 1, , , .T.,.F.,aPosObj[1,4],aPosObj[1,3]-(aPosObj[1,1]*0.10),)
//oFolder:bSetOption := {||IIF(oFolder:nOption==2,(_nSavFolder:=1,oDlgCotac:End()),nil)}
oFolder:bSetOption := {||IIF(oFolder:nOption==2,(SC1->(dbClearFilter()),Eval(bFiltraBrw),dbGotop()),nil)}

// Folder 1
oF1Layer:Init(oFolder:aDialogs[1],.F.)
oF2Layer:Init(oFolder:aDialogs[2],.F.)

//Cria as colunas do Layer
oF1Layer:AddCollumn("Col01",100,.T.)

//Adiciona Janelas as colunas
oF1Layer:AddWindow("Col01","Jan01","Dados da Cota็ใo"				,85,.T.,.F.,{|| },,{|| })
oF1Layer:AddWindow("Col01","Jan02","Op็๕es"     					,15,.T.,.F.,{|| },,{|| })

oF1Pnl01 := oF1Layer:GetWinPanel("Col01","Jan01")
oF1Pnl02 := oF1Layer:GetWinPanel("Col01","Jan02")
	
If _nSavFolder == 3
	( Pergunte("MTA130",.F.) )
EndIf

If !SC1->(EOF()) .Or. SC1->(FieldPos("C1_COMPRAC")) > 0

////	oMrkAll := TCheckBox():New( 005, 022, "Marcar", {|| oSlcAll},oF1Pnl01 , 60, 20, , {|| lExecuta := SlctMrkBrw(0, Len(oGetDad:aCols), 1,.T.,.T.)} , , , , , , .T., "Utilize esta op็ใo para Marcar/Desmarcar todos os Itens…" , , {|| })
////	oMrkAll := TCheckBox():New( 005, 052, "Desmarcar", {|| oSlcAll},oF1Pnl01 , 60, 20, , {|| lExecuta := SlctMrkBrw(0, Len(oGetDad:aCols), 1,.T.,.F.)} , , , , , , .T., "Utilize esta op็ใo para Marcar/Desmarcar todos os Itens…" , , {|| })
	
////	oMark:=MsSelect():New("SC1","C1_OK",,aCpos,@lInverte,@cMarca,{17,2,200,655},,,oF1Pnl01,,aCores)
	oMark:=MsSelect():New("SC1","C1_OK",,aCpos,,@cMarca,{17,2,100,285},,,oF1Pnl01,,aCores)
	
	oMark:oBrowse:lhasMark := .T.
	oMark:oBrowse:lCanAllmark := .T. 

	oMark:bMark := {|| xA131Mark()}
	
	oMark:oBrowse:Align := CONTROL_ALIGN_ALLCLIENT
	oMark:oBrowse:SetFocus()
		
//	@ 01, 180 BUTTON "Compra Centralizada" SIZE 53,10 ACTION U_xMAComCent() OF oF1Pnl02 PIXEL
	@ 01, 180 BUTTON "Gera Cota็๕es" SIZE 50,10 ACTION U_xA130Gera() OF oF1Pnl02 PIXEL
	@ 01, 240 BUTTON "Inserir Itens" SIZE 50,10 ACTION U_xA130ItemCot() OF oF1Pnl02 PIXEL
	@ 01, 300 BUTTON "Visualizar" SIZE 50,10 ACTION U_A130VSC() OF oF1Pnl02 PIXEL
	@ 01, 360 BUTTON "Filtro" SIZE 50,10 ACTION A130Filtro(1) OF oF1Pnl02 PIXEL
	@ 01, 420 BUTTON "Parโmetros" SIZE 50,10 ACTION A130ScFiltr() OF oF1Pnl02 PIXEL
	@ 01, 480 BUTTON "Legenda" SIZE 50,10 ACTION A130Legenda() OF oF1Pnl02 PIXEL
	@ 01, 560 BUTTON "Sair" SIZE 50,10 ACTION {||nOpcA:=1,oDlgCotac:End()} OF oF1Pnl02 PIXEL
	
EndIf

// Folder 2
(Pergunte("COT130",.F.) )
//Cria as colunas do Layer
oF2Layer:AddCollumn("Col01",100,.T.)

//Adiciona Janelas as colunas
oF2Layer:AddWindow("Col01","Jan01","Dados da Cota็ใo"				,20,.T.,.F.,{|| },,{|| })
oF2Layer:AddWindow("Col01","Jan02","Dados dos Itens da Cota็ใo"	,65,.T.,.F.,{|| },,{|| })
oF2Layer:AddWindow("Col01","Jan03","Op็๕es"					,15,.T.,.F.,{|| },,{|| })

oF2Pnl01 := oF2Layer:GetWinPanel("Col01","Jan01")
oF2Pnl02 := oF2Layer:GetWinPanel("Col01","Jan02")
oF2Pnl03 := oF2Layer:GetWinPanel("Col01","Jan03")

oF2Pnl01Vert := FWFormContainer():New(oF2Pnl01)
cF2Pnl01A := oF2Pnl01Vert:CreateVerticalBox(40)
cF2Pnl01B := oF2Pnl01Vert:CreateVerticalBox(60)
oF2Pnl01Vert:Activate(oF2Pnl01,.F.)

oF2Pnl01A := oF2Pnl01Vert:GeTPanel(cF2Pnl01A)
oF2Pnl01B := oF2Pnl01Vert:GeTPanel(cF2Pnl01B)

//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
//ณ Dados da Cota็ใo										  			ณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
If !(Len(aColsAux) == 1 .and. Empty(aColsAux[1][4]))
oSay	:= TSay():New(003,001,{|| OemToAnsi("Numero da Cota็ใo: ")},oF2Pnl01B,,,,,,.T.,,,200,20)
oTGet1 	:= TGet():New(001,052,{|| cNumCot},oF2Pnl01B ,080,008,"@!" ,,,,,.F.,,.T.,,.F.,,.F.,.F.,,.T.,.F.,,cNumCot,,,, )

oSay	:= TSay():New(018,001,{|| OemToAnsi("Valor Total Cota็ใo: ")},oF2Pnl01B,,,,,,.T.,,,200,20)
oTGet2 	:= TGet():New(016,052,{|| alltrim(TransForm(nVlrCotac,"@e 999,999,999.99")) },oF2Pnl01B,080,008,"@!",,,,,.F.,,.T.,,.F.,,.F.,.F.,,.T.,.F.,,alltrim(TransForm(nVlrCotac,"@e 999,999,999.99")),,,, )

oSay	:= TSay():New(003,160,{|| OemToAnsi("Fornecedor Sugerido: ")},oF2Pnl01B,,,,,,.T.,,,200,20)
oTGet3 	:= TGet():New(001,214,{|| cFornEsc},oF2Pnl01B ,080,008,"@!" ,,,,,.F.,,.T.,,.F.,,.F.,.F.,,.T.,.F.,,cFornEsc,,,, )

oSay	:= TSay():New(018,160,{|| OemToAnsi("Melhor Pre็o (Total): ")},oF2Pnl01B,,,,,,.T.,,,200,20)
oTGet4 	:= TGet():New(016,214,{|| alltrim(TransForm(nMelhorPrc,"@e 999,999,999.99")) },oF2Pnl01B,080,008,"@!",,,,,.F.,,.T.,,.F.,,.F.,.F.,,.T.,.F.,,alltrim(TransForm(nMelhorPrc,"@e 999,999,999.99")),,,, )
 
//oChkAll := TCheckBox():New( 025, 001.5, "Selecionar Todos.", {|| oSlcAll}, oPanel, 60, 20, , {|| lExecuta := SlctAcols(1, Len(oGetDados:aCols), oSlcAll)} , , , , , , .T., "Utilize esta op็ใo para Marcar/Desmarcar todos os Itens…" , , {|| })
oChkAll := TCheckBox():New( 018, 322, "Marcar", {|| oSlcAll},oF2Pnl01B , 60, 20, , {|| lExecuta := SlctAcols(0, Len(oGetDad:aCols), 1,.T.,.T.)} , , , , , , .T., "Utilize esta op็ใo para Marcar/Desmarcar todos os Itens…" , , {|| })
oChkAll := TCheckBox():New( 018, 352, "Desmarcar", {|| oSlcAll},oF2Pnl01B , 60, 20, , {|| lExecuta := SlctAcols(0, Len(oGetDad:aCols), 1,.T.,.F.)} , , , , , , .T., "Utilize esta op็ใo para Marcar/Desmarcar todos os Itens…" , , {|| })
//If !(Len(aColsAux) == 1 .and. Empty(aColsAux[1][4]))

oGetDad:= MsNewGetDados():New(120,00,00,00,2,,,,,10,99999,,,,oF2Pnl02,aHeader2,aColsAux)
oGetDad:oBrowse:Align:= CONTROL_ALIGN_ALLCLIENT
oGetDad:AddAction('MARCA',{|| lExecuta := SlctAcols(0,2, oGetDad:nAt)})
oGetDad:AddAction('LEGENDA',{|| msginfo("Cota็ใo")})
oGetDad:bChange := {|| U_xAtuCabec()}

// Pesquisa no grid
U_GJP_GDPesqu(aHeader2,aColsAux, oGetDad, oF2Pnl01A, 002,.F.,2)

@ 02.3, 143 BUTTON "Legenda" SIZE 28,12.2 ACTION A160Legenda() OF oF2Pnl01A PIXEL
@ 02.3, 175 BUTTON "Filtro"  SIZE 28,12.2 ACTION  A130Filtro(2) OF oF2Pnl01A PIXEL
@ 02.3, 322 BUTTON "Sair"    SIZE 50,10 ACTION {||nOpcA:=1,oDlgCotac:End()} OF oF2Pnl01B PIXEL
Else

@ 02.3, 01 BUTTON "Filtro"  SIZE 50,10 ACTION  A130Filtro(2) OF oF2Pnl01A PIXEL
@ 02.3, 60 BUTTON "Sair"    SIZE 50,10 ACTION {||nOpcA:=1,oDlgCotac:End()} OF oF2Pnl01A PIXEL
oSay	:= TSay():New(018,001,{|| OemToAnsi("Nใo existem registros de acordo com os filtros informados.")},oF2Pnl02,,,,,,.T.,,,200,20)

EndIf



If !(Len(aColsAux) == 1 .and. Empty(aColsAux[1][4]))
	Setkey( VK_F2,{||SlctAcols(0,2, oGetDad:nAt)})
	Setkey( VK_F4,{||xSelectWin()})
	@ 01, 01  BUTTON "Novo Participante"    SIZE 50,10 ACTION U_GJPNewPart() OF oF2Pnl03 PIXEL
	@ 01, 60  BUTTON "Excluir Participante" SIZE 50,10 ACTION U_GJPExcPart() OF oF2Pnl03 PIXEL
	@ 01, 120 BUTTON "Excluir Item"         SIZE 50,10 ACTION U_GJPExcItem() OF oF2Pnl03 PIXEL
	@ 01, 180 BUTTON "Exclusใo M๚ltipla"    SIZE 50,10 ACTION u_GJPExcMult() OF oF2Pnl03 PIXEL
	@ 01, 240 BUTTON "Compra Dividida"      SIZE 50,10 ACTION U_GJPComDiv() OF oF2Pnl03 PIXEL
	@ 01, 300 BUTTON "Desfazer Divisใo"     SIZE 50,10 ACTION U_GJPDesDiv() OF oF2Pnl03 PIXEL
	
	@ 01, 360 BUTTON "Total Cota็ใo"        SIZE 50,10 ACTION U_GJPTotCot() OF oF2Pnl03 PIXEL
	@ 01, 420 BUTTON "Inf. Fornecedor"      SIZE 50,10 ACTION U_GJPInfForn() OF oF2Pnl03 PIXEL
	@ 01, 480 BUTTON "Hist. Produto"        SIZE 50,10 ACTION U_GJPHistPrd() OF oF2Pnl03 PIXEL
	@ 01, 540 BUTTON "Aglutina Cota็๕es"    SIZE 50,10 ACTION U_GJPAglutCot() OF oF2Pnl03 PIXEL
	@ 01, 600 BUTTON "Finaliza Cota็ใo"     SIZE 50,10 ACTION U_GJPFinCot() OF oF2Pnl03 PIXEL
EndIf

//@ 01, 600 BUTTON "Sair" SIZE 50,10 ACTION {||nOpcA:=1,oDlgCotac:End()} OF oF2Pnl03 PIXEL


If _nSavFolder == 2
	oFolder:SetOption(2)
EndIf

CLOG += ('[ ' + DtoC(Date()) + ' ] - [ Cotacao 07] - Modo Construtor da interface - [ ' + ElapTime(cHoraIni,Time()) + ' ]' )+CHR(13)+CHR(10)+CHR(13)+CHR(10)
CHORAINI  := TIME()
msginfo(cLog)
ACTIVATE MSDIALOG oDlgCotac CENTERED
//ACTIVATE MSDIALOG oDlgCotac ON INIT EnchoiceBar(oDlgCotac,{||nOpcA:=1,oDlgCotac:End()},{nOpcA:=1,oDlgCotac:End()},,) CENTER
/*
If oGetDad <> nil
	For i:=1 to len(oGetDad:aCols)
		dbselectarea("SC8")
		dbsetorder(1)
		If dbseek(oGetDad:aCols[i][aScan(oGetDad:aHeader,{|x| AllTrim(x[2]) == "FILIAL"]+oGetDad:aCols[i][aScan(oGetDad:aHeader,{|x| AllTrim(x[2]) == "COTACAO"])
			While SC8->(!EOF()) .and. oGetDad:aCols[i][aScan(oGetDad:aHeader,{|x| AllTrim(x[2]) == "FILIAL"] == SC8->C8_FILIAL .and. oGetDad:aCols[i][aScan(oGetDad:aHeader,{|x| AllTrim(x[2]) == "COTACAO"] == SC8->C8_NUM
				If oGetDad:aCols[i][aScan(oGetDad:aHeader,{|x| AllTrim(x[2]) == "ITEM"] == SC8->C8_ITEM
					RecLock("SC8",.F.)
					SC8->C8_OBS := oGetDad:aCols[i][aScan(oGetDad:aHeader,{|x| AllTrim(x[2]) == "C8_OBS"]
					SC8->(msunlock())
				EndIf
				
				SC8->(dbskip())
			EndDo
		EndIf
	Next i
EndIf
*/
If nOpcA == 0
	SC1->(dbClearFilter())
	U_GJP130Process(1)
//	U_GJP130Cot(_nSavFolder)
	Processa({|lEnd| U_GJP130Cot(_nSavFolder)})
EndIf
	SetKey( VK_F2,{||NIL} )
	SetKey( VK_F4,{||NIL} )
	U_GJP130Process(2)
Return Nil


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณ A130VSC  บ Autor ณMicrosiga           บ Data ณ  19/05/15   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ Visualiza os detalhes da SC posicionada.                   บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ GJP Hotels & Resorts                                       บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
User Function A130VSC()
//A130VisuSC("SC1",SC1->(Recno()),2)
A131VisuSC("SC1",SC1->(Recno()),2)
Return .T.

User Function xMAComCent()
MAComCent()
oDlgCotac:End()
_nSavFolder := 1
Return .T.

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัอออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณ xA130Gera บ Autor ณ Carlos A. Queiroz  บ Data ณ  19/05/15   บฑฑ
ฑฑฬออออออออออุอออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ Gera a Cotacao da SC selecionada.						   บฑฑ
ฑฑฬออออออออออุอออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ GJP Hotels & Resorts                                        บฑฑ
ฑฑศออออออออออฯอออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
User Function xA130Gera()
Local cSCInicial  := ""  
Local cSCFinal    := ""  

Pergunte("COT130",.F.)

cSCInicial := MV_PAR04
cSCFinal   := MV_PAR05


//A130Gera()
( Pergunte("MTA130",.F.) )
If _nSavFolder <> 3
	MV_PAR01 := 1
	MV_PAR02 := stod("20100101")
	MV_PAR03 := stod("20491231")
	MV_PAR04 := 99
	MV_PAR05 := 1
	MV_PAR06 := 3
	MV_PAR07 := 2
	MV_PAR08 := 1
	MV_PAR09 := cSCInicial
	MV_PAR10 := cSCFinal
	MV_PAR11 := 1
	MV_PAR12 := ""
	MV_PAR13 := "ZZZZZZZZZ"
	MV_PAR14 := 2
EndIf

xA131Gera()
oDlgCotac:End()
_nSavFolder := 1
Return .T.

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณxA130ItemCotบ Autor ณ Carlos A. Queiroz  บ Data ณ  19/05/15   บฑฑ
ฑฑฬออออออออออุออออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ Insere um item em uma Cotacao ja existente. 				    บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ GJP Hotels & Resorts                                         บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
User Function xA130ItemCot()
Local aInfo     := {}
Local aPosObj   := {}
Local aObjects  := {}
Local aSize     := MsAdvSize()
Local oDlgItem
Local nOpcA     := 0
Local aHeader5 := {}
Local aCols5   := {}
Local _nVlrTot   := 0
Local oObj1
Local oObj2
Local oObj3
Local oObj4
Local oObj5
Local aPosGet	 := {}
Local aCotacoes  := {}
Local cQuery     := ""

Private lExecuta      := .F.
Private oSlcAll       := .F.
Private oChkAll
Private oFolderItem
Private aFolderItem := {"Inserir Itens em Cota็ใo"}
Private oOk 	   := LoadBitmap( GetResources(),"LBOK")
Private oNo 	   := LoadBitmap( GetResources(),"LBNO")
Private cCotNumber := ""
Private oGetDad5

If oMark:OBROWSE:NLEN > 0
	
	aHeader5 := {}
	
	DbSelectArea("SX3")
	DbSetOrder(2)
	If DbSeek("C6_UM")
		Aadd(aHeader5,{	"",;
		"MARCA",;
		"@BMP",;
		2,;
		0,;
		"",;
		SX3->X3_USADO,;
		"C",;
		"",;
		SX3->X3_CONTEXT,;
		"",;
		"",;
		"",;
		"A",;
		"",;
		"",;
		""})
	EndIf
	
	DbSelectArea("SX3")
	DbSetOrder(2)
	If DbSeek("C8_FILIAL")
		Aadd(aHeader5,{	AllTrim("Filial"),;
		"FILIAL",;
		SX3->X3_PICTURE,;
		SX3->X3_TAMANHO,;
		SX3->X3_DECIMAL,;
		SX3->X3_VALID,;
		SX3->X3_USADO,;
		SX3->X3_TIPO,;
		SX3->X3_F3,;
		SX3->X3_CONTEXT,;
		SX3->X3_CBOX,;
		SX3->X3_RELACAO,;
		SX3->X3_WHEN,;
		"V",;
		SX3->X3_VLDUSER,;
		SX3->X3_PICTVAR,;
		SX3->X3_OBRIGAT})
	EndIf
	
	DbSelectArea("SX3")
	DbSetOrder(2)
	If DbSeek("C8_NUM")
		Aadd(aHeader5,{	AllTrim("Cota็ใo"),;
		"COTACAO",;
		SX3->X3_PICTURE,;
		SX3->X3_TAMANHO,;
		SX3->X3_DECIMAL,;
		SX3->X3_VALID,;
		SX3->X3_USADO,;
		SX3->X3_TIPO,;
		SX3->X3_F3,;
		SX3->X3_CONTEXT,;
		SX3->X3_CBOX,;
		SX3->X3_RELACAO,;
		SX3->X3_WHEN,;
		"V",;
		SX3->X3_VLDUSER,;
		SX3->X3_PICTVAR,;
		SX3->X3_OBRIGAT})
	EndIf
	
	If select("QRYSC8") > 0
		QRYSC8->(dbclosearea())
	EndIf
	
	cQuery := " Select Distinct SC8.C8_FILIAL, SC8.C8_NUM from "+RetSqlName("SC8")+" SC8 "
	cQuery += " Where SC8.D_E_L_E_T_ <> '*' AND SC8.C8_FILIAL = '"+xFilial("SC8")+"' AND SC8.C8_NUMPED = ''
	cQuery += " Order by SC8.C8_FILIAL, SC8.C8_NUM
	cQuery := ChangeQuery(cQuery)
	dbUseArea(.T., "TOPCONN", TCGenQry(,,cQuery), "QRYSC8", .F., .T.)
	
	QRYSC8->(dbgotop())
	
	While QRYSC8->(!EOF())
		aAdd(aCotacoes,{oNo,QRYSC8->C8_FILIAL,QRYSC8->C8_NUM})
		QRYSC8->(dbskip())
	EndDo
	
	QRYSC8->(dbclosearea())
	
	For i:=1 to len(aCotacoes)
		Aadd(aCols5,Array(Len(aHeader5)+1))
		aCols5[Len(aCols5)][1]  := aCotacoes[i][1]
		aCols5[Len(aCols5)][2]  := aCotacoes[i][2]
		aCols5[Len(aCols5)][3]  := aCotacoes[i][3]
		aCols5[Len(aCols5)][Len(aHeader5)+1] := .F.
	Next i
	
	aAdd( aObjects, { 315, 20, .T., .T. } )
	aInfo := { aSize[ 1 ], aSize[ 2 ], aSize[ 3 ], aSize[ 4 ], 3, 3 }
	aPosObj := MsObjSize( aInfo, aObjects)
	
	aPosGet := MsObjGetPos(aSize[3]-aSize[1],305,;
	{{10,40,95,140,200,222,268,240},;
	{10,40,111,140,223,268,63},;
	{5,70,160,205,295},;
	{6,34,200,215},;
	{6,34,80,113,153,178},;
	{6,34,245,268,260},;
	{10,50,150,190,120},;
	{273,130,190},;
	{8,45,73,103,139,167,190,225,253},;
	{144,190,144,190,289,293},;
	{142,293,140},;
	{9,47,188,148,9,146} } )
	
	If !empty(aCotacoes)
		
		DEFINE MSDIALOG oDlgItem TITLE "GJP Hotels & Resort" From aSize[7]-200,0 to aSize[6]-420,aSize[5]-900 of oMainWnd PIXEL Style DS_MODALFRAME
		
		oFolderItem := TFolder():New(aPosObj[1,1], aPosObj[1,2], aFolderItem, , oDlgItem, 1, , , .T.,.F.,aPosObj[1,4]-450,aPosObj[1,3]-aPosObj[1,1]-120,)
		
		oGetDad5:= MsNewGetDados():New(120,00,00,00,2,,,,,,999,,,,oFolderItem:aDialogs[1],aHeader5,aCols5)
		oGetDad5:AddAction('MARCA',{|| lExecuta := SlctAcols(1,2, oGetDad5:nAt)})
		oGetDad5:oBrowse:Align:= CONTROL_ALIGN_ALLCLIENT
		
		ACTIVATE MSDIALOG oDlgItem ON INIT EnchoiceBar(oDlgItem,{|| iif(xValidItem(),(nOpcA:=1,oDlgItem:End()),NIL)},{||oDlgItem:End()},,) CENTER
		
		If nOpcA==1
			For i:=1 to Len(oGetDad5:aCols)
				If oGetDad5:aCols[i][1] == oOk
					cCotNumber := oGetDad5:aCols[i][3]
					i:=Len(oGetDad5:aCols)
				EndIf
			Next i

			If !empty(cCotNumber) 

			( Pergunte("MTA130",.F.) )
			If _nSavFolder <> 3
				MV_PAR01 := 1
				MV_PAR02 := stod("20100101")
				MV_PAR03 := stod("20491231")
				MV_PAR04 := 99
				MV_PAR05 := 1
				MV_PAR06 := 3
				MV_PAR07 := 2
				MV_PAR08 := 1
				MV_PAR09 := ""
				MV_PAR10 := "ZZZZZZ"
				MV_PAR11 := 1
				MV_PAR12 := ""
				MV_PAR13 := "ZZZZZZZZZ"
				MV_PAR14 := 2
			EndIf
			
				U_xA130ItGera()

			EndIf
		EndIf
		
	Else
		msginfo("Nใo existem Cota็๕es em aberto para a inser็ใo em uma jแ existente.")
	EndIf
	
	oDlgCotac:End()
	_nSavFolder := 1
	
Else
	msginfo("Nใo ้ possํvel inserir devido nใo existir SC filtrada.")
EndIf

Return .T.


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณ xValidItem บ Autor ณ Carlos A. Queiroz  บ Data ณ  19/05/15   บฑฑ
ฑฑฬออออออออออุออออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ Valida a marcacao de uma cotacao existente para que ocorra   บฑฑ
ฑฑบ          ณ o processo de 'Inserir Itens em Cotacoes'.                   บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ GJP Hotels & Resorts                                         บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
Static Function xValidItem()
Local lRet := .F.
Local nCount := 0

For i:=1 to Len(oGetDad5:aCols)
	If oGetDad5:aCols[i][1] == oOk
		nCount++
	EndIf
Next i

If nCount == 0
	msginfo("Nenhuma cota็ใo foi selecionada.")
ElseIf nCount > 1
	msginfo("Selecionar apenas 1 ๚nica cota็ใo para a inser็ใo de novos itens.")
	For i:=1 to Len(oGetDad5:aCols)
		oGetDad5:aCols[i][1] := oNo
	Next i
	oGetDad5:Refresh()
ElseIf nCount == 1
	lRet := .T.
Endif

Return lRet


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณ a130Filtro บ Autor ณ Carlos A. Queiroz  บ Data ณ  19/05/15   บฑฑ
ฑฑฬออออออออออุออออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ Executa a chamada de filtro das Cotacoes exibidas no Folder 2บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ GJP Hotels & Resorts                                         บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
Static Function A130Filtro(nFolderFil)

If Pergunte("COT130",.T.)
	oDlgCotac:End()
	_nSavFolder := nFolderFil
EndIf

Return .T.

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณ a130ScFiltrบ Autor ณ Carlos A. Queiroz  บ Data ณ  19/05/15   บฑฑ
ฑฑฬออออออออออุออออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ Executa a chamada do filtro das SC's contidas no Folder 1    บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ GJP Hotels & Resorts                                         บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
Static Function A130ScFiltr()
If  Pergunte("MTA130",.T.)
	oDlgCotac:End()
	_nSavFolder := 3
EndIf

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณ xAtuCabec  บ Autor ณ Carlos A. Queiroz  บ Data ณ  19/05/15   บฑฑ
ฑฑฬออออออออออุออออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ Atualiza os campos de Num.Cotacao e Valor Total no cabecalho บฑฑ
ฑฑบ          ณ do Folder 2.                                                 บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ GJP Hotels & Resorts                                         บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
User Function xAtuCabec()
Local _cFilial  := oGetDad:aCols[oGetDad:nAt][aScan(oGetDad:aHeader,{|x| AllTrim(x[2]) == "FILIAL"})]
Local _cNum     := oGetDad:aCols[oGetDad:nAt][aScan(oGetDad:aHeader,{|x| AllTrim(x[2]) == "COTACAO"})]
Local nVlrAux   := 0

For i:=1 to Len(oGetDad:aCols)
	If _cFilial == oGetDad:aCols[i][aScan(oGetDad:aHeader,{|x| AllTrim(x[2]) == "FILIAL"})]  .and. _cNum == oGetDad:aCols[i][aScan(oGetDad:aHeader,{|x| AllTrim(x[2]) == "COTACAO"})]
		//		nVlrAux += oGetDad:aCols[i][aScan(oGetDad:aHeader,{|x| AllTrim(x[1]) == "Melhor Pre็o"})]
		nVlrAux += oGetDad:aCols[i][aScan(oGetDad:aHeader,{|x| AllTrim(x[1]) == "Pre็o Total"})]
	EndIf
Next i

cNumCot   := _cNum
nVlrCotac := nVlrAux    
cFornEsc   := oGetDad:aCols[oGetDad:nAt][aScan(oGetDad:aHeader,{|x| AllTrim(x[2]) == "A2_NOME"})]
nMelhorPrc := oGetDad:aCols[oGetDad:nAt][aScan(oGetDad:aHeader,{|x| AllTrim(x[1]) == "Pre็o Total"})]

oTGet1:Refresh()
oTGet2:Refresh()
oTGet3:Refresh()
oTGet4:Refresh()

Return .T.

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณ SC8Refresh บ Autor ณ Carlos A. Queiroz  บ Data ณ  19/05/15   บฑฑ
ฑฑฬออออออออออุออออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ Funcao responsavel por atualizar online os campos editados   บฑฑ
ฑฑบ          ณ na intereface de Cotacoes (Folder 2).                        บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ GJP Hotels & Resorts                                         บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
User Function SC8Refresh()
Local _cFilial  := ""
Local cNum     := ""
Local cFornece := ""
Local cLoja    := ""
Local cItem    := ""

dbselectarea("SC8")
aBestPrc := {}

If !oGetDad:aCols[oGetDad:nAt][2] == oLegVerm
	For i:=11 to len(oGetDad:aHeader)
		
		If !oGetDad:aCols[oGetDad:nAt][len(oGetDad:aHeader)+1]
			
			_cFilial  := oGetDad:aCols[oGetDad:nAt][aScan(oGetDad:aHeader,{|x| AllTrim(x[2]) == "FILIAL"})]
			cNum     := oGetDad:aCols[oGetDad:nAt][aScan(oGetDad:aHeader,{|x| AllTrim(x[2]) == "COTACAO"})]
			cItem    := oGetDad:aCols[oGetDad:nAt][aScan(oGetDad:aHeader,{|x| AllTrim(x[2]) == "ITEM"})]
			
			If readvar() == "M->C8_PRECO"
				
				If oGetDad:OBROWSE:COLPOS == i
					cFornece := substr(oGetDad:aHeader[i][1],1,TamSX3("C8_FORNECE")[1])
					cLoja    := substr(oGetDad:aHeader[i][1],(TamSX3("C8_FORNECE")[1])+4,TamSX3("C8_LOJA")[1])
					
					dbselectarea("SC8")
					dbsetorder(1)
					If dbseek(_cFilial+cNum+cFornece+cLoja+cItem)
						RecLock("SC8",.F.)
						SC8->C8_PRECO := M->C8_PRECO
						SC8->C8_TOTAL := SC8->C8_QUANT * M->C8_PRECO
						SC8->(msunlock())
						oGetDad:aCols[oGetDad:nAt][2] := oLegVerd
	`					oGetDad:Refresh()
					Else
						If msgyesno("Fornecedor nใo faz parte do item "+alltrim(cItem)+" da cota็ใo "+alltrim(cNum)+", deseja inserir o fornecedor "+alltrim(cFornece)+" - "+alltrim(cLoja)+" - "+AllTrim(Posicione("SA2",1,xFilial("SA2")+cFornece+cLoja,"A2_NOME"))+"?")
							u_xNewFornec(cFornece,cLoja)
							u_SC8Refresh()
							Return .T.
						Else
							msginfo("Fornecedor nใo faz parte desta cota็ใo e portanto nใo serแ aceito o valor inserido.","Digita็ใo rejeitada")
							Return .F.
						EndIf
						
					EndIf
					
					For j:=11 To Len(aHeader2)
						If alltrim(aHeader2[j][2]) == "C8_PRECO" .and. alltrim(aHeader2[j][1]) <> AllTrim("Melhor Pre็o") .and. alltrim(aHeader2[j][1]) <> AllTrim("Pre็o Total") .and. (oGetDad:aCols[oGetDad:nAt][j] <> 0 .or. (ReadVar()=="M->C8_PRECO" .and. M->C8_PRECO <> 0))
							If oGetDad:OBROWSE:COLPOS == j .and. M->C8_PRECO > 0
								aAdd(aBestPrc,{M->C8_PRECO,substr(aHeader2[j][1],1,TamSX3("C8_FORNECE")[1]), substr(aHeader2[j][1],(TamSX3("C8_FORNECE")[1])+4,TamSX3("C8_LOJA")[1]) })
							ElseIf oGetDad:aCols[oGetDad:nAt][j] > 0 .and. oGetDad:OBROWSE:COLPOS <> j
								aAdd(aBestPrc,{oGetDad:aCols[oGetDad:nAt][j],substr(aHeader2[j][1],1,TamSX3("C8_FORNECE")[1]), substr(aHeader2[j][1],(TamSX3("C8_FORNECE")[1])+4,TamSX3("C8_LOJA")[1]) })
							EndIf
						EndIf
					Next j
					
					If empty(aBestPrc)
						aAdd(aBestPrc,{0,"",""})
					Else
						aSort( aBestPrc,,,{|x,y| x[1] < y[1] })
					EndIf
					
					For j:=11 To Len(aHeader2)
						If alltrim(aHeader2[j][1]) == AllTrim("Melhor Pre็o")
							oGetDad:aCols[oGetDad:nAt][j]  := aBestPrc[1][1]
						ElseIf alltrim(aHeader2[j][1]) == AllTrim("Pre็o Total")
							oGetDad:aCols[oGetDad:nAt][j]  := aBestPrc[1][1] * oGetDad:aCols[oGetDad:nAt][10]
						ElseIf alltrim(aHeader2[j][2]) == AllTrim("A2_NOME")
//							oGetDad:aCols[oGetDad:nAt][j]  := iif (!empty(aBestPrc[1][2]),AllTrim(Posicione("SA2",1,xFilial("SA2")+aBestPrc[1][2]+aBestPrc[1][3],"A2_NOME")),"")
							oGetDad:aCols[oGetDad:nAt][j]  := iif((aBestPrc[1][1] * oGetDad:aCols[oGetDad:nAt][10]) > 0, iif (!empty(aBestPrc[1][2]),substr(AllTrim(Posicione("SA2",1,xFilial("SA2")+aBestPrc[1][2]+aBestPrc[1][3],"A2_NOME")),1,30),""),"")						
						ElseIf alltrim(aHeader2[j][2]) == AllTrim("C8_XVENCED")
							oGetDad:aCols[oGetDad:nAt][j]  := aBestPrc[1][2]+" "+aBestPrc[1][3]+" - "+iif (!empty(aBestPrc[1][2]),substr(AllTrim(Posicione("SA2",1,xFilial("SA2")+aBestPrc[1][2]+aBestPrc[1][3],"A2_NREDUZ")),1,28),"")						
						EndIf
					Next j
					oGetDad:Refresh()
					
					i:=len(oGetDad:aHeader)
				EndIf
/*				
			ElseIf readvar() == "M->C8_COND"
				
				If oGetDad:OBROWSE:COLPOS == i
					cFornece := substr(oGetDad:aHeader[i-1][1],1,TamSX3("C8_FORNECE")[1])
					cLoja    := substr(oGetDad:aHeader[i-1][1],(TamSX3("C8_FORNECE")[1])+4,TamSX3("C8_LOJA")[1])
					
					dbselectarea("SC8")
					dbsetorder(1)
					If dbseek(_cFilial+cNum+cFornece+cLoja+cItem)
						RecLock("SC8",.F.)
						SC8->C8_COND := M->C8_COND
						SC8->(msunlock())
					EndIf
					i:=len(oGetDad:aHeader)
				EndIf
				                           */
			ElseIf readvar() == "M->B1_DESC"
				
				dbselectarea("SC8")
				dbsetorder(1)
				If dbseek(_cFilial+cNum/*+cFornece+cLoja+cItem*/)
					While SC8->(!EOF()) .and. _cFilial == SC8->C8_FILIAL .and. cNum == SC8->C8_NUM
						If cItem == SC8->C8_ITEM
							RecLock("SC8",.F.)
							SC8->C8_OBS := M->B1_DESC
							SC8->(msunlock())
						EndIf
						
						SC8->(dbskip())
					EndDo
				EndIf
				i:=len(oGetDad:aHeader)

			ElseIf readvar() == "M->C8_XJUST"
				
				dbselectarea("SC8")
				dbsetorder(1)
				If dbseek(_cFilial+cNum/*+cFornece+cLoja+cItem*/)
					While SC8->(!EOF()) .and. _cFilial == SC8->C8_FILIAL .and. cNum == SC8->C8_NUM
						If cItem == SC8->C8_ITEM
							RecLock("SC8",.F.)
							SC8->C8_XJUST := M->C8_XJUST
							SC8->(msunlock())
						EndIf
						
						SC8->(dbskip())
					EndDo
				EndIf
				i:=len(oGetDad:aHeader)
								
			ElseIf readvar() == "M->C8_PRAZO"
				
				If oGetDad:OBROWSE:COLPOS == i
					
					dbselectarea("SC8")
					dbsetorder(1)
					If dbseek(_cFilial+cNum)
						While SC8->(!EOF()) .and. _cFilial == SC8->C8_FILIAL .and. cNum == SC8->C8_NUM
							If cItem == SC8->C8_ITEM
								RecLock("SC8",.F.)
								SC8->C8_PRAZO := M->C8_PRAZO
								SC8->(msunlock())
							EndIf
							
							SC8->(dbskip())
						EndDo
					EndIf
					i:=len(oGetDad:aHeader)
				EndIf
				
			ElseIf readvar() == "M->C8_XVENCED"
				
				dbselectarea("SC8")
				dbsetorder(1)
				If dbseek(_cFilial+cNum/*+cFornece+cLoja+cItem*/)
					While SC8->(!EOF()) .and. _cFilial == SC8->C8_FILIAL .and. cNum == SC8->C8_NUM
						If cItem == SC8->C8_ITEM
							RecLock("SC8",.F.)
							SC8->C8_XVENCED := M->C8_XVENCED
							SC8->(msunlock())
						EndIf
						
						SC8->(dbskip())
					EndDo
				EndIf
				i:=len(oGetDad:aHeader)

			ElseIf readvar() == "M->C8_XPEDCON"
				
				dbselectarea("SC8")
				dbsetorder(1)
				If dbseek(_cFilial+cNum/*+cFornece+cLoja+cItem*/)
					While SC8->(!EOF()) .and. _cFilial == SC8->C8_FILIAL .and. cNum == SC8->C8_NUM
						If cItem == SC8->C8_ITEM
							RecLock("SC8",.F.)
							SC8->C8_XPEDCON := M->C8_XPEDCON
							SC8->(msunlock())
						EndIf
						
						SC8->(dbskip())
					EndDo
				EndIf
				i:=len(oGetDad:aHeader)
			
			EndIf
			
		EndIf
		
	Next i
Else
	msginfo("Cota็ใo com pedido de compra jแ gerado, nใo ้ permitido a altera็ใo deste registro.")
	Return .F.
EndIf

Return .T.



/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณ xNewFornec บ Autor ณ Carlos A. Queiroz  บ Data ณ  19/05/15   บฑฑ
ฑฑฬออออออออออุออออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ Insere um novo fornecedor que nao participa da Cotacao no    บฑฑ
ฑฑบ          ณ momento que o usuario esta editando os valores.              บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ GJP Hotels & Resorts                                         บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
User Function xNewFornec(cFornece,cLoja)
Local _aSC8 := {}
Local _cFilial  := oGetDad:aCols[oGetDad:nAt][aScan(oGetDad:aHeader,{|x| AllTrim(x[2]) == "FILIAL"})]
Local _cNum     := oGetDad:aCols[oGetDad:nAt][aScan(oGetDad:aHeader,{|x| AllTrim(x[2]) == "COTACAO"})]
Local _cItem    := oGetDad:aCols[oGetDad:nAt][aScan(oGetDad:aHeader,{|x| AllTrim(x[2]) == "ITEM"})]

DbSelectArea("SC8")
SC8->(dbOrderNickName("COTACNEW"))
if dbseek(_cFilial+_cNum+_cItem)
	
	aadd(_aSC8,SC8->C8_FILIAL)
	aadd(_aSC8,SC8->C8_ITEM)
	aadd(_aSC8,SC8->C8_NUMPRO)
	aadd(_aSC8,SC8->C8_PRODUTO)
	aadd(_aSC8,SC8->C8_UM)
	aadd(_aSC8,SC8->C8_QTDCTR)
	aadd(_aSC8,SC8->C8_QUANT)
	aadd(_aSC8,SC8->C8_PRECO)
	aadd(_aSC8,SC8->C8_CODTAB)
	aadd(_aSC8,SC8->C8_TOTAL)
//	aadd(_aSC8,SC8->C8_COND)
	aadd(_aSC8,Posicione("SA2",1,xFilial("SA2")+cFornece+cLoja,"A2_COND"))
	aadd(_aSC8,SC8->C8_TAXAFIN)
	aadd(_aSC8,SC8->C8_PRAZO)
	aadd(_aSC8,SC8->C8_OBS)
	aadd(_aSC8,cFornece)
	aadd(_aSC8,cLoja)
	aadd(_aSC8,SC8->C8_CONTATO)
	aadd(_aSC8,SC8->C8_FILENT)
	aadd(_aSC8,ddatabase)
	aadd(_aSC8,SC8->C8_NUM)
	aadd(_aSC8,SC8->C8_ALIIPI)
	aadd(_aSC8,SC8->C8_TES)
	aadd(_aSC8,SC8->C8_PICM)
	aadd(_aSC8,SC8->C8_VALFRE)
	aadd(_aSC8,SC8->C8_VALEMB)
	aadd(_aSC8,SC8->C8_DESC1)
	aadd(_aSC8,SC8->C8_DESC2)
	aadd(_aSC8,SC8->C8_TPFRETE)
	aadd(_aSC8,SC8->C8_TOTFRE)
	aadd(_aSC8,SC8->C8_AVISTA)
	aadd(_aSC8,SC8->C8_REAJUST)
	aadd(_aSC8,SC8->C8_DTVISTA)
	aadd(_aSC8,SC8->C8_VALIDA)
	aadd(_aSC8,SC8->C8_NUMPED)
	aadd(_aSC8,SC8->C8_ITEMPED)
	aadd(_aSC8,SC8->C8_NUMSC)
	aadd(_aSC8,SC8->C8_ITEMSC)
	aadd(_aSC8,SC8->C8_DATPRF)
	aadd(_aSC8,SC8->C8_IDENT)
	aadd(_aSC8,SC8->C8_VLDESC)
	aadd(_aSC8,SC8->C8_SEGUM)
	aadd(_aSC8,SC8->C8_QTSEGUM)
	aadd(_aSC8,SC8->C8_MOTIVO)
	aadd(_aSC8,SC8->C8_GRUPCOM)
	aadd(_aSC8,SC8->C8_STATME)
	aadd(_aSC8,SC8->C8_OK)
	aadd(_aSC8,SC8->C8_DESPESA)
	aadd(_aSC8,SC8->C8_SEGURO)
	aadd(_aSC8,SC8->C8_VALIPI)
	aadd(_aSC8,SC8->C8_VALICM)
	aadd(_aSC8,SC8->C8_BASEICM)
	aadd(_aSC8,SC8->C8_BASEIPI)
	aadd(_aSC8,SC8->C8_DESC)
	aadd(_aSC8,SC8->C8_MSG)
	aadd(_aSC8,SC8->C8_MOEDA)
	aadd(_aSC8,SC8->C8_TXMOEDA)
	aadd(_aSC8,SC8->C8_ORCFOR)
	aadd(_aSC8,SC8->C8_SEQFOR)
	aadd(_aSC8,SC8->C8_ITEFOR)
	aadd(_aSC8,SC8->C8_ITEMGRD)
	aadd(_aSC8,SC8->C8_ITSCGRD)
	aadd(_aSC8,SC8->C8_GRADE)
	aadd(_aSC8,SC8->C8_CODORCA)
	aadd(_aSC8,SC8->C8_ORIGEM)
	aadd(_aSC8,SC8->C8_BASESOL)
	aadd(_aSC8,SC8->C8_VALSOL)
	aadd(_aSC8,SC8->C8_ACCITEM)
	aadd(_aSC8,SC8->C8_ACCNUM)
	aadd(_aSC8,SC8->C8_CODED)
	aadd(_aSC8,SC8->C8_NUMPR)
	aadd(_aSC8,SC8->C8_RATFIN) 
    dbselectarea("SA2")
    dbsetorder(1)
    If dbseek(xFilial("SA2")+cFornece+cLoja)
		aadd(_aSC8,alltrim(SA2->A2_NOME))
		aadd(_aSC8,alltrim(SA2->A2_EMAIL))
		aadd(_aSC8,"INCLUSรO CLICBUSINESS")
	Else
		aadd(_aSC8,"")
		aadd(_aSC8,"")
		aadd(_aSC8,"")
	EndIf	
	
	Begin Transaction
	
	dbselectarea("SC8")
	SC8->(dbgotop())
	
	Reclock("SC8",.T.)
	SC8->C8_FILIAL   := _aSC8[1]
	SC8->C8_ITEM     := _aSC8[2]
	SC8->C8_NUMPRO   := _aSC8[3]
	SC8->C8_PRODUTO  := _aSC8[4]
	SC8->C8_UM       := _aSC8[5]
	SC8->C8_QTDCTR   := _aSC8[6]
	SC8->C8_QUANT    := _aSC8[7]
	SC8->C8_PRECO    := _aSC8[8]
	SC8->C8_CODTAB   := _aSC8[9]
	SC8->C8_TOTAL    := _aSC8[10]
	SC8->C8_COND     := _aSC8[11]
	SC8->C8_TAXAFIN  := _aSC8[12]
	SC8->C8_PRAZO    := _aSC8[13]
	SC8->C8_OBS      := _aSC8[14]
	SC8->C8_FORNECE  := _aSC8[15]
	SC8->C8_LOJA     := _aSC8[16]
	SC8->C8_CONTATO  := _aSC8[17]
	SC8->C8_FILENT   := _aSC8[18]
	SC8->C8_EMISSAO  := _aSC8[19]
	SC8->C8_NUM      := _aSC8[20]
	SC8->C8_ALIIPI   := _aSC8[21]
	SC8->C8_TES      := _aSC8[22]
	SC8->C8_PICM     := _aSC8[23]
	SC8->C8_VALFRE   := _aSC8[24]
	SC8->C8_VALEMB   := _aSC8[25]
	SC8->C8_DESC1    := _aSC8[26]
	SC8->C8_DESC2    := _aSC8[27]
	SC8->C8_TPFRETE  := _aSC8[28]
	SC8->C8_TOTFRE   := _aSC8[29]
	SC8->C8_AVISTA   := _aSC8[30]
	SC8->C8_REAJUST  := _aSC8[31]
	SC8->C8_DTVISTA  := _aSC8[32]
	SC8->C8_VALIDA   := _aSC8[33]
	SC8->C8_NUMPED   := _aSC8[34]
	SC8->C8_ITEMPED  := _aSC8[35]
	SC8->C8_NUMSC    := _aSC8[36]
	SC8->C8_ITEMSC   := _aSC8[37]
	SC8->C8_DATPRF   := _aSC8[38]
	SC8->C8_IDENT    := _aSC8[39]
	SC8->C8_VLDESC   := _aSC8[40]
	SC8->C8_SEGUM    := _aSC8[41]
	SC8->C8_QTSEGUM  := _aSC8[42]
	SC8->C8_MOTIVO   := _aSC8[43]
	SC8->C8_GRUPCOM  := _aSC8[44]
	SC8->C8_STATME   := _aSC8[45]
	SC8->C8_OK       := _aSC8[46]
	SC8->C8_DESPESA  := _aSC8[47]
	SC8->C8_SEGURO   := _aSC8[48]
	SC8->C8_VALIPI   := _aSC8[49]
	SC8->C8_VALICM   := _aSC8[50]
	SC8->C8_BASEICM  := _aSC8[51]
	SC8->C8_BASEIPI  := _aSC8[52]
	SC8->C8_DESC     := _aSC8[53]
	SC8->C8_MSG      := _aSC8[54]
	SC8->C8_MOEDA    := _aSC8[55]
	SC8->C8_TXMOEDA  := _aSC8[56]
	SC8->C8_ORCFOR   := _aSC8[57]
	SC8->C8_SEQFOR   := _aSC8[58]
	SC8->C8_ITEFOR   := _aSC8[59]
	SC8->C8_ITEMGRD  := _aSC8[60]
	SC8->C8_ITSCGRD  := _aSC8[61]
	SC8->C8_GRADE    := _aSC8[62]
	SC8->C8_CODORCA  := _aSC8[63]
	SC8->C8_ORIGEM   := _aSC8[64]
	SC8->C8_BASESOL  := _aSC8[65]
	SC8->C8_VALSOL   := _aSC8[66]
	SC8->C8_ACCITEM  := _aSC8[67]
	SC8->C8_ACCNUM   := _aSC8[68]
	SC8->C8_CODED    := _aSC8[69]
	SC8->C8_NUMPR    := _aSC8[70]
	SC8->C8_RATFIN   := _aSC8[71]
	SC8->C8_FORNOME  := _aSC8[72]
	SC8->C8_FORMAIL  := _aSC8[73]
//	SC8->C8_CRITER   := _aSC8[74]
	
	SC8->(msunlock())
	End Transaction
EndIf

Return .T.


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณ SlctAcols  บ Autor ณ Carlos A. Queiroz  บ Data ณ  19/05/15   บฑฑ
ฑฑฬออออออออออุออออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ Tratamento para marcar e desmarcar linhas do aCols.          บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ GJP Hotels & Resorts                                         บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
************************************************************************
//-> Tratamento para Marcar/Desmarcar linhas do Acols.
Static Function SlctAcols(nCall, nModo, nLinhas, lMarckAll,lSelMkDk)
Local lSelect  := .F.

If nCall == 0
	aCols := oGetDad:aCols
ElseIf nCall == 1
	aCols := oGetDad5:aCols
ElseIf nCall == 2
	aCols := oGetDad6:aCols
Endif

If nModo == 1
	For i:= 1 To nLinhas
		aCols[i,1] := Iif(!lMarckAll,oOk,oNo)
		lSelect    := Iif(!lMarckAll,.T.,.F.)
	Next i
	oSlcAll := !oSlcAll
	oChkAll:Refresh()
Else
	aCols[nLinhas,1] := Iif(aCols[nLinhas][1]:cName == oNo:cName,oOk,oNo)
	lSelect          := Iif(aScan(aCols, {|x| x[1]:cName == oOk:cName}) > 0,.T.,.F.)
Endif

If nCall == 0
	If nModo == 1 .or. (nModo == 2 .and. lMarckAll == nil .and. lSelMkDk == nil)
		oGetDad:SetArray(aCols)
		oGetDad:Refresh()
		oGetDad:nAt := nLinhas
		oGetDad:OBROWSE:NAT := nLinhas
	Else
		
		For i:= 1 To nModo
			aCols[i,1] := Iif(lSelMkDk,oOk,oNo)
		Next i
		oGetDad:SetArray(aCols)
		oGetDad:Refresh()
		oGetDad:nAt := nLinhas
		oGetDad:OBROWSE:NAT := nLinhas		
	EndIf	    
ElseIf nCall == 1
	oGetDad5:SetArray(aCols)
	oGetDad5:Refresh()
ElseIf nCall == 2
	oGetDad6:SetArray(aCols)
	oGetDad6:Refresh()
EndIf

Return lSelect


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณGJP130COT บAutor  ณMicrosiga           บ Data ณ  12/12/16   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ                                                            บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ AP                                                        บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
Static Function SlctMrkBrw(nCall, nModo, nLinhas, lMarckAll,lSelMkDk)
Local lRet := .T.

Return lRet
/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณ GJPFinCot  บ Autor ณ Carlos A. Queiroz  บ Data ณ  19/05/15   บฑฑ
ฑฑฬออออออออออุออออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ Funcionalidade do botao 'Finaliza Cotacao' gerando o pedido  บฑฑ
ฑฑบ          ณ de compras da cotacao selecionada.                           บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ GJP Hotels & Resorts                                         บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
User Function GJPFinCot()

Local _cFilial  := ""
Local _cNum     := ""
Local _cFornec  := ""
Local _cLoja    := ""
Local _cItem    := ""
Local _cNumSc   := ""
Local _cGera    := ""
Local _lRet      := .T.
Local _lFinaliza := .F.
Local _nCount    := 0
Local _lGeraPcContr := .T.
Local aColsAux1  := {}   
Local aGeraPc    := {}   
Local aGeraContr := {}   
Local m := 0
Local n := 0           
Local _cFilialPc := ""
Local _cNumPc 	 := ""
Local _cFornecPc := ""
Local _cLojaPc   := ""
Local _cCondPc   := ""
Local _cFilialContr := ""
Local _cNumContr 	:= ""
Local _cFornecContr := ""
Local _cLojaContr   := ""
Local _cProduto     := ""
Local _cObs         := ""
Local _aFinCotMark  

Private l160Auto := .F.
Private aSelManual:= {}
Private _cItemFinCot := ""

For i:=1 to Len(oGetDad:aCols)
	If oGetDad:aCols[i][1] == oOk
		_nCount++
	EndIf
Next i

If _nCount == 0
	msginfo("Nenhuma cota็ใo foi selecionada, marcar pelo menos 1 item para gerar pedido de compras.")
    Return .F.
EndIf

Pergunte("MTA160",.F.)
MV_PAR01 := 1
MV_PAR02 := 2
MV_PAR03 := 1
MV_PAR04 := 2
MV_PAR05 := 1
MV_PAR06 := 2
MV_PAR07 := 2
MV_PAR08 := 5
MV_PAR09 := 2
MV_PAR10 := 2
MV_PAR11 := 2
MV_PAR12 := 2
MV_PAR13 := 2
MV_PAR14 := 0
MV_PAR15 := "  "
MV_PAR16 := "ZZ"
MV_PAR17 := 1

//Inserido por Carlos Queiroz em 13/10/16 
_aFinCotMark  := {}
For i:=1 to Len(oGetDad:aCols)
	If oGetDad:aCols[i][1] == oOk
		If !oGetDad:aCols[i][2] == oLegVerm
			_cFilial  := oGetDad:aCols[i][aScan(oGetDad:aHeader,{|x| AllTrim(x[2]) == "FILIAL"})]
			_cNum     := oGetDad:aCols[i][aScan(oGetDad:aHeader,{|x| AllTrim(x[2]) == "COTACAO"})]
			_cItem    := oGetDad:aCols[i][aScan(oGetDad:aHeader,{|x| AllTrim(x[2]) == "ITEM"})]
			_cFornec  := substr(oGetDad:aCols[i][aScan(oGetDad:aHeader,{|x| AllTrim(x[2]) == "C8_XVENCED"})],1,TamSX3("C8_FORNECE")[1])
			_cLoja    := substr(oGetDad:aCols[i][aScan(oGetDad:aHeader,{|x| AllTrim(x[2]) == "C8_XVENCED"})],(TamSX3("C8_FORNECE")[1])+2,TamSX3("C8_LOJA")[1])
			_cProduto := oGetDad:aCols[i][aScan(oGetDad:aHeader,{|x| AllTrim(x[2]) == "PRODUTO"})]
			_cNumSc   := oGetDad:aCols[i][aScan(oGetDad:aHeader,{|x| AllTrim(x[2]) == "C8_NUMSC"})]
			_cObs     := oGetDad:aCols[i][aScan(oGetDad:aHeader,{|x| AllTrim(x[1]) == "Observa็ใo"})]
			If !empty(_aFinCotMark)
				If aScan(_aFinCotMark,{|x| x[2] == _cNum .and. x[4] == _cFornec .and. x[5] == _cLoja .and. x[6] == _cProduto .and. x[7] == _cNumSc .and. x[8] == _cObs} ) > 0
				   msgstop("Existem itens que foram dividos que estใo sendo solicitados para o mesmo fornecedor e nใo pode ser gerado Pedido de Compras. "+Chr(13)+Chr(10)+Chr(13)+Chr(10)+" Desfa็a a divisใo ou selecione o item "+alltrim(_cItem)+" - produto "+alltrim(_cProduto)+" - "+AllTrim(Posicione("SB1",1,xFilial("SB1")+_cProduto,"B1_DESC"))+" em uma gera็ใo de pedido de compra que esteja apenas ele marcado.")
				   Return .F.
				EndIf
			EndIf
			aAdd(_aFinCotMark,{_cFilial,_cNum,_cItem,_cFornec,_cLoja,_cProduto,_cNumSc,_cObs})
		EndIf
	EndIf
Next i

// testando unifica็ใo - carlos queiroz
For i:=1 to Len(oGetDad:aCols)
	If oGetDad:aCols[i][1] == oOk
		If !oGetDad:aCols[i][2] == oLegVerm
			_cFilial  := oGetDad:aCols[i][aScan(oGetDad:aHeader,{|x| AllTrim(x[2]) == "FILIAL"})]
			_cNum     := oGetDad:aCols[i][aScan(oGetDad:aHeader,{|x| AllTrim(x[2]) == "COTACAO"})]
			_cItem    := oGetDad:aCols[i][aScan(oGetDad:aHeader,{|x| AllTrim(x[2]) == "ITEM"})]
//			_cItemFinCot := oGetDad:aCols[i][aScan(oGetDad:aHeader,{|x| AllTrim(x[2]) == "ITEM"})]
			_cFornec  := substr(oGetDad:aCols[i][aScan(oGetDad:aHeader,{|x| AllTrim(x[2]) == "C8_XVENCED"})],1,TamSX3("C8_FORNECE")[1])
			_cLoja    := substr(oGetDad:aCols[i][aScan(oGetDad:aHeader,{|x| AllTrim(x[2]) == "C8_XVENCED"})],(TamSX3("C8_FORNECE")[1])+2,TamSX3("C8_LOJA")[1])
			_cGera    := oGetDad:aCols[i][aScan(oGetDad:aHeader,{|x| AllTrim(x[2]) == "C8_XPEDCON"})]
			
			If Empty(oGetDad:aCols[i][aScan(oGetDad:aHeader,{|x| AllTrim(x[2]) == "C8_XVENCED"})])
				msgstop("Item "+alltrim(_cItem)+" da Cota็ใo "+alltrim(_cNum)+" nใo foi informado Fornecedor Vencedor. Nใo serแ gerado PC ou Contrato para este item.")
				_lGeraPcContr := .F.
			EndIf
			
			If Empty(oGetDad:aCols[i][aScan(oGetDad:aHeader,{|x| AllTrim(x[2]) == "C8_XPEDCON"})])
				msgstop("Item Item "+alltrim(_cItem)+" da Cota็ใo "+alltrim(_cNum)+" nใo foi informado se gera Pedido de Compra ou Contrato. Nenhuma a็ใo serแ realizada para este item.")
				_lGeraPcContr := .F.
			EndIf                                                         
			dbselectarea("SC8")
			dbsetorder(1)
			if dbseek(_cFilial+_cNum+_cFornec+_cLoja+_cItem)				
				aAdd(aColsAux1,{_cFilial,_cNum,_cFornec,_cLoja,_cGera,_cItem,SC8->C8_COND})
			endif
		EndIf
	endif
Next i

aSort(aColsAux1,,, { |x,y| x[1]+x[2]+x[3]+x[4]+x[5]+x[7]+x[6] < y[1]+y[2]+y[3]+y[4]+y[5]+y[7]+y[6] } )

If !empty(aColsAux1)
	_cFilialPc := aColsAux1[1][1]
	_cNumPc    := aColsAux1[1][2]
	_cFornecPc := aColsAux1[1][3]
	_cLojaPc   := aColsAux1[1][4]    
	_cCondPc   := aColsAux1[1][7]    
	
	_cFilialContr := aColsAux1[1][1]
	_cNumContr    := aColsAux1[1][2]
	_cFornecContr := aColsAux1[1][3]
	_cLojaContr   := aColsAux1[1][4]    
	
	m := 1
	n := 1
EndIf

aGeraPc := {}
aAdd(aGeraPc,{})

aGeraContr := {}
aAdd(aGeraContr,{})

For k:=1 to len(aColsAux1)
	If aColsAux1[k][5] == "1"
		If 	_cFilialPc <> aColsAux1[k][1] .or. _cNumPc <> aColsAux1[k][2] .or. _cFornecPc <> aColsAux1[k][3] .or. _cLojaPc <> aColsAux1[k][4] .or. _cCondPc <> aColsAux1[k][7]
	        m++   
	        aAdd(aGeraPc,{})
        EndIf
		aAdd(aGeraPc[m],{aColsAux1[k][1],aColsAux1[k][2],aColsAux1[k][3],aColsAux1[k][4],aColsAux1[k][6]})
		_cFilialPc := aColsAux1[k][1]
		_cNumPc    := aColsAux1[k][2]
		_cFornecPc := aColsAux1[k][3]
		_cLojaPc   := aColsAux1[k][4]
		_cCondPc   := aColsAux1[k][7]     
	Else
		If 	_cFilialContr <> aColsAux1[k][1] .or. _cNumContr <> aColsAux1[k][2] .or. _cFornecContr <> aColsAux1[k][3] .or. _cLojaContr <> aColsAux1[k][4]
	        n++   
	        aAdd(aGeraContr[n],{})
        EndIf

		aAdd(aGeraContr[n],{aColsAux1[k][1],aColsAux1[k][2],aColsAux1[k][3],aColsAux1[k][4],aColsAux1[k][6]})
		_cFilialContr := aColsAux1[k][1]
		_cNumContr 	  := aColsAux1[k][2]
		_cFornecContr := aColsAux1[k][3]
		_cLojaContr   := aColsAux1[k][4] 
	EndIf
Next k

If !empty(aGeraPc[1])
//	msgstop("gera pc.")
	
	For i:=1 to len(aGeraPc)
		_cItemFinCot := ""
		For j:=1 to len(aGeraPc[i])
			_cFilial  := aGeraPc[i][j][1]
			_cNum     := aGeraPc[i][j][2]
			_cItem    := aGeraPc[i][j][5]
			If !empty(_cItemFinCot)
				_cItemFinCot := _cItemFinCot + ", "
			EndIf
			_cItemFinCot := _cItemFinCot + "'"+_cItem+"'
			_cFornec  := aGeraPc[i][j][3]
			_cLoja    := aGeraPc[i][j][4]
			_cGera    := "1"
		Next j	

			dbselectarea("SC8")
			dbsetorder(1)
			if dbseek(_cFilial+_cNum+_cFornec+_cLoja+_cItem)				
				SC1->(dbClearFilter())
//				xA161MapCot(_cFornec,_cLoja,_cGera)  
				Processa({|lEnd| xA161MapCot(_cFornec,_cLoja,_cGera)})				
						For j:=1 to len(aGeraPc[i])
							_cFilial  := aGeraPc[i][j][1]
							_cNum     := aGeraPc[i][j][2]
							_cItem    := aGeraPc[i][j][5]
							_cFornec  := aGeraPc[i][j][3]
							_cLoja    := aGeraPc[i][j][4]
								DbSelectArea("SC8")
								SC8->(dbOrderNickName("COTACNEW"))
								if dbseek(_cFilial+_cNum+_cItem)
								   While SC8->(!EOF()) .and. _cFilial+_cNum+_cItem == SC8->C8_FILIAL+SC8->C8_NUM+SC8->C8_ITEM
								   If empty(SC8->C8_NUMPED)
									   RecLock("SC8",.F.)
									   SC8->C8_NUMPED  := "XXXXXX" 
									   SC8->C8_ITEMPED := "XXXX"
									   SC8->(msunlock())
							       EndIf
								   SC8->(dbskip())
							   EndDo
                            endif
						Next j	
				
				_lFinaliza := .T.
			endif
			/*
			dbselectarea("SC8")
			dbsetorder(1)
			if dbseek(_cFilial+_cNum+_cFornec+_cLoja+_cItem)
				If !empty(SC8->C8_NUMPED) .and. !empty(SC8->C8_ITEMPED)
					oGetDad:aCols[i][2] := oLegVerm
					oGetDad:Refresh()
				EndIf
			endif
			*/
			If _cGera == "1"
				If SC7->C7_NUMCOT == _cNum
					U_MT120FIM()
					if msgyesno("Deseja imprimir Pedido de Compra gerado com o n๚mero "+alltrim(SC7->C7_NUM)+"?")
						U_GCOMR01()
					endif
				EndIf
			EndIf			
	Next i
EndIf

If !empty(aGeraContr[1])
//	msgstop("gera contrato.")
	
	For i:=1 to len(aGeraContr)
		_cItemFinCot := ""
		For j:=1 to len(aGeraContr[i])
			_cFilial  := aGeraContr[i][j][1]
			_cNum     := aGeraContr[i][j][2]
			_cItem    := aGeraContr[i][j][5]
			If !empty(_cItemFinCot)
				_cItemFinCot := _cItemFinCot + ", "
			EndIf
			_cItemFinCot := _cItemFinCot + "'"+_cItem+"'
			_cFornec  := aGeraContr[i][j][3]
			_cLoja    := aGeraContr[i][j][4]
			_cGera    := "0"
		Next j	

			dbselectarea("SC8")
			dbsetorder(1)
			if dbseek(_cFilial+_cNum+_cFornec+_cLoja+_cItem)				
				SC1->(dbClearFilter())
				xA161MapCot(_cFornec,_cLoja,_cGera)
				_lFinaliza := .T.
			endif
			/*
			dbselectarea("SC8")
			dbsetorder(1)
			if dbseek(_cFilial+_cNum+_cFornec+_cLoja+_cItem)
				If !empty(SC8->C8_NUMPED) .and. !empty(SC8->C8_ITEMPED)
					oGetDad:aCols[i][2] := oLegVerm
					oGetDad:Refresh()
				EndIf
			endif
			
			If _cGera == "1"
				If SC7->C7_NUMCOT == _cNum
					if msgyesno("Deseja imprimir Pedido de Compra gerado com o n๚mero "+alltrim(SC7->C7_NUM)+"?")
						U_GCOMR01()
					endif
				EndIf
			EndIf
			*/			
	Next i
	
EndIf

/*
For i:=1 to Len(oGetDad:aCols)
	If oGetDad:aCols[i][1] == oOk
		If !oGetDad:aCols[i][2] == oLegVerm
			_lGeraPcContr := .T.
			aBestPrc := {}
			For j:=11 To Len(aHeader2)
				If alltrim(aHeader2[j][2]) == "C8_PRECO" .and. alltrim(aHeader2[j][1]) <> AllTrim("Melhor Pre็o") .and. alltrim(aHeader2[j][1]) <> AllTrim("Pre็o Total")
					If oGetDad:aCols[i][j] > 0
						aAdd(aBestPrc,{oGetDad:aCols[i][j],substr(aHeader2[j][1],1,TamSX3("C8_FORNECE")[1]), substr(aHeader2[j][1],(TamSX3("C8_FORNECE")[1])+4,TamSX3("C8_LOJA")[1]) })
					EndIf
				EndIf
			Next j
			
			If empty(aBestPrc)
				aAdd(aBestPrc,{0,"",""})
			Else
				aSort( aBestPrc,,,{|x,y| x[1] < y[1] })
			EndIf
			
			_cFilial  := oGetDad:aCols[i][aScan(oGetDad:aHeader,{|x| AllTrim(x[2]) == "FILIAL"})]
			_cNum     := oGetDad:aCols[i][aScan(oGetDad:aHeader,{|x| AllTrim(x[2]) == "COTACAO"})]
			//			_cFornec  := substr(aBestPrc[1][2],1,TamSX3("C8_FORNECE")[1])
			//			_cLoja    := substr(aBestPrc[1][3],1,TamSX3("C8_LOJA")[1])
			_cItem    := oGetDad:aCols[i][aScan(oGetDad:aHeader,{|x| AllTrim(x[2]) == "ITEM"})]
			_cItemFinCot := oGetDad:aCols[i][aScan(oGetDad:aHeader,{|x| AllTrim(x[2]) == "ITEM"})]
			_cFornec  := substr(oGetDad:aCols[i][aScan(oGetDad:aHeader,{|x| AllTrim(x[2]) == "C8_XVENCED"})],1,TamSX3("C8_FORNECE")[1])
			_cLoja    := substr(oGetDad:aCols[i][aScan(oGetDad:aHeader,{|x| AllTrim(x[2]) == "C8_XVENCED"})],(TamSX3("C8_FORNECE")[1])+2,TamSX3("C8_LOJA")[1])
			_cGera    := oGetDad:aCols[i][aScan(oGetDad:aHeader,{|x| AllTrim(x[2]) == "C8_XPEDCON"})]
			
			If Empty(oGetDad:aCols[i][aScan(oGetDad:aHeader,{|x| AllTrim(x[2]) == "C8_XVENCED"})])
				msgstop("Item "+alltrim(_cItem)+" da Cota็ใo "+alltrim(_cNum)+" nใo foi informado Fornecedor Vencedor. Nใo serแ gerado PC ou Contrato para este item.")
				_lGeraPcContr := .F.
			EndIf
			
			If Empty(oGetDad:aCols[i][aScan(oGetDad:aHeader,{|x| AllTrim(x[2]) == "C8_XPEDCON"})])
				msgstop("Item Item "+alltrim(_cItem)+" da Cota็ใo "+alltrim(_cNum)+" nใo foi informado se gera Pedido de Compra ou Contrato. Nenhuma a็ใo serแ realizada para este item.")
				_lGeraPcContr := .F.
			EndIf
			
			// _cFornec,_cLoja,_cGera - validar se todos estใo preenchidos
			If _lGeraPcContr
				ProcRegua(3)
				Incproc()
				dbselectarea("SC8")
				dbsetorder(1)
				if dbseek(_cFilial+_cNum+_cFornec+_cLoja+_cItem)
					//				A160Analis("SC8",SC8->(Recno()),3)
					SC1->(dbClearFilter())
					xA161MapCot(_cFornec,_cLoja,_cGera)
					//				dbselectarea("SC1")
					//				dbsetorder(1)
					//				If dbseek(SC7->C7_FISCORI+SC7->C7_NUMSC+SC7->C7_ITEMSC)
					//				    Reclock("SC1",.F.)
					//				      SC1->C1_QUJE := SC1->C1_QUJE+SC7->C7_QUANT
					//				    SC1->(msunlock())
					//				EndIf
					_lFinaliza := .T.
				endif
				
				Incproc()
				
				dbselectarea("SC8")
				dbsetorder(1)
				if dbseek(_cFilial+_cNum+_cFornec+_cLoja+_cItem)
					If !empty(SC8->C8_NUMPED) .and. !empty(SC8->C8_ITEMPED)
						oGetDad:aCols[i][2] := oLegVerm
						oGetDad:Refresh()
					EndIf
				endif
				
				Incproc()
				If _cGera == "1"
				If SC7->C7_NUMCOT == _cNum
					if msgyesno("Deseja imprimir Pedido de Compra gerado com o n๚mero "+alltrim(SC7->C7_NUM)+"?")
						U_GCOMR01()
					endif
				EndIf
				EndIf
			EndIf
			
		Else
			msginfo("Cota็ใo "+alltrim(oGetDad:aCols[i][aScan(oGetDad:aHeader,{|x| AllTrim(x[2]) == "COTACAO"})])+" com pedido de compra jแ gerado, nใo ้ permitido a altera็ใo deste registro.")
			Return .F.
		EndIf
	endif
Next i
*/
If _lFinaliza
	oDlgCotac:End()
	_nSavFolder := 2
EndIf

Return _lRet


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณ GJPNewPart บ Autor ณ Carlos A. Queiroz  บ Data ณ  19/05/15   บฑฑ
ฑฑฬออออออออออุออออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ Insere um novo participante/fornecedor em uma Cotacao.       บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ GJP Hotels & Resorts                                         บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
User Function GJPNewPart()
Local _cFilial   := oGetDad:aCols[oGetDad:nAt][aScan(oGetDad:aHeader,{|x| AllTrim(x[2]) == "FILIAL"})]
Local _cNum      := oGetDad:aCols[oGetDad:nAt][aScan(oGetDad:aHeader,{|x| AllTrim(x[2]) == "COTACAO"})]
Local _cProduto  := oGetDad:aCols[oGetDad:nAt][aScan(oGetDad:aHeader,{|x| AllTrim(x[2]) == "PRODUTO"})]
Local _cProposta := ""
Local _nResult   := 5 

Private l150Auto := .F.
Private _cItem     := oGetDad:aCols[oGetDad:nAt][aScan(oGetDad:aHeader,{|x| AllTrim(x[2]) == "ITEM"})]
Private _nQuant    := oGetDad:aCols[oGetDad:nAt][aScan(oGetDad:aHeader,{|x| AllTrim(x[2]) == "QUANTIDADE"})]

If !oGetDad:aCols[oGetDad:nAt][2] == oLegVerm
	Pergunte("MTA160",.F.)
	
	MV_PAR01 := 1
	MV_PAR02 := 2
	MV_PAR03 := 1
	MV_PAR04 := 2
	MV_PAR05 := 1
	MV_PAR06 := 2
	MV_PAR07 := 2
	MV_PAR08 := 5
	MV_PAR09 := 2
	MV_PAR10 := 2
	MV_PAR11 := 2
	MV_PAR12 := 2
	MV_PAR13 := 2
	MV_PAR14 := 0
	MV_PAR15 := "  "
	MV_PAR16 := "ZZ"
	MV_PAR17 := 1
	
	DbSelectArea("SC8")
	SC8->(dbOrderNickName("COTACNEW"))
	if dbseek(_cFilial+_cNum+_cItem)
		_cProposta := SC8->C8_NUMPRO
		_nResult := U_xA150Digita("SC8",SC8->(Recno()),2)
	endif

	If _nResult == Nil 
		_nResult == 0
	EndIf

	If _nResult == 0
		oDlgCotac:End()
		_nSavFolder := 2
	   Return .T.
	EndIf

	oDlgCotac:End()
	_nSavFolder := 2
Else
	msginfo("Cota็ใo com pedido de compra jแ gerado, nใo ้ permitido a altera็ใo deste registro.")
	Return .F.
EndIf

Return .T.



/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณ GJPExcPart บ Autor ณ Carlos A. Queiroz  บ Data ณ  19/05/15   บฑฑ
ฑฑฬออออออออออุออออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ Exclui um participante/fornecedor de uma Cotacao.            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ GJP Hotels & Resorts                                         บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
User Function GJPExcPart()

Local _cFilial   := oGetDad:aCols[oGetDad:nAt][aScan(oGetDad:aHeader,{|x| AllTrim(x[2]) == "FILIAL"})]
Local _cNum      := oGetDad:aCols[oGetDad:nAt][aScan(oGetDad:aHeader,{|x| AllTrim(x[2]) == "COTACAO"})]
Local _cProduto  := oGetDad:aCols[oGetDad:nAt][aScan(oGetDad:aHeader,{|x| AllTrim(x[2]) == "PRODUTO"})]
Local _cItem     := oGetDad:aCols[oGetDad:nAt][aScan(oGetDad:aHeader,{|x| AllTrim(x[2]) == "ITEM"})]
Local _cFornece  := ""
Local _cLoja     := ""
Local _cNomeForn := ""
Local _nParticip := 0
Local _cItemSC8  := ""

If !oGetDad:aCols[oGetDad:nAt][2] == oLegVerm
	
	If alltrim(oGetDad:aHeader[oGetDad:OBROWSE:COLPOS][2]) == "C8_PRECO"
		_cFornece  := substr(oGetDad:aHeader[oGetDad:OBROWSE:COLPOS][1],1,TamSX3("C8_FORNECE")[1])
		_cLoja     := substr(oGetDad:aHeader[oGetDad:OBROWSE:COLPOS][1],(TamSX3("C8_FORNECE")[1])+4,TamSX3("C8_LOJA")[1])
		_cNomeForn := AllTrim(Posicione("SA2",1,xFilial("SA2")+_cFornece+_cLoja,"A2_NREDUZ"))
	Else
		msgalert("Para excluir um participante, posicione o cursor no fornecedor que deseja excluir para determinado produto.")
		Return .F.
	EndIf
	
	// Inserido por Carlos Queiroz em 04/10/16 para tratar a exclusใo de um participante caso ele seja o ๚nico na cota็ใo que cont้m apenas 1 produto.
	dbselectarea("SC8")
	dbsetorder(1)
	If dbseek(_cFilial+_cNum)
		While SC8->(!EOF()) .and. (_cFilial+_cNum) == (SC8->C8_FILIAL+SC8->C8_NUM)
			_nParticip++
			SC8->(dbskip())
		EndDo
	EndIf
	
	If _nParticip == 1
		If msgyesno("Existe um ๚nico participante e sua exclusใo elimina a Cota็ใo com a SC retornando para status 'em aberto'. Deseja continuar este processo?")
			oGetDad:aCols[oGetDad:nAt][1] := oOk   // Marca a linha
			U_GJPExcItem()   					  // Exclui a Cota็ใo e a SC retorna o status para 'em aberto'
			Return .F.
		Else
			Return .F.
		EndIf
	EndIf
	
	///////////////////////////////////////////////////////////////////////
	//Inserido por Carlos Queiroz em 20/10/16
	dbselectarea("SC8")
	SC8->(dbOrderNickName("COTACNEW"))
	If dbseek(_cFilial+_cNum+_cItem+_cFornece+_cLoja)  	
		_nParticip := 0                                
		cQuery := " Select * from "+RetSqlName("SC8")+" SC8 "
		cQuery += " Where SC8.D_E_L_E_T_ <> '*' AND SC8.C8_FILIAL = '"+xFilial("SC8")+"' AND "
		cQuery += " SC8.C8_NUM = '"+ALLTRIM(_cNum)+"' AND SC8.C8_NUMSC = '"+ALLTRIM(SC8->C8_NUMSC)+"' AND SC8.C8_ITEMSC = '"+ALLTRIM(SC8->C8_ITEMSC)+"' "
		cQuery += " Order by SC8.C8_FILIAL, SC8.C8_NUM
		cQuery := ChangeQuery(cQuery)
		dbUseArea(.T., "TOPCONN", TCGenQry(,,cQuery), "SC8ITEM", .F., .T.)
		
		SC8ITEM->(dbgotop())
		
		While SC8ITEM->(!eof())
			If SC8ITEM->C8_NUMPRO <> '01'
				_nParticip++  
			EndIf
			SC8ITEM->(dbskip())
		EndDo
		SC8ITEM->(dbclosearea())		
		 
		If _nParticip > 0
			msgalert("Este participante estแ presente em um item gerado de uma 'Compra Dividida'."+chr(13)+chr(10)+"Para que ele seja eliminado, necessแrio clicar em 'Desfazer Divisใo' para depois excluir o participante.")
			Return .F.		
		EndIf
//////////////////
	dbselectarea("SC8")
	dbsetorder(1)
	//	 dbseek(_cFilial+_cNum+_cProduto+_cFornece+_cLoja)
	If dbseek(_cFilial+_cNum)
			While SC8->(!EOF()) .and. (_cFilial+_cNum) == (SC8->C8_FILIAL+SC8->C8_NUM)
				if !Empty(SC8->C8_NUMPED)
// 					msgalert("Pedido de Compra "+alltrim(SC8->C8_NUMPED)+" gerado para esta Cota็ใo e por isso nใo ้ mais possํvel excluir qualquer fornecedor "+alltrim(_cNomeForn)+" da Cota็ใo "+alltrim(_cNum)+".")
 					msgalert("Pedido de Compra "+alltrim(SC8->C8_NUMPED)+" gerado no item "+alltrim(SC8->C8_ITEM)+" e por isso nใo ้ mais possํvel excluir qualquer fornecedor da Cota็ใo "+alltrim(_cNum)+".")
					Return .F.
				endif
				SC8->(dbskip())
			EndDo		
	Else
		msgalert("Fornecedor nใo incluํdo na cota็ใo deste produto e por isso nใo poderแ ser excluํdo.")
		Return .F.
	Endif
////////////////					
		_nParticip := 0
		//		xWhile SC8->(!EOF()) .and. (_cFilial+_cNum/*+_cFornece+_cLoja*/) == (SC8->C8_FILIAL+SC8->C8_NUM/*+C8_FORNECE+C8_LOJA*/)
		//		xIf (_cFilial+_cNum+_cFornece+_cLoja) == (SC8->C8_FILIAL+SC8->C8_NUM+C8_FORNECE+C8_LOJA)
		//	        _cItemSC8 := SC8->C8_ITEM
		cQuery := " Select * from "+RetSqlName("SC8")+" SC8 "
		cQuery += " Where SC8.D_E_L_E_T_ <> '*' AND SC8.C8_FILIAL = '"+xFilial("SC8")+"' AND SC8.C8_NUMPED = '' AND "
		cQuery += " SC8.C8_NUM = '"+ALLTRIM(_cNum)+"' AND SC8.C8_ITEM = '"+ALLTRIM(_cItem)+"' "
		cQuery += " Order by SC8.C8_FILIAL, SC8.C8_NUM
		cQuery := ChangeQuery(cQuery)
		dbUseArea(.T., "TOPCONN", TCGenQry(,,cQuery), "SC8QUERY", .F., .T.)
		
		SC8QUERY->(dbgotop())
		
		While SC8QUERY->(!eof())
			_nParticip++
			SC8QUERY->(dbskip())
		EndDo
		SC8QUERY->(dbclosearea())

	dbselectarea("SC8")
	SC8->(dbOrderNickName("COTACNEW"))
	If dbseek(_cFilial+_cNum+_cItem+_cFornece+_cLoja)  	

		If _nParticip == 1
			If SC8->C8_NUMPRO <> '01'
				msgstop("Fornecedor nใo pode ser excluํdo decorrente de pertencer a uma 'Compra Dividida' e o saldo nใo ้ possํvel retornar ao item original devido a cria็ใo de Pedido de Compra.")
			Else
				If msgyesno("Existe um ๚nico participante e sua exclusใo elimina este item da Cota็ใo com a SC retornando para status 'em aberto'. Deseja continuar este processo?")
					For i:=1 to Len(oGetDad:aCols)
						oGetDad:aCols[i][1] := oNo
					Next i
					oGetDad:aCols[oGetDad:nAt][1] := oOk   // Marca a linha
					U_GJPExcItem()   					  // Exclui a Cota็ใo e a SC retorna o status para 'em aberto'
					Return .F.
				Else
					Return .F.
				EndIf
			EndIf
		ElseIf _nParticip >= 2
			If SC8->C8_NUMPRO <> '01'
				msgstop("Este participante estแ presente em um item gerado de uma 'Compra Dividida'. Para que ele seja eliminado, necessแrio clicar em 'Desfazer Divisใo' para depois excluir o participante.")
				Return .F.
				/*	  	For i:=1 to Len(oGetDad:aCols)
				oGetDad:aCols[i][1] == oNo
				Next i
				oGetDad:aCols[oGetDad:nAt][1] := oOk   // Marca a linha
				//		   U_GJPExcItem()   					  // Exclui a Cota็ใo e a SC retorna o status para 'em aberto'
				U_GJPDesDiv()    					  // Retorna o saldo para o produto original
				Return .F.
				*/
				
			EndIf
			
		EndIf
	EndIf	
	EndIf
	///////////////////////////////////////////////////////////////////////

	///////////////////////////////////////////////////////////////////////
	///////////////////////////////////////////////////////////////////////

	dbselectarea("SC8")
	dbsetorder(1)
	//	 dbseek(_cFilial+_cNum+_cProduto+_cFornece+_cLoja)
	If dbseek(_cFilial+_cNum)
			While SC8->(!EOF()) .and. (_cFilial+_cNum) == (SC8->C8_FILIAL+SC8->C8_NUM)
				if !Empty(SC8->C8_NUMPED)
 					msgalert("Pedido de Compra "+alltrim(SC8->C8_NUMPED)+" gerado no item "+alltrim(SC8->C8_ITEM)+" e por isso nใo ้ mais possํvel excluir qualquer fornecedor da Cota็ใo "+alltrim(_cNum)+".")
					Return .F.
				endif
				SC8->(dbskip())
			EndDo		
	Else
		msgalert("Fornecedor nใo incluํdo na cota็ใo deste produto e por isso nใo poderแ ser excluํdo.")
		Return .F.
	Endif
	///////////////////////////////////////////////////////////////////////
	///////////////////////////////////////////////////////////////////////





	dbselectarea("SC8")
	dbsetorder(1)
	//	 dbseek(_cFilial+_cNum+_cProduto+_cFornece+_cLoja)
	If dbseek(_cFilial+_cNum+_cFornece+_cLoja)
		//		&&While SC8->(!EOF()) .and. (_cFilial+_cNum+_cProduto+_cFornece+_cLoja) == (SC8->C8_FILIAL+SC8->C8_NUM+SC8->C8_PRODUTO+C8_FORNECE+C8_LOJA)
		If msgyesno("Deseja excluir o fornecedor "+alltrim(_cFornece)+" - "+alltrim(_cLoja)+" "+alltrim(_cNomeForn)+" pertencente a Cota็ใo "+alltrim(_cNum)+"?")
			While SC8->(!EOF()) .and. (_cFilial+_cNum+_cFornece+_cLoja) == (SC8->C8_FILIAL+SC8->C8_NUM+SC8->C8_FORNECE+SC8->C8_LOJA)
				//			If _cItem == SC8->C8_ITEM
				if Empty(SC8->C8_NUMPED)
					// msgyesno("Deseja excluir o fornecedor "+alltrim(_cFornece)+" - "+alltrim(_cLoja)+" "+alltrim(_cNomeForn)+" do Produto "+alltrim(_cProduto)+" - "+AllTrim(Posicione("SB1",1,xFilial("SB1")+_cProduto,"B1_DESC"))+" pertencente a Cota็ใo "+alltrim(_cNum)+"?")
					
					Reclock("SC8",.F.)
					SC8->(dbDelete())
					SC8->(msunlock())
				else
					msgalert("Pedido de Compra "+alltrim(SC8->C8_NUMPED)+" gerado, nใo ้ possํvel excluir o fornecedor "+alltrim(_cNomeForn)+" da Cota็ใo no item "+alltrim(SC8->C8_ITEM)+" Produto "+alltrim(_cProduto)+" - "+AllTrim(Posicione("SB1",1,xFilial("SB1")+_cProduto,"B1_DESC"))+".")
				endif
				//			EndIf
				SC8->(dbskip())
			EndDo
		Else
			msginfo("Participante nใo excluํdo!!!")
			Return .F.
		EndIf
		
	Else
		msgalert("Fornecedor nใo incluํdo na cota็ใo deste produto e por isso nใo poderแ ser excluํdo.")
		Return .F.
	Endif
	
	oDlgCotac:End()
	_nSavFolder := 2
Else
	msginfo("Cota็ใo com pedido de compra jแ gerado, nใo ้ permitido a altera็ใo deste registro.")
	Return .F.
EndIf

Return .T.


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณ GJPExcItem บ Autor ณ Carlos A. Queiroz  บ Data ณ  19/05/15   บฑฑ
ฑฑฬออออออออออุออออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ Exclui o item marcado da Cotacao posicionada.                บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ GJP Hotels & Resorts                                         บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
User Function GJPExcItem()
Local _cFilial   := "" //oGetDad:aCols[oGetDad:nAt][aScan(oGetDad:aHeader,{|x| AllTrim(x[2]) == "FILIAL"})]
Local _cNum      := "" //oGetDad:aCols[oGetDad:nAt][aScan(oGetDad:aHeader,{|x| AllTrim(x[2]) == "COTACAO"})]
Local _cProduto  := "" //oGetDad:aCols[oGetDad:nAt][aScan(oGetDad:aHeader,{|x| AllTrim(x[2]) == "PRODUTO"})]
Local _cItem     := "" //oGetDad:aCols[oGetDad:nAt][aScan(oGetDad:aHeader,{|x| AllTrim(x[2]) == "ITEM"})]
Local _nQuant    := 0  //oGetDad:aCols[oGetDad:nAt][aScan(oGetDad:aHeader,{|x| AllTrim(x[2]) == "QUANTIDADE"})]
Local _cQuery    := ""
Local lValida    := .F.
Local lAtualizou := .F.
Local _cItemRec  := ""
Local lContinua  := .F.
Local _aExcItens := {}
Local _nCount    := 0

For i:=1 to Len(oGetDad:aCols)
	If oGetDad:aCols[i][1] == oOk
		lContinua := .T.
		aAdd(_aExcItens,{i,oGetDad:aCols[i][aScan(oGetDad:aHeader,{|x| AllTrim(x[2]) == "FILIAL"})],;
		oGetDad:aCols[i][aScan(oGetDad:aHeader,{|x| AllTrim(x[2]) == "COTACAO"})],oGetDad:aCols[i][aScan(oGetDad:aHeader,{|x| AllTrim(x[2]) == "PRODUTO"})],; 
		oGetDad:aCols[i][aScan(oGetDad:aHeader,{|x| AllTrim(x[2]) == "ITEM"})],oGetDad:aCols[i][aScan(oGetDad:aHeader,{|x| AllTrim(x[2]) == "C8_NUMSC"})]})
	EndIf
Next i

If lContinua
	aSort(_aExcItens,,, { |x,y| x[2]+x[3]+x[4]+x[5] < y[2]+y[3]+y[4]+y[5] } )
	For i:=1 to Len(_aExcItens)
		DbSelectArea("SC8")
		SC8->(dbOrderNickName("COTACNEW"))
		If dbseek(_aExcItens[i][2]+_aExcItens[i][3]+_aExcItens[i][5])
			_nCount := 0
			cQuery := " Select SC8.* from "+RetSqlName("SC8")+" SC8 "
			cQuery += " Where SC8.D_E_L_E_T_ <> '*' AND SC8.C8_FILIAL = '"+_aExcItens[i][2]+"' AND SC8.C8_NUM = '"+_aExcItens[i][3]+"' AND "
			cQuery += " SC8.C8_NUMSC = '"+_aExcItens[i][6]+"' AND SC8.C8_PRODUTO = '"+_aExcItens[i][4]+"' AND SC8.C8_ITEMSC = '"+SC8->C8_ITEMSC+"'AND SC8.C8_NUMPED = ''"
			cQuery += " ORDER BY SC8.C8_FILIAL, SC8.C8_NUM, SC8.C8_ITEM, SC8.C8_PRODUTO, SC8.C8_NUMSC
			cQuery := ChangeQuery(cQuery)
			dbUseArea(.T., "TOPCONN", TCGenQry(,,cQuery), "EXCSC8", .F., .T.)
			dbselectarea("EXCSC8")
			While EXCSC8->(!EOF())
				If _aExcItens[i][5] <> EXCSC8->C8_ITEM
					_nCount++    
				EndIf
				EXCSC8->(dbskip())
			EndDo
			EXCSC8->(dbclosearea())
			If _nCount > 0
				msginfo("Item "+_aExcItens[i][5]+" da Cota็ใo "+_aExcItens[i][3]+" nใo pode ser excluํdo decorrente de existir itens divididos em aberto. Desmarque o produto para prosseguir caso deseje excluir outros itens ou clique na op็ใo 'Desfazer Divisใo' para a exclusใo ser permitida." )
				Return .F.
			EndIf
		EndIf
	Next i
EndIf

If lContinua
	If msgyesno("Deseja excluir o(s) produto(s) selecionado(s)?")
		
		For i:=1 to Len(oGetDad:aCols)
			If oGetDad:aCols[i][1] == oOk
				_cFilial   := oGetDad:aCols[i][aScan(oGetDad:aHeader,{|x| AllTrim(x[2]) == "FILIAL"})]
				_cNum      := oGetDad:aCols[i][aScan(oGetDad:aHeader,{|x| AllTrim(x[2]) == "COTACAO"})]
				_cProduto  := oGetDad:aCols[i][aScan(oGetDad:aHeader,{|x| AllTrim(x[2]) == "PRODUTO"})]
				_cItem     := oGetDad:aCols[i][aScan(oGetDad:aHeader,{|x| AllTrim(x[2]) == "ITEM"})]
				_nQuant    := oGetDad:aCols[i][aScan(oGetDad:aHeader,{|x| AllTrim(x[2]) == "QUANTIDADE"})]
				
				dbselectarea("SC8")
				dbsetorder(3)
				If dbseek(_cFilial+_cNum+_cProduto)
					if Empty(SC8->C8_NUMPED)
						
						While SC8->(!EOF())
							If _cFilial == SC8->C8_FILIAL .and. _cNum == SC8->C8_NUM .and. _cProduto == SC8->C8_PRODUTO .and. SC8->C8_ITEM == _cItem
								
								cQuery := " Select r_e_c_n_o_ C1_RECNO from "+RetSqlName("SC1")+" "
								cQuery += " Where D_E_L_E_T_ <> '*' AND C1_FILIAL = '"+SC8->C8_FILIAL+"' AND C1_NUM = '"+SC8->C8_NUMSC+"' AND C1_ITEM = '"+SC8->C8_ITEMSC+"'"
								
								cQuery := ChangeQuery(cQuery)
								dbUseArea(.T., "TOPCONN", TCGenQry(,,cQuery), "QRYSC1", .F., .T.)
								
								// verificar se o item existem outras SC8 para lim
								If QRYSC1->(!EOF())
									SC1->(dbgoto(QRYSC1->C1_RECNO))
									RecLock("SC1",.F.)
									SC1->C1_COTACAO := ""
									SC1->C1_QUJE    := 0
									SC1->C1_QUJE2   := 0
									SC1->C1_FORNECE := ""
									SC1->C1_LOJA    := ""
									SC1->C1_PEDIDO  := ""
									SC1->C1_ITEMPED := ""									
									SC1->(msunlock())
								EndIf
								QRYSC1->(dbclosearea())
								
								Reclock("SC8",.F.)
								SC8->(dbDelete())
								SC8->(msunlock())
							EndIf
							SC8->(dbskip())
						EndDo
					else
						msgalert("Pedido de Compra "+alltrim(SC8->C8_NUMPED)+" gerado, nใo ้ possํvel excluir o produto "+alltrim(_cProduto)+" da Cota็ใo "+alltrim(_cFilial)+" - "+alltrim(_cNum)+".")
					endif
					
				Endif
				
			EndIf
		Next i
		
		oDlgCotac:End()
		_nSavFolder := 2
	Else
		msginfo("Produto nใo excluํdo!!!")
		Return .F.
	EndIf
Else
	msginfo("Necessแrio marcar o item que deseja efetuar a exclusใo.")	
EndIf

Return .T.


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณ GJPInfForn บ Autor ณ Carlos A. Queiroz  บ Data ณ  19/05/15   บฑฑ
ฑฑฬออออออออออุออออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ Interface com informacoes complementares a serem preenchidas บฑฑ
ฑฑบ          ณ para o fornecedor.                                           บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ GJP Hotels & Resorts                                         บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
User Function xGJPInfForn()
Local aInfo     := {}
Local aPosObj   := {}
Local aObjects  := {}
Local aSize     := MsAdvSize()
Local oDlgInf
Local nOpcA     := 0
Local oSay1, oSay2, oSay3, oSay4, oSay5
Local aHeader3 := {}
Local aCols3   := {}
Local _cFilial   := oGetDad:aCols[oGetDad:nAt][aScan(oGetDad:aHeader,{|x| AllTrim(x[2]) == "FILIAL"})]
Local _cNum      := oGetDad:aCols[oGetDad:nAt][aScan(oGetDad:aHeader,{|x| AllTrim(x[2]) == "COTACAO"})]
Local _cProduto  := oGetDad:aCols[oGetDad:nAt][aScan(oGetDad:aHeader,{|x| AllTrim(x[2]) == "PRODUTO"})]
Local _cItem     := oGetDad:aCols[oGetDad:nAt][aScan(oGetDad:aHeader,{|x| AllTrim(x[2]) == "ITEM"})]
Local _cFornece  := ""//substr(oGetDad:aHeader[oGetDad:nAt][oGetDad:OBROWSE:COLPOS],1,TamSX3("C8_FORNECE")[1])
Local _cLoja     := ""//substr(oGetDad:aHeader[oGetDad:nAt][oGetDad:OBROWSE:COLPOS],13,TamSX3("C8_LOJA")[1])
Local _cNomeForn := ""
Local oGetDad1
Local oObj1
Local oObj2
Local oObj3
Local oObj4
Local oObj5
Local oObj6
Local oObj7
Local aPosGet	 := {}
Local l150Visual:= .F.
Local aComboInf    := CarregaTipoFrete()

Private oFolderInf
Private aFolderInf := {"Informa็๕es complementares do Fornecedor para a Cota็ใo"}
Private l150Inclui  := .F.
Private a150Var   := {0,0,0,0,0,0,0,0,0,0,0,0,0,0,0}
Private c150Frete  := "" //If(l150Inclui,"C-CIF",RetTipoFrete(SC8->C8_TPFRETE))
Private nMoedaCot  := 0  //If(l150Inclui,1,Max(SC8->C8_MOEDA,1))
Private _nPrazo     := 0
Private _nDesconto  := 0    
Private _cCondPagto := ""
Private _cDescrCond := ""
Private oObj8

If !oGetDad:aCols[oGetDad:nAt][2] == oLegVerm
	
	If alltrim(oGetDad:aHeader[oGetDad:OBROWSE:COLPOS][2]) == "C8_PRECO"
		_cFornece  := substr(oGetDad:aHeader[oGetDad:OBROWSE:COLPOS][1],1,TamSX3("C8_FORNECE")[1])
		_cLoja     := substr(oGetDad:aHeader[oGetDad:OBROWSE:COLPOS][1],(TamSX3("C8_FORNECE")[1])+4,TamSX3("C8_LOJA")[1])
		_cNomeForn := AllTrim(Posicione("SA2",1,xFilial("SA2")+_cFornece+_cLoja,"A2_NREDUZ"))
	Else
		msgalert("Para alterar as informa็๕es de um fornecedor, posicione o cursor no fornecedor que deseja complementar os dados de determinado produto.","Posicionar em um Fornecedor")
		Return .F.
	EndIf
	
//	dbselectarea("SC8")
//	dbsetorder(3)
//	xIf dbseek(_cFilial+_cNum+_cProduto+_cFornece+_cLoja)
	DbSelectArea("SC8")
	SC8->(dbOrderNickName("COTACNEW"))
	If dbseek(_cFilial+_cNum+_cItem+_cFornece+_cLoja)
		c150Frete        := If(l150Inclui,"C-CIF",RetTipoFrete(SC8->C8_TPFRETE))
		nMoedaCot        := If(l150Inclui,1,Max(SC8->C8_MOEDA,1))
		a150Var[FRETE]   := SC8->C8_VALFRE
		a150Var[SEGURO]  := SC8->C8_SEGURO
		a150Var[VALDESP] := SC8->C8_DESPESA
		_cCondPagto      := SC8->C8_COND                                  
		_cDescrCond		 := AllTrim(Posicione("SE4",1,xFilial("SB1")+_cCondPagto,"E4_DESCRI"))
		_nPrazo          := Iif(!Empty(SC8->C8_PRAZO),SC8->C8_PRAZO,0)
		_nDesconto       := SC8->C8_VLDESC
	Else
		msginfo("Fornecedor nใo pertence a esta Cota็ใo.")
		Return .T.
	EndIf
	
	aAdd( aObjects, { 315, 20, .T., .T. } )
	aInfo := { aSize[ 1 ], aSize[ 2 ], aSize[ 3 ], aSize[ 4 ], 3, 3 }
	aPosObj := MsObjSize( aInfo, aObjects)
	
	aPosGet := MsObjGetPos(aSize[3]-aSize[1],305,;
	{{10,40,95,140,200,222,268,240},;
	{10,40,111,140,223,268,63},;
	{5,70,160,205,295},;
	{6,34,200,215},;
	{6,34,80,113,153,178},;
	{6,34,245,268,260},;
	{10,50,150,190,120},;
	{273,130,190},;
	{8,45,73,103,139,167,190,225,253},;
	{144,190,144,190,289,293},;
	{142,293,140},;
	{9,47,188,148,9,146} } )
		
	DEFINE MSDIALOG oDlgInf TITLE "GJP Hotels & Resort" From aSize[7]-200,0 to aSize[6]-200,aSize[5]-200 of oMainWnd PIXEL Style DS_MODALFRAME
	
	oFolderInf := TFolder():New(aPosObj[1,1], aPosObj[1,2], aFolderInf, , oDlgInf, 1, , , .T.,.F.,aPosObj[1,4]-100,aPosObj[1,3]-aPosObj[1,1],)
	
	//aadd(aObj,Array(5))
	@ 10,aPosGet[7,1] SAY OemToAnsi("Filial: "+alltrim(_cFilial)) Of oFolderInf:aDialogs[1] PIXEL SIZE 155 ,9 // "Tp. Frete"
	@ 25,aPosGet[7,1] SAY OemToAnsi("Cota็ใo: "+alltrim(_cNum)) Of oFolderInf:aDialogs[1] PIXEL SIZE 155 ,9 // "Tp. Frete"
	@ 40,aPosGet[7,1] SAY OemToAnsi("Produto: "+alltrim(_cProduto)+" - Descri็ใo: "+AllTrim(Posicione("SB1",1,xFilial("SB1")+_cProduto,"B1_DESC"))) Of oFolderInf:aDialogs[1] PIXEL SIZE 155 ,9 // "Tp. Frete"
	@ 55,aPosGet[7,1] SAY OemToAnsi("Fornecedor "+alltrim(_cFornece)+" - Loja: "+alltrim(_cLoja)+ " - "+alltrim(_cNomeForn)) Of oFolderInf:aDialogs[1] PIXEL SIZE 155 ,9 // "Tp. Frete"
//	@ 70,aPosGet[7,1] SAY OemToAnsi("Condi็ใo de Pagto: "+alltrim(_cCondPagto)+" - Descri็ใo: "+AllTrim(Posicione("SE4",1,xFilial("SB1")+_cCondPagto,"E4_DESCRI"))) Of oFolderInf:aDialogs[1] PIXEL SIZE 155 ,9 // "Tp. Frete"
	@ 78,11  TO 80 ,aPosGet[8,1]-40 LABEL '' OF oFolderInf:aDialogs[1] PIXEL
    /*
 	@ 109,aPosGet[7,1] SAY OemToAnsi("Prazo") Of oFolderInf:aDialogs[1] PIXEL SIZE 42 ,9 // "Prazo"
	@ 108,aPosGet[7,2] MSGET oObj6 VAR _nPrazo Picture PesqPict('SC8','C8_PRAZO',14,nMoedaCot) OF oFolderInf:aDialogs[1] PIXEL WHEN !l150Visual VALID Positivo() SIZE 80,9
	@ 109,aPosGet[7,3] SAY OemToAnsi("Desconto") Of oFolderInf:aDialogs[1] PIXEL SIZE 35 ,9 // "Desconto"
	@ 108,aPosGet[7,4] MSGET oObj7 VAR _nDesconto  Picture PesqPict('SC8','C8_VLDESC',14,nMoedaCot) OF oFolderInf:aDialogs[1] PIXEL WHEN !l150Visual VALID Positivo() SIZE 80,9
    */
	/*@ 129,aPosGet[7,1] SAY OemToAnsi("Tp. Frete") Of oFolderInf:aDialogs[1] PIXEL SIZE 35 ,9 // "Tp. Frete"
	@ 127,aPosGet[7,2] MSCOMBOBOX oObj1 VAR c150Frete ITEMS aComboInf ON CHANGE A150VldCombo(c150Frete,@a150Var) .And. A150AtuRef("NF_FRETE",a150Var[FRETE]) WHEN !l150Visual VALID CalcTot() SIZE 65 ,50 OF oFolderInf:aDialogs[1] PIXEL
	@ 129,aPosGet[7,3] SAY OemToAnsi("Valor do Frete") Of oFolderInf:aDialogs[1] PIXEL SIZE 35 ,9 //"Valor do Frete"
	@ 128,aPosGet[7,4] MSGET oObj2 VAR a150Var[FRETE]  Picture PesqPict('SC8','C8_VALFRE',14,nMoedaCot) OF oFolderInf:aDialogs[1] PIXEL WHEN !l150Visual .And. c150Frete=="C-CIF" VALID Positivo() .AND. A150AtuRef("NF_FRETE",a150Var[FRETE]) .and. CalcTot() SIZE 80,9
	@ 149,aPosGet[7,1] SAY OemToAnsi("Despesas") Of oFolderInf:aDialogs[1] PIXEL SIZE 42 ,9 // "Despesas"
	@ 148,aPosGet[7,2] MSGET oObj3 VAR a150Var[VALDESP] Picture PesqPict('SC8','C8_VALFRE',14,nMoedaCot) OF oFolderInf:aDialogs[1] PIXEL WHEN !l150Visual VALID Positivo() .AND. A150AtuRef("NF_DESPESA",a150Var[VALDESP]) .and. CalcTot() SIZE 80,9
	@ 149,aPosGet[7,3] SAY OemToAnsi("Seguro") Of oFolderInf:aDialogs[1] PIXEL SIZE 35 ,9 // "Seguro"
	@ 148,aPosGet[7,4] MSGET oObj4 VAR a150Var[SEGURO]  Picture PesqPict('SC8','C8_VALFRE',14,nMoedaCot) OF oFolderInf:aDialogs[1] PIXEL WHEN !l150Visual VALID Positivo() .AND. A150AtuRef("NF_SEGURO",a150Var[SEGURO]) .and. CalcTot() SIZE 80,9
	@ 168,11  TO 170 ,aPosGet[8,1]-40 LABEL '' OF oFolderInf:aDialogs[1] PIXEL
	@ 188,aPosGet[7,5] SAY OemToAnsi("Total ( Frete+Despesas)") Of oFolderInf:aDialogs[1] PIXEL SIZE 65 ,09 // "Total ( Frete+Despesas)"
	a150Var[TOTF3]:=a150Var[FRETE]+a150Var[VALDESP]+a150Var[SEGURO]
	@ 187,aPosGet[8,3] MSGET oObj5 VAR a150Var[TOTF3]  Picture PesqPict('SC8','C8_VALFRE',14,nMoedaCot) OF oFolderInf:aDialogs[1] PIXEL WHEN .F. SIZE 80,9
    */
	
	@ 94,aPosGet[7,1] SAY OemToAnsi("Tp. Frete") Of oFolderInf:aDialogs[1] PIXEL SIZE 35 ,9 // "Tp. Frete"
	@ 91,aPosGet[7,2] MSCOMBOBOX oObj1 VAR c150Frete ITEMS aComboInf ON CHANGE A150VldCombo(c150Frete,@a150Var) .And. A150AtuRef("NF_FRETE",a150Var[FRETE]) WHEN !l150Visual VALID CalcTot() SIZE 65 ,50 OF oFolderInf:aDialogs[1] PIXEL
	@ 94,aPosGet[7,3] SAY OemToAnsi("Valor do Frete") Of oFolderInf:aDialogs[1] PIXEL SIZE 35 ,9 //"Valor do Frete"
	@ 93,aPosGet[7,4] MSGET oObj2 VAR a150Var[FRETE]  Picture PesqPict('SC8','C8_VALFRE',14,nMoedaCot) OF oFolderInf:aDialogs[1] PIXEL WHEN !l150Visual .And. c150Frete=="C-CIF" VALID Positivo() .AND. A150AtuRef("NF_FRETE",a150Var[FRETE]) .and. CalcTot() SIZE 80,9
	@ 114,aPosGet[7,1] SAY OemToAnsi("Despesas") Of oFolderInf:aDialogs[1] PIXEL SIZE 42 ,9 // "Despesas"
	@ 113,aPosGet[7,2] MSGET oObj3 VAR a150Var[VALDESP] Picture PesqPict('SC8','C8_VALFRE',14,nMoedaCot) OF oFolderInf:aDialogs[1] PIXEL WHEN !l150Visual VALID Positivo() .AND. A150AtuRef("NF_DESPESA",a150Var[VALDESP]) .and. CalcTot() SIZE 80,9
	@ 114,aPosGet[7,3] SAY OemToAnsi("Seguro") Of oFolderInf:aDialogs[1] PIXEL SIZE 35 ,9 // "Seguro"
	@ 113,aPosGet[7,4] MSGET oObj4 VAR a150Var[SEGURO]  Picture PesqPict('SC8','C8_VALFRE',14,nMoedaCot) OF oFolderInf:aDialogs[1] PIXEL WHEN !l150Visual VALID Positivo() .AND. A150AtuRef("NF_SEGURO",a150Var[SEGURO]) .and. CalcTot() SIZE 80,9
	@ 134,11  TO 136 ,aPosGet[8,1]-40 LABEL '' OF oFolderInf:aDialogs[1] PIXEL
	@ 148,aPosGet[7,5] SAY OemToAnsi("Total ( Frete+Despesas)") Of oFolderInf:aDialogs[1] PIXEL SIZE 65 ,09 // "Total ( Frete+Despesas)"
	a150Var[TOTF3]:=a150Var[FRETE]+a150Var[VALDESP]+a150Var[SEGURO]
	@ 147,aPosGet[8,3] MSGET oObj5 VAR a150Var[TOTF3]  Picture PesqPict('SC8','C8_VALFRE',14,nMoedaCot) OF oFolderInf:aDialogs[1] PIXEL WHEN .F. SIZE 80,9

	@ 168,11  TO 170 ,aPosGet[8,1]-40 LABEL '' OF oFolderInf:aDialogs[1] PIXEL

 	@ 189,aPosGet[7,1] SAY OemToAnsi("Condi็ใo de Pagamento") Of oFolderInf:aDialogs[1] PIXEL SIZE 62 ,9 // "Prazo"
	@ 188,aPosGet[7,2] MSGET oObj6 VAR _cCondPagto Picture PesqPict('SC8','C8_COND') F3 CpoRetF3("C8_COND") OF oFolderInf:aDialogs[1] PIXEL WHEN !l150Visual VALID GJPCondPag() SIZE 80,9
	@ 189,aPosGet[7,3] SAY OemToAnsi("Desconto") Of oFolderInf:aDialogs[1] PIXEL SIZE 35 ,9 // "Desconto"
	@ 188,aPosGet[7,4] MSGET oObj7 VAR _nDesconto  Picture PesqPict('SC8','C8_VLDESC',14,nMoedaCot) OF oFolderInf:aDialogs[1] PIXEL WHEN !l150Visual VALID Positivo() SIZE 80,9
 	
 	@ 205,aPosGet[7,1] SAY OemToAnsi("Descri็ใo:") Of oFolderInf:aDialogs[1] PIXEL SIZE 122 ,9 // Descri็ใo
	@ 204,aPosGet[7,2] MSGET oObj8 VAR _cDescrCond Picture PesqPict('SC8','E4_DESCRI') OF oFolderInf:aDialogs[1] PIXEL WHEN l150Visual SIZE 80,9
	
	ACTIVATE MSDIALOG oDlgInf ON INIT EnchoiceBar(oDlgInf,{||nOpcA:=1,oDlgInf:End()},{||oDlgInf:End()},,) CENTER
	
	If nOpcA == 1
//		dbselectarea("SC8")
//		dbsetorder(3)
//		xIf dbseek(_cFilial+_cNum+_cProduto+_cFornece+_cLoja)
		DbSelectArea("SC8")
		SC8->(dbOrderNickName("COTACNEW"))
		If dbseek(_cFilial+_cNum+_cItem+_cFornece+_cLoja)
			Begin Transaction
			Reclock("SC8",.F.)
			SC8->C8_VALFRE  := a150Var[FRETE]
			SC8->C8_TPFRETE := substr(c150Frete,1,1)
			SC8->C8_SEGURO  := a150Var[SEGURO]
			SC8->C8_DESPESA := a150Var[VALDESP]
//			SC8->C8_PRAZO   := _nPrazo
			SC8->C8_VLDESC  := _nDesconto
			SC8->C8_COND    := _cCondPagto
			SC8->(msunlock())
			End Transaction
			msginfo("Informa็๕es do fornecedor "+alltrim(_cFornece)+" - "+alltrim(_cLoja)+" "+alltrim(_cNomeForn)+" atualizadas com sucesso.")
		EndIf
	EndIf
	
Else
	msginfo("Cota็ใo com pedido de compra jแ gerado, nใo ้ permitido a altera็ใo deste registro.")
	Return .F.
EndIf

Return .T.



/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณGJP130COT บAutor  ณMicrosiga           บ Data ณ  06/25/15   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ                                                            บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ AP                                                        บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
Static Function GJPCondPag()

_cDescrCond := AllTrim(Posicione("SE4",1,xFilial("SB1")+_cCondPagto,"E4_DESCRI"))
oObj8:Refresh()

Return .T.

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณ  CalcTot   บ Autor ณ Carlos A. Queiroz  บ Data ณ  19/05/15   บฑฑ
ฑฑฬออออออออออุออออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ Calcula os valores contidos na interface de Informacoes  do  บฑฑ
ฑฑบ          ณ fornecedor.                                                  บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ GJP Hotels & Resorts                                         บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
Static Function CalcTot()
a150Var[TOTF3] := a150Var[FRETE]+a150Var[VALDESP]+a150Var[SEGURO]
Return .T.


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณ GJPComDiv  บ Autor ณ Carlos A. Queiroz  บ Data ณ  19/05/15   บฑฑ
ฑฑฬออออออออออุออออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ Executa a Compra Dividida desmembrando a quantidade de um    บฑฑ
ฑฑบ          ณ produto em novos itens.                                      บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ GJP Hotels & Resorts                                         บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
User Function GJPComDiv()

Local aInfo     := {}
Local aPosObj   := {}
Local aObjects  := {}
Local aSize     := MsAdvSize()
Local aPosGet	 := {}
Local oDlgDiv
Local nOpcA     := 0
Local _cFilial   := oGetDad:aCols[oGetDad:nAt][aScan(oGetDad:aHeader,{|x| AllTrim(x[2]) == "FILIAL"})]
Local _cNum      := oGetDad:aCols[oGetDad:nAt][aScan(oGetDad:aHeader,{|x| AllTrim(x[2]) == "COTACAO"})]
Local _cProduto  := oGetDad:aCols[oGetDad:nAt][aScan(oGetDad:aHeader,{|x| AllTrim(x[2]) == "PRODUTO"})]
Local _cItem     := oGetDad:aCols[oGetDad:nAt][aScan(oGetDad:aHeader,{|x| AllTrim(x[2]) == "ITEM"})]
Local _cFornece  := "" //substr(oGetDad:aHeader[oGetDad:nAt][oGetDad:OBROWSE:COLPOS],1,TamSX3("C8_FORNECE")[1])
Local _cLoja     := "" //substr(oGetDad:aHeader[oGetDad:nAt][oGetDad:OBROWSE:COLPOS],13,TamSX3("C8_LOJA")[1])
Local _cNomeForn := ""
Local _cCondPagto := ""
Local oObj1
Local oObj2
Local oObj3
Local oObj4
Local oObj5
Local _aSC8       := {}
Local nCompDiv    := 0

Private nMoedaCot  :=  0
Private _nQuantOri := 0
Private _nQtdNew   := 0
Private _nQuantRem := 0
Private _nRecno    := 0
Private oFolderDiv
Private aFolderDiv := {"Compra Dividida"}

For i:=1 to Len(oGetDad:aCols)
	If oGetDad:aCols[i][1] == oOk
		nCompDiv++
		_cFilial   := oGetDad:aCols[i][aScan(oGetDad:aHeader,{|x| AllTrim(x[2]) == "FILIAL"})]
		_cNum      := oGetDad:aCols[i][aScan(oGetDad:aHeader,{|x| AllTrim(x[2]) == "COTACAO"})]
		_cProduto  := oGetDad:aCols[i][aScan(oGetDad:aHeader,{|x| AllTrim(x[2]) == "PRODUTO"})]
		_cItem     := oGetDad:aCols[i][aScan(oGetDad:aHeader,{|x| AllTrim(x[2]) == "ITEM"})]
	EndIf
Next i

If nCompDiv == 1
	
	cQuery := " Select SC8.R_E_C_N_O_ C8RECNO,SC8.* from "+RetSqlName("SC8")+" SC8 "
	cQuery += " Where SC8.D_E_L_E_T_ <> '*' AND SC8.C8_FILIAL = '"+_cFilial+"' AND SC8.C8_NUM = '"+_cNum+"' AND SC8.C8_ITEM = '"+_cItem+"' AND SC8.C8_PRODUTO = '"+_cProduto+"'"
	cQuery += " ORDER BY SC8.C8_FILIAL, SC8.C8_NUM, SC8.C8_ITEM, SC8.C8_PRODUTO, SC8.C8_NUMPRO DESC
	cQuery := ChangeQuery(cQuery)
	dbUseArea(.T., "TOPCONN", TCGenQry(,,cQuery), "QRYSC8", .F., .T.)
	
	cQuery1 := " Select MAX(C8_ITEM) ITEM, MAX(C8_IDENT) IDENT from "+RetSqlName("SC8")+" "
	cQuery1 += " Where D_E_L_E_T_ <> '*' AND C8_FILIAL = '"+_cFilial+"' AND C8_NUM = '"+_cNum+"' "
	cQuery1 := ChangeQuery(cQuery1)
	dbUseArea(.T., "TOPCONN", TCGenQry(,,cQuery1), "QRYMAX", .F., .T.)
	
	If !empty(QRYSC8->C8_NUMPED)
		msgstop("Existe pedido de venda atrelado a cota็ใo e nใo serแ permitido a divisใo da quantidade do item.")
		QRYSC8->(dbclosearea())
		QRYMAX->(dbclosearea())
		Return .F.
	EndIf
	
	dbselectarea("QRYSC8")
	QRYSC8->(dbgotop())
	If QRYSC8->(!EOF())
		_nRecno     := QRYSC8->C8RECNO
		_nQuantOri  := QRYSC8->C8_QUANT
		_cNumPro    := QRYSC8->C8_NUMPRO
		nMoedaCot   := QRYSC8->C8_MOEDA
	EndIf
	
	dbselectarea("QRYMAX")
	QRYMAX->(dbgotop())
	If QRYMAX->(!EOF())
		_cItemMax := QRYMAX->ITEM
	EndIf
	
	QRYSC8->(dbclosearea())
	QRYMAX->(dbclosearea())
	
	aAdd( aObjects, { 315, 20, .T., .T. } )
	aInfo := { aSize[ 1 ], aSize[ 2 ], aSize[ 3 ], aSize[ 4 ], 3, 3 }
	aPosObj := MsObjSize( aInfo, aObjects)
	
	aPosGet := MsObjGetPos(aSize[3]-aSize[1],305,;
	{{10,40,95,140,200,222,268,240},;
	{10,40,111,140,223,268,63},;
	{5,70,160,205,295},;
	{6,34,200,215},;
	{6,34,80,113,153,178},;
	{6,34,245,268,260},;
	{10,50,150,190,120},;
	{273,130,190},;
	{8,45,73,103,139,167,190,225,253},;
	{144,190,144,190,289,293},;
	{142,293,140},;
	{9,47,188,148,9,146} } )
	
	
	DEFINE MSDIALOG oDlgDiv TITLE "GJP Hotels & Resort" From aSize[7]-200,0 to aSize[6]-420,aSize[5]-200 of oMainWnd PIXEL Style DS_MODALFRAME
	
	oFolderDiv := TFolder():New(aPosObj[1,1], aPosObj[1,2], aFolderDiv, , oDlgDiv, 1, , , .T.,.F.,aPosObj[1,4]-100,aPosObj[1,3]-aPosObj[1,1]-120,)
	
	@ 10,aPosGet[7,1] SAY OemToAnsi("Filial: "+alltrim(_cFilial)) Of oFolderDiv:aDialogs[1] PIXEL SIZE 155 ,9 // "Tp. Frete"
	@ 25,aPosGet[7,1] SAY OemToAnsi("Cota็ใo: "+alltrim(_cNum)) Of oFolderDiv:aDialogs[1] PIXEL SIZE 155 ,9 // "Tp. Frete"
	@ 40,aPosGet[7,1] SAY OemToAnsi("Produto: "+alltrim(_cProduto)+" - Descri็ใo: "+AllTrim(Posicione("SB1",1,xFilial("SB1")+_cProduto,"B1_DESC"))) Of oFolderDiv:aDialogs[1] PIXEL SIZE 155 ,9 // "Tp. Frete"
	@ 58,11  TO 60 ,aPosGet[8,1]-40 LABEL '' OF oFolderDiv:aDialogs[1] PIXEL
	@ 79,aPosGet[7,1] SAY OemToAnsi("Quantidade Original") Of oFolderDiv:aDialogs[1] PIXEL SIZE 70 ,9
	@ 78,aPosGet[7,2] MSGET oObj2 VAR _nQuantOri  Picture PesqPict('SC8','C8_QUANT',14,nMoedaCot) OF oFolderDiv:aDialogs[1] PIXEL WHEN .F. VALID Positivo() SIZE 80,9
	
	@ 99,aPosGet[7,1] SAY OemToAnsi("Quant. Novo Item") Of oFolderDiv:aDialogs[1] PIXEL SIZE 70 ,9 //
	@ 98,aPosGet[7,2] MSGET oObj3 VAR _nQtdNew Picture PesqPict('SC8','C8_QUANT',14,nMoedaCot) OF oFolderDiv:aDialogs[1] PIXEL WHEN .T. VALID Positivo() .AND. CalcQuant() SIZE 80,9
	@ 99,aPosGet[7,3] SAY OemToAnsi("Quant. Remanescente") Of oFolderDiv:aDialogs[1] PIXEL SIZE 70 ,9 // "Seguro"
	@ 98,aPosGet[7,4] MSGET oObj4 VAR _nQuantRem  Picture PesqPict('SC8','C8_QUANT',14,nMoedaCot) OF oFolderDiv:aDialogs[1] PIXEL WHEN .F. SIZE 80,9
	
	ACTIVATE MSDIALOG oDlgDiv ON INIT EnchoiceBar(oDlgDiv,{||nOpcA:=1,oDlgDiv:End()},{||oDlgDiv:End()},,) CENTER
	
	If nOpcA == 1
		dbselectarea("SC8")
		SC8->(dbgoto(_nRecno))
		
		If !empty(SC8->C8_NUMPED)
			msgstop("Existe pedido de venda atrelado a cota็ใo e nใo serแ permitido a divisใo da quantidade do item.")
			Return .F.
		EndIf
		
		aadd(_aSC8,SC8->C8_FILIAL)
		aadd(_aSC8,SOMA1(_cItemMax))
		aadd(_aSC8,SOMA1(_cNumPro))
		aadd(_aSC8,SC8->C8_PRODUTO)
		aadd(_aSC8,SC8->C8_UM)
		aadd(_aSC8,SC8->C8_QTDCTR)
		aadd(_aSC8,_nQtdNew)
		aadd(_aSC8,SC8->C8_PRECO)
		aadd(_aSC8,SC8->C8_CODTAB)
		aadd(_aSC8,_nQtdNew*SC8->C8_PRECO)
		aadd(_aSC8,SC8->C8_COND)
		aadd(_aSC8,SC8->C8_TAXAFIN)
		aadd(_aSC8,SC8->C8_PRAZO)
		aadd(_aSC8,SC8->C8_OBS)
		aadd(_aSC8,SC8->C8_FORNECE)
		aadd(_aSC8,SC8->C8_LOJA)
		aadd(_aSC8,SC8->C8_CONTATO)
		aadd(_aSC8,SC8->C8_FILENT)
		aadd(_aSC8,ddatabase)
		aadd(_aSC8,SC8->C8_NUM)
		aadd(_aSC8,SC8->C8_ALIIPI)
		aadd(_aSC8,SC8->C8_TES)
		aadd(_aSC8,SC8->C8_PICM)
		aadd(_aSC8,SC8->C8_VALFRE)
		aadd(_aSC8,SC8->C8_VALEMB)
		aadd(_aSC8,SC8->C8_DESC1)
		aadd(_aSC8,SC8->C8_DESC2)
		aadd(_aSC8,SC8->C8_TPFRETE)
		aadd(_aSC8,SC8->C8_TOTFRE)
		aadd(_aSC8,SC8->C8_AVISTA)
		aadd(_aSC8,SC8->C8_REAJUST)
		aadd(_aSC8,SC8->C8_DTVISTA)
		aadd(_aSC8,SC8->C8_VALIDA)
		aadd(_aSC8,SC8->C8_NUMPED)
		aadd(_aSC8,SC8->C8_ITEMPED)
		aadd(_aSC8,SC8->C8_NUMSC)
		aadd(_aSC8,SC8->C8_ITEMSC)
		aadd(_aSC8,SC8->C8_DATPRF)
		aadd(_aSC8,SC8->C8_IDENT)
		aadd(_aSC8,SC8->C8_VLDESC)
		aadd(_aSC8,SC8->C8_SEGUM)
		aadd(_aSC8,SC8->C8_QTSEGUM)
		aadd(_aSC8,SC8->C8_MOTIVO)
		aadd(_aSC8,SC8->C8_GRUPCOM)
		aadd(_aSC8,SC8->C8_STATME)
		aadd(_aSC8,SC8->C8_OK)
		aadd(_aSC8,SC8->C8_DESPESA)
		aadd(_aSC8,SC8->C8_SEGURO)
		aadd(_aSC8,SC8->C8_VALIPI)
		aadd(_aSC8,SC8->C8_VALICM)
		aadd(_aSC8,SC8->C8_BASEICM)
		aadd(_aSC8,SC8->C8_BASEIPI)
		aadd(_aSC8,SC8->C8_DESC)
		aadd(_aSC8,SC8->C8_MSG)
		aadd(_aSC8,SC8->C8_MOEDA)
		aadd(_aSC8,SC8->C8_TXMOEDA)
		aadd(_aSC8,SC8->C8_ORCFOR)
		aadd(_aSC8,SC8->C8_SEQFOR)
		aadd(_aSC8,SC8->C8_ITEFOR)
		aadd(_aSC8,SC8->C8_ITEMGRD)
		aadd(_aSC8,SC8->C8_ITSCGRD)
		aadd(_aSC8,SC8->C8_GRADE)
		aadd(_aSC8,SC8->C8_CODORCA)
		aadd(_aSC8,SC8->C8_ORIGEM)
		aadd(_aSC8,SC8->C8_BASESOL)
		aadd(_aSC8,SC8->C8_VALSOL)
		aadd(_aSC8,SC8->C8_ACCITEM)
		aadd(_aSC8,SC8->C8_ACCNUM)
		aadd(_aSC8,SC8->C8_CODED)
		aadd(_aSC8,SC8->C8_NUMPR)
		aadd(_aSC8,SC8->C8_RATFIN)
		aadd(_aSC8,SC8->C8_FORNOME)
		aadd(_aSC8,SC8->C8_FORMAIL)
//		aadd(_aSC8,SC8->C8_CRITER)

		Begin Transaction
		
		dbselectarea("SC8")
		dbsetorder(3)
		If dbseek(_cFilial+_cNum+_cProduto)
			While SC8->(!EOF())
				If _cFilial == SC8->C8_FILIAL .and. _cNum == SC8->C8_NUM .and. _cProduto == SC8->C8_PRODUTO  .and. SC8->C8_ITEM == _cItem
					Reclock("SC8",.F.)
					SC8->C8_QUANT := _nQuantOri-_nQtdNew
					SC8->C8_TOTAL := (_nQuantOri-_nQtdNew)*SC8->C8_PRECO
					SC8->(msunlock())
				EndIf
				SC8->(dbskip())
			EndDo
		EndIf
		
		dbselectarea("SC8")
		SC8->(dbgotop())
		
		Reclock("SC8",.T.)
		SC8->C8_FILIAL   := _aSC8[1]
		SC8->C8_ITEM     := _aSC8[2]
		SC8->C8_NUMPRO   := _aSC8[3]
		SC8->C8_PRODUTO  := _aSC8[4]
		SC8->C8_UM       := _aSC8[5]
		SC8->C8_QTDCTR   := _aSC8[6]
		SC8->C8_QUANT    := _aSC8[7]
		SC8->C8_PRECO    := _aSC8[8]
		SC8->C8_CODTAB   := _aSC8[9]
		SC8->C8_TOTAL    := _aSC8[10]
		SC8->C8_COND     := _aSC8[11]
		SC8->C8_TAXAFIN  := _aSC8[12]
		SC8->C8_PRAZO    := _aSC8[13]
		SC8->C8_OBS      := _aSC8[14]
		SC8->C8_FORNECE  := _aSC8[15]
		SC8->C8_LOJA     := _aSC8[16]
		SC8->C8_CONTATO  := _aSC8[17]
		SC8->C8_FILENT   := _aSC8[18]
		SC8->C8_EMISSAO  := _aSC8[19]
		SC8->C8_NUM      := _aSC8[20]
		SC8->C8_ALIIPI    := _aSC8[21]
		SC8->C8_TES      := _aSC8[22]
		SC8->C8_PICM     := _aSC8[23]
		SC8->C8_VALFRE   := _aSC8[24]
		SC8->C8_VALEMB   := _aSC8[25]
		SC8->C8_DESC1    := _aSC8[26]
		SC8->C8_DESC2    := _aSC8[27]
		SC8->C8_TPFRETE  := _aSC8[28]
		SC8->C8_TOTFRE   := _aSC8[29]
		SC8->C8_AVISTA   := _aSC8[30]
		SC8->C8_REAJUST  := _aSC8[31]
		SC8->C8_DTVISTA  := _aSC8[32]
		SC8->C8_VALIDA   := _aSC8[33]
		SC8->C8_NUMPED   := _aSC8[34]
		SC8->C8_ITEMPED  := _aSC8[35]
		SC8->C8_NUMSC    := _aSC8[36]
		SC8->C8_ITEMSC   := _aSC8[37]
		SC8->C8_DATPRF   := _aSC8[38]
		SC8->C8_IDENT    := _aSC8[39]
		SC8->C8_VLDESC   := _aSC8[40]
		SC8->C8_SEGUM    := _aSC8[41]
		SC8->C8_QTSEGUM  := _aSC8[42]
		SC8->C8_MOTIVO   := _aSC8[43]
		SC8->C8_GRUPCOM  := _aSC8[44]
		SC8->C8_STATME   := _aSC8[45]
		SC8->C8_OK       := _aSC8[46]
		SC8->C8_DESPESA  := _aSC8[47]
		SC8->C8_SEGURO   := _aSC8[48]
		SC8->C8_VALIPI   := _aSC8[49]
		SC8->C8_VALICM   := _aSC8[50]
		SC8->C8_BASEICM  := _aSC8[51]
		SC8->C8_BASEIPI  := _aSC8[52]
		SC8->C8_DESC     := _aSC8[53]
		SC8->C8_MSG      := _aSC8[54]
		SC8->C8_MOEDA    := _aSC8[55]
		SC8->C8_TXMOEDA  := _aSC8[56]
		SC8->C8_ORCFOR   := _aSC8[57]
		SC8->C8_SEQFOR   := _aSC8[58]
		SC8->C8_ITEFOR   := _aSC8[59]
		SC8->C8_ITEMGRD  := _aSC8[60]
		SC8->C8_ITSCGRD  := _aSC8[61]
		SC8->C8_GRADE    := _aSC8[62]
		SC8->C8_CODORCA  := _aSC8[63]
		SC8->C8_ORIGEM   := _aSC8[64]
		SC8->C8_BASESOL  := _aSC8[65]
		SC8->C8_VALSOL   := _aSC8[66]
		SC8->C8_ACCITEM  := _aSC8[67]
		SC8->C8_ACCNUM   := _aSC8[68]
		SC8->C8_CODED    := _aSC8[69]
		SC8->C8_NUMPR    := _aSC8[70]
		SC8->C8_RATFIN   := _aSC8[71]
		SC8->C8_FORNOME  := _aSC8[72]
		SC8->C8_FORMAIL  := _aSC8[73]
//		SC8->C8_CRITER   := _aSC8[74]
		
		SC8->(msunlock())
		End Transaction
		
		oDlgCotac:End()
		_nSavFolder := 2
	EndIf
	
Else
	msginfo("Necessแrio escolher apenas 1 cota็ใo que nใo esteja encerrada para efetuar a Compra Dividida.")
EndIf

Return .T.


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณ GJPDesDiv  บ Autor ณ Carlos A. Queiroz  บ Data ณ  19/05/15   บฑฑ
ฑฑฬออออออออออุออออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ Efetua o processo de desfazer uma compra dividida retornando บฑฑ
ฑฑบ          ณ o saldo ao item original.                                    บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ GJP Hotels & Resorts                                         บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
User Function GJPDesDiv()

Local _cFilial   := "" //oGetDad:aCols[oGetDad:nAt][aScan(oGetDad:aHeader,{|x| AllTrim(x[2]) == "FILIAL"})]
Local _cNum      := "" //oGetDad:aCols[oGetDad:nAt][aScan(oGetDad:aHeader,{|x| AllTrim(x[2]) == "COTACAO"})]
Local _cProduto  := "" //oGetDad:aCols[oGetDad:nAt][aScan(oGetDad:aHeader,{|x| AllTrim(x[2]) == "PRODUTO"})]
Local _cItem     := "" //oGetDad:aCols[oGetDad:nAt][aScan(oGetDad:aHeader,{|x| AllTrim(x[2]) == "ITEM"})]
Local _nQuant    := 0  //oGetDad:aCols[oGetDad:nAt][aScan(oGetDad:aHeader,{|x| AllTrim(x[2]) == "QUANTIDADE"})]
Local nCompDiv   := 0
Local _cQuery    := ""
Local lValida    := .F.
Local lAtualizou := .F.
Local lContinua  := .T.
Local _cItemRec  := ""

For i:=1 to Len(oGetDad:aCols)
	If oGetDad:aCols[i][1] == oOk
		nCompDiv++
		_cFilial   := oGetDad:aCols[i][aScan(oGetDad:aHeader,{|x| AllTrim(x[2]) == "FILIAL"})]
		_cNum      := oGetDad:aCols[i][aScan(oGetDad:aHeader,{|x| AllTrim(x[2]) == "COTACAO"})]
		_cProduto  := oGetDad:aCols[i][aScan(oGetDad:aHeader,{|x| AllTrim(x[2]) == "PRODUTO"})]
		_cItem     := oGetDad:aCols[i][aScan(oGetDad:aHeader,{|x| AllTrim(x[2]) == "ITEM"})]
		_nQuant    := oGetDad:aCols[i][aScan(oGetDad:aHeader,{|x| AllTrim(x[2]) == "QUANTIDADE"})]
	EndIf
Next i

If nCompDiv == 1
	
	If val(_cItem) > 1
		
		cQuery := " Select SC8.R_E_C_N_O_ C8_RECNO, SC8.* from "+RetSqlName("SC8")+" SC8 "
		cQuery += " Where SC8.D_E_L_E_T_ <> '*' AND SC8.C8_FILIAL = '"+_cFilial+"' AND SC8.C8_NUM = '"+_cNum+"' AND SC8.C8_PRODUTO = '"+_cProduto+"'"
		cQuery += " AND SC8.C8_ITEM = '"+_cItem+"'"
		cQuery := ChangeQuery(cQuery)
		dbUseArea(.T., "TOPCONN", TCGenQry(,,cQuery), "QRYCHK", .F., .T.)
		
		While QRYCHK->(!EOF())
			If !Empty(QRYCHK->C8_NUMPED)
				lContinua := .F.
			EndIf
			QRYCHK->(dbskip())
		EndDo
		QRYCHK->(dbclosearea())
		
		If lContinua
			
			dbselectarea("SC8")
			dbsetorder(3)
			If dbseek(_cFilial+_cNum+_cProduto)
				
				If select("QRYSC8") > 0
					QRYSC8->(dbclosearea())
				EndIf
				
				cQuery := " Select SC8.R_E_C_N_O_ C8_RECNO, SC8.* from "+RetSqlName("SC8")+" SC8 "
				cQuery += " Where SC8.D_E_L_E_T_ <> '*' AND SC8.C8_FILIAL = '"+SC8->C8_FILIAL+"' AND SC8.C8_NUM = '"+SC8->C8_NUM+"' AND SC8.C8_PRODUTO = '"+_cProduto+"'"
				cQuery += " Order by SC8.C8_FILIAL, SC8.C8_NUM, SC8.C8_PRODUTO, SC8.C8_ITEM DESC"
				cQuery := ChangeQuery(cQuery)
				dbUseArea(.T., "TOPCONN", TCGenQry(,,cQuery), "QRYSC8", .F., .T.)
				
				QRYSC8->(dbgotop())
				While QRYSC8->(!EOF())
					If QRYSC8->C8_ITEM == _cItem
						If QRYSC8->C8_NUMPRO == "01"
							msginfo("Item nใo pode ser desfeito decorrente de nใo fazer parte de uma compra dividida.")
							Return .F.
	                    EndIf
					EndIf
					QRYSC8->(dbskip())
				EndDo
				
				QRYSC8->(dbgotop())
				While QRYSC8->(!EOF())
					If lValida
						If Empty(QRYSC8->C8_NUMPED)
							
							Begin Transaction
							
							While QRYSC8->(!EOF()) .and. QRYSC8->C8_FILIAL == _cFilial .and. QRYSC8->C8_NUM == _cNum .and. QRYSC8->C8_PRODUTO == _cProduto .and. QRYSC8->C8_ITEM == _cItemRec
								SC8->(dbgoto(QRYSC8->C8_RECNO))
								RecLock("SC8",.F.)
								SC8->C8_QUANT := SC8->C8_QUANT+_nQuant
								SC8->C8_TOTAL := SC8->C8_QUANT * SC8->C8_PRECO
								SC8->(msunlock())
								QRYSC8->(dbskip())
								lAtualizou := .T.
							EndDo
							
							QRYSC8->(dbgotop())
							While QRYSC8->(!EOF())
								If QRYSC8->C8_ITEM == _cItem
									SC8->(dbgoto(QRYSC8->C8_RECNO))
									Reclock("SC8",.F.)
									SC8->(dbDelete())
									SC8->(msunlock())
								EndIf
								QRYSC8->(dbskip())
							EndDo
							
							End Transaction
							
							msginfo("Item "+alltrim(_cItem)+" do produto "+alltrim(_cProduto)+" teve o saldo de "+alltrim(str(_nQuant))+" retornado para o item "+alltrim(_cItemRec)+".","Cota็ใo "+alltrim(_cNum))
							
							QRYSC8->(dbclosearea())
							oDlgCotac:End()
							_nSavFolder := 2
							Return .T.
						Else
							QRYSC8->(dbskip())
							_cItemRec := QRYSC8->C8_ITEM
							loop
						EndIf
					EndIf
					
					If QRYSC8->C8_ITEM == _cItem .and. !lValida
						lValida := .T.
						
						While QRYSC8->(!EOF()) .and. QRYSC8->C8_ITEM == _cItem
							QRYSC8->(dbskip())
						EndDo
						_cItemRec := QRYSC8->C8_ITEM						
						loop
						
					EndIf
					
					QRYSC8->(dbskip())
				EndDo
				
				If !lAtualizou
					msginfo("Nใo foi possํvel retornar item a divisใo original decorrente de jแ pedido de compra jแ ter sido gerado.")
				EndIf
				
			EndIf
			
		Else
			msginfo("Item nใo pode ser desfeito decorrente de jแ ter sido gerado pedido de compra.")
		EndIf
	Else
		msginfo("Item nใo pode ser desfeito decorrente de nใo fazer parte de uma compra dividida.")
	EndIf
	
Else
	msginfo("Necessแrio escolher apenas 1 item para efetuar o processo de 'Desfazer' uma compra dividida.")
EndIf

Return .T.


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณ GJPExcMult บ Autor ณ Carlos A. Queiroz  บ Data ณ  19/05/15   บฑฑ
ฑฑฬออออออออออุออออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ Funcionalidade de 'Exclusao Multipla' efetua a delecao de    บฑฑ
ฑฑบ          ณ todos os itens em aberto da Cotacao selecionada.             บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ GJP Hotels & Resorts                                         บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
User Function GJPExcMult()

Local _cFilial   := ""  //oGetDad:aCols[oGetDad:nAt][aScan(oGetDad:aHeader,{|x| AllTrim(x[2]) == "FILIAL"})]
Local _cNum      := ""  //oGetDad:aCols[oGetDad:nAt][aScan(oGetDad:aHeader,{|x| AllTrim(x[2]) == "COTACAO"})]
Local _cProduto  := ""  //oGetDad:aCols[oGetDad:nAt][aScan(oGetDad:aHeader,{|x| AllTrim(x[2]) == "PRODUTO"})]
Local _cItem     := ""  //oGetDad:aCols[oGetDad:nAt][aScan(oGetDad:aHeader,{|x| AllTrim(x[2]) == "ITEM"})]
Local _nQuant    := 0   //oGetDad:aCols[oGetDad:nAt][aScan(oGetDad:aHeader,{|x| AllTrim(x[2]) == "QUANTIDADE"})]
Local _cQuery    := ""
Local lValida    := .F.
Local lAtualizou := .F.
Local lContinua  := .F.
Local _cItemRec  := ""

For i:=1 to Len(oGetDad:aCols)
	If oGetDad:aCols[i][1] == oOk
		lContinua := .T.
	EndIf
Next i

If !lContinua
	msginfo("Necessแrio marcar pelo menos 1 item da Cota็ใo que serแ executada a Excluํda M๚ltipla.")
	Return .F.
EndIf 

If lContinua
	If msgyesno("Deseja efetuar a exclusใo m๚ltipla dos item(ns) selecionado(s) eliminando todos os itens em aberto da(s) Cota็ใo(๕es)?")
		Begin Transaction
		For i:=1 to Len(oGetDad:aCols)
			If oGetDad:aCols[i][1] == oOk
				_cFilial   := oGetDad:aCols[i][aScan(oGetDad:aHeader,{|x| AllTrim(x[2]) == "FILIAL"})]
				_cNum      := oGetDad:aCols[i][aScan(oGetDad:aHeader,{|x| AllTrim(x[2]) == "COTACAO"})]
				_cProduto  := oGetDad:aCols[i][aScan(oGetDad:aHeader,{|x| AllTrim(x[2]) == "PRODUTO"})]
				_cItem     := oGetDad:aCols[i][aScan(oGetDad:aHeader,{|x| AllTrim(x[2]) == "ITEM"})]
				_nQuant    := oGetDad:aCols[i][aScan(oGetDad:aHeader,{|x| AllTrim(x[2]) == "QUANTIDADE"})]
								
				dbselectarea("SC8")
				dbsetorder(3)
				If dbseek(_cFilial+_cNum)
					While SC8->(!EOF()) .and. _cFilial == SC8->C8_FILIAL .and. _cNum == SC8->C8_NUM
						
						cQuery := " Select SC8.R_E_C_N_O_ C8_RECNO, SC8.* from "+RetSqlName("SC8")+" SC8 "
						cQuery += " Where SC8.D_E_L_E_T_ <> '*' AND SC8.C8_FILIAL = '"+_cFilial+"' AND SC8.C8_NUM = '"+_cNum+"'
						cQuery += " AND SC8.C8_PRODUTO = '"+SC8->C8_PRODUTO+"' AND SC8.C8_ITEM = '"+SC8->C8_ITEM+"'
						cQuery += " Order by SC8.C8_FILIAL, SC8.C8_NUM, SC8.C8_PRODUTO, SC8.C8_ITEM"
						cQuery := ChangeQuery(cQuery)
						dbUseArea(.T., "TOPCONN", TCGenQry(,,cQuery), "QRYCHK", .F., .T.)
						
						lContinua := .T.
						
						While QRYCHK->(!EOF())
							If !Empty(QRYCHK->C8_NUMPED)
								lContinua := .F.
							EndIf
							QRYCHK->(dbskip())
						EndDo
						QRYCHK->(dbclosearea())
						
						If lContinua
							cQuery := " Select r_e_c_n_o_ C1_RECNO from "+RetSqlName("SC1")+" "
							cQuery += " Where D_E_L_E_T_ <> '*' AND C1_FILIAL = '"+SC8->C8_FILIAL+"' AND C1_NUM = '"+SC8->C8_NUMSC+"' AND C1_ITEM = '"+SC8->C8_ITEMSC+"'"
							
							cQuery := ChangeQuery(cQuery)
							dbUseArea(.T., "TOPCONN", TCGenQry(,,cQuery), "QRYSC1", .F., .T.)
							
							If QRYSC1->(!EOF())
								SC1->(dbgoto(QRYSC1->C1_RECNO))
								RecLock("SC1",.F.)
								SC1->C1_COTACAO := ""
								SC1->C1_QUJE    := 0
								SC1->C1_QUJE2   := 0
								SC1->C1_FORNECE := ""
								SC1->C1_LOJA    := ""
								SC1->C1_PEDIDO  := ""
								SC1->C1_ITEMPED := ""								
								SC1->(msunlock())
							EndIf
							QRYSC1->(dbclosearea())
												   
							Reclock("SC8",.F.)
							SC8->(dbDelete())
							SC8->(msunlock())
						EndIf
						SC8->(dbskip())
					EndDo
					
				Endif
			EndIf
		Next i
		End Transaction
		oDlgCotac:End()
		_nSavFolder := 2
	EndIf
EndIf

Return .T.


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณ GJPTotCot  บ Autor ณ Carlos A. Queiroz  บ Data ณ  19/05/15   บฑฑ
ฑฑฬออออออออออุออออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ Interface que informa os valores totais por fornecedor       บฑฑ
ฑฑบ          ณ envolvendo todos os itens da Cotacao selecionada.            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ GJP Hotels & Resorts                                         บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
User Function GJPTotCot()

Local aInfo     := {}
Local aPosObj   := {}
Local aObjects  := {}
Local aSize     := MsAdvSize()
Local oDlgInf
Local nOpcA     := 0
Local oSay1, oSay2, oSay3, oSay4, oSay5
Local aHeader4 := {}
Local aCols4   := {}
Local _cFilial   := oGetDad:aCols[oGetDad:nAt][aScan(oGetDad:aHeader,{|x| AllTrim(x[2]) == "FILIAL"})]
Local _cNum      := oGetDad:aCols[oGetDad:nAt][aScan(oGetDad:aHeader,{|x| AllTrim(x[2]) == "COTACAO"})]
Local _cProduto  := oGetDad:aCols[oGetDad:nAt][aScan(oGetDad:aHeader,{|x| AllTrim(x[2]) == "PRODUTO"})]
Local _cItem     := oGetDad:aCols[oGetDad:nAt][aScan(oGetDad:aHeader,{|x| AllTrim(x[2]) == "ITEM"})]
Local _cFornece  := "" //substr(oGetDad:aHeader[oGetDad:nAt][oGetDad:OBROWSE:COLPOS],1,TamSX3("C8_FORNECE")[1])
Local _cLoja     := "" //substr(oGetDad:aHeader[oGetDad:nAt][oGetDad:OBROWSE:COLPOS],13,TamSX3("C8_LOJA")[1])
Local _cNomeForn := ""
Local _nVlrTot   := 0
Local oGetDad4
Local oObj1
Local oObj2
Local oObj3
Local oObj4
Local oObj5
Local aPosGet	 := {}
Local aTotFornec := {}
Local cQuery     := ""

Private oFolderTot
Private aFolderTot := {"Totaliza Cota็ใo por Fornecedor"}
Private l150Inclui  := .F.
Private a150Var   := {0,0,0,0,0,0,0,0,0,0,0,0,0,0,0}
Private c150Frete  := "" //If(l150Inclui,"C-CIF",RetTipoFrete(SC8->C8_TPFRETE))
Private nMoedaCot  := 0  //If(l150Inclui,1,Max(SC8->C8_MOEDA,1))

aHeader4 := {}

DbSelectArea("SX3")
DbSetOrder(2)
If DbSeek("C8_FILIAL")
	Aadd(aHeader4,{	AllTrim("Filial"),;
	"FILIAL",;
	SX3->X3_PICTURE,;
	SX3->X3_TAMANHO,;
	SX3->X3_DECIMAL,;
	SX3->X3_VALID,;
	SX3->X3_USADO,;
	SX3->X3_TIPO,;
	SX3->X3_F3,;
	SX3->X3_CONTEXT,;
	SX3->X3_CBOX,;
	SX3->X3_RELACAO,;
	SX3->X3_WHEN,;
	"V",;
	SX3->X3_VLDUSER,;
	SX3->X3_PICTVAR,;
	SX3->X3_OBRIGAT})
EndIf

DbSelectArea("SX3")
DbSetOrder(2)
If DbSeek("C8_NUM")
	Aadd(aHeader4,{	AllTrim("Cota็ใo"),;
	"COTACAO",;
	SX3->X3_PICTURE,;
	SX3->X3_TAMANHO,;
	SX3->X3_DECIMAL,;
	SX3->X3_VALID,;
	SX3->X3_USADO,;
	SX3->X3_TIPO,;
	SX3->X3_F3,;
	SX3->X3_CONTEXT,;
	SX3->X3_CBOX,;
	SX3->X3_RELACAO,;
	SX3->X3_WHEN,;
	"V",;
	SX3->X3_VLDUSER,;
	SX3->X3_PICTVAR,;
	SX3->X3_OBRIGAT})
EndIf

DbSelectArea("SX3")
DbSetOrder(2)
If DbSeek("C8_FORNECE")
	Aadd(aHeader4,{	AllTrim("Fornecedor"),;
	SX3->X3_CAMPO,;
	SX3->X3_PICTURE,;
	SX3->X3_TAMANHO,;
	SX3->X3_DECIMAL,;
	SX3->X3_VALID,;
	SX3->X3_USADO,;
	SX3->X3_TIPO,;
	SX3->X3_F3,;
	SX3->X3_CONTEXT,;
	SX3->X3_CBOX,;
	SX3->X3_RELACAO,;
	SX3->X3_WHEN,;
	"V",;
	SX3->X3_VLDUSER,;
	SX3->X3_PICTVAR,;
	SX3->X3_OBRIGAT})
EndIf

DbSelectArea("SX3")
DbSetOrder(2)
If DbSeek("A2_NOME")
	Aadd(aHeader4,{	AllTrim("Nome" ),;
	SX3->X3_CAMPO,;
	SX3->X3_PICTURE,;
	30,;
	SX3->X3_DECIMAL,;
	SX3->X3_VALID,;
	SX3->X3_USADO,;
	SX3->X3_TIPO,;
	SX3->X3_F3,;
	SX3->X3_CONTEXT,;
	SX3->X3_CBOX,;
	SX3->X3_RELACAO,;
	SX3->X3_WHEN,;
	"V",;
	SX3->X3_VLDUSER,;
	SX3->X3_PICTVAR,;
	SX3->X3_OBRIGAT})
EndIf

DbSelectArea("SX3")
DbSetOrder(2)
If DbSeek("C8_LOJA")
	Aadd(aHeader4,{	AllTrim("Loja"),;
	SX3->X3_CAMPO,;
	SX3->X3_PICTURE,;
	SX3->X3_TAMANHO,;
	SX3->X3_DECIMAL,;
	SX3->X3_VALID,;
	SX3->X3_USADO,;
	SX3->X3_TIPO,;
	SX3->X3_F3,;
	SX3->X3_CONTEXT,;
	SX3->X3_CBOX,;
	SX3->X3_RELACAO,;
	SX3->X3_WHEN,;
	"V",;
	SX3->X3_VLDUSER,;
	SX3->X3_PICTVAR,;
	SX3->X3_OBRIGAT})
EndIf

DbSelectArea("SX3")
DbSetOrder(2)
If DbSeek("C8_PRECO")
	Aadd(aHeader4,{	AllTrim("Valor Total"),;
	SX3->X3_CAMPO,;
	SX3->X3_PICTURE,;
	SX3->X3_TAMANHO,;
	SX3->X3_DECIMAL,;
	SX3->X3_VALID,;
	SX3->X3_USADO,;
	SX3->X3_TIPO,;
	SX3->X3_F3,;
	SX3->X3_CONTEXT,;
	SX3->X3_CBOX,;
	SX3->X3_RELACAO,;
	SX3->X3_WHEN,;
	"V",;
	SX3->X3_VLDUSER,;
	SX3->X3_PICTVAR,;
	SX3->X3_OBRIGAT})
EndIf

If select("QRYSC8") > 0
	QRYSC8->(dbclosearea())
EndIf

cQuery := " Select SC8.* from "+RetSqlName("SC8")+" SC8 "
cQuery += " Where SC8.D_E_L_E_T_ <> '*' AND SC8.C8_FILIAL = '"+_cFilial+"' AND SC8.C8_NUM = '"+_cNum+"'
cQuery += " Order by SC8.C8_FILIAL, SC8.C8_NUM, SC8.C8_FORNECE, SC8.C8_LOJA"
cQuery := ChangeQuery(cQuery)
dbUseArea(.T., "TOPCONN", TCGenQry(,,cQuery), "QRYSC8", .F., .T.)

QRYSC8->(dbgotop())

_cFornece := QRYSC8->C8_FORNECE
_cLoja    := QRYSC8->C8_LOJA

While QRYSC8->(!EOF())
	If _cFornece == QRYSC8->C8_FORNECE .and. _cLoja == QRYSC8->C8_LOJA
		_nVlrTot += QRYSC8->C8_PRECO * QRYSC8->C8_QUANT
	Else
		aAdd(aTotFornec,{_cFilial,_cNum,_cFornece,AllTrim(Posicione("SA2",1,xFilial("SA2")+_cFornece+_cLoja,"A2_NOME")),_cLoja,_nVlrTot})
		_cFornece := QRYSC8->C8_FORNECE
		_cLoja    := QRYSC8->C8_LOJA
		_nVlrTot := 0
		loop
	EndIf
	QRYSC8->(dbskip())
EndDo
aAdd(aTotFornec,{_cFilial,_cNum,_cFornece,AllTrim(Posicione("SA2",1,xFilial("SA2")+_cFornece+_cLoja,"A2_NOME")),_cLoja,_nVlrTot})
QRYSC8->(dbclosearea())

For i:=1 to len(aTotFornec)
	Aadd(aCols4,Array(Len(aHeader4)+1))
	aCols4[Len(aCols4)][1]  := aTotFornec[i][1]
	aCols4[Len(aCols4)][2]  := aTotFornec[i][2]
	aCols4[Len(aCols4)][3]  := aTotFornec[i][3]
	aCols4[Len(aCols4)][4]  := aTotFornec[i][4]
	aCols4[Len(aCols4)][5]  := aTotFornec[i][5]
	aCols4[Len(aCols4)][6]  := aTotFornec[i][6]
	aCols4[Len(aCols4)][Len(aHeader4)+1] := .F.
Next i


aAdd( aObjects, { 315, 20, .T., .T. } )
aInfo := { aSize[ 1 ], aSize[ 2 ], aSize[ 3 ], aSize[ 4 ], 3, 3 }
aPosObj := MsObjSize( aInfo, aObjects)

aPosGet := MsObjGetPos(aSize[3]-aSize[1],305,;
{{10,40,95,140,200,222,268,240},;
{10,40,111,140,223,268,63},;
{5,70,160,205,295},;
{6,34,200,215},;
{6,34,80,113,153,178},;
{6,34,245,268,260},;
{10,50,150,190,120},;
{273,130,190},;
{8,45,73,103,139,167,190,225,253},;
{144,190,144,190,289,293},;
{142,293,140},;
{9,47,188,148,9,146} } )


DEFINE MSDIALOG oDlgTot TITLE "GJP Hotels & Resort" From aSize[7]-200,0 to aSize[6]-420,aSize[5]-600 of oMainWnd PIXEL

oFolderTot := TFolder():New(aPosObj[1,1], aPosObj[1,2], aFolderTot, , oDlgTot, 1, , , .T.,.F.,aPosObj[1,4]-300,aPosObj[1,3]-aPosObj[1,1]-120,)

oGetDad4:= MsNewGetDados():New(120,00,00,00,2,,,,,,999,,,,oFolderTot:aDialogs[1],aHeader4,aCols4)
oGetDad4:oBrowse:Align:= CONTROL_ALIGN_ALLCLIENT

ACTIVATE MSDIALOG oDlgTot ON INIT EnchoiceBar(oDlgTot,{||oDlgTot:End()},{||oDlgTot:End()},,) CENTER

Return .T.


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณ CalcQuant  บ Autor ณ Carlos A. Queiroz  บ Data ณ  19/05/15   บฑฑ
ฑฑฬออออออออออุออออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ Trata a quantidade desmembrada na opcao 'Compra Dividida'.   บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ GJP Hotels & Resorts                                         บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
Static Function CalcQuant()
If _nQtdNew < _nQuantOri
	_nQuantRem := _nQuantOri - _nQtdNew
Else
	msginfo("A quantidade a ser dividida nใo pode ser maior ou igual a quantidade original de "+alltrim(str(_nQuantOri))+".")
	Return .F.
EndIf

Return .T.


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณGJP130Procesบ Autor ณ Carlos A. Queiroz  บ Data ณ  19/05/15   บฑฑ
ฑฑฬออออออออออุออออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ Interface de transicao apos atualizacao de alguma funcionali-บฑฑ
ฑฑบ          ณ dade envolvendo o processo de Cotacoes.                      บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ GJP Hotels & Resorts                                         บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
User Function GJP130Process(_nProc)
Private oProcess
Default _nProc := 2
oProcess := MsNewProcess():New({|lEnd| U_GJP130Regua(_nProc)},"Atualizando Cota็๕es GJP ")
oProcess:Activate()

Return .T.


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณ GJP130Reguaบ Autor ณ Carlos A. Queiroz  บ Data ณ  19/05/15   บฑฑ
ฑฑฬออออออออออุออออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ Interface que mostra regua de processamento no momento de    บฑฑ
ฑฑบ          ณ atualizacao da interface de Cotacoes.                        บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ GJP Hotels & Resorts                                         บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
User Function GJP130Regua(_nProc)
Local _nRegua1 := 0
Local _nRegua2 := 0

If _nProc == 1
	_nRegua1 := 3
	_nRegua2 := 5
ElseIf _nProc == 2
	_nRegua1 := 2
	_nRegua2 := 1
EndIf

oProcess:SetRegua1(_nRegua1)
For i:=1 to _nRegua1
	oProcess:IncRegua1("Cota็๕es")
	j:=1
	oProcess:SetRegua2(_nRegua2)
	For j:=1 to _nRegua2
		oProcess:IncRegua2("Atualizando dados...")
	Next j
Next i

Return .T.


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณA130CHKCPOบ Autor ณ Microsiga			 บ Data ณ  19/05/15   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ Verifica se os campo B1_PE e C8_PRAZO estao com tamanhos   บฑฑ
ฑฑบ          ณ Diferentes, caso estiverem, alerta para alterar via CFG    บฑฑ
ฑฑบ          ณ e sai da rotina MATA130                                    บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ AP                                                         บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
Static Function A131CHKCPO()

Local aAreaSX3:= SX3->( GetArea() )
Local lRet 	  := .T.
Local nTamB1  := nTamB1:= TamSX3("B1_PE")[1]
Local nTamC8  := nTamC8:= TamSX3("C8_PRAZO")[1]

//Verifica o tamanho dos campos B1_PE e C8_PRAZO
If nTamB1 <> nTamC8
	lRet:= .F.
	Aviso("Atencao","Os campos B1_PE e C8_PRAZO nรฃo possuem o mesmo tamanho. Verifique o tamanho dos campos atravรฉs do configurador.",{"Ok"},2) //"Atencao"###"Os campos B1_PE e C8_PRAZO nรฃo possuem o mesmo tamanho. Verifique o tamanho dos campos atravรฉs do configurador."###"Ok"
EndIf

RestArea( aAreaSX3 )
Return lRet


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณGJP_GDPesqu บ Autor ณ Carlos A. Queiroz  บ Data ณ  19/05/15   บฑฑ
ฑฑฬออออออออออุออออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ Efetua pesquisa e ordena os itens da GetDados para melhor    บฑฑ
ฑฑบ          ณ visualicao quando houver muitas linhas.                      บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ GJP Hotels & Resorts                                         บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
User Function GJP_GDPesqu(aHPesq, aCPesq, oGDPesq, oDlgUse, nPosUse, lAlinhaH, nIndIni, lFiltra, cFiltro)
Local aArea   := getArea()
Local nCpoF   := 1, aIPesq := {}
Local nPosIni := 11, oDlgP, oCpoP, nCpoS := "XX", oChvP, cChvP := ""
Local cPict   := "@!", cAliasOld := Alias()

Default lAlinhaH := .F.
Default nIndIni  := 1
Default lFiltra  := .F.
Default cFiltro  := ""

oDlgP   := IIF(oDlgUse <> Nil, oDlgUse, oDlgP)
nPosIni := IIF(nPosUse <> Nil, nPosUse, nPosIni)

DbSelectArea("SX3")
DbSetOrder(2) // X3_CAMPO

For nCpoF := 1 To Len(oGDPesq:aHeader)
	If !(oGDPesq:aHeader[nCpoF][8] $ "NM") .And. oGDPesq:aHeader[nCpoF][3] # "@BMP" .And. alltrim(oGDPesq:aHeader[nCpoF][2]) <> "C8_COND" ;
		.and. alltrim(oGDPesq:aHeader[nCpoF][2]) <> "A2_NOME" .and. alltrim(oGDPesq:aHeader[nCpoF][2]) <> "B1_DESC" ;
		.and. alltrim(oGDPesq:aHeader[nCpoF][2]) <> "C1_TPOP" .and. alltrim(oGDPesq:aHeader[nCpoF][2]) <> "C8_MOTIVO" .and. alltrim(oGDPesq:aHeader[nCpoF][2]) <> "C8_XJUST"
		If nCpoS == "XX"
			nCpoS := StrZero(nCpoF, 2)
		EndIf
		
		If DbSeek(oGDPesq:aHeader[nCpoF][2])
			aAdd(aIPesq, StrZero(nCpoF, 2) + "=" + SX3->X3_DESCRIC)
		Else
			aAdd(aIPesq, StrZero(nCpoF, 2) + "=" + oGDPesq:aHeader[nCpoF][1])
		EndIf
		
	Endif
Next

DbSetOrder(1)
DbSelectArea(cAliasOld)

FS_PreP(@cChvP, @cPict, oGDPesq, Val(nCpoS))

If oDlgUse == Nil
	DEFINE MSDIALOG oDlgP TITLE OemToAnsi("Pesquisar") From 5, 14 To 11, 76 Of oMainWnd //"Pesquisar"
EndIf

@ nPosIni, 004 MsComboBox oCpoP Var nCpoS Color CLR_BLACK Size 100, 010 Items aIPesq On Change(FS_PreP(@cChvP, @cPict, oGDPesq, Val(nCpoS), oChvP)) Of oDlgP Pixel
oCpoP:nAt := nIndIni

If lAlinhaH
	
	@ nPosIni, 105 MSGet oChvP Var cChvP Picture cPict Size 100, 010 Of oDlgP Pixel Color CLR_BLACK
	
	oBtn1 := tButton():New(nPosIni, 205, "Pesquisar", oDlgP, {|| IIF(FS_EfeP(cChvP, Val(nCpoS), oGDPesq, cPict, lFiltra, cFiltro), oDlgP:End(), .F.)}, 030, 012,,,, .T.)    //"Pesquisar"
	If oDlgUse == Nil
		oBtn2 := tButton():New(nPosIni, 236, "Cancelar", oDlgP, {|| oDlgP:End()}, 030, 012,,,, .T.)    //"Cancelar"
	EndIf
	
Else
	
	@ nPosIni + 013, 004 MSGet oChvP Var cChvP Picture cPict Size 200, 010 Of oDlgP Pixel Color CLR_BLACK
	
	oBtn1 := tButton():New(nPosIni, 109, "Pesquisar", oDlgP, {|| IIF(FS_EfeP(cChvP, Val(nCpoS), oGDPesq, cPict, lFiltra), oDlgP:End(), .F.)}, 030, 012,,,, .T.)    //"Pesquisar"
	If oDlgUse == Nil
		oBtn2 := tButton():New(nPosIni, 139, "Cancelar", oDlgP, {|| oDlgP:End()}, 030, 012,,,, .T.)    //"Cancelar"
	EndIf
	
EndIf

If (cFiltro == " GA7_PERSOL = '1'")
	FS_EfeP("_", Val(nCpoS), oGDPesq, cPict, lFiltra, cFiltro)
EndIF

If oDlgUse == Nil
	ACTIVATE MSDIALOG oDlgP CENTERED
EndIf

RestArea(aArea)
Return(Nil)

Static Function FS_PreP(cChvP, cPict, oGDPesq, nCSel, oChvP)

cPict := oGDPesq:aHeader[nCSel][3]
If Empty(AllTRIM(cPicT))
	cPict := "@!"
EndIf

If oGDPesq:aHeader[nCSel][8] == "C"
	cChvP := Space(oGDPesq:aHeader[nCSel][4])
ElseIf oGDPesq:aHeader[nCSel][8] == "N"
	cChvP := 0
ElseIf oGDPesq:aHeader[nCSel][8] == "D"
	cChvP := dDataBase
Else
	cChvP := Space(Len(oGDPesq:aHeader[nCSel][4]))
EndIf

If oChvP # Nil
	oChvP:Refresh()
EndIf
Return(.T.)

Static Function FS_EfeP(cChvP, nCSel, oGDPesq, cPict, lFiltra, cCond)
Local aArea   := getArea()
Local nPosV := 0, lRet := .T.
Local aCPesq := aClone(oGDPesq:aCols)
Local cSql   := "", nI := 0, cCpos := ""
Local AAux   := {}, nContAux := 0
Local aCVirtual := {}, aArqCond := {}

Private cFiltro    := cCond
Private __aFnBfPsq := {cChvP, oGDPesq}

Default lFiltra := .F.
Default cFiltro := ""

If Type("__cFnBfPsq") <> "U"
	&(__cFnBfPsq)
EndIf

If !lFiltra
	If ValType(cChvP) # "D"
		cChvP := AllTrim(cChvP)
	EndIf
	
	If ValType(cChvP) == "D"
		aSort(aCPesq ,,, {| X, Y | DTOS(X[nCSel]) < DTOS(Y[nCSel])})
		nPosV  := aScan(aCPesq , {| aVet | DTOS(aVet[nCSel]) == DTOS(cChvP) })
	Else
		aSort(aCPesq,,, {| X, Y | X[nCSel] < Y[nCSel]})
		nPosV  := aScan(aCPesq, {| aVet | SubStr(aVet[nCSel], 1, Len(cChvP)) == cChvP})
	EndIf
Else
	cAlias := Substr(oGDPesq:aHeader[1,2],1,at("_",oGDPesq:aHeader[1,2])-1)
	
	cSql  := " Select "
	cFrom := " From "+RetSqlName(Substr(oGDPesq:aHeader[1,2],1,at("_",oGDPesq:aHeader[1,2])-1))+" "+Substr(oGDPesq:aHeader[1,2],1,at("_",oGDPesq:aHeader[1,2])-1)
	
	For nI := 1 to Len(oGDPesq:aHeader)
		DbSelectArea("SX3")
		DbSetOrder(2)
		If DbSeek(oGDPesq:aHeader[nI, 2])
			
			If SX3->X3_TIPO # "M" .And. SX3->X3_CONTEXT == "V" .And. !Empty(SX3->X3_RELACAO) .And. FS_IsJoin(SX3->X3_RELACAO)
				aAdd(aCVirtual, {SX3->X3_CAMPO, STRTRAN(STRTRAN(UPPER(SX3->X3_RELACAO), " ", ""), "'", '"'), SX3->X3_ORDEM})
			Else
				cCpos += IIF(nI == 1,"",", " ) + oGDPesq:aHeader[nI, 2]
			EndIf
			
		EndIf
	Next nI
	
	HS_ArqCond(cAlias, @aArqCond, aCVirtual, .T.)
	
	For nI := 1 To Len(aArqCond)
		If !Empty(aArqCond[nI, 1]) .And. !Empty(aArqCond[nI, 3])
			cFrom += " " + aArqCond[nI, 1] + " ON " + aArqCond[nI, 3] + " "
		EndIf
		
		If !Empty(aArqCond[nI, 2])
			cCpos += ", " + aArqCond[nI, 2] + " " + aArqCond[nI, 4]
		EndIf
	Next
	
	cSql += cCpos
	cSql += cFrom
	
	cSql += " Where "+cAlias+"."+cAlias+"_FILIAL = '"+xFilial(cAlias)+"' AND "+cAlias+".D_E_L_E_T_ <> '*' "
	
	cCpo := IIF(aScan(aArqCond, {|aVet| oGDPesq:aHeader[nCSel, 2] == aVet[4] }) > 0, aArqCond[aScan(aArqCond, {|aVet|    oGDPesq:aHeader[nCSel, 2] == aVet[4] }),2],cAlias+"."+oGDPesq:aHeader[nCSel, 2])
	If ValType(cChvP) == "D"
		cSql += " AND "+cCpo+" >= '"+cChvP+"' "
	Else
		cSql += " AND "+cCpo+" Like '%"+RTrim(cChvP)+"%' "
	EndIf
	
	If !(Empty(cFiltro))
		cSql += " AND "+cFiltro
	EndIf
	
	cSql += " Order By "+oGDPesq:aHeader[nCSel, 2]+" asc "
	
	TCQuery cSql New Alias "TMPPESQ"
	
	DbSelectArea("TMPPESQ")
	DbGoTop()
	aCPesq := {}
	
	While TMPPESQ->(!Eof())
		aAux := {}
		For nI := 1 to Len(oGDPesq:aHeader)
			aAdd(aAux,&("TMPPESQ->"+oGDPesq:aHeader[nI, 2]))
		Next nI
		aAdd(aAux,.F.)
		aAdd(aCPesq, aAux)
		nPosV := 1
		DbSkip()
	EndDo
	DbSelectArea("TMPPESQ")
	DbCloseArea()
	
EndIf

If nPosV > 0
	oGDPesq:SetArray(aCPesq)
	oGDPesq:oBrowse:nAt := nPosV
	oGDPesq:oBrowse:Refresh()
	oGDPesq:oBrowse:SetFocus()
	If Type("__cFunPesq") <> "U"
		&(__cFunPesq)
	EndIf
Else
	HS_MsgInf("Registro nใo encontrado", "Aten็ใo", "Pesquisar")  
	lRet := .F.
EndIf

RestArea(aArea)
Return(lRet)


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณ xA130ItGeraบ Autor ณ Carlos A. Queiroz  บ Data ณ  19/05/15   บฑฑ
ฑฑฬออออออออออุออออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ Insere um item de SC em uma Cotacao existente.               บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ GJP Hotels & Resorts                                         บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
User Function xA130ItGera(cAlias,cCampo,nOpcE,cMarca,lInverte)

Local aArea		  := GetArea()
Local aLocks      := {}
Local dValidade	  := dDataBase
Local nDiasVal    := MV_PAR04
Local nAmarracao  := MV_PAR06
Local nFornec	  := 0
Local nUltForn 	  := 0
Local nX          := 0
Local lRelatorio  := MV_PAR07 == 1
Local lContinua	  := .F.
Local lA130Lock   := .T.

If ExistBlock("MT130GER")
	ExecBlock("MT130GER",.F.,.F.)
EndIf

//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
//ณQuando nao estiver sendo utilizado o recurso de Multiusuario mantem o   ณ
//ณcontrole de semaforo padrao utilizado antes da implementacao do         ณ
//ณMV_MULTCOT.                                                             ณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
If !lMultCot
	lA130Lock :=( A130Lock(.T.,@aLocks) )
EndIf

//Verifica se nenhum outro usuario esta gerando cotacao
If lA130Lock	
	
	//Calcula a Data de Validade da Cotacao descontando Sab/Dom e Feriados
	While nDiasVal > 0
		
		dValidade ++
		
		dValida := DataValida(dValidade)
		
		If dValida == dValidade
			nDiasVal--
		EndIf
		
	EndDo
		
	//Verifica se o usuario pode selecionar fornecedores
	If ( GetMv("MV_SELFOR")="S" )
		While ( !lContinua )
			If ( Pergunte("MTA131",.T.) )
				If ( MV_PAR01 < MV_PAR02 )
					Help(" ",1,"A130SELE")
				Else
					lContinua := .T.
				EndIf
			Else
				Exit
				lContinua := .F.
			EndIf
		EndDo
		
		nFornec	 := MV_PAR01
		nUltForn := MV_PAR02
		
	EndIf
	
	//Inicia o Processamento de geracao das cotacoes
	Processa({|lEnd| a130Proces(nAmarracao,nFornec,nUltForn,dValidade,lRelatorio)})
		
	//Desbloqueia a geracao de Cotacao
	If !lMultCot
		A130Lock(.F.,aLocks)
	Else
				
		//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
		//ณA rotina a seguir varre o Array aRecMark com os registros locados pela       ณ
		//ณmarkbrowse quando o MV_MULTCOT estiver ativo para limpar as marcas           ณ
		//ณrealizadas no C1_OK de todos os registros marcados pelo usuario.             ณ
		//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
		dbSelectArea("SC1")
		For nX:=1 To Len(aRecMark)
			SC1->( dbGoto( aRecMark[nX] ) )
			If IsMark("C1_OK",cMarca)
				If SimpleLock("SC1",.F.)
					SC1->C1_OK      := Space(Len(SC1->C1_OK))
					If SC1->(FieldPos("C1_USRCODE")) > 0
						SC1->C1_USRCODE := Space(Len(SC1->C1_USRCODE))
					EndIf
					MsUnLock()
				EndIf
			EndIf
		Next nX
	EndIf
	
EndIf

RestArea(aArea)

// Caso nenhuma ordem esteja selecionada, seleciona a ordem 1
If Empty( SC1->( IndexOrd() ) )
	SC1->( dbSetOrder( 1 ) )
EndIf

Return(Nil)


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณA130Procesบ Autor ณMicrosiga           บ Data ณ  19/05/15   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ Rotina de processamento da solicitacoes de compra que devemบฑฑ
ฑฑบ          ณ gerar cotacao.                                             บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑบ          ณ ExpN1: 1 - Produto | 2 - Grupo ( Gera Cotacao por ? )      บฑฑ
ฑฑบ          ณ ExpN2: Numero de Fornecedores                              บฑฑ
ฑฑบ          ณ ExpN3: Numero de Fornecimentos                             บฑฑ
ฑฑบ          ณ ExpD4: Data de Validade da Cotacao                         บฑฑ
ฑฑบ          ณ ExpL5: Indicador de exibicao dos relatorios                บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ AP                                                         บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
Static Function A130Proces(nAmarracao,nFornec,nUltForn,dValidade,lRelatorio)

Local aArea		:= GetArea()
Local aAreaSC1  := SC1->(GetArea())
Local aFiltro   := Eval(bFiltraBrw,1)
Local aStruSC1  := SC1->(dbStruct())
Local aRegSC	:= {}
Local aSC8Num	:= {}
Local aQuebra   := {}
Local aScMono   := {}
Local aReplForn := {}
Local bQuebra	:= {|| C1_FILENT+C1_GRADE+C1_FORNECE+C1_LOJA+C1_PRODUTO+C1_DESCRI+Dtos(C1_DATPRF)+C1_CC+C1_CONTA+C1_ITEMCTA+C1_CLVL}
Local cFiltro	:= aFiltro[1]
Local cFilQry	:= aFiltro[2]
Local cMacro	:= aFiltro[3]
Local cAliasSC1 := "SC1"
Local cAliasSC8 := "SC8"
Local cQuery	:= ""
Local cIndex	:= ""
Local cKey		:= ""
Local cQuebra	:= ""
Local cNumCot	:= ""
Local cItem		:= ""
Local cIdent	:= ""
Local cNumScs   := ""
Local nX        := 0
Local nIndex	:= 0
Local nQtdSC	:= 0
Local nCntFor	:= 0
Local nRegSC8   := 0
Local nScan     := Nil
Local lMta130Sk := ExistBlock("MTA130SK")
Local lProcessa	:= .F.
Local lQuery	:= .F.
Local lLast     := .F.
Local lPrdxForn := .T.
Local lNumCot   := .F.
Local lReplica  := .F.
Local lControle := .T.
Local cKey130   := ''
Local lCotRatP  := SuperGetMv("MV_COTRATP",.F.,.F.)

Private aGrade     := {{"","","0000","000","0000"}}
Private aFirstIdent:= {}

If ExistBlock("MA130QSC")
	bQuebra := ExecBlock("MA130QSC",.F.,.F.,{bQuebra})
	If ValType(bQuebra)#"B"
		bQuebra := {|| C1_FILENT+C1_GRADE+C1_FORNECE+C1_LOJA+C1_PRODUTO+C1_DESCRI+Dtos(C1_DATPRF)+C1_CC+C1_CONTA+C1_ITEMCTA+C1_CLVL}
	EndIf
Else
	If lCotRatP
		bQuebra := {|| C1_FILENT+C1_GRADE+C1_FORNECE+C1_LOJA+C1_PRODUTO+C1_DESCRI+Dtos(C1_DATPRF)}
	Endif
Endif


//Verifica a melhor ordem de processamento
If ThisInv()
	cKey := "C1_FILIAL+C1_GRADE+C1_FORNECE+C1_LOJA+C1_PRODUTO+C1_DESCRI+DTOS(C1_DATPRF)+C1_CC+C1_CONTA+C1_ITEMCTA+C1_CLVL+C1_FILENT"
Else
	cKey := "C1_FILIAL+C1_OK+C1_GRADE+C1_FORNECE+C1_LOJA+C1_PRODUTO+C1_DESCRI+DTOS(C1_DATPRF)+C1_CC+C1_CONTA+C1_ITEMCTA+C1_CLVL+C1_FILENT"
EndIf


//Ponto de Entrada para ajustar a chave de ordenacao para usar em conjunto
//para usar em conjunto com o  MA130QSC
If ExistBlock("MA130KEY")
	cKey130 := ExecBlock("MA130KEY",.F.,.F.,{cKey})
	If ValType(cKey130)=="C"
		cKey    := cKey130
	EndIf
EndIf


//Monta a Query para Processamento das SCs                                
#IFDEF TOP
	If ( TcSrvType()!="AS/400" )


		//PE para adicionar novas condicoes de filtro para gerar cotacoes 
		If ExistBlock("M130PROC") 
			cFilQry := AllTrim(ExecBlock("M130PROC",.F.,.F., {cFilQry} ))
			If ValType(cFilQry)#"C"
				cFilQry := aFiltro[2]
			EndIf
		EndIf

		lQuery := .T.
		cQuery := "SELECT SC1.*,SC1.R_E_C_N_O_ SC1RECNO FROM "+RetSqlName("SC1")+" SC1 "
		cQuery += "WHERE "+cFilQry
		If ( Empty(cFilQry) )
			cQuery += " C1_FILIAL='"+xFilial("SC1")+"'"
			If SC1->(FieldPos("C1_ACCPROC")) > 0
				cQuery += " AND C1_ACCPROC <> '1'"
			EndIf
		EndIf
		If ( ValType(MV_PAR01)=="N" .And. ValType(MV_PAR02)=="D" .And. ValType(MV_PAR03)=="D" )
			If ( MV_PAR01==1 ) // Filtra por Data
				cQuery += " AND C1_EMISSAO >= '"+Dtos(MV_PAR02)+"'"
				cQuery += " AND C1_EMISSAO <= '"+Dtos(MV_PAR03)+"'"
			EndIf
		EndIf
		If ( !"C1_COTACAO"$cFilQry )
			If !(ValType(lCotSI)== "L" .And. lCotSI)
				cQuery += " AND C1_COTACAO = '"+Space(Len(SC1->C1_COTACAO))+"'"
			Else
				cQuery += " AND C1_COTACAO = 'IMPORT"+Space(Len(C1_COTACAO)-6)+"'"
			EndIf
			cQuery += " AND C1_QUJE < C1_QUANT"
			cQuery += " AND C1_TPOP <> 'P' "
			cQuery += " AND C1_APROV IN('L',' ') "
		EndIf
		If ( !ThisInv() )
			cQuery += " AND C1_OK = '"+ThisMark()+"'"
		Else
			cQuery += " AND C1_OK <> '"+ThisMark()+"'"
		EndIf
		If SC1->(FieldPos("C1_ACCPROC")) > 0
			cQuery += " AND C1_ACCPROC <> '1'"
		EndIf
		cQuery += " AND D_E_L_E_T_<>'*'"
		cQuery += " ORDER BY "+SqlOrder(cKey)
		cQuery := ChangeQuery(cQuery)
		cAliasSC1 := "A130PROCES"
		dbUseArea(.T.,"TOPCONN",TcGenQry(,,cQuery),cAliasSC1,.T.,.T.)
		For nCntFor := 1 To Len(aStruSc1)
			If ( aStruSC1[nCntFor][2] $ "NDL" ) 
				TcSetField(cAliasSC1,aStruSC1[nCntFor][1],aStruSC1[nCntFor][2],aStruSC1[nCntFor][3],aStruSC1[nCntFor][4])
			EndIf
		Next nCntFor
	Else
#ENDIF
	dbSelectArea("SC1")


	//PE para adicionar novas condicoes de filtro para gerar cotacoes 
	If ExistBlock("M130PROC")
		cFiltro := AllTrim(ExecBlock("M130PROC",.F.,.F., {cFiltro} ))
		If ValType(cFiltro)#"C"
			cFiltro := aFiltro[1]
		EndIf
	EndIf
	
	If ( Empty(cFiltro) )
		cFiltro := "C1_FILIAL=='"+xFilial("SC1")+"'"
		If SC1->(FieldPos("C1_ACCPROC")) > 0
			cQuery += ".And.C1_ACCPROC <> '1'"
		EndIf
	EndIf
	If ( ValType(MV_PAR01)=="N" .And. ValType(MV_PAR02)=="D" .And. ValType(MV_PAR03)=="D" )
		If ( MV_PAR01==1 ) // Filtra por Data
			cFiltro += ".And.Dtos(C1_EMISSAO)>='"+Dtos(MV_PAR02)+"'"
			cFiltro += ".And.Dtos(C1_EMISSAO)<='"+Dtos(MV_PAR03)+"'"
		EndIf
	EndIf
	If ( !"C1_COTACAO"$cFiltro )
		If !(ValType(lCotSI)== "L" .And. lCotSI)
			cFiltro += ".And.C1_COTACAO=='"+Space(Len(SC1->C1_COTACAO))+"'.And.C1_QUJE<C1_QUANT.And.C1_TPOP!='P'.And.C1_APROV$' ,L'"
		Else
			cFiltro += ".And.C1_COTACAO=='IMPORT"+Space(Len(C1_COTACAO)-6)+"'.And.C1_QUJE<C1_QUANT.And.C1_TPOP!='P'.And.C1_APROV$' ,L'"			      			 
		EndIf
	EndIf
	cIndex := CriaTrab(,.F.)
	dbSelectArea("SC1")
	IndRegua("SC1",cIndex,cKey,,cFiltro,"Selecionando Registros...")	
	nIndex := RetIndex("SC1")
	#IFNDEF TOP
		dbSetOrder(1)
		Eval(bFiltraBrw)
		nIndex += Len(aFiltro[4])
		dbSetIndex(cIndex+OrdBagExt())
	#ENDIF
	dbSelectArea("SC1")
	dbSetOrder(nIndex+1)
	MsSeek(xFilial("SC1")+IIf(ThisInv(),"",ThisMark()))
	#IFDEF TOP
	EndIf
	#ENDIF

ProcRegua(SC1->(LastRec()))

While !Eof() .And. (cAliasSC1)->C1_FILIAL == xFilial("SC1") .And. ( ThisMark() == (cAliasSC1)->C1_OK .Or. ThisInv() ) 

	If IsMark("C1_OK",ThisMark(),ThisInv()) 

		lProcessa := .T.

		If lMta130sk
			If lQuery
				SC1->(MsGoto((cAliasSC1)->SC1RECNO))
			EndIf
			lProcessa	:= ExecBlock("MTA130SK",.F.,.F.)
			If ValType(lProcessa)#"L"
				lProcessa := .T.
			EndIf
		EndIf

		If lProcessa .And. lQuery .And. !Empty(cMacro)
			If lQuery .And. !lMta130Sk 
				SC1->(MsGoto((cAliasSC1)->SC1RECNO))
			EndIf
			lProcessa := &cMacro
		EndIf

		If SB1->(MsSeek(xFilial("SB1")+(cAliasSC1)->C1_PRODUTO))
			If !RegistroOk("SB1")
				lProcessa := .F.
			EndIf
			If !Empty(SB1->B1_PROC) .And. SB1->B1_MONO == "S"
				aadd(aScMono,(cAliasSC1)->C1_NUM+"-"+(cAliasSC1)->C1_ITEM)
				lProcessa	:= .F.
			Endif
		Endif

		If lProcessa 
			nQtdSC += ( (cAliasSC1)->C1_QUANT - (cAliasSC1)->C1_QUJE )
			aadd(aRegSC,(cAliasSC1)->(IIf(lQuery,SC1RECNO,RecNo())))
		EndIf

	EndIf

	dbSelectArea(cAliasSC1)
	cQuebra := Eval(bQuebra)

	dbSkip()
	IncProc()

	//Realiza a quebra da SC conforme o bQuebra para a Geracao do SC8
	If cQuebra != (cAliasSC1)->(Eval(bQuebra)) .Or. Len(aRegSC)>4000 
		If !Empty(cQuebra) .And. nQtdSC > 0
			If ( a130Grava(nAmarracao,aRegSC,nQtdSC,nFornec,nUltForn,dValidade,@cNumCot,@cItem,@cIdent,@aQuebra,@lPrdxForn,@aReplForn,@lReplica,@lControle) )
				If aScan(aSc8Num,cNumCot) == 0 
					aadd(aSc8Num,cNumCot)
				EndIf
			EndIf

			//PE: MT130QNR: Forca gerar um novo numero de cotacao
			If ExistBlock("MA130QNR")
				lNumCot:=ExecBlock("MA130QNR",.F.,.F.,{})    
				If ValType(lNumCot)<>"L"
					lNumCot:=.F.
				EndIf
				If lNumcot
					cNumCot:=""
				EndIf
			EndIf
			aRegSC := {}
			nQtdSc := 0
		EndIf
	EndIf

EndDo

//Restaura o SC1                                                
If lQuery 
	dbSelectArea(cAliasSC1)
	dbCloseArea()
	dbSelectArea("SC1")
Else
	dbSelectArea("SC1")
	dbClearFilter()
	RetIndex("SC1")
	Ferase(cIndex+OrdBagExt())
EndIf

//Integracao com WF                                            
If Len(aSc8Num) > 0 .And. ExistBlock("MT130WF")
	ExecBlock("MT130WF",.F.,.F.,{aSc8Num[1],aSc8Num})
EndIf

If lRelatorio .And. Len(aSc8Num) > 0 
	dbSelectArea("SC8")
	dbSetOrder(1)
	MsSeek(xFilial("SC8")+aSc8Num[1])
	SC1->(dbClearFilter())

	A130Impri(SC8->C8_NUM)

	Pergunte("MTA130",.F.)
	  MV_PAR01 := 2
	  MV_PAR02 := stod("20100101")
	  MV_PAR03 := stod("20491231")
	  MV_PAR04 := 99
	  MV_PAR05 := 1
	  MV_PAR06 := 3
	  MV_PAR07 := 2
	  MV_PAR08 := 1
	  MV_PAR09 := ""
	  MV_PAR10 := "ZZZZZZ"
	  MV_PAR11 := 1
	  MV_PAR12 := ""
	  MV_PAR13 := "ZZZZZZZZZ"
	  MV_PAR14 := 2

	dbSelectArea("SC1")
EndIf

//Restaura o Filtro da FilBrowse                                
If bFiltraBrw != Nil
	dbSelectArea("SC1")
	dbSetOrder(1)
	Eval(bFiltraBrw)
EndIf

//Mostra as Solicitacoes que nao foram geradas.                
If Len(aScMono) > 0
	For nX:= 1 To Len(aScMono)
		If nX == 1
			cNumScs := aScMono[nX]
		Else
			cNumScs += ", "+aScMono[nX]
		Endif
	Next nX
	Aviso("Aten็ao","SC nao geradas "+cNumScs,{"Ok"}, 2)
Endif

RestArea(aAreaSC1)
RestArea(aArea)

Return Nil


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณA130Grava บ Autor ณ Microsiga          บ Data ณ  19/05/15   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDescricao ณ Efetua a Gravacao das Cotacoes.                            บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑบParametrosณ ExpN1: 1 - Produto ( Qual Tipo de Amarracao utilizar )     บฑฑ
ฑฑบ          ณ        2 - Grupo                                           บฑฑ
ฑฑบ          ณ ExpN2: Quantidade a ser considerada                        บฑฑ
ฑฑบ          ณ ExpA3: Array com as cotacoes a serem consideradas          บฑฑ
ฑฑบ          ณ ExpN4: Numero de Fornecedores a serem escolhidos           บฑฑ
ฑฑบ          ณ ExpN5: Numero de Ultimos Fornecimentos                     บฑฑ
ฑฑบ          ณ ExpD6: Data de Validade da Cotacao                         บฑฑ
ฑฑบ          ณ ExpC7: Numero da Cotacao  [Referencia]                     บฑฑ
ฑฑบ          ณ ExpC8: Item da Cotacao    [Referencia]                     บฑฑ
ฑฑบ          ณ ExpC9: Identificador da Cotacao [Referencia]               บฑฑ
ฑฑบ          ณ ExpCA: Controle de quebra da cotacao                       บฑฑ
ฑฑบ          ณ ExpC9: Identificador da Cotacao [Referencia]               บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ AP                                                         บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
Static Function A130Grava(nAmarracao,aSCs,nQtdSC,nFornec,nUltForn,dValidade,cNumCot,cItem,cIdent,aQuebra,lPrdxForn,aReplForn,lReplica,lControle)

Local aArea		  := GetArea()
Local aAreaSC1	  := SC1->(GetArea())
Local aAreaSB1	  := SB1->(GetArea())
Local aAreaSA2	  := SA2->(GetArea())
Local aAreaSA5	  := SA5->(GetArea())
Local aAreaSAD	  := SAD->(GetArea())
Local aStruSA5	  := SA5->(dbStruct())
Local aStruSAD	  := SAD->(dbStruct())
Local aSizeAut	  := MsAdvSize(,.F.)
Local aObjects	  := {}
Local aInfo 	  := {}
Local aPosObj	  := {}
Local aFornec	  := {}
Local aFornecAux  := {}
Local aUltFor	  := {}
Local aAlter	  := {}
Local aDelItems   := {}
Local aLastIdent  := {}   
Local aCols130    := {}
Local cAliasSA5	  := "SA5"
Local cAliasSAD	  := "SAD"
Local cQuery	  := ""
Local cCodTab     := ""
Local cRefGrd     := ""
Local cProdRef    := ""
Local cItemNoGrd  := ""
Local cLastIdent  := ""
Local cLastItem   := ""
Local cItemGrd    := ""
Local cNewCodTab  := ""
Local nCntFor	  := 0
Local nOpcA		  := 0
Local nCont		  := 0
Local nScan       := 0
Local nScanRef    := 0
Local lContinua	  := .T.
Local lGravou	  := .F.
Local lQuery	  := .F.
Local lRet        := .F.
Local lAchou      := .F.
Local lReferencia := .F.
Local lFornBloq   := .F.
Local oDlg
Local oGet
Local aButtons:={},nInd
Local nX        := 0
Local aHeadUser := {}
Local aColsUser := {}
Local oScroll
Local aRatFin	:= {}
Local lPrjCni := FindFunction("ValidaCNI") .And. ValidaCNI()
Local aChvCOI := {}
Local nAchoForn
Local lItem  := .T.

Default aReplForn  := {}
Default lReplica   := .F.
Default lControle  := .T.

Private aHeader    := {}
Private aCols	   := {}


//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
//ณFuncao utilizada para verificar a ultima versao dos fontes      ณ
//ณSIGACUS.PRW, SIGACUSA.PRX e SIGACUSB.PRX, aplicados no rpo do   ณ
//ณcliente, assim verificando a necessidade de uma atualizacao     ณ
//ณnestes fontes. NAO REMOVER !!!							       ณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
IF !(FindFunction("SIGACUS_V") .and. SIGACUS_V() >= 20050512)
	Final("Atualizar"+" SIGACUS.PRW !!!") //"Atualizar"
Endif
IF !(FindFunction("SIGACUSA_V") .and. SIGACUSA_V() >= 20050512)
	Final("Atualizar"+" SIGACUSA.PRX !!!") //"Atualizar"
Endif
IF !(FindFunction("SIGACUSB_V") .and. SIGACUSB_V() >= 20050512)
	Final("Atualizar"+" SIGACUSB.PRX !!!") //"Atualizar"
Endif


//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
//ณFuncao utilizada para verificar a ultima versao do ATUALIZADOR  ณ
//ณdo dicionario do modulo de Compras necessario para o uso do     ณ
//ณrecurso de grade produtos no MP10 Relese I deverรก ser retirado ณ
//ณno proximo Release da Versao quando o dicionario for Atualizado ณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
//If !(FindFunction("UPDCOM01_V") .And. UPDCOM01_V() >= 20070615)
//	Final("Atualizar UPDCOM01_V.PRW ou checar o processamento deste UPDATE !!!") 
//EndIf

//Posiciona Registros e Atualiza a Amarracao                       
dbSelectArea("SC1")
dbSetOrder(1)
MsGoto(aSCs[1])

dbSelectArea("SB1")
dbSetOrder(1)
MsSeek( xFilial("SB1")+SC1->C1_PRODUTO)

dbSelectArea("SA2")
dbSetOrder(1)
MsSeek( xFilial("SA2")+SC1->C1_FORNECE+SC1->C1_LOJA)

If nAmarracao == 1 .Or. nAmarracao == 3 //Produto
	If !Empty(SC1->C1_FORNECE)
		cRefGrd:=Pad( AtuSA5(SC1->C1_FORNECE,SC1->C1_LOJA,SC1->C1_PRODUTO,MV_PAR11==2),14)
	Else
		cRefGrd := SC1->C1_PRODUTO
		lReferencia:= MatGrdPrrf(@cRefGrd,.T.)	
		cRefGrd := Pad(cRefGrd,14)
	EndIf
Else  //Grupo
	If !Empty(SC1->C1_FORNECE) .And. !Empty(SB1->B1_GRUPO)
		dbSelectArea("SAD")
		dbSetOrder(2)
		If ( !MsSeek(xFilial("SAD")+SB1->B1_GRUPO+SC1->C1_FORNECE+SC1->C1_LOJA) )
			RecLock("SAD",.T.)
			SAD->AD_FILIAL		:= xFilial("SAD")
			SAD->AD_GRUPO   	:= SB1->B1_GRUPO
			SAD->AD_FORNECE 	:= SC1->C1_FORNECE
			SAD->AD_LOJA		:= SC1->C1_LOJA
			SAD->AD_NOMEFOR	:= SA2->A2_NOME
			SAD->AD_NOMGRUP	:= Tabela("03",SB1->B1_GRUPO)
			MsUnLock()
		EndIf
	EndIf
EndIf

//Adiciona as amarracoes cadastradas                                      
If nAmarracao == 1 .Or. nAmarracao == 3  //Produto

	#IFDEF TOP
		If TcSrvType()!= "AS/400" 
			lQuery := .T.
			cQuery := "SELECT " 
			cQuery += a130CpoStr(aStruSa5,"M")
			cQuery +=" ,SA5.R_E_C_N_O_ SA5RECNO  "
			cQuery += "  FROM "+RetSqlName("SA5")+" SA5 "
			cQuery += " WHERE SA5.A5_FILIAL='"+xFilial("SA5")+"'"
			cQuery += "   AND SA5.A5_PRODUTO='"+SC1->C1_PRODUTO+"' AND "
			If !Empty(SC1->C1_FORNECE)
				cQuery += "SA5.A5_FORNECE='"+SC1->C1_FORNECE+"' AND "
			EndIf
			If !Empty(SC1->C1_LOJA) 
				cQuery += "SA5.A5_LOJA='"+SC1->C1_LOJA+"' AND "
			EndIf
			cQuery += "SA5.D_E_L_E_T_<>'*'"
			cQuery += "UNION "
			cQuery += "SELECT "
			cQuery += a130CpoStr(aStruSa5,"M")
			cQuery += "	,SA5.R_E_C_N_O_ SA5RECNO  "
			cQuery += "  FROM "+RetSqlName("SA5")+" SA5 "
			cQuery += " WHERE SA5.A5_FILIAL='"+xFilial("SA5")+"'"
			cQuery += "   AND SA5.A5_REFGRD='"+cRefGrd+"' AND "
			If !Empty(SC1->C1_FORNECE) 
				cQuery += "SA5.A5_FORNECE='"+SC1->C1_FORNECE+"' AND "
			EndIf
			If !Empty(SC1->C1_LOJA) 
				cQuery += "SA5.A5_LOJA='"+SC1->C1_LOJA+"' AND "
			EndIf
			cQuery += "SA5.D_E_L_E_T_<>'*'"
			cQuery += "AND ( SELECT Count(*) "
			cQuery += "        FROM "+RetSqlName("SA5")+" SA52 "
			cQuery += "       WHERE SA52.A5_PRODUTO='"+SC1->C1_PRODUTO+"'  "
			If MaConsRefG()
				cQuery += "AND SA5.A5_FORNECE=SA52.A5_FORNECE "
			EndIf
			cQuery += "AND SA52.D_E_L_E_T_<>'*') = 0"
			cQuery := ChangeQuery(cQuery)
			dbUseArea(.T.,"TOPCONN",TcGenQry(,,cQuery),"A130GRAVA",.T.,.T.)
			cAliasSA5 := "A130GRAVA"
			For nCntFor := 1 To Len(aStruSA5)
				If ( aStruSA5[nCntFor][2] $ "NDL" ) 
					TcSetField(cAliasSA5,aStruSA5[nCntFor][1],aStruSA5[nCntFor][2],aStruSA5[nCntFor][3],aStruSA5[nCntFor][4])
				EndIf
			Next nCntFor
		Else
	#ENDIF
		dbSelectArea("SA5")
		dbSetOrder(2)
		lAchou	:= MsSeek(xFilial("SA5")+SC1->C1_PRODUTO+AllTrim(SC1->C1_FORNECE+SC1->C1_LOJA))
		lRet	:= MaConsRefG() .Or. !lAchou

		If lRet .And. lReferencia
			dbSelectArea("SA5")
			dbSetOrder(10)
			MsSeek(xFilial("SA5")+cRefGrd+AllTrim(SC1->C1_FORNECE+SC1->C1_LOJA))
			While ( !Eof() .And. xFilial("SA5") == (cAliasSA5)->A5_FILIAL .And.;
					cRefGrd==(cAliasSA5)->A5_REFGRD  .And.;
					(SC1->C1_FORNECE == (cAliasSA5)->A5_FORNECE .Or. Empty(SC1->C1_FORNECE)) .And.;
					(SC1->C1_LOJA == (cAliasSA5)->A5_LOJA .Or. Empty(SC1->C1_LOJA)) )

				If Empty(SC1->C1_CC) .Or. (cAliasSA5)->(FieldPos("A5_CCUSTO"))==0 .Or. Empty((cAliasSA5)->(FieldGet(FieldPos("A5_CCUSTO"))))
					aadd(aFornec,{(cAliasSA5)->A5_FORNECE,(cAliasSA5)->A5_LOJA,"","SA5",IIF(lQuery,(cAliasSA5)->SA5RECNO,SA5->(Recno())) })
				ElseIf (cAliasSA5)->(FieldPos("A5_CCUSTO"))<>0 .And. (cAliasSA5)->(FieldGet(FieldPos("A5_CCUSTO"))) == SC1->C1_CC
					aadd(aFornec,{(cAliasSA5)->A5_FORNECE,(cAliasSA5)->A5_LOJA,"","SA5",IIF(lQuery,(cAliasSA5)->SA5RECNO,SA5->(Recno())) })
				EndIf
				dbSelectarea("SA5")
				dbSkip()
			Enddo
		Endif
	#IFDEF TOP
		EndIf
	#ENDIF

	dbSelectArea(cAliasSA5)
	While ( !Eof() .And. xFilial("SA5") == (cAliasSA5)->A5_FILIAL .And.;
			(SC1->C1_PRODUTO== (cAliasSA5)->A5_PRODUTO .Or. cRefGrd==(cAliasSA5)->A5_REFGRD)  .And.;
			(SC1->C1_FORNECE == (cAliasSA5)->A5_FORNECE .Or. Empty(SC1->C1_FORNECE)) .And.;
			(SC1->C1_LOJA == (cAliasSA5)->A5_LOJA .Or. Empty(SC1->C1_LOJA)) )

		// Verifica se o Fornecedor esta bloqueado
		lFornBloq := .F.
		If SA2->(MsSeek(xFilial("SA2")+(cAliasSA5)->A5_FORNECE+(cAliasSA5)->A5_LOJA))
			If !RegistroOk("SA2",.F.)
				lFornBloq := .T.
			EndIf
		EndIf
		//Verifica se o Produto x Fornecedor nao foi bloqueado pela Qualidade
		If QieSitFornec((cAliasSA5)->A5_FORNECE,(cAliasSA5)->A5_LOJA,SC1->C1_PRODUTO,.F.) .And. !lFornBloq
			If Empty(SC1->C1_CC) .Or. (cAliasSA5)->(FieldPos("A5_CCUSTO"))==0 .Or. Empty((cAliasSA5)->(FieldGet(FieldPos("A5_CCUSTO"))))
				aadd(aFornec,{(cAliasSA5)->A5_FORNECE,(cAliasSA5)->A5_LOJA,"","SA5",IIF(lQuery,(cAliasSA5)->SA5RECNO,SA5->(Recno())) })
			ElseIf (cAliasSA5)->(FieldPos("A5_CCUSTO"))<>0 .And. (cAliasSA5)->(FieldGet(FieldPos("A5_CCUSTO"))) == SC1->C1_CC
				aadd(aFornec,{(cAliasSA5)->A5_FORNECE,(cAliasSA5)->A5_LOJA,"","SA5",IIF(lQuery,(cAliasSA5)->SA5RECNO,SA5->(Recno())) })			
			EndIf
		EndIf

		dbSelectArea(cAliasSA5)
		dbSkip()

	EndDo

	If lQuery 
		dbSelectArea(cAliasSA5)
		dbCloseArea()
		dbSelectArea("SA5")
	EndIf

EndIf

If nAmarracao == 2 .Or. nAmarracao == 3 // Grupo

	#IFDEF TOP
		If TcSrvType()!="AS/400"
			lQuery := .T.
			cQuery := "SELECT SAD.*,SAD.R_E_C_N_O_ SADRECNO  "
			cQuery += "FROM "+RetSqlName("SAD")+" SAD "
			cQuery += "INNER JOIN "+RetSqlName("SA2")+" SA2 ON A2_FILIAL = '"+xFilial("SA2")+"' AND A2_COD = AD_FORNECE"
			cQuery += " AND A2_LOJA = AD_LOJA "
			cQuery += "WHERE SAD.AD_FILIAL='"+xFilial("SAD")+"' AND "
			cQuery += "SAD.AD_GRUPO='"+SB1->B1_GRUPO+"' AND A2_MSBLQL = '2' AND "
			If !Empty(SC1->C1_FORNECE) 
				cQuery += "SAD.AD_FORNECE='"+SC1->C1_FORNECE+"' AND "
			EndIf
			If !Empty(SC1->C1_LOJA) 
				cQuery += "SAD.AD_LOJA='"+SC1->C1_LOJA+"' AND "
			EndIf
			cQuery += "SAD.D_E_L_E_T_<>'*' AND SA2.D_E_L_E_T_<>'*'"
			cQuery := ChangeQuery(cQuery)
			dbUseArea(.T.,"TOPCONN",TcGenQry(,,cQuery),"A130GRAVA",.T.,.T.)
			cAliasSAD := "A130GRAVA"
			For nCntFor := 1 To Len(aStruSAD)
				If ( aStruSAD[nCntFor][2] $ "NDL" ) 
					TcSetField(cAliasSAD,aStruSAD[nCntFor][1],aStruSAD[nCntFor][2],aStruSAD[nCntFor][3],aStruSAD[nCntFor][4])
				EndIf
			Next nCntFor
		Else
	#ENDIF
		dbSelectArea("SAD")
		dbSetOrder(2)
		MsSeek(xFilial("SAD")+SB1->B1_GRUPO+AllTrim(SC1->C1_FORNECE+SC1->C1_LOJA))
	#IFDEF TOP
		EndIf
	#ENDIF

	dbSelectArea(cAliasSAD)
	While ( !Eof() .And. xFilial("SAD") == (cAliasSAD)->AD_FILIAL .And.;
			SB1->B1_GRUPO== (cAliasSAD)->AD_GRUPO .And.;
			(SC1->C1_FORNECE == (cAliasSAD)->AD_FORNECE .Or. Empty(SC1->C1_FORNECE)) .And.;
			(SC1->C1_LOJA == (cAliasSAD)->AD_LOJA .Or. Empty(SC1->C1_LOJA)) )

		If aScan(aFornec,{|x| x[1] == (cAliasSAD)->AD_FORNECE .And. x[2] == (cAliasSAD)->AD_LOJA}) == 0	
			aadd(aFornec,{(cAliasSAD)->AD_FORNECE,(cAliasSAD)->AD_LOJA,"","SAD",IIF(lQuery,(cAliasSAD)->SADRECNO,SAD->(Recno())) })
		EndIf

		dbSelectArea(cAliasSAD)
		dbSkip()
	EndDo

	If lQuery 
		dbSelectArea(cAliasSAD)
		dbCloseArea()
		dbSelectArea("SAD")
	EndIf

EndIf


//Verifica se deve permitir escolher fornecedores                        
If GetMv("MV_SELFOR")=="S" .And. !lReplica

	If !lReplica
		aUltFor		:= a130UlForn(nUltForn,SC1->C1_PRODUTO)
		For nCntFor := 1 To Len(aUltFor)
			nCont := aScan(aFornec,{|x| x[1]==aUltFor[nCntFor][1] .And. x[2]==aUltFor[nCntFor][2]})
			If nCont == 0 
				SA2->(MsSeek( xFilial("SA2")+aUltFor[nCntFor][1]+aUltFor[nCntFor][2]))
				aadd(aFornec,{ aUltFor[nCntFor][1],aUltFor[nCntFor][2],aUltFor[nCntFor][3],"SA2",SA2->(Recno())})
			Else
				aFornec[nCont][3] := aUltFor[nCntFor][3]
			EndIf
		Next nCntFor
	
		If ExistTemplate("MT130FOR")
			aFornecAux  := aClone(aFornec)
			aFornec		:= ExecTemplate("MT130FOR",.F.,.F.,aFornec)
			If ValType(aFornec)#"A"
				aFornec := aClone(aFornecAux)
			EndIf
		EndIf
	
		If ExistBlock("MT130FOR")
			aFornecAux  := aClone(aFornec)
			aFornec		:= ExecBlock("MT130FOR",.F.,.F.,aFornec)
			If ValType(aFornec)#"A"
				aFornec := aClone(aFornecAux)
			EndIf
		EndIf
	Else
		aFornec := aClone(aReplForn)
	EndIf
	
	nCont := Len(aFornec)
	aadd(aAlter,"AD_FORNECE")
	aadd(aAlter,"AD_LOJA")

	aadd(aHeader,{"Forncedor","AD_FORNECE" ,"@!", Len( SAD->AD_FORNECE ),0,"A130Fornece()" ," ","C","SAD"," " })
	aadd(aHeader,{"Loja","AD_LOJA"    ,"@!", Len( SAD->AD_LOJA )   ,0,"A130Loja()"    ," ","C","SAD"," " })
	aadd(aHeader,{"Nome","_NOME"      ,"@!",30,0,""              ," ","C"," "," " })
	aadd(aHeader,{"Critica","_CRITICA"   ,"@!",34,0,""              ," ","C"," "," " })

	If Len(aFornec) > 0 .And. ExistBlock("MT130HED")
		If ValType(aHeadUser:=ExecBlock("MT130HED",.F.,.F.,{aHeader})) == "A"
			For nX:= 1 To Len(aHeadUser)
				AAdd( aHeader, aHeadUser[nX] )
			Next
		Endif
	EndIf	

	//Walk Thru                   
	ADHeadRec("SA5",aHeader)
	nAchoForn := IIF(!Empty(MV_PAR01) .And. Len(aFornec) > MV_PAR01,MV_PAR01, Len(aFornec) ) 

	For nCntFor :=1 To nAchoForn

		dbSelectArea("SA2")
		dbSetOrder(1)
		MsSeek(xFilial("SA2")+aFornec[nCntFor][1]+aFornec[nCntFor][2])

		aadd(aCols,Array(4))

		aCols[nCntFor][1]:= aFornec[nCntFor][1]
		aCols[nCntFor][2]:= aFornec[nCntFor][2]
		aCols[nCntFor][3]:= SA2->A2_NOME
		aCols[nCntFor][4]:= PadR(aFornec[nCntFor][3],35)
		
		If ExistBlock("MT130COL") 
		    aCols130:=aClone(aCols) 
		    aadd(aCols[nCntFor],aFornec[nCntFor][4])
   		    aadd(aCols[nCntFor],aFornec[nCntFor][5])   
			If ValType(aColsUser:=ExecBlock("MT130COL",.F.,.F.,{aCols})) == "A"
				aCols:=aClone(aCols130)
				For nX:= 1 To Len(aColsUser)
					aadd(aCols[nCntFor],aColsUser[nX])
				Next
			Else
				aCols:=aClone(aCols130)
			Endif
        Endif

		If IsHeadAlias(aHeader[Len(aHeader)-1][2])
			aadd(aCols[nCntFor],aFornec[nCntFor][4])
		EndIf

		If IsHeadRec(aHeader[Len(aHeader)][2])
			aadd(aCols[nCntFor],aFornec[nCntFor][5])
		EndIf

		Aadd(aCols[nCntFor],.T.)

	Next nCntFor

	nCntFor := Len(aCols)

	If nCntFor < nFornec 
		nCont := Max(1,nCont)

		//Marca Todos                                                             

		aEval(aCols,{|x| x[Len(aHeader)+1] := .F.,x[4] := IIf(Empty(x[4]),"Aleatยขrio",x[4]) },1,nCntFor)
	Else

		//Marca os ultimos fornecimentos como prioridade                          
		nCont := Min(nCont,Len(aUltFor))
		nFornec 	-= nCont
		For nCntFor := 1 To Len(aCols)
			If nCont == 0
				Exit
			EndIf
			If !Empty(aCols[nCntFor][4])
				aCols[nCntFor][Len(aHeader)+1] := .F.
				nCont--
			EndIf
		Next nCntFor


		//Seleciona Randomicamente os Fornecedores conforme os parametros         
		nCntFor	:= Len(aCols)
		If nFornec > 0 
			While nFornec != 0 
				nCont := Aleatorio(nCntFor,Seconds()-Int(Seconds()))
				nCont := Min(nCont,nCntFor)
				nCont := Max(0,nCont)
				If ( nCont != 0 .And. aCols[nCont][Len(aHeader)+1] )
					nFornec --
					aCols[nCont][Len(aHeader)+1] := .F.
					aCols[nCont][4] := IIf(Empty(aCols[nCont][4]),"Aleatยขrio",aCols[nCont][4]) //"Aleatยขrio"
				EndIf
			EndDo
		EndIf
	EndIf


	//Preenche a Acols caso nao haja fornecedores                             
	If Len(Acols) == 0 

		aadd(aCols,Array(Len(aHeader)+1))

		aCols[Len(aCols)][1]:= CriaVar("AD_FORNECE")
		aCols[Len(aCols)][2]:= CriaVar("AD_LOJA")
		aCols[Len(aCols)][3]:= CriaVar("AD_NOMEFOR")
		aCols[Len(aCols)][4]:= Space(30)
		aCols[Len(aCols)][Len(aHeader)+1]:= .F.

	EndIf


	//Guarda os itens excluidos no Array auxiliar e desmarca excluidos do acols
	aDelItems := {}
	AEval( aCols, { |x,y| AAdd( aDelItems, x[Len(aHeader)+1] ), aCols[ y, Len(aHeader)+1 ] := .F. } )
	
	If ExistBlock("MT130BUTTONS",,.T.)
		aButtonUsr := ExecBlock("MT130BUTTONS",.F.,.F.)
	  	If ValType(aButtonUsr) == "A"
			For nInd   := 1  To  Len(aButtonUsr)
				Aadd(aButtons,aClone(aButtonUsr[nInd]))
			Next
		EndIf
	EndIf	


	//Permite a alteracao da selecao randomica                                
	AAdd( aObjects, { 000, 070, .T., .F. })
	AAdd( aObjects, { 100, 100, .T., .T. })
	aInfo  := { aSizeAut[ 1 ], aSizeAut[ 2 ], aSizeAut[ 3 ], aSizeAut[ 4 ], 3, 3 }
	aPosObj:= MsObjSize( aInfo, aObjects )
	DEFINE MSDIALOG oDlg TITLE "Seleโ€กโ€o dos Fornecedores" From aSizeAut[7],0 TO aSizeAut[6],aSizeAut[5] OF oMainWnd PIXEL 
	oScroll := TScrollBox():New( oDlg, aPosObj[1,1], 150, 25,210)	
	@ aPosObj[1,1]   ,001 SAY   "Produto: "                     SIZE 030,009 OF oDlg PIXEL //"Produto: "
	@ aPosObj[1,1]   ,035 MSGET SC1->C1_PRODUTO             SIZE 100,009 OF oDlg PIXEL WHEN .F.
	@ 002			 ,002 SAY "" PROMPT SC1->C1_DESCRI		SIZE 300,300 PIXEL Of oScroll
	@ aPosObj[1,1]+30,001 SAY   "Quantidade"+":"                 SIZE 030,009 OF oDlg PIXEL //"Quantidade"
	@ aPosObj[1,1]+30,035 MSGET nQtdSc					    SIZE 060,009 OF oDlg PIXEL WHEN .F. PICTURE PesqPict("SC1","C1_QUANT")  
	@ aPosObj[1,1]+30,100 SAY   "Data Necess."+":"                 SIZE 040,009 OF oDlg PIXEL //"Data Necess."
	@ aPosObj[1,1]+30,145 MSGET dValidade				    SIZE 040,009 OF oDlg PIXEL WHEN .F.
	@ aPosObj[1,1]+45,001 SAY   "C.Custo"+":"                 SIZE 030,009 OF oDlg PIXEL //"C.Custo"
	@ aPosObj[1,1]+45,035 MSGET SC1->C1_CC				    SIZE 040,009 OF oDlg PIXEL WHEN .F.
	@ aPosObj[1,1]+45,080 SAY   "Conta"+":"                 SIZE 040,009 OF oDlg PIXEL
	@ aPosObj[1,1]+45,125 MSGET SC1->C1_CONTA			    SIZE 060,009 OF oDlg PIXEL WHEN .F.

	oGet := MSGetDados():New(aPosObj[2,1],aPosObj[2,2],aPosObj[2,3],aPosObj[2,4],3,"A130LinOK","A130TudOK","",.T.,aAlter,,,IIf(!Empty(MV_PAR01),MV_PAR01,))
	oScroll:Reset()

	ACTIVATE MSDIALOG oDlg ON INIT ( ,;
		oGet:oBrowse:Refresh(), EnchoiceBar(oDlg,{||nOpcA:=1,IIf(oGet:TudoOk(),oDlg:End(),nOpcA:=0)},{||oDlg:End()},,aButtons))
	aFornec := {}

	If nOpcA == 1 
		aEval(aCols,{|x| IIf(!x[Len(aHeader)+1].And.!Empty(x[1]),aadd(aFornec,{ x[1] , x[2] , x[3], x[4], x[5] }),Nil)})
		If mv_par14==1 .And. lControle
			aReplForn  := aClone(aFornec)
			lReplica   := .T.  
			lControle  := .F.
		EndIf
	EndIf

Else

	//Procedimento para Replicar os Fornecedores para os demais produtos      
	If lReplica
		aFornec := aClone(aReplForn)
	EndIf	

	//Verifica ponto de entrada de templates                                  
	If ExistTemplate("MT130FOR")
		aFornecAux  := aClone(aFornec)
		aFornec		:= ExecTemplate("MT130FOR",.F.,.F.,aFornec)
		If ValType(aFornec)#"A"
			aFornec := aClone(aFornecAux)
		EndIf
	EndIf

	//Verifica ponto de entrada                                               
	If ExistBlock("MT130FOR")
		aFornecAux  := aClone(aFornec)
		aFornec		:= ExecBlock("MT130FOR",.F.,.F.,aFornec)
		If ValType(aFornec)#"A"
			aFornec := aClone(aFornecAux)
		EndIf
	EndIf
EndIf

If Len(aFornec) > 0 

	//Ajusta o numero da Cotacao                                              
	If Empty(cIdent) 
		cIdent  := StrZero(1,Len(SC8->C8_IDENT))
	EndIf

	If Len(aQuebra)>999 .Or. Empty(cNumCot) // Aqui eh previsto ate 150 fornecedores
		cNumCot	:= cCotNumber
		cItem	:= StrZero(1,Len(SC8->C8_ITEM))
		aQuebra := {}
	EndIf

	Begin Transaction

		dbSelectArea("SC1")
		dbSetOrder(1)
		MsGoto(aSCs[Len(aSCs)])

		cProdRef := SC1->C1_PRODUTO
		lReferencia := MatGrdPrrf(@cProdRef, .T.)

		If ! Empty(SC1->C1_ITEMGRD) .And. lReferencia
			If (nScan := aScan(aGrade, {|z| z[1] == SC1->C1_PRODUTO })) == 0

				If (nScanRef   := aScan(aGrade, {|z| z[2] == cProdRef })) == 0
					aLastIdent := aClone(aGrade)
					aLastIdent := aSort(aLastIdent,,,{|x,y| x[5]+x[3] < y[5]+y[3] })

					cLastIdent := Soma1(aLastIdent[Len(aLastIdent), 5])
					cLastItem  := Soma1(aLastIdent[Len(aLastIdent), 3])
					cItemGrd   := StrZero(1,Len(SC8->C8_ITEMGRD))
				Else
					If (nScanFirst := aScan(aFirstIdent, {|z| z[2] == cProdRef })) > 0
						cLastIdent := aFirstIdent[nScanFirst, 5]
						cLastItem  := aFirstIdent[nScanFirst, 3]
					Else
						cLastIdent := aGrade[nScanRef, 5]
						cLastItem  := aGrade[nScanRef, 3]
					EndIf

					cItemGrd   := Soma1(aGrade[nScanRef, 4])

					aGrade[nScanRef, 4] := cItemGrd
				EndIf

				Aadd(aGrade, { SC1->C1_PRODUTO , cProdRef , cLastItem , cItemGrd , cLastIdent } )
				nScan := Len(aGrade)
			Else

				Aadd(aFirstIdent, { aGrade[nScan,1],aGrade[nScan,2],aGrade[nScan,3],aGrade[nScan,4],aGrade[nScan,5]})

				aGrade[nScan, 3] := Soma1(aGrade[nScan, 3]) // item
				aGrade[nScan, 5] := Soma1(aGrade[nScan, 5]) // ident

			Endif

		Else
			nScan := Nil
		Endif

		//Atualiza as solicitacoes de compra                                      
		nQtdSC := 0
		nQtdSC2:= 0
		dbSelectArea("SC1")
		dbSetOrder(1)
		For nCont := 1 To Len(aSCs)
			MsGoto(aSCs[nCont])
			RecLock("SC1",.F.)
			SC1->C1_COTACAO:= cNumCot
			SC1->C1_IDENT   := If(nScan == Nil,cIdent ,aGrade[nScan, 5])
			nQtdSC			+= SC1->C1_QUANT - SC1->C1_QUJE
			nQtdSC2			+= SC1->C1_QTSEGUM
			MsUnLock()
			
			If lPrjCni

				RSTSCLOG("COT",1,/*cUser*/)	
				
				//Controle do Rateio Financeiro                                           
				If SC1->C1_RATFIN == "1"
					cChaveRat := "SC1"+SC1->C1_FILIAL+SC1->C1_NUM
					F641TrfRat(cChaveRat,@aRatFin,SC1->C1_QUANT)
				EndIf
			EndIf
			
			MaAvalSC("SC1",4)
		Next nCont

		For nCntFor := 1 To Len(aFornec)
			lGravou := .T.

			//Posiciona Registros                                                     
			If cItem <= Repl("Z",Len(SC8->C8_ITEM)) 
				dbSelectArea("SA2")
				dbSetOrder(1)
				MsSeek(xFilial("SA2")+aFornec[nCntFor,1]+aFornec[nCntFor,2])
				dbSelectArea("SA5")
				dbSetOrder(1)
				lAchou:=MsSeek(xFilial("SA5")+aFornec[nCntFor,1]+aFornec[nCntFor,2]+SC1->C1_PRODUTO)
				If !lachou .And. lReferencia
					dbSelectArea("SA5")
					dbSetOrder(9)
					lAchou:=MsSeek(xFilial("SA5")+aFornec[nCntFor,1]+aFornec[nCntFor,2]+cProdRef)
				Endif

				If lAchou
					cCodTab := SA5->A5_CODTAB
				Endif


				//Carrega o codigo da tabela de precos do grupo X fornecedor caso hover.  
				If SAD->(FieldPos("AD_CODTAB")) > 0
					If (nAmarracao == 2 .Or. nAmarracao == 3 )// Grupo
						dbSelectArea("SAD")
						dbSetOrder(2)
						MsSeek(xFilial("SAD")+SB1->B1_GRUPO+aFornec[nCntFor,1]+aFornec[nCntFor,2])
						If Empty(cCodTab)
							cCodTab := SAD->AD_CODTAB
						EndIf
					EndIf
				EndIf

				//Ponto de Entrada para selecionar uma nova tabela de preco para cotacao. 
				If ExistBlock("A130CODTAB")
					cNewCodTab:=ExecBlock("A130CODTAB",.F.,.F.,{SC1->C1_PRODUTO,SB1->B1_GRUPO,aFornec[nCntFor,1],aFornec[nCntFor,2],cCodtab})
					If ValType(cNewCodTab) == "C"
						cCodTab:=cNewCodTab
					EndIf
				EndIf
                
                If lItem
                dbselectarea("SC8")
                SC8->(dbOrderNickName("COTACNEW"))
                If dbseek(xFilial("SC8")+cNumCot)
            	    While SC8->(!Eof()) .and. xFilial("SC8")+cNumCot == SC8->C8_FILIAL+SC8->C8_NUM
						cItem  := SC8->C8_ITEM
						lItem := .F.
    	        	    SC8->(dbskip())
             	   EndDo
                EndIf
				EndIf
				
				RecLock("SC8",.T.)
				SC8->C8_FILIAL  :=  xFilial("SC8")
				SC8->C8_FILENT  :=  SC1->C1_FILENT
				SC8->C8_NUM     :=  cNumCot
				SC8->C8_ITEM    :=  soma1(cItem)//If(nScan == Nil, cItem, aGrade[nScan, 3])
				SC8->C8_EMISSAO :=  dDataBase
				SC8->C8_CONTATO :=  SA2->A2_CONTATO
				SC8->C8_GRUPCOM :=  SC1->C1_GRUPCOM
				SC8->C8_COND    :=  SA2->A2_COND
				SC8->C8_FORNECE :=  SA2->A2_COD
				SC8->C8_LOJA    :=  SA2->A2_LOJA
				SC8->C8_PRODUTO :=  SC1->C1_PRODUTO
				SC8->C8_PRAZO   :=  RetFldProd(SB1->B1_COD,"B1_PE")
				SC8->C8_UM      :=  SC1->C1_UM
				SC8->C8_VALIDA  :=  dValidade
				SC8->C8_QUANT   :=  nQtdSC
				SC8->C8_NUMPRO  :=  "01"
				SC8->C8_DATPRF  := Max(SC1->C1_DATPRF,dDataBase) 
				SC8->C8_NUMSC   := SC1->C1_NUM
				SC8->C8_ITEMSC  := SC1->C1_ITEM
				SC8->C8_ITSCGRD := SC1->C1_ITEMGRD
				SC8->C8_OBS     := SC1->C1_OBS
				SC8->C8_IDENT   := If(nScan == Nil,cIdent ,aGrade[nScan, 5])
				SC8->C8_SEGUM	:= SC1->C1_SEGUM
				SC8->C8_QTSEGUM := nQtdSC2
				SC8->C8_CODTAB  := cCodTab
				SC8->C8_ORIGEM  := SC1->C1_ORIGEM
				
				If SC8->(FieldPos("C8_PRECOOR")) > 0
					SC8->C8_PRECOOR := SC1->C1_VUNIT
				EndIf	

				If cPaisLoc == "BRA"
					SC8->C8_PICM    := SB1->B1_PICM
					SC8->C8_ALIIPI  := SB1->B1_IPI				
				EndIf

				SC8->C8_ITEMGRD := If(nScan == Nil, "" , aGrade[nScan, 4])
				SC8->C8_GRADE   := If(nScan == Nil, "" , "S")

				If !Empty(SC8->C8_CODTAB)
					dbSelectArea("AIA")
					dbSetOrder(1)
					If MsSeek(xFilial("AIA")+SC8->C8_FORNECE+SC8->C8_LOJA+SC8->C8_CODTAB)
						If !Empty(AIA->AIA_CONDPG)
							SC8->C8_COND := AIA->AIA_CONDPG
						EndIf
						SC8->C8_PRECO   := MaTabPrCom(SC8->C8_CODTAB,SC8->C8_PRODUTO,SC8->C8_QUANT,SC8->C8_FORNECE,SC8->C8_LOJA,1,SC8->C8_EMISSAO)
						SC8->C8_TOTAL   := NoRound(SC8->C8_QUANT*SC8->C8_PRECO,2)
					EndIf
				EndIf
				
				//Controle do Rateio Financeiro                                           
				If lPrjCni
					If SC1->C1_RATFIN == "1"
						SC8->C8_RATFIN := "1"	// 1 = Sim; 2 = Nao
					EndIf
				EndIf
				
				SC8->C8_FORNOME := alltrim(SA2->A2_NOME)
				SC8->C8_FORMAIL := alltrim(SA2->A2_EMAIL)
//				SC8->C8_CRITER := "INCLUSรO CLICBUSINESS"

				MsUnLock()

				If nScan == Nil
					cItemNoGrd:= cItem
//					cItem	  := Soma1(cItem)
				Endif

				// Conforme situacao do parametro abaixo, integra com o SIGAGSP 
				// MV_SIGAGSP - 0-Nao / 1-Integra                   
				If SuperGetMV("MV_SIGAGSP",.F.,"0") == "1"
					GSPF180()
				EndIf

				If ( ExistBlock("MTA130C8") )
					Execblock("MTA130C8",.F.,.F.)
				EndIf

			EndIf
		Next nCntFor

		lItem := .T.

		If lPrjCni
			//Grava rateio financeiro
			If Len(aRatFin) > 0
				cChaveRat := "SC8"+SC8->C8_FILIAL+SC8->C8_NUM
				F641GrvRat(cChaveRat,aRatFin)
				aRatFin := {}
			EndIf
		EndIf
		
		If aScan(aQuebra,SC1->C1_PRODUTO) == 0
			aadd(aQuebra,SC1->C1_PRODUTO)
		EndIf

		//Incrementa o Identificador de cotacao                                   
		If nScan == Nil
			aGrade := {{"","",cItemNoGrd,"000",cIdent}}  // Controle do Numero do Item e do Ident para Produto de Grade
			cIdent := Soma1(cIdent)
		Endif	

	End Transaction

Else
	If ( GetMv("MV_SELFOR")="S" ) .And. !lReplica
		If nOpcA == 1 
			lPrdxForn := .F.	
		EndIf		
    Else
		lPrdxForn := .F.
    EndIf
EndIf

//Restaura a Entrada                                                      
RestArea(aAreaSC1)
RestArea(aAreaSB1)
RestArea(aAreaSA5)
RestArea(aAreaSA2)
RestArea(aAreaSAD)
RestArea(aArea)

Return(lGravou)


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณ A130Lock บ Autor ณ Microsiga          บ Data ณ  19/05/15   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDescricao ณ Tratamento do Bloqueio da Geracao das Cotacoes             บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑบParametrosณ ExpL1: Indica se a operacao eh de bloqueio ou nao          บฑฑ
ฑฑบ          ณ ExpA2: Locks dos grupos de compra                          บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ AP                                                         บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
Static Function A130Lock( lTrava , aLocks )

Local aArea		:= GetArea()
Local aGrupos   := {}
Local lRetorno  := .F.
Local nLimite   := 0
Local nX        := 0

//Ponto de entrada para selecao dos grupos de compra
If ExistBlock("A130LOCK") .And. lTrava
	aGrupos := ExecBlock("A130LOCK",.F.,.F.,{lTrava})
EndIf

//Verifica o parametro de restricao de compradores
If Empty(aGrupos) .And. SuperGetMv("MV_RESTCOM")=="S" .And. lTrava
	aGrupos := UsrGrComp(RetCodUsr())
Else
	If !lTrava
		aGrupos := aLocks
	EndIf
EndIf

If Empty(aGrupos)
	
	//Posiciona no SX6 para efetuar o Travamento
	dbSelectArea("SX6")
	dbSetOrder(1)
	If !MsSeek( xFilial("SC7")+"MV_LOCKCT",.F. )
		RecLock( "SX6",.T. )
		SX6->X6_FIL     :=  xFilial("SC7")
		SX6->X6_VAR     := "MV_LOCKCT"
		SX6->X6_TIPO    := "C"
		SX6->X6_DESCRIC := "Controle de Geracao de Cotacoes por Filial"
		MsUnLock()
	EndIf
	
	If lTrava
		While !lRetorno .And. nLimite <= 5
			lRetorno := MsRLock()
			If ( !lRetorno )
				nLimite++
				Inkey(nLimite)
			EndIf
		EndDo
		If ( !lRetorno )
			HELP(" ",1,"A130NGERA")
		EndIf
	Else
		MsRUnLock()
	EndIf
Else
	If lTrava
		For nX := 1 To Len(aGrupos)
			If LockByName("MATA130LOCKCT"+aGrupos[nX],.T.,!Empty(xFilial("SC1")),.T.)
				aadd(aLocks,"MATA130LOCKCT"+aGrupos[nX])
				lRetorno := .T.
			Else
				HELP(" ",1,"A130NGERA")
				For nX := 1 To Len(aLocks)
					UnLockByName(aLocks[nX],.T.,!Empty(xFilial("SC1")),.T.)
				Next nX
				lRetorno := .F.
				nX := Len(aGrupos) + 1
			EndIf
		Next nX
	Else
		For nX := 1 To Len(aLocks)
			UnLockByName(aLocks[nX],.T.,!Empty(xFilial("SC1")),.T.)
		Next nX
	EndIf
EndIf

RestArea(aArea)
Return( lRetorno )


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณ AjustaSX1  บ Autor ณ Carlos A. Queiroz  บ Data ณ  19/05/15   บฑฑ
ฑฑฬออออออออออุออออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ Cria as perguntas com os parametros que serao utilizados nos บฑฑ
ฑฑบ          ณ filtros da inteface de Cotacoes.                             บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ GJP Hotels & Resorts                                         บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
Static Function AjustaSX1()
Local aHelpPor := {}
Local aHelpEng := {}
Local aHelpSpa := {}

aHelpPor := {"Informe o c๓digo inicial."}
aHelpSpa := {"Informe o c๓digo inicial."}
aHelpEng := {"Informe o c๓digo inicial."}

PutSx1( "COT130","01","Cota็ใo de?","Cota็ใo de?","Cota็ใo de?","mv_ch1",;
"C",6,0,0,"G","","","","","mv_par01","","","","","","","","","","","","","","","","",aHelpPor,aHelpEng,aHelpSpa)

aHelpPor := {}
aHelpEng := {}
aHelpSpa := {}

aHelpPor := {"Informe o c๓digo final."}
aHelpSpa := {"Informe o c๓digo final."}
aHelpEng := {"Informe o c๓digo final."}

PutSx1( "COT130","02","Cota็ใo at้?","Cota็ใo at้?","Cota็ใo at้?","mv_ch2",;
"C",6,0,0,"G","","","","","mv_par02","","","","","","","","","","","","","","","","",aHelpPor,aHelpEng,aHelpSpa)

aHelpPor := {}
aHelpEng := {}
aHelpSpa := {}

aHelpPor := {"Cota็๕es que serใo exibidas."}
aHelpSpa := {"Cota็๕es que serใo exibidas."}
aHelpEng := {"Cota็๕es que serใo exibidas."}

PutSx1( "COT130","03","Exibir Cota็๕es","Exibir Cota็๕es","Exibir Cota็๕es","mv_ch3",;
"N",1,0,0,"C","","","","","mv_par03","Todas","Todas","Todas","","Em aberto","Em aberto","Em aberto","","","","","","","","","",aHelpPor,aHelpEng,aHelpSpa)

aHelpPor := {"Informe a SC inicial."}
aHelpSpa := {"Informe a SC inicial."}
aHelpEng := {"Informe a SC inicial."}

PutSx1( "COT130","04","Solicita็ใo de?","Solicita็ใo de?","Solicita็ใo de?","mv_ch4",;
"C",6,0,0,"G","","SC1","","","mv_par04","","","","","","","","","","","","","","","","",aHelpPor,aHelpEng,aHelpSpa)

aHelpPor := {}
aHelpEng := {}
aHelpSpa := {}

aHelpPor := {"Informe a SC final."}
aHelpSpa := {"Informe a SC final."}
aHelpEng := {"Informe a SC final."}

PutSx1( "COT130","05","Solicita็ใo at้?","Solicita็ใo at้?","Solicita็ใo at้?","mv_ch5",;
"C",6,0,0,"G","","SC1","","","mv_par05","","","","","","","","","","","","","","","","",aHelpPor,aHelpEng,aHelpSpa)

aHelpPor := {"Informe o Comprador."}
aHelpSpa := {"Informe o Comprador."}
aHelpEng := {"Informe o Comprador."}

PutSx1( "COT130","06","C๓digo do Comprador","C๓digo do Comprador","C๓digo do Comprador","mv_ch6",;
"C",6,0,0,"G","","USR","","","mv_par06","","","","","","","","","","","","","","","","",aHelpPor,aHelpEng,aHelpSpa)

MV_PAR06 := __cUserId

Return Nil

Static Function xA131Mark()

Local aArea   := GetArea()
Local cSeekSC1:= xFilial('SC1')+SC1->C1_NUM+SC1->C1_ITEM
Local cMarkSC := SC1->C1_OK
Local nRecno  := Recno()

//If Empty(cMarkSC) .OR. !IsMark("C1_OK",cMarca)
If aScan(aCotMark,{|x| x == SC1->(Recno())}) == 0
	AAdd( aCotMark, SC1->(Recno()) )
EndIf
//ElseIf Len(aCotMark) > 0 .AND. IsMark("C1_OK",cMarca)
//	aDel(aCotMark, 1)
//	aSize(aCotMark,Len(aCotMark)-1)
//EndIf
/*
If lMultCot
//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
//ณCodigo para tratamento da marca e lock de registros para versao Multi-Usuario.ณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
SC1->(dbGoTo(Recno()))

If SimpleLock("SC1",.F.)
SC1->C1_OK := Iif( IsMark("C1_OK",cMarca) , Space(Len(SC1->C1_OK)) , cMarca )

If SC1->(FieldPos("C1_USRCODE")) > 0
SC1->C1_USRCODE := Iif(!Empty(SC1->C1_OK) , RetCodUsr() , Space(Len(SC1->C1_USRCODE)) )
EndIf

cMarkSC := SC1->C1_OK

If !Empty(SC1->C1_OK) .And. IsMark("C1_OK",cMarca)
If aScan(aRecMark,{|x| x == SC1->(Recno())}) == 0
AAdd( aRecMark, SC1->(Recno()) )
EndIf
Else
MsUnLock()
EndIf

If MaGrade()
dbSelectArea("SC1")
dbSetOrder(1)
If MsSeek(cSeekSC1, .F.)
Do While !Eof() .And. cSeekSC1 == SC1->C1_FILIAL+SC1->C1_NUM+SC1->C1_ITEM
If !(nRecno==Recno())
If SimpleLock("SC1",.F.)
SC1->C1_OK := cMarkSC
SC1->C1_USRCODE := Iif(!Empty(SC1->C1_OK) , RetCodUsr() , Space(Len(SC1->C1_USRCODE)) )
If !Empty(SC1->C1_OK) .And. IsMark("C1_OK",cMarca)
If aScan(aRecMark,{|x| x == SC1->(Recno())}) == 0
AAdd( aRecMark, SC1->(Recno()) )
EndIf
Else
MsUnLock()
EndIf

EndIf
EndIf
dbSkip()
Enddo
EndIf
EndIf
Else
If !Empty(SC1->C1_OK)
Aviso("a131NOMARK", "Este Registro ja foi marcado e esta sendo utilizado pelo usuario." + SC1->C1_USRCODE + " " + UsrRetName(SC1->C1_USRCODE),{"Ok"},1) //"Este Registro ja foi marcado e esta sendo utilizado pelo usuario "
Else
Aviso("a131NOLOCK", "Este Registro esta sendo utilizado por outro processo de atualiza็ใo no momento e nใo podera ser marcado." ,{"Ok"},1) //"Este Registro esta sendo utilizado por outro processo de atualiza็ใo no momento e nใo podera ser marcado."
EndIf
EndIf

SC1->(dbCommit())

Else
//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
//ณCodigo para tratamento da marca e lock de registros para versao Mono-Usuario. ณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
RecLock("SC1",.F.)
SC1->C1_OK := Iif( IsMark("C1_OK",cMarca) , Space(Len(SC1->C1_OK)) , cMarca )
cMarkSC    := SC1->C1_OK
MsUnLock()

dbSelectArea("SC1")
dbSetOrder(1)
SC1->(dbGoTop())
If MsSeek(cSeekSC1, .F.)
Do While !Eof() .And. cSeekSC1 == SC1->C1_FILIAL+SC1->C1_NUM+SC1->C1_ITEM
If !(nRecno==Recno())
Reclock("SC1", .F.)
SC1->C1_OK := cMarkSC
MsUnlock()
EndIf
dbSkip()
Enddo
SC1->(dbCommit())//--Para forcar o refresh pois com DB2(AS400) nao funcionava.
SC1->(dbGoTop()) //--Markbrowse
EndIf

EndIf
*/
RestArea(aArea)
//MarkBRefresh()

Return .T.


/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑฺฤฤฤฤฤฤฤฤฤฤยฤฤฤฤฤฤฤฤฤฤยฤฤฤฤฤฤฤยฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤยฤฤฤฤฤฤยฤฤฤฤฤฤฤฤฤฤฟฑฑ
ฑฑณFuncao    ณA131Gera  ณ Autor ณEdson Maricate         ณ Data ณ01.09.98  ณฑฑ
ฑฑรฤฤฤฤฤฤฤฤฤฤลฤฤฤฤฤฤฤฤฤฤมฤฤฤฤฤฤฤมฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤมฤฤฤฤฤฤมฤฤฤฤฤฤฤฤฤฤดฑฑ
ฑฑณDescri…o ณGera Cotacoes atraves da Solicitacoes marcadas              ณฑฑ
ฑฑรฤฤฤฤฤฤฤฤฤฤลฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤดฑฑ
ฑฑณParametrosณcExpC1: Alias do Arquivo                                    ณฑฑ
ฑฑณ          ณcExpC2: Campo do Arquivo                                    ณฑฑ
ฑฑณ          ณcExpN3: Opcao selecionada                                   ณฑฑ
ฑฑณ          ณcExpC4: Marca realizada no campo                            ณฑฑ
ฑฑณ          ณcExpL5: Indica se a marca esta invertida                    ณฑฑ
ฑฑรฤฤฤฤฤฤฤฤฤฤลฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤดฑฑ
ฑฑณRetorno   ณNenhum                                                      ณฑฑ
ฑฑภฤฤฤฤฤฤฤฤฤฤมฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤูฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
/*/
Static Function xA131Gera(cAlias,cCampo,nOpcE,cMarca,lInverte)

Local aArea		  := GetArea()
Local aLocks      := {}

Local dValidade	  := dDataBase

Local nDiasVal    := MV_PAR04
Local nAmarracao  := MV_PAR06
Local nFornec	  := 0
Local nUltForn 	  := 0
Local nX          := 0

Local lRelatorio  := MV_PAR07 == 1
Local lContinua	  := .T.
Local la131Lock   := .T.
Local aSc8Item    := {}
Local _cWhileCot  := ""
Local cVar1       := ""
Local cVar2       := ""
Local cVar3       := ""
Local cVar4       := ""
Local cVar5       := ""

//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
//ณQuando nao estiver sendo utilizado o recurso de Multiusuario mantem o   ณ
//ณcontrole de semaforo padrao utilizado antes da implementacao do         ณ
//ณMV_MULTCOT.                                                             ณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
If !lMultCot
	la131Lock :=( StaticCall(MATA131,a131Lock,.T.,@aLocks) )
EndIf

//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
//ณVerifica se nenhum outro usuario esta gerando cotacao.                  ณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
If la131Lock
	
	//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
	//ณCalcula a Data de Validade da Cotacao descontando Sab/Dom e Feriadosณ
	//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
	While nDiasVal > 0
		
		dValidade ++
		
		dValida := DataValida(dValidade)
		
		If dValida == dValidade
			nDiasVal--
		EndIf
		
	EndDo
	
	//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
	//ณVerifica se o usuario pode selecionar fornecedores                  ณ
	//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
	// 	If Len(aCotMark) > 0
	If ( GetMv("MV_SELFOR",.F.,"N")="S" )
		While ( lContinua )
			If ( Pergunte("MTA131",.T.) )
				If ( MV_PAR01 < MV_PAR02 )
					Help(" ",1,"a130SELE")
				Else
					Exit
				EndIf
			Else
				lContinua := .F.
				Exit
			EndIf
		EndDo
		
		nFornec	 := MV_PAR01
		nUltForn 	 := MV_PAR02
		
	EndIf
	// 	Else
	//		lContinua := .F.
	//	EndIf
	
	//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
	//ณInicia o Processamento de geracao das cotacoes                          ณ
	//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
	If lContinua
		Processa({|lEnd| U_xa131Proc(nAmarracao,nFornec,nUltForn,dValidade,lRelatorio)    })
		//		Processa({|lEnd| StaticCall(MATA131,a131Proces,nAmarracao,nFornec,nUltForn,dValidade,lRelatorio)    })
		//		StaticCall(MATA131,a131Proces,nAmarracao,nFornec,nUltForn,dValidade,lRelatorio)
	EndIf
	
	//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
	//ณDesbloqueia a geracao de Cotacao                                        ณ
	//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
	If !lMultCot
		StaticCall(MATA131,a131Lock,.F.,aLocks)
	Else
		//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
		//ณA rotina a seguir varre o Array aRecMark com os registros locados pela  ณ
		//ณmarkbrowse quando o MV_MULTCOT estiver ativo para limpar as marcas realiณ
		//ณzadas no C1_OK de todos os registros marcados pelo usuario.             ณ
		//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
		dbSelectArea("SC1")
		For nX:=1 To Len(aRecMark)
			SC1->( dbGoto( aRecMark[nX] ) )
			If IsMark("C1_OK",cMarca)
				If SimpleLock("SC1",.F.)
					SC1->C1_OK      := Space(Len(SC1->C1_OK))
					If SC1->(FieldPos("C1_USRCODE")) > 0
						SC1->C1_USRCODE := Space(Len(SC1->C1_USRCODE))
					EndIf
					MsUnLock()
				EndIf
			EndIf
		Next nX
	EndIf
	
EndIf

RestArea(aArea)

//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
//ณ Caso nenhuma ordem esteja selecionada, seleciona a ordem 1   ณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
If Empty( SC1->( IndexOrd() ) )
	SC1->( dbSetOrder( 1 ) )
EndIf

If !empty(SC1->C1_COTACAO)
	
	dbselectarea("SC8")
	dbsetorder(1)
	_cWhileCot := xFilial("SC8")+SC1->C1_COTACAO
	If dbseek(xFilial("SC8")+SC1->C1_COTACAO)
		While SC8->(!EOF()) .and. _cWhileCot == SC8->C8_FILIAL+SC8->C8_NUM
			aadd(aSc8Item,{SC8->C8_NUM,SC8->C8_NUMSC,SC8->C8_ITEMSC,SC8->C8_PRODUTO,SC8->C8_ITEM})
			SC8->(dbskip())
		EndDo
		aSort(aSc8Item,,, { |x,y| x[1]+x[2]+x[3]+x[4] < y[1]+y[2]+y[3]+y[4] } )
	EndIf
	
	If len(aSc8Item) > 0
		cVar1 := aSc8Item[1][1]
		cVar2 := aSc8Item[1][2]
		cVar3 := aSc8Item[1][3]
		cVar4 := aSc8Item[1][4]
		cVar5 := STRZERO(1,TamSX3("C8_ITEM")[1])
	EndIf
	
	For i:=1 to len(aSc8Item)
		If cVar1 == aSc8Item[i][1] .and. cVar2 == aSc8Item[i][2] .and. cVar3 == aSc8Item[i][3] .and. cVar4 == aSc8Item[i][4]
			aSc8Item[i][5] := cVar5
		Else
			cVar5 := Soma1(cVar5)
			
			cVar1 := aSc8Item[i][1]
			cVar2 := aSc8Item[i][2]
			cVar3 := aSc8Item[i][3]
			cVar4 := aSc8Item[i][4]
			
			aSc8Item[i][5] := cVar5
		EndIf
	Next i
	
	cVar5 := STRZERO(500,TamSX3("C8_ITEM")[1])
	
	dbselectarea("SC8")
	dbsetorder(1)
	_cWhileCot := xFilial("SC8")+SC1->C1_COTACAO
	If dbseek(xFilial("SC8")+SC1->C1_COTACAO)
		While SC8->(!EOF()) .and. _cWhileCot == SC8->C8_FILIAL+SC8->C8_NUM
			RecLock("SC8",.F.)
			SC8->C8_ITEM := cVar5
			SC8->(msunlock())
			cVar5 := Soma1(cVar5)
			SC8->(dbskip())
		EndDo
	EndIf
	
	dbselectarea("SC8")
	SC8->(dbOrderNickName("COTSC"))
	_cWhileCot := xFilial("SC8")+SC1->C1_COTACAO
	If dbseek(xFilial("SC8")+SC1->C1_COTACAO)
		While SC8->(!EOF()) .and. _cWhileCot == SC8->C8_FILIAL+SC8->C8_NUM
			For i:=1 to len(aSc8Item)
				If aSc8Item[i][1] == SC8->C8_NUM .and. aSc8Item[i][2] == SC8->C8_NUMSC .and. aSc8Item[i][3] == SC8->C8_ITEMSC .and. aSc8Item[i][4] == SC8->C8_PRODUTO
					RecLock("SC8",.F.)
					SC8->C8_ITEM := aSc8Item[i][5]
					SC8->(msunlock())
					i:=len(aSc8Item)
				EndIf
			Next i
			SC8->(dbskip())
		EndDo
	EndIf
	
	msginfo("Cota็ใo "+alltrim(SC1->C1_COTACAO)+" criada com sucesso.")
	
EndIf

Return(Nil)


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณGJP130COT บAutor  ณMicrosiga           บ Data ณ  07/14/15   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ                                                            บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ AP                                                        บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
Static Function xA161MapCot(_cFornec,_cLoja,_cGera)

Local oDlg

//Local aItens		:= {}
//Local aPropostas	:= {}
Local aItensC		:= {"Pedido de Compra","Contrato"}//"Pedido de Compra"//"Contrato"

Local cTpDoc 		:= If(Val(_cGera)== 1,"Pedido de Compra","Contrato")//"Pedido de Compra"//"Contrato"

Local nTpDoc

Local oSize		:= FWDefSize():New(.T.)
Local lOk			:= .F.

PRIVATE cCadastro := "Anแlise de Cota็ใo"
PRIVATE INCLUI    := .T.
PRIVATE aItens		:= {}
PRIVATE aPropostas	:= {}

//aCoors := FWGetDialogSize(oMainWnd) //&&&&&

//DEFINE MSDIALOG oDlg TITLE cCadastro FROM oSize:aWindSize[1],oSize:aWindSize[2] TO oSize:aWindSize[3],oSize:aWindSize[4] PIXEL //&&&&&

//ACTIVATE MSDIALOG oDlg ON INIT (EnchoiceBar(oDlg,{||lOk := .T.,aItens:=aClone(aItens) ,aPropostas:=aClone(aPropostas),oDlg:End()},{||lOk:= .F., oDlg:End()}),xConstLayer(oDlg, @aItens, @aPropostas,@aItensC,@cTpDoc)) //&&&&&

lOk := .T.

xConstLayer(oDlg, @aItens, @aPropostas,@aItensC,@cTpDoc,_cFornec,_cLoja)
//_cFornec,_cLoja - Escolher vencedor no aPropostas

If !empty(aItens) .and. !empty(aPropostas)
	lOk := .T.
EndIf

If lOk
	For j:=1 to Len(aPropostas[1])
		If !empty(aPropostas[1][j][1])
			If aPropostas[1][j][1][1] == _cFornec .and. aPropostas[1][j][1][2] == _cLoja
				For l:=1 to Len(aPropostas[1][j][2])
					aPropostas[1][j][2][l][1] := .T.
				Next l
				// 			j:=Len(aPropostas[1])
			EndIf
		EndIf
	Next j
	nTpDoc := aScan(aItensC,{|x| x == cTpDoc})
	A161GerDoc(aItens,aPropostas,nTpDoc) //Efetua a gera็ใo do pedido de compra ou contrato
EndIf

//SetKey( VK_F4,{||NIL} ) //&&&&&
//SetKey( VK_F5,{||NIL} ) //&&&&&
//SetKey( VK_F6,{||NIL} ) //&&&&&
//SetKey( VK_F7,{||NIL} ) //&&&&&

Return Nil

Static Function xConstLayer(oDlg, aItens, aPropostas,aItensC,cTpDoc,_cFornec,_cLoja)

Local oFWLayer
Local oPanel0
Local oPanel1
Local oPanel2
Local oPanel3
Local oBrowse1
Local oBrowse2
Local oBrowse3
Local oVlrFinal

Local aCoors		:= {}

Local dDataVld 	:= SC8->C8_VALIDA
Local cCotacao 	:= SC8->C8_NUM

Local cFor1		:= ''
Local cFor2		:= ''
Local cCondPag1	:= SC8->C8_COND
Local cCondPag2	:= Space(30)
Local cTpFrete1	:= Space(30)
Local cTpFrete2	:= Space(30)

Local nVlrFinal		:= 0
Local nPag			:= 1
Local nNumPag		:= 0
Local nProp1		:= 0
Local nProp2		:= 0
Local nVlTot1		:= 0
Local nVlTot2		:= 0
Local nI			:= 0
Local nOpcA			:= 0

Local nPercent1
Local nPercent2
Local nAltura
//&&&&&
//Setkey( VK_F4,{||A161HisPro(aItens[oBrowse1:At()][1])})
//Setkey( VK_F5,{||A161MovPag(aPropostas, @oBrowse2, @oBrowse3, IIF(nPag > 1,--nPag,1), @cFor1, @nProp1, @cCondPag1, @cTpFrete1, @nVlTot1,@cFor2, @nProp2, @cCondPag2, @cTpFrete2, @nVlTot2, @oPanel3,oBrowse1)})
//Setkey( VK_F6,{||A161MovPag(aPropostas, @oBrowse2, @oBrowse3, IIF(Len(aPropostas) <= nPag,nPag,++nPag), @cFor1, @nProp1, @cCondPag1, @cTpFrete1, @nVlTot1,@cFor2, @nProp2, @cCondPag2, @cTpFrete2, @nVlTot2, @oPanel3,oBrowse1)})
//SetKey( VK_F7,{||A161HisForn(aPropostas[nPag][1][1][1],aPropostas[nPag][1][1][2])})
//SetKey( VK_F8,{||A161HisForn(aPropostas[nPag][2][1][1],aPropostas[nPag][2][1][2])})
//&&&&&

xA161Prop(cCotacao, @aItens, @aPropostas,_cFornec,_cLoja ) //Efetua a montagem do array para ser usado na interface do Mapa de Cota็ใo

//&&&&&
/////nNumPag := Len(aPropostas)

/////oPanel0:= tPanel():New(0,0,,oDlg,,,,,,0,0)
/////oPanel0:Align := CONTROL_ALIGN_ALLCLIENT

// Cria instancia do fwlayer
/////oFWLayer := FWLayer():New()

// Inicializa componente passa a Dialog criada,o segundo parametro ้ para
// cria็ใo de um botao de fechar utilizado para Dlg sem cabe็alho
/////oFWLayer:Init(oPanel0,.F./*,.T.*/)
/*
oPanel0:ReadClientCoors(.T.,.T.)
nAltura := oPanel0:nHeight

nPercent1 := (210 * 100) / nAltura
nPercent2 := 100 - nPercent1

// Efetua a montagem das linhas das telas

oFWLayer:addLine("LINHA1",nPercent1,.T.)
oFWLayer:addLine("LINHA2",nPercent2,.F.)

// Efetua a montagem das colunas das telas
oFWLayer:AddCollumn("BOX1",34,.T.,"LINHA1")
oFWLayer:AddCollumn("BOX2",33,.T.,"LINHA1")
oFWLayer:AddCollumn("BOX3",33,.T.,"LINHA1")

oFWLayer:AddCollumn("BOX4",34,.T.,"LINHA2")
oFWLayer:AddCollumn("BOX5",33,.T.,"LINHA2")
oFWLayer:AddCollumn("BOX6",33,.T.,"LINHA2")

// Cria a window passando, nome da coluna onde sera criada, nome da window
// titulo da window, a porcentagem da altura da janela, se esta habilitada para click,
// se ้ redimensionada em caso de minimizar outras janelas e a a็ใo no click do split
oFWLayer:AddWindow("BOX1","oPanel1","Dados da Cota็ใo"	,100,.F.,.T.,,"LINHA1",{ || })//"Dados da Cota็ใo"
oFWLayer:AddWindow("BOX2","oPanel2","Dados da Proposta"	,100,.F.,.T.,,"LINHA1",{ || })//"Dados da Proposta"
oFWLayer:AddWindow("BOX3","oPanel3","Dados da Proposta"	,100,.F.,.T.,,"LINHA1",{ || })//"Dados da Proposta"

oFWLayer:AddWindow("BOX4","oPanel4","Produtos"			,100,.F.,.T.,,"LINHA2",{ || })//"Produtos"
oFWLayer:AddWindow("BOX5","oPanel5","Item da Proposta"	,100,.F.,.T.,,"LINHA2",{ || })//"Item da Proposta"
oFWLayer:AddWindow("BOX6","oPanel6","Item da Proposta"	,100,.F.,.T.,,"LINHA2",{ || })//"Item da Proposta"

// Retorna o objeto do painel da Janela
oPanel1 := oFWLayer:GetWinPanel("BOX1","oPanel1","LINHA1")
oPanel2 := oFWLayer:GetWinPanel("BOX2","oPanel2","LINHA1")
oPanel3 := oFWLayer:GetWinPanel("BOX3","oPanel3","LINHA1")

oPanel4 := oFWLayer:GetWinPanel("BOX4","oPanel4","LINHA2")
oPanel5 := oFWLayer:GetWinPanel("BOX5","oPanel5","LINHA2")
oPanel6 := oFWLayer:GetWinPanel("BOX6","oPanel6","LINHA2")

// Dados da cota็ใo
@ 7,2 SAY RetTitle("C8_NUM") OF oPanel1 PIXEL
@ 5,37 MSGET cCotacao SIZE 30,10 WHEN .F. OF oPanel1 PIXEL

@ 27,2 SAY RetTitle("C8_VALIDA") OF oPanel1 PIXEL
@ 25,37 MSGET dDataVld SIZE 50,10 WHEN .F. OF oPanel1 PIXEL

@ 47,2 SAY "Valor Final"  OF oPanel1 PIXEL //"Valor Final"
@ 45,37 MSGET oVlrFinal VAR nVlrFinal SIZE 50,10 WHEN .F. PICTURE PesqPict("SC8","C8_TOTAL") OF oPanel1 PIXEL

@ 7,96 SAY RetTitle("C8_TPDOC") OF oPanel1 PIXEL
@ 5,120 MSCOMBOBOX cTpDoc ITEMS aItensC SIZE 68,14 WHEN aScan(aItens,{|x| x[9] == .F.  }) >0 OF oPanel1 PIXEL

@ 27,96 SAY 'Pแgina' OF oPanel1 PIXEL//'Pแgina'
@ 25,120 MSGET nPag SIZE 20,10 VALID nPag > 0 .And. nPag <= nNumPag .And. ;
A161MovPag(aPropostas, @oBrowse2, @oBrowse3, nPag, @cFor1, @nProp1, @cCondPag1, @cTpFrete1, @nVlTot1,@cFor2, @nProp2, @cCondPag2, @cTpFrete2, @nVlTot2,@oPanel3,oBrowse1);
OF oPanel1 PIXEL

@ 27,143 SAY '/' OF oPanel1 PIXEL//'/'
@ 25,148 MSGET nNumPag SIZE 20,10 WHEN .F. OF oPanel1 PIXEL

TButton():Create(oPanel1,63,2,'Hist๓rico do Produto (F4)',{||A161HisPro(aItens[oBrowse1:At()][1])},85,13,,,,.T.,,'Hist๓rico do Produto (F4)',,,,)//STR0022//'Hist๓rico do Produto (F4)'
TButton():Create(oPanel1,45,120,'Pแgina Anterior (F5)',{|| A161MovPag(aPropostas, @oBrowse2, @oBrowse3, IIF(nPag > 1,--nPag,1), @cFor1, @nProp1, @cCondPag1, @cTpFrete1, @nVlTot1,@cFor2, @nProp2, @cCondPag2, @cTpFrete2, @nVlTot2, @oPanel3,oBrowse1 )},67,13,,,,.T.,,'Pแgina Anterior (F5)',,,,)//STR0024//'Pแgina Anterior (F5)'
TButton():Create(oPanel1,63,120,'Pr๓xima Pแgina (F6)' ,{|| A161MovPag(aPropostas, @oBrowse2, @oBrowse3, IIF(Len(aPropostas) <= nPag,nPag,++nPag), @cFor1, @nProp1, @cCondPag1, @cTpFrete1, @nVlTot1,@cFor2, @nProp2, @cCondPag2, @cTpFrete2, @nVlTot2, @oPanel3,oBrowse1)},67,13,,,,.T.,,'Pr๓xima Pแgina (F6)',,,,)//STR0026//'Pr๓xima Pแgina (F6)'

// Dados do PRIMEIRO fornecedor na tela
cFor1 		:= aPropostas[1][1][1][3]
nProp1		:= aPropostas[1][1][1][4]
cCondPag1	:= aPropostas[1][1][1][5]
cTpFrete1	:= A161DscFrt(aPropostas[1][1][1][6])
nVlTot1	:= aPropostas[1][1][1][7]

@ 7,2 SAY 'Fornecedor' OF oPanel2 PIXEL//'Fornecedor'
@ 5,35 MSGET cFor1 SIZE 153,10 WHEN .F. OF oPanel2 PIXEL

@ 27,2 SAY 'Proposta' OF oPanel2 PIXEL//'Proposta'
@ 25,35 MSGET nProp1 SIZE 30,10 WHEN .F. OF oPanel2 PIXEL

@ 47,2 SAY 'Tp. Frete'	OF oPanel2 PIXEL//'Tp. Frete'
@ 45,35 MSGET cTpFrete1 SIZE 30,10 WHEN .F. OF oPanel2 PIXEL

@ 27,90 SAY 'Cond. Pagto' OF oPanel2 PIXEL//'Cond. Pagto'
@ 25,125 MSGET cCondPag1 SIZE 63,10 WHEN .F. OF oPanel2 PIXEL


@ 47,90 SAY 'Vl. Total' OF oPanel2 PIXEL//'Vl. Total'
@ 45,125 MSGET nVlTot1 SIZE 63,10 WHEN .F. PICTURE PesqPict("SC8","C8_TOTAL") OF oPanel2 PIXEL

TButton():Create(oPanel2,63,35,'Hist๓rico do Fornecedor (F7)',{||A161HisForn(aPropostas[nPag][1][1][1],aPropostas[nPag][1][1][2])},153,13,,,,.T.,,'Hist๓rico do Fornecedor (F7)',,,,)//STR0033//'Hist๓rico do Fornecedor (F7)'

// Dados do SEGUNDO fornecedor na tela
If !Empty(aPropostas[1,2,1])
cFor2 		:= aPropostas[1][2][1][3]
nProp2		:= aPropostas[1][2][1][4]
cCondPag2	:= aPropostas[1][2][1][5]
cTpFrete2	:= A161DscFrt(aPropostas[1][2][1][6])
nVlTot2	:= aPropostas[1][2][1][7]
SetKey(VK_F8,{||A161HisForn(aPropostas[nPag][2][1][1],aPropostas[nPag][2][1][2])})
Else
oPanel3:lVisible := .F.
oPanel6:lVisible := .F.
SetKey( VK_F8,{||NIL} )
EndIf

@ 7,2 SAY 'Fornecedor' OF oPanel3 PIXEL//'Fornecedor'
@ 5,35 MSGET cFor2 SIZE 153,10 WHEN .F. OF oPanel3 PIXEL

@ 27,2 SAY 'Proposta' OF oPanel3 PIXEL//'Proposta'
@ 25,35 MSGET nProp2 SIZE 30,10 WHEN	 .F. OF oPanel3 PIXEL

@ 47,2 SAY 'Tp. Frete'	OF oPanel3 PIXEL//'Tp. Frete'
@ 45,35 MSGET cTpFrete2 SIZE 30,10 WHEN .F. OF oPanel3 PIXEL

@ 27,90 SAY 'Cond. Pagto' OF oPanel3 PIXEL//'Cond. Pagto'
@ 25,125 MSGET cCondPag2 SIZE 63,10 WHEN .F. OF oPanel3 PIXEL

@ 47,90 SAY 'Vl. Total' OF oPanel3 PIXEL//'Vl. Total'
@ 45,125 MSGET nVlTot2 SIZE 63,10 WHEN .F. PICTURE PesqPict("SC8","C8_TOTAL") OF oPanel3 PIXEL

TButton():Create(oPanel3,63,35,'Hist๓rico do Fornecedor (F8)',{||A161HisForn(aPropostas[nPag][2][1][1],aPropostas[nPag][2][1][2])},153,13,,,,.T.,,'Hist๓rico do Fornecedor (F8)',,,,)//STR0040//'Hist๓rico do Fornecedor (F8)'
TButton():Create(oPanel2,63,35,'Hist๓rico do Fornecedor (F7)',{||A161HisForn(aPropostas[nPag][1][1][1],aPropostas[nPag][1][1][2])},153,13,,,,.T.,,'Hist๓rico do Fornecedor (F7)',,,,)//STR0033//'Hist๓rico do Fornecedor (F7)'
// Carga de dados dos produtos
DEFINE FWBROWSE oBrowse1 DATA ARRAY ARRAY aItens NO CONFIG  NO REPORT NO LOCATE OF oPanel4

ADD COLUMN oColumn DATA { || aItens[oBrowse1:At(),1] } TITLE "Cod. Produto" HEADERCLICK { || .T. } OF oBrowse1//"Cod. Produto"
ADD COLUMN oColumn DATA { || aItens[oBrowse1:At(),8] } TITLE "Descri็ใo" 	HEADERCLICK { || .T. }	OF oBrowse1//"Descri็ใo"
ADD COLUMN oColumn DATA { || aItens[oBrowse1:At(),3] } TITLE "Quantidade" PICTURE PesqPict("SC8","C8_QUANT") HEADERCLICK { || .T. } OF oBrowse1//"Quantidade"
ADD COLUMN oColumn DATA { || aItens[oBrowse1:At(),4] } TITLE "UM" HEADERCLICK { || .T. } OF oBrowse1//"UM"
ADD COLUMN oColumn DATA { || aItens[oBrowse1:At(),5] } TITLE "Necessidade" HEADERCLICK { || .T. } OF oBrowse1//"Necessidade"
ADD COLUMN oColumn DATA { || aItens[oBrowse1:At(),6] } TITLE "Entrega" HEADERCLICK { || .T. } OF oBrowse1//"Entrega"
ADD COLUMN oColumn DATA { || aItens[oBrowse1:At(),7] } TITLE "Valor Final" PICTURE PesqPict("SC8","C8_TOTAL") HEADERCLICK { || .T. } OF oBrowse1//"Valor Final"

oBrowse1:bOnMove := {|oBrowse,nMoveType,nCursorPos,nQtdLinha,nVisbleRow| A161OnMove(oBrowse,nMoveType,nCursorPos,nQtdLinha,nVisbleRow,oBrowse1,oBrowse2,oBrowse3)}
oBrowse1:SetLineHeight(25)

ACTIVATE FWBROWSE oBrowse1

// Carga de dados da primeira proposta na tela
DEFINE FWBROWSE oBrowse2 DATA ARRAY ARRAY aPropostas[nPag,1,2] NO CONFIG  NO REPORT NO LOCATE OF oPanel5
oBrowse2:AddMarkColumns( { || IIf( aPropostas[nPag,1,2,oBrowse2:At(),1], "AVGLBPAR1","" ) },;
{ || StaticCall(MATA161,A161DesMark,nPag,1,oBrowse2:At(),@aPropostas,@aItens,oBrowse1,oBrowse2,oBrowse3),;
nVlrFinal:= StaticCall(MATA161,A161CalTot,aItens),oVlrFinal:Refresh()},;
{ || StaticCall(MATA161,A161MarkAll,nPag,1,@aPropostas,@aItens,oBrowse1,oBrowse2,oBrowse3),;
nVlrFinal:= StaticCall(MATA161,A161CalTot,aItens),oVlrFinal:Refresh()})

//						    { || A161DesMark(nPag,1,oBrowse2:At(),@aPropostas,@aItens,oBrowse1,oBrowse2,oBrowse3),;
//						    								nVlrFinal:= A161CalTot(aItens),oVlrFinal:Refresh()},;
//						    { || A161MarkAll(nPag,1,@aPropostas,@aItens,oBrowse1,oBrowse2,oBrowse3),;
//						    								nVlrFinal:= A161CalTot(aItens),oVlrFinal:Refresh()})

ADD COLUMN oColumn DATA { || IIf(!Empty(aPropostas[nPag,1,2,oBrowse2:At(),2]),Transform(aPropostas[nPag,1,2,oBrowse2:At(),4], PesqPict("SC8","C8_TOTAL")),'') } TITLE 'Valor Total' SIZE 20 HEADERCLICK { || .T. } OF oBrowse2//'Valor Total'
ADD COLUMN oColumn DATA { || aPropostas[nPag,1,2,oBrowse2:At(),5] } PICTURE PesqPict("SC8","C8_DATPRF") Type 'D' TITLE 'Entrega' SIZE 20 HEADERCLICK { || .T. } OF oBrowse2//'Entrega'
ADD COLUMN oColumn DATA {||'Memo'} PICTURE '@!' TITLE RetTitle("C8_OBS") SIZE 20 HEADERCLICK { || .T. } DOUBLECLICK {|| StaticCall(MATA161,ShowBMemo,aPropostas[nPag,1,2,oBrowse2:At(),6])}   OF oBrowse2

oBrowse2:bOnMove := {|oBrowse,nMoveType,nCursorPos,nQtdLinha,nVisbleRow| A161OnMove(oBrowse,nMoveType,nCursorPos,nQtdLinha,nVisbleRow,oBrowse1,oBrowse2,oBrowse3)}
oBrowse2:SetLineHeight(25)
ACTIVATE FWBROWSE oBrowse2

// Carga de dados da segunda proposta na tela
DEFINE FWBROWSE oBrowse3 DATA ARRAY ARRAY aPropostas[nPag,2,2] NO CONFIG  NO REPORT NO LOCATE OF oPanel6
oBrowse3:AddMarkColumns(	{ || IIf( !Empty(aPropostas[nPag,2,2]) .And. aPropostas[nPag,2,2,oBrowse3:At(),1], 'AVGLBPAR1','' ) },;
{ || StaticCall(MATA161,A161DesMark,nPag,2,oBrowse3:At(),@aPropostas,@aItens,oBrowse1,oBrowse2,oBrowse3),;
nVlrFinal:= StaticCall(MATA161,A161CalTot,aItens), oVlrFinal:Refresh()},;
{ || StaticCall(MATA161,A161MarkAll,nPag,2,@aPropostas,@aItens,oBrowse1,oBrowse2,oBrowse3),;
nVlrFinal:= StaticCall(MATA161,A161CalTot,aItens), oVlrFinal:Refresh()})

ADD COLUMN oColumn DATA { || IIf(!Empty(aPropostas[nPag,2,2]) .And. !Empty(aPropostas[nPag,2,2,oBrowse3:At(),2]),Transform(aPropostas[nPag,2,2,oBrowse3:At(),4], PesqPict("SC8","C8_TOTAL")),'') } TITLE 'Valor Total' SIZE 20 HEADERCLICK { || .T. } OF oBrowse3//'Valor Total'
ADD COLUMN oColumn DATA { || IIf(!Empty(aPropostas[nPag,2,2]),aPropostas[nPag,2,2,oBrowse3:At(),5],'') } PICTURE PesqPict("SC8","C8_DATPRF") TITLE 'Entrega' SIZE 20 HEADERCLICK { || .T. } OF oBrowse3//'Entrega'
ADD COLUMN oColumn DATA {||'Memo'} PICTURE '@!' TITLE RetTitle("C8_OBS") SIZE 20 HEADERCLICK { || .T. } DOUBLECLICK {|| StaticCall(MATA161,ShowBMemo,aPropostas[nPag,2,2,oBrowse3:At(),6])}   OF oBrowse3

oBrowse3:bOnMove := {|oBrowse,nMoveType,nCursorPos,nQtdLinha,nVisbleRow| A161OnMove(oBrowse,nMoveType,nCursorPos,nQtdLinha,nVisbleRow,oBrowse1,oBrowse2,oBrowse3)}
oBrowse3:SetLineHeight(25)

ACTIVATE FWBROWSE oBrowse3
*/
//&&&&&

nVlrFinal:= StaticCall(MATA161,A161CalTot,aItens)

Return

//-------------------------------------------------------------------
/*{Protheus.doc} xA161Prop
Efetua montagem do array de tens para a grid fixa e o array para as propostas.

@author Jos้ Eulแlio
@since 28/10/2013
@version P11.90
*/
//-------------------------------------------------------------------
Static Function xA161Prop(cNum, aItens, aPropostas,_cFornec,_cLoja )
Local nPag 		:= 1
Local nProp 		:= 1
Local nX 			:= 0
Local nPg 			:= 0
Local nNumPro 	:= 0
Local nY 			:= 1
Local nPosRef1 	:= 0
Local nPosRef2 	:= 0
Local nCusto 		:= ''
Local nPosRef 	:= 0
Local nPa 			:= 0
Local nPo 			:= 0

Local cPgto		:= ''
Local cQuery		:= ''
Local cCodRef 	:= ''
Local cMsg 		:= ''
Local cAtuPos 	:= ''

Local lWin 		:= .F.
Local lFim 		:= .F.
Local lGrdOk 		:= .F.

Local aRefImpos 	:= {}
Local _lFirstItem   := .T.

//Query que retorna quantidade de propostas
BeginSQL Alias "SC8PRO"
	SELECT C8_FORNECE,C8_LOJA,C8_NUMPRO,C8_ITEM
	FROM %Table:SC8%
	WHERE %NotDel% AND
	C8_FILIAL = %xFilial:SC8% AND
	C8_NUM = %Exp:cNum% AND
	C8_PRECO > 0
	GROUP BY C8_FORNECE,C8_LOJA,C8_NUMPRO,C8_ITEM
EndSQL

Do While SC8PRO->(!EOF())
	//If SC8PRO->C8_ITEM == alltrim(_cItemFinCot)
	If (SC8PRO->C8_ITEM $ _cItemFinCot) .and. SC8PRO->C8_FORNECE == _cFornec .and. SC8PRO->C8_LOJA == _cLoja
		nNumPro += 1
	EndIf
	SC8PRO->(dbSkip())
EndDo

SC8PRO->(dbCloseArea())

//Query que organiza as cota็๕es para o Array
cQuery := "SELECT MAPA.*, SC8.C8_ITEM FITEM FROM "

cQuery += "	(SELECT * FROM "

cQuery += "		(SELECT DISTINCT C8_IDENT IDENT, "
cQuery += "			C8_PRODUTO IPROD, "
cQuery += "			C8_ITEMGRD IGRAD "
cQuery += "		FROM " +RetSQLName("SC8") +" "
cQuery += "		WHERE D_E_L_E_T_ = ' ' AND "
cQuery += "			C8_FILIAL = '" +xFilial("SC8") +"' AND "
cQuery += "			C8_NUM = '" +cNum +"') IDENTS, "
cQuery += "		(SELECT DISTINCT C8_FORNECE FCODI, "
cQuery += "			C8_LOJA FLOJA, "
cQuery += "			C8_NUMPRO FPROP "
cQuery += "		FROM " +RetSQLName("SC8") +" "
cQuery += "		WHERE D_E_L_E_T_ = ' ' AND "
cQuery += "			C8_FILIAL = '" +xFilial("SC8") +"' AND "
cQuery += "			C8_NUM = '" +cNum +"') FORNECEDORES "

cQuery += "	) MAPA "

cQuery += "LEFT JOIN " +RetSQLName("SC8") +" SC8 ON SC8.D_E_L_E_T_ = ' ' AND "
cQuery += "	SC8.C8_FILIAL = '" +xFilial("SC8") +"' AND "
cQuery += "	SC8.C8_NUM = '" +cNum +"' AND "
cQuery += "	SC8.C8_FORNECE = FCODI AND "
cQuery += "	SC8.C8_LOJA = FLOJA AND "
cQuery += "	SC8.C8_IDENT = IDENT AND "
cQuery += "	SC8.C8_PRODUTO = IPROD AND "
cQuery += "	SC8.C8_NUMPRO = FPROP "

//cQuery += "	AND SC8.C8_FORNECE = '"+_cFornec+"' AND "
//cQuery += "	SC8.C8_LOJA = '"+_cLoja+"'  "

cQuery += "ORDER BY IDENT, FCODI, FLOJA, FPROP"

dbUseArea(.T.,"TOPCONN",TcGenQry(,,cQuery),"SC8MAPA",.F.,.T.)

//Quantidade de pแginas
nPg := Int(nNumPro / 2)
If Mod(nNumPro,2) > 0
	nPg++
EndIf

//Array para a Refer๊ncia do Imposto
SX3->(dbSetOrder(1))
SX3->(dbSeek("SC8"))
While ( !SX3->(Eof()) .And. SX3->X3_ARQUIVO == "SC8" )
	nPosRef1 := At("MAFISREF(",Upper(SX3->X3_VALID))
	If ( nPosRef1 > 0 )
		nPosRef1    += 10
		nPosRef2    := At(",",SubStr(SX3->X3_VALID,nPosRef1))-2
		aAdd(aRefImpos,{"SC8",SX3->X3_CAMPO,SubStr(SX3->X3_VALID,nPosRef1,nPosRef2)})
	EndIf
	
	SX3->(dbSkip())
EndDo

/*------- Estrutura do Array de aItens --------*/

//aItens[n,x]: Numero do item
//aItens[n,1]: C8_PRODUTO
//aItens[n,2]: C8_IDENT
//aItens[n,3]: C8_QUANT
//aItens[n,4]: C8_ UM
//aItens[n,5]: C8_ DATPRF
//aItens[n,6]: C8_ FILENT
//aItens[n,7]: valor do produto por proposta escolhida
//aItens[n,8]: Descri็ใo do Produto
//aItens[n,9]: Flag finalizado

/*------- Estrutura do Array de aPropostas --------*/

//CABEวALHO//
//aPropostas[n]			: n๚mero da pแgina
//aPropostas[n,p]			: posi็ใo do pedido na pแgina (1,2)
//aPropostas[n,p,1,x]	: Dados do cabe็alho da proposta
//aPropostas[n,p,1,1 ]	: Cod Fornecedor
//aPropostas[n,p,1,2 ]	: Loja
//aPropostas[n,p,1,3 ]	: Nome
//aPropostas[n,p,1,4 ]	: Proposta
//aPropostas[n,p,1,5 ]	: Cond pagto
//aPropostas[n,p,1,6 ]	: Frete
//aPropostas[n,p,1,7 ]	: Valor total (soma de nCusto dos itens)
//ITENS DA PROPOSTA//
//aPropostas[n,p,2,x]	: Itens da proposta
//aPropostas[n,p,2,x,1]	: Flag vencendor
//aPropostas[n,p,2,x,2]	: Item
//aPropostas[n,p,2,x,3]	: Cod produto
//aPropostas[n,p,2,x,4]	: Valor total (nCusto)
//aPropostas[n,p,2,x,5]	: Data de entrega
//aPropostas[n,p,2,x,6]	: Observa็๕es
//aPropostas[n,p,2,x,7]	: Filial Entrega
//aPropostas[n,p,2,x,8]	: Flag finalizado
//aPropostas[n,p,2,x,9]	: Recno SC8

/*------- -------------------------------------- --------*/
//Adiciona Array com quantidade de pแginas, propostas e cabe็alho e itens de proposta pra cada
For nX := 1 To nPg
	aAdd(aPropostas,{{{},{}},{{},{}}})
Next nX

//Array de Itens na grid de Produtos
While SC8MAPA->(!Eof())
	
	// Inserido por Carlos Queiroz em 25/05/2015 (***bloco nใo existe no padrใo)
	//		If SC8MAPA->FITEM <> alltrim(_cItemFinCot)
	If !(SC8MAPA->FITEM $ _cItemFinCot) //.and. SC8MAPA->FCODI <> _cFornec .and. SC8MAPA->FLOJA <> _cLoja
		//Skip para a pr๓xima linha da busca
		SC8MAPA->(dbSkip())
		loop
	EndIf
	
	SC8->(dbSetOrder(4))
	SC8->(dbSeek(xFilial("SC8")+cNum+SC8MAPA->IDENT))
	
	// Inserido por Carlos Queiroz em 25/05/2015 (***bloco nใo existe no padrใo)
	While SC8->(!Eof())
		If (SC8->C8_ITEM $ _cItemFinCot) .and. SC8->C8_FORNECE == _cFornec .and. SC8->C8_LOJA == _cLoja
			Exit
		EndIf
		SC8->(dbSkip())
	EndDo
	
	cProduto	:= SC8->C8_PRODUTO
	
	If SC8->C8_GRADE == 'S'
		MatGrdPrRf(@cProduto,.T.)
		cDesc 	:= MaGetDescGrd(cProduto) //Recupera nome do produto
	Else
		cDesc 	:= Posicione("SB1",1,xFilial("SB1")+cProduto,"B1_DESC")
	EndIf
	
	//Preenche Array do Item
	If SC8->C8_FORNECE == _cFornec .and. SC8->C8_LOJA == _cLoja  //teste cq
		//		If _lFirstItem
		If aScan(aItens,{|x| x[1] == cProduto  }) < 1  .or. aScan(aItens,{|x| x[12] == SC8->C8_ITEM  }) < 1 // ALTERADO por Carlos Queiroz em 15/12/16  //NECESSITA TESTE E ANALISE POIS PODE IMPACTAR NA GERACAO DE PEDIDOS
			////Comentado por Carlos Queiroz em 04/10/16
			////			aAdd(aItens, {cProduto,SC8->C8_IDENT,SC8->C8_QUANT,SC8->C8_UM,SC8->C8_DATPRF,SC8->C8_FILENT,0,cDesc,!Empty(SC8->C8_NUMPED)} )
			AAdd(aItens, {cProduto, SC8->C8_IDENT, SC8->C8_QUANT, SC8->C8_UM, SC8->C8_DATPRF, SC8->C8_FILENT, 0, cDesc, !Empty(SC8->C8_NUMPED), SC8->C8_FORNECE, SC8->C8_LOJA, SC8->C8_ITEM, SC8->C8_NUMPRO, SC8->C8_ITEMSC })
			//		_lFirstItem := .F.
		EndIf
	EndIf
	//Inicia a posi็ใo do Array aPropostas
	nPag := 1
	nProp:= 1
	
	//Quebra do While de Propostas
	cQuebra := SC8->(C8_NUM+C8_IDENT)
	
	SC8->(dbSetOrder(1))
	While !SC8MAPA->(EOF()) .And. SC8MAPA->(cNum+IDENT) == cQuebra
		
		// Inserido por Carlos Queiroz em 25/05/2015 (***bloco nใo existe no padrใo)
		//		If SC8MAPA->FITEM <> alltrim(_cItemFinCot) //&&&&&
		If !(SC8MAPA->FITEM $ _cItemFinCot) //.and. SC8MAPA->FCODI <> _cFornec .and. SC8MAPA->FLOJA <> _cLoja
			//Skip para a pr๓xima linha da busca
			SC8MAPA->(dbSkip())
			loop
		EndIf
		
		If !(SC8MAPA->FCODI == _cFornec .and. SC8MAPA->FLOJA == _cLoja)  // Teste cq
			//Skip para a pr๓xima linha da busca
			SC8MAPA->(dbSkip())
			loop
		EndIf
		
		//Adiciona posi็ใo no Array na primeira passagem
		If Empty(SC8MAPA->IGRAD) .Or. SC8MAPA->IGRAD == StrZero(1,Len(SC8MAPA->IGRAD))
			//		If SC8MAPA->FCODI == _cFornec .and. SC8MAPA->FLOJA == _cLoja  // teste cq
			aAdd(aPropostas[nPag,nProp,2],{})
			//		EndIf
		EndIf
		
		//Tratamento para Preenche Array de aPropostas
		If SC8->(dbSeek(xFilial("SC8")+cNum+SC8MAPA->(FCODI+FLOJA+FITEM+FPROP+IGRAD)))
			
			//Inicia o Valor
			lWin := .F.
			lFim := .F.
			//Verifica se tem numero de pedido e marca como vencedor
			If !Empty(SC8->C8_NUMPED) .Or. !Empty(SC8->C8_NUMCON)
				//Marca como Finalizado
				lFim := .T.
				//Marca como Vencedor/Perdedor
				If SC8->C8_NUMPED # Replicate('X',Len(SC8->C8_NUMPED)) .OR.;
					(SC8->C8_NUMCON # Replicate('X',Len(SC8->C8_NUMCON)) .AND. !Empty(SC8->C8_NUMCON))
					lWin := .T.
				Else
					lWin := .F.
				EndIf
				
			EndIf
			
			//Calcula o Custo para o valor total do produto
			MaFisIni(SC8->C8_FORNECE,SC8->C8_LOJA,"F","N","R")
			MaFisIniLoad(1)
			For nY := 1 To Len(aRefImpos)
				MaFisLoad(aRefImpos[nY,3],SC8->(FieldGet(FieldPos(aRefImpos[nY,2]))),1)
			Next nY
			MaFisEndLoad(1)
			nCusto := Ma160Custo("SC8",1)
			MaFisEnd()
			
			// Tratamento para adicionar cabe็alho somente uma vez
			If Empty(aPropostas[nPag,nProp,1])
				//Recupera condi็ใo de pagamento
				cPgto := Posicione("SE4",1,xFilial("SE4")+SC8->C8_COND,"E4_DESCRI")
				//Preenche Array do Cabe็alho
				//				IF SC8->C8_FORNECE == _cFornec .and. SC8->C8_LOJA == _cLoja  // teste cq
				aPropostas[nPag,nProp,1] := {SC8->C8_FORNECE,SC8->C8_LOJA,SC8->C8_FORNOME	,SC8->C8_NUMPRO,cPgto,SC8->C8_TPFRETE,0}
				//              ENDIF
			EndIf
			
			//Tratamento para Itens de Grade
			If SC8->C8_GRADE == 'S'
				cCodRef := SC8->C8_PRODUTO
				cFrnRef := SC8->C8_FORNECE
				cLojRef := SC8->C8_LOJA
				lReferencia := MatGrdPrRf(@cCodRef,.T.)
				
				//Caso exista Item de Grade, apenas soma nCusto ao produto existente na Proposta
				If !Empty(aPropostas[nPag,nProp,2]) .And. !Empty(aPropostas[nPag,nProp,2,1]) .And. Type("aPropostas[nPag,nProp,2, 3]") <> 'U' .And.  (nPosRef := aScan(aPropostas[nPag,nProp,2], {|x| x[3] == cCodRef} )) > 0
					aPropostas[nPag,nProp,2,nPosRef,4] += nCusto
					//Soma nCusto no Valor total do Cabe็alho
					aPropostas[nPag,nProp,1,7] += nCusto
				Else
					//Preenche Array dos Produtos de cada proposta
					///     Comentado por Carlos Queiroz em 04/10/16
					///		aTail(aPropostas[nPag,nProp,2]) := {lWin, SC8->C8_ITEM, cCodRef, nCusto, (DATE()+SC8->C8_PRAZO), SC8->C8_OBS,SC8->C8_FILENT,lFim,SC8->(Recno())}
					// Inserido por Carlos Queiroz em 04/10/16
					aTail(aPropostas[nPag,nProp,2]) := {lWin, SC8->C8_ITEM, cCodRef, nCusto, (DATE()+SC8->C8_PRAZO), SC8->C8_OBS,SC8->C8_FILENT,lFim,SC8->(Recno()), SC8->C8_IDENT, Len(aItens), SC8->C8_NUMPRO}
					//Soma nCusto no Valor total do Cabe็alho
					aPropostas[nPag,nProp,1,7] += nCusto
				EndIf
			Else
				//Preenche Array dos Produtos de cada proposta
				///     Comentado por Carlos Queiroz em 04/10/16
				///	aTail(aPropostas[nPag,nProp,2]) := {lWin, SC8->C8_ITEM, SC8->C8_PRODUTO, nCusto, (DATE()+SC8->C8_PRAZO), SC8->C8_OBS,SC8->C8_FILENT,lFim,SC8->(Recno())}
				
				// Inserido por Carlos Queiroz em 04/10/16
				aTail(aPropostas[nPag,nProp,2]) := {lWin, SC8->C8_ITEM, cCodRef, nCusto, (DATE()+SC8->C8_PRAZO), SC8->C8_OBS,SC8->C8_FILENT,lFim,SC8->(Recno()), SC8->C8_IDENT, Len(aItens), SC8->C8_NUMPRO}
				
				//Soma nCusto no Valor total do Cabe็alho
				aPropostas[nPag,nProp,1,7] += nCusto
			EndIf
		ElseIf Empty(SC8MAPA->IGRAD) // ** diferen็a para ser analisada - consta no atual ElseIf Empty(SC8MAPA->C8_ITEMGRD)
			//Preenche Vazio Array de aProspostas, caso nใo hava o produto para aquela proposta
			// Comentado por Carlos Queiro em 04/10/16
			///aTail(aPropostas[nPag,nProp,2]) := {.F.,'' , '', 0, '', '','',.F.,''}
			aTail(aPropostas[nPag, nProp, 2]) := {.F., '' , '', 0, CToD('//'), '', '', .F., 0, '', Len(aItens)}
			
		EndIf
		
		If lWin
			aItens[Len(aItens),7]:= aPropostas[nPag,nProp,2,Len(aPropostas[nPag,nProp,2]),4]
		EndIf
		
		//Preenche variแveis para verificar se ้ uma proposta (fornecedor) diferente
		cAtuPos := SC8MAPA->(FCODI+FLOJA+FPROP+FITEM)
		
		//Skip para a pr๓xima linha da busca
		SC8MAPA->(dbSkip())
		
		//Atualiza a posi็ใo do Array, caso nใo seja o mesmo item de Grade
		If (SC8MAPA->(FCODI+FLOJA+FPROP+FITEM)) # cAtuPos
			If nProp == 1
				nProp := 2
			Else
				nPag++
				nProp := 1
			EndIf
		EndIf
		
	EndDo
EndDo

SC8MAPA->(dbCloseArea())

Return NIL

/*/
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑฺฤฤฤฤฤฤฤฤฤฤยฤฤฤฤฤฤฤฤฤฤฤยฤฤฤฤฤฤฤยฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤยฤฤฤฤฤฤยฤฤฤฤฤฤฤฤฤฤฟฑฑ
ฑฑณFun…o    ณa120ComViewณ Autor ณ Edson Maricate       ณ Data ณ 14.10.98 ณฑฑ
ฑฑรฤฤฤฤฤฤฤฤฤฤลฤฤฤฤฤฤฤฤฤฤฤมฤฤฤฤฤฤฤมฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤมฤฤฤฤฤฤมฤฤฤฤฤฤฤฤฤฤดฑฑ
ฑฑณDescri…o ณ Cria uma tela de consulta de historico dos produtos        ณฑฑ
ฑฑรฤฤฤฤฤฤฤฤฤฤลฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤดฑฑ
ฑฑณParametrosณ Nenhum                                                     ณฑฑ
ฑฑรฤฤฤฤฤฤฤฤฤฤลฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤดฑฑ
ฑฑณ Uso      ณ MATA120                                                    ณฑฑ
ฑฑภฤฤฤฤฤฤฤฤฤฤมฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤูฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
/*/
User Function GJPHistPrd()

Local nPosCod := aScan(oGetDad:aHeader,{|x| AllTrim(x[2]) == "PRODUTO"})

MaFisSave()
MaFisEnd()

If !AtIsRotina("MACOMVIEW")
	If !Empty(oGetDad:aCols[oGetDad:nAt][nPosCod])
		MaComView(oGetDad:aCols[oGetDad:nAt][nPosCod])
	EndIf
EndIf

MaFisRestore()

Return

Static Function xSelectWin()

Local aInfo     := {}
Local aPosObj   := {}
Local aObjects  := {}
Local aSize     := MsAdvSize()
Local oDlgWin
Local nOpcA     := 0
Local aHeader6 := {}
Local aCols6   := {}
Local oObj1
Local oObj2
Local oObj3
Local oObj4
Local oObj5
Local aPosGet	  := {}
Local aFornWin    := {}
Local cQuery      := ""

Private lExecuta      := .F.
Private oSlcAll       := .F.
Private oChkAll
Private oFolderWin
Private aFolderWin := {"Definir Vencedor"}
Private oOk 	   := LoadBitmap( GetResources(),"LBOK")
Private oNo 	   := LoadBitmap( GetResources(),"LBNO")
Private cCotNumber := ""
Private oGetDad6

//msginfo("Linha da Cota็ใo "+alltrim(oGetDad:aCols[oGetDad:nAt][aScan(oGetDad:aHeader,{|x| AllTrim(x[2]) == "COTACAO"})])+".")

aHeader6 := {}

DbSelectArea("SX3")
DbSetOrder(2)
If DbSeek("C6_UM")
	Aadd(aHeader6,{	"",;
	"MARCA",;
	"@BMP",;
	2,;
	0,;
	"",;
	SX3->X3_USADO,;
	"C",;
	"",;
	SX3->X3_CONTEXT,;
	"",;
	"",;
	"",;
	"A",;
	"",;
	"",;
	""})
EndIf

DbSelectArea("SX3")
DbSetOrder(2)
If DbSeek("C8_FILIAL")
	Aadd(aHeader6,{	AllTrim("Filial"),;
	"FILIAL",;
	SX3->X3_PICTURE,;
	SX3->X3_TAMANHO,;
	SX3->X3_DECIMAL,;
	SX3->X3_VALID,;
	SX3->X3_USADO,;
	SX3->X3_TIPO,;
	SX3->X3_F3,;
	SX3->X3_CONTEXT,;
	SX3->X3_CBOX,;
	SX3->X3_RELACAO,;
	SX3->X3_WHEN,;
	"V",;
	SX3->X3_VLDUSER,;
	SX3->X3_PICTVAR,;
	SX3->X3_OBRIGAT})
EndIf

DbSelectArea("SX3")
DbSetOrder(2)
If DbSeek("C8_NUM")
	Aadd(aHeader6,{	AllTrim("Cota็ใo"),;
	"COTACAO",;
	SX3->X3_PICTURE,;
	SX3->X3_TAMANHO,;
	SX3->X3_DECIMAL,;
	SX3->X3_VALID,;
	SX3->X3_USADO,;
	SX3->X3_TIPO,;
	SX3->X3_F3,;
	SX3->X3_CONTEXT,;
	SX3->X3_CBOX,;
	SX3->X3_RELACAO,;
	SX3->X3_WHEN,;
	"V",;
	SX3->X3_VLDUSER,;
	SX3->X3_PICTVAR,;
	SX3->X3_OBRIGAT})
EndIf

DbSelectArea("SX3")
DbSetOrder(2)
If DbSeek("C8_FORNECE")
	Aadd(aHeader6,{	AllTrim("Fornecedor"),;
	SX3->X3_CAMPO,;
	SX3->X3_PICTURE,;
	SX3->X3_TAMANHO,;
	SX3->X3_DECIMAL,;
	SX3->X3_VALID,;
	SX3->X3_USADO,;
	SX3->X3_TIPO,;
	SX3->X3_F3,;
	SX3->X3_CONTEXT,;
	SX3->X3_CBOX,;
	SX3->X3_RELACAO,;
	SX3->X3_WHEN,;
	"V",;
	SX3->X3_VLDUSER,;
	SX3->X3_PICTVAR,;
	SX3->X3_OBRIGAT})
EndIf

DbSelectArea("SX3")
DbSetOrder(2)
If DbSeek("C8_LOJA")
	Aadd(aHeader6,{	AllTrim("Loja"),;
	SX3->X3_CAMPO,;
	SX3->X3_PICTURE,;
	SX3->X3_TAMANHO,;
	SX3->X3_DECIMAL,;
	SX3->X3_VALID,;
	SX3->X3_USADO,;
	SX3->X3_TIPO,;
	SX3->X3_F3,;
	SX3->X3_CONTEXT,;
	SX3->X3_CBOX,;
	SX3->X3_RELACAO,;
	SX3->X3_WHEN,;
	"V",;
	SX3->X3_VLDUSER,;
	SX3->X3_PICTVAR,;
	SX3->X3_OBRIGAT})
EndIf

DbSelectArea("SX3")
DbSetOrder(2)
If DbSeek("A2_NOME")
	Aadd(aHeader6,{	AllTrim("Nome"),;
	"A2_NOME",;
	SX3->X3_PICTURE,;
	30,;
	SX3->X3_DECIMAL,;
	SX3->X3_VALID,;
	SX3->X3_USADO,;
	SX3->X3_TIPO,;
	SX3->X3_F3,;
	SX3->X3_CONTEXT,;
	SX3->X3_CBOX,;
	SX3->X3_RELACAO,;
	SX3->X3_WHEN,;
	"V",;
	SX3->X3_VLDUSER,;
	SX3->X3_PICTVAR,;
	SX3->X3_OBRIGAT})
EndIf

DbSelectArea("SX3")
DbSetOrder(2)
If DbSeek("C8_PRECO")
	Aadd(aHeader6,{	AllTrim("Pre็o"),;
	SX3->X3_CAMPO,;
	SX3->X3_PICTURE,;
	SX3->X3_TAMANHO,;
	SX3->X3_DECIMAL,;
	SX3->X3_VALID,;
	SX3->X3_USADO,;
	SX3->X3_TIPO,;
	SX3->X3_F3,;
	SX3->X3_CONTEXT,;
	SX3->X3_CBOX,;
	SX3->X3_RELACAO,;
	SX3->X3_WHEN,;
	"V",;
	SX3->X3_VLDUSER,;
	SX3->X3_PICTVAR,;
	SX3->X3_OBRIGAT})
EndIf

If select("QRYSC8") > 0
	QRYSC8->(dbclosearea())
EndIf

cQuery := " Select SC8.C8_FILIAL, SC8.C8_NUM, SC8.C8_FORNECE, SC8.C8_LOJA, SC8.C8_LOJA, SC8.C8_PRECO from "+RetSqlName("SC8")+" SC8 "
cQuery += " Where SC8.D_E_L_E_T_ <> '*' AND SC8.C8_FILIAL = '"+xFilial("SC8")+"' AND SC8.C8_NUMPED = '' AND SC8.C8_PRECO > 0 AND "
cQuery += " SC8.C8_NUM = '"+oGetDad:aCols[oGetDad:nAt][aScan(oGetDad:aHeader,{|x| AllTrim(x[2]) == "COTACAO"})]+"' AND "
cQuery += " SC8.C8_ITEM = '"+oGetDad:aCols[oGetDad:nAt][aScan(oGetDad:aHeader,{|x| AllTrim(x[2]) == "ITEM"})]+"' "
cQuery += " Order by SC8.C8_FILIAL, SC8.C8_NUM, SC8.C8_ITEM
cQuery := ChangeQuery(cQuery)
dbUseArea(.T., "TOPCONN", TCGenQry(,,cQuery), "QRYWIN", .F., .T.)

QRYWIN->(dbgotop())

While QRYWIN->(!EOF())
	aAdd(aFornWin,{oNo,QRYWIN->C8_FILIAL,QRYWIN->C8_NUM,QRYWIN->C8_FORNECE,QRYWIN->C8_LOJA,AllTrim(Posicione("SA2",1,xFilial("SA2")+QRYWIN->C8_FORNECE+QRYWIN->C8_LOJA,"A2_NREDUZ")),QRYWIN->C8_PRECO})
	QRYWIN->(dbskip())
EndDo

QRYWIN->(dbclosearea())

For i:=1 to len(aFornWin)
	Aadd(aCols6,Array(Len(aHeader6)+1))
	aCols6[Len(aCols6)][1]  := aFornWin[i][1]
	aCols6[Len(aCols6)][2]  := aFornWin[i][2]
	aCols6[Len(aCols6)][3]  := aFornWin[i][3]
	aCols6[Len(aCols6)][4]  := aFornWin[i][4]
	aCols6[Len(aCols6)][5]  := aFornWin[i][5]
	aCols6[Len(aCols6)][6]  := aFornWin[i][6]
	aCols6[Len(aCols6)][7]  := aFornWin[i][7]
	aCols6[Len(aCols6)][Len(aHeader6)+1] := .F.
Next i

aAdd( aObjects, { 315, 20, .T., .T. } )
aInfo := { aSize[ 1 ], aSize[ 2 ], aSize[ 3 ], aSize[ 4 ], 3, 3 }
aPosObj := MsObjSize( aInfo, aObjects)

aPosGet := MsObjGetPos(aSize[3]-aSize[1],305,;
{{10,40,95,140,200,222,268,240},;
{10,40,111,140,223,268,63},;
{5,70,160,205,295},;
{6,34,200,215},;
{6,34,80,113,153,178},;
{6,34,245,268,260},;
{10,50,150,190,120},;
{273,130,190},;
{8,45,73,103,139,167,190,225,253},;
{144,190,144,190,289,293},;
{142,293,140},;
{9,47,188,148,9,146} } )

If !empty(aFornWin)
	
	DEFINE MSDIALOG oDlgWin TITLE "GJP Hotels & Resort" From aSize[7]-200,0 to aSize[6]-420,aSize[5]-640 of oMainWnd PIXEL Style DS_MODALFRAME
	
	oFolderWin := TFolder():New(aPosObj[1,1], aPosObj[1,2], aFolderWin, , oDlgWin, 1, , , .T.,.F.,aPosObj[1,4]-330,aPosObj[1,3]-aPosObj[1,1]-120,)
	
	oGetDad6:= MsNewGetDados():New(120,00,00,00,2,,,,,,999,,,,oFolderWin:aDialogs[1],aHeader6,aCols6)
	oGetDad6:AddAction('MARCA',{|| lExecuta := SlctAcols(2,2, oGetDad6:nAt)})
	oGetDad6:oBrowse:Align:= CONTROL_ALIGN_ALLCLIENT
	
	ACTIVATE MSDIALOG oDlgWin ON INIT EnchoiceBar(oDlgWin,{|| iif(xValidWin(),(nOpcA:=1,oDlgWin:End()),NIL)},{||oDlgWin:End()},,) CENTER
	
	For i:=1 to Len(oGetDad6:aCols)
		If oGetDad6:aCols[i][1] == oOk
			dbselectarea("SC8")
			dbsetorder(1)
			If dbseek(oGetDad6:aCols[i][2]+oGetDad6:aCols[i][3])
				While SC8->(!EOF()) .and. oGetDad6:aCols[i][2] == SC8->C8_FILIAL .and. oGetDad6:aCols[i][3] == SC8->C8_NUM
					If oGetDad:aCols[oGetDad:nAt][aScan(oGetDad:aHeader,{|x| AllTrim(x[2]) == "ITEM"})] == SC8->C8_ITEM
						RecLock("SC8",.F.)
						SC8->C8_XVENCED := oGetDad6:aCols[i][4]+" "+oGetDad6:aCols[i][5]+" - "+oGetDad6:aCols[i][6]
						SC8->(msunlock())
						oGetDad:aCols[oGetDad:nAt][aScan(oGetDad:aHeader,{|x| AllTrim(x[2]) == "C8_XVENCED"})] := SC8->C8_XVENCED
					EndIf
					
					SC8->(dbskip())
				EndDo
			EndIf
		EndIf
	Next i
	
EndIf

Return

Static Function xValidWin()
Local lRet := .F.
Local nCount := 0

For i:=1 to Len(oGetDad6:aCols)
	If oGetDad6:aCols[i][1] == oOk
		nCount++
	EndIf
Next i

If nCount == 0
	msginfo("Nenhuma cota็ใo foi selecionada.")
ElseIf nCount > 1
	msginfo("Selecionar apenas 1 ๚nico Vencedor.")
	For i:=1 to Len(oGetDad6:aCols)
		oGetDad6:aCols[i][1] := oNo
	Next i
	oGetDad6:Refresh()
ElseIf nCount == 1
	lRet := .T.
Endif

Return lRet



/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณGJP130COT บAutor  ณMicrosiga           บ Data ณ  07/05/15   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ                                                            บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ AP                                                        บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
User Function GJPAglutCot()

Local _cFilial   := "" //oGetDad:aCols[oGetDad:nAt][aScan(oGetDad:aHeader,{|x| AllTrim(x[2]) == "FILIAL"})]
Local _cNum      := "" //oGetDad:aCols[oGetDad:nAt][aScan(oGetDad:aHeader,{|x| AllTrim(x[2]) == "COTACAO"})]
Local _cProduto  := "" //oGetDad:aCols[oGetDad:nAt][aScan(oGetDad:aHeader,{|x| AllTrim(x[2]) == "PRODUTO"})]
Local _cItem     := "" //oGetDad:aCols[oGetDad:nAt][aScan(oGetDad:aHeader,{|x| AllTrim(x[2]) == "ITEM"})]
Local _nQuant    := 0  //oGetDad:aCols[oGetDad:nAt][aScan(oGetDad:aHeader,{|x| AllTrim(x[2]) == "QUANTIDADE"})]
Local _cQuery    := ""
Local lValida    := .F.
Local lAtualizou := .F.
Local _cItemRec  := ""
Local _nContador  := 0
Local _aSC1Recno := {}

For i:=1 to Len(oGetDad:aCols)
	If oGetDad:aCols[i][1] == oOk
		_nContador++
	EndIf
Next i

If _nContador > 1
	If msgyesno("Deseja aglutinar as cota็๕es selecionadas?")
		
		For i:=1 to Len(oGetDad:aCols)
			If oGetDad:aCols[i][1] == oOk
				_cFilial   := oGetDad:aCols[i][aScan(oGetDad:aHeader,{|x| AllTrim(x[2]) == "FILIAL"})]
				_cNum      := oGetDad:aCols[i][aScan(oGetDad:aHeader,{|x| AllTrim(x[2]) == "COTACAO"})]
				_cProduto  := oGetDad:aCols[i][aScan(oGetDad:aHeader,{|x| AllTrim(x[2]) == "PRODUTO"})]
				_cItem     := oGetDad:aCols[i][aScan(oGetDad:aHeader,{|x| AllTrim(x[2]) == "ITEM"})]
				_nQuant    := oGetDad:aCols[i][aScan(oGetDad:aHeader,{|x| AllTrim(x[2]) == "QUANTIDADE"})]
				
				dbselectarea("SC8")
				//				dbsetorder(3)
				//				If dbseek(_cFilial+_cNum+_cProduto)
				SC8->(dbOrderNickName("COTACNEW"))
				If dbseek(_cFilial+_cNum+_cItem)
					
					if Empty(SC8->C8_NUMPED)
						
						While SC8->(!EOF())
							If _cFilial == SC8->C8_FILIAL .and. _cNum == SC8->C8_NUM .and. _cProduto == SC8->C8_PRODUTO .and. SC8->C8_ITEM == _cItem
								
								cQuery := " Select r_e_c_n_o_ C1_RECNO from "+RetSqlName("SC1")+" "
								cQuery += " Where D_E_L_E_T_ <> '*' AND C1_FILIAL = '"+SC8->C8_FILIAL+"' AND C1_NUM = '"+SC8->C8_NUMSC+"' AND C1_ITEM = '"+SC8->C8_ITEMSC+"'"
								
								cQuery := ChangeQuery(cQuery)
								dbUseArea(.T., "TOPCONN", TCGenQry(,,cQuery), "QRYSC1", .F., .T.)
								
								// verificar se o item existem outras SC8 para lim
								If QRYSC1->(!EOF())
									SC1->(dbgoto(QRYSC1->C1_RECNO))
									aadd(_aSC1Recno,QRYSC1->C1_RECNO)
									RecLock("SC1",.F.)
									SC1->C1_COTACAO := ""
									SC1->(msunlock())
								EndIf
								QRYSC1->(dbclosearea())
								
								Reclock("SC8",.F.)
								SC8->(dbDelete())
								SC8->(msunlock())
							EndIf
							SC8->(dbskip())
						EndDo
					else
						if SC8->C8_ITEM == _cItem
							msgalert("Pedido de Compra "+alltrim(SC8->C8_NUMPED)+" gerado, nใo ้ possํvel aglutinar o produto "+alltrim(_cProduto)+" da Cota็ใo "+alltrim(_cFilial)+" - "+alltrim(_cNum)+".")
						endIf
					endif
					
				Endif
				
			EndIf
		Next i
		
		oDlgCotac:End()
		_nSavFolder := 2
	Else
		msginfo("Cota็๕es nใo aglutinadas!!!")
		Return .F.
	EndIf
Else
	msginfo("Necessแrio marcar no mํnimo 2 itens para efetuar o processo de 'Aglutinar Cota็๕es'.")
EndIf

If !empty(_aSC1Recno)
	For i:=1 to len(_aSC1Recno)
		dbselectarea("SC1")
		SC1->(dbgoto(_aSC1Recno[i]))
		RecLock("SC1",.F.)
		SC1->C1_OK := cMarca
		SC1->(msunlock())
	Next i
	U_xA130Gera()
	_nSavFolder := 2
EndIf

Return .T.


/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑฺฤฤฤฤฤฤฤฤฤฤยฤฤฤฤฤฤฤฤฤฤยฤฤฤฤฤฤฤยฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤยฤฤฤฤฤฤยฤฤฤฤฤฤฤฤฤฤฟฑฑ
ฑฑณFuncao    ณa131Procesณ Autor ณ 			          ณ Data ณ 			  ณฑฑ
ฑฑรฤฤฤฤฤฤฤฤฤฤลฤฤฤฤฤฤฤฤฤฤมฤฤฤฤฤฤฤมฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤมฤฤฤฤฤฤมฤฤฤฤฤฤฤฤฤฤดฑฑ
ฑฑณDescri…o ณRotina de processamento da solicitacoes de compra que devem ณฑฑ
ฑฑณ          ณgerar cotacao.                                              ณฑฑ
ฑฑรฤฤฤฤฤฤฤฤฤฤลฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤดฑฑ
ฑฑณParametrosณExpN1: 1 - Produto | 2 - Grupo ( Gera Cotacao por ? )       ณฑฑ
ฑฑณ          ณExpN2: Numero de Fornecedores                               ณฑฑ
ฑฑณ          ณExpN3: Numero de Fornecimentos                              ณฑฑ
ฑฑณ          ณExpD4: Data de Validade da Cotacao                          ณฑฑ
ฑฑณ          ณExpL5: Indicador de exibicao dos relatorios                 ณฑฑ
ฑฑรฤฤฤฤฤฤฤฤฤฤลฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤดฑฑ
ฑฑณRetorno   ณNenhum                                                      ณฑฑ
ฑฑภฤฤฤฤฤฤฤฤฤฤมฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤูฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
/*/
User Function xa131Proc(nAmarracao,nFornec,nUltForn,dValidade,lRelatorio)

Local aArea		:= GetArea()
Local aAreaSC1  := SC1->(GetArea())
Local aStruSC1  := SC1->(dbStruct())
Local aRegSC	:= {}
Local aSC8Num	:= {}
Local aQuebra   := {}
Local aScMono   := {}
Local aReplForn := {}

Local bQuebra	:= {|| C1_FILENT+C1_GRADE+C1_NUM+C1_ITEM+C1_FORNECE+C1_LOJA+C1_PRODUTO+C1_DESCRI+Dtos(C1_DATPRF)+C1_CC+C1_CONTA+C1_ITEMCTA+C1_CLVL}

Local cFilQry	:= cQuerySC1
Local cAliasSC1 := "SC1"
Local cAliasSC8 := "SC8"
Local cQuery	:= ""
Local cIndex	:= ""
Local cKey		:= ""
Local cQuebra	:= ""
Local cNumCot	:= ""
Local cItem		:= ""
Local cIdent	:= ""
Local cNumScs   := ""

Local nX        := 0
Local nY		  := 0
Local nZ		  := 0
Local nIndex	:= 0
Local nQtdSC	:= 0
Local nQtdSC2 := 0
Local nCntFor	:= 0
Local nRegSC8   := 0
Local nScan     := Nil

Local lProcessa	:= .F.
Local lLast     := .F.
Local lPrdxForn := .T.
Local lNumCot   := .F.
Local lReplica  := .F.
Local lControle := .T.
Local lClicB	  := A131VerInt()

Local cKey130   := ''
Local lCotRatP  := SuperGetMv("MV_COTRATP",.F.,.F.)
Local lSelFor	:= If(SuperGetMv("MV_SELFOR",.F.,"N")="S",.T.,.F.)
Local oModel  	:= FWLoadModel( "MATA131" )
Local oModGrp		:= oModel:GetModel('SBMDETAIL')
Local oModTmp		:= oModel:GetModel('TMPDETAIL')
Local oModCot		:= oModel:GetModel('SC8DETAIL')
Local oModPrd		:= oModel:GetModel('SC1DETAIL')
Local lQuebrou		:= .F.

PRIVATE aGrade     := {{"","","0000","000","0000"}}
PRIVATE aFirstIdent:= {}


If lCotRatP
	bQuebra := {|| C1_FILENT+C1_GRADE+C1_NUM+C1_ITEM+C1_FORNECE+C1_LOJA+C1_PRODUTO+C1_DESCRI+Dtos(C1_DATPRF)}
Endif


//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
//ณVerifica a melhor ordem de processamento                                ณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
If ThisInv()
	cKey := "C1_FILIAL+C1_GRADE+C1_FORNECE+C1_LOJA+C1_PRODUTO+C1_DESCRI+DTOS(C1_DATPRF)+C1_CC+C1_CONTA+C1_ITEMCTA+C1_CLVL+C1_FILENT"
Else
	cKey := "C1_FILIAL+C1_OK+C1_GRADE+C1_FORNECE+C1_LOJA+C1_PRODUTO+C1_DESCRI+DTOS(C1_DATPRF)+C1_CC+C1_CONTA+C1_ITEMCTA+C1_CLVL+C1_FILENT"
EndIf


//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
//ณMonta a Query para Processamento das SCs                                ณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู

cQuery += "SELECT SC1.*,SC1.R_E_C_N_O_ SC1RECNO, "
cQuery += "CASE C1_GRADE WHEN 'S' THEN B4_GRUPO ELSE B1_GRUPO END GRUPO "
cQuery += "FROM "+RetSqlName("SC1")+" SC1 "

cQuery += "JOIN "+RetSqlName("SB1")+ " SB1 ON SB1.D_E_L_E_T_ = ' ' AND SB1.B1_FILIAL = '"+xFilial("SB1") +"'"
cQuery += " AND SB1.B1_COD = SC1.C1_PRODUTO "

cQuery += "LEFT JOIN "+RetSqlName("SBM")+" SBM ON SBM.D_E_L_E_T_ = ' ' AND SBM.BM_FILIAL = '"+xFilial("SBM")+"'"
cQuery += " AND SBM.BM_GRUPO = SB1.B1_GRUPO "

cQuery += "LEFT JOIN "+RetSqlName("SB4")+" SB4 ON SB4.D_E_L_E_T_ = ' ' AND SB4.B4_FILIAL = '"+xFilial("SB4") +"'"
cQuery += " AND SB4.B4_COD = CASE C1_GRADE WHEN 'S' "
cQuery += " THEN SUBSTRING(C1_PRODUTO,1,"+ SubStr(SuperGetMv("MV_MASGRD",.F.,"11,02,02"),1,At(",",SuperGetMv("MV_MASGRD",.F.,"11,02,02"))-1)+ ")"
cquery += " ELSE ' ' END "

cQuery += "WHERE "+cFilQry
If ( Empty(cFilQry) )
	cQuery += " C1_FILIAL='"+xFilial("SC1")+"'"
	If SC1->(FieldPos("C1_ACCPROC")) > 0
		cQuery += " AND C1_ACCPROC <> '1'"
	EndIf
EndIf
If ( ValType(MV_PAR01)=="N" .And. ValType(MV_PAR02)=="D" .And. ValType(MV_PAR03)=="D" )
	If ( MV_PAR01==1 ) // Filtra por Data
		cQuery += " AND C1_EMISSAO >= '"+Dtos(MV_PAR02)+"'"
		cQuery += " AND C1_EMISSAO <= '"+Dtos(MV_PAR03)+"'"
	EndIf
EndIf
If ( !"C1_COTACAO"$cFilQry )
	cQuery += " AND C1_COTACAO = '"+Space(Len(SC1->C1_COTACAO))+"'"
	cQuery += " AND C1_QUJE < C1_QUANT"
	cQuery += " AND C1_TPOP <> 'P' "
	cQuery += " AND C1_APROV IN('L',' ') "
EndIf
If ( !ThisInv() )
	cQuery += " AND C1_OK = '"+ThisMark()+"'"
Else
	cQuery += " AND C1_OK <> '"+ThisMark()+"'"
EndIf
If SC1->(FieldPos("C1_ACCPROC")) > 0
	cQuery += " AND C1_ACCPROC <> '1'"
EndIf
cQuery += " AND SC1.D_E_L_E_T_<>'*'"
cQuery += " ORDER BY GRUPO,"+SqlOrder(cKey)
cQuery := ChangeQuery(cQuery)
cAliasSC1 := "a131PROCES"
dbUseArea(.T.,"TOPCONN",TcGenQry(,,cQuery),cAliasSC1,.T.,.T.)
For nCntFor := 1 To Len(aStruSc1)
	If ( aStruSC1[nCntFor][2] $ "NDL" )
		TcSetField(cAliasSC1,aStruSC1[nCntFor][1],aStruSC1[nCntFor][2],aStruSC1[nCntFor][3],aStruSC1[nCntFor][4])
	EndIf
Next nCntFor

ProcRegua(SC1->(LastRec()))

//---------------------------------------
//Ativa o Modelo MATA131
//----------------------------------------
oModel:SetOperation(MODEL_OPERATION_INSERT)
If oModel:Activate()
	StaticCall(MATA131,a131Bloq,oModel,.F.)
	While !Eof() .And. (cAliasSC1)->C1_FILIAL == xFilial("SC1") .And. ( ThisMark() == (cAliasSC1)->C1_OK .Or. ThisInv() )
		
		If IsMark("C1_OK",ThisMark(),ThisInv())
			
			lProcessa := .T.
			
			lQuebrou := !(Empty(oModel:GetModel("SC1DETAIL"):GetValue("C1_PRODUTO"))) .And. cQuebra # Eval(bQuebra)
			
			
			If lProcessa
				SC1->(MsGoto((cAliasSC1)->SC1RECNO))
			EndIf
			
			If SB1->(MsSeek(xFilial("SB1")+(cAliasSC1)->C1_PRODUTO))
				If !RegistroOk("SB1")
					lProcessa := .F.
				EndIf
				If !Empty(SB1->B1_PROC) .And. SB1->B1_MONO == "S"
					aadd(aScMono,(cAliasSC1)->C1_NUM+"-"+(cAliasSC1)->C1_ITEM)
					lProcessa	:= .F.
				Endif
			Endif
			
			If lProcessa
				nQtdSC += ( (cAliasSC1)->C1_QUANT - (cAliasSC1)->C1_QUJE )
				nQtdSC2 +=  (cAliasSC1)->C1_QTSEGUM
				aadd(aRegSC,(cAliasSC1)->SC1RECNO)
				//----------------------
				// Adiciona Produto
				//----------------------
				If Empty((cAliasSC1)->C1_ITEMGRD)
					StaticCall(MATA131,a131AddSC,oModel,cAliasSC1,nQtdSC,nQtdSC2,lQuebrou)
				Else
					StaticCall(MATA131,a131AddSC,oModel,cAliasSC1,( (cAliasSC1)->C1_QUANT - (cAliasSC1)->C1_QUJE ),(cAliasSC1)->C1_QTSEGUM,lQuebrou)
				EndIf
			EndIf
			
		EndIf
		
		dbSelectArea(cAliasSC1)
		cQuebra := Eval(bQuebra)
		
		dbSkip()
		IncProc()
		
		//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
		//ณRealiza a quebra da SC conforme o bQuebra para a Geracao do SC8ณ
		//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
		If cQuebra != (cAliasSC1)->(Eval(bQuebra)) .Or. Len(aRegSC)>4000
			If !Empty(cQuebra) .And. nQtdSC > 0
				If ( StaticCall(MATA131,a131Grava,nAmarracao,aRegSC,nQtdSC,nFornec,nUltForn,dValidade,@cNumCot,@cItem,@cIdent,@aQuebra,@lPrdxForn,@aReplForn,@lReplica,@lControle,@oModel,nQtdSC2) )
					If aScan(aSc8Num,cNumCot) == 0
						aadd(aSc8Num,cNumCot)
					EndIf
				EndIf
				aRegSC := {}
				nQtdSc := 0
			EndIf
		EndIf
		
	EndDo
	
	If lClicB
		aSaveLines 	:= FWSaveRows()
		
		For nX := 1 To oModGrp:Length()
			oModGrp:GoLine(nX)
			For nY:=1 To oModPrd:Length()
				oModPrd:GoLine(nY)
				For nZ:=1 To oModTmp:Length()
					oModTmp:GoLine(nZ)
					If !Empty(oModTmp:GetValue('TMP_CGC'))
						SA2->(DbSetOrder(3))
						If SA2->(DbSeek(xFilial('SA2')+oModTmp:GetValue('TMP_CGC')))
							If !Empty(oModCot:GetValue("C8_FORNECE"))
								oModCot:AddLine()
							EndIf
							oModCot:SetValue("C8_FORNECE",SA2->A2_COD)
							oModCot:SetValue("C8_LOJA",SA2->A2_LOJA)
							oModCot:SetValue("C8_FORNOME",SA2->A2_NOME)
							oModCot:SetValue("C8_FORMAIL",SA2->A2_EMAIL)
							oModCot:LoadValue("C8_CRITER","INCLUSรO CLICBUSINESS")//"INCLUSรO CLICBUSINESS"
						Endif
					Endif
				Next nz
			Next nY
		Next nX
		
		FWRestRows( aSaveLines )
	Endif
	If	lSelFor
		StaticCall(MATA131,a131Bloq,oModel,.T.)
		//		a131Bloq(oModel,.T.)
		oModel:GetModel("SBMDETAIL"):GoLine(1)
		oModel:getModel("SC1DETAIL"):GoLine(1)
		oModel:getModel("SC8DETAIL"):GoLine(1)
		oModel:getModel("TMPDETAIL"):GoLine(1)
		FWExecView ('', "MATA131A",  MODEL_OPERATION_INSERT,/*oDlg*/ , {||.T.},,,,/*{||.F.}*/,,,oModel)
	Else
		If oModel:VldData()
			oModel:CommitData()
		Else
			Help("",1,"NOVLDDATA",,"Ocorreu um erro de valida็ใo e nใo foi possivel gerar a cota็ใo.",4,1) //"Ocorreu um erro de valida็ใo e nใo foi possivel gerar a cota็ใo."
		EndIf
	EndIf
Else
	Help("",1,"NOACTIVE",,"Ocorreu um erro e nใo foi possivel ativar o modelo de dados, assim o processo foi abortado.",4,1) //"Ocorreu um erro e nใo foi possivel ativar o modelo de dados, assim o processo foi abortado."
EndIf
oModel  := Nil


If !lPrdxForn .And. !lSelFor
	//	Aviso(STR0024,STR0031,{STR0030}, 2)
	Aviso("Aten็ใo","As solicita็๕es de compras que nใo criaram cotacoes, nใo possuem amarra็ใo produto/grupo x fornecedor. verifique o registo de amarra็ใo.",{"Ok"}, 2)
Endif

//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
//ณRestaura o SC1                                                ณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
dbSelectArea(cAliasSC1)
dbCloseArea()
dbSelectArea("SC1")


//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
//ณ Chamada do Relatorio.                                        ณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
If lRelatorio .And. Len(aSc8Num) > 0
	dbSelectArea("SC8")
	dbSetOrder(1)
	dbSeek(xFilial("SC8")+aSc8Num[1])
	SC1->(dbClearFilter())
	
	a131Impri(SC8->C8_NUM)
	
	Pergunte("MTA130",.F.)
	dbSelectArea("SC1")
EndIf

//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
//ณMostra as Solicitacoes que nao foram geradas.                 ณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
If Len(aScMono) > 0
	For nX:= 1 To Len(aScMono)
		If nX == 1
			cNumScs := aScMono[nX]
		Else
			cNumScs += ", "+aScMono[nX]
		Endif
	Next nX
	Aviso("SC nใo gerou cota็ใo: ","Numero(s) - "+cNumScs,{"Ok"}, 2)
Endif

RestArea(aAreaSC1)
RestArea(aArea)

Return .T.


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณ GJPInfForn บ Autor ณ Carlos A. Queiroz  บ Data ณ  07/10/16   บฑฑ
ฑฑฬออออออออออุออออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ Interface com informacoes complementares a serem preenchidas บฑฑ
ฑฑบ          ณ para o fornecedor. ATUALIZA COTACAO.                         บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ GJP Hotels & Resorts                                         บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
User Function GJPInfForn()
Local _cFilial   := oGetDad:aCols[oGetDad:nAt][aScan(oGetDad:aHeader,{|x| AllTrim(x[2]) == "FILIAL"})]
Local _cNum      := oGetDad:aCols[oGetDad:nAt][aScan(oGetDad:aHeader,{|x| AllTrim(x[2]) == "COTACAO"})]
Local _cProduto  := oGetDad:aCols[oGetDad:nAt][aScan(oGetDad:aHeader,{|x| AllTrim(x[2]) == "PRODUTO"})]
Local _cItem     := oGetDad:aCols[oGetDad:nAt][aScan(oGetDad:aHeader,{|x| AllTrim(x[2]) == "ITEM"})]
Local _cFornece  := ""//substr(oGetDad:aHeader[oGetDad:nAt][oGetDad:OBROWSE:COLPOS],1,TamSX3("C8_FORNECE")[1])
Local _cLoja     := ""//substr(oGetDad:aHeader[oGetDad:nAt][oGetDad:OBROWSE:COLPOS],13,TamSX3("C8_LOJA")[1])
Local _cNomeForn := ""
Local _nRetCot   := 0
Private l150Auto := .F.

If !oGetDad:aCols[oGetDad:nAt][2] == oLegVerm
	If alltrim(oGetDad:aHeader[oGetDad:OBROWSE:COLPOS][2]) == "C8_PRECO"
		_cFornece  := substr(oGetDad:aHeader[oGetDad:OBROWSE:COLPOS][1],1,TamSX3("C8_FORNECE")[1])
		_cLoja     := substr(oGetDad:aHeader[oGetDad:OBROWSE:COLPOS][1],(TamSX3("C8_FORNECE")[1])+4,TamSX3("C8_LOJA")[1])
		_cNomeForn := AllTrim(Posicione("SA2",1,xFilial("SA2")+_cFornece+_cLoja,"A2_NREDUZ"))
	Else
		msgalert("Para alterar as informa็๕es de um fornecedor, posicione o cursor no fornecedor que deseja complementar os dados de determinado produto.","Posicionar em um Fornecedor")
		Return .F.
	EndIf
	
	DbSelectArea("SC8")
	SC8->(dbOrderNickName("COTACNEW"))
	If dbseek(_cFilial+_cNum+_cItem+_cFornece+_cLoja)
		Pergunte("MTA150",.F.)
		_nRetCot := U_xA150Digita("SC8",SC8->(Recno()),3)
		If _nRetCot <> 0
			msginfo("Informa็๕es do fornecedor "+alltrim(_cFornece)+" - "+alltrim(_cLoja)+" "+alltrim(_cNomeForn)+" atualizadas com sucesso.")
			oDlgCotac:End()
			_nSavFolder := 2
		Else
			msgstop("Nใo houveram atualiza็๕es para o fornecedor "+alltrim(_cFornece)+" - "+alltrim(_cLoja)+" "+alltrim(_cNomeForn)+".")
		EndIf
	Else
		msginfo("Fornecedor nใo pertence a esta Cota็ใo.")
		Return .T.
	EndIf
Else
	msginfo("Cota็ใo com pedido de compra jแ gerado, nใo ้ permitido a altera็ใo deste registro.")
	Return .F.
EndIf

Return .T.



/*/
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑฺฤฤฤฤฤฤฤฤฤฤยฤฤฤฤฤฤฤฤฤฤยฤฤฤฤฤฤฤยฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤยฤฤฤฤฤฤยฤฤฤฤฤฤฤฤฤฤฤฟฑฑ
ฑฑณFuno    ณA150DigitaณRev.   ณ Edson Maricate        ณ Data ณ29.07.2000 ณฑฑ
ฑฑรฤฤฤฤฤฤฤฤฤฤลฤฤฤฤฤฤฤฤฤฤมฤฤฤฤฤฤฤมฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤมฤฤฤฤฤฤมฤฤฤฤฤฤฤฤฤฤฤดฑฑ
ฑฑณ          ณRotina de atualizacao manual das cotacoes de compra          ณฑฑ
ฑฑณ          ณ                                                             ณฑฑ
ฑฑรฤฤฤฤฤฤฤฤฤฤลฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤดฑฑ
ฑฑณSintaxe   ณA150Digita(ExpC1,ExpN1,ExpN2)                                ณฑฑ
ฑฑรฤฤฤฤฤฤฤฤฤฤลฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤดฑฑ
ฑฑณParametrosณExpC1: Alias do Arquivo                                      ณฑฑ
ฑฑณ          ณExpN1: Numero do Registro                                    ณฑฑ
ฑฑณ          ณExpN2: Opcao do MBrowse                                      ณฑฑ
ฑฑรฤฤฤฤฤฤฤฤฤฤลฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤดฑฑ
ฑฑณRetorno   ณNenhum                                                       ณฑฑ
ฑฑณ          ณ                                                             ณฑฑ
ฑฑรฤฤฤฤฤฤฤฤฤฤลฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤดฑฑ
ฑฑณDescrio ณEsta rotina efetua a atualizacao das cotacoes de compra      ณฑฑ
ฑฑณ          ณ                                                             ณฑฑ
ฑฑรฤฤฤฤฤฤฤฤฤฤลฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤดฑฑ
ฑฑณUso       ณ Materiais                                                   ณฑฑ
ฑฑภฤฤฤฤฤฤฤฤฤฤมฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤูฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
/*/
USER FUNCTION xA150Digita(cAlias,nReg,nOpcX)

Local aArea     := GetArea()
Local aPages	:= {"HEADER"}
Local aRecSC8	:= {}
Local aSCs		:= {}
Local aImpRef   := {}
Local aTitles	:= {OemToAnsi("Totais"),; //"Totais"
OemToAnsi("Inf. Fornecedor"),; //"Inf. Fornecedor"
OemToAnsi("Frete/Despesas"),; //"Frete/Despesas"
OemToAnsi("Descontos"),; //"Descontos"
OemToAnsi("Impostos"),; //"Impostos"
OemToAnsi("Mensagem/Reajuste") } //"Mensagem/Reajuste"
Local aObj      := {}
Local aInfForn	:= {"","",Ctod(""),Ctod(""),"","",""}
Local aCombo    := CarregaTipoFrete()
Local abuttons  := {}
Local aColsUsr  := {}
Local bBlock
Local bRefCabOk :={||StaticCall(MATA150,A150CabOk,nOpcX,aImpRef,aInfForn,@cDescMsg,@cDescFor,@a150Var)}
Local cCadastro := OemtoAnsi("Atualiza็ใo Pre็os da Cota็ใo")			//"Atualizaฦo Preos da Cotaฦo"
Local cDescMsg	 := ""
Local cDescFor	 := ""
Local cAviso    := ""
Local cHelp     := ""
Local cNumCot	:= SC8->C8_NUM
Local l150Visual:= .F.
Local l150Altera:= .F.
Local lContinua := .T.
Local lValido   := .F.
Local lAnalisada:= .F.
Local lIniTes   := MV_PAR01==1
Local lDelCot   := MV_PAR04==2 .And. nOpcx == 5
Local lDelProd  := MV_PAR04==3 .And. nOpcx == 5
Local lMt150Scr := ExistBlock("MT150SCR")
Local lMT150OK  := ExistBlock("MT150OK")
Local lClicB	  := A131VerInt()
Local nOpc      := 0
Local nX        := 0
Local nSaveSX8  := GetSX8Len()
Local aObjects  := {}
Local aInfo 	 := {}
Local aPosGet	 := {}
Local aPosObj   := {}
Local aSizeAut  := {}
Local oDlg
Local oFolder
Local oGetDados
Local oForn
Local oSize
Local ocA150Loj
Local oCond
Local oGetMoeda
Local oDescCond
Local oDescMoed
Local oGetTaxa
Local lHelp := .F.

Local aItens	:= {}
Local aForns	:= {}
Local aCots	:= {}
/* aCots 	[x]
[x,1] 			- Num. Cota็ใo.
[x,2] 			- Data Emissใo.
[x,3,y] 		- Array de Fornecedores (aForns).
[x,3,y,1]		- Cod.  Fornecedor.
[x,3,y,2]		- Loja  Fornecedor.
[x,3,y,3]		- eMail Fornecedor.
[x,3,y,4,z]	- Array de Itens por Fornecedor (aItens).
[x,3,y,4,z,1]	- Cod. Produto.
[x,3,y,4,z,2] - Quantidade.
[x,3,y,4,z,3]	- Prazo de entrega.
*/
Local cBody := ""

If !l150Auto
	aSizeAut	:= MsAdvSize()
EndIf

PRIVATE l150Inclui  := .F.
PRIVATE l150Propost := .F.
PRIVATE l150Deleta  := .F.
PRIVATE l150Atuliz  := .F.
/*
If Ascan({2,3,4},nOpcX) > 0
	If !IsInCallStack("U_GJPINFFORN")
		If a150JaPedido(SC8->C8_NUM)
			lContinua := .F.
			If !l150Auto
				Aviso("Cancelar","Jแ existe Pedido de Compras gerado para esta Cota็ใo e por isso nใo ้ permitido nova inclusใo de participante.",{"Ok"})
				Return 0
			EndIf
		EndIf
	EndIf
EndIf
*/

//Limpa variaveis de BKP //
cFornBKP:=""
cLojBkp:=""

//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
//ณ Avalia botoes do usuario                                     ณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
If ExistBlock( "MA150BUT" )
	aButtons := ExecBlock( "MA150BUT", .F., .F. )
EndIf
//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
//ณIdentifica qual operacao esta sendo executada                 ณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
Do Case
	Case nOpcX == 6
		l150Visual := .T.
	Case nOpcX == 2
		l150Inclui	:= .T.
		If ExistBlock("MT150NPA")
			lContinua := ExecBlock("MT150NPA",.F.,.F.)
			If ValType(lContinua) <> "L"
				lContinua := .T.
			EndIf
		EndIf
	Case nOpcX == 3 .Or. nOpcX == 4
		If ExistBlock("MT150ENV")
			lContinua := ExecBlock("MT150ENV",.F.,.F.)
			If ValType(lContinua) <> "L"
				lContinua := .T.
			EndIf
		EndIf
		l150Altera	:= .T.
		If nOpcX == 4
			l150Propost := .T.
		EndIf
		If nOpcX == 3
			l150Atuliz := .T.
		EndIf
	Case nOpcX == 5
		l150Deleta	:= .T.
		l150Visual	:= .T.
EndCase

PRIVATE cA150Num  := SC8->C8_NUM
PRIVATE dA150Emis := SC8->C8_EMISSAO
PRIVATE cA150Forn := If(l150Inclui,CriaVar("C8_FORNECE"),SC8->C8_FORNECE)
PRIVATE cA150Loj  := If(l150Inclui,CriaVar("C8_LOJA"),SC8->C8_LOJA)

PRIVATE cA150FNome:= IF(l150Inclui,CriaVar("C8_FORNOME"),SC8->C8_FORNOME)
PRIVATE cA150FMail:= IF(l150Inclui,CriaVar("C8_FORMAIL"),SC8->C8_FORMAIL)

PRIVATE cA150ProvEnt:= If(cPaisLoc == "ARG", If(l150Inclui, CriaVar("C8_PROVENT"),SC8->C8_PROVENT ), "")
PRIVATE cCondicao := If(l150Inclui,CriaVar("C8_COND"),SC8->C8_COND)
PRIVATE cDescCond := If(l150Inclui,CriaVar("E4_DESCRI"),SE4->E4_DESCRI)
PRIVATE cContato  := If(l150Inclui,CriaVar("C8_CONTATO"),SC8->C8_CONTATO)
PRIVATE cMsg      := If(l150Inclui,CriaVar("C8_MSG"),SC8->C8_MSG)
PRIVATE cReajuste := If(l150Inclui,CriaVar("C8_REAJUST"),SC8->C8_REAJUST)
PRIVATE c150Frete := If(l150Inclui,"C-CIF",RetTipoFrete(SC8->C8_TPFRETE))
PRIVATE nDesc1	  := If(l150Inclui,CriaVar("C8_DESC1"),SC8->C8_DESC1)
PRIVATE nDesc2    := If(l150Inclui,CriaVar("C8_DESC2"),SC8->C8_DESC2)
PRIVATE nDesc3	  := If(l150Inclui,CriaVar("C8_DESC3"),SC8->C8_DESC3)
PRIVATE a150Var   := {0,0,0,0,0,0,0,0,0,0,0,0,0,0,0}
PRIVATE aCols     := {}
PRIVATE aHeader   := {}
PRIVATE aHeaderPro:= {}

PRIVATE bFolderRefresh:= {|| (StaticCall(MATA150,A150RodOk,oFolder,aObj)) }
PRIVATE bGDRefresh    := {|| (oGetDados:oBrowse:Refresh()) }
PRIVATE bZeraDesc	  := {|| (nDesc1:=0),(nDesc2:=0),(nDesc3:=0)}
PRIVATE bCalcDesc	  := {|| (A150VDesc(nDesc1,nDesc2,nDesc3,@a150Var))}
//PRIVATE bRefresh      := {|| (A150Refresh(@a150Var)),(Eval(bFolderRefresh))}
PRIVATE bRefresh      := {|| ( StaticCall(MATA150,A150Refresh,@a150Var) ),(Eval(bFolderRefresh))}
PRIVATE bFisToaCols   := {|| (A150FisToaCols()),Eval(bRefresh),Eval(bGDRefresh)}
PRIVATE nMoedaCot     := If(l150Inclui,Iif(SC8->C8_MOEDA > 0, SC8->C8_MOEDA, 1),Max(SC8->C8_MOEDA,1)) // Pega a moeda informada na rotina Gera Cotacoes (MATA130).
PRIVATE nTxMoeda      := If(l150Inclui,0,SC8->C8_TXMOEDA)
PRIVATE cDescMoed     := SuperGetMv("MV_MOEDA"+AllTrim(Str(nMoedaCot,2)))
PRIVATE cMoeda

If !l150Auto .And. !Empty(SC8->C8_ACCNUM) .And. Empty(SC8->C8_NUMPED)
	If nOpcX # 5
		Aviso("Portal ACC","Esta cota็ใo poderแ ser manipulada somente via portal ACC.",{"Ok"}) //"Portal ACC ## Esta cota็ใo poderแ ser manipulada somente via portal ACC."
		lContinua := .F.
	ElseIf Aviso("Portal ACC","Esta cota็ใo estแ no portal ACC. Prosseguir com a exclusใo?",{"Sim","Nใo"}) == 2
		lContinua := .F.
	EndIf
EndIf

//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
//ณ Verifica se a SC esta vinculada a um Edital              ณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
SC1->(dbSetOrder(5))
If SC1->( MsSeek(xFilial("SC1")+SC8->C8_NUM+SC8->C8_PRODUTO))
	If (SC1->C1_QUJE>0 .And. !Empty(SC1->C1_CODED) ) .And. !l150Auto
		Aviso('Atencao!','A Solicita็ใo de compras: '+SC1->C1_NUM+' estแ vinculada ao edital: '+Alltrim(SC1->C1_CODED)+', portanto nใo pode ser utilizada por um pedido de compras',{"Ok"})
		lContinua := .F.
	EndIf
EndIf

If lContinua
	//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
	//ณBotao de consulta ao Historico de Produtos                    ณ
	//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
	aadd(aButtons,{"S4WB005N" ,{|| A150ComView() },"Consultar Historico do Produto","Hist.Prd"})
	If ! __lPyme
		aadd(aButtons,{"RPMCPO"   ,{|| A150Replace() },"Replicar dados","Replicar"})  //"Replicar dados" ### "Replicar"
	EndIf
	
	//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
	//ณSe for rotina automatica nao executar funcoes de atualizacoesณ
	//ณde janela                                                    ณ
	//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
	If l150Auto
		bGDRefresh		:= {|| Nil }
		bFolderRefresh	:= {|| Nil }
		lDelCot 		:= (nOpcx==5) .And. MV_PAR04 == 2	// Exclusao por cotacao
	EndIf
	
	//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
	//ณVerifica se a Cotacao de compra pode ser alterada             ณ
	//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
	If ( l150Deleta )
		bBlock := {|| l1:=MaCanDelCOT("SC8",.F.,@cAviso,@cHelp),lValido:=If(lValido,lValido,l1),l1}
	Else
		bBlock := {|| l1:=MaCanAltCot("SC8",.F.,@cAviso,nOpcX),lValido:=If(lValido,lValido,l1),l1}
	EndIf
	
	//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
	//ณEfetua a montagem do Aheader e do Acols                       ณ
	//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
	MaFisIni(cA150Forn,cA150Loj,"F","N",,,,!l150Visual)
	lContinua := xA150Monta(nOpcX,bBlock,@aRecSc8,@aSCs,@aImpRef,lIniTes,lDelCot,lDelProd,@lAnalisada)
	//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
	//ณPonto de entrada para alterar/inserir dados no Item                     ณ
	//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
	If l150Altera .and.!l150Propost
		If ExistBlock("MT150GET")
			aColsUsr := ExecBlock("MT150GET",.F.,.F.,{aCols})
			If ValType(aColsUsr) == "A"
				aCols:= ACLONE(aColsUsr)
			EndIf
		Endif
	EndIF
	If ( lContinua .And. lValido )
		StaticCall(MATA150,A150CabOk,nOpcX,aImpRef,aInfForn,@cDescMsg,@cDescFor,@a150Var)
		A150DescCnd(cCondicao,,@cDescCond)
		A150DescMoed(nMoedaCot,,@cDescMoed)
		If !l150Auto
			//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
			//ณVerifica o tipo de Exclusao                                   ณ
			//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
			If nOpcX == 5 .And. (lDelCot .Or. lDelProd)
				If MsgYesNo(IIF(lDelCot,"Confirmar a exclusใo da cota็ใo?", "Caso o Produto fa็a parte de uma grade de produtos, toda a Familia deste produto serแ excluida. Confirma a exclusao desse produto de todos os fornecedores da cotacao ?"),"Atencao!") // ''Confirma exclusao da cotacao?'#'Atencao!'
					nOpc := 1
				EndIf
			Else
				aInfo := { aSizeAut[ 1 ], aSizeAut[ 2 ], aSizeAut[ 3 ], aSizeAut[ 4 ], 3, 3 }
				aPosGet := MsObjGetPos(aSizeAut[3]-aSizeAut[1],305,;
				{{10,40,95,140,200,222,268,240},;
				{10,40,111,140,223,268,63},;
				{5,70,160,205,295},;
				{6,34,200,215},;
				{6,34,80,113,153,178},;
				{6,34,245,268,260},;
				{10,50,150,190,120},;
				{273,130,190},;
				{8,45,73,103,139,167,190,225,253},;
				{144,190,144,190,289,293},;
				{142,293,140},;
				{9,47,188,148,9,146} } )
				DEFINE MSDIALOG oDlg FROM aSizeAut[7],0 TO aSizeAut[6],aSizeAut[5] TITLE cCadastro Of oMainWnd PIXEL
				
				oSize := FwDefSize():New(.T.,,,oDlg)
				
				oSize:AddObject('HEADER',100,40,.T.,.F.)
				oSize:AddObject('GRID'  ,100,10,.T.,.T.)
				oSize:AddObject('FOOT'  ,100,90,.T.,.F.)
				
				oSize:aMargins 	:= { 3, 3, 3, 3 }
				oSize:Process()
				
				aAdd(aPosObj,{oSize:GetDimension('HEADER', 'LININI'),oSize:GetDimension('HEADER', 'COLINI'),oSize:GetDimension('HEADER', 'LINEND'),oSize:GetDimension('HEADER', 'COLEND')})
				aAdd(aPosObj,{oSize:GetDimension('GRID'  , 'LININI'),oSize:GetDimension('GRID'  , 'COLINI'),oSize:GetDimension('GRID'  , 'LINEND'),oSize:GetDimension('GRID'  , 'COLEND')})
				aAdd(aPosObj,{oSize:GetDimension('FOOT'  , 'LININI'),oSize:GetDimension('FOOT'  , 'COLINI'),oSize:GetDimension('FOOT'  , 'LINEND'),oSize:GetDimension('FOOT'  , 'COLEND')})
				
				//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
				//ณCabecalho da cotacao de compra                                ณ
				//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
				@ aPosObj[1][1],aPosObj[1][2] TO aPosObj[1][3],aPosObj[1][4] LABEL '' OF oDlg PIXEL
				@ aPosObj[1][1]+3 ,aPosGet[1,1]  SAY OemToAnsi("Numero") Of oDlg PIXEL SIZE 31 ,6  // "Numero"
				@ aPosObj[1][1]+2 ,aPosGet[1,2]  MSGET cA150Num  Picture PesqPict('SC8','C8_NUM') F3 CpoRetF3('C8_NUM');
				When .F. Valid CheckSX3('C8_NUM',cA150Num) ;
				OF oDlg PIXEL SIZE 31 ,6
				@ aPosObj[1][1]+3 ,aPosGet[2,3]  SAY OemToAnsi("Data de Emissao") Of oDlg PIXEL SIZE 50 ,6 // "Data de Emissao"
				@ aPosObj[1][1]+2 ,aPosGet[1,4]  MSGET dA150Emis Picture PesqPict('SC8','C8_EMISSAO') F3 CpoRetF3('C8_EMISSAO');
				When .F. Valid CheckSX3('C8_EMISSAO',dA150Emis) ;
				OF oDlg PIXEL SIZE 42 ,6
				@ aPosObj[1][1]+3  ,aPosGet[1,5] SAY OemToAnsi("Fornecedor") Of oDlg PIXEL SIZE 36 ,6 // "Fornecedor"
				@ aPosObj[1][1]+2  ,aPosGet[1,6] MSGET oForn  VAR cA150Forn SIZE 075, 009 Picture PesqPict('SC8','C8_FORNECE') F3 CpoRetF3('C8_FORNECE');
				When l150Inclui  Valid A150Forn(cA150Forn,@cA150Loj,l150Inclui) .And. CheckSX3('C8_FORNECE',cA150Forn) .And. If(cPaisLoc == "ARG",a150ProEnt(),.T.) ;
				.And. A150AtuRef('NF_CODCLIFOR',cA150Forn) OF oDlg PIXEL SIZE 60 ,6
				@ aPosObj[1][1]+2  ,aPosGet[1,7] MSGET ocA150Loj VAR cA150Loj  Picture PesqPict('SC8','C8_LOJA') F3 CpoRetF3('C8_LOJA');
				When l150Inclui Valid A150Forn(cA150Forn,@cA150Loj,l150Inclui) .And. CheckSX3('C8_LOJA',cA150Loj) ;
				.And. A150AtuRef('NF_LOJA',cA150Loj).And. Eval(bRefCabOk) OF oDlg PIXEL SIZE 19 ,6
				@ aPosObj[1][1]+15 ,aPosGet[2,1]  SAY OemToAnsi("Cond. Pagto") Of oDlg PIXEL SIZE 30 ,6 // "Cond. Pagto"
				@ aPosObj[1][1]+14 ,aPosGet[2,2]  MSGET oCond VAR cCondicao  Picture PesqPict('SC8','C8_COND') F3 CpoRetF3('C8_COND');
				When !l150Visual .And. VisualSX3('C8_COND') Valid CheckSX3('C8_COND',cCondicao) .And. A150DescCnd(cCondicao,@oDescCond,@cDescCond,oGetDados) .And. A150ValCond(cCondicao) ;
				OF oDlg PIXEL SIZE 25 ,6
				@ aPosObj[1][1]+14,aPosGet[2,7] MSGET oDescCond VAR cDescCond PICTURE PesqPict('SE4','E4_DESCRI') ;
				WHEN .F. OF oDlg PIXEL SIZE 055,006
				@ aPosObj[1][1]+15 ,aPosGet[2,3] SAY OemToAnsi("Contato") Of oDlg PIXEL SIZE 38 ,6 // Contato
				@ aPosObj[1][1]+14 ,aPosGet[2,4] MSGET cContato  Picture PesqPict('SC8','C8_CONTATO') F3 CpoRetF3('C8_CONTATO');
				When !l150Visual .And. VisualSX3('C8_CONTATO') Valid CheckSX3('C8_CONTATO',cContato) ;
				OF oDlg PIXEL SIZE 74 ,6
				
				// novos campos nome email e wf
				@ aPosObj[1][1]+15  ,aPosGet[1,5] SAY OemToAnsi("Nome") Of oDlg PIXEL SIZE 36 ,6 // "Nome"
				@ aPosObj[1][1]+14  ,aPosGet[1,6] MSGET oForn  VAR cA150Fnome SIZE 100, 009 Picture PesqPict('SC8','C8_FORNOME');
				When a150fWhen() .And. l150Inclui OF oDlg PIXEL SIZE 60 ,6
				@ aPosObj[1][1]+27  ,aPosGet[1,5] SAY OemToAnsi("E-mail") Of oDlg PIXEL SIZE 36 ,6 // "Email"
				@ aPosObj[1][1]+26  ,aPosGet[1,6] MSGET oForn  VAR cA150FMail SIZE 100, 009 Picture PesqPict('SC8','C8_FORMAIL');
				OF oDlg PIXE SIZE 60,6
				/*
				Funcionalidade aguardando possibilidade de direcionar WF
				@ aPosObj[1][1]+27  ,aPosGet[1,6]+100 CHECKBOX oForn VAR cA150WF PROMPT "WF" OF oDlg SIZE 050, 010 PIXEL /* ON CLICK (ft321Click(lTarefa,oComboTar,@dDtTarIni,@dDtTarFim)
				*/
				
				If cPaisLoc == "ARG"
					@ aPosObj[1][1]+15,aPosGet[1,8] SAY Alltrim(RetTitle("C8_PROVENT")) OF oDlg PIXEL SIZE 045,10 // Prov. Entrega
					@ aPosObj[1][1]+14,aPosGet[1,7] MSGET oca150PrvE VAR cA150ProvEnt PICTURE PesqPict('SC8','C8_PROVENT') F3 CpoRetF3('C8_PROVENT');
					WHEN VisualSX3('C8_PROVENT')  Valid  ProvEntCt() OF oDlg PIXEL SIZE 019,006  HASBUTTON
				EndIf
				
				@ aPosObj[1][1]+27,aPosGet[1,1] SAY OemToAnsi("Moeda") OF oDlg PIXEL SIZE 030,006 // "Moeda"
				@ aPosObj[1][1]+26,aPosGet[2,2] MSGET oGetMoeda VAR nMoedaCot PICTURE PesqPict("SC8","C8_MOEDA") ;
				VALID M->nMoedaCot <= MoedFin() .And. M->nMoedaCot <> 0 .And. A150DescMoed(nMoedaCot,@oDescMoed,@cDescMoed,oGetTaxa) ;
				.And. Eval({|| IIf(oGetMoeda:lModified,nTxMoeda:=If(cPaisLoc=="BRA" .Or. GetNewPar("MV_MDLOCCT",.F.),RecMoeda(dDataBase,M->nMoedaCot),A150TxMoeda(nMoedaCot,oGetTaxa)),Nil),.T.} );
				.And. (StaticCall(MATA150,A150RodOk,oFolder,aObj,(cPaisLoc!="BRA")));
				WHEN !l150Visual .And. VisualSX3("C8_MOEDA") PIXEL SIZE 30,06 OF oDlg
				
				@ aPosObj[1][1]+26,aPosGet[2,7] MSGET oDescMoed VAR cDescMoed WHEN .F. OF oDlg PIXEL SIZE 055,006
				@ aPosObj[1][1]+27,aPosGet[2,3] SAY OemToAnsi("Taxa da Moeda") OF oDlg PIXEL SIZE 030,006 // "Taxa da Moeda"
				@ aPosObj[1][1]+26,aposget[1,4] MSGET oGetTaxa VAR nTxMoeda OF oDlg PICTURE PesqPict("SC8","C8_TXMOEDA",11) F3 CpoRetF3('C8_TXMOEDA');
				WHEN !l150Visual .And. VisualSX3('C8_TXMOEDA') Valid CheckSX3('C8_TXMOEDA',nMoedaCot) ;
				PIXEL SIZE 060,006
				//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
				//ณGetdados                                                      ณ
				//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
				oGetDados := MSGetDados():New(aPosObj[2,1],aPosObj[2,2],aPosObj[2,3],aPosObj[2,4],nOpcX,'A150LinOk','A150TudOk(,'+Str(nOpcX,1)+')','+C8_ITEM',.T.,,,,300,'A150FieldOk',,,'A150Del')
				
				oFolder := TFolder():New(aPosObj[3,1],aPosObj[3,2],aTitles,aPages,oDlg,,,, .T., .F.,aPosObj[3,4]-aPosObj[3,2],aPosObj[3,3]-aPosObj[3,1],)
				//acerto no folder para nao perder o foco
				For nX := 1 to Len(oFolder:aDialogs)
					DEFINE SBUTTON FROM 5000,5000 TYPE 5 ACTION Allwaystrue() ENABLE OF oFolder:aDialogs[nX]
				Next nX
				//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
				//ณFolder de totais                                              ณ
				//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
				oFolder:aDialogs[1]:oFont := oDlg:oFont
				aadd(aObj,Array(7))
				@ 6,aPosGet[3,1] SAY OemToAnsi("Valor da Mercadoria") Of oFolder:aDialogs[1] PIXEL SIZE 55 ,9 // "Valor da Mercadoria"
				@ 5,aPosGet[3,2] MSGET aObj[1][1] VAR a150Var[VALMERC] Picture PesqPict('SC8','C8_TOTAL',GetSx3Cache("C8_TOTAL","X3_TAMANHO"),nMoedaCot) OF oFolder:aDialogs[1] PIXEL When .F. SIZE 80 ,9
				@ 6,aPosGet[3,3] SAY OemToAnsi("Descontos") Of oFolder:aDialogs[1] PIXEL SIZE 49 ,9 // "Descontos"
				@ 5,aPosGet[3,4] MSGET aObj[1][2] VAR a150Var[VALDESC]  Picture PesqPict('SC8','C8_VLDESC',GetSx3Cache("C8_VLDESC","X3_TAMANHO"),nMoedaCot) OF oFolder:aDialogs[1] PIXEL When .F. SIZE 80 ,9
				If cPaisLoc == "BRA"
					@ 20,aPosGet[3,1] SAY OemToAnsi("Valor do IPI") Of oFolder:aDialogs[1] PIXEL SIZE 31 ,9 // "Valor do IPI"
					@ 19,aPosGet[3,2]  MSGET aObj[1][3] VAR a150Var[VALIPI]  Picture PesqPict('SC8','C8_VALIPI',14,nMoedaCot) OF oFolder:aDialogs[1] PIXEL When .F. SIZE 80 ,9
					@ 20,aPosGet[3,3] SAY OemToAnsi("Valor do ICMS") Of oFolder:aDialogs[1] PIXEL SIZE 34 ,9 // "Valor do ICMS"
					@ 19,aPosGet[3,4] MSGET aObj[1][4] VAR a150Var[VALICM]  Picture PesqPict('SC8','C8_VALICM',14,nMoedaCot) OF oFolder:aDialogs[1] PIXEL When .F. SIZE 80 ,9
				EndIf
				@ 34,aPosGet[3,1]   SAY OemToAnsi("Frete+Despesas") Of oFolder:aDialogs[1] PIXEL SIZE 50 ,9  // "Frete+Despesas"
				@ 33,aPosGet[3,2]  MSGET aObj[1][5] VAR a150Var[TOTF3]  Picture PesqPict('SC8','C8_VALFRE',14,nMoedaCot) OF oFolder:aDialogs[1] PIXEL When .F.  SIZE 80 ,9
				If cPaisLoc == "BRA"
					@ 34,aPosGet[3,3] SAY OemToAnsi("Valor ICMS Ret.") Of oFolder:aDialogs[1] PIXEL SIZE 50 ,9 // "Valor ICMS Ret."
					@ 33,aPosGet[3,4] MSGET aObj[1][6] VAR a150Var[VALSOL]  Picture PesqPict('SC8','C8_TOTAL',GetSx3Cache("C8_TOTAL","X3_TAMANHO"),nMoedaCot) OF oFolder:aDialogs[1] PIXEL When .F. SIZE 80 ,9
				EndIf
				@ 51,aPosGet[3,3] SAY OemToAnsi("Total do Pedido") Of oFolder:aDialogs[1] PIXEL SIZE 58 ,9 // "Total do Pedido"
				@ 49,aPosGet[3,4] MSGET aObj[1][7] VAR a150Var[TOTPED]  Picture PesqPict('SC8','C8_TOTAL',GetSx3Cache("C8_TOTAL","X3_TAMANHO"),nMoedaCot) OF oFolder:aDialogs[1] PIXEL When .F. SIZE 80 ,9
				@ 43 ,3   TO 46 ,aPosGet[3,5] LABEL '' OF oFolder:aDialogs[1] PIXEL
				//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
				//ณDados do Fornecedor                                           ณ
				//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
				oFolder:aDialogs[2]:oFont := oDlg:oFont
				aadd(aObj,Array(7))
				@ 6  ,aPosGet[4,1]  SAY OemToAnsi("Nome") Of oFolder:aDialogs[2] PIXEL SIZE 37 ,9 // "Nome"
				@ 5  ,aPosGet[4,2]  MSGET aObj[2][1] VAR aInfForn[1] Picture PesqPict('SA2','A2_NOME');
				When .F. OF oFolder:aDialogs[2] PIXEL SIZE 159,9
				@ 6  ,aPosGet[4,3] SAY OemToAnsi("Tel.") Of oFolder:aDialogs[2] PIXEL SIZE 23 ,9 // "Tel."
				@ 5  ,aPosGet[4,4] MSGET aObj[2][2] VAR aInfForn[2];
				When .F. OF oFolder:aDialogs[2] PIXEL SIZE 74 ,9
				@ 43 ,aPosGet[5,1]  SAY OemToAnsi("1a Compra") Of oFolder:aDialogs[2] PIXEL SIZE 32 ,9 // "1a Compra"
				@ 42 ,aPosGet[5,2]  MSGET aObj[2][3] VAR aInfForn[3] Picture PesqPict('SA2','A2_PRICOM') ;
				When .F. OF oFolder:aDialogs[2] PIXEL SIZE 40 ,9
				@ 43 ,aPosGet[5,3] SAY OemToAnsi("Ult. Compra") Of oFolder:aDialogs[2] PIXEL SIZE 36 ,9 // "Ult. Compra"
				@ 42 ,aPosGet[5,4] MSGET aObj[2][4] VAR aInfForn[4] Picture PesqPict('SA2','A2_ULTCOM');
				When .F. OF oFolder:aDialogs[2] PIXEL SIZE 40 ,9
				@ 43 ,aPosGet[5,5] SAY RetTitle("A2_CGC") Of oFolder:aDialogs[2] PIXEL SIZE 21 ,9 // "cgc"
				@ 42 ,aPosGet[5,6] MSGET aObj[2][7] VAR aInfForn[7] Picture PesqPict('SA2','A2_CGC');
				When .F. OF oFolder:aDialogs[2] PIXEL SIZE 76 ,9
				@ 24 ,aPosGet[6,1]   SAY OemToAnsi("Endereco") Of oFolder:aDialogs[2] PIXEL SIZE 49 ,9 // "Endereco"
				@ 23 ,aPosGet[6,2] MSGET aObj[2][5] VAR aInfForn[5]  Picture PesqPict('SA2','A2_END');
				When .F. OF oFolder:aDialogs[2] PIXEL SIZE 205,9
				@ 24 ,aPosGet[6,3] SAY OemToAnsi("Estado") Of oFolder:aDialogs[2] PIXEL SIZE 32 ,9 // "Estado"
				@ 23 ,aPosGet[6,4] MSGET aObj[2][6] VAR aInfForn[6]  Picture PesqPict('SA2','A2_EST');
				When .F. OF oFolder:aDialogs[2] PIXEL SIZE 21 ,9
				@42 ,aPosGet[6,5] BUTTON OemToAnsi("Mais Inf.") SIZE 30 ,10  FONT oDlg:oFont ACTION A1502FC030()  OF oFolder:aDialogs[2] PIXEL // "Mais Inf."
				//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
				//ณFolder de Frete e despesas acessorias                         ณ
				//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
				oFolder:aDialogs[3]:oFont := oDlg:oFont
				aadd(aObj,Array(5))
				@ 09,aPosGet[7,1] SAY OemToAnsi("Tp. Frete") Of oFolder:aDialogs[3] PIXEL SIZE 35 ,9 // "Tp. Frete"
				@ 08,aPosGet[7,2] MSCOMBOBOX aObj[3][1] VAR c150Frete ITEMS aCombo ON CHANGE A150VldCombo(c150Frete,@a150Var) .And. A150AtuRef("NF_FRETE",a150Var[FRETE]) WHEN !l150Visual SIZE 65 ,50 OF oFolder:aDialogs[3] PIXEL
				@ 09,aPosGet[7,3] SAY OemToAnsi("Valor do Frete") Of oFolder:aDialogs[3] PIXEL SIZE 35 ,9 //"Valor do Frete"
				@ 08,aPosGet[7,4] MSGET aObj[3][2] VAR a150Var[FRETE]  Picture PesqPict('SC8','C8_VALFRE',14,nMoedaCot) OF oFolder:aDialogs[3] PIXEL WHEN !l150Visual .And. c150Frete=="C-CIF" VALID Positivo() .AND. A150AtuRef("NF_FRETE",a150Var[FRETE]) SIZE 80,9
				@ 26,aPosGet[7,1] SAY OemToAnsi("Despesas") Of oFolder:aDialogs[3] PIXEL SIZE 42 ,9 // "Despesas"
				@ 25,aPosGet[7,2] MSGET aObj[3][3] VAR a150Var[VALDESP] Picture PesqPict('SC8','C8_VALFRE',14,nMoedaCot) OF oFolder:aDialogs[3] PIXEL WHEN !l150Visual VALID Positivo() .AND. A150AtuRef("NF_DESPESA",a150Var[VALDESP]) SIZE 80,9
				@ 26,aPosGet[7,3] SAY OemToAnsi("Seguro") Of oFolder:aDialogs[3] PIXEL SIZE 35 ,9 // "Seguro"
				@ 25,aPosGet[7,4] MSGET aObj[3][4] VAR a150Var[SEGURO]  Picture PesqPict('SC8','C8_VALFRE',14,nMoedaCot) OF oFolder:aDialogs[3] PIXEL WHEN !l150Visual VALID Positivo() .AND. A150AtuRef("NF_SEGURO",a150Var[SEGURO]) SIZE 80,9
				@ 38,11  TO 40 ,aPosGet[8,1] LABEL '' OF oFolder:aDialogs[3] PIXEL
				@ 48,aPosGet[7,5] SAY OemToAnsi("Total ( Frete+Despesas)") Of oFolder:aDialogs[3] PIXEL SIZE 65 ,09 // "Total ( Frete+Despesas)"
				@ 47,aPosGet[8,3] MSGET aObj[3][5] VAR a150Var[TOTF3]  Picture PesqPict('SC8','C8_VALFRE',14,nMoedaCot) OF oFolder:aDialogs[3] PIXEL WHEN .F. SIZE 80,9
				//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
				//ณFolder de Descontos                                           ณ
				//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
				oFolder:aDialogs[4]:oFont := oDlg:oFont
				aadd(aObj,Array(5))
				@ 9 ,aPosGet[9,1]  SAY OemToAnsi("Desconto 1") Of oFolder:aDialogs[4] PIXEL SIZE 40 ,9 // "Desconto 1"
				@ 8 ,aPosGet[9,2]  MSGET aObj[4][1] VAR nDesc1  Picture PesqPict('SC8','C8_DESC1',6,nMoedaCot) OF oFolder:aDialogs[4] PIXEL WHEN !l150Visual VALID Positivo() .AND. A150VDesc(@nDesc1,@nDesc2,@nDesc3,@a150Var) SIZE 30 ,9
				@ 9 ,aPosGet[9,3]  SAY '%' Of oFolder:aDialogs[4] PIXEL SIZE 11 ,9
				@ 9 ,aPosGet[9,4] SAY OemToAnsi("Desconto 2") Of oFolder:aDialogs[4] PIXEL SIZE 36 ,9 // "Desconto 2"
				@ 8 ,aPosGet[9,5] MSGET aObj[4][2] VAR nDesc2  Picture PesqPict('SC8','C8_DESC2',6,nMoedaCot) OF oFolder:aDialogs[4] PIXEL WHEN !l150Visual VALID Positivo() .AND. A150VDesc(@nDesc1,@nDesc2,@nDesc3,@a150Var) SIZE 30 ,9
				@ 9 ,aPosGet[9,6] SAY '%' Of oFolder:aDialogs[4] PIXEL SIZE 9  ,9
				@ 9 ,aPosGet[9,7] SAY OemToAnsi("Desconto 3") Of oFolder:aDialogs[4] PIXEL SIZE 42 ,9 // "Desconto 3"
				@ 8 ,aPosGet[9,8] MSGET aObj[4][3] VAR nDesc3  Picture PesqPict('SC8','C8_DESC3',6,nMoedaCot) OF oFolder:aDialogs[4] PIXEL WHEN !l150Visual VALID Positivo() .AND. A150VDesc(@nDesc1,@nDesc2,@nDesc3,@a150Var) SIZE 30 ,9
				@ 9 ,aPosGet[9,9] SAY '%' Of oFolder:aDialogs[4] PIXEL SIZE 12 ,9
				@ 27 ,aPosGet[10,1] SAY OemToAnsi("Valor do Desconto") Of oFolder:aDialogs[4] PIXEL SIZE 48 ,9 //"Valor do Desconto"
				@ 26 ,aPosGet[10,2] MSGET aObj[4][4] VAR a150Var[VALDESC]  Picture PesqPict('SC8','C8_VLDESC',GetSx3Cache("C8_VLDESC","X3_TAMANHO"),nMoedaCot) OF oFolder:aDialogs[4] PIXEL When !l150Visual .And.(nDesc1+nDesc2+nDesc3==0) VALID Positivo() .AND. A150AtuRef("NF_DESCONTO",a150Var[VALDESC]) SIZE 75 ,9
				@ 49 ,aPosGet[10,3] SAY OemToAnsi("Total do Pedido") Of oFolder:aDialogs[4] PIXEL SIZE 43 ,9 // "Total do Pedido"
				@ 48 ,aPosGet[10,4] MSGET aObj[4][5] VAR a150Var[TOTPED]  Picture PesqPict('SC8','C8_TOTAL',GetSx3Cache("C8_TOTAL","X3_TAMANHO"),nMoedaCot) OF oFolder:aDialogs[4] PIXEL When .F. SIZE 75 ,9
				@ 38 ,5   TO 40 ,aPosGet[10,5] LABEL '' OF oFolder:aDialogs[4] PIXEL
				//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
				//ณFolder de Resumo dos impostos                                 ณ
				//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
				oFolder:aDialogs[5]:oFont := oDlg:oFont
				aadd(aObj,Array(1))
				aObj[5][1] := MaFisRodape(mv_par05,oFolder:aDialogs[5],,{5,3,aPosGet[10,6],53},bFisToaCols,l150Visual)
				//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
				//ณFolder de Formulas de reajuste e mensagem                     ณ
				//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
				oFolder:aDialogs[6]:oFont := oDlg:oFont
				@ 5  ,aPosGet[11,1] TO 55 ,aPosGet[11,2] LABEL OemToAnsi("Reajuste") OF oFolder:aDialogs[6] PIXEL //"Reajuste"
				@ 5  ,3   TO 55 ,aPosGet[11,3] LABEL OemToAnsi("Mensagem") OF oFolder:aDialogs[6] PIXEL // "Mensagem"
				@ 15 ,aPosGet[12,1]  SAY OemToAnsi("Cod. Formula") Of oFolder:aDialogs[6] PIXEL SIZE 40 ,9 // "Cod. Formula"
				@ 14 ,aPosGet[12,2]  MSGET cMsg Picture PesqPict('SC8','C8_MSG') F3 CpoRetF3('C8_MSG');
				When !l150Visual .And.VisualSX3('C8_MSG') ;
				Valid CheckSX3('C8_MSG',cMsg) .And. A120FormDesc(cMsg,@cDescMsg) .And.;
				Eval(bFolderRefresh) ;
				OF oFolder:aDialogs[6] PIXEL SIZE 23 ,9
				@ 14 ,aPosGet[12,3] MSGET cReajuste Picture PesqPict('SC8','C8_REAJUST') F3 CpoRetF3('C8_REAJUST');
				When !l150Visual .And.VisualSX3('C8_REAJUST') ;
				Valid CheckSX3('C8_REAJUST',cReajuste) .And. A120FormReaj(cReajuste,@cDescFor) .And.;
				Eval(bFolderRefresh) ;
				OF oFolder:aDialogs[6] PIXEL SIZE 23 ,9
				@ 15 ,aPosGet[12,4] SAY OemToAnsi("Cod. Formula") Of oFolder:aDialogs[6] PIXEL SIZE 40 ,9 //"Cod. Formula"
				@ 32 ,aPosGet[12,5] MSGET cDescMsg  Picture "@!" OF oFolder:aDialogs[6] When .F. PIXEL SIZE 124,9
				@ 31 ,aPosGet[12,6] MSGET cDescFor  Picture "@!" OF oFolder:aDialogs[6] When .F. PIXEL SIZE 140,9
				
				If lMt150Scr
					ExecBlock("MT150SCR",.F.,.F.,@oDlg)
				EndIf
				
				ACTIVATE MSDIALOG oDlg ON INIT ;
				EnchoiceBar(oDlg,{||If(oGetDados:TudoOk().And. StaticCall(MATA150,A150CabOk,nOpcX,aImpRef,aInfForn,@cDescMsg,@cDescFor,@a150Var,.T.).And.A150OK(nOpcX,lMT150OK),(nOpc:=1,oDlg:End()),nOpc:=0)},{||nOpc:=0,oDlg:End()},,aButtons)
			EndIf
		Else
			nOpc	:= 1
			If !l150Deleta
				//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
				//ณ Execucao da rotina automatica                               ณ
				//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
				aValidGet := {}
				If l150Inclui
					AADD(aValidGet,{"cA150Forn"  ,aAutoCab[ProcH("C8_FORNECE"),2],"A150Forn(cA150Forn,@cA150Loj,l150Inclui) .And. CheckSX3('C8_FORNECE',cA150Forn).And. A150AtuRef('NF_CODCLIFOR',cA150Forn)" + If(cPaisLoc == "ARG"," .And. a150ProEnt()",""),.T.})
					AADD(aValidGet,{"cA150Loj"   ,aAutoCab[ProcH("C8_LOJA"   ),2],"A150Forn(cA150Forn,@cA150Loj,l150Inclui) .And. CheckSX3('C8_LOJA',cA150Loj) .And. A150AtuRef('NF_LOJA',cA150Loj)",.T.})
				EndIf
				If cPaisLoc == "ARG" .And. ProcH("C8_PROVENT")<>0
					AADD(aValidGet,{"cA150ProvEnt" ,aAutoCab[ProcH("C8_PROVENT" ),2],"ProvEntCt()",.T.})
				EndIf
				AADD(aValidGet,{"cCondicao"  ,aAutoCab[ProcH("C8_COND"   ),2],"CheckSX3('C8_COND',cCondicao)",.T.})
				AADD(aValidGet,{"cContato"   ,aAutoCab[ProcH("C8_CONTATO"),2],"CheckSX3('C8_CONTATO',cContato)",.F.})
				If !IsInCallStack("PUTQUOTE") // Veio do Portal do Fornecedor
					AADD(aValidGet,{"nMoedaCot"   ,aAutoCab[ProcH("C8_MOEDA"),2],"CheckSX3('C8_MOEDA',nMoedaCot)",.T.})
				EndIf
				If nOpc == 1 .And. !SC8->(MsVldGAuto(aValidGet))
					nOpc := 0
				EndIf
				If nOpc == 1 .And. !MsGetDAuto(aAutoItens,"A150LinOk",{|| A150TudOk(,nOpcX).And. StaticCall(MATA150,A150CabOk,nOpcX,aImpRef,aInfForn,@cDescMsg,@cDescFor,@a150Var)},aAutoCab)
					nOpc := 0
				EndIf
				//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
				//ณValida os Gets referentes ao rodapeณ
				//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
				aValidGet := {}
				If ProcH("C8_TPFRETE") > 0
					AADD(aValidGet,{"c150frete" ,aAutoCab[ProcH("C8_TPFRETE" ),2],  "A150VldCombo(c150Frete,@a150Var) .And. A150AtuRef('NF_FRETE',a150Var[5])",.T.})
				EndIf
				If ProcH("C8_TOTFRE" ) > 0
					AADD(aValidGet,{"a150var[5]" ,aAutoCab[ProcH("C8_TOTFRE" ),2],  "A150AtuRef('NF_FRETE',a150var[5])",.T.})
				EndIf
				If ProcH("C8_VLDESC" ) > 0
					AADD(aValidGet,{"a150var[2]" ,aAutoCab[ProcH("C8_VLDESC" ),2],"A150AtuRef('NF_DESCONTO',a150var[2])",.T.})
				EndIf
				If ProcH("C8_DESPESA" ) > 0
					AADD(aValidGet,{"a150var[6]" ,aAutoCab[ProcH("C8_DESPESA" ),2],"A150AtuRef('NF_DESPESA',a150var[6])",.T.})
				EndIf
				If ProcH("C8_SEGURO" ) > 0
					AADD(aValidGet,{"a150var[14]" ,aAutoCab[ProcH("C8_SEGURO" ),2],"A150AtuRef('NF_SEGURO',a150var[14])",.T.})
				EndIf
				If ProcH("C8_DESC1") > 0
					AADD(aValidGet,{"nDesc1"     ,aAutoCab[ProcH("C8_DESC1"  ),2],  "A150VDesc(@nDesc1,@nDesc2,@nDesc3,@a150var)",.T.})
				EndIf
				If ProcH("C8_DESC2") > 0
					AADD(aValidGet,{"nDesc2"     ,aAutoCab[ProcH("C8_DESC2"  ),2],  "A150VDesc(@nDesc1,@nDesc2,@nDesc3,@a150var)",.T.})
				EndIf
				If ProcH("C8_DESC3") > 0
					AADD(aValidGet,{"nDesc3",aAutoCab[ProcH("C8_DESC3"  ),2],  "A150VDesc(@nDesc1,@nDesc2,@nDesc3,@a150var)",.T.})
				EndIf
				If ProcH("C8_MSG") > 0
					AADD(aValidGet,{"cMsg" ,aAutoCab[ProcH("C8_MSG" ),2],"CheckSX3('C8_MSG',cMsg) .And. (Vazio() .Or. ExistCpo('SM4'))",.T.})
				EndIf
				If ProcH("C8_REAJUST") > 0
					AADD(aValidGet,{"cReajuste"  ,aAutoCab[ProcH("C8_REAJUST"),2],"CheckSX3('C8_REAJUST',cReajuste) .And. (Vazio() .Or. ExistCpo('SM4'))",.T.})
				EndIf
				If nOpc == 1 .And. !SC8->(MsVldGAuto(aValidGet))
					nOpc := 0
				EndIf
			EndIf
		EndIf
	Else
		If ( !lValido .and. !l150Auto )
			If lAnalisada
				Aviso("Analisada","Cota็ใo jแ foi analisada",{"Voltar"},2) //"Analisada"#"Cota็ใo jแ foi analisada"#"Voltar"
			Else
				Aviso("Acesso Restrito",cAviso,{"Voltar"},2) //"Acesso Restrito"###"Voltar"
			EndIf
		EndIf
	EndIf
	
	If nOpc == 1
		Begin Transaction
		//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
		//ณ Efetua a gravacao do Pedido (Inclusao/Alteracao/Exclusao  ณ
		//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
		If l150Inclui .Or. l150Altera .Or. l150Deleta
			If Type("lOnUpDate") == "U" .Or. lOnUpdate
				//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
				//ณ Inicializa a gravacao atraves das funcoes MATXFIS         ณ
				//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
				If ( !(StaticCall(MATA150,A150Grava,nOpcX,aRecSC8,aSCs,bBlock)) )
					lHelp := .T.
				Else
					//Monta Array para envio de e-mail ao fornecedor adicionado.
					If SuperGetMV("MV_ENVCOT") .AND. !Empty(SC8->C8_FORMAIL) .AND. l150Inclui
						aAdd(aItens,allTrim(SC8->C8_PRODUTO))
						aAdd(aItens,SC8->C8_QUANT)
						aAdd(aItens,SC8->C8_PRAZO)
						
						aAdd(aForns,allTrim(SC8->C8_FORNECE))
						aAdd(aForns,allTrim(SC8->C8_LOJA))
						aAdd(aForns,allTrim(SC8->C8_FORMAIL))
						aAdd(aForns,{})
						aAdd(aForns[4],aItens)
						
						aAdd(aCots,{})
						aAdd(aCots[1],allTrim(SC8->C8_NUM))
						aAdd(aCots[1],SC8->C8_EMISSAO)
						aAdd(aCots[1],{})
						aAdd(aCots[1][3],aForns)
					EndIf
					
					If nOpcX == 5
						If lClicB
							A311RegCot(cNumCot,3)
						Endif
					Endif
					EvalTrigger()
					While ( GetSX8Len() > nSaveSX8 )
						ConfirmSx8()
					EndDo
				EndIf
			Else
				aAutoItens := MsAuto2Gd(aHeader,aCols)
			EndIf
		EndIf
		End Transaction
		If lHelp
			Help(" ",1,"A150NAOREG")
		Endif
		If ExistBlock("MT150END")
			ExecBlock("MT150END",.F.,.F.,{nOpcx})
		EndIf
	Endif
	
	If nOpc == 0
		While ( GetSX8Len() > nSaveSX8 )
			RollBackSX8()
		EndDo
	Else
		If SuperGetMV("MV_ENVCOT") .AND. Len(aCots) > 0 .AND. l150Inclui
			cBody := A131GerMail(aCots[1][1],aCots[1][2],aCots[1][3][1])
			MTSendMail({aCots[1][3][1][3]},OemToAnsi(' '),cBody)
		EndIf
	EndIf
	//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
	//ณ Destrava os registros na aletaracao e exclusao            ณ
	//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
	If l150Altera .Or. l150Deleta
		MsUnlockAll()
	EndIf
	//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
	//ณ Finaliza o uso das funcoes MATXFIS                        ณ
	//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
	MaFisEnd()
	RestArea(aArea)
	If !(SC8->(IndexOrd()) > 0) //ajuste para Oracle
		dbSetOrder(1)
	EndIf
	Return(nOpc)
EndIf


/*/
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑฺฤฤฤฤฤฤฤฤฤฤยฤฤฤฤฤฤฤฤฤฤยฤฤฤฤฤฤฤยฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤยฤฤฤฤฤฤยฤฤฤฤฤฤฤฤฤฤฤฟฑฑ
ฑฑณFuno    ณa150Monta ณ Autor ณ Eduardo Riera         ณ Data ณ27.07.2000 ณฑฑ
ฑฑรฤฤฤฤฤฤฤฤฤฤลฤฤฤฤฤฤฤฤฤฤมฤฤฤฤฤฤฤมฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤมฤฤฤฤฤฤมฤฤฤฤฤฤฤฤฤฤฤดฑฑ
ฑฑณ          ณRotina de montagem do aHeader e do aCols da cotacao de compraณฑฑ
ฑฑรฤฤฤฤฤฤฤฤฤฤลฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤดฑฑ
ฑฑณSintaxe   ณExpL1 := A150Monta(ExpN1,ExpB1,ExpA1,ExpA2,ExpA3,ExpL1,	   ณฑฑ
ฑฑณ          ณ                   ExpL2,ExpL3)                              ณฑฑ
ฑฑรฤฤฤฤฤฤฤฤฤฤลฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤดฑฑ
ฑฑณParametrosณExpN1: [2] Novo participante                                 ณฑฑ
ฑฑณ          ณ       [3] Atualiza cotacao                                  ณฑฑ
ฑฑณ          ณ       [3] Nova propostaante                                 ณฑฑ
ฑฑณ          ณ       [4] Exclusao                                          ณฑฑ
ฑฑณ          ณExpB1: Code block que eh avaliado para cada registro do SC8  ณฑฑ
ฑฑณ          ณExpA1: Registros do SC8 para atualizacao                     ณฑฑ
ฑฑณ          ณExpA2: Identificador de amarracao com a cotacao              ณฑฑ
ฑฑณ          ณExpA3: Impostos tratados pela rotina                         ณฑฑ
ฑฑณ          ณExpL1: Indica se a TES deve ser inicializada                 ณฑฑ
ฑฑณ          ณExpL2: Indica qdo delecao da cotacao  		               ณฑฑ
ฑฑณ          ณExpL3: Indica qdo delecao do produto 			               ณฑฑ
ฑฑณ          ณExpL4: Indica cotacao ja analisada 			               ณฑฑ
ฑฑรฤฤฤฤฤฤฤฤฤฤลฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤดฑฑ
ฑฑณRetorno   ณ ExpL1: Conforme indicado pelo CodeBlock em ExpB2, quando o  ณฑฑ
ฑฑณ          ณ este indicar .F., a execucao da funcao sera interrompida.   ณฑฑ
ฑฑณ          ณ Para o codeblock sera informado o alias do SC8.             ณฑฑ
ฑฑรฤฤฤฤฤฤฤฤฤฤลฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤดฑฑ
ฑฑณDescrio ณEsta rotina tem como objetivo atualizar as variaveis de uti- ณฑฑ
ฑฑณ          ณlizada na modelo 2.                                          ณฑฑ
ฑฑรฤฤฤฤฤฤฤฤฤฤลฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤดฑฑ
ฑฑณUso       ณ Materiais                                                   ณฑฑ
ฑฑภฤฤฤฤฤฤฤฤฤฤมฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤูฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
/*/
Static Function xa150Monta(nOpc,bBlock,aRecNo,aSCs,aRefImpos,lIniTes,lDelCot,lDelProd,lAnalisada)

Local aSC8      := {}
Local bWhile    := {|| !Eof() .And. SC8->C8_FILIAL == xFilial("SC8") .And.;
SC8->C8_NUM == cA150Num .And.;
SC8->C8_FORNECE == cFornece .And.;
SC8->C8_LOJA == cLoja }
Local nItensG  := 0
Local nUsado   := 0
Local nX	   := 0
Local nY	   := 0
Local nZ	   := 0
Local nPosTes  := 0
Local nPosTotal:= 0
Local nPNumPro := 0
Local nPItem   := 0
Local nPosRef1 := 0
Local nPosRef2 := 0
Local nTotal   := 0
Local cFornece := ""
Local cLoja    := ""
Local cProposta:= SC8->C8_NUMPRO
//Local cItem    := StrZero(0,Len(SC8->C8_ITEM))
Local cNextPro := ""
Local lItensG  := .F.
Local lRetorno := .T.
Local lMT150Lin:= ExistBlock("MT150LIN")
Local cProduto := ""
Local cProdDel := SC8->C8_PRODUTO
Local cProdSC8 := SC8->C8_PRODUTO
Local lZeraProp:= GetNewPar('MV_ZERPROP','1') == '1' //1=Sim  2=Nao - Zera os valores na inclusao de nova proposta
Local lReItProp:= GetNewPar('MV_REITPRO','1') == '1' //1=Sim  2=Nao - Renumera os itens na inclusao de nova proposta, caso exista um item deletado na proposta origem.
Local lDelForn := .F.
Local lDelCotAc:= GetNewPar('MV_PERFORM',.T.) //Indica se na exclusao da cotacao inteira ou por produto sera carregado o acols, pois esses tipos de exclusoes nao e apresentada a tela
Local lMT150Chv:= ExistBlock("MT150CHV")
Local cChaveDel:= SC8->C8_PRODUTO
Local cChaveAux:= ""
Local bSoftlock:= {|| Iif(nOpc == 5 , .T. , SoftLock("SC8") ) }
Local aNoFields:= {"C8_FORNOME","C8_FORMAIL","C8_WF","C8_FORNECE","C8_LOJA","C8_CONTATO","C8_COND"}
Local lFornNome:= .F.
Local lScan	 := .F.
Local cItem	:= StrZero(1,TamSx3("C8_ITEM")[1])

DEFAULT bBlock		:= {|| .T.}
DEFAULT lIniTes		:= .F.
DEFAULT lDelCot		:= .F.
DEFAULT lDelProd	:= .F.
DEFAULT lAnalisada	:= .F.
DEFAULT aRecNo		:= {}
DEFAULT aSCs		:= {}

PRIVATE N


bWhile    := {|| !Eof() .And. SC8->C8_FILIAL == xFilial("SC8") .And.;
SC8->C8_NUM == cA150Num .And.;
SC8->C8_FORNECE == cFornece .And.;
SC8->C8_LOJA == cLoja .And. ;
SC8->C8_FORNOME == cA150FNome }

lGrade := If(Type('lGrade')=="L",lGrade,MaGrade())

MatGrdPrrf(@cProdDel, .T.)

If cPaisLoc == "ARG"
	dbSelectArea("SA2")
	dbSetOrder(1)
	If ( MsSeek(xFilial("SA2")+cA150Forn+cA150Loj) )
		If Empty(cA150ProvEnt)
			cA150ProvEnt := SA2->A2_EST // Provincia de Entrega do Fornecedor
		Endif
	Endif
EndIf

If !lDelCot .And. !lDelProd
	lDelForn := .T.
Endif
If !lDelCotAc .And. nOpc <> 5
	lDelCotAc := .T.
Endif
If lDelProd .And. lMT150Chv
	cChaveAux := ExecBlock("MT150CHV",.F.,.F.)
	If ValType(cChaveAux) == "C" .And. !Empty(cChaveAux)
		cChaveDel += &(cChaveAux)
		cChaveAux := "SC8->C8_PRODUTO+"+cChaveAux
	Endif
Endif

If lDelCotAc .Or. (nOpc == 5 .And. lDelForn)
	//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
	//ณ Faz a montagem do aHeader a partir dos campos SX3.           ณ
	//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
	aHeader := {}
	//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
	//ณ Montagem do aHeader                                          ณ
	//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
	dbSelectArea("SX3")
	dbSetOrder(1)
	dbSeek("SC8")
	While ( !Eof() .And. SX3->X3_ARQUIVO == "SC8" )
		If ( X3Uso(SX3->X3_USADO) .And. cNivel >= SX3->X3_NIVEL .And. aScan(aNoFields,AllTrim(SX3->X3_CAMPO)) == 0 )
			nUsado++
			AADD(aHeader,{ TRIM(X3Titulo()),;
			SX3->X3_CAMPO,;
			SX3->X3_PICTURE,;
			SX3->X3_TAMANHO,;
			SX3->X3_DECIMAL,;
			SX3->X3_VALID,;
			SX3->X3_USADO,;
			SX3->X3_TIPO,;
			SX3->X3_ARQUIVO,;
			SX3->X3_CONTEXT } )
			
			//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
			//ณ Array dos campos de Usuario para posterior replicacao do aCols ณ
			//ณ na funcao a150AcolsSC8 em unificacao de precos = SIM           ณ
			//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
			aAdd(aHeaderPro,{X3_CAMPO, X3_PROPRI} )
			
			If ( Trim(SX3->X3_CAMPO)=="C8_NUMPRO" )
				nPNumPro := nUsado
			ElseIf ( Trim(SX3->X3_CAMPO)=="C8_ITEM" )
				nPItem := nUsado
			ElseIf ( Trim(SX3->X3_CAMPO)=="C8_TES" )
				nPosTes := nUsado
			ElseIf ( Trim(SX3->X3_CAMPO)=="C8_TOTAL" )
				nPosTotal := nUsado
			EndIf
		EndIf
		nPosRef1	:= At("MAFISREF(",Upper(SX3->X3_VALID))
		If ( nPosRef1 > 0 )
			nPosRef1    += 10
			nPosRef2    := At(",",SubStr(SX3->X3_VALID,nPosRef1))-2
			aadd(aRefImpos,{"SC8",SX3->X3_CAMPO,SubStr(SX3->X3_VALID,nPosRef1,nPosRef2)})
		EndIf
		dbSelectArea("SX3")
		dbSkip()
	EndDo
	
	//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
	//ณ Aciona o Walk Thru somente quando nao for utilizada a unificacao de precos ณ
	//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
	If mv_par06 == 1
		ADHeadRec("SC8",aHeader)
	EndIf
	
	//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
	//ณ Faz a montagem do aCols com os dados da Cotacao de Compra    ณ
	//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
	aCols := {}
Endif
Do Case
	Case ( nOpc == 5 .And. (lDelCot .Or. lDelProd) )
		dbSelectArea("SC8")
		If lDelCot
			dbSetOrder(1)
			dbSeek(xFilial("SC8")+cA150Num)
			bWhile := {|| !Eof() .And. SC8->C8_FILIAL == xFilial("SC8") .And.;
			SC8->C8_NUM == cA150Num }
		Else
			If SC8->C8_GRADE == "S"
				dbSetOrder(1)
				dbSeek(xFilial("SC8")+cA150Num)
				bWhile := {|| !Eof() .And. SC8->C8_FILIAL == xFilial("SC8") .And.;
				SC8->C8_NUM == cA150Num }
			Else
				dbSetOrder(3)
				dbSeek(xFilial("SC8")+cA150Num+cProdDel)
				bWhile := {|| !Eof() .And. SC8->C8_FILIAL == xFilial("SC8") .And.;
				SC8->C8_NUM == cA150Num .And. SC8->C8_PRODUTO == cProdDel }
			EndIf
		Endif
	Case ( nOpc <> 2 )
		cFornece := cA150Forn
		cLoja    := cA150Loj
		cProposta:= SC8->C8_NUMPRO
		dbSelectArea("SC8")
		If mv_par06==2
			dbSetOrder(10)
			dbSeek(xFilial("SC8")+cA150Num+cFornece+cLoja)
		Else
			dbSetOrder(8)
			dbSeek(xFilial("SC8")+cA150Num+cFornece+cLoja+cA150FNome)
		EndIf
	OtherWise
		bWhile := {|| !Eof() .And. SC8->C8_FILIAL == xFilial("SC8") .And.;
		SC8->C8_NUM == cA150Num }
		dbSelectArea("SC8")
		dbSetOrder(1)
		dbSeek(xFilial("SC8")+cA150Num)
EndCase

While ( Eval(bWhile) )
	//	If (lDelCot .Or. lDelProd) .Or. aScan(aSC8,{|x| x[1] == SC8->C8_PRODUTO.And.x[2]==SC8->C8_IDENT})==0
	If (lDelCot .Or. lDelProd) .Or. aScan(aSC8,{|x| x[1] == SC8->C8_PRODUTO .And. x[2]==SC8->C8_IDENT .And. x[3]==SC8->C8_NUMPRO})==0   //Inserido por Carlos Queiroz em 11/10/16
		///		If ( (lDelCot .Or. lDelProd) ) //.Or. SC8->C8_NUMPRO == cProposta )
		If nOpc==3 .And. !Empty(SC8->C8_NUMPED)
			lAnalisada := .T.
			SC8->(dbSkip())
			Loop
		Endif
		If ( Eval(bSoftlock) .And. Eval(bBlock,"SC8") )
			If lDelCotAc .Or. (nOpc == 5 .And. lDelForn)
				If mv_par06 == 1
					AADD(aCols,Array(Len(aHeader)+1))
				Endif
			Endif
			If lDelProd
				If !lMT150Chv
					cProdSC8 := SC8->C8_PRODUTO
					MatGrdPrrf(@cProdSC8, .T.)
					If cProdDel == cProdSC8
						AADD(aRecNo,SC8->(RecNo()))
					Endif
				Else
					If !Empty(cChaveAux) .And. !Empty(cChaveDel)
						If cChaveDel == &(cChaveAux)
							AADD(aRecNo,SC8->(RecNo()))
						Endif
					Else
						cProdSC8 := SC8->C8_PRODUTO
						MatGrdPrrf(@cProdSC8, .T.)
						If cProdDel == cProdSC8
							AADD(aRecNo,SC8->(RecNo()))
						Endif
					Endif
				Endif
			Else
				AADD(aRecNo,SC8->(RecNo()))
			Endif
			AADD(aScs,{SC8->C8_NUMSC,SC8->C8_ITEMSC,SC8->C8_IDENT,SC8->C8_GRUPCOM,alltrim(SC8->C8_PRODUTO),SC8->(RecNo())})
			
			If lDelCotAc .Or. (nOpc == 5 .And. lDelForn)
				If mv_par06 == 1
					nX++
				Else
					//						If cProduto <> SC8->C8_PRODUTO
					AADD(aCols,Array(Len(aHeader)+1))
					cProduto := SC8->C8_PRODUTO
					nX++
					//		                EndIf
				Endif
				
				For nY := 1 To Len(aHeader)
					dbSelectArea("SC8")
					If mv_par06 == 1
						If ( aHeader[nY][10] != "V")
							aCols[nX][nY] := FieldGet(FieldPos(aHeader[nY][2]))
						ElseIf IsHeadRec(aHeader[nY][2])
							aCols[nX][nY] := IIF(nOpc == 3 .Or. (nOpc == 5 .And. mv_par04 == 1) , SC8->(Recno()) , 0 )
						ElseIf IsHeadAlias(aHeader[nY][2])
							aCols[nX][nY] := "SC8"
						Else
							aCols[nX][nY] := CriaVar(aHeader[nY][2],.T.)
						EndIf
						
						
						aCols[nX][Len(aHeader)+1] := .F.
					Else
						//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
						//ณUnifica Atualizacao de Precos por Produto                               ณ
						//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
						If ( aHeader[nY][10] != "V")
							If !(alltrim(aHeader[nY][2]) $ "C8_QUANT/C8_QTSEGUM/C8_TOTAL/C8_VALFRE/C8_DESPESA/C8_SEGURO/C8_VLDESC/C8_XTOTAL")
								aCols[nX][nY] := FieldGet(FieldPos(aHeader[nY][2]))
							Else
								If ( Trim(aHeader[nY][2])=="C8_XTOTAL" )
									aCols[nX][nY] := CriaVar(aHeader[nY][2],.T.)
								ElseIf aCols[nX][nY] == Nil
									aCols[nX][nY] := FieldGet(FieldPos(aHeader[nY][2]))
								Else
									If (Trim(aHeader[nY][2])=="C8_QUANT") .Or. (Trim(aHeader[nY][2])=="C8_QTSEGUM")
										If cProduto == SC8->C8_PRODUTO
											aCols[nX][nY] += FieldGet(FieldPos(aHeader[nY][2]))
										EndIf
									EndIf
									If ( Trim(aHeader[nY][2])=="C8_TOTAL" )
										If cProduto == SC8->C8_PRODUTO
											aCols[nX][nY] += FieldGet(FieldPos(aHeader[nY][2]))
										EndIf
									EndIf
									If ( Trim(aHeader[nY][2])=="C8_VALFRE" )
										If cProduto == SC8->C8_PRODUTO
											aCols[nX][nY] += FieldGet(FieldPos(aHeader[nY][2]))
										EndIf
									EndIf
									If ( Trim(aHeader[nY][2])=="C8_DESPESA" )
										If cProduto == SC8->C8_PRODUTO
											aCols[nX][nY] += FieldGet(FieldPos(aHeader[nY][2]))
										EndIf
									EndIf
									If ( Trim(aHeader[nY][2])=="C8_SEGURO" )
										If cProduto == SC8->C8_PRODUTO
											aCols[nX][nY] += FieldGet(FieldPos(aHeader[nY][2]))
										EndIf
									EndIf
									If ( Trim(aHeader[nY][2])=="C8_VLDESC" )
										If cProduto == SC8->C8_PRODUTO
											aCols[nX][nY] += FieldGet(FieldPos(aHeader[nY][2]))
										EndIf
									EndIf
								Endif
							Endif
						Else
							aCols[nX][nY] := CriaVar(aHeader[nY][2],.T.)
						EndIf
						aCols[nX][Len(aHeader)+1] := .F.
					Endif
					
					If Trim(aHeader[nY][02])=="C8_ITEM" .And. l150Inclui
//						aCols[nX][nY] := cItem
//						cItem := Soma1(cItem)
					EndIf
					
					If cPaisLoc <> "BRA"
						If ( Trim(aHeader[nY][2])=="C8_TAXAFIN" )
							aCols[nX][nY] := Iif(Empty(SC8->C8_TAXAFIN),GetMv("MV_JUROS"), SC8->C8_TAXAFIN)
						EndIf
					EndIf
					//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
					//ณPreenche a TES padrao                                                   ณ
					//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
					If ( Trim(aHeader[nY][2])=="C8_TES" .And. lIniTes )
						dbSelectArea("SB1")
						dbSetOrder(1)
						dbSeek(xFilial("SB1")+SC8->C8_PRODUTO,.F.)
						If ( Empty(aCols[nX][nPosTes]) )
							aCols[nX][nPosTes] := RetFldProd(SB1->B1_COD,"B1_TE")
						EndIf
					EndIf
					//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
					//ณEfetua tratamento para uma nova proposta                                ณ
					//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
					If ( nOpc == 2 .Or. nOpc == 4 ) .And. lZeraProp
						If ( Trim(aHeader[nY][02])$"C8_PICM/C8_PRECO/C8_TOTAL/C8_AVISTA/C8_VLDESC/C8_VALFRE/C8_PRAZO/C8_DESPESA/C8_SEGURO/C8_DESC/C8_VALEMB" )
							aCols[nX][nY] := 0
						Else
							If Trim(aHeader[nY][02])=="C8_COND"
								aCols[nX][nY] := ""
							EndIf
							If Trim(aHeader[nY][02])=="C8_CODTAB"
								aCols[nX][nY] := CriaVar(aHeader[nY][2],.T.)
							EndIf
							If Trim(aHeader[nY][02])=="C8_NUMPRO"
								aCols[nX][nY] := FieldGet(FieldPos(aHeader[nY][2])) //CriaVar(aHeader[nY][2],.T.)
							EndIf
						EndIf
					EndIf
					//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
					//ณProvincia de Entrega do Fornecedor                                      ณ
					//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
					If cPaisLoc == "ARG" .And. Trim(aHeader[nY][2])=="C8_PROVENT"
						aCols[nX][nY] := cA150Provent
					EndIf
					//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
					//ณEfetua tratamento para campos prazo e observa็ใo                        ณ
					//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
					If nOpc == 2 .And. AllTrim(aHeader[nY][2])$"C8_PRAZO"
						aCols[nX][nY] := CriaVar(aHeader[nY][2],.T.)
					EndIf
				Next nY
				//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
				//ณ Inicia a Carga do item nas funcoes MATXFIS  ณ
				//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
				MaFisIniLoad(nX)
				For nZ := 1 To Len(aRefImpos)
					If (Trim(aRefImpos[nZ][2]) == "C8_TOTAL") .AND. nOpc == 2
						MaFisLoad(aRefImpos[nZ][3],0,nX)
					Else
						MaFisLoad(aRefImpos[nZ][3],SC8->(FieldGet(FieldPos(aRefImpos[nZ][2]))),nX)
					EndIf
				Next nZ
				MaFisEndLoad(nX,2)
				
				//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
				//ณ Zera valores na MATXFIS  					ณ
				//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
				If ( nOpc == 2 .Or. nOpc == 4 ) .And. lZeraProp
					MaFisAlt("NF_FRETE",0)
					MaFisAlt("NF_DESPESA",0)
					MaFisAlt("NF_SEGURO",0)
					MaFisAlt("NF_DESCONTO",0)
					MaFisAlt("NF_VALEMB",0)
				EndIf
				
				//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
				//ณ Atualiza TES nas rotinas fiscais       ณ
				//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
				If lIniTes .And. nPosTES > 0
					N := nX
					nTotal := IIf(nPosTotal>0,aCols[nX,nPosTotal],0)
					MaFisRef('IT_TES',"MT150",aCols[nX][nPosTES])
					// Protecao para Atualizacao Unificada
					If mv_par06==2 .And. nPosTotal > 0 .And. QtdComp(nTotal) <> QtdComp(aCols[nX,nPosTotal])
						aCols[nX,nPosTotal] := nTotal
					EndIf
				EndIf
			Endif
			
			//				aadd(aSC8,{SC8->C8_PRODUTO,SC8->C8_IDENT})
			aadd(aSC8,{SC8->C8_PRODUTO,SC8->C8_IDENT,SC8->C8_NUMPRO}) // Inserido por Carlos Queiroz em 11/10/16
			
			If lMt150Lin
				N := nX
				ExecBlock("MT150LIN",.F.,.F.,{nOpc})
			Endif
		ElseIf nOpc==3 .And. !Empty(SC8->C8_NUMPED)
			lAnalisada := .T.
		EndIf
		///		EndIf
	EndIf
	cNextPro := If(cNextPro>SC8->C8_NUMPRO,cNextPro,SC8->C8_NUMPRO)
	dbSelectArea("SC8")
	dbSkip()
EndDo

If lDelCotAc .Or. (nOpc == 5 .And. lDelForn)
	
	If ( Len(aCols)==0 )
		lRetorno := .F.
	EndIf
	If ( nOpc == 2 .Or. (nOpc == 4 .And. lReItProp) ) .Or. (mv_par06 == 2) .Or. ( nOpc == 4 )
		lItensG := .F.
		// Caso MV_ReItPro=1(SIM), identifica se ha' itens de grade, anulando neste caso o param. p/ renumerar os itens
		If lGrade .And. nOpc == 4 .And. lReItProp
			For nX := Len(aCols) To 1 Step -1
				nItensG := (aScan(aCols,{|x|x[1] == aCols[nX][1]}))
				If nItensG <> nX
					lItensG := .T.
					Exit
				EndIf
			Next
		EndIf
		For nX := 1 To Len(aCols)
			//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
			//ณAtualiza o Campo Proposta                                               ณ
			//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
			If ( nOpc == 4 )
				aCols[nX][nPNumPro] := Soma1(cNextPro,1)
			Endif
		Next
	Endif
Endif

Return(lRetorno)