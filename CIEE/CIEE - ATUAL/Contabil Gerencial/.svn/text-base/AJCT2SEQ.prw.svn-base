#INCLUDE "rwmake.ch"

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³NOVO2     º Autor ³ AP6 IDE            º Data ³  27/07/05   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDescricao ³ Codigo gerado pelo AP6 IDE.                                º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ AP6 IDE                                                    º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/


User Function AJCT2SEQ()
     MsAguarde({|lEnd| AJCT2SEQA()}, "Atualizando...", "Aguarde", .F.)
Return


STATIC Function AJCT2SEQA()


//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Declaracao de Variaveis                                             ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ


Private cString := "CT2"

dbSelectArea("CT2")
dbSetOrder(1)

nReg := RECCOUNT("CT2")
ProcRegua(nReg)

While !CT2->(EOF())

/*     
      IF ALLTRIM(CT2->CT2_LOTE) <> "009000" .OR. ;
         ALLTRIM(CT2->CT2_LOTE) <> "009500"  .OR. ;
         ALLTRIM(CT2->CT2_LOTE) <> "009700"  
         CT2->(DBSKIP())
         LOOP
      ENDIF
*/      
      IncProc("Processando...")
/*
      IF ALLTRIM(CT2->CT2_LOTE) <> "009700"  .OR. ALLTRIM(CT2->CT2_LOTE) <> "009000" 
         CT2->(DBSKIP())
         LOOP
      ENDIF
*/
      IF ALLTRIM(CT2->CT2_LOTE) <> "009700"  
         CT2->(DBSKIP())
         LOOP
      ENDIF

      IF ALLTRIM(CT2->CT2_TPSALD) <> "1"                                   
         CT2->(DBSKIP())
         LOOP
       ENDIF

//         IF CT2->CT2_DATA < CTOD("12/08/05") .OR. CT2->CT2_DATA > CTOD("15/08/05")
         IF CT2->CT2_DATA <> CTOD("11/08/05")
         CT2->(DBSKIP())
         LOOP
      ENDIF


      cDATA := CT2->CT2_DATA 
      cLote := CT2->CT2_LOTE
      cSbLote := CT2->CT2_SBLOTE
      cDoc    := CT2->CT2_DOC
      nSeqLan := 0
      While CT2->CT2_FILIAL == xFILIAL("CT2") .AND. CT2->CT2_DATA == cDATA .AND. ;
            CT2->CT2_LOTE == cLote .AND. CT2->CT2_SBLOTE == cSbLote  .AND. ;
            CT2->CT2_DOC == cDoc 
                                  
            IncProc("Processando...")
            nSeqLan := nSeqLan + 1
            RecLock("CT2",.F.)
            CT2->CT2_SEQLAN := STRZERO(nSeqLan,3)
            CT2->(MsUnlock())
            CT2->(DBSKIP())
      End
            
End            
      
      
MsgInfo("Fim do Processamento.....")      
            

Return
            



