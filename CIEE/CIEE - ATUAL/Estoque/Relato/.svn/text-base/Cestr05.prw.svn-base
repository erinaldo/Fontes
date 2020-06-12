#INCLUDE "rwmake.ch"

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³CESTR05   º Autor ³ CLAUDIO BARROS     º Data ³  10/03/05   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDescricao ³ Relatorio para verificar os produtos que estão divergentes º±±
±±º          ³ do Kardex e o Saldo Atual.                                 º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ Especifico CIEE - SIGAEST                                                    º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/

User Function CESTR05()


//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Declaracao de Variaveis                                             ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

Processa({|| _lRet := RuEst02() },"Selecionando Registros...")



Return


Static Function RuEst02()


Local cDesc1         := "Este programa tem como objetivo imprimir relatorio "
Local cDesc2         := "de acordo com os parametros informados pelo usuario."
Local cDesc3         := "Relatorio Comparativo Kardex c/  Saldo Atual"
Local cPict          := ""
Local titulo       := "Relatorio Comparativo Kardex c/  Saldo Atual"
Local nLin         := 80

Local Cabec1       := " Codigo           Descricao                        Local        Kardex          Saldo Atual     Divergecias "
// XXXXXXXXXXXXXXX   XXXXXXXXXXXXXXXXXXXXXXXXXXXXXX  XX           99.999.999,99   99.999.999,99   99.999.999,99
// 12345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890
//          1         2         3         4         5         6         7         8         9         1         1
Local Cabec2       := ""
Local imprime      := .T.
Local aOrd := {}
Local nOrdem
Local _cFL := CHR(13)+CHR(10)
Local _cQuery := " "
Local _aEstrut  := {}
Local _aCampos
Local _nProds
Local _nSaldo
Local _nDive

Private lEnd         := .F.
Private lAbortPrint  := .F.
Private CbTxt        := ""
Private limite           := 132
Private tamanho          := "M"
Private nomeprog         := "CESTR05" // Coloque aqui o nome do programa para impressao no cabecalho
Private nTipo            := 15
Private aReturn          := { "Zebrado", 1, "Administracao", 1, 2, 1, "", 1}
Private nLastKey        := 0
Private cPerg       := "CEST05    "
Private cbtxt      := Space(10)
Private cbcont     := 00
Private CONTFL     := 01
Private m_pag      := 01
Private wnrel      := "CESTR05" // Coloque aqui o nome do arquivo usado para impressao em disco

Private cString := "SB1"


ValidPerg()
_lConf := Pergunte(cPerg,.T.) 

If _lConf == .F.
   Return
EndIf   


dbSelectArea("SB1")
dbSetOrder(1)


// Define a estrutura do arquivo de trabalho.

_aCampos := {;
{"CODIGO"  , "C", 15, 0},;
{"DESCRI" , "C", 40, 0},;
{"ALMOX" , "C", 2, 0},;
{"KARDQTD" , "N", 14, 2},;
{"KARDVALX" , "N", 14, 2},;
{"ATUALQTD" , "N", 14, 2},;
{"ATUALVAL" , "N", 14, 2},;
{"DIVATD"   , "N", 14, 2},;
{"DIVVAL" , "N", 14, 2} }

If Select("TRT") > 0
   TRT->(DbcloseArea())
EndIf   
If Select("TRB") > 0
   TRB->(DbcloseArea())
EndIf   


// Cria o arquivo de trabalho.
_cArqTrab := CriaTrab(_aCampos, .T.)
dbUseArea(.T., "DBFCDX", _cArqTrab, "TRT", .F., .F.)

_cQuery:= " SELECT B1_COD,B1_DESC FROM "+RetSqlName("SB1")+"  "+_cFL
_cQuery+= " WHERE D_E_L_E_T_ <> '*' "+_cFL
_cQuery+= " AND B1_COD BETWEEN '"+MV_PAR02+"' " +_cFL
_cQuery+= " AND '"+MV_PAR03+"' "+_cFL
_cQuery+= " AND B1_TIPO = 'ME' " +_cFL
_cQuery+= " AND B1_FILIAL = '"+xFilial("SB1")+"' " +_cFL
_cQuery+= " ORDER BY B1_FILIAL,B1_COD "+_cFL
_cQuery := ChangeQuery(_cQuery)
dbUseArea(.T.,"TOPCONN",TcGenQry(,,_cQuery),'TRB',.T.,.T.)


