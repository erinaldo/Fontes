#INCLUDE "TOTVS.CH"

#DEFINE ENTER CHR(13)+CHR(10)

/*/

{Protheus.doc} CADPROMO
                 
Tela para inclusao de precos promocionais que o vendedor pode trabalhar

@author  Milton J.dos Santos	
@since   22/07/20
@version 1.0

/*/

//Ponto de entrada inclusao botao dentro do cadastro de Tabelas de Preco

User Function CADPROMO()

Local cTitulo   := "Preco Promocional"
Local cCodTab   := DA0->DA0_CODTAB
Local cNomTab 	:= DA0->DA0_DESCRI
Local cDtIni    := DtoC(DA0->DA0_DATDE)
Local cDtFin    := DtoC(DA0->DA0_DATATE)
Local aColSizSZD := {{"ZD_DESPROD",196},{"ZD_VLRPROM",35},{"ZD_UF     ",20}}
//LOCAL aAlterSZD	:= {"ZA_CODMUN","ZA_TABELA"}
Local aNoFielSZD:= {"ZD_TABELA", "ZD_USER", "ZD_DTINC"}
Local nOpc 		:= 4
LOCAL nModo		:= IIF(nOpc == 4 .OR. nOpc == 6,GD_INSERT+GD_DELETE+GD_UPDATE,0) 
Local cQuerySZD

Private aHeaderSZD	:= {}
Private aColsSZD	:= {} 
Private oPreProm
Private nLinSel		:= 0	
Private aPreProm  	:= {{Space(10), Space(10), Space(10), Space(10), Space(10), Space(10)}}

DEFINE MSDIALOG oDlgMain TITLE cTitulo  OF oMainWnd PIXEL FROM 040,040 TO 390,860
DEFINE FONT oFont1	NAME "Mono AS"	SIZE 10, 18
DEFINE FONT oFont2	NAME "Mono AS"	SIZE 11, 19
DEFINE FONT oBold   NAME "Arial"	SIZE 0, -12 BOLD
DEFINE FONT oBold2  NAME "Arial"	SIZE 0, -40 BOLD

oGroup1:= TGroup():New(025,002,155,411,,oDlgMain,,,.T.)

@ 013,010 SAY "Tabela:"                             	SIZE 040,10 PIXEL OF oDlgMain FONT oBold 
@ 010,034 MSGET oCodTab     VAR cCodTab	Picture "@!"	SIZE 030,10 PIXEL OF oDlgMain When .F.
@ 010,067 MSGET oNomTab     VAR cNomTab	Picture "@!"	SIZE 150,10 PIXEL OF oDlgMain When .F.

@ 013,228 SAY "Dt. Inicial:"                           	SIZE 040,10 PIXEL OF oDlgMain FONT oBold 
@ 010,260 MSGET oDtIni      VAR cDtIni	Picture "@!"	SIZE 037,10 PIXEL OF oDlgMain When .F.
@ 013,306 SAY "Dt. Final:"                           	SIZE 040,10 PIXEL OF oDlgMain FONT oBold 
@ 010,334 MSGET oDtFin      VAR cDtFin	Picture "@!"	SIZE 037,10 PIXEL OF oDlgMain When .F.

///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
// Pasta  01 - Preco Promocional
///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
RegToMemory("SZD",.F.)	
cQuery := "SELECT *, " + ENTER  
cQuery += "SZD.R_E_C_N_O_  " 	+ ENTER 
cQuery += "FROM " + RetSQLName("SZD") + " SZD " + ENTER	
cQuery += "WHERE SZD.ZD_FILIAL = '"+xFilial("SZD") + "'" + " AND SZD.D_E_L_E_T_ <> '*' " + ENTER
cQuery += "AND SZD.ZD_TABELA = '" + DA0->DA0_CODTAB + "' " + ENTER	
cQuery += "ORDER BY ZD_TABELA  " + ENTER

cQuerySZD := ChangeQuery(cQuery)

FillGetDados(nOpc,"SZD",1,/*cSeek*/,/*{|| &cWhile }*/,{|| .T. },aNoFielSZD,/*aYesFields*/,/*lOnlyYes*/,cQuerySZD,/*bMontCols*/,/*lEmpty*/,aHeaderSZD,aColsSZD)

oGetSZD:=	MsNewGetDados():New(026,003,156,673,nModo,;
"AllwaysTrue()","AllwaysTrue()","",/*aAlterSZD*/,,999,"AllwaysTrue()",,"AllwaysTrue()",oGroup1,aHeaderSZD,aColsSZD,,,aColSizSZD)      	
oGetSZD:oBrowse:LHSCROLL   := .F.

