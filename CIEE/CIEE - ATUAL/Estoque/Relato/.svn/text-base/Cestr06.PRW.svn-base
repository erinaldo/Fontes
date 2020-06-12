#INCLUDE "rwmake.ch"
#INCLUDE "TOPCONN.ch"

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณCESTR06   บ Autor ณ Emerson Natali     บ Data ณ  12/09/2007 บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDescricao ณ Relatorio de Consumo das Requisicoes de Materiais do       บฑฑ
ฑฑบ          ณ Estoque                                                    บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ CIEE                                                       บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
/*/

User Function CESTR06

Local cDesc1 	:= "Este programa tem como objetivo imprimir relatorio "
Local cDesc2 	:= "de acordo com os parametros informados pelo usuario."
Local cDesc3 	:= "Relatorio de Consumo"
Local titulo 	:= "Relatorio de Consumo"
Local nLin 		:= 80
Local Cabec1 	:= ""
Local Cabec2 	:= ""

Private lAbortPrint := .F.
Private tamanho 	:= "P" //P - 80 colunas ; M - 120 colunas ; G - 220 colunas
Private nTipo 		:= 18
Private aReturn 	:= { "Zebrado", 1, "Administracao", 2, 2, 1, "", 1}
Private nLastKey 	:= 0
Private cPerg 		:= "CEST06    "
Private m_pag 		:= 01
Private nomeprog 	:= "CESTR06"
Private wnrel 		:= "CESTR06"
Private cString		:= "SD3"
Private aOrd 		:= {OemToAnsi("Por Produto"),OemToAnsi("Por Centro de Custo")}

dbSelectArea("SD3")
dbSetOrder(1)

/*
ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
ณ Variaveis utilizadas para parametros                                                               ณ
ณ mv_par01				// Data de                                                                   ณ
ณ mv_par02				// Data ate                                                                  ณ
ณ mv_par03				// Cr de                                                                     ณ
ณ mv_par04				// Cr Ate                                                                    ณ
ณ mv_par05				// Produto De                                                                ณ
ณ mv_par06				// Produto Ate                                                               ณ
ณ mv_par07				// Localizacao (Sede/ Unidade/ Ambos)/campo CTT_LOCALI (1-Sede, 2-Unidade)   ณ
ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
*/

_fCriaSx1()

//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
//ณ Monta a interface padrao com o usuario...                           ณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู

wnrel := SetPrint(cString,NomeProg,cPerg,@titulo,cDesc1,cDesc2,cDesc3,.F.,aOrd,.F.,Tamanho,,.F.)

pergunte(cPerg,.F.)

If nLastKey == 27
	Return
Endif

SetDefault(aReturn,cString)

If nLastKey == 27
   Return
Endif

nTipo := If(aReturn[4]==1,15,18)

//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
//ณ Processamento. RPTSTATUS monta janela com a regua de processamento. ณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู

RptStatus({|| RunReport(Cabec1,Cabec2,Titulo,nLin) },Titulo)