DbSelectarea("TRB")
TRB->(dbGoTop())

nCnt := VREGSQL()

ProcRegua(nCnt)

While !TRB->(EOF())
	
	IncProc("Lendo Produto "+TRB->B1_COD)
	
	_nSaldo := CESTSAL(TRB->B1_COD)
	_nProds := {}
	IF LEN(_nSaldo) > 0
		For Ic:=1 to Len(_nSaldo)
		    DbSelectarea("SB2")
			aSalAtu:=CalcEst(_nSaldo[Ic][1],_nSaldo[Ic][2],MV_PAR01+1)
			AADD(_nProds,{_nSaldo[Ic][1],_nSaldo[Ic][2],_nSaldo[Ic][3],_nSaldo[Ic][4],aSalAtu[1],aSalAtu[1]})
			//               1               2                  3            4           5            6
		Next
	ENDIF
	IF LEN(_nProds) > 0
		
		FOR Ix := 1 TO LEN(_nProds)
			IF MV_PAR04 == 1
				_nDive := (_nProds[Ix][5]-_nProds[Ix][3]) 
				IF _nDive <> 0
				    DbSelectArea("TRT")
					RecLock("TRT",.T.)
					TRT->CODIGO   := _nProds[Ix][1]
					TRT->DESCRI   := TRB->B1_DESC
					TRT->ALMOX    := _nProds[Ix][2]
					TRT->KARDQTD  := _nProds[Ix][5]
					TRT->KARDVALX := _nProds[Ix][6]
					TRT->ATUALQTD := _nProds[Ix][3]
					TRT->ATUALVAL := _nProds[Ix][4]
					TRT->DIVATD   := (_nProds[Ix][5]-_nProds[Ix][3])
					//TRT->DIVVAL   := _nProds[Ix][1]
					TRT->(MsUnlock())
				Endif
			Else   
			    DbSelectArea("TRT")
				RecLock("TRT",.T.)
				TRT->CODIGO   := _nProds[Ix][1]
				TRT->DESCRI   := TRB->B1_DESC
				TRT->ALMOX    := _nProds[Ix][2]
				TRT->KARDQTD  := _nProds[Ix][5]
				TRT->KARDVALX := _nProds[Ix][6]
				TRT->ATUALQTD := _nProds[Ix][3]
				TRT->ATUALVAL := _nProds[Ix][4]
				TRT->DIVATD   := (_nProds[Ix][5]-_nProds[Ix][3])
				//TRT->DIVVAL   := _nProds[Ix][1]
				TRT->(MsUnlock())
			Endif
		Next
	Endif    
	DbSelectArea("TRB")
	TRB->(DbSkip())
End


If RecCount("TRT") == 0
   MsgInfo("Nao Existem Divergencias Entre Kardex e Saldo Atual","Informativo!!")
   If Select("TRB") > 0
      TRB->(DbcloseArea())
   EndIf   
   If Select("TRT") > 0
      TRT->(DbcloseArea())
   EndIf   
   If FILE(_cArqTrab)
      fErase(_cArqTrab)
   EndIf
   Return
Endif   


//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Monta a interface padrao com o usuario...                           ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

wnrel := SetPrint(cString,NomeProg,cPerg,@titulo,cDesc1,cDesc2,cDesc3,.T.,aOrd,.T.,Tamanho,,.T.)

If nLastKey == 27
	Return
Endif

SetDefault(aReturn,cString)

If nLastKey == 27
	Return
Endif

nTipo := If(aReturn[4]==1,15,18)





//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Processamento. RPTSTATUS monta janela com a regua de processamento. ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

RptStatus({|| RunReport(Cabec1,Cabec2,Titulo,nLin) },Titulo)
Return

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºFun‡„o    ³RUNREPORT º Autor ³ AP6 IDE            º Data ³  10/03/05   º±±
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


dbSelectArea("TRT")


//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ SETREGUA -> Indica quantos registros serao processados para a regua ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

