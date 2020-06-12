#INCLUDE "rwmake.ch"

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³CIEE005   º Autor ³ Rubens Lacerda     º Data ³  11/10/06   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDescricao ³Relatorio Vigencia x Documento                              º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³CIEE                                                        º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/

User Function CIEE005

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Declaracao de Variaveis                                             ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

Local cDesc1       := "Este programa tem como objetivo imprimir relatorio "
Local cDesc2       := "de acordo com os parametros informados pelo usuario."
Local cDesc3       := "Relatorio Documentos Fiscos"
Local cPict        := ""
Local titulo       := "Relatorio Documentos Fiscos"
Local nLin         := 80
Local Cabec1       := "UNIDADE                                  UF       DOCUMENTO   NUMERO               DATA       DATA       DATA       SITUACAO     TP.UNIDADE	OBSERVACOES "
Local Cabec2       := "                                                              DOCUMENTO            ABERTURA   VALIDADE   REGUL.                        "
Local imprime      := .T.
Local aOrd         := { 'Unidade', 'CNPJ', 'Data Abertura', 'Data Vencimento', 'Gerencia' }

Private lEnd        := .F.
Private lAbortPrint := .F.
Private CbTxt       := ""
Private limite      := 120 //80
Private tamanho     := "G" //"M"
Private nomeprog    := "CIEE005"
Private nTipo       := 18
Private aReturn     := { "Zebrado", 1, "Administracao", 2, 2, 1, "", 1 }
Private nLastKey    := 0
Private cbcont      := 00
Private CONTFL      := 01
Private m_pag       := 01
Private wnrel       := "CIEE005"
Private cPerg       := "CIE005    "
Private cString     := "PA1"

dbSelectArea( "PA1" )
dbSetOrder( 1 )

AjusteSX1()
Pergunte( cPerg, .F. )

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Monta a interface padrao com o usuario...                           ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

wnrel := SetPrint( cString, NomeProg, cPerg, @titulo, cDesc1, cDesc2, cDesc3, .F., aOrd, .F., Tamanho,, .F. )

If nLastKey == 27
	Return
EndIf

SetDefault( aReturn, cString )

If nLastKey == 27
	Return
EndIf

nTipo := If( aReturn[4] == 1, 15, 18 )

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Processamento. RptStatus monta janela com a regua de processamento. ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

RptStatus( { || RunReport( Cabec1, Cabec2, Titulo, nLin ) }, Titulo )

Return

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºRotina    ³ RunProc  ºAutor  ³ Rubens Lacerda     º Data ³  11/10/06   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDescricao ³ Processamento das informacoes                              º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ CIEE                                                       º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

Static Function RunProc()

Local cQuery := ''

nOrdem := aReturn[8]

PA1->( dbSetOrder( 1 ) )
PA2->( dbSetOrder( 1 ) )
PA4->( dbSetOrder( 1 ) )
PA5->( dbSetOrder( 1 ) )

cQuery := "SELECT PA2_TPUNID, PA2_OBS, PA2_GER, PA2_DESC, PA2_EST, PA1_TPDOC, PA1_COD, PA1_DESC, PA1_CNPJ, PA4_DTABER, PA4_DTVCTO, PA4_DTENCE, PA4_DTREG, "
cQuery += " PA4_CTVCTO, PA4_DTVCTO, PA2_STATUS, PA4_INDEFE, PA4_ENCE, PA4_OBS, PA4_NUMDOC, PA4.R_E_C_N_O_ PA4RECNO FROM " + RetSqlName( 'PA1' ) + " PA1 "

cQuery += " INNER JOIN " + RetSqlName( 'PA4' ) + " PA4 "
cQuery += " ON  PA4_FILIAL = '" + xFilial( 'PA4' ) + "' "
cQuery += " AND PA4_CODDOC = PA1_COD "
cQuery += " AND PA4_DTABER BETWEEN '" + DToS ( MV_PAR08 ) + "' AND '" + DToS ( MV_PAR09 ) + "'"
cQuery += " AND PA4_DTVCTO BETWEEN '" + DToS ( MV_PAR10 ) + "' AND '" + DToS ( MV_PAR11 ) + "'"
cQuery += " AND PA4.D_E_L_E_T_ = ' ' "

If     MV_PAR12 == '01'
	cQuery += " AND PA4_DTREG =  '        ' AND PA4_DTVCTO >= '" + DToS( dDataBase ) + "' "       // AGUARDANDO
ElseIf MV_PAR12 == '02'
	cQuery += " AND PA4_DTREG <> '        ' AND PA4_DTENCE = ' ' AND (PA4_DTVCTO = ' ' OR PA4_DTVCTO >= '" + DToS( dDataBase ) + "')"   // VIGENTE
