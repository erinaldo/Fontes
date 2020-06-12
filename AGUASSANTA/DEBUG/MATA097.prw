#INCLUDE "PROTHEUS.CH"
#INCLUDE "MATA097.CH"
#INCLUDE "FWMVCDEF.CH"
#INCLUDE "FWADAPTEREAI.CH"	
#INCLUDE "FWEVENTVIEWCONSTS.CH" 


/*/
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������Ŀ��
���Fun��o    � MATA097  � Autor � Edson Maricate        � Data �15.10.1998���
�������������������������������������������������������������������������Ĵ��
���Descri��o � Programa de liberacao de pedido de compras.                ���
���          �                                                            ���
�������������������������������������������������������������������������Ĵ��
���Sintaxe   � Void MATA097(void)                                         ���
�������������������������������������������������������������������������Ĵ��
���Retorno   � Nenhum                                                     ���
�������������������������������������������������������������������������Ĵ��
��� Uso      � Generico                                                   ���
��������������������������������������������������������������������������ٱ�
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������Ŀ��
���Descri��o � PLANO DE MELHORIA CONTINUA        �Programa     MATA097.PRX���
�������������������������������������������������������������������������Ĵ��
���ITEM PMC  � Responsavel              � Data        BOPS                ���
�������������������������������������������������������������������������Ĵ��
���      01  �Nereu Humberto Junior     � 13/03/2006  00000094227         ���
���      02  �Ricardo Berti		        � 14/12/2005                      ���
���      03  �Nereu Humberto Junior     � 13/03/2006  00000094227         ���
���      04  �Ricardo Berti		        � 14/12/2005                      ���
���      05  �ALexandre Inacio Lemes    � 30/01/2006                      ���
���      06  �Alexandre Inacio Lemes    � 30/01/2006                      ���
���      07  �Alexandre Inacio Lemes    � 10/05/2006                      ���
���      08  �Alexandre Inacio Lemes    � 05/12/2005                      ���
���      09  �Ricardo Berti             � 24/02/2006  090183              ���
���      10  �Alexandre Inacio Lemes    � 05/12/2005                      ���
���     *10  �Ricardo Berti             � 24/02/2006  090183  *Doc.funcoes���
��������������������������������������������������������������������������ٱ�
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
/*/
Function MATA097()

Local ca097User
Local cFiltraSCR
Local cFitroUs     := ""
local lFiltroUs1   :=.T. 
Local aCoresUsr    := {}
Local cFilQuery := "" 
Local cFilQry   := "" 
Local aCores       := { { 'CR_STATUS== "01"', 'BR_AZUL' },;   //Bloqueado (aguardando outros niveis)
						{ 'CR_STATUS== "02"', 'DISABLE' },;   //Aguardando Liberacao do usuario
   						{ 'CR_STATUS== "03"', 'ENABLE'  },;   //Documento Liberado pelo usuario
  						{ 'CR_STATUS== "04"', 'BR_PRETO'},;   //Documento Bloqueado pelo usuario
  						{ 'CR_STATUS== "05"', 'BR_CINZA'} }   //Documento Liberado por outro usuario
Local lSai

PRIVATE aIndexSCR		:= {}
PRIVATE bFilSCRBrw 	:= {|| Nil}
PRIVATE cXFiltraSCR 	:= ""
//��������������������������������������������������������������Ŀ
//� Define Array contendo as Rotinas a executar do programa      �
//� ----------- Elementos contidos por dimensao ------------     �
//� 1. Nome a aparecer no cabecalho                              �
//� 2. Nome da Rotina associada                                  �
//� 3. Usado pela rotina                                         �
//� 4. Tipo de Transa��o a ser efetuada                          �
//�    1 - Pesquisa e Posiciona em um Banco de Dados             �
//�    2 - Simplesmente Mostra os Campos                         �
//�    3 - Inclui registros no Bancos de Dados                   �
//�    4 - Altera o registro corrente                            �
//�    5 - Remove o registro corrente do Banco de Dados          �
//����������������������������������������������������������������
PRIVATE aRotina := MenuDef()
PRIVATE cCadastro := OemToAnsi(STR0006) // "Liberacao do PC"

If ( ExistBlock("MT097SAI"))
	lSai :=	ExecBlock("MT097SAI",.F.,.F.)
	If ( ValType(lSai) == "L" )
		If !lSai
			Return
		Endif
	EndIf
EndIf             				

//��������������������������������������������������������������Ŀ
//� Verifica se o usuario possui direito de liberacao.           �
//����������������������������������������������������������������
ca097User := RetCodUsr()
dbSelectArea("SAK")
dbSetOrder(2)
If !MsSeek(xFilial("SAK")+ca097User)
	Help(" ",1,"A097APROV") //Aviso(STR0035,STR0036,{STR0037},2) //"Acesso Restrito"###"O  acesso  e  a utilizacao desta rotina e destinada apenas aos usuarios envolvidos no processo de aprovacao de Pedido Compras definido pelos grupos de aprovacao. Usuario sem permissao para utilizar esta rotina.  "###"Voltar"
	dbSelectArea("SCR")
	dbSetOrder(1)
Else
	If Pergunte("MTA097",.T.)
	
		//������������������������������������������������������Ŀ
		//� Controle de Aprovacao : CR_STATUS -->                �
		//� 01 - Bloqueado p/ sistema (aguardando outros niveis) �
		//� 02 - Aguardando Liberacao do usuario                 �
		//� 03 - Pedido Liberado pelo usuario                    �
		//� 04 - Pedido Bloqueado pelo usuario                   �
		//� 05 - Pedido Liberado por outro usuario               �
		//��������������������������������������������������������

		dbSelectArea("SCR")
		dbSetOrder(1)   
		
		//��������������������������������������������������������������Ŀ
		//� PE: MT097IND										         �
		//����������������������������������������������������������������
		If ExistBlock("MT097IND")
			nInd:=ExecBlock("MT097IND",.F.,.F.,{})
			If ValType(nInd)=="N"
				SIX->(DbSetOrder(1))
				SIX->(DbSeek("SCR"+RetAsc(nInd,1,.T.))) 
				If !Eof()
					SCR->(DbSetOrder(nInd))
				EndIf
			EndIf
		EndIf
                            
		//���������������������������������������������������������������Ŀ
		//� Ponto de Entrada: MT097LBF   -                                |
		//� Este ponto de entrada tem como finalidade indicar se a filial �
		//| sera utilizada na filtragem dos campos para a MBrowse 		  |
		//| .T. = Considera a filial no filtro					 		  |
		//| .F. = NAO considera a filial no filtro				 		  |
		//�����������������������������������������������������������������
		If ExistBlock("MT097LBF")
			If ValType(lFiltroUs1 := ExecBlock( "MT097LBF", .f., .f. )) == "L"     
			    if !lFiltroUs1
		            cFiltraSCR  := 'CR_USER=="'+ca097User
		            cFilQry     := " CR_USER='"+ca097User+"' "
  			    Endif
  			Endif    
 		EndIf         
 		if cFiltraSCR==nil
 		    cFiltraSCR  := 'CR_FILIAL=="'+xFilial("SCR")+'"'+'.And.CR_USER=="'+ca097User
 		    cFilQry     := " CR_FILIAL='"+xFilial("SCR")+"' AND CR_USER='"+ca097User+"'"
   	    endIf		
   	    
   		Do Case
			Case mv_par01 == 1
				cFiltraSCR += '".And.CR_STATUS=="02"'
				cFilQry    += " AND CR_STATUS='02' "
			Case mv_par01 == 2
				cFiltraSCR += '".And.(CR_STATUS=="03".OR.CR_STATUS=="05")'
				cFilQry    += " AND (CR_STATUS='03' OR CR_STATUS='05') "
			Case mv_par01 == 3
				cFiltraSCR += '"'
				cFilQry    += " "
			OtherWise
				cFiltraSCR += '".And.(CR_STATUS=="01".OR.CR_STATUS=="04")'
				cFilQry    += " AND (CR_STATUS='01' OR CR_STATUS='04' ) "
		EndCase
	
		//��������������������������������������������������������������Ŀ
		//� Define ponto para o filtro de usuario                        �
		//����������������������������������������������������������������
		If ExistBlock("MT097FIL" )
			If ValType( cFiltroUs := ExecBlock( "MT097FIL", .f., .f. ) ) == "C"
				cFiltraSCR += " .And. " + cFiltroUs
			EndIf
		EndIf		
	
		cXFiltraSCR := cFiltraSCR
		set filter to  &(cFiltraSCR)

			//������������������������������������������������������������Ŀ
			//�Ponto de entrada para inclus�o de nova COR da legenda       �
			//��������������������������������������������������������������
		 	If ( ExistBlock("MT097COR") )			
		 		aCoresUsr := ExecBlock("MT097COR",.F.,.F.,{aCores})
		     	If ( ValType(aCoresUsr) == "A" )
		 			aCores :=aClone(aCoresUsr)
		 		EndIf
			EndIf
	
	
		//��������������������������������������������������������������Ŀ
		//� Endereca a funcao de BROWSE                                  �
		//����������������������������������������������������������������
	    mBrowse( 6, 1,22,75,"SCR",,,,,,aCores,,,,,,,,IIF(!Empty(cFilQuery),cFilQuery, NIL))
	
		dbClearFilter()

	EndIf
EndIf
Return Nil


/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������Ŀ��
���Fun��o    �A097Visual� Autor � Edson Maricate        � Data �15.10.1998���
�������������������������������������������������������������������������Ĵ��
���Descri��o � Programa de visualiza�ao do pedido de compras.             ���
���          �                                                            ���
�������������������������������������������������������������������������Ĵ��
���Sintaxe   � A097Visual(ExpC1,ExpN1,ExpN2)                              ���
�������������������������������������������������������������������������Ĵ��
���Parametros� ExpC1 = Alias do arquivo                                   ���
���          � ExpN1 = Numero do registro                                 ���
���          � ExpN2 = Opcao selecionada                                  ���
�������������������������������������������������������������������������Ĵ��
���Retorno   � .T.                                                        ���
�������������������������������������������������������������������������Ĵ��
��� Uso      � Generico                                                   ���
��������������������������������������������������������������������������ٱ�
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/
Function A097Visual(cAlias,nReg,nOpcx)

Local cSavAlias  := Alias()
Local cSavOrd    := IndexOrd()
Local cSavReg    := RecNo()
Local aRetAgro	 := {} // Documentos do modulo Agro

PRIVATE nTipoPed := 1
PRIVATE l120Auto := .F.
PRIVATE aRotina

If ValType(aRotina) == "U"
	aRotina := {}
	AAdd( aRotina, { '' , '' , 0, 1 } )
	AAdd( aRotina, { '' , '' , 0, 2 } )
	AAdd( aRotina, { '' , '' , 0, 3 } )
	AAdd( aRotina, { '' , '' , 0, 4 } )
	AAdd( aRotina, { '' , '' , 0, 5 } )
EndIf

If SCR->CR_TIPO == "NF"
	dbSelectArea("SF1")
	dbSetOrder(1)
	If MsSeek(xFilial("SF1")+Substr(SCR->CR_NUM,1,Len(SF1->F1_DOC+SF1->F1_SERIE+SF1->F1_FORNECE+SF1->F1_LOJA)))
		Pergunte("MTA103",.F.)
		Mata103(NIL,NIL,nOpcx)
	EndIf
ElseIf SCR->CR_TIPO == "PC" .Or. SCR->CR_TIPO == "AE" .Or. SCR->CR_TIPO == "IP"
	dbSelectArea("SC7")
	dbSetOrder(1)
	If MsSeek(xFilial("SC7")+Substr(SCR->CR_NUM,1,len(SC7->C7_NUM)))
		Mata120(NIL,NIL,NIL,nOpcx)
	EndIf
ElseIf SCR->CR_TIPO == "CP"
	dbSelectArea("SC3")
	dbSetOrder(1)
	If MsSeek(xFilial("SC3")+Substr(SCR->CR_NUM,1,len(SC3->C3_NUM)))
		Mata125(NIL,NIL,nOpcx)
	EndIf
ElseIf SCR->CR_TIPO $ "MD|IM"
	dbSelectArea("CND")
	dbSetOrder(4)
	If MsSeek(xFilial("CND")+Substr(SCR->CR_NUM,1,len(CND->CND_NUMMED)))
		PRIVATE lAuto := .F.
		If IsNewMed(CND->CND_CONTRA,CND->CND_REVISA,CND->CND_NUMMED)
			FWExecView(STR0003,'CNTA121',1,,{||.T.})
		Else
			CN130Manut("CND",CND->(Recno()),nOpcx)
		EndIf
	EndIf
ElseIf SCR->CR_TIPO $ "CT|IC"	//Documentos do Tipo Contrato
	DbSelectArea("CN9")
	DbSetOrder(1)
	If MsSeek(xFilial("CN9")+Left(SCR->CR_NUM,Len(CN9->CN9_NUMERO)))
		CN300Visua()
	EndIf
ElseIf SCR->CR_TIPO $ "RV|IR"	//Documentos do Tipo de Revis�o
	DbSelectArea("CN9")
	DbSetOrder(1)
	If MsSeek(xFilial("CN9")+Left(SCR->CR_NUM,Len(CN9->CN9_NUMERO)+Len(CN9->CN9_REVISA)))
		FWExecView(STR0003,'CNTA300',1,,{||.T.})
	EndIf
ElseIf SCR->CR_TIPO = "GA" // Documento de Garantia (SIGAJURI)	
	dbSelectArea("NV3")
	dbSetOrder(1)
	If MsSeek(xFilial("NV3")+Substr(AllTrim(SCR->CR_NUM),4,Len(AllTrim(SCR->CR_NUM))))				
		dbSelectArea("NT2")
		dbSetOrder(5)
		If MsSeek(xFilial("NT2")+NV3->NV3_CODLAN+NV3->NV3_CAJURI)
			FWExecView(STR0097,'JURA098',1,,{||.T.}) //-- Garantia
		EndIf
	EndIf	
ElseIf SCR->CR_TIPO = "SC" // Solicita��o de Compra (SIGACOM)
	dbSelectArea("SC1")
	dbSetOrder(1)
	If MsSeek(xFilial("SC1")+Substr(SCR->CR_NUM,1,len(SC1->C1_NUM)))
		Mata110(NIL,NIL,2)		
	EndIf
ElseIf SCR->CR_TIPO = "SA" // Solicita��o ao Armaz�m (SIGAEST)
	dbSelectArea("SCP")
	dbSetOrder(1)
	If MsSeek(xFilial("SCP")+Substr(SCR->CR_NUM,1,len(SCP->CP_NUM)))
		A105Visual(NIL,NIL,2)
	EndIf
	
ElseIf SCR->CR_TIPO = "ST" // Solicita��o de Trasfer�ncia
	DbSelectArea("NNS")
	DbSetOrder(1)
	If MsSeek(xFilial("NNS")+Substr(SCR->CR_NUM,1,len(NNS->NNS_COD)))
		FWExecView("Solicita��o de Transfer�ncia",'MATA311',1,,{||.T.})
	EndIf	
ElseIf SCR->CR_TIPO >= "A1" .AND. SCR->CR_TIPO <= "A9" // Documentos do modulo Agro
	
	If FindFunction("OGXUtlOrig") //Identifica que esta utilizando o sigaagr				
		If OGXUtlOrig() .AND. FindFunction("OGX701AALC")	
			aRetAgro := AGRXCOM2(SCR->CR_NUM, SCR->CR_TIPO, SCR->(Recno()))	
			
			DbSelectArea(aRetAgro[1])
			DbSetOrder(aRetAgro[2])
			If MsSeek(aRetAgro[3])
				AGRXCOM1(SCR->CR_NUM, SCR->CR_TIPO, SCR->(Recno()))	
			EndIf
		EndIf
	EndIf
	
ElseIf !Empty(aMTAlcDoc := MTGetAlcPE(SCR->CR_TIPO))
	dbSelectArea(aMTAlcDoc[2])
	dbSetOrder(aMTAlcDoc[3])
	If MsSeek(xFilial(aMTAlcDoc[2])+Substr(SCR->CR_NUM,1,Len(&(aMTAlcDoc[4]))))
		Eval(aMTAlcDoc[5])
	EndIf
EndIf

Pergunte("MTA097",.F.)
dbSelectArea(cSavAlias)
dbSetOrder(cSavOrd)
dbGoto(cSavReg)

Return(.T.)


/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������Ŀ��
���Fun��o    �A097Libera� Autor � Edson Maricate        � Data �15.10.1998���
�������������������������������������������������������������������������Ĵ��
���Descri��o � Programa de Liberacao de Pedidos de Compra.                ���
���          �                                                            ���
�������������������������������������������������������������������������Ĵ��
���Sintaxe   � Void A097Libera(ExpC1,ExpN1,ExpN2)                         ���
�������������������������������������������������������������������������Ĵ��
���Parametros� ExpC1 = Alias do arquivo                                   ���
���          � ExpN1 = Numero do registro                                 ���
���          � ExpN2 = Opcao selecionada                                  ���
�������������������������������������������������������������������������Ĵ��
���Retorno   � Nenhum                                                     ���
�������������������������������������������������������������������������Ĵ��
��� Uso      � Generico                                                   ���
��������������������������������������������������������������������������ٱ�
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/
Function A097Libera(cAlias,nReg,nOpcx)

Local aArea		:= GetArea()
Local aCposObrig:= {"D1_ITEM","D1_COD","D1_QUANT","D1_VUNIT","D1_PEDIDO","D1_ITEMPC","C7_QUANT","C7_PRECO","C7_QUJE",STR0065}
Local aHeadCpos := {}
Local aHeadSize := {}
Local aArrayNF	:= {}
Local aCampos   := {}
Local aRetSaldo := {}
Local aTolerancia := {}

Local cObs 	  := IIF(!Empty(SCR->CR_OBS),SCR->CR_OBS,SPACE(50))
Local ca097User := RetCodUsr()
Local cTipoLim  := ""
Local CRoeda    := ""
Local cAprov    := ""
Local cName     := ""
Local cSavColor := ""
Local cGrupo	:= SCR->CR_GRUPO
Local cCodLiber := SCR->CR_APROV
Local cDocto    := SCR->CR_NUM
Local cTipo     := SCR->CR_TIPO   
Local cFilDoc   := SCR->CR_FILIAL
Local dRefer 	:= dDataBase
Local cPCLib	:= ""
Local cPCUser	:= ""
                                                           
Local lShowSA2	:= .F.
Local lAprov    := .F.
Local lLiberou	:= .F.
Local lLibOk    := .F.                                               
Local lContinua := .T.
Local lShowBut  := .T.
Local lOGpaAprv := SuperGetMv("MV_OGPAPRV",.F.,.F.)
Local lVlr		:= .F.
Local lQtd		:= .F.

Local nSavOrd   := IndexOrd()        
Local nSaldo    := 0
Local nOpc      := 0
Local nSalDif	:= 0
Local nTotal    := 0
Local nMoeda	:= 1
Local nX        := 1
Local nRecnoAS400:= 1
Local nTolVlr	:= 0
Local nTolQtd	:= 0

Local oDlg
Local oDataRef
Local oSaldo
Local oSalDif
Local oBtn1
Local oBtn2
Local oBtn3
Local oQual     

Local aSize := {0,0}

Local lA097PCO	:= ExistBlock("A097PCO")
Local lLanPCO	:= .T.	//-- Podera ser modificada pelo PE A097PCO

Local lTolerNeg := GetNewPar("MV_TOLENEG",.F.)

If ExistBlock("MT097LIB")
	ExecBlock("MT097LIB",.F.,.F.)
EndIf

If ExistBlock("MT097LOK")
	lContinua := ExecBlock("MT097LOK",.F.,.F.)
	If ValType(lContinua) # 'L'
		lContinua := .T.
	Endif
EndIf

lContinua := A097LibVal("MATA097")

If lContinua .And. !Empty(SCR->CR_DATALIB) .And. SCR->CR_STATUS$"03#05"
	Help(" ",1,"A097LIB")  //Aviso(STR0038,STR0039,{STR0037},2) //"Atencao!"###"Este pedido ja foi liberado anteriormente. Somente os pedidos que estao aguardando liberacao (destacado em vermelho no Browse) poderao ser liberados."###"Voltar"
	lContinua := .F.
ElseIf lContinua .And. SCR->CR_STATUS$"01"
	Aviso("A097BLQ",STR0083,{STR0031}) //Esta opera��o n�o poder� ser realizada pois este registro se encontra bloqueado pelo sistema (aguardando outros niveis)"
	lContinua := .F.
EndIf

