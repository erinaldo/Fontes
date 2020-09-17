#INCLUDE "TOTVS.CH"

#DEFINE ENTER CHR(13)+CHR(10)
/*/

{Protheus.doc} CADREGRA
                 
Tela para inclusao de Regiões x tabelas que o vendedor pode trabalhar

@author Milton J.dos Santos
@since 14/07/20
@version 1.0

/*/

//Tela com informacoes ...
///////////////////////////////////////////////////////////////////////////////////////////////////////////////////
User Function CADREGRA()
///////////////////////////////////////////////////////////////////////////////////////////////////////////////////
Local cTitulo		:= "Cadastro do Comissionado"
Local cCodVend		:= SA3->A3_COD
Local cNomVend		:= SA3->A3_NOME
Local aColSizSZA	:= {{"ZA_CODMUN ",25}, {"ZA_TABELA ",10}}
Local aNoFielSZA	:= {"ZA_CODIBGE", "ZA_VEND", "ZA_USER", "ZA_DTINC"}
Local aColSizSZB	:= {{"ZB_DESCOND",348}}
Local aNoFielSZB	:= {"ZB_VEND", "ZB_USER", "ZB_DTINC"}
Local aColSizSZC	:= {{"ZC_COMIS  ",43}, {"ZC_DESGRPR",205}}     
Local aNoFielSZC	:= {"ZC_VEND", "ZC_USER", "ZC_DTINC"}
Local aColSizSZE	:= {{"ZE_OPER   ",50},{"ZE_DESC   ",400}}
Local aNoFielSZE	:= {"ZE_VEND", "ZE_USER", "ZE_DTINC"}
Local nOpc			:= 4
LOCAL nModo			:= IIF(nOpc == 4 .OR. nOpc == 6,GD_INSERT+GD_DELETE+GD_UPDATE,0) 
Local cQuerySZA
Local cQuerySZB
Local cQuerySZC
Local cQuerySZE

Private aHeaderSZA	:= {}
Private aColsSZA	:= {} 
Private aHeaderSZB	:= {}
Private aColsSZB	:= {} 
Private aHeaderSZC	:= {}
Private aColsSZC	:= {} 
Private aHeaderSZE	:= {}
Private aColsSZE	:= {} 

Private oRegioes
Private oCondPag
Private oDescont
Private oOperacoes
Private nLinSel		:= 0	
Private aRegioes  	:= {{Space(10), Space(10), Space(10), Space(10), Space(10), Space(10)}}
Private aCondPag  	:= {{Space(10), Space(10), Space(10), Space(10), Space(10)}}
Private aDescont	:= {{Space(10), Space(10), Space(10), Space(10), Space(10), Space(10), Space(10), Space(10)}}
Private aOperacoes 	:= {{Space(10), Space(10), Space(10), Space(10), Space(10)}}

If SA3->A3_MSBLQL == "1"
    MsgAlert("Vendedor bloqueado !")
    Return
Endif

DEFINE MSDIALOG oDlgMain TITLE cTitulo  OF oMainWnd PIXEL FROM 040,040 TO 390,860
DEFINE FONT oFont1	NAME "Mono AS"	SIZE 10, 18
DEFINE FONT oFont2	NAME "Mono AS"	SIZE 11, 19
DEFINE FONT oBold   NAME "Arial"	SIZE 0, -12 BOLD
DEFINE FONT oBold2  NAME "Arial"	SIZE 0, -40 BOLD

aPasta := { "Cidades","Condicoes de Pagamento","Descontos","Operacoes"}
//              01               02                03           04 

@ 025,005 FOLDER oFolder OF oDlgMain PROMPT aPasta[ 1],aPasta[ 2],aPasta[ 3],aPasta[ 4] PIXEL SIZE 400,130
@ 013,010 SAY "Vendedor:"                           	SIZE 040,10 PIXEL OF oDlgMain FONT oBold 
@ 010,042 MSGET oCodVend   VAR cCodVend	Picture "@!"	SIZE 030,10 PIXEL OF oDlgMain When .F.
@ 010,075 MSGET oNomVend   VAR cNomVend	Picture "@!"	SIZE 150,10 PIXEL OF oDlgMain When .F.

