#INCLUDE "RWMAKE.CH"
#INCLUDE "RECIBO.CH"
#DEFINE CRLF CHR( 13 )+CHR( 10 )

/*                                                                                                                             
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑฺฤฤฤฤฤฤฤฤฤฤยฤฤฤฤฤฤฤฤฤฤยฤฤฤฤฤฤฤยฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤยฤฤฤฤฤฤยฤฤฤฤฤฤฤฤฤฤฟฑฑ
ฑฑณFun…o    ณ RECBRAD  ณ Autor ณ R.H. 			        ณ Data ณ 14.03.95 ณฑฑ
ฑฑรฤฤฤฤฤฤฤฤฤฤลฤฤฤฤฤฤฤฤฤฤมฤฤฤฤฤฤฤมฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤมฤฤฤฤฤฤมฤฤฤฤฤฤฤฤฤฤดฑฑ
ฑฑณDescri…o ณ Emissao do Recibos de Pagamento Eletronico BCO BRADESCO    ณฑฑ
ฑฑรฤฤฤฤฤฤฤฤฤฤลฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤดฑฑ
ฑฑณSintaxe   ณ GPER030( void )                                            ณฑฑ
ฑฑรฤฤฤฤฤฤฤฤฤฤลฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤดฑฑ
ฑฑณParametrosณ                                                            ณฑฑ
ฑฑรฤฤฤฤฤฤฤฤฤฤลฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤดฑฑ
ฑฑณ Uso      ณ Generico                                                   ณฑฑ
ฑฑรฤฤฤฤฤฤฤฤฤฤมฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤดฑฑ
ฑฑณ 		   ณ14/09/02ณ------ณ Inclusao das rotinas de geracao de arqui-ณฑฑ
ฑฑณ            ณ        ณ------ณ vo texto com lay-out definido Bradesco   ณฑฑ
ฑฑภฤฤฤฤฤฤฤฤฤฤฤฤมฤฤฤฤฤฤฤฤมฤฤฤฤฤฤมฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤูฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿*/
User Function RecBrad()

//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
//ณ Define Variaveis Locais ( Basicas )                            ณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
Local cString:="SRA"        // alias do arquivo principal ( Base )
Local aOrd   := {STR0001, STR0002, STR0003, STR0004, STR0005} //"Matricula"###"C.Custo"###"Nome"###"Chapa"###"C.Custo + Nome"
Local cDesc1 := STR0006		//"Emisso de Recibos de Pagamento."
Local cDesc2 := STR0007		//"Ser  impresso de acordo com os parametros solicitados pelo"
Local cDesc3 := STR0008		//"usu rio."

//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
//ณ Define Variaveis Locais ( Programa )                           ณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
Local nExtra, cIndCond, cIndRc
Local Baseaux := "S", cDemit := "N"
PRIVATE cMesAnoRef

//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
//ณ Declaracao de variaveis utilizadas no programa atraves da funcao    ณ
//ณ SetPrvt, que criara somente as variaveis definidas pelo usuario,    ณ
//ณ identificando as variaveis publicas do sistema utilizadas no codigo ณ
//ณ Incluido pelo assistente de conversao do AP5 IDE                    ณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู

SetPrvt( "CSTRING, AORD, CDESC1, CDESC2, CDESC3, BASEAUX" )
SetPrvt( "CDEMIT, ARETURN, NOMEPROG, ALINHA, NLASTKEY, CPERG" )
SetPrvt( "CSEM_DE, CSEM_ATE, ALANCA, APROVE, ADESCO, ABASES" )
SetPrvt( "AINFO, ACODFOL, LI, TITULO, WNREL, NORDEM" )
SetPrvt( "DDATAREF, NTIPREL, ESC, SEMANA, CFILDE, CFILATE" )
SetPrvt( "CCCDE, CCCATE, CMATDE, CMATATE, CNOMDE, CNOMATE" )
SetPrvt( "CHAPADE, CHAPAATE, MENSAG1, MENSAG2, MENSAG3, CSITUACAO" )
SetPrvt( "CCATEGORIA, CBASEAUX, CMESANOREF, TAMANHO, LIMITE, AORDBAG" )
SetPrvt( "CMESARQREF, CARQMOV, CALIASMOV, CACESSASR1, CACESSASRA, CACESSASRC" )
SetPrvt( "CACESSASRI, LATUAL, CARQNTX, CINDCOND, ADRIVER, CCOMPAC" )
SetPrvt( "CNORMAL, CINICIO, CFIM, TOTVENC, TOTDESC, FLAG" )
SetPrvt( "CHAVE, DESC_FIL, DESC_END, DESC_CC, DESC_FUNC, DESC_MSG1" )
SetPrvt( "DESC_MSG2, DESC_MSG3, CFILIALANT, CFUNCAOANT, CCCANT, VEZ" )
SetPrvt( "ORDEMZ, NATELIM, NBASEFGTS, NFGTS, NBASEIR, NBASEIRFE" )
SetPrvt( "ORDEM_REL, DESC_CGC, NCONTA, NCONTR, NCONTRT, NLINHAS" )
SetPrvt( "CDET, NCOL, NTERMINA, NCONT, NCONT1, NVALIDOS, NSEQ_, CREG, LCONTINUA" )
SetPrvt( "NVALSAL, DESC_BCO, CCHAVESEM, DESC_PAGA, NPOS, CARRAY, NHDL, CNOMEARQ, NSEQ_" )

//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
//ณ Define Variaveis Private( Basicas )                            ณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
//Private aReturn  := {STR0009, 1, STR0010, 2, 2, 1, "", 1 }	//"Zebrado"###"Administrao"
Private nomeprog :="RECBRAD"
Private aLinha   := { }, nLastKey := 0
Private cPerg    :="BRAREC"
Private cSem_De  := "  /  /    "
Private cSem_Ate := "  /  /    "
Private nAteLim , nBaseFgts , nFgts , nBaseIr , nBaseIrFe

//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
//ณ Define Variaveis Private( Programa )                           ณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
Private aLanca := {}
Private aProve := {}
Private aDesco := {}
Private aBases := {}
Private aInfo  := {}
Private aCodFol:= {}
Private li     := 0
Private nHdl   := 0
PRIVATE nSeq_  := 0
Private Titulo := STR0011		//"EMISSO DE RECIBOS DE PAGAMENTOS"
Private GERAOK

//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
//ณ Verifica as perguntas selecionadas                           ณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
VerPerg()    
pergunte( "BRAREC", .F. )

//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
//ณ Montagem da tela de processamento.                                  ณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
@ 200,1 TO 380,380 DIALOG GERAOK TITLE OemToAnsi("Gera็ใo Holerite Eletronico - Bco Bradesco") 
@ 02,10 TO 080,190
@ 10,010 Say " Este programa fara a gera็ใo do arquivo magnetico para envio              "
@ 18,010 Say " ao Banco Bradesco para disponibiliza็ใo do Holerite Eletronico		     "

@ 70,098 BMPBUTTON TYPE 01 ACTION GERRImp1() 
@ 70,128 BMPBUTTON TYPE 02 ACTION Close(GERAOK) 
@ 70,158 BMPBUTTON TYPE 05 ACTION Pergunte(cPerg,.T.)

Activate Dialog GERAOK Centered

Return


//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
//ณ Carregando variaveis mv_par?? para Variaveis do Sistema.     ณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
//ณ Variaveis utilizadas para parametros                         ณ
//ณ mv_par01        //  Data de Referencia para a impressao      ณ
//ณ mv_par02        //  Tipo de Recibo( Pre/Zebrado/Email/Arquivo )ณ
//ณ mv_par03        //  Emitir Recibos( Adto/Folha/1ฆ/2ฆ/V.Extra ) ณ
//ณ mv_par04        //  Numero da Semana                         ณ
//ณ mv_par05        //  Filial De                                ณ
//ณ mv_par06        //  Filial Ate                               ณ
//ณ mv_par07        //  Centro de Custo De                       ณ
//ณ mv_par08        //  Centro de Custo Ate                      ณ
//ณ mv_par09        //  Matricula De                             ณ
//ณ mv_par10        //  Matricula Ate                            ณ
//ณ mv_par11        //  Nome De                                  ณ
//ณ mv_par12        //  Nome Ate                                 ณ
//ณ mv_par13        //  Chapa De                                 ณ
//ณ mv_par14        //  Chapa Ate                                ณ
//ณ mv_par15        //  Mensagem 1                               ณ
//ณ mv_par16        //  Mensagem 2                               ณ
//ณ mv_par17        //  Mensagem 3                               ณ
//ณ mv_par18        //  Situacoes a Imprimir                     ณ
//ณ mv_par19        //  Categorias a Imprimir                    ณ
//ณ mv_par20        //  Imprimir Bases                           ณ
//ณ mv_par21        //  Arquivo de Saida                         ณ
//ณ mv_par22        //  Arquivo p/ BDN                           ณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
Static Function GERRImp1()

nOrdem     := 1
dDataRef   := mv_par01
nTipRel    := 4
dDataPag   := mv_par02
nTipRec    := mv_par03
Semana     := mv_par04
cFilDe     := mv_par05
cFilAte    := mv_par06
cCcDe      := mv_par07
cCcAte     := mv_par08
cMatDe     := mv_par09
cMatAte    := mv_par10
cNomDe     := mv_par11
cNomAte    := mv_par12
cSituacao  := mv_par13
cCategoria := mv_par14
cNomeArq   := mv_par15
lArqBDN    := ( mv_par16 == 1 )
cNum       := ''
lEhIncBDN  := ( MV_PAR17 == 1 )
cMesAnoRef := StrZero( Month( dDataRef ), 2 ) + StrZero( Year( dDataRef ), 4 )
cCodRec    := ''
Mensag1    := mv_par20
Mensag2    := mv_par21
Mensag3    := mv_par22
lTipoRem   := mv_par23


