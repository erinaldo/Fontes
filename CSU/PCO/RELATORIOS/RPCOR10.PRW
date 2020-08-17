
///////////////////////////////////////////////////////////////////////////////////
//+-----------------------------------------------------------------------------+//
//| PROGRAMA  | RPCOR10.prw      | AUTOR | Fernando Garrigos| DATA | 06/02/2007 |//
//+-----------------------------------------------------------------------------+//
//| DESCRICAO | Funcao - RPCOR10()                                              |//
//|           | Relatório em SQL , comparativo de saldos entre PCO e CTB        |//
//|           |                                                                 |//
//+-----------------------------------------------------------------------------+//
//| MANUTENCAO DESDE SUA CRIACAO                                                |//
//+-----------------------------------------------------------------------------+//
//| DATA     | AUTOR                | DESCRICAO                                 |//
//+-----------------------------------------------------------------------------+//
//|          |                      |                                           |//
//+-----------------------------------------------------------------------------+//
///////////////////////////////////////////////////////////////////////////////////

User Function RPCOR10()

//+-------------------------------------------------------------------------------
//| Declaracoes de variaveis
//+-------------------------------------------------------------------------------

Local cDesc1  := "Este relatorio ira imprimir infomacoes referentes aos valores do PCO e CTB"
Local cDesc2  := "conforme parametros informado pelo usuario - Valores Mensais"
Local cDesc3  := ""

Private cString  := "CT3"
Private Tamanho  := "M"
Private aReturn  := { "Zebrado",1,"Administracao",2,2,1,"",1 }
Private wnrel    := "RPCOR10"
Private NomeProg := "RPCOR10"
Private nLastKey := 0
Private Limite   := 120
Private Titulo   := "Comparativo - Realizado (CTB) x Orçado (PCO)- Mês"
Private cPerg    := PADR("RPCO10",LEN(SX1->X1_GRUPO))
Private nTipo    := 0
Private cbCont   := 0
Private cbTxt    := "registro(s) lido(s)"
Private Cabec1   := ""
Private Cabec2   := ""
Private Li       := 80
Private m_pag    := 1
Private aOrd     := {}
//                             1         2         3         4         5         6         7         8         9        10        11
//                   012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789
//Private Cabec1   := "  FORNECEDOR                                                                 VLR. ORIGINAL              PAGO               SALDO  "
Private Cabec2   := "  Cta Orc.   Desc. Cta Orcamentária                             Vlr Real CTB        Vlr Orçado PCO        Diferença "
Private Cabec3   := ""

#IFNDEF TOP
	MsgInfo("Não é possível executar este programa, está base de dados não é TopConnect","Incompatibilidade")
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
aReturn[6] - Prota ou arquivo 1-Lpt1... 4-Com1...
CReturn[7] - Expressao do filtro
aReturn[8] - Ordem a ser selecionada
aReturn[9] [10] [n] - Campos a processar se houver
*/

//Parametros de perguntas para o relatorio
//+-------------------------------------------------------------+
//| mv_par01 - C Custo Inicial    ? ZZZZZZ                      |
//| mv_par02 - C Custo Final      ? ZZZZZZ                      |
//| mv_par03 - Cta Orc. Inicial   ? XX                          |
//| mv_par04 - Cta Orc. Final     ? XX                          |
//| mv_par05 - Data Inicial		  ? ZZZZZZ                      |
//| mv_par06 - Data Final	      ? ZZZZZZ                      |
//| mv_par07 - Cubo 	          ? ZZZZZZ                      |
//| mv_par08 - Valores Zerados    ? X                           |
//| mv_par09 - Movim. ou Acum     ? XX                          |
//+-------------------------------------------------------------+

//+-------------------------------------------------------------------------------
//| Disponibiliza para usuario digitar os parametros
//+-------------------------------------------------------------------------------

AjustaSx1() //Ajusta o SX1 se necessário

Pergunte(cPerg,.F.)

