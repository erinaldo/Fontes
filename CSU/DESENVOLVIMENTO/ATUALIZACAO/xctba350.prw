#Include "CTBA350.Ch"
#Include "PROTHEUS.Ch"

#DEFINE D_PRELAN	"9"

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
user Function xCTBA350()

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
Local nCont		:= 0
Local aPergs	:= {}
Local aHelpPor	:= {}
Local aHelpEsp	:= {}
Local aHelpEng	:= {}

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

If ( !AMIIn(34) )		// Acesso somente pelo SIGACTB
	Return
EndIf
aAdd(aPergs,{	"SubLote Inicial    ?","�De SubLote        ?","Initial SubLot     ?","mv_ch9","C",3,0,0,"G","","mv_par09","","","","","","","","","","","","","","","","","","","","","","","","","","","S",""})
aAdd(aPergs,{	"SubLote Final      ?","�A SubLote         ?","Final SubLot       ?","mv_cha","C",3,0,0,"G","","mv_par10","","","","","","","","","","","","","","","","","","","","","","","","","","","S",""})


//�����������������������������������������������������������������������Ŀ
//� Pergunta 11                                                           �
//� Opcao para que o sistema exiba os lancamentos inconsistentes na tela, �
//� e o usuario possa corrigi-los para serem efetivados                   �
//�������������������������������������������������������������������������
Aadd( aHelpPor,{"Indica se o lan�amento cont�bil deve ser " , "exibido quando encontrar inconsist�ncia. " } )
Aadd( aHelpEsp,{"Indica si el asiento contable debe ser   " , "exhibido cu�ndo encontrar inconsistencia." } )
Aadd( aHelpEng,{"Indicates if the accounting entry must   " , "be displayed when to find inconsistency  " } )

Aadd(aPergs,{"Mostra Lanc Contab ?","�Muestra Asientos  ?","Display Accnt.Entry ?","mv_chb","N",1,0,2,"C","","mv_par11","Sim","Si","Yes","","","Nao","No","No","","","","","","","","","","","","","","","","","","","S",""})
PutHelp("P.CTB35011.",aHelpPor[1],aHelpEng[1],aHelpEsp[1],.T.)

AjustaSX1("CTB350", aPergs)

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
//� mv_par11 // Mostra Lancamento Contabil?  Sim/Nao				  �
//����������������������������������������������������������������
Pergunte("CTB350",.f.)

AADD(aSays,OemToAnsi( STR0002 ) )//"Transfere os lancamentos indicados com status pre-lancamento (que nao controla saldos)"
AADD(aSays,OemToAnsi( STR0003 ) )//"para o saldo informado, acompanhando relatorio de confirmacao do processamento."

//��������������������������������������������������������������Ŀ
//� Inicializa o log de processamento                            �
//����������������������������������������������������������������
ProcLogIni( aButtons )

AADD(aButtons, { 5,.T.,{|| Pergunte("CTB350",.T. ) } } )
AADD(aButtons, { 1,.T.,{|| nOpca:= 1, If( ConaOk(), FechaBatch(), nOpca:=0 ) }} )
AADD(aButtons, { 2,.T.,{|| FechaBatch() }} )

FormBatch( cCadastro, aSays, aButtons,, 160 )

If ( Select( "TRB" ) <> 0 )
	dbSelectArea ( "TRB" )
	dbCloseArea ()
Endif

//������������������������������������������������������������Ŀ
//� Crio arq. de trab. p/ gravar as inconsistencias.           �
//��������������������������������������������������������������                                        
cArqTrab		:= CriaTrab(aCampos,.t.)
cChave 			:= "TRB->DDATA+TRB->LOTE+TRB->DOC"

dbUseArea(.t.,,cArqTrab,"TRB",.f.,.f.)

IndRegua("TRB",cArqTrab,cChave,,,STR0013)//"Selecionando Registros..."

dbSelectArea( "TRB" )
dbSetIndex(cArqTrab+OrdBagExt())
dbSetOrder(1)

IF nOpca == 1
	//Verificar se o calendario esta aberto para poder efetuar a efetivacao. 
	//Somente verificar a data inicial.
	For nCont := 1 To __nQuantas                	
		lRet	:= xCtbStatus(StrZero(nCont,2),mv_par03,mv_par04) 	
		If !lRet                      		
			nOpca	:= 0             
			Exit
		EndIf
	Next
EndIf

IF nOpca == 1
	If FindFunction("CTBSERIALI")
		While !CTBSerialI("CTBPROC","ON")
		EndDo
	EndIf
	//�����������������������������������Ŀ
	//� Atualiza o log de processamento   �
	//�������������������������������������
	ProcLogAtu("INICIO")

	Processa({|lEnd| xCtb350Proc()})

	If FindFunction("CTBSERIALI")
		CTBSerialF("CTBPROC","ON")
	EndIf
	//�����������������������������������Ŀ
	//� Atualiza o log de processamento   �
	//�������������������������������������
	ProcLogAtu("FIM")

