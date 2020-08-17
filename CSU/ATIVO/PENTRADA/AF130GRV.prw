#include "rwmake.ch"

User Function AF130GRV()     

IF PARAMIXB[1]=="SN1"
   SN1->N1_CHAPA:=SUBSTR(SN1->N1_CBASE,5,6)
ENDIF

RETURN   

