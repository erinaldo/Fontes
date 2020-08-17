#include "rwmake.ch"
*-------------------------------------------------------------------------------------------------------------
user function CsGpeM07()
* Recalculo da folha em tabela temporaria e emissao do Resumo da folha
* Ricardo Luiz da Rocha 15/07/2004 GNSJC
*-------------------------------------------------------------------------------------------------------------
private _lProcessou:=.f.

@ 100,091 To 310,585 Dialog oBase Title OemToAnsi("Previa da folha de pagamentos")
@ 010,016 Say u__fAjTxt('Esta rotina realizara o recalculo da folha de pagamento em area de dados')
@ 020,016 Say u__fAjTxt('temporaria. Pode-se emitir o relatorio-resumo para avaliacao dos resultados.')
@ 030,016 Say u__fAjTxt('Nenhum dos dados atualizados aqui afetara a area oficial, porem os lancamentos')
@ 040,016 Say u__fAjTxt("mensais nela constantes serao utilizados como situacao inicial para o calculo.")
_lTemp:=.f.
@ 055,020 Button "1-Recalculo" size 50,15 action processa({||_fRecalculo()},"Recalculo da folha")
@ 055,090 button "2-Relatorio" size 50,15 Action GpeR040()
@ 055,160 BmpButton Type 2 Action close(oBase)
@ 080,020 CHECKBOX "Utilizando a area de dados temporaria" var _lTemp object _oCheck1
_oCheck1:lReadOnly:=.t.
Activate Dialog oBase centered

if _lProcessou
   src->(dbclosearea())
   chkfile("SRC")
   srz->(dbclosearea())
   chkfile("SRZ")
endif

Return

*-------------------------------------------------------------------------------------------------------------
static Function _fRecalculo
*-------------------------------------------------------------------------------------------------------------
procregua(_cUltimo:=src->(lastrec()))
_cUltimo:="/"+alltrim(str(_cUltimo))
_nRec:=1
if !_lProcessou
   _lTemp:=.t.
   cursorwait()
   _lProcessou:=.t.
   incproc("Isolamento dos lancamentos mensais em ambiente temporario")
   _vStruct:=src->(dbstruct())
   dbcreate(_cNomTmp:=criatrab(,.f.),_vStruct)
   dbusearea(.t.,,_cNomTmp,"SRCNew",.t.,.f.)
   src->(dbgotop())
   do while src->(!eof())
      incproc("Exportando: "+alltrim(str(_nRec++))+_cUltimo)
      srcnew->(reclock(alias(),.t.))
      for _nVezCpo:=1 to src->(fcount())
          _cCampo:=srcnew->(fieldname(_nVezCpo))
          _cComando:="srcnew->"+_cCampo+":=src->"+_cCampo
          _x:=&_cComando
      next
      srcnew->(msunlock())
      src->(dbskip(1))
   enddo
   src->(dbclosearea())
   srcnew->(dbclosearea())
   dbusearea(.t.,,_cNomTmp,"SRC",.t.,.f.)
   src->(_fIndices())
   
   _vStruct:=srz->(dbstruct())
   dbcreate(_cNomTmp:=criatrab(,.f.),_vStruct)
   srz->(dbclosearea())
   dbusearea(.t.,,_cNomTmp,"SRZ",.t.,.f.)
   srz->(_fIndices())   
   
endif

incproc("Acionando o recalculo da folha de pagamentos")
msgbox("A seguir sera acionada a rotina de recalculo da folha ja na area temporaria.Se os valores ja foram previamente calculados, esta etapa podera ser desconsiderada, a criterio do operador.")
gpem020() // Aciona o programa de recalculo da folha, agora, com o SRA modificado
return

*-------------------------------------------------------------
static function _fIndices()
*-------------------------------------------------------------
_cAlias:=alias()
six->(dbseek(_cAlias))
dbclearind()
_nIndice:=0                                                   
_vIndices:={}
do while six->(!eof().and.indice==_cAlias)
   IndRegua(alias(),aadd(_vIndices,_cNomInd:=CriaTrab(NIL,.F.)),six->(alltrim(chave)))
   six->(dbskip(1))
enddo
dbclearind()
for _nVez:=1 to len(_vIndices)
    dbsetindex(_vIndices[_nVez])
next    
return
