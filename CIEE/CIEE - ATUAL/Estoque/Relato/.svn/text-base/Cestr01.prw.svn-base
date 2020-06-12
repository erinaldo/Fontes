#INCLUDE "rwmake.ch"
#INCLUDE "TOPCONN.ch"
#INCLUDE "AP5MAIL.ch"
/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³Cestr01   º Autor ³ Felipe Raposo      º Data ³  30/09/02   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDescricao ³ Programa de emissao de romaneio.                           º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ CIEE.                                                      º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±ºData      ³ ATUALIZAÇÕES                                               º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±º29/04/2013³ Gravação do flag de geração de Pedido de Vendas foi altera-º±±
±±º          ³ do para o campo D3_XGEROPV - Daniel G.Jr.                  º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
User Function Cestr01()

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Declaracao de Variaveis                                             ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
Local cDesc1	 := "Este programa tem como objetivo imprimir o romaneio"
Local cDesc2	 := "de acordo com os parâmetros informados pelo usuário."
Local cDesc3	 := "Romaneio Geral"
Local cPict		 := ""
Local titulo	 := "Romaneio Geral"
Local nLin		 := 80
Local Cabec1	 := "Docto. Material                            Quantidade        Peso          Valor"
Local Cabec2	 := "                                            fornecida                       (R$)"
********		 := "999999 xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx 99999999,99 999999,9999 999.999.999,99"
********		 := "01234567890123456789012345678901234567890123456789012345678901234567890123456789"
********		 := "0         1         2         3         4         5         6         7         "
Local imprime	 := .T.
Local aOrd		 := {}
Local _aSX1

Private lEnd        := .F.
Private lAbortPrint := .F.
Private CbTxt       := ""
Private limite      := 80
Private tamanho     := "P"
Private nomeprog    := "CESTR01"
Private nTipo       := 15
Private aReturn     := {"Zebrado", 1, "Administracao", 1, 2, 1, "", 1}
Private nTipo       := IIf(aReturn[4] == 1, 15, 18)
Private nLastKey    := 0
Private cbtxt       := Space(10)
Private cbcont      := 00
Private CONTFL      := 01
Private m_pag       := 01
Private wnrel       := nomeprog
Private cString     := "SD3"
Private _cLocal		:= ""

Private _aPV		:= {}
Private _aD3		:= {}
Private lMsErroAuto := .f.
Private cNumPed
Private _nCusto

Private _aErroPV	:= {}
// O bloco de comandos abaixo atualiza a tabela SX1 antes de abrir
// a caixa de perguntas (parametros) ao usuario.
cPerg := "CSTR01    "

_fCriaSX1()

// Atualiza o campo data de referencia (mv_par03)
// para a daba base do sistema (dDataBase).
SX1->(dbSetOrder(1)); SX1->(dbSeek(cPerg + "03"))
RecLock("SX1", .F.)
SX1->X1_CNT01 := "'" + dtoc(dDataBase) + "'"
SX1->(msUnLock())

// Se o usuario nao confirmar, nao processar.
If Pergunte(cPerg, .T.)
	
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Monta a interface padrao com o usuario...                           ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	wnrel := SetPrint(cString,NomeProg,cPerg,@titulo,cDesc1,cDesc2,cDesc3,.F.,aOrd,.T.,Tamanho,,.T.)
	If nLastKey == 27
		Return
	Endif
	SetDefault(aReturn,cString)
	If nLastKey == 27
		Return
	Endif
	
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Impressao do romaneio.                                              ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	RunReport(Cabec1,Cabec2,Titulo,nLin)
Endif

Return

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºFun‡„o    ³RUNREPORT º Autor ³ AP6 IDE            º Data ³  30/09/02   º±±
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

Local _cAlias, _aAreaB1, _aAreaCTT, _cFiltro
Private _nTotPeso, _nTotVal

