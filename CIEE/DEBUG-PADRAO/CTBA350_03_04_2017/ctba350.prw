#Include "CTBA350.Ch"
#Include "PROTHEUS.Ch"

#DEFINE D_PRELAN	"9"

STATIC __lBlind  := IsBlind()
STATIC __cTEMPOS := ""
STATIC __aRptLog := {}

STATIC lAtSldBase
STATIC lCusto
STATIC lItem
STATIC lClVl
STATIC lCtb350Ef
STATIC lEfeLanc
STATIC lCT350QRY
STATIC lCT350TRC
STATIC lCT350TSL
STATIC nQtdEntid
STATIC lUsaProc := .F.

//Atualiza��o CTC e CT6

/*/
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������Ŀ��
���Fun��o    � CTBA350  � Autor � Simone Mie Sato       � Data � 14/05/01 ���
�������������������������������������������������������������������������Ĵ��
���Descri��o � Efetiva os pre-lancamentos                                 ���
�������������������������������������������������������������������������Ĵ��
���Sintaxe   � CTBA350()                                                  ���
�������������������������������������������������������������������������Ĵ��
���Retorno   � Nenhum                                                     ���
�������������������������������������������������������������������������Ĵ��
���Uso       � SIGACTB                                                    ���
�������������������������������������������������������������������������Ĵ��
���Parametros� Nenhum                                                     ���
��������������������������������������������������������������������������ٱ�
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
/*/
Function CTBA350()

Local nOpca 	:= 0
Local aSays 	:= {}, aButtons := {}
Local aCampos	:= {{"DDATA","C",10,0},;
					{"LOTE","C",Len(CriaVar("CT2_LOTE")),0},;
					{"DOC","C",Len(CriaVar("CT2_DOC")),0},;
					{"MOEDA","C",Len(CriaVar("CT2_MOEDLC")),0},;
					{"VLRDEB","N",16,2},;
					{"VLRCRD","N",16,2},;
					{"DESCINC","C",80,0}}

Local cArqTrab  := ""
Local cChave 	:= ""
Local lRet		:= .T.
Local aPergs	:= {}
Local aHelpPor	:= {}
Local aHelpEsp	:= {}
Local aHelpEng	:= {}
Local nCont		:= 0
Local nX
Local nThread	:= GetNewPar( "CTB350THR", 10 )
Local nSeconds	:= 0

Private cCadastro := OemToAnsi(OemtoAnsi(STR0001))  //"Efetivacao de Pre-Lancamentos"

PRIVATE wnrel
PRIVATE cString   	:= "CT2"
PRIVATE cDesc1    	:= OemToAnsi(STR0002)  //"Esta rotina ir� efetivar os Pre-lancamentos e emitir"
PRIVATE cDesc2    	:= OemToAnsi(STR0003)  //"o log da efetivacao. "
PRIVATE cDesc3    	:= ""
PRIVATE titulo    	:= OemToAnsi(STR0004)  //"Log Validacao Efetivacao"
PRIVATE cCancel   	:= OemToAnsi(STR0006)  //"***** CANCELADO PELO OPERADOR *****"
PRIVATE aReturn   	:= { OemToAnsi(STR0007), 1, OemToAnsi(STR0008), 2, 2, 1, "",1 }  //"Zebrado"###"Administracao"
PRIVATE nomeprog  	:= "CTBA170"
PRIVATE aLinha    	:= { },nLastKey := 0

//���������������������������������������������������������������������������Ŀ
//� Definicao do Cabecalho.                                                   �
//�����������������������������������������������������������������������������
//          1         2         3         4         5         6         7         8         9        10        11        12        13        14        15        16        17        18        19        20        21        22
//0123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012
PRIVATE cabec1    	:= OemToAnsi(STR0005)		  // DATA    LOTE     DOC      MOEDA         VALOR DEBITO      VALOR CREDITO  INCONSISTENCIA
PRIVATE cabec2    	:= " "

Private aCtbEntid
If ( !AMIIn(34) )		// Acesso somente pelo SIGACTB
	Return
EndIf

If nQtdEntid == NIL
	nQtdEntid := If(FindFunction("CtbQtdEntd"),CtbQtdEntd(),4) //sao 4 entidades padroes -> conta /centro custo /item contabil/ classe de valor
EndIf

If aCtbEntid == NIL
	aCtbEntid := Array(2,nQtdEntid)  //posicao 1=debito  2=credito
EndIf

//DEBITO
aCtbEntid[1,1] := {|| TMP->CT2_DEBITO   }
aCtbEntid[1,2] := {|| TMP->CT2_CCD      }
aCtbEntid[1,3] := {|| TMP->CT2_ITEMD    }
aCtbEntid[1,4] := {|| TMP->CT2_CLVLDB   }
//CREDITO
aCtbEntid[2,1] := {|| TMP->CT2_CREDITO  }
aCtbEntid[2,2] := {|| TMP->CT2_CCC      }
aCtbEntid[2,3] := {|| TMP->CT2_ITEMC    }
aCtbEntid[2,4] := {|| TMP->CT2_CLVLCR   }

For nX := 5 TO nQtdEntid
	aCtbEntid[1, nX] := MontaBlock("{|| TMP->CT2_EC"+StrZero(nX,2)+"DB } ")  //debito
	aCtbEntid[2, nX] := MontaBlock("{|| TMP->CT2_EC"+StrZero(nX,2)+"CR } ")  //credito
Next

lAtSldBase	:= ( GetMv("MV_ATUSAL") == "S" )
lCusto		:= CtbMovSaldo("CTT")
lItem 		:= CtbMovSaldo("CTD")
lClVl		:= CtbMovSaldo("CTH")
lCtb350Ef	:= ExistBlock("CTB350EF")
lEfeLanc 	:= ExistBlock("EFELANC")
lCT350QRY	:= GetNewPar( "MV_CT350QY", .T.)			///PARAMETRO N�O PUBLICADO NA CRIA��O (15/03/07-BOPS120975)
lCT350TRC	:= GetNewPar( "MV_CT350TC", .F.)			///PARAMETRO N�O PUBLICADO NA CRIA��O (15/03/07-BOPS120975)
lCT350TSL	:= GetNewPar( "MV_CT350SL", .T.)			///PARAMETRO N�O PUBLICADO NA CRIA��O (15/03/07-BOPS120975)


CtAjustSx1( "CTB350" ) // ajusta as perguntas("CTB350", aPergs)

//��������������������������������������������������������������Ŀ
//� Variaveis utilizadas para parametros                         �
//� mv_par01 // Numero do Lote Inicial                           �
//� mv_par02 // Numero do Lote Final                             �
//� mv_par03 // Data Inicial									 �
//� mv_par04 // Data Final										 �
//� mv_par05 // Efetiva sem Bater Lote?   				         �
//� mv_par06 // Efetiva sem Bater Documento?                     �
//� mv_par07 // Efetiva para sald?Real/Gerencial/Orcado          �
//� mv_par08 // Verifica entidades contabeis?                    �
//� mv_par09 // SubLote Inicial?                                 �
//� mv_par10 // SubLote Final?                                   �
//� mv_par11 // Mostra Lancamento Contabil?  Sim/Nao			 �
//� mv_par12 // Modo Processamento							  	 �
//� mv_par13 // Documento Inicial 				 				 �
//� mv_par14 // Documento Final					 				 �
//����������������������������������������������������������������

Pergunte( "CTB350" , .F. )

AADD(aSays,OemToAnsi( STR0002 ) )//"Transfere os lancamentos indicados com status pre-lancamento (que nao controla saldos)"
AADD(aSays,OemToAnsi( STR0003 ) )//"para o saldo informado, acompanhando relatorio de confirmacao do processamento."

//��������������������������������������������������������������Ŀ
//� Inicializa o log de processamento                            �
//����������������������������������������������������������������
ProcLogIni( aButtons )

AADD(aButtons, { 5,.T.,{|| Pergunte("CTB350",.T. ) } } )
AADD(aButtons, { 1,.T.,{|| nOpca:= 1, If( ConaOk(), FechaBatch(), nOpca:=0 ) }} )
AADD(aButtons, { 2,.T.,{|| FechaBatch() }} )

PcoIniLan("000082")

FormBatch( cCadastro, aSays, aButtons,, 160 )

//������������������������������������������������������������Ŀ
//� Crio arq. de trab. p/ gravar as inconsistencias.           �
//��������������������������������������������������������������
//cArqTrab		:= CriaTrab(,.F.)
cChave 			:= "TRB350REL->DDATA+TRB350REL->LOTE+TRB350REL->DOC"

CriaTmp(aCampos,{cChave})


dbSelectArea( "TRB350REL" )
dbSetOrder(1)

