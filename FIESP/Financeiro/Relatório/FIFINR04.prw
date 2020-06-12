#INCLUDE "rwmake.CH"
#INCLUDE "PROTHEUS.CH"

/*
苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘
北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北�
北谀哪哪哪哪穆哪哪哪哪哪履哪哪哪履哪哪哪哪哪哪哪哪哪哪哪履哪哪穆哪哪哪哪哪勘�
北矲un噮o    � FIFINR04 � Autor � TOTVS                 � Data � 25/04/03 潮�
北媚哪哪哪哪呐哪哪哪哪哪聊哪哪哪聊哪哪哪哪哪哪哪哪哪哪哪聊哪哪牧哪哪哪哪哪幢�
北矰escri噮o � Recibo Requisicao de Numerario                  	        潮�
北媚哪哪哪哪呐哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪幢�
北� Uso      � FIESP                                                      潮�
北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北�
哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌
*/
User Function FIFINR04()
//谀哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪目
//� Define Variaveis                                             �
//滥哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪馁
LOCAL cDesc1 := "Este relatorio ira imprimir o recibo "
LOCAL cDesc2 := "referente a Requisicao de Numerario  "
LOCAL cDesc3 := ""
LOCAL wnrel
LOCAL cString := "SZL"

PRIVATE Tamanho := "P"
PRIVATE limite  := 80
PRIVATE titulo := "Recibo"
PRIVATE cabec1
PRIVATE cabec2
Private nTipo   := 18
PRIVATE aReturn := {"Zebrado", 1,"Administracao", 2, 2, 1, "",1 }
PRIVATE aLinha  := { },nLastKey := 0
PRIVATE cPerg   := ""
PRIVATE nomeprog:= "FIFINR04"
PRIVATE lMenu := .F.

//谀哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪目
//� Envia controle para a funcao SETPRINT                        �
//滥哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪馁
wnrel := "FIFINR04"            //Nome Default do relatorio em Disco
wnrel := SetPrint(cString,wnrel,cPerg,@titulo,cDesc1,cDesc2,cDesc3,.T.,""  ,.T.,Tamanho,"",.T.)

If nLastKey == 27
	Return
Endif

SetDefault(aReturn,cString)

nTipo := If(aReturn[4]==1,15,18)

RptStatus({|lEnd| FIFINImp(@lEnd,wnRel,cString)},titulo)

Return

/*/
苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘�
北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北�
北谀哪哪哪哪穆哪哪哪哪哪履哪哪哪履哪哪哪哪哪哪哪哪哪哪哪履哪哪穆哪哪哪哪哪勘�
北矲un噮o    � FIFINR04 � Autor � TOTVS                 � Data � 25/04/03 潮�
北媚哪哪哪哪呐哪哪哪哪哪聊哪哪哪聊哪哪哪哪哪哪哪哪哪哪哪聊哪哪牧哪哪哪哪哪幢�
北矰escri噮o � Relatorio de Recibo de Adiantamentos do Caixinha	        潮�
北媚哪哪哪哪呐哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪幢�
北砈intaxe e � FA565Imp(lEnd,wnRel,cString)                               潮�
北媚哪哪哪哪呐哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪幢�
北砅arametros� lEnd    - A嚻o do Codeblock                                潮�
北�          � wnRel   - Tulo do relatio                              潮�
北�          � cString - Mensagem                                         潮�
北媚哪哪哪哪呐哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪幢�
北� Uso      � FIESP                                                      潮�
北滥哪哪哪哪牧哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪俦�
北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北�
哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌�
*/
Static Function FIFINImp(lEnd,wnRel,cString)

LOCAL CbCont
LOCAL CbTxt

LOCAL cChave
Local cExtenso:= ""
Local cExt1 := ""
Local cExt2 := ""
Local cMoeda := GetMv("MV_SIMB1")
Local aAreaSZL := SZL->(GetArea())
Local nX



//谀哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪目
//� Vari爒eis utilizadas para Impress刼 do Cabe嘺lho e Rodap�	  �
//滥哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪馁
cbtxt 	:= SPACE(10)
cbcont	:= 0
m_pag 	:= 1

//谀哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪目
//� Filtragem dos recibos a serem impressos. Apenas se relatorio �
//� for chamado do Menu														  �
//滥哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪馁
dbSelectArea("SZL")
dbSetOrder(1)
SetRegua(RecCount())

IF lEnd
	@Prow()+1,001 PSAY OemToAnsi("CANCELADO PELO OPERADOR")
EndIF

fr565Param()  // Imprime folha de parametos se foi chamado do menu


li := 08