//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
//ณTabela de Tipo de Recibo no HPAGณ
//ณ                                ณ
//ณ001 Pagamento Mensal            ณ
//ณ002 Pagamento 1a quizena        ณ
//ณ003 Adiantamento                ณ
//ณ004 Ferias                      ณ
//ณ005 13 Salario                  ณ
//ณ006 Aluguel                     ณ
//ณ007 Participacao Nos Lucros     ณ
//ณ008 Folha de Pagamento Especial ณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู

If     nTipRec == 1
	cCodRec := '003'
ElseIf nTipRec == 2
	cCodRec := '001'
ElseIf nTipRec == 3
	cCodRec := '005'
ElseIf nTipRec == 4
	cCodRec := '005'
ElseIf nTipRec == 5
	cCodRec := '008'
Else
	cCodRec := '008'
EndIf

Close(GERAOK)

Processa({|| GERRImp() },"Processando...")

//Gerar Arquivo
If nTipRel == 4
	If nHdl > 0
		If fClose( nHdl )
			
			If nSeq_ <> 0
				//If lArqBDN
					If lEhIncBDN
						Aviso( 'AVISO', 'Gerado o arquivo ' + AllTrim( AllTrim( cNomeArq ) ) + CRLF + CRLF + ;
						'Guarde o n๚mero do lote deste arquivo para eventual substitui็ใo junto ao BDN: ' + cNum , {'OK'}, 3 )
					EndIf
				//EndIf
				
				//Aviso( 'AVISO', 'Gerado o arquivo ' + AllTrim( AllTrim( cNomeArq ) ) + '...', {'OK'} )
			Else
				If fErase( cNomeArq ) == 0
					If lContinua
						Aviso( 'AVISO', 'No existem registros a serem gravados. A gera็ใo do arquivo ' + AllTrim( AllTrim( cNomeArq ) ) + ' foi abortada ...', {'OK'} )
					EndIf
				Else
					MsgAlert( 'Ocorreram problemas na tentativa de dele็ใo do arquivo '+AllTrim( cNomeArq )+'.' )
				EndIf
			EndIf
		Else
			MsgAlert( 'Ocorreram problemas no fechamento do arquivo '+AllTrim( cNomeArq )+'.' )
		EndIf
	EndIf
	
EndIf


Return

//Gerar Arquivo
If nTipRel == 4
	If nHdl > 0
		If fClose( nHdl )
			
			If nSeq_ <> 0
				//If lArqBDN
					If lEhIncBDN
						Aviso( 'AVISO', 'Gerado o arquivo ' + AllTrim( AllTrim( cNomeArq ) ) + CRLF + CRLF + ;
						'Guarde o n๚mero do lote deste arquivo para eventual substitui็ใo junto ao BDN: ' + cNum , {'OK'}, 3 )
					EndIf
				//EndIf
				
				//Aviso( 'AVISO', 'Gerado o arquivo ' + AllTrim( AllTrim( cNomeArq ) ) + '...', {'OK'} )
			Else
				If fErase( cNomeArq ) == 0
					If lContinua
						Aviso( 'AVISO', 'No existem registros a serem gravados. A gera็ใo do arquivo ' + AllTrim( AllTrim( cNomeArq ) ) + ' foi abortada ...', {'OK'} )
					EndIf
				Else
					MsgAlert( 'Ocorreram problemas na tentativa de dele็ใo do arquivo '+AllTrim( cNomeArq )+'.' )
				EndIf
			EndIf
		Else
			MsgAlert( 'Ocorreram problemas no fechamento do arquivo '+AllTrim( cNomeArq )+'.' )
		EndIf
	EndIf
	
EndIf

Return NIL


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑฺฤฤฤฤฤฤฤฤฤฤยฤฤฤฤฤฤฤฤฤฤยฤฤฤฤฤฤฤยฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤยฤฤฤฤฤฤยฤฤฤฤฤฤฤฤฤฤฟฑฑ
ฑฑณFun…o    ณ GERRIMP  ณ Autor ณ R.H. - Ze Maria       ณ Data ณ 14.03.95 ณฑฑ
ฑฑรฤฤฤฤฤฤฤฤฤฤลฤฤฤฤฤฤฤฤฤฤมฤฤฤฤฤฤฤมฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤมฤฤฤฤฤฤมฤฤฤฤฤฤฤฤฤฤดฑฑ
ฑฑณDescri…o ณ Processamento Para emissao do Recibo                       ณฑฑ
ฑฑรฤฤฤฤฤฤฤฤฤฤลฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤดฑฑ
ฑฑณSintaxe   ณ R030IMP( lEnd, Wnrel, cString )                            ณฑฑ
ฑฑรฤฤฤฤฤฤฤฤฤฤลฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤดฑฑ
ฑฑณParametrosณ                                                            ณฑฑ
ฑฑรฤฤฤฤฤฤฤฤฤฤลฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤดฑฑ
ฑฑณ Uso      ณ Generico                                                   ณฑฑ
ฑฑรฤฤฤฤฤฤฤฤฤฤมฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤดฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿*/
Static Function GERRImp()//( lEnd, WnRel, cString, cMesAnoRef )
//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
//ณ Define Variaveis Locais ( Basicas )                            ณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
Local lIgual                 //Vari vel de retorno na comparaao do SRC
Local cArqNew                //Vari vel de retorno caso SRC #SX3
Local tamanho     := "P"
Local limite      := 80
Local aOrdBag     := {}                                                                                    
Local cMesArqRef  := If( nTipRec == 4, "13"+Right( cMesAnoRef, 4 ), cMesAnoRef )
Local cArqMov     := ""
Local cAliasMov   := ""
Local cAcessaSR1  := &( "{ || " + ChkRH( "GPER030", "SR1", "2" ) + "}" )
Local cAcessaSRA  := &( "{ || " + ChkRH( "GPER030", "SRA", "2" ) + "}" )
Local cAcessaSRC  := &( "{ || " + ChkRH( "GPER030", "SRC", "2" ) + "}" )
Local cAcessaSRI  := &( "{ || " + ChkRH( "GPER030", "SRI", "2" ) + "}" )

//Private aTabVbHrs  := {}
//Private aVerbHrs   := {}
Private nQtdComp   := 0
Private nTotRLote  := 0
Private cQuebraLin := Chr( 13 ) + Chr( 10 )  // Caracteres de Salto de Linha


//fCarrTab( @aTabVbHrs, 'U003', dDataRef )