IF nOpca == 1
	//Verificar se o calendario esta aberto para poder efetuar a efetivacao.
	//Somente verificar a data inicial.
	For nCont := 1 To __nQuantas
		If CtbExisCTE( StrZero(nCont,2),Year(mv_par03) )
			
			lRet := CtbStatus(StrZero(nCont,2),mv_par03,mv_par04, .F.)
			If !lRet
				nOpca	:= 0
				Exit
			EndIf
		Endif
	Next
	
	If ! lCT350TSL
		MsgInfo(STR0061,STR0062) //"Ap�s as efetiva��es do periodo, para emissao de relat�rios executar 'Reprocessamento de Saldos' do periodo/data.","ATEN��O ! At. de saldos desligada, MV_CT350SL (L) = F "
		lAtSldBase := .F.
	EndIf
	
	#IFNDEF TOP
		If nThread > 1
			Help(" ",1,"NONDBACCESS" ,,"Rotina de efetiva��o multithread � exclusiva para ambientes com Banco de dados Relacional (SGDB). A rotina ser� executada de forma padr�o." ,3,0)	
			nThread := 1
		Endif
	#ENDIF
EndIf

IF nOpca == 1
	nSeconds := Seconds()
	Conout("INICIO|" + dtoc(dDatabase) + "|" + Time() + "|" + Str(nSeconds))

	#IFDEF TOP
		// efetuo a cria��o da procedure que ir� alimentar os dados para o relatorio.
		lUsaProc := CtbCriaProc()
	#ENDIF

	If FindFunction("CTBSERIALI")
		While !CTBSerialI("CTBPROC","ON")
		EndDo
	EndIf
	//�����������������������������������Ŀ
	//� Atualiza o log de processamento   �
	//�������������������������������������
	ProcLogAtu("INICIO")
	lEnd := .F.
	If nThread <= 1
		Processa({|lEnd| Ctb350Proc(@lEnd)},cCadastro)
	Else
		Processa({|lEnd| Ctb351Proc(@lEnd)},cCadastro)
	Endif
	
	CTBSerialF("CTBPROC","ON")
	//�����������������������������������Ŀ
	//� Atualiza o log de processamento   �
	//�������������������������������������
	ProcLogAtu("FIM")

	If lUsaProc
		If TCSPExist("CTB350REL_" + cEmpAnt )
			CtbSqlExec( "Drop procedure CTB350REL_" + cEmpAnt )
		Endif	
	Endif

	Conout("TERMINO|" + dtoc(dDatabase) + "|" + Time() + "|" + Str(Seconds()) + "| Tempo GASTO:" + Str(Seconds() - nSeconds) )
Endif

PcoFinLan("000082")

// efetua a exclus�o do arquivo temporario
DeleteTmp( "TRB350REL" )

dbSelectArea("CT2")
dbSetOrder(1)

Return

/*/
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������Ŀ��
���Fun��o    �Ctb350Proc� Autor � Simone Mie Sato       � Data � 14.05.01 ���
�������������������������������������������������������������������������Ĵ��
���Descri��o � Efetua os Lancamentos para efetivacao                      ���
�������������������������������������������������������������������������Ĵ��
���Sintaxe   � Ctb350Proc()                                               ���
�������������������������������������������������������������������������Ĵ��
���Retorno   � Nenhum                                                     ���
�������������������������������������������������������������������������Ĵ��
��� Uso      � Generico                                                   ���
�������������������������������������������������������������������������Ĵ��
���Parametros� Nenhum                                                     ���
��������������������������������������������������������������������������ٱ�
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
/*/
Function Ctb350Proc(lEnd)

Local cTpSldAtu 	:= mv_par07	//Efetiva p/ que saldo?
Local nValor		:= 0
Local nVlrDeb		:= 0
Local nVlrCrd		:= 0
Local lLoteOk		:= .T.
Local lDocOk		:= .T.
Local lEfLote		:= Iif(mv_par05 == 1,.T.,.F.)//.T. ->Efetiva sem bater Lote / .F. ->Nao efetiva sem bater Lote
Local lEfDoc		:= Iif(mv_par06 == 1,.T.,.F.)//.T. ->Efetiva sem bater Doc / .F. ->Nao efetiva sem bater Doc
Local lProcessa		:= .F. 						//Indica se processou algum lote
Local cDescInc		:= ""
Local cLoteAnt		:= ""
Local cDocAnt		:= ""
Local dDataAnt		:= CTOD("  /  /  ")
Local aErro
Local aErroTexto 	:= {}
Local nCont

Local lMostraLct	:= ( mv_par11 == 1 )
Local lSimula		:= ( mv_par12 == 2 )
Local lTemIncons	:= .F.
Local nPriLinCT2    := 1
Local cLancAnt
Local nRecCT2
Local aLctProc

//Utilizados na CTBA105
PRIVATE INCLUI 		:= .F.
PRIVATE ALTERA 		:= .T.
PRIVATE DELETA 		:= .F.

// Variaveis utilizadas na fun��o CT105LINOK()
PRIVATE __lCusto	:= CtbMovSaldo("CTT")
PRIVATE __lItem		:= CtbMovSaldo("CTD")
PRIVATE __lCLVL		:= CtbMovSaldo("CTH")

PRIVATE dDataLanc	:= {}
PRIVATE OPCAO	:= 3

__aRptLog := {}

lAtSldBase	:= ( GetMv("MV_ATUSAL") == "S" )
lCusto		:= CtbMovSaldo("CTT")
lItem 		:= CtbMovSaldo("CTD")
lClVl		:= CtbMovSaldo("CTH")
lCtb350Ef	:= ExistBlock("CTB350EF")
lEfeLanc 	:= ExistBlock("EFELANC")
lCT350QRY	:= GetNewPar( "MV_CT350QY", .T.)			///PARAMETRO N�O PUBLICADO NA CRIA��O (15/03/07-BOPS120975)
lCT350TRC	:= GetNewPar( "MV_CT350TC", .F.)			///PARAMETRO N�O PUBLICADO NA CRIA��O (15/03/07-BOPS120975)
lCT350TSL	:= GetNewPar( "MV_CT350SL", .T.)			///PARAMETRO N�O PUBLICADO NA CRIA��O (15/03/07-BOPS120975)

If lMostraLct .and. lSimula
	If !IsBlind()
		If MsgYesNo(STR0064,cCadastro)//"Nao � permitido modo 'Simula��o' exibindo lan�amentos, continua Simula��o sem exibir lan�amentos ?"
			lMostraLct	:= .F.
			mv_par11 	:= 2
		Else
			Return
		EndIf
	Else
		Return
	EndIf
EndIf

If lSimula
	If !IsBlind()
		If !MsgYesNo(STR0065,Alltrim(cCadastro)+ STR0066)//"Neste modo apenas serao listadas se houverem inconsist�ncias, os lan�amentos mesmo que v�lidos nao serao efetivados neste modo. Continua Simula��o ?"##" Modo Simula��o "
			Return
		EndIf
	EndIf
EndIf


xCONOUT("|INI CTB350PROC !")
If mv_par11 == 1
	//
	// Se mostra Lancamentos Contabeis, declarar variaveis utilizadas na rotina dos lancamentos
	//
	Private aRotina := {{},{},{},	{STR0004 ,"Ctba102Cal", 0 , 4} } // "Alterar"
	
	Private cLote
	Private cLoteSub := GetMv("MV_SUBLOTE")
	Private cSubLote := cLoteSub
	Private lSubLote := Empty(cSubLote)
	Private cDoc
	Private cSeqCorr
	Private aTotRdpe := {{0,0,0,0},{0,0,0,0}}
Endif

// Textos correspondentes aos erros retornados da fun��o CT105LINOK()
Aadd( aErroTexto,STR0027 ) // "1 Erro no Tipo do Lancamento Contabil."											// 01 Help "FALTATPLAN"
Aadd( aErroTexto,STR0028 ) // "2 Ausencia do Valor do Lancamento Contabil."										// 02 Help "FALTAVALOR"
Aadd( aErroTexto,STR0029 ) // "3 O campo historico nao pode ficar em branco."									// 03 Help "CTB105HIST"
Aadd( aErroTexto,STR0030 ) // "4 Este registro nao pode conter valor, pois e um complemento de historico."		// 04 Help "CONTHIST"
Aadd( aErroTexto,STR0031 ) // "5 Lancamento de historico complementar nao pode conter entidade preenchida."	    // 05 Help "HISTNOENT"
Aadd( aErroTexto,STR0032 ) // "6 Lancamento a debito, porem conta debito nao digitada."							// 06 Help "FALTA DEB"
Aadd( aErroTexto,STR0033 ) // "7 Entidade bloqueada ou Data do lancto. menor/maior que a data da entidade."     // 07 ValidaBloq()
Aadd( aErroTexto,STR0034 ) // "8 Conta debito preenchida e seu respectivo digito verificador nao."				// 08 Help "DIG_DEBITO"
Aadd( aErroTexto,STR0035 ) // "9 Digito de Controle NAO confere com o Digito cadastrado no Plano de Contas."    // 09 Help "DIGITO"
Aadd( aErroTexto,STR0036 ) // "10 Amarracao entre as entidades nao permitida. Observe as regras de amarracao."  // 10 CtbAmarra()
Aadd( aErroTexto,STR0037 ) // "11 Entidade obrigatoria nao preenchida ou Entidade proibida preenchida."		    // 11 CtbObrig()
Aadd( aErroTexto,STR0038 ) // "12 Lancamento a credito, porem conta credito nao digitada."						// 12 Help "FALTA CRD"
Aadd( aErroTexto,STR0039 ) // "13 Conta credito preenchida e seu respectivo digito verificador nao."			// 13 Help "DIG-CREDIT"
Aadd( aErroTexto,STR0040 ) // "14 Deve-se informar o valor em outra moeda para validar o lancamento."			// 14 Help "SEMVALUS$"
Aadd( aErroTexto,STR0041 ) // "15 As entidades contabeis sao iguais no debito e credito."						// 15 Help "CTAEQUA123"
Aadd( aErroTexto,STR0042 ) // "16 C.Custo, Item e/ou Cl.Valor nao preenchidos conforme o tipo do lancamento."	// 16 Help ""NOCTADEB
Aadd( aErroTexto,STR0042 ) // "17 C.Custo, Item e/ou Cl.Valor nao preenchidos conforme o tipo do lancamento."	// 17 Help "NOCTACRD"
Aadd( aErroTexto,STR0043 ) // "18 Ponto de Entrada 'CT105LOK'" 													// 18 P.Entrada CT105LOK
Aadd( aErroTexto,STR0044 ) // "19 Moeda/Data bloqueada para lan�amento"											// 19 Help "CT2_VLR0x"
Aadd( aErroTexto,STR0063) // "20 Problema com a(as) entidade(es) informada(as)