If lContinua
	//�������������������������������������������������������Ŀ
	//� Monta o Header com os titulos do TWBrowse             �
	//���������������������������������������������������������
	dbSelectArea("SX3")
	dbSetOrder(2)
	For nx	:= 1 to Len(aCposObrig)
		If MsSeek(aCposObrig[nx])
			AADD(aHeadCpos,AllTrim(X3Titulo()))
			AADD(aHeadSize,CalcFieldSize(SX3->X3_TIPO,SX3->X3_TAMANHO,SX3->X3_DECIMAL,SX3->X3_PICTURE,X3Titulo()))
			AADD(aCampos,{SX3->X3_CAMPO,SX3->X3_TIPO,SX3->X3_CONTEXT,SX3->X3_PICTURE})
		Else
			AADD(aHeadCpos,STR0065) // "Divergencia"
			AADD(aCampos,{" ","C"})
		EndIf
	Next
	
	SAK->(dbSetOrder(1))
	SAK->(dbSeek(xFilial("SAK")+cCodLiber))
	
	//��������������������������������������������������������������Ŀ
	//� Inicializa as variaveis utilizadas no Display.               �
	//����������������������������������������������������������������
	aRetSaldo := MaSalAlc(cCodLiber,dRefer)
	nSaldo 	  := aRetSaldo[1]
	CRoeda 	  := A097Moeda(aRetSaldo[2])
	cName  	  := UsrRetName(ca097User)
	nTotal    := xMoeda(SCR->CR_TOTAL,SCR->CR_MOEDA,aRetSaldo[2],SCR->CR_EMISSAO,,SCR->CR_TXMOEDA)
	
	Do Case
	Case SAK->AK_TIPO == "D"
		cTipoLim :=OemToAnsi(STR0007) // "Diario"
	Case  SAK->AK_TIPO == "S"
		cTipoLim := OemToAnsi(STR0008) //"Semanal"
	Case  SAK->AK_TIPO == "M"
		cTipoLim := OemToAnsi(STR0009) //"Mensal"
	Case  SAK->AK_TIPO == "A"
		cTipoLim := OemToAnsi(STR0064) //"Anual"
	EndCase
	
	dbSelectArea("SAL")
	dbSetOrder(3)
	If !MsSeek(xFilial("SAL")+cGrupo+SCR->CR_APROV) .And. !MsSeek(xFilial("SAL")+cGrupo+SCR->CR_APRORI) .And. lOGpaAprv
		Aviso("A097NOAPRV",STR0087+cGrupo+CRLF+STR0090,{"Ok"}) // "O aprovador n�o foi encontrado no grupo de aprova��o deste documento, verifique e se necess�rio inclua novamente o aprovador no grupo de aprova��o "
		lContinua := .F.
	EndIf
	
	Do Case
	Case SCR->CR_TIPO == "NF"
	
		dbSelectArea("SF1")
		dbSetOrder(1)
		MsSeek(xFilial("SF1")+Substr(SCR->CR_NUM,1,Len(SF1->F1_DOC+SF1->F1_SERIE+SF1->F1_FORNECE+SF1->F1_LOJA)))
			
		dbSelectArea("SD1")
		dbSetOrder(1)
		MsSeek(xFilial("SD1")+SF1->F1_DOC+SF1->F1_SERIE+SF1->F1_FORNECE+SF1->F1_LOJA)
	
		While ( !Eof().And. SD1->D1_FILIAL == xFilial("SD1") .And. SD1->D1_DOC     == SF1->F1_DOC     .And. ;
				SD1->D1_SERIE  == SF1->F1_SERIE  .And. SD1->D1_FORNECE == SF1->F1_FORNECE .And. SD1->D1_LOJA == SF1->F1_LOJA )
	
			Aadd(aArrayNF,Array(Len(aCampos)))
	
			If !Empty(SD1->D1_PEDIDO)
				dbSelectArea("SC7")
				dbSetOrder(1)
				MsSeek(xFilial("SC7")+SD1->D1_PEDIDO+SD1->D1_ITEMPC)
			EndIf
			
			aTolerancia := MaAvalToler(SD1->D1_FORNECE,SD1->D1_LOJA,SD1->D1_COD)
			nTolVlr	:= aTolerancia[2]/100	//Percentual maximo para tolerancia de valor
			nTolQtd	:= aTolerancia[3]/100	//Percentual maximo para tolerancia de quantidade
	
			For nX := 1 to Len(aCampos)
	
				If Substr(aCampos[nX][1],1,2) == "D1"
					If aCampos[nX][2] == "N"
						aArrayNF[Len(aArrayNF)][nX] := Transform(SD1->(FieldGet(FieldPos(aCampos[nX][1]))),PesqPict("SD1",aCampos[nX][1]))
					Else
						aArrayNF[Len(aArrayNF)][nX] := SD1->(FieldGet(FieldPos(aCampos[nX][1])))
					Endif
				Elseif Substr(aCampos[nX][1],1,2) == "C7"
					If !Empty(SD1->D1_PEDIDO)
						If aCampos[nX][2] == "N"
							If AllTrim(aCampos[nX][1])== "C7_PRECO"
								aArrayNF[Len(aArrayNF)][nX] := Transform(xMoeda(SC7->C7_PRECO,SC7->C7_MOEDA,1,SD1->D1_EMISSAO,TamSX3("D1_VUNIT")[2],SC7->C7_TXMOEDA),PesqPict("SC7",aCampos[nX][1]))
							Else
								aArrayNF[Len(aArrayNF)][nX] := Transform(SC7->(FieldGet(FieldPos(aCampos[nX][1]))),PesqPict("SC7",aCampos[nX][1]))
							EndIf
						Else	
							aArrayNF[Len(aArrayNF)][nX] := SC7->(FieldGet(FieldPos(aCampos[nX][1])))
						Endif
					Else
						aArrayNF[Len(aArrayNF)][nX] := " "
					EndIf
				Else
					If !Empty(SD1->D1_PEDIDO)
						lQtd	:= (SD1->D1_QUANT > (SC7->C7_QUANT+(SC7->C7_QUANT*nTolQtd))) .Or. (lTolerNeg .And. (SD1->D1_QUANT < (SC7->C7_QUANT-(SC7->C7_QUANT*nTolQtd))))
						lVlr	:= (SD1->D1_VUNIT > xMoeda(SC7->C7_PRECO+(SC7->C7_PRECO*nTolVlr),SC7->C7_MOEDA,1,SD1->D1_EMISSAO,TamSX3("D1_VUNIT")[2],SC7->C7_TXMOEDA)) .Or. (lTolerNeg .And. (SD1->D1_VUNIT < xMoeda(SC7->C7_PRECO+(SC7->C7_PRECO*nTolVlr),SC7->C7_MOEDA,1,SD1->D1_EMISSAO,TamSX3("D1_VUNIT")[2],SC7->C7_TXMOEDA)))
						
						If	lQtd .And. lVlr
							aArrayNF[Len(aArrayNF)][nX] := OemToAnsi(STR0067) //Qtde/Preco
						ElseIf lQtd
							aArrayNF[Len(aArrayNF)][nX] := OemToAnsi(STR0066) //Quantidade
						ElseIf lVlr
							aArrayNF[Len(aArrayNF)][nX] := OemToAnsi(STR0068) //Preco
					    Else
							aArrayNF[Len(aArrayNF)][nX] := OemToAnsi(STR0069) //OK 
						EndIf       
					Else
						aArrayNF[Len(aArrayNF)][nX] := OemToAnsi(STR0070) //"Sem Pedido"
					EndIf
				EndIf
	
			Next nX
	
			SD1->( dbSkip() )
		EndDo
	
		dbSelectArea("SA2")
		dbSetOrder(1)
		MsSeek(xFilial("SA2")+SF1->F1_FORNECE+SF1->F1_LOJA)
			
	Case SCR->CR_TIPO $ "PC|AE|IP" 
	
		dbSelectArea("SC7")
		dbSetOrder(1)
		MsSeek(xFilial("SC7")+Substr(SCR->CR_NUM,1,len(SC7->C7_NUM)))
			
		dbSelectArea("SA2")
		dbSetOrder(1)
		MsSeek(xFilial("SA2")+SC7->C7_FORNECE+SC7->C7_LOJA) 
	
	Case SCR->CR_TIPO == "CP"
	
		dbSelectArea("SC3")
		dbSetOrder(1)
		MsSeek(xFilial("SC3")+Substr(SCR->CR_NUM,1,len(SC3->C3_NUM)))
	
		dbSelectArea("SA2")
		dbSetOrder(1)
		MsSeek(xFilial("SA2")+SC3->C3_FORNECE+SC3->C3_LOJA)
		
	Case SCR->CR_TIPO == "MD"
	
		dbSelectArea("CND")
		dbSetOrder(4)
		MsSeek(xFilial("CND")+Substr(SCR->CR_NUM,1,len(CND->CND_NUMMED)))
	
		dbSelectArea("SA2")
		dbSetOrder(1)
		MsSeek(xFilial("SA2")+CND->CND_FORNEC+CND->CND_LJFORN)
		
	Case SCR->CR_TIPO == "CT"
	
		dbSelectArea("CN9")
		dbSetOrder(1)
		MsSeek(xFilial("CN9")+Substr(SCR->CR_NUM,1,len(CN9->CN9_NUMERO)))              
            
		dbSelectArea("CNC")
		dbSetOrder(1)
		MsSeek(xFilial("CNC")+CN9->CN9_NUMERO)
	
		If CN300RetST("COMPRA")
			dbSelectArea("SA2")
			dbSetOrder(1)
			MsSeek(xFilial("SA2")+CNC->CNC_CODIGO+CNC->CNC_LOJA)
			lShowSA2 := .T.
		EndIf

	EndCase
	
	If SAL->AL_LIBAPR != "A"
		lAprov := .T.
		cAprov := OemToAnsi(STR0010) // "VISTO / LIVRE"
	EndIf
	nSalDif := nSaldo - IIF(lAprov,0,nTotal)
	If (nSalDif) < 0
		Help(" ",1,"A097SALDO") //Aviso(STR0040,STR0041,{STR0037},2) //"Saldo Insuficiente"###"Saldo na data insuficiente para efetuar a liberacao do pedido. Verifique o saldo disponivel para aprovacao na data e o valor total do pedido."###"Voltar"
		lContinua := .F.
	EndIf
EndIf
	
If lContinua
	
	lShowSA2 := SCR->CR_TIPO $ "NF|PC|AE|IP|CP|MD"
	
	If lA097PCO
		lLanPCO := ExecBlock("A097PCO",.F.,.F.,{SC7->C7_NUM,cName,lLanPCO})
	Endif

	If lLanPCO
		//-- Inicializa a gravacao dos lancamentos do SIGAPCO
		PcoIniLan("000055")
	EndIf
	
	If SCR->CR_TIPO <> "NF"
		aSize := {290,410}
	   
		//������������������������������������������������������������Ŀ
		//�Ponto de Entrada MT097DLG permite alterar o tamanho da tela.�
		//��������������������������������������������������������������
		If ExistBlock("MT097DLG")
	   		aMT097DLG:=ExecBlock("MT097DLG",.F.,.F., {aSize})
	   		If Valtype(aMT097DLG)== "A"
	   		  	aSize := aClone(aMT097DLG)
			EndIf
    	Endif
    	
		DEFINE MSDIALOG oDlg FROM 0,0 TO aSize[1],aSize[2] TITLE OemToAnsi(STR0011) PIXEL  //"Liberacao do PC"
		@ 0.5,01 TO 44,204 LABEL "" OF oDlg PIXEL
		@ 45,01  TO 128,204 LABEL "" OF oDlg PIXEL
		@ 07,06  Say OemToAnsi(STR0012) OF oDlg PIXEL //"Numero do Pedido "
		@ 07,120 Say OemToAnsi(STR0013) OF oDlg SIZE 50,9 PIXEL //"Emissao "
		If lShowSA2		
			@ 19,06  Say OemToAnsi(STR0014) OF oDlg PIXEL //"Fornecedor "
		EndIf
		@ 31,06  Say OemToAnsi(STR0015) OF oDlg PIXEL SIZE 30,9 //"Aprovador "
		@ 31,120 Say OemToAnsi(STR0016) SIZE 60,9 OF oDlg PIXEL  //"Data de ref.  "
		@ 53,06  Say OemToAnsi(STR0017) +CRoeda OF oDlg PIXEL //"Limite min."
		@ 53,103 Say OemToAnsi(STR0018)+CRoeda SIZE 60,9 OF oDlg PIXEL //"Limite max. "
		@ 65,06  Say OemToAnsi(STR0019)+CRoeda  OF oDlg PIXEL //"Limite  "
		@ 65,103 Say OemToAnsi(STR0020) OF oDlg PIXEL //"Tipo lim."
		@ 77,06  Say OemToAnsi(STR0021)+CRoeda OF oDlg PIXEL //"Saldo na data  "
		If lAprov .Or. SCR->CR_MOEDA == aRetSaldo[2]
			@ 89,06 Say OemToAnsi(STR0022)+CRoeda OF oDlg PIXEL //"Total do documento "
		Else
			@ 89,06 Say OemToAnsi(STR0091)+CRoeda OF oDlg PIXEL //"Total do documento, convertido em "
		EndIf
		@ 101,06 Say OemToAnsi(STR0023) +CRoeda SIZE 130,10 OF oDlg PIXEL //"Saldo disponivel apos liberacao  "
		@ 113,06 Say OemToAnsi(STR0033) SIZE 100,10 OF oDlg PIXEL //"Observa��es "
		If SCR->CR_TIPO == "CT"
	  		@ 07,45  MSGET SCR->CR_NUM     When .F. SIZE 65 ,9 OF oDlg PIXEL
		Else
	   		@ 07,45  MSGET SCR->CR_NUM     When .F. SIZE 28 ,9 OF oDlg PIXEL
		EndIf
		@ 07,155 MSGET SCR->CR_EMISSAO When .F. SIZE 45 ,9 OF oDlg PIXEL
		If lShowSA2
			@ 19,45  MSGET SA2->A2_NOME    When .F. SIZE 155,9 OF oDlg PIXEL
		EndIf
		@ 31,45  MSGET cName           When .F. SIZE 50 ,9 OF oDlg PIXEL
		@ 31,155 MSGET oDataRef VAR dRefer When .F. SIZE 45 ,9 OF oDlg PIXEL
 		@ 53,42  MSGET SAK->AK_LIMMIN Picture PesqPict('SAK','AK_LIMMIN')When .F. SIZE 60,9 OF oDlg PIXEL RIGHT
		@ 53,141 MSGET SAK->AK_LIMMAX Picture PesqPict('SAK','AK_LIMMAX')When .F. SIZE 59,1 OF oDlg PIXEL RIGHT
		@ 65,42  MSGET SAK->AK_LIMITE Picture PesqPict('SAK','AK_LIMITE')When .F. SIZE 60,9 OF oDlg PIXEL RIGHT
		@ 65,141 MSGET cTipoLim When .F. SIZE 59,9 OF oDlg PIXEL CENTERED
		@ 77,115 MSGET oSaldo VAR nSaldo Picture "@E 999,999,999,999.99" When .F. SIZE 85,14 OF oDlg PIXEL RIGHT
		If lAprov
			@ 89,115 MSGET cAprov Picture "@!" When .F. SIZE 85,9 OF oDlg PIXEL RIGHT
		Else
			@ 89,115 MSGET nTotal Picture "@E 999,999,999,999.99" When .F. SIZE 85,9 OF oDlg PIXEL RIGHT
		EndIf
		@ 101,115 MSGET oSaldif VAR nSalDif Picture "@E 999,999,999,999.99" When .F. SIZE 85,9 OF oDlg PIXEL RIGHT
		@ 113,115 MSGET cObs Picture "@!" SIZE 85,9 OF oDlg PIXEL
	
		If ExistBlock("MT097BUT")
			@ 132,00 BUTTON OemToAnsi(STR0063) SIZE 38 ,11  FONT oDlg:oFont ACTION (ExecBlock("MT097BUT",.F.,.F.))  OF oDlg PIXEL
		Endif
	
		If ExistBlock("MT097DTR")
			lShowBut := IIf(Valtype(lShowBut:=ExecBlock("MT097DTR",.F.,.F.,{SCR->CR_TIPO}))=='L',lShowBut,.T.) 
		Endif
	
		If lShowBut
			@ 132, 39 BUTTON OemToAnsi(STR0016) SIZE 40 ,11  FONT oDlg:oFont ACTION A097Data(oDataRef,oSaldo,oSalDif,@dRefer,aRetSaldo,@cCodLiber,@nSaldo,@cRoeda,@cName,@ca097User,@nTotal,@nSalDif,lAprov) OF oDlg PIXEL
		Endif	
	
		@ 132, 80 BUTTON OemToAnsi(STR0024) SIZE 40 ,11  FONT oDlg:oFont ACTION If(ValidPcoLan(lLanPCO) .And. A097ValObs(cObs),(nOpc:=2,oDlg:End()),Nil)  OF oDlg PIXEL
		@ 132,121 BUTTON OemToAnsi(STR0025) SIZE 40 ,11  FONT oDlg:oFont ACTION (nOpc:=1,oDlg:End())  OF oDlg PIXEL
		@ 132,162 BUTTON OemToAnsi(STR0026) SIZE 40 ,11  FONT oDlg:oFont ACTION (nOpc:=3,oDlg:End())  OF oDlg PIXEL
	   
		//����������������������������������������������������������������Ŀ
		//�Ponto de Entrada MT097SCR permite a customizacao de botoes      �
		//������������������������������������������������������������������
		If ExistBlock("MT097SCR")
			ExecBlock("MT097SCR",.F.,.F.,{@oDlg})
		EndIf
		
		ACTIVATE MSDIALOG oDlg CENTERED
	Else
		aSize := {400,780}
	    
	   	//������������������������������������������������������������Ŀ
		//�Ponto de Entrada MT097DLG permite alterar o tamanho da tela.�
		//��������������������������������������������������������������
		If ExistBlock("MT097DLG")
	   		aMT097DLG:=ExecBlock("MT097DLG",.F.,.F.,{aSize})
	   		If Valtype(aMT097DLG)== "A"
	   		  	aSize := aClone(aMT097DLG)
			EndIf
    	Endif
		
		DEFINE MSDIALOG oDlg FROM 000,000 TO aSize[1],aSize[2] TITLE OemToAnsi(STR0011) PIXEL  //"Liberacao do PC"
	
		@ 001,001  TO 050,425 LABEL "" OF oDlg PIXEL
	
		@ 007,006 Say OemToAnsi(STR0012) OF oDlg PIXEL SIZE 080,009  //"Numero do Pedido "
		@ 007,130 Say OemToAnsi(STR0013) OF oDlg PIXEL SIZE 050,009  //"Emissao "
		@ 007,216 Say OemToAnsi(STR0015) OF oDlg PIXEL SIZE 030,009  //"Aprovador "
		@ 021,006 Say OemToAnsi(STR0014) OF oDlg PIXEL SIZE 030,009  //"Fonecedor "
		@ 021,216 Say OemToAnsi(STR0016) OF oDlg PIXEL SIZE 060,009  //"Data de ref.  "
		@ 035,006 Say OemToAnsi(STR0033) OF oDlg PIXEL SIZE 100,010  //"Observa��es "
		@ 035,216 Say OemToAnsi(STR0011) OF oDlg PIXEL SIZE 100,010  //"Liberacao do docto"
	
		@ 007,045 MSGET SCR->CR_NUM        When .F. SIZE 065,009 OF oDlg PIXEL
		@ 007,155 MSGET SCR->CR_EMISSAO    When .F. SIZE 045,009 OF oDlg PIXEL
		@ 007,270 MSGET cName              When .F. SIZE 050,009 OF oDlg PIXEL RIGHT
		@ 021,045 MSGET SA2->A2_NOME       When .F. SIZE 155,009 OF oDlg PIXEL
		@ 021,270 MSGET oDataRef VAR dRefer When .F. SIZE 050,009 OF oDlg PIXEL RIGHT
		@ 035,115 MSGET cObs           Picture "@!" SIZE 085,009 OF oDlg PIXEL
		@ 035,270 MSGET OemToAnsi(STR0010) When .F. SIZE 050,009 OF oDlg PIXEL RIGHT
	
		oQual:= TWBrowse():New( 051,001,389,133,,aHeadCpos,aHeadSize,oDlg,,,,,,,,,,,,.F.,,.T.,,.F.,,,)
		oQual:SetArray(aArrayNF)
		oQual:bLine := { || aArrayNF[oQual:nAT] }
	
		If ExistBlock("MT097BUT")
			@ 187,176 BUTTON OemToAnsi(STR0063) SIZE 040,011 FONT oDlg:oFont ACTION (ExecBlock("MT097BUT",.F.,.F.))  OF oDlg PIXEL
		Endif

		If ExistBlock("MT097DTR")
			lShowBut := IIf(Valtype(lShowBut:=ExecBlock("MT097DTR",.F.,.F.,{SCR->CR_TIPO}))=='L',lShowBut,.T.) 
		Endif
	
		If lShowBut		
			@ 187,217 BUTTON OemToAnsi(STR0016) SIZE 040,011  FONT oDlg:oFont ACTION A097Data(oDataRef,oSaldo,oSalDif,@dRefer,aRetSaldo,@cCodLiber,@nSaldo,@cRoeda,@cName,@ca097User,@nTotal,@nSalDif,lAprov) OF oDlg PIXEL
		Endif
	
		@ 187,258 BUTTON OemToAnsi(STR0024) SIZE 040,011 FONT oDlg:oFont ACTION If(ValidPcoLan(lLanPCO) .And. A097ValObs(cObs),(nOpc:=2,oDlg:End()),Nil)  OF oDlg PIXEL
		@ 187,299 BUTTON OemToAnsi(STR0025) SIZE 040,011 FONT oDlg:oFont ACTION (nOpc:=1,oDlg:End()) OF oDlg PIXEL
		@ 187,340 BUTTON OemToAnsi(STR0026) SIZE 040,011 FONT oDlg:oFont ACTION (nOpc:=3,oDlg:End())  OF oDlg PIXEL
	
		//����������������������������������������������������������������Ŀ
		//�Ponto de Entrada MT097SCR permite a customizacao de botoes      �
		//������������������������������������������������������������������
		If ExistBlock("MT097SCR")
			ExecBlock("MT097SCR",.F.,.F.,{@oDlg})
		EndIf    
	
		ACTIVATE MSDIALOG oDlg CENTERED
	EndIf
	
	If nOpc == 2 .Or. nOpc == 3
		A097ProcLib(nReg,nOpc,nTotal,cCodLiber,cGrupo,cObs,dRefer)
	EndIf
	dbSelectArea("SCR")
	dbSetOrder(1)

	set filter to  &(cXFiltraSCR)
    If MV_PAR01 == 1
		SCR->(dbGoTo(nRecnoAS400))
    EndIf

	If lLanPCO
		PcoFreeBlq("000055")
	EndIf
	
EndIf
dbSelectArea("SC7")
If ExistBlock("MT097END")
	ExecBlock("MT097END",.F.,.F.,{cDocto,cTipo,nOpc,cFilDoc})
EndIf
RestArea(aArea)

Return Nil


/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������Ŀ��
���Fun��o    �A097Moeda � Autor � Edson Maricate        � Data �29.10.1998���
�������������������������������������������������������������������������Ĵ��
���Descri��o � Retorna o SIMBOLO da moeda referencia                      ���
���          �                                                            ���
�������������������������������������������������������������������������Ĵ��
���Sintaxe   � ExpC1 := A097Moeda(ExpN1)                                  ���
�������������������������������������������������������������������������Ĵ��
���Parametros� ExpN1 = Codigo da Moeda                                    ���
�������������������������������������������������������������������������Ĵ��
���Retorno   � ExpC1 = Simbolo da moeda ou string vazia                   ���
�������������������������������������������������������������������������Ĵ��
��� Uso      � Generico                                                   ���
��������������������������������������������������������������������������ٱ�
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/
Function A097Moeda(nMoeda)

Local cAuxMoeda := AllTrim(Str(nMoeda,2))
Local cRet      := GetMv("MV_SIMB"+cAuxMoeda)

If ValType(cRet) <> "C"
	cRet := ""
EndIf

Return(cRet)


/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������Ŀ��
���Fun��o    �A097Superi� Autor � Edson Maricate        � Data �15.10.1998���
�������������������������������������������������������������������������Ĵ��
���Descri��o � Programa de Liberacao de Pedidos de Compra pelo supervisor ���
���          �                                                            ���
�������������������������������������������������������������������������Ĵ��
���Sintaxe   � Void A097Superi(ExpC1,ExpN1,ExpN2)                         ���
�������������������������������������������������������������������������Ĵ��
���Parametros� ExpC1 = Alias do arquivo                                   ���
���          � ExpN1 = Numero do registro                                 ���
���          � ExpN2 = Opcao selecionada                                  ���
�������������������������������������������������������������������������Ĵ��
���Retorno   � Nenhum                                                     ���
�������������������������������������������������������������������������Ĵ��
��� Uso      � Generico                                                   ���
��������������������������������������������������������������������������ٱ�
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/
Function A097Superi(cAlias,nReg,nOpcx)

Local aArea		:= GetArea()
Local aRetSaldo := {}

Local cObs 		:= CriaVar("CR_OBS")
Local CRoeda    := ""
Local cTipoLim  := ""
Local cAprovS	:= ""
Local cAprovacao:= ""
Local cGrupo    := SCR->CR_GRUPO
Local cName     := ""
Local cSavColor := ""
Local cOriAprov := SCR->CR_APROV
Local cSavAprov := SCR->CR_APROV
Local cDocto    := SCR->CR_NUM
Local cTipo     := SCR->CR_TIPO
Local cCodLiber := SCR->CR_APROV 
Local cFilDoc   := SCR->CR_FILIAL
Local ca097User := RetCodUsr()
Local dRefer 	:= MaAlcDtRef(cOriAprov,dDataBase)
Local cPCLib	:= ""
Local cPCUser	:= ""

Local lShowSA2	 := .F.
Local lLiberou  := .F.
Local lLibOk    := .F.
Local lAprov    := .F.
Local lContinua := .T.
Local lShowBut  := .T.
Local lOGpaAprv := SuperGetMv("MV_OGPAPRV",.F.,.F.)

Local nSaldo    := 0
Local nOpc      := 0
Local nSalDif	:= 0
Local nTotal    := 0

Local oDlg
Local oDataRef
Local oSaldo
Local oSalDif

If ExistBlock("MT097LIB")
	ExecBlock("MT097LIB",.F.,.F.)
EndIf

If ExistBlock("MT097SOK")
	lContinua := ExecBlock("MT097SOK",.F.,.F.)
	If ValType(lContinua) # 'L'
		lContinua := .T.
	Endif
EndIf

If lContinua .And. !Empty(SCR->CR_DATALIB) .And. SCR->CR_STATUS$"03#05"
	Help(" ",1,"A097LIB")  //Aviso(STR0038,STR0039,{STR0037},2) //"Atencao!"###"Este pedido ja foi liberado anteriormente. Somente os pedidos que estao aguardando liberacao (destacado em vermelho no Browse) poderao ser liberados."###"Voltar"
	lContinua := .F.
