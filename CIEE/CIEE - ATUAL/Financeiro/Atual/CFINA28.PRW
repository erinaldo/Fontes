#include "rwmake.ch"        // incluido pelo assistente de conversao do AP6 IDE em 08/04/05
#INCLUDE "CFINA28.CH"
#INCLUDE "TOPCONN.CH"


User Function CFINA28()        // incluido pelo assistente de conversao do AP6 IDE em 08/04/05

//旼컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴�
//� Declaracao de variaveis utilizadas no programa atraves da funcao    �
//� SetPrvt, que criara somente as variaveis definidas pelo usuario,    �
//� identificando as variaveis publicas do sistema utilizadas no codigo �
//� Incluido pelo assistente de conversao do AP6 IDE                    �
//읕컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴�

LOCAL 	nRegs :=0

Private _cPath
Private _cDrive :=GETMV("MV_PATCNAB")
SetPrvt("NREGS,APERGS,CPERG,NHDLBCO,NHDLSAIDA,NSEQ")
SetPrvt("NSOMAVALOR,NSOMACGC,NSOMADATA,AROTINA,NTOTCNAB2,NLINHA")
SetPrvt("CCADASTRO,NREG,CSETFILTER,NPOSATU,NPOSANT,NTOTREGS")
SetPrvt("NPOSCNT,NTAMARQ,NLIDOS,LRESP,LHEADER,LFIRST")
SetPrvt("LTRAILLER,LTEMHEADER,NULTDISCO,NGRAVA,ABORDERO,NSAVRECNO")
SetPrvt("NRECEMP,CNUMBORANT,LFIRSTBORD,LBORBLOCK,LFIN420_1,LF420FIL")
SetPrvt("CFILTRO,LSOMAVALOR,CINDEX,CCHAVE,NINDEX,CBANCO")
SetPrvt("CAGENCIA,CCONTA,CSUBCTA,CFILDE,CFILATE,CFILANT")
SetPrvt("XBUFFER,NTAM,NDEC,CCONTEUDO,EA_TRANSF,CARQENT")
SetPrvt("LFA420CRI,LRET,CARQSAIDA,EXPL1,NRETORNO,CTECLA")
SetPrvt("NX,L420CHKFILE,NOPC,CCAMPO,LCONTEUDO,BBLOCK")
SetPrvt("BERRO,XCONTEUDO,Alias")

/*/
複複複複複複複複複複複複複複複複複複複複複複複複複複複複複複複複複複複複複複�
굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇
굇旼컴컴컴컫컴컴컴쩡컴컴컴컫컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴커굇
굇� DATA   � BOPS 쿛rograd.쿌LTERACAO                                      낢�
굇쳐컴컴컴컵컴컴컴탠컴컴컴컵컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴캑굇
굇�02.12.97퀈xxxxx쿐duardo 쿟ratamento de Cnab Modelo 2                    낢�
굇�18.06.97퀈xxxxx쿘auricio쿛ermitir PA's na geracao do arquivo envio      낢�
굇�28.08.98퀈xxxxx쿌lice   쿟ratamento de filiais                          낢�
굇�31.08.99�23681a쿘auricio쿎ontrole de Bordero pertencente ao banco para o낢�
굇�        �      �        쿿ual esta se gerando o arquivo remessa         낢�
굇�24.11.99퀈xxxxx쿘auricio쿎orrigir tratamento Filial De/Ate              낢�
굇�20.12.99퀈xxxxx쿛ilar   쿔ncluir ponto de entrada				       낢�
굇�04.01.00퀈xxxxx쿛ilar   쿔ncluir ponto de entrada - Fa420Cria           낢�
굇읕컴컴컴컨컴컴컴좔컴컴컴컨컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴켸굇
굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇
賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽�
/*/
// Movido para o inicio do arquivo pelo assistente de conversao do AP5 IDE em 08/04/05 ==> #INCLUDE "FINA420.CH"
// Movido para o inicio do arquivo pelo assistente de conversao do AP5 IDE em 08/04/05 ==> #include "FiveWin.ch"
/*/
複複複複複複複複複複複複複複複複複複複複複複複複複複複複複複複複複複複複複複�
굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇�
굇旼컴컴컴컴컫컴컴컴컴컴쩡컴컴컴쩡컴컴컴컴컴컴컴컴컴컴컴쩡컴컴컫컴컴컴컴컴엽�
굇쿑un뇚o    � Fina420  � Autor � Pilar Sanchez         � Data � 27/05/96 낢�
굇쳐컴컴컴컴컵컴컴컴컴컴좔컴컴컴좔컴컴컴컴컴컴컴컴컴컴컴좔컴컴컨컴컴컴컴컴눙�
굇쿏escri뇚o � Gera뇙o do Arquivo SisPag Banco de Boston                  낢�
굇쳐컴컴컴컴컵컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴눙�
굇쿞intaxe   � Fina420()                                                  낢�
굇쳐컴컴컴컴컵컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴눙�
굇� Uso      � Generico                                                   낢�
굇읕컴컴컴컴컨컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴袂�
굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇�
賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽�
/*/


//aPergs := {{STR0014,STR0014,STR0014,"mv_chd","N",12,2,0,"G","",;
//"MV_PAR13","","","","","","","","","","","","","","",;
//"","","","","","","","","","","", "" }}
//旼컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴커
//� Verifica as perguntas selecionadas                           �
//읕컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴켸

//旼컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴�
//� Variaveis utilizadas para parametros 		 �
//� mv_par01		 // Do Bordero 		  		 �
//� mv_par02		 // Ate Bordero   	  		 �
//� mv_par03		 // Arq.Configuracao   		 �
//� mv_par04		 // Arq. Saida				 �
//� mv_par05		 // Banco       			 �
//� mv_par06		 // Agencia 				 �
//� mv_par07		 // Conta       			 �
//� mv_par08		 // Sub-Conta				 �
//� mv_par09 		 // Modelo 1/Modelo 2  		 �
//� mv_par10		 // Cons.Filiais Abaixo		 �
//� mv_par11		 // Filial de     	         �
//� mv_par12		 // Filial Ate 		  		 �
//� mv_par13		 // Receita Bruta Acumulada  �
//읕컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴�
//AjustaSx1("AFI420", aPergs) // CTBXFUN

