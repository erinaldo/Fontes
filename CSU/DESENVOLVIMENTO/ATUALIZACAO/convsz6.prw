#include "rwmake.ch"

*---------------------------------------------------------------------------------------------------------------
User Function ConvSz6()
* Batch para conversao dos registros em SZ6 para SEV e SEZ
* Ricardo Luiz da Rocha - Dts Consulting - 01/11/2004 GNSJC
*---------------------------------------------------------------------------------------------------------------

@ 100,091 To 250,610 Dialog oBase Title OemToAnsi("Conversao dos dados em SZ6")
@ 012,016 Say u__fAjTxt('Esta rotina transforma os dados de rateio em SZ6 para o padrao SEV/SEZ')
@ 022,016 Say u__fAjTxt('')

@ 045,090 BmpButton Type 1 Action (_fProssegue(),close(oBase))
//@ 045,130 BmpButton Type 5 Action _fPar()
@ 045,170 BmpButton Type 2 Action close(oBase)
Activate Dialog oBase centered
Return
  
/*
*---------------------------------------------------------------------------------------------------------------
static function _fPar()
*---------------------------------------------------------------------------------------------------------------
validperg(_cPerg)
pergunte(_cPerg,.t.)
return
*/

*-------------------------------------------------------------------------------------------------------------
static Function _fProssegue
*-------------------------------------------------------------------------------------------------------------
//pergunte(_cPerg,.f.)
//_lAtualiza:=(mv_par01==2)
cursorwait()
_vLog:={}
processa({||_fConvSZ6()},"Importando dados para SEV e SEZ")
cursorarrow()
if len(_vLog)>0
   _fImpLog()
endif


