#INCLUDE "rwmake.ch"
//---------------------------------------------------------------------------------------
/*/{Protheus.doc} CESTR05
Relatorio para verificar os produtos que estใo divergentes do Kardex e o Saldo Atual 
@author     Totvs
@since     	01/01/2015
@version  	P.11      
@param 		Nenhum
@return    	Nenhum
@obs        Nenhum
Altera็๕es Realizadas desde a Estrutura็ใo Inicial
------------+-----------------+----------------------------------------------------------
Data       	|Desenvolvedor    |Motivo                                                                                                                 
------------+-----------------+----------------------------------------------------------
		  	|				  | 
------------+-----------------+----------------------------------------------------------
/*/
//---------------------------------------------------------------------------------------
User Function CESTR05()

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
Private cPerg       := "CESTR05"
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


//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
//ณ Monta a interface padrao com o usuario...                           ณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู

wnrel := SetPrint(cString,NomeProg,cPerg,@titulo,cDesc1,cDesc2,cDesc3,.T.,aOrd,.T.,Tamanho,,.T.)

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
/*
ÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออปฑฑ
ฑฑบPrograma  ณ RUNREPORT  บAutor  ณ Totvs       	   บ Data ณ01/01/2015 บฑฑ
ฑฑฬออออออออออุออออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออนฑฑ
ฑฑบDescrio ณ Funcao auxiliar chamada pela RPTSTATUS. A funcao RPTSTATUS บฑฑ
ฑฑบ          ณ monta a janela com a regua de processamento.               บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ CIEE                                                       บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛ
*/
Static Function RunReport(Cabec1,Cabec2,Titulo,nLin)


dbSelectArea("TRT")


//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
//ณ SETREGUA -> Indica quantos registros serao processados para a regua ณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู

SetRegua(RecCount())

//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
//ณ Posicionamento do primeiro registro e loop principal. Pode-se criar ณ
//ณ a logica da seguinte maneira: Posiciona-se na filial corrente e pro ณ
//ณ cessa enquanto a filial do registro for a filial corrente. Por exem ณ
//ณ plo, substitua o dbGoTop() e o While !EOF() abaixo pela sintaxe:    ณ
//ณ                                                                     ณ
//ณ dbSeek(xFilial())                                                   ณ
//ณ While !EOF() .And. xFilial() == A1_FILIAL                           ณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู

//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
//ณ O tratamento dos parametros deve ser feito dentro da logica do seu  ณ
//ณ relatorio. Geralmente a chave principal e a filial (isto vale prin- ณ
//ณ cipalmente se o arquivo for um arquivo padrao). Posiciona-se o pri- ณ
//ณ meiro registro pela filial + pela chave secundaria (codigo por exem ณ
//ณ plo), e processa enquanto estes valores estiverem dentro dos parame ณ
//ณ tros definidos. Suponha por exemplo o uso de dois parametros:       ณ
//ณ mv_par01 -> Indica o codigo final a processar                       ณ
//ณ                                                                     ณ
//ณ dbSeek(xFilial()+mv_par01,.T.) // Posiciona no 1o.reg. satisfatorio ณ
//ณ While !EOF() .And. xFilial() == A1_FILIAL .And. A1_COD <= mv_par02  ณ
//ณ                                                                     ณ
//ณ Assim o processamento ocorrera enquanto o codigo do registro posicioณ
//ณ nado for menor ou igual ao parametro mv_par02, que indica o codigo  ณ
//ณ limite para o processamento. Caso existam outros parametros a serem ณ
//ณ checados, isto deve ser feito dentro da estrutura de la็o (WHILE):  ณ
//ณ                                                                     ณ
//ณ mv_par01 -> Indica o codigo inicial a processar                     ณ
//ณ mv_par02 -> Indica o codigo final a processar                       ณ
//ณ mv_par03 -> Considera qual estado?                                  ณ
//ณ                                                                     ณ
//ณ dbSeek(xFilial()+mv_par01,.T.) // Posiciona no 1o.reg. satisfatorio ณ
//ณ While !EOF() .And. xFilial() == A1_FILIAL .And. A1_COD <= mv_par02  ณ
//ณ                                                                     ณ
//ณ     If A1_EST <> mv_par03                                           ณ
//ณ         dbSkip()                                                    ณ
//ณ         Loop                                                        ณ
//ณ     Endif                                                           ณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู


DbSelectArea("TRT")
TRT->(dbGoTop())

If RecCount("TRT") == 0
   MsgInfo("Nao Existem Divergencias Entre Kardex e Saldo Atual","Informativo!!")
Endif   


While !TRT->(EOF())
	
	//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
	//ณ Verifica o cancelamento pelo usuario...                             ณ
	//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
	
	If lAbortPrint
		@nLin,00 PSAY "*** CANCELADO PELO OPERADOR ***"
		Exit
	Endif
	
	//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
	//ณ Impressao do cabecalho do relatorio. . .                            ณ
	//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
	
	If nLin > 55 // Salto de Pแgina. Neste caso o formulario tem 55 linhas...
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


//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
//ณ Finaliza a execucao do relatorio...                                 ณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู


If Select("TRT") > 0
   TRT->(DbcloseArea())
EndIf   

If FILE(_cArqTrab)
   fErase(_cArqTrab)
EndIf
  
SET DEVICE TO SCREEN

//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
//ณ Se impressao em disco, chama o gerenciador de impressao...          ณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู

If aReturn[5]==1
	dbCommitAll()
	SET PRINTER TO
	OurSpool(wnrel)
Endif

MS_FLUSH()

Return
/*
ÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออปฑฑ
ฑฑบPrograma  ณ ValidPerg  บAutor  ณ Totvs       	   บ Data ณ01/01/2015 บฑฑ
ฑฑฬออออออออออุออออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออนฑฑ
ฑฑบDescrio ณ Ajusta grupo de pergunstas								  บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ CIEE                                                       บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛ
*/
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
/*
ÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออปฑฑ
ฑฑบPrograma  ณ  CESTSAL   บAutor  ณ Totvs       	   บ Data ณ01/01/2015 บฑฑ
ฑฑฬออออออออออุออออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออนฑฑ
ฑฑบDescrio ณ  														  บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ CIEE                                                       บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛ
*/
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
/*
ÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออปฑฑ
ฑฑบPrograma  ณ  VREGSQL   บAutor  ณ Totvs       	   บ Data ณ01/01/2015 บฑฑ
ฑฑฬออออออออออุออออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออนฑฑ
ฑฑบDescrio ณ  														  บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ CIEE                                                       บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛ
*/
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
