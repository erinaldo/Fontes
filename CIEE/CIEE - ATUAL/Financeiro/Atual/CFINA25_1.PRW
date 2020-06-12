#include "rwmake.ch"
#include "TOPCONN.ch"
#INCLUDE "FINXFUN.CH"
#Include "PROTHEUS.CH"
#include "colors.ch"

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³CFINA25_1 ºAutor  ³Microsiga           º Data ³  12/16/09   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³                                                            º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ AP                                                        º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

User Function CFINA25_1(aCols)

Private oValDist
Private oValFal
Private oPerFal
Private nVlTit
Private nValDist
Private aSize := MsAdvSize()
Private aObjects := {}

aHeader	:= {}
aCols	:= {}
aCampos := {}
aButton := {}
aStru 	:= {}


dbSelectArea("SX3")
dbSetOrder(2)
dbSeek("E5_NATUREZ") // Codigo Contatos
_fCabec("aHeader")
dbSeek("E5_VALOR") // Codigo Contatos
_fCabec("aHeader")

AADD(aCols,{Space(10),0,.F.})

nOpc 		:= 4
nOpca 		:= 0
nVlTit		:= SE5->E5_VALOR
nValDist	:= 0
nValFal		:= 0
nPerFal		:= 0
nFreeze		:= nil
nLinhas		:= 99               // Numero maximo de linhas na GetDados.

AADD(aCampos,"E5_NATUREZ") 	//campos alteraveis no GetDados2
AADD(aCampos,"E5_VALOR") 	//campos alteraveis no GetDados2

AADD(aObjects, { 100 , 100 , .T. , .T. } )
aInfo	:= { aSize[1],aSize[2],aSize[3],aSize[4],3,3 }
aObj	:= MsObjSize( aInfo, aObjects, .T.)

DEFINE FONT oBold		NAME "Arial" SIZE 0, -12 BOLD

//comando desabilita o X da tela
//STYLE DS_MODALFRAME
DEFINE MSDIALOG oDlg TITLE OemToAnsi("Naturezas do titulo") From 7,0 TO 30,80 of oMainWnd STYLE DS_MODALFRAME

oDlg:lEscClose := .F.

@  17 , 010 Say "Documento: "+SE5->E5_DOCUMEN	OF oDlg PIXEL FONT oBold
@  17 , 160 Say "Beneficiario: "+SE5->E5_BENEF OF oDlg PIXEL FONT oBold

@  9.4, 0.5 To 11.8,18 OF oDlg 
@  9.4,18.6 To 11.8,39 OF oDlg 
	
@ 10.6 , 1.4  Say "Valor"  OF oDlg 				   							FONT oDlg:oFont 
@ 10.6 , 7.6  Say nVlTit	PICTURE "@E 99,999,999.99"  OF oDlg 				FONT oDlg:oFont
		
@ 11.6 , 1.4  Say OemToAnsi("Total Distribuido: ") 	 OF oDlg 				FONT oDlg:oFont
@ 11.6 , 7.6  Say oValDist VAR nValDist PICTURE "@E 99,999,999.99" OF oDlg 	FONT oDlg:oFont 
		
//@ 10.6 , 19  Say "Valor a Distribuir"					   			FONT oDlg:oFont
//@ 10.6 , 28  Say oValFal VAR nValFal PICTURE "@E 99,999,999.99"		FONT oDlg:oFont 

//@ 11.6 , 19  Say "Percentual a Distribuir"							FONT oDlg:oFont
//@ 11.6 , 30  Say oPerFal VAR nPerFal PICTURE "@E 999.99"			FONT oDlg:oFont 
		
@  1.0, 0.5 To  2.35,18  OF oDlg 
@  1.0,18.6 To  2.35,39  OF oDlg 

nGetd		:= GD_INSERT+GD_UPDATE+GD_DELETE
oGetDados1	:= MsNewGetDados():New(35,5,120,310,nGetd ,"U_CFINA25LIN()","AllwaysTrue()","",aCampos ,nFreeze,nLinhas,"AllwaysTrue()",/*superdel*/,/*delok*/,,aheader ,acols )

ACTIVATE MSDIALOG oDlg CENTERED ON INIT (EnchoiceBar(oDlg,;
											{||iif(U_CFINA25TOK(),(nOpca:=1,oDlg:End()), nOpca:=0)},;
											{||iif(U_CFINA25CAN(),nOpca:=0,nOpca:=0)},;
											,;
											aButton),;
											)
*/
If nOpca == 1
	ACOLS := ACLONE(oGetDados1:aCols)
	Return(aCols)
EndIf

Return(.F.)

User Function CFINA25CAN()

alert("nao pode cancelar a tela")

Return(.f.)

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³CFINA25_1 ºAutor  ³Microsiga           º Data ³  01/27/10   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³                                                            º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ AP                                                         º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

User Function CFINA25LIN()

nValDist := 0

For _nI := 1 to Len(oGetDados1:aCols)

	If !oGetDados1:ACOLS[_nI,3] // Se tiver deletado
		nValDist+= oGetDados1:ACOLS[_nI,2]
	EndIf

	If nValDist > nVlTit
		msgbox(OemToAnsi("O Valor do Rateio é maior que o Saldo a Distribuir!!!"))
		oValDist:Refresh()
		Return(.F.)
	EndIf

Next _nI

oValDist:Refresh()

Return(.t.)

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³CFINA25_1 ºAutor  ³Microsiga           º Data ³  02/08/10   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³                                                            º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ AP                                                        º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

User Function CFINA25TOK()

Local nValDist := 0

For _nI := 1 to Len(oGetDados1:aCols)

	If !oGetDados1:ACOLS[_nI,3] // Se tiver deletado
		nValDist+= oGetDados1:ACOLS[_nI,2]
	EndIf

	If nValDist > nVlTit
		msgbox(OemToAnsi("O Valor do Rateio é maior que o Saldo a Distribuir!!!"))
		oValDist:Refresh()
		Return(.F.)
	EndIf

Next _nI

If nValDist < nVlTit
	msgbox(OemToAnsi("O Valor do Rateio é menor que o Saldo a Distribuir!!!"))
	oValDist:Refresh()
	Return(.F.)
EndIf

oValDist:Refresh()

Return(.t.)

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³CFINA25_1 ºAutor  ³Microsiga           º Data ³  12/16/09   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³                                                            º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ AP                                                        º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

Static Function _fCabec(cCabec)

// Cria aHeader com base no SX3
AADD(&cCabec,{ TRIM(X3Titulo()) ,;
				X3_CAMPO         ,;
				X3_PICTURE       ,;
				X3_TAMANHO       ,;
				X3_DECIMAL       ,;
				X3_VALID         ,;
				X3_USADO         ,;
				X3_TIPO          ,;
				X3_F3            ,;
				X3_CONTEXT       ,;
				X3_CBOX			 ,;
				X3_RELACAO       ,;
				X3_WHEN          ,;
				X3_VISUAL        ,;
				X3_VLDUSER       ,;
				X3_PICTVAR       ,;
				X3_OBRIGAT       })
Return