Private cPerg   := "CIE420"
Private nHdlBco :=0,nHdlSaida:=0,nSeq:=0,cBanco,cAgencia,nSomaValor := 0
Private nSomaCGC:=0,nSomaData:=0
Private aRotina := { {OemToAnsi(STR0003) 		, 'execBlock("CFina28E",.F.,.F.)', 0 , 0 },;  // "Parametros"    //Fa420Par
                     {OemToAnsi(STR0004) 		, 'execBlock("CFina28A",.F.,.F.)' , 0 , 0 },;  // "Gerar Arquivo"  // Fa420Gera
                     {OemToAnsi("Relat�rio") 	, 'execBlock("CFINR028",.F.,.F.)' , 0 , 0 } }  // "Relatorio

PRIVATE xConteudo
PRIVATE nTotCnab2 := 0 // Contador de Lay-out nao deletar
PRIVATE nLinha    := 0 // Contador de LINHAS, nao deletar

//旼컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴커
//� Define o cabecalho da tela de baixas                         �
//읕컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴켸
PRIVATE cCadastro := OemToAnsi(STR0005)  //"Gera뇙o Arquivo Envio"
Private cArqCfg   := ""
Private cPathCfg  := ""
Private cFilDe    := SPACE(02) // MV_PAR11
Private cFilAte   := SPACE(02) // MV_PAR12
Private cModelo   := 1   // MV_PAR09
Private cConsFil  := 2   // MV_PAR10
PRIVATE cRecBrut  := 0   // MV_PAR13
/*
If !Pergunte("AFI420",.T.)  // Retirado para executar a consulta padr�o especifica
	Return
Endif
*/

If !Pergunte("CIE420",.T.)
	Return
Endif




//MV_PAR04 := GETMV("MV_PATCNAB")

DbSelectArea("SE2")
nReg:=Recno( )
mBrowse( 6, 1,22,75,"SE2" )
dbGoto( nReg )

//旼컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴커
//� Fecha os Arquivos ASC II                                     �
//읕컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴켸
FCLOSE(nHdlBco)
FCLOSE(nHdlSaida)

//旼컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴커
//� Recupera a Integridade dos dados                             �
//읕컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴켸
dbSelectArea("SE2")
dbSetOrder(1)

Return .T.

/*/
複複複複複複複複複複複複複複複複複複複複複複複複複複複複複複複複複複複複複複�
굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇�
굇旼컴컴컴컴컫컴컴컴컴컴쩡컴컴컴쩡컴컴컴컴컴컴컴컴컴컴컴쩡컴컴컫컴컴컴컴컴엽�
굇쿑un뇚o    � Fa420Gera� Autor � Pilar S. Albaladejo   � Data � 26/05/96 낢�
굇쳐컴컴컴컴컵컴컴컴컴컴좔컴컴컴좔컴컴컴컴컴컴컴컴컴컴컴좔컴컴컨컴컴컴컴컴눙�
굇쿏escri뇚o � Sispag - Envio Banco de Boston -> Geracao Arquivo (chamada)낢�
굇쳐컴컴컴컴컵컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴눙�
굇쿞intaxe   � Fa420Gera(cAlias)                                          낢�
굇쳐컴컴컴컴컵컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴눙�
굇� Uso      � FinA420                                                    낢�
굇읕컴컴컴컴컨컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴袂�
굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇�
賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽�
/*/
// Substituido pelo assistente de conversao do AP6 IDE em 08/04/05 ==> Function Fa420Gera(cAlias)
User Function Cfina28A(Alias)  //  Fa420Gera(cAlias)()

Private cSetFilter := SE2->(DBFILTER()) // Salva o filtro atual, para restaurar no final da rotina
Private cAlias := "SE2"
Private lReconc := .F.
Private _aRelBord := {}

Private	_xGeraArq	:= .T.

//Processa({|lEnd| Fa420Ger(cAlias)})  // Chamada com regua
Processa({|lEnd| CFINA28B(cAlias)})  // Chamada com regua

//旼컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴커
//� Ponto de Entrada para Tratamento baixa - Citibank�
//읕컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴켸

/*
DbSelectArea("SE5")
SE5->(DbSetOrder(10))
IF SE5->(DBSEEK(xFILIAL("SE5")+MV_PAR01))
   IF !Empty(SE5->E5_RECONC) 
    lReconc := .F.
  ELSE
    lReconc := .T.
  ENDIF   
ENDIF      
*/

If !_xGeraArq	//Se Falso
	Return
EndIf

IF LEN(_aRelBord) > 0
   FOR cT:=1 TO LEN(_aRelBord)
       IF _aRelBord[cT][2] == "A"
          lReconc := .T.
       ENDIF
   NEXT
ENDIF       
       
If cEmpant == '05' //CIEE NACIONAL
	cNomeArq := RIGHT(cPathCfg,9)
Else
	cNomeArq := RIGHT(cPathCfg,8)
EndIf

If lReconc == .T.       
	MSGINFO("ARQUIVO GERADO COM SUCESSO!!!  "+cPathCfg)
	_aArea	:= GetArea()
	FOR _cT:=1 TO LEN(_aRelBord)
		_cQuery := "UPDATE "+RetSqlName("SE2")+" SET E2_PAGFOR = '"+cNomeArq+"' "		
		_cQuery += "WHERE D_E_L_E_T_ = '' "
		_cQuery += "AND E2_NUMBOR = '"+_aRelBord[_cT][1]+"' " //Numero do Bordero
		TcSQLExec(_cQuery)
	NEXT
	RestArea(_aArea)
	U_CFINR028(mv_par01, mv_par02)
