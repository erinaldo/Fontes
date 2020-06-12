#INCLUDE "rwmake.ch"

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³CCTBE01  º Autor ³ Claudio Barros     º Data ³  18/08/05   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDescricao ³ Validar a digitacao da conta contabil.                     º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ SIGAFIN - Creditos Nao identificados                       º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/

User Function CCTBE01(pConta)



//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Declaracao de Variaveis                                             ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

Local lRet := .T.
Private cString := "CT1"


dbSelectArea("CT1")
dbSetOrder(2)
CT1->(DBGOTOP())

Do Case 
   Case Subs(Alltrim(pConta),1,1) $ "1/2"
  
        IF Len(Alltrim(pConta)) > 8
           MsgAlert("Quantidade de Digitos da Conta Incorretos!!!","Informe ate 8 Digitos")
           lRet := .F.
        EndIf
       IF !CT1->(Dbseek(xFilial("CT1")+Subs(pConta,1,8),.F.))
           MsgAlert("Conta Reduzida Nao Econtrada, Verifique!!!",Subs(Alltrim(pConta),1,7))
           lRet := .F.
       Else 
         IF Alltrim(CT1->CT1_CLASSE) == "1" 
            MsgAlert("A conta deve ser analitica, Verifique!!!")
            lRet := .F.
         EndIf
       Endif

   Case Subs(Alltrim(pConta),1,1) $ "3/4"
        IF Len(Alltrim(pConta)) > 5
           MsgAlert("Quantidade de Digitos da Conta Incorretos!!!","Informe ate 5 Digitos")
           lRet := .F.
        EndIf
       IF !CT1->(Dbseek(xFilial("CT1")+Subs(pConta,1,5),.F.))
           MsgAlert("Conta Reduzida Nao Econtrada, Verifique!!!",Subs(Alltrim(pConta),1,5))
           lRet := .F.
       Else 
         IF Alltrim(CT1->CT1_CLASSE) == "1" 
            MsgAlert("A conta deve ser analitica, Verifique!!!")
            lRet := .F.
         EndIf
       Endif
    OtherWise
       MsgAlert("Conta Invalida, Verifique!!!",pConta)
       lRet := .F.
EndCase



Return(lRet)