Endif

DbSelectArea( "TRB" )
DbCloseArea()
If Select("cArqTrab") = 0
	Ferase(cArqTrab+GetDBExtension())
	Ferase(cArqTrab+OrdBagExt())
EndIf	

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
static Function xCtb350Proc()

Local cTpSldAtu 	:= mv_par07	//Efetiva p/ que saldo? 
Local lCusto		:= CtbMovSaldo("CTT")
Local lItem 		:= CtbMovSaldo("CTD")
Local lClVl			:= CtbMovSaldo("CTH")
Local lCtb350Ef		:= ExistBlock("CTB350EF")
Local nValor		:= 0
Local nVlrDeb		:= 0
Local nVlrCrd		:= 0
Local lLoteOk		:= .T.
Local lDocOk		:= .T.
Local lEfLote		:= Iif(mv_par05 == 1,.T.,.F.)//.T. ->Efetiva sem bater Lote
													//.F. ->Nao efetiva sem bater Lote													
Local lEfDoc		:= Iif(mv_par06 == 1,.T.,.F.)//.T. ->Efetiva sem bater Doc
													//.F. ->Nao efetiva sem bater Doc
Local lProcessa		:= .F. 						//Indica se processou algum lote													
Local cDescInc		:= ""
Local cLoteAnt		:= ""
Local cDocAnt		:= ""
Local dDataAnt		:= CTOD("  /  /  ")                 
Local lEfeLanc 		:= ExistBlock("EFELANC")
Local lPodeGrv := .F.
Local	aErro
Local aErroTexto := {}
Local nCont

Local lMostraLct	:= ( mv_par11 == 1 )
Local lTodas
Local lTemIncons	:= .F.
Local nPriLinCT2
Local cLancAnt
Local nTotInf
Local lJaMostrou	:= .F.
//Utilizados na CTBA105
PRIVATE INCLUI := .F.
PRIVATE ALTERA := .T.
PRIVATE DELETA := .F.

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
Aadd( aErroTexto,STR0027 ) // "Erro no Tipo do Lancamento Contabil."														// 01 Help "FALTATPLAN"
//Aadd( aErroTexto,STR0028 ) // "Ausencia do Valor do Lancamento Contabil."												// 02 Help "FALTAVALOR"
Aadd( aErroTexto,STR0029 ) // "O campo historico nao pode ficar em branco."											// 03 Help "CTB105HIST"
Aadd( aErroTexto,STR0030 ) // "Este registro nao pode conter valor, pois e um complemento de historico."		// 04 Help "CONTHIST"
Aadd( aErroTexto,STR0031 ) // "Lancamento de historico complementar nao pode conter entidade preenchida."	// 05 Help "HISTNOENT"
Aadd( aErroTexto,STR0032 ) // "Lancamento a debito, porem conta debito nao digitada."								// 06 Help "FALTA DEB"
Aadd( aErroTexto,STR0033 ) // "Entidade bloqueada ou Data do lancto. menor/maior que a data da entidade."   // 07 ValidaBloq()
Aadd( aErroTexto,STR0034 ) // "Conta debito preenchida e seu respectivo digito verificador nao."				// 08 Help "DIG_DEBITO"
Aadd( aErroTexto,STR0035 ) // "Digito de Controle NAO confere com o Digito cadastrado no Plano de Contas."  // 09 Help "DIGITO"
Aadd( aErroTexto,STR0036 ) // "Amarracao entre as entidades nao permitida. Observe as regras de amarracao." // 10 CtbAmarra()
Aadd( aErroTexto,STR0037 ) // "Entidade obrigatoria nao preenchida ou Entidade proibida preenchida."		   // 11 CtbObrig()
Aadd( aErroTexto,STR0038 ) // "Lancamento a credito, porem conta credito nao digitada."							// 12 Help "FALTA CRD"
Aadd( aErroTexto,STR0039 ) // "Conta credito preenchida e seu respectivo digito verificador nao."				// 13 Help "DIG-CREDIT"
Aadd( aErroTexto,STR0040 ) // "Deve-se informar o valor em outra moeda para validar o lancamento."				// 14 Help "SEMVALUS$"
Aadd( aErroTexto,STR0041 ) // "As entidades contabeis sao iguais no debito e credito."								// 15 Help "CTAEQUA123"
Aadd( aErroTexto,STR0042 ) // "C.Custo, Item e/ou Cl.Valor nao preenchidos conforme o tipo do lancamento."	// 16 Help ""NOCTADEB
Aadd( aErroTexto,STR0042 ) // "C.Custo, Item e/ou Cl.Valor nao preenchidos conforme o tipo do lancamento."	// 17 Help "NOCTACRD"
Aadd( aErroTexto,STR0043 ) // "Ponto de Entrada 'CT105LOK'" 																// 18 P.Entrada CT105LOK