If lArqBDN
	// Registro Header da Empresa - TIPO 0
	aTipo0 := {}
	//              Descricao                                Ini  Fim   Tipo  Tam Dec  Conteudo
	aAdd( aTipo0, { 'TIPO DE REGISTRO                     ', 001, 001,   'N',   1,  0, '"0"' } )
	aAdd( aTipo0, { 'DESCRIวรO DO ARQUIVO                 ', 002, 021,   'C',  20,  0, '"REMESSA HPAG EMPRESA"' } )
    aAdd( aTipo0, { 'CำDIGO DA EMPRESA                    ', 022, 030,   'N',   9,  0, 'StrZero(Val( MV_PAR19 ),9)' } )
	aAdd( aTipo0, { 'NฺMERO DO LOTE                       ', 031, 039,   'N',   9,  0, 'cNum' } )
	aAdd( aTipo0, { 'NฺMERO DO CNPJ OU CPF DA EMPRESA     ', 040, 048,   'N',   9,  0, '"001896779"' } )
	aAdd( aTipo0, { 'FILIAL DO CNPJ OU CPF DA EMPRESA     ', 049, 052,   'N',   4,  0, '"0001"' } )
	aAdd( aTipo0, { 'DอGITO DE CONTROLE                   ', 053, 054,   'N',   2,  0, '"38"' } )
	aAdd( aTipo0, { 'DATA DO MOVIMENTO ( DDMMSSAA )       ', 055, 062,   'N',   8,  0, 'GravaData( dDataRef, .F., 5 )  ' } )
	aAdd( aTipo0, { 'REFERสNCIA DA OPERAวรO DO LOTE       ', 063, 063,   'C',   1,  0, 'IIF( MV_PAR16==1, "I", "S" )' } )
	aAdd( aTipo0, { 'CำDIGO DE LANวAMENTO DO PRODUTO      ', 064, 068,   'C',   5,  0, '"00777"' } )
	aAdd( aTipo0, { 'FILLER                               ', 069, 223,   'C', 155,  0, '  ' } )
	aAdd( aTipo0, { 'INDICADOR DE REMESSA                 ', 224, 224,   'C',   1,  0, 'If(lTipoRem==1,"T"," ")' } ) 
	aAdd( aTipo0, { 'RESERVADO                            ', 225, 233,   'C',   9,  0, '  ' } )
	aAdd( aTipo0, { 'RESERVADO                            ', 234, 245,   'C',  12,  0, '  ' } )
	aAdd( aTipo0, { 'SEQUENCIAL DO ARQUIVO                ', 246, 250,   'N',   5,  0, 'nSeq_' } )
	
	// Registro Header do Comprovante - TIPO 1
	aTipo1 := {}
	//              Descricao                                Ini  Fim   Tipo  Tam Dec  Conteudo
	aAdd( aTipo1, { 'TIPO DE REGSITRO                     ', 001, 001,   'N',   1,  0, '"1"' } )
	aAdd( aTipo1, { 'REFERสNCIA DA OPERAวรO COMPROVANTE   ', 002, 002,   'C',   1,  0, '"I"' } )
	aAdd( aTipo1, { 'TIPO DE COMPROVANTE                  ', 003, 005,   'N',   3,  0, 'cCodRec' } )
	aAdd( aTipo1, { 'MสS\ANO DE REF. COMPROVANTE (MMAAAA) ', 006, 011,   'N',   6,  0, 'SubStr( GravaData( dDataRef, .F., 5 ), 3, 6 )' } )
	aAdd( aTipo1, { 'DATA LIBERAวรO COMPROVANTE(DDMMAAAA) ', 012, 019,   'N',   8,  0, 'GravaData( DataValida( dDataRef ), .F., 5 )' } )
	aAdd( aTipo1, { 'BANCO DO FUNCIONARIO                 ', 020, 023,   'N',   4,  0, '0237' } ) //'Subs( SRA->RA_BCDEPSA, 1, 3 )' } )
	aAdd( aTipo1, { 'NฺMERO DA AGสNCIA DO FUNCIONมRIO     ', 024, 028,   'N',   5,  0, 'Subs( SRA->RA_BCDEPSA, 4, 4 )' } )
	aAdd( aTipo1, { 'NฺMERO DA CONTA DO FUNCIONมRIO       ', 029, 041,   'N',  13,  0, 'cCtaFunc' } )
	aAdd( aTipo1, { 'FILLER                               ', 042, 042,   'C',   1,  0, ''           } )
	aAdd( aTipo1, { 'DอGITO DA CONTA DO FUNCIONมRIO       ', 043, 043,   'C',   1,  0, 'cDgCtaFunc' } )
	aAdd( aTipo1, { 'NฺMERO DO CPF DO FUNCIONมRIO         ', 044, 054,   'N',  11,  0, 'SRA->RA_CIC' } )
	aAdd( aTipo1, { 'NฺMERO DO PIS\PASEP DO FUNCIONมRIO   ', 055, 068,   'C',  14,  0, 'Transform( SRA->RA_PIS, "@R 999.999.999/99")' } )
	aAdd( aTipo1, { 'NฺMERO DO RG DO FUNCIONมRIO          ', 069, 081,   'C',  13,  0, 'SRA->RA_RG' } )
	aAdd( aTipo1, { 'NฺMERO DA CTPS DO FUNCIONมRIO        ', 082, 090,   'C',   9,  0, 'cNumCP' } )
	aAdd( aTipo1, { 'NOME DO FUNCIONมRIO                  ', 091, 120,   'C',  30,  0, 'SRA->RA_NOME' } )
	aAdd( aTipo1, { 'NฺMERO DE MATRอCULA DO FUNCIONมRIO   ', 121, 132,   'C',  12,  0, 'SRA->RA_MAT' } )
	aAdd( aTipo1, { 'FUNวรO DO FUNCIONมRIO                ', 133, 172,   'C',  40,  0, 'GetAdvFVal( "SRJ", "RJ_DESC", xFilial( "SRJ" )+SRA->RA_CODFUNC, 1, "" )' } )
	aAdd( aTipo1, { 'DATA ADMISSรO FUNCIONมRIO (DDMMAAAA) ', 173, 180,   'C',   8,  0, 'GravaData( SRA->RA_ADMISSA, .F., 5 )' } )
	aAdd( aTipo1, { 'FILLER                               ', 181, 233,   'C',  53,  0, '  ' } )
	aAdd( aTipo1, { 'RESERVADO                            ', 234, 245,   'C',  12,  0, '  ' } )
	aAdd( aTipo1, { 'SEQUENCIAL DO ARQUIVO                ', 246, 250,   'N',   5,  0, 'nSeq_' } )
	
	// Registro Detalhes do Comprovante - TIPO 2
	aTipo2 := {}
	//              Descricao                                Ini  Fim   Tipo  Tam Dec  Conteudo
	aAdd( aTipo2, { 'TIPO DE REGISTRO                     ', 001, 001,   'N',   1,  0, '"2"' } )
	aAdd( aTipo2, { 'CำDIGO DE LANวAMENTO                 ', 002, 005,   'C',   4,  0, 'cCodLan' } )
	aAdd( aTipo2, { 'DESCRIวรO DE LANวAMENTO              ', 006, 025,   'C',  20,  0, 'cDescLan' } )
	aAdd( aTipo2, { 'VALOR DO LANวAMENTO                  ', 026, 037,   'N',  12,  2, 'nValLan' } )
	aAdd( aTipo2, { 'IDENTIFICADOR DE LANวAMENTO          ', 038, 038,   'N',   1,  0, 'cIdLan' } )
	aAdd( aTipo2, { 'FILLER                               ', 039, 236,   'C', 198,  0, '  ' } )
	aAdd( aTipo2, { 'RESERVADO                            ', 237, 245,   'C',   9,  0, '  ' } )
	aAdd( aTipo2, { 'SEQUENCIAL DO ARQUIVO                ', 246, 250,   'N',   5,  0, 'nSeq_' } )
	
	// Registro Mensagem do Comprovante - TIPO 3
	aTipo3 := {}
	//              Descricao                                Ini  Fim   Tipo  Tam Dec  Conteudo
	aAdd( aTipo3, { 'TIPO DE REGISTRO                     ', 001, 001,   'N',   1,  0, '"3"' } )
	aAdd( aTipo3, { 'MENSAGEM DO COMPROVANTE              ', 002, 041,   'C',  40,  0, 'cMsg' } )
	aAdd( aTipo3, { 'FILLER                               ', 042, 236,   'C', 195,  0, '  ' } )
	aAdd( aTipo3, { 'RESERVADO                            ', 237, 245,   'C',   9,  0, '  ' } )
	aAdd( aTipo3, { 'SEQUENCIAL DO ARQUIVO                ', 246, 250,   'N',   5,  0, 'nSeq_' } )
	
	// Registro Trailler do Comprovante TIPO 4
	aTipo4 := {}
	//              Descricao                                Ini  Fim   Tipo  Tam Dec  Conteudo
	aAdd( aTipo4, { 'TIPO DE REGISTRO                     ', 001, 001,   'N',   1,  0, '"4"' } )
	aAdd( aTipo4, { 'DATA PAGAMENTO (DDMMAAAA)            ', 002, 009,   'C',   8,  0, 'GravaData( dDataPag, .F., 5 )' } )
	aAdd( aTipo4, { 'QTDE DEPENDENTES PARA IRRF           ', 010, 011,   'C',   2,  0, 'StrZero(Val(Sra->Ra_Depir),2)  ' } )
	aAdd( aTipo4, { 'QTDE DEPENDENTES PARA IRRF           ', 012, 013,   'C',   2,  0, 'StrZero(Val(Sra->Ra_Depir),2)  ' } )
	aAdd( aTipo4, { 'QTDE HORAS TRAB NA SEMANA            ', 014, 015,   'C',   2,  0, 'StrZero(Sra->Ra_HrSeman,2)  ' } )
	aAdd( aTipo4, { 'SALARIO CONTRATUAL                   ', 016, 027,   'N',  12,  2, 'Sra->Ra_Salario' } )
	aAdd( aTipo4, { 'QTDE FALTAS PERIODO FERIAS           ', 028, 029,   'C',   2,  0, '"00"' } )
	aAdd( aTipo4, { 'INDICADOR DE IMPRESSAO BANCARIA      ', 030, 030,   'C',   1,  0, '"S"' } )
	aAdd( aTipo4, { 'DATA INICIO PERIODO AQUISITIVO       ', 031, 038,   'C',   8,  0, '"00000000"' } )
	aAdd( aTipo4, { 'DATA FINAL  PERIODO AQUISITIVO       ', 039, 046,   'C',   8,  0, '"00000000"' } )
	aAdd( aTipo4, { 'DATA INICIO GOZO DE FERIAS           ', 047, 054,   'C',   8,  0, '"00000000"' } )
	aAdd( aTipo4, { 'DATA FINAL GOZO DE FERIAS            ', 055, 062,   'C',   8,  0, '"00000000"' } )
	aAdd( aTipo4, { 'VALOR BASE INSS                      ', 063, 074,   'N',  12,  2, 'If(nTipRec<>4,nAteLim,Space(12)) ' } )
	aAdd( aTipo4, { 'VALOR BASE INSS 13                   ', 075, 086,   'N',  12,  2, 'If(nTipRec==4,nAteLim,Space(12) )' } )
	aAdd( aTipo4, { 'VALOR BASE IRRF SALARIO              ', 087, 098,   'N',  12,  2, 'If(nTipRec<>4,nBaseIr,Space(12) )' } )
	aAdd( aTipo4, { 'VALOR BASE IRRF 13                   ', 099, 110,   'N',  12,  2, 'If(nTipRec==4,nBaseIr,Space(12) )' } )
	aAdd( aTipo4, { 'VALOR BASE IRRF FERIAS               ', 111, 122,   'N',  12,  2, '  ' } )
	aAdd( aTipo4, { 'VALOR BASE IRRF PPR                  ', 123, 134,   'N',  12,  2, '  ' } )
	aAdd( aTipo4, { 'VALOR BASE FGTS                      ', 135, 146,   'N',  12,  2, 'nBaseFgts' } )
	aAdd( aTipo4, { 'VALOR DO FGTS                        ', 147, 158,   'N',  12,  2, 'nFgts' } )
	aAdd( aTipo4, { 'FILLER                               ', 159, 236,   'C',  78,  0, '  ' } )
	aAdd( aTipo4, { 'RESERVADO                            ', 237, 245,   'C',   9,  0, '  ' } )
	aAdd( aTipo4, { 'SEQUENCIAL DO ARQUIVO                ', 246, 250,   'N',   5,  0, 'nSeq_' } )
                             
	// Registro Trailler do Comprovante TIPO 5
	aTipo5 := {}
	//              Descricao                                Ini  Fim   Tipo  Tam Dec  Conteudo
	aAdd( aTipo5, { 'TIPO DE REGISTRO                     ', 001, 001,   'N',   1,  0, '"5"' } )
	aAdd( aTipo5, { 'TOTAL DE LANวAMENTOS DO COMPROVANTE  ', 002, 006,   'N',   5,  0, 'nQtdComp' } )
	aAdd( aTipo5, { 'FILLER                               ', 007, 236,   'C', 230,  0, '  ' } )
	aAdd( aTipo5, { 'RESERVADO                            ', 237, 245,   'C',   9,  0, '  ' } )
	aAdd( aTipo5, { 'SEQUENCIAL DO ARQUIVO                ', 246, 250,   'N',   5,  0, 'nSeq_' } )
	
	// Registro Trailler da Empresa - TIPO 9
	aTipo9 := {}
	//              Descricao                                Ini  Fim   Tipo  Tam Dec  Conteudo
	aAdd( aTipo9, { 'TIPO DE REGISTRO                     ', 001, 001,   'N',   1,  0, '"9"' } )
	aAdd( aTipo9, { 'TOTAL DE REGISTROS DO LOTE           ', 002, 006,   'N',   5,  0, 'nTotRLote' } )
	aAdd( aTipo9, { 'FILLER                               ', 007, 236,   'C', 230,  0, '  ' } )
	aAdd( aTipo9, { 'RESERVADO                            ', 237, 245,   'C',   9,  0, '  ' } )
	aAdd( aTipo9, { 'SEQUENCIAL DO ARQUIVO                ', 246, 250,   'N',   5,  0, 'nSeq_' } )
