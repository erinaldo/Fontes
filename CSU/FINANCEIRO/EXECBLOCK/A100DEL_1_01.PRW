#include "rwmake.ch"
*------------------------------------------------------------------------------
user function A100DEL()
* Ponto de entrada na exclusão notas de entrada via mata103
* MTdO - 05/10/2004
*REV. 08/10/04
*------------------------------------------------------------------------------

Local lRet := .T.
Local dEmissao := SF1->F1_DTDIGIT
Local dMesFec  := GetMv("MV_XMESNFE")
Local dDataFis := GetMv("MV_DATAFIS")
Local cHelp := ""

SE2->(dbsetorder(1)) // E2_FILIAL+E2_PREFIXO+E2_NUM+E2_PARCELA+E2_TIPO+E2_FORNECE+E2_LOJA
SE2->(dbseek(xFilial()+SF1->(F1_PREFIXO+F1_DOC),.f.))
do while SE2->(!eof().and.E2_FILIAL+E2_PREFIXO+E2_NUM==xFilial()+SF1->(F1_PREFIXO+F1_DOC))
	if SE2->(E2_FORNECE+E2_LOJA+DtoS(E2_EMISSAO)==SF1->(F1_FORNECE+F1_LOJA+DtoS(F1_EMISSAO)).And.;
		AllTrim(E2_ORIGEM)<>"MATA100".And.ALLTRIM(E2_NATUREZ)=="2.9.99".And.RecLock(alias(),.f.))
		SE2->E2_ORIGEM:="MATA100"
		SE2->(MsUnLock())
	endif
	SE2->(dbskip(1))
enddo

// Leonardo - 22/02/07
If dEmissao <> dDataBase
	lRet := .F.
	cHelp := "As notas fiscais devem ser excluídas na"+Chr(13)+Chr(10)+"mesma data de seu lançamento."+Chr(13)+Chr(10)+"Favor alterar a database para: "+DTOC(SF1->F1_DTDIGIT)
	Help(' ', 1, 'xRestr',,cHelp,1,0)
Endif

//////////////////////////////////////////////////////////////////////////////////////////////////////
// incluido por Daniel G.Jr. em 23/09/2008                                                          //
// Objetivo: impedir a exclusão de NFs cuja conferência já foi efetuada por Contas a Pagar e Fiscal //
//////////////////////////////////////////////////////////////////////////////////////////////////////
If !Empty(SF1->F1_XCONF01).And.!Empty(SF1->F1_XCONF03)
	lRet := .F.                                            
	cHelp := "Esta Nota Fiscal já foi conferida pelos departamentos "+Chr(13)+Chr(10)+;
	         "Fiscal e Contas a Pagar, não sendo permitida sua exclusão."+Chr(13)+Chr(10)+;
	         "Favor entrar em contato com o departamento de Contas a Pagar!"
	Aviso('ATENÇÃO!',cHelp,{'Ok'})
EndIf

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³VG - 2011.03.08 - Se foi chamado pelo documento de entrada³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
If IsInCallStack("MATA103") 
	If SF1->F1_XPRORAT == '1'
		Aviso("Aviso","O documento de entrada tem rateios já contabilizados. Por favor, estorne os rateios antes de excluir o documento.",{"OK"},,"Atenção",,"BMPPERG")
		lRet	:= .F.    		
	Endif
Endif

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//2017.07.28 - OS 2078/17 - Douglas David						 ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
If dEmissao <= dDataFis
	Aviso("Aviso","A data da operação é menor ou igual a data limite para realização de operações fiscais.",{"OK"},,"Atenção",,"BMPPERG")
	lRet := .F.
Endif

Return(lRet)