// Variaveis utilizadas na fun��o CT105LINOK()
Private __lCusto	:= CtbMovSaldo("CTT")
Private __lItem	:= CtbMovSaldo("CTD")
Private __lCLVL	:= CtbMovSaldo("CTH")
Private dDataLanc
Private OPCAO	:= 1

// Abrindo o CT2 com o alias "TMP" para sofrer as consistencias da fun��o CT105LINOK()
If Select("TMP") > 0
	TMP->( DbCloseArea() )
EndIf	

ChkFile("CT2",.F.,"TMP")

dbSelectArea("CT2")
dbSetOrder(1)
dbSeek(xFilial("CT2")+Dtos(mv_par03)+mv_par01,.T.) // Procuro por Filial+Data Inicial + Lote

ProcRegua(CT2->(RecCount()))
dDataAnt := CT2->CT2_DATA
cLoteAnt := ""
cDocAnt	 := ""  
cLancAnt := ""

While !Eof() .And. CT2->CT2_FILIAL == xFilial("CT2") .And.CT2->CT2_DATA <= mv_par04 
                                          
	If lMostraLct
		If CT2->( DTOS(CT2_DATA) + CT2_LOTE + CT2_SBLOTE + CT2_DOC ) <> cLancAnt
			// Se mudou de documento, guardar o primeiro registro p/ posicionar o CT2 para correcao do lancamento
			cLancAnt		:= CT2->( DTOS(CT2_DATA) + CT2_LOTE + CT2_SBLOTE + CT2_DOC )
			lJaMostrou	:= .F. 
			nPriLinCT2	:= CT2->( Recno() )
		EndIf
	EndIf
	
	lTemIncons	:= .F.
	
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
	
	If CT2->CT2_SBLOTE < mv_par09 .Or. CT2->CT2_SBLOTE > mv_par10
		dbSkip()
		Loop
	EndIf
	
	TMP->( DbGoTo( CT2->(Recno()) ) )
	dDataLanc := TMP->CT2_DATA // "dDataLanc" � utilizada na funcao CT105LinOK()
	aErro		 := {}
	lTodas	 := If( lJaMostrou, .T., (mv_par11 == 2) )
	
	//����������������������������������������������������������������������������������������Ŀ
	//� Verificar se ha inconsistencia (se lTodas==.T., verificara todas as inconsistencias    �
	//� do documento, caso contrario, retornara apos a primeira inconsistencia encontrada)		 �
	//������������������������������������������������������������������������������������������
	If !CT105LinOK("",.T.,@aErro,lTodas)
		lTemIncons := .T.
		If !lMostraLct	.Or. lJaMostrou	//	Se nao deve mostrar o lancto inconsistente na tela, ou se ja mostrou, gravar inconsistencia
			For nCont := 1 to Len(aErro)
	         cDescInc := aErroTexto[ aErro[nCont] ]         
				nVlrDeb 	:= IF( CT2->CT2_DC $ "13", CT2->CT2_VALOR, 0 )
				nVlrCrd 	:= IF( CT2->CT2_DC $ "23", CT2->CT2_VALOR, 0 )
				If nVlrDeb == 0 .And. nVlrCrd == 0
					nVlrDeb := nVlrCrd := CT2->CT2_VALOR
				EndIf
				xCT350GrInc(DTOC(CT2->CT2_DATA),CT2->CT2_LOTE,CT2->CT2_DOC,CT2->CT2_MOEDLC,nVlrDeb,nVlrCrd,cDescInc)
			Next
			dbSkip()
			Loop
		EndIf
	EndIf
	
	// Se tem Inconsistencias (lTemIncons = .T.) mas chegou aqui, significa que o lancamento devera ser mostrado e, 
	// por isso, nao serao verficadas novas inconsistencias (observe a variavel lTemIncons).
	
	If !lTemIncons .And. CT2->CT2_DC == "4"
		Reclock("CT2",.F.)
		CT2->CT2_TPSALD	:= cTpSldAtu
		MsUnlock()	      
		dbSkip()
		Loop
	EndIf
	
	lProcessa := .T. //Indica que ha algum reg. a processar
	         
	IncProc()
	
	If !lTemIncons .And.;	//	Se nao tem inconsistencias e;
		( (cLoteAnt != CT2->CT2_LOTE)  .Or. (CT2->CT2_DATA != dDataAnt) .Or. Empty(cLoteAnt) )
		//������������������������������������������������������Ŀ
		//� Verifico se o lote esta batendo	em todas as moedas   �
		//��������������������������������������������������������                                        
		dbSelectArea("CT6")
		dbSetOrder(1)
		If dbSeek(xFilial("CT6")+dtos(CT2->CT2_DATA)+CT2->CT2_LOTE+CT2->CT2_SBLOTE+CT2->CT2_MOEDLC+CT2->CT2_TPSALD)
	    	If CT6->CT6_DEBITO != CT6->CT6_CREDIT //Se debito e credito nao baterem
            lTemIncons := .T.
            If ! lMostraLct
					lLoteOk	:= .F.	  	                                            
					nVlrDeb := CT6->CT6_DEBITO
					nVlrCrd := CT6->CT6_CREDIT
					cDescInc := OemToAnsi(STR0014)		//"Debito e Credito do Lote nao estao batendo"
					//Gravo no arquivo temporario as inconsistencias				
					xCT350GrInc(DTOC(CT6->CT6_DATA),CT6->CT6_LOTE,,CT2->CT2_MOEDLC,nVlrDeb,nVlrCrd,cDescInc)
				EndIf
			Endif
		Endif    		   	
	Endif
	                                
	If !lTemIncons .And.;	//	Se nao tem inconsistencias e;
		( (cLoteAnt != CT2->CT2_LOTE) .Or.(cDocAnt != CT2->CT2_DOC) .Or. (CT2->CT2_DATA != dDataAnt) .Or. Empty(cLoteAnt) )
		//������������������������������������������������������������Ŀ
		//� Verifico se o documentos esta batendo em todas as moedas   �
		//��������������������������������������������������������������                                        
    
		dbSelectArea("CTC")
		dbSetOrder(1)
		If dbSeek(xFilial("CTC")+dtos(CT2->CT2_DATA)+CT2->CT2_LOTE+CT2->CT2_DOC+CT2->CT2_MOEDLC+CT2->CT2_TPSALD)
	    	If CTC->CTC_DEBITO != CTC->CTC_CREDIT //Se debito e credito baterem
            lTemIncons := .T.
            If ! lMostraLct
					lDocOk	:= .F.	  	                            
					nVlrDeb	:= CTC->CTC_DEBITO
					nVlrCrd := CTC->CTC_CREDIT                
					//Gravo no arquivo temporario as inconsistencias
					cDescInc := OemToAnsi(STR0015)		//"Debito e Credito do Documento nao estao batendo"								
					xCT350GrInc(DTOC(CTC->CTC_DATA),CTC->CTC_LOTE,CTC->CTC_DOC,CT2->CT2_MOEDLC,nVlrDeb,nVlrCrd,cDescInc)											
				EndIf
			Endif
		Endif
	Endif

	If lTemIncons .And. lMostraLct 	// Se tem inconsistencias e deve mostrar lancamento na tela
		CT2->( DbGoTo(nPriLinCT2) )	//	Posicionando no primeiro registro do lancamento

		// Buscando o total do documento                  
		dbSelectArea("CTC")
		dbSetOrder(1)
		If MsSeek(xFilial()+DtoS(CT2->CT2_DATA)+CT2->CT2_LOTE+CT2->CT2_SBLOTE+CT2->CT2_DOC+CT2->CT2_MOEDLC+CT2->CT2_TPSALD)
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
      
		dbSelectArea("CT2")
		CT2->( DbGoTo(nPriLinCT2) )	//	Posicionando no primeiro registro do lancamento

		lJaMostrou := .T.	//	Indicar que o lancamento ja foi visualizado	
		Loop					// Retornar para seguir o processamento
	EndIf
		
	If  (lEfLote .And. lEfDoc) .Or. ; 							//Efetivo sem bater Lote e Doc
		(!lEfLote .And. lLoteOk .And. lEfDoc) .Or. ;			//Lote esta batendo			
		(!lEfDoc .And. lDocOk .And. lEfLote)	.Or.;			//Documento esta batendo
		(!lEfDoc .And. lDocOk .And. !lEfLote .And. lLoteOk)	//Lote e Documento estao batendo	
		
		//������������������������������������Ŀ                    
		//� Executa Ponto de Entrada antes de  �
		//� alterar o tipo de saldo no CT2     �
		//��������������������������������������
	    If lCtb350Ef
    	   ExecBlock("CTB350EF",.F.,.F.)
	    Endif

        lPodeGrv := .F.
		While !lPodeGrv
			//Chamar a multlock	
			aTravas := {}

			IF !Empty(CT2->CT2_DEBITO)
			   AADD(aTravas,CT2->CT2_DEBITO)
			Endif
			IF !Empty(CT2->CT2_CREDIT)
			   AADD(aTravas,CT2->CT2_CREDIT)
			Endif
			
			//Chamar a multlock	
		   	IF MultLock("CT1",aTravas,1)    
				lPodeGrv := .T.
			Else
				lPodeGrv := .F.
			Endif
		    
		    If lPodeGrv 

				BEGIN TRANSACTION 
					//Altero o tipo de saldo no lancamento contabil. 	  
					Reclock("CT2",.F.)
					CT2->CT2_TPSALD := cTpSldAtu
					MsUnlock()
					
					If lEfeLanc
					   ExecBlock("EFELANC",.F.,.F.)
					Endif 	  
		
					nValor	:= CT2->CT2_VALOR
					//Os parametros lReproc e lAtSldBase estao sendo passados como .T.
					//porque sempre sera atualizado os saldos basicos na efetivacao 
			 	 	CtbGravSaldo(CT2->CT2_LOTE,CT2->CT2_SBLOTE,CT2->CT2_DOC,CT2->CT2_DATA,CT2->CT2_DC,CT2->CT2_MOEDLC,;
			 	 				CT2->CT2_DEBITO,CT2->CT2_CREDIT,CT2->CT2_CCD,CT2->CT2_CCC,CT2->CT2_ITEMD,CT2->CT2_ITEMC,;
								CT2->CT2_CLVLDB,CT2->CT2_CLVLCR,nValor,CT2->CT2_TPSALD,3,,,;
								,,,,,,,,,,lCusto,lItem,lClVL,,.T.,.F.)							
									
					//Desgravo o valor do arquivo CTC
					If CT2->CT2_DC == "3"
						DSGRAVACTC(CT2->CT2_LOTE,CT2->CT2_SBLOTE,CT2->CT2_DOC,'1',CT2->CT2_DATA,CT2->CT2_MOEDLC,nValor,D_PRELAN)
						DSGRAVACTC(CT2->CT2_LOTE,CT2->CT2_SBLOTE,CT2->CT2_DOC,'2',CT2->CT2_DATA,CT2->CT2_MOEDLC,nValor,D_PRELAN)				  
						DSGRAVACT6(CT2->CT2_LOTE,CT2->CT2_SBLOTE,'1',CT2->CT2_DATA,CT2->CT2_MOEDLC,nValor,D_PRELAN)
						DSGRAVACT6(CT2->CT2_LOTE,CT2->CT2_SBLOTE,'2',CT2->CT2_DATA,CT2->CT2_MOEDLC,nValor,D_PRELAN)
					Else
						DSGRAVACTC(CT2->CT2_LOTE,CT2->CT2_SBLOTE,CT2->CT2_DOC,CT2->CT2_DC,CT2->CT2_DATA,CT2->CT2_MOEDLC,nValor,D_PRELAN)
						DSGRAVACT6(CT2->CT2_LOTE,CT2->CT2_SBLOTE,CT2->CT2_DC,CT2->CT2_DATA,CT2->CT2_MOEDLC,nValor,D_PRELAN)			
					Endif
				END TRANSACTION 
			EndIf
		EndDo						
	Endif
	dbSelectArea("CT2")
	cLoteAnt := CT2->CT2_LOTE    
	cDocAnt  := CT2->CT2_DOC
	dDataAnt :=	 CT2->CT2_DATA 
	dbSkip()
