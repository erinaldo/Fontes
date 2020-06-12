#INCLUDE "rwmake.ch"

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³FA050GRV  ºAutor  ³Microsiga           º Data ³  06/09/06   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ Gera a tabela SV3, a partir da inclusao do contas a pagar  º±±
±±º          ³ com rateio, iguala a natureza com o plano de contas.       º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ PROTHEUS 8.11 - Exclusivo CIEE                             º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

Private _aStru := {}

If SE2->E2_PREFIXO # "FFC" .OR SE2->E2_PREFIXO # "FFQ"
   Return
Endif

dbSelectArea("CV4")
dbsetorder(1)

IF dbseek(SE2->E2_ARQRAT) // Monta arquivo de trabalho
   AADD(_aStru,{"xFILIAL",  "C",  2,0})
   AADD(_aStru,{"xPREFIXO", "C",  3,0})
   AADD(_aStru,{"xTITULO",  "C",  6,0})
   AADD(_aStru,{"xPARCELA", "C",  1,0})
   AADD(_aStru,{"xFORNEC",  "C",  6,0})
   AADD(_aStru,{"xLOJA",    "C",  3,0})
   AADD(_aStru,{"xTIPO",    "C",  3,0})
   AADD(_aStru,{"xVALOR",   "N", 17,2})
   AADD(_aStru,{"xNATUREZ", "C", 10,0})
   AADD(_aStru,{"xRECPAG",  "C",  1,0})
   AADD(_aStru,{"xPERRAT",  "N",  11,7})
   AADD(_aStru,{"xRATCC",   "C",  1,0})
   AADD(_aStru,{"xIDENT",   "C",  1,0})
dArqTrb := CriaTrab(_aStru,.t.)
dbUseArea(.T.,,dArqTrb,"TRT",.T.)
//IndRegua("TRT",dArqTrb,"CT2_FILIAL+DTOS(CT2_DATA)+CT2_LOTE+CT2_SBLOTE+CT2_DOC+CT2_LINHA",,,"Criando Arquivo...")
IndRegua("TRT",dArqTrb,"CT2_FILIAL+DTOS(CT2_DATA)+CT2_LOTE+CT2_DOC+CT2_LINHA",,,"Criando Arquivo...")