ElseIf MV_PAR12 == '03'
	cQuery += " AND PA4_CTVCTO = 'S' and PA4_DTVCTO < '" + DToS( dDataBase ) + "' AND PA4_ENCE <> 'S' " // VENCIDO
ElseIf MV_PAR12 == '04'
	cQuery += " AND PA4_INDEFE = 'S' "             // INDEFERIDO
ElseIf MV_PAR12 == '06'
	cQuery += " AND PA4_ENCE = 'S' "               // ENCERRADO
EndIf
/*
If  MV_PAR13 == 1 
	cQuery += " AND PA4_OBS  IS NOT NULL " // COM OBSERVACAO
ElseIf MV_PAR13 == 2 
	cQuery += " AND PA4_OBS  IS NULL     " // SEM OBSERVACAO
EndIf
*/

cQuery += " INNER JOIN " + RetSqlName( 'PA2' ) + " PA2 "
cQuery += " ON  PA2_FILIAL = '" + xFilial( 'PA2' ) + "' "
cQuery += " AND PA2_COD = PA4_CODUNI "
cQuery += " AND PA2_COD BETWEEN '" + MV_PAR01 + "' AND '" + MV_PAR02 + "'"
cQuery += " AND PA2_EST BETWEEN '" + MV_PAR03 + "' AND '" + MV_PAR04 + "'"

If mv_par14 <> 4
	cQuery += " AND PA2_TPUNID = '" + alltrim(str(mv_par14)) + "' " 
EndIf

If MV_PAR12 == '05'
	cQuery += " AND PA2_STATUS = 'I' "       // INATIVO
EndIf

cQuery += " AND PA2.D_E_L_E_T_ = ' ' "

cQuery += " INNER JOIN " + RetSqlName( 'PA5' ) + " PA5 "
cQuery += " ON  PA5_FILIAL = '" + xFilial( 'PA5' ) + "' "
cQuery += " AND PA5_COD = PA2_GER "
cQuery += " AND PA5.D_E_L_E_T_ = ' ' "
cQuery += " AND PA2_GER BETWEEN '"+mv_par15+"' AND '"+mv_par16+"' "

cQuery += " WHERE PA1_FILIAL = '" + xFilial( 'PA1' ) + "' "

If     MV_PAR05 <> '99'
	cQuery += "   AND PA1_TPDOC = '" + MV_PAR05 + "'"
EndIf

If     MV_PAR06 == 1 .AND. MV_PAR05 == '02'
	cQuery += " AND PA1_ALVA  = 'A'"
ElseIf MV_PAR06 == 2 .AND. MV_PAR05 == '02'
	cQuery += " AND PA1_ALVA  = 'T'"
EndIf

If      MV_PAR07 == 1 .AND. MV_PAR05 == '03'
	cQuery += " AND PA1_ISIND = 'IM' "
ElseIf  MV_PAR07 == 2 .AND. MV_PAR05 == '03'
	cQuery += " AND PA1_ISIND = 'IS' "
EndIf

cQuery += " AND PA1.D_E_L_E_T_ = ' ' "

If     nOrdem == 1
	cQuery += " ORDER BY PA1_FILIAL, PA2_DESC "
ElseIf nOrdem == 2
	cQuery += " ORDER BY PA1_FILIAL, PA1_CNPJ"
ElseIf nOrdem == 3
	cQuery += " ORDER BY PA1_FILIAL, PA4_DTABER "
ElseIf nOrdem == 4
	cQuery += " ORDER BY PA1_FILIAL, PA4_DTVCTO "
ElseIf nOrdem == 5
	cQuery += " ORDER BY PA1_FILIAL, PA2_GER"
EndIf

MemoWrit("CIEE005",cQuery)

dbUseArea( .T., 'TOPCONNECT', TcGenQry( ,, cQuery ), 'TRB', .F., .T. )

Return NIL

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºFun‡„o    ³RUNREPORT º Autor ³ AP6 IDE            º Data ³  19/09/06   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDescri‡„o ³ Funcao auxiliar chamada pela RptStatus. A funcao RptStatus º±±
±±º          ³ monta a janela com a regua de processamento.               º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ Programa principal                                         º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/

Static Function RunReport( Cabec1, Cabec2, Titulo, nLin )
Local nI := 0

RunProc()
dbSelectArea( cString )
dbSetOrder( 1 )

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ SetRegua -> Indica quantos registros serao processados para a regua ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
SetRegua( RecCount() )

dbSelectArea( "TRB" ) //aBRE A TABELA TRB

TRB->( dbGoTop() )//APONTA O INICIO DA TABELA

