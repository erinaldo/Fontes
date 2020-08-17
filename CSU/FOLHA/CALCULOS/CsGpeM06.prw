#include "rwmake.ch"
*----------------------------------------------------------------------------------------------------------------
User Function CsGpeM06()
* Atualizacao automatica do campo RA_RGUF (Uf onde o RG foi emitido)
* Ricardo Luiz da Rocha - Dts Consulting - 06/07/2004 GNSJC
*---------------------------------------------------------------------------------------------------------------
private _vLog:={}
if sm0->m0_codigo<>"05"
   msgbox("Esta rotina somente pode ser executada na empresa 05 (Santo Andre)")
   return
endif

@ 100,091 To 270,610 Dialog oBase Title OemToAnsi("Atualizacao do campo RA_RGUF")
@ 012,016 Say u__fAjTxt('Esta rotina realizara automaticamente a atualizacao do campo RA_UFEMR (Uf de emissao do RG)')
@ 022,016 Say u__fAjTxt('na empresa 05 (Cardsystem - Santo Andre), conforme as regras informadas por usuarios do RH.')
@ 032,016 Say u__fAjTxt('somente serao atualizados os registros onde o campo mencionado esteja em branco.')
@ 042,016 Say u__fAjTxt('Serao verificados registros de todas as filiais da empresa corrente.')

@ 065,130 BmpButton Type 1 Action _fProssegue()
@ 065,170 BmpButton Type 2 Action close(oBase)
Activate Dialog oBase centered
Return

*-------------------------------------------------------------------------------------------------------------
static Function _fProssegue
*-------------------------------------------------------------------------------------------------------------
cursorwait()
processa({||_fAtuSRA()},"Atualizando o cadastro de funcionarios")
cursorarrow()
if len(_vLog)==0
   msgbox("Nenhuma atualizacao e necessaria no momento")
else   
   _fImpLog()
endif

*-------------------------------------------------------------------------------------------------------------
static Function _fAtuSRA
*-------------------------------------------------------------------------------------------------------------
_vLog:={}                               
sra->(dbsetorder(1))
procregua(sra->(lastrec()))
sra->(dbgotop())
_nAlterados:=_nPercorridos:=0
do while sra->(!eof())
   if empty(sra->ra_rguf).or.sra->ra_rguf=="UF"
      _cUf:=""
      do case
         case sra->ra_filial$"01/02/03/04/13"
              if alltrim(sra->ra_cc)=="5043400.04.010901"
                 _cUf:="GO"
              else
                 _cUf:="SP"
              endif
         case sra->ra_filial=="10"
              _cUf:="RJ"
         case sra->ra_filial=="06"
              _cUf:="PE"
         case sra->ra_filial=="05"
              _cUf:="BA"
         case sra->ra_filial=="07"
              _cUf:="BH"
      endcase
      if !empty(_cUf).and.sra->(reclock(alias(),.f.))
         sra->ra_rguf=_cUf
         sra->(msunlock())
         sra->(aadd(_vLog,ra_filial+"     "+ra_mat+"    "+ra_nome+" "+ra_cc+" "+ra_rguf))
         _nAlterados++
      endif
   endif
   incproc(_cMens:="Percorridos: "+alltrim(str(++_nPercorridos))+"  Alterados: "+alltrim(str(_nAlterados)))
   sra->(dbskip(1))
enddo
msgbox("Concluido, "+_cMens)
*-------------------------------------------------------------------------
static function _fImpLog()
*-------------------------------------------------------------------------

nLastKey  :=0
limite    :=132
wnrel     :=nomeprog:="CsGpeM06"
cDesc1    :="Log de alteracao - Uf de emissao do RG"
cDesc2    :=" "
cDesc3    :=" "
cString   :="CT1"
tamanho   := "M"
titulo    := cDesc1
aReturn   := { "Zebrado", 1,"Administracao", 1, 2, 1, "",0 }
_nLin     :=99
m_pag     :=1
Li        :=0
Cabec1:="Filial Matricula Nome                                               Centro de custo      Uf de emissao do RG"
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