Return

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบFuno    ณRUNREPORT บ Autor ณ AP6 IDE            บ Data ณ  12/09/07   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDescrio ณ Funcao auxiliar chamada pela RPTSTATUS. A funcao RPTSTATUS บฑฑ
ฑฑบ          ณ monta a janela com a regua de processamento.               บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ Programa principal                                         บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
/*/

Static Function RunReport(Cabec1,Cabec2,Titulo,nLin)

nOrdem := aReturn[8]

_cQuery	:= "SELECT D3_DOC, D3_COD, D3_EMISSAO, D3_QUANT, D3_CUSTO1, D3_CC, CTT_DESC01, CTT_LOCALI, B1_DESC "
_cQuery	+= "FROM "+ RetSqlName("SD3")+" SD3, "+ RetSqlName("CTT")+" CTT, "+ RetSqlName("SB1")+" SB1 "
_cQuery += "WHERE SD3.D_E_L_E_T_ <> '*' AND CTT.D_E_L_E_T_ <> '*' AND SB1.D_E_L_E_T_ <> '*'"
_cQuery += "AND SD3.D3_CC = CTT.CTT_CUSTO "
_cQuery += "AND SD3.D3_COD = SB1.B1_COD "
_cQuery += "AND SD3.D3_EMISSAO BETWEEN '"+dtos(mv_par01)+"' AND '"+dtos(mv_par02)+"' "
_cQuery += "AND SD3.D3_CC      BETWEEN '"+mv_par03      +"' AND '"+mv_par04      +"' "
_cQuery += "AND SD3.D3_COD     BETWEEN '"+mv_par05      +"' AND '"+mv_par06      +"' "
_cQuery += "AND SD3.D3_ESTORNO = '' "
_cQuery += "AND SD3.D3_TM >= '501' "
If mv_par07 == 1 //SEDE
	_cQuery += "AND CTT.CTT_LOCALI = '1' "
ElseIf mv_par07 == 2 //UNIDADE
	_cQuery += "AND CTT.CTT_LOCALI = '2' "
Else //AMBOS
	_cQuery += "AND CTT.CTT_LOCALI BETWEEN '' AND 'ZZZZ' "
EndIf
IF nOrdem = 1
	titulo 	:= "Relatorio de Consumo por Produto"
	_cQuery += "ORDER BY SD3.D3_COD, SD3.D3_DOC, SD3.D3_EMISSAO "
Else
	titulo 	:= "Relatorio de Consumo por CR"
	_cQuery += "ORDER BY SD3.D3_CC, SD3.D3_DOC, SD3.D3_EMISSAO "
EndIf
TCQUERY _cQuery ALIAS "TMP" NEW

TcSetField("TMP","D3_EMISSAO","D",8, 0 )

dbSelectArea("TMP")
SetRegua(RecCount())
dbGoTop()

_cCod 		:= TMP->D3_COD
_cCC 		:= TMP->D3_CC
_nQtd 		:= 0
_nTot 		:= 0
_lFirst 	:= .T.
_nQtdGer	:= 0 	//Geral
_nTotGer 	:= 0	//Geral

If nOrdem == 1
	Cabec1 	:= "Documento  Emissao        Qtde      Custo CC    Desc.CC"
Else
	Cabec1 	:= "Documento  Emissao        Qtde      Custo Produto    Desc.Produto"
EndIf

While !EOF()

	IncRegua()
	
	If lAbortPrint
		@nLin,00 PSAY "*** CANCELADO PELO OPERADOR ***"
		Exit
	Endif

	If nLin > 58
		Cabec(Titulo,Cabec1,Cabec2,NomeProg,Tamanho,nTipo)
		nLin := 8
	Endif

/*
          1         2         3         4         5         6         7         8         9        10        11        12
0123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890
Documento  Emissao        Qtde      Custo CC    Desc.CC
XXXXXX     XX/XX/XX       9999   9,999.99 XXXXX XXXXXXXXXXXXXXXXXXXX

Documento  Emissao        Qtde      Custo Produto    Desc.Produto
XXXXXX     XX/XX/XX       9999   9,999.99 XXXXXXXXXX XXXXXXXXXXXXXXXXXXXX
                   -----------------------
*/
	
	If iif(nOrdem == 1, _cCod <> TMP->D3_COD, _cCC <> TMP->D3_CC)
		nLin++
		@ nLin, 019 PSAY "-----------------------"
		nLin++
		@ nLin, 026 PSAY _nQtd picture "@E 9999" 			//Total Quantidade Requisitada
		@ nLin, 031 PSAY _nTot picture "@E 9,999.99"		//Total Custo Total
		nLin++
		@ nLin,000 PSAY __PrtThinLine()
		nLin++
		_cCod 	:= TMP->D3_COD
		_cCC 	:= TMP->D3_CC
		_nQtd 	:= 0
		_nTot 	:= 0
		_lFirst := .T.
	EndIf

	If _lFirst
		_lFirst := .F.
		If nOrdem == 1
			@ nLin, 000 PSAY "Produto: "+ alltrim(TMP->D3_COD) + " - " + SUBSTR(TMP->B1_DESC,1,30)
		Else
			@ nLin, 000 PSAY "CR: "+ alltrim(TMP->D3_CC) + " - " + SUBSTR(TMP->CTT_DESC01,1,30)
		EndIf
		nLin++
		nLin++
	EndIf

	@ nLin, 000 PSAY TMP->D3_DOC								//Documento
	@ nLin, 011 PSAY TMP->D3_EMISSAO							//Emissao
	@ nLin, 026 PSAY TMP->D3_QUANT  picture "@E 9999"			//Quantidade Requisitada
	@ nLin, 031 PSAY TMP->D3_CUSTO1 picture "@E 9,999.99"		//Custo Total
	If nOrdem == 1
		@ nLin, 042 PSAY SUBSTR(ALLTRIM(TMP->D3_CC),1,5)			//Cod Centro de Custo
		@ nLin, 048 PSAY TMP->CTT_DESC01							//Descricao Centro de Custo
	Else
		@ nLin, 042 PSAY SUBSTR(ALLTRIM(TMP->D3_COD),1,10)			//Cod Produto
		@ nLin, 053 PSAY SUBSTR(TMP->B1_DESC,1,30)					//Descricao Produto
	EndIf
	_nQtd 		+= TMP->D3_QUANT
	_nTot 		+= TMP->D3_CUSTO1
	_nQtdGer	+= TMP->D3_QUANT
	_nTotGer	+= TMP->D3_CUSTO1
	nLin++

	TMP->(dbSkip())
EndDo

nLin++
@ nLin, 019 PSAY "-----------------------"
nLin++
@ nLin, 026 PSAY _nQtd picture "@E 9999"	  		//Total Quantidade Requisitada
@ nLin, 031 PSAY _nTot picture "@E 9,999.99"		//Total Custo Total
nLin++
@ nLin,000 PSAY __PrtThinLine()
nLin++
nLin++
@ nLin, 000 PSAY "TOTAL GERAL"
@ nLin, 026 PSAY _nQtdGer picture "@E 9999"			//Total Quantidade Requisitada
@ nLin, 031 PSAY _nTotGer picture "@E 9,999.99"		//Total Custo Total

