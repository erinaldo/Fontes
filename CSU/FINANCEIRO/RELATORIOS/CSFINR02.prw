#INCLUDE 'RWMAKE.CH'
#INCLUDE 'PROTHEUS.CH'
#INCLUDE 'TOPCONN.CH'

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄ¿±±
±±³ Programa   ³ CSFINR02.PRW ³ Autor ³ Flavio Novaes   ³ Data ³ 03/04/2007 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Descricao  ³ Relatorio de Gerenciamento das Liberacoes de Inclusao de   ³±±
±±³            ³ Notas Fiscais de Entrada Fora do Prazo e/ou com Impostos   ³±±
±±³            ³ Vencidos. Baseado na Tabela Especifica ZU7.                ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso        ³ Exclusivo CSU.                                             ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Observacao ³                                                            ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

USER FUNCTION CSFINR02()

LOCAL wnrel      := 'CSFINR02'
LOCAL cDesc1     := 'Este relatorio ira emitir as Liberações de '
LOCAL cDesc2     := 'Inclusão de Notas Fiscais de Entrada. '
LOCAL cDesc3     := ''
LOCAL cString    := 'ZU7'
PRIVATE tamanho  := 'G'		// 'P', 'M' ou 'G'
PRIVATE limite   := 220		//  80, 132 ou 220
PRIVATE titulo   := 'Relatório Gerencial de Liberações'
PRIVATE aReturn  := {'Zebrado',1,'Administracao',2,2,1,'',1}
PRIVATE nomeprog := 'CSFINR02'
PRIVATE aLinha   := {}
PRIVATE nLastKey := 0
PRIVATE cPerg    := PADR('CSFI02',LEN(SX1->X1_GRUPO))

ChkFile('ZU7')

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Variaveis utilizadas para parametros    ³
//³ mv_par01   Da Data de Liberacao         ³
//³ mv_par02   Ate a Data de Liberacao      ³
//³ mv_par03   Do Fornecedor                ³
//³ mv_par04   Ate o Fornecedor             ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
CRIASX1()
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Verifica as perguntas selecionadas ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

PERGUNTE(cPerg,.F.)

wnrel := SETPRINT('',wnrel,cPerg,@titulo,cDesc1,cDesc2,cDesc3,.F.,'',,tamanho)

IF nLastKey==27
	dbClearFilter()
	RETURN
ENDIF

SETDEFAULT(aReturn,cString)

IF nLastKey == 27
	dbClearFilter()
	RETURN()
ENDIF

RPTSTATUS({|lEnd|CSFINR2A()(@lEnd,wnRel,cString)},titulo)

RETURN
/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄ¿±±
±±³ Funcao     ³ CSFINR2A()   ³ Autor ³ Flavio Novaes   ³ Data ³ 03/04/2007 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Descricao  ³ Relatorio de Gerenciamento das Liberacoes de Inclusao de   ³±±
±±³            ³ Notas Fiscais de Entrada Fora do Prazo e/ou com Impostos   ³±±
±±³            ³ Vencidos. Baseado na Tabela Especifica ZU7.                ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso        ³ Exclusivo CSU.                                             ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Observacao ³                                                            ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
STATIC FUNCTION CSFINR2A(lEnd,WnRel,cString)
LOCAL cabec1    := 'Tipo Fornecedor           Solicitante                       Motivo                          Data Liberação    Usuário Lib.     Data Bloqueio    Usuário Bloq. '
LOCAL cabec2    := ''
LOCAL lContinua := .T.
LOCAL lImprimiu := .F.
LOCAL _cFornece := ''
LOCAL _cSolicit := ''
LOCAL _cMotivo  := ''
LOCAL _nLinhas  := 0
LOCAL _cLinha   := ''
LOCAL _nPos     := 0

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Variaveis utilizadas para Impressao do Cabecalho e Rodape. ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

li    := 80
m_pag := 1
nTipo := IIF(aReturn[4]==1,15,18)

IF SELECT('SZU7') > 0
	SZU7->( DbCloseArea() )