_aAreaB1  := SB1->(GetArea())
_aAreaCTT := CTT->(GetArea())
_aAreaD3  := SD3->(GetArea())
_cFiltro  := "(D3_EMISSAO == mv_par03 .and. empty(D3_ESTORNO))" // +;
IIf (empty(aReturn[7]), "", " .and. (" + aReturn[7] + ")")

SB1->(dbSetOrder(1))
CTT->(dbSetOrder(1))
SD3->(dbSetOrder(2))

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Processamento. RPTSTATUS monta janela com a regua de processamento. ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
RptStatus({|| ImpRomaneio(Cabec1,Cabec2,Titulo,nLin,_cFiltro)},Titulo)

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Finaliza a execucao do relatorio...                                 ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
Set Device To Screen
SB1->(RestArea(_aAreaB1))
CTT->(RestArea(_aAreaCTT))
SD3->(RestArea(_aAreaD3))

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

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³CESTR01   ºAutor  ³Felipe Raposo       º Data ³  10/03/03   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ Imprime o romaneio. Funcao especifica para auxiliar a mon- º±±
±±º          ³ tagem da regua de progressao.                              º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ CIEE.                                                      º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
Static Function ImpRomaneio(Cabec1,Cabec2,Titulo,nLin,cFiltro)

Local _cCusto, _nAux1, _cFiltro, _aAreaCTT
Local cDirect    := Iif(cEmpAnt=="01","\arq_txt\almoxarifado\LogRomaneio\","\arq_txtrj\almoxarifado\LogRomaneio\")
Private _cAlias

_cAlias   := Alias()
_aAreaCTT := CTT->(GetArea())

cQuery := "SELECT CTT_CUSTO, CTT_DESC01, CTT_LOCALI, CTT_CODCLI, CTT_LOJCLI, CTT_CODTRA, "
cQuery +=        "D3_DOC, D3_COD, D3_CC, D3_CF, D3_QUANT, D3_CUSTO1, D3_EMISSAO, D3_ESTORNO, D3_XUSERLG, SD3.R_E_C_N_O_ SD3REC "
cQuery +=   "FROM "+RetSqlName("CTT")+" CTT, "
cQuery +=         RetSqlName("SD3")+" SD3 "
cQuery +=  "WHERE CTT_FILIAL='"+xFilial("CTT")+"' "
cQuery +=    "AND CTT_CUSTO BETWEEN '"+mv_par01+"' AND '"+mv_par02+"' "
If mv_par05<>3			// 1=sede; 2=unidade; 3=ambas
	cQuery +=    "AND CTT_LOCALI='"+Iif(mv_par05==1,"1","2")+"' "
EndIf                                   
cQuery +=    "AND CTT.D_E_L_E_T_='' "
cQuery +=    "AND D3_FILIAL='"+xFilial("SD3")+"' "
cQuery +=    "AND D3_CC = CTT_CUSTO "
cQuery +=    "AND D3_EMISSAO = '"+DtoS(mv_par03)+"' "
cQuery +=    "AND D3_ESTORNO = '' "
If mv_par06==1			// 1=gera PV; 2=não gera PV
/*
	cQuery +="AND D3_DOC NOT IN (SELECT C6_XDOC "
	cQuery +=                     "FROM "+RetSqlName("SC6")+" SC6"
	cQuery +=                    "WHERE C6_XDOC = SD3.D3_DOC "
	cQuery +=                      "AND SC6.D_E_L_E_T_='') "
*/
//	cQuery +="AND D3_OP <> 'S' "				// retirado em 29/04/2013
	cQuery +="AND D3_XGEROPV <> 'S' "			// incluido em 29/04/2013
EndIf
cQuery +=    "AND SD3.D_E_L_E_T_='' "
cQuery += "ORDER BY CTT_CUSTO, D3_CC, D3_DOC, D3_COD "
cQuery := ChangeQuery(cQuery)
If Select("TRB")>0
	TRB->(dbCloseArea())
EndIf
dbUseArea(.T.,"TOPCONN",TcGenQry(,,cQuery),'TRB',.T.,.T.)

DbSelectarea("TRB")
TRB->(dbGoTop())
If TRB->(Eof().And.Bof())
	MsgAlert("Não há registros a serem processados...")
	dbSelectArea(_cAlias)
	CTT->(RestArea(_aAreaCTT))
	Return
EndIf

// Imprime quantas vezes o usuario informar nos parametros.
For _nAux1 := 1 to mv_par04     
    
    TRB->(dbGoTop())

	Do While !TRB->(Eof())
        _aPV := {}
        _aD3 := {}
		ImpPorCC(Cabec1,Cabec2,Titulo,nLin,TRB->D3_CC,_cFiltro,_nAux1)
		If !Empty(_aPV)
			lEnd	:= .F.
			MsAguarde({|lEnd| _GeraPV(@lEnd,_aPV)}, "Aguarde...", OemToAnsi("Processando Gravação do Pedido de Vendas..."),.T.)
			Pergunte(cPerg, .F.)
		EndIF
			
		// Proximo centro de custo.
		dbSelectArea("TRB")
	EndDo

Next _nAux1

If !EmptY(_aErroPV)
	AutoGrLog("Inicio Log ROMANEIO - CR que nao geraram PEDIDO DE VENDAS")
	AutoGrLog("")
	For _nXX := 1 to Len(_aErroPV)
		AutoGrLog(_aErroPV[_nXX,1]+" "+Iif(!Empty(_aErroPV[_nXX,2]),_aErroPV[_nXX,2]+"-"+_aErroPV[_nXX,3],""))
	Next _nXX
	AutoGrLog("")
	AutoGrLog("Fim Log ROMANEIO")

	_cFileog := NomeAutoLOg()
	If _cFileog <> nil
		_cNomeLog := "log_romaneio_"+dtos(mv_par03)+"_"+StrTran(time(),":","")+".txt"
		__CopyFile("\system\"+_cFileog,cDirect+_cNomeLog)
		_cAnx :=  cDirect+_cNomeLog
		u_cieeMail(_cAnx) 
		ferase("\system\"+_cFileog)
	EndIf
EndIf

//almoxarifado@cieesp.org.br
//

// Limpa os filtros.
dbSelectArea("CTT")
Set Filter To
dbSelectArea("SD3")
Set Filter To

If Select("TRB")>0
	TRB->(dbCloseArea())
EndIf
dbSelectArea(_cAlias)
CTT->(RestArea(_aAreaCTT))
Return

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³ImpPorCC  ºAutor  ³ Felipe Raposo      º Data ³  10/03/03   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ Imprime o romaneio do centro de custo posicionado (CTT).   º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ CIEE.                                                      º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
Static Function ImpPorCC(Cabec1,Cabec2,Titulo,nLin,CCusto,cFiltro,nVia)

Local _nTotPeso, _nTotVal, _cSemPV := ""
Private _aAreaB1

// Salva a area do alias.
_aAreaB1 := SB1->(GetArea())

// Variaveis totalizadoras.
_nTotPeso := 0
_nTotVal  := 0

Titulo := alltrim(Titulo) + " - " + _cLocal
Titulo += " - " + dtoc(mv_par03)
If ValType(nVia) == "N" .and. mv_par04 > 1
	Titulo += " -   via " + AllTrim(str(nVia)) + "/" + AllTrim(str(mv_par04))
Endif
SB1->(dbSetOrder(1))  // B1_FILIAL+B1_COD.

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ SETREGUA -> Indica quantos registros serao processados para a regua ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

//SetRegua(SD3->(RecCount()))
SetRegua(100)
//dbSelectArea("SD3")
dbSelectArea("TRB")
cDesCusto := TRB->CTT_DESC01

Do While TRB->D3_CC == CCusto .And. !TRB->(Eof())
	
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Verifica o cancelamento pelo usuario...                             ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	IncRegua()
	If lAbortPrint
		@nLin, 000 PSAY "*** CANCELADO PELO OPERADOR ***"
		Exit
	Endif                   
	                                   
	If LEFT(TRB->D3_CF,2) == "DE"  // Descarta devoluções
		TRB->(dbSkip()) // Avanca o ponteiro do registro no arquivo
      	Loop
	Endif
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Impressao do cabecalho do relatorio. . .                            ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	If nLin > 55  // Salto de Pagina. Neste caso o formulario tem 55 linhas...
		Cabec(Titulo,Cabec1,Cabec2,NomeProg,Tamanho,nTipo)
		nLin	 := 09
		_cCabec3 := "Unidade destino: " + AllTrim(TRB->CTT_CUSTO) + " - " + AllTrim(TRB->CTT_DESC01)
		@nLin, 00 PSay padc(_cCabec3, limite); nLin += 2
	Endif
	
	SB1->(dbSeek(xFilial("SB1") + TRB->D3_COD, .F.))
	
	_nPeso := (SB1->B1_PESO * TRB->D3_QUANT) / 1000
	
	@nLin, 00 PSay SubStr(TRB->D3_DOC, 1, 6)
	@nLin, 07 PSay SubStr(SB1->(AllTrim(B1_COD) + " " + B1_DESC),  1, 34)
	@nLin, 42 PSay Transform(TRB->D3_QUANT, "@E 99999999.99")
	@nLin, 54 PSay Transform(_nPeso, "@E 999999.9999")
//	@nLin, 66 PSay Transform(TRB->D3_CUSTO1, "@E 999,999,999.99")
	_nCusto := (TRB->D3_QUANT * round(TRB->D3_CUSTO1/TRB->D3_QUANT,2)) //Estamos forçando a conta do Valor Total para nao estourar 2 casas decimais e com isso levar o mesmo valor para o faturamento
	@nLin, 66 PSay Transform(_nCusto, "@E 999,999,999.99")
	nLin++ // Avanca a linha de impressao
	
	_nTotPeso += _nPeso
	_nTotVal  += _nCusto //TRB->D3_CUSTO1

	If mv_par06 == 1 //Sim
		If !Empty(TRB->CTT_CODCLI).And.!Empty(TRB->CTT_LOJCLI)
			_nPos	:= 0
			_nPos 	:= aScan( _aPV,{|x| AllTrim(x[1]) == AllTrim(TRB->CTT_CUSTO)+AllTrim(TRB->D3_COD)	})
			If _nPos > 0
				_aPV[_nPos,7] += TRB->D3_QUANT
				_aPV[_nPos,10] += _nPeso
			Else
				aadd(_aPV,{	AllTrim(TRB->CTT_CUSTO)+AllTrim(TRB->D3_COD),; 
							TRB->CTT_CODCLI,;
							TRB->CTT_LOJCLI,;
							"01",;
							TRB->CTT_CODTRA,;
							TRB->D3_COD,;
							TRB->D3_QUANT,;
							(_nCusto/TRB->D3_QUANT),;
							TRB->D3_DOC,;
							_nPeso,;
							AllTrim(TRB->CTT_CUSTO),;
							AllTrim(TRB->CTT_DESC01),;
							Iif(!Empty(TRB->D3_XUSERLG), TRB->D3_XUSERLG, UsrRetName(RetCodUsr()) ) })
				aAdd(_aD3, TRB->SD3REC)
			EndIf
		Else
			_cSemPV := TRB->CTT_CUSTO
		EndIf
	EndIf
	dbSelectArea("TRB")
	TRB->(dbSkip()) // Avanca o ponteiro do registro no arquivo
EndDo
If !Empty(_cSemPV)
	aadd(_aErroPV, {"Nao Gerou PV porque não consta Cod.Cliente no CR "+_cSemPV,"",""})
EndIf

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Impressao do cabecalho do relatorio. . .                            ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
If nLin > 55 // Salto de Pagina. Neste caso o formulario tem 55 linhas...
	Cabec(Titulo,Cabec1,Cabec2,NomeProg,Tamanho,nTipo)
	nLin := 8
Endif
@nLin, 00 PSay Replicate("-",limite); nLin++
@nLin, 15 PSay "Total....:"
@nLin, 51 PSay Transform(_nTotPeso, "@E 9,999,999.9999")
@nLin, 66 PSay Transform(_nTotVal,  "@E 999,999,999.99"); nLin++
@nLin, 15 PSay "Quantidade de volumes gerados: ___________"; nLin += 2
@nLin, 00 PSay Replicate("=",limite); nLin += 2

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Impressao do cabecalho do relatorio. . .                            ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
If nLin > 44 // Salto de Pagina. Neste caso o formulario tem 55 linhas...
	Cabec(Titulo,Cabec1,Cabec2,NomeProg,Tamanho,nTipo)
	nLin := 9
Endif
// Observacao.
@nLin, 00 PSay "Obs.: " + Replicate("_",limite - 6); nLin++
@nLin, 00 PSay Replicate("_",limite); nLin++
@nLin, 00 PSay Replicate("_",limite); nLin++
@nLin, 00 PSay Replicate("_",limite); nLin += 2

// Vistos.
@nLin, 05 PSay "  Almoxarifado            Adm.  Patrimonial         Adm.  Patrimonial "; nLin++
@nLin, 05 PSay "Liberado:__/__/__         Recebido:__/__/__         Enviado.:__/__/__ "; nLin++
@nLin, 05 PSay "Nome:____________         Nome:____________         Nome:____________ "; nLin++
@nLin, 05 PSay "Visto:___________         Visto:___________         Visto:___________ "; nLin += 2

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Impressao do cabecalho do relatorio. . .                            ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
If nLin > 40 // Salto de Pagina. Neste caso o formulario tem 55 linhas...
	Cabec(Titulo,Cabec1,Cabec2,NomeProg,Tamanho,nTipo)
	nLin := 9
Else
	@nLin, 00 PSay Replicate("=",limite); nLin += 2
Endif
//CTT->(dbSeek(xFilial("CTT") + CCusto, .F.))
@nLin, 05 PSay upper("A ser preenchido pela area / unidade e devolvido ao almoxarifado."); nLin += 3
@nLin, 05 PSay "Unidade destino: " + AllTrim(cCusto) + " - " + cDesCusto; nLin += 2

// Observacao.
@nLin, 00 PSay "Obs.: " + Replicate("_", limite - 6); nLin++
@nLin, 00 PSay Replicate("_", limite); nLin++
@nLin, 00 PSay Replicate("_", limite); nLin++
@nLin, 00 PSay Replicate("_", limite); nLin += 2

// Vistos.
@nLin, 05 PSay "Unidade de Distribuicao   Unidade de Distribuicao   Unidade de Distribuicao"; nLin++
@nLin, 05 PSay "Recebido......:__/__/__   Reencaminhado.:__/__/__   Recebido......:__/__/__"; nLin++
@nLin, 05 PSay "Nome:__________________   Nome:__________________   Nome:__________________"; nLin++
@nLin, 05 PSay "Visto:_________________   Visto:_________________   Visto:_________________"; nLin++
nLin := 80

// Restaura a area do alias.
SB1->(RestArea(_aAreaB1))
Return
/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³SX1       ºAutor  ³Microsiga           º Data ³  08/03/06   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ Parametros da rotina                                       º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ AP                                                         º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
Static Function _fCriaSX1()

aRegs     := {}
nSX1Order := SX1->(IndexOrd())

SX1->(dbSetOrder(1))

cPerg := Left(cPerg,10)

/*
             grupo ,ordem ,pergunt               ,perg spa              ,perg eng              , variav ,tipo,tam,dec,pres,gsc,valid     ,var01     ,def01                 ,defspa01,defeng01,cnt01       ,var02,def02           ,defspa02,defeng02,cnt02   ,var03,def03      ,defspa03,defeng03,cnt03  ,var04,def04           ,defspa04,defeng04,cnt04,var05,def05  ,defspa05,defeng05,cnt05,f3   ,"","","",""
*/
aAdd(aRegs,{cPerg  ,"01" ,"Centro de Custo de ?","¨De Centro de Costo?","From Cost Center   ?","mv_ch1","C" ,09 ,00 ,0  ,"G",""        ,"mv_par01",""                    ,""      ,""      ,""         ,""   ,""             ,""      ,""      ,""       ,""   ,""         ,""      ,""     ,""     ,""   ,""              ,""      ,""      ,""   ,""   ,""     ,""      ,""     ,""   ,"CTT","","","",""})
aAdd(aRegs,{cPerg  ,"02" ,"Centro de Custo ate?","¨A Centro de Costo ?","To Cost Center     ?","mv_ch2","C" ,09 ,00 ,0  ,"G",""        ,"mv_par02",""                    ,""      ,""      ,"zzzzzzzzz",""   ,""             ,""      ,""      ,""       ,""   ,""         ,""      ,""     ,""     ,""   ,""              ,""      ,""      ,""   ,""   ,""     ,""      ,""     ,""   ,"CTT","","","",""})
aAdd(aRegs,{cPerg  ,"03" ,"Data de Referˆncia ?","¨Fecha Referencia  ?","Reference Date     ?","mv_ch3","D" ,08 ,00 ,0  ,"G","naovazio","mv_par03",""                    ,""      ,""      ,"''"       ,""   ,""             ,""      ,""      ,""       ,""   ,""         ,""      ,""     ,""     ,""   ,""              ,""      ,""      ,""   ,""   ,""     ,""      ,""     ,""   ,""   ,"","","",""})
aAdd(aRegs,{cPerg  ,"04" ,"Vias               ?","¨Vias              ?","Vias               ?","mv_ch4","N" ,02 ,00 ,0  ,"G",""        ,"mv_par04",""                    ,""      ,""      ,"2"        ,""   ,""             ,""      ,""      ,""       ,""   ,""         ,""      ,""     ,""     ,""   ,""              ,""      ,""      ,""   ,""   ,""     ,""      ,""     ,""   ,""   ,"","","",""})
aAdd(aRegs,{cPerg  ,"05" ,"Localizacao         ",""                    ,""                    ,"mv_ch5","C" ,01 ,00 ,0  ,"C",""        ,"mv_par05","Sede"                ,""      ,""      ,""         ,""   ,"Unidade"      ,""      ,""      ,""       ,""   ,"Ambas"    ,""      ,""     ,""     ,""   ,""              ,""      ,""      ,""   ,""   ,""     ,""      ,""     ,""   ,""   ,"","","",""})
aAdd(aRegs,{cPerg  ,"06" ,"Gera Pedido Venda  ?",""                    ,""                    ,"mv_ch6","C" ,01 ,00 ,0  ,"C",""        ,"mv_par06","Sim"                 ,""      ,""      ,""         ,""   ,"Nao"          ,""      ,""      ,""       ,""   ,""         ,""      ,""     ,""     ,""   ,""              ,""      ,""      ,""   ,""   ,""     ,""      ,""     ,""   ,""   ,"","","",""})

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

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³CESTR01   ºAutor  ³Microsiga           º Data ³  10/11/12   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³                                                            º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ AP                                                        º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
Static Function _GeraPV(lEnd, _aPV)

Local aCabPV := {}
Local aItemPV:= {}
Local nItem	 := 0
Local nPeso	 := 0

//cNumPed	:= GetSXENum("SC5","C5_NUM")

For _nY := 1 to len(_aPV)
	nPeso+=_aPV[_nY,10]
Next _nY

For _nI := 1 to len(_aPV)

	If _nI==1
		//Cabecalho
		aCabPV:={{"C5_TIPO"   	,"N"			,Nil},; // Tipo de pedido
				 {"C5_CLIENTE"	,_aPV[1,2] 		,Nil},; // Codigo do cliente
				 {"C5_LOJACLI"	,_aPV[1,3] 		,Nil},; // Loja do cliente
				 {"C5_EMISSAO"	,dDatabase 		,Nil},; // Data de emissao
				 {"C5_CONDPAG"	,_aPV[1,4]		,Nil},; // Codigo da condicao de pagamanto*
				 {"C5_TIPOCLI" 	,"R"			,Nil},; // Tipo de pedido
				 {"C5_MOEDA"  	,1				,Nil},; // Moeda
				 {"C5_ESPECI1" 	,"VOLUME"		,Nil},; // Especie 1
				 {"C5_PESOL"  	,nPeso			,Nil},; // Peso Liquido
				 {"C5_PBRUTO"  	,nPeso			,Nil},; // Peso Bruto		 
				 {"C5_TRANSP"  	,_aPV[1,5] 		,Nil},; // Transportadora
				 {"C5_TIPLIB" 	,"1"			,Nil},; // Tipo de Liberacao
				 {"C5_LIBEROK"	,"S"			,Nil},; // Liberacao Total
				 {"C5_XCR"		,_aPV[1,11]		,Nil},; // Centro de Custos
				 {"C5_XDESCCR"	,_aPV[1,12]		,Nil},; // Descricao CR
				 {"C5_XUSERLG"	,_aPV[1,13]		,Nil}}  // Usuário de inclusão
	EndIf

	//Items
	nItem++
	_xUM	:= POSICIONE("SB1",1,xFilial("SB1")+ALLTRIM(_aPV[_nI,6]),"B1_UM")
	_xGrupo	:= POSICIONE("SB1",1,xFilial("SB1")+ALLTRIM(_aPV[_nI,6]),"B1_GRUPO")
	_xTES	:= POSICIONE("SBM",1,xFilial("SBM")+ALLTRIM(_xGrupo),"BM_XTES")
	AADD(aItemPV,{	{"C6_ITEM"   ,strzero(nItem,2)	  	  			,Nil},; // Numero do Item no Pedido
					{"C6_CLI"    ,_aPV[_nI,2]		  	 			,Nil},; // Cliente
					{"C6_LOJA"   ,_aPV[_nI,3]		  	 			,Nil},; // Loja do Cliente
					{"C6_ENTREG" ,dDataBase			  	 			,Nil},; // Data da Entrega
					{"C6_PRODUTO",_aPV[_nI,6]		  	 			,Nil},; // Codigo do Produto
					{"C6_QTDVEN" ,_aPV[_nI,7]		   				,Nil},; // Quantidade Vendida
					{"C6_PRCVEN" ,round(_aPV[_nI,8],4)				,Nil},; // Preco Unitario Liquido
					{"C6_VALOR"  ,round(_aPV[_nI,7]*round(_aPV[_nI,8],4),2)	,Nil},; // Valor Total do Item
					{"C6_UM"     ,_xUM	   							,Nil},; // Unidade de Medida
					{"C6_TES"    ,_xTES	  							,Nil},; // Tipo de Entrada/Saida do Item
					{"C6_LOCAL"  ,"01"	 							,Nil},; // Almoxarifado
					{"C6_XDOC"   ,_aPV[_nI,9] 						,Nil}}) // Quantidade Empenhada

Next _nI
	
MSExecAuto({|x,y,z|Mata410(x,y,z)},aCabPv,aItemPV,3)
	
If lMsErroAuto
	DisarmTransaction()
	lMsErroAuto := .f.
// MostraErro()				// retirado em 16/04/2013 pelo analista Emerson
// RollBackSXE()			// retirado em 04/04/2013
// break					// retirado em 16/04/2013 pelo analista Emerson. Nao mostra o Erro e nao para o processo. Depois Grava um LOG com os CR nao gerados
	If len(_aPV) > 0
		aadd(_aErroPV, {"Nao Gerou PV",_aPV[1,11],_aPV[1,12]})
	EndIf 
Else
//	ConfirmSXE(.T.)			// retirado em 04/04/2013
	lEnd := .T.
	For _nI:=1 To Len(_aD3)
		SD3->(dbGoTo(_aD3[_nI]))
		RecLock("SD3",.F.)
		SD3->D3_XGEROPV := "S"			// incluido em 29/04/2013
		SD3->(MsUnLock())
	Next _nI
EndIf

Return(lEnd)