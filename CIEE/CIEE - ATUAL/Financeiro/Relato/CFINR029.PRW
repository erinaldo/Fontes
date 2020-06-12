#include "rwmake.ch"
#include "protheus.ch"
#include "TOPCONN.ch"

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³CFINA29   ºAutor  ³Emerson Natali      º Data ³  01/06/09   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ Relatorio de controle das Contas de Consumo em funcao do   º±±
±±º          ³ debito ou nao no mes selecionado                           º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ CIEE                                                       º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

User Function CFINR29()

//³ Declaracao de Variaveis
Local cDesc1 	:= "Este programa tem como objetivo imprimir relatorio "
Local cDesc2 	:= "de acordo com os parametros informados pelo usuario."
Local cDesc3 	:= "Debitos Contas de Consumo"
Local titulo 	:= OemToAnsi("Contas de Consumo - ")
Local nLin 		:= 80
Local Cabec1 	:= "Documento  Prestadora      Telefone  Vencto. Dt Lanc.          Valor  Status"
Local Cabec2 	:= ""

Private lAbortPrint 	:= .F.
Private limite 			:= 132
Private tamanho 		:= "P"
Private nomeprog 		:= "CFINR29"
Private nTipo 			:= 18
Private aReturn 		:= { "Zebrado", 1, "Administracao", 2, 2, 1, "", 1}
Private nLastKey 		:= 0
Private m_pag 			:= 01
Private wnrel 			:= "CFINR29"
Private cString 		:= "SZ6"

Private cPerg			:= "CFIR29    "

dbSelectArea("SZ6")
dbSetOrder(1)

_fCriaSx1()

//³ Monta a interface padrao com o usuario...
wnrel := SetPrint(cString,NomeProg,cPerg,@titulo,cDesc1,cDesc2,cDesc3,.F.,,.F.,Tamanho,,.F.)

Pergunte(cPerg,.F.)

If nLastKey == 27
	Return
Endif

SetDefault(aReturn,cString)

If nLastKey == 27
   Return
Endif

nTipo := If(aReturn[4]==1,15,18)

RptStatus({|| RunReport(Cabec1,Cabec2,Titulo,nLin) },Titulo)
Return

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºFun‡„o    ³RUNREPORT º Autor ³ AP6 IDE            º Data ³  23/03/09   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDescri‡„o ³ Funcao auxiliar chamada pela RPTSTATUS. A funcao RPTSTATUS º±±
±±º          ³ monta a janela com a regua de processamento.               º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ Programa principal                                         º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/

Static Function RunReport(Cabec1,Cabec2,Titulo,nLin)

titulo += "Período " + DTOC(MV_PAR01) + " a " + DTOC(MV_PAR02)+ " "

dbSelectArea(cString)
//dbSetOrder(2) //FILIAL + PRESTADORA + DOCUMENTO + UNIDADE 
//dbSetOrder(3) //FILIAL + UNIDADE + DOCUMENTO 
dbSetOrder(5) //FILIAL + Unidade + Prestadora + Documento
SetRegua(RecCount())
dbGoTop()

_lFirst := .T.
_cUnid	:= alltrim(SZ6->Z6_UNIDADE)

While !EOF()

	IncRegua()
	//³ Verifica o cancelamento pelo usuario...

	If nLin > 58
		Cabec(Titulo,Cabec1,Cabec2,NomeProg,Tamanho,nTipo)
		nLin := 8
	Endif

	If lAbortPrint
		@nLin,00 PSAY "*** CANCELADO PELO OPERADOR ***"
		Exit
	Endif
/*
          1         2         3         4         5         6         7         8         9         10        11        12        13
012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789
Documento  Prestadora      Telefone  Vencto. Dt Lanc.          Valor  Status
XXXXXXXXXX XXXXXXXXXXXXXXX XXXXXXXXX   XX    XX/XX/XX 999,999,999.99  Nao Debitou
*/

	If SZ6->Z6_STATUS == '2' //Inativo
		DbSelectArea("SZ6")
		SZ6->(dbSkip())
	EndIf

	If DTOS(SZ6->Z6_DATAINC) >= DTOS(MV_PAR01) //Valida para nao imprimir movimentos anteriores a data de inclusao
		DbSelectArea("SZ6")
		SZ6->(dbSkip())
	EndIf

	If alltrim(SZ6->Z6_UNIDADE) <> _cUnid
		nLin++
		nLin++
		_lFirst := .T.
		_cUnid := alltrim(SZ6->Z6_UNIDADE)
		@ nLin,000 PSAY __PrtThinLine()
		nLin++
	EndIf

	If _lFirst
		_lFirst := .F.
		@ nLin, 000 PSAY "UNIDADE: "+SZ6->Z6_UNIDADE
