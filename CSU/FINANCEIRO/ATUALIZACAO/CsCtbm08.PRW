#include "rwmake.ch"

*-------------------------------------------------------------------------------------------------------------
user function CsCtbM08()
* Batch para ajuste da contabilizacao e valor do cofins dos titulos a pagar
* eventualmente gerados com o valor de R$ 0,01
* Ricardo Luiz da Rocha 20/06/2006 GNSJC
* Procedimento para a implantacao: 
*-------------------------------------------------------------------------------------------------------------
Private _cPerg:=PADR("CtbM08",LEN(SX1->X1_GRUPO))

validperg(_cPerg)

@ 100,091 To 285,527 Dialog _oDlg1 Title 'Ajuste da contabilizacao dos titulos de R$ 0,01'
@ 012,016 Say u__fAjTxt('Esta rotina realizara o ajuste para que a contabilizacao automatica')
@ 022,016 Say u__fAjTxt('despreze os titulos a pagar eventualmente gerados com  o valor de')
@ 032,016 Say u__fAjTxt('R$ 0,01, alem do incremento deste mesmo valor no recolhimento do')
@ 042,016 Say u__fAjTxt("Cofins.")

@ 075,020 BmpButton Type 1 Action u_rsaguarde({||_fProssegue()},"Analisando titulos a pagar")
@ 075,090 BmpButton Type 5 Action pergunte(_cPerg,.t.)
@ 075,160 BmpButton Type 2 Action close(_oDlg1)

Activate Dialog _oDlg1 centered

se2->(retindex(alias()))

*--------------------------------------------------------------------------------
Static Function _fProssegue()
*--------------------------------------------------------------------------------
u_RsProcTxt("Colhendo parametros")
pergunte(_cPerg,.f.)
_dDataIni:=mv_par01
_dDataFim:=mv_par02

// 1a fase, colher os titulos ainda nao tratados
_vRecSe2:={}

_cFiltro:="E2_FILIAL=='"+xfilial("SE2")+"'"
_cFiltro+=".and.dtos(E2_EMISSAO)>='"+dtos(_dDataIni)+"'.and.dtos(E2_EMISSAO)<='"+dtos(_dDataFim)+"'"
_cFiltro+=".and.E2_LA<>'S'"
_cFiltro+=".and.E2_VALOR<0.02"

u_RsProcTxt("Selecionando os titulos principais")

se2->(indregua(alias(),criatrab(,.f.),"e2_filial+dtos(e2_emissao)",,_cFiltro))
se2->(dbgotop())

_vLog:={}

_cPictVal:=pesqpict("SE2","E2_VALOR")

_vRecSe2:={}
do while se2->(!eof())
   se2->(u_RsProcTxt("Analisando os titulos do periodo, Numero: "+e2_num+" Emissao: "+dtoc(e2_emissao)))
   if se2->e2_valor==0.01
      aadd(_vRecSe2,se2->(recno()))
   endif
   se2->(dbskip(1))
enddo

u_RsProcTxt("Restaurando indices - contas a pagar")
se2->(dbclearfil())
se2->(retindex())

