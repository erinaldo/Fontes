#INCLUDE "rwmake.ch"
#INCLUDE "TOPCONN.ch"

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณCESTR07   บ Autor ณ Emerson Natali     บ Data ณ  19/09/2007 บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDescricao ณ Relatorio de Analise das Requisicoes de Materiais do       บฑฑ
ฑฑบ          ณ Estoque                                                    บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ CIEE                                                       บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
/*/

User Function CESTR07

Local cDesc1 	:= "Este programa tem como objetivo imprimir relatorio "
Local cDesc2 	:= "de acordo com os parametros informados pelo usuario."
Local cDesc3 	:= "Relatorio de Analise das Requisicoes"
Local titulo 	:= "Relatorio de Analise das Requisicoes"
Local nLin 		:= 80
Local Cabec1 	:= ""
Local Cabec2 	:= ""

Private lAbortPrint := .F.
Private tamanho 	:= "G" //P - 80 colunas ; M - 120 colunas ; G - 220 colunas
Private nTipo 		:= 18
Private aReturn 	:= { "Zebrado", 1, "Administracao", 2, 2, 1, "", 1}
Private nLastKey 	:= 0
Private cPerg 		:= "CEST07    "
Private m_pag 		:= 01
Private nomeprog 	:= "CESTR07"
Private wnrel 		:= "CESTR07"
Private cString		:= "SZN"
Private aOrd 		:= {OemToAnsi("Por Requisi็ใo"),OemToAnsi("Por Produto"),OemToAnsi("Por Centro de Custo")}

dbSelectArea("SZN")
dbSetOrder(1)

/*
ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
ณ Variaveis utilizadas para parametros                                                               ณ
ณ mv_par01				// Periodo de                                                                ณ
ณ mv_par02				// Periodo Ate                                                               ณ
ณ mv_par03				// Requisicao De                                                             ณ
ณ mv_par04				// Requisicao Ate                                                            ณ
ณ mv_par05				// Cr de                                                                     ณ
ณ mv_par06				// Cr Ate                                                                    ณ
ณ mv_par07				// Produto De                                                                ณ
ณ mv_par08				// Produto Ate                                                               ณ
ณ mv_par09				// Status (Aberto/ Processado/ Pendente/ Cancelado/ Ambos)                   ณ
ณ mv_par10				// Localizacao (Sede/ Unidade/ Ambos)/campo CTT_LOCALI (1-Sede, 2-Unidade)   ณ
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

_cQuery	:= "SELECT * "
_cQuery	+= "FROM "+ RetSqlName("SZN")+" SZN, "+ RetSqlName("CTT")+" CTT, "+ RetSqlName("SB1")+" SB1 "
_cQuery += "WHERE SZN.D_E_L_E_T_ <> '*' AND CTT.D_E_L_E_T_ <> '*' AND SB1.D_E_L_E_T_ <> '*'"
_cQuery += "AND SZN.ZN_CR  = CTT.CTT_CUSTO "
_cQuery += "AND SZN.ZN_COD = SB1.B1_COD "
_cQuery += "AND SZN.ZN_DATA   BETWEEN '"+dtos(mv_par01)+"' AND '"+dtos(mv_par02)+"' "
_cQuery += "AND SZN.ZN_NUMSOC BETWEEN '"+mv_par03      +"' AND '"+mv_par04      +"' "
_cQuery += "AND SZN.ZN_CR     BETWEEN '"+mv_par05      +"' AND '"+mv_par06      +"' "
_cQuery += "AND SZN.ZN_COD    BETWEEN '"+mv_par07      +"' AND '"+mv_par08      +"' "
If mv_par09 == 1 //ABERT
	_cQuery += "AND SZN.ZN_STATUS = '' "
ElseIf mv_par09 == 2 //PROCESSADO
	_cQuery += "AND SZN.ZN_STATUS = '1' "
ElseIf mv_par09 == 3 //PENDENTE
	_cQuery += "AND SZN.ZN_STATUS = '2' "
ElseIf mv_par09 == 4 //CANCELADO
	_cQuery += "AND SZN.ZN_STATUS = '3' "
Else //AMBOS
	_cQuery += "AND SZN.ZN_STATUS BETWEEN '' AND 'ZZZZ' "
EndIf
If mv_par10 == 1 //SEDE
	_cQuery += "AND CTT.CTT_LOCALI = '1' "
ElseIf mv_par10 == 2 //UNIDADE
	_cQuery += "AND CTT.CTT_LOCALI = '2' "
Else //AMBOS
	_cQuery += "AND CTT.CTT_LOCALI BETWEEN '' AND 'ZZZZ' "
EndIf
IF nOrdem = 1
	titulo 	:= OemToAnsi("Relatorio de Analise das Requisi็๕es por Requisi็ใo")
	_cQuery += "ORDER BY SZN.ZN_NUMSOC, SZN.ZN_COD, SZN.ZN_DATA, SZN.ZN_CR "
ElseIf nOrdem = 2
	titulo 	:= OemToAnsi("Relatorio de Analise das Requisi็๕es por Produto")
	_cQuery += "ORDER BY SZN.ZN_COD, SZN.ZN_DATA, SZN.ZN_CR "
Else
	titulo 	:= OemToAnsi("Relatorio de Analise das Requisi็๕es por CR")
	_cQuery += "ORDER BY SZN.ZN_CR, SZN.ZN_COD, SZN.ZN_DATA "
EndIf
TCQUERY _cQuery ALIAS "TMP" NEW

TcSetField("TMP","ZN_DATA","D",8, 0 )

dbSelectArea("TMP")
SetRegua(RecCount())
dbGoTop()

_cReq 		:= TMP->ZN_NUMSOC
_cCod 		:= TMP->ZN_COD
_cCC 		:= TMP->ZN_CR
_nQtd 		:= 0
_nTot 		:= 0
_nQtdGer	:= 0 	//Geral
_nTotGer 	:= 0	//Geral

Cabec1 	:= "Status     Nr.Req Cod.            Descricao                                CR    Descr                          Data       Quant Qt.Entr Saldo Qt.Canc Obs"

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
          1         2         3         4         5         6         7         8         9        10        11        12        13        14        15        16        17        18        19
01234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890
Status     Nr.Req Cod.            Descricao                                CR    Descr                          Data       Quant Qt.Entr Saldo Qt.Canc Obs
XXXXXXXXXX XXXXXX XXXXXXXXXXXXXXX XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX XXX   XXXXXXXXXXXXXXXXXXXXXXXXXXXXXX XX/XX/XXXX 99999   99999 99999   99999 XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX
                                                                                                                         ---------------------------
                                                                                                             
*/
	_cChave := ""

	If nOrdem == 1
		_cChave := "_cReq <> TMP->ZN_NUMSOC"
	ElseIf nOrdem == 2
		_cChave := "_cCod <> TMP->ZN_COD"
	Else
		_cChave := "_cCC <> TMP->ZN_CR"
	EndIf

	If &_cChave
		nLin++
		@ nLin, 121+2 PSAY "-----------------------------"
		nLin++
		@ nLin, 121+2 PSAY _nQtd picture "@E 99999"		//Total Quantidade Requisitada
		@ nLin, 129+2 PSAY _nTot picture "@E 99999"		//Total Quantidade Entregue
		nLin++
		@ nLin,000 PSAY __PrtThinLine()
		nLin++
		_cReq 	:= TMP->ZN_NUMSOC
		_cCod 	:= TMP->ZN_COD
		_cCC 	:= TMP->ZN_CR
		_nQtd 	:= 0
		_nTot 	:= 0
	EndIf

	_cStatus := ""
	Do Case
		Case ALLTRIM(TMP->ZN_STATUS) == ""
			_cStatus := "Aberto"
		Case ALLTRIM(TMP->ZN_STATUS) == "1"
			_cStatus := "Processado"
		Case ALLTRIM(TMP->ZN_STATUS) == "2"
			_cStatus := "Pendente"
		Case ALLTRIM(TMP->ZN_STATUS) == "3"
			_cStatus := "Cancelado"
	EndCase

	@ nLin, 000 PSAY _cStatus									//Status
	@ nLin, 011 PSAY TMP->ZN_NUMSOC								//Nr Requisicao
	@ nLin, 018 PSAY alltrim(TMP->ZN_COD)						//Cod Produto
	@ nLin, 034 PSAY SUBSTR(TMP->B1_DESC,1,40)					//Descricao
	@ nLin, 075 PSAY SUBSTR(alltrim(TMP->ZN_CR),1,5)			//Centro de Custo
	@ nLin, 079+2 PSAY SUBSTR(TMP->CTT_DESC01,1,30)				//Descricao
	@ nLin, 110+2 PSAY TMP->ZN_DATA		picture "99/99/9999"	//Data
	@ nLin, 121+2 PSAY TMP->ZN_QUANT		picture "@E 99999"		//Quantidade Requisitada
	@ nLin, 129+2 PSAY TMP->ZN_QTENTRE	picture "@E 99999"		//Quantidade Entregue
	@ nLin, 135+2 PSAY TMP->ZN_SALDO 		picture "@E 99999"		//Saldo
	@ nLin, 143+2 PSAY TMP->ZN_QTRESID 	picture "@E 99999"		//Quantidade Cancelada

	SZN->(dBGoto(TMP->R_E_C_N_O_))
	nLinhas := MlCount( ALLTRIM(SZN->ZN_OBS), 70 ) //Conta o numero de linhas dentro do campo MEMO
	If nLinhas > 0
	    For _nI := 1 to nLinhas
			@ nLin, 151+2 PSAY MemoLine( ALLTRIM(SZN->ZN_OBS), 70, _nI)
			nLin++
		Next
	Else
		nLin++
	EndIf
	_nQtd 		+= TMP->ZN_QUANT
	_nTot 		+= TMP->ZN_QTENTRE
	_nQtdGer	+= TMP->ZN_QUANT
	_nTotGer	+= TMP->ZN_QTENTRE

	TMP->(dbSkip())