End        

//��������������������������������������������������������������Ŀ
//� Se nao tiver inconsistencias, imprime mensagem que esta ok.	 �
//����������������������������������������������������������������
If lProcessa .And. lLoteOk .And. lDocOk
	cDescInc := OemToAnsi(STR0016)		//"Nao ha inconsistencias no lote e documento."	
	//Gravo no arquivo temporario as inconsistencias				
	xCT350GrInc(,,,,,,cDescInc)															
ElseIf !lProcessa 
	cDescInc := OemToAnsi(STR0017)		//"Nao ha lote a ser efetivado."	
	//Gravo no arquivo temporario as inconsistencias				
	xCT350GrInc(,,,,,,cDescInc)															
Endif

//������������������������������������Ŀ
//� Imprime relatorio de consistencias �
//��������������������������������������
C350ImpRel()

If Select("TMP") > 0
	TMP->( DbCloseArea() )
EndIf	

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
static Function xCt350GrInc(dData,cLote,cDoc,cMoeda,nVlrDeb,nVlrCrd,cDescInc)			

Local aSaveArea:= GetArea()	

dbSelectArea("TRB") 
Reclock("TRB",.T.)	
TRB->DDATA		:= dData
TRB->LOTE		:= cLote
TRB->DOC		:=	cDoc
TRB->MOEDA		:=	cMoeda                     
TRB->VLRDEB		:=	nVlrDeb
TRB->VLRCRD		:=  nVlrCrd
TRB->DESCINC	:=	cDescInc
MsUnlock()

