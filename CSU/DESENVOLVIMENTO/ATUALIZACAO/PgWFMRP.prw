#Include 'Rwmake.ch'

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³PgWFMRP   ºAutor  ³ Sergio Oliveira    º Data ³  Jul/2007   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ Verifica os processos de e-mails de PC por link enviados   º±±
±±º          ³ aos fornecedores o de Rdmakes (FA5).                       º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ CSU.                                                       º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

User Function PgWFMRP()

Local cDesc1         := "Este programa tem como objetivo imprimir relatorio "
Local cDesc2         := "de acordo com os parametros informados pelo usuario."
Local cDesc3         := "SS"
Local cPict          := ""
Local titulo       := "SS"
Local nLin         := 80
Local Cabec1       := "Pedido  Forn    Lj  Nome                                                                              Emissao   Aceite    Envio     Hora"
Local Cabec2       := ""
Local imprime      := .T.
Local aOrd := {}
Private lEnd         := .F.
Private lAbortPrint  := .F.
Private CbTxt        := ""
Private limite           := 80
Private tamanho          := "P"
Private nomeprog         := "NOME" // Coloque aqui o nome do programa para impressao no cabecalho
Private nTipo            := 18
Private aReturn          := { "Zebrado", 1, "Administracao", 2, 2, 1, "", 1}
Private nLastKey        := 0
Private cbtxt      := Space(10)
Private cbcont     := 00
Private CONTFL     := 01
Private m_pag      := 01
Private wnrel      := "NOME" // Coloque aqui o nome do arquivo usado para impressao em disco

Private cString := ""

wnrel   := SetPrint(cString,wnrel,cPerg,@titulo,cDesc1,cDesc2,cDesc3,.T.,,.T.,Tamanho,,.T.)

IF nLastKey==27
	RETURN
ENDIF

SETDEFAULT(aReturn,cString)

IF nLastKey == 27
	RETURN
ENDIF

RPTSTATUS({|lEnd|U_RunCont(Titulo, cabec1, cabec2, nomeprog, tamanho, 18)},titulo)

RETURN

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºFun‡„o    ³ RunCount º Autor ³ Sergio Oliveira    º Data ³  Jun/2006   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDescri‡„o ³ Processamento do programa.                                 º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ PoePrj.prw                                                 º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/

User Function RunCont(titulo,cabec1,cabec2,nomeprog,tamanho,nTipo)

Local cNumPed, nHdl, nAt1, cLine
Local cEOL := CHR(13)+CHR(10)

ChkFile( 'SA2' )
ChkFile( 'SC7' )

SA2->( DbSetOrder(1) )
SC7->( DbSetOrder(1) )

// Abrir os processos que se refere a pedido de compras e no for considerar somente pedidos:

aDirectory := Directory( 'd:\transfer\csu\wfms\*.html' )

ProcRegua( Len( aDirectory ) )

For xk := 1 To Len( aDirectory )

    IncProc()
	
	nHdl := FT_FUse("d:\transfer\csu\wfms\"+aDirectory[xk][1])
	If nHdl == -1
	    MsgAlert("O arquivo de nome "+aDirectory[xk][1]+" nao pode ser aberto!","Atencao!")
		Loop
	Endif
	
	FT_FGotop()
	
	While ! FT_FEof()
		
		cLine := FT_FReadLN()
		           
		// Ao abrir o e-mail, verificar se no codigo-fonte do e-mail constam as instrucoes abaixo. Em caso
		// afirmativo, verificar o numero do Pedido de Compras
		
		nAt1 := At( '<span class="textoItalico style2">No. ',cLine )
		
		If nAt1 > 0
			
			// Localizar o pedido dentro do sistema:
			
			cNumPed := SubStr(cLine,nAt1 + Len( '<span class="textoItalico style2">No. ' ),6)
			
			If SC7->( DbSeek( xFilial('SC7')+cNumPed ) )
			   SA2->( xFilial('SA2')+SC7->(C7_FORNECE+C7_LOJA) )
			   // Pedido  Forn    Lj  Nome                                                                              Emissao   Aceite    Envio     Hora
			   // 999999  999999  99  xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx  99/99/99  99/99/99  99/99/99  99:99:99
			   // 123456789.123456789.123456789.123456789.123456789.123456789.123456789.123456789.123456789.123456789.123456789.123456789.123456789.123456789.
			   //        10        20        30        40        50        60        70        80        90       100       110       120       130        140
			   @ nLin, 001 Psay SC7->C7_NUM
			   @ nLin, 009 Psay SC7->C7_FORNECE
			   @ nLin, 017 Psay SC7->C7_LOJA
			   @ nLin, 021 Psay SA2->A2_NOME
			   @ nLin, 103 Psay SC7->C7_EMISSAO
			   @ nLin, 113 Psay SC7->C7_X_DTACT
			   @ nLin, 123 Psay aDirectory[xk][3] // Data de Envio
			   @ nLin, 133 Psay aDirectory[xk][4] // Hora do Envio
			   @ nLin, Pcol()+2 Psay SA2->A2_EMAIL
			Else
			   @ nLin, 001 Psay "Pedido ja Excluido..."
			EndIf			
			
			nLin ++
			
			If nLin > 55
				nLin := Cabec(titulo,cabec1,cabec2,nomeprog,tamanho,nTipo)
				nLin ++
			EndIf
			
		EndIf
		
		FT_FSkip()
		
	EndDo
	
	FT_FUse()
	
Next

IF aReturn[5] = 1
	SET PRINTER TO
	dbCommitAll()
	OURSPOOL(wnrel)
ENDIF
MS_FLUSH()

Return