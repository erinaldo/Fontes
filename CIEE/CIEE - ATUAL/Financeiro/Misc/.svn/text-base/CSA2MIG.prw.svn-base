#INCLUDE "rwmake.ch"

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณCSA2MIG   บ Autor ณ AP6 IDE            บ Data ณ  26/05/06   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDescricao ณ Codigo gerado pelo AP6 IDE.                                บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ AP6 IDE                                                    บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
/*/


USER FUNCTION CSA2MIG()
PRIVATE lEnd := .F.

MsAguarde({|lEnd| RunProc(@lEnd)},"Aguarde...","Processando Contas Correntes",.T.)

RETURN



Static Function RunProc(lEnd)


//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
//ณ Declaracao de Variaveis                                             ณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู

Local cQuery := " "
Local nVez := 0
Private cString := "SA2"

dbSelectArea("SA2")
dbSetOrder(1)

cQuery := " SELECT A2_COD,A2_NOME, A2_LOJA, A2_BANCO,A2_AGENCIA, A2_DVAG, A2_CCPOUPA, A2_NUMCON "
cQuery += " FROM SA2010 WHERE D_E_L_E_T_ = ' '  AND A2_NUMCON <> ' ' "
cQuery := ChangeQuery(cQuery)
dbUseArea(.T.,"TOPCONN",TcGenQry(,,cQuery),'TRB',.T.,.T.)



DbSelectarea("TRB")

MsgInfo("Inicio Processo... ")      
nVez:=0
While !TRB->(EOF())

   If lEnd
      MsgInfo(cCancel,"Fim")
      Exit
   Endif                           
   nVez++
  
   MsProcTxt("Processando Registros "+Str(nVez,5))

      DbSelectArea("SZK")
      Reclock("SZK",.T.)
      SZK->ZK_FILIAL  :=  xFilial("SZK") 
      SZK->ZK_BANCO   :=  TRB->A2_BANCO
      SZK->ZK_AGENCIA :=  TRB->A2_AGENCIA
      SZK->ZK_TIPO    :=  IIF(ALLTRIM(TRB->A2_CCPOUPA) <> "2","1","2") 
      SZK->ZK_NUMCON  :=  IIF(ALLTRIM(TRB->A2_CCPOUPA) <> "2" ,TRB->A2_NUMCON, "")
      SZK->ZK_NROPOP  :=  IIF(TRB->A2_CCPOUPA == "2" ,TRB->A2_NUMCON, "")
      SZK->ZK_NROCRT  :=  " "
      SZK->ZK_FORNECE :=  TRB->A2_COD
      SZK->ZK_LOJA    :=  TRB->A2_LOJA
      SZK->ZK_NOME    :=  TRB->A2_NOME
      SZK->ZK_NOMBCO  :=  POSICIONE("SZ1",1,xFilial("SZ1")+TRB->A2_BANCO,"Z1_DESCR")
      SZK->ZK_DVAG    :=  TRB->A2_DVAG
      SZK->(MsUnlock())
      TRB->(DBSKIP())
End      
      
      
MsgInfo("Processo Finalizado....Ok")      
      
If Select("TRB") > 0
   TRB->(DbCloseArea())
EndIf   


Return