// Abrindo o CT2 com o alias "TMP" para sofrer as consistencias da fun��o CT105LINOK()
If Select("TMP") > 0
	TMP->( DbCloseArea() )
EndIf

ChkFile("CT2",.F.,"TMP")

dbSelectArea("CT6")
dbSetOrder(1)
cFilCT6 := xFilial("CT6")

dbSelectArea("CTC")
dbSetOrder(1)
cFilCTC := xFilial("CTC")

dbSelectArea("CT2")
cFilCT2 := xFilial("CT2")
dbSetOrder(1)

dbSeek(cFilCT2+Dtos(mv_par04)+mv_par02+(If(mv_par02==mv_par01,"Z","")),.T.)	// Localiza registro pr�ximo ao �ltimo
nRecF := CT2->(Recno())						// Guara n� do registro final

dbSeek(cFilCT2+Dtos(mv_par03)+(If(!Empty(mv_par01),mv_par01,""))+(If(!Empty(mv_par09),mv_par09,"")),.T.) // Procuro por Filial+Data Inicial + Lote + SbLote
nRecI := CT2->(Recno()) 					// Guarda n� do registro inicial

ProcRegua(nRecF - nRecI)					// Seta regua contando intervalo de registro
dDataAnt := CT2->CT2_DATA
cLoteAnt := ""
cDocAnt	 := ""
cLancAnt := ""

aCT2DocOk := {}

#IFDEF TOP
If TcSrvType() <> "AS/400" .AND. lCT350QRY	/// SE FOR TOP <> AS/400 E DEVE EXECUTAR COM SQL.
	
	cQuery := " SELECT CT2_FILIAL, CT2_DATA, CT2_LOTE, CT2_SBLOTE, MIN(R_E_C_N_O_) MINRECNO"
	cQuery += " FROM "+RetSqlName("CT2")
	cQuery += " WHERE CT2_FILIAL = '"+cFilCT2+"'
	
	If mv_par03 == mv_par04
		cQuery += " AND CT2_DATA = '" + DTOS(mv_par03) + "' "
	Else
		cQuery += " AND CT2_DATA >= '" + DTOS(mv_par03) + "' "
		cQuery += " AND CT2_DATA <= '" + DTOS(mv_par04) + "' "
	Endif
	
	If ! Empty( mv_par01 ) .Or. ! Empty( mv_par02 )
		If ( mv_par01 == mv_par02 )
			cQuery += " AND CT2_LOTE = '" + mv_par01 + "' "
		Else
			If ! Empty( mv_par01 )
				cQuery += " AND CT2_LOTE >= '" + mv_par01 + "' "
			Endif
			
			If ! Empty( mv_par02 )
				cQuery += " AND CT2_LOTE <= '" + mv_par02 + "' "
			Endif
		Endif
	Endif
	
	If ! Empty( mv_par09 ) .Or. ! Empty( mv_par10 )
		If ( mv_par09 == mv_par10 )
			cQuery += " AND CT2_SBLOTE = '" + mv_par09 + "' "
		Else
			If ! Empty( mv_par09 )
				cQuery += " AND CT2_SBLOTE >= '" + mv_par09 + "' "
			Endif
			
			If ! Empty( mv_par10 )
				cQuery += " AND CT2_SBLOTE <= '" + mv_par10 + "' "
			Endif
		Endif
	Endif
	
	If ! Empty( mv_par13 ) .Or. ! Empty( mv_par14 )
		If ( mv_par13 == mv_par14 )
			cQuery += " AND CT2_DOC = '" + mv_par13 + "' "
		Else
			If ! Empty( mv_par13 )
				cQuery += " AND CT2_DOC >= '" + mv_par13 + "' "
			Endif
			
			If ! Empty( mv_par14 )
				cQuery += " AND CT2_DOC <= '" + mv_par14 + "' "
			Endif
		Endif
	Endif
	cQuery += " AND CT2_TPSALD = '" + D_PRELAN + "' "
	cQuery += " AND D_E_L_E_T_ = ' ' "
	cQuery += " GROUP BY CT2_FILIAL, CT2_DATA, CT2_LOTE, CT2_SBLOTE "
	cQuery += " ORDER BY CT2_FILIAL, CT2_DATA, CT2_LOTE, CT2_SBLOTE "
	
	cQuery := ChangeQuery(cQuery)
	
	If Select("TMP350") > 0
		dbSelectArea("TMP350")
		dbCloseArea()
	Endif
	
	xCONOUT("|INI QUERY !")
	
	dbUseArea(.T.,"TOPCONN",TcGenQry(,,cQuery),"TMP350",.T.,.F.)
	
	xCONOUT("|FIM QUERY !")
	
	TcSetField("TMP350","MINRECNO","N",17,0)
	TcSetField("TMP350","CT2_DATA","D",8,0)
	
	If lEnd
		Return
	Endif
	
	dbSelectArea( "TMP350" )
	dbGoTop()
	
	While !TMP350->(Eof())
		
		CT2->( dbGoTo(TMP350->MINRECNO) )
		
		IncProc( DTOC( CT2->CT2_DATA ) + "-" + CT2->CT2_LOTE + STR0056 + ALLTRIM( STR( CT2->( Recno() ) )))//" Lendo Lote... Reg.: "
		
		Processa({|lEnd| Ct350roda( @lEnd, @aErro, aErroTexto, cTpSldAtu, lEfLote, lEfDoc, lMostraLct, lSimula )} ,cCadastro )
		
		If lEnd
			Return
		EndIf
		
		lProcessa := .T.
		
		TMP350->( dbSkip() )
	EndDo
	
Else
#ENDIF

	dbSelectArea("CT2")
	dbSetOrder(1)			// Localiza pr�ximo documento v�lido
	dbSeek(cFilCT2+Dtos(mv_par03), .T.)
	aLctProc := {}
	While CT2->(!Eof() .And. CT2_FILIAL == cFilCT2 .And. DTOS(CT2_DATA) <= DTOS(mv_par04) )
		
		IncProc(DTOC(CT2->CT2_DATA)+"-"+CT2->CT2_LOTE+STR0056+ALLTRIM(STR(CT2->(Recno()))))//" Lendo Lote... Reg.: "
		
		nRecCT2 := CT2->(Recno())
		
		//os lotes processados sao armazenados no array aLctProc
		If Ascan(aLctProc, CT2->( CT2_FILIAL+DTOS(CT2_DATA)+CT2_LOTE+CT2_SBLOTE+CT2_DOC+CT2_LINHA+CT2_MOEDLC  ) ) == 0 //se nao processou ainda
			
			If CT2->( CT2_TPSALD == D_PRELAN	.And. ;    //regras normais
				CT2_LOTE >= mv_par01 .And. CT2_LOTE <= mv_par02  .And. ;
				CT2_SBLOTE >= mv_par09 .And. CT2_SBLOTE <= mv_par10 .And. ;
				CT2_DOC >= mv_par13 .And. CT2_DOC <= mv_par14 )
				
				aAdd(aLctProc, CT2->( CT2_FILIAL+DTOS(CT2_DATA)+CT2_LOTE+CT2_SBLOTE+CT2_DOC+CT2_LINHA+CT2_MOEDLC ) ) //armazena no array
				ct350roda(@lEnd,@aErro,aErroTexto,cTpSldAtu,lEfLote,lEfDoc,lMostraLct,lSimula)  //efetiva pre-lct
				
			EndIf
			
		EndIf
		
		If lEnd
			Return
		EndIf
		
		lProcessa := .T.
		
		CT2->( dbGoto(nRecCT2) )
		CT2->( dbSkip() )
		
	EndDo