ElseIf lContinua .And. SCR->CR_STATUS$"01"
	Aviso("A097BLQ",STR0083,{STR0031}) //Esta opera��o n�o poder� ser realizada pois este registro se encontra bloqueado pelo sistema (aguardando outros niveis)"
	lContinua := .F.
EndIf

If lContinua

	dbSelectArea("SAK")
	dbSetOrder(1)
	MsSeek(xFilial("SAK")+SCR->CR_APROV)

	If Empty(SAK->AK_APROSUP)
		Help(" ",1,"A097APSUP")  //Aviso(STR0044,STR0045,{STR0037},2) //"Superior nao cadastrado"###"Aprovador Superior nao cadastrado para efetuar esta operacao. Verifique o cadastro de aprovadores. "###"Voltar"
		lContinua := .F.
	EndIf
EndIf

If lContinua

	cAprovS := SAK->AK_APROSUP
	
	dbSelectArea("SAK")
	dbSetOrder(1)
	MsSeek(xFilial("SAK")+cAprovS)
	
	cOriAprov := SAK->AK_USER
	aRetSaldo := MaSalAlc(cAprovS,dRefer)
	nSaldo 	  := aRetSaldo[1]
	CRoeda 	  := A097Moeda(aRetSaldo[2])
	cName  	  := UsrRetName(cOriAprov)
	nTotal    := xMoeda(SCR->CR_TOTAL,SCR->CR_MOEDA,aRetSaldo[2],SCR->CR_EMISSAO,,SCR->CR_TXMOEDA)
	
	Do Case
	Case SAK->AK_TIPO == "D"
		cTipoLim := STR0046 //"Diario"
	Case  SAK->AK_TIPO == "S"
		cTipoLim := STR0047 //"Semanal"
	Case  SAK->AK_TIPO == "M"
		cTipoLim := STR0048 //"Mensal"
	Case  SAK->AK_TIPO == "A"
		cTipoLim := STR0064 //"Anual"
	EndCase
	
	dbSelectArea("SAL")
	dbSetorder(3)
	If !MsSeek(xFilial("SAL")+cGrupo+cAprovS) .And. lOGpaAprv
		Aviso("A097NOAPRV",STR0087+cGrupo+CRLF+STR0090,{"Ok"}) // "O aprovador n�o foi encontrado no grupo de aprova��o deste documento, verifique e se necess�rio inclua novamente o aprovador no grupo de aprova��o "
		lContinua := .F.
	EndIf
	
	dbSelectArea("SAK")
	dbSetOrder(1)
	MsSeek(xFilial("SAK")+cSavAprov)
	
	If SCR->CR_TIPO == "NF"
		dbSelectArea("SF1")
		dbSetOrder(1)
		MsSeek(xFilial("SF1")+Substr(SCR->CR_NUM,1,Len(SF1->F1_DOC+SF1->F1_SERIE+SF1->F1_FORNECE+SF1->F1_LOJA)))
		
		dbSelectArea("SA2")
		dbSetOrder(1)
		MsSeek(xFilial("SA2")+SF1->F1_FORNECE+SF1->F1_LOJA)
		
	ElseIf SCR->CR_TIPO $ "PC|AE"
		dbSelectArea("SC7")
		dbSetOrder(1)
		MsSeek(xFilial("SC7")+Substr(SCR->CR_NUM,1,len(SC7->C7_NUM)))
		cGrupo := SC7->C7_APROV
		dbSelectArea("SA2")
		dbSetOrder(1)
		MsSeek(xFilial("SA2")+SC7->C7_FORNECE+SC7->C7_LOJA)
		
	ElseIf SCR->CR_TIPO == "CP"
		dbSelectArea("SC3")
		dbSetOrder(1)
		MsSeek(xFilial("SC3")+Substr(SCR->CR_NUM,1,len(SC3->C3_NUM)))
		
		dbSelectArea("SA2")
		dbSetOrder(1)
		MsSeek(xFilial("SA2")+SC3->C3_FORNECE+SC3->C3_LOJA)
		
	ElseIf SCR->CR_TIPO == "MD"
		dbSelectArea("CND")
		dbSetOrder(4)
		MsSeek(xFilial("CND")+Substr(SCR->CR_NUM,1,len(CND->CND_NUMMED)))
		
		dbSelectArea("SA2")
		dbSetOrder(1)
		MsSeek(xFilial("SA2")+CND->CND_FORNEC+CND->CND_LJFORN)
		
	ElseIf SCR->CR_TIPO == "CT"
		
		dbSelectArea("CN9")
		dbSetOrder(1)
		MsSeek(xFilial("CN9")+Substr(SCR->CR_NUM,1,len(CN9->CN9_NUMERO)))              
		
		dbSelectArea("CNC")
		dbSetOrder(1)
		MsSeek(xFilial("CNC")+CN9->CN9_NUMERO)
		
		If CN300RetST("COMPRA")
			dbSelectArea("SA2")
			dbSetOrder(1)
			MsSeek(xFilial("SA2")+CNC->CNC_CODIGO+CNC->CNC_LOJA)
			lShowSA2 := .T.
		EndIf
	
	EndIf
	
	nSalDif := nSaldo - IIF(lAprov,0,nTotal)
	If (nSalDif) < 0
		Help(" ",1,"A097SALDO") //Aviso(STR0040,STR0041,{STR0037},2) //"Saldo Insuficiente"###"Saldo na data insuficiente para efetuar a liberacao do pedido. Verifique o saldo disponivel para aprovacao na data e o valor total do pedido."###"Voltar"
		lContinua := .F.
	EndIf

EndIf                                

If lContinua
	
	dbSelectArea("SAK")
	dbSetOrder(2)
	MsSeek(xFilial("SAK")+cOriAprov)
	
	lShowSA2 := SCR->CR_TIPO $ "NF|PC|AE|CP|MD"
	
	nSalDif := nSaldo - IIF(lAprov,0,nTotal)
	DEFINE MSDIALOG oDlg FROM 0,0 TO 290,410 TITLE OemToAnsi(STR0011) PIXEL  //"Liberacao do PC"
	@ 0.5,01 TO 44,204 LABEL "" OF oDlg PIXEL
	@ 45,01  TO 128,204 LABEL "" OF oDlg PIXEL
	@ 07,06 Say OemToAnsi(STR0012) OF oDlg PIXEL //"Numero do Pedido "
	@ 07,120 Say OemToAnsi(STR0013) OF oDlg SIZE 50,9 PIXEL //"Emissao "
	If lShowSA2
		@ 19,06 Say OemToAnsi(STR0014) OF oDlg PIXEL //"Fonecedor "
	EndIf
	@ 31,06 Say OemToAnsi(STR0015) OF oDlg PIXEL SIZE 30,9 //"Aprovador "
	@ 31,120 Say OemToAnsi(STR0016) SIZE 60,9 OF oDlg PIXEL  //"Data de ref.  "
	@ 53,06 Say OemToAnsi(STR0017) +CRoeda OF oDlg PIXEL //"Limite min."
	@ 53,103 Say OemToAnsi(STR0018)+CRoeda SIZE 60,9 OF oDlg PIXEL //"Limite max. "
	@ 65,06 Say OemToAnsi(STR0019)+CRoeda  OF oDlg PIXEL //"Limite  "
	@ 65,103 Say OemToAnsi(STR0020) OF oDlg PIXEL //"Tipo lim."
	@ 77,06 Say OemToAnsi(STR0021)+CRoeda OF oDlg PIXEL //"Saldo na data  "
	If lAprov .Or. SCR->CR_MOEDA == aRetSaldo[2]
		@ 89,06 Say OemToAnsi(STR0022)+CRoeda OF oDlg PIXEL //"Total do documento "
	Else
		@ 89,06 Say OemToAnsi(STR0091)+CRoeda OF oDlg PIXEL //"Total do documento, convertido em "
	EndIf
	@ 101,06 Say OemToAnsi(STR0023) +CRoeda SIZE 130,10 OF oDlg PIXEL //"Saldo disponivel apos liberacao  "
	@ 113,06 Say OemToAnsi(STR0033) SIZE 100,10 OF oDlg PIXEL //"Observa��es "
	If SCR->CR_TIPO == "CT"
		@ 07,45 MSGET SCR->CR_NUM When .F. SIZE 65,9 OF oDlg PIXEL
	Else  
		@ 07,45 MSGET SCR->CR_NUM When .F. SIZE 28,9 OF oDlg PIXEL
	EndIf
	@ 07,155 MSGET SCR->CR_EMISSAO When .F. SIZE 45,9 OF oDlg PIXEL
	If lShowSA2
		@ 19,45 MSGET SA2->A2_NOME When .F. SIZE 155,9 OF oDlg PIXEL
	EndIf
	@ 31,45 MSGET cName        When .F. SIZE 50,9 OF oDlg PIXEL
	@ 31,155 MSGET oDataRef VAR dRefer When .F. SIZE 45,9 OF oDlg PIXEL
	@ 53,42 MSGET SAK->AK_LIMMIN Picture PesqPict('SAK','AK_LIMMIN') When .F. SIZE 60,9 OF oDlg PIXEL RIGHT
	@ 53,141 MSGET SAK->AK_LIMMAX Picture PesqPict('SAK','AK_LIMMAX') When .F. SIZE 59,1 OF oDlg PIXEL RIGHT
	@ 65,42 MSGET SAK->AK_LIMITE Picture PesqPict('SAK','AK_LIMITE') When .F. SIZE 60,9 OF oDlg PIXEL RIGHT
	@ 65,141 MSGET cTipoLim When .F. SIZE 59,9 OF oDlg PIXEL CENTERED
	@ 77,115 MSGET oSaldo VAR nSaldo Picture "@E 999,999,999,999.99" When .F. SIZE 85,9 OF oDlg PIXEL RIGHT
	If lAprov
		@ 89,115 MSGET cAprovacao Picture "@!" When .F. SIZE 85,9 OF oDlg PIXEL RIGHT
	Else
		@ 89,115 MSGET nTotal Picture "@E 999,999,999,999.99" When .F. SIZE 85,9 OF oDlg PIXEL RIGHT
	EndIf
	@ 101,115 MSGET oSalDif VAR nSalDif Picture "@E 999,999,999,999.99" When .F. SIZE 85,9 OF oDlg PIXEL RIGHT
	@ 113,115 MSGET cObs Picture "@!" SIZE 85,9 OF oDlg PIXEL

	If ExistBlock("MT097DTR")
		lShowBut := IIf(Valtype(lShowBut:=ExecBlock("MT097DTR",.F.,.F.,{SCR->CR_TIPO}))=='L',lShowBut,.T.) 
	Endif
	
	If lShowBut		
		@ 132,39 BUTTON OemToAnsi(STR0016) SIZE 40 ,11  FONT oDlg:oFont ACTION A097Data(oDataRef,oSaldo,oSalDif,@dRefer,aRetSaldo,@cCodLiber,@nSaldo,@cRoeda,@cName,@ca097User,@nTotal,@nSalDif,lAprov) OF oDlg PIXEL
	Endif	

	@ 132,80 BUTTON OemToAnsi(STR0024) SIZE 40 ,11  FONT oDlg:oFont ACTION If(A097Pass(cOriAprov),(nOpc := 2,oDlg:End()),(nOpc:=1,oDlg:End())) OF oDlg PIXEL
	@ 132,121 BUTTON OemToAnsi(STR0025) SIZE 40 ,11  FONT oDlg:oFont ACTION (nOpc:=1,oDlg:End())  OF oDlg PIXEL
	@ 132,162 BUTTON OemToAnsi(STR0026) SIZE 40 ,11  FONT oDlg:oFont ACTION (nOpc:=3,oDlg:End())  OF oDlg PIXEL
	ACTIVATE MSDIALOG oDlg CENTERED
	
	If nOpc == 2 .Or. nOpc == 3
		A097ProcSup(nReg,nOpc,nTotal,cAprovS,cGrupo,cObs,cSavAprov,dRefer)
	EndIf
	
	dbSelectArea("SCR")
	dbSetOrder(1)
	
	set filter to  &(cXFiltraSCR)
EndIf

dbSelectArea("SC7")
If ExistBlock("MT097END")
	ExecBlock("MT097END",.F.,.F.,{cDocto,cTipo,nOpc,cFilDoc})
EndIf
RestArea(aArea)

Return Nil


/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������Ŀ��
���Fun��o    �A097VldPsw� Autor � Edson Maricate        � Data �15.10.1998���
�������������������������������������������������������������������������Ĵ��
���Descri��o � Valida a senha digitada pelo usuario.                      ���
���          �                                                            ���
�������������������������������������������������������������������������Ĵ��
���Sintaxe   � ExpL1 := A097VldPsw(ExpC1,ExpC2)                           ���
�������������������������������������������������������������������������Ĵ��
���Parametros� ExpC1 = Codigo do Usuario                                  ���
���          � ExpC2 = Senha digitada                                     ���
�������������������������������������������������������������������������Ĵ��
���Retorno   � .T. / .F.                                                  ���
�������������������������������������������������������������������������Ĵ��
��� Uso      � Generico                                                   ���
��������������������������������������������������������������������������ٱ�
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/
Function A097VldPsw(cUser,cPass)

Local lRet := .T.

PswOrder(1)
PswSeek(cUser)

If !PswName(cPass)
	Help(" ",1,"A097SENHA") //Aviso(STR0049,STR0050,{STR0037},2) //"Senha Invalida"###"Verifique a senha digitada. Digite a senha correta."###"Voltar"
	lRet := .F.
EndIf

Return(lRet)


/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������Ŀ��
���Fun��o    �A097Pass  � Autor � Edson Maricate        � Data �15.10.1998���
�������������������������������������������������������������������������Ĵ��
���Descri��o � Digita e valida a senha digitada pelo usuario.         	  ���
���          �                                                            ���
�������������������������������������������������������������������������Ĵ��
���Sintaxe   � ExpL1 := A097Pass(ExpC1)                                   ���
�������������������������������������������������������������������������Ĵ��
���Parametros� ExpC1 = Codigo do Usuario                                  ���
�������������������������������������������������������������������������Ĵ��
���Retorno   � .T. / .F.                                                  ���
�������������������������������������������������������������������������Ĵ��
��� Uso      � Generico                                                   ���
��������������������������������������������������������������������������ٱ�
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/
Function A097Pass(cUser)

Local cName := UsrRetName(cUser)
Local cPass := SPACE(20)
Local cAprov:= ""

Local lOk   := .F.

Local oDlg
Local oBtn1
Local oBtn2
Local oBtn3
Local oBut1
Local oBut2
Local oBitMap

DEFINE MSDIALOG oDlg FROM 50,100 TO 260,430 TITLE OemToAnsi(STR0006) PIXEL
@ 20,02 TO 80,163 LABEL "" OF oDlg PIXEL
@ 6,20 SAY OemToAnsi(STR0027) SIZE 122,9 Of oDlg PIXEL //" Digite a senha para o usuario a seguir."
@ 35,08 SAY OemToAnsi(STR0028) SIZE 22,9 Of oDlg PIXEL //"Nome :"
@ 55,08 SAY OemToAnsi(STR0030) SIZE 18,9 Of oDlg PIXEL //"Senha :"
@ 35,43 MSGET cName When .F. SIZE 110,10 Of oDlg PIXEL
@ 55,43 MSGET cPass SIZE 110,10 Of oDlg PIXEL PASSWORD
@ 88,70 BUTTON oBut1 PROMPT (STR0031) SIZE 44,12 Of oDlg PIXEl Action IIF(a097VldPsw(cUser,cPass),(lOk:=.T.,oDlg:End()),) //"&Ok"
@ 88,120 BUTTON oBut2 PROMPT (STR0032) SIZE 44,12 Of oDlg PIXEl Action (lOk:=.F.,oDlg:End()) //"&Cancela"
@ 5,8 BITMAP oBitmap RESOURCE "CADEADO" SIZE 10,8 Of oDlg PIXEL NOBORDER
ACTIVATE MSDIALOG oDlg

Return(lOk)


/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������Ŀ��
���Fun��o    �A097Consulta� Autor � Edson Maricate      � Data �16.11.2000���
�������������������������������������������������������������������������Ĵ��
���Descri��o �Executa a chamada da funcao de consulta de Saldos           ���
���          �                                                            ���
�������������������������������������������������������������������������Ĵ��
���Parametros�Nenhum                                                      ���
�������������������������������������������������������������������������Ĵ��
���Retorno   �Nenhum                                                      ���
�������������������������������������������������������������������������Ĵ��
��� Uso      �MATA097                                                     ���
��������������������������������������������������������������������������ٱ�
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/
Function A097Consulta()

If SCR->CR_STATUS$"01"
	Aviso("A097BLQ",STR0083,{STR0031}) //Esta opera��o n�o poder� ser realizada pois este registro se encontra bloqueado pelo sistema (aguardando outros niveis)"
Else
	A095Consulta("MTA097")
	
	dbSelectArea("SCR")
	dbSetOrder(1)
	
	If Type("cXFiltraSCR") <> "U"
		set filter to  &(cXFiltraSCR)
	EndIf
	
EndIf

Return Nil


/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������Ŀ��
���Fun��o    �A097Estorna� Autor � Edson Maricate       � Data �16.11.2000���
�������������������������������������������������������������������������Ĵ��
���Descri��o �Estorna a liberacao de todo o pedido.                       ���
���          �                                                            ���
�������������������������������������������������������������������������Ĵ��
���Parametros�Nenhum                                                      ���
�������������������������������������������������������������������������Ĵ��
���Retorno   �Nenhum                                                      ���
�������������������������������������������������������������������������Ĵ��
��� Uso      �MATA097                                                     ���
��������������������������������������������������������������������������ٱ�
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/
Function A097Estorna()

Local aArea		:= GetArea()
Local aAreaSC7	:= SC7->(GetArea())
Local aAreaSCR	:= SCR->(GetArea())
Local aMTAlcDoc := MTGetAlcPE(SCR->CR_TIPO)

Local cNumero	:= ""
Local cChave    := ""
Local cAlias    := "SC7"
Local cTipo     := SCR->CR_TIPO
Local cSituac	:= ""
Local cRevisa	:= ""

Local lEstorna	:= .T.
Local lContinua := .T.
Local lLibOk    := .F.

Local nOpc      := 0
Local nTotPC	:= 0
Local nReg		:= SCR->(Recno())
Local lLog  := GetNewPar("MV_HABLOG",.F.)
Local aSaldo := MaSalAlc(SCR->CR_APROV,MaAlcDtRef(SCR->CR_APROV,IIF(Empty(SCR->CR_DATALIB),dDataBase,SCR->CR_DATALIB)))
Local cDbCrTipo := IIF(SCR->CR_TIPO $ "PC|IP", "C7", "C1")
Local cQuery := ''
Local cAliasSC := ''




If SCR->CR_TIPO == "NF"
	dbSelectArea("SF1")
	cAlias := "SF1"
	cChave := Substr(SCR->CR_NUM,1,Len(SF1->F1_DOC+SF1->F1_SERIE+SF1->F1_FORNECE+SF1->F1_LOJA))
	If MsSeek(xFilial(cAlias)+cChave)
		If SF1->F1_STATUS $ "AB"
			Help(" ",1,"NOALTERA")
			lContinua := .F.
		EndIf
	EndIf
ElseIf SCR->CR_TIPO == "PC" .Or. SCR->CR_TIPO == "AE" .Or. (SCR->CR_TIPO == "IP" .And. ScrItComPai(SCR->CR_NUM))
	dbSelectArea("SC7")
	cAlias := "SC7"
	cChave := Substr(SCR->CR_NUM,1,len(SC7->C7_NUM))
	MsSeek(xFilial("SC7")+cChave)
	While xFilial("SC7")+Substr(SCR->CR_NUM,1,len(SC7->C7_NUM)) = SC7->C7_FILIAL+Substr(SC7->C7_NUM,1,len(SC7->C7_NUM)) .And. !Eof()
		If C7_QUJE > 0
			Help(" ",1,"NOALTERA")
			lContinua := .F.
			Exit
		EndIf
		dbSkip()
	EndDo
ElseIf SCR->CR_TIPO == "CP"
	dbSelectArea("SC3")
	cAlias := "SC3"
	cChave := Substr(SCR->CR_NUM,1,len(SC3->C3_NUM))
	MsSeek(xFilial(cAlias)+cChave)
	While xFilial("SC3")+Substr(SCR->CR_NUM,1,len(SC3->C3_NUM)) = SC3->C3_FILIAL+Substr(SC3->C3_NUM,1,len(SC3->C3_NUM)) .And. !Eof()
		If C3_QUJE > 0
			Help(" ",1,"NOALTERA")
			lContinua := .F.
			Exit
		EndIf
		dbSkip()
	EndDo
ElseIf SCR->CR_TIPO == "MD"
	dbSelectArea("CND")
	dbSetOrder(4)
	cAlias := "CND"
	cChave := Substr(SCR->CR_NUM,1,len(CND->CND_NUMMED))
	If dbSeek(xFilial(cAlias)+cChave)
		If !Empty(CND->CND_DTFIM)
			Help(" ",1,"NOALTERA")
			lContinua := .F.
		EndIf
	EndIf
ElseIf SCR->CR_TIPO == "SC" // Solicita��o de Compras(SIGACOM)
	SC1->(dbSetOrder(1))
	cAlias := "SC1"
	cChave := Substr(SCR->CR_NUM,1,Len(SC1->C1_NUM))
	DBM->(dbSetOrder(3))
	DBM->(dbSeek(xFilial("DBM")+SCR->(CR_TIPO+CR_NUM+CR_GRUPO+CR_ITGRP+CR_APROV+CR_APRORI)))
	While DBM->(!EOF()) .And. DBM->(DBM_FILIAL+DBM_TIPO+DBM_NUM+DBM_GRUPO+DBM_ITGRP+DBM_USAPRO+DBM_USAPOR) == SCR->(CR_FILIAL+CR_TIPO+CR_NUM+CR_GRUPO+CR_ITGRP+CR_APROV+CR_APRORI) 
		If SC1->(dbSeek(xFilial("SC1")+PadR(SCR->CR_NUM,tamSX3("C1_NUM")[1])+PadR(DBM->DBM_ITEM,tamSX3("C1_ITEM")[1])))
			If 	SC1->C1_QUJE > 0
				Help(" ",1,"NOALTERA")
				lContinua := .F.
				Exit
			EndIf
		EndIf
		DBM->(dbSkip())
	End
ElseIf SCR->CR_TIPO == "SA" // Solicita��o de Compras(SIGACOM)
	SCP->(dbSetOrder(1))
	cAlias := "SCP"
	cChave := Substr(SCR->CR_NUM,1,Len(SCP->CP_NUM))     			
	DBM->(dbSetOrder(3))
	DBM->(dbSeek(xFilial("DBM")+SCR->(CR_TIPO+CR_NUM+CR_GRUPO+CR_ITGRP+CR_APROV+CR_APRORI)))
	While DBM->(!EOF()) .And. DBM->(DBM_FILIAL+DBM_TIPO+DBM_NUM+DBM_GRUPO+DBM_ITGRP+DBM_USAPRO+DBM_USAPOR) == SCR->(CR_FILIAL+CR_TIPO+CR_NUM+CR_GRUPO+CR_ITGRP+CR_APROV+CR_APRORI)
		If SCP->(dbSeek(xFilial("SCP")+PadR(SCR->CR_NUM,tamSX3("CP_NUM")[1])+PadR(DBM->DBM_ITEM,tamSX3("CP_ITEM")[1])))
			If 	SCP->CP_QUJE > 0
				Help(" ",1,"NOALTERA")
				lContinua := .F.
				Exit
			EndIf
		EndIf
		DBM->(dbSkip())
	End
