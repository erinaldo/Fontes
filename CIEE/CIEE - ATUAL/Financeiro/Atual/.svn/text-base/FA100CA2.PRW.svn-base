//#INCLUDE "rwmake.ch"
#Include "Protheus.Ch"



/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³FA100CA2  º Autor ³ Claudio Barros     º Data ³  09/11/05   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDescricao ³ Ponto de Entrada para gravar o motivo da exclusao          º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ AP6 IDE                                                    º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/

User Function FA100CA2()


//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Declaracao de Variaveis                                             ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ



//+----------------------------------------------------------------------------
//| Declarações das varáveis
//+----------------------------------------------------------------------------
Local oDlg    := Nil
Local oFld    := Nil

Local cNome   := Space(40)
Local lChk    := .F.
Local cAtencao:= "Atenção"
Local lRet := .T.

Private cString := "SE5"

dbSelectArea("SE5")
dbSetOrder(1)           



//+----------------------------------------------------------------------------
//| Definição da janela e seus conteúdos
//+----------------------------------------------------------------------------
DEFINE MSDIALOG oDlg TITLE "Motivo da Exclusao" FROM 0,0 TO 130,382 OF oDlg PIXEL

@ 06,06 TO 46,177 LABEL "Descricao do Motivo" OF oDlg PIXEL
@ 25, 15 MSGET cNome Valid(!Empty(cNome))  PICTURE "@!" SIZE 150,10 PIXEL OF oDlg

//+----------------------------------------------------------------------------
//| Botoes da MSDialog
//+----------------------------------------------------------------------------
DEFINE SBUTTON FROM  050, 150 TYPE  1 ENABLE ACTION (oDLg:End()) OF oDLg // ENABLE OF oFld:aDialogs[3]


ACTIVATE MSDIALOG oDlg CENTER


IF Empty(cNome)
   lRet := .F.
Endif   


RecLock("SE5",.F.)
SE5->E5_MOTIVO := cNome
SE5->(MsUnlock())


Return(lRet)