While TRB->( !EOF() )
	
	IncRegua()
	
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Verifica o cancelamento pelo usuario...                             ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	
	If lAbortPrint
		@nLin, 00 PSay "*** CANCELADO PELO OPERADOR ***"
		Exit
	EndIf
	
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Impressao do cabecalho do relatorio. . .                            ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	
	If nLin > 55 // Salto de Página. Neste caso o formulario tem 55 linhas...
		Cabec( Titulo, Cabec1, Cabec2, NomeProg, Tamanho, nTipo )
		nLin := 8
	EndIf
	nLin := nLin + 1 // Avanca a linha de impressao
	
	@nLin, 000 PSay TRB->PA2_DESC
	@nLin, 041 PSay TRB->PA2_EST
	@nLin, 050 PSay TRB->PA1_DESC
	If Empty(TRB->PA1_CNPJ)
		@nLin, 063 PSay TRB->PA4_NUMDOC
	Else
		@nLin, 063 PSay TRB->PA4_NUMDOC Picture "@R 99.999.999/9999-99"		
	EndIf
	@nLin, 084 PSay DToC(StoD(TRB->PA4_DTABER) )
	@nLin, 095 PSay DToC(StoD(TRB->PA4_DTVCTO) )
	@nLin, 106 PSay DToC(StoD(TRB->PA4_DTENCE) )

/*
Alterado pelo analista Emerson dia 12/02/08
Coloquei o bloco de If abaixo conforme a ordem da Legenda
*/

	If TRB->PA4_ENCE == 'S'
		@nLin, 117 PSay 'ENCERRADO
	ElseIf TRB->PA4_INDEFE == 'S'
		@nLin, 117 PSay 'INDEFERIDO
	ElseIf TRB->PA4_CTVCTO == 'S' .and. PA4_DTVCTO < DToS( dDataBase )
		@nLin, 117 PSay 'VENCIDO'
	ElseIf !Empty( TRB->PA4_DTREG )
		@nLin, 117 PSay 'VIGENTE'
	ElseIf Empty( TRB->PA4_DTREG )
		@nLin, 117 PSay 'AGUARDANDO'
	EndIf

	PA4->( dbGoTo( TRB->PA4RECNO ) )
	
	If MV_PAR13 <> 2
		nLinhas := MlCount( PA4->PA4_OBS, 60 )
	
		If nLinhas > 0
		
			@nLin, 145 PSay MemoLine( PA4->PA4_OBS, 60, 1 )
		
			For nI := 2 to nLinhas  
		
				nLin++

   				If nLin > 55 // Salto de Página. Neste caso o formulario tem 55 linhas...
					Cabec( Titulo, Cabec1, Cabec2, NomeProg, Tamanho, nTipo )
					nLin := 8
				EndIf
			
				@ nLin,450 PSay MemoLine( PA4->PA4_OBS, 60, nI)
			Next nI
		
		EndIf
	EndIf

	_cTpUnid	:= ""
	Do Case 
		Case TRB->PA2_TPUNID == "1"
			_cTpUnid := "Unid.Operac."
		Case TRB->PA2_TPUNID == "2"
			_cTpUnid := "Posto de Atend"
		Case TRB->PA2_TPUNID == "3"
			_cTpUnid := "Sala Aprendiz"
	EndCase

	@nLin, 130 PSay _cTpUnid
	
	TRB->( dbSkip() ) // Avanca o ponteiro do registro no arquivo
EndDo

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Finaliza a execucao do relatorio...                                 ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

SET DEVICE TO SCREEN

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Se impressao em disco, chama o gerenciador de impressao...          ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

If aReturn[5] == 1
	dbCommitAll()
	SET PRINTER TO
	OurSpool( wnrel )
EndIf

MS_FLUSH()

TRB->( dbCloseArea() )

Return