EndDo

nLin++
@ nLin, 121+2 PSAY "-----------------------------"
nLin++
@ nLin, 121+2 PSAY _nQtd picture "@E 99999"		//Total Quantidade Requisitada
@ nLin, 129+2 PSAY _nTot picture "@E 99999"		//Total Quantidade Entregue
nLin++
@ nLin,000 PSAY __PrtThinLine()
nLin++
nLin++
@ nLin, 000 PSAY "TOTAL GERAL"
@ nLin, 121+2 PSAY _nQtdGer picture "@E 99999"	//Total Quantidade Requisitada
@ nLin, 129+2 PSAY _nTotGer picture "@E 99999"	//Total Quantidade Entregue

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
             grupo ,ordem ,pergunt             ,perg spa,perg eng , variav ,tipo,tam,dec,pres,gsc,valid,var01     ,def01                 ,defspa01,defeng01,cnt01,var02,def02           ,defspa02,defeng02,cnt02,var03,def03      ,defspa03,defeng03,cnt03,var04,def04           ,defspa04,defeng04,cnt04,var05,def05  ,defspa05,defeng05,cnt05,f3   ,"","","",""
*/
aAdd(aRegs,{cPerg  ,"01" ,"Periodo De        ","      ","       ","mv_ch1","D" ,08 ,00 ,0  ,"G",""   ,"mv_par01",""                    ,""      ,""      ,""   ,""   ,""             ,""      ,""      ,""   ,""   ,""         ,""      ,""     ,""   ,""   ,""              ,""      ,""      ,""   ,""   ,""     ,""      ,""     ,""   ,""   ,"","","",""})
aAdd(aRegs,{cPerg  ,"02" ,"Periodo Ate       ","      ","       ","mv_ch2","D" ,08 ,00 ,0  ,"G",""   ,"mv_par02",""                    ,""      ,""      ,""   ,""   ,""             ,""      ,""      ,""   ,""   ,""         ,""      ,""     ,""   ,""   ,""              ,""      ,""      ,""   ,""   ,""     ,""      ,""     ,""   ,""   ,"","","",""})
aAdd(aRegs,{cPerg  ,"03" ,"Requisicao De     ","      ","       ","mv_ch3","C" ,06 ,00 ,0  ,"G",""   ,"mv_par03",""                    ,""      ,""      ,""   ,""   ,""             ,""      ,""      ,""   ,""   ,""         ,""      ,""     ,""   ,""   ,""              ,""      ,""      ,""   ,""   ,""     ,""      ,""     ,""   ,""   ,"","","",""})
aAdd(aRegs,{cPerg  ,"04" ,"Requisicao Ate    ","      ","       ","mv_ch4","C" ,06 ,00 ,0  ,"G",""   ,"mv_par04",""                    ,""      ,""      ,""   ,""   ,""             ,""      ,""      ,""   ,""   ,""         ,""      ,""     ,""   ,""   ,""              ,""      ,""      ,""   ,""   ,""     ,""      ,""     ,""   ,""   ,"","","",""})
aAdd(aRegs,{cPerg  ,"05" ,"Cr De             ","      ","       ","mv_ch5","C" ,09 ,00 ,0  ,"G",""   ,"mv_par05",""                    ,""      ,""      ,""   ,""   ,""             ,""      ,""      ,""   ,""   ,""         ,""      ,""     ,""   ,""   ,""              ,""      ,""      ,""   ,""   ,""     ,""      ,""     ,""   ,"CTT","","","",""})
aAdd(aRegs,{cPerg  ,"06" ,"Cr Ate            ","      ","       ","mv_ch6","C" ,09 ,00 ,0  ,"G",""   ,"mv_par06",""                    ,""      ,""      ,""   ,""   ,""             ,""      ,""      ,""   ,""   ,""         ,""      ,""     ,""   ,""   ,""              ,""      ,""      ,""   ,""   ,""     ,""      ,""     ,""   ,"CTT","","","",""})
aAdd(aRegs,{cPerg  ,"07" ,"Produto De        ","      ","       ","mv_ch7","C" ,15 ,00 ,0  ,"G",""   ,"mv_par07",""                    ,""      ,""      ,""   ,""   ,""             ,""      ,""      ,""   ,""   ,""         ,""      ,""     ,""   ,""   ,""              ,""      ,""      ,""   ,""   ,""     ,""      ,""     ,""   ,"SB1","","","",""})
aAdd(aRegs,{cPerg  ,"08" ,"Produto Ate       ","      ","       ","mv_ch8","C" ,15 ,00 ,0  ,"G",""   ,"mv_par08",""                    ,""      ,""      ,""   ,""   ,""             ,""      ,""      ,""   ,""   ,""         ,""      ,""     ,""   ,""   ,""              ,""      ,""      ,""   ,""   ,""     ,""      ,""     ,""   ,"SB1","","","",""})
aAdd(aRegs,{cPerg  ,"09" ,"Status            ","      ","       ","mv_ch9","N" ,01 ,00 ,0  ,"C",""   ,"mv_par09","Aberto"              ,""      ,""      ,""   ,""   ,"Processado"   ,""      ,""      ,""   ,""   ,"Pendente" ,""      ,""     ,""   ,""   ,"Cancelado"     ,""      ,""      ,""   ,""   ,"Ambos",""      ,""     ,""   ,""   ,"","","",""})
aAdd(aRegs,{cPerg  ,"10" ,"Localizacao       ","      ","       ","mv_chA","N" ,01 ,00 ,0  ,"C",""   ,"mv_par10","Sede"                ,""      ,""      ,""   ,""   ,"Unidade"      ,""      ,""      ,""   ,""   ,"Ambas"    ,""      ,""     ,""   ,""   ,""              ,""      ,""      ,""   ,""   ,""     ,""      ,""     ,""   ,""   ,"","","",""})

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