ElseIf SCR->CR_TIPO == "IP" // Item do pedido (SIGACOM)
	SC7->(dbSetOrder(1))
	cAlias := "SC1"
	cChave := Substr(SCR->CR_NUM,1,Len(SC7->C7_NUM))
	DBM->(dbSetOrder(3))
	DBM->(dbSeek(xFilial("DBM")+SCR->(CR_TIPO+CR_NUM+CR_GRUPO+CR_ITGRP+CR_APROV+CR_APRORI)))
	While DBM->(!EOF()) .And. DBM->(DBM_FILIAL+DBM_TIPO+DBM_NUM+DBM_GRUPO+DBM_ITGRP+DBM_USAPRO+DBM_USAPOR) == SCR->(CR_FILIAL+CR_TIPO+CR_NUM+CR_GRUPO+CR_ITGRP+CR_APROV+CR_APRORI)
		If SC7->(dbSeek(xFilial("SC7")+PadR(SCR->CR_NUM,tamSX3("C7_NUM")[1])+PadR(DBM->DBM_ITEM,TamSX3("C7_ITEM")[1])))
			If 	SC7->C7_QUJE > 0
				Help(" ",1,"NOALTERA")
				lContinua := .F.
				Exit
			EndIf
		EndIf
		DBM->(dbSkip())
	End
ElseIf SCR->CR_TIPO == "ST" //Solicita��o de transfer�ncia
	DbSelectArea("NNS")
	cChave := Substr(SCR->CR_NUM,1,Len(NNS->NNS_COD))	
	If MsSeek(xFilial("NNS")+cChave)
		If NNS->NNS_STATUS $ "2" // Solicita��o finalizada
			Help(" ",1,"NOALTERA")
			lContinua := .F.
		EndIf
	EndIf
ElseIf !Empty(aMTAlcDoc)	
	dbSelectArea(aMTAlcDoc[2])
	dbSetOrder(aMTAlcDoc[3])
	If MsSeek(xFilial(aMTAlcDoc[2])+Substr(SCR->CR_NUM,1,Len(&(aMTAlcDoc[4])))) .And. !Eval(aMTAlcDoc[6])
		Help(" ",1,"NOALTERA")
		lContinua := .F.		
	EndIf
EndIf

If lContinua .And. SCR->CR_STATUS$"01"
	Aviso("A097BLQ",STR0083,{STR0031}) //Esta opera��o n�o poder� ser realizada pois este registro se encontra bloqueado pelo sistema (aguardando outros niveis)"
	lContinua := .F.
EndIf

If lContinua .And. ExistBlock("MT097EOK")
	lContinua := ExecBlock("MT097EOK",.F.,.F.)
	If ValType(lContinua) # 'L'
		lContinua := .T.
	Endif
EndIf

If lContinua
	
	nOpc := Aviso(STR0038,STR0051,{STR0052,STR0053},2) //"Atencao!"###"Esta operacao estorna todos os niveis e aprovacoes anteriores e cria todo o processo de aprovacao do pedido de compras novamente. Todas as Aprovacoes efetuadas serao perdidas. Confirma o estorno ? "###"Cancelar"###"Confirma"

	If nOpc == 2
		//������������������������������������������������������������������������������������������������-Ŀ
		//Retorna valor original do Cr_total da SC7 ou SC1 quando Moeda de nota e aprovador s�o diferentes  �
		//������������������������������������������������������������������������������������������������-Ŀ
		If SCR->CR_TIPO $ "PC|IP|SC" .AND. aSaldo[2] <> SCR->CR_MOEDA
			cAliasSC := GetNextAlias()
			cQuery := "SELECT "+cDbCrTipo+"_TOTAL AS TOTAL FROM  " +RetSqlname("S"+cDbCrTipo)+ "  WHERE "+cDbCrTipo+"_NUM ="+"'" + SCR->CR_NUM+"'" + "AND "+cDbCrTipo+"_FILIAL ="+"'"+SCR->CR_FILIAL+"'"+" AND D_E_L_E_T_ <> '*' "
			cQuery := ChangeQuery(cQuery)
			dbUseArea(.T.,"TOPCONN",TcGenQry(,,cQuery),cAliasSC,.T.,.T.)	
			dbSelectArea(cAliasSC)
			SCR->CR_TOTAL := (cAliasSC)->TOTAL
			dbCloseArea()
		EndIf
		
		//�������������������������������������������������������������-Ŀ
		//� Conforme situacao do parametro abaixo, integra com o SIGAGSP �
		//�             MV_SIGAGSP - 0-Nao / 1-Integra                   �
		//������������������������������������������������������������-���
		If SuperGetMV("MV_SIGAGSP",.F.,"0") == "1"
			GSPF130()
		EndIf
		If ExistBlock("MT097EST")
			ExecBlock("MT097EST",.F.,.F.)
		EndIf
		//��������������������������������������������������Ŀ
		//� Efetua a gravacao do arquivo SCR                 �
		//����������������������������������������������������
		dbSelectArea(cAlias)
		MsSeek(xFilial(cAlias)+cChave)
		cNumero := cChave
		SCR->(dbClearFilter())
		SCR->(dbGoTo(nReg))
		
		If cTipo == "CT" .AND. !Empty(SCR->CR_NUM)	//Recebe o Num. Documento qdo e do tipo Contrato
			cNumero := SCR->CR_NUM
		EndIf
		
		lLibOk := A097Lock(cNumero,SCR->CR_TIPO)
		If lLibOk
			PcoIniLan("000055")
			Begin Transaction
				PcoDetLan("000055","02","MATA097",.T.)
				If cTipo == "NF"
					lEstorna := MaAlcDoc({SCR->CR_NUM,"NF",0,SCR->CR_LIBAPRO,,SF1->F1_APROV},SF1->F1_EMISSAO,5)
					dbSelectArea("SF1")
					Reclock("SF1",.F.)
					SF1->F1_STATUS := "B"
					MsUnlock()
				ElseIf cTipo == "PC" .Or. cTipo == "AE"					
					lEstorna := MaAlcDoc({SCR->CR_NUM,SCR->CR_TIPO,SCR->CR_TOTAL,SCR->CR_LIBAPRO,,SC7->C7_APROV},SC7->C7_EMISSAO,5)
					dbSelectArea("SC7")
					MsSeek(xFilial("SC7")+cNumero)
					If SuperGetMv("MV_EASY")=="S" .And. !EMPTY(SC7->C7_PO_EIC)
						If SW2->(MsSeek(xFilial("SW2")+SC7->C7_PO_EIC)) .AND. !Empty(SW2->W2_CONAPRO)
							Reclock("SW2",.F.)
							SW2->W2_CONAPRO := "B"
							MsUnlock()
						EndIf
					EndIf
					dbSelectArea("SC7") 

					While !Eof() .And. SC7->C7_FILIAL+Substr(SC7->C7_NUM,1,len(SC7->C7_NUM)) == xFilial("SC7")+cNumero
						Reclock("SC7",.F.)
						SC7->C7_CONAPRO := "B"
						MsUnlock()
						//Caio.Santos - 11/01/13 - Req.72
						If lLog
							RSTSCLOG("LIB",3,/*cUser*/)
						Endif
						PcoDetLan("000055","01","MATA097",.T.)
						dbSkip()
					EndDo
				ElseIf cTipo == "CP"
					lEstorna := MaAlcDoc({SCR->CR_NUM,SCR->CR_TIPO,SCR->CR_TOTAL,SCR->CR_LIBAPRO,,SC3->C3_APROV},SC3->C3_EMISSAO,5)
					dbSelectArea("SC3")
					MsSeek(xFilial("SC3")+cNumero)
					While !Eof() .And. SC3->C3_FILIAL+Substr(SC3->C3_NUM,1,len(SC3->C3_NUM)) == xFilial("SC3")+cNumero
						Reclock("SC3",.F.)
						SC3->C3_CONAPRO := "B"
						MsUnlock()
						dbSkip()
					EndDo
				ElseIf cTipo == "MD"
					lEstorna := MaAlcDoc({SCR->CR_NUM,SCR->CR_TIPO,SCR->CR_TOTAL,SCR->CR_LIBAPRO,,CND->CND_APROV},CND->CND_DTINIC,5)
					dbSelectArea("CND")
					dbSetOrder(4)
					If MsSeek(xFilial("CND")+cNumero)
						Reclock("CND",.F.)
						CND->CND_ALCAPR := "B"
						MsUnlock()
					EndIf
				ElseIf cTipo == "CT"
					dbSelectArea("CN9")
					CN9->(DbSetOrder(1))

					If CN9->(MsSeek(xFilial("CN9")+cNumero))

						If CN9->CN9_SITUAC $ "05/07/08/09/10"	//Vigente/Sol.Final./Finalizado/Em Revis�o/Revisado
							Aviso("A097ESTCTR",STR0096,{"Ok"})	//"Nao � possivel estornar o documento. O estorno � permitido apenas para documentos gerados a partir de contratos com a situa��o Em Aprova��o."
						Else
							lEstorna := MaAlcDoc({SCR->CR_NUM,SCR->CR_TIPO,SCR->CR_TOTAL,SCR->CR_LIBAPRO,,},,5)

							Reclock("CN9",.F.)
						   	CN9->CN9_SITUAC := "02"	//Em Elaboracao
							MsUnlock()
					    EndIf

					EndIf
				ElseIf cTipo == "SC" // Solicita��o de Compras(SIGACOM)					
					lEstorna := MaAlcDoc({SCR->CR_NUM,SCR->CR_TIPO,SCR->CR_TOTAL,SCR->CR_LIBAPRO,,SCR->CR_GRUPO},SC1->C1_EMISSAO,5)
					SC1->(dbSetOrder(1))
					DBM->(dbSetOrder(3))
					DBM->(dbSeek(xFilial("DBM")+SCR->(CR_TIPO+CR_NUM+CR_GRUPO+CR_ITGRP+CR_APROV+CR_APRORI)))
					While DBM->(!EOF()) .And. DBM->(DBM_FILIAL+DBM_TIPO+DBM_NUM+DBM_GRUPO+DBM_ITGRP+DBM_USAPRO+DBM_USAPOR) == SCR->(CR_FILIAL+CR_TIPO+CR_NUM+CR_GRUPO+CR_ITGRP+CR_APROV+CR_APRORI)
	 					If SC1->(dbSeek(xFilial("SC1")+DBM->(PadR(DBM_NUM,TamSX3("C1_NUM")[1])+PadR(DBM_ITEM,TamSX3("C1_ITEM")[1]))))
							Reclock("SC1",.F.)
							SC1->C1_APROV := "B"
							SC1->(MsUnlock())
						EndIf
						DBM->(dbSkip())
					End				                                        
				ElseIf cTipo == "SA"	// Solicita��o ao Armaz�m(SIGAEST)
					lEstorna := MaAlcDoc({SCR->CR_NUM,SCR->CR_TIPO,SCR->CR_TOTAL,SCR->CR_LIBAPRO,,SCR->CR_GRUPO},SCP->CP_EMISSAO,5)
					SCP->(dbSetOrder(1))
					DBM->(dbSetOrder(3))
					DBM->(dbSeek(xFilial("DBM")+SCR->(CR_TIPO+CR_NUM+CR_GRUPO+CR_ITGRP+CR_APROV+CR_APRORI)))
					While DBM->(!EOF()) .And. DBM->(DBM_FILIAL+DBM_TIPO+DBM_NUM+DBM_GRUPO+DBM_ITGRP+DBM_USAPRO+DBM_USAPOR) == SCR->(CR_FILIAL+CR_TIPO+CR_NUM+CR_GRUPO+CR_ITGRP+CR_APROV+CR_APRORI)
	 					If SCP->(dbSeek(xFilial("SCP")+DBM->(PadR(DBM_NUM,TamSX3("CP_NUM")[1])+PadR(DBM_ITEM,TamSX3("CP_ITEM")[1]))))
							Reclock("SCP",.F.)
							SCP->CP_STATSA := "B"
							SCP->(MsUnlock())
						EndIf
						DBM->(dbSkip())
					End
				ElseIf cTipo == "IP" // Item de Pedido
					lEstorna := MaAlcDoc({SCR->CR_NUM,SCR->CR_TIPO,SCR->CR_TOTAL,SCR->CR_LIBAPRO,,SCR->CR_GRUPO},SC7->C7_EMISSAO,5)
					dbSelectArea("SC7")
					SC7->(dbSetOrder(1))
					DBM->(dbSetOrder(3))
					DBM->(dbSeek(xFilial("DBM")+SCR->(CR_TIPO+CR_NUM+CR_GRUPO+CR_ITGRP+CR_APROV+CR_APRORI)))
					While DBM->(!EOF()) .And. DBM->(DBM_FILIAL+DBM_TIPO+DBM_NUM+DBM_GRUPO+DBM_ITGRP+DBM_USAPRO+DBM_USAPOR) == SCR->(CR_FILIAL+CR_TIPO+CR_NUM+CR_GRUPO+CR_ITGRP+CR_APROV+CR_APRORI)
	 					If SC7->(dbSeek(xFilial("SC7")+DBM->(PadR(DBM_NUM,TamSX3("C7_NUM")[1])+PadR(DBM_ITEM,TamSX3("C7_ITEM")[1]))))
							Reclock("SC7",.F.)
							SC7->C7_CONAPRO := "B"
							SC7->(MsUnlock())								
						EndIf
						DBM->(dbSkip())
					End
					If ScrItComPai(SCR->CR_NUM,@nTotPC)
						MaAlcDoc({SC7->C7_NUM,"PC",nTotPC,,,SC7->C7_APROV,,SC7->C7_MOEDA,SC7->C7_TXMOEDA,SC7->C7_EMISSAO},SC7->C7_EMISSAO,3)
					EndIf
				ElseIf cTipo == "ST"
					lEstorna := MaAlcDoc({SCR->CR_NUM,SCR->CR_TIPO	,SCR->CR_TOTAL	,SCR->CR_LIBAPRO,,SCR->CR_GRUPO},NNS->NNS_DATA,5)					
					DbSelectArea("NNS")
					Reclock("NNS",.F.)
						NNS->NNS_STATUS := "3"
					MsUnlock()	
				ElseIf !Empty(aMTAlcDoc)
					lEstorna := MaAlcDoc({SCR->CR_NUM,SCR->CR_TIPO	,SCR->CR_TOTAL	,SCR->CR_LIBAPRO,,SCR->CR_GRUPO},SCR->CR_EMISSAO,5)					
					dbSelectArea(aMTAlcDoc[2])
					dbSetOrder(aMTAlcDoc[3])
					MsSeek(xFilial(aMTAlcDoc[2])+Substr(SCR->CR_NUM,1,Len(&(aMTAlcDoc[4]))))
					While !EOF() .And. &(aMTAlcDoc[4]) == Substr(SCR->CR_NUM,1,Len(&(aMTAlcDoc[4])))
						Reclock(aMTAlcDoc[2],.F.)
						(aMTAlcDoc[7,1]) := aMTAlcDoc[7,2]
						MsUnlock()
						(aMTAlcDoc[2])->(dbSkip())
					End				
				EndIf
			End Transaction                               
			PcoFinLan("000055")   
			
			//������������������������������������������������������������������������Ŀ
			//� Ponto de Entrada para execucoes complementares apos gravacao dos dados �
			//��������������������������������������������������������������������������
			If ExistBlock("MT97EXPOS")
				ExecBlock("MT97EXPOS",.F.,.F.)
			EndIf
			
		Else
			Help(" ",1,"A097LOCK")

			If cTipo == "NF"
				SF1->(MsUnlockAll())
			ElseIf cTipo $ "PC|AE"
				SC7->(MsUnlockAll())
			ElseIf cTipo == "CP"
				SC3->(MsUnlockAll())
			ElseIf cTipo == "MD"
				CND->(MsUnlockAll())
			ElseIf cTipo == "ST"
				NNS->(MsUnlockAll())	
			ElseIf !Empty(aMTAlcDoc)
				(aMTAlcDoc[2])->(MsUnLockAll())				
			EndIf
		Endif
	EndIf
EndIf

RestArea(aAreaSCR)
RestArea(aAreaSC7)
RestArea(aArea)
dbSelectArea("SCR")
dbSetOrder(1)

If Type("cXFiltraSCR") <> "U"
	set filter to  &(cXFiltraSCR)
EndIf

Return Nil


/*/
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������Ŀ��
���Funcao    �Ma097Pesq � Autor �Eduardo Riera          � Data �23.01.2002���
�������������������������������������������������������������������������Ĵ��
���Descri��o �Tratamento do Filtro na Pesquisa                            ���
���          �                                                            ���
�������������������������������������������������������������������������Ĵ��
���Parametros�Nenhum                                                      ���
�������������������������������������������������������������������������Ĵ��
���Retorno   �.T.	                                                      ���
�������������������������������������������������������������������������Ĵ��
��� Uso      �Generico                                                    ���
��������������������������������������������������������������������������ٱ�
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
/*/
Function Ma097Pesq()

AxPesqui()

set filter to  &(cXFiltraSCR)


Return(.T.)


/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������Ŀ��
���Fun��o    �A097Transf� Autor � Aline Correa do Vale  � Data �23.06.2003���
�������������������������������������������������������������������������Ĵ��
���Descri��o � Programa de Transferencia da alcada para o Superior.       ���
���          �                                                            ���
�������������������������������������������������������������������������Ĵ��
���Sintaxe   � Void A097Transf(ExpC1,ExpN1)                               ���
�������������������������������������������������������������������������Ĵ��
���Parametros� ExpC1 = Alias do arquivo                                   ���
���          � ExpN1 = Numero do registro                                 ���
���          � ExpN2 = Opcao selecionada                                  ���
�������������������������������������������������������������������������Ĵ��
���Retorno   � Nenhum                                                     ���
�������������������������������������������������������������������������Ĵ��
��� Uso      � Generico                                                   ���
��������������������������������������������������������������������������ٱ�
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/
Function A097Transf(cAlias,nReg,nOpcx)

Local aArea		 := GetArea()
Local aRetSaldo  := {}

Local cObs 		 := CriaVar("CR_OBS")
Local CRoeda     := ""
Local cTipoLim   := ""
Local cAprovS	 := ""
Local cAprovacao := ""
Local cSavColor  := ""
Local cName      := ""
Local cDocto     := SCR->CR_NUM
Local cTipo      := SCR->CR_TIPO
Local cGrupo		:= SCR->CR_GRUPO
Local cSavAprov  := SCR->CR_APROV
Local cOriAprov  := SCR->CR_APROV 
Local cFilDoc    := SCR->CR_FILIAL
Local dRefer 	 	:= MaAlcDtRef(cOriAprov,dDataBase)

Local lShowSA2	  := .F.
Local lLiberou   := .F.
Local lAprov     := .F.
Local lContinua  := .T. 

Local nSaldo     := 0
Local nOpc       := 0
Local nSalDif	 := 0
Local nTotal     := 0

Local oDlg
Local oDataRef
Local oSaldo
Local oSalDif

If ExistBlock("MT097LIB")
	ExecBlock("MT097LIB",.F.,.F.)
EndIf

If ExistBlock("MT097SOK")
	lContinua := ExecBlock("MT097SOK",.F.,.F.)
	If ValType(lContinua) # 'L'
		lContinua := .T.
	Endif
EndIf

If lContinua .And. !Empty(SCR->CR_DATALIB) .And. SCR->CR_STATUS$"03#05"
	Help(" ",1,"A097LIB")  //Aviso(STR0038,STR0039,{STR0037},2) //"Atencao!"###"Este pedido ja foi liberado anteriormente. Somente os pedidos que estao aguardando liberacao (destacado em vermelho no Browse) poderao ser liberados."###"Voltar"
	lContinua := .F.
ElseIf lContinua .And. SCR->CR_STATUS$"01"
	Aviso("A097BLQ",STR0083,{STR0031}) //Esta opera��o n�o poder� ser realizada pois este registro se encontra bloqueado pelo sistema (aguardando outros niveis)"
	lContinua := .F.
EndIf

If lContinua
	dbSelectArea("SAK")
	dbSetOrder(1)
	MsSeek(xFilial("SAK")+SCR->CR_APROV)

	If Empty(SAK->AK_APROSUP)
		Help(" ",1,"A097APSUP")
		lContinua := .F.
	EndIf
EndIf