//		@ nLin, 037 PSAY "VENCTO : "+SZ6->Z6_VENCTO
//		@ nLin, 055 PSAY "CR     : "+SZ6->Z6_CR
		@ nLin, 037 PSAY "CR     : "+SZ6->Z6_CR
		nLin++
		nLin++
	EndIf

	_cQuery := "SELECT * "
	_cQuery += "FROM "+RetSqlName("SZ5")+ " "
	_cQuery += "WHERE D_E_L_E_T_ = ''"
	_cQuery += "AND Z5_UNIDADE = '"+SZ6->Z6_UNIDADE+"' "
	_cQuery += "AND Z5_DOC = '"+SZ6->Z6_DOC+"' "
	_cQuery += "AND Z5_LANC BETWEEN '"+Dtos(MV_PAR01)+"' AND '"+Dtos(MV_PAR02)+"' "
	_cQuery += "ORDER BY Z5_PRESTA, Z5_DOC, Z5_UNIDADE "
	_cQuery := ChangeQuery(_cQuery)
	dbUseArea(.T.,"TOPCONN",TcGenQry(,,_cQuery),'SZ5TMP',.T.,.T.)

	TcSetField("SZ5TMP","Z5_LANC","D",8, 0 )

	DbGotop()

	If Type(SZ5TMP->Z5_DOC) != "U"
		Do While !EOF()
			If mv_par03 == 1 .or. mv_par03 == 3 //Sim ou Todos
				If nLin > 58
					Cabec(Titulo,Cabec1,Cabec2,NomeProg,Tamanho,nTipo)
					nLin := 8
				Endif
				@ nLin, 000 PSAY SZ5TMP->Z5_DOC
				@ nLin, 011 PSAY SZ5TMP->Z5_PRESTA
				@ nLin, 027 PSAY SZ5TMP->Z5_TEL
				@ nLin, 039 PSAY SZ6->Z6_VENCTO
				@ nLin, 045 PSAY SZ5TMP->Z5_LANC
				@ nLin, 054 PSAY SZ5TMP->Z5_VALOR picture "@E 999,999,999.99"
				@ nLin, 070 PSAY "OK"
				nLin++
			EndIf
			DbSelectArea("SZ5TMP")
			SZ5TMP->(DbSkip())
		EndDo
	Else
		If mv_par03 == 2 .or. mv_par03 == 3 //Nao ou Todos
			If nLin > 58
				Cabec(Titulo,Cabec1,Cabec2,NomeProg,Tamanho,nTipo)
				nLin := 8
			Endif
			@ nLin, 000 PSAY SZ6->Z6_DOC
			@ nLin, 011 PSAY SZ6->Z6_PRESTA
			@ nLin, 027 PSAY SZ6->Z6_TEL
			@ nLin, 039 PSAY SZ6->Z6_VENCTO
			@ nLin, 045 PSAY "  /  /  "
			@ nLin, 054 PSAY 0 picture "@E 999,999,999.99"
			@ nLin, 070 PSAY "NAO DEBITOU"
			nLin++
		EndIf
    EndIf

	DbSelectArea("SZ5TMP")
	SZ5TMP->(DbCloseArea())

	DbSelectArea("SZ6")
	SZ6->(dbSkip())
EndDo

//³ Finaliza a execucao do relatorio...

SET DEVICE TO SCREEN

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Se impressao em disco, chama o gerenciador de impressao...          ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

If aReturn[5]==1
	dbCommitAll()
	SET PRINTER TO
	OurSpool(wnrel)
Endif

MS_FLUSH()

u_CFINR29()

Return

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³CFINA57   ºAutor  ³Microsiga           º Data ³  03/23/09   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³                                                            º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ AP                                                         º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
Static Function _fCriaSx1()

aRegs     := {}
nSX1Order := SX1->(IndexOrd())

SX1->(dbSetOrder(1))

cPerg := Left(cPerg,10)

/*
             grupo ,ordem ,pergunt      ,perg spa ,perg eng , variav ,tipo,tam,dec,pres,gsc,valid ,var01  ,def01       ,defspa01,defeng01,cnt01,var02,def02       ,defspa02,defeng02 ,cnt02 ,var03 ,def03  ,defspa03 ,defeng03 ,cnt03 ,var04 ,def04 ,defspa04 ,defeng04 ,cnt04 ,var05 ,def05 ,defspa05 ,defeng05,cnt05 ,f3       ,"","","",""
*/
aAdd(aRegs,{cPerg,"01"   ,"Data de   ?",""       ,""       ,"mv_ch1","D" ,08 ,0  ,0   ,"G","","mv_par01",""          ,""      ,""      ,""   ,""   ,""          ,""     ,""       ,""    ,""    ,""     ,""       ,""       ,""   ,""    ,""    ,""       ,""       ,""    ,""    ,""    ,""      ,""      ,""    ,""       ,"",""})
aAdd(aRegs,{cPerg,"02"   ,"Data ate  ?",""       ,""       ,"mv_ch2","D" ,08 ,0  ,0   ,"G","","mv_par02",""          ,""      ,""      ,""   ,""   ,""          ,""     ,""       ,""    ,""    ,""     ,""       ,""       ,""   ,""    ,""    ,""       ,""       ,""    ,""    ,""    ,""      ,""      ,""    ,""       ,"",""})
aAdd(aRegs,{cPerg,"03"   ,"Com Movim.?",""       ,""       ,"mv_ch3","C" ,01 ,0  ,0   ,"C","","mv_par03","Sim"       ,""      ,""      ,""   ,""   ,"Nao"       ,""     ,""       ,""    ,""    ,"Todos",""       ,""       ,""   ,""    ,""    ,""       ,""       ,""    ,""    ,""    ,""      ,""      ,""    ,""       ,"",""})

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