// Cabecalho
@ li,00 PSAY __PrtFatLine()
li++
@ li,00 PSAY __PrtLogo()
li++
@ li,00 PSAY __PrtFatLine()
li+= 2
@ li,00 PSAY __PrtLeft(SM0->M0_NOME)		// Empresa
@ li,00 PSAY __PrtRight("EMISSAO "+DTOC(dDataBase))
li++
@ li,00 PSAY __PrtCenter("RECIBO REQUISICAO DE NUMERARIO")
li++
@ li,00 PSAY __PrtCenter("Nro.: "+SZL->ZL_NUM)
cBenef := ALLTRIM(SZL->ZL_NOME)
cValor := cMoeda+" "+ AllTrim(Transform(SZL->ZL_VALOR,PesqPict("SZL","ZL_VALOR",19,1)))

li+=2
@ li,00 PSAY __PrtRight(cValor)
li+=3
@ li,10 PSAY "Recebi em "+DTOC(DDatabase)+ " a quantia de "

cExtenso:= Extenso( SZL->ZL_VALOR)
RestArea(aAreaSZL)

Fr565Exten(cExtenso,@cExt1,@cExt2)

@li,PCOL() PSAY cExt1
If !Empty(cExt2) .or. Len(cExt1) >= 38
	li++
	@li,00 PSAY Alltrim(cExt2) +"."
Else
	@li,PCOL()+2 PSAY "."
Endif
li++
@li,00 PSAY "Este valor refere-se a "+ALLTRIM(SZL->ZL_OBS)+"."
li+= 5
@li,00 PSAY __PrtCenter(Replicate("-",Len(SZL->ZL_NOME)))
li++
@li,00 PSAY __PrtCenter(cBenef)
@li+9,00 PSAY __PrtFatLine()

dbSelectArea("SZL")
RecLock("SZL",.F.)
SZL->ZL_IMPRESS := "S"
MsUnlock()

//谀哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪�
//� Finaliza a execucao do relatorio...                                 �
//滥哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪�

SET DEVICE TO SCREEN

//谀哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪�
//� Se impressao em disco, chama o gerenciador de impressao...          �
//滥哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪�

If aReturn[5] = 1
	Set Printer TO
	dbCommitAll()
	Ourspool(wnrel)
Endif
MS_FLUSH()

Return

/*/
苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘�
北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北�
北谀哪哪哪哪穆哪哪哪哪哪履哪哪哪履哪哪哪哪哪哪哪哪哪哪哪履哪哪穆哪哪哪哪哪勘�
北矲un噮o    � FIFINR04 � Autor � TOTVS                 � Data � 25/04/03 潮�
北媚哪哪哪哪呐哪哪哪哪哪聊哪哪哪聊哪哪哪哪哪哪哪哪哪哪哪聊哪哪牧哪哪哪哪哪幢�
北矰escri噭o � Extenso para o recibo de caixinha           					  潮�
北媚哪哪哪哪呐哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪幢�
北砈intaxe e 矲r565Exten() 															  潮�
北媚哪哪哪哪呐哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪幢�
北� Uso      � FIESP                                                      潮�
北滥哪哪哪哪牧哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪俦�
北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北�
哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌�
/*/
Static FUNCTION Fr565Exten(cExtenso,cExt1,cExt2)

cExt1 := SubStr (cExtenso,1,39) // 1.a linha do extenso
nLoop := Len(cExt1)

While .T.
	If Len(cExtenso) == Len(cExt1)
		Exit
	EndIf
	
	If SubStr(cExtenso,Len(cExt1),1) == " "
		Exit
	EndIf
	
	cExt1 := SubStr( cExtenso,1,nLoop )
	nLoop --
Enddo

cExt2 := SubStr(cExtenso,Len(cExt1)+1,80) // 2.a linha do extenso
IF !Empty(cExt2)
	cExt1 := StrTran(cExt1," ","  ",,39-Len(cExt1))
Endif

Return

/*/
苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘�
北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北�
北谀哪哪哪哪穆哪哪哪哪哪履哪哪哪履哪哪哪哪哪哪哪哪哪哪哪履哪哪穆哪哪哪哪哪勘�
北矲un噭o	 砯r565Param� Autor � Mauricio Pequim Jr	  矰ata  � 24.04.03 潮�
北媚哪哪哪哪呐哪哪哪哪哪聊哪哪哪聊哪哪哪哪哪哪哪哪哪哪哪聊哪哪牧哪哪哪哪哪幢�
北矰escri噭o � Cabe嘺lho do recibo  												  潮�
北媚哪哪哪哪呐哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪幢�
北砈intaxe e 砯r565cabec() 															  潮�
北媚哪哪哪哪呐哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪幢�
北砅arametros� 																			  潮�
北媚哪哪哪哪呐哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪幢�
北� Uso		 � Generico 																  潮�
北滥哪哪哪哪牧哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪俦�
北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北�
哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌�
/*/
Static Function fr565Param()

Local cAlias
Local nLargura := 080
Local nLin:=0
Local aDriver := ReadDriver()
Local nCont:= 0 
Local cVar
Local uVar
Local cPicture
Local lWin := .f.
Local nRow
Local nCol
Local cNomprg:= "FINR565"