///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
// Pasta  01 - Regioes
///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////        
RegToMemory("SZA",.F.)	
cQuery := "SELECT *, DA0_DESCRI , SZA.R_E_C_N_O_  " 	+ ENTER 
cQuery += "FROM " + RetSQLName("SZA") + " SZA " + ENTER	
cQuery += "INNER JOIN " + RetSQLName("DA0") + " DA0 ON DA0_FILIAL = '"+  xFilial("DA0")+"' AND SZA.ZA_TABELA = DA0.DA0_CODTAB AND DA0.D_E_L_E_T_ <> '*' "  + ENTER
cQuery += "WHERE SZA.ZA_FILIAL = '"+xFilial("SZA") + "'" + " AND SZA.D_E_L_E_T_ <> '*' " + ENTER
cQuery += "AND SZA.ZA_VEND = '" + SA3->A3_COD + "' " + ENTER	
cQuery += "ORDER BY ZA_CODMUN  " + ENTER

cQuerySZA := ChangeQuery(cQuery)

FillGetDados(nOpc,"SZA",1,/*cSeek*/,/*{|| &cWhile }*/,{|| .T. },aNoFielSZA,/*aYesFields*/,/*lOnlyYes*/,cQuerySZA,/*bMontCols*/,/*lEmpty*/,aHeaderSZA,aColsSZA)

oGetSZA:=	MsNewGetDados():New(003,003,295,673,nModo,;
"AllwaysTrue()","AllwaysTrue()","",/*aAlterSZA*/,,999,"AllwaysTrue()",,"AllwaysTrue()",oFolder:aDialogs[1],aHeaderSZA,aColsSZA,,,aColSizSZA)      	
///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
// Pasta  02 - Condicoes de Pagamento
///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
RegToMemory("SZB",.F.)	
cQuery := "SELECT *, " + ENTER 
cQuery += "E4_DESCRI DESCRI, SZB.R_E_C_N_O_ RECNO " + ENTER 
cQuery += "FROM " + RetSQLName("SZB") + " SZB " + ENTER	
cQuery += "INNER JOIN " + RetSQLName("SE4") + " SE4 ON SZB.ZB_COND = SE4.E4_CODIGO AND SE4.D_E_L_E_T_ <> '*' "  + ENTER
cQuery += "WHERE SZB.ZB_FILIAL = '"+xFilial("SZB") + "'" + " AND SZB.D_E_L_E_T_ <> '*' " + ENTER
cQuery += "AND SZB.ZB_VEND = '" + SA3->A3_COD + "' " + ENTER	
cQuery += "ORDER BY ZB_COND " + ENTER

cQuerySZB := ChangeQuery(cQuery)

FillGetDados(nOpc,"SZB",1,/*cSeek*/,/*{|| &cWhile }*/,{|| .T. },aNoFielSZB,/*aYesFields*/,/*lOnlyYes*/,cQuerySZB,/*bMontCols*/,/*lEmpty*/,aHeaderSZB,aColsSZB)
oGetSZB:=	MsNewGetDados():New(003,003,295,673,nModo,;
"AllwaysTrue()","AllwaysTrue()","",/*aAlterSZB*/,,999,"AllwaysTrue()",,"AllwaysTrue()",oFolder:aDialogs[2],aHeaderSZB,aColsSZB,,,aColSizSZB)      	

///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
// Pasta  03 - Descontos
///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
RegToMemory("SZC",.F.)	
cQuery := "SELECT *, " + ENTER 
cQuery += "BM_DESC DESCRI, SZC.R_E_C_N_O_ RECNO " + ENTER 
cQuery += "FROM " + RetSQLName("SZC") + " SZC " + ENTER	
cQuery += "INNER JOIN " + RetSQLName("SBM") + " SBM ON BM_FILIAL = '" + xFilial("SBM")+ "' AND SBM.BM_GRUPO = SZC.ZC_GRPROD AND SBM.D_E_L_E_T_ <> '*' "  + ENTER
cQuery += "WHERE SZC.ZC_FILIAL = '"+xFilial("SZC") + "'" + " AND SZC.D_E_L_E_T_ <> '*' " + ENTER
cQuery += "AND SZC.ZC_VEND = '" + SA3->A3_COD + "' " + ENTER	
cQuery += "ORDER BY ZC_GRPROD " + ENTER

cQuerySZC := ChangeQuery(cQuery)