Else
	Return
EndIf

/*   
If ExistBlock("F420CIT") .AND. lReconc == .T.
	ExecBlock("F420CIT",.F.,.F.)
Endif
*/
dbSelectArea("SE2")
RetIndex("SE2")
// Restaura o filtro
Set Filter To &cSetFilter

Return .T.
/*
複複複複複複複複複複複複複複複複複複複複複複複複複複複複複複複複複複複複複複�
굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇�
굇旼컴컴컴컴컫컴컴컴컴컴쩡컴컴컴쩡컴컴컴컴컴컴컴컴컴컴컴쩡컴컴컫컴컴컴컴컴엽�
굇쿑un뇚o    � Fa420Ger � Autor � Wagner Xavier         � Data � 26/05/92 낢�
굇쳐컴컴컴컴컵컴컴컴컴컴좔컴컴컴좔컴컴컴컴컴컴컴컴컴컴컴좔컴컴컨컴컴컴컴컴눙�
굇쿏escri뇚o � Comunica뇙o Banc쟲ia - Envio                               낢�
굇쳐컴컴컴컴컵컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴눙�
굇쿞intaxe   � Fa420Ger()                                                 낢�
굇쳐컴컴컴컴컵컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴눙�
굇� Uso      � FinA420                                                    낢�
굇읕컴컴컴컴컨컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴袂�
굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇�
賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽�
*/
// Substituido pelo assistente de conversao do AP6 IDE em 08/04/05 ==> Function Fa420Ger(cAlias)

Static Function CFINA28B(Alias)         //Fa420Ger(cAlias)()

LOCAL cSav7,cSav20,cSavCur,nPosAtu:=0,nPosAnt:=0,nTotRegs:=0,nPosCnt:=0
LOCAL xBuffer,nTamArq:=0,nLidos:=0,lResp:=.t.
LOCAL lHeader:=.F.,lFirst:=.F.,cSaveMenuh,lTrailler := .F.,lTemHeader := .F.
LOCAL nTam,nDec,nUltDisco:=0,nGrava:=0,aBordero:={}
LOCAL nSavRecno := recno()
LOCAL nRecEmp := SM0->(RecNo())
LOCAL cFilDe
LOCAL cFilAte
LOCAL cNumBorAnt := CRIAVAR("E2_NUMBOR",.F.)
LOCAL lFirstBord := .T.
LOCAL lBorBlock  := .F.
LOCAL lFIN420_1  := ExistBlock("FIN420_1")
LOCAL lF420FIL   := ExistBlock("F420FIL")
LOCAL cFiltro    := ""
LOCAL lSomaValor := ExistBlock("F420SOMA")
Private cAlias   := "SE2"
Private lReconc  := .T.
Private lRecBor  := .T.
nHdlBco    := 0
nHdlSaida  := 0
nSeq       := 0
nSomaValor := 0
nSomaCGC   := 0
nSomaData  := 0
nTotCnab2  := 0 // Contador de Lay-out nao deletar

ProcRegua(SE2->(RecCount()))

//旼컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴커
//� Ponto de Entrada F420FIL                                  	  �
//� Cria chave de filtro para titulos do bordero a n�o serem 	  �
//� enviados ao arquivo bancario											  �
//읕컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴켸
If lF420Fil
	cFiltro := ExecBlock("F420FIL",.F.,.F.)
Endif

//旼컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴커
//� Cria indice temporario					                          �
//읕컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴켸
cIndex := CriaTrab(nil,.f.)
cChave  := IndexKey()
IndRegua("SE2",cIndex,"E2_FILIAL+E2_NUMBOR",,cFiltro,OemToAnsi(STR0007))  //"Selecionando Registros..."
nIndex := RetIndex("SE2")
dbSelectArea("SE2")
#IFNDEF TOP
	dbSetIndex(cIndex+ordBagExt())
#ENDIF
dbSetOrder(nIndex+1)
dbGoTop()

//旼컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴커
//� Verifica se o arquivo est� realmente vazio ou se       �
//� est� posicionado em outra filial.                      �
//읕컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴켸
If EOF() .or. BOF()
	HELP(" " , 1 , "ARQVAZIO")
	Return Nil
Endif

//旼컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴커
//� Posiciona no Banco indicado                                  �
//읕컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴켸

_xArea := GetArea()
ChkFile("SZL")
DbSelectArea("SZL")
SZL->(DbSetOrder(1))
SZL->(DbGoTop())
IF SZL->(DBSEEK(xFilial("SZL")+MV_PAR03))

	If SZL->ZL_BANCO <> "237"
		msgbox("Arquivo de Configura豫o n�o pertence ao Banco Bradesco!!!", "ATENCAO")
		RestArea(_xArea)
		Return(.F.)
	EndIf

   cArqCfg  := ALLTRIM(SZL->ZL_ARQUIVO)
   cPathCfg := ALLTRIM(SZL->ZL_PATH)
ENDIF   



SEA->(DbSeek(xFilial("SEA")+MV_PAR01,.T.))
cBanco   := SEA->EA_PORTADO
cAgencia := SEA->EA_AGEDEP
cConta   := SEA->EA_NUMCON
cSubCta  := "001"

_xAreaSEA := GetArea()
If SZL->ZL_BANCO <> SEA->EA_PORTADO
	msgbox("Bordero nr."+SEA->EA_NUMBOR+" nao pertence ao arquivo de configuracao do banco "+SZL->ZL_BANCO+" !!!", "ATENCAO")
	_xGeraArq	:= .F.
	RestArea(_xAreaSEA)
	Return(_xGeraArq)
EndIf