SetRegua(RecCount())

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Posicionamento do primeiro registro e loop principal. Pode-se criar ³
//³ a logica da seguinte maneira: Posiciona-se na filial corrente e pro ³
//³ cessa enquanto a filial do registro for a filial corrente. Por exem ³
//³ plo, substitua o dbGoTop() e o While !EOF() abaixo pela sintaxe:    ³
//³                                                                     ³
//³ dbSeek(xFilial())                                                   ³
//³ While !EOF() .And. xFilial() == A1_FILIAL                           ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ O tratamento dos parametros deve ser feito dentro da logica do seu  ³
//³ relatorio. Geralmente a chave principal e a filial (isto vale prin- ³
//³ cipalmente se o arquivo for um arquivo padrao). Posiciona-se o pri- ³
//³ meiro registro pela filial + pela chave secundaria (codigo por exem ³
//³ plo), e processa enquanto estes valores estiverem dentro dos parame ³
//³ tros definidos. Suponha por exemplo o uso de dois parametros:       ³
//³ mv_par01 -> Indica o codigo final a processar                       ³
//³                                                                     ³
//³ dbSeek(xFilial()+mv_par01,.T.) // Posiciona no 1o.reg. satisfatorio ³
//³ While !EOF() .And. xFilial() == A1_FILIAL .And. A1_COD <= mv_par02  ³
//³                                                                     ³
//³ Assim o processamento ocorrera enquanto o codigo do registro posicio³
//³ nado for menor ou igual ao parametro mv_par02, que indica o codigo  ³
//³ limite para o processamento. Caso existam outros parametros a serem ³
//³ checados, isto deve ser feito dentro da estrutura de laço (WHILE):  ³
//³                                                                     ³
//³ mv_par01 -> Indica o codigo inicial a processar                     ³
//³ mv_par02 -> Indica o codigo final a processar                       ³
//³ mv_par03 -> Considera qual estado?                                  ³
//³                                                                     ³
//³ dbSeek(xFilial()+mv_par01,.T.) // Posiciona no 1o.reg. satisfatorio ³
//³ While !EOF() .And. xFilial() == A1_FILIAL .And. A1_COD <= mv_par02  ³
//³                                                                     ³
//³     If A1_EST <> mv_par03                                           ³
//³         dbSkip()                                                    ³
//³         Loop                                                        ³
//³     Endif                                                           ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ


DbSelectArea("TRT")
TRT->(dbGoTop())

If RecCount("TRT") == 0
   MsgInfo("Nao Existem Divergencias Entre Kardex e Saldo Atual","Informativo!!")
Endif   


While !TRT->(EOF())
	
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Verifica o cancelamento pelo usuario...                             ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	
	If lAbortPrint
		@nLin,00 PSAY "*** CANCELADO PELO OPERADOR ***"
		Exit
	Endif
	
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Impressao do cabecalho do relatorio. . .                            ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	
	If nLin > 55 // Salto de Página. Neste caso o formulario tem 55 linhas...
		Cabec(Titulo,Cabec1,Cabec2,NomeProg,Tamanho,nTipo)
		nLin := 8
	Endif
	
	// Coloque aqui a logica da impressao do seu programa...
	// Utilize PSAY para saida na impressora. Por exemplo:
	// @nLin,00 PSAY SA1->A1_COD
	// Codigo           Descricao                        Local        Kardex          Saldo Atual     Divergecias "
	// XXXXXXXXXXXXXXX  XXXXXXXXXXXXXXXXXXXXXXXXXXXXXX   XX           99.999.999,99   99.999.999,99   99.999.999,99
	// 12345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890
	//          1         2         3         4         5         6         7         8         9         1         1
	
	@nLin,001 PSAY TRT->CODIGO
	@nLin,018 PSAY SUBS(TRT->DESCRI,1,30)
	@nLin,051 PSAY TRT->ALMOX
	@nLin,064 PSAY TRT->KARDQTD  Picture "@E 99,999,999.99"
	//      @nLin,00 PSAY TRT->KARDVALX
	@nLin,080 PSAY TRT->ATUALQTD Picture "@E 99,999,999.99"
	//      @nLin,00 PSAY TRT->ATUALVAL
	@nLin,096 PSAY TRT->DIVATD   Picture "@E 99,999,999.99"
	nLin := nLin + 1 // Avanca a linha de impressao
	DbSelectArea("TRT")
	TRT->(dbSkip()) // Avanca o ponteiro do registro no arquivo)