FillGetDados(nOpc,"SZC",1,/*cSeek*/,/*{|| &cWhile }*/,{|| .T. },aNoFielSZC,/*aYesFields*/,/*lOnlyYes*/,cQuerySZC,/*bMontCols*/,/*lEmpty*/,aHeaderSZC,aColsSZC)
oGetSZC:=	MsNewGetDados():New(003,003,295,673,nModo,;
"AllwaysTrue()","AllwaysTrue()","",/*aAlterSZC*/,,999,"AllwaysTrue()",,"AllwaysTrue()",oFolder:aDialogs[3],aHeaderSZC,aColsSZC,,,aColSizSZC)      	

///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
// Pasta  04 - Operacoes
///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
RegToMemory("SZE",.F.)	
cQuery := "SELECT DISTINCT SZE.*, " + ENTER 
cQuery += "SX5.X5_DESCRI DESCRI, SZE.R_E_C_N_O_ RECNO " + ENTER 
cQuery += "FROM " + RetSQLName("SZE") + " SZE " + ENTER	
cQuery += "INNER JOIN " + RetSQLName("SX5") + " SX5 ON SZE.ZE_OPER = SX5.X5_CHAVE AND SX5.X5_TABELA = 'DJ' AND SX5.D_E_L_E_T_ <> '*' "  + ENTER
cQuery += "WHERE SZE.ZE_FILIAL = '"+xFilial("SZE") + "'" + " AND SZE.D_E_L_E_T_ <> '*' " + ENTER
cQuery += "AND SZE.ZE_VEND = '" + SA3->A3_COD + "' " + ENTER	
cQuery += "ORDER BY SZE.ZE_OPER " + ENTER

cQuerySZE := ChangeQuery(cQuery)

FillGetDados(nOpc,"SZE",1,/*cSeek*/,/*{|| &cWhile }*/,{|| .T. },aNoFielSZE,/*aYesFields*/,/*lOnlyYes*/,cQuerySZE,/*bMontCols*/,/*lEmpty*/,aHeaderSZE,aColsSZE)
oGetSZE:=	MsNewGetDados():New(003,003,295,673,nModo,;
"AllwaysTrue()","AllwaysTrue()","",/*aAlterSZE*/,,999,"AllwaysTrue()",,"AllwaysTrue()",oFolder:aDialogs[4],aHeaderSZE,aColsSZE,,,aColSizSZE)      	

@ 160,343 BUTTON oCancel PROMPT "Cancelar"  ACTION (oDlgMain:End())	SIZE 36,12  PIXEL 
@ 160,380 BUTTON oOk	 PROMPT "OK"        ACTION (IIF(Confirma(),oDlgMain:End(),))	SIZE 26,12 	PIXEL

ACTIVATE MSDIALOG oDlgMain  CENTERED

RETURN
//////////////////////////////////////////////////////////////////////////////////////////////////
Static Function Confirma
//////////////////////////////////////////////////////////////////////////////////////////////////
Local nLinha := 0
Local nPosTab		:= aScan( aHeaderSZA, {|x| Alltrim(x[2]) == "ZA_TABELA"  })
Local nPosCdMun		:= aScan( aHeaderSZA, {|x| Alltrim(x[2]) == "ZA_CODMUN"	})
Local nPosUF		:= aScan( aHeaderSZA, {|x| Alltrim(x[2]) == "ZA_UF"		})
Local nPosRecSZA	:= aScan( aHeaderSZA, {|x| Alltrim(x[2]) == "ZA_REC_WT"	})
Local nPosDelSZA	:= Len(aHeaderSZA) + 1
Local nPosCond		:= aScan( aHeaderSZB, {|x| Alltrim(x[2]) == "ZB_COND"	})
Local nPosRecSZB	:= aScan( aHeaderSZB, {|x| Alltrim(x[2]) == "ZB_REC_WT"	})
Local nPosDelSZB	:= Len(aHeaderSZB) + 1
Local nPosGrPro		:= aScan( aHeaderSZC, {|x| Alltrim(x[2]) == "ZC_GRPROD"	}) 
Local nPosDesMin	:= aScan( aHeaderSZC, {|x| Alltrim(x[2]) == "ZC_DESMIN"	}) 
Local nPosDesMax	:= aScan( aHeaderSZC, {|x| Alltrim(x[2]) == "ZC_DESMAX"	}) 
Local nPosComis		:= aScan( aHeaderSZC, {|x| Alltrim(x[2]) == "ZC_COMIS"	}) 
Local nPosRecSZC	:= aScan( aHeaderSZC, {|x| Alltrim(x[2]) == "ZC_REC_WT"	})
Local nPosDelSZC	:= Len(aHeaderSZC) + 1
Local nPosOper		:= aScan( aHeaderSZE, {|x| Alltrim(x[2]) == "ZE_OPER"	})
Local nPosRecSZE	:= aScan( aHeaderSZE, {|x| Alltrim(x[2]) == "ZE_REC_WT"	})
Local nPosDelSZE	:= Len(aHeaderSZE) + 1