IF SEA->EA_MODELO == "99"
	msgbox("Bordero nr."+SEA->EA_NUMBOR+" nao pertence ao layout de geracao para Transmissao ao Banco!!!", "ATENCAO")
	_xGeraArq	:= .F.
	RestArea(_xAreaSEA)
	Return(_xGeraArq)
EndIf

dbSelectArea("SA6")
SA6->( dbSeek(cFilial+cBanco+cAgencia+cConta) )

dbSelectArea("SEE")
SEE->( dbSeek(xFilial("SEE")+cBanco+cAgencia+cConta+cSubCta) )
If !SEE->( found() )
	Help(" ",1,"PAR150")
	Return .F.
Else
	If Val(EE_FAXFIM)-Val(EE_FAXATU) < 100
		Help(" ",1,"FAIXA150")
	Endif
Endif


//lResp:=Fa420Abre()	//Abertura Arquivo ASC II
lResp := CFINA28C()
If !lResp
	Return .F.
Endif

nSeq := 0
nTotCnab2 := 0

if cConsFil == 2  // MV_PAR10
	cFilDe := cFilAnt
	cFilAte:= cFilAnt
Else
	cFilDe := cFilDe  // MV_PAR11
	cFilAte:= cFilAte // MV_PAR12
Endif



dbSelectArea("SM0")
dbSeek(cEmpAnt+cFilDe,.T.)

While !Eof() .and. M0_CODIGO == cEmpAnt .and. M0_CODFIL <= cFilAte
	
	cFilAnt := M0_CODFIL
	
	//旼컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴커
	//� Posiciona no Bordero Informado pelo usuario                  �
	//읕컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴켸
	dbSelectArea("SE2")
	SE2->( dbSeek(cFilial+mv_par01,.T.))
	
	//旼컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴커
	//� Inicia a leitura do arquivo de Titulos                       �
	//읕컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴켸
	dbSelectArea("SE2")
	While !SE2->( Eof() ) .And. SE2->E2_FILIAL == cFilial .And.;
		SE2->E2_NUMBOR>=mv_par01 .and. SE2->E2_NUMBOR <=mv_par02
		
		IncProc()
		
		//Alterado pelo analista Emerson dia 27/01/10.
		//acrescentado bloco abaixo para filtrar Data de Vencimento.
		If SE2->E2_VENCREA < DDATABASE
			// Despreza borderos com a Data menor que a DataBase
			SE2->(DbSkip())
			Loop
		EndIf

		DbSelectArea("SE5")
/*
		SE5->(DbSetOrder(10))
		IF SE5->(DBSEEK(xFILIAL("SE5")+SE2->E2_NUMBOR))
			//Alterado pelo analista Cristiano dia 28/01/10.
			//acrescentado bloco abaixo para filtrar data do documento.
			If SE5->E5_DATA >= DDATABASE
*/

		//Alterado pelo analista Emerson dia 21/09/10.
		//o bloco comentado acima foi tirado pois nao podemos procurar o movimento pelo E5_DOCUMEN pois este campo nao e exclusivo
		//para BORDERO.
		//a chave mais correta (pois nao vai existir repeticao) e a sequencia abaixo.
		
		SE5->(DbSetOrder(7)) //       E5_FILIAL+E5_PREFIXO+E5_NUMERO+E5_PARCELA+E5_TIPO+E5_CLIFOR+E5_LOJA+E5_SEQ
		IF SE5->(DBSEEK(xFILIAL("SE5")+   SE2->(E2_PREFIXO+E2_NUM+E2_PARCELA+E2_TIPO+E2_FORNECE+E2_LOJA) ))
				IF !Empty(SE5->E5_RECONC)
					lRecBor := .F.
					_PosAnt := ASCAN(_aRelBord,{|x|x[1]== SE2->E2_NUMBOR })
					IF _PosAnt > 0 
						_aRelBord[_PosAnt][1] := SE2->E2_NUMBOR
						_aRelBord[_PosAnt][2] := "X"
					ELSE
						AADD(_aRelBord,{SE2->E2_NUMBOR,"X"})
					ENDIF    
				ELSE
					lRecBor := .T.
					_PosAnt := ASCAN(_aRelBord,{|x|x[1]== SE2->E2_NUMBOR })
					IF _PosAnt > 0 
						_aRelBord[_PosAnt][1] := SE2->E2_NUMBOR
						_aRelBord[_PosAnt][2] := "A"
					ELSE
						AADD(_aRelBord,{SE2->E2_NUMBOR,"A"})
					ENDIF    
				ENDIF   