DbSelectArea("TMP")
DbCloseArea()

SET DEVICE TO SCREEN

If aReturn[5]==1
   dbCommitAll()
   SET PRINTER TO
   OurSpool(wnrel)
Endif

MS_FLUSH()

Return
/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณSX1       บAutor  ณMicrosiga           บ Data ณ  08/03/06   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ Parametros da rotina                                       บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ AP                                                         บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

Static Function _fCriaSX1()

aRegs     := {}
nSX1Order := SX1->(IndexOrd())

SX1->(dbSetOrder(1))

cPerg := Left(cPerg,10)

/*
             grupo ,ordem ,pergunt             ,perg spa,perg eng , variav ,tipo,tam,dec,pres,gsc,valid,var01     ,def01                 ,defspa01,defeng01,cnt01,var02,def02           ,defspa02,defeng02,cnt02,var03,def03    ,defspa03,defeng03,cnt03,var04,def04           ,defspa04,defeng04,cnt04,var05,def05  ,defspa05,defeng05,cnt05,f3   ,"","","",""
*/
aAdd(aRegs,{cPerg  ,"01" ,"Data De           ","      ","       ","mv_ch1","D" ,08 ,00 ,0  ,"G",""   ,"mv_par01",""                    ,""      ,""      ,""   ,""   ,""             ,""      ,""      ,""   ,""   ,""       ,""      ,""     ,""   ,""   ,""              ,""      ,""      ,""   ,""   ,""     ,""      ,""     ,""   ,""   ,"","","",""})
aAdd(aRegs,{cPerg  ,"02" ,"Data Ate          ","      ","       ","mv_ch2","D" ,08 ,00 ,0  ,"G",""   ,"mv_par02",""                    ,""      ,""      ,""   ,""   ,""             ,""      ,""      ,""   ,""   ,""       ,""      ,""     ,""   ,""   ,""              ,""      ,""      ,""   ,""   ,""     ,""      ,""     ,""   ,""   ,"","","",""})
aAdd(aRegs,{cPerg  ,"03" ,"Cr De             ","      ","       ","mv_ch3","C" ,09 ,00 ,0  ,"G",""   ,"mv_par03",""                    ,""      ,""      ,""   ,""   ,""             ,""      ,""      ,""   ,""   ,""       ,""      ,""     ,""   ,""   ,""              ,""      ,""      ,""   ,""   ,""     ,""      ,""     ,""   ,"CTT","","","",""})
aAdd(aRegs,{cPerg  ,"04" ,"Cr Ate            ","      ","       ","mv_ch4","C" ,09 ,00 ,0  ,"G",""   ,"mv_par04",""                    ,""      ,""      ,""   ,""   ,""             ,""      ,""      ,""   ,""   ,""       ,""      ,""     ,""   ,""   ,""              ,""      ,""      ,""   ,""   ,""     ,""      ,""     ,""   ,"CTT","","","",""})
aAdd(aRegs,{cPerg  ,"05" ,"Produto De        ","      ","       ","mv_ch5","C" ,15 ,00 ,0  ,"G",""   ,"mv_par05",""                    ,""      ,""      ,""   ,""   ,""             ,""      ,""      ,""   ,""   ,""       ,""      ,""     ,""   ,""   ,""              ,""      ,""      ,""   ,""   ,""     ,""      ,""     ,""   ,"SB1","","","",""})
aAdd(aRegs,{cPerg  ,"06" ,"Produto Ate       ","      ","       ","mv_ch6","C" ,15 ,00 ,0  ,"G",""   ,"mv_par06",""                    ,""      ,""      ,""   ,""   ,""             ,""      ,""      ,""   ,""   ,""       ,""      ,""     ,""   ,""   ,""              ,""      ,""      ,""   ,""   ,""     ,""      ,""     ,""   ,"SB1","","","",""})
aAdd(aRegs,{cPerg  ,"07" ,"Localizacao       ","      ","       ","mv_ch7","N" ,01 ,00 ,0  ,"C",""   ,"mv_par07","Sede"                ,""      ,""      ,""   ,""   ,"Unidade"      ,""      ,""      ,""   ,""   ,"Ambas"  ,""      ,""     ,""   ,""   ,""              ,""      ,""      ,""   ,""   ,""     ,""      ,""     ,""   ,""   ,"","","",""})

For nX := 1 to Len(aRegs)
	If !SX1->(dbSeek(cPerg+aRegs[nX,2]))
		RecLock('SX1',.T.)
		For nY:=1 to FCount()
			If nY <= Len(aRegs[nX])
				SX1->(FieldPut(nY,aRegs[nX,nY]))
			Endif
		Next nY
		MsUnlock()
	Endif
Next nX

SX1->(dbSetOrder(nSX1Order))

Return