EndDo
nLin := nLin + 1 // Avanca a linha de impressao


//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Finaliza a execucao do relatorio...                                 ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ


If Select("TRT") > 0
   TRT->(DbcloseArea())
EndIf   

If FILE(_cArqTrab)
   fErase(_cArqTrab)
EndIf
  
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

Return


Static Function ValidPerg()

Local _sAlias := Alias()
Local aRegs := {}
Local i,j

dbSelectArea("SX1")
dbSetOrder(1)
cPerg := PADR(cPerg,10)

//          Grupo/Ordem/Pergunta             /Variavel/Tipo/Tamanho/Decimal/Presel/GSC/Valid/Var01/Def01/Cnt01/Var02/Def02/Cnt02/Var03/Def03/Cnt03/Var04/Def04/Cnt04/Var05/Def05/Cnt05

aAdd(aRegs,{cPerg,"01","Data Consulta ?","","","mv_ch1","D",8,0,0,"G","","mv_par01","","","","","","","","","","","","","","",""})
aAdd(aRegs,{cPerg,"02","Produto De  ?","","","mv_ch2","C",15,0,0,"G","","mv_par02","","","","","","","","","","","","","","",""})
aAdd(aRegs,{cPerg,"03","Produto Ate ?","","","mv_ch3","C",15,0,0,"G","","mv_par03","","","","","","","","","","","","","","",""})
aAdd(aRegs,{cPerg,"04","So Divergentes ?","","","mv_ch4","C",1,0,0,"C","","mv_par04","Divergentes","","","","","","","","","","","","","",""})




For i:=1 to Len(aRegs)
	If !dbSeek(cPerg+aRegs[i,2])
		RecLock("SX1",.T.)
		For j:=1 to FCount()
			If j <= Len(aRegs[i])
				FieldPut(j,aRegs[i,j])
			Endif
		Next
		MsUnlock()
	Endif
Next

dbSelectArea(_sAlias)

Return


STATIC FUNCTION CESTSAL(pCODIGO)


Local _cFL := CHR(13)+CHR(10)
Local _cQuery := " "
Local _aSaldos := {}
Local _lRetSal

Dbselectarea("SB2")
SB2->(DBGOTOP())

_cQuery:= " SELECT B2_COD,B2_QATU, B2_VATU1, B2_LOCAL FROM "+RetSqlName("SB2")+"  "+_cFL
_cQuery+= " WHERE D_E_L_E_T_ <> '*' AND B2_COD = '"+pCodigo+"' "+_cFL
_cQuery+= " AND B2_FILIAL = '"+xFilial("SB2")+"' " +_cFL
_cQuery := ChangeQuery(_cQuery)
dbUseArea(.T.,"TOPCONN",TcGenQry(,,_cQuery),'TRC',.T.,.T.)

TRC->(DBGOTOP())

While !TRC->(EOF())
	AADD(_aSaldos,{TRC->B2_COD,TRC->B2_LOCAL,TRC->B2_QATU,TRC->B2_VATU1})
	TRC->(DBSKIP())
End

If Select() > 0
	TRC->(DbCloseArea())
EndIf


_lRetSal := _aSaldos


Return(_lRetSal)


Static Function VREGSQL()

Local _cFL := CHR(13)+CHR(10)
Local _cQuery := " "
Local _lRetReg := 0

_cQuery:= " SELECT COUNT(B1_COD) AS REGARQ FROM "+RetSqlName("SB1")+"  "+_cFL
_cQuery+= " WHERE D_E_L_E_T_ <> '*' "+_cFL
_cQuery+= " AND B1_COD BETWEEN '"+MV_PAR02+"' " +_cFL
_cQuery+= " AND '"+MV_PAR03+"' "+_cFL
_cQuery+= " AND B1_TIPO = 'ME' " +_cFL
_cQuery+= " AND B1_FILIAL = '"+xFilial("SB1")+"' " +_cFL
_cQuery := ChangeQuery(_cQuery)
dbUseArea(.T.,"TOPCONN",TcGenQry(,,_cQuery),'TRZ',.T.,.T.)


_lRetReg := TRZ->REGARQ

If SelecT("TRZ") > 0
   TRZ->(DbcloseArea())
EndIf   


Return(_lRetReg)	