//			ENDIF   
		ENDIF
		      
		IF Empty(SE2->E2_NUMBOR) .Or. lRecBor == .F. .Or.  ;                                   // .Or. SE2->E2_SALDO == 0 .or. ;
			(SE2->E2_NUMBOR == cNumBorAnt .and. lBorBlock)
			SE2->( dbSkip() )
			Loop
		EndIF
		
		//旼컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴커
		//� Verifica se o portador do bordero � o mesmo dos parametros   �
		//읕컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴켸
		If SE2->E2_NUMBOR != cNumBorAnt .or. lFirstBord
			lFirstBord := .F.
			dbSelectArea("SEA")
			If dbSeek(xFilial()+SE2->E2_NUMBOR)
				While SEA->EA_NUMBOR == SE2->E2_NUMBOR
					If SEA->EA_CART == "P"
						cNumBorAnt := SE2->E2_NUMBOR
						lBorBlock := .F.
						If cBanco+cAgencia+cConta != SEA->(EA_PORTADO+EA_AGEDEP+EA_NUMCON)
							//旼컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴커
							//� Bordero pertence a outro Bco/Age/Cta �
							//읕컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴켸
							Help(" ",1,"NOBCOBORD",,cNumBorAnt,4,1)
							lBorBlock := .T.
						Endif
						Exit
					Else
						//旼컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴�
						//� Bordero pertence a outra Carteira (Receber) �
						//읕컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴�
						lBorBlock := .T.
						SEA->(dbSkip())
						Loop
					Endif
				Enddo
			Else
				//旼컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴커
				//� Bordero n�o foi achado no SEA        �
				//읕컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴켸
				Help(" ",1,"BORNOXADO",,SE2->E2_NUMBOR,4,1)
				lBorBlock := .T.
			Endif
		Endif
		dbSelectArea("SE2")
		If lBorBlock
			SE2->( dbSkip() )
			Loop
		Endif
		
		//旼컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴커
		//� Posiciona no Fornecedor                                      �
		//읕컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴켸
		dbSelectArea("SA2")
		dbSeek(cFilial+SE2->E2_FORNECE+SE2->E2_LOJA)
		If lFin420_1
			Execblock("FIN420_1",.F.,.F.)
		Endif
		
		dbSelectArea("SE2")
		
		nSeq++
		
		If lSomaValor
			nSomaValor += Execblock("F420SOMA",.F.,.F.)	// Retornar um determinado saldo do usuario
		Else
			nSomaValor += SE2->E2_SALDO
		Endif
		
		nSomaCGC    += Val(SA2->A2_CGC)
		nSomaData   += Val(GravaData(SE2->E2_VENCTO,.F.,1))
		
		If ( cModelo == 1 )  // MV_PAR09
			//旼컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴커
			//� Le Arquivo de Parametrizacao                                 �
			//읕컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴켸
			nLidos:=0
			FSEEK(nHdlBco,0,0)
			nTamArq:=FSEEK(nHdlBco,0,2)
			FSEEK(nHdlBco,0,0)
			
			While nLidos <= nTamArq
				
				//旼컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴커
				//� Verifica o tipo qual registro foi lido                       �
				//읕컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴켸
				xBuffer:=Space(85)
				FREAD(nHdlBco,@xBuffer,85)
				
				Do Case
					case SubStr(xBuffer,1,1) == CHR(1)
						IF lHeader
							nLidos+=85
							Loop
						EndIF
						lTemHeader := .T.
					case SubStr(xBuffer,1,1) == CHR(2)
						IF !lFirst .And. lTemHeader
							lFirst := .T.
							FWRITE(nHdlSaida,CHR(13)+CHR(10))
						EndIF
					case SubStr(xBuffer,1,1) == CHR(3)
						lTrailler := .T.
						nLidos+=85
						Loop
					Otherwise
						nLidos+=85
						Loop
				EndCase
				
				nTam := 1+(Val(SubStr(xBuffer,20,3))-Val(SubStr(xBuffer,17,3)))
				nDec := Val(SubStr(xBuffer,23,1))
				cConteudo:= SubStr(xBuffer,24,60)
				//				nGrava := Fa420Grava(nTam,nDec,cConteudo,@aBordero)
				nGrava := CFINA28D(nTam,nDec,cConteudo,@aBordero)
				If nGrava != 1
					Exit
				Endif
				
				dbSelectArea("SE2")
				nLidos+=85
			EndDO
			
			If nGrava == 3
				Exit
			Endif
			
			If nGrava == 1
				fWrite(nHdlSaida,CHR(13)+CHR(10))
				IF !lHeader
					lHeader := .T.
				EndIF
				dbSelectArea("SEA")
				If (dbSeek(xFilial()+SE2->E2_NUMBOR+SE2->E2_PREFIXO+SE2->E2_NUM+;
					SE2->E2_PARCELA+SE2->E2_TIPO+SE2->E2_FORNECE+;
					SE2->E2_LOJA))
					Reclock("SEA")
					SEA -> EA_TRANSF := "S"
					MsUnlock()
				Endif
			Endif
		Else
			//			nGrava := Fa420Grava(0,0,"",@aBordero)
			nGrava := CFINA28D(0,0,"",@aBordero)
			If nGrava == 1
				dbSelectArea("SEA")
				If (dbSeek(xFilial()+SE2->E2_NUMBOR+SE2->E2_PREFIXO+SE2->E2_NUM+;
					SE2->E2_PARCELA+SE2->E2_TIPO+SE2->E2_FORNECE+SE2->E2_LOJA))
					Reclock("SEA")
					SEA -> EA_TRANSF := "S"
					MsUnlock()
				EndIf
				nTotCnab2++
				DetCnab2(nHdlSaida,cArqCfg)
			Endif
		EndIf
		dbSelectArea("SE2")
		SE2->( dbSkip( ) )
	EndDO
	iF Empty(xFilial("SE2"))
		Exit
	Endif
	dbSelectArea("SM0")
	dbSkip()
Enddo


IF Len(_aRelBord) > 0 
   For Ij:=1 to Len(_aRelBord)
       IF _aRelBord[Ij][2] == "X"
          MSGINFO("BORDERO "+_aRelBord[Ij][1]+" JA CONCILIADO, NAO SERA GERADO!!!")
          lReconc := .F.
          Return
       ENDIF
   NEXT 
   
ENDIF       

   

If ( cModelo == 1 ) .AND. lReconc == .T.//MV_PAR09
	//旼컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴커
	//� Monta Registro Trailler                              		  �
	//읕컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴켸
	nSeq++
	nLidos:=0
	FSEEK(nHdlBco,0,0)
	nTamArq:=FSEEK(nHdlBco,0,2)
	FSEEK(nHdlBco,0,0)
	
	While nLidos <= nTamArq
		
		IF nGrava == 3
			Exit
		End
		
		//旼컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴커
		//� Tipo qual registro foi lido             		                 �
		//읕컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴켸
		xBuffer:=Space(85)
		FREAD(nHdlBco,@xBuffer,85)
		
		IF SubStr(xBuffer,1,1) == CHR(3)
			lTrailler := .T.
			nTam := 1+(Val(SubStr(xBuffer,20,3))-Val(SubStr(xBuffer,17,3)))
			nDec := Val(SubStr(xBuffer,23,1))
			cConteudo:= SubStr(xBuffer,24,60)
			//			nGrava:=Fa420Grava( nTam,nDec,cConteudo,@aBordero )
			nGrava:=CFINA28D( nTam,nDec,cConteudo,@aBordero )
			IF nGrava == 3
				Exit
			End
		EndIF
		nLidos+=85
	End
	If lTrailler
		FWRITE(nHdlSaida,CHR(13)+CHR(10))
	Endif