RestArea(aSaveArea)

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

static Function xC350ImpRel()			
                                
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


RptStatus({|lEnd| xCTR350Imp(@lEnd,wnRel,cString,Titulo)})

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

static Function xCtr350Imp(lEnd,wnRel,cString,Titulo)			
                    
Local Li := 80
	
dbSelectArea("TRB")
dbGotop()

SetRegua(RecCount())
While !Eof()	

	If Li > 55	
		Cabec(titulo,cabec1,cabec2,NomeProg,Tamanho)
		Li := 10
	Endif
	IncRegua()
	If ! Empty(TRB->DDATA)
		@ Li,01 PSAY TRB->DDATA
		@ Li,12 PSAY TRB->LOTE
		@ Li,22 PSAY TRB->DOC		
		@ Li,32 PSAY TRB->MOEDA
		@ Li,38 PSAY TRB->VLRDEB		Picture "@E 999,999,999,999.99" 
		@ Li,57 PSAY TRB->VLRCRD		Picture "@E 999,999,999,999.99" 
		@ Li,77 PSAY TRB->DESCINC
	Else		
		@ Li,01 PSAY TRB->DESCINC
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

static Function xCt350Valid()

Local aSaveArea	:= GetArea()
Local lRet		:= .T.
Local lCusto	:= CtbMovSaldo("CTT")
Local lItem		:= CtbMovSaldo("CTD")
Local lClVl		:= CtbMovSaldo("CTH")
Local cDescInc	:= ""
Local cSayCusto		:= CtbSayApro("CTT")
Local cSayItem		:= CtbSayApro("CTD")
Local cSayClVL		:= CtbSayApro("CTH")
                     