ENDIF

/*
ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
³ Sergio em Mar/2008: Chamado 002427 - Novo parametro de tipo de liberacao. ³
ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
*/	
_cQuery := " SELECT ZU7_FILIAL,ZU7_FORNEC,ZU7_LOJA,ZU7_TIPOLI,ZU7_ATIVO,ZU7_MOTIVO,"
_cQuery += " ZU7_DTLIB,ZU7_HRLIB,ZU7_USLIB,ZU7_DTBLOQ,ZU7_HRBLOQ,ZU7_USBLOQ,ZU7_SOLIC, R_E_C_N_O_ AS REGIS "
_cQuery += " FROM "+RETSQLNAME('ZU7')+" WHERE D_E_L_E_T_ = ' ' "
_cQuery += " AND ZU7_FILIAL = '"+xFilial('ZU7')+"' "
_cQuery += " AND ZU7_DTLIB  BETWEEN '"+Dtos(MV_PAR01)+"' AND '"+Dtos(MV_PAR02)+"' "
_cQuery += " AND ZU7_FORNEC BETWEEN '"+MV_PAR03+"' AND '"+MV_PAR04+"' "
If MV_PAR05 == 3 // Impostos
	_cQuery += " AND ZU7_TIPOLI = '1' "
ElseIf MV_PAR05 == 2 // Fora Prazo
	_cQuery += " AND ZU7_TIPOLI <> '1' "
EndIf
_cQuery += " ORDER BY ZU7_FORNEC,ZU7_LOJA,ZU7_DTLIB,ZU7_HRLIB "

nCntView := U_MontaView( _cQuery, 'SZU7' )

dbSelectArea('SZU7')
dbGoTop()

PROCREGUA(nCntView)
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Imprime Relatorio. ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
WHILE !EOF() .AND. lContinua

	IF lAbortPrint
		IF lImprimiu
			@ li,001 PSAY '** CANCELADO PELO OPERADOR **'
		ENDIF
		lContinua := .F.
		EXIT
	ENDIF
	
	INCPROC('Processando...')
	
	ZU7->( DbGoTo( SZU7->REGIS ) )
	
	DbSelectArea('SZU7')
	
	_cFornece := POSICIONE('SA2',1,xFilial('SA2')+SZU7->ZU7_FORNEC+SZU7->ZU7_LOJA,'A2_NREDUZ')
	_cFornece := SUBSTR(ALLTRIM(_cFornece),1,IIF(LEN(ALLTRIM(_cFornece))>20,20,LEN(ALLTRIM(_cFornece))))
	_cSolicit := ALLTRIM(SZU7->ZU7_SOLIC)
	
	PswOrder(2) // Ordem de nome do usuario
	PswSeek( _cSolicit )

 	_cSolicit := PadR( "("+_cSolicit+")" + UsrFullName( PswId() ), 33 )
	lImprimiu := .T.

	IF li > 55
		CABEC(titulo,cabec1,cabec2,nomeprog,tamanho,nTipo)
	ENDIF

	//'Tipo Fornecedor           Solicitante                       Motivo                          Data Liberação    Usuário Lib.     Data Bloqueio    Usuário Bloq. '
	//'xxxx xxxxxxxxxxxxxxxxxxxx xxxxxxxxxxxxxxx (123456789012345) 123456789012345678901234567890 12345678901234567 123456789012345 12345678901234567 123456789012345'
	//'123456789.123456789.123456789.123456789.123456789.123456789.1234567890123456789.123456789.123456789.123456789.123456789.123456789.123456789.123456789.12345678'
	//'        10        20        23        40        50        60        70        80        90       100       110       120       130       140       150        '
	