#DEFINE INIFIELD    Chr(27)+Chr(02)+Chr(01)
#DEFINE FIMFIELD    Chr(27)+Chr(02)+Chr(02)
#DEFINE INIPARAM    Chr(27)+Chr(04)+Chr(01)
#DEFINE FIMPARAM    Chr(27)+Chr(04)+Chr(02)

lPerg := If(GetMv("MV_IMPSX1") == "S" .and. lMenu ,.T.,.F.)

Private cSuf:=""

If TYPE("__DRIVER") == "C"
	If "DEFAULT"$__DRIVER
		lWin := .t.
	EndIf
EndIf

IF aReturn[5] == 1   // imprime em disco
   lWin := .f.    // Se eh disco , nao eh windows
Endif

nRow := PRow()
nCol := PCol()
SetPrc(0,0)
If aReturn[5] <> 2 // Se nao for via Windows manda os caracteres para setar a impressora
	If !lWin .and. __cInternet == Nil
		@ 0,0 PSAY &(aDriver[1])
	EndIf
EndIF
If GetMV("MV_CANSALT",,.T.) // Saltar uma p醙ina na impress鉶
	If GetMv("MV_SALTPAG",,"S") != "N"
		Setprc(nRow,nCol)
	EndIf	
Endif
// Impress鉶 da lista de parametros quando solicitada
If lPerg .and. Substr(cAcesso,101,1) == "S"
	// Imprime o cabecalho padrao
	nLin := SendCabec(lWin, nLargura, cNomPrg, RptParam+" - "+Alltrim(Titulo), "", "", .F.)
	cAlias := Alias()
	DbSelectArea("SX1")
	DbSeek( padr( cPerg , Len( X1_GRUPO ) , " " ) )

	@ nLin+=2, 5 PSAY INIPARAM
	While !EOF() .AND. X1_GRUPO = cPerg
		cVar := "MV_PAR"+StrZero(Val(X1_ORDEM),2,0)
		@(nLin+=2),5 PSAY INIFIELD+RptPerg+" "+ X1_ORDEM + " : "+ AllTrim(X1Pergunt())+FIMFIELD
		If X1_GSC == "C"
			xStr:=StrZero(&cVar,2)
			If ( &(cVar)==1 )
				@ nLin,Pcol()+3 PSAY INIFIELD+X1Def01()+FIMFIELD
			ElseIf ( &(cVar)==2 )
				@ nLin,Pcol()+3 PSAY INIFIELD+X1Def02()+FIMFIELD
			ElseIf ( &(cVar)==3 )
				@ nLin,Pcol()+3 PSAY INIFIELD+X1Def03()+FIMFIELD
			ElseIf ( &(cVar)==4 )
				@ nLin,Pcol()+3 PSAY INIFIELD+X1Def04()+FIMFIELD
			ElseIf ( &(cVar)==5 )
				@ nLin,Pcol()+3 PSAY INIFIELD+X1Def05()+FIMFIELD
			Else					
				@ nLin,Pcol()+3 PSAY INIFIELD+''+FIMFIELD
			EndIf
		Else
			uVar := &(cVar)
			If ValType(uVar) == "N"
				cPicture:= "@E "+Replicate("9",X1_TAMANHO-X1_DECIMAL-1)
				If( X1_DECIMAL>0 )
					cPicture+="."+Replicate("9",X1_DECIMAL)
				Else
					cPicture+="9"
				EndIf
				@nLin,Pcol()+3 PSAY INIFIELD+Transform(Alltrim(Str(uVar)),cPicture)+FIMFIELD
			Elseif ValType(uVar) == "D"
				@nLin,Pcol()+3 PSAY INIFIELD+DTOC(uVar)+FIMFIELD
			Else
				@nLin,Pcol()+3 PSAY INIFIELD+uVar+FIMFIELD
			EndIf
		EndIf
		DbSkip()
	Enddo
	cFiltro := Iif (!Empty(aReturn[7]),MontDescr("SEU",aReturn[7]),"")
	nCont := 1
	If !Empty(cFiltro)
		nLin+=2
		@ nLin,5  PSAY  INIFIELD+ "Filtro      : " + Substr(cFiltro,nCont,nLargura-19)+FIMFIELD   //"Filtro      : "
		While Len(AllTrim(Substr(cFiltro,nCont))) > (nLargura-19)
			nCont += nLargura - 19
			nLin+=1
			@ nLin,19	PSAY	INIFIELD+Substr(cFiltro,nCont,nLargura-19)+FIMFIELD
		Enddo
		nLin++
	EndIf
	nLin++
	@ nLin ,00  PSAY __PrtFatLine()+FIMPARAM
	DbSelectArea(cAlias)
EndIf
m_pag++
If Subs(__cLogSiga,4,1) == "S"
	__LogPages()
EndIf

Return nLin