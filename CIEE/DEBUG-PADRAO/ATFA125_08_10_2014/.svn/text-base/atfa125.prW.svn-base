#Include "ATFA125.CH"
#Include "TOPCONN.CH"
#Include "AP5MAIL.CH"
#Include "TBICONN.CH"
#Include "PROTHEUS.CH"

//********************************
// Controle de multiplas moedas  *
//********************************
Static lMultMoed := FindFunction( "AtfMoedas" )

// POSICOES DO ARRAY aMoedas (Moedas usadas no sistema)
// 1) N: Numero  Moeda
// 2) C: Simbolo Moeda
// 3) C: Nome    Moeda
// 4) N: Taxa    Moeda no SM2
#DEFINE _MdNumero		1
#DEFINE _MdSimbolo		2
#DEFINE _MdNome			3
#DEFINE _MdTaxa			4

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡…o    ³ ATFA125  ³ Autor ³ Marcos R. Pires       ³ Data ³ 19/07/10 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³ Rotina de Solicitacoes de baixa e transferencia            ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Sintaxe   ³ ATFA125                                                    ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³ ATF                                                        ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
Function ATFA125()

Local aCores := {}

Private cCadastro := STR0009 	//"Solicitações de baixa e transferência de Ativo"
Private aRotina	  := MenuDef()
Private aEmailSol := {}

//Verifica se controle de solicitações está ativado
If SuperGetMv( "MV_ATFSOLD", .F., "2" ) == "2"
	Help(" ",1,"AF125SOLD",,STR0020,1,0) //"Controle de solicitações desativado, verifique parâmetro 'MV_ATFSOLD'."
	Return Nil
EndIf

//Verifica se tabelas SNM( Documentos de Solicitação) e SNL(Cadastro de Locais) foram criadas.
If !AliasInDic( "SNM" ) 
	Help(" ",1,"AF125SNM",,"(SNM) " + STR0069 ,1,0) //"Tabela não encontrada, atualize o sistema." 
	Return Nil
EndIf

If !AliasInDic( "SNL" )
	Help(" ",1,"AF125SNL",,"(SNL) " + STR0069 ,1,0) //"Tabela não encontrada, atualize o sistema." 
	Return Nil
EndIf

If Alltrim(xFilial("SN1")) != Alltrim(xFilial("SNM"))
	Help(" ",1,"AF125FIL",,"(SNL) " + "(SNM) " + STR0150 ,1,0) //"A tabela SNM deve ter o mesmo modo de compartilhamento da tabela SN1, por favor verifique a configuração"
	Return Nil
EndIf

If FindFunction("CTBINTRAN")
	lCtbInTran := CtbInTran( 1, .F. )
Else   
	Help(" ",1,"AF125TRAN",,STR0148,1,0) //"Função CTBINTRAN não está presente no ambiente. Por favor atualizar."
	lCtbInTran := .F.
EndIf

If !lCtbInTran
	Return()
EndIf

aAdd( aCores, { "NM_SITSOL == '2'", "BR_VERDE"    } ) //Aprovada
aAdd( aCores, { "NM_SITSOL == '3'", "BR_VERMELHO" } ) //Rejeitada
aAdd( aCores, { "NM_SITSOl == '1'", "BR_AMARELO"  } ) //Pendente

dbSelectArea( "SNM" )
dbSetOrder(1)

mBrowse( 6, 1, 22, 75, "SNM", , /*cCpo*/, /*nPar08*/, /*cFun*/, /*nClickDef*/, aCores)

Return

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³ AF125SolBx  ºAutor  ³Microsiga         º Data ³  08/25/10  º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ Solicitacao de baixa de ativo.                             º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ SIGAATF                                                    º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
Function AF125SolBx( cAlias, nReg, nOpc )

Static oDlg

Local oButton1
Local oButton2
Local oFolder1

//FOLDER 1
//Dados do bem
Local oCBASE, oITEM, oTIPO, oDESCBEM
Local cCBASE	:= ""
Local cITEM		:= ""
Local cTIPO 	:= ""
Local cDESCBEM	:= ""
//Informacoes complementares
Local oN1_QTDE, oQTDBX, oPERCBX, oMOTBX, oCONDPG, oVLRBAIX, oVLVENDA
Local nN1_QTDE	:= 0
Local nQTDBX	:= 0
Local nPERCBX	:= 0
Local cMOTBX	:= ""
Local cCONDPG	:= ""
Local nVLRBAIX	:= 0
Local nVLVENDA	:= 0
//Dados da Nota Fiscal
Local oGERANF, oCLIENTE, oLOJA, oNOTA, oSERIE, oTESNFS
Local cGERANF	:= ""
Local cCLIENTE	:= ""
Local cLOJA		:= ""
Local cNOTA		:= ""
Local cSERIE	:= ""
Local cTESNFS	:= ""

//FOLDER 2
//Dados da solicitacao
Local oDATSOL, oHORSOL, oUSRSOL, oNMUSSOL, oHistSol
Local dDATSOL
Local dHORSOL
Local cUSRSOL	:= ""
Local cNMUSSOL	:= ""
Local cHistSol
//Dados da Aprov/Rejeic
Local odDTAPVRE, odHRAPVRE, oUSRAPV, oNMUSAPV, ocHistApRj
Local ddDTAPVRE
Local ddHRAPVRE
Local cUSRAPV	:= ""
Local cNMUSAPV	:= ""
Local cHistApRj

Local cCapital	:= ""
Local aMotivos	:= {}
Local cCodSol
Local nRecSN1 := 0

Static oGetValores

Private INCLUI := ( nOpc == 3 )

If INCLUI
	
	//FOLDER 1
	//Dados do bem
	cCBASE		:= CriaVar( "NM_CBASE" )
	cITEM		:= CriaVar( "NM_ITEM" )
	cTIPO		:= ""
	cDESCBEM	:= ""
	//Informacoes complementares
	nN1_QTDE	:= 0
	nQTDBX		:= 0
	nPERCBX		:= 0
	cMOTBX		:= "01"
	cCONDPG		:= CriaVar( "E4_CODIGO" )
	nVLRBAIX	:= 0
	nVLVENDA	:= 0
	//Dados da Nota Fiscal
	cGERANF		:= "2"
	cCLIENTE	:= CriaVar( "NM_CLIENTE" )
	cLOJA		:= ""
	cNOTA		:= CriaVar( "NM_NOTA" )
	cSERIE		:= CriaVar( "NM_SERIE" )
	cTESNFS		:= CriaVar( "NM_TESNFS" )
	
	//FOLDER 2
	//Dados da solicitacao
	dDATSOL		:= dDataBase
	dHORSOL		:= Left(TIME(),5)
	cUSRSOL		:= __cUserID
	cNMUSSOL	:= cUserName
	
Else //Exclusão ou Visualização
	
	//FOLDER 1
	//Dados do bem
	cCBASE	 	:= SNM->NM_CBASE
	cITEM	 	:= SNM->NM_ITEM
	cTIPO	 	:= SNM->NM_TIPO
	//Informacoes complementares
	nQTDBX		:= SNM->NM_QTDBX
	nPERCBX		:= SNM->NM_PERCBX
	cMOTBX		:= SNM->NM_MOTBX
	cCONDPG		:= SNM->NM_CONDPG
	nVLRBAIX	:= SNM->NM_VLRBAIX
	nVLVENDA	:= SNM->NM_VLVENDA
	//Dados da Nota Fiscal
	cGERANF		:= SNM->NM_GERANF
	cCLIENTE	:= SNM->NM_CLIENTE
	cLOJA		:= SNM->NM_LOJA
	cNOTA		:= SNM->NM_NOTA
	cSERIE		:= SNM->NM_SERIE
	cTESNFS		:= SNM->NM_TESNFS
	
	//FOLDER 2
	//Dados da solicitacao
	dDATSOL		:= SNM->NM_DATSOL
	dHORSOL		:= SNM->NM_HORSOL
	cUSRSOL		:= SNM->NM_USRSOL
	cHistSol 	:= MSMM( SNM->NM_CDHSOL, 80 )
	//Dados da Aprov/Rejeic
	dDTAPVRE	:= SNM->NM_DTAPVRE
	dHRAPVRE	:= SNM->NM_HRAPVRE
	cUSRAPV		:= SNM->NM_USRAPV
	cHistApRj	:= MSMM( SNM->NM_CDHREJ, 80 )
	
	cNMUSSOL := USRFULLNAME( SNM->NM_USRSOL )
	cNMUSAPV := USRFULLNAME( SNM->NM_USRAPV )
	
	dbSelectArea( "SN1" )
	dbSetOrder(1)
	
	If SN1->( dbSeek( xFilial( "SN1" ) + cCbase + cItem ) )
		cDescBem := SN1->N1_DESCRIC
		nN1_QTDE := SN1->N1_QUANTD
	Else
		Help(" ",1,"AF125ITEM",,STR0022,1,0) //"Item nao encontrado"
	EndIf
	
EndIf

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Verifica tabela de motivos para baixa ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
dbSelectArea( "SX5" )
SX5->( dbSeek( xFilial( "SX5" ) + "16" ) )

While SX5->X5_FILIAL + SX5->X5_TABELA == xFilial("SX5") + "16"
	If !( Alltrim(SX5->X5_CHAVE) $ '13/15/16/17')
		cCapital := Capital( X5Descri() )
		aAdd( aMotivos, Left( SX5->X5_CHAVE, 2) + "=" + SubStr( cCapital, 1, 12 ) )
	EndIf
	SX5->( dbSkip() )
End

If INCLUI
DEFINE MSDIALOG oDlg TITLE STR0023 FROM 000, 000  TO 405, 766 PIXEL	//"Solicitação de Baixa"
ElseIf nOpc ==  2
DEFINE MSDIALOG oDlg TITLE STR0023 +" - "+ STR0002 FROM 000, 000  TO 405, 766 PIXEL	//"Visualizar"
ElseIf nOpc == 7
DEFINE MSDIALOG oDlg TITLE STR0023 +" - "+ STR0007 FROM 000, 000  TO 405, 766 PIXEL	//"Excluir" 
EndIf

@ 000, 000 FOLDER oFolder1 SIZE 383, 202 OF oDlg ITEMS STR0024, STR0025 PIXEL	//"Dados do Bem" | "Dados da Solicitacao"

//FOLDER 1
//Dados do Bem
@ 000, 002 GROUP oGroup3 TO 024, 377 PROMPT STR0025  OF oFolder1:aDialogs[1] PIXEL //"Dados do Bem"
@ 010, 015 SAY   STR0026               SIZE 019, 007 OF oFolder1:aDialogs[1] PIXEL COLOR CLR_HBLUE	//"Código"
@ 009, 036 MSGET oCBASE   VAR cCBASE   SIZE 043, 010 OF oFolder1:aDialogs[1] PIXEL VALID A125AtCpBx( STR0026, @cCBASE, @cITEM, @cTipo, @cDescBem, @nN1_QTDE, @nQTDBX, @nPercBx, @cCondPg, @cGeraNF, @cCliente, @cLoja, @cTESNFS, @cNota, @cSerie,,,@nVLRBAIX, @nRecSN1 ) ON CHANGE cItem := CRIAVAR( "NM_ITEM" )
oCBASE:BF3 := {|| AF125F3Cod( @cCBASE, @cItem, @oCBASE )}
@ 010, 095 SAY   STR0027               SIZE 013, 007 OF oFolder1:aDialogs[1] PIXEL //"Item"
@ 009, 110 MSGET oITEM    VAR cITEM    SIZE 022, 010 OF oFolder1:aDialogs[1] PIXEL VALID A125AtCpBx( STR0027, @cCBASE, @cITEM, @cTipo, @cDescBem, @nN1_QTDE, @nQTDBX, @nPercBx, @cCondPg, @cGeraNF, @cCliente, @cLoja, @cTESNFS, @cNota, @cSerie, Inclui,,@nVLRBAIX, @nRecSN1 )
@ 010, 152 SAY   STR0028               SIZE 013, 007 OF oFolder1:aDialogs[1] PIXEL //"Tipo"
@ 009, 167 MSGET oTIPO    VAR cTIPO    SIZE 020, 010 OF oFolder1:aDialogs[1] PIXEL WHEN .F.
@ 010, 210 SAY   STR0029               SIZE 027, 007 OF oFolder1:aDialogs[1] PIXEL //"Descrição"
@ 009, 239 MSGET oDESCBEM VAR cDESCBEM SIZE 124, 010 OF oFolder1:aDialogs[1] PIXEL WHEN .F.

//Informacoes Complementares
@ 025, 002 GROUP oGroup4 TO 136, 377   PROMPT STR0030  		  OF oFolder1:aDialogs[1] PIXEL //"Informações Complementares"
@ 036, 007 SAY   STR0031                 		SIZE 027, 007 OF oFolder1:aDialogs[1] PIXEL //"Qtde Atual"
@ 034, 036 MSGET oN1_QTD  		VAR nN1_QTDE   	SIZE 052, 010 OF oFolder1:aDialogs[1] PIXEL WHEN .F. PICTURE X3Picture( "N1_QUANTD" )
@ 036, 090 SAY   STR0032                 		SIZE 034, 007 OF oFolder1:aDialogs[1] PIXEL COLOR CLR_HBLUE	//"Qtde Baixada"
@ 034, 125 MSGET oQTDBX   		VAR nQTDBX     	SIZE 052, 010 OF oFolder1:aDialogs[1] PIXEL PICTURE X3Picture( "NM_QTDBX" ) VALID A125AtCpBx( STR0032, @cCBASE, @cITEM, @cTipo, @cDescBem, @nN1_QTDE, @nQTDBX, @nPercBx, @cCondPg, @cGeraNF, @cCliente, @cLoja, @cTESNFS, @cNota, @cSerie,,,@nVLRBAIX )
@ 036, 182 SAY   STR0033                 		SIZE 034, 007 OF oFolder1:aDialogs[1] PIXEL //"Perc Baixado"
@ 034, 211 MSGET oPERCBX  		VAR nPERCBX    	SIZE 065, 010 OF oFolder1:aDialogs[1] PIXEL WHEN .F. PICTURE X3Picture( "NM_PERCBX" )
@ 036, 279 SAY   STR0034                 		SIZE 027, 007 OF oFolder1:aDialogs[1] PIXEL //"Mot. Baixa"
@ 034, 311 MSCOMBOBOX oMOTBX 	VAR cMOTBX ITEMS aMotivos SIZE 057, 010 OF oFolder1:aDialogs[1] PIXEL
@ 050, 006 SAY   STR0035                 		SIZE 029, 007 OF oFolder1:aDialogs[1] PIXEL //"Cond. Pgto"
@ 048, 036 MSGET oCONDPG     	VAR cCONDPG    	SIZE 051, 010 OF oFolder1:aDialogs[1] PIXEL F3 "SE4" WHEN Left(cMOTBX,2) == "01" VALID Vazio( cCONDPG ) .Or. ExistCpo( "SE4", cCONDPG )
@ 050, 178 SAY   STR0036                 		SIZE 024, 007 OF oFolder1:aDialogs[1] PIXEL //"Vlr. Baixa"
@ 048, 211 MSGET oVLRBAIX 		VAR nVLRBAIX   	SIZE 065, 010 OF oFolder1:aDialogs[1] PIXEL WHEN .F. PICTURE X3Picture( "NM_VLRBAIX" )
@ 050, 279 SAY   STR0037                 		SIZE 027, 007 OF oFolder1:aDialogs[1] PIXEL //"Vlr. Venda"
@ 048, 311 MSGET oVLVENDA 		VAR nVLVENDA   	SIZE 065, 010 OF oFolder1:aDialogs[1] PIXEL WHEN Left(cMOTBX,2) == "01"  PICTURE X3Picture( "NM_VLVENDA" )

A125GetDad( oFolder1, nOpc )

//Dados da Nota Fiscal
@ 138, 002 GROUP oGroup5 TO 168, 377 PROMPT STR0038 OF oFolder1:aDialogs[1] PIXEL	//"Dados da Nota Fiscal" 
@ 149, 009 SAY STR0039                 SIZE 025, 007 OF oFolder1:aDialogs[1] PIXEL	//"Gera NFS"
@ 148, 036 MSCOMBOBOX oGERANF VAR cGERANF ITEMS { "1=" + STR0040 /*Sim*/, "2=" + STR0041 /*Não*/ } SIZE 030, 010 OF oFolder1:aDialogs[1] PIXEL VALID A125AtCpBx( STR0039, @cCBASE, @cITEM, @cTipo, @cDescBem, @nN1_QTDE, @nQTDBX, @nPercBx, @cCondPg, @cGeraNF, @cCliente, @cLoja, @cTESNFS, @cNota, @cSerie, , @cMotBx,@nVLRBAIX )	//"Sim" | "Não"
@ 149, 070 SAY STR0042                 SIZE 019, 007 OF oFolder1:aDialogs[1] PIXEL	//"Cliente"
@ 148, 95 MSGET oCLIENTE  VAR cCLIENTE SIZE 032, 010 OF oFolder1:aDialogs[1] PIXEL F3 "SA1"  When cGERANF == "1" VALID A125AtCpBx( STR0042,@cCBASE,@cITEM,@cTipo,@cDescBem,@nN1_QTDE,@nQTDBX,@nPercBx,@cCondPg,@cGeraNF,@cCliente,@cLoja,@cTESNFS,@cNota,@cSerie,,,@nVLRBAIX)
@ 149, 137 SAY STR0043                 SIZE 012, 007 OF oFolder1:aDialogs[1] PIXEL	//"Loja"
@ 148, 152 MSGET oLOJA    VAR cLOJA    SIZE 020, 010 OF oFolder1:aDialogs[1] PIXEL When .F.
@ 149, 180 SAY STR0044                 SIZE 028, 007 OF oFolder1:aDialogs[1] PIXEL	//"TES Saida"
@ 148, 209 MSGET oTESNFS  VAR cTESNFS  SIZE 018, 010 OF oFolder1:aDialogs[1] PIXEL F3 "SF4"  WHEN cGERANF == "1" VALID A125AtCpBx( "TES", @cCBASE, @cITEM, @cTipo, @cDescBem, @nN1_QTDE, @nQTDBX, @nPercBx, @cCondPg, @cGeraNF, @cCliente, @cLoja, @cTESNFS, @cNota, @cSerie,,,@nVLRBAIX) //Vazio( cTESNFS ) .Or. ExistCpo( "SF4", cTESNFS )
@ 149, 245 SAY STR0045                 SIZE 023, 007 OF oFolder1:aDialogs[1] PIXEL	//"Num. NF"
@ 148, 270 MSGET oNOTA    VAR cNOTA    SIZE 043, 010 OF oFolder1:aDialogs[1] PIXEL F3 "SF2"  WHEN cGERANF == "3" VALID A125AtCpBx( STR0045, @cCBASE, @cITEM, @cTipo, @cDescBem, @nN1_QTDE, @nQTDBX, @nPercBx, @cCondPg, @cGeraNF, @cCliente, @cLoja, @cTESNFS, @cNota, @cSerie,,,@nVLRBAIX )
@ 149, 322 SAY STR0046                 SIZE 015, 007 OF oFolder1:aDialogs[1] PIXEL	//"Serie"
@ 148, 340 MSGET oSERIE   VAR cSERIE   SIZE 020, 010 OF oFolder1:aDialogs[1] PIXEL F3 "01"   WHEN cGERANF == "1" VALID Vazio( cSerie ) .Or. ExistCpo( "SX5", "01" + cSerie )

//FOLDER 2
//Dados da Solicitacao
@ 000, 002 GROUP oGroup1 TO 082, 377 PROMPT STR0025 OF oFolder1:aDialogs[2] COLOR 0, 16777215 PIXEL	//"Dados da Solicitação"
@ 014, 010 SAY STR0047     			 	SIZE 028, 007 OF oFolder1:aDialogs[2] PIXEL	//"Data Solic."
@ 013, 051 MSGET oDATSOL  VAR dDATSOL 	SIZE 060, 010 OF oFolder1:aDialogs[2] PIXEL WHEN .F.
@ 014, 136 SAY   STR0048    		 	SIZE 028, 007 OF oFolder1:aDialogs[2] PIXEL	//"Hora Solic."
@ 013, 165 MSGET oHORSOL  VAR dHORSOL 	SIZE 060, 010 OF oFolder1:aDialogs[2] PIXEL WHEN .F. PICTURE X3Picture( "NM_HORSOL" )
@ 028, 010 SAY   STR0016   			 	SIZE 035, 007 OF oFolder1:aDialogs[2] PIXEL	//"Solicitante"
@ 027, 051 MSGET oUSRSOL  VAR cUSRSOL 	SIZE 060, 010 OF oFolder1:aDialogs[2] PIXEL WHEN .F.
@ 028, 133 SAY   STR0049   			 	SIZE 030, 007 OF oFolder1:aDialogs[2] PIXEL	//"Nome Solic."
@ 027, 165 MSGET oNMUSSOL VAR cNMUSSOL  SIZE 155, 010 OF oFolder1:aDialogs[2] PIXEL WHEN .F.
@ 044, 022 SAY   STR0050  				SIZE 027, 007 OF oFolder1:aDialogs[2] PIXEL COLOR CLR_HBLUE	//"Hist. Solic."
@ 054, 021 GET   oHistSol VAR cHistSol OF oFolder1:aDialogs[2] MULTILINE SIZE 332, 020 HSCROLL PIXEL

//Dados da Aprov/Rejeic
@ 085, 002 GROUP oGroup2 TO 167, 377 PROMPT STR0051 OF oFolder1:aDialogs[2] PIXEL	//"Dados da Aprov/Rejeic"
@ 099, 019 SAY   STR0052    				SIZE 030, 007 OF oFolder1:aDialogs[2] PIXEL	//"Dt Apv/Rej."
@ 097, 051 MSGET odDTAPVRE VAR ddDTAPVRE 	SIZE 060, 010 OF oFolder1:aDialogs[2] PIXEL WHEN .F.
@ 099, 136 SAY   STR0053    				SIZE 027, 007 OF oFolder1:aDialogs[2] PIXEL	//"Hr apv/rej."
@ 097, 165 MSGET odHRAPVRE VAR ddHRAPVRE 	SIZE 060, 010 OF oFolder1:aDialogs[2] PIXEL WHEN .F. PICTURE X3Picture( "NM_HRAPVRE" )
@ 113, 017 SAY   STR0054   					SIZE 032, 007 OF oFolder1:aDialogs[2] PIXEL	//"Apr/Rej. Por"
@ 112, 051 MSGET oUSRAPV   VAR cUSRAPV   	SIZE 060, 010 OF oFolder1:aDialogs[2] PIXEL WHEN .F.
@ 113, 130 SAY   STR0055    				SIZE 033, 007 OF oFolder1:aDialogs[2] PIXEL
@ 112, 165 MSGET oNMUSAPV  VAR cNMUSAPV  	SIZE 155, 010 OF oFolder1:aDialogs[2] PIXEL WHEN .F.
@ 129, 022 SAY   STR0056   					SIZE 029, 007 OF oFolder1:aDialogs[2] PIXEL	//"Hist. Rejeic"
@ 139, 021 GET ocHistApRj  VAR cHistApRj OF oFolder1:aDialogs[2] MULTILINE SIZE 332, 020 HSCROLL PIXEL WHEN .F.

DEFINE SBUTTON FROM 185, 310 TYPE 1 ACTION If( AF125TOkBx( nOpc, cCBASE, cItem, cItem, nQtdBx, cMotbx, cCondPg, nVlVenda, cGeraNF, cCliente, cLoja, cSerie, cTESNFS, cHistSol ), ( cCodSol := AF125PrcBx( nOpc, cCBase, cItem, cTipo, nQTDbx, nPercBX, cMotbx, cCondPg, nVlrBaix, nVlVenda, cGeraNF, cCliente, cLoja, cNota, cSerie, cTESNFS, dDATSOL, dHorsol, cUsrSol, cHistSol ), oDlg:End()), Nil ) ENABLE OF oDlg
DEFINE SBUTTON FROM 185, 345 TYPE 2 ACTION oDlg:End() ENABLE OF oDlg PIXEL

// Exclusão ou visualização
If !INCLUI
	oCbase:lReadonly	:= .T.
	oQtdBx:lReadonly	:= .T.
	oMotBx:lReadonly	:= .T.
	oCondPg:lReadonly	:= .T.
	oVlVenda:lReadonly	:= .T.
	oGeraNF:lReadonly	:= .T.
	oCliente:lReadonly	:= .T.
	oNota:lReadonly		:= .T.
	oTESNFS:lReadonly	:= .T.
	oHistSol:lReadonly	:= .T.
	oItem:lReadOnly     := .T.
	oSerie:lReadOnly    := .T.
EndIf

ACTIVATE MSDIALOG oDlg CENTERED
SN1->(MsRUnlock(nRecSN1))
Return

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³A125GetDad   ºAutor  ³Microsiga        º Data ³  08/25/10   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ Monta GetDados com as moedas do sistema                    º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ SIGAATF                                                    º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
Static Function A125GetDad( oFolder1, nOpc )

Local nX
Local aHeaderEx		:= {}
Local aColsEx		:= {}
Local aAlterFields	:= {}
Local aMoedas		:= {}

Local aTamCpo  := TamSX3( "NM_VLRBAIX" )
Local cPictCpo := X3Picture( "NM_VLRBAIX" )

//              "cTitulo"         ,"cCampo" ,"cPicture","nTamanho","nDecimais","cValidação","cReservado","cTipo","xReservado1","xReservado2"
aAdd( aHeaderEx, { "Moeda"           , 'DESCRIC', "@!"    , 10        , 0         , "", "û", 'C', '', '', '', '', ".T."})
aAdd( aHeaderEx, { "Valor Atualizado", 'VLRATU' , cPictCpo, aTamCpo[1], aTamCpo[2], "", "û", 'N', '', '', '', '', ".T."})
aAdd( aHeaderEx, { "Valor Residual"  , 'VLRRES' , cPictCpo, aTamCpo[1], aTamCpo[2], "", "û", 'N', '', '', '', '', ".T."})
aAdd( aHeaderEx, { "Valor da Baixa"  , 'VLRBX'  , cPictCpo, aTamCpo[1], aTamCpo[2], "", "û", 'N', '', '', '', '', ".T."})

aMoedas := Atf125Moe()

For nx := 1 To Len( aMoedas )
	aAdd( aColsEx, { aMoedas[nX,2], 0, 0, 0, .F. } )
Next

oGetValores := MsNewGetDados():New( 065, 007, 130, 372, GD_UPDATE, "AllwaysTrue", "AllwaysTrue", "", aAlterFields, ,;
99, "AllwaysTrue", "","AllwaysTrue", oFolder1:aDialogs[1], aHeaderEx, aColsEx )

Return