#IFDEF TOP
EndIf
#ENDIF

xCONOUT("|FIM CTB350PROC !",.T.)
//��������������������������������������������������������������Ŀ
//� Se nao tiver inconsistencias, imprime mensagem que esta ok.	 �
//����������������������������������������������������������������
lPrintR := .T.
If lProcessa .And. Len(__aRptLog) <= 0
	If !__lBlind .and. MsgYesNo(STR0016+CRLF+STR0052,cCadastro)
		lPrintR := .T.
		cDescInc := OemToAnsi(STR0016)		//"Nao ha inconsistencias no lote e documento."
		CT350GrInc(,,,,,,cDescInc)		//Gravo no arquivo temporario as inconsistencias
	Else
		lPrintR := .F.
	EndIf
ElseIf !lProcessa
	If !__lBlind .and. MsgYesNo(STR0017+CRLF+STR0052,cCadastro)
		lPrintR := .T.
		cDescInc := OemToAnsi(STR0017)		//"Nao ha lote a ser efetivado."
		CT350GrInc(,,,,,,cDescInc)		//Gravo no arquivo temporario as inconsistencias
	Else
		lPrintR := .F.
	EndIf
ElseIf Len(__aRptLog) > 0 .and. !__lBlind
	MsgInfo(STR0053+CRLF+STR0054,STR0055)//"Houveram inconsist�ncias na efetiva��o !"
Endif

//������������������������������������Ŀ
//� Imprime relatorio de consistencias �
//��������������������������������������
If lPrintR
	If lSimula
		titulo+=" - " +STR0066 //" Modo Simula��o."
	EndIf
	C350ImpRel()
Endif

If Select("TMP") > 0
	TMP->( DbCloseArea() )
EndIf
xCONOUT("|AFTER RPT LOG !")

Return

/*/
������������������������������������������������������������������������������
��������������������������������������������������������������������������Ŀ��
���Fun��o    �Ct350GrInc� Autor � Simone Mie Sato       � Data � 14.05.01  ���
��������������������������������������������������������������������������Ĵ��
���Descri��o � Grava as Inconsistencias no Arq. de Trabalho.               ���
��������������������������������������������������������������������������Ĵ��
���Sintaxe   � Ct350GrInc(dData,cLote,cDoc,cMoeda,nVlrDeb,nVlrCrd,cDescInc)���
��������������������������������������������������������������������������Ĵ��
���Retorno   � Nenhum                                                      ���
��������������������������������������������������������������������������Ĵ��
��� Uso      � Ctba350                                                     ���
��������������������������������������������������������������������������Ĵ��
���Parametros� ExpD1 = Data                                                ���
���          � ExpC1 = Lote                                                ���
���          � ExpC2 = Documento                                           ���
���          � ExpC3 = Moeda                                               ���
���          � ExpN1 = Valor Debito                                        ���
���          � ExpN2 = Valor Credito                                       ���
���          � ExpC4 = Descricao da Inconsistentcia                        ���
���������������������������������������������������������������������������ٱ�
������������������������������������������������������������������������������
�������������������������������������������������������������������������������
/*/
Function Ct350GrInc(dData,cLote,cDoc,cMoeda,nVlrDeb,nVlrCrd,cDescInc)
Local cQuery	:= ""

Default dData 		:= ""
Default cLote 		:= ""
Default cDoc 		:= ""
Default cMoeda 		:= ""
Default nVlrDeb		:= 0
Default nVlrCrd		:= 0
Default cDescInc	:= ""

If lUsaProc
	aResult := TCSPEXEC( "CTB350REL_" + cEmpAnt, dData , cLote, cDoc, cMoeda, nVlrDeb, nVlrCrd, cDescInc)

	If Empty(aResult)
  		conout("Falha na chamada do processo de inclus�o dos dados para o relatorios. Grava��o ser� efetuada de forma padr�o.")
   		lUsaProc := .F.
	EndIf
EndIf

IF !lUsaProc
	If Valtype(__aRptLog) # "A" 
		__aRptLog := {}
	Endif
  
	If aScan( __aRptLog , { |x| 	x[1] == dData .And. ;
									x[2] == cLote .And. ;
									x[3] == cDoc .And. ;
									x[4] == cMoeda .And. ;
									x[5] == nVlrDeb .And. ;
									x[6] == nVlrCrd .And. ;
									x[7] == cDescInc} ) == 0
	
		aAdd(__aRptLog,{dData,cLote,cDoc,cMoeda,nVlrDeb,nVlrCrd,cDescInc})
	
		If Select("TRB350REL") <= 0
			dbUseArea( .T., "TOPCONN", "TRB350REL", "TRB350REL", .F., .F. )
			TcRefresh("TRB350REL")
		Endif

		dbSelectArea("TRB350REL")
		Reclock("TRB350REL",.T.)
		
		TRB350REL->DDATA	:= dData
		TRB350REL->LOTE		:= cLote
		TRB350REL->DOC		:= cDoc 
		TRB350REL->MOEDA	:= cMoeda
		TRB350REL->VLRDEB	:= nVlrDeb
		TRB350REL->VLRCRD	:= nVlrCrd
		TRB350REL->DESCINC	:= cDescInc
		MsUnlock()
	Endif
EndIf

Return


/*/
�����������������������������������������������������������������������������
�������������������������������������������������������������������������Ŀ��
���Fun��o    �C350ImpRel� Autor � Simone Mie Sato       � Data � 14.05.01 ���
�������������������������������������������������������������������������Ĵ��
���Descri��o �Imprime o Relatorio Final.                                  ���
�������������������������������������������������������������������������Ĵ��
���Sintaxe   � C350ImpRel()		  							              ���
�������������������������������������������������������������������������Ĵ��
���Retorno   � Nenhum       	  							              ���
�������������������������������������������������������������������������Ĵ��
��� Uso      � Ctba350                                                    ���
�������������������������������������������������������������������������Ĵ��
���Parametros� Nenhum                                                     ���
��������������������������������������������������������������������������ٱ�
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
/*/

Function C350ImpRel()

Local nRpt := 1

PRIVATE Tamanho		:="M"
PRIVATE aLinha		:= {}
PRIVATE nomeProg 	:= "CTBA350"

li 			:= 80
m_pag			:= 1

wnrel	:= "CTBA350"            //Nome Default do relatorio em Disco
wnrel := SetPrint(cString,wnrel,,@titulo,cDesc1,,,.F.,"",,Tamanho)

If nLastKey = 27
	Set Filter To
	Return
Endif

If aReturn[4] == 2 // Paisagem
	Tamanho := "G"
EndIf

SetDefault(aReturn,cString)

If nLastKey = 27
	Set Filter To
	Return
Endif

If Select("TRB350REL") <= 0
	dbUseArea( .T., "TOPCONN", "TRB350REL", "TRB350REL", .F., .F. )
	TcRefresh("TRB350REL")
	
	DbSelectArea("TRB350REL")
	DbSetOrder(1)
	DbGoTop()
Endif

RptStatus({|lEnd| CTR350Imp(@lEnd,wnRel,cString,Titulo)})

Return

/*/
�����������������������������������������������������������������������������
�������������������������������������������������������������������������Ŀ��
���Fun��o    �Ctr350Imp �Autor  � Simone Mie Sato       � Data � 14.05.01 ���
�������������������������������������������������������������������������Ĵ��
���Descri��o �Imprime o Relatorio Final.                                  ���
�������������������������������������������������������������������������Ĵ��
���Sintaxe   � Ctr350Imp()       							              ���
�������������������������������������������������������������������������Ĵ��
���Retorno   �Nenhum             							              ���
�������������������������������������������������������������������������Ĵ��
��� Uso      � Ctba350                                                    ���
�������������������������������������������������������������������������Ĵ��
���Parametros� ExpL1 = Acao do CodeBlock                                  ���
���          � ExpC1 = Nome do relatorio                                  ���
���          � ExpC2 = Mensagem                                           ���
���          � ExpC3 = Titulo                                             ���
��������������������������������������������������������������������������ٱ�
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
/*/
Function Ctr350Imp(lEnd,wnRel,cString,Titulo)

Local Li := 80

dbSelectArea("TRB350REL")
dbGotop()

SetRegua(RecCount())
While !Eof()
	
	If Li > 55
		Cabec(titulo,cabec1,cabec2,NomeProg,Tamanho)
		Li := 10
	Endif
	IncRegua()
	If ! Empty(TRB350REL->DDATA)
		@ Li,01 PSAY TRB350REL->DDATA
		@ Li,12 PSAY TRB350REL->LOTE
		@ Li,22 PSAY TRB350REL->DOC
		@ Li,32 PSAY TRB350REL->MOEDA
		@ Li,38 PSAY TRB350REL->VLRDEB		Picture "@E 999,999,999,999.99"
		@ Li,57 PSAY TRB350REL->VLRCRD		Picture "@E 999,999,999,999.99"
		@ Li,77 PSAY TRB350REL->DESCINC
	Else
		@ Li,01 PSAY TRB350REL->DESCINC
	Endif
	
	Li += 1
	dbSkip()