Else
	RodaCnab2(nHdlSaida,cArqCfg)  // mv_par03
EndIf
//旼컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴커
//� Atualiza Numero do ultimo Disco                              �
//읕컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴켸
dbSelectArea("SEE")
IF !Eof() .and. nGrava != 3
	Reclock("SEE")
	nUltDisco:=VAL(EE_ULTDSK)+1
	Replace EE_ULTDSK With StrZero(nUltDisco,6)
	MsUnlock()
EndIF

dbSelectArea(cAlias)
dbGoTo( nSavRecno )

SM0->(dbGoto(nRecEmp))
cFilAnt := SM0->M0_CODFIL

dbSelectArea("SE2")
dbClearFil(NIL)
RetIndex("SE2")
Ferase(cIndex+OrdBagExt())
dbSetOrder(1)

//旼컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴커
//� Fecha o arquivo gerado.                                      �
//읕컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴켸
FCLOSE(nHdlSaida)

Return

/*/
複複複複複複複複複複複複複複複複複複複複複複複複複複複複複複複複複複複複複複�
굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇�
굇旼컴컴컴컴컫컴컴컴컴컴쩡컴컴컴쩡컴컴컴컴컴컴컴컴컴컴컴쩡컴컴컫컴컴컴컴컴엽�
굇쿑un뇚o    쿑a420Abre � Autor � Wagner Xavier         � Data � 26/05/92 낢�
굇쳐컴컴컴컴컵컴컴컴컴컴좔컴컴컴좔컴컴컴컴컴컴컴컴컴컴컴좔컴컴컨컴컴컴컴컴눙�
굇쿏escri뇚o 쿌bre arquivo de Parametros                                  낢�
굇쳐컴컴컴컴컵컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴눙�
굇쿞intaxe   쿌brePar()                                                   낢�
굇쳐컴컴컴컴컵컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴눙�
굇� Uso      쿑inA420                                                     낢�
굇읕컴컴컴컴컨컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴袂�
굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇�
賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽�
/*/
// Substituido pelo assistente de conversao do AP6 IDE em 08/04/05 ==> Function Fa420Abre()
Static Function CFINA28C() // Fa420Abre()

LOCAL cArqEnt:=cArqCfg,cArqSaida
Local lFa420Cri := .T.
Local lRet := .T.
Local := _cDiaMes := SUBS(DTOC(dDataBase),1,2)+SUBS(DTOC(dDataBase),4,2)

dBselectarea("SX5")
dBsetOrder(1)
IF dBseek(xFilial("SX5")+"Z8"+"01") 
    
    IF SUBS(SX5->X5_DESCRI,1,4) == _cDiaMes 
       _nSeq := STRZERO(VAL(SUBS(SX5->X5_DESCRI,5,2))+1,2)
       _cDiaMes+=_nSeq
    ELSE
       _cDiaMes+="00"
    ENDIF
	Reclock("SX5",.F.)
	SX5->X5_DESCRI := _cDiaMes
	SX5->(MsUnlock())
ENDIF

cPathCfg += ALLTRIM(_cDiaMes)


IF AT(".",cPathCfg)>0 //mv_par04
	cArqSaida:=SubStr(TRIM(cPathCfg),1,AT(".",cPathCfg)-1)+"."+TRIM(SEE->EE_EXTEN)
Else
	cArqSaida:=TRIM(cPathCfg)+"."+TRIM(SEE->EE_EXTEN)
EndIF

IF !FILE(cArqEnt)
	Help(" ",1,"NOARQPAR")
	lRet := .F.
Else
	If ExistBlock("FA420CRI")
		lFa420CRI := ExecBlock("FA420CRI",.F.,.F.)
	EndIf
	If lFa420Cri
		If ( cModelo == 1 ) // Modelo 1 // MV_PAR09
			nHdlBco:=FOPEN(cArqEnt,0+64)
			If nHdlBco <= 0
				Help(" ",1,"F420ABRE",,"Erro abertura do arquivo de configura豫o",4,0)
				lRet := .F.
			Else
				//旼컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴커
				//� Cria Arquivo Saida                                       �
				//읕컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴켸
				nHdlSaida:=MSFCREATE(cArqSaida,0)
			Endif
		Else
			nHdlSaida := HeadCnab2(cArqSaida,cArqCfg)
		EndIf
	Else
		lRet := .F.
	EndIf
EndIF
If lRet .And. nHdlSaida <= 0
	Help(" ",1,"F420CRIA",,"Erro na cria豫o do arquivo de saida",4,0)
	lRet := .F.
Endif

Return lRet