If lContinua

	cAprovS := SAK->AK_APROSUP

	dbSelectArea("SAK")
	dbSetOrder(1)
	MsSeek(xFilial("SAK")+cAprovS)

	cOriAprov := SAK->AK_USER
	aRetSaldo := MaSalAlc(cAprovS,dRefer)
	nSaldo 	  := aRetSaldo[1]
	CRoeda 	  := A097Moeda(aRetSaldo[2])
	cName  	  := UsrRetName(cOriAprov)
	nTotal    := xMoeda(SCR->CR_TOTAL,SCR->CR_MOEDA,aRetSaldo[2],SCR->CR_EMISSAO,,SCR->CR_TXMOEDA)

	Do Case
	Case SAK->AK_TIPO == "D"
		cTipoLim := STR0046 //"Diario"
	Case  SAK->AK_TIPO == "S"
		cTipoLim := STR0047 //"Semanal"
	Case  SAK->AK_TIPO == "M"
		cTipoLim := STR0048 //"Mensal"
	Case  SAK->AK_TIPO == "A"
		cTipoLim := STR0064 //"Anual"
	EndCase
	
	dbSelectArea("SAL")
	dbSetOrder(3)
	MsSeek(xFilial("SAL")+cGrupo+cAprovS)

	dbSelectArea("SAK")
	dbSetOrder(1)
	MsSeek(xFilial("SAK")+cSavAprov)

	If SCR->CR_TIPO == "NF"
		dbSelectArea("SF1")
		dbSetOrder(1)
		MsSeek(xFilial("SF1")+Substr(SCR->CR_NUM,1,Len(SF1->F1_DOC+SF1->F1_SERIE+SF1->F1_FORNECE+SF1->F1_LOJA)))
		dbSelectArea("SA2")
		dbSetOrder(1)
		MsSeek(xFilial("SA2")+SF1->F1_FORNECE+SF1->F1_LOJA)
	ElseIf SCR->CR_TIPO $ "PC|AE"
		dbSelectArea("SC7")
		dbSetOrder(1)
		MsSeek(xFilial("SC7")+Substr(SCR->CR_NUM,1,len(SC7->C7_NUM)))
		dbSelectArea("SA2")
		dbSetOrder(1)
		MsSeek(xFilial("SA2")+SC7->C7_FORNECE+SC7->C7_LOJA)
	ElseIf SCR->CR_TIPO == "CP"
		dbSelectArea("SC3")
		dbSetOrder(1)
		MsSeek(xFilial("SC3")+Substr(SCR->CR_NUM,1,len(SC3->C3_NUM)))
		dbSelectArea("SA2")
		dbSetOrder(1)
		MsSeek(xFilial("SA2")+SC3->C3_FORNECE+SC3->C3_LOJA)
	ElseIf SCR->CR_TIPO == "MD"
		dbSelectArea("CND")
		dbSetOrder(4)
		MsSeek(xFilial("CND")+Substr(SCR->CR_NUM,1,len(CND->CND_NUMMED)))
		cGrupo := CND->CND_APROV
		dbSelectArea("SA2")
		dbSetOrder(1)
		MsSeek(xFilial("SA2")+CND->CND_FORNEC+CND->CND_LJFORN)
	EndIf
	
	lShowSA2 := SCR->CR_TIPO $ "NF|PC|AE|CP|MD"

	If SAL->AL_LIBAPR != "A"
		lAprov	  := .T.
		cAprovacao := OemToAnsi(STR0010) // "VISTO / LIVRE"
	EndIf

	dbSelectArea("SAK")
	dbSetOrder(2)
	MsSeek(xFilial("SAK")+cOriAprov)

	nSalDif := nSaldo - IIF(lAprov,0,nTotal)
	DEFINE MSDIALOG oDlg FROM 0,0 TO 290,410 TITLE OemToAnsi(STR0055) PIXEL  //"Transferencia para Superior"
	@ 0.5,01  TO 44,204 LABEL ""     OF oDlg PIXEL
	@ 45 ,01  TO 128,204 LABEL ""    OF oDlg PIXEL
	@ 07 ,06  Say OemToAnsi(STR0012) OF oDlg PIXEL //"Numero do Pedido "
	@ 07 ,120 Say OemToAnsi(STR0013) OF oDlg SIZE 50,9 PIXEL //"Emissao "
	If lShowSA2
		@ 19 ,06  Say OemToAnsi(STR0014) OF oDlg PIXEL //"Fonecedor "
	EndIf
	@ 31 ,06  Say OemToAnsi(STR0005) OF oDlg PIXEL SIZE 30,9 //"Superior "
	@ 31 ,120 Say OemToAnsi(STR0016) SIZE 60,9 OF oDlg PIXEL  //"Data de ref.  "
	@ 53 ,06  Say OemToAnsi(STR0017)+CRoeda    OF oDlg PIXEL //"Limite min."
	@ 53 ,103 Say OemToAnsi(STR0018)+CRoeda SIZE 60,9 OF oDlg PIXEL //"Limite max. "
	@ 65 ,06  Say OemToAnsi(STR0019)+CRoeda OF oDlg PIXEL //"Limite  "
	@ 65 ,103 Say OemToAnsi(STR0020) OF oDlg PIXEL //"Tipo lim."
	@ 77 ,06  Say OemToAnsi(STR0021)+CRoeda OF oDlg PIXEL //"Saldo na data  "
	If lAprov .Or. SCR->CR_MOEDA == aRetSaldo[2]
		@ 89,06 Say OemToAnsi(STR0022)+CRoeda OF oDlg PIXEL //"Total do documento "
	Else
		@ 89,06 Say OemToAnsi(STR0091)+CRoeda OF oDlg PIXEL //"Total do documento, convertido em "
	EndIf
	@ 101,06  Say OemToAnsi(STR0023) +CRoeda SIZE 130,10 OF oDlg PIXEL //"Saldo disponivel apos liberacao  "
	@ 113,06  Say OemToAnsi(STR0033) SIZE 100,10 OF oDlg PIXEL //"Observa��es "
	If SCR->CR_TIPO == "CT"
		@ 07 ,45  MSGET SCR->CR_NUM     When .F. SIZE 65,9 OF oDlg PIXEL
	Else 
		@ 07 ,45  MSGET SCR->CR_NUM     When .F. SIZE 28,9 OF oDlg PIXEL
	EndIf
	@ 07 ,155 MSGET SCR->CR_EMISSAO When .F. SIZE 45,9 OF oDlg PIXEL
	If lShowSA2
		@ 19 ,45  MSGET SA2->A2_NOME    When .F. SIZE 155,9 OF oDlg PIXEL
	EndIf
	@ 31 ,45  MSGET cName           When .F. SIZE 50,9 OF oDlg PIXEL
	@ 31 ,155 MSGET oDataRef VAR dRefer When .F. SIZE 45,9 OF oDlg PIXEL
	@ 53 ,42  MSGET SAK->AK_LIMMIN Picture PesqPict('SAK','AK_LIMMIN') When .F. SIZE 60,9 OF oDlg PIXEL RIGHT
	@ 53 ,141 MSGET SAK->AK_LIMMAX Picture PesqPict('SAK','AK_LIMMAX') When .F. SIZE 59,9 OF oDlg PIXEL RIGHT
	@ 65 ,42  MSGET SAK->AK_LIMITE Picture PesqPict('SAK','AK_LIMITE') When .F. SIZE 60,9 OF oDlg PIXEL RIGHT
	@ 65 ,141 MSGET cTipoLim When .F. SIZE 45,9 OF oDlg PIXEL CENTERED
	@ 77 ,115 MSGET oSaldo VAR nSaldo Picture "@E 999,999,999,999.99" When .F. SIZE 85,14 OF oDlg PIXEL RIGHT
	
	If lAprov
		@ 89,115 MSGET cAprovacao Picture "@!" When .F. SIZE 85,9 OF oDlg PIXEL RIGHT
	Else
		@ 89,115 MSGET nTotal Picture "@E 999,999,999,999.99" When .F. SIZE 85,9 OF oDlg PIXEL RIGHT
	EndIf 
	@ 101,115 MSGET oSalDif VAR nSalDif Picture "@E 999,999,999,999.99" When .F. SIZE 85,9 OF oDlg PIXEL RIGHT
	@ 113,115 MSGET cObs Picture "@!" SIZE 85,9 OF oDlg PIXEL
	@ 132,121 BUTTON OemToAnsi(STR0025) SIZE 40 ,11  FONT oDlg:oFont ACTION (nOpc:=2,oDlg:End()) OF oDlg PIXEL
	@ 132,162 BUTTON OemToAnsi(STR0056) SIZE 40 ,11  FONT oDlg:oFont ACTION (nOpc:=1,oDlg:End()) OF oDlg PIXEL
	ACTIVATE MSDIALOG oDlg CENTERED

	If nOpc == 1  //Confirma a transferencia
		A097ProcTf(nReg,nOpc,cAprovS,cObs,dRefer)
	EndIf
	dbSelectArea("SCR")
	dbSetOrder(1)
EndIf

dbSelectArea("SC7")
If ExistBlock("MT097END")
	ExecBlock("MT097END",.F.,.F.,{cDocto,cTipo,nOpc,cFilDoc})
EndIf
RestArea(aArea)

Return Nil
    

/*/
�����������������������������������������������������������������������������
�������������������������������������������������������������������������Ŀ��
���Fun��o    �A097Legend� Autor � Aline Correa do Vale  � Data � 07.10.03 ���
�������������������������������������������������������������������������Ĵ��
���Descri��o �Cria uma janela contendo a legenda da mBrowse               ���
���          �                                                            ���
�������������������������������������������������������������������������Ĵ��
���Parametros�Nenhum                                                      ���
�������������������������������������������������������������������������Ĵ��
���Retorno   � .T.                                                        ���
�������������������������������������������������������������������������Ĵ��
��� Uso      �MATA097                                                     ���
��������������������������������������������������������������������������ٱ�
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
/*/
Function A097Legend() 

Local aLegeUsr   := {}
Local aLegenda   := {       {"BR_AZUL" , STR0057},; //Bloqueado (Aguardando outros niveis)
				  		  	{"DISABLE" , STR0058},; //Aguardando Liberacao do usuario
   							{"ENABLE"  , STR0059},; //Documento Liberado pelo usuario
  					 		{"BR_PRETO", STR0060},; //Documento Bloqueado pelo usuario
  					 		{"BR_CINZA", STR0061}}  //Documento Liberado por outro usuario
  					 		 
		If ( ExistBlock("MT097LEG") )
			aLegeUsr := ExecBlock("MT097LEG",.F.,.F.,{aLegenda})
	    	If ( ValType(aLegeUsr) == "A" )
				aLegenda := aClone(aLegeUsr)
			EndIf
		EndIf	 
		 						
		BrwLegenda(cCadastro,STR0078,aLegenda)    	

Return(.T.)


/*/
�����������������������������������������������������������������������������
�������������������������������������������������������������������������Ŀ��
���Fun��o    � A097Lock � Autor � Nereu Humberto Junior � Data � 01.09.04 ���
�������������������������������������������������������������������������Ĵ��
���Descri��o � Verifica se o pedido de compra nao esta com lock           ���
���          �                                                            ���
�������������������������������������������������������������������������Ĵ��
���Sintaxe   � ExpL1 := A097Lock(ExpC1,ExpC2)                             ���
�������������������������������������������������������������������������Ĵ��
���Parametros� ExpC1 = Codigo do Documento                                ���
���          � ExpC2 = Tipo do Documento                                  ���
�������������������������������������������������������������������������Ĵ��
���Retorno   � .T. / .F.                                                  ���
�������������������������������������������������������������������������Ĵ��
��� Uso      �MATA097                                                     ���
��������������������������������������������������������������������������ٱ�
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
/*/
Function A097Lock(cNumero,cTipo)

Local aArea    	:= GetArea()
Local lRet     	:= .F.
Local nTamC7Num	:= TamSx3("C7_NUM")[1]
Local aAreaAgro := "" // Documentos do modulo Agro

If cTipo == "NF"
	aArea := SF1->(GetArea())
	dbSelectArea("SF1")
	dbSetOrder(1)
	If MsSeek(xFilial("SF1")+cNumero)
		If Reclock("SF1")
			lRet := .T.
		Else
			lRet := .F.
		EndIf
	EndIf
ElseIf cTipo == "PC" .Or. cTipo == "AE" .Or. cTipo == "IP"
	aArea := SC7->(GetArea())
	dbSelectArea("SC7")
	SC7->(dbSetOrder(1))
	If SC7->(MsSeek(xFilial("SC7") + cNumero))
		While SC7->(!Eof()) .And. SC7->C7_FILIAL + Padr(SC7->C7_NUM,nTamC7Num) == xFilial("SC7") + cNumero
				If RecLock("SC7")
					lRet := .T.
				Else
					lRet := .F.
				Endif
			SC7->(dbSkip())
		EndDo
	EndIf
ElseIf cTipo == "CP"
	aArea := SC3->(GetArea())
	dbSelectArea("SC3")
	dbSetOrder(1)
	If MsSeek(xFilial("SC3")+cNumero)
		While !Eof() .And. SC3->C3_FILIAL+Substr(SC3->C3_NUM,1,len(SC3->C3_NUM)) == xFilial("SC3")+cNumero
			If RecLock("SC3")
				lRet := .T.
			Else
				lRet := .F.
				Exit
			Endif
			dbSkip()
		EndDo
	EndIf
ElseIf cTipo == "MD"
	aArea := CND->(GetArea())
	dbSelectArea("CND")
	dbSetOrder(4)
	If MsSeek(xFilial("CND")+cNumero)
		If RecLock("CND")
			lRet := .T.
		Else
			lRet := .F.
		Endif
	EndIf
ElseIf cTipo == "IM"
	aArea := CNE->(GetArea())
	dbSelectArea("CNE")
	dbSetOrder(4)
	If MsSeek(xFilial("CNE")+cNumero)
		If RecLock("CNE")
			lRet := .T.
		Else
			lRet := .F.
		Endif
	EndIf
ElseIf cTipo $ "CT|RV"
	aArea := CN9->(GetArea())
	dbSelectArea("CN9")
	dbSetOrder(1)
	If MsSeek(xFilial("CN9")+cNumero)
		If RecLock("CN9")
			lRet := .T.
		Else
			lRet := .F.
		Endif
	EndIf
ElseIf cTipo == "IC"
	aArea := CNB->(GetArea())
	cNumero := Left(allTrim(cNumero),TamSx3('CNB_CONTRA')[1])+Right(allTrim(cNumero),TamSx3('CNB_NUMERO')[1])
	dbSelectArea("CNB")
	CNB->(dbSetOrder(3)) //CNB_FILIAL+CNB_CONTRA+CNB_NUMERO+CNB_ITEM+CNB_REVISA
	If CNB->(MsSeek(xFilial("CNB")+cNumero))
		While !Eof() .And. AllTrim(CNB->(CNB_FILIAL+CNB_CONTRA+CNB_NUMERO)) == AllTrim(xFilial("CNB")+cNumero)
			If RecLock("CNB")
				lRet := .T.
			Else
				lRet := .F.
				Exit
			Endif
			CNB->(dbSkip())
		EndDo
	EndIf
ElseIf cTipo == "IR"
	aArea := CNB->(GetArea())
	dbSelectArea("CNB")
	dbSetOrder(1)
	If MsSeek(xFilial("CNB")+AllTrim(cNumero))
		While !Eof() .And. AllTrim(CNB->(CNB_FILIAL+CNB_CONTRA+CNB_REVISA)) == AllTrim(xFilial("CNB")+cNumero)
			If RecLock("CNB")
				lRet := .T.
			Else
				lRet := .F.
				Exit
			Endif
			dbSkip()
		EndDo
	EndIf

ElseIf cTipo == "GA" // Documento de Garantia (SIGAJURI)
	aArea := NV3->(GetArea())
	dbSelectArea("NV3")
	dbSetOrder(1)
	If MsSeek(xFilial("NV3")+Substr(AllTrim(SCR->CR_NUM),4,Len(AllTrim(SCR->CR_NUM))))				
		If RecLock("NV3")
			lRet := .T.
		Else
			lRet := .F.
		Endif
	EndIf
ElseIf cTipo == "SC" // Solicita��o de compra (SIGACOM)
	aArea := SC1->(GetArea())
	dbSelectArea("SC1")
	dbSetOrder(1)
	If MsSeek(xFilial("SC1")+AllTrim(cNumero))
		While !Eof() .And. SC1->C1_FILIAL+Substr(SC1->C1_NUM,1,len(SC1->C1_NUM)) == xFilial("SC1")+AllTrim(cNumero) 
			If RecLock("SC1")
				lRet := .T.		
			Else
				lRet := .F.
			EndIf
			dbSkip()
		End
	EndIf
ElseIf	cTipo == "SA" // Solicita��o ao armaz�m (SIGAEST)
	aArea := SCP->(GetArea())
	dbSelectArea("SCP")
	dbSetOrder(1)
	If MsSeek(xFilial("SCP")+AllTrim(cNumero))
		While !Eof() .And. SCP->CP_FILIAL+Substr(SCP->CP_NUM,1,len(SCP->CP_NUM)) == xFilial("SCP")+AllTrim(cNumero) 	
			If RecLock("SCP")
				lRet := .T.		
			Else
				lRet := .F.
			EndIf
			dbSkip()
		End		
	EndIf
ElseIf	cTipo == "ST" // Solicita��o de transfer�ncia (SIGAEST)	
	aArea := NNS->(GetArea())
	dbSelectArea("NNS")
	dbSetOrder(1)
	If MsSeek(xFilial("NNS")+cNumero)
		If Reclock("NNS")
			lRet := .T.
		Else
			lRet := .F.
		EndIf
	EndIf
ElseIf cTipo >= "A1" .AND. cTipo <= "A9" // Documentos do modulo Agro
	
	If FindFunction("OGXUtlOrig") //Identifica que esta utilizando o sigaagr				
		If OGXUtlOrig() .AND. FindFunction("OGX701AALC")	
	
			aAreaAgro := AGRXCOM2(SC1->C1_NUM,cTipo,SC1->(Recno()))
			
			aArea := (aAreaAgro[1])->(GetArea())
			dbSelectArea(aAreaAgro[1])
			dbSetOrder(aAreaAgro[2])
			If MsSeek(xFilial(aAreaAgro[1])+cNumero)
				If Reclock(aAreaAgro[1])
					lRet := .T.
				Else
					lRet := .F.
				EndIf
			EndIf
		EndIf
	EndIf	
ElseIf !Empty(aMTAlcDoc := MTGetAlcPE(SCR->CR_TIPO))
	aArea := (aMTAlcDoc[2])->(GetArea())
	dbSelectArea(aMTAlcDoc[2])
	dbSetOrder(aMTAlcDoc[3])
	If MsSeek(xFilial(aMTAlcDoc[2])+cNumero)
		lRet := Reclock(aMTAlcDoc[2])
	EndIf	
EndIf

RestArea(aArea)

Return(lRet)

/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������Ŀ��
���Fun�ao    � A097Data � Autor �Rodrigo de A Sartorio  � Data �10/08/2005���
�������������������������������������������������������������������������Ĵ��
���Descri�ao � Altera data de referencia para verificacao da alcada       ���
���          �                                                            ���
�������������������������������������������������������������������������Ĵ��
���Sintaxe   � A097Data(ExpO1,ExpO2,ExpO3,ExpD1,ExpA1,ExpC1,ExpN1,		  ���
���          � 			ExpC2,Expc3,ExpC4,ExpN2,ExpN3,ExpL1)			  ���
�������������������������������������������������������������������������Ĵ��
���Parametros� Expo1 = Objeto da Data de referencia                       ���
���          � Expo2 = Objeto do Saldo                                    ���
���          � Expo3 = Objeto da diferenca do saldo                       ���
���          � ExpD1 = Data de referencia                                 ���
���          � ExpA1 = Array com Saldos                                   ���
���          � ExpC1 = Codigo do usuario Liberacao                        ���
���          � ExpN1 = Saldo                                              ���
���          � ExpC2 = Moeda                                              ���
���          � ExpC3 = Nome do Usuario                                    ���
���          � ExpC4 = Codigo do Usuario                                  ���
���          � ExpN2 = Valor total do docto                               ���
���          � ExpN3 = Valor da diferenca do saldo                        ���
���          � ExpL1 = Aprovacao ou Visto                                 ���
�������������������������������������������������������������������������Ĵ��
���Retorno   � Nenhum                                                     ���
�������������������������������������������������������������������������Ĵ��
��� Uso      � MATA097			                                          ���
��������������������������������������������������������������������������ٱ�
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/
Static Function A097Data(oDataRef,oSaldo,oSalDif,dRefer ,aRetSaldo ,cCodLiber,nSaldo,cRoeda,cName,ca097User,nTotal,nSalDif,lAprov)

Local dNewData:= dRefer
Local lCancel :=.T.
Local oDlg
Local oDtNewRef

DEFINE MSDIALOG oDlg TITLE STR0016 From 145,0 To 270,400 OF oMainWnd PIXEL
@ 10,15 TO 40,100 LABEL STR0016 OF oDlg PIXEL	
@ 20,20 MSGET oDtNewRef Var dNewData Picture "@E" VALID A097VldRef(@oDlg,@oDtNewRef,@dNewData,dRefer,@lCancel) OF oDlg PIXEL 
DEFINE SBUTTON FROM 50,131 TYPE 1 ACTION (lCancel:=.F.,oDlg:End()) ENABLE OF oDlg
DEFINE SBUTTON FROM 50,158 TYPE 2 ACTION oDlg:End() ENABLE OF oDlg
ACTIVATE MSDIALOG oDlg

If !lCancel
	dRefer   := dNewData
	aRetSaldo:= MaSalAlc(cCodLiber,dRefer)
	nSaldo 	 := aRetSaldo[1]
	CRoeda 	 := A097Moeda(aRetSaldo[2])
	cName  	 := UsrRetName(ca097User)
	nTotal   := xMoeda(SCR->CR_TOTAL,SCR->CR_MOEDA,aRetSaldo[2],SCR->CR_EMISSAO,,SCR->CR_TXMOEDA)
	nSalDif  := nSaldo - IIF(lAprov,0,nTotal)

    If oDataRef <> Nil
		oDataRef:Refresh()
    EndIf
    
    If oSaldo <> Nil 
		oSaldo:Refresh()
    EndIf  

    If oSalDif <>Nil
		oSalDif:Refresh()
	EndIf
	
EndIf

Return Nil
          

