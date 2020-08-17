#INCLUDE "PROTHEUS.CH"

user function GPM040GR

Local aAreaAnt := GetArea()
Local xCodUser := ""
Local xNameUser:= ""

dbSelectArea("SRA")

//OS 2383/16
PswOrder(1)

xCodUser := Sra->Ra_CodUsu_

If PswSeek(xCodUser)
   //Se encontrou grava o Username na variavel xNameUser                  
   xNameUser := PswRet(1)[1][2]
   //Bloqueia usuário no configurador
   PswBlock(xNameUser)
EndIf
//OS 2383/16

RecLock("SRA",.F.)
SRA->RA_MDEXC := " "
MsUnlock()

RestArea(aAreaAnt)
Return Nil