EndIf

//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
//| Verifica se existe o arquivo de fechamento do mes informado  |
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
lAtual := ( !fExistArq( cMesArqRef,, 0 ) .AND. MesAno( dDataRef ) == MesAno( dDataBase ) )

If !lAtual
	If !fIniArqMov( cMesArqRef, @cAliasMov , @aOrdBag , @cArqMov )
		//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
		//| Se nao encontrar o arquivo retorna o arquivo atual           |
		//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
		ChkFile( cAliasMov , .F. )
		Return NIL
	EndIf
EndIf

//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
//ณ Cria o arquivo texto                                                ณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู

If nTipRel == 4
	
	//Verifica se Arquivo Existe
	If File( cNomeArq )
		If ( nAviso := Aviso( 'AVISO', 'Deseja substituir o ' + AllTrim( cNomeArq ) + ' existente ?', {'Sim', 'No'} ) ) == 1
			//Deleta Arquivo
			If fErase( cNomeArq ) <> 0
				MsgAlert( 'Ocorreram problemas na tentativa de deleo do arquivo '+AllTrim( cNomeArq )+'.' )
				Return NIL
			EndIf
		Else
			Return NIL
		EndIf
	EndIf
	
	//Verifica se Nome de Arquivo em Branco
	If Empty( cNomeArq )
		MsgAlert( 'Nome do Arquivo nos Parametros em Branco.', 'Ateno!' )
		Return NIL
	Else
		//Cria Arquivo
		nHdl := fCreate( cNomeArq )
		nSeq_ := 0
		lContinua := .T.
		
		//Verifica Criacao do Arquivo
		If nHdl == -1
			MsgAlert( 'O arquivo '+AllTrim( cNomeArq )+' no p“de ser criado! Verifique os parmetros.', 'Ateno!' )
			Return NIL
		EndIf
	EndIf
	
EndIf

//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
//ณ Selecionando a Ordem de impressao escolhida no parametro.    ณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
dbSelectArea( "SRA" )
If nOrdem == 1
	dbSetOrder( 1 )
EndIf
dbGoTop()

If nTipRel == 2
	aDriver := LEDriver()
	cCompac := aDriver[1]
	cNormal := aDriver[2]
	@ LI, 00 PSAY &cCompac
EndIf

//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
//ณ Selecionando o Primeiro Registro e montando Filtro.          ณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
If     nOrdem == 1
	dbSeek( cFilDe + cMatDe, .T. )
	cInicio := "SRA->RA_FILIAL + SRA->RA_MAT"
	cFim    := cFilAte + cMatAte
EndIf

dbSelectArea( "SRA" )
//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
//ณ Carrega Regua Processamento                                  ณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
ProcRegua( RecCount() )   // Total de elementos da regua

TOTVENC:= TOTDESC:= FLAG:= CHAVE := 0

Desc_Fil := Desc_End := DESC_CC:= DESC_FUNC:= ""
DESC_MSG1:= DESC_MSG2:= DESC_MSG3:= Space( 01 )
cFilialAnt := "  "
cFuncaoAnt := "    "
cCcAnt     := Space( 9 )
Vez        := 0
OrdemZ     := 0

If nTipRel == 4 .AND. lArqBDN
	GeraBDN0()
EndIf