dbSelectArea("CT2")
dbSetOrder(1)
MsSeek(xFilial("CT2")+Dtos(mv_par03)+mv_par01,.T.) // Procuro por Filial+Data Inicial + Lote

ProcRegua(CT2->(RecCount()))
dDataAnt := CT2->CT2_DATA
cLoteAnt := ""
cDocAnt	 := ""

While !Eof() .And. CT2->CT2_FILIAL == xFilial("CT2") .And. CT2->CT2_DATA <= mv_par04
	  
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
				xCT350GrInc(DTOC(CT2->CT2_DATA),CT2->CT2_LOTE,CT2->CT2_DOC,,,,cDescInc)																
			EndIf
		Endif           
		
		//����������������������������������������������������������������������������������Ŀ
		//� Verifica se a conta existe e nao e sintetica                                     �
		//������������������������������������������������������������������������������������
		dbSelectArea("CT1")
		lRet:= ValidaConta(CT2->CT2_DEBITO,"1",,,.T.,.F.)
		If !lRet	
			cDescInc	:= STR0024 + Alltrim(CT2->CT2_DEBITO) + STR0025 + CT2->CT2_LINHA //Verificar conta: 	Linha:
			xCT350GrInc(DTOC(CT2->CT2_DATA),CT2->CT2_LOTE,CT2->CT2_DOC,,,,cDescInc)																
		EndIf
		
		//����������������������������������������������������������������������������������Ŀ
		//� CENTRO DE CUSTO - DEBITO                                                         �
		//������������������������������������������������������������������������������������
		If lCusto
			lRet:= ValidaCusto(CT2->CT2_CCD,"1",,,.T.,.F.)
			If !lRet	
				cDescInc	:= STR0026+ Alltrim(cSayCusto) + " : " + Alltrim(CT2->CT2_CCD)+STR0025+CT2->CT2_LINHA //Verificar  Linha
				xCT350GrInc(DTOC(CT2->CT2_DATA),CT2->CT2_LOTE,CT2->CT2_DOC,,,,cDescInc)																
			EndIf
		EndIf
		//����������������������������������������������������������������������������������Ŀ
		//� ITEM - DEBITO 		                                                             �
		//������������������������������������������������������������������������������������
		If lItem
			lRet:= ValidItem(CT2->CT2_ITEMD,"1",,,.T.,.F.)
			If !lRet                                                                                  
				cDescInc	:= STR0026+ Alltrim(cSayItem) + " : " + Alltrim(CT2->CT2_ITEMD)+STR0025+CT2->CT2_LINHA //Verificar  Linha			
				xCT350GrInc(DTOC(CT2->CT2_DATA),CT2->CT2_LOTE,CT2->CT2_DOC,,,,cDescInc)																
			EndIf
		EndIf
		//����������������������������������������������������������������������������������Ŀ
		//� CLASSE VALOR - DEBITO 		                                                       �
		//������������������������������������������������������������������������������������
		If lCLVL
			lRet:= ValidaCLVL(CT2->CT2_CLVLDB,"1",,,.T.,.F.)
			If !lRet
				cDescInc	:= STR0026+ Alltrim(cSayClVl) + " : " + Alltrim(CT2->CT2_CLVLDB)+STR0025+CT2->CT2_LINHA //Verificar  Linha			
				xCT350GrInc(DTOC(CT2->CT2_DATA),CT2->CT2_LOTE,CT2->CT2_DOC,,,,cDescInc)																
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
				xCT350GrInc(DTOC(CT2->CT2_DATA),CT2->CT2_LOTE,CT2->CT2_DOC,,,,cDescInc)																
			EndIf									
		Endif
		//����������������������������������������������������������������������������������Ŀ
		//� Verifica se a conta existe e nao e sintetica                                     �
		//������������������������������������������������������������������������������������
		lRet := ValidaConta(CT2->CT2_CREDIT,"2",,,.T.,.F.)
		If !lRet	
			cDescInc	:= STR0024 + Alltrim(CT2->CT2_CREDIT) + STR0025 + CT2->CT2_LINHA //Verificar conta: 	Linha:		
			xCT350GrInc(DTOC(CT2->CT2_DATA),CT2->CT2_LOTE,CT2->CT2_DOC,,,,cDescInc)																
		EndIf									
				
		//����������������������������������������������������������������������������������Ŀ
		//� CENTRO DE CUSTO - CREDITO                                                        �
		//������������������������������������������������������������������������������������
		If lCusto
			lRet:= ValidaCusto(CT2->CT2_CCC,"2",,,.T.,.F.)
			If !lRet	
				cDescInc	:= STR0026+ Alltrim(cSayCusto) + " : " + Alltrim(CT2->CT2_CCC)+STR0025+CT2->CT2_LINHA //Verificar  Linha										
				xCT350GrInc(DTOC(CT2->CT2_DATA),CT2->CT2_LOTE,CT2->CT2_DOC,,,,cDescInc)																
			EndIf					
		Endif

		//����������������������������������������������������������������������������������Ŀ
		//� ITEM - CREDITO		                                                             �
		//������������������������������������������������������������������������������������
		If lItem
			lRet:= ValidItem(CT2->CT2_ITEMC,"2",,,.T.,.F.)
			If !lRet	
				cDescInc	:= STR0026+ Alltrim(cSayItem) + " : " + Alltrim(CT2->CT2_ITEMC)+STR0025+CT2->CT2_LINHA //Verificar  Linha										
				xCT350GrInc(DTOC(CT2->CT2_DATA),CT2->CT2_LOTE,CT2->CT2_DOC,,,,cDescInc)																				
			EndIf							
		Endif
		
		//����������������������������������������������������������������������������������Ŀ
		//� CLASSE VALOR - CREDITO		                                                       �
		//������������������������������������������������������������������������������������
		If lCLVL
			lRet:= ValidaCLVL(CT2->CT2_CLVLCR,"2",,,.T.,.F.)
			If !lRet	
				cDescInc	:= STR0026+ Alltrim(cSayClVl) + " : " + Alltrim(CT2->CT2_CLVLCR)+STR0025+CT2->CT2_LINHA //Verificar  Linha										
				xCT350GrInc(DTOC(CT2->CT2_DATA),CT2->CT2_LOTE,CT2->CT2_DOC,,,,cDescInc)																
			EndIf							
		EndIf	
	EndIf     
	dbSelectArea("CT2")
	dbSkip()
