
/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณCCTRB002  บ Autor ณ CLAUDIO BARROS     บ Data ณ  26/05/06   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDescricao ณ Relatorio para impressao dos Lan็amentos contabeis, totali-บฑฑ
ฑฑบ          ณ dos por dia de movimenta็ใo.                               บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ SIGACTB - Especifico CIEE                                  บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
/*/

User Function CCTBR02()

//+-------------------------------------------------------------------------------
//| Declaracoes de variaveis
//+-------------------------------------------------------------------------------


Local cDesc1  := "Este relatorio ira imprimir infomacoes dos movimentos contabeis"
Local cDesc2  := "parametros informado pelo usuario"
Local cDesc3  := ""
Private cString  := "CT2"
Private Limite   := 132
Private Tamanho  := "M"
Private nTipo    := 15
Private aReturn  := { "Zebrado",1,"Administracao",1,2,1,"",1 }
Private wnrel    := "CCTBR02"
Private NomeProg := "CCTBR02"
Private nLastKey := 0
Private Titulo   := "Relatorio Sintetico Lctos Contabeis "
Private cPerg    := "CTBR02    "
Private imprime      := .T.
Private cbCont   := 0
Private cbTxt    := "registro(s) lido(s)"
Private Cabec1   := ""
Private Cabec2   := ""
Private nLin     := 80
Private m_pag    := 1
Private aOrd     := {}
Private Cabec1   := "Data Contabil         Valor Contabil"
"01234567890123456789012345678901234567890123456789"
Private Cabec2   := ""

#IFNDEF TOP
	MsgInfo("Nใo ้ possํvel executar este programa, estแ base de dados nใo ้ TopConnect","Incompatibilidade")
	RETURN
#ENDIF

/*+----------------------
| Parametros do aReturn
+----------------------
aReturn - Preenchido pelo SetPrint()
aReturn[1] - Reservado para formulario
aReturn[2] - Reservado para numero de vias
aReturn[3] - Destinatario
aReturn[4] - Formato 1=Comprimido 2=Normal
aReturn[5] - Midia 1-Disco 2=Impressora
aReturn[6] - Porta ou arquivo 1-Lpt1... 4-Com1...
CReturn[7] - Expressao do filtro
aReturn[8] - Ordem a ser selecionada
aReturn[9] [10] [n] - Campos a processar se houver
*/

//aAdd( aOrd, "Data Contabil"   )

//Parametros de perguntas para o relatorio
//+-------------------------------------------------------------+
//| mv_par01 - Data De            ? 99/99/9999                  |
//| mv_par02 - Data Ate           ? 99/99/9999                  |
//+-------------------------------------------------------------+

CriaSx1()

//+-------------------------------------------------------------------------------
//| Disponibiliza para usuario digitar os parametros
//+-------------------------------------------------------------------------------

If !Pergunte(cPerg,.T.)
	Return(Nil)
EndIf


//+-------------------------------------------------------------------------------
//| Solicita ao usuario a parametrizacao do relatorio.
//+-------------------------------------------------------------------------------

IF MV_PAR03 == 1
   Titulo := Titulo + "- Efetivado "
ELSEIF MV_PAR03 == 2
 Titulo := Titulo + "- Pre-Lancamento " 
ELSE  
 Titulo := Titulo + "- Efetivado / Pre-Lancamento"
ENDIF 	

wnrel := SetPrint(cString,wnrel,cPerg,@Titulo,cDesc1,cDesc2,cDesc3,.F.,,.T.,Tamanho,,.F.)
//SetPrint(cAlias,cNome,cPerg,cDesc,cCnt1,cCnt2,cCnt3,lDic,aOrd,lCompres,;
//cSize,aFilter,lFiltro,lCrystal,cNameDrv,lNoAsk,lServer,cPortToPrint)

//+-------------------------------------------------------------------------------
//| Se teclar ESC, sair
//+-------------------------------------------------------------------------------
If nLastKey == 27
	Return
Endif

//+-------------------------------------------------------------------------------
//| Estabelece os padroes para impressao, conforme escolha do usuario
//+-------------------------------------------------------------------------------

SetDefault(aReturn,cString)

//+-------------------------------------------------------------------------------
//| Verificar se sera reduzido ou normal
//+-------------------------------------------------------------------------------
//nTipo := Iif(aReturn[4] == 2, 15, 18)
nTipo := If(aReturn[4]==1,15,18)
//+-------------------------------------------------------------------------------
//| Se teclar ESC, sair
//+-------------------------------------------------------------------------------
If nLastKey == 27
	Return
Endif

//+-------------------------------------------------------------------------------
//| Chama funcao que processa os dados
//+-------------------------------------------------------------------------------
RptStatus({|lEnd| RelSQLImp(@lEnd, wnrel, cString) }, "Aguarde...", "Processando registros...", .T. )

Return

///////////////////////////////////////////////////////////////////////////////////
//+-----------------------------------------------------------------------------+//
//| PROGRAMA  | Relatorio_SQL.prw    | AUTOR | Robson Luiz  | DATA | 18/01/2004 |//
//+-----------------------------------------------------------------------------+//
//| DESCRICAO | Funcao - u_RelSQLImp()                                          |//
//|           | Fonte utilizado no curso oficina de programacao.                |//
//|           | Funcao de impressao                                             |//
//+-----------------------------------------------------------------------------+//
///////////////////////////////////////////////////////////////////////////////////
Static Function RelSQLImp(lEnd,wnrel,cString)