*-------------------------------------------------------------------------------------------------------------
static Function _fConvSZ6
*-------------------------------------------------------------------------------------------------------------
_vLog:={}
sz6->(dbsetorder(1)) // Z6_FILIAL+Z6_PREFIXO+Z6_NUMERO+Z6_PARCELA+Z6_TIPO+Z6_FORNECE+Z6_LOJA+Z6_NLINHA
procregua(sz6->(lastrec()))
sz6->(dbgotop())
_nPercorridos:=0
se2->(dbsetorder(1)) // E2_FILIAL+E2_PREFIXO+E2_NUM+E2_PARCELA+E2_TIPO+E2_FORNECE+E2_LOJA
sev->(dbsetorder(1)) // EV_FILIAL+EV_PREFIXO+EV_NUM+EV_PARCELA+EV_TIPO+EV_CLIFOR+EV_LOJA+EV_NATUREZ
sez->(dbsetorder(1)) // EZ_FILIAL+EZ_PREFIXO+EZ_NUM+EZ_PARCELA+EZ_TIPO+EZ_CLIFOR+EZ_LOJA+EZ_NATUREZ+EZ_CCUSTO
_cMens:=""
do while sz6->(!eof())
   _cChave:=sz6->(Z6_PREFIXO+Z6_NUMERO+Z6_PARCELA+Z6_TIPO+Z6_FORNECE+Z6_LOJA)
   _vSev:={}
   _vSez:={}
   _nPerc:=0
   do while sz6->(!eof().and.xfilial()+_cChave==Z6_FILIAL+Z6_PREFIXO+Z6_NUMERO+Z6_PARCELA+Z6_TIPO+Z6_FORNECE+Z6_LOJA)
      if sz6->(_nPosic:=ascan(_vSev,{|_vAux|alltrim(_vAux[1])==alltrim(z6_naturez)}))==0
         sz6->(aadd(_vSev,{z6_naturez,0,0}))
         _nPosic:=len(_vSev)
      endif
      _vSev[_nPosic][2]+=sz6->z6_perc
      _vSev[_nPosic][3]+=sz6->z6_valor
      
      if sz6->(_nPosic:=ascan(_vSez,{|_vAux|alltrim(_vAux[1])+"#"+alltrim(_vAux[2])==alltrim(z6_naturez)+"#"+alltrim(z6_cc)}))==0
         sz6->(aadd(_vSez,{z6_naturez,z6_cc,0,0,z6_empresa}))
         _nPosic:=len(_vSez)
      endif
      _vSez[_nPosic][3]+=round(sz6->z6_perc,7)
      _vSez[_nPosic][4]+=sz6->z6_valor
      
      incproc(_cMens:="Percorridos: "+alltrim(str(++_nPercorridos)))
      _nPerc+=round(sz6->z6_perc,7)
      sz6->(dbskip(1))
   enddo
   if _nPerc>200
      a:=1
   endif         
   if se2->(dbseek(xfilial()+_cChave,.f.))
      // Tratamento anti-duplicidade em SEV e SEZ
      sev->(dbseek(xfilial()+_cChave,.f.))
      do while sev->(!eof().and.EV_FILIAL+EV_PREFIXO+EV_NUM+EV_PARCELA+EV_TIPO+EV_CLIFOR+EV_LOJA==xfilial()+_cChave)
         if sev->ev_recpag=="P"
            sev->(reclock(alias(),.f.))
            sev->(dbdelete())
            sev->(msunlock())
         endif   
         sev->(dbskip(1))
      enddo   
   
      sez->(dbseek(xfilial()+_cChave,.f.))
      do while sez->(!eof().and.EZ_FILIAL+EZ_PREFIXO+EZ_NUM+EZ_PARCELA+EZ_TIPO+EZ_CLIFOR+EZ_LOJA==xfilial()+_cChave)
         if sez->ez_recpag=="P"
            sez->(reclock(alias(),.f.))
            sez->(dbdelete())
            sez->(msunlock())
         endif   
         sez->(dbskip(1))
      enddo
      
      // Verifica / ajusta eventuais diferencas
      _nDifVal:=SE2->(E2_VALOR+E2_IRRF+E2_ISS+E2_INSS+E2_RETENC+IIf(FieldPos("E2_SEST")>0,E2_SEST,0))
      _nDifPerc:=100
      
      for _nVez:=1 to len(_vSev)
          _nDifPerc-=_vSev[_nVez][2]
          _nDifVal-= _vSev[_nVez][3]
      next

      if _nDifVal<>0
         _vSev[len(_vSev)][3]+=_nDifVal
         if abs(_nDifVal)>.05
            //aadd(_vLog,"SEV - Chave: ["+_cChave+"] Diferenca no Valor: "+str(_nDifVal))
         endif
      endif   
      
      if _nDifPerc<>0
         _vSev[len(_vSev)][2]+=_nDifPerc
         if abs(_nDifPerc)>2
            //aadd(_vLog,"SEV - Chave: ["+_cChave+"] Diferenca no Perc.: "+str(_nDifPerc))
         endif
      endif   
      
      _nDifVal:=SE2->(E2_VALOR+E2_IRRF+E2_ISS+E2_INSS+E2_RETENC+IIf(FieldPos("E2_SEST")>0,E2_SEST,0))
      _nDifPerc:=100
      
      for _nVez:=1 to len(_vSez)
          _nDifPerc-=_vSez[_nVez][3]
          _nDifVal-= _vSez[_nVez][4]
      next

      if _nDifVal<>0
         _vSez[len(_vSez)][4]+=_nDifVal
         if abs(_nDifVal)>.05
            aadd(_vLog,"Registro: "+strzero(se2->(recno()),8)+" Emissao: "+dtoc(se2->e2_emissao)+" Baixa: "+dtoc(se2->e2_baixa)+" Contabilizado: ["+se2->e2_la+"]   SEZ - Chave: ["+_cChave+"] Diferenca no Valor: "+str(_nDifVal))
         endif
      endif   
      
      if _nDifPerc<>0
         _vSez[len(_vSez)][3]+=_nDifPerc
         if abs(_nDifPerc)>2
            aadd(_vLog,"Registro: "+strzero(se2->(recno()),8)+" Emissao: "+dtoc(se2->e2_emissao)+" Baixa: "+dtoc(se2->e2_baixa)+" Contabilizado: ["+se2->e2_la+"]   SEZ - Chave: ["+_cChave+"] Diferenca no Perc.: "+str(_nDifPerc))
         endif
      endif   
            
      // Vetores prontos, alimentar sev e sez
      
      for _nVez:=1 to len(_vSev)
          sev->(reclock(alias(),.t.))
          sev->ev_filial :=xfilial("SEV")
          sev->ev_prefixo:=se2->e2_prefixo
          sev->ev_num    :=se2->e2_num
          sev->ev_parcela:=se2->e2_parcela
          sev->ev_clifor :=se2->e2_fornece
          sev->ev_loja   :=se2->e2_loja
          sev->ev_tipo   :=se2->e2_tipo
          sev->ev_naturez:=_vSev[_nVez][1]
          sev->ev_perc   :=round(_vSev[_nVez][2]/100,7)
          sev->ev_valor  :=_vSev[_nVez][3]

          sev->ev_recpag :="P"
          sev->ev_rateicc:="1"
          sev->ev_la     :=se2->e2_la
          
          sev->(msunlock())
      next   
      for _nVez:=1 to len(_vSez)
          sez->(reclock(alias(),.t.))
          sez->ez_filial :=xfilial("SEZ")
          sez->ez_prefixo:=se2->e2_prefixo
          sez->ez_num    :=se2->e2_num
          sez->ez_parcela:=se2->e2_parcela
          sez->ez_clifor :=se2->e2_fornece
          sez->ez_loja   :=se2->e2_loja
          sez->ez_tipo   :=se2->e2_tipo
          sez->ez_naturez:=_vSez[_nVez][1]
          sez->ez_ccusto :=_vSez[_nVez][2]
          sez->ez_perc   :=round(_vSez[_nVez][3]/100,7)
          sez->ez_valor  :=_vSez[_nVez][4]
          sez->ez_recpag :="P"
          sez->ez_cspercr:=round(sev->ev_perc*sez->ez_perc,7)
          sez->ez_la     :=se2->e2_la

          sez->ez_empr   :=_vSez[_nVez][5]
          sez->(msunlock())
      next
      // Atualiza SE2
      do while se2->(!reclock(alias(),.f.))
      enddo
      se2->e2_multnat:="1"
      se2->(msunlock())
   endif
enddo
msgbox("Concluido, "+_cMens)

*-------------------------------------------------------------------------
static function _fImpLog()
*-------------------------------------------------------------------------

nLastKey  :=0
limite    :=220
wnrel     :=nomeprog:="ConvSz6"
cDesc1    :="Log de conversao SZ6 x SEV/SEZ"
cDesc2    :=" "
cDesc3    :=" "
cString   :="SZ6"
tamanho   := "G"
titulo    := cDesc1
aReturn   := { "Zebrado", 1,"Administracao", 1, 2, 1, "",0 }
_nLin     :=99
m_pag     :=1
Li        :=0
Cabec1:="Registro em SE2 / Descricao da ocorrencia"
Cabec2:=""
cursorarrow()
wnrel := SetPrint(cString,wnrel,,@Titulo,cDesc1,cDesc2,cDesc3,.t.,,.t.,tamanho)
if nLastkey==27
   set filter to
   return
endif
cursorwait()

RptStatus({|| RptDetail() })
cursorarrow()

*-------------------------------------------
Static function rptdetail
*-------------------------------------------
setdefault(aReturn,cString)
setregua(len(_vLog))
asort(_vLog)
_nLin:=99
_cUltimo:=_vLog[1]
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

return