EndDo
	
RestArea(aSaveArea)
	
Return 

static Function xCtbStatus(cMoeda,dDataIni,dDataFim,lAll)

Local aSaveArea	:= GetArea()
Local aPeriodos	:= {}
Local lRet		:= .T.       
Local nPeriodos	:= 0

DEFAULT lAll	:= .T.		
If Month(dDataIni) = Month(dDataFim) .And. Year(dDataIni) = Year(dDataFim)
	aPeriodos	:= xCtbPeriodos(cMoeda,dDataIni,dDataFim,.F.,.F.) 
Else                                                              
	If lAll	//Se eh para verificar o calendario inteiro
		aPeriodos	:= xCtbPeriodos(cMoeda,dDataIni,dDataFim,.T.,.F.) 
	Else	//Se nao eh para verificar somente a linha do calendario solicitado. 
		aPeriodos	:= xCtbPeriodos(cMoeda,dDataIni,dDataFim,.F.,.F.) 	
	EndIf
EndIf

If !Empty(aPeriodos)
	For nPeriodos := 1 to len(aPeriodos)
		If aPeriodos[nPeriodos][4] <> '1'			
			Help(" ",1,"CTGDTCOMP")		
			lRet	:= .F.
			Exit
		EndIf
	Next
EndIf
                                                   
RestArea(aSaveArea)

Return lRet