aColsSZA := oGetSZA:aCols // aCols recebe os dados que estao em tela e nao os que vieram da tabela
aColsSZB := oGetSZB:aCols
aColsSZC := oGetSZC:aCols
aColsSZE := oGetSZE:aCols

// Salva as alteracoes/inclusoes na SZA
DbSelectArea("SZA")
SZA->( dbSetOrder(2) )
For nLinha := 1 to Len( aColsSZA )
    If Empty(aColsSZA[ nLinha, nPosTab])
        MsgStop("Campo Tabela é de preenchimento obrigatorio")
        Return .F.
    Endif      
    If Empty(aColsSZA[ nLinha, nPosCdMun])
        MsgStop("Campo Cod.Municipio é de preenchimento obrigatorio")
        Return .F.
    Endif   
    If Empty(aColsSZA[ nLinha, nPosUF])
        MsgStop("Campo Sigla Estado é de preenchimento obrigatorio")
        Return .F.
    Endif
Next
For nLinha := 1 to Len( aColsSZA )
	IF aColsSZA[ nLinha, nPosRecSZA] = 0
		If DbSeek(xFilial("SZA") + SA3->A3_COD + aColsSZA[ nLinha, nPosUF] + aColsSZA[ nLinha, nPosCdMun] + aColsSZA[ nLinha, nPosTab]) // ZA_FILIAL + ZA_VEND + ZA_UF + ZA_CODMUN + ZA_TABELA  
			RECLOCK("SZA",.F.)
		Else
			RECLOCK("SZA",.T.)
			SZA->ZA_FILIAL	:= xFilial("SZA")
			SZA->ZA_VEND	:= SA3->A3_COD
            SZA->ZA_USER    := RetCodUsr()
            SZA->ZA_DTINC   := Date()
		Endif
		SZA->ZA_TABELA	:= aColsSZA[ nLinha, nPosTab] 	
		SZA->ZA_CODMUN	:= aColsSZA[ nLinha, nPosCdMun]	
		SZA->ZA_UF		:= aColsSZA[ nLinha, nPosUF]	
		SZA->( MsUnLock() )
	ELSE
		DBGOTO( aColsSZA[ nLinha, nPosRecSZA] ) 
		RECLOCK("SZA",.F.)
		IF aColsSZA[ nLinha, nPosDelSZA]		// SE FOR PRA APAGAR
			DbDelete()
		Else									//SENAO é ALTERAR
		SZA->ZA_TABELA	:= aColsSZA[ nLinha, nPosTab] 
		SZA->ZA_CODMUN	:= aColsSZA[ nLinha, nPosCdMun]	
		SZA->ZA_UF		:= aColsSZA[ nLinha, nPosUF]	
		ENDIF		
		SZA->( MsUnLock() )
	ENDIF
Next

// Salva as alteracoes/inclusoes na SZB
DbSelectArea("SZB")
SZB->( dbSetOrder(1) )
For nLinha := 1 to Len( aColsSZB )   
    If Empty(aColsSZB[ nLinha, nPosCond])
        MsgStop("Campo Cond.Pgto é de preenchimento obrigatorio")
        Return .F.
    Endif
Next
For nLinha := 1 to Len( aColsSZB )   
	IF aColsSZB[ nLinha, nPosRecSZB] = 0
		If DbSeek(xFilial("SZB") + SA3->A3_COD + aColsSZB[ nLinha, nPosCond]) // ZB_FILIAL+ZB_VEND+ZB_COND  
			RECLOCK("SZB",.F.)
		Else
			RECLOCK("SZB",.T.)
			SZB->ZB_FILIAL	:= xFilial("SZB")
			SZB->ZB_VEND	:= SA3->A3_COD
            SZB->ZB_USER    := RetCodUsr()
            SZB->ZB_DTINC   := Date()
		Endif
		SZB->ZB_COND	:= aColsSZB[ nLinha, nPosCond]
		SZB->( MsUnLock() )
	ELSE
		DBGOTO( aColsSZB[ nLinha, nPosRecSZB] )
		RECLOCK("SZB",.F.)
		IF aColsSZB[ nLinha, nPosDelSZB]		// SE FOR PRA APAGAR
			DbDelete()
		Else									//SENAO é ALTERAR
			SZB->ZB_COND	:= aColsSZB[ nLinha, nPosCond]
		ENDIF		
		SZB->( MsUnLock() )
	ENDIF
