#include "rwmake.ch"

*---------------------------------------------------------------------------------------------------------------
User Function CT2ORIG()
* Localizacao e ajuste do campo ct2_origem inconsistente com base no centro de custo
* Ricardo Luiz da Rocha - Dts Consulting - 29/11/2004 GNSJC
*---------------------------------------------------------------------------------------------------------------
private _cPerg:="Ct2Ori",_vLog:={},_cMens
validperg(_cPerg)      

@ 100,091 To 250,610 Dialog oBase Title OemToAnsi("Inconsistencias em CT2_ORIG")
@ 012,016 Say u__fAjTxt('Esta rotina localiza e/ou atualiza a empresa de destino do lancamento')
@ 022,016 Say u__fAjTxt('a ser distribuido.')

@ 045,090 BmpButton Type 1 Action (_fProssegue(),close(oBase))
@ 045,130 BmpButton Type 5 Action (_fPar(),close(oBase))
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
_nExecuta:=mv_par03

cursorwait()       

processa({||_fct2orig()},"Analisando / atualizando dados")
cursorarrow()
if len(_vLog)>0
   _fImpLog()
endif   

ct2->(retindex(alias()))

*-------------------------------------------------------------------------------------------------------------
static Function _fCt2Orig()
*-------------------------------------------------------------------------------------------------------------
procregua(ct2->(lastrec()))
incproc()     
             
ct2->(dbsetorder(1))
_cFiltro:="dtos(ct2_data)>='"+dtos(_dDataIni)+"'.and.dtos(ct2_data)<='"+dtos(_dDataFim)+"'"
ct2->(IndRegua(alias(),criatrab(,.f.),indexkey(),,_cFiltro,"Selecionando Registros no arquivo "+alias()))

do while ct2->(!eof())
   _cCCusto:=ct2->ct2_ccc
   if empty(_cCCusto)
      _cCCusto:=ct2->ct2_ccd
   endif
   if empty(_cCCusto)
   else
      _cEmpresa:=posicione("CTT",1,xfilial("CTT")+_cCCusto,"ctt_empres")
   
      _nPosic:=at(chr(1),ct2->ct2_origem)
      if _nPosic>0      
         _cDestAtu:=substr(ct2->ct2_origem,_nPosic+1,2)
         if _cDestAtu==_cEmpresa
         else
            aadd(_vLog,"Lancamento: "+ct2->(CT2_FILIAL+DTOS(CT2_DATA)+CT2_LOTE+CT2_SBLOTE+CT2_DOC+CT2_LINHA)+" Valor: "+tran(ct2->ct2_valor,"@er 999,999,999.99")+" - Destino incorreto: "+_cDestAtu+" Correto: "+_cEmpresa)
            if _nExecuta==2
               ct2->(reclock(alias(),.f.))
               ct2->ct2_origem:=left(ct2->ct2_origem,_nPosic)+_cEmpresa
               ct2->(msunlock())
            endif
         endif      
      endif      
   endif   
   ct2->(dbskip(1))
   incproc()
enddo   
     
procregua(1)
incproc()

msgbox(_cMens:="Concluido, "+alltrim(str(len(_vLog)))+" inconsistencia(s) localizada(s)")

return
*-------------------------------------------------------------------------
static function _fImpLog()
*-------------------------------------------------------------------------

nLastKey  :=0
limite    :=132
wnrel     :=nomeprog:="Ct2Orig"
cDesc1    :="Inconsistencias com ct2_origem"
cDesc2    :=" "
cDesc3    :=" "
cString   :="CT2"
tamanho   := "M"
titulo    := cDesc1
aReturn   := { "Zebrado", 1,"Administracao", 1, 2, 1, "",0 }
_nLin     :=99
m_pag     :=1
Li        :=0
          
Cabec1:="Dados dos registros atualizados / a atualizar"
Cabec2:=""   
cursorarrow()
wnrel := SetPrint(cString,wnrel,,@Titulo,cDesc1,cDesc2,cDesc3,.t.,,.t.,tamanho)
if nLastkey==27
   set filter to
   return
endif
cursorwait()
asort(_vLog)
RptStatus({|| RptDetail() })
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

@ _nLin+2,0 PSAY _cMens

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
AADD(aRegs,{_cPerg,"01","Data de               :","mv_ch1","D",08,0,0,"G","","mv_par01",""    ,"","",""      ,"","","","","","","","","","",""})
AADD(aRegs,{_cPerg,"02","Data ate              :","mv_ch2","D",08,0,0,"G","","mv_par02",""    ,"","",""      ,"","","","","","","","","","",""})
AADD(aRegs,{_cPerg,"03","Executar              :","mv_ch2","N",01,0,0,"C","","mv_par03","Exibicao"    ,"","","Atualizacao"      ,"","","","","","","","","","",""})

u__fAtuSx1(padr(_cPerg,len(sx1->x1_grupo)),aRegs)
Return