/*
�����������������������������������������������������������������������������
�������������������������������������������������������������������������Ŀ��
���Fun��o    �A097VldRef� Autor � Ricardo Berti         � Data � 14/12/05 ���
�������������������������������������������������������������������������Ĵ��
���Descri��o � Valida a data ref. em relacao a data do pedido/BOPS 89458  ���
���          �                                                            ���
�������������������������������������������������������������������������Ĵ��
���Sintaxe   � A097VldRef(ExpO1,ExpO2,ExpD1,ExpD2,ExpL1)				  ���
�������������������������������������������������������������������������Ĵ��
���Parametros� Expo1 = Objeto da Data de referencia                       ���
���          � Expo2 = Objeto da nova data de referencia                  ���
���          � ExpD1 = nova data de referencia                            ���
���          � ExpD2 = data de referencia                                 ���
���          � ExpL1 = confirmacao da nova data ref.                      ���
�������������������������������������������������������������������������Ĵ��
���Retorno   � .T. / .F.                                                  ���
�������������������������������������������������������������������������Ĵ��
��� Uso      � MATA097                                                    ���
��������������������������������������������������������������������������ٱ�
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/
Static Function A097VldRef(oDlg,oDtNewRef,dNewData,dRefer,lCancel)

Local lRet     := .T.    
Local lDtLimPc := GetNewPar("MV_DTLIMPC",.F.)

If dNewData < SCR->CR_EMISSAO

    If lDtLimPc 
		Help(" ",1,"A097DREF")
        lRet := .F.
    Else
		lRet := ( Aviso(STR0038,STR0071,{STR0072,STR0073},2) == 1 ) //"Atencao!"###"Confirma a data de refer�ncia MENOR que a data do pedido?"###"Sim"###"N�o"
		If lRet 
			lCancel:=.F.
			oDlg:End()
		Else
			dNewData := dRefer
	    	oDtNewRef:Refresh() 
		EndIf	
    EndIf

EndIf
Return(lRet)
    

/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������Ŀ��
���Fun��o    �A097Ausente�Autor  �Alexandre Inacio Lemes �Data �27/01/2006���
�������������������������������������������������������������������������Ĵ��
���Descri��o �Acessa as liberacoes dos Aprovadores que possuem o usuario  ���
���          �Logado cadastrado como Superior no cadastro de Aprovadores. ���
�������������������������������������������������������������������������Ĵ��
���Parametros� Nenhum                              	                      ���
�������������������������������������������������������������������������Ĵ��
���Retorno   � Nenhum                                                     ���
�������������������������������������������������������������������������Ĵ��
��� Uso      � Generico                                                   ���
��������������������������������������������������������������������������ٱ�
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/
Function A097Ausente()

Local aArea		:= GetArea()
Local aCpos     := {"CR_NUM","CR_TIPO","CR_USER","CR_APROV","CR_STATUS","CR_TOTAL","CR_EMISSAO"}
Local aHeadCpos := {}
Local aHeadSize := {}
Local aArraySCR	:= {}
Local aCampos   := {}
Local aCombo    := {}
Local cAliasSCR := "SCR"
Local cAprov    := ""
Local cUserName := ""   
Local cUsrApvSup:= "" 
Local cUser     := RetCodUsr()
Local nX        := 0
Local nOpc      := 0
Local nOk       := 0
Local nRegSak   := 0

Local oDlg
Local oQual


If Type("aIndexSCR") <> "U"	
	dbClearFilter()
EndIf

//�������������������������������������������������������Ŀ
//� Monta o Header com os titulos do TWBrowse             �
//���������������������������������������������������������
dbSelectArea("SX3")
dbSetOrder(2)
For nx	:= 1 to Len(aCpos)
	If MsSeek(aCpos[nx])
		AADD(aHeadCpos,AllTrim(X3Titulo()))
		AADD(aHeadSize,CalcFieldSize(SX3->X3_TIPO,SX3->X3_TAMANHO,SX3->X3_DECIMAL,SX3->X3_PICTURE,X3Titulo()))
		AADD(aCampos,{SX3->X3_CAMPO,SX3->X3_TIPO,SX3->X3_CONTEXT,SX3->X3_PICTURE})
	EndIf
Next

//�������������������������������������������������������Ŀ
//�Apartir do codigo do usuario do sistema, obtem o codigo|
//�da cadeia de aprovadores superiores e os aprovadores   �
//�ausentes												  �
//���������������������������������������������������������
dbSelectArea("SAK")
dbSetOrder(2)
dbSeek(xFilial("SAK")+cUser)
While ( !Eof().And. SAK->AK_FILIAL == xFilial("SAK") .AND. SAK->AK_USER == cUser )
	 nRegSak :=Recno()    
     cUsrApvSup := SAK->AK_COD
	 dbSetOrder(3) // AK_FILIAL+AK_APROSUP
	 dbSeek(cSeek:=xFilial("SAK")+cUsrApvSup)
     While ( !Eof().And. SAK->(AK_FILIAL+AK_APROSUP) == cSeek )
		 AADD(aCombo,SAK->AK_COD+" - "+SAK->AK_NOME)
	     SAK->(dbSkip())
     EndDo
	 dbSetOrder(2)
     dbgoto(nRegSak)  
  	 SAK->(dbSkip())
EndDo                        
               
cUsrApvSup := ""

If Len(aCombo) > 0
	
	A097Aprov(cAliasSCR,Substr(aCombo[1],1,6),@aArraySCR,aCampos,aCombo)
	
	DEFINE MSDIALOG oDlg FROM 000,000 TO 400,780 TITLE STR0076 PIXEL // "Transferencia por Ausencia Temporaria de Aprovadores"
	@ 001,001  TO 050,425 LABEL "" OF oDlg PIXEL
	
	@ 012,006 Say STR0077 OF oDlg PIXEL SIZE 080,009 // "Aprovador Ausente "
	@ 012,058 MSCOMBOBOX cAprov ITEMS aCombo SIZE 250,090 WHEN .T. VALID A097Aprov(cAliasSCR,cAprov,@aArraySCR,aCampos,aCombo,oQual) OF oDlg PIXEL
	
	@ 030,006 Say STR0078 OF oDlg PIXEL SIZE 080,009 // "Aprovador Superior" 
	@ 030,058 MSGET cUserName : = (trim(A097UsuSup(cAprov))+If(Len(aCombo)>1,"   "+STR0086,"")) When .F. SIZE 250,009 OF oDlg PIXEL   
	
	oQual:= TWBrowse():New( 051,001,389,133,,aHeadCpos,aHeadSize,oDlg,,,,,,,,,,,,.F.,,.T.,,.F.,,,)
	oQual:SetArray(aArraySCR)
	oQual:bLine := { || aArraySCR[oQual:nAT] }
	
	@ 187,299 BUTTON STR0079 SIZE 040,011 FONT oDlg:oFont ACTION (nOpc:=1,oDlg:End())  OF oDlg PIXEL // "Transferir"
	@ 187,340 BUTTON STR0080 SIZE 040,011 FONT oDlg:oFont ACTION (nOpc:=2,oDlg:End())  OF oDlg PIXEL // "Cancelar  "
	
	ACTIVATE MSDIALOG oDlg CENTERED

	If nOpc == 1 
		cUsrApvSup:=Substr(cUserName,1,6)

	    If !Empty(aArraySCR[1][1])
	 
		    nOk := Aviso(STR0038,STR0075,{STR0052,STR0053},2) //"Atencao!"###"Ao confirmar este processo todas aprova��es pendentes do aprovador ser�o transferidas ao aprovador superior. Confirma a Transfer�ncia ? "###"Cancelar"###"Confirma"
	
	        If  nOk == 2  // Confirma a transferencia
	
		        For nX := 1 To Len(aArraySCR)
					dbSelectArea("SCR")                
					dbGoTo(aTail(aArraySCR[nX]))
			
					Begin Transaction
					MaAlcDoc({SCR->CR_NUM,SCR->CR_TIPO,,cUsrApvSup,cUser,,,SCR->CR_MOEDA,SCR->CR_TXMOEDA,,STR0081},,2) // "Tranferido por Ausencia"
					End Transaction	
		        Next nX
		
	        EndIf 
	        
	 	Else
			Aviso("A097NOSCR",STR0084,{STR0031}) //"N�o existem registros para serem transferidos"         
        EndIf
        
	EndIf	
Else
	Aviso("A097NOSUP",STR0082,{STR0031}) //"Para utilizar esta op��o � necessario que exista no minimo um aprovador com um superior cadastrado"
EndIf

If Type("cXFiltraSCR") <> "U"
	set filter to  &(cXFiltraSCR)
EndIf

RestArea(aArea)	
	
Return Nil

/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������Ŀ��
���Fun��o    �A097UsuSup �Autor  �Julio C.Guerato        �Data �11/02/2009���
�������������������������������������������������������������������������Ĵ��
���Descri��o � Retorna Dados do Usuario Superior apartir de um aprovador. ���
�������������������������������������������������������������������������Ĵ��
���Sintaxe   � A097UsuSup(ExpC1)				   			 			  ���
�������������������������������������������������������������������������Ĵ��
���Parametros� ExpC1 = Cod.do Aprovador                                   ���
���Retorno   � String com Codigo / Nome do Superiorr                      ���
�������������������������������������������������������������������������Ĵ��
��� Uso      � Generico                                                   ���
��������������������������������������������������������������������������ٱ�
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/
Function A097UsuSup(cAprov)
Local aAreaSAK   := SAK->( GetArea() )
Local cUsr :=""    

dbSelectArea("SAK")
dbSetOrder(1)
dbSeek(xFilial("SAK")+cAprov)
dbSeek(xFilial("SAK")+SAK->AK_APROSUP)   
cUsr = (SAK->AK_COD +" - "+UsrFullName(SAK->AK_USER))  

RestArea( aAreaSAK) 
return (cUsr)
          
//--------------------------------------------------------------------
/*/{Protheus.doc} A097UsuApr()
Fun��o que busca o codigo do usuario aprovador
@author Leonardo Quintania
@since 28/01/2013
@version 1.0
@return aReturn
/*/
//--------------------------------------------------------------------
Function A097UsuApr(cAprov,nTipo)
Local aAreaSAK	:= SAK->( GetArea() )  
Local cUsr			:= ""
Default nTipo		:= 1 // (1 - Retorna AK_USER, 2 - Retorna AK_COD)

If nTipo == 1 	// Retorna AK_USER
	SAK->(dbSetOrder(1))
	If SAK->(dbSeek(xFilial("SAK")+cAprov))
		cUsr = SAK->AK_USER
	Endif
Elseif nTipo == 2 // Retorna AK_COD
	SAK->(dbSetOrder(2))
	If SAK->(dbSeek(xFilial("SAK")+cAprov))
		cUsr = SAK->AK_COD
	Endif
Endif

RestArea(aAreaSAK) 

Return cUsr

/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������Ŀ��
���Fun��o    �A097Aprov  �Autor  �Alexandre Inacio Lemes �Data �27/01/2006���
�������������������������������������������������������������������������Ĵ��
���Descri��o �Acessa as liberacoes dos Aprovadores que possuem o usuario  ���
���          �Logado cadastrado como Superior no cadastro de Aprovadores. ���
�������������������������������������������������������������������������Ĵ��
���Sintaxe   � A097Aprov(ExpC1,ExpC2,ExpA1,ExpA2,ExpA3,ExpO1)			  ���
�������������������������������������������������������������������������Ĵ��
���Parametros� ExpC1 = Alias do SCR                                       ���
���          � ExpC2 = cod.do aprovador                                   ���
���          � ExpA1 = array dos campos de SCR		                      ���
���          � ExpA2 = array dos campos de SCR e outro(s)                 ���
���          � ExpA3 =                                                    ���
���          � ExpO1 = objeto do SCR                                      ���
�������������������������������������������������������������������������Ĵ��
���Retorno   � Nenhum                                                     ���
�������������������������������������������������������������������������Ĵ��
��� Uso      � Generico                                                   ���
��������������������������������������������������������������������������ٱ�
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/
Function A097Aprov(cAliasSCR,cAprov,aArraySCR,aCampos,aCombo,oQual)

Local aStruSCR  := {}
Local cIndSCR	:= ""
Local cQuery    := ""
Local nX        := 0
Local nOrderSCR := 0 
Local lQuery    := .F.
Local lMT097AUS	:= ExistBlock("MT097AUS")
Local lContinua := .T.

dbSelectArea("SCR")
dbSetOrder(1)

lQuery := .T.
cAliasSCR := "QRYSCR"
aStruSCR  := SCR->(dbStruct())
cQuery := "SELECT * "
cQuery += "FROM "+RetSqlName("SCR")+" "
cQuery += "WHERE CR_FILIAL='"+xFilial("SCR")+"' AND "
cQuery += "CR_APROV='"+Substr(cAprov,1,6)+"' AND ( CR_STATUS='02' OR CR_STATUS='04' ) AND "
cQuery += "D_E_L_E_T_ = ' ' "
cQuery += "ORDER BY "+SqlOrder(SCR->(IndexKey()))

cQuery := ChangeQuery(cQuery)
dbUseArea(.T.,"TOPCONN",TcGenQry(,,cQuery),cAliasSCR)

For nX := 1 To len(aStruSCR)
			If aStruSCR[nX][2] <> "C" .And. FieldPos(aStruSCR[nX][1])<>0
		TcSetField(cAliasSCR,aStruSCR[nX][1],aStruSCR[nX][2],aStruSCR[nX][3],aStruSCR[nX][4])
	EndIf
Next nX
dbSelectArea(cAliasSCR)	

If Eof()
	aArraySCR := {{"","","","","",0,""}}
Else
	aArraySCR := {}
EndIf

While ( !(cAliasSCR)->(Eof()) .And. (cAliasSCR)->CR_FILIAL == xFilial("SCR") )
	
	If lMT097AUS
		lContinua := If (ValType(lContinua:= ExecBlock("MT097AUS",.F.,.F.)) == "L",lContinua,.T.)
	EndIf	
	
	If lContinua
		Aadd(aArraySCR,Array(Len(aCampos)+1))
		For nX := 1 to Len(aCampos)
			If Substr(aCampos[nX][1],1,2) == "CR"
				If aCampos[nX][2] == "N"
					aArraySCR[Len(aArraySCR)][nX] := Transform((cAliasSCR)->(FieldGet(FieldPos(aCampos[nX][1]))),PesqPict("SCR",aCampos[nX][1]))
				Else
					aArraySCR[Len(aArraySCR)][nX] := (cAliasSCR)->(FieldGet(FieldPos(aCampos[nX][1])))
				Endif
			EndIf
		Next nX
		aTail(aTail(aArraySCR)) := (cAliasSCR)->R_E_C_N_O_
	EndIf
	
	(cAliasSCR)->(dbSkip())
	
EndDo

If Len(aArraySCR) == 0
	aArraySCR := {{"","","","","",0,""}}
EndIf

If oQual <> Nil
	oQual:SetArray(aArraySCR)
	oQual:bLine := { || aArraySCR[oQual:nAT] }
	oQual:Refresh()
EndIf

//�������������������������������������������������������������������������������������Ŀ
//� Apaga os arquivos de trabalho, cancela os filtros e restabelece as ordens originais.|
//���������������������������������������������������������������������������������������
If lQuery
	dbSelectArea(cAliasSCR)
	dbCloseArea()
Else
  	dbSelectArea("SCR")
	RetIndex("SCR")
	dbClearFilter()
	Ferase(cIndSCR+OrdBagExt())
EndIf
Return Nil


/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �MATA097   �Autor  �Microsiga           � Data �  08/09/11   ���
�������������������������������������������������������������������������͹��
���Desc.     �                                                            ���
���          �                                                            ���
�������������������������������������������������������������������������͹��
���Uso       � AP                                                         ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/
Static Function ValidPcoLan(lLanPCO)
Local lRet	   := .T.
Local aArea    := GetArea()
Local aAreaSC7 := SC7->(GetArea())

Default lLanPCO := .T.

If lLanPCO
	If SCR->CR_TIPO == "PC" .Or. SCR->CR_TIPO == "AE"
		dbSelectArea("SC7")
		DbSetOrder(1)
		DbSeek(xFilial("SC7")+Substr(SCR->CR_NUM,1,len(SC7->C7_NUM)))
	Endif
	If lRet	:=	PcoVldLan('000055','02','MATA097')
		If SCR->CR_TIPO == "NF"
			dbSelectArea("SF1")
		ElseIf SCR->CR_TIPO == "PC" .Or. SCR->CR_TIPO == "AE"
			While lRet .And. !Eof() .And. SC7->C7_FILIAL+Substr(SC7->C7_NUM,1,len(SC7->C7_NUM)) == xFilial("SC7")+Substr(SCR->CR_NUM,1,len(SC7->C7_NUM))
				lRet	:=	PcoVldLan("000055","01","MATA097")
				dbSelectArea("SC7")
				dbSkip()
			EndDo
		ElseIf SCR->CR_TIPO == "CP"
			dbSelectArea("SC3")
			//-- While !Eof() .And. SC3->C3_FILIAL+Substr(SC3->C3_NUM,1,len(SC3->C3_NUM)) == xFilial("SC3")+Substr(SCR->CR_NUM,1,len(SC3->C3_NUM))
			//-- 	dbSkip()
			//-- EndDo
		EndIf
	Endif
	If !lRet
		PcoFreeBlq("000055")
	Endif
EndIf

RestArea(aAreaSC7)
RestArea(aArea)
Return lRet

/*/
���������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������Ŀ��
���Programa  �MenuDef   � Autor � Fabio Alves Silva     � Data �08/11/2006���
�������������������������������������������������������������������������Ĵ��
���Descri��o � Utilizacao de menu Funcional                               ���
���          �                                                            ���
���          �                                                            ���
�������������������������������������������������������������������������Ĵ��
���Retorno   �Array com opcoes da rotina.                                 ���
�������������������������������������������������������������������������Ĵ��
���Parametros�Parametros do array a Rotina:                               ���
���          �1. Nome a aparecer no cabecalho                             ���
���          �2. Nome da Rotina associada                                 ���
���          �3. Reservado                                                ���
���          �4. Tipo de Transa��o a ser efetuada:                        ���
���          �		1 - Pesquisa e Posiciona em um Banco de Dados           ���
���          �    2 - Simplesmente Mostra os Campos                       ���
���          �    3 - Inclui registros no Bancos de Dados                 ���
���          �    4 - Altera o registro corrente                          ���
���          �    5 - Remove o registro corrente do Banco de Dados        ���
���          �5. Nivel de acesso                                          ���
���          �6. Habilita Menu Funcional                                  ���
�������������������������������������������������������������������������Ĵ��
���   DATA   � Programador   �Manutencao efetuada                         ���
�������������������������������������������������������������������������Ĵ��
���          �               �                                            ���
��������������������������������������������������������������������������ٱ�
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
/*/
Static Function MenuDef()     

PRIVATE aRotina	:= {{OemToAnsi(STR0001),"Ma097Pesq",   0 , 1, 0, .F.},; //"Pesquisar"
						{OemToAnsi(STR0002),"A097Visual",  0 , 2, 0, nil},; //"Consulta pedido"
						{OemToAnsi(STR0034),"A097Consulta",0 , 2, 0, nil},; //"Consulta Saldos"
						{OemToAnsi(STR0004),"A097Libera",  0 , 4, 0, nil},; //"Liberar"
						{OemToAnsi(STR0054),"A097Estorna", 0 , 4, 0, nil},; //"Estornar"
						{OemToAnsi(STR0005),"A097Superi",  0 , 4, 0, nil},; //"Superior"
						{OemToAnsi(STR0055),"A097Transf",  0 , 4, 0, nil},; //"Transf. para Superior"
						{OemToAnsi(STR0074),"A097Ausente", 0 , 3, 0, nil},; //"Ausencia Temporaria"
						{OemToAnsi(STR0062),"A097Legend",  0 , 2, 0, .F.}}  //"Legenda"	

//������������������������������������������������������������������������Ŀ
//� Ponto de entrada utilizado para inserir novas opcoes no array aRotina  �
//��������������������������������������������������������������������������
If ExistBlock("MTA097MNU")
	ExecBlock("MTA097MNU",.F.,.F.)
EndIf           

Return(aRotina) 


/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������Ŀ��
���Fun��o    �A097VALOBS �Autor  �Julio C.Guerato        �Data �13/08/2009���
�������������������������������������������������������������������������Ĵ��
���Descri��o �Efetua valida��o do Campo Observa��es 				      ���
�������������������������������������������������������������������������Ĵ��
���Parametros� Campo Observa��es                  	                      ���
�������������������������������������������������������������������������Ĵ��
���Retorno   � Valor L�gico                                               ���
�������������������������������������������������������������������������Ĵ��
��� Uso      � Generico                                                   ���
��������������������������������������������������������������������������ٱ�
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/
Function A097VALOBS(cObs)
Local lObs:= .T.

If ExistBlock("MT097OBS")
      lObs := ExecBlock("MT097OBS",.F.,.F.,{cOBS})
	  If Valtype(lObs)<>"L"
	    lObs := .T.
	  EndIf
Endif 

Return (lObs)

//--------------------------------------------------------------------
/*/{Protheus.doc} A097ProcLib()
Realiza o processamento da libera��o de documentos.
@author Leonardo Quintania
@since 28/01/2013
@version 1.0
@return aReturn
/*/
//--------------------------------------------------------------------
Function A097ProcLib(nReg,nOpc,nTotal,cCodLiber,cGrupo,cObs,dRefer,oModelCT)
Local lLog			:= GetNewPar("MV_HABLOG",.F.)
Local lMta097		:= ExistBlock("MTA097")
Local lA097PCO	:= ExistBlock("A097PCO")
Local lLanPCO		:= .T.	//-- Podera ser modificada pelo PE A097PCO
Local ca097User 	:= RetCodUsr()
Local cName   	:= UsrRetName(ca097User)
Local lLiberou	:= .F.
Local cPCLib		:= ""
Local cPCUser		:= ""

Local cEnvPed		:= SuperGetMV("MV_ENVPED",.F.,"0")                                                                                                    
Local lAlcSolCtb	:= SuperGetMv("MV_APRSCEC",.F.,.F.)
Local aMail		:= {}
Local aPedCom		:= {}
Local nOpMail		:= 0
Local cTit			:= ""
Local cNomeEmp	:= FWEmpName(cEmpAnt)
Local cNomeFil	:= Alltrim(FWFilialName())
Local cBody 		:= ""
Local cAprTipRev	:= ""
Local lRet			:= .T.
Local lLibOk		:= .F.
Local cScrNum		:= SCR->CR_NUM
Local aMTAlcDoc 	:= MTGetAlcPE(SCR->CR_TIPO)
Local cEventID   := 0        // Variavel usada para armazenar o ID do EventViewer
Local cMensagem  := " "     // Variavel para armazenar a mensagem utilizada no eventviewer
Local aItens		:= {}
Local lBlqPA      := SuperGetMv("MV_BLQPAPC",.F.,.F.)
Local cAliasFIE   := ''
Local cQuery     	:= ""

Local lDtRefPed:= GetNewPar("MV_DTLIMPC",.F.)

Default nTotal	:= SCR->CR_TOTAL
Default cCodLiber	:= SCR->CR_APROV
Default cGrupo 	:= SCR->CR_GRUPO
Default cObs		:= SCR->CR_OBS
Default dRefer	:= SCR->CR_DATALIB
Default oModelCT	:= NIL

SCR->(dbClearFilter())
If ( Select("SCR") > 0 )
	SCR->(dbCloseArea())
EndIf

dbSelectArea("SCR")
SCR->(dbSetOrder(1))
SCR->(dbGoTo(nReg))

If Empty(cGrupo)
	cGrupo := SCR->CR_GRUPO
Endif


If ( SCR->CR_TIPO == "NF" )
	lLibOk := A097Lock(Substr(SCR->CR_NUM,1,Len(SF1->F1_DOC+SF1->F1_SERIE+SF1->F1_FORNECE+SF1->F1_LOJA)),SCR->CR_TIPO)
ElseIf SCR->CR_TIPO == "PC" .Or. SCR->CR_TIPO == "AE" .Or. SCR->CR_TIPO == "IP"
	lLibOk := A097Lock(Substr(SCR->CR_NUM,1,Len(SC7->C7_NUM)),SCR->CR_TIPO)
ElseIf SCR->CR_TIPO == "CP"
	lLibOk := A097Lock(Substr(SCR->CR_NUM,1,Len(SC3->C3_NUM)),SCR->CR_TIPO)
ElseIf SCR->CR_TIPO == "MD"
	lLibOk := A097Lock(Substr(SCR->CR_NUM,1,TAMSX3("CND_NUMMED")[1]),SCR->CR_TIPO)
ElseIf SCR->CR_TIPO == "IM"
	lLibOk := A097Lock(Substr(SCR->CR_NUM,1,TAMSX3("CNE_NUMMED")[1]),"MD")
ElseIf SCR->CR_TIPO == "CT"
	lLibOk := A097Lock(Substr(SCR->CR_NUM,1,TAMSX3("CN9_NUMERO")[1]),SCR->CR_TIPO)
ElseIf SCR->CR_TIPO == "IC"
	lLibOk := A097Lock(Substr(SCR->CR_NUM,1,TAMSX3("CN9_NUMERO")[1] + TAMSX3("CN9_REVISA")[1]+ TAMSX3("CNB_NUMERO")[1]),SCR->CR_TIPO)
ElseIf SCR->CR_TIPO == "GA" // Documento de Garantia (SIGAJURI)
	lLibOk := A097Lock(SCR->CR_NUM,SCR->CR_TIPO)			
ElseIf SCR->CR_TIPO == "SC" // Solicita��o de Compras (SIGACOM)
	lLibOk := A097Lock(SCR->CR_NUM,SCR->CR_TIPO)
ElseIf	SCR->CR_TIPO == "SA" // Solicita��o ao Armaz�m (SIGAEST)
	lLibOk := A097Lock(SCR->CR_NUM,SCR->CR_TIPO)
ElseIf	SCR->CR_TIPO == "ST" // Solicita��o de transfer�ncia (SIGAEST)
	lLibOk := A097Lock(SCR->CR_NUM,SCR->CR_TIPO)	
ElseIf SCR->CR_TIPO $ "RV|IR"
	lLibOk := A097Lock(Substr(SCR->CR_NUM,1,TAMSX3("CN9_NUMERO")[1] + TAMSX3("CN9_REVISA")[1]),SCR->CR_TIPO)
ElseIf SCR->CR_TIPO >= "A1" .AND. SCR->CR_TIPO <= "A9"  // Documentos do modulo Agro
	lLibOk := A097Lock(SCR->CR_NUM,SCR->CR_TIPO)	
ElseIf !Empty(aMTAlcDoc)
	lLibOk := A097Lock(Substr(SCR->CR_NUM,1,Len(&(aMTAlcDoc[4]))),SCR->CR_TIPO)
EndIf
If lLibOk
	Begin Transaction
		If lMta097 .And. nOpc == 2
			If lDtRefPed
				If dRefer < SCR->CR_EMISSAO .And. (SCR->CR_TIPO == "PC" .Or. SCR->CR_TIPO == "IP")
					Help(" ",1,"A097DREF")
				Else
					lLiberou := MaAlcDoc({SCR->CR_NUM,SCR->CR_TIPO,nTotal,cCodLiber,,cGrupo,,,,,cObs},dRefer,If(nOpc==2,4,6))
				EndIf
			Else
				If ExecBlock("MTA097",.F.,.F.)
					lLiberou := MaAlcDoc({SCR->CR_NUM,SCR->CR_TIPO,nTotal,cCodLiber,,cGrupo,,,,,cObs},dRefer,If(nOpc==2,4,6))
				Endif
			EndIf	
		Else
			If lDtRefPed
					If dRefer < SCR->CR_EMISSAO .And. (SCR->CR_TIPO == "PC" .Or. SCR->CR_TIPO == "IP")
						Help(" ",1,"A097DREF")
					Else
						lLiberou := MaAlcDoc({SCR->CR_NUM,SCR->CR_TIPO,nTotal,cCodLiber,,cGrupo,,,,,cObs},dRefer,If(nOpc==2,4,6))
					EndIf
			Else
				lLiberou := MaAlcDoc({SCR->CR_NUM,SCR->CR_TIPO,nTotal,cCodLiber,,cGrupo,,,,,cObs},dRefer,If(nOpc==2,4,6))
			EndIf
		EndIf
		
		If lA097PCO
			lLanPCO := ExecBlock("A097PCO",.F.,.F.,{SC7->C7_NUM,cName,lLanPCO})
		Endif
		
		//-- Apenas o PE A097PCO pode alterar o valor de lA097PCO
		//-- Se ele nao existir ela devera seguir o valor da liberacao (lLiberou)
		If !lA097PCO
			lLanPCO := lLiberou
		EndIf

		//��������������������������������������������������������������������Ŀ
		//� Envia e-mail ao comprador ref. Liberacao do pedido para compra- 034�
		//����������������������������������������������������������������������  
		If lLiberou .And. (SCR->CR_TIPO == "PC" .Or. SCR->CR_TIPO == "AE" .Or. SCR->CR_TIPO == "IP")
			If IsInCallStack("MTFlgLbDoc")
				SC7->(dbSetOrder(1))
				SC7->(dbSeek(xFilial("SC7") + Padr(cScrNum,TamSX3("C7_NUM")[1]) ))
			Endif
			cPCLib  := SC7->C7_NUM
			cPCUser := SC7->C7_USER	
			dbSelectarea("SXI")
			SXI->(dbsetorder(2))
			cEventID  := "034"
			If msSeek('002' + '001' + cEventID)
				cMensagem:=STR0101+" - "+SC7->C7_NUM+" - "+STR0102+" - "+cUsername
				EventInsert(FW_EV_CHANEL_ENVIRONMENT, FW_EV_CATEGORY_MODULES, cEventID,FW_EV_LEVEL_INFO,""/*cCargo*/,STR0103,cMensagem,.T./*lPublic*/)	
			Else	
				MEnviaMail("034",{cPCLib,SCR->CR_TIPO},cPCUser) 				
			Endif
		EndIf
			
		If lLiberou .or. lLanPCO
			//����������������������������������������������������������Ŀ
			//� Grava os lancamentos nas contas orcamentarias SIGAPCO    �
			//������������������������������������������������������������
			If lLanPCO
				PcoDetLan("000055","02","MATA097")
			EndIf

			If lLiberou .and. (SCR->CR_TIPO == "NF")
				dbSelectArea("SF1")
				Reclock("SF1",.F.)
				SF1->F1_STATUS := If(SF1->F1_STATUS=="B"," ",SF1->F1_STATUS)
				MsUnlock()
			ElseIf (SCR->CR_TIPO == "PC" .Or. SCR->CR_TIPO == "AE")
				If lLiberou .And. SuperGetMv("MV_EASY")=="S" .And. !Empty(SC7->C7_PO_EIC)
					If SW2->(MsSeek(xFilial("SW2")+SC7->C7_PO_EIC)) .AND. !Empty(SW2->W2_CONAPRO)
						Reclock("SW2",.F.)
						SW2->W2_CONAPRO := "L"
						MsUnlock()
						TPO_NUM := SW2->W2_PO_NUM
						EICFI400("ANT_GRV_PO","E")
              		EICFI400("POS_GRV_PO","E")
					EndIf
				EndIf
				dbSelectArea("SC7")
				DbSetOrder(1)
				MsSeek(xFilial("SC7") + Alltrim(SCR->CR_NUM))
				cPCLib := SC7->C7_NUM
				cPCUser:= SC7->C7_USER
				While !SC7->(Eof()) .And. SC7->C7_FILIAL+Substr(SC7->C7_NUM,1,len(SC7->C7_NUM)) == xFilial("SC7")+Substr(SCR->CR_NUM,1,len(SC7->C7_NUM))
					If lLiberou
						Reclock("SC7",.F.)
						SC7->C7_CONAPRO := "L"
						MsUnlock()
						If lBlqPA  // Libera os titulos do financeiro
						
							cAliasFIE := GetNextAlias()  
							cQuery := "SELECT FIE_FILIAL , FIE_PEDIDO , FIE_NUM , FIE_FORNEC, FIE_PREFIX FROM " +RetSqlname("FIE")+ "  WHERE FIE_PEDIDO ='" + SC7->C7_NUM + "' AND FIE_TIPO = 'PA' AND D_E_L_E_T_ <> '*' "  	 
							cQuery := ChangeQuery(cQuery)
							dbUseArea(.T.,"TOPCONN",TcGenQry(,,cQuery),cAliasFIE,.T.,.T.)							
							dbSelectArea(cAliasFIE)
							
							Do While ( !Eof() .And. FIE_FILIAL == xFilial("FIE") .And. FIE_PEDIDO == SC7->C7_NUM )							
									cQuery := "UPDATE "+RetSqlname("SE2")		
									cQuery += " SET E2_STATLIB = '02' , E2_USUALIB = '"+cPCUser+"'"+", E2_DATALIB = '" + Dtos(dDataBase) + "'"
									cQuery += " WHERE E2_FILIAL ='"+xFilial("SE2")+"' AND "
									cQuery += " E2_NUM='"+FIE_NUM+"' AND "
									cQuery += " E2_FORNECE ='" +  FIE_FORNEC+"' AND"
									cQuery += " E2_PREFIXO ='" +  FIE_PREFIX+"'"
									TcSqlExec(cQuery)									
									dbSkip()
							EndDo
						Endif
						//Caio.Santos - 11/01/13 - Req.72
						If lLog
							RSTSCLOG("LIB",1,/*cUsrWF*/)
						EndIf
						If ExistBlock("MT097APR")
							ExecBlock("MT097APR",.F.,.F.)      
						EndIf
						
						//Alimenta array para envio de email
						If cEnvPed == "2"
							aMail	:= {AllTrim(POSICIONE('SA2', 1, xFilial('SA2') + SC7->(C7_FORNECE+C7_LOJA), 'A2_EMAIL'))}
							If !(Empty(aMail[1]))
								If Empty(Len(aPedCom))
									Aadd(aPedCom,SC7->C7_NUM)
									Aadd(aPedCom,AllTrim(POSICIONE('SA2', 1, xFilial('SA2') + SC7->(C7_FORNECE+C7_LOJA), 'A2_NOME')) + " - " + AllTrim(SC7->C7_FORNECE) + "/" + SC7->C7_LOJA)
									Aadd(aPedCom,cNomeEmp + " - " + cNomeFil)
									Aadd(aPedCom,C7_CONTATO)
									Aadd(aPedCom,{})
								EndIf
								Aadd(aPedCom[5],{	SC7->C7_ITEM,;
													SC7->C7_PRODUTO,;
													POSICIONE('SB1', 1, xFilial('SB1') + SC7->C7_PRODUTO, 'B1_DESC'),;
													SC7->C7_UM,;
													SC7->C7_QUANT,;
													SC7->C7_PRECO,;
													SC7->C7_TOTAL,;
													SC7->C7_DATPRF;
												})
							EndIf
						EndIf
						
					EndIf
					//����������������������������������������������������������Ŀ
					//� Grava os lancamentos nas contas orcamentarias SIGAPCO    �
					//������������������������������������������������������������
					If lLanPCO
						PcoDetLan("000055","01","MATA097")
					EndIf
					SC7->(dbSkip())
				EndDo
				
			ElseIf lLiberou .and. SCR->CR_TIPO == "CP"
				dbSelectArea("SC3")
				While !SC3->(Eof()) .And. SC3->C3_FILIAL+Substr(SC3->C3_NUM,1,len(SC3->C3_NUM)) == xFilial("SC3")+Substr(SCR->CR_NUM,1,len(SC3->C3_NUM))
					Reclock("SC3",.F.)
					SC3->C3_CONAPRO := "L"
					MsUnlock()
					dbSkip()
				EndDo
			ElseIf lLiberou .and. SCR->CR_TIPO $ "MD|IM"
				dbSelectArea("CND")
				dbSetOrder(4)
				If CND->(dbSeek(xFilial("CND")+Left(SCR->CR_NUM,Len(CND->CND_NUMMED))))
					Reclock("CND",.F.)
					CND->CND_ALCAPR := "L"
					CND->CND_SITUAC := "A"
					MsUnlock()
					If ExistBlock("MT097APR")
						ExecBlock("MT097APR",.F.,.F.)
					EndIf
				EndIf
			ElseIf lLiberou .and. SCR->CR_TIPO $ "CT|IC"
				dbSelectArea("CN9")
				dbSetOrder(1)
				If dbSeek(xFilial("CN9")+Left(SCR->CR_NUM,Len(CN9->CN9_NUMERO)))
					Reclock("CN9",.F.)
					CN9->CN9_SITUAC := "05" //Vigente 
					CN9->CN9_DTASSI := dDataBase
					MsUnlock()
				EndIf
			ElseIf lLiberou .and. SCR->CR_TIPO == "GA" // Documento de Garantia (SIGAJURI)
				dbSelectArea("NV3")
				dbSetOrder(1)												
				If dbSeek(xFilial("NV3")+Substr(AllTrim(SCR->CR_NUM),4,Len(AllTrim(SCR->CR_NUM))))				
					If !JurGerPag(3,'NT2',SCR->CR_TOTAL,NV3->NV3_CAJURI,NV3->NV3_CODLAN,'2','NV3',1)
						DisarmTransaction()  // Problema ao gerar Contas a Pagar
					EndIf										
				EndIf
				
			ElseIf lLiberou .And. SCR->CR_TIPO == "SC" // Solicita��o de Compras(SIGACOM)
              SC1->(dbSetOrder(1))            			
				If lAlcSolCtb
					DBM->(dbSetOrder(3))
					DBM->(dbSeek(xFilial("DBM")+SCR->(CR_TIPO+CR_NUM+CR_GRUPO+CR_ITGRP+CR_APROV+CR_APRORI)))
					While DBM->(!EOF()) .And. DBM->(DBM_FILIAL+DBM_TIPO+DBM_NUM+DBM_GRUPO+DBM_ITGRP+DBM_USAPRO+DBM_USAPOR) == SCR->(CR_FILIAL+CR_TIPO+CR_NUM+CR_GRUPO+CR_ITGRP+CR_APROV+CR_APRORI)
	             		If MtGLastDBM(SCR->CR_TIPO,DBM->DBM_NUM,DBM->DBM_ITEM,DBM->DBM_ITEMRA) //-- Verifica se � o ultimo item de aprova��o
                    		If SC1->(dbSeek(xFilial("SC1")+DBM->(PadR(DBM_NUM,TamSX3("C1_NUM")[1])+PadR(DBM_ITEM,TamSX3("C1_ITEM")[1]))))
                   	 		Reclock("SC1",.F.)
                    			SC1->C1_APROV := "L"
								SC1->C1_NOMAPRO := UsrRetName(DBM->DBM_USAPRO) 
                    			SC1->(MsUnlock())
                    		EndIf
                 		EndIf
                  		DBM->(dbSkip())
					End
				Else
					If MtGLastSCR(SCR->CR_TIPO,SCR->CR_NUM) .And. SC1->(dbSeek(xFilial("SC1")+Rtrim(SCR->CR_NUM)))
						While SC1->(!Eof()) .And. xFilial('SC1')+Rtrim(SCR->CR_NUM) == SC1->C1_FILIAL+Rtrim(SC1->C1_NUM)
							Reclock("SC1",.F.)
							SC1->C1_APROV := "L"
							SC1->C1_NOMAPRO := UsrRetName(SCR->CR_USERLIB) 
							SC1->(MsUnlock())
							SC1->(dbSkip())
						EndDo
					Endif
				Endif
                                        
			ElseIf lLiberou .And. SCR->CR_TIPO == "SA"	// Solicita��o ao Armaz�m(SIGAEST)
				SCP->(dbSetOrder(1))
				DBM->(dbSetOrder(3))
				DBM->(dbSeek(xFilial("DBM")+SCR->(CR_TIPO+CR_NUM+CR_GRUPO+CR_ITGRP+CR_APROV+CR_APRORI)))
				While DBM->(!EOF()) .And. DBM->(DBM_FILIAL+DBM_TIPO+DBM_NUM+DBM_GRUPO+DBM_ITGRP+DBM_USAPRO+DBM_USAPOR) == SCR->(CR_FILIAL+CR_TIPO+CR_NUM+CR_GRUPO+CR_ITGRP+CR_APROV+CR_APRORI)
                 If MtGLastDBM(SCR->CR_TIPO,DBM->DBM_NUM,DBM->DBM_ITEM) //-- Verifica se � o �ltimo item de aprova��o
                 		If SCP->(dbSeek(xFilial("SCP")+DBM->(PadR(DBM_NUM,TamSX3("CP_NUM")[1])+PadR(DBM_ITEM,TamSX3("CP_ITEM")[1]))))
                    		Reclock("SCP",.F.)
                    		SCP->CP_STATSA := "L"
                   		SCP->(MsUnlock())
                 		EndIf
                 	EndIf
              	DBM->(dbSkip())
				End
                
			ElseIf lLiberou .And. SCR->CR_TIPO == "IP" // Item do Pedido (SIGACOM)
				SC7->(dbSetOrder(1))
				SC7->(dbSeek(xFilial("SC7") + cPCLib))
				
				If Empty(SC7->C7_APROV)
					DBM->(dbSetOrder(3))
					DBM->(dbSeek(xFilial("DBM")+SCR->(CR_TIPO+CR_NUM+CR_GRUPO+CR_ITGRP+CR_APROV+CR_APRORI)))
					While DBM->(!EOF()) .And. DBM->(DBM_FILIAL+DBM_TIPO+DBM_NUM+DBM_GRUPO+DBM_ITGRP+DBM_USAPRO+DBM_USAPOR) == ;
												SCR->(CR_FILIAL+CR_TIPO+CR_NUM+CR_GRUPO+CR_ITGRP+CR_APROV+CR_APRORI)
			          	If MtGLastDBM(SCR->CR_TIPO,DBM->DBM_NUM,DBM->DBM_ITEM,DBM->DBM_ITEMRA) .And.;//-- Verifica se � o ultimo item de aprova��o
		              	SC7->(dbSeek(xFilial("SC7") + cPCLib + PadR(DBM->DBM_ITEM,TamSX3("C7_ITEM")[1])))
	                 	While SC7->(!EoF()) .And. PadR(DBM->DBM_NUM,TamSX3("C7_NUM")[1]) == PadR(SC7->C7_NUM,TamSX3("C7_NUM")[1]) .And. PadR(SC7->C7_ITEM,TamSX3("C7_ITEM")[1]) == PadR(DBM->DBM_ITEM,TamSX3("C7_ITEM")[1])
	                 		Reclock("SC7",.F.)
	                 		SC7->C7_CONAPRO := "L"
	                 		SC7->(MsUnlock())
	                 		SC7->(DbSkip())
	                   EndDo	
	                 	EndIf
	              		DBM->(dbSkip())
	              	EndDo
	              	//����������������������������������������������������������Ŀ
					//� Grava os lancamentos nas contas orcamentarias SIGAPCO    �
					//������������������������������������������������������������
					If lLanPCO
						PcoDetLan("000055","01","MATA097")
					EndIf
				ElseIf MtGLastDBM(SCR->CR_TIPO,SCR->CR_NUM)
					aItens := MaRetItDoc(SC7->C7_NUM,xFilial("SC7"),"SC7","PC")
					If (lRet := MaAlcDoc({SC7->C7_NUM,"PC",A097TotPC(SC7->C7_NUM),,,SC7->C7_APROV,,SC7->C7_MOEDA,SC7->C7_TXMOEDA,SC7->C7_EMISSAO},SC7->C7_EMISSAO,1,,,,aItens))
						While SC7->(!EOF()) .And. SC7->(C7_FILIAL+C7_NUM) == xFilial("SC7")+cPCLib
							Reclock("SC7",.F.)
	                 		SC7->C7_CONAPRO := "L"
	                 		SC7->(MsUnlock())
									
	                 		If cEnvPed == "2"
								aMail	:= {AllTrim(POSICIONE('SA2', 1, xFilial('SA2') + SC7->(C7_FORNECE+C7_LOJA), 'A2_EMAIL'))}
								If !(Empty(aMail[1]))
										If Empty(Len(aPedCom))
											Aadd(aPedCom,SC7->C7_NUM)
										Aadd(aPedCom,AllTrim(POSICIONE('SA2', 1, xFilial('SA2') + SC7->(C7_FORNECE+C7_LOJA), 'A2_NOME')) + " - " + AllTrim(SC7->C7_FORNECE) + "/" + SC7->C7_LOJA)
											Aadd(aPedCom,cNomeEmp + " - " + cNomeFil)
											Aadd(aPedCom,SC7->C7_CONTATO)
											Aadd(aPedCom,{})
										EndIf
										Aadd(aPedCom[5],{	SC7->C7_ITEM,;
															SC7->C7_PRODUTO,;
															POSICIONE('SB1', 1, xFilial('SB1') + SC7->C7_PRODUTO, 'B1_DESC'),;
															SC7->C7_UM,;
															SC7->C7_QUANT,;
															SC7->C7_PRECO,;
															SC7->C7_TOTAL,;
														SC7->C7_DATPRF  })
									EndIf
								EndIf
							SC7->(DbSkip())
						EndDo
					EndIf
				EndIf
				
			Elseif lLiberou .And. SCR->CR_TIPO == "ST"
				Reclock("NNS",.F.)
					NNS->NNS_STATUS := "1"
				NNS->(MsUnlock())
				
			ElseIf lLiberou .and. SCR->CR_TIPO $ "RV|IR"
				//-- Inicializa lan�amento do PCO
				PcoIniLan("000354")
				PcoIniLan("000357")
				//- Verifica qual tipo de revis�o est� sendo aprovada.

				If A300GATpRv() ==  "5" //DEF_REV_PARAL - Paralisa��o
					oModelCT:LoadValue('CN9MASTER','CN9_SITUAC','06') //DEF_SPARA - Paralisado
				Else
					oModelCT:LoadValue('CN9MASTER','CN9_SITUAC','05') //DEF_SVIGE - Vigente
				EndIf

				If oModelCT:VldData()
					oModelCT:CommitData()	
					oModelCT:DeActivate()
				Else
					lLiberou := .F.		
				EndIf

				//-- Finaliza lancamentos do PCO
				PcoFinLan("000357")
				PcoFreeBlq("000357")

				PcoFinLan("000354")
				PcoFreeBlq("000354")

			ElseIf lLiberou .And. !Empty(aMTAlcDoc)
				dbSelectArea(aMTAlcDoc[2])
				dbSetOrder(aMTAlcDoc[3])
				MsSeek(xFilial(aMTAlcDoc[2])+Substr(SCR->CR_NUM,1,Len(&(aMTAlcDoc[4]))))
				While !EOF() .And. &(aMTAlcDoc[4]) == Substr(SCR->CR_NUM,1,Len(&(aMTAlcDoc[4])))
					RecLock(aMTAlcDoc[2],.F.)
					&(aMTAlcDoc[7,1]) := aMTAlcDoc[7,3]
					MsUnLock()
					(aMTAlcDoc[2])->(dbSkip())
				End
			Elseif lLiberou .And. SCR->CR_TIPO >= "A1" .AND. SCR->CR_TIPO <= "A9" // Documentos do modulo Agro
				If FindFunction("OGXUtlOrig") //Identifica que esta utilizando o sigaagr				
					If OGXUtlOrig() .AND. FindFunction("OGX701AALC")												
						If !AGRXCOM8( SCR->CR_NUM, SCR->CR_TIPO, SCR->(Recno()),"999")						
							DisarmTransaction() 
							lLiberou := .F.
						EndIf						
					EndIF
				Endif	
			EndIf
			
			If ExistBlock("MT097APR")
				ExecBlock("MT097APR",.F.,.F.)
			EndIf
				
		EndIf

		//Envia email para fornecedor.
		If cEnvPed == "2" .And. lRet .And. Len(aMail) > 0 .And. !(Empty(aMail[1]))
			nOpMail := 2
			cTit 	:= cNomeEmp + " - " + cNomeFil + " - Pedido de Compra " + aPedCom[1]
			cBody 	:= A120GerMail(aPedCom,nOpMail)
				
			MTSendMail(aMail,cTit,cBody)

		EndIf
		
	End Transaction