/*/
複複複複複複複複複複複複複複複複複複複複複複複複複複複複複複複複複複複複複複�
굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇�
굇旼컴컴컴컴컫컴컴컴컴컴쩡컴컴컴쩡컴컴컴컴컴컴컴컴컴컴컴쩡컴컴컫컴컴컴컴컴엽�
굇쿑un뇚o    쿑a420Grava� Autor � Pilar Sanchez         � Data � 26/05/96 낢�
굇쳐컴컴컴컴컵컴컴컴컴컴좔컴컴컴좔컴컴컴컴컴컴컴컴컴컴컴좔컴컴컨컴컴컴컴컴눙�
굇쿏escri뇚o 쿝otina de Geracao do Arquivo de Remessa de SisPag Banco de  낢�
굇�          쿍oston                                                      낢�
굇쳐컴컴컴컴컵컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴눙�
굇쿞intaxe   쿐xpL1:=Fa420Grava(ExpN1,ExpN2,ExpC1)                        낢�
굇쳐컴컴컴컴컵컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴눙�
굇� Uso      � FinA420                                                    낢�
굇읕컴컴컴컴컨컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴袂�
굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇�
賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽�
/*/
// Substituido pelo assistente de conversao do AP6 IDE em 08/04/05 ==> STATIC Function Fa420Grava( nTam,nDec,cConteudo,aBordero )
STATIC Function CFINA28D( nTam,nDec,cConteudo,aBordero ) //Fa420Grava( nTam,nDec,cConteudo,aBordero )()
Local nRetorno := 1
Local cTecla   := ""
Local nX       := 1
Local oDlg, oRad, nTecla
LOCAL l420Chkfile := ExistBlock("F420CHK")

If l420ChkFile		// garantir que o arquivo nao seja reenviado
	nRetorno := Execblock("F420CHK",.F.,.F.)		// Retornar 1,2 ou 3
	If nRetorno != 1  // Se Ignora ou Abandona Rotina
		Return nRetorno
	Endif
Endif

//旼컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴커
//� O retorno podera' ser :                                  �
//� 1 - Grava Ok                                             �
//� 2 - Ignora bordero                                       �
//� 3 - Abandona rotina                                      �
//읕컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴켸
While .T.
	
	//旼컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴커
	//� Verifica se titulo ja' foi enviado                       �
	//읕컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴켸
	If !l420ChkFile  // Ignora verifica눯o se existir o PE
		If SE2->E2_NUMBOR >= MV_PAR01 .and. SE2->E2_NUMBOR <= MV_PAR02
			dbSelectArea("SEA")
			If (dbSeek(xFilial()+SE2->E2_NUMBOR+SE2->E2_PREFIXO+SE2->E2_NUM+;
				SE2->E2_PARCELA+SE2->E2_TIPO+SE2->E2_FORNECE+SE2->E2_LOJA))
				If SEA->EA_TRANSF == "S"
					nX := ASCAN(aBordero,SubStr(SE2->E2_NUMBOR,1,6))
					If nX == 0
						nOpc := 1
						DEFINE MSDIALOG oDlg FROM  35,   37 TO 188,383 TITLE OemToAnsi(STR0008) PIXEL  //"Bordero Existente"
						@ 11, 7 SAY OemToAnsi(STR0009) SIZE 58, 7 //OF oDlg PIXEL  //"O border� n즡ero:"
						@ 11, 68 GET SE2->E2_NUMBOR When .F. SIZE 37, 10  //OF oDlg PIXEL
						@ 24, 7 SAY OemToAnsi(STR0010) SIZE 82, 7 // OF oDlg PIXEL  //"j� foi enviado ao banco."
//						@ 37, 6 TO 69, 120 // LABEL OemToAnsi(STR0011) PIXEL // OF oDlg  PIXEL  //"Para prosseguir escolha uma das op뉏es"
						//						@ 45, 11 RADIO oRad VAR nTecla 3D SIZE 75, 11  PROMPT OemToAnsi(STR0012),OemToAnsi(STR0013) OF oDlg PIXEL  //"Gera com esse border�"###"Ignora esse border�"
						//						@ 45, 11 RADIO oRad VAR nTecla  SIZE 75, 11 // PROMPT OemToAnsi(STR0012),OemToAnsi(STR0013)// OF oDlg PIXEL  //"Gera com esse border�"###"Ignora esse border�"
						DEFINE SBUTTON FROM 11, 140 TYPE 1 ENABLE OF oDlg Action (nOpc:=1,oDlg:End())
						DEFINE SBUTTON FROM 24, 140 TYPE 2 ENABLE OF oDlg Action (nopc:=0,oDlg:End())
						ACTIVATE MSDIALOG oDlg Centered
						nTecla := 1
						If nOpc == 1
							If nTecla == 1
								nRetorno := 1
							Else
								nRetorno := 2
							EndIf
						Else
							nRetorno := 3
						EndIf
					Else
						nRetorno := Int(Val(SubStr(aBordero[nX],7,1)))
					Endif
				Endif
			Endif
		Endif
	Endif
	If nRetorno == 1 .And. cModelo == 1  // MV_PAR09
		//旼컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴커
		//� Analisa conteudo                                         �
		//읕컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴켸
		IF Empty(cConteudo)
			cCampo:=Space(nTam)
		Else
			//        lConteudo := Fa420Orig( cConteudo )
			lConteudo := CFINA28F( cConteudo )
			IF !lConteudo
				Exit
			Else
				IF ValType(xConteudo)="D"
					cCampo := GravaData(xConteudo,.F.)
				Elseif ValType(xConteudo)="N"
					cCampo:=Substr(Strzero(xConteudo,nTam,nDec),1,nTam)
				Else
					cCampo:=Substr(xConteudo,1,nTam)
				End
			End
		End
		If Len(cCampo) < nTam  //Preenche campo a ser gravado, caso menor
			cCampo:=cCampo+Space(nTam-Len(cCampo))
		End
		Fwrite( nHdlSaida,cCampo,nTam )
	End
	If nX == 0
		Aadd(aBordero,Substr(SE2->E2_NUMBOR,1,6)+Str(nRetorno,1))
	End
	Exit
End
Return nRetorno