for _nVez:=1 to len(_vRecSe2)
    _cAtual:=alltrim(str(_nVez))+" / "+alltrim(str(len(_vRecSe2)))
    
    se2->(dbgoto(_vRecSe2[_nVez]))
    se2->(u_RsProcTxt("Localizando titulo Cofins: "+e2_num+" de "+dtoc(e2_emissao)))
    _cKeyCof:=se2->(e2_filial+e2_prefixo+e2_num)
    _nValCof:=se2->e2_vretcof
    _lAchouCof:=.f.

    do while se2->(!reclock(alias(),.f.))
    enddo

    se2->(dbseek(_cKeyCof,.f.))
    do while se2->(!eof().and.e2_filial+e2_prefixo+e2_num==_cKeyCof)
       if se2->(e2_valor==_nValCof.and.;
          alltrim(e2_fornece)=="UNIAO".and.;
          e2_loja=="00".and.;
          alltrim(e2_tipo)=="TX")
          // Se chegou aqui, localizou o titulo do cofins
          u_RsProcTxt("Corrigindo o titulo: "+se2->e2_num)
          _lAchouCof:=.t.
          do while se2->(!reclock(alias(),.f.))
          enddo
          _nOldValor:=se2->e2_valor
          se2->e2_valor +=0.01
          se2->e2_vlcruz+=0.01
          se2->e2_saldo +=0.01

	      se2->(msunlock())

          se2->(aadd(_vLog,"Titulo corrigido - Filial: "+e2_filial+" Prefixo: "+e2_prefixo+" Numero: "+e2_num+;
                           " Parcela: "+e2_parcela+" Tipo: "+e2_tipo+" Fornecedor: "+e2_fornece+"/"+e2_loja+;
                           ' Valor principal alterado de R$ '+alltrim(tran(_nOldValor,_cPictVal))+;
                           " para: "+alltrim(tran(e2_valor,_cPictVal))))
          // o titulo de imposto foi atualizado, agora, atualizar o principal
          
          se2->(dbgoto(_vRecSe2[_nVez]))

          _nOldCof:=se2->e2_vretcof
          reclock("SE2",.f.)          
          se2->e2_vretcof+=0.01
          se2->e2_valor:=0
          se2->e2_saldo:=0
          se2->(msunlock())
          se2->(aadd(_vLog,"Titulo corrigido - Filial: "+e2_filial+" Prefixo: "+e2_prefixo+" Numero: "+e2_num+;
                           " Parcela: "+e2_parcela+" Tipo: "+e2_tipo+" Fornecedor: "+e2_fornece+"/"+e2_loja+;
                           ' Valor principal alterado de R$ 0,01 para R$ 0,00 - Valor do Cofins alterado de R$ '+;
                           alltrim(tran(_nOldCof,_cPictVal))+" para: "+alltrim(tran(e2_vretcof,_cPictVal))))
      
          aadd(_vLog,'')
          exit
       endif
       se2->(dbskip(1))   
    enddo
    if !_lAchouCof // se nao localizou o titulo do cofins, gera log e destrava o titulo principal
       se2->(dbgoto(_vRecSe2[_nVez]))
       se2->(msunlock())
       se2->(aadd(_vLog,"Titulo NAO corrigido - Filial: "+e2_filial+" Prefixo: "+e2_prefixo+" Numero: "+e2_num+;
                        " Parcela: "+e2_parcela+" Tipo: "+e2_tipo+" Fornecedor: "+e2_fornece+"/"+e2_loja+;
                        ' Valor principal: '+alltrim(tran(e2_valor,_cPictVal))+;
                        ' Valor do Cofins: '+alltrim(tran(e2_vretcof,_cPictVal))+;
                        '- O titulo do Cofins nao foi localizado'))
    endif
next

se2->(retindex())
    
if len(_vLog)>0
   _fImpLog()
else
   msgbox("Nao foram encontrados titulos para o ajuste")   
endif      
        
*-------------------------------------------------------------------------
static function _fImpLog()
*-------------------------------------------------------------------------

nLastKey  :=0
tamanho   := "G"
limite    :=220
wnrel     :=nomeprog:="CsCtbM08"
cDesc1    :="Relacao de titulos alterados"
cDesc2    :=" "
cDesc3    :=" "
cString   :="SE2"
titulo    := cDesc1
aReturn   := { "Zebrado", 1,"Administracao", 1, 2, 1, "",0 }
_nLin     :=99
m_pag     :=1
Li        :=0
          
Cabec1:="Detalhes dos titulos analisados / alterados"
Cabec2:=""
cursorarrow()
wnrel := SetPrint(cString,wnrel,,@Titulo,cDesc1,cDesc2,cDesc3,.t.,,.t.,tamanho)
if nLastkey==27
   set filter to
   return
endif
cursorwait()
asort(_vLog)
RptStatus({|| RptDetail()})
cursorarrow()
*-------------------------------------------
Static function rptdetail
*-------------------------------------------
setdefault(aReturn,cString)
setregua(len(_vLog))
_nLin:=99
for _nVez:=1 to len(_vLog)
    incregua()
    if _nLin>58
       Cabec(titulo,cabec1,cabec2,nomeprog,tamanho)
       _nLin:=li+2
    endif
    @ _nLin++,0 PSAY _vLog[_nVez]
next

roda(0,"",tamanho)

If aReturn[5] == 1
   Set Printer To
   Commit
   ourspool(wnrel)
Endif
MS_FLUSH()
Return
     
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
AADD(aRegs,{_cPerg,"01","Data de emissao de    :","mv_ch1","D",08,0,0,"G","","mv_par01",""    ,"","",""      ,"","","","","","","","","","",""})
AADD(aRegs,{_cPerg,"02","Data de emissao ate   :","mv_ch2","D",08,0,0,"G","","mv_par01",""    ,"","",""      ,"","","","","","","","","","",""})

u__fAtuSx1(padr(_cPerg,len(sx1->x1_grupo)),aRegs)
Return