End

If aReturn[5] = 1
	Set Printer To
	Commit
	Ourspool(wnrel)
EndIf

MS_FLUSH()

Return

/*/
�����������������������������������������������������������������������������
�������������������������������������������������������������������������Ŀ��
���Fun��o    �Ct350Valid�Autor  � Simone Mie Sato       � Data � 14.05.01 ���
�������������������������������������������������������������������������Ĵ��
���Descri��o �Verifica as entidades.                                      ���
�������������������������������������������������������������������������Ĵ��
���Sintaxe   � Ct350Valid()      							              ���
�������������������������������������������������������������������������Ĵ��
���Retorno   �Nenhum             							              ���
�������������������������������������������������������������������������Ĵ��
��� Uso      � Ctba350                                                    ���
�������������������������������������������������������������������������Ĵ��
���Parametros� 				                                              ���
��������������������������������������������������������������������������ٱ�
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
/*/
Function Ct350Valid()

Local aSaveArea	:= GetArea()
Local lRet		:= .T.
Local cDescInc	:= ""
Local cSayCusto		:= CtbSayApro("CTT")
Local cSayItem		:= CtbSayApro("CTD")
Local cSayClVL		:= CtbSayApro("CTH")

dbSelectArea("CT2")
dbSetOrder(1)
MsSeek(xFilial("CT2")+Dtos(mv_par03)+mv_par01+mv_par13,.T.) // Procuro por Filial+Data Inicial + Lote + DOC inicial

ProcRegua(CT2->(RecCount()))
dDataAnt := CT2->CT2_DATA
cLoteAnt := ""
cDocAnt	 := ""

While !Eof() .And. CT2->CT2_FILIAL == xFilial("CT2") .And. CT2->CT2_DATA <= mv_par04 .And. CT2->CT2_DOC <= mv_par14
	
	If CT2->CT2_TPSALD != D_PRELAN //Se o tipo de saldo for diferente de pre-lancamento
		dbSkip()
		Loop
	Endif
	
	If CT2->CT2_DATA < mv_par03 .Or. CT2->CT2_DATA > mv_par04
		dbSkip()
		Loop
	Endif
	
	If  CT2->CT2_LOTE < mv_par01 .Or. CT2->CT2_LOTE > mv_par02
		dbSkip()
		Loop
	EndIf
	
	If CT2->CT2_DC $ "13"
		//����������������������������������������������������������������������������������Ŀ
		//� CONTA CONTABIL A DEBITO                                                          �
		//������������������������������������������������������������������������������������
		//����������������������������������������������������������������������������������Ŀ
		//� Verifica se a conta foi preenchida                                               �
		//������������������������������������������������������������������������������������
		If Empty( CT2->CT2_DEBITO )
			lRet := .F.
			If !lRet
				cDescInc := STR0023	+ STR0025 + CT2->CT2_LINHA //Conta nao preenchida.  	Linha:
				CT350GrInc(DTOC(CT2->CT2_DATA),CT2->CT2_LOTE,CT2->CT2_DOC,,,,cDescInc)
			EndIf
		Endif
		
		//����������������������������������������������������������������������������������Ŀ
		//� Verifica se a conta existe e nao e sintetica                                     �
		//������������������������������������������������������������������������������������
		dbSelectArea("CT1")
		lRet:= ValidaConta(CT2->CT2_DEBITO,"1",,,.T.,.F.)
		If !lRet
			cDescInc	:= STR0024 + Alltrim(CT2->CT2_DEBITO) + STR0025 + CT2->CT2_LINHA //Verificar conta: 	Linha:
			CT350GrInc(DTOC(CT2->CT2_DATA),CT2->CT2_LOTE,CT2->CT2_DOC,,,,cDescInc)
		EndIf
		
		//����������������������������������������������������������������������������������Ŀ
		//� CENTRO DE CUSTO - DEBITO                                                         �
		//������������������������������������������������������������������������������������
		If lCusto
			lRet:= ValidaCusto(CT2->CT2_CCD,"1",,,.T.,.F.)
			If !lRet
				cDescInc	:= STR0026+ Alltrim(cSayCusto) + " : " + Alltrim(CT2->CT2_CCD)+STR0025+CT2->CT2_LINHA //Verificar  Linha
				CT350GrInc(DTOC(CT2->CT2_DATA),CT2->CT2_LOTE,CT2->CT2_DOC,,,,cDescInc)
			EndIf
		EndIf
		//����������������������������������������������������������������������������������Ŀ
		//� ITEM - DEBITO 		                                                             �
		//������������������������������������������������������������������������������������
		If lItem
			lRet:= ValidItem(CT2->CT2_ITEMD,"1",,,.T.,.F.)
			If !lRet
				cDescInc	:= STR0026+ Alltrim(cSayItem) + " : " + Alltrim(CT2->CT2_ITEMD)+STR0025+CT2->CT2_LINHA //Verificar  Linha
				CT350GrInc(DTOC(CT2->CT2_DATA),CT2->CT2_LOTE,CT2->CT2_DOC,,,,cDescInc)
			EndIf
		EndIf
		//����������������������������������������������������������������������������������Ŀ
		//� CLASSE VALOR - DEBITO 		                                                       �
		//������������������������������������������������������������������������������������
		If lClVL
			lRet:= ValidaCLVL(CT2->CT2_CLVLDB,"1",,,.T.,.F.)
			If !lRet
				cDescInc	:= STR0026+ Alltrim(cSayClVl) + " : " + Alltrim(CT2->CT2_CLVLDB)+STR0025+CT2->CT2_LINHA //Verificar  Linha
				CT350GrInc(DTOC(CT2->CT2_DATA),CT2->CT2_LOTE,CT2->CT2_DOC,,,,cDescInc)
			EndIf
		EndIf
	Endif
	
	//�������������������������������������������������������������������������������������Ŀ
	//� Bloco de Valida�oes Lancamentos a Credito                                           �
	//���������������������������������������������������������������������������������������
	If CT2->CT2_DC $ "23"
		//����������������������������������������������������������������������������������Ŀ
		//� CONTA CONTABIL A CREDITO                                                         �
		//������������������������������������������������������������������������������������
		//����������������������������������������������������������������������������������Ŀ
		//� Verifica se a conta foi preenchida                                               �
		//������������������������������������������������������������������������������������
		If Empty( CT2->CT2_CREDIT )
			lRet := .F.
			If !lRet
				cDescInc 	:= STR0023	+ STR0025 + CT2->CT2_LINHA //Conta nao preenchida.  	Linha:
				CT350GrInc(DTOC(CT2->CT2_DATA),CT2->CT2_LOTE,CT2->CT2_DOC,,,,cDescInc)
			EndIf
		Endif
		//����������������������������������������������������������������������������������Ŀ
		//� Verifica se a conta existe e nao e sintetica                                     �
		//������������������������������������������������������������������������������������
		lRet := ValidaConta(CT2->CT2_CREDIT,"2",,,.T.,.F.)
		If !lRet
			cDescInc	:= STR0024 + Alltrim(CT2->CT2_CREDIT) + STR0025 + CT2->CT2_LINHA //Verificar conta: 	Linha:
			CT350GrInc(DTOC(CT2->CT2_DATA),CT2->CT2_LOTE,CT2->CT2_DOC,,,,cDescInc)
		EndIf
		
		//����������������������������������������������������������������������������������Ŀ
		//� CENTRO DE CUSTO - CREDITO                                                        �
		//������������������������������������������������������������������������������������
		If lCusto
			lRet:= ValidaCusto(CT2->CT2_CCC,"2",,,.T.,.F.)
			If !lRet
				cDescInc	:= STR0026+ Alltrim(cSayCusto) + " : " + Alltrim(CT2->CT2_CCC)+STR0025+CT2->CT2_LINHA //Verificar  Linha
				CT350GrInc(DTOC(CT2->CT2_DATA),CT2->CT2_LOTE,CT2->CT2_DOC,,,,cDescInc)
			EndIf
		Endif
		
		//����������������������������������������������������������������������������������Ŀ
		//� ITEM - CREDITO		                                                             �
		//������������������������������������������������������������������������������������
		If lItem
			lRet:= ValidItem(CT2->CT2_ITEMC,"2",,,.T.,.F.)
			If !lRet
				cDescInc	:= STR0026+ Alltrim(cSayItem) + " : " + Alltrim(CT2->CT2_ITEMC)+STR0025+CT2->CT2_LINHA //Verificar  Linha
				CT350GrInc(DTOC(CT2->CT2_DATA),CT2->CT2_LOTE,CT2->CT2_DOC,,,,cDescInc)
			EndIf
		Endif
		
		//����������������������������������������������������������������������������������Ŀ
		//� CLASSE VALOR - CREDITO		                                                       �
		//������������������������������������������������������������������������������������
		If lClVL
			lRet:= ValidaCLVL(CT2->CT2_CLVLCR,"2",,,.T.,.F.)
			If !lRet
				cDescInc	:= STR0026+ Alltrim(cSayClVl) + " : " + Alltrim(CT2->CT2_CLVLCR)+STR0025+CT2->CT2_LINHA //Verificar  Linha
				CT350GrInc(DTOC(CT2->CT2_DATA),CT2->CT2_LOTE,CT2->CT2_DOC,,,,cDescInc)
			EndIf
		EndIf
	EndIf
	dbSelectArea("CT2")
	dbSkip()
