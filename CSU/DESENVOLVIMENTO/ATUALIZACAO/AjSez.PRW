#include "rwmake.ch"
user function  AjSez
// Ajusta o percentual real em SEZ

local _oDlg1

private _cPerg:= PADR("AjSez",LEN(SX1->X1_GRUPO))
validperg(_cPerg)

@ 000,000 to 180,400 dialog _odlg1 title 'Ajuste do percentual real em SEZ'

@ 010,010 say "Batch para atualizacao do campo EZ_CSPERCR"

@ 040,050 bmpbutton type 1 action u_RsAguarde({||_fAjSez()},"Ajustando o percentual em SEZ")
@ 040,090 BmpButton Type 5 Action (_fPar(),close(_oDlg1))
@ 040,130 bmpbutton type 2 action close(_oDlg1)

activate dialog _oDlg1 centered

*-------------------------------------------------------------------------------------------
static function _fAjSez()
*-------------------------------------------------------------------------------------------
pergunte(_cPerg,.f.)
_dDataIni:=mv_par01
_dDataFim:=mv_par02

_cFiltro:="dtos(e2_emissao)>='"+dtos(mv_par01)+"'.and.dtos(e2_emissao)<='"+dtos(mv_par02)+"'"
se2->(IndRegua(alias(),criatrab(,.f.),indexkey(),,_cFiltro))

_cUltimo:="/"+alltrim(str(se2->(lastrec())))
_nJafoi:=0

se2->(dbgotop())
do while se2->(!eof())
   _fAjSez1()
   se2->(dbskip(1))
   u_RsProcTxt("Titulos: "+alltrim(str(++_nJafoi))+_cUltimo+"     Emissao:"+dtoc(se2->e2_emissao))
enddo
se2->(retindex())

*---------------------------------------------------------------------------------------------------------------
static function _fPar()
*---------------------------------------------------------------------------------------------------------------

pergunte(_cPerg,.t.)
return

*-------------------------------------------------------------------------------------------
static function _fAjSez1()
*-------------------------------------------------------------------------------------------
local _cKeySe2:=se2->(e2_prefixo+e2_num+e2_parcela+e2_tipo+e2_fornece+e2_loja),;
      _vAmbSev:=sev->(getarea()),;
      _vAmbSez:=sez->(getarea())

sev->(dbsetorder(1)) // EV_FILIAL+EV_PREFIXO+EV_NUM+EV_PARCELA+EV_TIPO+EV_CLIFOR+EV_LOJA+EV_NATUREZ
sez->(dbsetorder(1)) // EZ_FILIAL+EZ_PREFIXO+EZ_NUM+EZ_PARCELA+EZ_TIPO+EZ_CLIFOR+EZ_LOJA+EZ_NATUREZ+EZ_CCUSTO

// Atualiza o percentual real de rateio em SEZ
sev->(dbseek(xfilial()+_cKeySe2,.f.))
do while sev->(!eof().and.EV_FILIAL+EV_PREFIXO+EV_NUM+EV_PARCELA+EV_TIPO+EV_CLIFOR+EV_LOJA==xfilial()+_cKeySe2)
   if sev->ev_recpag=="P"
      _cKeySev:=sev->(EV_PREFIXO+EV_NUM+EV_PARCELA+EV_TIPO+EV_CLIFOR+EV_LOJA+EV_NATUREZ)
      sez->(dbseek(xfilial()+_cKeySev,.f.))
      do while sez->(!eof().and.EZ_FILIAL+EZ_PREFIXO+EZ_NUM+EZ_PARCELA+EZ_TIPO+EZ_CLIFOR+EZ_LOJA+EZ_NATUREZ==;
                                xfilial()+_cKeySeV)
         if sez->(ez_cspercr==0.and.ez_recpag=="P")
            do while sez->(!reclock(alias(),.f.))
            enddo
            sez->ez_cspercr:=round(sev->ev_perc*sez->ez_perc,7)
            sez->(msunlock())
         endif
         sez->(dbskip(1))
      enddo
   endif
   sev->(dbskip(1))
enddo

sev->(restarea(_vAmbSev))
sez->(restarea(_vAmbSez))
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

u__fAtuSx1(padr(_cPerg,len(sx1->x1_grupo)),aRegs)
Return