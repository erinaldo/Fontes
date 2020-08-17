*-------------------------------------------------------------------------
user function CsFinR01()
*-------------------------------------------------------------------------

nLastKey  :=0
limite    :=132
wnrel     :=nomeprog:="CsFinR01"
cDesc1    :="Relacao de rateios com inconsistencias no centro de custo / empresa de destino"
cDesc2    :=" "
cDesc3    :=" "
cString   :="CT2"
tamanho   := "M"
titulo    := cDesc1
aReturn   := { "Zebrado", 1,"Administracao", 1, 2, 1, "",0 }
_nLin     :=99
m_pag     :=1
Li        :=0
_cPerg:= PADR("FinR01",LEN(SX1->X1_GRUPO))
validperg(_cPerg)
          
Cabec1:="Orig Reg. Filial Prefixo Numero Parcela Tipo Fornecedor (Codigo-Loja Nome)  Emissao           Valor Empresa de destino"
Cabec2:=""   
cursorarrow()
wnrel := SetPrint(cString,wnrel,_cPerg,@Titulo,cDesc1,cDesc2,cDesc3,.t.,,.t.,tamanho)
if nLastkey==27
   set filter to
   return
endif
cursorwait()
RptStatus({|| RptDetail() })
cursorarrow()
se2->(retindex(alias()))
*-------------------------------------------
Static function rptdetail
*-------------------------------------------
pergunte(_cPerg,.f.)                      
se2->(dbsetorder(1))                            
sez->(dbsetorder(1))
_cFiltro:="e2_multnat<>'2'.and.dtos(e2_emissao)>='"+dtos(mv_par01)+"'.and.dtos(e2_emissao)<='"+dtos(mv_par02)+"'.and.e2_tipo<>'TX '.and.e2_tipo<>'INS'"
_cOrdem:="e2_filial+dtos(e2_emissao)+e2_prefixo+e2_num+e2_parcela+e2_tipo+e2_fornece+e2_loja"
se2->(IndRegua(alias(),criatrab(,.f.),_cOrdem,,_cFiltro,"Selecionando Registros no arquivo "+alias()))
setregua(se2->(lastrec()))
se2->(dbgotop())
setdefault(aReturn,cString)

_nLin:=99
_nErros:=0
do while se2->(!eof())
    incregua()
    _cEmpresa:=se2->e2_codarea
    if sez->(!dbseek(xfilial()+se2->(e2_prefixo+e2_num+e2_parcela+e2_tipo+e2_fornece+e2_loja),.f.))
       _nErros++
       @ _fIncrLin(),0 PSAY se2->("Principal   "+e2_filial+"     "+e2_prefixo+"   "+e2_num+"    "+e2_parcela+"     "+e2_tipo+" "+e2_fornece+"-"+e2_loja+" "+e2_nomfor+" "+dtoc(e2_emissao)+" "+tran(e2_valor,"@er 999,999,999.99")+" "+_cEmpresa)
    else
       // Se chegou aqui, SEZ existe, verificar se esta correto quanto a somatoria e a empresa de destino
       _nDif:=0
       do while sez->(!eof().and.ez_filial==xfilial().and.se2->(e2_prefixo+e2_num+e2_parcela+e2_tipo+e2_fornece+e2_loja)==;
                ez_prefixo+ez_num+ez_parcela+ez_tipo+ez_clifor+ez_loja)
          if sez->ez_recpag=="P"
             _nDif+=(sez->ez_cspercr*100)
             _cEmpresa:=sez->ez_empr
             if !_cEmpresa$"02/03/04/09"
                @ _fIncrlin(),0 PSAY sez->("Rateio CC   "+ez_filial+"     "+ez_prefixo+"   "+ez_num+"    "+ez_parcela+"     "+ez_tipo+" "+ez_clifor+"-"+ez_loja+" "+se2->e2_nomfor+" "+dtoc(se2->e2_emissao)+" "+tran(ez_valor,"@er 999,999,999.99")+" "+_cEmpresa)
                _nErros++
             endif
          endif
          sez->(dbskip(1))
       enddo
       if abs(_nDif-100)>1
          @ _fIncrLin(),0 PSAY se2->("Principal   "+e2_filial+"     "+e2_prefixo+"   "+e2_num+"    "+e2_parcela+"     "+e2_tipo+" "+e2_fornece+"-"+e2_loja+" "+e2_nomfor+" "+dtoc(e2_emissao)+" "+tran(e2_valor,"@er 999,999,999.99")+" "+_cEmpresa+" Percentual invalido: "+alltrim(str(_nDif))+" %")
          _nErros++
       endif
          
    endif
    se2->(dbskip(1))
enddo
if _nLin>58
   Cabec(titulo,cabec1,cabec2,nomeprog,tamanho)
   _nLin:=li+2
endif

@ _nLin+=3,0 PSAY "Total de registros inconsistentes: "+alltrim(str(_nErros))

setregua(1)
incregua()

roda(0,"",tamanho)

If aReturn[5] == 1
   Set Printer To
   Commit
   ourspool(wnrel)
Endif
MS_FLUSH()
Return

return
              
*--------------------------------------------------------------------------------
static function _fIncrLin()
*--------------------------------------------------------------------------------
if _nLin>58
   Cabec(titulo,cabec1,cabec2,nomeprog,tamanho)
   _nLin:=li+2
else
   _nLin++   
endif
return _nLin

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