EndDo

RestArea(aSaveArea)

Return

/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �CT350DigLa�Autor  �Marcos S. Lobo      � Data �  02/02/07   ���
�������������������������������������������������������������������������͹��
���Desc.     �Efetua chamada da tela de lan�amento contabil manual para   ���
���          �a efetiva��o quando configurada para Mostrar Lan�amento.    ���
�������������������������������������������������������������������������͹��
���Uso       � AP                                                        ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/
Static Function Ct350DigLan(nPriLinCT2)
Local cSubLote
Local nTotInf

CT2->( DbGoTo(nPriLinCT2) )	//	Posicionando no primeiro registro do lancamento

dDataLanc := CT2->CT2_DATA // "dDataLanc" � utilizada na funcao CT105LinOK()

// Buscando o total do documento
dbSelectArea("CTC")
dbSetOrder(1)

If MsSeek(cFilCTC+DtoS(CT2->CT2_DATA)+CT2->CT2_LOTE+CT2->CT2_SBLOTE+CT2->CT2_DOC+CT2->CT2_MOEDLC+CT2->CT2_TPSALD)
	nTotInf := CTC->CTC_INF
Else
	nTotInf := 0
Endif

// Fechando o Alias "TMP", pois na funcao CTBA102LAN(), esse Alias e usado para o temporario da GetDados
TMP->( DbCloseArea() )

cSubLote	:=	CT2->CT2_SBLOTE //variavel privada utilizada nas validacoes

Ctba102Lan(4,CT2->CT2_DATA,CT2->CT2_LOTE,CT2->CT2_SBLOTE,CT2->CT2_DOC,"CT2",CT2->(Recno()),0,"",nTotInf)

// Abrindo novamente o CT2 com o alias "TMP"
If Select("TMP") > 0
	TMP->( DbCloseArea() )
EndIf

ChkFile("CT2",.F.,"TMP")

Return

/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �CTBA350   �Autor  �Microsiga           � Data �  03/09/07   ���
�������������������������������������������������������������������������͹��
���Desc.     �                                                            ���
���          �                                                            ���
�������������������������������������������������������������������������͹��
���Uso       � AP                                                        ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/
Static Function ct350roda(lEnd,aErro,aErroTexto,cTpSldAtu,lEfLote,lEfDoc,lMostraLct,lSimula)

Local nCont		:= 0
Local nDocOk	:= 0
Local nPriLinCT2    := 1
Local nValor		:= 0
Local nCT6CRD		:= 0
Local nCT6DEB		:= 0
Local nCTCDEB 		:= 0
Local nCTCCRD 		:= 0
Local nVlrDeb		:= 0
Local nVlrCrd		:= 0
Local lTodas

Local lTemIncons  := .F.
Local lLoteOk		:= .T.
Local lDocOk		:= .T.

Local cLoteAtu	:= CT2->CT2_LOTE
Local dDataAtu	:= CT2->CT2_DATA
Local aOutrEntid	:= {}

ProcRegua(1000)

If !lEfLote	///Se s� efetivar LOTE batido
	//������������������������������������������������������Ŀ
	//� Verifico se o lote esta batendo	em todas as moedas   �
	//��������������������������������������������������������
	aSaldo:= SaldoCT6(CT2->CT2_LOTE,CT2->CT2_SBLOTE,CT2->CT2_DATA,CT2->CT2_MOEDLC,CT2->CT2_TPSALD)
	
	If aSaldo[2] <> 0 .OR. aSaldo[3] <> 0
		
		nCT6DEB := Round(aSaldo[2],2)
		nCT6CRD := Round(aSaldo[3],2)
		
		If nCT6DEB != nCT6CRD .or. (nCT6DEB == 0 .and. nCT6CRD == 0)//Se debito e credito nao baterem
			lTemIncons := .T.
			lLoteOk	:= .F.
			cDescInc := OemToAnsi(STR0014)		//"Debito e Credito do Lote nao estao batendo"
			CT350GrInc(DTOC(CT2->CT2_DATA),CT2->CT2_LOTE,,CT2->CT2_MOEDLC,nCT6DEB,nCT6CRD,cDescInc) //Grava TMP com as inconsistencias
		EndIf
	Else
		lTemIncons	:= .T.
		lLoteOk		:= .F.
		//Gravo no arquivo temporario as inconsistencias
		cDescInc := OemToAnsi(STR0051)		//"Registro de Saldo Total do Lote/Doc. n�o encontrado. Reprocessar Pr�-Lan�amentos (9)."
		CT350GrInc(DTOC(CT2->CT2_DATA),CT2->CT2_LOTE,,CT2->CT2_MOEDLC,0,0,cDescInc)
	Endif
	
	If !lLoteOk	//Se houve diferen�a no total Deb x Cred.
		///Ja localiza o proximo lote.
		lSkip := .F.
		#IFNDEF TOP
			lSkip := .T.
		#ELSE
			If TcSrvType() == "AS/400" .OR. !lCT350QRY ///Se n�o executa query, faz skip do while.
				lSkip := .T.
			EndIf
		#ENDIF
		
		If lSkip ///nas versoes sem query deve-se localizar o proximo registro de lote a ser validado no CT2.
			dbSelectArea("CT2")
			dbSetOrder(1)
			dbSeek(cFilCT2+DTOS(dDataAtu)+Soma1(cLoteAtu),.T.)
		EndIf
		Return
	EndIf
EndIf

If lEnd
	Return
EndIf