/*/
����������������������������������������������������������������������������������������
������������������������������������������������������������������������������������Ŀ��
���Fun��o	 �CtbPeriodos� Autor � Pilar S. Albaladejo 			   � Data � 27/11/00 ���
������������������������������������������������������������������������������������Ĵ��
���Descri��o �Retorna os periodos para a moeda.                                      ���
������������������������������������������������������������������������������������Ĵ��
���Sintaxe	 �CtbPeriodos(cMoeda,dDtIni,dDtFim,lExercicio,lZeradas)                  ���
������������������������������������������������������������������������������������Ĵ��
���Retorno	 �aRet                                                        			 ���
������������������������������������������������������������������������������������Ĵ��
��� Uso		 � Generico 												 			 ���
������������������������������������������������������������������������������������Ĵ��
���Parametros� ExpC1 = Moeda                            				 			 ���
���			 � ExpD1 = Data Inicial													 ���
���			 � ExpD2 = Data Final  													 ���
���			 � ExpL1 = Indica se a verificacao do periodo deve ser por exercicio     ���
���			 � ExpL2 = Indica se a existirem calendarios fora da data solicita       ���
���			 �         Retornara matriz com informacoes em branco                    ���
�������������������������������������������������������������������������������������ٱ�
����������������������������������������������������������������������������������������
����������������������������������������������������������������������������������������
/*/
static FUNCTION xCtbPeriodos( cMoeda, dDtIni, dDtFim, lExercicio, lZeradas )


LOCAL aRet := {}
Local aAreaPer:= GetArea()
Local lAchouFim := .F.
DEFAULT lExercicio := .F.
DEFAULT lZeradas   := .T.

dDtFim := Iif(Empty(dDtFim),dDtIni,dDtFim)

// Localiza a moeda 
dbSelectArea("CTO")
dbSetOrder(1)
If MsSeek(xFilial("CTO")+cMoeda)
	dbSelectArea("CTE")
	dbSetOrder(1)    
	If MsSeek(xFilial()+cMoeda)
		While !Eof() .And. CTE_FILIAL == xFilial() .And. CTE->CTE_MOEDA == cMoeda
			// Localiza os periodos para a moeda
			dbSelectArea("CTG")
			dbSetOrder(1)
			MsSeek(xFilial()+CTE->CTE_CALEND)
			While 	CTG->(!Eof()) 							.AND.;
					CTG->CTG_FILIAL == xFilial("CTG") 		.AND.;
					CTG->CTG_CALEND == CTE->CTE_CALEND
	         // Se estiver dentro do periodo solicitado
				If 	If(lExercicio,  Year(CTG->CTG_DTFIM) <= Year(dDtFim) .And.;
									Year(CTG->CTG_DTINI) >= Year(dDtIni),;
					CTG->CTG_DTINI <= dDtIni .AND.;
					CTG->CTG_DTFIM >= dDtFim)
					// Adiciona os periodos na matriz de retorno
					Aadd( aRet, { 	CTG->CTG_DTINI, CTG->CTG_DTFIM,;
									CTG->CTG_EXERC, CTG->CTG_STATUS } )
               lAchouFim := .T.
               
            // Se o Periodo do Calendario estiver dentro do intervalo solicitado. Para atender, por exemplo, calendario com periodos diarios
				ElseIf !lExercicio .And. CTG->CTG_DTINI >= dDtIni .AND. CTG->CTG_DTINI <= dDtFim

					Aadd( aRet, { CTG->CTG_DTINI, CTG->CTG_DTFIM, CTG->CTG_EXERC, CTG->CTG_STATUS } )
               // Verificando se encontrou a data final do intervalo no calendario
               If ! lAchouFim
						lAchouFim := ( CTG->CTG_DTFIM >= dDtFim )
					EndIf

				ElseIf lZeradas
					Aadd( aRet, {	CTOD("  /  /  "), CTOD("  /  /  "), Space(4), " " })
				Endif					  
				dbSkip()
			EndDo
			dbSelectArea("CTE")
			dbSkip()
		EndDo	
		If Len(aRet) = 0
			Aadd( aRet, {	CTOD("  /  /  "), CTOD("  /  /  "), Space(4), " " })

		ElseIf !lAchouFim		//	Se nao encontrou no calendario a data final do intervalo, nao permitir continuar
			aRet := {}
			Aadd( aRet, {	CTOD("  /  /  "), CTOD("  /  /  "), Space(4), " " })
		Endif			
	Else
		Aadd( aRet, {	CTOD("  /  /  "), CTOD("  /  /  "), Space(4), " " })
	EndIf
Else                                                                         
	Aadd( aRet, {	CTOD("  /  /  "), CTOD("  /  /  "), Space(4), " " })
EndIf	

RestArea(aAreaPer)
RETURN aRet

