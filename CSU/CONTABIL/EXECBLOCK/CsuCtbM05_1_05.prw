#include "rwmake.ch"

*---------------------------------------------------------------------------------------------------------------
User Function CsCtbM05()
* Batch para ajuste da somatoria dos percentuais em Sz6
* Ricardo Luiz da Rocha - Dts Consulting - 16/07/2004 GNSJC
*---------------------------------------------------------------------------------------------------------------
private _vLog:={},_cPerg:=PADR("CtbM05",LEN(SX1->X1_GRUPO))

@ 100,091 To 250,610 Dialog oBase Title OemToAnsi("Ajuste dos percentuais em SZ6")
@ 012,016 Say u__fAjTxt('Esta rotina identifica e ajusta automaticamente incoerencias na somatoria dos percentuais')
@ 022,016 Say u__fAjTxt('da tabela SZ6 (RATEIOS C.CUSTO X TIT.PAGAR).')

@ 045,030 Button "SZ6 x SE2"  size 035,15 Action (_fProssegue(),close(oBase))
@ 045,070 Button "SE2 x SZ6"  size 035,15 Action (_fProsseg1(),close(oBase))
@ 045,130 BmpButton Type 5 Action (_fPar(),close(oBase))
@ 045,170 BmpButton Type 2 Action close(oBase)
Activate Dialog oBase centered
Return

*---------------------------------------------------------------------------------------------------------------
static function _fPar()
*---------------------------------------------------------------------------------------------------------------
validperg(_cPerg)
pergunte(_cPerg,.t.)
return

*-------------------------------------------------------------------------------------------------------------
static Function _fProsseg1
*-------------------------------------------------------------------------------------------------------------
_vLog:={}
pergunte(_cPerg,.f.)
_lAtualiza:=(mv_par01==2)
cursorwait()
processa({||_fVerSE2()},"Verificando SE2 x SZ6")
cursorarrow()
if len(_vLog)==0
   msgbox("Nenhuma atualizacao e necessaria no momento")
else
   _fImpLog()
endif
*-------------------------------------------------------------------------------------------------------------
static Function _fVerSe2
*-------------------------------------------------------------------------------------------------------------
se2->(dbsetorder(5)) // E2_FILIAL+DTOS(E2_EMISSAO)+E2_NUM+E2_TIPO+E2_FORNECE+E2_LOJA
procregua(se2->(lastrec()))
se2->(dbgotop())
sz6->(dbsetorder(1))
_nPercorridos:=_nErrados:=0
do while se2->(!eof())
   _nPercorridos++
   if se2->e2_ratcsu=="S".and.sz6->(!dbseek(xfilial()+se2->(e2_prefixo+e2_num+e2_parcela+e2_tipo+e2_fornece+e2_loja),.f.))
      se2->(aadd(_vLog,"Registro:"+str(recno(),7)+" Chave: "+e2_FILIAL+e2_PREFIXO+e2_NUM+e2_PARCELA+e2_TIPO+e2_FORNECE+e2_LOJA+" Emissao: "+dtoc(e2_emissao)+" Baixa: "+dtoc(e2_baixa))+" Nao possue correspondencia em SZ6")
      _nErrados++
      SE2->(RECLOCK(ALIAS(),.F.))
      SE2->E2_RATCSU:="N"
      SE2->(MSUNLOCK())
   endif
   incproc(_cMens:="Percorridos: "+alltrim(str(++_nPercorridos))+"  Incorretos: "+alltrim(str(_nErrados)))
   se2->(dbskip(1))      
enddo   

*-------------------------------------------------------------------------------------------------------------
static Function _fProssegue
*-------------------------------------------------------------------------------------------------------------
pergunte(_cPerg,.f.)
_lAtualiza:=(mv_par01==2)
cursorwait()
processa({||_fAtuSZ6()},if(_lAtualiza,"Atualizando","Verificando")+" SZ6")
cursorarrow()
if len(_vLog)==0
   msgbox("Nenhuma atualizacao e necessaria no momento")
else
   _fImpLog()
endif