Next

// Salva as alteracoes/inclusoes na SZC
DbSelectArea("SZC")
SZC->( dbSetOrder(1) )
For nLinha := 1 to Len( aColsSZC )  
    If Empty(aColsSZC[ nLinha, nPosGrPro])
        MsgStop("Campo Grupo Prod. é de preenchimento obrigatorio")
        Return .F.
    Endif
Next
For nLinha := 1 to Len( aColsSZC )  
	IF aColsSZC[ nLinha, nPosRecSZC] = 0
		If DbSeek(xFilial("SZC") + SA3->A3_COD + aColsSZC[ nLinha, nPosGrPro]) //ZC_FILIAL+ZC_VEND+ZC_GRPROD
			RECLOCK("SZC",.F.)
		Else
			RECLOCK("SZC",.T.)
			SZC->ZC_FILIAL	:= xFilial("SZC")
			SZC->ZC_VEND	:= SA3->A3_COD
            SZC->ZC_USER    := RetCodUsr()
            SZC->ZC_DTINC   := Date()
		Endif
		SZC->ZC_GRPROD	:= aColsSZC[ nLinha, nPosGrPro] 
		SZC->ZC_DESMIN	:= aColsSZC[ nLinha, nPosDesMin] 
		SZC->ZC_DESMAX	:= aColsSZC[ nLinha, nPosDesMax] 
		SZC->ZC_COMIS	:= aColsSZC[ nLinha, nPosComis] 
		SZC->( MsUnLock() )
	ELSE
		DBGOTO( aColsSZC[ nLinha, nPosRecSZC] )
		RECLOCK("SZC",.F.)
		IF aColsSZC[ nLinha, nPosDelSZC]		// SE FOR PRA APAGAR
			DbDelete()
		Else									// SENAO é ALTERAR
			SZC->ZC_GRPROD	:= aColsSZC[ nLinha, nPosGrPro] 
			SZC->ZC_DESMIN	:= aColsSZC[ nLinha, nPosDesMin] 
			SZC->ZC_DESMAX	:= aColsSZC[ nLinha, nPosDesMax] 
			SZC->ZC_COMIS	:= aColsSZC[ nLinha, nPosComis] 
		ENDIF		
		SZC->( MsUnLock() )
	ENDIF
Next

// Salva as alteracoes/inclusoes na SZE
DbSelectArea("SZE")
SZE->( dbSetOrder(1) )
For nLinha := 1 to Len( aColsSZE )   
    If Empty(aColsSZE[ nLinha, nPosOper])
        MsgStop("Campo Operação é de preenchimento obrigatorio")
        Return .F.
    Endif
Next
For nLinha := 1 to Len( aColsSZE )   
	IF aColsSZE[ nLinha, nPosRecSZE] = 0
		If DbSeek(xFilial("SZE") + SA3->A3_COD + aColsSZE[ nLinha, nPosOper]) // ZE_FILIAL+ZE_VEND+ZE_OPER  
			RECLOCK("SZE",.F.)
		Else
			RECLOCK("SZE",.T.)
			SZE->ZE_FILIAL	:= xFilial("SZE")
			SZE->ZE_VEND	:= SA3->A3_COD
            SZE->ZE_USER    := RetCodUsr()
            SZE->ZE_DTINC   := Date()
		Endif
		SZE->ZE_OPER	:= aColsSZE[ nLinha, nPosOper]
		SZE->( MsUnLock() )
	ELSE
		DBGOTO( aColsSZE[ nLinha, nPosRecSZE] )
		RECLOCK("SZE",.F.)
		IF aColsSZE[ nLinha, nPosDelSZE]		// SE FOR PRA APAGAR
			DbDelete()
		Else									//SENAO é ALTERAR
			SZE->ZE_OPER	:= aColsSZE[ nLinha, nPosOper]
		ENDIF		
		SZE->( MsUnLock() )
	ENDIF
Next

Return .T.