/*ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
  ³ Sergio em Jan/2008: Correcao da impressao do campo memo. A informacao nao ³
  ³                     estava sendo impressa.                                ³
  ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ*/	
	
	DbSelectArea('SZU7')
	
	@ li,001 PSAY IIF(ZU7_TIPOLI=='1','IMP.','F.P.')
	@ li,006 PSAY IIF(EMPTY(_cFornece),SPACE(20),_cFornece)
	@ li,027 PSAY _cSolicit
	lImpResto := .t.
	nLineSize := 30
	nTabSize  := 2
	lWrap     := .t.
	nLines    := MlCount(ZU7->ZU7_MOTIVO, nLineSize, nTabSize, lWrap)
	For nCurrLine := 1 To nLines
		If Li > 60
			Li := Cabec(titulo,cabec1,cabec2,nomeprog,tamanho,nTipo)
			Li += 2
		Endif
		@ Li, 061 Psay MemoLine(ZU7->ZU7_MOTIVO, nLineSize, nCurrLine, nTabSize, lWrap)
		If nCurrLine == 1
			@ li,092 PSAY Dtoc(Stod(ZU7_DTLIB)) +'-'+ZU7_HRLIB
			@ li,110 PSAY ZU7_USLIB
			@ li,121 PSAY Dtoc(Stod(ZU7_DTBLOQ))+'-'+ZU7_HRBLOQ
			@ li,144 PSAY ZU7_USBLOQ
			lImpResto := .f.
		EndIf
		Li ++
	Next
	If lImpResto
		@ li,092 PSAY Dtoc(Stod(ZU7_DTLIB)) +'-'+ZU7_HRLIB
		@ li,110 PSAY ZU7_USLIB
		@ li,121 PSAY Dtoc(Stod(ZU7_DTBLOQ))+'-'+ZU7_HRBLOQ
		@ li,144 PSAY ZU7_USBLOQ
	EndIf
	li++
	
	DbSelectArea('SZU7')
	DbSkip()

ENDDO

IF lImprimiu
	RODA(0,SPACE(10),'G')
ENDIF

dbSelectArea('SZU7')
dbCloseArea()

IF aReturn[5] = 1
	SET PRINTER TO
	dbCommitAll()
	OURSPOOL(wnrel)
ENDIF

MS_FLUSH()

RETURN(.T.)
/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄ¿±±
±±³ Funcao     ³ CRIASX1()    ³ Autor ³ Flavio Novaes   ³ Data ³ 03/04/2007 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Descricao  ³ Relatorio de Gerenciamento das Liberacoes de Inclusao de   ³±±
±±³            ³ Notas Fiscais de Entrada Fora do Prazo e/ou com Impostos   ³±±
±±³            ³ Vencidos. Baseado na Tabela Especifica ZU7.                ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso        ³ Exclusivo CSU.                                             ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Observacao ³                                                            ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

STATIC FUNCTION CRIASX1()

LOCAL nX       := 0
LOCAL nY       := 0
LOCAL aAreaAnt := GETAREA()
LOCAL aAreaSX1 := SX1->(GETAREA())
Local aReg     := {}

aAdd(aReg,{cPerg,"01","Da Data de Liberacao  ","","","mv_ch1","D",08,0,0,"G","","mv_par01","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","",""})
aAdd(aReg,{cPerg,"02","Ate a Data de Liber.  ","","","mv_ch2","D",08,0,0,"G","","mv_par02","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","",""})
aAdd(aReg,{cPerg,"03","Do Fornecedor         ","","","mv_ch3","C",06,0,0,"G","","mv_par03","","","","","","","","","","","","","","","","","","","","","","","","","","","SA2","","","","",""})
aAdd(aReg,{cPerg,"04","Ate o Fornecedor      ","","","mv_ch4","C",06,0,0,"G","","mv_par04","","","","","","","","","","","","","","","","","","","","","","","","","","","SA2","","","","",""})
aAdd(aReg,{cPerg,"05","Tipo de Liberação     ","","","mv_ch5","N",01,0,0,"C","","mv_par05","Ambos","","","","","Fora do Prazo","","","","","Impostos","","","","","","","","","","","","","","","","","","","","",""})

U_ValidPerg( cPerg, aReg ) // Rcomw02.prw

RESTAREA(aAreaSX1)
RESTAREA(aAreaAnt)

RETURN