Static Function AjusteSX1()
PutSx1( cPerg, '01', 'Da Unidade            ?', 'Da Unidade            ?', 'Da Unidade            ?', 'mv_ch1', 'C', 6, 0, 0, 'G', '', 'PA2', '', '', 'mv_par01', '', '', '', '', '', '', '', '', '', '', '', '', '', '', '', '',,, )
PutSx1( cPerg, '02', 'Ate a Unidade         ?', 'Ate a Unidade         ?', 'Ate a Unidade         ?', 'mv_ch2', 'C', 6, 0, 0, 'G', '', 'PA2', '', '', 'mv_par02', '', '', '', '', '', '', '', '', '', '', '', '', '', '', '', '',,, )
PutSx1( cPerg, '03', 'Da UF                 ?', 'Da UF                 ?', 'Da UF                 ?', 'mv_ch3', 'C', 2, 0, 0, 'G', '', '12' , '', '', 'mv_par03', '', '', '', '', '', '', '', '', '', '', '', '', '', '', '', '',,, )
PutSx1( cPerg, '04', 'Ate a UF              ?', 'Ate a UF              ?', 'Ate a UF              ?', 'mv_ch4', 'C', 2, 0, 0, 'G', '', '12' , '', '', 'mv_par04', '', '', '', '', '', '', '', '', '', '', '', '', '', '', '', '',,, )
PutSx1( cPerg, '05', 'Tipo Documento        ?', 'Tipo Documento        ?', 'Tipo Documento        ?', 'mv_ch5', 'C', 2, 0, 0, 'G', '', 'P1' , '', '', 'mv_par05', '', '', '', '', '', '', '', '', '', '', '', '', '', '', '', '',,, )
PutSx1( cPerg, '06', 'Tipo Alvara           ?', 'Tipo Alvara           ?', 'Tipo Alvara           ?', 'mv_ch6', 'N', 1, 0, 0, 'C', '', ''   , '', '', 'mv_par06', 'Alvara', 'Alvara', 'Alvara', '', 'Taxa', 'Taxa', 'Taxa', 'Todos', 'Todos', 'Todos', '', '', '', '', '', '',,, )
PutSx1( cPerg, '07', 'Tipo ISSQN            ?', 'Tipo ISSQN            ?', 'Tipo ISSQN            ?', 'mv_ch7', 'N', 1, 0, 0, 'C', '', ''   , '', '', 'mv_par07', 'Imunidade', 'Imunidade', 'Imunidade', '', 'Isencao', 'Isencao', 'Isencao', 'Todos', 'Todos', 'Todos', '', '', '', '', '', '',,, )
PutSx1( cPerg, '08', 'Da Data Abertura      ?', 'Da Data Abertura      ?', 'Da Data Abertura      ?', 'mv_ch8', 'D', 8, 0, 0, 'G', '', ''   , '', '', 'mv_par08', '', '', '', '', '', '', '', '', '', '', '', '', '', '', '', '',,, )
PutSx1( cPerg, '09', 'Ate a Data Abertura   ?', 'Ate a Data Abertura   ?', 'Ate a Data Abertura   ?', 'mv_ch9', 'D', 8, 0, 0, 'G', '', ''   , '', '', 'mv_par09', '', '', '', '', '', '', '', '', '', '', '', '', '', '', '', '',,, )
PutSx1( cPerg, '10', 'Da Data Vencimento    ?', 'Da Data Vencimento    ?', 'Da Data Vencimento    ?', 'mv_chA', 'D', 8, 0, 0, 'G', '', ''   , '', '', 'mv_par10', '', '', '', '', '', '', '', '', '', '', '', '', '', '', '', '',,, )
PutSx1( cPerg, '11', 'Ate a Data Vencimento ?', 'Ate a Data Vencimento ?', 'Ate a Data Vencimento ?', 'mv_chB', 'D', 8, 0, 0, 'G', '', ''   , '', '', 'mv_par11', '', '', '', '', '', '', '', '', '', '', '', '', '', '', '', '',,, )
PutSx1( cPerg, '12', 'Status Controle       ?', 'Status Controle       ?', 'Status Controle       ?', 'mv_chC', 'C', 2, 0, 0, 'G', '', 'P2' , '', '', 'mv_par12', '', '', '', '', '', '', '', '', '', '', '', '', '', '', '', '',,, )
PutSx1( cPerg, '13', 'Observacao            ?', 'Observacao            ?', 'Observacao            ?', 'mv_chD', 'N', 1, 0, 0, 'C', '', ''   , '', '', 'mv_par13', 'Sim', 'Sim', 'Sim', '', 'Nao', 'Nao', 'Nao', '', '', '', '', '', '', '', '', '',,, )

PutSx1( cPerg, '14', 'Tipo Unidade          ?', 'Tipo Unidade          ?', 'Tipo Unidade          ?', 'mv_chE', 'N', 1, 0, 0, 'C', '', ''   , '', '', 'mv_par14', 'Unid.Operacao', 'Unid.Operacao' , 'Unid.Operacao' , '', 'Posto Atend', 'Posto Atend', 'Posto Atend'   , 'Sala Aprendiz', 'Sala Aprendiz', 'Sala Aprendiz','Ambos', 'Ambos', 'Ambos', '', '', '',,, )
PutSx1( cPerg, '15', 'Da Gerencia           ?', 'Da Gerencia           ?', 'Da Gerencia           ?', 'mv_chF', 'C', 2, 0, 0, 'G', '', 'PA5', '', '', 'mv_par15', '', '', '', '', '', '', '', '', '', '', '', '', '', '', '', '',,, )
PutSx1( cPerg, '16', 'Ate a Gerencia        ?', 'Ate a Gerencia        ?', 'Ate a Gerencia        ?', 'mv_chG', 'C', 2, 0, 0, 'G', '', 'PA5', '', '', 'mv_par16', '', '', '', '', '', '', '', '', '', '', '', '', '', '', '', '',,, )




Return NIL