Else
	Help(" ",1,"A097LOCK")
Endif
If SCR->CR_TIPO == "NF"
	SF1->(MsUnlockAll())
ElseIf SCR->CR_TIPO $ "PC|IP|AE"
	SC7->(MsUnlockAll())
ElseIf SCR->CR_TIPO == "SC"
	SC1->(MsUnlockAll())
ElseIf SCR->CR_TIPO == "SA"
	SCP->(MsUnlockAll())
ElseIf SCR->CR_TIPO == "CP"
	SC3->(MsUnlockAll())
ElseIf SCR->CR_TIPO == "MD"
	CND->(MsUnlockAll())
ElseIf SCR->CR_TIPO == "IM"
	CNE->(MsUnlockAll())
ElseIf SCR->CR_TIPO $ "CT|RV"
	CN9->(MsUnlockAll())
ElseIf SCR->CR_TIPO $ "IC|IR"
	CNB->(MsUnlockAll())
ElseIf !Empty(aMTAlcDoc)
	(aMTAlcDoc[2])->(MsUnLockAll())
EndIf

Return lLiberou


//--------------------------------------------------------------------
/*/{Protheus.doc} A097ProcSup()
Realiza o processamento do superior
@author Leonardo Quintania
@since 28/01/2013
@version 1.0
@return aReturn
/*/
//--------------------------------------------------------------------

Function A097ProcSup(nReg,nOpc,nTotal,cAprovS,cGrupo,cObs,cSavAprov,dRefer)
Local lLog  := GetNewPar("MV_HABLOG",.F.)
Local lMta097		:= ExistBlock("MTA097")
Local lLiberou	:= .F.
Local lLibOk		:= .T.

Local cEnvPed		:= SuperGetMV("MV_ENVPED",.F.,"0")                                                                                                    
Local aMail		:= {}
Local aPedCom		:= {}
Local nOpMail		:= 0
Local cTit			:= ""
Local cNomeEmp	:= FWEmpName(cEmpAnt)
Local cNomeFil	:= Alltrim(FWFilialName())
Local cBody 		:= ""				
Local aMTAlcDoc 	:= MTGetAlcPE(SCR->CR_TIPO)		

Default nTotal	:= SCR->CR_TOTAL
Default cAprovS	:= SAK->AK_APROSUP
Default cGrupo 	:= SCR->CR_GRUPO
Default cObs		:= SCR->CR_OBS
Default cSavAprov	:= SCR->CR_APROV
Default dRefer	:= SCR->CR_DATALIB


SCR->(dbClearFilter())
SCR->(dbGoTo(nReg))

If ( SCR->CR_TIPO == "NF" )
	lLibOk := A097Lock(Substr(SCR->CR_NUM,1,Len(SF1->F1_DOC+SF1->F1_SERIE+SF1->F1_FORNECE+SF1->F1_LOJA)),SCR->CR_TIPO)
ElseIf SCR->CR_TIPO == "PC" .Or. SCR->CR_TIPO == "AE" .Or. SCR->CR_TIPO == "IP"
	lLibOk := A097Lock(Substr(SCR->CR_NUM,1,Len(SC7->C7_NUM)),SCR->CR_TIPO)
ElseIf SCR->CR_TIPO == "CP"
	lLibOk := A097Lock(Substr(SCR->CR_NUM,1,Len(SC3->C3_NUM)),SCR->CR_TIPO)
ElseIf SCR->CR_TIPO == "MD"
	lLibOk := A097Lock(Substr(SCR->CR_NUM,1,Len(CND->CND_NUMMED)),SCR->CR_TIPO)
ElseIf SCR->CR_TIPO == "IM"
	lLibOk := A097Lock(Substr(SCR->CR_NUM,1,Len(CNE->CNE_NUMMED)),SCR->CR_TIPO)
ElseIf SCR->CR_TIPO == "CT"
	lLibOk := A097Lock(Substr(SCR->CR_NUM,1,Len(CN9->CN9_NUMERO)),SCR->CR_TIPO)
ElseIf SCR->CR_TIPO == "SC" // Solicita��o de Compras (SIGACOM)
	lLibOk := A097Lock(SCR->CR_NUM,SCR->CR_TIPO)