@ 160,343 BUTTON oCancel PROMPT "Cancelar"  ACTION (oDlgMain:End())	SIZE 36,12  PIXEL 
@ 160,380 BUTTON oOk	 PROMPT "OK"        ACTION (IIF(Confirma(),oDlgMain:End(),))	SIZE 26,12 	PIXEL

ACTIVATE MSDIALOG oDlgMain  CENTERED

RETURN
//////////////////////////////////////////////////////////////////////////////////////////////////
Static Function Confirma
//////////////////////////////////////////////////////////////////////////////////////////////////
Local nLinha := 0
Local nPosProd		:= aScan( aHeaderSZD, {|x| Alltrim(x[2]) == "ZD_PRODUTO"})
Local nPosPrPro		:= aScan( aHeaderSZD, {|x| Alltrim(x[2]) == "ZD_VLRPROM"})
Local nPosMoed		:= aScan( aHeaderSZD, {|x| Alltrim(x[2]) == "ZD_MOEDA"	})
Local nPosUF		:= aScan( aHeaderSZD, {|x| Alltrim(x[2]) == "ZD_UF"		})
Local nPosDtVld		:= aScan( aHeaderSZD, {|x| Alltrim(x[2]) == "ZD_DTVLD"	})
Local nPosRecSZD	:= aScan( aHeaderSZD, {|x| Alltrim(x[2]) == "ZD_REC_WT"	})
Local nPosDelSZD	:= Len(aHeaderSZD) + 1

aColsSZD := oGetSZD:aCols // aCols recebe os dados que estao em tela e nao os que vieram da tabela

// Salva as alteracoes/inclusoes na SZD
DbSelectArea("SZD")
SZD->( dbSetOrder(1) )
For nLinha := 1 to Len( aColsSZD )
    If Empty(aColsSZD[ nLinha, nPosProd])
        MsgStop("Campo Cod.Prod. é de preenchimento obrigatorio")
        Return .F.
    Endif        
    If Empty(aColsSZD[ nLinha, nPosPrPro])
        MsgStop("Campo Valor é de preenchimento obrigatorio")
        Return .F.
    Endif    
    If Empty(aColsSZD[ nLinha, nPosUF])
        MsgStop("Campo Sigla UF é de preenchimento obrigatorio")
        Return .F.
    Endif   
    If Empty(aColsSZD[ nLinha, nPosDtVld])
        MsgStop("Campo Dt.Validade é de preenchimento obrigatorio")
        Return .F.
    Endif    
Next 	
For nLinha := 1 to Len( aColsSZD )
	IF aColsSZD[ nLinha, nPosRecSZD] = 0
		If DbSeek(xFilial("SZD") + DA0->DA0_CODTAB + aColsSZD[ nLinha, nPosUF] + aColsSZD[ nLinha, nPosProd] ) // (1) ZD_FILIAL+ZD_TABELA+ZD_UF+ZD_PRODUTO 
			RECLOCK("SZD",.F.)
		Else
			RECLOCK("SZD",.T.)
			SZD->ZD_FILIAL	:= xFilial("SZD")
			SZD->ZD_TABELA	:= DA0->DA0_CODTAB
            SZD->ZD_USER    := RetCodUsr()
            SZD->ZD_DTINC   := Date()
		Endif
		SZD->ZD_PRODUTO	:= aColsSZD[ nLinha, nPosProd]	
		SZD->ZD_VLRPROM	:= aColsSZD[ nLinha, nPosPrPro]	
        SZD->ZD_MOEDA   := aColsSZD[ nLinha, nPosMoed]
		SZD->ZD_UF		:= aColsSZD[ nLinha, nPosUF]	
        SZD->ZD_DTVLD   := aColsSZD[ nLinha, nPosDtVld]
		
		SZD->( MsUnLock() )
	ELSE
		DBGOTO( aColsSZD[ nLinha, nPosRecSZD] ) 
		RECLOCK("SZD",.F.)
		IF aColsSZD[ nLinha, nPosDelSZD]		// SE FOR PRA APAGAR
			DbDelete()
		Else						            //SENAO é ALTERAR
		SZD->ZD_PRODUTO	:= aColsSZD[ nLinha, nPosProd]	
		SZD->ZD_VLRPROM	:= aColsSZD[ nLinha, nPosPrPro]	
        SZD->ZD_MOEDA   := aColsSZD[ nLinha, nPosMoed]
		SZD->ZD_UF		:= aColsSZD[ nLinha, nPosUF]	
        SZD->ZD_DTVLD   := aColsSZD[ nLinha, nPosDtVld]
		ENDIF		
		SZD->( MsUnLock() )
	ENDIF
Next

Return .T.