/*/
複複複複複複複複複複複複複複複複複複複複複複複複複複複複複複複複複複複複複複�
굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇�
굇旼컴컴컴컴컫컴컴컴컴컴쩡컴컴컴쩡컴컴컴컴컴컴컴컴컴컴컴쩡컴컴컫컴컴컴컴컴엽�
굇쿑un뇚o    쿑a420Par  � Autor � Pilar Sanchez         � Data � 26/05/92 낢�
굇쳐컴컴컴컴컵컴컴컴컴컴좔컴컴컴좔컴컴컴컴컴컴컴컴컴컴컴좔컴컴컨컴컴컴컴컴눙�
굇쿏escri뇚o 쿌ciona parametros do Programa                               낢�
굇쳐컴컴컴컴컵컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴눙�
굇쿞intaxe   � 		                                                     낢�
굇쳐컴컴컴컴컵컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴눙�
굇� Uso      � Generico                                                   낢�
굇읕컴컴컴컴컨컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴袂�
굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇�
賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽�
/*/
// Substituido pelo assistente de conversao do AP6 IDE em 08/04/05 ==> Function Fa420Par()
User Function CFINA28E() //Fa420Par()
Pergunte(cPerg,.T.)
Return .T.

/*/
굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇�
굇旼컴컴컴컴컫컴컴컴컴컴쩡컴컴컴쩡컴컴컴컴컴컴컴컴컴컴컴쩡컴컴컫컴컴컴컴컴엽�
굇쿑un뇚o    쿑a420Orig � Autor � Pilar Sanchez         � Data � 10/11/92 낢�
굇쳐컴컴컴컴컵컴컴컴컴컴좔컴컴컴좔컴컴컴컴컴컴컴컴컴컴컴좔컴컴컨컴컴컴컴컴눙�
굇쿏escri뇚o 쿣erifica se expressao e' valida para Remessa CNAB.          낢�
굇쳐컴컴컴컴컵컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴눙�
굇� Uso      쿑ina420                                                     낢�
굇읕컴컴컴컴컨컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴袂�
굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇�
賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽�
/*/
// Substituido pelo assistente de conversao do AP6 IDE em 08/04/05 ==> Function Fa420Orig( cForm )
Static Function CFINA28F(cForm) // Fa420Orig( cForm )()

Local bBlock:=ErrorBlock(),bErro := ErrorBlock( { |e| ChecErr260(e,cForm) } )
Private lRet := .T.

BEGIN SEQUENCE
xConteudo := &cForm
END SEQUENCE
ErrorBlock(bBlock)
Return lRet

/*/
複複複複複複複複複複複複複複複複複複複複複複複複複複複複複複複複複複複複複複�
굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇�
굇旼컴컴컴컴컫컴컴컴컴컴쩡컴컴컴쩡컴컴컴컴컴컴컴컴컴컴컴쩡컴컴컫컴컴컴컴컴엽�
굇쿑un뇚o    � SomaCGC  � Autor � Pilar S. Albaladejo   � Data � 27/05/96 낢�
굇쳐컴컴컴컴컵컴컴컴컴컴좔컴컴컴좔컴컴컴컴컴컴컴컴컴컴컴좔컴컴컨컴컴컴컴컴눙�
굇쿏escri뇚o � Retorna o valor dos CPF/CGC Somados                        낢�
굇쳐컴컴컴컴컵컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴눙�
굇쿞intaxe   � SomaCGC()                                                  낢�
굇쳐컴컴컴컴컵컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴눙�
굇� Uso      � Generico                                                   낢�
굇읕컴컴컴컴컨컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴袂�
굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇�
賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽�
/*/
// Substituido pelo assistente de conversao do AP6 IDE em 08/04/05 ==> Function SomaCGC()
// Static Function SomaCGC()
// Return nSomaCGC * 100

/*/
複複複複複複複複複複複複複複複複複複複複複複複複複複複複複複複複複複複複複複�
굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇�
굇旼컴컴컴컴컫컴컴컴컴컴쩡컴컴컴쩡컴컴컴컴컴컴컴컴컴컴컴쩡컴컴컫컴컴컴컴컴엽�
굇쿑un뇚o    � SomaData � Autor � Pilar S. Albaladejo   � Data � 27/05/96 낢�
굇쳐컴컴컴컴컵컴컴컴컴컴좔컴컴컴좔컴컴컴컴컴컴컴컴컴컴컴좔컴컴컨컴컴컴컴컴눙�
굇쿏escri뇚o � Retorna o valor das Datas somadas                          낢�
굇쳐컴컴컴컴컵컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴눙�
굇쿞intaxe   � SomaData()                                                 낢�
굇쳐컴컴컴컴컵컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴눙�
굇� Uso      � Generico                                                   낢�
굇읕컴컴컴컴컨컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴袂�
굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇�
賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽�
/*/
// Substituido pelo assistente de conversao do AP6 IDE em 08/04/05 ==> Function SomaData()
// Static Function SomaData()
// Return nSomaData * 100
/*/
複複複複複複複複複複複複複複複複複複複複複複複複複複複複複複複複複複複複複複�
굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇�
굇旼컴컴컴컴컫컴컴컴컴컴쩡컴컴컴쩡컴컴컴컴컴컴컴컴컴컴컴쩡컴컴컫컴컴컴컴컴엽�
굇쿑un뇚o    쿑a420NumTi� Autor � Claudio D. de Souza   � Data � 29/11/01 낢�
굇쳐컴컴컴컴컵컴컴컴컴컴좔컴컴컴좔컴컴컴컴컴컴컴컴컴컴컴좔컴컴컨컴컴컴컴컴눙�
굇쿏escri뇚o � Retorna a chave primaria do SE2                            낢�
굇쳐컴컴컴컴컵컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴눙�
굇쿞intaxe   � Fa420NumTit()                                              낢�
굇쳐컴컴컴컴컵컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴눙�
굇� Uso      � Generico                                                   낢�
굇읕컴컴컴컴컨컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴袂�
굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇�
賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽�
/*/
// Substituido pelo assistente de conversao do AP6 IDE em 08/04/05 ==> Function Fa420NumTit
//Static Function Fa420NumTit()
//RETURN xFilial("SE2")+SE2->(E2_PREFIXO+E2_NUM+E2_PARCELA+E2_TIPO+E2_FORNECE+E2_LOJA)