//+-------------------------------------------------------------------------------
//| Solicita ao usuario a parametrizacao do relatorio.
//+-------------------------------------------------------------------------------
wnrel := SetPrint(cString,wnrel,cPerg,@Titulo,cDesc1,cDesc2,cDesc3,.F.,aOrd,.F.,Tamanho,.F.,.F.)
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
nTipo := Iif(aReturn[4] == 1, 15, 18)

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
//| PROGRAMA  | RPCOR10.prw  | AUTOR | Fernando J. Garrigos | DATA | 22/03/2007 |//
//+-----------------------------------------------------------------------------+//
//| DESCRICAO | Funcao - RESTR08()                                              |//
//|           | 												                |//
//|           | Funcao de impressao                                             |//
//+-----------------------------------------------------------------------------+//
///////////////////////////////////////////////////////////////////////////////////
Static Function RelSQLImp(lEnd,wnrel,cString)

// Geral
Local aCol := {}
Local _nValCCCTB := 0
Local _nValCCPCO := 0
Local _nTOTCCCTB := 0
Local _nTOTCCPCO := 0
Local cQuery
Local cQuery2
Local _ctactb	:=	""
Local _ctapco 	:=  ""
Local _somactb 	:= "F"

//PCO
Local aRetFim
Local nCrdFim
Local nDebFim
Local cConfig
Local cChave
Local nSldFim := 0

//CTB
Local cConta     := ""
Local cCusto     := ""
Local dData      := mv_par05	// Data Referência.
Local nSldFimCTB := 0


Local dDataf	 := mv_par06 // antes mv_par05
Local dDataI 	 := mv_par05

Local cMoeda     := "01"   	  	// Moeda 1 - Real
Local cTpSald    := "1" 		// Tipo de Saldo 1 - Real
Local nQualSaldo := 1			// Saldo Atual (com sinal)
Local nImpAntLP	 := 0
Local dDataLP    := CTOD("  /  /  ")
Local lImpAntLP  := 0
Local aSaldos	:= 0

Private aSavPar		:= {}
aSavPar := { MV_PAR01, MV_PAR02, MV_PAR03, MV_PAR04, MV_PAR05, mv_par07, mv_par08, mv_par09 }

Titulo	:= Titulo+" - Período :"+DTOC(mv_par05)+" - "+DTOC(mv_par06)

//Define Data Inicial
dDataI 	:= dtoc(dDataI)
dDataI 	:= "01/"+substr(dDataI,3,6)
dDataI 	:=  ctod(ddataI)
dDataI	:= dDataI-1

//+--------------------
//| Coluna de impressao
//+--------------------

aAdd( aCol, 001 ) //Conta Orçamentária
aAdd( aCol, 013 ) //Desc. da Conta Orçamentária
aAdd( aCol, 064 ) //Vlr. Realizado - CTB
aAdd( aCol, 084 ) //Vlr. Orçado - PCO
aAdd( aCol, 103 ) //Variação - Realizado menos Orçado

//+--------------------
//| Seleciona Contas
//+--------------------

DbSelectArea("CTT")
DbSetOrder(1)
DbGoTop()
DbSeek(xFilial("CTT")+mv_par01)
SetRegua( RecCount() )