dbSelectArea( "SRA" )
While !EOF() .AND. &cInicio <= cFim
	
	//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
	//ณ Movimenta Regua Processamento                                ณ
	//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู

	  INCPROC() // Anda a regua
	
	//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
	//ณ Consiste Parametrizacao do Intervalo de Impressao            ณ
	//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
	
	IF	( SRA->RA_NOME < cNomDe )  .OR. ( SRA->Ra_NOME > cNomAte )    .OR. ;
		( SRA->RA_MAT < cMatDe )   .OR. ( SRA->Ra_MAT > cMatAte )     .OR. ;
		( SRA->RA_CC < cCcDe )     .OR. ( SRA->Ra_CC > cCcAte )
		SRA->( dbSkip( 1 ) )
		Loop
	EndIf
	
	// Se o funcionario nao tiver conta no Bradesco nao envia
	If nTipRel == 4 .AND. lArqBDN .AND. Subs( SRA->RA_BCDEPSAL, 1, 3 ) <> '237'
		SRA->( dbSkip() )
		Loop
	EndIf
	
	aLanca:={}         // Zera Lancamentos
	aProve:={}         // Zera Lancamentos
	aDesco:={}         // Zera Lancamentos
	aBases:={}         // Zera Lancamentos
	//aVerbHrs:={}
	nAteLim := nBaseFgts := nFgts := nBaseIr := nBaseIrFe := 0.00
	
	Ordem_rel := 1     // Ordem dos Recibos
	
	//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
	//ณ Consiste situacao e categoria dos funcionarios			     |
	//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
	If !( SRA->RA_SITFOLH $ cSituacao ) .OR.  ! ( SRA->RA_CATFUNC $ cCategoria )
		dbSkip()
		Loop
	EndIf
	If SRA->RA_SITFOLH $ "D" .AND. Mesano( SRA->RA_DEMISSA ) #Mesano( dDataRef )
		dbSkip()
		Loop
	EndIf
	
	//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
	//ณ Consiste controle de acessos e filiais validas				 |
	//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
	If !( SRA->RA_FILIAL $ fValidFil() ) .OR. !Eval( cAcessaSRA )
		dbSkip()
		Loop
	EndIf
	
	If SRA->RA_CODFUNC #cFuncaoAnt           // Descricao da Funcao
		DescFun( Sra->Ra_Codfunc, Sra->Ra_Filial )
		cFuncaoAnt:= Sra->Ra_CodFunc
	EndIf
	
	If SRA->RA_CC #cCcAnt                   // Centro de Custo
		DescCC( Sra->Ra_Cc, Sra->Ra_Filial )
		cCcAnt:=SRA->RA_CC
	EndIf
	
	If SRA->RA_Filial #cFilialAnt
		If ! Fp_CodFol( @aCodFol, Sra->Ra_Filial ) .OR. ! fInfo( @aInfo, Sra->Ra_Filial )
			Exit
		EndIf
		Desc_Fil := aInfo[3]
		Desc_End := aInfo[4]                // Dados da Filial
		Desc_CGC := aInfo[8]
		
		DESC_MSG1:= DESC_MSG2:= DESC_MSG3:= Space( 01 )
		
		// MENSAGENS
		If MENSAG1 #SPACE( 1 )
			If FPHIST82( SRA->RA_FILIAL, "06", SRA->RA_FILIAL+MENSAG1 )
				DESC_MSG1 := Left( SRX->RX_TXT, 30 )
			ElseIf FPHIST82( SRA->RA_FILIAL, "06", "  "+MENSAG1 )
				DESC_MSG1 := Left( SRX->RX_TXT, 30 )
			EndIf
		EndIf
		
		If MENSAG2 #SPACE( 1 )
			If FPHIST82( SRA->RA_FILIAL, "06", SRA->RA_FILIAL+MENSAG2 )
				DESC_MSG2 := Left( SRX->RX_TXT, 30 )
			ElseIf FPHIST82( SRA->RA_FILIAL, "06", "  "+MENSAG2 )
				DESC_MSG2 := Left( SRX->RX_TXT, 30 )
			EndIf
		EndIf
		
		If MENSAG3 #SPACE( 1 )
			If FPHIST82( SRA->RA_FILIAL, "06", SRA->RA_FILIAL+MENSAG3 )
				DESC_MSG3 := Left( SRX->RX_TXT, 30 )
			ElseIf FPHIST82( SRA->RA_FILIAL, "06", "  "+MENSAG3 )
				DESC_MSG3 := Left( SRX->RX_TXT, 30 )
			EndIf
		EndIf
		
		dbSelectArea( "SRA" )
				
		cFilialAnt := SRA->RA_FILIAL
		
	EndIf
	
	Totvenc := Totdesc := 0
	
	If nTipRec == 1 .OR. nTipRec == 2
		dbSelectArea( "SRC" )
		If dbSeek( SRA->RA_FILIAL + SRA->RA_MAT )
			While !Eof() .AND. SRC->RC_FILIAL+SRC->RC_MAT == SRA->RA_FILIAL+SRA->RA_MAT
				If SRC->RC_SEMANA #Semana
					dbSkip()
					Loop
				EndIf
				If !Eval( cAcessaSRC )
					dbSkip()
					Loop
				EndIf
				If ( nTipRec == 1 ) .AND. ( Src->Rc_Pd == aCodFol[7, 1] )      // Desconto de Adto
					fSomaPd( "P", aCodFol[6, 1], SRC->RC_HORAS, SRC->RC_VALOR )
					TOTVENC += Src->Rc_Valor
				ElseIf ( nTipRec == 1 ) .AND. ( Src->Rc_Pd == aCodFol[12, 1] )
					fSomaPd( "D", aCodFol[9, 1], SRC->RC_HORAS, SRC->RC_VALOR )
					TOTDESC += SRC->RC_VALOR
				ElseIf ( nTipRec == 1 ) .AND. ( Src->Rc_Pd == aCodFol[8, 1] )
					fSomaPd( "P", aCodFol[8, 1], SRC->RC_HORAS, SRC->RC_VALOR )
					TOTVENC += SRC->RC_VALOR
				Else
					If PosSrv( Src->Rc_Pd , SRA->RA_FILIAL , "RV_TIPOCOD" ) == "1"
						If ( nTipRec <> 1 ) .OR. ( nTipRec == 1 .AND. PosSrv( Src->Rc_Pd, Sra->Ra_Filial, "RV_ADIANTA" ) == "S" )
							fSomaPd( "P", SRC->RC_PD, SRC->RC_HORAS, SRC->RC_VALOR )
							TOTVENC += Src->Rc_Valor
						EndIf
					ElseIf PosSrv( Src->Rc_Pd , SRA->RA_FILIAL , "RV_TIPOCOD" ) == "2"
						If ( nTipRec #1 ) .OR. ( nTipRec == 1 .AND. PosSrv( Src->Rc_Pd, Sra->Ra_Filial, "RV_ADIANTA" ) == "S" )
							fSomaPd( "D", SRC->RC_PD, SRC->RC_HORAS, SRC->RC_VALOR )
							TOTDESC += Src->Rc_Valor
						EndIf
					ElseIf PosSrv( Src->Rc_Pd , SRA->RA_FILIAL , "RV_TIPOCOD" ) == "3"
						If ( nTipRec #1 ) .OR. ( nTipRec == 1 .AND. PosSrv( Src->Rc_Pd, Sra->Ra_Filial, "RV_ADIANTA" ) == "S" )
							fSomaPd( "B", SRC->RC_PD, SRC->RC_HORAS, SRC->RC_VALOR )
						EndIf
					EndIf
				EndIf
				If nTipRec = 1
					If SRC->RC_PD == aCodFol[10, 1]
						nBaseIr := SRC->RC_VALOR
					EndIf
				ElseIf SRC->RC_PD == aCodFol[13, 1]
					nAteLim += SRC->RC_VALOR
				ElseIf SRC->RC_PD$ aCodFol[108, 1]+'*'+aCodFol[17, 1]
					nBaseFgts += SRC->RC_VALOR
				ElseIf SRC->RC_PD$ aCodFol[109, 1]+'*'+aCodFol[18, 1]
					nFgts += SRC->RC_VALOR
				ElseIf SRC->RC_PD == aCodFol[15, 1]
					nBaseIr += SRC->RC_VALOR
				ElseIf SRC->RC_PD == aCodFol[16, 1]
					nBaseIrFe += SRC->RC_VALOR
				EndIf
				dbSelectArea( "SRC" )
				dbSkip()
			Enddo
		EndIf
	ElseIf nTipRec == 3
		dbSelectArea( "SRC" )
		If dbSeek( SRA->RA_FILIAL + SRA->RA_MAT )
			While !Eof() .AND. SRA->RA_FILIAL + SRA->RA_MAT == SRC->RC_FILIAL + SRC->RC_MAT
				If !Eval( cAcessaSRC )
					dbSkip()
					Loop
				EndIf
				If SRC->RC_PD == aCodFol[22, 1]
					fSomaPd( "P", SRC->RC_PD, SRC->RC_HORAS, SRC->RC_VALOR )
					TOTVENC += SRC->RC_VALOR
				ElseIf SRC->RC_PD == aCodFol[172, 1]
					fSomaPd( "D", SRC->RC_PD, SRC->RC_HORAS, SRC->RC_VALOR )
					TOTDESC += SRC->RC_VALOR
				ElseIf SRC->RC_PD == aCodFol[108, 1] .OR. SRC->RC_PD == aCodFol[109, 1] .OR. SRC->RC_PD == aCodFol[173, 1]
					fSomaPd( "B", SRC->RC_PD, SRC->RC_HORAS, SRC->RC_VALOR )
				EndIf
				
				If SRC->RC_PD == aCodFol[108, 1]
					nBaseFgts := SRC->RC_VALOR
				ElseIf SRC->RC_PD == aCodFol[109, 1]
					nFgts     := SRC->RC_VALOR
				EndIf
				dbSelectArea( "SRC" )
				dbSkip()
			Enddo
		EndIf
	ElseIf nTipRec == 4
		dbSelectArea( "SRI" )
		dbSetOrder( 2 )
		If dbSeek( SRA->RA_FILIAL + SRA->RA_CC + SRA->RA_MAT )
			While !Eof() .AND. SRA->RA_FILIAL + SRA->RA_CC + SRA->RA_MAT == SRI->RI_FILIAL + SRI->RI_CC + SRI->RI_MAT
				If !Eval( cAcessaSRI )
					dbSkip()
					Loop
				EndIf
				If PosSrv( SRI->RI_PD , SRA->RA_FILIAL , "RV_TIPOCOD" ) == "1"
					fSomaPd( "P", SRI->RI_PD, SRI->RI_HORAS, SRI->RI_VALOR )
					TOTVENC = TOTVENC + SRI->RI_VALOR
				ElseIf PosSrv( SRI->RI_PD , SRA->RA_FILIAL , "RV_TIPOCOD" ) == "2"
					fSomaPd( "D", SRI->RI_PD, SRI->RI_HORAS, SRI->RI_VALOR )
					TOTDESC = TOTDESC + SRI->RI_VALOR
				ElseIf PosSrv( SRI->RI_PD , SRA->RA_FILIAL , "RV_TIPOCOD" ) == "3"
					fSomaPd( "B", SRI->RI_PD, SRI->RI_HORAS, SRI->RI_VALOR )
				EndIf
				
				If SRI->RI_PD == aCodFol[19, 1]
					nAteLim += SRI->RI_VALOR
				ElseIf SRI->RI_PD$ aCodFol[108, 1]
					nBaseFgts += SRI->RI_VALOR
				ElseIf SRI->RI_PD$ aCodFol[109, 1]
					nFgts += SRI->RI_VALOR
				ElseIf SRI->RI_PD == aCodFol[27, 1]
					nBaseIr += SRI->RI_VALOR
				EndIf
				dbSkip()
			Enddo
		EndIf
	ElseIf nTipRec == 5
		dbSelectArea( "SR1" )
		dbSetOrder( 1 )
		If dbSeek( SRA->RA_FILIAL + SRA->RA_MAT )
			While !Eof() .AND. SRA->RA_FILIAL + SRA->RA_MAT ==	SR1->R1_FILIAL + SR1->R1_MAT
				If Semana #"99"
					If SR1->R1_SEMANA #Semana
						dbSkip()
						Loop
					EndIf
				EndIf
				If !Eval( cAcessaSR1 )
					dbSkip()
					Loop
				EndIf
				If PosSrv( SR1->R1_PD , SRA->RA_FILIAL , "RV_TIPOCOD" ) == "1"
					fSomaPd( "P", SR1->R1_PD, SR1->R1_HORAS, SR1->R1_VALOR )
					TOTVENC = TOTVENC + SR1->R1_VALOR
				ElseIf PosSrv( SR1->R1_PD , SRA->RA_FILIAL , "RV_TIPOCOD" ) == "2"
					fSomaPd( "D", SR1->R1_PD, SR1->R1_HORAS, SR1->R1_VALOR )
					TOTDESC = TOTDESC + SR1->R1_VALOR
				ElseIf PosSrv( SR1->R1_PD , SRA->RA_FILIAL , "RV_TIPOCOD" ) == "3"
					fSomaPd( "B", SR1->R1_PD, SR1->R1_HORAS, SR1->R1_VALOR )
				EndIf
				dbskip()
			Enddo
		EndIf
	EndIf
	
	dbSelectArea( "SRA" )
	
	If TOTVENC = 0 .AND. TOTDESC = 0
		dbSkip()
		Loop
	EndIf
	
	If Vez == 0  .AND.  nTipRec == 2 //--> Verifica se for FOLHA.
		PerSemana() // Carrega Datas referentes a Semana.
	EndIf
	                 	
	If  nTipRel == 4
		If lArqBDN
			GeraBDN1()
			GeraBDN2()
			GeraBDN3()
			GeraBDN4()
			GeraBDN5()
		EndIf
	EndIf
	
	If Vez = 0 .AND. nTipRel <> 4
		Pergunte( "GPR30A", .T. )
		If mv_par01 = 2 // Este mv_par e da "Pergunte" GPR30A"
			dbSelectArea( "SRA" )
			TOTDESC := TOTVENC := 0
			LOOP
		EndIf
		Vez = 1
	EndIf
	
	dbSelectArea( "SRA" )
	
	dbSkip()
	TOTDESC := TOTVENC := 0
ENDDO

If nTipRel == 4 .AND. lArqBDN
	GeraBDN9()
EndIf

//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
//ณ Seleciona arq. defaut do Siga caso Imp. Mov. Anteriores      ณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
If !lAtual
	fFimArqMov( cAliasMov , aOrdBag , cArqMov )
EndIf

//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
//ณ Termino do relatorio                                         ณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
dbSelectArea( "SRC" )
dbSetOrder( 1 )          // Retorno a ordem 1
dbSelectArea( "SRI" )
dbSetOrder( 1 )          // Retorno a ordem 1
dbSelectArea( "SRA" )
SET FILTER TO
RetIndex( "SRA" )

If !( Type( "cArqNtx" ) == "U" )
	fErase( cArqNtx + OrdBagExt() )
EndIf

Set Device To Screen

MS_FLUSH()

fClose(nHdl)
Close(GERAOK)



********************
Static Function PerSemana() // Pesquisa datas referentes a semana.()
********************

If !Empty( Semana )
	cChaveSem := StrZero( Year( dDataRef ), 4 )+StrZero( Month( dDataRef ), 2 )+SRA->RA_TNOTRAB
	If !Srx->( dbSeek( If( cFilial=="  ", "  ", SRA->RA_FILIAL ) + "01" + cChaveSem + Semana , .T. ) ) .AND. ;
		!Srx->( dbSeek( If( cFilial=="  ", "  ", SRA->RA_FILIAL ) + "01" + Subs( cChaveSem, 3, 9 ) + Semana , .T. ) ) .AND. ;
		!Srx->( dbSeek( If( cFilial=="  ", "  ", SRA->RA_FILIAL ) + "01" + Left( cChaveSem, 6 )+"999"+ Semana , .T. ) ) .AND. ;
		!Srx->( dbSeek( If( cFilial=="  ", "  ", SRA->RA_FILIAL ) + "01" + Subs( cChaveSem, 3, 4 )+"999"+ Semana , .T. ) ) .AND. ;
		HELP( " ", 1, "SEMNAOCAD" )
		Return NIL
	EndIf
	
	If Len( AllTrim( SRX->RX_COD ) ) == 9
		cSem_De  := Transforma( CtoD( Left( SRX->RX_TXT, 8 ) ), "DDMMYY" )
		cSem_Ate := Transforma( CtoD( Subs( SRX->RX_TXT, 10, 8 ) ), "DDMMYY" )
	Else
		cSem_De  := Transforma( If( "/" $ SRX->RX_TXT , CtoD( SubStr( SRX->RX_TXT, 1, 10 ) ) , StoD( SubStr( SRX->RX_TXT, 1, 8 ) ) ), "DDMMYY" )
		cSem_Ate := Transforma( If( "/" $ SRX->RX_TXT , CtoD( SubStr( SRX->RX_TXT, 12, 10 ) ), StoD( SubStr( SRX->RX_TXT, 12, 8 ) ) ), "DDMMYY" )
	EndIf
EndIf

Return NIL


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑฺฤฤฤฤฤฤฤฤฤฤยฤฤฤฤฤฤฤฤฤฤยฤฤฤฤฤฤฤยฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤยฤฤฤฤฤฤยฤฤฤฤฤฤฤฤฤฤฟฑฑ
ฑฑณFun…o    ณfSomaPd   ณ Autor ณ R.H. - Mauro          ณ Data ณ 24.09.95 ณฑฑ
ฑฑรฤฤฤฤฤฤฤฤฤฤลฤฤฤฤฤฤฤฤฤฤมฤฤฤฤฤฤฤมฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤมฤฤฤฤฤฤมฤฤฤฤฤฤฤฤฤฤดฑฑ
ฑฑณDescri…o ณ Somar as Verbas no Array                                   ณฑฑ
ฑฑรฤฤฤฤฤฤฤฤฤฤลฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤดฑฑ
ฑฑณSintaxe   ณ fSomaPd( Tipo, Verba, Horas, Valor )                            ณฑฑ
ฑฑรฤฤฤฤฤฤฤฤฤฤลฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤดฑฑ
ฑฑณParametrosณ                                                            ณฑฑ
ฑฑรฤฤฤฤฤฤฤฤฤฤมฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤดฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿*/
Static Function fSomaPd( cTipo, cPd, nHoras, nValor )
Local nPos
Local Desc_paga

Desc_paga := DescPd( cPd, Sra->Ra_Filial )  // mostra como pagto

If cTipo #'B'
	//--Array para Recibo Pre-Impresso
	nPos := Ascan( aLanca, { |X| X[2] = cPd } )
	If nPos == 0
		Aadd( aLanca, {cTipo, cPd, Desc_Paga, nHoras, nValor} )
	Else
		aLanca[nPos, 4] += nHoras
		aLanca[nPos, 5] += nValor
	EndIf
EndIf

//--Array para o Recibo Pre-Impresso
If cTipo = 'P'
	cArray := "aProve"
ElseIf cTipo = 'D'
	cArray := "aDesco"
ElseIf cTipo = 'B'
	cArray := "aBases"
EndIf

nPos := Ascan( &cArray, { |X| X[1] = cPd } )
If nPos == 0
	Aadd( &cArray, {cPd+" "+Desc_Paga, nHoras, nValor } )
Else
	&cArray[nPos, 2] += nHoras
	&cArray[nPos, 3] += nValor
EndIf

//nPos := 0
//If ( nPos := aScan( aTabVbHrs, { |x| x[5] == cPd } ) ) > 0
//	aAdd( aVerbHrs, { aTabVbHrs[nPos][5], nHoras } )
//EndIf

Return NIL


*-------------------------------------------------------
Static Function Transforma( dData ) //Transforma as datas no formato DD/MM/AAAA()
*-------------------------------------------------------
Return( StrZero( Day( dData ), 2 ) +"/"+ StrZero( Month( dData ), 2 ) +"/"+ Right( Str( Year( dData ) ), 4 ) )


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑฺฤฤฤฤฤฤฤฤฤฤยฤฤฤฤฤฤฤฤฤฤฤฤฤฤยฤฤฤฤฤฤฤยฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤยฤฤฤฤฤฤยฤฤฤฤฤฤฤฤฤฤฟฑฑ
ฑฑณFuno    ณ  GravaReg    ณ Autor ณ Jose Carlos       ณ Data ณ 15.09.99 ณฑฑ
ฑฑรฤฤฤฤฤฤฤฤฤฤลฤฤฤฤฤฤฤฤฤฤฤฤฤฤมฤฤฤฤฤฤฤมฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤมฤฤฤฤฤฤมฤฤฤฤฤฤฤฤฤฤดฑฑ
ฑฑณDescrio ณ Grava Registro                                             ณฑฑ
ฑฑรฤฤฤฤฤฤฤฤฤฤลฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤดฑฑ
ฑฑณSintaxe   ณ GravaReg                                                   ณฑฑ
ฑฑรฤฤฤฤฤฤฤฤฤฤลฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤดฑฑ
ฑฑณ Uso      ณ GeraRec                                                    ณฑฑ
ฑฑรฤฤฤฤฤฤฤฤฤฤมฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤดฑฑ
ฑฑณ         ATUALIZACOES SOFRIDAS DESDE A CONSTRU€AO INICIAL.             ณฑฑ
ฑฑรฤฤฤฤฤฤฤฤฤฤฤฤยฤฤฤฤฤฤฤฤยฤฤฤฤฤฤยฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤดฑฑ
ฑฑณProgramador ณ Data   ณ BOPS ณ  Motivo da Alteracao                     ณฑฑ
ฑฑรฤฤฤฤฤฤฤฤฤฤฤฤลฤฤฤฤฤฤฤฤลฤฤฤฤฤฤลฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤดฑฑ
ฑฑณ            ณ        ณ      ณ                                          ณฑฑ
ฑฑณ            ณ        ณ      ณ                                          ณฑฑ
ฑฑณ            ณ        ณ      ณ                                          ณฑฑ
ฑฑณ            ณ        ณ      ณ                                          ณฑฑ
ฑฑภฤฤฤฤฤฤฤฤฤฤฤฤมฤฤฤฤฤฤฤฤมฤฤฤฤฤฤมฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤูฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ/*/
Static Function GravaReg

If fWrite( nHdl, cReg, Len( cReg ) ) <> Len( cReg )
	If !MsgYesNo( 'Ocorreu um erro na gravao do arquivo '+AllTrim( cNomeArq )+'.   Continua?', 'Ateno!' )
		lContinua := .F.
		Return NIL
	EndIf
EndIf

Return NIL


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑฺฤฤฤฤฤฤฤฤฤฤยฤฤฤฤฤฤฤฤฤฤฤฤฤฤยฤฤฤฤฤฤฤยฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤยฤฤฤฤฤฤยฤฤฤฤฤฤฤฤฤฤฟฑฑ
ฑฑณFuno    ณ VerPerg      ณ Autor ณ Fernando Joly     ณ Data ณ 15.06.98 ณฑฑ
ฑฑรฤฤฤฤฤฤฤฤฤฤลฤฤฤฤฤฤฤฤฤฤฤฤฤฤมฤฤฤฤฤฤฤมฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤมฤฤฤฤฤฤมฤฤฤฤฤฤฤฤฤฤดฑฑ
ฑฑณDescrio ณ Verifica as perguntas, Incluindo-as caso no existam       ณฑฑ
ฑฑภฤฤฤฤฤฤฤฤฤฤฤฤมฤฤฤฤฤฤฤฤมฤฤฤฤฤฤมฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤูฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿*/
Static Function VerPerg()

aRegs     := {}

cPerg := Left( cPerg, 6 )

aAdd( aRegs, {cPerg, "01", "Data de Refer๊ncia ?", "ฟFecha Referencia?", "Reference Date ?", "mv_ch1", "D", 8, 0, 0, "G", "naovazio", "mv_par01", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "S", "", ""} )
aAdd( aRegs, {cPerg, "02", "Data do Credito ?", "Data do Credito ?", "Data do Credito ?", "mv_ch2", "D", 8, 0, 0, "G", "naovazio", "mv_par02", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "S", "", ""} )
aAdd( aRegs, {cPerg, "03", "Imprimir Recibos ?", "ฟImprimir Facturas?", "Print Receipts ?", "mv_ch3", "N", 1, 0, 2, "C", "", "mv_par03", "Adto.", "Anticipo", "Advance", "", "", "Folha", "Liquidacion", "Payroll", "", "", "1ฆParc.", "1a Cuota", "1st Installment", "", "", "2ฆParc.", "2a Cuota", "2nd Installment", "", "", "Val.Extras", "Vlr. Extras", "Extra Val.", "", "", "S", "", ""} )
aAdd( aRegs, {cPerg, "04", "Numero da Semana ?", "ฟNum.de la Semana?", "Week Number ?", "mv_ch4", "C", 2, 0, 0, "G", "", "mv_par04", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "S", "", ""} )
aAdd( aRegs, {cPerg, "05", "Filial De ?", "ฟDe Filial?", "From Branch ?", "mv_ch5", "C", 2, 0, 0, "G", "naovazio", "mv_par05", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "XM0", "S", "", ""} )
aAdd( aRegs, {cPerg, "06", "Filial At้ ?", "ฟA Filial?", "To Branch ?", "mv_ch6", "C", 2, 0, 0, "G", "naovazio", "mv_par06", "", "", "", "ZZ", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "XM0", "S", "", ""} )
aAdd( aRegs, {cPerg, "07", "Centro de Custo De ?", "ฟDe Centro de Costo?", "From Cost Center ?", "mv_ch7", "C", 10, 0, 0, "G", "naovazio", "mv_par07", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "CTT", "S", "004", ""} )
aAdd( aRegs, {cPerg, "08", "Centro de Custo At้ ?", "ฟA  Centro de Costo?", "To Cost Center ?", "mv_ch8", "C", 10, 0, 0, "G", "naovazio", "mv_par08", "", "", "", "ZZZZZZZZZ", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "CTT", "S", "004", ""} )
aAdd( aRegs, {cPerg, "09", "Matricula De ?", "ฟDe Matricula?", "From Registration ?", "mv_ch9", "C", 6, 0, 0, "G", "naovazio", "mv_par09", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "SRA", "S", "", ""} )
aAdd( aRegs, {cPerg, "10", "Matricula At้ ?", "ฟA  Matricula?", "To Registration ?", "mv_cha", "C", 6, 0, 0, "G", "naovazio", "mv_par10", "", "", "", "ZZZZZZ", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "SRA", "S", "", ""} )
aAdd( aRegs, {cPerg, "11", "Nome De ?", "ฟDe Nombre?", "From Name ?", "mv_chb", "C", 30, 0, 0, "G", "naovazio", "mv_par11", "", "", "", "AAAAAAAAAAAAAAAAAAAAAAAAAAAAAA", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "S", "", ""} )
aAdd( aRegs, {cPerg, "12", "Nome At้ ?", "ฟA  Nombre?", "To Name ?", "mv_chc", "C", 30, 0, 0, "G", "naovazio", "mv_par12", "", "", "", "ZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZ", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "S", "", ""} )
aAdd( aRegs, {cPerg, "13", "Situa็๖es a Imp. ?", "ฟSituaciones a Imp.?", "Situations to Print ?", "mv_chd", "C", 5, 0, 0, "G", "fSituacao", "mv_par13", "", "", "", " ADFT", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "S", "", ""} )
aAdd( aRegs, {cPerg, "14", "Categorias a Imp. ?", "ฟCategorias a Imp.?", "Categories to Print ?", "mv_che", "C", 15, 0, 0, "G", "fCategoria", "mv_par14", "", "", "", "ACDEGHMPST", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "S", "", ""} )
aAdd( aRegs, {cPerg, "15", "Arquivo de Saida ?", "Arquivo de Saida ?", "Arquivo de Saida?", "mv_chf", "C", 30, 0, 0, "G", "", "mv_par15", "", "", "", "A:\RECIBO.TXT", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", ""} )
aAdd( aRegs, {cPerg, "16", "Arquivo p/ BDN?", "ฟArquivo p/ BDN?", "BDN File ?", "mv_chg", "N", 1, 0, 1, "C", "", "mv_par16", "Sim", "Si", "Yes", "", "", "Nao", "No", "No", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "S", "", ""} )
aAdd( aRegs, {cPerg, "17", "Operacao p/ BDN?", "ฟOperacion p/ BDN?", "BDN Operation ?", "mv_chh", "N", 1, 0, 1, "C", "", "mv_par17", "Inclusao", "Inclusao", "Inclusao", "", "", "Substituicao", "Substituicao", "Substituicao", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "S", "", ""} )
aAdd( aRegs, {cPerg, "18", "Num. Lote Orig. p/ Subs. BDN?", "Num. Lote Orig. p/ Subs. BDN?", "Num. Lote Orig. p/ Subs. BDN?", "mv_chi", "C", 9, 0, 0, "G", "", "mv_par18", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", ""} )
aAdd( aRegs, {cPerg, "19", "Cod. Empresa no BDN ?", "Cod. Empresa no BDN ?", "Cod. Empresa no BDN ?", "mv_chj", "C", 9, 0, 0, "G", "", "mv_par19", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", ""} )
aAdd( aRegs, {cPerg, "20", "Mensagem 1 ?", "ฟMensaje 1?", "Message 1 ?", "mv_chk", "C", 1, 0, 0, "G", "", "mv_par20", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "S", "", ""} )
aAdd( aRegs, {cPerg, "21", "Mensagem 2 ?", "ฟMensaje 2?", "Message 2 ?", "mv_chl", "C", 1, 0, 0, "G", "", "mv_par21", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "S", "", ""} )
aAdd( aRegs, {cPerg, "22", "Mensagem 3 ?", "ฟMensaje 3?", "Message 3 ?", "mv_chm", "C", 1, 0, 0, "G", "", "mv_par22", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "S", "", ""} )
aAdd( aRegs, {cPerg, "23", "Tipo de Remessa  ?", "Tipo de Remessa  ?", "Tipo de Remessa  ?", "mv_chn", "N", 1, 0, 2, "C", "", "mv_par23", "Teste", "Teste", "Teste", "", "", "Producao", "Producao", "Producao", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", ""} )


ValidPerg( aRegs, cPerg , .F. )

Return NIL


//Fim do Programa


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบRotina    ณ GeraBDN0 บAutor  ณ Ernani Forastieri  บ Data ณ  25/08/05   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDescricao ณ Geracao de Registro Tipo 0 para hollerith eletronico BDN   บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ                                                 บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
Static Function GeraBDN0()
cNum := GetMV( 'FS_SEQBDN',, '000000000' )

If lEhIncBDN
	cNum  := Soma1( cNum )
Else

	cNum  := MV_PAR17
EndIf
nSeq_++

FWrite( nHdl, GeraLinhas( aTipo0 ) )
nTotRLote++

Return NIL


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบRotina    ณ GeraBDN1 บAutor  ณ Ernani Forastieri  บ Data ณ  25/08/05   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDescricao ณ Geracao de Registro Tipo 1 para hollerith eletronico BDN   บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ			                                                  บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
Static Function GeraBDN1()
Local   cAux       := ''
Private cCtaFunc   := ''
Private cDgCtaFunc := ''
Private cNumCP     := ''

cAux       := AllTrim( SRA->RA_CTDEPSA )
cCtaFunc   := SubStr( cAux, 1, Len( cAux  ) - 1 )
cDgCtaFunc := SubStr( cAux, Len( cAux ), 1 )
cNumCP     := StrZero( Val( SRA->RA_NUMCP ), 6 ) + IIF(!Empty(SRA->RA_UFCP), "-" + SRA->RA_UFCP, "" )

nSeq_++
FWrite( nHdl, GeraLinhas( aTipo1 ) )
nTotRLote++

Return NIL


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบRotina    ณ GeraBDN2 บAutor  ณ Ernani Forastieri  บ Data ณ  25/08/05   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDescricao ณ Geracao de Registro Tipo 2 para hollerith eletronico BDN   บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ    		                                                  บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
Static Function GeraBDN2()
Local   nI       := 1
Local   aVerbas  := {}
Local   nPos     := 0
Local   nLiquido := 0
			Local   lGravou  := .F.
Local   nJ       := 0

Private cCodLan  := ''
Private cDescLan := ''
Private nValLan  := 0
Private cIdLan   := ''

nQtdComp         := 0

For nI := 1 To 2
	aVerbas := IIf( nI == 1, aClone( aProve ), aClone( aDesco ) )
	lGravou := .F.
	nTot    := 0
	
	For nJ := 1 To Len( aVerbas )
		nSeq_++
		cCodLan    := SubStr( aVerbas[nJ][1], 1, 3 )
		cDescLan   := SubStr( aVerbas[nJ][1], 5 )
		nValLan    := aVerbas[nJ][3]
		cIdLan     := IIf( nI == 1, 1, 3 )
		
		lGravou := .T.
		FWrite( nHdl, GeraLinhas( aTipo2 ) )
		nQtdComp++
		nTotRLote++
	Next
	
	// Total
	If  nI == 1
		cCodLan    := '399'
		cDescLan   := 'TOTAL CREDITOS'
		cIdLan     := 2
		nValLan    := TOTVENC
	Else
		cCodLan    := '699'
		cDescLan   := 'TOTAL DEBITOS'
		cIdLan     := 4
		nValLan    := TOTDESC
	EndIf
	
	nSeq_++
	FWrite( nHdl, GeraLinhas( aTipo2 ) )
	nQtdComp++
	nTotRLote++
	
Next

If lGravou
	
	If nTipRec == 4
		// Liquido 2. Parcela
		cCodLan    := '849'
	Else
		// Liquido Folha
		cCodLan    := '850'
	EndIf
	
	cDescLan   := 'TOTAL LIQUIDO'
	cIdLan     := 5
	nValLan    := TOTVENC-TOTDESC
	
	If ( nPos := aScan( aBases, { |x| SubStr( x[1], 1, 3 ) == cCodLan } ) ) > 0
		nValLan := aBases[nPos][3]
	EndIf
	
	nSeq_++
	FWrite( nHdl, GeraLinhas( aTipo2 ) )
	nQtdComp++
	nTotRLote++
EndIf

Return NIL


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบRotina    ณ GeraBDN3 บAutor  ณ Ernani Forastieri  บ Data ณ  25/08/05   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDescricao ณ Geracao de Registro Tipo 3 para hollerith eletronico BDN   บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ			                                                  บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
Static Function GeraBDN3()
Local   nI       := 1
Local   cCpo     := 'Desc_Msg'
Local   nMesAniv := 0
//Local   nQtdVerb := Len( aVerbHrs )
Local   cMsgVrb  := ''
Private cMsg     := ''

//cMsg := 'FGTS - ' + AllTrim( Transform( nFgts, '@e 99,999,999.99' ) )
//nSeq_++
//FWrite( nHdl, GeraLinhas( aTipo3 ) )
//nQtdComp++
//nTotRLote++

nMesAniv = IIf( Month( dDataRef ) + 1 > 12, 01, Month( dDataRef ) )
IF nMesAniv = Month( SRA->RA_NASC )
	cMsg := STR0038		//"F E L I Z   A N I V E R S A R I O  ! !"
	nSeq_++
	FWrite( nHdl, GeraLinhas( aTipo3 ) )
	nQtdComp++
	nTotRLote++
EndIf

For nI := 1 To 2
	cMsg := AllTrim( &( cCpo+Str( nI, 1 ) ) )
	
	If !Empty( cMsg )
		nSeq_++
		FWrite( nHdl, GeraLinhas( aTipo3 ) )
		nQtdComp++
		nTotRLote++
	EndIf
	
Next


// Verbas de Horas
/*
COD T   QTDE  COD T   QTDE  COD T   QTDE
999 H 999,99/ 999 H 999,99/ 999 H 999,99


If nQtdVerb > 0
	// Mensagem 5
	If     nQtdVerb == 1
		cMsg := 'COD T   QTDE                            '
	ElseIf nQtdVerb == 2
		cMsg := 'COD T   QTDE  COD T   QTDE              '
	Else
		cMsg := 'COD T   QTDE  COD T   QTDE  COD T   QTDE'
	EndIf
	
	nSeq_++
	FWrite( nHdl, GeraLinhas( aTipo3 ) )
	nQtdComp++
	nTotRLote++
	                       	
	cMsgVrb := ''  
	//aEval( aVerbHrs, {|x,y|	cMsgVrb += IIf( y == 1, '', '/ ' ) + x[1] + ' H ' + Transform( x[2], '@E 999.99' ) } )

	// Mensagem 6
	cMsg := PADR( SubStr( cMsgVrb, 1, 40 ), 40 )
	If !Empty( cMsg )
		nSeq_++
		FWrite( nHdl, GeraLinhas( aTipo3 ) )
		nQtdComp++
		nTotRLote++
	EndIf
	
	// Mensagem 7
	cMsg := PADR( SubStr( cMsgVrb, 43, 40 ), 40 )
	If !Empty( cMsg )
		nSeq_++
		FWrite( nHdl, GeraLinhas( aTipo3 ) )
		nQtdComp++
		nTotRLote++
	EndIf
	
EndIf
*/
Return NIL


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบRotina    ณ GeraBDN4 บAutor  ณ Ernani Forastieri  บ Data ณ  25/08/05   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDescricao ณ Geracao de Registro Tipo 4 para hollerith eletronico BDN   บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ			                                                  บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿'฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
Static Function GeraBDN4()
nSeq_++
FWrite( nHdl, GeraLinhas( aTipo4 ) )
nQtdComp++
nTotRLote++
Return NIL

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบRotina    ณ GeraBDN5 บAutor  ณ Ernani Forastieri  บ Data ณ  25/08/05   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDescricao ณ Geracao de Registro Tipo 5 para hollerith eletronico BDN   บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ			                                                  บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
Static Function GeraBDN5()
nSeq_++
FWrite( nHdl, GeraLinhas( aTipo5 ) )
nTotRLote++
Return NIL


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบRotina    ณ GeraBDN9 บAutor  ณ Ernani Forastieri  บ Data ณ  25/08/05   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDescricao ณ Geracao de Registro Tipo 9 para hollerith eletronico BDN   บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ			                                                  บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
Static Function GeraBDN9()
nSeq_++
nTotRLote++
FWrite( nHdl, GeraLinhas( aTipo9 ) )

If lEhIncBDN
	PutMV( 'FS_SEQBDN', cNum  )
EndIf


Return NIL


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบRotina    ณGeralinhasบAutor  ณ Ernani Forastieri  บ Data ณ  25/08/05   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDescricao ณ Geracao de linhas de texto                                 บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ			                                                  บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
Static Function GeraLinhas( aTipo )
Local cLinha     := ''
Local nTamMaxLin := 250
Local nI         := 0

For nI := 1 To Len( aTipo )
	bAux      := &( '{ || ' + aTipo[nI][7] + ' } ' )
	
	cTipo     := aTipo[nI][4]
	nTamanho  := aTipo[nI][5]
	nDecimal  := aTipo[nI][6]
	
	uConteudo := EVal( bAux )
	uConteudo := IIf( ValType( uConteudo ) == 'U' , '', EverChar( uConteudo ) )
	
	If     cTipo == 'C'
		uConteudo := PADR( SubStr( AllTrim( uConteudo ), 1, nTamanho ), nTamanho )
		
	ElseIf cTipo == 'N'
		uConteudo := StrZero( Val( uConteudo ) * (10^nDecimal) , nTamanho )
		
	EndIf
	
	cLinha += uConteudo
	
Next

cLinha += Replicate( ' ', nTamMaxLin - Len( cLinha ) ) + cQuebraLin

Return cLinha                                           

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบRotina    ณ EVERCHAR บAutor  ณ Ernani Forastieri  บ Data ณ  13/09/04   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDescricao ณ Funcao auxiliar para transformar um campo de qualquer tipo บฑฑ
ฑฑบ          ณ em caracter                                                บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ Generico                                                   บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
Static Function EverChar( uCpoConver )

Local cRet  := NIL
Local cTipo := ''

cTipo := ValType( uCpoConver )

If     cTipo == 'C'                    // Tipo Caracter
	cRet := uCpoConver
	
ElseIf cTipo == 'N'                    // Tipo Numerico
	cRet := AllTrim( Str( uCpoConver ) )
	
ElseIf cTipo == 'L'                    // Tipo Logico
	cRet := IIf( uCpoConver, '.T.', '.F.' )
	
ElseIf cTipo == 'D'                    // Tipo Data
	cRet := DToC( uCpoConver )
	
ElseIf cTipo == 'M'                    // Tipo Memo
	cRet := 'MEMO'
	
ElseIf cTipo == 'A'                    // Tipo Array
	cRet := 'ARRAY[' + AllTrim( Str( Len( uCpoConver ) ) ) + ']'
	
ElseIf cTipo == 'U'                    // Indefinido
	cRet := 'NIL'
	
EndIf

Return(cRet)