ElseIf	SCR->CR_TIPO == "SA" // Solicita��o ao Armaz�m (SIGAEST)
	lLibOk := A097Lock(SCR->CR_NUM,SCR->CR_TIPO)
ElseIf !Empty(aMTAlcDoc)
	lLibOk := A097Lock(Substr(SCR->CR_NUM,1,Len(&(aMTAlcDoc[4]))),SCR->CR_TIPO)
EndIf

If lLibOk
	//�����������������������������������������������������������Ŀ
	//� Inicializa a gravacao dos lancamentos do SIGAPCO          �
	//�������������������������������������������������������������
	PcoIniLan("000055")
	Begin Transaction
		If lMta097 .And. nOpc == 2
			If ExecBlock("MTA097S",.F.,.F.)
				Processa({|lEnd| lLiberou := MaAlcDoc({SCR->CR_NUM,SCR->CR_TIPO,nTotal,cAprovS,,cGrupo,,,,,cObs,cSavAprov},dRefer,If(nOpc==2,4,6))})
			EndIf
		Else
			Processa({|lEnd| lLiberou := MaAlcDoc({SCR->CR_NUM,SCR->CR_TIPO,nTotal,cAprovS,,cGrupo,,,,,cObs,cSavAprov},dRefer,If(nOpc==2,4,6))})
		EndIf

		If lLiberou
			//����������������������������������������������������������Ŀ
			//� Grava os lancamentos nas contas orcamentarias SIGAPCO    �
			//������������������������������������������������������������
			PcoDetLan("000055","02","MATA097")

			If SCR->CR_TIPO == "NF"
				dbSelectArea("SF1")
				Reclock("SF1",.F.)
				SF1->F1_STATUS := If(SF1->F1_STATUS=="B"," ",SF1->F1_STATUS)
				MsUnlock()
			ElseIf SCR->CR_TIPO == "PC" .Or. SCR->CR_TIPO == "AE" .Or. SCR->CR_TIPO == "IP"
				If SuperGetMv("MV_EASY")=="S" .And. !Empty(SC7->C7_PO_EIC)
					If SW2->(MsSeek(xFilial("SW2")+SC7->C7_PO_EIC)) .AND. !Empty(SW2->W2_CONAPRO)
						Reclock("SW2",.F.)
						SW2->W2_CONAPRO := "L"
						MsUnlock()
						TPO_NUM := SW2->W2_PO_NUM 
						EICFI400("ANT_GRV_PO","E")
              		EICFI400("POS_GRV_PO","E")
					EndIf
				EndIf

				dbSelectArea("SC7")
				cPCLib := SC7->C7_NUM
				cPCUser:= SC7->C7_USER
				While !Eof() .And. SC7->C7_FILIAL+Substr(SC7->C7_NUM,1,len(SC7->C7_NUM)) == xFilial("SC7")+Substr(SCR->CR_NUM,1,len(SC7->C7_NUM))
					Reclock("SC7",.F.)
					SC7->C7_CONAPRO := "L"
					MsUnlock()
					//Caio.Santos - 11/01/13 - Req.72
					
					//Alimenta array para envio de email
					If cEnvPed $ "1|2"
						aMail	:= {AllTrim(POSICIONE('SA2', 1, xFilial('SA2') + SC7->(C7_FORNECE+C7_LOJA), 'A2_EMAIL'))}
						If !(Empty(aMail[1]))
							If Empty(Len(aPedCom))
								Aadd(aPedCom,SC7->C7_NUM)
								Aadd(aPedCom,AllTrim(POSICIONE('SA2', 1, xFilial('SA2') + SC7->(C7_FORNECE+C7_LOJA), 'A2_NOME')) + " - " + AllTrim(SC7->C7_FORNECE) + "/" + SC7->C7_LOJA)
								Aadd(aPedCom,cNomeEmp + " - " + cNomeFil)
								Aadd(aPedCom,C7_CONTATO)
								Aadd(aPedCom,{})
							EndIf
							Aadd(aPedCom[5],{	SC7->C7_ITEM,;
												SC7->C7_PRODUTO,;
												POSICIONE('SB1', 1, xFilial('SB1') + SC7->C7_PRODUTO, 'B1_DESC'),;
												SC7->C7_UM,;
												SC7->C7_QUANT,;
												SC7->C7_PRECO,;
												SC7->C7_TOTAL,;
												SC7->C7_DATPRF;
											})
						EndIf
					EndIf
					
					If lLog
						RSTSCLOG("LIB",1,/*cUsrWF*/)
					EndIf
					//����������������������������������������������������������Ŀ
					//� Grava os lancamentos nas contas orcamentarias SIGAPCO    �
					//������������������������������������������������������������
					PcoDetLan("000055","01","MATA097")
					dbSkip()
				EndDo

			   	//��������������������������������������������������������������������Ŀ
		    	//� Envia e-mail ao comprador ref. Liberacao do pedido para compra- 034�
			   	//����������������������������������������������������������������������
				MEnviaMail("034",{cPCLib,SCR->CR_TIPO},cPCUser)

			ElseIf SCR->CR_TIPO == "CP"
				dbSelectArea("SC3")
				While !Eof() .And. SC3->C3_FILIAL+Substr(SC3->C3_NUM,1,len(SC3->C3_NUM)) == xFilial("SC3")+Substr(SCR->CR_NUM,1,len(SC3->C3_NUM))
					Reclock("SC3",.F.)
					SC3->C3_CONAPRO := "L"
					MsUnlock()
					dbSkip()
				EndDo			
			ElseIf SCR->CR_TIPO == "MD"
				dbSelectArea("CND")
				dbSetOrder(4)
				If dbSeek(xFilial("CND")+CND->CND_NUMMED)
					Reclock("SC3",.F.)
					CND->CND_ALCAPR := "L"
					CND->CND_SITUAC := "A"
					MsUnlock()
					dbSkip()
				EndIf				

			ElseIf SCR->CR_TIPO == "IM" // Item da Medi��o
				CND->(dbSetOrder(4))
				DBM->(dbSetOrder(3))
				DBM->(dbSeek(xFilial("DBM")+SCR->(CR_TIPO+CR_NUM+CR_GRUPO+CR_ITGRP+CR_APROV+CR_APRORI)))
				While DBM->(!EOF()) .And. DBM->(DBM_FILIAL+DBM_TIPO+DBM_NUM+DBM_GRUPO+DBM_ITGRP+DBM_USAPRO+DBM_USAPOR) == SCR->(CR_FILIAL+CR_TIPO+CR_NUM+CR_GRUPO+CR_ITGRP+CR_APROV+CR_APRORI)
	             	If MtGLastDBM(SCR->CR_TIPO,DBM->DBM_NUM,DBM->DBM_ITEM) //-- Verifica se � o ultimo item de aprova��o
                 		If CND->(dbSeek(xFilial("CND")+DBM->(PadR(DBM_NUM,TamSX3("CND_NUMMED")[1])))) .AND. Empty(CND->CND_APROV)
                    		Reclock("CND",.F.)
                    		CND->CND_ALCAPR := "L"
                    		CND->CND_SITUAC := "A"
                    		CND->(MsUnlock())
                    	EndIf
                 	EndIf
              	DBM->(dbSkip())
				End
				If MtGLastDBM(SCR->CR_TIPO,SCR->CR_NUM)
					If CND->(dbSeek(xFilial("CND")+DBM->(PadR(DBM_NUM,TamSX3("CND_NUMMED")[1])))) .AND. !Empty(CND->CND_APROV)
						If !(MaAlcDoc({CND->CND_NUMMED,"MD",CND->CND_VLTOT,,,CND->CND_APROV,,CND->CND_MOEDA,,CND->CND_DTINIC},,3))
							Reclock("CND",.F.)
                    		CND->CND_ALCAPR := "L"
                    		CND->CND_SITUAC := "A"
                    		CND->(MsUnlock())
                    	EndIf
					EndIf
				EndIf
			ElseIf lLiberou .and. SCR->CR_TIPO $ "CT"
				dbSelectArea("CN9")
				dbSetOrder(1)
				If dbSeek(xFilial("CN9")+Left(SCR->CR_NUM,Len(CN9->CN9_NUMERO)))
					Reclock("CN9",.F.)
					CN9->CN9_SITUAC := "05" //Vigente 
					CN9->CN9_DTASSI := dDataBase
					MsUnlock()
				EndIf
			ElseIf SCR->CR_TIPO == "SC" // Solicita��o de Compras(SIGACOM)
				SC1->(dbSetOrder(1)) 			
				DBM->(dbSetOrder(3))
				DBM->(dbSeek(xFilial("DBM")+SCR->(CR_TIPO+CR_NUM+CR_GRUPO+CR_ITGRP+CR_APROV+CR_APRORI)))
				While DBM->(!EOF()) .And. DBM->(DBM_FILIAL+DBM_TIPO+DBM_NUM+DBM_GRUPO+DBM_ITGRP+DBM_USAPRO+DBM_USAPOR) == SCR->(CR_FILIAL+CR_TIPO+CR_NUM+CR_GRUPO+CR_ITGRP+CR_APROV+CR_APRORI)
	            	If 	MtGLastDBM(SCR->CR_TIPO,DBM->DBM_NUM,DBM->DBM_ITEM) //-- Verifica se � o ultimo item de aprova��o
						If SC1->(dbSeek(xFilial("SC1")+DBM->(PadR(DBM_NUM,TamSX3("C1_NUM")[1])+PadR(DBM_ITEM,TamSX3("C1_ITEM")[1]))))
							Reclock("SC1",.F.)
							SC1->C1_APROV := "L"
							SC1->(MsUnlock())
						EndIf
					EndIf
					DBM->(dbSkip())
				EndDo                                        
			ElseIf SCR->CR_TIPO == "SA"	// Solicita��o ao Armaz�m(SIGAEST)
				SCP->(dbSetOrder(1))            	
				DBM->(dbSetOrder(3))
				DBM->(dbSeek(xFilial("DBM")+SCR->(CR_TIPO+CR_NUM+CR_GRUPO+CR_ITGRP+CR_APROV+CR_APRORI)))
				While DBM->(!EOF()) .And. DBM->(DBM_FILIAL+DBM_TIPO+DBM_NUM+DBM_GRUPO+DBM_ITGRP+DBM_USAPRO+DBM_USAPOR) == SCR->(CR_FILIAL+CR_TIPO+CR_NUM+CR_GRUPO+CR_ITGRP+CR_APROV+CR_APRORI)
              	If MtGLastDBM(SCR->CR_TIPO,DBM->DBM_NUM,DBM->DBM_ITEM) //-- Verifica se � o �ltimo item de aprova��o
						If SCP->(dbSeek(xFilial("SCP")+DBM->(PadR(DBM_NUM,TamSX3("CP_NUM")[1])+PadR(DBM_ITEM,TamSX3("CP_ITEM")[1]))))
                    		Reclock("SCP",.F.)
                    		SCP->CP_STATSA := "L"
                    		SCP->(MsUnlock())
						EndIf
					EndIf
					DBM->(dbSkip())
				EndDo
			ElseIf SCR->CR_TIPO == "IP" // Item do Pedido (SIGACOM)
				SC7->(dbSetOrder(1))
				DBM->(dbSetOrder(3))
				DBM->(dbSeek(xFilial("DBM")+SCR->(CR_TIPO+CR_NUM+CR_GRUPO+CR_ITGRP+CR_APROV+CR_APRORI)))
				While DBM->(!EOF()) .And. DBM->(DBM_FILIAL+DBM_TIPO+DBM_NUM+DBM_GRUPO+DBM_ITGRP+DBM_USAPRO+DBM_USAPOR) == SCR->(CR_FILIAL+CR_TIPO+CR_NUM+CR_GRUPO+CR_ITGRP+CR_APROV+CR_APRORI)
	             	If 	MtGLastDBM(SCR->CR_TIPO,DBM->DBM_NUM,DBM->DBM_ITEM) //-- Verifica se � o ultimo item de aprova��o
                    	If SC7->(dbSeek(xFilial("SC7")+DBM->(PadR(DBM_NUM,TamSX3("C7_NUM")[1])+PadR(DBM_ITEM,TamSX3("C7_ITEM")[1])))) .And. Empty(SC7->C7_APROV)
                    		Reclock("SC7",.F.)
                    		SC7->C7_CONAPRO := "L"
                    		SC7->(MsUnlock())
                    		
                    	EndIf
                  EndIf
                  DBM->(dbSkip())
				EndDo
				If MtGLastDBM(SCR->CR_TIPO,SCR->CR_NUM) .And. !Empty(SC7->C7_APROV)
					IF !Empty(SC7->C7_APROV) 
						lRet := MaAlcDoc({SC7->C7_NUM,"PC",A097TotPC(SC7->C7_NUM),,,SC7->C7_APROV,,SC7->C7_MOEDA,SC7->C7_TXMOEDA,SC7->C7_EMISSAO},SC7->C7_EMISSAO,1)
					EndIf
					If lRet
						//Alimenta array para envio de email
						While SC7->(dbSeek(xFilial("SC7")+DBM->(PadR(DBM_NUM,TamSX3("C7_NUM")[1])))) .And. !(SC7->(EoF()))
							If cEnvPed $ "1|2" .And. !Empty(SC7->C7_APROV)
								aMail	:= {AllTrim(POSICIONE('SA2', 1, xFilial('SA2') + SC7->(C7_FORNECE+C7_LOJA), 'A2_EMAIL'))}
								If !(Empty(aMail[1]))
									If Empty(Len(aPedCom))
										Aadd(aPedCom,SC7->C7_NUM)
										Aadd(aPedCom,AllTrim(POSICIONE('SA2', 1, xFilial('SA2') + SC7->(C7_FORNECE+C7_LOJA), 'A2_NOME')) + " - " + AllTrim(SC7->C7_FORNECE) + "/" + SC7->C7_LOJA)
										Aadd(aPedCom,cNomeEmp + " - " + cNomeFil)
										Aadd(aPedCom,C7_CONTATO)
										Aadd(aPedCom,{})
									EndIf
								EndIf
								Aadd(aPedCom[5],{	SC7->C7_ITEM,;
													SC7->C7_PRODUTO,;
													POSICIONE('SB1', 1, xFilial('SB1') + SC7->C7_PRODUTO, 'B1_DESC'),;
													SC7->C7_UM,;
													SC7->C7_QUANT,;
													SC7->C7_PRECO,;
													SC7->C7_TOTAL,;
													SC7->C7_DATPRF;
												})
							EndIf
						EndDo
						SC7->(DbSkip())
					EndIf
				EndIf
				
				ElseIf !Empty(aMTAlcDoc)
					dbSelectArea(aMTAlcDoc[2])
					dbSetOrder(aMTAlcDoc[3])
					MsSeek(xFilial(aMTAlcDoc[2])+Substr(SCR->CR_NUM,1,Len(&(aMTAlcDoc[4]))))
					While !EOF() .And. &(aMTAlcDoc[4]) == Substr(SCR->CR_NUM,1,Len(&(aMTAlcDoc[4])))
						RecLock(aMTAlcDoc[2],.F.)
						&(aMTAlcDoc[7,1]) := aMTAlcDoc[7,3]
						MsUnLock()
						(aMTAlcDoc[2])->(dbSkip())
					End
				EndIf
			EndIf			
		
		//Envia email para fornecedor.
		If cEnvPed $ "1|2" .And. Len(aMail) > 0 .And. !(Empty(aMail[1]))
			nOpMail := 2
			cTit 	:= cNomeEmp + " - " + cNomeFil + " - Pedido de Compra " + aPedCom[1]
			cBody 	:= A120GerMail(aPedCom,nOpMail)
				
			MTSendMail(aMail,cTit,cBody)

		EndIf
		
	End Transaction
	//�����������������������������������������������������������Ŀ
	//� Finaliza a gravacao dos lancamentos do SIGAPCO            �
	//�������������������������������������������������������������
	PcoFinLan("000055")
Else
	Help(" ",1,"A097LOCK")

	If cTipo == "NF"
		SF1->(MsUnlockAll())
	ElseIf cTipo $ "PC|AE|IP"
		SC7->(MsUnlockAll())
	ElseIf cTipo == "CP"
		SC3->(MsUnlockAll())
	ElseIf cTipo == "MD"
		CND->(MsUnlockAll())
	ElseIf cTipo == "IM"
		CNE->(MsUnlockAll())
	ElseIf SCR->CR_TIPO $ "CT"
		CN9->(MsUnlockAll())
	ElseIf cTipo == "SC"
		SC1->(MsUnlockAll())
	ElseIf cTipo == "SA"
		SCP->(MsUnlockAll())
	ElseIf !Empty(aMTAlcDoc)
		(aMTAlcDoc[2])->(MsUnLockAll())
	EndIf
Endif

//--------------------------------------------------------------------
/*/{Protheus.doc} A097ProcTf()
Realiza transferencia para superior
@author Leonardo Quintania
@since 28/01/2013
@version 1.0
@return aReturn
/*/
//--------------------------------------------------------------------
Function A097ProcTf(nReg,nOpc,cAprovS,cObs,dRefer)
Local lMta097    := ExistBlock("MTA097S")

Default cAprovS	:= SAK->AK_APROSUP
Default cObs		:= SCR->CR_OBS
Default dRefer	:= SCR->CR_DATALIB

Begin Transaction
	If lMta097
		If ExecBlock("MTA097S",.F.,.F.)
			Processa({|lEnd| lLiberou := MaAlcDoc({SCR->CR_NUM,SCR->CR_TIPO,,cAprovS,,,,,,,cObs},dRefer,2)})
		EndIf
	Else
		Processa({|lEnd| lLiberou := MaAlcDoc({SCR->CR_NUM,SCR->CR_TIPO,,cAprovS,,,,,,,cObs},dRefer,2)})
	EndIf
End Transaction

Return .T.

//--------------------------------------------------------------------
/*/{Protheus.doc} ScrItComPai
Retorna se o item possui documento gerador.
@param cDoc:	Documento a ser verificado.
		nTot:	Valor total do Pai do item (variavel para retorno).
		cTipo: Tipo do documento de aprova��o.

@author Israel Escorizza
@since 13/05/2015
@version 1.0
@return lRet
/*/
//--------------------------------------------------------------------
Static Function ScrItComPai(cDoc,nTot,cTipo)
Local aAreaSCR   := SCR->( GetArea() )
Local lRet 	     := .F.

Default cTipo := "PC"

SCR->(dbSetOrder(1))
If (lRet :=  SCR->(dbSeek(xFilial("SCR")+cTipo+cDoc)))
	nTot := SCR->CR_TOTAL
EndIf

RestArea( aAreaSCR )

Return lRet

//--------------------------------------------------------------------
/*/{Protheus.doc} A097TotPC()
Retorna se o valor total do documento 
@author Leonardo Quintania
@since 04/09/2013
@version 1.0
@return aReturn
/*/
//--------------------------------------------------------------------
Static Function A097TotPC(cPedido)
Local aArea := GetArea()

BeginSQL Alias "TMPSC7"
	SELECT SUM(C7_TOTAL + C7_VALFRE + C7_SEGURO + C7_DESPESA - C7_VLDESC) TOTPED
	FROM %Table:SC7%
	WHERE %NotDel% AND
	      C7_FILIAL = %xFilial:SC7% AND
	      C7_RESIDUO <> 'S' AND
	      C7_NUM = %Exp:cPedido%
EndSQL
	
nRet := TMPSC7->TOTPED
TMPSC7->(dbCloseArea())
RestArea(aArea)

Return nRet
//-------------------------------------------------------------------
/*/{Protheus.doc} A097FstNiv()
Funcao que retorna o primeiro nivel do Grupo de Aprova��o

@param cGrAprov

@author rafael.duram
@since 21/08/2015
@version 1.0
@return cNivel 
/*/
//-------------------------------------------------------------------

Function A097FstNiv(cGrAprov,cTipoDoc,cNumDoc)
Local cNivel 	:= ""
Local aAreaAnt	:= GetArea()	
Local aAreaSAL	:= {}
Local cAliasTemp	:= ""

// Verifica o menor nivel que foi gerado al�ada
If cTipoDoc <> NIL

	cAliasTemp	:= GetNextAlias()

	BeginSQL Alias cAliasTemp

	SELECT DISTINCT SCR.CR_NIVEL
	FROM %Table:SCR% SCR
	WHERE SCR.%NotDel% AND
	SCR.CR_FILIAL = %xFilial:SCR% AND
	SCR.CR_NUM = %Exp:cNumDoc% AND
	SCR.CR_TIPO = %Exp:cTipoDoc%

	EndSQL

	While !(cAliasTemp)->(Eof())
		If Empty(cNivel) .Or. (cAliasTemp)->CR_NIVEL < cNivel
			cNivel := (cAliasTemp)->CR_NIVEL
		Endif
		(cAliasTemp)->(DbSkip())
	EndDo
	DbCloseArea(cAliasTemp)

Else // Verifica o menor nivel do grupo de aprova��o

	aAreaSAL	:= SAL->(GetArea())
	DbSelectArea('SAL')
	SAL->(DbSetOrder(1))
	SAL->(MsSeek(xFilial('SAL')+cGrAprov))

	While SAL->(!Eof()) .And. xFilial('SAL')+cGrAprov == SAL->(AL_FILIAL+AL_COD)
	If Empty(cNivel) .Or. SAL->AL_NIVEL < cNivel
		cNivel := SAL->AL_NIVEL
	Endif
	SAL->(dbSkip())
	EndDo

	RestArea(aAreaSAL)

Endif

RestArea(aAreaAnt)

Return cNivel

//-------------------------------------------------------------------
/*/{Protheus.doc} A097AprFlg()
Funcao que retorna se a aprova��o do processo devera ocorrer apenas pelo Fluig

@param cTpAprov

@author rafael.duram
@since 23/09/2015
@version 1.0
@return lAprovFlg
/*/
//-------------------------------------------------------------------

Function A097AprFlg(cTpAprov)
Local lAprovFlg 	:= .F.
Local aAreaAnt	:= GetArea()
Local aAreaCPF	:= CPF->(GetArea())

dbSelectArea("CPF")
dbSetOrder(1)

If CPF->(DbSeek(xFilial('CPF')+cTpAprov)) .And. CPF->CPF_AFLUIG == "1"
	lAprovFlg := .T.
Endif

RestArea(aAreaCPF)
RestArea(aAreaAnt)

Return lAprovFlg

//-------------------------------------------------------------------
/*/{Protheus.doc} A097LibVal()
Funcao que retorna se a libera��o do processo podera ser realizada

@param cRotina

@author rafael.duram
@since 24/09/2015
@version 1.0
@return lLibera
/*/
//-------------------------------------------------------------------

Function A097LibVal(cRotina)
Local lLibera 	:= .T.
Local cCodRot		:= Substr(cRotina,5,3) // Ex: "097", "094"

If !Empty(SCR->CR_DATALIB) .And. SCR->CR_STATUS $ "03#05#06"
	Help(" ",1,"A097LIB")  // "Problema: Este documento j� foi liberado. ## "Solu��o: Escolha outro item que n�o foi liberado."
	lLibera := .F.
ElseIf SCR->CR_STATUS $ "01"
	Aviso("A"+cCodRot+"BLQ",STR0083,{STR0031}) // "Esta opera��o n�o poder� ser realizada pois este registro se encontra bloqueado pelo sistema (aguardando outros niveis)"
	lLibera := .F.
ElseIf !Empty(SCR->CR_FLUIG) .And. A097AprFlg(SCR->CR_TIPO)
	Aviso("A"+cCodRot+"FLG",STR0100,{STR0031}) // "Esta opera��o deve ser realizada somente atrav�s do Fluig, conforme defini��o no Gerador de Processos."
	lLibera := .F.
EndIf

Return lLibera