Do While !Eof() .and. ALLTRIM(CTT->CTT_CUSTO) >= ALLTRIM(mv_par01) .and. ALLTRIM(mv_par02) >= ALLTRIM(CTT->CTT_CUSTO)
	
	If CTT->CTT_CLASSE = "2"
		
		_cCusto 	:= CTT->CTT_CUSTO
		_cCCDesc    := CTT->CTT_DESC01
		
		IncRegua()
		
		If Li > 55
			Cabec(Titulo,Cabec2,Cabec3,NomeProg,Tamanho,nTipo)
		Endif
		
		@ Li, aCol[1]  PSay "Centro de Custo: " + _cCusto + " - " + _cCCDesc
		Li ++
		Li ++
		
		cQuery	:=	" SELECT DISTINCT CT1_CTAPCO AS CTAPCO FROM "+RetSqlName('CT1')+' CT1 '
		cQuery	+=	" WHERE CT1_FILIAL = '"+xFilial('CT1')+"' "
		cQuery	+=	" AND CT1_CTAPCO <> ' ' "
		cQuery	+=	" AND CT1_CONTA BETWEEN '"+mv_par03+"' AND '"+mv_par04+"' "
		cQuery	+=	" AND D_E_L_E_T_=' ' "
		cQuery	+=	" ORDER BY CT1_CTAPCO "
		cQuery	:=	ChangeQuery(cQuery)
		dbUseArea( .T., "TopConn", TCGenQry(,,cQuery),"TRB", .F., .F. )
		
		DbSelectArea("TRB")
		DbGoTop()
		
		Do While !Eof()
			
			_ctapco 	:= TRB->CTAPCO
			nSldFimCTB  := 0
			
			DbSelectArea("AK5")
			DbSetOrder(1)
			DbGoTop()
			DbSeek(xFilial("AK5")+_ctapco)
			
			If AK5->AK5_TIPO = "2"
				
				_cCO		:= AK5->AK5_CODIGO
				_cCODesc    := AK5->AK5_DESCRI
				
				If Li > 55
					Cabec(Titulo,Cabec2,Cabec3,NomeProg,Tamanho,nTipo)
				Endif
				
				//+--------------------
				//| Saldos do PCO
				//+--------------------
				
				//Define as datas para o relatório - valores do PCO
				_data3 	:= mv_par05
				_data3 	:= dtoc(_data3)
				_data3  := "01"+SUBSTR(_data3,3,6)
				_data3	:= ctod(_data3)
				dIni	:= _data3-1
				dFim	:= mv_par06 // antes - mv_par05
				
				//+--------------------
				cConfig := mv_par07 //Definição do Cubo - Utilizado com estrutura CO + CC - parâmetro 06
				cChave  := _cCusto+_cCO+"OR"
				
				/*
				aRetFim := PcoRetSld(cConfig,cChave,mv_par05)
				nCrdFim := aRetFim[1, 1] //aRetFim [Deb/Cred,Moeda]
				nDebFim := aRetFim[2, 1]
				
				nSldFim := nCrdFim-nDebFim
				*/
				
				aRetIni := PcoRetSld(cConfig,cChave,dIni)      // saldo final do mês anterior
				nCrdIni := aRetIni[1, 1]
				nDebIni := aRetIni[2, 1]
				
				aRetFim := PcoRetSld(cConfig,cChave,dFim)    // saldo final do mês atual
				nCrdFim := aRetFim[1, 1]
				nDebFim := aRetFim[2, 1]
				
				nMovCrd := nCrdFim-nCrdIni
				nMovDeb := nDebFim-nDebIni
				nMovPer := nMovCrd-nMovDeb                   // valor do movimento do período

				// Verifica se Valores de Movimentação ou Acumulado - parâmetro mv_par09
//				If mv_par09 = "M" // Valor do movimento mensal	
				nSldFim	:= nMovPer
