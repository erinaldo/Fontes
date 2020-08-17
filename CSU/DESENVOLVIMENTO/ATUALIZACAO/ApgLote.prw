#include "rwmake.ch"

*---------------------------------------------------------------------------------------------------------------
User Function ApgLote()
* Batch para eliminacao de registros em CT2
* Ricardo Luiz da Rocha - Dts Consulting - 24/03/2005 GNSJC
*---------------------------------------------------------------------------------------------------------------
private _cPerg:= PADR("ApgLo",LEN(SX1->X1_GRUPO))
validperg(_cPerg)      

@ 100,091 To 250,610 Dialog oBase Title OemToAnsi("Eliminacao de lotes contabeis por periodo")
@ 012,016 Say u__fAjTxt('Esta rotina elimina todos os registros de um mesmo lote contabil na')
@ 022,016 Say u__fAjTxt('empresa atual e periodo definido nos parametros.')

@ 045,090 BmpButton Type 1 Action _fProssegue()
@ 045,130 BmpButton Type 5 Action _fPar()
@ 045,170 BmpButton Type 2 Action close(oBase)
Activate Dialog oBase centered
Return

*---------------------------------------------------------------------------------------------------------------
static function _fPar()
*---------------------------------------------------------------------------------------------------------------

pergunte(_cPerg,.t.)
return

*-------------------------------------------------------------------------------------------------------------
static Function _fProssegue
*-------------------------------------------------------------------------------------------------------------
pergunte(_cPerg,.f.)
                                                                
_dDataIni:=mv_par01
_dDataFim:=mv_par02
_cLote   :=mv_par03
_cMens:=_cMen2:=""
if !msgyesno("Atencao: TODOS os registros pertencentes ao lote ["+_cLote+"], no periodo de "+dtoc(_dDataIni)+" a "+dtoc(_dDataFim)+" na empresa atual serao eliminados, confirma ?")
   return
endif    

cursorwait()
u_rsaguarde({||_fDesfl()},"Eliminando registros...")
cursorarrow()

*-------------------------------------------------------------------------------------------------------------
static Function _fDesfl()
*-------------------------------------------------------------------------------------------------------------

ct2->(dbsetorder(1)) // CT2_FILIAL+DTOS(CT2_DATA)+CT2_LOTE+CT2_SBLOTE+CT2_DOC+CT2_LINHA+CT2_TPSALD+CT2_EMPORI+CT2_FILORI+CT2_MOEDLC
ct2->(dbseek(xfilial()+dtos(_dDataIni),.t.))
_nPerc:=_nApag:=0
_cRefer:=dtoc(date())+" as "+time()+" h"
_cMens2:=""
do while ct2->(!eof().and.ct2_filial==xfilial().and.ct2_data<=_dDataFim)
   if ct2->ct2_lote==_cLote
      do while ct2->(!eof().and.ct2_filial==xfilial().and.ct2_data<=_dDataFim.and.ct2_lote==_cLote)
         
         if ct2->(reclock(alias(),.f.))
            ct2->ct2_origem:=alltrim(ct2->ct2_origem)+" ApgLote em "+_cRefer
            ct2->(dbdelete())
            ct2->(msunlock())
            _nApag++
         endif
         ct2->(dbskip(1))
         u_rsproctxt(_cMens+(_cMen2:=" Eliminados: "+alltrim(str(_nApag)))+" Data: "+dtoc(ct2->ct2_data))
         _nPerc++
      enddo
   else
      ct2->(dbskip(1))
      _nPerc++
   endif
   u_rsproctxt(_cMens+_cMen2+" Data: "+dtoc(ct2->ct2_data))
enddo         

msgbox("Concluido, "+_cMens+_cMens2)

return

*--------------------------------------------------------------------------------
Static Function VALIDPERG(_cPerg)
*--------------------------------------------------------------------------------

local aRegs := {}
          *   1    2            3                   4     5   6  7 8  9  10   11        12    13 14    15    16 17 18 19 20 21 22 23 24 25  26
          *+------------------------------------------------------------------------------------------------------------------------------------+
          *¦G    ¦ O  ¦ PERGUNT                 ¦V       ¦T  ¦T ¦D¦P¦ G ¦V ¦V         ¦ D    ¦C ¦V ¦D       ¦C ¦V ¦D ¦C ¦V ¦D ¦C ¦V ¦D ¦C ¦F    ¦
          *¦ R   ¦ R  ¦                         ¦ A      ¦ I ¦A ¦E¦R¦ S ¦A ¦ A        ¦  E   ¦N ¦A ¦ E      ¦N ¦A ¦E ¦N ¦A ¦E ¦N ¦A ¦E ¦N ¦3    ¦
          *¦  U  ¦ D  ¦                         ¦  R     ¦  P¦MA¦C¦E¦ C ¦ L¦  R       ¦   F  ¦ T¦ R¦  F     ¦ T¦R ¦F ¦ T¦R ¦F ¦ T¦R ¦F ¦ T¦     ¦
          *¦   P ¦ E  ¦                         ¦   I    ¦  O¦NH¦ ¦S¦   ¦ I¦   0      ¦    0 ¦ 0¦ 0¦   0    ¦ 0¦0 ¦0 ¦ 0¦0 ¦0 ¦ 0¦0 ¦0 ¦ 0¦     ¦
          *¦    O¦ M  ¦                         ¦    AVL ¦   ¦ O¦ ¦E¦   ¦ D¦    1     ¦    1 ¦ 1¦ 2¦    2   ¦ 2¦3 ¦3 ¦ 3¦4 ¦4 ¦ 4¦5 ¦5 ¦ 5¦     ¦
AADD(aRegs,{_cPerg,"01","Emissao de            :","mv_ch1","D",08,0,0,"G","","mv_par01",""    ,"","",""      ,"","","","","","","","","","",""})
AADD(aRegs,{_cPerg,"02","Emissao ate           :","mv_ch2","D",08,0,0,"G","","mv_par02",""    ,"","",""      ,"","","","","","","","","","",""})
AADD(aRegs,{_cPerg,"03","Lote contabil         :","mv_ch3","C",06,0,0,"G","","mv_par03",""    ,"","",""      ,"","","","","","","","","","",""})

u__fAtuSx1(padr(_cPerg,len(sx1->x1_grupo)),aRegs)
Return