Local cFilSE2   := xFilial(cString)
Local cQuery    := ""
Local aCol      := {}
Local cFornec   := ""
Local nValor    := 0
Local nPago     := 0
Local nSaldo    := 0
Local nT_Valor  := 0
Local nT_Pago   := 0
Local nT_Saldo  := 0
Local cArqExcel := ""
Local cFlg  := chr(13)+chr(10)
Local nTotVal := 0

//+-----------------------
//| Cria filtro temporario
//+-----------------------

//+-----------------------
//| Cria indice temporario
//+-----------------------

//+-----------------------
//| Cria uma view no banco
//+-----------------------

cQuery := " SELECT CT2_DATA,SUM(CT2_VALOR)AS VALOR FROM "+RetSqlName("CT2")+" "+cFlg
cQuery += " WHERE D_E_L_E_T_ = ' ' AND CT2_DATA BETWEEN '"+Dtos(MV_PAR01)+"' "+cFlg
cQuery += " AND '"+Dtos(MV_PAR02)+"' AND CT2_ITEMC <> ' '  " +cFlg
If MV_PAR03 == 1
   cQuery += " AND CT2_TPSALD = '1' "
Endif
If MV_PAR03 == 2
   cQuery += " AND CT2_TPSALD = '9' "
EndIf   
cQuery += " GROUP BY CT2_DATA "+cFlg
cQuery += " ORDER BY CT2_DATA "+cFlg
cQuery := ChangeQuery(cQuery)
dbUseArea(.T.,"TOPCONN",TcGenQry(,,cQuery),'TRB',.T.,.F.)

TcSetField("TRB","CT2_DATA","D",8, 0 )

DbSelectArea("TRB")

dbGoTop()

SetRegua( RecCount() )

While !TRB->(Eof()) .And. !lEnd

	IncRegua()

	If nLin > 65
		Cabec(Titulo,Cabec1,Cabec2,NomeProg,Tamanho,nTipo)
		nLin:=8
	Endif
	
	@nLin,000 PSAY TRB->CT2_DATA
	@nLin,020 PSAY TRB->VALOR PICTURE "@E 9,999,999,999.99"
	nTotVal +=TRB->VALOR
	nLin := nLin + 1 // Avanca a linha de impressao
	TRB->(dbSkip())
	
End

If nLin > 65
	Cabec(Titulo,Cabec1,Cabec2,NomeProg,Tamanho,nTipo)
	nLin:=8
Endif
nLin++
@nLin,000 PSAY Replicate("-",132)
nLin++
@nLin,000 PSAY "Total Geral ==> "
@nLin,019 PSAY nTotVal Picture "@E 99,999,999,999.99"
nLin++
@nLin,000 PSAY Replicate("-",132)


If lEnd
	@ Li, aCol[1] PSay cCancel
	Return
Endif

dbSelectArea("TRB")
dbCloseArea()

If aReturn[5] == 1
	Set Printer TO
	dbCommitAll()
	Ourspool(wnrel)
EndIf

Ms_Flush()

Return

///////////////////////////////////////////////////////////////////////////////////
//+-----------------------------------------------------------------------------+//
//| PROGRAMA  | Relatorio_SQL.prw    | AUTOR | Robson Luiz  | DATA | 18/01/2004 |//
//+-----------------------------------------------------------------------------+//
//| DESCRICAO | Funcao - CriaSX1()                                              |//
//|           | Fonte utilizado no curso oficina de programacao.                |//
//|           | Funcao que cria o grupo de perguntas se caso nao existir        |//
//+-----------------------------------------------------------------------------+//
///////////////////////////////////////////////////////////////////////////////////
Static Function CriaSx1()

Local j  := 0
Local nY := 0
Local aAreaAnt := GetArea()
Local aAreaSX1 := SX1->(GetArea())
Local aReg := {}

aAdd(aReg,{cPerg,"01","Data De    ? ","","","mv_ch1","D",8,0,0,"G","","mv_par01","","","","","","","","","","","","","","",""})
aAdd(aReg,{cPerg,"02","Data Ate   ? ","","","mv_ch2","D",8,0,0,"G","","mv_par02","","","","","","","","","","","","","","",""})
aAdd(aReg,{cPerg,"03","Tipo Saldo ? ","","","mv_ch3","N",1,0,0,"G","","mv_par03","","","","","","","","","","","","","","",""})
aAdd(aReg,{"X1_GRUPO","X1_ORDEM","X1_PERGUNT","","","X1_VARIAVL","X1_TIPO","X1_TAMANHO","X1_DECIMAL","X1_PRESEL","X1_GSC","X1_VALID","X1_VAR01","X1_DEF01","X1_CNT01","X1_VAR02","X1_DEF02","X1_CNT02","X1_VAR03","X1_DEF03","X1_CNT03","X1_VAR04","X1_DEF04","X1_CNT04","X1_VAR05","X1_DEF05","X1_CNT05","X1_F3"})

dbSelectArea("SX1")
dbSetOrder(1)

For ny:=1 to Len(aReg)-1
	If !dbSeek(aReg[ny,1]+aReg[ny,2])
		RecLock("SX1",.T.)
		For j:=1 to Len(aReg[ny])
			FieldPut(FieldPos(aReg[Len(aReg)][j]),aReg[ny,j])
		Next j
		MsUnlock()
	EndIf
Next ny

RestArea(aAreaSX1)
RestArea(aAreaAnt)

Return Nil