//				Elseif mv_par09 = "A"  // Valor acumulado
//				nSldFim := nCrdFim - nDebFim
//				Endif				
				
				//+--------------------
				//| Saldos do CTB
				//+--------------------
				
				cQuery2	:=	" SELECT DISTINCT CT1_CONTA AS CTA FROM "+RetSqlName('CT1')+' CT1 '
				cQuery2	+=	" WHERE CT1_FILIAL = '"+xFilial('CT1')+"' "
				cQuery2	+=	" AND CT1_CTAPCO = '"+_ctapco+"' "
				cQuery2	+=	" AND D_E_L_E_T_=' ' "
				cQuery2	+=	" ORDER BY CT1_CONTA "
				cQuery2	:=	ChangeQuery(cQuery2)
				dbUseArea( .T., "TopConn", TCGenQry(,,cQuery2),"TRB2", .F., .F. )
				
				DbSelectArea("TRB2")
				DbGoTop()
				
				Do While !Eof()
					
					_cConta := TRB2->CTA
					
					//Saldo Atual
					aSaldosAtu := SaldoCT3(_cConta,_cCusto,dDataF,cMoeda,cTpSald)
					
					nSaldoAtuD 	:= aSaldosAtu[4]
					nSaldoAtuC 	:= aSaldosAtu[5]
					nSldAtuCTB	:= nSaldoAtuC - nSaldoAtuD // saldo atual
					
					//Saldo anterior
					aSaldosAnt := SaldoCT3(_cConta,_cCusto,dDataI,cMoeda,cTpSald)
					
					nSaldoAntD 	:= aSaldosAnt[4]
					nSaldoAntC 	:= aSaldosAnt[5]
					nSldAntCTB	:= nSaldoAntC - nSaldoAntD // saldo anterior
					
					// Verifica se Valores de Movimentação ou Acumulado - parâmetro mv_par09
					
//					If mv_par09 = "M"  //Saldo Movimento do Mês
					nSldFimCTB := nSldFimCTB + (nSldAtuCTB - nSldAntCTB)
//					Elseif mv_par09 = "A"
//					nSldFimCTB := nSldFimCTB + nSldAtuCTB
//					Endif
					
					DbSelectArea("TRB2")
					dbSkip()
				
				Enddo

				TRB2->(dbCloseArea())
				
				//+--------------------
				// IMPRESSAO DE DADOS DO RELATORIO
				//+--------------------
				
				IF mv_par08 = "N" .AND. nSldFimCTB <> 0 .OR. mv_par08 = "N" .AND. nSldFim <> 0         // Valores zerados = N
					
					@ Li, aCol[1]  PSay _cCo
					@ Li, aCol[2]  PSay SUBSTR(_cCODesc,1,30)
					//		@ Li, aCol[7]  PSay DTOC(mv_par05)
					@ Li, aCol[3]  PSay (nSldFimCTB)*-1  Picture "@E 99,999,999,999.99"
					@ Li, aCol[4]  PSay nSldFim Picture "@E 99,999,999,999.99"
					@ Li, aCol[5]  PSay (nSldFimCTB+nSldFim) Picture "@E 99,999,999,999.99"
					
					Li ++
					
				ELSEIF mv_par08 = "S"         // Imprime Zerados = S
					
					@ Li, aCol[1]  PSay _cCo
					@ Li, aCol[2]  PSay SUBSTR(_cCODesc,1,30)
					//		@ Li, aCol[7]  PSay DTOC(mv_par05)
					@ Li, aCol[3]  PSay (nSldFimCTB)*-1  Picture "@E 99,999,999,999.99"
					@ Li, aCol[4]  PSay nSldFim Picture "@E 99,999,999,999.99"
					@ Li, aCol[5]  PSay (nSldFimCTB+nSldFim) Picture "@E 99,999,999,999.99"
					
					Li ++
				ENDIF
				_nValCCCTB := _nValCCCTB + nSldFimCTB
				_nValCCPCO := _nValCCPCO + nSldFim
				_nTOTCCCTB := _nTOTCCCTB_Tot + nSldFimCTB
				_nTOTCCPCO := _nTOTCCPCO_Tot + nSldFim
				
				
			ENDIF
			
			
			DbSelectArea("TRB")
			dbSkip()
			
		Enddo
		
		DBCLOSEAREA("TRB")
		DBCLOSEAREA("TRB2")
		
		DbSelectArea("CTT")
		dbSkip()
		
		//Totalização do Centro de Custo
		IF CTT->CTT_CUSTO <> _cCusto
			
			@ Li, aCol[1]  PSay "Total da CC: " + _cCusto + " - " + SUBSTR(_cCCDesc,1,20)
			@ Li, aCol[3]  PSay (_nValCCCTB)*-1  Picture "@E 99,999,999,999.99"
			@ Li, aCol[4]  PSay _nValCCPCO  Picture "@E 99,999,999,999.99"
			@ Li, aCol[5]  PSay (_nValCCCTB + _nValCCPCO)  Picture "@E 99,999,999,999.99"
			_nValCCCTB := 0
			_nValCCPCO := 0
			Li ++
			@ Li, 000 PSay Replicate("-",Limite)
			Li ++
			
			
		Endif
	ELSEIF CTT->CTT_CLASSE = "1"
		DbSelectArea("CTT")
		dbSkip()
	ENDIF
	