*-------------------------------------------------------------------------------------------------------------
static Function _fAtuSZ6
*-------------------------------------------------------------------------------------------------------------
_vLog:={}
sz6->(dbsetorder(1)) // Z6_FILIAL+Z6_PREFIXO+Z6_NUMERO+Z6_PARCELA+Z6_TIPO+Z6_FORNECE+Z6_LOJA+Z6_NLINHA
procregua(sz6->(lastrec()))
sz6->(dbgotop())
_nAlterados:=_nPercorridos:=_nIdentificados:=0
_cChave:=sz6->(Z6_FILIAL+Z6_PREFIXO+Z6_NUMERO+Z6_PARCELA+Z6_TIPO+Z6_FORNECE+Z6_LOJA)
_nPerc:=sz6->z6_perc
se2->(dbsetorder(1))
do while sz6->(!eof())
   if se2->(dbseek(xfilial()+sz6->(Z6_PREFIXO+Z6_NUMERO+Z6_PARCELA+Z6_TIPO+Z6_FORNECE+Z6_LOJA),.f.).and.e2_baixa==ctod("25/10/2004"))
	   if sz6->(Z6_FILIAL+Z6_PREFIXO+Z6_NUMERO+Z6_PARCELA+Z6_TIPO+Z6_FORNECE+Z6_LOJA)<>_cChave
	      if _nPerc==100
	      else
	         _nDif:=100-_nPerc
	         sz6->(dbskip(-1))
	         _nOldPerc:=sz6->z6_perc
	         if abs(_nDif)<1
	            _nIdentificados++
	            if _lAtualiza
	               if sz6->(reclock(alias(),.f.))
	                  sz6->z6_perc+=_nDif
	                  sz6->(msunlock())
	                  sz6->(aadd(_vLog,"Registro:"+str(recno(),7)+"E2_emissao: "+dtoc(se2->e2_emissao)+" E2_baixa: "+dtoc(se2->e2_baixa)+" Chave: "+Z6_FILIAL+Z6_PREFIXO+Z6_NUMERO+Z6_PARCELA+Z6_TIPO+Z6_FORNECE+Z6_LOJA+Z6_NLINHA+" Somatoria perc: "+str(_nPerc,14,10)+" Vl original: "+str(_nOldPerc,14,10)+" Ajustado: "+str(_nOldPerc+_nDif,14,10)))
	                  _nAlterados++
	               endif
	            else
	               sz6->(aadd(_vLog,"Registro:"+"E2_emissao: "+dtoc(se2->e2_emissao)+" E2_baixa: "+dtoc(se2->e2_baixa)+str(recno(),7)+" Chave: "+Z6_FILIAL+Z6_PREFIXO+Z6_NUMERO+Z6_PARCELA+Z6_TIPO+Z6_FORNECE+Z6_LOJA+Z6_NLINHA+" Somatoria perc: "+str(_nPerc,14,10)+" Vl original: "+str(_nOldPerc,14,10)+" Ajustar:  "+str(_nOldPerc+_nDif,14,10)))
	            endif   
	         else
	            sz6->(aadd(_vLog,"Registro:"+str(recno(),7)+"E2_emissao: "+dtoc(se2->e2_emissao)+" E2_baixa: "+dtoc(se2->e2_baixa)+" Chave: "+Z6_FILIAL+Z6_PREFIXO+Z6_NUMERO+Z6_PARCELA+Z6_TIPO+Z6_FORNECE+Z6_LOJA+Z6_NLINHA+" Somatoria perc: "+str(_nPerc,14,10)+" Vl original: "+str(_nOldPerc,14,10)+" Nao ajustado"))
	         endif
	         sz6->(dbskip(1))
	      endif
	      _cChave:=sz6->(Z6_FILIAL+Z6_PREFIXO+Z6_NUMERO+Z6_PARCELA+Z6_TIPO+Z6_FORNECE+Z6_LOJA)
	      _nPerc:=sz6->z6_perc
	   else
	      _nPerc+=sz6->z6_perc
	   endif   
   endif
   incproc(_cMens:="Percorridos: "+alltrim(str(++_nPercorridos))+"  Alterados: "+alltrim(str(_nAlterados))+" Identif: "+alltrim(str(_nIdentificados)))
   sz6->(dbskip(1))
enddo
msgbox("Concluido, "+_cMens)

*-------------------------------------------------------------------------
static function _fImpLog()
*-------------------------------------------------------------------------

nLastKey  :=0
limite    :=132
wnrel     :=nomeprog:="CsCtbM05"
cDesc1    :="Log de alteracao - Percentuais em SZ6"
cDesc2    :=" "
cDesc3    :=" "
cString   :="SZ6"
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

*--------------------------------------------------------------------------------------------------------------------
Static Function VALIDPERG(_cPerg)
*--------------------------------------------------------------------------------------------------------------------
_cPerg:=PADR(_cPerg,len(sx1->x1_grupo))
aRegs := {}
             *   1    2            3                4     5   6  7 8  9  10   11        12    13 14    15    16 17 18 19 20 21 22 23 24 25  26
             *+----------------------------------------------------------------------------------------------------------------------------------------+
             *¦G    ¦ O  ¦ PERGUNT                     ¦V       ¦T  ¦T ¦D¦P¦ G ¦V ¦V         ¦ D    ¦C ¦V ¦D       ¦C ¦V ¦D ¦C ¦V ¦D ¦C ¦V ¦D ¦C ¦F    ¦
             *¦ R   ¦ R  ¦                             ¦ A      ¦ I ¦A ¦E¦R¦ S ¦A ¦ A        ¦  E   ¦N ¦A ¦ E      ¦N ¦A ¦E ¦N ¦A ¦E ¦N ¦A ¦E ¦N ¦3    ¦
             *¦  U  ¦ D  ¦                             ¦  R     ¦  P¦MA¦C¦E¦ C ¦ L¦  R       ¦   F  ¦ T¦ R¦  F     ¦ T¦R ¦F ¦ T¦R ¦F ¦ T¦R ¦F ¦ T¦     ¦
             *¦   P ¦ E  ¦                             ¦   I    ¦  O¦NH¦ ¦S¦   ¦ I¦   0      ¦    0 ¦ 0¦ 0¦   0    ¦ 0¦0 ¦0 ¦ 0¦0 ¦0 ¦ 0¦0 ¦0 ¦ 0¦     ¦
             *¦    O¦ M  ¦                             ¦    AVL ¦   ¦ O¦ ¦E¦   ¦ D¦    1     ¦    1 ¦ 1¦ 2¦    2   ¦ 2¦3 ¦3 ¦ 3¦4 ¦4 ¦ 4¦5 ¦5 ¦ 5¦     ¦
   AADD(aRegs,{_cPerg,"01","Atualizar ou verificar   :","mv_ch1","N",01,0,0,"C","","mv_par01","Verificar","","","Atualizar"      ,"","","","","","","","","","",""})

u__fAtuSx1(padr(_cPerg,len(sx1->x1_grupo)),aRegs)

Return
