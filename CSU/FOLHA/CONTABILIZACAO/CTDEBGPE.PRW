#INCLUDE "rwmake.ch"

User Function CTDEBGPE()
/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³CTDEBGPE  |Autor  ³ Sandra R. Prada    º Data ³  03/10/03   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±º 																	  º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ SIGAGPE                                                    º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

// Declaracao das Variaveis
                                                    
SetPrvt("_cSitfolh,_TPCCUSTO,_CTADEB") 

_cSitfolh := " "    
_TPCCUSTO := " " 
_CTADEB   := " " 

 DbSelectArea("SRA")
 DbSetOrder(1)                              

 If DbSeek(SRZ->RZ_FILIAL + SRZ->RZ_MAT)                   
    _cSitfolh := SRA->RA_SITFOLH 
    _demissa  := SRA->RA_DEMISSA          
 Endif 

 _dtperiodo := dDataBase  //"30/"+subs(mv_par01,1,2)+"/"+subs(mv_par01,3,4)

 DbSelectArea("CTT")
 DbSetOrder(1) 
 
  If DbSeek("  "+SRZ->RZ_CC)                             
     _TPCCUSTO := CTT->CTT_GRUPO
  Endif 

If SRV->RV_LCTOP <> SPACE(3)
  If _cSitfolh <> 'D' .AND. _TPCCUSTO = "01"
       _CTADEB := SRV->RV_CTDEB1
  ElseIf _cSitfolh <> 'D' .AND. _TPCCUSTO = "02"
       _CTADEB := SRV->RV_CTDEB2
  ElseIf _cSitfolh == 'D' .AND._demissa > _dtperiodo .AND. _TPCCUSTO = "01"
       _CTADEB := SRV->RV_CTDEB1       
  ElseIf _cSitfolh == 'D' .AND._demissa > _dtperiodo .AND. _TPCCUSTO = "02"
       _CTADEB := SRV->RV_CTDEB2
  ElseIf _cSitfolh == 'D' .AND. _demissa <= _dtperiodo .AND. _TPCCUSTO = "01"
       _CTADEB := SRV->RV_CTDEB3
  ElseIf _cSitfolh == 'D' .AND. _demissa <= _dtperiodo .AND. _TPCCUSTO = "02"
       _CTADEB := SRV->RV_CTDEB4       
 // Else 
  //     _CTADEB := "ERRO"
  Endif                      
Endif   
                                                  
Return _CTADEB