Enddo

@ Li, aCol[1]  PSay "Total Geral: "
@ Li, aCol[3]  PSay (_nTOTCCCTB)*-1  Picture "@E 99,999,999,999.99"
@ Li, aCol[4]  PSay _nTOTCCPCO  Picture "@E 99,999,999,999.99"
@ Li, aCol[5]  PSay (_nTOTCCCTB + _nTOTCCPCO)  Picture "@E 99,999,999,999.99"
Li ++
@ Li, 000 PSay Replicate("-",Limite)
Li ++

If Li <> 80
	Roda(cbCont,cbTxt,Tamanho)
Endif


If aReturn[5] == 1
	Set Printer TO
	dbCommitAll()
	Ourspool(wnrel)
EndIf

Ms_Flush()

Return


Return Nil

//Atualização do SX1

Static Function AjustaSX1()
Local aHelpP01	:= {}
Local aHelpE01	:= {}
Local aHelpS01	:= {}
DbSelectArea('SX1')


PutSx1('RPCO10','01','CC Inicial?','CC Inicial?','CC Inicial?','mv_ch1','C'   , 20, 0, 0,'G','','CTT'   ,'','','mv_par01','','','','','','','','','','','','','','','','','','','')
PutSx1('RPCO10','02','CC Final?','CC Final?','CC Final?','mv_ch2','C', 20, 0, 0,'G','','CTT'   ,'','','mv_par02','','','','','','','','','','','','','','','','','','','')
PutSx1('RPCO10','03','Cta Contábil Ini?','Cta Contábil Ini?','Cta Contábil Ini?','mv_ch3','C'   , 20, 0, 0,'G','','CT1'   ,'','','mv_par03','','','','','','','','','','','','','','','','','','','')
PutSx1('RPCO10','04','Cta Contábil Fim?','Cta Contábil Fim?','Cta Contábil Fim?','mv_ch4','C', 20, 0, 0,'G','','CT1'   ,'','','mv_par04','','','','','','','','','','','','','','','','','','','')
PutSx1('RPCO10','05','Dt Inicial?','Dt Inicial?','Dt Inicial?','mv_ch5','D'   , 08, 0, 0,'G','',''   ,'','','mv_par05','','','','','','','','','','','','','','','','','','','')
PutSx1('RPCO10','06','Dt Final?','Dt Final?','Dt Final?','mv_ch6','D'   , 08, 0, 0,'G','',''   ,'','','mv_par06','','','','','','','','','','','','','','','','','','','')
PutSx1('RPCO10','07','Cubo?','Cubo?','Cubo?','mv_ch7','C', 02, 0, 0,'G','',''   ,'','','mv_par07','','','','','','','','','','','','','','','','','','','')
PutSx1('RPCO10','08','Imp. Zerados (SN)?','Imp. Zerados (SN)?','Imp. Zerados (SN)?','mv_ch8','C', 01, 0, 0,'G','',''   ,'','','mv_par08','','','','','','','','','','','','','','','','','','','')
//PutSx1('RPCO10','09','Mov. ou Acum. (MA)?','Mov. ou Acum. (MA)?','Mov. ou Acum. (MA)?','mv_ch9','C', 01, 0, 0,'G','',''   ,'','','mv_par09','','','','','','','','','','','','','','','','','','','')

Return .T.