/*
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡„o	 ³ Atf125Moe  ³ Autor ³ Cristiano Denardi     ³ Data ³ 16/11/04 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡„o ³ Monta Array com dados das Moedas Utilizadas Pelo Sistema		³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Uso		 ³ Paises Localizados											³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Parametros³ ( Void )  													³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Retorno	 ³ RetA1 = Moedas												³±±
±±³     	 ³         [1] N: Numero  Moeda									³±±
±±³     	 ³         [2] C: Simbolo Moeda									³±±
±±³     	 ³         [3] C: Nome    Moeda									³±±
±±³     	 ³         [4] N: Taxa    Moeda no SM2							³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
Static Function Atf125Moe()

Local nA	 := 0
Local aArea	 := GetArea()
Local nMoeda := 0
Local aAux	 := {}
Local aRet 	 := {} // Array com dados das Moedas Utilizadas Pelo Sistema
Local __nQuantas := If(lMultMoed,AtfMoedas(),5)
Local nX	:= 0
Local cParam:= ""

SM2->( DbSetOrder(1) ) // M2_DATA
SM2->( DbSeek( dDataBase ) )
For nX := 1 to __nQuantas
	cParam := "MV_SIMB"+cValToChar(nX)
	If !Empty( GetMv( cParam ) )
		nMoeda := nX
		aAux := {}
		aAdd( aAux, {,,,} )
		aAux[ 1, _MdNumero  ] := nMoeda
		aAux[ 1, _MdSimbolo ] := GetMv( cParam )
		aAux[ 1, _MdNome    ] := GetMv( "MV_MOEDA" + cValToChar( nMoeda ) )
		aAux[ 1, _MdTaxa    ] := If( nMoeda == 1, 1 , SM2->&( "M2_MOEDA" + cValToChar( nMoeda ) ) )
		Aadd( aRet,	aAux[1] )
	Endif
Next nX

RestArea( aArea )
Return( aRet )

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³AF125F3Cod ºAutor  ³Marcos R. Pires     º Data ³  31/07/10  º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ Executa a consulta padrao para preenchimento do codigo baseº±±
±±           ³ e item                                                     º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ SigaAtf                                                    º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
Function AF125F3Cod( __cBase, __cItem, oObjCod )

Local aArea := GetArea()
Local lRet  := .F.

lRet := Conpad1( , , , "SN1" )

If lRet
	__cBase := SN1->N1_CBASE
	__cItem := SN1->N1_ITEM
	oObjCod:Refresh()
EndIf

RestArea(aArea)

Return

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³A125AtCpBx ºAutor  ³Microsiga          º Data ³  25/07/10   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ Função genérica para validação e preenchimento dos campos  º±±
±±º          ³ na solicitação de baixa.                                   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ SIGAATF                                                    º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
Static Function A125AtCpBx( cCampo, cCBASE, cITEM, cTipo, cDescBem, nN1_QTDE,;
nQTDBX, nPERCBX, cCondPg, cGeraNF, cCliente, cLoja,;
cTESNFS, cNota, cSerie, lInclui, cMotBx,nVLRBAIX, nRecSN1 )

//Variáveis para guardar situação atual nos Alias abertos
Local aArea    := {}
Local aAreaSN1 := {}
Local aAreaSN3 := {}
Local aAreaSNM := {}

Local cMoeda	 := ""
Local nMoeda	 := 0
Local nResidual  := 0
Local cN1TipoNeg := Alltrim( SuperGetMv( "MV_N1TPNEG", .F., "" ) ) // Tipos de N1_PATRIM que aceitam Valor originais negativos
Local cN3TipoNeg := Alltrim( SuperGetMv( "MV_N3TPNEG", .F., "" ) ) // Tipos de N3_TIPO que aceitam Valor originais negativos
Local cMotGeraNF := SuperGetMV( "MV_ATFMBNF", .F., "01/10" )		//Motivos de baixa que permitem gerar NF
Local lRet 		 := .T.
Local cMoedaAtf  := GetMV( "MV_ATFMOEDA" )

Default lInclui := .T.
Default nRecSN1 := 0

//Salva situação atual dos Alias usados na rotina
aArea := GetArea()

If Select( "SN1") > 0
	aAreaSN1 := SN1->(GetArea())
EndIf

If Select( "SN3") > 0
	aAreaSN3 := SN3->(GetArea())
EndIf

If Select( "SNM") > 0
	aAreaSNM := SNM->(GetArea())
EndIf

//Valida apenas se for inclusão de baixa.
If lInclui
	
	Do Case
		
		//Código
		Case cCampo == STR0026
			If !Empty( cCBase )
				
				dbSelectArea( "SN1" )
				dbSetOrder(1)
				
				If SN1->( dbSeek( xFilial( "SN1" ) + cCBase + AllTrim( cItem ) ) )
					
					If SN1->N1_STATUS == "0"
						lRet := .F.
						Help(" ",1,"AF125CLAS",,STR0162,1,0)  // "Bem não classificado.Verifique!"
					Else
						If !Empty( cItem ) //Se o campo item já foi preenchido
							If SN1->(Simplelock())
								nRecSN1 := SN1->(Recno())							
								dbSelectArea( "SNM" )
								SNM->( dbSetOrder(2) )
								SNM->( dbSeek( xFilial( "SNM" ) + cCBase + cItem ) )
								
								If SNM->( !Found() ) .Or. SNM->NM_SITSOL != "1"  //Se não há solicitação ou solicitacao pendente
									
									dbSelectArea( "SN3" )
									SN3->( dbSetOrder(1) )
									SN3->( dbSeek( xFilial( "SN3" ) + cCBase + cItem ) )
									
									If SN3->N3_BAIXA == "0" .And. Empty( SN3->N3_DTBAIXA )
										cItem    := SN1->N1_ITEM
										cTipo    := SN3->N3_TIPO
										cDescBem := SN1->N1_DESCRIC
										nN1_QTDE := SN1->N1_QUANTD
									Else
										lRet := .F. 
										Help(" ",1,"AF125BX",,STR0070,1,0)//"Ativo baixado."
									EndIf
								Else
									
									Help(" ",1,"AF125SOL",,STR0071,1,0)//"Ativo com solicitação pendente."
								EndIf         
								
								If SN1->N1_STATUS $ "2|3" 
									lRet := .F.
									Help(" ",1,"AF125STA",,STR0131,1,0)//"Este bem não pode ser selecionado, pois está bloqueado!"
								EndIf
							Else
								lRet := .F.
								Help(" ",1,"AF125STA",,STR0131,1,0)//"Este bem não pode ser selecionado, pois está bloqueado!"
							EndIf
						EndIf
					EndIf
				Else
					lRet := .F.
					Help(" ",1,"AF125IT",,STR0072,1,0)//"Código não cadastrado"
				EndIf
			EndIf
			
			//Item
		Case cCampo == STR0027
			If !Empty( cCBase ) .And. !Empty( cItem )
				
				dbSelectArea( "SN1" )
				SN1->( dbSetOrder(1) )
				
				If SN1->( dbSeek( xFilial( "SN1" ) + cCBase + cItem ) )
					If SN1->(Simplelock())
						nRecSN1 := SN1->(Recno())
	
						If SN1->N1_STATUS == "0"
							lRet := .F.
							Help(" ",1,"AF125CLAS",,STR0162,1,0)  //"Bem não classificado.Verifique!"
						Else
						
							dbSelectArea( "SNM" )
							SNM->( dbSetOrder(2) )
							SNM->( dbSeek( xFilial( "SNM" ) + cCBase + cItem ) )
							
							If SNM->( !Found() ) .Or. SNM->NM_SITSOL != "1"
								
								dbSelectArea( "SN3" )
								SN3->( dbSetOrder(1) )
								SN3->( dbSeek( xFilial( "SN3" ) + cCBase + cItem ) )
								
								If SN3->N3_BAIXA == "0" .And. Empty( SN3->N3_DTBAIXA )
									cTipo    := SN3->N3_TIPO
									cDescBem := SN1->N1_DESCRIC
									nN1_QTDE := SN1->N1_QUANTD
								Else
									lRet := .F.
									Help(" ",1,"AF125BX",,STR0070,1,0)//"Ativo baixado."
								EndIf
							Else
								lRet := .F.
								Help(" ",1,"AF125SOL",,STR0071,1,0)//"Ativo com solicitação pendente."
							EndIf
							If SN1->N1_STATUS $ "2|3"
								lRet := .F.
								Help(" ",1,"AF125STA",,STR0131,1,0)//"Este bem não pode ser selecionado, pois está bloqueado!"
							EndIf
						EndIf
					Else
						lRet := .F.
						Help(" ",1,"AF125STA",,STR0131,1,0)//"Este bem não pode ser selecionado, pois está bloqueado!"
					EndIf
				Else
					lRet := .F.
					Help(" ",1,"AF125IT",,STR0072,1,0)//"Código não cadastrado"
				EndIf
			EndIf
			
			//Qtde Baixada
		Case cCampo == STR0032
			
			If nQTDBX > nN1_QTDE .Or. nQTDBX < 0
				lRet := .F.
				Help(" ",1,"AF125QT",,STR0073,1,0)//"Quantidade inválida."
			Else
				nPERCBX := (nQTDBX / nN1_QTDE) * 100
				If !Empty(nQTDBX) .And. !Empty(cCBase)
					
					dbSelectArea( "SN3" )
					SN3->( dbSetOrder(1) )
					SN3->( dbSeek( xFilial("SN3") + cCbase + cItem ) )
					
					//Valor atualizado
					oGetValores:aCols[1][2] := IIf( SN1->N1_PATRIM # "C", SN3->N3_VORIG1 + SN3->N3_VRCACM1 + SN3->N3_AMPLIA1, SN3->N3_VORIG1 + SN3->N3_AMPLIA1 )
					For nMoeda := 1 To Len(oGetValores:aCols)
						cMoeda := Alltrim( Str( nMoeda ) )
						oGetValores:aCols[nMoeda][2] := SN3->&("N3_VORIG"+cMoeda) + SN3->&("N3_AMPLIA"+cMoeda)
					Next nX
					
					
					For nMoeda := 1 To Len(oGetValores:aCols)
						cMoeda := Alltrim( Str( nMoeda ) )
						
						If cMoeda == "1"
							nResidual := SN3->N3_VRDACM1 + SN3->N3_VRCDA1
							If SN3->N3_TIPO = "05" .Or. ( SN1->N1_PATRIM $ cN1TipoNeg ) .Or. ( SN3->N3_TIPO $ cN3TipoNeg )
								nResidual := SN3->N3_VORIG1 + SN3->N3_AMPLIA1 + SN3->N3_VRCACM1 + Abs( nResidual )
							Else
								nResidual := Abs( SN3->N3_VORIG1 + SN3->N3_AMPLIA1 + SN3->N3_VRCACM1 - nResidual )
							Endif
						Else
							nResidual := &( If( nMoeda > 9, 'SN3->N3_VRDAC', 'SN3->N3_VRDACM' ) + cMoeda )
							If SN3->N3_TIPO = "05" .Or. ( SN1->N1_PATRIM $ cN1TipoNeg ) .Or. ( SN3->N3_TIPO $ cN3TipoNeg )
								nResidual := &( 'SN3->N3_VORIG' + cMoeda ) + &( If( Val( cMoedaAtf ) > 9, 'SN3->N3_AMPLI', 'SN3->N3_AMPLIA' ) + cMoedaAtf ) + Abs( nResidual )
							Else
								nResidual := Abs( &( 'SN3->N3_VORIG' + cMoeda ) + &( If( Val( cMoedaAtf ) > 9, 'SN3->N3_AMPLI', 'SN3->N3_AMPLIA') + cMoedaAtf ) - nResidual )
							Endif
						End
						If nMoeda == 1
							nVLRBAIX := (nPERCBX/100) * nResidual
						EndIf
						oGetValores:aCols[nMoeda][3] := nResidual
						oGetValores:aCols[nMoeda][4] := (nPERCBX/100) * nResidual
					Next
					oGetValores:Refresh()
				EndIf
			EndIf
			
			//Gera NFS
		Case cCampo == STR0039
			If  cGERANF == "2"
				cCLIENTE	:= CRIAVAR( "NM_CLIENTE" )
				cLoja		:= ""
				cTESNFS		:= CRIAVAR( "NM_TESNFS" )
				cSerie		:= CRIAVAR( "NM_SERIE" )
			Else
				If cMotBx $ cMotGeraNF
					dbSelectArea( "SN1" )
					SN1->(dbGoTop())
					SN1->(dbSeek( xFilial( "SN1" ) + cCBase + cItem ) )
					
					If SN1->( FieldPos( "N1_PRODUTO" ) ) > 0
						dbSelectArea( "SB1" )
						SB1->(dbGoTop())
						If !SB1->(dbSeek( xFilial( "SB1" ) + SN1->N1_PRODUTO ) )
							lRet := .F.
							Help(" ",1,"AF125PROD",,STR0136,1,0)	//"Não existe produto relacioanado a esse bem para gerar documento fiscal."
						EndIf
					Else
						lRet    := .F. 
						Help(" ",1,"AF125DIC",,STR0137,1,0)	//"Dicionário desatualizado, não será possível gerar documento fiscal, verifique campo SNM_PRODUTO."
					EndIf
				Else
					lRet := .F.
					Help(" ",1,"AF125PAR",,STR0138,1,0)	//"Motivo de baixa não permite geração de Nota Fiscal ou não configurado, verique parâmetro MV_ATFMBNF"
				EndIf
			EndIf
			
			//Cliente
		Case cCampo == STR0042
			If !Empty(cCliente)
				cLoja := SA1->A1_LOJA
				dbSelectArea( "SA1" )
				SA1->( dbSetOrder(1) )
				If SA1->( !dbSeek( xFilial("SA1") + cCliente + cLoja ) )
					lRet := .F.
					Help(" ",1,"AF125CLI",,STR0072,1,0)//"Código não cadastrado"
				EndIf
				
				If lRet .And. !Empty(SA1->A1_RISCO) .And.  Alltrim(SA1->A1_RISCO) != "A" 
		   			Help(" ",1,"AF125RIS",,STR0149,1,0)//"Cliente cadastrado deve possuir Risco A para efetuar a transferencia."
					lRet   :=.F.
				EndIf

				If lRet .And. Empty(SA1->A1_NATUREZ) .And. SF4->F4_DUPLIC == "S"
		   			Help(" ",1,"AF125NAT",,STR0153,1,0)//"Cliente deve ter natureza cadastrada!"
					lRet   :=.F.
				EndIf				
				
			EndIf
			
			//Num. NF
		Case cCampo == STR0045
			If !Empty( cNota )
				dbSelectArea( "SF2" )
				SF2->( dbSetOrder(1) )
				If SF2->( dbSeek( xFilial("SF2") + cNota ) )
					cCliente := SF2->F2_CLIENTE
					cLoja    := SF2->F2_LOJA
					cSerie   := SF2->F2_SERIE
					cTESNFS  := CRIAVAR( "NM_TESNFS" )
				Else
					lRet     := .F. 
					Help(" ",1,"AF125NOT",,STR0072,1,0)//"Código não cadastrado"
				EndIf
			EndIf
			
			//TES
		Case cCampo == "TES"
			If cGeraNF == "1"
				If !Empty( cTESNFS )
					dbSelectArea( "SF4" )
					SF4->(dbSetOrder(1))
					If SF4->(dbSeek( xFilial( "SF4" ) + cTESNFS ) )
						If SF4->F4_TIPO == "E"
							lRet := .F.
							Help(" ",1,"AF125TESS",,STR0139,1,0)	//"A TES utilizada deve ser de saída!"  
						ElseIf SF4->F4_ATUATF == "S" .Or. SF4->F4_ESTOQUE == "S"
							lRet := .F.
							Help(" ",1,"AF125TESDUP",,STR0140,1,0)//"A TES utilizada não pode gerar duplicata, atualizar estoque ou atualizar ativo fixo!"
						EndIf
					Else
						lRet := .F.
						Help(" ",1,"AF125TESENC",,STR0141,1,0)	//"TES não encontrada!"
					EndIf
				EndIf
			EndIf
	EndCase
EndIf

If Len( aAreaSN1 ) > 0
	RestArea(aAreaSN1)
EndIf

If Len( aAreaSN3 ) > 0
	RestArea(aAreaSN3)
EndIf

If Len( aAreaSNM ) > 0
	RestArea(aAreaSNM)
EndIf

RestArea( aArea )

Return lRet

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡…o    ³AF125TOkBx ³ Autor ³ Marcos R. Pires      ³ Data ³ 26/07/10 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³Validar o botao Ok na inclusao da solic de baixa            ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³ SIGAATF                                                    ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
Static Function AF125TOkBx( nOpc, cCBASE, cItem, cItem, nQtdBx, cMotbx,;
cCondPg, nVlVenda, cGeraNF, cCliente, cLoja,;
cSerie, cTESNFS, cHistSol )

Local lRet  := .T.
Local aArea := GetArea()

If INCLUI
	
	//Verifica o preenchimento de campos obrigatórios.
	If Empty(cCBase) .And. lRet
		lRet := .F.
		Help(" ",1,"AF125OBG",,STR0074 + " - '" + STR0026 + "'",1,0)	//"Campo obrigatório não informado" | "Código"
	EndIf
	
	If Empty(cItem) .And. lRet
		lRet := .F. 
		Help(" ",1,"AF125OBG",,STR0074 + " - '" + STR0027 + "'",1,0)	//"Campo obrigatório não informado" | "Item"
	EndIf
	
	If nQtdBx == 0 .And. lRet
		lRet := .F. 
		Help(" ",1,"AF125OBG",,STR0074 + " - '" + STR0032 + "'",1,0)	//"Campo obrigatório não informado" | "Qtde Baixada"
	EndIf
	
	If ( cMotBx == "01" .And. Empty( nVlvenda ) ) .And. lRet
		lRet := .F.
		Help(" ",1,"AF125OBG",,STR0074 + " - '" + STR0037 + "'",1,0)	//"Campo obrigatório não informado" | "Vlr. Venda"
	EndIf
	
	If ( cGeraNF == "1" .And. Empty( cCondPg ) ) .And. lRet
		lRet := .F. 
		Help(" ",1,"AF125OBG",,STR0074 + " - '" + STR0035 + "'",1,0)	//"Campo obrigatório não informado" | "Cond. Pgto"
	EndIf
	
	If ( cGeraNF == "1" .And. Empty( cCliente ) ) .And. lRet
		lRet := .F.   
		Help(" ",1,"AF125OBG",,STR0074 + " - '" + STR0042 + "'",1,0)	//"Campo obrigatório não informado" | "Cliente"
	EndIf
	
	If ( cGeraNF == "1" .And. Empty(cTesNFS) ) .And. lRet
		lRet := .F. 
		Help(" ",1,"AF125OBG",,STR0074 + " - '" + STR0044 + "'",1,0)	//"Campo obrigatório não informado" | "TES Saida"
	EndIf
	
	If ( cGeraNF == "1" .And. Empty(cSerie) ) .And. lRet
		lRet := .F.  
		Help(" ",1,"AF125OBG",,STR0074 + " - '" + STR0046 + "'",1,0)	//"Campo obrigatório não informado" | "Serie"
	EndIf
	
	If Empty( cHistSol ) .And. lRet
		lRet := .F.         
		Help(" ",1,"AF125OBG",,STR0074 + " - '" + STR0050 + "'",1,0)	//"Campo obrigatório não informado" |  "Hist. Solic."
	EndIf
	
	If lRet
		//Verifica se WorkFlow está ativado.
		If SuperGetMV( "MV_ATFWFM", , .F. )
			lRet := A125VlRspWF( cCBase, cItem )	//Valida e-mail responsável
		EndIf
	EndIf
	
EndIf

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ\¿
//³ PE para validação da inclusão e exclusão da solicitação de baixa 				³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ\Ù
If ExistBlock( "AF125OKB" ) .And. nOpc > 2 .And. lRet
	lRet := ExecBlock( "AF125OKB", .F., .F., { nOpc, cCBASE, cItem, nQtdBx, cMotbx,;
	cCondPg, nVlVenda, cGeraNF, cCliente,;
	cLoja, cSerie, cTESNFS } )
EndIf

RestArea( aArea )

Return lRet

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡…o    ³AF125PrcBx³ Autor ³ Marcos R. Pires       ³ Data ³ 26/07/10 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³ Processa a inclusao, exclusao e visualizacao das solicita- ³±±
±±³          ³ coes de baixa                                              ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³ SIGAATF                                                    ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
Static Function AF125PrcBx( nOpc, cCBase, cItem, cTipo, nQTDbx, nPercBX,;
cMotbx, cCondPg, nVlrBaix, nVlVenda, cGeraNF,;
cCliente, cLoja, cNota, cSerie, cTESNFS, dDatSol,;
dHorsol, cUsrSol, cHistSol )

Local cCodSol := Nil

If INCLUI //Inclusão da solicitação de baixa
	
	Begin Transaction
	cCodSol := GetSxENum( "SNM", "NM_CODIGO" )
	ConfirmSX8()
	
	MsgRun( STR0065,;	//"Gerando a solicitação, aguarde..."
	STR0023,;	//"Solicitação de Baixa"
	{ || GravaBx( cCBase, cItem, cTipo, nQTDbx, nPercBX,;
	cMotbx, cCondPg, nVlrBaix, nVlVenda, cGeraNF,;
	cCliente, cLoja, cNota, cSerie, cTESNFS,;
	dDatSol, dHorsol, cUsrSol, cHistSol, cCodSol ) } )
	
	//Chamada do WorkFlow
	If SuperGetMV( "MV_ATFWFM", , .F. )
		If !A125WfBx( cCodSol )
			DisarmTransaction()
		EndIf
	EndIf
	
	End Transaction
	
	
	
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Ponto de entrada executado após a gravação da solicitação		³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	If ExistBlock( "AF125GRB" )
		ExecBlock( "AF125GRB" , .F., .F. )
	EndIf
	
ElseIf nOpc == 7 //Exclusão da solicitação de baixa
	
	If  MsgNoYes( STR0067, STR0021 )	//"Deseja realmente excluir esta solicitação?" | "Atencão"
		cCodSol := SNM->NM_CODIGO
		SNM->( dbSetOrder(1) )
		SNM->( dbSeek( xFilial( "SNM" ) + cCodSol ) )
		While SNM->( !EOF() ) .And. xFilial( "SNM" ) == SNM->NM_FILIAL .And. cCodSol == SNM->NM_CODIGO
			RecLock( "SNM", .F. )
			SNM->( dbDelete() )
			SNM->( MsUnlock() )
			SNM->( dbSkip() )
		End
	EndIf
	
ElseIf nOpc == 2
	oDlg:End()
EndIf

Return cCodSol

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡…o    ³GravaBx³    Autor ³ Marcos R. Pires       ³ Data ³ 26/07/10 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³ Grava a baixa.                                             ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³ SIGAATF                                                    ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
Static Function GravaBx( cCBase, cItem, cTipo, nQTDbx, nPercBX, cMotbx,;
cCondPg, nVlrBaix, nVlVenda, cGeraNF, cCliente,;
cLoja, cNota, cSerie, cTESNFS, dDatSol, dHorsol,;
cUsrSol, cHistSol, cCodSol )

RecLock( "SNM", .T. )
SNM->NM_FILIAL	:= xFilial( "SNM" )
SNM->NM_CODIGO	:= cCodSol
SNM->NM_DATSOL	:= dDatSol
SNM->NM_HORSOL	:= StrTran( Left( dHorsol, 5), ":", "" )
SNM->NM_CBASE	:= cCBase
SNM->NM_ITEM	:= cITEM
SNM->NM_TIPO	:= cTIPO
SNM->NM_SITSOL	:= "1" 		//Pendente
SNM->NM_USRSOL	:= cUSRSOL
SNM->NM_TIPOSOL	:= "1" 		//Baixa
SNM->NM_MOTBX	:= SubStr( cMOTBX, 1, 2 )
SNM->NM_QTDBX	:= nQTDBX
SNM->NM_PERCBX	:= nPERCBX
SNM->NM_VLRBAIX	:= nVLRBAIX
SNM->NM_VLVENDA	:= nVLVENDA
SNM->NM_GERANF	:= SubStr( cGERANF, 1, 1 )
SNM->NM_NOTA	:= cNOTA
SNM->NM_SERIE	:= cSERIE
SNM->NM_TESNFS	:= cTESNFS
SNM->NM_CONDPG	:= cCONDPG
SNM->NM_CLIENTE	:= cCLIENTE
SNM->NM_LOJA	:= cLOJA
SNM->NM_CCUSTO	:= SN3->N3_CCUSTO
SNM->NM_LOCAL	:= SN1->N1_LOCAL
SNM->NM_GRUPO	:= SN1->N1_GRUPO
MSMM( SNM->NM_CDHSOL, , ,cHistSol, 1, , , "SNM", "NM_CDHSOL" )
SNM->( MsUnlock() )

Return Nil

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³AF125SolTr ºAutor  ³Marcos R. Pires    º Data ³  25/07/10   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ Rotina de solicitação de transferência                     º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ SIGAATF                                                    º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
Function AF125SolTr( cAlias, nReg, nOpc )

Static oDlg

Local oButton1, oButton2
Local oGroup1, oGroup2, oGroup3, oGroup4, oGroup5
Local oFolder1, oFolder2

//Folder1
//Dados do Bem
Local oCBase,oItem,oTipo,oDescBem
Local cCBase		:= CRIAVAR( "NM_CBASE" )
Local cItem			:= CRIAVAR( "NM_ITEM" )
Local cTipo			:= ""
Local cDescBem		:= ""
//Informacoes Complementares
Local oN1_Qtde, oFilDest, oGrupo, oCCusto, oCustAtu, oValResid, oLocal, oCCustoDst, oLocalDst
Local cN1_Qtde		:= ""
Local cFilDest		:= ""
Local cGrupo		:= ""
Local cCCusto		:= ""
Local nCustAtu		:= 0
Local nValResid		:= 0
Local cLocal		:= ""
Local cCCustoDst	:= ""
Local cLocalDst		:= ""
//SubFolder1 - Conta Contabil
Local oCContab, oCContabDst, oCCorrec, oCCorrecDst, oCDeprec, oCDeprecDst, oCDDepr, oCDDeprDst, oCDesp, oCDespDst
Local cCContab		:= ""
Local cDsCContab	:= ""
Local cCCorrec		:= ""
Local cDsCCorrec	:= ""
Local cCDeprec		:= ""
Local cDsCDeprec	:= ""
Local cCDDepr		:= ""
Local cDsCDDepr		:= ""
Local cCDesp		:= ""
Local cDsCDesp		:= ""
//SubFolder2 - Centro Custo
Local oCustBem, oCustBemDst, oCCCorr, oCCCorrDst, oCCDesp, oCCDespDst, oCCCDep, oCCCDepDst, oCCCDES, oCCCDESDst
Local cCustBem		:= ""
Local cDsCustBem	:= ""
Local cCCCorr		:= ""
Local cDsCCCORR		:= ""
Local cCCDesp		:= ""
Local cDsCCDesp		:= ""
Local cCCCDep		:= ""
Local cDsCCCDep		:= ""
Local cCCCDES		:= ""
Local cDsCCCDES		:= ""
//SubFolder3 - Item Contab.
Local oItBem, oItBemDst, oItCorr, oItCorrDst, oItDesp, oItDespDst, oItCDep, oItCDepDst, oItCDes, oItCDesDst
Local cItBem		:= ""
Local cDsItBem		:= ""
Local cItCorr		:= ""
Local cDsItCorr		:= ""
Local cItDesp		:= ""
Local cDsItDesp		:= ""
Local cItCDep		:= ""
Local cDsItCDep		:= ""
Local cItCDes		:= ""
Local cDsItCDes		:= ""
//SubFolder4 - Classe Valor
Local oClVlBem, oClVlBemDst, oClVlCor, oClVlCorDst, oClVlDep, oClVlDepDst, oClVlCDe, oClVlCDeDst, oClVlDes, oClVlDesDst
Local cClVlBem		:= ""
Local cDsClVlBem	:= ""
Local cClVlCor		:= ""
Local cDsClVlCor	:= ""
Local cClVlDep		:= ""
Local cDsClVlDep	:= ""
Local cClVlCDe		:= ""
Local cDsClVlCDe	:= ""
Local cClVlDes		:= ""
Local cDsClVlDes	:= ""
//Dados da Nota Fiscal
Local oGeraNF, oClasNFE, oTESNFS, oTESNFE, oNota, oSerie, oCONDPG
Local cGeraNF		:= ""
Local cClasNFE		:= ""
Local cTESNFS		:= ""
Local cTESNFE		:= ""
Local cNota			:= ""
Local cSerie		:= ""
Local cCONDPG		:= ""

Local aEntDst		:= {} // Array das entidades destino
Local aEntAux		:= {}

//FOLDER 2
//Dados da Solicitacao
Local oDatSol, oHorSol, oUsrSol, oNmUsSol, oHistSol
Local dDatSol		:= ""
Local dHorSol		:= ""
Local cUsrSol		:= ""
Local cNmUsSol		:= ""
Local cHistSol		:= ""
//Dados da Aprov/Rejeic
Local oDtApvRe, oHrApvRe, oUsrApv, oNmUsApv, oHistRej
Local cDtApvRe		:= ""
Local cHrApvRe		:= ""
Local cUsrApv		:= ""
Local cNmUsApv		:= ""
Local cHistRej		:= ""
//Fim das variaveis de campos

Local nX			:= 0
Local cFilOri		:= cFilAnt
Local cFilDstOld	:= cFilAnt

Local cPatrim		:= ""
Local nValor		:= 0
Local nQtdeSn		:= 0
Local nQtdOrig		:= 0
Local nQuant		:= 0
Local cN1TipoNeg	:= Alltrim( SuperGetMv( "MV_N1TPNEG", .F., "" ) ) // Tipos de N1_PATRIM que aceitam Valor originais negativos
Local cN3TipoNeg	:= Alltrim( SuperGetMv( "MV_N3TPNEG", .F., "" ) ) // Tipos de N3_TIPO que aceitam Valor originais negativos

Local lCCusto	:= CtbMovSaldo( "CTT" )
Local lItemCont	:= CtbMovSaldo( "CTD" )
Local lClValor	:= CtbMovSaldo( "CTH" )


Local aTitFolder := { STR0075 }		//"Conta contabil"

Local lLibCpo := .T. // Variavel para permitir apenas a troca de locais.
Private nAt:=1                                 
Private lTrava:=.F.

aAdd( aTitFolder, CtbSayApro( "CTT" ) )
aAdd( aTitFolder, CtbSayApro( "CTD" ) )
aAdd( aTitFolder, CtbSayApro( "CTH" ) )

If INCLUI //Inclusao
	//Folder1
	//Dados do Bem
	cCBASE		:= CriaVar( "NM_CBASE" )
	//Informacoes Complementares
	cN1_Qtde	:= CriaVar( "N1_QUANTD" )
	cFilDest	:= cFilAnt
	cGRUPO		:= CriaVar( "NM_GRUPO" )
	cCCustoDst	:= CriaVar( "NM_CCUSTO" )
	cLOCALDst	:= CriaVar( "NM_LOCAL" )
	//SubFolder1 - Conta Contabil
	aEntAux := {}
	aAdd(aEntAux,{"NM_CCONTAB",CriaVar( "NM_CCONTAB" ),"NG_CCONTAB"})
	aAdd(aEntAux,{"NM_CCORREC",CriaVar( "NM_CCORREC" ),"NG_CCORREC"})
	aAdd(aEntAux,{"NM_CDEPREC",CriaVar( "NM_CDEPREC" ),"NG_CDEPREC"})
	aAdd(aEntAux,{"NM_CDDEPR",CriaVar( "NM_CDDEPR" ),"NG_CCDEPR"})
	aAdd(aEntAux,{"NM_CDESP",CriaVar( "NM_CDESP" ),"NG_CDESP"})
	aAdd(aEntDst,aEntAux)
	//SubFolder2 - Centro Custo
	aEntAux := {}
	aAdd(aEntAux,{"NM_CUSTBEM",CriaVar( "NM_CUSTBEM" ),"NG_CUSTBEM"})
	aAdd(aEntAux,{"NM_CCCORR",CriaVar( "NM_CCCORR" ),"NG_CCCORR"})
	aAdd(aEntAux,{"NM_CCDESP",CriaVar( "NM_CCDESP" ),"NG_CCDESP"})
	aAdd(aEntAux,{"NM_CCCDEP",CriaVar( "NM_CCCDEP" ),"NG_CCCDEP"})
	aAdd(aEntAux,{"NM_CCCDES",CriaVar( "NM_CCCDES" ),"NG_CCCDES"})
	aAdd(aEntDst,aEntAux)
	//SubFolder3 - Item Contab.
	aEntAux := {}
	aAdd(aEntAux,{"NM_ITBEM",CriaVar( "NM_ITBEM" ),"NG_SUBCCON"})
	aAdd(aEntAux,{"NM_ITCORR",CriaVar( "NM_ITCORR" ),"NG_SUBCCOR"})
	aAdd(aEntAux,{"NM_ITDESP",CriaVar( "NM_ITDESP" ),"NG_SUBCDEP"})
	aAdd(aEntAux,{"NM_ITCDEP",CriaVar( "NM_ITCDEP" ),"NG_SUBCCDE"})
	aAdd(aEntAux,{"NM_ITCDES",CriaVar( "NM_ITCDES" ),"NG_SUBCDES"})
	aAdd(aEntDst,aEntAux)
	//SubFolder4 - Classe Valor
	aEntAux := {}
	aAdd(aEntAux,{"NM_CLVLBEM",CriaVar( "NM_CLVLBEM" ),"NG_CLVLCON"})
	aAdd(aEntAux,{"NM_CLVLCOR",CriaVar( "NM_CLVLCOR" ),"NG_CLVLCOR"})
	aAdd(aEntAux,{"NM_CLVLDEP",CriaVar( "NM_CLVLDEP" ),"NG_CLVLDEP"})
	aAdd(aEntAux,{"NM_CLVLCDE",CriaVar( "NM_CLVLCDE" ),"NG_CLVLCDE"})
	aAdd(aEntAux,{"NM_CLVLDES",CriaVar( "NM_CLVLDES" ),"NG_CLVLDES"})
	aAdd(aEntDst,aEntAux)
	
	//Dados da Nota Fiscal
	cGeraNF		:= "1"
	cClasNFE	:= ""
	cTESNFS		:= CriaVar( "NM_TESNFS" )
	cTESNFE		:= CriaVar( "NM_TESNFE" )
	cNota		:= CriaVar( "NM_NOTA" )
	cSerie		:= CriaVar( "NM_SERIE" )
	cCONDPG		:= Criavar( "NM_CONDPG" )
	
	//FOLDER 2
	//Dados da Solicitacao
	dDatSol		:= dDataBase
	dHorSol		:= Left(TIME(),5)
	cUsrSol		:= __cUserID
	cNmUsSol	:= cUserName
	
Else //Visualizacao ou Exclusao
	
	//Folder1
	//Dados do Bem
	cCBASE		:= SNM->NM_CBASE
	cITEM		:= SNM->NM_ITEM
	cTIPO		:= SNM->NM_TIPO
	//Informacoes Complementares
	cFilDest	:= SNM->NM_FILDEST
	cGRUPO		:= SNM->NM_GRUPO
	cCCustoDst	:= SNM->NM_CCUSTO
	cLOCALDst	:= SNM->NM_LOCAL
	
	//SubFolder1 - Conta Contabil
	aEntAux := {}
	aAdd(aEntAux,{"NM_CCONTAB",SNM->NM_CCONTAB 	,"NG_CCONTAB"})
	aAdd(aEntAux,{"NM_CCORREC",SNM->NM_CCORREC 	,"NG_CCORREC"})
	aAdd(aEntAux,{"NM_CDEPREC",SNM->NM_CDEPREC 	,"NG_CDEPREC"})
	aAdd(aEntAux,{"NM_CDDEPR",SNM->NM_CDDEPR 	,"NG_CCDEPR"})
	aAdd(aEntAux,{"NM_CDESP",SNM->NM_CDESP 		,"NG_CDESP"	})
	aAdd(aEntDst,aEntAux)
	//SubFolder2 - Centro Custo
	aEntAux := {}
	aAdd(aEntAux,{"NM_CUSTBEM",SNM->NM_CUSTBEM 		,"NG_CUSTBEM"})
	aAdd(aEntAux,{"NM_CCCORR",SNM->NM_CCCORR 		,"NG_CCCORR"})
	aAdd(aEntAux,{"NM_CCDESP",SNM->NM_CCDESP 		,"NG_CCDESP"})
	aAdd(aEntAux,{"NM_CCCDEP",SNM->NM_CCCDEP 		,"NG_CCCDEP"})
	aAdd(aEntAux,{"NM_CCCDES",SNM->NM_CCCDES 		,"NG_CCCDES"})
	aAdd(aEntDst,aEntAux)
	//SubFolder3 - Item Contab.
	aEntAux := {}
	aAdd(aEntAux,{"NM_ITBEM",SNM->NM_ITBEM 	   		,"NG_SUBCCON"})
	aAdd(aEntAux,{"NM_ITCORR",SNM->NM_ITCORR 		,"NG_SUBCCOR"})
	aAdd(aEntAux,{"NM_ITDESP",SNM->NM_ITDESP 		,"NG_SUBCDEP"})
	aAdd(aEntAux,{"NM_ITCDEP",SNM->NM_ITCDEP	 	,"NG_SUBCCDE"})
	aAdd(aEntAux,{"NM_ITCDES",SNM->NM_ITCDES 		,"NG_SUBCDES"})
	aAdd(aEntDst,aEntAux)
	//SubFolder4 - Classe Valor
	aEntAux := {}
	aAdd(aEntAux,{"NM_CLVLBEM",SNM->NM_CLVLBEM 	,"NG_CLVLCON"})
	aAdd(aEntAux,{"NM_CLVLCOR",SNM->NM_CLVLCOR 	,"NG_CLVLCOR"})
	aAdd(aEntAux,{"NM_CLVLDEP",SNM->NM_CLVLDEP 	,"NG_CLVLDEP"})
	aAdd(aEntAux,{"NM_CLVLCDE",SNM->NM_CLVLCDE 	,"NG_CLVLCDE"})
	aAdd(aEntAux,{"NM_CLVLDES",SNM->NM_CLVLDES	,"NG_CLVLDES"})
	aAdd(aEntDst,aEntAux)
	
	//Dados da Nota Fiscal
	cGeraNF		:= SNM->NM_GERANF
	cClasNFE	:= SNM->NM_CLASNFE
	cTESNFS		:= SNM->NM_TESNFS
	cTESNFE		:= SNM->NM_TESNFE
	cNota		:= SNM->NM_NOTA
	cSerie		:= SNM->NM_SERIE
	cCONDPG		:= SNM->NM_CONDPG
	//FOLDER 2
	//Dados da Solicitacao
	dDatSol		:= SNM->NM_DATSOL
	dHorSol		:= SNM->NM_HORSOL
	cUsrSol		:= SNM->NM_USRSOL
	cNmUsSol	:= USRFULLNAME( SNM->NM_USRSOL )
	cHistSol	:= MSMM( SNM->NM_CDHSOL, 80 )
	//Dados da Aprov/Rejeic
	cDtApvRe	:= SNM->NM_DTAPVRE
	cHrApvRe	:= SNM->NM_HRAPVRE
	cUsrApv		:= SNM->NM_USRAPV
	cNmUsApv	:= USRFULLNAME( SNM->NM_USRAPV )
	cHistRej	:= MSMM( SNM->NM_CDHREJ, 80 )
	
	//SubFolder1 - Conta Contabil Descricao
	cDsCContab := Posicione( "CT1", 1, xFilial( "CT1" ) + aEntDst[1][1][2] , "CT1_DESC01" )
	cDsCCorrec := Posicione( "CT1", 1, xFilial( "CT1" ) + aEntDst[1][2][2] , "CT1_DESC01" )
	cDsCDeprec := Posicione( "CT1", 1, xFilial( "CT1" ) + aEntDst[1][3][2] , "CT1_DESC01" )
	cDsCDDepr  := Posicione( "CT1", 1, xFilial( "CT1" ) + aEntDst[1][4][2] , "CT1_DESC01" )
	cDsCDesp   := Posicione( "CT1", 1, xFilial( "CT1" ) + aEntDst[1][5][2] , "CT1_DESC01" )
	//SubFolder2 - Centro Custo Descricao
	If lCCusto
		cDsCustBem := Posicione( "CTT", 1, xFilial( "CTT" ) + aEntDst[2][1][2] , "CTT_DESC01" )
		cDsCCCORR  := Posicione( "CTT", 1, xFilial( "CTT" ) + aEntDst[2][2][2] , "CTT_DESC01" )
		cDsCCDesp  := Posicione( "CTT", 1, xFilial( "CTT" ) + aEntDst[2][3][2] , "CTT_DESC01" )
		cDsCCCDep  := Posicione( "CTT", 1, xFilial( "CTT" ) + aEntDst[2][4][2] , "CTT_DESC01" )
		cDsCCCDES  := Posicione( "CTT", 1, xFilial( "CTT" ) + aEntDst[2][5][2] , "CTT_DESC01" )
	EndIf
	//SubFolder3 - Item Contab. Descricao
	If lItemCont
		cDsItBem  := Posicione( "CTD", 1, xFilial( "CTD" ) + aEntDst[3][1][2] , "CTD_DESC01" )
		cDsItCorr := Posicione( "CTD", 1, xFilial( "CTD" ) + aEntDst[3][2][2] , "CTD_DESC01" )
		cDsItDesp := Posicione( "CTD", 1, xFilial( "CTD" ) + aEntDst[3][3][2] , "CTD_DESC01" )
		cDsItCDep := Posicione( "CTD", 1, xFilial( "CTD" ) + aEntDst[3][4][2] , "CTD_DESC01" )
		cDsItCDes := Posicione( "CTD", 1, xFilial( "CTD" ) + aEntDst[3][5][2] , "CTD_DESC01" )
	EndIf
	//SubFolder4 - Classe Valor Descricao
	If lClValor
		cDsClVlBem := Posicione( "CTH", 1, xFilial( "CTH" ) + aEntDst[4][1][2], "CTH_DESC01" )
		cDsClVlCor := Posicione( "CTH", 1, xFilial( "CTH" ) + aEntDst[4][2][2], "CTH_DESC01" )
		cDsClVlDep := Posicione( "CTH", 1, xFilial( "CTH" ) + aEntDst[4][3][2], "CTH_DESC01" )
		cDsClVlCDe := Posicione( "CTH", 1, xFilial( "CTH" ) + aEntDst[4][4][2], "CTH_DESC01" )
		cDsClVlDes := Posicione( "CTH", 1, xFilial( "CTH" ) + aEntDst[4][5][2], "CTH_DESC01" )
	EndIf
	
	dbSelectArea( "SN1" )
	SN1->( dbSetOrder(1) )
	If SN1->( dbSeek( xFilial( "SN1" ) + cCBase + cItem ) )
		cDESCBEM := SN1->N1_DESCRIC
		cN1_QTDE := SN1->N1_QUANTD
		cLOCAL	 := SN1->N1_LOCAL
	EndIf
	
	dbSelectArea( "SN3" )
	SN3->( dbSetOrder(1) )
	If SN3->( dbSeek( xFilial( "SN3" ) + cCBase + cItem ) )
		cCCusto		:= SN3->N3_CCUSTO
		//SubFolder1 - Conta Contabil - Origem
		cCContab	:= SN3->N3_CCONTAB
		cCCorrec	:= SN3->N3_CCORREC
		cCDeprec	:= SN3->N3_CDEPREC
		cCDDepr		:= SN3->N3_CCDEPR
		cCDesp		:= SN3->N3_CDESP
		//SubFolder2 - Centro Custo - Origem
		cCustBem	:= SN3->N3_CUSTBEM
		cCCCorr		:= SN3->N3_CCCORR
		cCCDesp		:= SN3->N3_CCDESP
		cCCCDep		:= SN3->N3_CCCDEP
		cCCCDES		:= SN3->N3_CCCDES
		//SubFolder3 - Item Contab - Origem
		cItBem		:= SN3->N3_SUBCCON
		cItCorr		:= SN3->N3_SUBCCOR
		cItDesp		:= SN3->N3_SUBCDEP
		cItCDep		:= SN3->N3_SUBCCDE
		cItCDes		:= SN3->N3_SUBCDES
		//SubFolder4 - Classe Valor - Origem
		cClVlBem	:= SN3->N3_CLVLCON
		cClVlCor	:= SN3->N3_CLVLCOR
		cClVlDep	:= SN3->N3_CLVLDEP
		cClVlCDe	:= SN3->N3_CLVLCDE
		cClVlDes	:= SN3->N3_CLVLDES
	EndIf
	
	
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³	 No caso de contas de Capital, nÆo vai a corre‡Æo monet ria.		³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	cPatrim  	:= SN1->N1_PATRIM
	nValor	 	:= IIf( cPatrim # "C" , SN3->N3_VORIG1 + SN3->N3_VRCACM1 + SN3->N3_AMPLIA1, SN3->N3_VORIG1 + SN3->N3_AMPLIA1 )
	
	nQtdeSn  	:= IIf( SN1->N1_QUANTD == 0, 1, SN1->N1_QUANTD )
	nQtdOrig 	:= nQtdeSn
	nQuant	 	:= nQtdeSn
	nCustAtu 	:= nValor
	If SN3->N3_TIPO = "05" .Or. ( SN1->N1_PATRIM $ cN1TipoNeg ) .Or. ( SN3->N3_TIPO $ cN3TipoNeg )
		nValResid:= nValor + Abs( ( SN3->N3_VRDACM1 + SN3->N3_VRCDA1 ) )
	Else
		nValResid:= nValor - ( SN3->N3_VRDACM1 + SN3->N3_VRCDA1 )
	Endif
	
EndIf

If INCLUI
DEFINE MSDIALOG oDlg TITLE STR0066 FROM 000, 000  TO 405, 766 PIXEL	//"Solicitação de Transferência"
ElseIf nOpc ==  2
DEFINE MSDIALOG oDlg TITLE STR0066 +" - "+ STR0002 FROM 000, 000  TO 405, 766 PIXEL	//"Visualizar"
ElseIf nOpc == 7
DEFINE MSDIALOG oDlg TITLE STR0066 +" - "+ STR0007 FROM 000, 000  TO 405, 766 PIXEL	//"Excluir" 
EndIf

@ 000, 000 FOLDER oFolder1 SIZE 383, 202 OF oDlg ITEMS STR0024, STR0025 PIXEL	//"Dados do Bem" | "Dados da Solicitação"

//FOLDER 1
// Dados do Bem
@ 000, 002 GROUP oGroup3 TO 023, 377 PROMPT STR0024  OF oFolder1:aDialogs[1] PIXEL	//"Dados do Bem"
@ 010, 017 SAY STR0026                 SIZE 019, 007 OF oFolder1:aDialogs[1] PIXEL COLOR CLR_HBLUE	//"Código"
@ 008, 038 MSGET oCBASE   VAR cCBASE   SIZE 043, 010 OF oFolder1:aDialogs[1] PIXEL VALID A125AtCpTr("Codigo",@cCBase,@cItem,@cTipo,@cDescBem,@cN1_QTDE,@cGrupo,@cLOCAL,@cCCusto,@cCContab,@cCCorrec,@cCDeprec,@cCDDepr,@cCDesp,@cCustBem,@cCCCorr,@cCCDesp,@cCCCDep,@cCCCDes,@cItBem,@cItCorr,@cItDesp,@cItCDep,@cItCDes,@cClVlBem,@cClVlCor,@cClVlDep,@cClVlCDe,@cClVlDes,@nCustAtu,@nValResid,@cGeraNF,@cClasNFE,@cTESNFS,@cTESNFE,@cNota,@cSerie,cFilDest,@lLibCpo) ON CHANGE cItem := CRIAVAR("NM_ITEM")
oCBASE:BF3 := { || AF125F3Cod( @cCBASE, @cItem, @oCBASE ) }
@ 010, 087 SAY STR0027                 SIZE 013, 007 OF oFolder1:aDialogs[1] PIXEL	//"Item"
@ 008, 102 MSGET oITEM    VAR cITEM    SIZE 022, 010 OF oFolder1:aDialogs[1] PIXEL VALID A125AtCpTr("Item",@cCBase,@cItem,@cTipo,@cDescBem,@cN1_QTDE,@cGrupo,@cLOCAL,@cCCusto,@cCContab,@cCCorrec,@cCDeprec,@cCDDepr,@cCDesp,@cCustBem,@cCCCorr,@cCCDesp,@cCCCDep,@cCCCDes,@cItBem,@cItCorr,@cItDesp,@cItCDep,@cItCDes,@cClVlBem,@cClVlCor,@cClVlDep,@cClVlCDe,@cClVlDes,@nCustAtu,@nValResid,@cGeraNF,@cClasNFE,@cTESNFS,@cTESNFE,@cNota,@cSerie,cFilDest,@lLibCpo)
@ 010, 135 SAY STR0028                 SIZE 013, 007 OF oFolder1:aDialogs[1] PIXEL	//"Tipo"
@ 008, 150 MSGET oTIPO    VAR cTIPO    SIZE 020, 010 OF oFolder1:aDialogs[1] PIXEL WHEN .F.
@ 010, 182 SAY STR0029                 SIZE 027, 007 OF oFolder1:aDialogs[1] PIXEL	//"Descrição"
@ 008, 211 MSGET oDESCBEM VAR cDESCBEM SIZE 149, 010 OF oFolder1:aDialogs[1] PIXEL WHEN .F.

//Informacoes Complementares
@ 023, 002 GROUP oGroup4 TO 151, 376 PROMPT STR0030      OF oFolder1:aDialogs[1] PIXEL	//"Informações Complementares"
@ 033, 007 SAY STR0031                	   SIZE 027, 007 OF oFolder1:aDialogs[1] PIXEL	//"Qtde Atual"
@ 031, 035 MSGET oN1_QTDE   VAR cN1_QTDE   SIZE 052, 010 OF oFolder1:aDialogs[1] PIXEL WHEN .F. PICTURE X3Picture("N1_QUANTD")
@ 033, 092 SAY STR0076                     SIZE 026, 007 OF oFolder1:aDialogs[1] PIXEL	//"Filial Dest."
@ 031, 120 MSGET oFILDEST   VAR cFilDest   SIZE 020, 010 OF oFolder1:aDialogs[1] PIXEL F3 "SM0_01" WHEN lLibCpo VALID ExistCpo("SM0",cEmpAnt+cFilDest) .And.  A125TrFlDst(cFilDest,@aEntDst,@cFilDstOld,@cCCustoDst,@cLOCALDst,@cDsCContab,@cDsCCorrec,@cDsCDeprec,@cDsCDDepr,@cDsCDesp,@cDsCustBem,@cDsCCCORR,@cDsCCDesp,@cDsCCCDep,@cDsCCCDES,@cDsItBem,@cDsItCorr,@cDsItDesp,@cDsItCDep,@cDsItCDes,@cDsClVlBem,@cDsClVlCor,@cDsClVlDep,@cDsClVlCDe,@cDsClVlDes)
@ 033, 165 SAY STR0077                     SIZE 017, 007 OF oFolder1:aDialogs[1] PIXEL	//"Grupo"
@ 031, 185 MSGET oGRUPO     VAR cGRUPO     SIZE 024, 010 OF oFolder1:aDialogs[1] PIXEL F3 "SNG" VALID AF125GRP(@aEntDst,cGRUPO,cFilDest) WHEN lLibCpo
@ 032, 220 SAY STR0078                     SIZE 033, 007 OF oFolder1:aDialogs[1] PIXEL	//"Centro Custo"
@ 030, 246 MSGET oCCusto    VAR cCCusto    SIZE 042, 010 OF oFolder1:aDialogs[1] PIXEL WHEN .F.
@ 032, 295 SAY STR0079                     SIZE 021, 007 OF oFolder1:aDialogs[1] PIXEL	//"Destino"
@ 030, 317 MSGET oCCustoDst VAR cCCustoDst SIZE 042, 010 OF oFolder1:aDialogs[1] PIXEL VALID  A125VlDsTr( cFilDest, "CTT", cCCustoDst ) WHEN lLibCpo
oCCustoDst:BF3 := { || AF125F3Dst( cFilDest, "CTT", "CTT_CUSTO", @cCCustoDst, @oCCustoDst ) }
@ 046, 004 SAY STR0080                     SIZE 031, 007 OF oFolder1:aDialogs[1] PIXEL	//"Custo Atual."
@ 045, 035 MSGET oCustAtu   VAR nCustAtu   SIZE 060, 010 OF oFolder1:aDialogs[1] PIXEL WHEN .F. PICTURE X3Picture( "N3_VORIG1" )
@ 046, 120 SAY STR0081                     SIZE 031, 007 OF oFolder1:aDialogs[1] PIXEL	//"Valor Resid."
@ 045, 155 MSGET oValResid  VAR nValResid  SIZE 060, 010 OF oFolder1:aDialogs[1] PIXEL WHEN .F. PICTURE X3Picture( "N3_VORIG1" )
@ 046, 219 SAY STR0082                     SIZE 025, 007 OF oFolder1:aDialogs[1] PIXEL	//"Endereço"
@ 044, 246 MSGET oLOCAL     VAR cLOCAL     SIZE 042, 010 OF oFolder1:aDialogs[1] PIXEL WHEN .F.
@ 046, 295 SAY STR0079                     SIZE 021, 007 OF oFolder1:aDialogs[1] PIXEL	//"Destino"
@ 044, 317 MSGET oLOCALDst  VAR cLOCALDst  SIZE 042, 010 OF oFolder1:aDialogs[1] PIXEL VALID  A125VlDsTr( cFilDest, "SNL", cLOCALDst )
oLOCALDst:BF3 := { || AF125F3Dst( cFilDest, "SNL", "NL_CODIGO", @cLOCALDst, @oLOCALDst ) }

//SubFolders - Entidades
oFolder2 := TFolder():New( 059, 009, aTitFolder, , oFolder1:aDialogs[1], , , , .T., , 352, 089 )

For nX:= 1 TO Len(aTitFolder)
	@ 000, 005 GROUP TO 075, 061 PROMPT STR0068           OF oFolder2:aDialogs[nX] PIXEL	//"Dados Contábeis"
	@ 010, 008 SAY STR0083              SIZE 013, 007     OF oFolder2:aDialogs[nX] PIXEL	//"Bem"
	@ 023, 008 SAY STR0084              SIZE 049, 007     OF oFolder2:aDialogs[nX] PIXEL	//"Correção Monetária"
	@ 036, 008 SAY STR0085              SIZE 037, 007     OF oFolder2:aDialogs[nX] PIXEL	//"Desp. Deprec."
	@ 049, 008 SAY STR0086              SIZE 035, 007 	  OF oFolder2:aDialogs[nX] PIXEL	//"Depr. Acumul."
	@ 062, 008 SAY STR0087              SIZE 038, 007     OF oFolder2:aDialogs[nX] PIXEL	//"Corr.Mon.Depr."
	@ 000, 069 GROUP TO 075, 142 PROMPT STR0088  		  OF oFolder2:aDialogs[nX] PIXEL	//"Origem"
	@ 000, 151 GROUP TO 075, 224 PROMPT STR0079 		  OF oFolder2:aDialogs[nX] PIXEL	//"Destino"
Next

//SubFolder1 - Conta Contabil
@ 008, 075 MSGET oCContab    VAR cCContab    SIZE 060, 010 OF oFolder2:aDialogs[1] PIXEL WHEN .F.
@ 008, 157 MSGET oCContabDst VAR aEntDst[1][1][2] SIZE 060, 010 OF oFolder2:aDialogs[1] PIXEL VALID  A125VlDsTr(cFilDest,"CT1",aEntDst[1][1][2],@cDsCContab) WHEN lLibCpo
oCContabDst:BF3 := { || AF125F3Dst( cFilDest, "CT1", "CT1_CONTA", @aEntDst[1][1][2], @oCContabDst ) }
@ 010, 227 SAY   cDsCContab                  SIZE 119, 007 OF oFolder2:aDialogs[1] PIXEL COLOR CLR_HBLUE
@ 021, 075 MSGET oCCorrec    VAR cCCorrec    SIZE 060, 010 OF oFolder2:aDialogs[1] PIXEL WHEN .F.
@ 021, 157 MSGET oCCorrecDst VAR aEntDst[1][2][2] SIZE 060, 010 OF oFolder2:aDialogs[1] PIXEL VALID  A125VlDsTr(cFilDest,"CT1",aEntDst[1][2][2],@cDsCCorrec) WHEN lLibCpo
oCCorrecDst:BF3 := { || AF125F3Dst( cFilDest, "CT1", "CT1_CONTA", @aEntDst[1][2][2], @oCCorrecDst ) }
@ 023, 227 SAY   cDsCCorrec                  SIZE 119, 007 OF oFolder2:aDialogs[1] PIXEL COLOR CLR_HBLUE
@ 034, 075 MSGET oCDeprec    VAR cCDeprec    SIZE 060, 010 OF oFolder2:aDialogs[1] PIXEL WHEN .F.
@ 034, 157 MSGET oCDeprecDst VAR aEntDst[1][3][2] SIZE 060, 010 OF oFolder2:aDialogs[1] PIXEL VALID  A125VlDsTr(cFilDest,"CT1",aEntDst[1][3][2],@cDsCDeprec) WHEN lLibCpo
oCDeprecDst:BF3 := { || AF125F3Dst( cFilDest, "CT1", "CT1_CONTA", @aEntDst[1][3][2], @oCDeprecDst ) }
@ 036, 227 SAY   cDsCDeprec                  SIZE 119, 007 OF oFolder2:aDialogs[1] PIXEL COLOR CLR_HBLUE
@ 047, 075 MSGET oCDDepr     VAR cCDDepr     SIZE 060, 010 OF oFolder2:aDialogs[1] PIXEL WHEN .F.
@ 047, 157 MSGET oCDDeprDst  VAR aEntDst[1][4][2]  SIZE 060, 010 OF oFolder2:aDialogs[1] PIXEL VALID  A125VlDsTr(cFilDest,"CT1",aEntDst[1][4][2],@cDsCDDepr) WHEN lLibCpo
oCDDeprDst:BF3  := { || AF125F3Dst( cFilDest, "CT1", "CT1_CONTA", @aEntDst[1][4][2], @oCDDeprDst ) }
@ 049, 227 SAY   cDsCDDepr                   SIZE 119, 007 OF oFolder2:aDialogs[1] PIXEL COLOR CLR_HBLUE
@ 060, 075 MSGET oCDesp      VAR cCDesp      SIZE 060, 010 OF oFolder2:aDialogs[1] PIXEL WHEN .F.
@ 060, 157 MSGET oCDespDst   VAR aEntDst[1][5][2]   SIZE 060, 010 OF oFolder2:aDialogs[1] PIXEL VALID  A125VlDsTr(cFilDest,"CT1",aEntDst[1][5][2],@cDsCDesp) WHEN lLibCpo
oCDespDst:BF3   := { || AF125F3Dst( cFilDest, "CT1", "CT1_CONTA", @aEntDst[1][5][2], @oCDespDst ) }
@ 062, 227 SAY   cDsCDesp                    SIZE 119, 007 OF oFolder2:aDialogs[1] PIXEL COLOR CLR_HBLUE

//SubFolder2 - Centro de Custo
@ 008, 075 MSGET oCustBem    VAR cCustBem    SIZE 060, 010 OF oFolder2:aDialogs[2] PIXEL WHEN .F.
@ 008, 157 MSGET oCustBemDst VAR aEntDst[2][1][2] SIZE 060, 010 OF oFolder2:aDialogs[2] PIXEL VALID  A125VlDsTr(cFilDest,"CTT",aEntDst[2][1][2],@cDsCustBem) WHEN lLibCpo .And. lCCusto
oCustBemDst:BF3 := { || AF125F3Dst( cFilDest, "CTT", "CTT_CUSTO", @aEntDst[2][1][2], @oCustBemDst ) }
@ 010, 227 SAY   cDsCustBem                  SIZE 119, 007 OF oFolder2:aDialogs[2] PIXEL COLOR CLR_HBLUE
@ 021, 075 MSGET oCCCorr     VAR cCCCorr     SIZE 060, 010 OF oFolder2:aDialogs[2] PIXEL WHEN .F.
@ 021, 157 MSGET oCCCorrDst  VAR aEntDst[2][2][2]  SIZE 060, 010 OF oFolder2:aDialogs[2] PIXEL VALID  A125VlDsTr(cFilDest,"CTT",aEntDst[2][2][2],@cDsCCCorr) WHEN lLibCpo .And. lCCusto
oCCCorrDst:BF3 := { || AF125F3Dst( cFilDest, "CTT", "CTT_CUSTO", @aEntDst[2][2][2], @oCCCorrDst ) }
@ 023, 227 SAY   cDsCCCorr                   SIZE 119, 007 OF oFolder2:aDialogs[2] PIXEL COLOR CLR_HBLUE
@ 034, 075 MSGET oCCDesp     VAR cCCDesp     SIZE 060, 010 OF oFolder2:aDialogs[2] PIXEL WHEN .F.
@ 034, 157 MSGET oCCDespDst  VAR aEntDst[2][3][2]  SIZE 060, 010 OF oFolder2:aDialogs[2] PIXEL VALID  A125VlDsTr(cFilDest,"CTT",aEntDst[2][3][2],@cDsCCDesp) WHEN lLibCpo .And. lCCusto
oCCDespDst:BF3 := { || AF125F3Dst( cFilDest, "CTT", "CTT_CUSTO", @aEntDst[2][3][2], @oCCDespDst ) }
@ 036, 227 SAY   cDsCCDesp                   SIZE 119, 007 OF oFolder2:aDialogs[2] PIXEL COLOR CLR_HBLUE
@ 047, 075 MSGET oCCCDep     VAR cCCCDep     SIZE 060, 010 OF oFolder2:aDialogs[2] PIXEL WHEN .F.
@ 047, 157 MSGET oCCCDepDst  VAR  aEntDst[2][4][2]  SIZE 060, 010 OF oFolder2:aDialogs[2] PIXEL VALID  A125VlDsTr(cFilDest,"CTT",aEntDst[2][4][2],@cDsCCCDep) WHEN lLibCpo .And. lCCusto
oCCCDepDst:BF3 := { || AF125F3Dst( cFilDest, "CTT", "CTT_CUSTO", @aEntDst[2][4][2], @oCCCDepDst ) }
@ 049, 227 SAY   cDsCCCDep                   SIZE 119, 007 OF oFolder2:aDialogs[2] PIXEL COLOR CLR_HBLUE
@ 060, 075 MSGET oCCCDES     VAR cCCCDES     SIZE 060, 010 OF oFolder2:aDialogs[2] PIXEL WHEN .F.
@ 060, 157 MSGET oCCCDESDst  VAR aEntDst[2][5][2]  SIZE 060, 010 OF oFolder2:aDialogs[2] PIXEL VALID  A125VlDsTr(cFilDest,"CTT",aEntDst[2][5][2],@cDsCCCDES) WHEN lLibCpo .And. lCCusto
oCCCDESDst:BF3 := { || AF125F3Dst( cFilDest, "CTT", "CTT_CUSTO", @aEntDst[2][5][2], @oCCCDESDst ) }
@ 062, 227 SAY   cDsCCCDES                   SIZE 119, 007 OF oFolder2:aDialogs[2] PIXEL COLOR CLR_HBLUE


//SubFolder3 - Item Contabil
@ 008, 075 MSGET oItBem     VAR cItBem     SIZE 060, 010 OF oFolder2:aDialogs[3] PIXEL WHEN .F.
@ 008, 157 MSGET oItBemDst  VAR aEntDst[3][1][2]  SIZE 060, 010 OF oFolder2:aDialogs[3] PIXEL VALID  A125VlDsTr(cFilDest,"CTD",aEntDst[3][1][2],@cDsItBem) WHEN lLibCpo .And. lItemCont
oItBemDst:BF3 := {|| AF125F3Dst(cFilDest,"CTD","CTD_ITEM",@aEntDst[3][1][2],@oItBemDst)}
@ 010, 227 SAY   cDsItBem                  SIZE 119, 007 OF oFolder2:aDialogs[3] PIXEL COLOR CLR_HBLUE
@ 021, 075 MSGET oItCorr    VAR cItCorr    SIZE 060, 010 OF oFolder2:aDialogs[3] PIXEL WHEN .F.
@ 021, 157 MSGET oItCorrDst VAR aEntDst[3][2][2] SIZE 060, 010 OF oFolder2:aDialogs[3] PIXEL VALID  A125VlDsTr(cFilDest,"CTD",aEntDst[3][2][2],@cDsItCorr) WHEN lLibCpo .And. lItemCont
oItCorrDst:BF3 := {|| AF125F3Dst(cFilDest,"CTD","CTD_ITEM",@aEntDst[3][2][2],@oItCorrDst)}
@ 023, 227 SAY   cDsItCorr                 SIZE 119, 007 OF oFolder2:aDialogs[3] PIXEL COLOR CLR_HBLUE
@ 034, 075 MSGET oItDesp    VAR cItDesp    SIZE 060, 010 OF oFolder2:aDialogs[3] PIXEL WHEN .F.
@ 034, 157 MSGET oItDespDst VAR aEntDst[3][3][2] SIZE 060, 010 OF oFolder2:aDialogs[3] PIXEL VALID  A125VlDsTr(cFilDest,"CTD",aEntDst[3][3][2],@cDsItDesp) WHEN lLibCpo .And. lItemCont
oItDespDst:BF3 := {|| AF125F3Dst(cFilDest,"CTD","CTD_ITEM",@aEntDst[3][3][2],@oItDespDst)}
@ 036, 227 SAY   cDsItDesp                 SIZE 119, 007 OF oFolder2:aDialogs[3] PIXEL COLOR CLR_HBLUE
@ 047, 075 MSGET oItCDep    VAR cItCDep    SIZE 060, 010 OF oFolder2:aDialogs[3] PIXEL WHEN .F.
@ 047, 157 MSGET oItCDepDst VAR aEntDst[3][4][2] SIZE 060, 010 OF oFolder2:aDialogs[3] PIXEL VALID  A125VlDsTr(cFilDest,"CTD",aEntDst[3][4][2],@cDsItCDep) WHEN lLibCpo .And. lItemCont
oItCDepDst:BF3 := {|| AF125F3Dst(cFilDest,"CTD","CTD_ITEM",@aEntDst[3][4][2],@oItCDepDst)}
@ 049, 227 SAY   cDsItCDep                 SIZE 119, 007 OF oFolder2:aDialogs[3] PIXEL COLOR CLR_HBLUE
@ 060, 075 MSGET oItCDes    VAR cItCDes    SIZE 060, 010 OF oFolder2:aDialogs[3] PIXEL WHEN .F.
@ 060, 157 MSGET oItCDesDst VAR aEntDst[3][5][2] SIZE 060, 010 OF oFolder2:aDialogs[3] PIXEL VALID  A125VlDsTr(cFilDest,"CTD",aEntDst[3][5][2],@cDsItCDes) WHEN lLibCpo .And. lItemCont
oItCDesDst:BF3 := {|| AF125F3Dst(cFilDest,"CTD","CTD_ITEM",@aEntDst[3][5][2],@oItCDesDst)}
@ 062, 227 SAY   cDsItCDes                 SIZE 119, 007 OF oFolder2:aDialogs[3] PIXEL COLOR CLR_HBLUE

//SubFolder4 - Classe de Valor
@ 008, 075 MSGET oClVlBem    VAR cClVlBem    SIZE 060, 010 OF oFolder2:aDialogs[4] PIXEL WHEN .F.
@ 008, 157 MSGET oClVlBemDst VAR aEntDst[4][1][2] SIZE 060, 010 OF oFolder2:aDialogs[4] PIXEL VALID  A125VlDsTr(cFilDest,"CTH",aEntDst[4][1][2],@cDsClVlBem) WHEN lLibCpo .And. lClValor
oClVlBemDst:BF3 := { || AF125F3Dst( cFilDest, "CTH", "CTH_CLVL", @aEntDst[4][1][2], @oClVlBemDst ) }
@ 010, 227 SAY   cDsClVlBem                  SIZE 119, 007 OF oFolder2:aDialogs[4] PIXEL COLOR CLR_HBLUE
@ 021, 075 MSGET oClVlCor    VAR cClVlCor    SIZE 060, 010 OF oFolder2:aDialogs[4] PIXEL WHEN .F.
@ 021, 157 MSGET oClVlCorDst VAR aEntDst[4][2][2] SIZE 060, 010 OF oFolder2:aDialogs[4] PIXEL VALID  A125VlDsTr(cFilDest,"CTH",aEntDst[4][2][2],@cDsClVlCor) WHEN lLibCpo .And. lClValor
oClVlCorDst:BF3 := { || AF125F3Dst( cFilDest, "CTH", "CTH_CLVL", @aEntDst[4][2][2], @oClVlCorDst ) }
@ 023, 227 SAY   cDsClVlCor                  SIZE 119, 007 OF oFolder2:aDialogs[4] PIXEL COLOR CLR_HBLUE
@ 034, 075 MSGET oClVlDep    VAR cClVlDep    SIZE 060, 010 OF oFolder2:aDialogs[4] PIXEL WHEN .F.
@ 034, 157 MSGET oClVlDepDst VAR aEntDst[4][3][2] SIZE 060, 010 OF oFolder2:aDialogs[4] PIXEL VALID  A125VlDsTr(cFilDest,"CTH",aEntDst[4][3][2],@cDsClVlDep) WHEN lLibCpo .And. lClValor
oClVlDepDst:BF3 := { || AF125F3Dst( cFilDest, "CTH", "CTH_CLVL", @aEntDst[4][3][2], @oClVlDepDst ) }
@ 036, 227 SAY   cDsClVlDep                  SIZE 119, 007 OF oFolder2:aDialogs[4] PIXEL COLOR CLR_HBLUE
@ 047, 075 MSGET oClVlCDe    VAR cClVlCDe    SIZE 060, 010 OF oFolder2:aDialogs[4] PIXEL WHEN .F.
@ 047, 157 MSGET oClVlCDeDst VAR aEntDst[4][4][2] SIZE 060, 010 OF oFolder2:aDialogs[4] PIXEL VALID  A125VlDsTr(cFilDest,"CTH",aEntDst[4][4][2],@cDsClVlCDe) WHEN lLibCpo .And. lClValor
oClVlCDeDst:BF3 := { || AF125F3Dst( cFilDest, "CTH", "CTH_CLVL", @aEntDst[4][4][2], @oClVlCDeDst ) }
@ 049, 227 SAY   cDsClVlCDe                  SIZE 119, 007 OF oFolder2:aDialogs[4] PIXEL COLOR CLR_HBLUE
@ 060, 075 MSGET oClVlDes    VAR cClVlDes    SIZE 060, 010 OF oFolder2:aDialogs[4] PIXEL WHEN .F.
@ 060, 157 MSGET oClVlDesDst VAR aEntDst[4][5][2] SIZE 060, 010 OF oFolder2:aDialogs[4] PIXEL VALID  A125VlDsTr(cFilDest,"CTH",aEntDst[4][5][2],@cDsClVlDes) WHEN lLibCpo .And. lClValor
oClVlDesDst:BF3 := { || AF125F3Dst( cFilDest, "CTH", "CTH_CLVL", @aEntDst[4][5][2], @oClVlDesDst ) }
@ 062, 227 SAY   cDsClVlDes                  SIZE 119, 007 OF oFolder2:aDialogs[4] PIXEL COLOR CLR_HBLUE


//Dados da Nota Fiscal
@ 152, 002 GROUP oGroup5 TO 188, 295 PROMPT STR0038 OF oFolder1:aDialogs[1] PIXEL	//"Dados da Nota Fiscal" 
@ 162, 006 SAY STR0039                 SIZE 025, 007 OF oFolder1:aDialogs[1] PIXEL	//"Gera NFS"
@ 160, 033 MSCOMBOBOX oGeraNF  VAR cGeraNF  ITEMS { "1=" + STR0040, "2=" + STR0041 };	//"Sim" | "Não"
SIZE 031, 010 OF oFolder1:aDialogs[1] PIXEL  WHEN Af125VlGeraNF(cFilDest, cFilAnt, lLibCpo,@oGeraNF)  VALID A125AtCpTr( "GeraNF",@cCBase,@cItem,@cTipo,@cDescBem,@cN1_QTDE,@cGrupo,@cLOCAL,@cCCusto,@cCContab,@cCCorrec,@cCDeprec,@cCDDepr,@cCDesp,@cCustBem,@cCCCorr,@cCCDesp,@cCCCDep,@cCCCDes,@cItBem,@cItCorr,@cItDesp,@cItCDep,@cItCDes,@cClVlBem,@cClVlCor,@cClVlDep,@cClVlCDe,@cClVlDes,@nCustAtu,@nValResid,@cGeraNF,@cClasNFE,@cTESNFS,@cTESNFE,@cNota,@cSerie,cFilDest)
@ 162, 070 SAY STR0089                 SIZE 033, 007 OF oFolder1:aDialogs[1] PIXEL	//"Tip Clas NFE"
@ 160, 105 MSCOMBOBOX oClasNFE VAR cClasNFE ITEMS { "1=" + STR0063, "2=" + STR0064, "" };	//"A Classificar" | "Classificada"
SIZE 050, 010 OF oFolder1:aDialogs[1] PIXEL When cGERANF == "1"
@ 162, 163 SAY STR0044                 SIZE 028, 007 OF oFolder1:aDialogs[1] PIXEL	//"TES Saida"
@ 160, 192 MSGET oTESNFS  VAR cTESNFS  SIZE 020, 010 OF oFolder1:aDialogs[1] PIXEL F3 "SF4" WHEN cGERANF == "1" VALID A125AtCpTr( "TESNFS",@cCBase,@cItem,@cTipo,@cDescBem,@cN1_QTDE,@cGrupo,@cLOCAL,@cCCusto,@cCContab,@cCCorrec,@cCDeprec,@cCDDepr,@cCDesp,@cCustBem,@cCCCorr,@cCCDesp,@cCCCDep,@cCCCDes,@cItBem,@cItCorr,@cItDesp,@cItCDep,@cItCDes,@cClVlBem,@cClVlCor,@cClVlDep,@cClVlCDe,@cClVlDes,@nCustAtu,@nValResid,@cGeraNF,@cClasNFE,@cTESNFS,@cTESNFE,@cNota,@cSerie,cFilDest)
@ 162, 227 SAY STR0090                 SIZE 033, 007 OF oFolder1:aDialogs[1] PIXEL	//"TES Entrada"
@ 160, 262 MSGET oTESNFE  VAR cTESNFE  SIZE 020, 010 OF oFolder1:aDialogs[1] PIXEL WHEN cGERANF == "1" VALID A125AtCpTr( "TESNFE",@cCBase,@cItem,@cTipo,@cDescBem,@cN1_QTDE,@cGrupo,@cLOCAL,@cCCusto,@cCContab,@cCCorrec,@cCDeprec,@cCDDepr,@cCDesp,@cCustBem,@cCCCorr,@cCCDesp,@cCCCDep,@cCCCDes,@cItBem,@cItCorr,@cItDesp,@cItCDep,@cItCDes,@cClVlBem,@cClVlCor,@cClVlDep,@cClVlCDe,@cClVlDes,@nCustAtu,@nValResid,@cGeraNF,@cClasNFE,@cTESNFS,@cTESNFE,@cNota,@cSerie,cFilDest)
oTESNFE:BF3 := { || AF125F3Dst( cFilDest, "SF4", "F4_CODIGO", @cTESNFE, @oTESNFE ) }
@ 175, 008 SAY STR0045                 SIZE 023, 007 OF oFolder1:aDialogs[1] PIXEL	//"Num. NF"
@ 174, 033 MSGET oNota    VAR cNota    SIZE 045, 010 OF oFolder1:aDialogs[1] PIXEL F3 "SF2" WHEN cGERANF == "3" VALID Vazio( cNota ) .Or. ExistCpo( "SF2", cNota )
@ 175, 088 SAY STR0046                 SIZE 015, 007 OF oFolder1:aDialogs[1] PIXEL	//"Serie"
@ 174, 105 MSGET oSerie   VAR cSerie   SIZE 020, 010 OF oFolder1:aDialogs[1] PIXEL F3 "01"  WHEN cGERANF == "1" VALID Vazio( cSerie ) .Or. ExistCpo( "SX5", "01" + cSerie )
@ 175, 163 SAY STR0035                 SIZE 029, 007 OF oFolder1:aDialogs[1] PIXEL 	//"Cond. Pgto"
@ 174, 192 MSGET oCONDPG VAR cCONDPG   SIZE 030, 010 OF oFolder1:aDialogs[1] PIXEL F3 "SE4" WHEN cGERANF == "1" VALID Vazio( cCONDPG ) .Or. ExistCpo( "SE4", cCONDPG )

//FOLDER 2
//Dados da Solicitacao
@ 000, 002 GROUP oGroup1 TO 082, 377 PROMPT STR0025  OF oFolder1:aDialogs[2] PIXEL	//"Dados da Solicitação"
@ 014, 010 SAY STR0047                 SIZE 028, 007 OF oFolder1:aDialogs[2] PIXEL	//"Data Solic."
@ 013, 051 MSGET oDatSol  VAR dDatSol  SIZE 060, 010 OF oFolder1:aDialogs[2] PIXEL WHEN .F.
@ 014, 136 SAY STR0048                 SIZE 028, 007 OF oFolder1:aDialogs[2] PIXEL	//"Hora Solic."
@ 013, 165 MSGET oHorSol  VAR dHorSol  SIZE 060, 010 OF oFolder1:aDialogs[2] PIXEL WHEN .F.
@ 028, 010 SAY STR0016                 SIZE 035, 007 OF oFolder1:aDialogs[2] PIXEL	//"Solicitante"
@ 027, 051 MSGET oUsrSol  VAR cUsrSol  SIZE 060, 010 OF oFolder1:aDialogs[2] PIXEL WHEN .F.
@ 028, 133 SAY STR0049                 SIZE 030, 007 OF oFolder1:aDialogs[2] PIXEL	//"Nome Solic."
@ 027, 165 MSGET oNmUsSol VAR cNmUsSol SIZE 155, 010 OF oFolder1:aDialogs[2] PIXEL WHEN .F.
@ 044, 022 SAY STR0050                 SIZE 027, 007 OF oFolder1:aDialogs[2] PIXEL COLOR CLR_HBLUE	//"Hist. Solic."
@ 054, 021 GET oHistSol   VAR cHistSol OF oFolder1:aDialogs[2] MULTILINE SIZE 332, 020 HSCROLL PIXEL

//Dados da Aprov./Rejeic
@ 085, 002 GROUP oGroup2 TO 167, 377 PROMPT STR0051  OF oFolder1:aDialogs[2] PIXEL	//"Dados da Aprov/Rejeic"
@ 099, 019 SAY STR0052                 SIZE 030, 007 OF oFolder1:aDialogs[2] PIXEL	//"Dt Apv/Rej."
@ 097, 051 MSGET oDtApvRe VAR cDtApvRe SIZE 060, 010 OF oFolder1:aDialogs[2] PIXEL WHEN .F.
@ 099, 136 SAY STR0053                 SIZE 027, 007 OF oFolder1:aDialogs[2] PIXEL	//"Hr apv/rej."
@ 097, 165 MSGET oHrApvRe VAR cHrApvRe SIZE 060, 010 OF oFolder1:aDialogs[2] PIXEL WHEN .F.
@ 113, 017 SAY STR0054                 SIZE 032, 007 OF oFolder1:aDialogs[2] PIXEL	//"Apr/Rej. Por"
@ 112, 051 MSGET oUsrApv  VAR cUsrApv  SIZE 060, 010 OF oFolder1:aDialogs[2] PIXEL WHEN .F.
@ 113, 130 SAY STR0055                 SIZE 033, 007 OF oFolder1:aDialogs[2] PIXEL	//"Nome Aprov."
@ 112, 165 MSGET oNmUsApv VAR cNmUsApv SIZE 155, 010 OF oFolder1:aDialogs[2] PIXEL WHEN .F.
@ 129, 022 SAY STR0056                 SIZE 029, 007 OF oFolder1:aDialogs[2] PIXEL	//"Hist. Rejeic"
@ 139, 021 GET oHistRej   VAR cHistRej OF oFolder1:aDialogs[2] MULTILINE SIZE 332, 020 HSCROLL PIXEL WHEN .F.

DEFINE SBUTTON FROM 185, 310 TYPE 1 ACTION If( AF125TOkTr( nOpc, cCBASE, cItem, cGeraNF, cClasNFE, cTESNFS,;
	cTESNFE, cNota, cSerie, cCondPg, cHistSol, cCCustoDst),;
	( AF125PrcTr( nOpc, cCBase, cItem, cTipo, cFilDest, cGrupo,cCCustoDst, cLocalDst,;
	aEntDst,cGeraNF, cClasNFE, cTESNFS,cTESNFE, cNota, cSerie, dDatSol,;
	dHorSol, cUsrSol,cHistSol, cCondPg ), oDlg:End() ), Nil ) ENABLE OF oDlg
DEFINE SBUTTON FROM 185, 345 TYPE 2 ACTION oDlg:End() ENABLE OF oDlg PIXEL

If nOpc != 5 //Visualizacao/exclusao
	oCBASE:lReadonly		:= .T.
	oITEM:lReadonly			:= .T.
	oFILDEST:lReadonly		:= .T.
	oGRUPO:lReadonly		:= .T.
	oCCustoDst:lReadonly	:= .T.
	oLOCALDst:lReadonly		:= .T.
	oCContabDst:lReadonly	:= .T.
	oCCorrecDst:lReadonly	:= .T.
	oCDeprecDst:lReadonly	:= .T.
	oCDDeprDst:lReadonly	:= .T.
	oCDespDst:lReadonly		:= .T.
	If lCCusto
		oCustBemDst:lReadonly	:= .T.
		oCCCorrDst:lReadonly	:= .T.
		oCCDespDst:lReadonly	:= .T.
		oCCCDepDst:lReadonly	:= .T.
		oCCCDESDst:lReadonly	:= .T.
	Endif
	If lItemCont
		oItBemDst:lReadonly		:= .T.
		oItCorrDst:lReadonly	:= .T.
		oItDespDst:lReadonly	:= .T.
		oItCDepDst:lReadonly	:= .T.
		oItCDesDst:lReadonly	:= .T.
	Endif
	If lClValor
		oClVlBemDst:lReadonly	:= .T.
		oClVlCorDst:lReadonly	:= .T.
		oClVlDepDst:lReadonly	:= .T.
		oClVlCDeDst:lReadonly	:= .T.
		oClVlDesDst:lReadonly	:= .T.
	Endif
	oGeraNF:lReadonly		:= .T.
	oClasNFE:lReadonly		:= .T.
	oTESNFS:lReadonly		:= .T.
	oTESNFE:lReadonly		:= .T.
	oNota:lReadonly			:= .T.
	oSerie:lReadonly		:= .T.
	oHistSol:lReadonly		:= .T.
	oCONDPG:lReadonly		:= .T.
EndIf

ACTIVATE MSDIALOG oDlg CENTERED

Return

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡…o    ³AF125TOkTr ³ Autor ³ Marcos R. Pires      ³ Data ³ 02/08/10 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³Validar o botao Ok na inclusao da solic de transferencia    ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Sintaxe   ³                                                            ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³ SIGAATF                                                    ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
Static Function AF125TOkTr( nOpc, cCBASE, cItem, cGeraNF, cClasNFE, cTESNFS, cTESNFE, cNota, cSerie, cCondPg, cHistSol, cCCustoDst )

Local aArea := GetArea()
Local lRet  := .T.

If nOpc == 5
	
	//Verifica o preenchimento de campos obrigatórios.
	If Empty(cCBase) .And. lRet
		lRet := .F.
		Help(" ",1,"AF125OBG",,STR0074 + " - '" + STR0026 + "'",1,0)	//"Campo obrigatório não informado" |  "Código"
	EndIf
	
	If Empty(cItem) .And. lRet
		lRet := .F. 
		Help(" ",1,"AF125OBG",,STR0074 + " - '" + STR0027 + "'",1,0)	//"Campo obrigatório não informado" |  "Item"
	EndIf
	
	If ( cGeraNF == "1" .And. Empty(cClasNFE) ) .And. lRet
		lRet := .F.
		Help(" ",1,"AF125OBG",,STR0074 + " - '" + STR0089 + "'",1,0)	//"Campo obrigatório não informado" |  "Tip Clas NFE"
	EndIf
	
	If ( cGeraNF == "1" .And. Empty( cCondPg ) ) .And. lRet
		lRet := .F.
		Help(" ",1,"AF125OBG",,STR0074 + " - '" + STR0035 + "'",1,0)	//"Campo obrigatório não informado" | "Cond. Pgto"
	EndIf
	
	If ( cGeraNF == "1" .And. Empty(cTesNFS) ) .And. lRet
		lRet := .F.
		Help(" ",1,"AF125OBG",,STR0074 + " - '" + STR0044 + "'",1,0)	//"Campo obrigatório não informado" |  "TES Saida"
	EndIf
	
	If ( cGeraNF == "1" .And. Empty(cTesNFE) ) .And. lRet
		lRet := .F.  
		Help(" ",1,"AF125OBG",,STR0074 + " - '" + STR0090 + "'",1,0)	//"Campo obrigatório não informado" | "TES Entrada"
	EndIf
	
	If ( cGeraNF == "1" .And. Empty(cSerie) ) .And. lRet
		lRet := .F.     
		Help(" ",1,"AF125OBG",,STR0074 + " - '" + STR0046 + "'",1,0)	//"Campo obrigatório não informado" |  "Serie"
	EndIf
	
	If Empty( cHistSol ) .And. lRet
		lRet := .F.  
		Help(" ",1,"AF125OBG",,STR0074 + " - '" + STR0050 + "'",1,0)	//"Campo obrigatório não informado" |  "Hist. Solic."
	EndIf
	
	//Verifica se WorkFlow está ativado.
	If lRet
		If SuperGetMV( "MV_ATFWFM", , .F. )
			lRet := A125VlRspWF( cCBase, cItem )	//Valida se há e-mail do responsável pelo bem
		EndIf										//ou do responsável padrão élo Ativo
	EndIf
	
EndIf


//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ\¿
//³PE para validação da inclusão e exclusao da solicitação de baixa / transferencia³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ\Ù
If ExistBlock( "AF125OKT" ) .And. nOpc > 2 .And. lRet
	lRet := ExecBlock( "AF125OKT", .F., .F., { nOpc, cCBASE, cItem, cGeraNF, cClasNFE, cTESNFS, cTESNFE, cNota, cSerie, cCondPg, cHistSol, cCCustoDst } )
EndIf

RestArea( aArea )

Return lRet

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡…o    ³AF125PrcTr³ Autor ³ Marcos R. Pires       ³ Data ³ 26/07/10 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³ Processa as operacoes de inclusao, alteracao e exclusao    ³±±
±±³          ³ solicitacoes de transferencia.                             ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³ SIGAATF                                                    ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
Static Function AF125PrcTr( nOpc, cCBase, cItem, cTipo, cFilDest, cGrupo,cCCustoDst,;
cLocalDst,aEntDst, cGeraNF, cClasNFE,cTESNFS, cTESNFE, cNota,;
cSerie, dDatSol, dHorSol,cUsrSol, cHistSol, cCondpg )

Local cCodSol := Nil

If nOpc == 5	//Inclusão da solicitação de transferência
	
	Begin Transaction
	
	cGRUPO		:=IIF(!Empty(cGRUPO		),cGRUPO	 ,	  SN1->N1_GRUPO		)
	cCCustoDst	:=IIF(!Empty(cCCustoDst	),cCCustoDst ,	  SN3->N3_CCUSTO	)
	cLOCALDst	:=IIF(!Empty(cLOCALDst	),cLOCALDst	 ,	  SN1->N1_LOCAL		)
	
	cCContabDst	:=IIF(!Empty(aEntDst[1][1][2]),aEntDst[1][1][2] ,  SN3->N3_CCONTAB	)
	cCCorrecDst	:=IIF(!Empty(aEntDst[1][2][2]),aEntDst[1][2][2] ,  SN3->N3_CCORREC	)
	cCDeprecDst	:=IIF(!Empty(aEntDst[1][3][2]),aEntDst[1][3][2] ,  SN3->N3_CDEPREC	)
	cCDDeprDst	:=IIF(!Empty(aEntDst[1][4][2]),aEntDst[1][4][2] ,  SN3->N3_CCDEPR	)
	cCDespDst	:=IIF(!Empty(aEntDst[1][5][2]),aEntDst[1][5][2]	,  SN3->N3_CDESP	)
	
	cCustBemDst :=IIF(!Empty(aEntDst[2][1][2]),aEntDst[2][1][2] ,   SN3->N3_CUSTBEM	)
	cCCCorrDst	:=IIF(!Empty(aEntDst[2][2][2]),aEntDst[2][2][2] ,   SN3->N3_CCCORR	)
	cCCDespDst	:=IIF(!Empty(aEntDst[2][3][2]),aEntDst[2][3][2] ,   SN3->N3_CCDESP	)
	cCCCDepDst	:=IIF(!Empty(aEntDst[2][4][2]),aEntDst[2][4][2] ,   SN3->N3_CCCDEP	)
	cCCCDESDst	:=IIF(!Empty(aEntDst[2][5][2]),aEntDst[2][5][2] ,   SN3->N3_CCCDES	)
	
	cItBemDst	:=IIF(!Empty(aEntDst[3][1][2]),aEntDst[3][1][2]	,  SN3->N3_SUBCCON)
	cItCorrDst	:=IIF(!Empty(aEntDst[3][2][2]),aEntDst[3][2][2] ,  SN3->N3_SUBCCOR	)
	cItDespDst	:=IIF(!Empty(aEntDst[3][3][2]),aEntDst[3][3][2] ,  SN3->N3_SUBCDEP	)
	cItCDepDst	:=IIF(!Empty(aEntDst[3][4][2]),aEntDst[3][4][2] ,  SN3->N3_SUBCCDE	)
	cItCDesDst	:=IIF(!Empty(aEntDst[3][5][2]),aEntDst[3][5][2] ,  SN3->N3_SUBCDES	)
	
	cClVlBemDst	:=IIF(!Empty(aEntDst[4][1][2]),aEntDst[4][1][2] ,  SN3->N3_CLVLCON	)
	cClVlCorDst	:=IIF(!Empty(aEntDst[4][2][2]),aEntDst[4][2][2] ,  SN3->N3_CLVLCOR	)
	cClVlDepDst	:=IIF(!Empty(aEntDst[4][3][2]),aEntDst[4][3][2] ,  SN3->N3_CLVLDEP	)
	cClVlCDeDst	:=IIF(!Empty(aEntDst[4][4][2]),aEntDst[4][4][2] ,  SN3->N3_CLVLCDE	)
	cClVlDesDst	:=IIF(!Empty(aEntDst[4][5][2]),aEntDst[4][5][2] ,  SN3->N3_CLVLDES	)
	
	
	cCodSol := GetSxENum( "SNM", "NM_CODIGO" )
	ConfirmSx8()
	MsgRun( STR0065,;	//"Gerando a solicitação, aguarde..."
	STR0066,;	//"Solicitação de Transferência"
	{ || GravaTr( cCBase, cItem, cTipo, cFilDest, cGrupo, cCCustoDst,;
	cLocalDst, cCContabDst, cCCorrecDst, cCDeprecDst,;
	cCDDeprDst, cCDespDst, cCustBemDst, cCCCorrDst,;
	cCCDespDst, cCCCDepDst, cCCCDESDst, cItBemDst,;
	cItCorrDst, cItDespDst, cItCDepDst, cItCDesDst,;
	cClVlBemDst, cClVlCorDst, cClVlDepDst, cClVlCDeDst,;
	cClVlDesDst, cGeraNF, cClasNFE, cTESNFS, cTESNFE,;
	cNota, cSerie, dDatSol, dHorSol, cUsrSol, cHistSol,;
	cCodSol, cCondpg ) } )
	End Transaction
	
	If SuperGetMV( 'MV_ATFWFM' ,, .F. )
		//Chamada do WorkFlow
		A125WfTr( cCodSol )
	EndIf
	
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Ponto de entrada executado após a gravação da solicitação transferência.  			³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	If ExistBlock( "AF125GRT" )
		ExecBlock( "AF125GRT", .F., .F. )
	EndIf
	
ElseIf nOpc == 7	//Exclusao da solicitacao de transferencia
	
	If  MsgNoYes( STR0067, STR0021 )	//"Deseja realmente excluir esta solicitação?" | "Atencão"
		cCodSol := SNM->NM_CODIGO
		dbSelectArea( "SNM" )
		SNM->( dbSetOrder(1) )
		SNM->( dbSeek(xFilial( "SNM" ) + cCodSol ) )
		
		While SNM->(!EOF()) .And. xFilial( "SNM" ) == SNM->NM_FILIAL .And. cCodSol == SNM->NM_CODIGO
			RecLock( "SNM", .F. )
			SNM->( dbDelete() )
			SNM->( MsUnlock() )
			SNM->( dbSkip() )
		EndDo
	EndIf
	
ElseIf nOpc == 2	// Visualização
	oDlg:End()
EndIf

Return

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³GravaTr   ºAutor  ³Microsiga           º Data ³  30/08/10   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ Gravação da solicitação de transferencia                   º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ SIGAATF                                                    º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
Static Function GravaTr(cCBase,cItem,cTipo,cFilDest, cGrupo,cCCustoDst,cLocalDst,cCContabDst,;
cCCorrecDst,cCDeprecDst,cCDDeprDst,cCDespDst,cCustBemDst,cCCCorrDst,;
cCCDespDst,cCCCDepDst,cCCCDESDst,cItBemDst,cItCorrDst,cItDespDst,;
cItCDepDst,cItCDesDst,cClVlBemDst,cClVlCorDst,cClVlDepDst,cClVlCDeDst,;
cClVlDesDst,cGeraNF,cClasNFE,cTESNFS,cTESNFE,cNota,cSerie,dDatSol,dHorSol,;
cUsrSol,cHistSol,cCodSol,cCondpg)


RecLock( "SNM", .T. )
SNM->NM_FILIAL	:= xFilial( "SNM" )
SNM->NM_CODIGO	:= cCodSol
SNM->NM_DATSOL	:= dDatSol
SNM->NM_HORSOL	:= StrTran( Left( dHorsol, 5 ), ":", "" )
SNM->NM_CBASE	:= cCBase
SNM->NM_ITEM	:= cItem
SNM->NM_TIPO	:= cTipo
SNM->NM_SITSOL	:= "1" //Pendente
SNM->NM_USRSOL	:= cUsrSol
SNM->NM_TIPOSOL	:= "2" //Transferencia
SNM->NM_FILDEST := cFilDest
SNM->NM_GRUPO	:= cGrupo
SNM->NM_CCUSTO	:= cCCustoDst
SNM->NM_LOCAL	:= cLocalDst
SNM->NM_CCONTAB	:= cCContabDst
SNM->NM_CCORREC	:= cCCorrecDst
SNM->NM_CDEPREC	:= cCDeprecDst
SNM->NM_CDDEPR	:= cCDDeprDst
SNM->NM_CDESP	:= cCDespDst
SNM->NM_CUSTBEM	:= cCustBemDst
SNM->NM_CCCORR	:= cCCCorrDst
SNM->NM_CCDESP	:= cCCDespDst
SNM->NM_CCCDEP	:= cCCCDepDst
SNM->NM_CCCDES	:= cCCCDESDst
SNM->NM_ITBEM	:= cItBemDst
SNM->NM_ITCORR	:= cItCorrDst
SNM->NM_ITDESP	:= cItDespDst
SNM->NM_ITCDEP	:= cItCDepDst
SNM->NM_ITCDES	:= cItCDesDst
SNM->NM_CLVLBEM	:= cClVlBemDst
SNM->NM_CLVLCOR	:= cClVlCorDst
SNM->NM_CLVLDEP	:= cClVlDepDst
SNM->NM_CLVLCDE	:= cClVlCDeDst
SNM->NM_CLVLDES	:= cClVlDesDst
SNM->NM_GERANF	:= SubStr(cGeraNF,1,1)
SNM->NM_NOTA	:= cNota
SNM->NM_SERIE	:= cSerie
SNM->NM_TESNFS	:= cTESNFS
SNM->NM_CLASNFE	:= SubStr(cClasNFE,1,1)
SNM->NM_TESNFE	:= cTESNFE
SNM->NM_CONDPG	:= cCONDPG
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Grava historico³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
MSMM( SNM->NM_CDHSOL, , , cHistSol, 1, , , "SNM", "NM_CDHSOL" )
SNM->( MsUnlock() )

Return Nil

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³AF125F3Dst ºAutor  ³Marcos R. Pires     º Data ³  31/07/10  º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ Executa a consulta padrao na filial destino.               º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ SigaAtf                                                    º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
Function AF125F3Dst( _cFilDest, _cAlias, _cCpoTab, _cCpoCod, _oObjCpo )

Local _cFilOri := cFilAnt
Local aArea    := GetArea()
Local lRet 	   := .F.

//ATENCAO! alteracao do valor da variavel publica cFilAnt
If _cFilOri != _cFilDest
	cFilAnt := _cFilDest
EndIf

lRet := Conpad1( , , , _cAlias )

If lRet
	_cCpoCod := &( _cAlias + "->" + _cCpoTab )
	_oObjCpo:Refresh()
EndIf

//ATENCAO! retorno do valor da variavel publica cFilAnt
If cFilAnt	!= _cFilOri
	cFilAnt	:= _cFilOri
EndIf

RestArea( aArea )

Return

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³A125VlDsTr ºAutor  ³Marcos R. Pires     º Data ³  31/07/10  º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ Valida o preenchimento dos campos destino da transferencia.º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ SigaAtf                                                    º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
Function A125VlDsTr( _cFilDest, _cAlias, _cConteud, _cCpoDsc )

Local aArea    := GetArea()
Local lRet	   := .F.
Local _cFilOri := cFilAnt

If !Empty( _cConteud )
	//ATENCAO! Alteracao do valor da variavel publica cFilAnt
	If _cFilOri != _cFilDest
		cFilAnt := _cFilDest
	EndIf
	
	dbSelectArea( _cAlias )
	( _cAlias )->( dbSetOrder(1) )	//dbSeek incluso pois as funcoes de validacao aceitam codigo sem zero a esquerda
	If ( _cAlias )->( dbSeek( xFilial( _cAlias ) + _cConteud ) )
		If _cAlias == "CT1"
			lRet := Ctb105Cta( _cConteud )
		ElseIf _cAlias == "CTT"
			lRet := Ctb105Cc( _cConteud )
		ElseIf _cAlias == "CTD"
			lRet := Ctb105Item( _cConteud )
		ElseIf _cAlias == "CTH"
			lRet := Ctb105ClVl( _cConteud )
		ElseIf _cAlias == "SNL"
			lRet := ExistCpo( _cAlias, _cConteud )
		EndIf
		
		If ValType( _cCpoDsc ) == "C"
			//Preeche o campo descricao exibido na tela
			_cCpoDsc := If( lRet, Posicione( _cAlias, 1, xFilial( _cAlias) + _cConteud, _cAlias + "_DESC01" ), Nil )
		EndIf
	Else
		lRet := .F.
		Help(" ",1,"AF125NOT",,STR0072,1,0)//"Código não cadastrado"
	EndIf
Else
	IIf( ValType( _cCpoDsc ) == "C", _cCpoDsc := "", Nil) //Local Destino e Centro de Custo destino não possuem descricao
	lRet := .T.
EndIf


//ATENCAO! Retorno do valor da variavel publica cFilAnt
If cFilAnt	!= _cFilOri
	cFilAnt	:= _cFilOri
EndIf

RestArea( aArea )

Return lRet


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³A125AtCpTr ºAutor  ³Microsiga          º Data ³  25/07/10   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ Funcao generica para validacao e preenchimento dos campos  º±±
±±º          ³ na solicitacao de transferencia.                           º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ SIGAATF                                                    º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
Static Function A125AtCpTr( cCampo,cCBase,cItem,cTipo,cDescBem,cN1_QTDE,cGrupo,cLocal,cCCusto,cCContab,cCCorrec,;
cCDeprec,cCDDepr,cCDesp,cCustBem,cCCCorr,cCCDesp,cCCCDep,cCCCDES,cItBem,cItCorr,cItDesp,;
cItCDep,cItCDes,cClVlBem,cClVlCor,cClVlDep,cClVlCDe,cClVlDes,nCustAtu,nValResid,cGeraNF,;
cClasNFE,cTESNFS,cTESNFE,cNota,cSerie,cFilDest,lLibCpo)

Local aArea      := GetArea()
Local lRet 		 := .T.
Local cPatrim	 := ""
Local nValor	 := 0
Local nCustoAtu	 := 0
Local nVlrResid  := 0
Local nQtdeSn	 := 0
Local nQtdOrig	 := 0
Local nQuant	 := 0
Local cN1TipoNeg := Alltrim( SuperGetMv( "MV_N1TPNEG", .F., "" ) ) // Tipos de N1_PATRIM que aceitam Valor originais negativos
Local cN3TipoNeg := Alltrim( SuperGetMv( "MV_N3TPNEG", .F., "" ) ) // Tipos de N3_TIPO que aceitam Valor originais negativos
Local _cFilOri := cFilAnt

Default lLibCpo := .T.

Do Case
	Case cCampo == "Codigo"
		If !Empty(cCBase)
			dbSelectArea( "SN1" )
			SN1->( dbSetOrder(1) )
			
			If SN1->( dbSeek( xFilial( "SN1" ) + cCbase + AllTrim( cItem ) ) )
				If SN1->N1_STATUS == "0"
					lRet := .F.
					Help(" ",1,"AF125CLAS",,STR0162,1,0) //"Bem não classificado.Verifique!"
				Else
					If !Empty( cItem )//Se o campo item não foi preenchido ainda
						dbSelectArea( "SNM" )
						SNM->( dbSetOrder(2) )
						SNM->( dbSeek( xFilial( "SNM" ) + cCBase + cItem ) )
						
						If SNM->( !Found()) .Or. SNM->NM_SITSOL != "1"
							dbSelectArea( "SN3" )
							SN3->( dbSetOrder(1) )
							SN3->( dbSeek( xFilial( "SN3" ) + cCBase + cItem ) )
							
							If SN3->N3_BAIXA == "0" .And. Empty( SN3->N3_DTBAIXA )
								cDescBem := SN1->N1_DESCRIC
								cN1_QTDE := SN1->N1_QUANTD
								cGrupo   := SN1->N1_GRUPO
								cLocal   := SN1->N1_LOCAL
								dbSelectArea( "SN3" )
								SN3->( dbSetOrder(1) )
								
								If SN3->( dbSeek( xFilial( "SN3" ) + cCBase + cItem + cTipo ) )
									cTipo		:= SN3->N3_TIPO
									cCCusto		:= SN3->N3_CCUSTO
									cCContab	:= SN3->N3_CCONTAB
									cCCorrec	:= SN3->N3_CCORREC
									cCDeprec	:= SN3->N3_CDEPREC
									cCDDepr		:= SN3->N3_CCDEPR
									cCDesp		:= SN3->N3_CDESP
									cCustBem	:= SN3->N3_CUSTBEM
									cCCCorr		:= SN3->N3_CCCORR
									cCCDesp		:= SN3->N3_CCDESP
									cCCCDep		:= SN3->N3_CCCDEP
									cCCCDES		:= SN3->N3_CCCDES
									cItBem		:= SN3->N3_SUBCCON
									cItCorr		:= SN3->N3_SUBCCOR
									cItDesp		:= SN3->N3_SUBCDEP
									cItCDep		:= SN3->N3_SUBCCDE
									cItCDes		:= SN3->N3_SUBCDES
									cClVlBem	:= SN3->N3_CLVLCON
									cClVlCor	:= SN3->N3_CLVLCOR
									cClVlDep	:= SN3->N3_CLVLDEP
									cClVlCDe	:= SN3->N3_CLVLCDE
									cClVlDes	:= SN3->N3_CLVLDES
									
									//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
									//³	 No caso de contas de Capital, nÆo vai a corre‡Æo monet ria.		³
									//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
									cPatrim  	:= SN1->N1_PATRIM
									nValor	 	:= IIf( cPatrim # "C" , SN3->N3_VORIG1 + SN3->N3_VRCACM1 + SN3->N3_AMPLIA1, SN3->N3_VORIG1 + SN3->N3_AMPLIA1 )
									nQtdeSn  	:= IIf( SN1->N1_QUANTD == 0, 1, SN1->N1_QUANTD )
									nQtdOrig 	:= nQtdeSn
									nQuant	 	:= nQtdeSn
									nCustoAtu 	:= nValor
									If SN3->N3_TIPO = "05" .Or. ( SN1->N1_PATRIM $ cN1TipoNeg ) .Or. ( SN3->N3_TIPO $ cN3TipoNeg )
										nVlrResid:= nValor + Abs( ( SN3->N3_VRDACM1 + SN3->N3_VRCDA1 ) )
									Else
										nVlrResid:= nValor - ( SN3->N3_VRDACM1 + SN3->N3_VRCDA1 )
									Endif
								EndIf
								
							Else
								Help(" ",1,"AF125BX",,STR0070,1,0)//"Ativo baixado."
								lRet := .F.
							EndIf
						Else
							lRet := .F.
							Help(" ",1,"AF125SOL",,STR0071,1,0)//"Ativo com solicitação pendente."
						EndIf
					EndIf
				EndIf
				// Verifica Local
				lLibCpo := AF060LibCpo(cCBase,cItem)
			Else
				lRet := .F.
				Help(" ",1,"AF125BEM",,STR0072,1,0)//"Código não cadastrado"
			EndIf
		EndIf
	Case cCampo == "Item"
		If !Empty(cCBase) .And. !Empty(cItem)
			dbSelectArea( "SN1" )
			SN1->( dbSetOrder(1) )
			
			If SN1->( dbSeek( xFilial( "SN1" ) + cCbase + cItem ) )
				If SN1->N1_STATUS == "0"
					lRet := .F.
					Help(" ",1,"AF125CLAS",,STR0162,1,0)  //"Bem não classificado.Verifique!"
				Else
					dbSelectArea( "SNM" )
					SNM->( dbSetOrder(2) )
					SNM->( dbSeek( xFilial( "SNM" ) + cCBase + cItem ) )
					
					If SNM->( !Found() ) .Or. SNM->NM_SITSOL != "1"
						dbSelectArea( "SN3" )
						SN3->( dbSetOrder(1) )
						SN3->( dbSeek( xFilial( "SN3" ) + cCBase + cItem ) )
						
						If SN3->N3_BAIXA == "0" .And. Empty( SN3->N3_DTBAIXA )
							cDescBem := SN1->N1_DESCRIC
							cN1_QTDE := SN1->N1_QUANTD
							cGrupo   := SN1->N1_GRUPO
							cLocal   := SN1->N1_LOCAL
							dbSelectArea("SN3")
							SN3->( dbSetOrder(1) )
							
							If SN3->( dbSeek( xFilial( "SN3" ) + cCBase + cItem + cTipo ) )	//"Codigo nao cadastrado"
								cTipo		:= SN3->N3_TIPO
								cCCusto		:= SN3->N3_CCUSTO
								cCContab	:= SN3->N3_CCONTAB
								cCCorrec	:= SN3->N3_CCORREC
								cCDeprec	:= SN3->N3_CDEPREC
								cCDDepr		:= SN3->N3_CCDEPR
								cCDesp		:= SN3->N3_CDESP
								cCustBem	:= SN3->N3_CUSTBEM
								cCCCorr		:= SN3->N3_CCCORR
								cCCDesp		:= SN3->N3_CCDESP
								cCCCDep		:= SN3->N3_CCCDEP
								cCCCDES		:= SN3->N3_CCCDES
								cItBem		:= SN3->N3_SUBCCON
								cItCorr		:= SN3->N3_SUBCCOR
								cItDesp		:= SN3->N3_SUBCDEP
								cItCDep		:= SN3->N3_SUBCCDE
								cItCDes		:= SN3->N3_SUBCDES
								cClVlBem	:= SN3->N3_CLVLCON
								cClVlCor	:= SN3->N3_CLVLCOR
								cClVlDep	:= SN3->N3_CLVLDEP
								cClVlCDe	:= SN3->N3_CLVLCDE
								cClVlDes	:= SN3->N3_CLVLDES
								
								//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
								//³	 No caso de contas de Capital, nÆo vai a corre‡Æo monet ria.		³
								//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
								cPatrim  	:= SN1->N1_PATRIM
								nValor	 	:= IIf( cPatrim # "C", SN3->N3_VORIG1 + SN3->N3_VRCACM1 + SN3->N3_AMPLIA1, SN3->N3_VORIG1 + SN3->N3_AMPLIA1 )
								
								nQtdeSn  	:= IIf( SN1->N1_QUANTD == 0, 1, SN1->N1_QUANTD )
								nQtdOrig 	:= nQtdeSn
								nQuant	 	:= nQtdeSn
								nCustoAtu 	:= nValor
								If SN3->N3_TIPO = "05" .Or. ( SN1->N1_PATRIM $ cN1TipoNeg ) .Or. ( SN3->N3_TIPO $ cN3TipoNeg )
									nVlrResid:= nValor + Abs( ( SN3->N3_VRDACM1 + SN3->N3_VRCDA1 ) )
								Else
									nVlrResid:= nValor - ( SN3->N3_VRDACM1 + SN3->N3_VRCDA1 )
								Endif
							EndIf
							
						Else
							lRet := .F.
							Help(" ",1,"AF125BX",,STR0070,1,0)//"Ativo baixado."
						EndIf
					Else
						lRet := .F.
						Help(" ",1,"AF125SOL",,STR0071,1,0)//"Ativo com solicitação pendente."
					EndIf
				EndIf
				// Verifica Local
				lLibCpo := AF060LibCpo(cCBase,cItem)
			Else
				lRet := .F.
				Help(" ",1,"AF125BEM",,STR0072,1,0)//"Código não cadastrado"
			EndIf
		EndIf
	Case cCampo == "GeraNF"
		If  cGERANF == "2"
			cClasNFE	:= ""
			cTESNFS		:= CRIAVAR( "NM_TESNFS" )
			cTESNFE		:= CRIAVAR( "NM_TESNFE" )
			cNota		:= CRIAVAR( "NM_NOTA" )
			cSerie		:= CRIAVAR( "NM_SERIE" )
			
		EndIf
		
	Case cCampo == "TESNFS"
		If cGeraNF == "1"
			If !Empty( cTESNFS )
				dbSelectArea( "SF4" )
				SF4->(dbGoTop())
				If SF4->(dbSeek( xFilial( "SF4" ) + cTESNFS ) )
					If SF4->F4_TIPO == "E"
						lRet := .F.
						Help(" ",1,"AF125TESS",,STR0139,1,0)	//"A TES utilizada deve ser de saída!"  
					ElseIf SF4->F4_ATUATF == "S" .Or. SF4->F4_ESTOQUE == "S"
						lRet := .F.
						Help(" ",1,"AF125TESDUP",,STR0140,1,0)//"A TES utilizada não pode gerar duplicata, atualizar estoque ou atualizar ativo fixo!"
					EndIf
				Else
					lRet := .F.
					Help(" ",1,"AF125TESENC",,STR0141,1,0)	//"TES não encontrada!"
				EndIf
			Else
				lRet := .F.
				Help(" ",1,"AF125TESOBG",,STR0142,1,0)	//"Preencha o campo TES!"
			EndIf
		EndIf
	Case cCampo == "TESNFE"
		If cGeraNF == "1"
			//ATENCAO! Alteracao do valor da variavel publica cFilAnt
			If _cFilOri != cFilDest
				cFilAnt := cFilDest
			EndIf
			If !Empty( cTESNFE )
				dbSelectArea( "SF4" )
				SF4->(dbGoTop())
				If SF4->(dbSeek( xFilial( "SF4" ) + cTESNFE ) )
					If SF4->F4_TIPO == "S"
						lRet := .F.
						Help(" ",1,"AF125TESE",,STR0145,1,0)	//"A TES utilizada deve ser de entrada!"
					ElseIf SF4->F4_ATUATF == "S" .Or. SF4->F4_DUPLIC == "S" .Or. SF4->F4_ESTOQUE == "S"
						lRet := .F.
						Help(" ",1,"AF125TESDUP",,STR0140,1,0)//"A TES utilizada não pode gerar duplicata, atualizar estoque ou atualizar ativo fixo!"
					EndIf
				Else
					lRet := .F.
					Help(" ",1,"AF125TESENC",,STR0141,1,0)	//"TES não encontrada!"
				EndIf
			Else
				lRet := .F.
				Help(" ",1,"AF125TESOBG",,STR0142,1,0)	//"Preencha o campo TES!"
			EndIf
			//ATENCAO! Retorno do valor da variavel publica cFilAnt
			If cFilAnt	!= _cFilOri
				cFilAnt	:= _cFilOri
			EndIf
		EndIf
		
EndCase

RestArea( aArea )

Return lRet

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³A125TrFlDst ºAutor  ³Marcos R. Pires   º Data ³  02/08/10   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ Ao trocar a filial se os campos das entidades destino      º±±
±±º          ³ estiverem preenchidos sao zerados                          º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ SigaAtf                                                    º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
Function A125TrFlDst(cFilDest,aEntDst,cFilDstOld,cCCustoDst,cLOCALDst,cDsCContab,cDsCCorrec,;
cDsCDeprec,cDsCDDepr,cDsCDesp,cDsCustBem,cDsCCCORR,;
cDsCCDesp,cDsCCCDep,cDsCCCDES,cDsItBem,cDsItCorr,cDsItDesp,;
cDsItCDep,cDsItCDes,cDsClVlBem,cDsClVlCor,cDsClVlDep,;
cDsClVlCDe,cDsClVlDes)

Local aArea := GetArea()
Local nX	:= 0
Local nY	:= 0

If cFilDest != cFilDstOld
	cCCustoDst	:= CriaVar( "NM_CCUSTO" )
	cLOCALDst	:= CriaVar( "NM_LOCAL" )
	For nX := 1 to Len(aEntDst)
		For nY := 1 to Len(aEntDst[nX])
			aEntDst[nX][nY][2] := CriaVar(aEntDst[nX][nY][1])
		Next nY
	Next nX
	cDsCContab  := cDsCCorrec := cDsCDeprec := cDsCDDepr :=	cDsCDesp := ""
	cDsCustBem	:= cDsCCCORR := cDsCCDesp := cDsCCCDep := cDsCCCDES	:= ""
	cDsItBem	:= cDsItCorr := cDsItDesp := cDsItCDep := cDsItCDes	:= ""
	cDsClVlBem	:= cDsClVlCor := cDsClVlDep := cDsClVlCDe := cDsClVlDes := ""
	
	cFilDstOld := cFilDest
EndIf

RestArea( aArea )

Return .T.


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³A125VlRspWF ºAutor  ³Marcos R. Pires   º Data ³  02/08/10   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ Valida e-mail para envio do WorkFlow de solicitacao de     º±±
±±º          ³ aprovacao.                                                 º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ SigaATF                                                    º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
Function A125VlRspWF( cCBase, cItem )

Local aArea     := GetArea()
Local cMsg      := ""
Local lContinua := .F.
Local cVarSX6

aEmailSol := {} //Zerar vetor para adicionar novos aprovadores

dbSelectArea( "SND" )	//Tabela de cadastro de Responsáveis pelos bens
SND->(dbSetOrder(2))

If SND->( dbSeek( xFilial( "SND" ) + cCBase + cItem ) )
	
	dbSelectArea( "RD0" )	//Tabela de cadastro de participantes
	RDO->(dbSetOrder(1))
	
	While ( SND->(!Eof()) ) .And. ( SND->ND_CBASE == cCBase ) .And. ( SND->ND_ITEM  == cItem )
		
		//Se responsável está Ativo
		If	SND->ND_STATUS == "1"
			If RD0->( MsSeek( xFilial( "RD0" ) + SND->ND_CODRESP ) )
				If !Empty( RD0->RD0_EMAIL )
					aAdd( aEmailSol, { RD0->RD0_EMAIL, RD0->RD0_CODIGO, .T. } )
				Endif
			End
		Endif
		
		SND->(DbSkip())
	End
	
	If !Empty( aEmailSol )
		lContinua := .T.
	Else
		lContinua := .F.
		cMsg := STR0057	//"Ausência do endereço de e-mail no cadastro do responsável pelo Ativo."
	EndIf
	
Else
	cMsg := STR0058	//"Ausência de responsável pelo Ativo para envio de e-mail de solicitação de aprovação."
EndIf

If !lContinua
	
	cMsg += CRLF
	cMsg += STR0151 + cCBase +  STR0152 + cItem  //" Código do Ativo: " ## " Código do Item do Ativo: " 
	
	If  MsgYesNo( cMsg + CRLF + STR0059, STR0021 )	//"Deseja enviar e-mail de solicitação para o responsável padrão dos Ativos Imobilizados?" / "Atencao"
		cVarSX6 := SuperGetMV( "MV_ATFRESP", .F., "" )
		If !Empty(cVarSX6)
			PswOrder(1)
			If PswSeek(cVarSX6)
				If Alltrim( PswRet()[1,14] ) == ""
					lContinua := .F.
				Else
					aEmailSol := { { PswRet()[1,14], cVarSX6, .F. } }
					lContinua := .T.
				EndIf
			Endif
		Else
			lContinua := .F.
			Help(" ",1,"AF125RESP",,STR0060,1,0)	//"Responsavel padrão dos Ativos não preenchido."
		Endif
	Else
		lContinua := .F.
	EndIf
EndIf

If !lContinua
	Help(" ",1,"AF125MAIL",,STR0061,1,0)//"Nao há e-mail cadastrado para envio da solicitação de aprovação!"
EndIf

RestArea( aArea )

Return( lContinua )


//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Rotina WorkFlow Solicitacao Baixa - INICIO ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Funcao    ³ A125WfBx  ³ Autor ³ Darlan Maciel         ³ Data ³ 08/12/09 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descricao ³ Chamada da(s) rotina(s) de WorkFlow                        ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
Function A125WfBx( cCodSol )

//Salva ambiente atual
Local aArea     := GetArea()
Local lRet		:= .T.
Local _cEmp		:= cEmpAnt
Local _cFil		:= cFilAnt
Local cTmp      := ''
Local cPCAnt    := ''
Local cAprov    := ''
Local cPedido	:= ''
Local aSolBx    := {}
Local nX		:= 0
Local nI        := 0
Local nPos      := 0
Local nQtdReg   := 0
Local cTitulo   := ''
Local cNumEmp	:= ''
Local cDirHTTP	:= ''
Local cWFID		:= ''
Local cCotAnt	:= ''
Local aCot		:= {}
Local aCond		:= {}
Local cForAnt	:= ''
Local _cNmCli	:= ""
Local _cClNF	:= ""
Local _cCondPg	:= ""
Local _cGeraNF	:= ""

cDirHTTP := AllTrim( SuperGetMV( "MV_ATFHTTP", , "\web\ws" ) )

ConOut( " " )
ConOut( '[INICIO DO WorkFlow FMTW001]' + '[EMPRESA '+_cEmp+']' )
ConOut(	"********************************************************************"+ CRLF +;
"*   I N I C I O   W O R K F L O W   P A R A   E M P R E S A:["+_cEmp+"]   *"+ CRLF +;
"********************************************************************" )

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Dispara WF de Aprovacao de solicitacao de baixa ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
cTmp	  := ''
cPCAnt	  := ''
cAprov	  := ''
cNumEmp	  := ''
nI		  := 0
nPos	  := 0
cTitulo	  := STR0062	//'Aprovação da Solicitação de Baixa'
aMotivos  := {}
cCapital  := ""
cDesMotBx := ""

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Verifica tabela de motivos para baixa ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
dbSelectArea( "SX5" )
SX5->( dbSeek( xFilial( "SX5" ) + "16" ) )

While SX5->X5_FILIAL + SX5->X5_TABELA == xFilial("SX5") + "16"
	If !( Alltrim(SX5->X5_CHAVE) $ '13/15/16/17')
		cCapital := Capital( X5Descri() )
		aAdd( aMotivos, Left( SX5->X5_CHAVE, 2 ) + "=" + SubStr( cCapital, 1, 12 ) )
	EndIf
	SX5->( dbSkip() )
End

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Prepara a solicitacao de baixa ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
dbSelectArea( 'SM0' )
SM0->( dbSetOrder( 1 ) )

If SM0->( dbSeek( _cEmp + _cFil, .T. ) )
	
	cFilAnt := SM0->M0_CODFIL
	cNumEmp := SM0->( M0_CODIGO + M0_CODFIL )
	
	ConOut( '' )
	ConOut( '[WorkFlow] - Empresa '  + _cEmp + '/' + cFilAnt + ' - Iniciado ' + cTitulo )
	
	cTmp := GetNextAlias()
	
	BeginSql Alias cTmp
		
		SELECT SNM.NM_CODIGO , SNM.NM_GERANF , SNM.R_E_C_N_O_ RECNOSNM,
		SNM.NM_USRSOL , SNM.NM_MOTBX  , SNM.NM_VLVENDA, SNM.NM_CLASNFE, SNM.NM_CLIENTE,
		SNM.NM_LOJA   , SNM.NM_NOTA   , SNM.NM_SERIE  , SNM.NM_TESNFS , SNM.NM_CONDPG ,
		SNM.NM_CBASE  , SNM.NM_ITEM   , SNM.NM_TIPO   , SN1.N1_DESCRIC, SNM.NM_QTDBX  ,
		SNM.NM_VLRBAIX, SNM.NM_LOCAL  , SNM.NM_GRUPO  , SNM.NM_CCUSTO , SNM.NM_CDHSOL ,
		SA1.A1_NOME   , SE4.E4_DESCRI , SF4.F4_TEXTO  , SN1.N1_CHAPA
		FROM %table:SNM% SNM
		JOIN %table:SN1% SN1 ON
		SN1.N1_FILIAL = %xFilial:SN1%
		AND SN1.N1_CBASE = SNM.NM_CBASE
		AND SN1.N1_ITEM = SNM.NM_ITEM       //Marcio Douglas - 04/10/10
		AND SN1.%notDel%
		LEFT JOIN %table:SA1% SA1 ON
		SA1.A1_FILIAL = %xFilial:SA1%
		AND SA1.A1_COD = SNM.NM_CLIENTE
		AND SA1.A1_LOJA = SNM.NM_LOJA
		AND SA1.%notDel%
		LEFT JOIN %table:SE4% SE4 ON
		SE4.E4_FILIAL = %xFilial:SE4%
		AND SE4.E4_CODIGO = SNM.NM_CONDPG
		AND SE4.%notDel%
		LEFT JOIN %table:SF4% SF4 ON
		SF4.F4_FILIAL = %xFilial:SF4%
		AND SF4.F4_CODIGO = SNM.NM_TESNFS
		AND SF4.%notDel%
		WHERE SNM.NM_FILIAL = %xFilial:SNM%
		AND SNM.NM_CODIGO = %exp:cCodSol%
		AND SNM.NM_SITSOL = '1'
		AND SNM.%notDel%
		ORDER BY SNM.NM_CBASE, SNM.NM_ITEM
		
	EndSql
	
	
	cDesMotBx := aMotivos[ Val( (cTmp)->NM_MOTBX ) ]
	_cNmCli	  := (cTmp)->A1_NOME
	_cCondPg  := (cTmp)->E4_DESCRI
	_cGeraNF  := If( (cTmp)->NM_GERANF == "1", STR0040, STR0041 )	//"Sim" | "Não"
	
	While !(cTmp)->( EOF() )
		
		If ( nPos := aScan( aSolBx, { |x| x == (cTmp)->NM_CODIGO } ) ) == 0
			aSolBx := {  ;
			""								,;// 01 E-Mail Aprovador
			(cTmp)->NM_CODIGO				,;// 02 Nro Solicitacao
			USRFULLNAME((cTmp)->NM_USRSOL)	,;// 03 Solicitante
			cDesMotBx						,;// 04 Mot. Baixa
			(cTmp)->NM_VLVENDA				,;// 05 Vlr.Venda
			_cGeraNF						,;// 06 GeraNFS
			(cTmp)->NM_CLASNFE				,;// 07 Tip Clas NFE
			MSMM((cTmp)->NM_CDHSOL,80)		,;// 08 Observacao Solicitante
			_cNmCli							,;// 09 Cliente
			(cTmp)->NM_LOJA	    			,;// 10 Loja
			(cTmp)->NM_NOTA					,;// 11 Num. NF
			(cTmp)->NM_SERIE				,;// 12 Serie
			(cTmp)->F4_TEXTO				,;// 13 Tes Saida
			_cCondPg						,;// 14 Cond. Pgto.
			{}								,;// 15 Itens
			(cTmp)->RECNOSNM				,;// 16 Recno
			"" }							  // 17 Cod Aprovador
		EndIf
		
		aAdd( aSolBx[15], { ;
		(cTmp)->NM_CBASE		,; // 1 Codigo do Bem
		(cTmp)->NM_ITEM			,; // 2 Item
		(cTmp)->NM_TIPO			,; // 3 Tipo
		(cTmp)->N1_DESCRIC		,; // 4 Descricao
		(cTmp)->NM_QTDBX		,; // 5 Quantidade
		(cTmp)->NM_VLVENDA		,; // 6 Valor
		(cTmp)->NM_LOCAL		,; // 7 Local
		(cTmp)->NM_GRUPO		,; // 8 Grupo
		(cTmp)->NM_CCUSTO		,; // 9 Centro Custo
		(cTmp)->N1_CHAPA		}) // 10  Numero da Plaqueta - Marcio Douglas (07/10/10)
		
		(cTmp)->( dbSkip() )
		
	EndDo // EOF
	
	For nX := 1 To Len( aEmailSol )
		aSolBx[1] := aEmailSol[nX,1]
		aSolBx[17] := aEmailSol[nX,2]
		lRet := WFSBAprov( 1, , aSolBx )
	Next nX
	
	(cTmp)->( dbCloseArea() )
	
	ConOut( '[WorkFlow] - Empresa '  + _cEmp + '/' + cFilAnt + ' - Finalizado ' + cTitulo )
Endif

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Finaliza ambiente                                            ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
//FreeUsedCode()
ConOut( '' )
ConOut(	"********************************************************************"+ CRLF +;
"*      F I M   W O R K F L O W   P A R A   E M P R E S A:["+_cEmp+"]      *"+ CRLF +;
"********************************************************************" )

//Restaura o ambiente anterior
RestArea( aArea )

Return lRet

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºFuncao    ³WFPCAprov º Autor ³ Darlan Maciel      º Data ³  08/12/09   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDescricao ³ WorkFlow do pedido de compra para aprovacao via HTTPRET    º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³                                                            º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
Function WFSBAprov( nOpc, oWF, aSolBx )

Local aArea      := GetArea()
Local lRet 		 := .T.
Local nI         := 0
Local cObs     	 := ''
Local cWFID      := ''
Local cCDAPROV   := ''
Local nTamObs    := 80
Local eMailApv	 := ''
Local oHTML		 := NIL
Local cAprov	 := ''
Local cOpc		 := ""
Local dDtApvRej	 := dDataBase
Local dHrApvRej	 := StrTran( Left( Time(), 5), ':', '' )
Local cCodApvRej := ""
Local cMensagem	 := ""`
Local cUsrSol	 := ""
Local cEmailUsr	 := ""
Local cHtmlMod   := AllTrim( SuperGetMV( 'MV_ATFASBX', , '\Workflow\Modelos\SolBxAprovac.htm' ) )
Local cLinkMod	 := AllTrim( SuperGetMV( 'MV_ATFAAPS', , '\Workflow\Modelos\AvisoSolAprovac.htm' ) )
Local cDirHTTP	 := AllTrim( SuperGetMV( 'MV_ATFHTTP', , '\web\ws' ) )
Local cUrlWF 	 := ""
Local cMailID    := " "
Local cAssunto
Local cHtmlAction
Local cCodSol    := ""

//Valida conteúdo dos parâmetros necessários ao envio da solicitação
If lRet .And. !File( cHTMLMod )
	lRet := .F.
	Help(" ",1,"AF125HT1",,STR0132 + "'",1,0)	//"Modelo de solicitação de baixa não encontrado, verifique parâmetro MV_ATFASBX."
EndIf

If lRet .And. !File( cLinkMod )
	lRet := .F.
	Help(" ",1,"AF125HT2",,STR0134 + "'",1,0)	//"Modelo de aprovação de solicitação não encontrado, verifique parâmetro MV_ATFAAPS."
EndIf

If lRet .And. !ExistDir( cDirHTTP )
	lRet := .F.                                                                                       
	Help(" ",1,"AF125HT3",,STR0135 + "'",1,0)	// "Diretório do servidor HTTP não encontrado, verifique parâmetro MV_ATFHTTP."
EndIf

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Envio do WF - nOpc = 1 ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
If lRet
	If nOpc == 1
		
		Conout( "[WF:ENVIO DE APROVACAO SOLICITACAO DE BAIXA]" )
		
		//obtem o url que vai no link via e-mail
		cUrlWF 	    := AllTrim( SuperGetMV( "MV_ATFURL", , "http://localhost:8082/ws/" ) )
		cHtmlAction := If( cUrlWF == "", "http://localhost:8082/ws/WFHTTPRET.APL", cUrlWF + "WFHTTPRET.APL" )
		cAssunto    := STR0092 + " - " + STR0093 + aSolBx[2]	//"Aprovação da solicitação de baixa" + " - " + "Número"
		
		//codigo e email do aprovador
		cAprov	 := aSolBx[17]
		eMailApv := aSolBx[1]
		
		If Right( cUrlWF, 1) != "/"
			cUrlWF += "/"
		EndIF
		
		//inicia a classe TWFProcess e assinala a variável objeto oProcess
		oWF := TWFProcess():New( '100100' , cAssunto)
		
		//cria uma tarefa
		oWF:NewTask( '100100' , cHtmlMod  )
		oWF:cSubject := cAssunto
		oWF:bReturn  := "WFSBAprov(2)"
		
		If Empty( eMailApv )
			ConOut( STR0061 + CRLF + STR0094 + ": " + aSolBx[17] + CRLF + STR0003 + ": " + aSolBx[2] )	//"Nao há e-mail cadastrado para envio da solicitação de aprovação!"
			oWF:Track( '100100', STR0061 + CRLF + STR0094 + ": " + UsrRetName( aSolBx[17] ) + CRLF + STR0003 + ": " + aSolBx[2], aSolBx[17] )
		Else
			
			oWF:cTo			:= eMailApv
			oWF:UserSiga	:= __cUserId
			cWFID			:= oWF:fProcessID + oWF:fTaskId
			oHtml			:= oWF:oHTML
			
			//Cabeçalho da solicitação
			oHtml:ValByName( 'cHtmlAction', cHtmlAction )
			
			oHtml:ValByName( 'WNumSol'	, aSolBx[2]	)
			oHtml:ValByName( 'WSolic'	, aSolBx[3]	)
			oHtml:ValByName( 'WMotBx'	, aSolBx[4]	)
			oHtml:ValByName( 'WGeraNF'	, aSolBx[6]	)
			oHtml:ValByName( 'WVlVend'	, aSolBx[5]	)
			oHtml:ValByName( 'WObsSol'	, aSolBx[8]	)
			oHtml:ValByName( 'WClient'	, aSolBx[9]	)
			oHtml:ValByName( 'WLoja'	, aSolBx[10])
			oHtml:ValByName( 'WNumNF'	, aSolBx[11])
			oHtml:ValByName( 'WSerie'	, aSolBx[12])
			oHtml:ValByName( 'WTESSaida', aSolBx[13])
			oHtml:ValByName( 'WCondPgto', aSolBx[14])
			
			//Itens da solicitação
			For nI := 1 To Len( aSolBx[15] )
				aAdd( (oHtml:ValByName( 'it.1') ), aSolBx[15][nI][1])
				aAdd( (oHtml:ValByName( 'it.2') ), aSolBx[15][nI][2])
				aAdd( (oHtml:ValByName( 'it.3') ), aSolBx[15][nI][3])
				aAdd( (oHtml:ValByName( 'it.4') ), aSolBx[15][nI][4])
				aAdd( (oHtml:ValByName( 'it.5') ), aSolBx[15][nI][5])
				aAdd( (oHtml:ValByName( 'it.6') ), aSolBx[15][nI][6])
				aAdd( (oHtml:ValByName( 'it.7') ), aSolBx[15][nI][7])
				aAdd( (oHtml:ValByName( 'it.8') ), aSolBx[15][nI][8])
				aAdd( (oHtml:ValByName( 'it.9') ), aSolBx[15][nI][9])
				aAdd( (oHtml:ValByName( 'it.10') ), aSolBx[15][nI][10])
			Next
			
			//Hidden Fields
			oHtml:ValByName( 'Wemp'		, cEmpAnt	)
			oHtml:ValByName( 'Wfil'		, cFilAnt	)
			oHtml:ValByName( 'WFID'		, cWFID		)
			oHtml:ValByName( 'WFaprcod' , cAprov	)
			
			oWF:oWF:lHtmlBody := .T.
			oWF:oWF:lSendAuto := .F.
			
			//INICIA O PROCESSO
			cMailID	:= oWF:Start( cDirHTTP )
			
			//inicia a classe TWFProcess e assinala a variável objeto oProcess
			oWF := TWFProcess():New( '100100' , cAssunto)
			oWF:oWF:lSendAuto := .T.
			//COMECA AGORA A MONTAR A MENSAGEM QUE VAI NO E-MAIL DOS FORNECEDORES.
			oWF:NewTask( '100130' , cLinkMod )
			oWF:cSubject := '[Link] ' + cAssunto
			
			eMailApv := aSolBx[1]
			//INFORMA O ENDERECO ELETRONICO DO FORNECEDOR.
			oWF:cTo := eMailApv
			
			//assinalar valores das macros do html
			oWF:ohtml:ValByName( "cContato" , Posicione( "RD0", 1, xFilial( "RD0" ) + aSolBx[17], "RD0_NOME" ) )
			oWF:ohtml:ValByName( "cNumPC"   , aSolBx[2] )
			oWF:ohtml:ValByName( "proc_link", cUrlWF + cMailID + ".htm")
			oWF:ohtml:ValByName( "titulo"   , STR0023 )	//"Solicitação de Baixa"
			oWF:Start()
						
			ConOut("(INICIO -> OK <- (Aprovacao da solicitacao de baixa)Processo: " + cWFID )
			
			Begin Transaction
			dbSelectArea( "SNM" )
			SNM->( dbSetOrder(1) )
			SNM->( dbSeek( xFilial( "SNM" ) + aSolBx[2] ) )
			
			While SNM->NM_FILIAL == xFilial( "SNM" ) .And. SNM->NM_CODIGO == aSolBx[2]
				RecLock( "SNM", .F. )
				SNM->NM_WFID := cWFID
				SNM->( dbSkip() )
				SNM->( MsUnLock() )
			EndDo
			End Transaction
		EndIf
		
		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³ Retorno do WF - nOpc = 2                                     ³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	ElseIf nOpc == 2 // Retorno
		
		cEmpAnt	 := AllTrim( oWF:oHtml:RetByName( 'Wemp' )					     ) //Empresa
		cFilAnt	 := AllTrim( oWF:oHtml:RetByName( 'Wfil' )					     ) //Filial
		cOpc	 := AllTrim( oWF:oHtml:RetByName( 'RBAPROVA' )				     ) //Aprova S/N
		cObs	 := SubStr( AllTrim( oWF:oHtml:RetByName( 'Wobs' ) ), 1, nTamObs ) //Obs. Aprov/Rej
		cWFID	 := AllTrim( oWF:oHtml:RetByName( 'WFID' )				         ) //ID do WorkFlow
		cCDAPROV := AllTrim( oWF:oHtml:RetByName( 'WFaprcod' ) 				     ) //Codigo do usuario Apv/Rej
		
		ConOut( 'WFReturn - Retorno da Aprovacao da Solicitacao de Baixa' )
		ConOut( 'WF Id....: ' + cWFID )
		ConOut( 'cEmpAnt..: ' + cEmpAnt )
		ConOut( 'cFilAnt..: ' + cFilAnt )
		ConOut( 'cCDAPROV.: ' + cCDAPROV )
		
		
		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³ Ponto de entrada no retorno do WF de Baixa                   ³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		If ExistBlock( "AT125RTB" )
			ExecBlock( "AT125RTB", .F., .F., cFilAnt + cWFID )
		EndIf
		
		dbSelectArea( "SNM" )
		SNM->( dbSetOrder(3) )
		If SNM->( dbSeek( xFilial("SNM") + cWFID ) )
			
			cCodSol := SNM->NM_CODIGO
			
			If SNM->NM_SITSOL == '1' //Se Pendente
				
				If cOpc == 'S'  // Aprovar
					
					lLiberou := ATFA126Grava( 3, .T./*lWFProc*/ )	//FUNCAO QUE IRA FAZER A BAIXA E DEMAIS PROCESSOS
					
					Conout(lLiberou)
					ConOut( 'Aprovado.: ' + cOpc )
					ConOut( 'Solicitacao de Baixa ' + SNM->NM_CODIGO + ' aprovado por ' + cCDAPROV )
					
					If lLiberou
						
						dbSelectArea( "SNM" )
						SNM->( dbSetOrder(1) )
						SNM->( dbSeek( xFilial( "SNM" ) + cCodSol ) )      //Marcio Douglas - 04/10/10
						MSMM( SNM->NM_CDHREJ, , , cObs, 1, , , "SNM", "NM_CDHREJ" )
						cCodApvRej := SNM->NM_CDHREJ
						cUsrSol	   := SNM->NM_USRSOL
						
						While SNM->(!EOF()) .AND. xFilial( "SNM" ) + cCodSol == SNM->NM_FILIAL + SNM->NM_CODIGO
							RecLock( "SNM", .F. )
							
							SNM->NM_USRAPV	:=	cCDAPROV
							SNM->NM_DTAPVRE	:=	dDtApvRej
							SNM->NM_HRAPVRE	:=	dHrApvRej
							SNM->NM_CDHREJ 	:=  cCodApvRej
							SNM->NM_SITSOL	:=	"2"
							
							SNM->( MsUnlock() )
							
							SNM->( dbSkip() )
						EndDo
						
						cMensagem := STR0092 + " " + cCodSol	//"Aprovação da solicitação de baixa"
						cEmailUsr := Posicione( "RD0", 1, xFilial( "RD0" ) + cUsrSol, "RD0_EMAIL" )
						
						If !Empty( cEmailUsr )
							FSSendMail( cEmailUsr, STR0023 + " - " + cCodSol, cMensagem )	//"Solicitação de Baixa"
						Else
							Conout( STR0095 + ": " + cUsrSol )	//"E-mail não cadastrado para o solicitante de código"
						EndIF
						
					EndIf
					
					//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
					//³ Apaga o arquivo HTML que foi criado para envio           ³
					//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
					aFile := Directory( cDirHTTP + '\' + cWFID + "*.htm" ) // pode ser com coringa tipo *.txt
					If Len(aFile) > 0
						For nI := 1 to Len(aFile)
							cFile := cDirHTTP + '\' + aFile[nI][1]
							If File( cFile )
								If FErase( cFile ) == -1
									Conout( STR0096 + cFile )	//"Erro ao apagar o arquivo HTML"
								Endif
							EndIf
						Next nI
					EndIf
					
				ElseIf cOpc == 'N' // Rejeitar
					ConOut( STR0011 + ".: " + cOpc )	//"Rejeitada"
					ConOut( STR0023 + " " + Posicione( "SNM", 3, xFilial( "SNM" ) + cWFID, "NM_CODIGO" ) + " " + STR0097 + " " + cCDAPROV )	//"Solicitação de Baixa" | "rejeitado por"
					
					dbSelectArea( "SNM" )
					SNM->( dbSetOrder(1) )
					SNM->( dbSeek( xFilial("SNM") + cCodSol ) )
					
					MSMM( SNM->NM_CDHREJ, , , cObs,1, , , "SNM", "NM_CDHREJ" )
					cCodApvRej := SNM->NM_CDHREJ
					cUsrSol	   := SNM->NM_USRSOL
					
					While SNM->(!EOF()) .AND. xFilial( "SNM" ) + cCodSol == SNM->NM_FILIAL + SNM->NM_CODIGO
						RecLock( "SNM", .F. )
						SNM->NM_USRAPV	:= cCDAPROV
						SNM->NM_DTAPVRE	:= dDtApvRej
						SNM->NM_HRAPVRE	:= dHrApvRej
						SNM->NM_CDHREJ 	:= cCodApvRej
						SNM->NM_SITSOL	:= "3"
						SNM->( MsUnlock() )
						
						SNM->( dbSkip() )
					EndDo
					
					//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
					//³ Apaga o arquivo HTML que foi criado para envio           ³
					//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
					aFile := Directory( cDirHTTP + '\' + cWFID +"*.htm" ) // pode ser com coringa tipo *.txt
					
					If Len(aFile) > 0
						For nI := 1 to Len(aFile)
							cFile := cDirHTTP + '\' + aFile[nI][1]
							If File(cFile)
								If FErase(cFile) == -1
									Conout( STR0096 + cFile )	//"Erro ao apagar o arquivo HTML"
								Endif
							EndIf
						Next nI
					EndIf
					
					cMensagem := STR0098 = " " + cCodSol	//"Rejeição da solicitação de baixa"
					
					cEmailUsr := Posicione( "RD0", 1, xFilial( "RD0" ) + cUsrSol, "RD0_EMAIL" )
					
					If !Empty( cEmailUsr )
						FSSendMail( cEmailUsr, STR0023 + " " + cCodSol, cMensagem )
					Else
						Conout( STR0095 + ": " + cUsrSol )	//"E-mail não cadastrado para o solicitante de código"
					EndIF
					
				Else
					ConOUT( 'Erro no tratamento do RADIO BOX valor retornado: ' + cOpc)
				EndIf
			Else
				ConOut( STR0023 + " [" + SNM->NM_CODIGO + "] " + STR0099 )	//"Respondido anteriormente ou respondido por outro usuário"
			EndIf
		Else
			ConOut( STR0100 + CRLF +;		//"Registro de liberação do título não encontrado."
			STR0101 + ": [" + cFilAnt + "] " + STR0102 + ":\ [" + cWFID + "]" )	//"Filial" | "Workflow ID"
		EndIf
	EndIf
EndIf

RestArea( aArea )

Return lRet

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Rotina WorkFlow Solicitacao Baixa - FIM ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Rotina WorkFlow Solicitacao Transferencia - INICIO ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Funcao    ³ A125WfTr  ³ Autor ³                      ³ Data ³ 08/12/09 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descricao ³ Chamada da(s) rotina(s) de WorkFlow Transferencia          ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
Function A125WfTr( cCodSol )

Local aArea     := GetArea()
Local _cEmp		:= cEmpAnt
Local _cFil		:= cFilAnt
Local cTmp      := ''
Local cPCAnt    := ''
Local cAprov    := ''
Local cPedido	:= ''
Local aSolTr    := {}
Local nI        := 0
Local nPos      := 0
Local nQtdReg   := 0
Local cTitulo   := ''
Local cNumEmp   := ''
Local cDirHTTP	:= ''
Local cWFID	    := ''
Local cCotAnt   := ''
Local aCot      := {}
Local aCond     := {}
Local cForAnt   := ''
Local _cNmCli	:= ""
Local _cClNF	:= ""
Local _cCondPg	:= ""
Local _cGeraNF	:= ""
Local nX		:= 0
Local aEmailPE	:=	{}

cDirHTTP := AllTrim( SuperGetMV( "MV_ATFHTTP", , '\web\ws' ) )

ConOut( " " )
ConOut( '[INICIO DO WorkFlow FMTW002]' + '[EMPRESA '+_cEmp+']' )
ConOut(	"********************************************************************"+ CRLF +;
"*   I N I C I O   W O R K F L O W   P A R A   E M P R E S A:["+_cEmp+"]   *"+ CRLF +;
"********************************************************************" )

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Dispara WF de Aprovacao de solicitacao de transferencia ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
cQuery     := ""
cTmp       := ""
cPCAnt     := ""
cNumEmp    := ""
nI         := 0
nPos       := 0
cTitulo    := STR0062	//"Aprovação da Solicitação de Transferência"

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Prepara a solicitacao de transferencia ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
dbSelectArea( "SM0" )
SM0->( dbSetOrder( 1 ) )
If SM0->( dbSeek( _cEmp + _cFil, .T. ) )
	
	cFilAnt   := SM0->M0_CODFIL
	cNumEmp   := SM0->( M0_CODIGO + M0_CODFIL )
	
	ConOut( '' )
	ConOut( '[WorkFlow] - Empresa '  + _cEmp + '/' + cFilAnt + ' - Iniciado ' + cTitulo )
	
	cTmp   := GetNextAlias()
	cQuery := ""
	
	BeginSql Alias cTmp
		SELECT SNM.NM_CODIGO , SNM.NM_GERANF , SNM.NM_FILDEST, SNM.R_E_C_N_O_ RECNOSNM,
		SNM.NM_USRSOL , SNM.NM_CLASNFE, SNM.NM_CLIENTE, SNM.NM_LOCAL  ,
		SNM.NM_LOJA   , SNM.NM_NOTA   , SNM.NM_SERIE  , SNM.NM_TESNFS ,
		SNM.NM_CBASE  , SNM.NM_ITEM   , SNM.NM_TIPO   , SN1.N1_DESCRIC,
		SNM.NM_LOCAL  , SNM.NM_GRUPO  , SNM.NM_CCUSTO , SNM.NM_CDHSOL ,
		SN1.N1_LOCAL  , SN3.N3_CCUSTO , SN1.N1_QUANTD , SN3.N3_VORIG1 ,
		SNM.NM_TESNFE , SN1.N1_CHAPA
		FROM %table:SNM% SNM
		JOIN %table:SN1% SN1 ON
		SN1.N1_FILIAL = %xFilial:SN1%
		AND SN1.N1_CBASE = SNM.NM_CBASE
		AND SN1.N1_ITEM  = SNM.NM_ITEM
		AND SN1.%notdel%
		JOIN %table:SN3% SN3 ON
		SN3.N3_FILIAL    = %xFilial:SN3%
		AND SN3.N3_CBASE = SNM.NM_CBASE
		AND SN3.N3_ITEM  = SNM.NM_ITEM
		AND SN3.N3_TIPO = SNM.NM_TIPO
		AND SN3.N3_BAIXA = '0'
		AND SN3.%notdel%
		WHERE SNM.NM_FILIAL = %xFilial:SNM%
		AND SNM.NM_CODIGO = %exp:cCodSol%
		AND SNM.NM_SITSOL = '1'
		AND SNM.%notdel%
		ORDER BY SNM.NM_CBASE, SNM.NM_ITEM
	EndSql
	
	_cGeraNF := If( ( cTmp )->NM_GERANF == "1", STR0040, STR0041 )	//"Sim" | "Não"
	
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Monta Solicitacao de transferencia ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	While !(cTmp)->( EOF() )
		
		_cClNF := If( ( cTmp )->NM_CLASNFE == "1", STR0063, STR0064 )	//"A Classificar" | "Classificada"
		
		If ( nPos := aScan( aSolTr, { |x| x == ( cTmp )->NM_CODIGO } ) ) == 0
			aSolTr := {  ;
			""								,;// 01 Aprovador
			(cTmp)->NM_CODIGO				,;// 02 Nro Solicitacao
			USRFULLNAME((cTmp)->NM_USRSOL)	,;// 03 Solicitante
			_cGeraNF						,;// 04 GeraNFS
			_cClNF							,;// 05 Tip Clas NFE
			MSMM((cTmp)->NM_CDHSOL,80)		,;// 06 Observacao
			(cTmp)->NM_NOTA					,;// 07 Num. NF
			(cTmp)->NM_SERIE				,;// 08 Serie
			(cTmp)->NM_TESNFS				,;// 09 Tes Saida
			(cTmp)->NM_TESNFE				,;// 10 Tes Entrada
			(cTmp)->NM_CCUSTO				,;// 11 Centro de Custo Destino
			(cTmp)->NM_LOCAL				,;// 12 Local Destino
			{}								,;// 13 Itens
			(cTmp)->RECNOSNM                ,;// 14 Recno
			""								} //15 Emails e codigo
		EndIf
		
		aAdd( aSolTr[13], { ;
		(cTmp)->NM_CBASE		,; // 1 Codigo do Bem
		(cTmp)->NM_ITEM			,; // 2 Item
		(cTmp)->NM_TIPO			,; // 3 Tipo
		(cTmp)->N1_DESCRIC		,; // 4 Descricao
		(cTmp)->N1_QUANTD		,; // 5 Quantidade
		(cTmp)->N3_VORIG1		,; // 6 Valor
		(cTmp)->NM_LOCAL		,; // 7 Local
		(cTmp)->NM_GRUPO		,; // 8 Grupo
		(cTmp)->NM_CCUSTO		,; // 9 Centro Custo
		(cTmp)->N1_CHAPA		}) // 9 Centro Custo
		(cTmp)->( dbSkip() )
		
	EndDo // EOF
	
	//Ponto de Entrada para manipulação dos aprovadores na Transferência - Marcio Douglas - 30/09/10
	If ExistBlock( "AF125APT" )
		aEmailPE :=	ExecBlock( "AF125APT", .F., .F., { aEmailSol, cCodSol } )
		
		If	ValType( aEmailPE )	== "A"
			aEmailSol := AClone( aEmailPE )
		EndIf
		
		If Empty( aEmailSol )
  	   		Help(" ",1,"AF125APT",,STR0057 + "'",1,0)	//"Ausência do endereço de e-mail no cadastro do responsável pelo Ativo"
		Endif
	EndIf
	
	For nX := 1 To Len( aEmailSol )
		aSolTr[1]  := aEmailSol[nX,1]
		aSolTr[15] := aEmailSol[nX,2]
		WFSTAprov( 1, , aSolTr )
	Next nX
	
	(cTmp)->( dbCloseArea() )
	
	ConOut( '[WorkFlow] - Empresa '  + _cEmp + '/' + cFilAnt + ' - Finalizado ' + cTitulo )
	
EndIf


//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Finaliza ambiente                                            ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

ConOut( "" )
ConOut(	"********************************************************************"  + CRLF +;
"*      F I M   W O R K F L O W   P A R A   E M P R E S A:["+_cEmp+"]*" + CRLF +;
"********************************************************************" )

RestArea( aArea )

Return NIL

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºFuncao    ³WFPCAprov º Autor ³ Darlan Maciel      º Data ³  08/12/09   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDescricao ³ WorkFlow do pedido de compra para aprovacao via HTTPRET    º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³                                                            º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
Function WFSTAprov( nOpc, oWF, aSolTr)

Local aArea      := GetArea()
Local lRet       := .T.
Local nI         := 0
Local cObs     	 := ''
Local cWFID      := ''
Local cCDAPROV   := ''
Local nTamObs    := 80
Local eMailApv   := ''
Local oHTML      := NIL
Local cAprov	 := ''
Local dDtApvRej	 := dDataBase
Local dHrApvRej	 := StrTran( Left( Time(), 5), ':', '' )
Local cCodApvRej := ""
Local cMensagem	 := ""
Local cUsrSol	 := ""
Local cEmailUsr	 := ""
Local cHtmlMod   := AllTrim( SuperGetMV( 'MV_ATFASTR', , '\Workflow\Modelos\SolTrAprovac.htm' ) )
Local cLinkMod	 := AllTrim( SuperGetMV( 'MV_ATFAAPS', , '\Workflow\Modelos\AvisoSolAprovac.htm' ) )
Local cDirHTTP	 := AllTrim( SuperGetMV( 'MV_ATFHTTP', , '\web\ws' ) )
Local cUrlWF 	 := ""
Local cMailID
Local cAssunto
Local cHtmlAction

//Valida conteúdo dos parâmetros necessários ao envio da solicitação
If lRet .And. !File( cHTMLMod )
	lRet := .F.
	Conout( STR0133 )
	Help(" ",1,"AF125APT",,STR0133 + "'",1,0)	//"Modelo de solicitação de transf3erência não encontrado, verifique parâmetro MV_ATFASTR."
EndIf

If lRet .And. !File( cLinkMod )
	lRet := .F.
	Conout( STR0134 )
	Help(" ",1,"AF125HT3",,STR0134 + "'",1,0)	//"Modelo de aprovação de solicitação não encontrado, verifique parâmetro MV_ATFAAPS."
EndIf

If lRet .And. !ExistDir( cDirHTTP )
	lRet := .F.
	Conout( STR0135 ) 
	Help(" ",1,"AF125HT4",,STR0135 + "'",1,0)	// "Diretório do servidor HTTP não encontrado, verifique parâmetro MV_ATFHTTP."
EndIf

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Envio do WF - nOpc = 1 ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
If lRet
	If nOpc == 1
		
		Conout( "[WF:ENVIO DE APROVACAO SOLICITACAO DE TRANSFERENCIA]" )
		
		//obtem o url que vai no link via e-mail
		cUrlWF 	    := AllTrim(SuperGetMV("MV_ATFURL",,"http://localhost:8082/ws/") )
		cHtmlAction := cUrlWF + "WFHTTPRET.APL"
		cAssunto    := STR0062 + " [" +  aSolTr[2] + "]"	//"Aprovação da Solicitação de Transferência"
		
		//codigo e email do aprovador
		cAprov	 := aSolTr[15]
		eMailApv := aSolTr[1]
		
		If Right( cUrlWF, 1) != "/"
			cUrlWF += "/"
		EndIF
		
		//inicia a classe TWFProcess e assinala a variável objeto oProcess
		oWF := TWFProcess():New( '100100' , cAssunto)
		
		//cria uma tarefa
		oWF:NewTask( '100100' , cHtmlMod  )
		
		oWF:cSubject := cAssunto
		
		oWF:bReturn  := "WFSTAprov(2)"
		
		oWF:NewVersion(.T.)
		
		If Empty( eMailApv )
			ConOut( STR0061 + CRLF + ;	//"Nao há e-mail cadastrado para envio da solicitação de aprovação!"
			STR0094 + ": [" + UsrRetName( aSolTr[15]) + "] " + CRLF + ;	//"Aprovador"
			STR0004 + ": [" + aSolTr[2] + "]" )	//"Solic. Transf."
			oWF:Track( '100120', STR0061 + " " + STR0094 + ": " + UsrRetName( aSolTr[15]) + " - " + STR0004 + ": " + aSolTr[2], aSolTr[15] )
		Else
			
			oWF:cTo			:= eMailApv
			oWF:UserSiga	:= __cUserId
			cWFID			:= oWF:fProcessID + oWF:fTaskId
			oHtml			:= oWF:oHTML
			
			oHtml:ValByName( 'cHtmlAction', cHtmlAction )
			
			oHtml:ValByName( 'WNumSol'		, aSolTr[2]	)
			oHtml:ValByName( 'WSolic'		, aSolTr[3]	)
			oHtml:ValByName( 'WGeraNF'		, aSolTr[4]	)
			oHtml:ValByName( 'WClasNF'		, aSolTr[5]	)
			oHtml:ValByName( 'WObsSol'		, aSolTr[6]	)
			oHtml:ValByName( 'WNumNF'		, aSolTr[7]	)
			oHtml:ValByName( 'WSerie'		, aSolTr[8]	)
			oHtml:ValByName( 'WTESSaida'	, aSolTr[9]	)
			oHtml:ValByName( 'WTESEntrad'	, aSolTr[10])
			oHtml:ValByName( 'WCCustDest'	, aSolTr[11])
			oHtml:ValByName( 'WLocalDest'	, aSolTr[12])
			
			For nI := 1 To Len( aSolTr[13] )
				aAdd( (oHtml:ValByName( 'it.1') ), aSolTr[13][nI][1])
				aAdd( (oHtml:ValByName( 'it.2') ), aSolTr[13][nI][2])
				aAdd( (oHtml:ValByName( 'it.3') ), aSolTr[13][nI][3])
				aAdd( (oHtml:ValByName( 'it.4') ), aSolTr[13][nI][4])
				aAdd( (oHtml:ValByName( 'it.5') ), aSolTr[13][nI][5])
				aAdd( (oHtml:ValByName( 'it.6') ), aSolTr[13][nI][6])
				aAdd( (oHtml:ValByName( 'it.7') ), aSolTr[13][nI][7])
				aAdd( (oHtml:ValByName( 'it.8') ), aSolTr[13][nI][8])
				aAdd( (oHtml:ValByName( 'it.9') ), aSolTr[13][nI][9])
				aAdd( (oHtml:ValByName( 'it.10') ), aSolTr[13][nI][10])
			Next
			
			// Hidden Fields
			oHtml:ValByName( 'Wemp'		, cEmpAnt	)
			oHtml:ValByName( 'Wfil'		, cFilAnt	)
			oHtml:ValByName( 'WFID'		, cWFID		)
			oHtml:ValByName( 'WFaprcod' , cAprov	)
			
			//oWF:oHtml:lUsaJS  := .F.
			oWF:oWF:lHtmlBody := .T.
			
			//INICIA O PROCESSO
			cMailID	:= oWF:Start(cDirHTTP)
			oWF:Free()
			
			//COMECA AGORA A MONTAR A MENSAGEM QUE VAI NO E-MAIL DOS FORNECEDORES.
			oWF:NewTask( '100130' , cLinkMod )
			oWF:cSubject := '[Link] ' + cAssunto
			
			eMailApv := aSolTr[1]
			//INFORMA O ENDERECO ELETRONICO DO FORNECEDOR.
			oWF:cTo := eMailApv
			
			//assinalar valores das macros do html
			oWF:ohtml:ValByName("cContato" , Posicione("RD0",1,xFilial("RD0")+aSolTr[15],"RD0_NOME"))//aSolTr[15] )
			oWF:ohtml:ValByName("cNumPC"   , aSolTr[2] )
			oWF:ohtml:ValByName("proc_link", cUrlWF + cMailID + ".htm")
			oWF:ohtml:ValByName("titulo"   , STR0066 )	//"Solicitacao de Transferencia"
			oWF:Start()
			
			Begin Transaction
			dbSelectArea( "SNM" )
			SNM->( dbSetOrder(1) )
			SNM->( dbSeek( xFilial( "SNM" ) + aSolTr[2] ) )
			
			While SNM->NM_FILIAL == xFilial( "SNM" ) .And. SNM->NM_CODIGO == aSolTr[2]
				RecLock( 'SNM', .F. )
				SNM->NM_WFID := cWFID
				SNM->( dbSkip() )
			EndDo
			
			MsUnLock()
			End Transaction
		EndIf
		
		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³ Retorno do WF - nOpc = 2                                     ³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	ElseIf nOpc == 2 // Retorno
		
		cEmpAnt		:= AllTrim(oWF:oHtml:RetByName('Wemp')					)//Empresa
		cFilAnt		:= AllTrim(oWF:oHtml:RetByName('Wfil')					)//Filial
		cOpc		:= AllTrim(oWF:oHtml:RetByName('RBAPROVA')				) //Aprova Sim/Nao
		cObs		:= SubStr(AllTrim(oWF:oHtml:RetByName('Wobs')),1,nTamObs) //Obs. Aprov/Rej
		cWFID		:= AllTrim(oWF:oHtml:RetByName('WFID')					) //ID do WorkFlow
		cCDAPROV	:= AllTrim(oWF:oHtml:RetByName('WFaprcod') 				) //Codigo do usuario Apv/Rej
		
		ConOut( 'WFReturn - Retorno da Aprovacao da Solicitacao de Tranfs.' )
		ConOut( 'WF Id....: ' + cWFID )
		ConOut( 'cEmpAnt..: ' + cEmpAnt )
		ConOut( 'cFilAnt..: ' + cFilAnt )
		ConOut( 'cCDAPROV.: ' + cCDAPROV )
		
		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³ Ponto de entrada no retorno do WF de Tranasferencia          ³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		If ExistBlock( "AT125RTT" )
			ExecBlock( "AT125RTT", .F., .F., cFilAnt+cWFID )
		EndIf
		
		dbSelectArea( "SNM" )
		SNM->( dbSetOrder(3) )
		If SNM->( dbSeek( xFilial("SNM") + cWFID ) )
			If SNM->NM_SITSOL == '1' //Se Pendente
				If cOpc == 'S'  // Aprovar
					
					lLiberou := ATFA126Grava( 3, .T./*lWFProc*/ )	//FUNCAO QUE IRA FAZER A BAIXA E DEMAIS PROCESSOS
					
					Conout(lLiberou)
					ConOut( 'Aprovado.: ' + cOpc )
					ConOut( 'Solicitacao de Transf. ' + Posicione( "SNM", 3, xFilial( "SNM" ) + cWFID, "NM_CODIGO" ) + ' aprovado por ' + cCDAPROV )
					
					If lLiberou
						
						oWF:Finish()
						
						dbSelectArea( "SNM" )
						SNM->( dbSetOrder(3) )
						SNM->( dbSeek( xFilial( "SNM" ) + cWFID ) )
						MSMM( SNM->NM_CDHREJ, , , cObs, 1, , , "SNM", "NM_CDHREJ" )
						cCodApvRej	:= SNM->NM_CDHREJ
						cCodSol		:= SNM->NM_CODIGO
						cUsrSol		:= SNM->NM_USRSOL
						
						While SNM->(!EOF()) .AND. xFilial( "SNM" ) + cWFID == SNM->NM_FILIAL + SNM->NM_WFID
							RecLock( "SNM", .F. )
							SNM->NM_USRAPV	:= cCDAPROV
							SNM->NM_DTAPVRE	:= dDtApvRej
							SNM->NM_HRAPVRE	:= dHrApvRej
							SNM->NM_CDHREJ 	:= cCodApvRej
							SNM->NM_SITSOL	:= "2"
							SNM->( MsUnlock() )
							SNM->( dbSkip() )
						EndDo
						
						cMensagem := STR0103 + " " + cCodSol 	//"Aprovação da solicitação de transferência"
						
						If !Empty(cUsrSol)
							PswOrder(1)
							If PswSeek(cUsrSol)
								cEmailUsr := PswRet()[1,14]
							Endif
						Endif
						
						//P.Entrada para manipulação dos Emails quer receberão o aviso de efetivação/negação da transferência - Marcio Douglas - 30/09/10
						If ExistBlock( "A125EMRT" )
							cEmailRet := ExecBlock( "A125EMRT", .F., .F., { cEmailUsr, cCodSol } )      //Retorna lista de emails para retorno da aprovacao
							
							If	ValType( cEmailRet ) == "C"
								cEmailUsr := cEmailRet
							EndIf
							
						EndIf
						
						
						If !Empty( cEmailUsr )
							FSSendMail( cEmailUsr, STR0066 + " [" + cCodSol + "]", cMensagem )
						Else
							Conout( STR0095 + " " + cUsrSol )	//"E-mail não cadastrado para o solicitante de código"
						EndIF

					EndIf
					
					//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
					//³ Apaga o arquivo HTML que foi criado para envio           ³
					//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
					aFile := Directory( cDirHTTP + '\' + cWFID + "*.htm" ) // pode ser com coringa tipo *.txt
					If Len(aFile) > 0
						For nI := 1 to Len(aFile)
							cFile := cDirHTTP + '\' + aFile[nI][1]
							If File(cFile)
								If FErase(cFile) == -1
									Conout( STR0096 + " " + cFile )	//"Erro ao apagar o arquivo HTML"
								Endif
							EndIf
						Next nI
					EndIf
					
				ElseIf cOpc == 'N' // Rejeitar
					ConOut( 'Aprovado.: ' + cOpc )
					ConOut( 'Solicitacao de Tranf. ' + Posicione("SNM",3,xFilial("SNM")+cWFID,"NM_CODIGO") + ' rejeitado por ' +  cCDAPROV)
					
					oWF:Finish()
					
					dbSelectArea( "SNM" )
					SNM->( dbSetOrder(3) )
					SNM->( dbSeek( xFilial( "SNM" ) + cWFID ) )
					MSMM( SNM->NM_CDHREJ, , , cObs, 1, , , "SNM", "NM_CDHREJ" )
					cCodApvRej := SNM->NM_CDHREJ
					cCodSol	   := SNM->NM_CODIGO
					cUsrSol	   := SNM->NM_USRSOL
					
					While SNM->( !EOF() ) .AND. xFilial( "SNM" ) + cWFID == SNM->NM_FILIAL + SNM->NM_WFID
						
						RecLock( "SNM", .F. )
						
						SNM->NM_USRAPV	:= cCDAPROV
						SNM->NM_DTAPVRE	:= dDtApvRej
						SNM->NM_HRAPVRE	:= dHrApvRej
						SNM->NM_CDHREJ 	:= cCodApvRej
						SNM->NM_SITSOL	:= "3"
						
						SNM->(MsUnlock())
						
						SNM->(dbSkip())
						
					EndDo
					
					//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
					//³ Apaga o arquivo HTML que foi criado para envio           ³
					//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
					aFile := Directory( cDirHTTP + '\' + cWFID + "*.htm" ) // pode ser com coringa tipo *.txt
					If Len(aFile) > 0
						For nI := 1 to Len(aFile)
							cFile := cDirHTTP + '\' + aFile[nI][1]
							If File(cFile)
								If FErase(cFile) == -1
									Conout( STR0096 + cFile )	//"Erro ao apagar o arquivo HTML "
								Endif
							EndIf
						Next nI
					EndIf
					
					cMensagem := STR0104 + " " + cCodSol	//"Rejeição da solicitação de transferência"
					
					If !Empty( cUsrSol )
						PswOrder(1)
						If PswSeek( cUsrSol )
							cEmailUsr := PswRet()[1,14]
						Endif
					Endif
					
					//P.Entrada para manipulação dos Emails quer receberão o aviso de efetivação/negação da transferência - Marcio Douglas - 30/09/10
					If ExistBlock( "A125EMRT" )
						cEmailRet := ExecBlock( "A125EMRT", .F., .F., {cEmailUsr,cCodSol})      //Retorna lista de emails para retorno da aprovacao
						
						If	ValType(cEmailRet)	==	"C"
							cEmailUsr := cEmailRet
						EndIf
					EndIf
					
					
					If !Empty(cEmailUsr)
						FSSendMail( cEmailUsr, STR0066 + " " + cCodSol, cMensagem )	//"Solicitação de Transferência"
					Else
						Conout( STR0095 + " " + cUsrSol )	//"E-mail não cadastrado para o solicitante de código"
					EndIf       
								
				EndIf
			Else
				ConOut( STR0099 + CRLF + ;	//"Respondido anteriormente ou respondido por outro usuário"
				STR0014 + ": [" + SNM->NM_CODIGO + "]" )	//"No. Solic."
			EndIf
		Else
			ConOut( 'Registro de liberacao SNM - Filial: [' + cFilAnt + '] WF Id: [' + cWFID + '] nao encontrado no retorno' )
		EndIf
	EndIf
EndIf

Conout( "Etapa: Fim" )

RestArea( aArea )

Return NIL

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Rotina WorkFlow Solicitacao Transferencia - FIM ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³FSSendMailºAutor  ³ Darlan Maciel      º Data ³  29/12/09   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³Rotina de envio de e-mail                                   º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³                                                            º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
Function FSSendMail( cEmail, cAssunto, cMensagem, cAttach )

Local aArea     := GetArea()
Local cEmailTo  := ""								// E-mail de destino
Local cEmailBcc := ""								// E-mail de copia
Local lResult   := .F.								// Se a conexao com o SMPT esta ok
Local cError    := ""								// String de erro
Local lRelauth  := SuperGetMv("MV_RELAUTH",, .F.)	// Parametro que indica se existe autenticacao no e-mail
Local lRet	    := .F.								// Se tem autorizacao para o envio de e-mail
Local cConta    := Trim(GetMV('MV_RELACNT')) 		// Conta Autenticacao Ex.: fuladetal@fulano.com.br
Local cPsw      := Trim(GetMV('MV_RELAPSW')) 		// Senha de acesso Ex.: 123abc
Local cServer   := Trim(GetMV('MV_RELSERV')) 		// Ex.: smtp.ig.com.br ou 200.181.100.51
Local cFrom	    := Trim(GetMV('MV_RELFROM')) 		// e-mail utilizado no campo From'MV_RELACNT' ou 'MV_RELFROM' e 'MV_RELPSW'

Default cAttach := ""

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Envia o mail para a lista selecionada. Envia como BCC para que a pessoa pense³
//³que somente ela recebeu aquele email, tornando o email mais personalizado.   ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

cEmailTo := cEmail
If At( ";", cEmail ) > 0 // existe um segundo e-mail.
	cEmailBcc := SubStr( cEmail, At( ";", cEmail ) + 1, Len( cEmail ) )
Endif

CONNECT SMTP SERVER cServer ACCOUNT cConta PASSWORD cPsw RESULT lResult

// Se a conexao com o SMPT esta ok
If lResult
	
	// Se existe autenticacao para envio valida pela funcao MAILAUTH
	If lRelauth
		lRet := Mailauth( cConta, cPsw )
	Else
		lRet := .T.
	Endif
	
	If lRet
		SEND MAIL;
		FROM 		cFrom;
		TO      	cEmailTo;
		BCC     	cEmailBcc;
		SUBJECT 	cAssunto;
		BODY    	cMensagem;
		ATTACHMENT  cAttach  ;
		RESULT 		lResult
		
		If !lResult
			//Erro no envio do email
			GET MAIL ERROR cError
			If !IsBlind()
				Help( " ", 1, "01 - " + STR0021, , cError + " " + cEmailTo, 4, 5 ) //"01 - Atenção"
			Else
				ApMsgInfo( "01 - " + STR0021 + " " + cError + " " + cEmailTo )  //"01 - Atenção "
			EndIf
		Endif
		
	Else
		GET MAIL ERROR cError
		If !IsBlind()
			Help( " ", 1, "02 - " + STR105, , cError, 4, 5 )  //"Autenticação"
		Else
			ApMsgStop( "02 - " + STR106, STR107 )  //"Erro de autenticação" | "Verifique a conta e a senha para envio."
		EndIf
	Endif
	
	DISCONNECT SMTP SERVER
Else
	//Erro na conexao com o SMTP Server
	GET MAIL ERROR cError
	If !IsBlind()
		Help( " ", 1, "03 - " + STR0021, , cError, 4, 5 )  	//"Atenção"
	Else
		ApMsgInfo( "03 - " + STR0021 + " " + cError )  		//"Atenção"
	EndIf
Endif

RestArea( aArea )

Return (lResult)

//--------------------------------------------------------------------------------
//BAIXA EM LOTE INICIO
/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡„o	 ³AF030Auto ³ Autor ³ Alice Yamamoto		³ Data ³		  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡„o ³ Baixa Automatica de Bens									  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Sintaxe   ³ AF030AUTO()												  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso		 ³ ATFA030													  ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
Function AF125BxLt( cAlias, nReg, nOpc )

Local oDlg, oDlg1, oQtda
Local oMark			:= 0
Local lInverte 		:= .F.
Local cCapital
Local nOpt		 	:= 0
Local cNota 	 	:= CriaVar( "NM_NOTA" , .F. )
Local cSerie	 	:= CriaVar( "NM_SERIE" , .F. )
Local nUfir 	 	:= 0
Local cIndex		:= "", cChave := ""
Local nSavOrd1		:= IndexOrd()
Local nQuant      	:= 0
Local nQtdOrig		:= 0
Local nVlrOrig1 	:= 0, nVlrOrig2 :=0,  nVlrOrig3 :=0,  nVlrOrig4 :=0,  nVlrOrig5 :=0
Local nVlrBx1   	:= 0, nVlrBx2   :=0,  nVlrBx3   :=0,  nVlrBx4   :=0,  nVlrBx5   :=0
Local nVlrDesp1 	:= 0, nVlrDesp2 :=0,  nVlrDesp3 :=0,  nVlrDesp4 :=0,  nVlrDesp5 :=0
Local nVlrCorBem	:= 0, nVlrCorDep:=0
Local bFirst		:= { || SN1->( MsSeek( xFilial("SN1") + cBaseI + cItemI, .T. ) ) }
Local bFor 			:= { || SN1->N1_OK == cMarca .And. (SN1->N1_QUANTD > 0 ) }
Local bWhile 		:= { ||	!( SN1->(EOF())) .And.;
SN1->N1_FILIAL == xFilial("SN1") .And.;
SN1->N1_CBASE  <= cBaseF .And.;
SN1->N1_ITEM   <= cItemF }

Local aCampos	 := {}
Local cHistSol
Local oHistSol
Local cCodSol    := ""
Local cHrSol     := Time()
Local cVarSX6    := ""
Local lContinua  := .F.
Local cTipoAprov := "1=" + STR0108	//"Responsável individual"
Local aTipoAprov := { "1=" + STR0108, "2=" + STR0109 }	//"Responsável individual" | "Responsável geral"
Local oTipoAprov

Private cExpFiltro  := ""
Private cArquivo	:= ""
Private nTotal 		:= 0
Private nHdlPrv		:= 0
Private cPadrao   	:= ""
Private nPercBaixa	:= 100
Private dDInDepr	:= CTOD("  /  /  ")
Private cPicture1, cPicture2, cPicture3, cPicture4, cPicture5, cPictQtd
Private nVlrAtual1	:= 0, nVlrAtual2:= 0, nVlrAtual3:= 0, nVlrAtual4 := 0, nVlrAtual5 := 0
Private nVlResid1 	:= 0, nVlResid2 := 0, nVlResid3 := 0, nVlResid4  := 0, nVlResid5  := 0
Private nValBaixa1	:= 0, nValBaixa2:= 0, nValBaixa3:= 0, nValBaixa4 := 0, nValBaixa5 := 0
Private nValDepr1 	:= 0, nValDepr2 := 0, nValDepr3 := 0, nValDepr4  := 0, nValDepr5  := 0
Private nDepr1 		:= 0, nDepr2 := 0, nDepr3 := 0, nDepr4 := 0, nDepr5 := 0
Private cMotivo		:= "01"
Private aMotivos	:= {}
Private cBasei 		:= CriaVar("NM_CBASE", .F. )
Private cItemI 		:= CriaVar("NM_ITEM", .F. )
Private cBasef 		:= cBasei
Private cItemF 		:= Replicate("Z",Len(cItemI))
Private nQtdBens
Private dBaixa030  	:= dDataBase
Private cCliente	:= CriaVar("NM_CLIENTE", .F. )
Private cLoja		:= ""
Private cTES		:= CriaVar("NM_TESNFS", .F. )
Private cCondPag	:= CriaVar("NM_CONDPG", .F. )
Private cGeraNF		:= "2"
Private nValCorr 	:= 0, nValCorDep := 0
Private lSN7 		:= .F.
Private lQuant 		:= .T.
PRIVATE cMarca		:= GetMark( )
Private cFilIni     := xFilial("SN1")
Private cFilFim     := xFilial("SN1")

Default aEmailSol	:= {}

lPrimlPad := .T.

Set( _SET_DECIMALS, 20 )

lUmaVez := .F.
lAuto   := .T.
lPrim   := .T.

aCampos := {}
AADD( aCampos, { "N1_OK", "", "  ", "" } )

dbSelectArea( "SX3" )
SX3->( dbSeek ( "SN1" ) )

Do While SX3->( !EOF() ) .And. ( X3_ARQUIVO == "SN1" )
	
	If ( X3USO( X3_USADO) .And. cNivel >= X3_NIVEL .And. SX3->X3_CONTEXT # "V") .Or.;
		( X3_PROPRI == "U" .And. X3_CONTEXT != "V" .And. X3_TIPO <> 'M' ) .Or.;
		Alltrim( X3_CAMPO ) $ "N1_CBASE#N1_ITEM"
		
		aAdd( aCampos, { X3_CAMPO, "", X3Titulo(), X3_PICTURE } )
	Endif
	
	SX3->( dbSkip() )
	
EndDo

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Verifica tabela de motivos para baixa 												³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
dbSelectArea( "SX5" )
SX5->( dbSeek( xFilial( "SX5" ) + "16" ) )

While SX5->X5_FILIAL + SX5->X5_TABELA == xFilial("SX5") + "16"
	If !( Alltrim(SX5->X5_CHAVE) $ '13/15/16/17')
		cCapital := Capital( X5Descri() )
		aAdd( aMotivos, SubStr( SX5->X5_CHAVE, 1, 2 ) + "=" + SubStr( cCapital, 1, 12 ) )
	EndIf
	SX5->( dbSkip() )
EndDo

dbSelectArea( "SN1" )
SN1->(dbGoTop())

DEFINE MSDIALOG oDlg FROM 18, 1 TO 257, 566 TITLE STR0110 PIXEL  //"Solicitação de Baixa em Lote"

@ 3,  3	TO 118, 242 OF oDlg PIXEL
@ 11, 007	SAY STR0039		SIZE 024, 007 OF oDlg PIXEL  //"Gera NF"
@ 11, 092	SAY STR0034		SIZE 021, 007 OF oDlg PIXEL  //"Mot. Baixa"
@ 11, 174	SAY STR0035		SIZE 032, 007 OF oDlg PIXEL  //"Cond. Pgto"
@ 24, 007	SAY STR0045		SIZE 024, 007 OF oDlg PIXEL  //"Num.NF"
@ 24, 092	SAY STR0046		SIZE 016, 007 OF oDlg PIXEL  //"Serie"
@ 24, 174	SAY STR0044		SIZE 032, 007 OF oDlg PIXEL  //"TES Saída"
@ 38, 007	SAY STR0042		SIZE 032, 007 OF oDlg PIXEL  //"Cliente"
@ 38, 092	SAY STR0043		SIZE 032, 007 OF oDlg PIXEL  //"Loja"
@ 53, 007	SAY STR0111		SIZE 045, 007 OF oDlg PIXEL  //"Do Codigo"
@ 53, 092	SAY STR0113		SIZE 045, 007 OF oDlg PIXEL  //"Ate"
@ 68, 007	SAY STR0112		SIZE 032, 007 OF oDlg PIXEL  //"Do Item"
@ 68, 065	SAY STR0113		SIZE 032, 007 OF oDlg PIXEL  //"Até"
@ 68, 110   SAY STR0114 	SIZE 032, 007 OF oDlg PIXEL  //"Gera aprovação para"
@ 88, 007	SAY STR0050		SIZE 032, 007 OF oDlg PIXEL  //"Hist. Solic."

@ 9 , 36	COMBOBOX oGERANF	VAR cGERANF ITEMS { "1=" + STR0040,"2=" + STR0041 } SIZE 46,  9 OF oDlg PIXEL VALID A125VlBxLt("cGeraNF",@cGERANF,@cMotivo,@cNota,@cSerie,@cCONDPAG,@cCliente,@cLoja,@cTES)
@ 9 , 114	COMBOBOX oCbxMotBx	VAR cMotivo ITEMS aMotivos 		   					SIZE 49, 27 OF oDlg PIXEL VALID A125VlBxLt("cMotivo",@cGERANF,@cMotivo,@cNota,@cSerie,@cCONDPAG,@cCliente,@cLoja,@cTES)
@ 9 , 206	MSGET cCONDPAG 	SIZE	021, 009 	OF oDlg PIXEL F3 "SE4" WHEN cGeraNF == "1" VALID Vazio(cCONDPAG) .Or. ExistCpo("SE4",cCONDPAG)
@ 23, 36	MSGET cNota		SIZE	043, 009 	OF oDlg PIXEL F3 "SF2" WHEN cGeraNF == "3" VALID A125VlBxLt("cNota",@cGERANF,@cMotivo,@cNota,@cSerie,@cCONDPAG,@cCliente,@cLoja,@cTES)
@ 23, 114	MSGET cSerie	SIZE	021, 009 	OF oDlg PIXEL F3 "01"  WHEN cGeraNF == "1" VALID Vazio(cSerie) .Or. ExistCpo("SX5","01"+cSerie)
@ 23, 206	MSGET cTES		SIZE	021, 009 	OF oDlg PIXEL F3 "SF4" WHEN cGeraNF == "1" VALID A125VlBxLt("TES",@cGERANF,@cMotivo,@cNota,@cSerie,@cCONDPAG,@cCliente,@cLoja,@cTES)
@ 37, 36	MSGET cCliente 	SIZE	046, 009 	OF oDlg PIXEL F3 "SA1" WHEN cGeraNF == "1" VALID A125VlBxLt("cCliente",@cGERANF,@cMotivo,@cNota,@cSerie,@cCONDPAG,@cCliente,@cLoja,@cTES)
@ 37, 114	MSGET cLoja 	SIZE	021, 009 	OF oDlg PIXEL WHEN .F.
@ 52, 36	MSGET cBasei	SIZE 	050, 009 	OF oDlg PIXEL F3 "SN1" Valid !Empty(cBaseI)
@ 52, 114	MSGET cBasef	SIZE 	050, 009 	OF oDlg PIXEL F3 "SN1" Valid cBasef >= cBaseI
@ 67, 36	MSGET cItemI					OF oDlg PIXEL
@ 67, 80	MSGET cItemF					OF oDlg PIXEL
@ 67, 140	COMBOBOX oTipoAprov VAR cTipoAprov	ITEMS aTipoAprov	OF oDlg SIZE 89, 40 PIXEL
@ 87, 36	GET   oHistSol VAR cHistSol 	OF oDlg MULTILINE SIZE 198, 25 HSCROLL PIXEL

DEFINE SBUTTON FROM 03,250 TYPE  1 ENABLE OF oDlg ACTION ( nOpt := TudOkBxLt( cGERANF, cMotivo, cNota, cSerie, cCONDPAG, cCliente, cLoja, cTES, cHistSol ), IIf( nOpt == 1, Odlg:End(), .F. ) )
DEFINE SBUTTON FROM 17,250 TYPE  2 ENABLE OF oDlg ACTION ( nOpt := 0, oDlg:End() )
DEFINE SBUTTON FROM 40,250 TYPE 17 ENABLE OF oDlg ACTION SN1->( cExpFiltro := BuildExpr( "SN1", oDlg ) )

ACTIVATE MSDIALOG oDlg CENTERED

//Filtra os registros
If !Empty( cExpFiltro )
	SN1->(dbSetFilter( { || &cExpFiltro }, cExpFiltro ) )
EndIf

If nOpt != 0
	nQtdBens := 0	  // quantidade de Bens, mostrado no rodape‚ do browse

	Eval(bFirst)

	If SN1->( !Eof() )
	
		nOpca := 0
		aF125Marca( "SN1", cMarca, .F., , bFirst, bWhile, , .T., cGeraNF )
	
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Faz o calculo automatico de dimensoes de objetos     ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		aSize := MSADVSIZE()
	
		DEFINE MSDIALOG oDlg1 TITLE STR0115 From aSize[7],0 TO aSize[6],aSize[5] OF oMainWnd  PIXEL //"Baixas Automáticas"
		oDlg1:lMaximized := .T.
	
		oPanel := TPanel():New( 0, 0, '', oDlg1, , .T., .T., , , 40, 40, .T., .T. )
		oPanel:Align := CONTROL_ALIGN_TOP
	
		@1.9,.8 Say STR0116 OF oPanel  //"Total de Bens a Baixar..."
		@1.9,11 Say oQtda VAR nQtdBens  SIZE 50,10 OF oPanel
	
		oMark := MsSelect():New( "SN1", "N1_OK",,aCampos,@lInverte,@cMarca,{35,oDlg1:nLeft,oDlg1:nBottom,oDlg1:nRight},'Atf030Fil(1)', 'Atf030Fil(2)')
		oMark:oBrowse:bAllMark := { || aF125Marca( "SN1", cMarca, .T. , oQtda, bFirst, bWhile, , , cGeraNF ) }
		oMark:bMark := { || Af030Display( cMarca, lInverte, oQtda ) }
		oMark:bAval	:= { || aF125Marca( "SN1", cMarca, .T., oQtda, bFirst, bWhile, .F., , cGeraNF) }
		oMark:oBrowse:Align := CONTROL_ALIGN_ALLCLIENT
	
		ACTIVATE MSDIALOG oDlg1 ON INIT EnchoiceBar( oDlg1, { || ( nOpca := 1, oDlg1:End() ) }, {|| nOpca := 0, ODlg1:End() } )
	
		If nOpca == 1	//Se usuário clicou em Ok
		
			If Left( cTipoAprov, 1 ) != "1" // Resp. Geral
				cVarSX6 := GetMV( "MV_ATFRESP" )
			Endif
		
			If !SuperGetMV( "MV_ATFWFM", , .F. )
				lContinua := .T.
			ElseIf !Empty(cVarSX6)
				PswOrder(1)
			// Se encontrou o usuario no cadastro de usuarios e o e-mail estiver preenchido
				If PswSeek( cVarSX6 ) .And. !Empty( Alltrim( PswRet()[1,14] ) )
					aEmailSol := { { Alltrim( PswRet()[1,14]), cVarSX6, .T. } }
					lContinua := .T.
				Else
					lContinua := .F.
					Help(" ",1,"AF125RESP",, STR0057 + " [MV_ATFRESP]",1,0)//"Ausência do endereço de e-mail no cadastro do responsável pelo Ativo."
				EndIf
			ElseIf Left( cTipoAprov, 1 ) == "2" // Resp. Geral
				lContinua := .F.
				Help(" ",1,"AF125RESP",,STR0060 + CRLF + STR0117,1,0)//"Responsável padrão pelos Ativos não preenchido." | "Preencha o código do usuário padrão [MV_ATFRESP] ou desative o envio de Workflow [MV_ATFWFM]"
			Else
				lContinua := .T.
			Endif
		
			If lContinua
				Eval(bFirst)
			
				If Left( cTipoAprov, 1 ) == "2" // Resp. Geral
					cCodSol := GetSxENum( "SNM", "NM_CODIGO" )
					ConfirmSx8()
				Endif
			
				dbSelectArea( "SN3" )
				SN3->(dbGoTop())
			
				While Eval(bWhile)
				
					If ( SN1->N1_OK != cMarca )
						SN1->(dbSkip())
						Loop
					EndIf
				
					SN3->( dbSeek( xFilial("SN3") + SN1->N1_CBASE + SN1->N1_ITEM ) )
				
				//Obtem a quantidade do bem
					nQuant := If( SN1->N1_QUANTD == 0, 1, SN1->N1_QUANTD )
				
					If Eval( bFor )
					
					//Gravação da solicitação de baixa em lote
						nVlrBaix := Round((SN3->N3_VORIG1 + SN3->N3_VRCACM1 + SN3->N3_AMPLIA1), X3Decimal("N3_VORIG1"))
					
						If Left( cTipoAprov, 1 ) != "2" // Responsavel individual
						//Verifica se WorkFlow está ativado
							If SuperGetMv( "MV_ATFWFM", , .F. )
							// Preenche a matriz PRIVATE aEmailSol com o e-mail dos responsaveis
								A125VlRspWF( SN3->N3_CBASE, SN3->N3_ITEM )
							EndIf
							cCodSol := GetSxENum( "SNM", "NM_CODIGO" )
							ConfirmSx8()
						Endif
					
						GravaBx( SN1->N1_CBASE	, SN1->N1_ITEM	, SN3->N3_TIPO  ,;
							nQuant			, 100			, cMotivo		,;
							cCondPag		, nVlrBaix		, nVlrBaix		,;
							cGeraNF		, cCliente		, cLoja			,;
							cNota			, cSerie		, cTES			,;
							dDataBase		, cHrSol		,__cUserID		,;
							cHistSol		, cCodSol )
					
						If Left(cTipoAprov,1) == "1"	// Responsavel Individual
							If SuperGetMV( 'MV_ATFWFM' ,, .F. )
							//Chamada do WorkFlow
								A125WfBx(cCodSol)
							EndIf
						Endif
					EndIf
				
					SN1->( dbSkip() )
				EndDo
				If Left( cTipoAprov, 1 ) == "2"	// Responsavel Geral
					If SuperGetMV( 'MV_ATFWFM', , .F. )
					//Chamada do WorkFlow
						A125WfBx( cCodSol )
					EndIf
				Endif
			EndIf
		Endif
	Endif
EndIf
//Apagar Indices temporarios
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Restaura os ¡ndices 										  ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
SN1->(dbClearFilter())


Return Nil

/*
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡„o	 ³af125Marca³ Autor ³ Alice Y. Yamamoto	  ³ Data ³ 04/03/97   ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡„o ³ marcar e desmarcar item 									  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Sintaxe	 ³ Af125Marca(ExpN1,ExpD1,ExpD2) 							  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso		 ³ atfa030													  ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
Static Function Af125Marca( cAlias, cMarca, lInverte, oQtda, bFirst, bWhile, lTodos, lFiltro, cGeraNF ,lTraLocal)

Local aArea := (cAlias)->(GetArea())
Local lRet  := .T.

Default lInverte := .F.
Default lTodos	 := .T.
Default lFiltro	 := .F.
Default lTraLocal:= .F.

dbSelectArea( "SNM" )
SNM->( dbSetOrder(2) )
SNM->( dbGoTop() )

dbSelectArea("SB1")
SB1->(dbSetOrder(1))
SB1->(dbGoTop())

If lTodos
	Eval( bFirst )
Endif

While !lTodos .Or. Eval( bWhile )
	
	SNM->( dbSeek( xFilial( "SNM" ) + SN1->N1_CBASE + SN1->N1_ITEM ), , .T. )
	
	lRet := .T.
	
	If cGeraNF == "1"
		If !SB1->(dbSeek( xFilial("SB1") + SN1->N1_PRODUTO ) )
			lRet := .F.
			If !lTodos
			    Help(" ",1,"AF125PROD",,STR0143,1,0)//"Não existe produto relacioanado a esse bem para gerar documento fiscal."
			Else
				If SN1->N1_OK == cMarca
					RecLock("SN1")
					SN1->N1_OK := ""
					nQtdBens--
					nQtdBens := IIf ( nQtdBens <= 0, 0, nQtdBens )
					oQtda:Refresh()
					MsUnlock()
				EndIf
			EndIf
		EndIf
	EndIf
	
	If lRet
		If ( SN1->N1_QUANTD > 0 )  		//Verifica se tem quantidade disponível para a solicitação
			If ( SN1->N1_STATUS == "1" ) .Or. lTraLocal	//Verifica se item está bloqueado
				If ( SNM->NM_SITSOL != "1" )	//Verifica se existe solicitação pendente para o item
					RecLock( "SN1" )
					If lInverte
						If SN1->N1_OK == cMarca
							SN1->N1_OK := ""
							nQtdBens--
							nQtdBens := IIf ( nQtdBens <= 0, 0, nQtdBens )
						Else
							SN1->N1_OK := cMarca
							nQtdBens++
						EndIf
						oQtda:Refresh()
					Else
						SN1->N1_OK := cMarca
						nQtdBens++
					EndIf
					MsUnLock()
				Else	//Executa se item com solicitação pendente NM_SITSOL == "1"
					If !lTodos
						Help(" ",1,"AF125SOL",,STR0071,1,0)//"Ativo com solicitação pendente."
					EndIf
				EndIf
			Else	//Executa se item bloqueado N1_STATUS = "2"
				If !lTodos
					If SN1->N1_STATUS == "0"   //bem pendente de classificacao nao deixa marcar/desmarcar
						Help(" ",1,"AF125CLAS",,"Bem nao classificado nao pode ser selecionado.",1,0)
					Else
				    	Help(" ",1,"AF125STA",,STR0131,1,0)//"Este bem não pode ser selecionado, pois está bloqueado!"
					EndIf
				EndIf
			EndIf
		Else	//Executa se item zerado N1_QUANTD = 0
			If !lTodos
				Help(" ",1,"AF125BX",,STR0118,1,0)//"Este bem não pode ser selecionado, pois está baixado!"
			Endif
		Endif
	EndIf
	
	If !lTodos
		Exit
	Endif
	
	SN1->(dbSkip())
	
EndDo

RestArea( aArea )

Return

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³A125VlBxLt  ºAutor  ³Microsiga         º Data ³  27/08/10   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ Valida o valor preenchido nos campos da baixa em lote      º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ SIGAATF                                                    º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
Function A125VlBxLt( cCpoBxLt, cGERANF, cMotivo, cNota, cSerie,;
cCONDPAG, cCliente, cLoja, cTES )

Local lRet  := .T.
Local aArea := GetArea()
Local cMotGeraNF := SuperGetMV( "MV_ATFMBNF", .F., "01/10" )		//Motivos de baixa que permitem gerar NF

Do Case
	Case cCpoBxLt == "cGeraNF"
		If  cGeraNF == "2"
			cCliente := CRIAVAR( "NM_CLIENTE", .F. )
			cLoja	 := ""
			cTES	 := CRIAVAR( "NM_TESNFS", .F. )
			cCondPag := CRIAVAR( "NM_CONDPG", .F. )
		Else
			If !(cMotivo $ cMotGeraNF)
				lRet := .F.
				Help(" ",1,"AF125GERNOT",, STR0144 ,1,0)//"Motivo de baixa não permite geração de Nota Fiscal ou não configurado, verique parâmetro MV_ATFMBNF"
			EndIf
		EndIf
	Case cCpoBxLt == "cMotivo"
		If cGeraNF == "1"
			If !(cMotivo $ cMotGeraNF)
				lRet := .F.
				Help(" ",1,"AF125GERNOT",, STR0144 ,1,0)//"Motivo de baixa não permite geração de Nota Fiscal ou não configurado, verique parâmetro MV_ATFMBNF"
			EndIf
		EndIf
	Case cCpoBxLt == "cNota"
		If !Empty(cNota)
			dbSelectArea( "SF2" )
			SF2->(dbSetOrder(1))
			If SF2->( dbSeek( xFilial( "SF2" ) + cNota ) )
				cCliente := SF2->F2_CLIENTE
				cLoja	 := SF2->F2_LOJA
				cSerie	 := SF2->F2_SERIE
				cTES	 := CRIAVAR( "NM_TESNFS" )
			Else
				lRet := .F.
				Help(" ",1,"AF125TES",,STR0072,1,0)//"Código não cadastrado"
			EndIf
		EndIf
	Case cCpoBxLt == "cCliente"
		If !Empty(cCliente)
			cLoja := SA1->A1_LOJA
			dbSelectArea( "SA1" )
			SA1->(dbSetOrder(1))
			If SA1->( !dbSeek( xFilial( "SA1" ) + cCliente ) )
				Help(" ",1,"AF125CLI",,STR0072,1,0)//"Código não cadastrado"
				lRet := .F.
			EndIf
			If lRet .And. !Empty(SA1->A1_RISCO) .And.  Alltrim(SA1->A1_RISCO) != "A"
	   			Help(" ",1,"AF125RIS",,STR0149,1,0)//"Cliente cadastrado deve possuir Risco A para efetuar a transferencia."
				lRet   :=.F.
			EndIf
		EndIf
	Case cCpoBxLt == "TES"
		If cGeraNF == "1"
			If !Empty( cTES )
				dbSelectArea( "SF4" )
				SF4->(dbGoTop())
				If SF4->(dbSeek( xFilial( "SF4" ) + cTES ) )
					If SF4->F4_TIPO == "E"
						lRet := .F.
						Help(" ",1,"AF125TESS",,STR0139,1,0)	//"A TES utilizada deve ser de saída!"  
					ElseIf SF4->F4_ATUATF == "S" .Or. SF4->F4_DUPLIC == "S" .Or. SF4->F4_ESTOQUE == "S"
						lRet := .F.
						Help(" ",1,"AF125TESDUP",,STR0140,1,0)//"A TES utilizada não pode gerar duplicata, atualizar estoque ou atualizar ativo fixo!"
					EndIf
				Else
					lRet := .F.
					Help(" ",1,"AF125TESENC",,STR0141,1,0)	//"TES não encontrada!"
				EndIf
			Else
				lRet := .F.
				Help(" ",1,"AF125TESOBG",,STR0142,1,0)	//"Preencha o campo TES!"
			EndIf
		EndIf
EndCase

RestArea( aArea )

Return(lRet)

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³TudOkBxLt  ºAutor  ³Microsiga          º Data ³  27/08/10   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ Valida o preenchimentos dos campos obrigatorios.           º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ SIGAATF                                                    º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
Static Function TudOkBxLt( cGERANF, cMotivo, cNota, cSerie, cCONDPAG,;
cCliente, cLoja, cTES, cHistSol )

Local lRet := .T.

//Verifica o preenchimento de campos obrigatórios.
If Empty( cHistSol ) .And. lRet
	lRet := .F.                                                                                     
	Help(" ",1,"AF125OBG",,STR0074 + " - '" + STR0050 + "'",1,0)	//"Campo obrigatório não informado" |  "Hist. Solic."
EndIf

If ( cGeraNF == "1" .And. Empty(cSerie) ) .And. lRet
	lRet := .F.
	Help(" ",1,"AF125OBG",,STR0074 + " - '" + STR0046 + "'",1,0)	//"Campo obrigatório não informado" |  "Serie"
EndIf

If ( cGeraNF == "1" .And. Empty(cTES) ) .And. lRet
	lRet := .F.
	Help(" ",1,"AF125OBG",,STR0074 + " - '" + STR0044 + "'",1,0)	//"Campo obrigatório não informado" |  "TES Saida"
EndIf

If cGeraNF == "1" .And. Empty(cCliente) .And. lRet
	lRet := .F.
	Help(" ",1,"AF125OBG",,STR0074 + " - '" + STR0042 + "'",1,0)	//"Campo obrigatório não informado" | "Cliente"
EndIf

If ( cGeraNF == "1" .And. Empty( cCondPag ) ) .And. lRet
	lRet := .F.
	Help(" ",1,"AF125OBG",,STR0074 + " - '" + STR0035 + "'",1,0)	//"Campo obrigatório não informado" | "Cond. Pgto"
EndIf

Return IIf( lRet, 1, 0 )

//BAIXA EM LOTE FIM
//--------------------------------------------------------------------------------

//TRANSFERENCIA EM LOTE INICIO
//---------------------------------------------------------------------------------
/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³SolTransLt ºAutor  ³Microsiga          º Data ³  29/08/10   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ Solicitação de transferência em lote.                      º±±
±±º          ³ Acionada através do botão Solic. transf. lote.             º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ SIGAATF                                                    º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
Function SolTransLt( cAlias, nReg, nOpc )

Local oDlg, oDlg1, oQtda, ocBasei, ocBasef
Local lInverte	 := .F.
Local nSavOrd1	 := IndexOrd()
Local nOpt		 := 0
Local nOpca      := 0
Local cExpFiltro := ".T."
Local cTipoAprov := ""
Local cVarSX6    := ""
Local lContinua  := .T.
Local aCampos    := {}
Local lTraLocal  := .F.

Local bFirst		:= { || SN1->( MsSeek( xFilial("SN1") + cBaseI + cItemI, .T. ) ) }
Local bFor 		:= { || SN1->N1_OK == cMarca .And. (SN1->N1_QUANTD > 0 ) }
Local bWhile 		:= { ||	!( SN1->(EOF())) .And.;
	SN1->N1_FILIAL == xFilial("SN1") .And.;
	SN1->N1_CBASE  <= cBaseF .And.;
	SN1->N1_ITEM   <= cItemF }

Private cBasei 		:= CriaVar( "NM_CBASE", .F. )
Private cItemI 		:= CriaVar( "NM_ITEM", .F. )
Private cBasef 		:= cBasei
Private cItemF 		:= Replicate( "Z", Len(cItemI) )
Private cLocAtivo   := CriaVar( "N1_LOCAL" )
PRIVATE cMarca	    := GetMark()
Private _cGERANF	:= "2"
Private _cClasNF	:= ""
Private _cTesS		:= CriaVar( "NM_TESNFS", .F. )
Private _cTesE		:= CriaVar( "NM_TESNFE", .F. )
Private _cNota		:= CriaVar( "NM_NOTA", .F.)
Private _cSerie		:= CriaVar( "NM_SERIE", .F.)
Private _cCONDPAG	:= CriaVar( "NM_CONDPG", .F.)
Private _cHistSol	:= Space(80)

cFilDest 	:= cFilAnt
cFilOrig 	:= cFilAnt

//Cria MsDialog para usuário digitar dados da transferência
//e guarda o retorno da função, que é um Array, em variáveis.
aRet 	   := AF125Trans( "SN3", , nOpc, @cExpFiltro )
aVar	   := aRet[1]
aCpDigit   := aRet[2]
nOpt	   := aRet[3]
cTipoAprov := aRet[4]

// Verifica se houve apenas a troca de locais 
lTraLocal := AF125TraLoc(aVar,cFilDest,cFilOrig)

//Se usuário cancelou, restaura Alias e encerra.


If nOpt == 1
	nQtdBens := 0

	//Cria Array com campos para tela de seleção
	AADD( aCampos, { "N1_OK", "", "  ", "" } )

	dbSelectArea( "SX3" )
	SX3->(DBSetOrder(1))
	SX3->(dbSeek("SN1"))

	Do While SX3->( !EOF() ) .And. ( X3_ARQUIVO == "SN1" )
	
		If ( X3USO( X3_USADO) .And. cNivel >= X3_NIVEL .And. SX3->X3_CONTEXT # "V") .Or.;
				( X3_PROPRI == "U" .And. X3_CONTEXT != "V" .And. X3_TIPO <> 'M' ) .Or.;
				Alltrim( X3_CAMPO ) $ "N1_CBASE#N1_ITEM"
		
			aAdd( aCampos, { X3_CAMPO, "", X3Titulo(), X3_PICTURE } )
		Endif
	
		SX3->( dbSkip() )
	EndDo

	//Filtro gerado em AF125Trans
	If !Empty( cExpFiltro )
		SN1->(dbSetFilter( { || &cExpFiltro }, cExpFiltro ) )
	EndIf

	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Faz o calculo automatico de dimensoes de objetos     ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	aSize := MSADVSIZE()

	DEFINE MSDIALOG oDlg1 	FROM  aSize[7],0 To aSize[6],aSize[5] TITLE STR0006 OF oMainWnd PIXEL // "Solic. Transf. Lote"
	oDlg1:lMaximized := .T.

	oPanel := TPanel():New(0,0,'',oDlg1,, .T., .T.,, ,70,70,.T.,.T. )
	oPanel:Align := CONTROL_ALIGN_TOP

	@ 05 , 5   SAY STR0111 + ":" 	SIZE 34, 7 OF oPanel PIXEL // "Do Codigo:"
	@ 05 , 40  SAY ocBasei 	VAR cBasei + " - " + cItemi SIZE 80, 10 OF oPanel PIXEL
	@ 05 , 127 SAY STR0120 + ":" 	SIZE 34, 7 OF oPanel PIXEL // "Ao Codigo:"
	@ 05 , 185 SAY ocBasef 	VAR cBasef + " - " + cItemf SIZE 80, 10 OF oPanel PIXEL

	@ 20, 5	   SAY STR0121 	SIZE 80, 10 OF oPanel PIXEL //"Total de bens a transferir"
	@ 20, 90   SAY oQtda 	VAR nQtdBens  SIZE 53, 10 OF oPanel PIXEL

	oMark := MsSelect():New( "SN1", "N1_OK", , aCampos, @lInverte, @cMarca, { 45, oDlg1:nLeft, oDlg1:nBottom, oDlg1:nRight }, 'Atf060Fil(1)', 'Atf060Fil(2)' )
	oMark:oBrowse:bAllMark := { || aF125Marca( "SN1", cMarca, .T. , oQtda, bFirst, bWhile, , , _cGeraNF,lTraLocal ) }
	oMark:bMark := {| | Af060display( cMarca, lInverte, oQtda, , cFilDest, cFilOrig, oMark ) }
	oMark:bAval := { || aF125Marca( "SN1", cMarca, .T., oQtda, bFirst, bWhile, .F., , _cGeraNF,lTraLocal ) }
	oMark:oBrowse:Align := CONTROL_ALIGN_ALLCLIENT

	ACTIVATE MSDIALOG oDlg1 ON INIT EnchoiceBar(oDlg1,{|| nOpca := 1,oDlg1:End()},{|| nOpca := 0,ODlg1:End()})

	If nOpca == 1
		If Left(cTipoAprov,1) != "1" // Resp. Geral
			cVarSX6 := GetMV( "MV_ATFRESP" )
		Endif
	
		If !SuperGetMV( 'MV_ATFWFM' ,, .F. )
			lContinua := .T.
		ElseIf !Empty(cVarSX6)
			PswOrder(1)
			// Se encontrou o usuario no cadastro de usuarios e o e-mail estiver preenchido
			If PswSeek(cVarSX6) .And. !Empty(Alltrim(PswRet()[1,14]))
				aEmailSol := { { Alltrim(PswRet()[1,14]), cVarSX6, .T. } }
				lContinua := .T.
			Else
				lContinua := .F.
				Help(" ",1,"AF125RESP",, STR0057 ,1,0)//"Ausência do endereço de e-mail no cadastro do responsável pelo Ativo."
			EndIf
		ElseIf Left(cTipoAprov,1) == "2" // Resp. Geral
			lContinua := .F.
			Help(" ",1,"AF125RESP",,STR0060,1,0)	//"Responsavel padrão dos Ativos não preenchido."
		Else
			lContinua := .T.
		Endif
	
		If lContinua
			Processa({|lEnd|  AF125LeSN3(cAlias, aVar, aCpDigit, dDataBAse,cFilDest,cFilOrig, cExpFiltro, .T., cTipoAprov)})
		Endif
	
	EndIf
EndIf

SN1->(dbClearFilter())

Return

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³AF125Trans ºAutor  ³Microsiga          º Data ³  29/08/10   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³  Solicitação de transferência em lote.                     º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ SIGAATF                                                    º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
Function AF125Trans( cAlias, nReg, nOpc, cExpFiltro )

Local aArea      := GetArea()
Local oDlg
Local nOpt		 := 1
Local cBase 	 := CriaVar( "NM_CBASE" , .f. )
Local cItem 	 := CriaVar( "NM_ITEM" , .f. )
Local dDataTrans := dDataBase
Local oBaseI
Local oBaseF
Local lGspInUseM := If( Type( 'lGspInUse' ) == 'L', lGspInUse, .F.)

Local nCustAtu 	 := 0, nValResid := 0
Local nHdlPrv	 := 0
Local cArquivo	 := ""
Local lCtb      	:= CtbInUse(), cAliasCta, cAliasCus, cAliasIt, cAliasCl
Local aCtb			// Variavel para contabilizacao entre filiais
Local aTitFolder := { "Conta contabil" }
Local aPages	 := {}
Local oPai
Local nLin		 := nPanelBem := 0
Local lCC		 := (lGspInUseM .Or. CtbMovSaldo("CTT"))
Local lItem		 := (! lGspInUseM .And. CtbMovSaldo("CTD"))
Local lClVl		 := (! lGspInUseM .And. CtbMovSaldo("CTH"))
Local lFolder    := .F.
Local bConta		:= { |cConta| A060DscCta(cConta, lCtb, lGspInUseM,"CT1") }
Local bCC    		:= { |cCc   | 	A060DscCta(cCc, lCtb, lGspInUseM,"CTT") }
Local bItem  		:= { |cItem | A060DscCta(cItem, lCtb, lGspInUseM,"CTD")}
Local bClVl  		:= { |cClvl | 	A060DscCta(cClvl, lCtb, lGspInUseM,"CTH")}
Local aObjetos		:= { { ,,,,, 	IIF(lGspInUseM, "NI1","CT1"), bConta } }, nTamObjs := 8, nEntidade, nGets

Local aVar     		:= { { "", "", "", "", "" } }		// Somente inicializo
Local aCpDigit		:= { { "N3_CCONTAB", "N3_CCORREC", "N3_CDEPREC", "N3_CCDEPR", "N3_CDESP", "N3_CCUSTO", "SN1->N1_LOCAL" } }
Local oLocal, oCCusto
Local ni
Local cN1TipoNeg := Alltrim(SuperGetMv("MV_N1TPNEG",.F.,"")) // Tipos de N1_PATRIM que aceitam Valor originais negativos
Local cN3TipoNeg := Alltrim(SuperGetMv("MV_N3TPNEG",.F.,"")) // Tipos de N3_TIPO que aceitam Valor originais negativos
Local oDataTrans
Local cGrupo := Space(Len(SN1->N1_GRUPO))
Local oGetGrupo
Local oGetTxPad
Local bCcdesp := { |cCCusto| aVar[2][3] := cCCusto, .T. } //Atualização dos campos de Centro de Custo.
Local lCcdp := GetMv("MV_ATFCCDP",.F.,.F.)
Local oGERANF
Local _cGERANF := "2"
Local oCbxClasNF
Local oHistSol
Local cTipoAprov := "1=" + STR0108	//"Responsavel individual"
Local aTipoAprov := { "1=" + STR0108, "2=" + STR0109}	//"Responsavel individual" | "Responsavel geral"
Local oTipoAprov

// Classificacoes 	1 - Classificacao do bem
//					2 - Correcao monetaria
//					3 - Despesa depreciacao
//					4 - Depreciacao acumulada
//					5 - Correcao Despesa Depreciacao

Private nTotal 		:= 0 , nTotal2:= 0
Private lPrim 		:= .T., lPrim2 := .T.

//********************************
// Controle de multiplas moedas  *
//********************************
Private aPicture	:= {}, cPictQtd
Private cLocAtivo

// VARIAVEIS PARA CONTABILIZACAO CONTA

CTABEM		:= ""
DESPDEPR	:= ""
DEPREACUM	:= ""
CORREDEPR	:= ""
CORREBEM	:= ""

// Variaveis para contabilizacao Centro de custo, item e classe de valor

Custo 		:= ""

CUSTBEMCTB	:= ""
CCCORRCTB	:= ""
CCDESPCTB	:= ""
CCCDESCTB	:= ""
CCCDEPCTB	:= ""

SUBCCONCTB	:= ""
SUBCCORCTB	:= ""
SUBCDESCTB	:= ""
SUBCDEPCTB	:= ""
SUBCCDECTB	:= ""

CLVLCONCTB	:= ""
CLVLCORCTB	:= ""
CLVLDESCTB	:= ""
CLVLDEPCTB	:= ""
CLVLCDECTB	:= ""

lAuto 		:= nReg = Nil
cFilDest 	:= cFilAnt
cFilOrig 	:= cFilAnt

// Posicionamento dos campos da tela para facilitar manutencao

#DEFINE 	P_LABEL			9
#DEFINE 	P_ORIGEM		75
#DEFINE 	P_DESTINO		150
#DEFINE 	P_ESPACO_OBJ    14

//Tipo Depreciacao diferente 02-Mes Subsequente
If GetMv( "MV_TIPDEPR" ) == "2" .And. dDatabase < ( FirstDay( GetMv( "MV_ULTDEPR" ) ) )
	Help(" ",1,"AF125TPDEP",,STR0122 + DTOC( SuperGetMv( "MV_ULTDEPR" ) ) ,1,0)	//"Tipo Depreciacao diferente 02-Mes Subsequente"
	Return
Endif

For nGets := 1 To Len(aCpDigit[1]) - 2
	nTamObjs += P_ESPACO_OBJ
Next

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Se CTB estiver em uso CT1 e CTT respectiva/e ao inves de SI1 e SI3        ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
If lCtb .And. ! lGspInUseM
	cAliasCta := "CT1"
	cAliasCus := "CTT"
	cAliasIt  := "CTD"
	cAliasCl  := "CTH"
Else
	If lGspInUseM
		cAliasCta := "NI1"
		cAliasCus := "NI3"
		cAliasIt  := ""
		cAliasCl  := ""
	Else
		cAliasCta := "SI1"
		cAliasCus := "SI3"
		cAliasIt  := "SID"
		cAliasCl  := ""
	Endif
EndIf

// A posicao do Centro de Custo torna-se obrigatoria quando existir Item ou Classe de Valor.
If lCc .or. lItem .or. lClVl
	Aadd( aTitFolder, IIF( lGspInUseM, STR0078, CtbSayApro( "CTT" ) ) )	//"Centro de Custo"
	Aadd( aObjetos, { ,,,,, IIF( lGspInUseM, "NI3", "CTT" ), bCC } )
	Aadd( aVar, AClone(aVar[1]))
	Aadd( aCpDigit, { "N3_CUSTBEM", "N3_CCCORR", "N3_CCDESP", "N3_CCCDEP", "N3_CCCDES" } )
Endif

// A posicao do item torna-se obrigatoria quando existir a Classe de Valor.
If lItem .or. lClVl
	Aadd( aTitFolder, CtbSayApro( "CTD" ) )
	Aadd( aObjetos, { ,,,,, "CTD", bItem } )
	Aadd( aVar, AClone(aVar[1]))
	Aadd( aCpDigit, { "N3_SUBCCON", "N3_SUBCCOR", "N3_SUBCDEP", "N3_SUBCCDE", "N3_SUBCDES" } )
Endif

If lClVl
	Aadd( aTitFolder, CtbSayApro("CTH"))
	Aadd( aObjetos, { ,,,,, "CTH", bClVl })
	Aadd( aVar, AClone(aVar[1]))
	Aadd( aCpDigit, { "N3_CLVLCON", "N3_CLVLCOR", "N3_CLVLDEP", "N3_CLVLCDE", "N3_CLVLDES" })
Endif

lFolder   := Len(aTitFolder) > 1

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Pesquisa picture para valores do ativo									³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
cPictQtd  := PesqPict("SN1","N1_QUANTD", 12)

//********************************
// Controle de multiplas moedas  *
//********************************
If lMultMoed
	AtfMultMoe( ,,{ |x| Aadd(aPicture, PesqPict( "SN3", "N3_VORIG" + Alltrim(Str(x)), 18) ) } )
Else
	aPicture := {nil,nil,nil,nil,nil}
	aPicture[1] := PesqPict("SN3","N3_VORIG1", 18)
	aPicture[2] := PesqPict("SN3","N3_VORIG2", 18)
	aPicture[3] := PesqPict("SN3","N3_VORIG3", 18)
	aPicture[4] := PesqPict("SN3","N3_VORIG4", 18)
	aPicture[5] := PesqPict("SN3","N3_VORIG5", 18)
EndIf
Pergunte("AFA060", .F.)

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Carrega as perguntas selecionadas:                            ³
//³ mv_par01 - 1 Contabiliza                                      ³
//³            2 NAO Contabiliza                                  ³
//³ mv_par02 - 1 Mostra Lancto Cont bil                           ³
//³            2 Nao Mostra Lancto Cont bil                       ³
//³ mv_par03 - 1 Aglutina Lancto                                  ³
//³          - 2 Nao Aglutina Lancto                              ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Verifica se o registro n„o est  em uso por outra esta‡„o. ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

dbSelectArea( cAlias )

Aadd(aVar[1], CriaVar("N3_CCUSTO",.F.))
Aadd(aVar[1], SN1->N1_LOCAL)

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³	 No caso de contas de Capital, nÆo vai a corre‡Æo monet ria.		³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
cPatrim  	:= SN1->N1_PATRIM
nValor	 	:= Iif( cPatrim # "C" , SN3->N3_VORIG1+SN3->N3_VRCACM1+SN3->N3_AMPLIA1, SN3->N3_VORIG1+SN3->N3_AMPLIA1 )

nQtdeSn  	:= IIF(SN1->N1_QUANTD == 0, 1, SN1->N1_QUANTD)
nQtdOrig 	:= nQtdeSn
nQuant	 	:= nQtdeSn
nCustAtu 	:= nValor

If SN3->N3_TIPO = "05" .Or. (SN1->N1_PATRIM $ cN1TipoNeg) .Or. (SN3->N3_TIPO $ cN3TipoNeg)
	nValResid:= nValor + Abs( (SN3->N3_VRDACM1 + SN3->N3_VRCDA1) )
Else
	nValResid:= nValor - ( SN3->N3_VRDACM1 + SN3->N3_VRCDA1 )
Endif

nOpt 	 	:= 0
nLin 		:= 14

DEFINE 	MSDIALOG oDlg FROM  36,1 TO 600 - If(lFolder, 0, 35),540 TITLE STR0123 PIXEL	//"Solicitação de transferência em lote."

@ 004, 004 	TO 040, (oDlg:nRight / 2) - 7 LABEL STR0124 OF oDlg  PIXEL // "Filtrar Origem"

@ nLin - 0,009 	SAY STR0111 + ":"		SIZE 34, 7 OF oDlg PIXEL // "Do Código:"
@ nLin - 2,045	MSGET oBasei VAR cBasei   	F3 "SN1"	Valid Af060Base(cBasei)   SIZE 60, 10 OF oDlg PIXEL
@ nLin - 0,115 	SAY STR0146 + ":"		SIZE 34, 7 OF oDlg PIXEL // "Do Item:"
@ nLin - 2,145	MSGET cItemi   	SIZE 30, 10 OF oDlg PIXEL
oBasei:bChange := {|| cBasef := cBasei , oBasef:Refresh() }

nLin += 14

@ nLin - 0,009 	SAY STR0120 + ":"		SIZE 34, 7 OF oDlg PIXEL // "Ao Código:"
@ nLin - 2,045 	MSGET oBasef VAR cBasef   	F3 "SN1"	Valid Af060Base(cBasef)   SIZE 60, 10 OF oDlg PIXEL
@ nLin - 0,115 	SAY STR0147 + ":"		SIZE 34, 7 OF oDlg PIXEL // "Até Item:"
@ nLin - 2,145	MSGET cItemf   	SIZE 30, 10 Valid !Empty(cItemF) OF oDlg PIXEL

nLin += 14

@ nLin, 004 	TO 094, (oDlg:nRight / 2) - 7 LABEL STR0125 OF oDlg  PIXEL // "Transferir para"

nLin += 10

@ nLin - 0,009 	SAY STR0126  	SIZE 34, 7 OF oDlg PIXEL // "Filial Destino"
@ nLin - 1,055  	MSGET cFilDest	Valid AfA060Fil(cFilDest) .And. AtGeraNF(cFilDest,cFilOrig,@_cGERANF);
When !Empty(xFilial("SN3")) F3 "XM0" SIZE 40, 10 OF oDlg PIXEL

nLin += 14

@ nLin - 0,006		SAY STR0078				SIZE 53, 07 OF oPai PIXEL // "Centro Custo"

@ nLin - 2,055	MSGET oCCusto VAR aVar[1][6]	SIZE 69, 10 OF oPai PIXEL  Picture "@!" F3 cAliasCus Valid AF060CCusto( @aVar[1][6], cAliasCus ) .And. Iif(lCcdp,Eval(bCcdesp, aVar[1][6]),.T.)
@ nLin - 3,160	SAY oCusto  PROMPT Eval(bCc, aVar[1][6]) OF oPai PIXEL FONT oDlg:oFont COLOR CLR_HBLUE

oCCusto:cReadVar := "N3_CCUSTO"

nLin += 14

@ nLin - 0,006	SAY STR0127 SIZE 53, 07 OF oPai PIXEL // "Localização"
@ nLin - 2,055 	MSGET oLocal VAR aVar[1][7]	SIZE 69, 10 OF oPai PIXEL Picture "@!" F3 CpoRetF3("N1_LOCAL") Valid CheckSx3("N1_LOCAL", aVar[1][7])

oLocal:cReadVar := "N1_LOCAL"

nLin += 16

@ nLin, 004 TO 173, (oDlg:nRight / 2) - 7 LABEL STR0038 OF oDlg  PIXEL // "Dados da Nota Fiscal"
@ nLin+8 , 007	SAY STR0128			SIZE 024, 009 OF oDlg PIXEL  //"Num.NF"
@ nLin+7 , 045	COMBOBOX oGERANF	VAR _cGERANF ITEMS { "1=" + STR0040, "2=" + STR0041 }	SIZE 30,  9 OF oDlg PIXEL WHEN cFilDest != cFilOrig VALID  A125VlTrLt("cGERANF")
@ nLin+8 , 080	SAY STR0129			SIZE 042, 009 OF oDlg PIXEL  //"Tip Clas NFE"
@ nLin+7 , 120	COMBOBOX oCbxClasNF	VAR _cClasNF ITEMS { "1=" + STR0063, "2=" + STR0064, "" }	SIZE 46,  9 OF oDlg PIXEL WHEN _cGERANF == "1"
@ nLin+8 , 175	SAY STR0044			SIZE 032, 009 OF oDlg PIXEL  //"TES Saida"
@ nLin+7 , 210	MSGET oTESNFS VAR _cTesS		SIZE 015, 009 OF oDlg PIXEL WHEN _cGERANF == "1" VALID A125VlTrLt( "TESNFS" , cFilOrig)
oTESNFS:BF3 := { || AF125F3Dst( cFilOrig, "SF4", "F4_CODIGO", @_cTesS, @oTESNFS ) }
@ nLin+21, 007	SAY STR0045			SIZE 024, 009 OF oDlg PIXEL  //"Num.NF"
@ nLin+20, 045	MSGET _cNota		SIZE 028, 009 OF oDlg PIXEL F3 "SF2" WHEN _cGERANF == "3" VALID  A125VlTrLt("cNota")
@ nLin+21, 100	SAY STR0046			SIZE 016, 009 OF oDlg PIXEL  //"Serie"
@ nLin+20, 118	MSGET _cSerie		SIZE 021, 009 OF oDlg PIXEL F3 "01"  WHEN _cGERANF == "1" VALID Vazio(_cSerie) .Or. ExistCpo("SX5","01"+_cSerie)
@ nLin+21, 175	SAY STR0090			SIZE 042, 009 OF oDlg PIXEL  //"TES Entrada"
@ nLin+20, 210	MSGET oTESNFE VAR _cTesE		SIZE 015, 009 OF oDlg PIXEL WHEN _cGERANF == "1" VALID A125VlTrLt( "TESNFE" , cFilDest )
oTESNFE:BF3 := { || AF125F3Dst( cFilDest, "SF4", "F4_CODIGO", @_cTesE, @oTESNFE ) }
@ nLin+34, 007	SAY STR0035			SIZE 032, 009 OF oDlg PIXEL  //"Até"
@ nLin+33, 045	MSGET _cCONDPAG		SIZE 019, 009 OF oDlg PIXEL F3 "SE4" WHEN _cGERANF == "1" VALID Vazio(_cCONDPAG) .Or. ExistCpo("SE4",_cCONDPAG)

@ nLin+33, 150	COMBOBOX oTipoAprov VAR cTipoAprov	ITEMS aTipoAprov	OF oDlg SIZE 80, 40 PIXEL
@ nLin+34, 078	SAY STR0114	OF oDlg PIXEL 	//"Gera aprovação para"

@ nLin+47, 007	SAY STR0050	SIZE 32, 7 OF oDlg PIXEL FONT oDlg:oFont COLOR CLR_HBLUE  //"Hist. Solic."
@ nLin+46, 045	GET oHistSol VAR _cHistSol OF oDlg MULTILINE SIZE 177, 25 HSCROLL PIXEL

nLin += 080

If lFolder
	
	oFolder := TFolder():New(	nLin,04,aTitFolder,aPages,oDlg,,,,.T.,.F.,(oDlg:nRight / 2) - 10,nTamObjs + 20,)
	
	For ni := 1 to Len(oFolder:aDialogs)
		DEFINE SBUTTON FROM 5000,5000 TYPE 5 ACTION Allwaystrue() ENABLE OF oFolder:aDialogs[ni]
	Next
	
	oPai := oFolder:aDialogs[1]
Else
	oPai := oDlg
Endif

//dbSelectArea("SN3")

nLin += 23

nPanelBem := nLin

For nEntidade := 1 To Len(aTitFolder)
	If lFolder
		nLin 	:= 2
		nColFim := 310
	Else
		nColFim := 320
		nLin 	:= nPanelBem
	Endif
	
	If nEntidade > 1
		oPai := oFolder:aDialogs[nEntidade]
	Endif
	
	@ nLin, 004 TO nLin + nTamObjs - 1,070 LABEL STR0068 OF oPai  PIXEL // "Dados Contabeis"
	
	@ nLin-3, 072 TO nLin + nTamObjs - 1,(oDlg:nRight / 2) - 14 LABEL STR0029 OF oPai PIXEL // "Destino"
	@ nLin+1, 160 SAY "(*) " + STR0130 SIZE 53, 07 OF oPai PIXEL // "(*) Destino igual origem"
	
	nLin += 8
	
	// Identificacao do bem
	
	IF aObjetos[nEntidade][6] $ "CT1#NI1"
		Af060Get(	aVar[nEntidade], aCpDigit[1][1], cAliasCta, @nLin, oPai, bConta,;
		aObjetos[nEntidade], 1)
	ElseIf aObjetos[nEntidade][6] $ "CTT#NI3"
		Af060Get(	aVar[nEntidade], aCpDigit[2][1], cAliasCus, @nLin, oPai, bCc,;
		aObjetos[nEntidade], 1)
	ElseIf aObjetos[nEntidade][6] = "CTD"
		Af060Get(	aVar[nEntidade], aCpDigit[3][1], cAliasIt, @nLin, oPai, bItem,;
		aObjetos[nEntidade], 1)
	Else
		Af060Get(	aVar[nEntidade], aCpDigit[4][1], cAliasCl, @nLin, oPai, bClVl,;
		aObjetos[nEntidade], 1)
	Endif
	
	// Correcao monetaria
	
	IF aObjetos[nEntidade][6] $ "CT1#NI1"
		Af060Get(	aVar[nEntidade], aCpDigit[1][2], cAliasCta, @nLin, oPai, bConta,;
		aObjetos[nEntidade], 2)
	ElseIf aObjetos[nEntidade][6] $ "CTT#NI3"
		Af060Get(	aVar[nEntidade], aCpDigit[2][2], cAliasCus, @nLin, oPai, bCc,;
		aObjetos[nEntidade], 2)
	ElseIf aObjetos[nEntidade][6] = "CTD"
		Af060Get(	aVar[nEntidade], aCpDigit[3][2], cAliasIt, @nLin, oPai, bItem,;
		aObjetos[nEntidade], 2)
	Else
		Af060Get(	aVar[nEntidade], aCpDigit[4][2], cAliasCl, @nLin, oPai, bClVl,;
		aObjetos[nEntidade], 2)
	Endif
	
	// Despesa depreciacao
	
	IF aObjetos[nEntidade][6] $ "CT1#NI1"
		Af060Get(	aVar[nEntidade], aCpDigit[1][3], cAliasCta, @nLin, oPai, bConta,;
		aObjetos[nEntidade], 3)
	ElseIf aObjetos[nEntidade][6] $ "CTT#NI3"
		Af060Get(	aVar[nEntidade], aCpDigit[2][3], cAliasCus, @nLin, oPai, bCc,;
		aObjetos[nEntidade], 3)
	ElseIf aObjetos[nEntidade][6] = "CTD"
		Af060Get(	aVar[nEntidade], aCpDigit[3][3], cAliasIt, @nLin, oPai, bItem,;
		aObjetos[nEntidade], 3)
	Else
		Af060Get(	aVar[nEntidade], aCpDigit[4][3], cAliasCl, @nLin, oPai, bClVl,;
		aObjetos[nEntidade], 3)
	Endif
	
	// Depreciacao acumulada
	
	IF aObjetos[nEntidade][6] $ "CT1$NI1"
		Af060Get(	aVar[nEntidade], aCpDigit[1][4], cAliasCta, @nLin, oPai, bConta,;
		aObjetos[nEntidade], 4)
	ElseIf aObjetos[nEntidade][6] $ "CTT#NI3"
		Af060Get(	aVar[nEntidade], aCpDigit[2][4], cAliasCus, @nLin, oPai, bCc,;
		aObjetos[nEntidade], 4)
	ElseIf aObjetos[nEntidade][6] = "CTD"
		Af060Get(	aVar[nEntidade], aCpDigit[3][4], cAliasIt, @nLin, oPai, bItem,;
		aObjetos[nEntidade], 4)
	Else
		Af060Get(	aVar[nEntidade], aCpDigit[4][4], cAliasCl, @nLin, oPai, bClVl,;
		aObjetos[nEntidade], 4)
	Endif
	
	// Correcao monetaria depreciacao
	
	IF aObjetos[nEntidade][6] $ "CT1#NI1"
		Af060Get(	aVar[nEntidade], aCpDigit[1][5], cAliasCta, @nLin, oPai, bConta,;
		aObjetos[nEntidade], 5)
	ElseIf aObjetos[nEntidade][6] $ "CTT#NI3"
		Af060Get(	aVar[nEntidade], aCpDigit[2][5], cAliasCus, @nLin, oPai, bCc,;
		aObjetos[nEntidade], 5)
	ElseIf aObjetos[nEntidade][6] = "CTD"
		Af060Get(	aVar[nEntidade], aCpDigit[3][5], cAliasIt, @nLin, oPai, bItem,;
		aObjetos[nEntidade], 5)
	Else
		Af060Get(	aVar[nEntidade], aCpDigit[4][5], cAliasCl, @nLin, oPai, bClVl,;
		aObjetos[nEntidade], 5)
	Endif
Next

DEFINE SBUTTON 	FROM /*nPanelBem - */P_ESPACO_OBJ + 65, (oDlg:nRight / 2) - 100 TYPE 17	ENABLE OF oDlg ACTION SN1->(cExpFiltro := BuildExpr( "SN1", oDlg ) )
DEFINE SBUTTON 	FROM /*nPanelBem - */P_ESPACO_OBJ + 65, (oDlg:nRight / 2) - 70  TYPE 1  ENABLE OF oDlg ACTION ( ( nOpt := TudOkTrLt(), IIf( nOpt == 1, Odlg:End(), .F.) ) )
DEFINE SBUTTON 	FROM /*nPanelBem - */P_ESPACO_OBJ + 65, (oDlg:nRight / 2) - 40  TYPE 2  ENABLE OF oDlg ACTION ( nOpt := 0, oDlg:End() )
ACTIVATE MSDIALOG oDlg CENTERED

cFilAnt := cFilOrig		// Garanto que a filial atual seja a original

RestArea( aArea )

Return { aVar, aCpDigit, nOpt, cTipoAprov }

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³A125VlTrLt  ºAutor  ³Microsiga         º Data ³  08/27/10   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ Valida o valor dos campos da solicitacao de transferencia  º±±
±±º          ³ em lote                                                    º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ SIGAATF                                                    º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
Function A125VlTrLt( cCpoTrLt , _cFilOri )
Local _cFilDes := cFilAnt
Local aArea := GetArea()
Local lRet  := .T.

Do Case
	Case cCpoTrLt == "cGERANF"
		If  _cGERANF == "2"
			_cClasNF	:= ""
			_cTesS		:= CRIAVAR("NM_TESNFS",.F.)
			_cTesE		:= CRIAVAR("NM_TESNFE",.F.)
			_cCONDPAG	:= CRIAVAR("NM_CONDPG",.F.)
			If Empty(_cNota)
				_cSerie := CRIAVAR("NM_SERIE",.F.)
			EndIf
		ElseIf _cGERANF == "1"
			_cNota		:= CRIAVAR("NM_NOTA",.F.)
		EndIf
	Case cCpoTrLt == "cNota"
		If !Empty(_cNota)
			dbSelectArea("SF2")
			SF2->(dbSetOrder(1))
			If SF2->( dbSeek( xFilial( "SF2" ) + _cNota ) )
				_cSerie	:= SF2->F2_SERIE
				_cTesS	:= CRIAVAR("NM_TESNFS")
				_cTesE	:= CRIAVAR("NM_TESNFE")
			Else
				lRet	:= .F.
				Help(" ",1,"AF125TES",,STR0072,1,0)//"Código não cadastrado"
			EndIf
		Else
			_cSerie := CRIAVAR( "NM_SERIE", .F. )
		EndIf
		
	Case cCpoTrLt == "TESNFS"
		If _cGeraNF == "1"
			//ATENCAO! alteracao do valor da variavel publica cFilAnt
			If _cFilDes != _cFilOri
				cFilAnt := _cFilOri
			EndIf
			
			If !Empty( _cTESs )
				dbSelectArea( "SF4" )
				SF4->(dbGoTop())
				If SF4->(dbSeek( xFilial( "SF4" ) + _cTESs ) )
					If SF4->F4_TIPO == "E"
						lRet := .F.
						Help(" ",1,"AF125TESS",,STR0139,1,0)	//"A TES utilizada deve ser de saída!"  
					ElseIf SF4->F4_ATUATF == "S" .Or. SF4->F4_DUPLIC == "S" .Or. SF4->F4_ESTOQUE == "S"
						lRet := .F.
						Help(" ",1,"AF125TESDUP",,STR0140,1,0)//"A TES utilizada não pode gerar duplicata, atualizar estoque ou atualizar ativo fixo!"
					EndIf
				Else
					lRet := .F.
					Help(" ",1,"AF125TESENC",,STR0141,1,0)	//"TES não encontrada!"
				EndIf
			Else
				lRet := .F.
				Help(" ",1,"AF125TESOBG",,STR0142,1,0)	//"Preencha o campo TES!"
			EndIf
			//ATENCAO! retorno do valor da variavel publica cFilAnt
			If cFilAnt	!= _cFilDes
				cFilAnt	:= _cFilDes
			EndIf
		EndIf
	Case cCpoTrLt == "TESNFE"
		If _cGeraNF == "1"
			If !Empty( _cTesE )
				dbSelectArea( "SF4" )
				SF4->(dbGoTop())
				If SF4->(dbSeek( xFilial( "SF4" ) + _cTesE ) )
					If SF4->F4_TIPO == "S"
						lRet := .F.
						Help(" ",1,"AF125TESE",,STR0145,1,0)	//"A TES utilizada deve ser de entrada!"
					ElseIf SF4->F4_ATUATF == "S" .Or. SF4->F4_DUPLIC == "S" .Or. SF4->F4_ESTOQUE == "S"
						lRet := .F.
						Help(" ",1,"AF125TESDUP",,STR0140,1,0)//"A TES utilizada não pode gerar duplicata, atualizar estoque ou atualizar ativo fixo!"
					EndIf
				Else
					lRet := .F.
					Help(" ",1,"AF125TESENC",,STR0141,1,0)	//"TES não encontrada!"
				EndIf
			Else
				lRet := .F.
				Help(" ",1,"AF125TESOBG",,STR0142,1,0)	//"Preencha o campo TES!"
			EndIf
		EndIf
EndCase

RestArea( aArea )

Return(lRet)


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³TudOkTrLt ºAutor  ³Microsiga           º Data ³  08/27/10   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ Verifica preenchimento dos campos obrigatorios             º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ SIGAATF                                                    º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
Static Function TudOkTrLt()

Local lRet := .T.

//Verifica o preenchimento de campos obrigatórios.
If Empty( _cHistSol ) .And. lRet
	lRet := .F.
	Help(" ",1,"AF125OBG",,STR0074 + " - '" + STR0050 + "'",1,0)	//"Campo obrigatório não informado" |  "Hist. Solic."
EndIf

If ( _cGeraNF == "1" .And. Empty( _cSerie ) ) .And. lRet
	lRet := .F.
	Help(" ",1,"AF125OBG",,STR0074 + " - '" + STR0046 + "'",1,0)	//"Campo obrigatório não informado" | "Serie"
EndIf

If ( _cGeraNF == "1" .And. Empty( _cTesE ) ) .And. lRet
	lRet := .F.
	Help(" ",1,"AF125OBG",,STR0074 + " - '" + STR0090 + "'",1,0)	//"Campo obrigatório não informado" |"TES Entrada"
EndIf

If ( _cGeraNF == "1" .And. Empty( _cTesS ) ) .And. lRet
	lRet := .F.                                                                                                       
	Help(" ",1,"AF125OBG",,STR0074 + " - '" + STR0044 + "'",1,0)	//"Campo obrigatório não informado" | "TES Saida"
EndIf

If ( _cGeraNF == "1" .And. Empty( _cCondPag ) ) .And. lRet
	lRet := .F.                                                                                                       
	Help(" ",1,"AF125OBG",,STR0074 + " - '" + STR0035 + "'",1,0)	//"Campo obrigatório não informado" | "Cond. Pgto"
EndIf

If ( _cGeraNF == "1" .And. Empty( _cClasNF ) ) .And. lRet
	lRet := .F.                                                                                                       
	Help(" ",1,"AF125OBG",,STR0074 + " - '" + STR0089 + "'",1,0)	//"Campo obrigatório não informado" | "Tip Clas NFE"
EndIf

Return IIf( lRet, 1, 0 )

/*/
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡„o	 ³ AF125LeSN3 ³ Autor ³ Microsiga             ³ Data ³ 27/08/10 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡„o ³ Leitura do SN3          										³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso		 ³ Generico 													³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
Function AF125LeSN3( cAlias, aVar, aCpDigit, dDataTrans, cFilDest, cFilOrig,;
cExpFiltro, lAutomatico, cTipoAprov )

Local aArea      := GetArea()
Local cPatrim    := ""
Local nProcRec 	 := 0
Local nRecAtu  	 := 0
Local lUltReg  	 := .F.
Local nHdlPrv  	 := 0
Local cArquivo   := ""
Local aCtb		 := { { }, { } }		// Retorno para contabilizacao
Local lAst		 := .F.
Local nRegSN3	 := 0
Local nEntDigit  := 1
Local nCpDigit	 := 1
Local aBackVar	 := {}
Local lGspInUseM := If(Type('lGspInUse')=='L', lGspInUse, .F.)
Local lNgaTfMnt  := FindFunction("NGATFMNT")
Local dUltDepr 	 := GetMV("MV_ULTDEPR")
Local nTaxaMedia := Af060moeda(If(lGspInUseM,MsSomaMes(dUltDepr,-1,.T.),dUltDepr))
Local cTxPad	 := ""
Local cDataSol	 := dDataBase
Local cHoraSol	 := StrTran(Left(Time(),5),':','')
Local cCodSol	 := ""

Private nTotal := 0
Private lPrim  := .T.

If Left( cTipoAprov, 1 ) == "2" // Resp. Geral
	cCodSol := GetSxENum( "SNM", "NM_CODIGO" )
Endif

dbSelectArea( "SN1" )
SN1->( dbSetOrder(1) )
SN1->( MsSeek( xFilial( "SN1" ) + cBasei + cItemi, .T. ) )
ProcRegua( SN1->(RecCount()) )

dbSelectArea( "SN3" )
SN3->( dbSetOrder(1) )

If cFilDest == cFilOrig
	
	While SN1->(!Eof()) .And. xFilial( "SN1" ) == SN1->N1_FILIAL .And. SN1->N1_CBASE <= cBasef .And. SN1->N1_ITEM <= cItemf
		IncProc()

		//bem pendente de classificacao
		If SN1->N1_STATUS == "0"
			SN1->( dbSkip() )
			Loop
		EndIf

		// Se nao existir o filtro do usuario ou se ele retornar .T., marca o registro
		dbSelectArea( "SN3" )
		If Empty( cExpFiltro ) .Or. SN1->( &(cExpFiltro) )
			
			SN3->( dbSeek( xFilial( "SN3" ) + SN1->N1_CBASE + SN1->N1_ITEM ) )
			
			If SN1->N1_OK == cMarca
				//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
				//³	No caso de contas de Capital, nÆo vai a corre‡Æo monet ria. ³
				//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
				cPatrim	:= SN1->N1_PATRIM
				
				If SN1->( FieldPos( "N1_TAXAPAD" ) ) > 0
					cTxPad := SN1->N1_TAXAPAD
				EndIf
				
				nValor	:= Iif( cPatrim # "C" , SN3->N3_VORIG1 + SN3->N3_VRCACM1 + SN3->N3_AMPLIA1, SN3->N3_VORIG1 + SN3->N3_AMPLIA1 )
				
				If Left( cTipoAprov, 1 ) == "1" // Resp. Individual
					//Verifica se WorkFlow está ativado
					If SuperGetMv( "MV_ATFWFM", , .F. )
						// Preenche a matriz PRIVATE aEmailSol com o e-mail dos responsaveis
						A125VlRspWF( SN3->N3_CBASE, SN3->N3_ITEM )
					EndIf
					cCodSol := GetSxENum( "SNM", "NM_CODIGO" )
				Endif
				GravaTr(SN3->N3_CBASE												,; //Codigo do Bem
				SN3->N3_ITEM												,; //Item do Bem
				SN3->N3_TIPO												,; //Tipo do Bem
				cFilDest													,; //Filial Destino
				SN1->N1_GRUPO												,; //Grupo do Bem
				IIf(AllTrim(aVar[1][6]) == "*", SN3->N3_CCUSTO , aVar[1][6])	,; //Centro de Custo destino - cCCustoDst
				IIf(AllTrim(aVar[1][7]) == "*", SN3->N3_LOCAL  , aVar[1][7])	,; //Local destino - cLocalDst
				IIf(AllTrim(aVar[1][1]) == "*", SN3->N3_CCONTAB, aVar[1][1])	,; //Conta do Bem destino - cCContabDst
				IIf(AllTrim(aVar[1][2]) == "*", SN3->N3_CCORREC, aVar[1][2])	,; //Conta - cCCorrecDst
				IIf(AllTrim(aVar[1][3]) == "*", SN3->N3_CDEPREC, aVar[1][3])	,; //Conta - cCDeprecDst
				IIf(AllTrim(aVar[1][4]) == "*", SN3->N3_CCDEPR , aVar[1][4])	,; //Conta - cCDDeprDst
				IIf(AllTrim(aVar[1][5]) == "*", SN3->N3_CDESP  , aVar[1][5])	,; //Conta - cCDespDst
				IIf(AllTrim(aVar[2][1]) == "*", SN3->N3_CUSTBEM, aVar[2][1])	,; //Centro de Custo - cCustBemDst
				IIf(AllTrim(aVar[2][2]) == "*", SN3->N3_CCCORR , aVar[2][2])	,; //Centro de Custo - cCCCorrDst
				IIf(AllTrim(aVar[2][3]) == "*", SN3->N3_CCDESP , aVar[2][3])	,; //Centro de Custo - cCCDespDst
				IIf(AllTrim(aVar[2][4]) == "*", SN3->N3_CCCDEP , aVar[2][4])	,; //Centro de Custo - cCCCDepDst
				IIf(AllTrim(aVar[2][5]) == "*", SN3->N3_CCCDES , aVar[2][5])	,; //Centro de Custo - cCCCDESDst
				IIf(Len(aVar) < 3 .Or. AllTrim(aVar[3][1]) == "*", SN3->N3_SUBCCON, aVar[3][1])	,; //Item Contabil  - cItBemDst
				IIf(Len(aVar) < 3 .Or. AllTrim(aVar[3][2]) == "*", SN3->N3_SUBCCOR, aVar[3][2])	,; //Item Contabil - cItCorrDst
				IIf(Len(aVar) < 3 .Or. AllTrim(aVar[3][3]) == "*", SN3->N3_SUBCDEP, aVar[3][3])	,; //Item Contabil - cItDespDst
				IIf(Len(aVar) < 3 .Or. AllTrim(aVar[3][4]) == "*", SN3->N3_SUBCCDE, aVar[3][4])	,; //Item Contabil - cItCDepDst
				IIf(Len(aVar) < 3 .Or. AllTrim(aVar[3][5]) == "*", SN3->N3_SUBCDES, aVar[3][5])	,; //Item Contabil - cItCDesDst
				IIf(Len(aVar) < 4 .Or. AllTrim(aVar[4][1]) == "*", SN3->N3_CLVLCON, aVar[4][1])	,; //Classe de Valor - cClVlBemDst
				IIf(Len(aVar) < 4 .Or. AllTrim(aVar[4][2]) == "*", SN3->N3_CLVLCOR, aVar[4][2])	,; //Classe de Valor - cClVlCorDst
				IIf(Len(aVar) < 4 .Or. AllTrim(aVar[4][3]) == "*", SN3->N3_CLVLDEP, aVar[4][3])	,; //Classe de Valor - cClVlDepDst
				IIf(Len(aVar) < 4 .Or. AllTrim(aVar[4][4]) == "*", SN3->N3_CLVLCDE, aVar[4][4])	,; //Classe de Valor - cClVlCDeDst
				IIf(Len(aVar) < 4 .Or. AllTrim(aVar[4][5]) == "*", SN3->N3_CLVLDES, aVar[4][5])	,; //Classe de Valor - cClVlDesDst
				_cGeraNF													,; //Gera NF?
				_cClasNF													,; //Classificacao da NF
				_cTesS														,; //TES de Saida
				_cTesE														,; //TES de entrada
				_cNota														,; //Numero da NF (Caso já haja)
				_cSerie														,; //Serie da NF
				cDataSol													,; //Data da solicitacao
				cHoraSol													,; //Hora da Solicitacao
				__cUserID													,; //Codigo do solicitante
				_cHistSol													,; //Historico da solicitacao
				cCodSol														,; //Codigo da solicitacao
				_cCondpag													)  //Condicao de pagamento
				
				If Left(cTipoAprov,1) == "1" // Resp. Individual
					ConfirmSx8()
					
					If SuperGetMV( 'MV_ATFWFM' ,, .F. )
						//Chamada do WorkFlow
						A125WfTr( cCodSol )
					EndIf
				Endif
			Endif
		Endif
		SN1->( DbSkip() )
	EndDo
	
	If Left( cTipoAprov, 1 ) == "2" // Resp. Geral
		ConfirmSx8()
		If SuperGetMV( 'MV_ATFWFM', , .F. )
			//Chamada do WorkFlow
			A125WfTr(cCodSol)
		EndIf
	Endif
	
Else
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³cFilOrig <> cFilDest       ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³Verifica se contas transferidas existem na filial destino³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	lAst := .F.
	For nEntDigit := 1 to Len(aVar)
		For nCpDigit := 1 To Len(aVar[nEntDigit])
			If AllTrim( aVar[nEntDigit][nCpDigit] ) == "*"
				lAst := .T.
				Exit
			EndIf
		Next nCpDigit
		If lAst
			Exit
		EndIf
	Next nEntDigit
	
	aBackVar := aClone( aVar )
	SN1->( MsSeek( xFilial( "SN1" ) + cBasei + cItemi, .T. ) )
	
	While SN1->(!Eof()) .And.;
		xFilial( "SN1" ) == SN1->N1_FILIAL .And.;
		SN1->N1_CBASE <= cBasef .And.;
		SN1->N1_ITEM <= cItemf
		//bem pendente de classificacao
		If SN1->N1_STATUS == "0"
			SN1->( dbSkip() )
			Loop
		EndIf
		
		// Se nao existir o filtro do usuario ou se ele retornar .T., marca o registro
		If Empty( cExpFiltro ) .Or. SN1->(&( cExpFiltro ))
			If SN1->N1_OK == cMarca
				SN3->( dbSeek( xFilial( "SN3" ) + SN1->N1_CBASE + SN1->N1_ITEM ) )
				aVar := aClone( aBackVar )			/// RESTAURA O aVar PARA O PRÓXIMO ITEM (PODE TER ORIGENS DIFERENTES)
				If lAst								/// SE TIVER ASTERISCO NO CONTEÚDO DE ALGUMA VARIAVEL (VALIDA ORIGEM = DESTINO)
					For nEntDigit := 1 to Len(aVar)
						For nCpDigit := 1 To Len(aVar[nEntDigit])
							If ALLTRIM(aVar[nEntDigit][nCpDigit]) == "*"
								aVar[nEntDigit][nCpDigit] := &( "SN3->" + aCpDigit[nEntDigit][nCpDigit] )
							EndIf
						Next nCpDigit
					Next nEntDigit
				EndIf
				
				If !AF060ExiFil( aVar[1][1], aVar[1][2], aVar[1][3],aVar[1][4],aVar[1][5],;
					aVar[1][6], cFilDest, cFilOrig, aCpDigit, aVar )
					MsgInfo( STR0026 + " " + SN1->N1_CBASE + " " + STR0027 + " " + SN1->N1_ITEM, STR0068 )	//"Código" | "Item" | "Dados Contábeis"
					Return
				Endif
			EndIf
		Endif
		SN1->( dbSkip() )
	EndDo
	
	SN3->( dbGoTo( nRegSN3 ) )
	aVar := aClone( aBackVar )
	SN1->( MsSeek( xFilial( "SN3" ) + cBasei + cItemi, .T. ) )
	
	While SN1->(!Eof()) .And.;
		xFilial( "SN3" ) == SN1->N1_FILIAL .And.;
		SN1->N1_CBASE <= cBasef .And.;
		SN1->N1_ITEM <= cItemf

		//bem pendente de classificacao
		If SN1->N1_STATUS == "0"
			SN1->( dbSkip() )
			Loop
		EndIf

		// Se NAO existir o filtro do usuario E se ele retornar .T., marca o registro
		If !Empty( cExpFiltro ) .and. SN1->(&( cExpFiltro ))
			
			SN3->( dbSeek( xFilial( "SN3" ) + SN1->N1_CBASE + SN1->N1_ITEM ) )
			
			If SN1->N1_OK == cMarca
				If Left( cTipoAprov, 1 ) == "1" // Resp. Individual
					//Verifica se WorkFlow está ativado
					If SuperGetMv( "MV_ATFWFM", , .F. )
						// Preenche a matriz PRIVATE aEmailSol com o e-mail dos responsaveis
						A125VlRspWF( SN1->N1_CBASE, SN1->N1_ITEM )
					EndIf
					cCodSol := GetSxENum( "SNM", "NM_CODIGO" )
				Endif
				GravaTr(    SN3->N3_CBASE												,; //Codigo do Bem
				SN3->N3_ITEM												,; //Item do Bem
				SN3->N3_TIPO												,; //Tipo do Bem
				cFilDest													,; //Filial Destino
				SN1->N1_GRUPO												,; //Grupo do Bem
				IIf(AllTrim(aVar[1][6]) == "*", SN3->N3_CCUSTO , aVar[1][6])	,; //Centro de Custo destino - cCCustoDst
				IIf(AllTrim(aVar[1][7]) == "*", SN3->N3_LOCAL  , aVar[1][7])	,; //Local destino - cLocalDst
				IIf(AllTrim(aVar[1][1]) == "*", SN3->N3_CCONTAB, aVar[1][1])	,; //Conta do Bem destino - cCContabDst
				IIf(AllTrim(aVar[1][2]) == "*", SN3->N3_CCORREC, aVar[1][2])	,; //Conta - cCCorrecDst
				IIf(AllTrim(aVar[1][3]) == "*", SN3->N3_CDEPREC, aVar[1][3])	,; //Conta - cCDeprecDst
				IIf(AllTrim(aVar[1][4]) == "*", SN3->N3_CCDEPR , aVar[1][4])	,; //Conta - cCDDeprDst
				IIf(AllTrim(aVar[1][5]) == "*", SN3->N3_CDESP  , aVar[1][5])	,; //Conta - cCDespDst
				IIf(AllTrim(aVar[2][1]) == "*", SN3->N3_CUSTBEM, aVar[2][1])	,; //Centro de Custo - cCustBemDst
				IIf(AllTrim(aVar[2][2]) == "*", SN3->N3_CCCORR , aVar[2][2])	,; //Centro de Custo - cCCCorrDst
				IIf(AllTrim(aVar[2][3]) == "*", SN3->N3_CCDESP , aVar[2][3])	,; //Centro de Custo - cCCDespDst
				IIf(AllTrim(aVar[2][4]) == "*", SN3->N3_CCCDEP , aVar[2][4])	,; //Centro de Custo - cCCCDepDst
				IIf(AllTrim(aVar[2][5]) == "*", SN3->N3_CCCDES , aVar[2][5])	,; //Centro de Custo - cCCCDESDst
				IIf(Len(aVar) < 3 .Or. AllTrim(aVar[3][1]) == "*", SN3->N3_SUBCCON, aVar[3][1])	,; //Item Contabil  - cItBemDst
				IIf(Len(aVar) < 3 .Or. AllTrim(aVar[3][2]) == "*", SN3->N3_SUBCCOR, aVar[3][2])	,; //Item Contabil - cItCorrDst
				IIf(Len(aVar) < 3 .Or. AllTrim(aVar[3][3]) == "*", SN3->N3_SUBCDEP, aVar[3][3])	,; //Item Contabil - cItDespDst
				IIf(Len(aVar) < 3 .Or. AllTrim(aVar[3][4]) == "*", SN3->N3_SUBCCDE, aVar[3][4])	,; //Item Contabil - cItCDepDst
				IIf(Len(aVar) < 3 .Or. AllTrim(aVar[3][5]) == "*", SN3->N3_SUBCDES, aVar[3][5])	,; //Item Contabil - cItCDesDst
				IIf(Len(aVar) < 4 .Or. AllTrim(aVar[4][1]) == "*", SN3->N3_CLVLCON, aVar[4][1])	,; //Classe de Valor - cClVlBemDst
				IIf(Len(aVar) < 4 .Or. AllTrim(aVar[4][2]) == "*", SN3->N3_CLVLCOR, aVar[4][2])	,; //Classe de Valor - cClVlCorDst
				IIf(Len(aVar) < 4 .Or. AllTrim(aVar[4][3]) == "*", SN3->N3_CLVLDEP, aVar[4][3])	,; //Classe de Valor - cClVlDepDst
				IIf(Len(aVar) < 4 .Or. AllTrim(aVar[4][4]) == "*", SN3->N3_CLVLCDE, aVar[4][4])	,; //Classe de Valor - cClVlCDeDst
				IIf(Len(aVar) < 4 .Or. AllTrim(aVar[4][5]) == "*", SN3->N3_CLVLDES, aVar[4][5])	,; //Classe de Valor - cClVlDesDst
				_cGeraNF													,; //Gera NF?
				_cClasNF													,; //Classificacao da NF
				_cTesS														,; //TES de Saida
				_cTesE														,; //TES de entrada
				_cNota														,; //Numero da NF (Caso já haja)
				_cSerie														,; //Serie da NF
				cDataSol													,; //Data da solicitacao
				cHoraSol													,; //Hora da Solicitacao
				__cUserID													,; //Codigo do solicitante
				_cHistSol													,; //Historico da solicitacao
				cCodSol														,; //Codigo da solicitacao
				_cCondpag													)  //Condicao de pagamento
				If Left( cTipoAprov, 1 ) == "1" // Resp. Individual
					ConfirmSx8()
					If SuperGetMV( 'MV_ATFWFM' ,, .F. )
						//Chamada do WorkFlow
						A125WfTr( cCodSol )
					EndIf
				Endif
			Endif
		Endif
		IncProc()
		SN1->(dbSkip())
	Enddo
	
	If Left( cTipoAprov, 1 ) == "2" // Resp. Geral
		ConfirmSx8()
		If SuperGetMV( 'MV_ATFWFM' ,, .F. )
			//Chamada do WorkFlow
			A125WfTr( cCodSol )
		EndIf
	Endif
Endif

RestArea( aArea )

Return

//---------------------------------------------------------------------------------
//TRANSFERENCIA EM LOTE FIM

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³AF125Excl  ºAutor  ³Marcos R. Pires    º Data ³  25/07/10   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ Exclusao da solicitacao de baixa ou transferencia          º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ SIGAATF                                                    º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
Function AF125Excl( cAlias, nReg, nOpc )

Local aArea := GetArea()

If SNM->NM_SITSOL == "1"	//Status da solicitação ( 1=Pendente | 2=Aprovada )
	If SNM->NM_TIPOSOL == "1"
		AF125SolBx( cAlias, nReg, nOpc ) //Solicitacao de baixa
	Else
		AF125SolTr( cAlias, nReg, nOpc ) //Solicitação de transferencia
	EndIf
Else
	Help(" ",1,"AF125PED",,STR0091 + "'",1,0)	//"Apenas solicitações pendentes podem ser excluídas."
EndIf

RestArea( aArea )

Return

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³AF125SolVi ºAutor  ³Marcos R. Pires    º Data ³  25/07/10   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ Visualização da solicitação de baixa ou transferência.     º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ SIGAATF                                                    º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
Function AF125SolVi( cAlias, nReg, nOpc )

Local aArea := GetArea()

If SNM->NM_TIPOSOL == "1"
	AF125SolBx( cAlias, nReg, nOpc )	//Solicitação de baixa.
Else
	AF125SolTr( cAlias, nReg, nOpc )	//Solicitação de transferência.
EndIf

RestArea(aArea)

Return

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³ATFA125Leg ºAutor  ³Marcos R. Pires     º Data ³  20/07/10  º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ Cria uma janela contendo a legenda da mBrowse.             º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ ATFA125                                                    º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
Function ATFA125Leg()

BrwLegenda( cCadastro, STR0010, { {"BR_VERDE"	, STR0011 },; 		//"Legenda" | "Aprovada"
{"BR_VERMELHO", STR0012 },; 		//"Rejeitada"
{"BR_AMARELO" , STR0013 } } ) 	//"Pendente"

Return Nil


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³AF125GRP   ºAutor  ³Microsiga           º Data ³  05/25/11   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³Gatilho do Grupo de Campos                                  º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ AP                                                        º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
Function AF125GRP(aEntDst,cGRUPO,cFilDest)
Local lRet := .T.
Local aArea:= GetArea()
Local aAreaSNG:= SNG->(GetArea())
Local nX	:= 0
Local nY	:= 0
Local cFilx	:= cFilAnt

cFilAnt := IIF(!Empty(cFilDest),cFilDest,cFilAnt)
SNG->(dbSetOrder(1))

If !Empty(cGrupo)
	lRet := SNG->(MsSeek(xFilial("SNG")+cGrupo))
	If 	lRet
		lRet := ExistCpo("SNG", cGrupo, 1)
		If !lRet .and. (oGet <> nil)
			oGet:SetFocus()
		EndIf
	Else
		Help(" ",1,"REGNOIS")
	Endif
	
	If lRet
		For nX := 1 To Len(aEntDst)
			For nY := 1 To Len(aEntDst[nX])
				// Se o campo da entidade contabil existir no SNG, associa a variavel de memoria exibida na tela
				If SNG->(FieldPos(aEntDst[nX][nY][3])) > 0 .And. !Empty(SNG->&(aEntDst[nX][nY][3]))
					aEntDst[nX][nY][2] := SNG->&(aEntDst[nX][nY][3])
				Endif
			Next
		Next
	EndIf
Endif


cFilAnt := cFilx
RestArea(aAreaSNG)
RestArea(aArea)
Return lRet

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Programa  ³MenuDef   ³ Autor ³ Ana Paula N. Silva    ³ Data ³28/11/06  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³ Utilizacao de menu Funcional                               ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Retorno   ³Array com opcoes da rotina.                                 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Parametros³Parametros do array a Rotina:                               ³±±
±±³          ³1. Nome a aparecer no cabecalho                             ³±±
±±³          ³2. Nome da Rotina associada                                 ³±±
±±³          ³3. Reservado                                                ³±±
±±³          ³4. Tipo de Transa‡„o a ser efetuada:                        ³±±
±±³          ³	  1 - Pesquisa e Posiciona em um Banco de Dados           ³±±
±±³          ³    2 - Simplesmente Mostra os Campos                       ³±±
±±³          ³    3 - Inclui registros no Bancos de Dados                 ³±±
±±³          ³    4 - Altera o registro corrente                          ³±±
±±³          ³    5 - Remove o registro corrente do Banco de Dados        ³±±
±±³          ³5. Nivel de acesso                                          ³±±
±±³          ³6. Habilita Menu Funcional                                  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³   DATA   ³ Programador   ³Manutencao efetuada                         ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³          ³               ³                                            ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/

Static Function MenuDef()

Local aRotina := { { STR0001, "AxPesqui"  , 0, 1 , , .F. },; //"Pesquisar"
{ STR0002, "AF125SolVi", 0, 2		  },; //"Visualizar"
{ STR0003, "AF125SolBx", 0, 3		  },; //"Solic. Baixa"
{ STR0005, "AF125BxLt" , 0, 3         },; //"Solic. Baixa Lote"
{ STR0004, "AF125SolTr", 0, 3		  },; //"Solic. Transf."
{ STR0006, "SolTransLt", 0, 3	      },; //"Solic. Transf. Lote"
{ STR0007, "AF125Excl" , 0, 5	   	  },; //"Excluir"
{ STR0008, "ATFA125Leg", 0, 10, , .F. } } //"Legenda"

Return( aRotina )  

 
/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³AF125TraLoc   ºAutor  ³Microsiga           º Data ³  03/15/12   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³Verifica se houve a apenas a troca de filiais               º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ AP                                                        º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
Static Function AF125TraLoc(aVar,cFilDest,cFilOrig)
Local lRet    := .T.
Local nX      := 0
Local nY      := 0
Local lOutEnt := .F.

If xFilial("SN1",cFilOrig) != xFilial("SN1",cFilDest)
	lRet := .F.
EndIf

If lRet
	For nX := 1 to Len(aVar)
		For nY := 1 to Len(aVar[nX])
			// Verifica se apenas o local (aVar[1][7]) foi alterado
			If Alltrim(aVar[nX][nY]) != '*'
				If  (nX == 1 .And. nY == 7) .Or. ( nX == 1 .And. nY == 6 .And. Empty(aVar[nX][nY]) )
					lOutEnt := .F.
				Else
					lOutEnt := .T.
					Exit
				EndIf
			EndIf
		Next nY
		IF lOutEnt
			lRet := .F.
			Exit
		EndIf
	Next nX
EndIf

Return lRet

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³AtGeraNF   ºAutor  ³Will Carvalho      º Data ³  06/08/14   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³Atualiza o combo de gerar Nota Fiscal com Sim ou Nao.       º±±
±±º          ³Não é permitido emitir nota para a mesma filial, assim essa º±±
±±º          ³função habilita/desabilita o campo e da mesma forma atuali- º±±
±±º          ³za dinamicamente o valor da variavel _cGERANF.              º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ AP                                                         º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
Static Function AtGeraNF(cDest,cOrig,_cGERANF)
_cGERANF := IIF( cDest != cOrig,"1","2" ) 
Return .T.
/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  VldoGeraNF ºAutor  ³Eduardo.FLima      º Data ³  07/01/15   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ Funcao para validação de combo gera nfs setando a resposta º±±
±±º          ³ para nao quando o campo for desabilitado.                  º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ SIGAATF                                                    º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
Static Function Af125VlGeraNF(cxFilDest, cxFilAnt, lLibCpo,oGeraNF)
If !(cxFilDest != cxFilAnt .And. lLibCpo)
	If !lTrava
		nAt:= oGeraNF:nat
		oGeraNF:nat:=2
		lTrava:=.T.
	Endif
Elseif lTrava
	oGeraNF:nat:= nAt
	lTrava:=.F.
Endif	            
oGeraNF:Refresh() 
Return cxFilDest != cxFilAnt .And. lLibCpo