// Enquanto for o mesmo Lote
While CT2->(!Eof()) .And. CT2->CT2_FILIAL == cFilCT2 .And. CT2->CT2_DATA == dDataAtu .and. CT2->CT2_LOTE == cLoteAtu .and. CT2->CT2_SBLOTE <= mv_par10 .And. CT2->CT2_DOC <= mv_par14
	
	IncProc(DTOC(CT2->CT2_DATA)+"-"+CT2->CT2_LOTE+"/"+CT2->CT2_DOC+STR0058+ALLTRIM(STR(CT2->(Recno()))))///" Lendo Doc... Reg.: "
	
	If lEnd
		Return
	EndIf
	
	If CT2->CT2_LOTE < mv_par01 .or. CT2->CT2_SBLOTE < mv_par09
		CT2->(dbSeek(cFilCT2+CT2->(DTOS(CT2_DATA)+CT2_LOTE+CT2_SBLOTE+SOMA1(CT2_DOC)),.T.))
		Loop
	ElseIf CT2->CT2_TPSALD != D_PRELAN //Se o tipo de saldo for diferente de pre-lancamento
		CT2->(dbSeek(cFilCT2+CT2->(DTOS(CT2_DATA)+CT2_LOTE+CT2_SBLOTE+CT2_DOC+SOMA1(CT2_LINHA)),.T.))
		Loop
	EndIf
	
	cSubAtu := CT2->CT2_SBLOTE
	cDocAtu := CT2->CT2_DOC
	
	lTemIncons	:= .F.
	lDocOk		:= .T.
	
	If !lEfDoc			/// Se s� efetivar DOCUMENTO batido.
		//������������������������������������������������������������Ŀ
		//� Verifico se o documentos esta batendo em todas as moedas   �
		//��������������������������������������������������������������
		dbSelectArea("CTC")
		dbSetOrder(1)
		If dbSeek(cFilCTC+CT2->(dtos(CT2_DATA)+CT2_LOTE+CT2_SBLOTE+CT2_DOC+CT2_MOEDLC),.F.)
			nCTCDEB := 0
			nCTCCRD := 0
			While !CTC->(Eof()) .and. CTC->CTC_FILIAL == cFilCTC .and. CTC->CTC_DATA == CT2->CT2_DATA .AND. CTC->CTC_LOTE == CT2->CT2_LOTE .AND.;
				CTC->CTC_SBLOTE == CT2->CT2_SBLOTE .and. CTC->CTC_DOC == CT2->CT2_DOC .and. CTC->CTC_MOEDA == CT2->CT2_MOEDLC
				
				nCTCDEB += CTC->CTC_DEBITO
				nCTCCRD += CTC->CTC_CREDIT
				
				CTC->(dbSkip())
			EndDo
			
			nCTCDEB := Round(nCTCDEB,2)
			nCTCCRD := Round(nCTCCRD,2)
			
			If nCTCDEB != nCTCCRD .or. (nCTCDEB == 0 .and. nCTCCRD == 0)//Se debito e credito nao baterem
				lTemIncons := .T.
				lDocOk	:= .F.
				nVlrDeb	:= CTC->CTC_DEBITO
				nVlrCrd := CTC->CTC_CREDIT
				//Gravo no arquivo temporario as inconsistencias
				cDescInc := OemToAnsi(STR0015)		//"Debito e Credito do Documento nao estao batendo"
				CT350GrInc(DTOC(CT2->CT2_DATA),CT2->CT2_LOTE,CT2->CT2_DOC,CT2->CT2_MOEDLC,nVlrDeb,nVlrCrd,cDescInc)
			Endif
		Else
			lTemIncons	:= .T.
			lDocOk		:= .F.
			//Gravo no arquivo temporario as inconsistencias
			cDescInc := OemToAnsi(STR0051)		//"Registro de Saldo Total do Lote/Doc. n�o encontrado. Reprocessar Pr�-Lan�amentos (9)."
			CT350GrInc(DTOC(CT2->CT2_DATA),CT2->CT2_LOTE,CT2->CT2_DOC,CT2->CT2_MOEDLC,0,0,cDescInc)
		Endif
	EndIf
	
	nPriLinCT2	:= CT2->( Recno() )		// Guarda a 1� Linha do Documento
	dDataLanc	:= CT2->CT2_DATA
	
	If lEnd
		Return
	EndIf

	If !lEfDoc .And. lTemIncons .And. lMostraLct
		CT350DigLan( nPriLinCT2 )
		dbSelectArea("CT2")
		dbSetOrder(1)
		dbSeek(cFilCT2 + CT2->(DTOS(CT2_DATA)+CT2_LOTE+CT2_SBLOTE+Soma1(CT2_DOC)) )
		nNextCT2 := CT2->(Recno())
	Else

		IF !lEfDoc .and. lTemIncons
			
			dbSelectArea("CT2")
			dbSetOrder(1)
			dbSeek(cFilCT2 + CT2->(DTOS(CT2_DATA)+CT2_LOTE+CT2_SBLOTE+Soma1(CT2_DOC)) )
			
		Else
			
			lTemIncons  := .F.
			aCT2DocOk	 := {}
			
			While CT2->(!Eof()) .and. 	CT2->CT2_FILIAL == cFilCT2 .And. CT2->CT2_DATA == dDataAtu .and. CT2->CT2_LOTE == cLoteAtu .and.;
				CT2->CT2_SBLOTE == cSubAtu .and. CT2->CT2_DOC == cDocAtu
				
				IncProc(DTOC(CT2->CT2_DATA)+"-"+CT2->CT2_LOTE+"/"+CT2->CT2_DOC+STR0059+ALLTRIM(STR(CT2->(Recno()))))//" Validado...Reg.: "
				
				If CT2->CT2_LOTE < mv_par01 .or. CT2->CT2_SBLOTE < mv_par09
					CT2->(dbSeek(cFilCT2+CT2->(DTOS(CT2_DATA)+CT2_LOTE+CT2_SBLOTE+SOMA1(CT2_DOC)),.T.))
					Loop
				ElseIf CT2->CT2_TPSALD != D_PRELAN //Se o tipo de saldo for diferente de pre-lancamento
					CT2->(dbSeek(cFilCT2+CT2->(DTOS(CT2_DATA)+CT2_LOTE+CT2_SBLOTE+CT2_DOC+SOMA1(CT2_LINHA)),.T.))
					Loop
				EndIf
				
				TMP->( DbGoTo( CT2->(Recno()) ) )		/// Posiciona o mesmo registro do CT2 no alias TMP.
				
				dDataLanc	 := TMP->CT2_DATA // "dDataLanc" � utilizada na funcao CT105LinOK()
				aErro		 := {}
				lTodas	 	 := (mv_par11 == 2)
				
				//����������������������������������������������������������������������������������������Ŀ
				//� Verificar se ha inconsistencia (se lTodas==.T., verificara todas as inconsistencias    �
				//� do documento, caso contrario, retornara apos a primeira inconsistencia encontrada)	   �
				//������������������������������������������������������������������������������������������
				If !CT105LinOK("",.T.,@aErro,lTodas,OPCAO)
					lTemIncons := .T.
					For nCont := 1 to Len(aErro)
						cDescInc := aErroTexto[ aErro[nCont] ]
						nVlrDeb 	:= IF( CT2->CT2_DC $ "13", CT2->CT2_VALOR, 0 )
						nVlrCrd 	:= IF( CT2->CT2_DC $ "23", CT2->CT2_VALOR, 0 )
						If nVlrDeb == 0 .And. nVlrCrd == 0
							nVlrDeb := nVlrCrd := CT2->CT2_VALOR
						EndIf
						CT350GrInc(DTOC(CT2->CT2_DATA),CT2->CT2_LOTE,CT2->CT2_DOC,CT2->CT2_MOEDLC,nVlrDeb,nVlrCrd,cDescInc)
					Next
				Else		/// Se n�o teve inconsist�ncia na Linha
					aAdd(aCT2DocOk,CT2->(Recno()) )
				EndIf
				
				nUltLinCT2 := CT2->( Recno()) // Guarda a �ltima linha do Documento
				CT2->(dbSkip())
			EndDo
			
		EndIF
		
		/// Quando Terminar a leitura do documento.
		nNextCT2 := CT2->(Recno())      /// Guarda o posicionamento do pr�ximo registro.
		
		/// Efetua grava��o dos lan�amentos ou mostra tela para corre��es e grava��o
		If lTemIncons .And. lMostraLct 	// Se tem inconsistencias e deve mostrar lancamento na tela
			Ct350DigLan(nPriLinCT2)	//Mostra o lan�amento para corre��es, grava CT2 e Saldos.
			
		ElseIf !lTemIncons .and. ( lLoteOk	.and. lDocOk )// Se n�o teve inconsist�ncia e n�o mostra a tela
			
			If !lSimula
				
				FOR nDocOk := 1 TO Len( aCT2DocOk )
					
					CT2->( DbGoTo( aCT2DocOk[ nDocOk ] ) )
					
					If nDocOk == 1
						IncProc(DTOC(CT2->CT2_DATA)+"-"+CT2->CT2_LOTE+"/"+CT2->CT2_DOC+STR0060+ALLTRIM(STR(CT2->(Recno()))))///" Gravando...Reg.: "
					EndIf
					
					//������������������������������������Ŀ
					//� Executa Ponto de Entrada antes de  �
					//� alterar o tipo de saldo no CT2     �
					//��������������������������������������
					If lCtb350Ef
						ExecBlock("CTB350EF",.F.,.F.)
					Endif
					
					//Chamar a multlock
					aTravas := {}
					
					IF !Empty(CT2->CT2_DEBITO)
						AADD(aTravas,CT2->CT2_DEBITO)
					Endif
					IF !Empty(CT2->CT2_CREDIT)
						AADD(aTravas,CT2->CT2_CREDIT)
					Endif
					
					/// VERIFICA SE O SEMAFORO DE CONTAS PERMITE GRAVA��O DOS LAN�AMENTOS/SALDOS
					If CtbCanGrv(aTravas,@lAtSldBase)
						
						BEGIN TRANSACTION
						
						// Utilizado para gerar o lancamento no PCO com o novo tipo de saldo
						PcoDetLan("000082","01","CTBA350",.T.)
						
						//Altero o tipo de saldo no lancamento contabil.
						Reclock("CT2",.F.)
						
						CT2->CT2_TPSALD := cTpSldAtu
						
						MsUnlock()
						
						If lEfeLanc
							ExecBlock("EFELANC",.F.,.F.)
						Endif
						
						If lAtSldBase
							nValor	:= CT2->CT2_VALOR
							//Os parametros lReproc e lAtSldBase estao sendo passados como .T.
							//porque sempre sera atualizado os saldos basicos na efetivacao
							aOutrEntid 	:= CtbOutrEnt(.F.)
							
							CtbGravSaldo(CT2->CT2_LOTE,CT2->CT2_SBLOTE,CT2->CT2_DOC,CT2->CT2_DATA,CT2->CT2_DC,CT2->CT2_MOEDLC,;
							CT2->CT2_DEBITO,CT2->CT2_CREDIT,CT2->CT2_CCD,CT2->CT2_CCC,CT2->CT2_ITEMD,CT2->CT2_ITEMC,;
							CT2->CT2_CLVLDB,CT2->CT2_CLVLCR,nValor,CT2->CT2_TPSALD,3,,,;
							,,,,,,,,,,lCusto,lItem,lClVL,,.T.,.F.,,,,,,,,,,,"+"/*cOperacao*/,aOutrEntid[1])
							
							//Desgravo o valor do arquivo CTC
							If CT2->CT2_DC == "3"
								GRAVACTC(CT2->CT2_LOTE,CT2->CT2_SBLOTE,CT2->CT2_DOC,'1',CT2->CT2_DATA,CT2->CT2_MOEDLC,nValor,D_PRELAN,,"-")
								GRAVACTC(CT2->CT2_LOTE,CT2->CT2_SBLOTE,CT2->CT2_DOC,'2',CT2->CT2_DATA,CT2->CT2_MOEDLC,nValor,D_PRELAN,,"-")
								GRAVACT6(CT2->CT2_LOTE,CT2->CT2_SBLOTE,'1',CT2->CT2_DATA,CT2->CT2_MOEDLC,nValor,D_PRELAN,,"-")
								GRAVACT6(CT2->CT2_LOTE,CT2->CT2_SBLOTE,'2',CT2->CT2_DATA,CT2->CT2_MOEDLC,nValor,D_PRELAN,,"-")
							Else
								GRAVACTC(CT2->CT2_LOTE,CT2->CT2_SBLOTE,CT2->CT2_DOC,CT2->CT2_DC,CT2->CT2_DATA,CT2->CT2_MOEDLC,nValor,D_PRELAN,,"-")
								GRAVACT6(CT2->CT2_LOTE,CT2->CT2_SBLOTE,CT2->CT2_DC,CT2->CT2_DATA,CT2->CT2_MOEDLC,nValor,D_PRELAN,,"-")
							Endif
						EndIf
						
						// Utilizado para gerar o lancamento no PCO com o novo tipo de saldo
						PcoDetLan("000082","02","CTBA350")
						
						END TRANSACTION
						Ct1MUnLock()
						dbCommitAll()
						
					EndIf
				NEXT nDocOk
				
			EndIf
		Endif
		
		CT2->(dbSetOrder(1))
		CT2->(MsGoto(nNextCT2))	///Vai para o pr�ximo registro a ser validado.
	EndIf
EndDo

Return

/////////////////////////////////////////////////////////////////////////////////
/// funcoes para testes
/////////////////////////////////////////////////////////////////////////////////
Static Function xCONOUT(cTexto,lResume)

Local cTxtLog := ""

DEFAULT lResume  := .F.

If !lCT350TRC
	Return
EndIf

cTxtLog := "TRACE|CTBA350|"+DTOC(Date())+"|"+Time()+"|"+ALLTRIM(STR(SECONDS()))

__cTEMPOS+= cTxtLog+cTexto+CRLF

CONOUT(cTxtLog+cTexto)

If lResume
	MsgInfo(__cTEMPOS,STR0067)//"Resumo de Tempos -> Efetiva�ao CTB"
	__cTEMPOS := ""
EndIf

Return
/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �CtbExisCTE�Autor  �CTB		         � Data �  02/06/10   ���
�������������������������������������������������������������������������͹��
���Desc.     �                                                            ���
���          �                                                            ���
�������������������������������������������������������������������������͹��
���Uso       � AP                                                         ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/
Static Function CtbExisCTE( cMoeda, cAno )
Local aArea := GetArea()
Local lRet	:= .F.

DbSelectArea( 'CTE' )
DbSetOrder( 1 )
If MsSeek( xFilial( 'CTE' ) + cMoeda )
	DbSelectArea("CTG")
	DbSetOrder(1)
	If MsSeek(xFilial("CTG")+CTE->(CTE_CALEND)+Str(cAno))
		lRet := .T.
	EndIf
EndIf

RestArea( aArea )

Return lRet

/*-------------------------------------------------------------------------
Funcao	   	  : CriaTmp
Autor         : Renato Campos
Data          : 11/08/2012
Uso           : Cria a tabela temporaria a ser usada na impress�o do relatorio
-------------------------------------------------------------------------*/
Static Function CriaTmp( aCampos, aChaves )
Local aArea		:= GetArea()
Local cArq		:= "TRB350REL"
Local cChave	:= ""
Local nIx		:= 0

Default aChaves := {}

MsErase(cArq)

MsCreate(cArq, aCampos, "TOPCONN")
dbUseArea( .T., "TOPCONN", cArq, cArq, .F., .F. )
TcRefresh(cArq)

If Len( aChaves ) > 0
	// Efetua a cria��o da tabela no banco
	For nIx := 1 TO Len( aChaves )
		cChave := aChaves[nIx]
		
		cOrdName := cArq + StrZero( nIx ,2)
		If ( !TcCanOpen(cArq,cOrdName) )
			INDEX ON &(ClearKey( cChave )) TO &(cOrdName)
   		EndIf

		DbSetIndex(cOrdName)
		DbSetNickName(OrdName(nIx),cOrdName)
	Next nIx
	
	DbSelectArea( cArq )
	DbSetOrder(1)
Endif

RestArea(aArea)

Return cArq

/*-------------------------------------------------------------------------
Funcao		  : DeleteTmp
Autor         : Renato Campos
Data          : 12/09/2016
Uso           : Executa a instru��o de exclus�o do temporario do banco
-------------------------------------------------------------------------*/
Static Function DeleteTmp( cAliasTmp )
Local aArea := GetArea()

If cAliasTmp <> NIL .And. Valtype(cAliasTmp) == "C" .And. !Empty(cAliasTmp)
	If Select(cAliasTmp) > 0
		DbSelectArea(cAliasTmp)
		dbCloseArea()
	EndIf

	MsErase(cAliasTmp)
EndIf

RestArea(aArea)

Return

/*-------------------------------------------------------------------------
Funcao		  : CtbSqlExec
Autor         : Renato Campos
Data          : 12/09/2016
Uso           : Executa a instru��o de banco via TCSQLExec
-------------------------------------------------------------------------*/
Static Function CtbSqlExec( cStatement )
Local bBlock	:= ErrorBlock( { |e| ChecErro(e) } )
Local lRetorno := .T.

BEGIN SEQUENCE
	IF TcSqlExec(cStatement) <> 0
		UserException( "Erro na instru��o de execu��o do SQL" + CRLF + TCSqlError()  + CRLF + ProcName(1) + CRLF + cStatement )
		lRetorno := .F.
	Endif
RECOVER
	lRetorno := .F.
END SEQUENCE
ErrorBlock(bBlock)

Return lRetorno

/*-------------------------------------------------------------------------
Funcao		  : CtbCriaProc()
Autor         : Renato Campos
Data          : 12/09/2016
Uso           : Executa a instru��o de banco via TCSQLExec
-------------------------------------------------------------------------*/
Static Function CtbCriaProc()
Local cQuery	:= ""
Local nPTratRec := 0
Local lOk		:= .T.

cQuery := "Create Procedure CTB350REL_" + cEmpAnt + "(" + CRLF
cQuery += "    @IN_DDATA      Char( 10 )," + CRLF
cQuery += "    @IN_LOTE       Char( " + StrZero(TAMSX3('CT2_LOTE')[1],2) + " )," + CRLF
cQuery += "    @IN_DOC        Char( " + StrZero(TAMSX3('CT2_DOC' )[1],2) + " )," + CRLF
cQuery += "    @IN_MOEDA      Char( " + StrZero(TAMSX3('CT2_MOEDLC' )[1],2) + " )," + CRLF
cQuery += "    @IN_VLRDEB     Float," + CRLF
cQuery += "    @IN_VLRCRD     Float," + CRLF
cQuery += "    @IN_DESCINC    Char( 80 )," + CRLF
cQuery += "    @OUT_RESULT    Char( 01 ) OutPut" + CRLF
cQuery += "    " + CRLF
cQuery += ")" + CRLF
cQuery += "as" + CRLF
cQuery += "declare @iRecno      Integer" + CRLF
cQuery += "    " + CRLF
cQuery += "begin" + CRLF
cQuery += "    select @OUT_RESULT = '0'" + CRLF
cQuery += "    select @iRecno   = 0" + CRLF
cQuery += "    select @iRecno = IsNull( Min(R_E_C_N_O_ ), 0) From TRB350REL" + CRLF
cQuery += "    select @iRecno = @iRecno + 1" + CRLF
cQuery += "    " + CRLF
cQuery += "    ##TRATARECNO @iRecno\" + CRLF
cQuery += "    begin tran" + CRLF
cQuery += "    INSERT INTO TRB350REL ( DDATA, LOTE, DOC, MOEDA, VLRDEB, VLRCRD, DESCINC, D_E_L_E_T_, R_E_C_N_O_ ) " + CRLF
cQuery += "                   VALUES ( @IN_DDATA, @IN_LOTE, @IN_DOC, @IN_MOEDA, @IN_VLRDEB, @IN_VLRCRD, @IN_DESCINC , '', @iRecno )" + CRLF
cQuery += "    commit tran " + CRLF
cQuery += "    ##FIMTRATARECNO" + CRLF
cQuery += "    " + CRLF
cQuery += "    select @OUT_RESULT = '1'" + CRLF
cQuery += "End" + CRLF
cQuery += "    " + CRLF

cQuery := CtbAjustaP(.T., cQuery, @nPTratRec)
cQuery := MsParse(cQuery,If(Upper(TcSrvType())= "ISERIES", "DB2", Alltrim(TcGetDB())))
cQuery := CtbAjustaP(.F., cQuery, nPTratRec)

If !TCSPExist( "CTB350REL_" + cEmpAnt )
	lOk := CtbSqlExec(cQuery)
EndIf

Return lOk