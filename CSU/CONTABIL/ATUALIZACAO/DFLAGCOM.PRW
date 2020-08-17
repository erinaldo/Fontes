#include "rwmake.ch"

*---------------------------------------------------------------------------------------------------------------
User Function Dflagcom()
* Batch para conversao dos registros em SZ6 para SEV e SEZ
* Ricardo Luiz da Rocha - Dts Consulting - 01/11/2004 GNSJC
*---------------------------------------------------------------------------------------------------------------
private _cPerg:="DSFCOM"
Private _cMens := "Nenhum dado foi desmarcado. Verifique os parametros da rotina."
validperg(_cPerg)

@ 100,091 To 250,610 Dialog oBase Title OemToAnsi("Eliminacao do flag de contabilizacao - Compras")
@ 012,016 Say u__fAjTxt('Esta rotina elimina os flags de contabilizacao das tabelas do modulo citado,')
@ 022,016 Say u__fAjTxt('no periodo definido pelos parametros. O lote ao qual o movimento se refere e 008850')

@ 045,090 BmpButton Type 1 Action (_fProssegue(),close(oBase))
@ 045,130 BmpButton Type 5 Action (_fPar())
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

// Filtra SF1
_cFiltro:="dtos(f1_dtdigit)>='"+dtos(mv_par01)+"'.and.dtos(f1_dtdigit)<='"+dtos(mv_par02)+"'"
_cFiltro+=".AND. F1_FORNECE >= '"+MV_PAR07+"' .AND. F1_FORNECE <= '"+MV_PAR08+"'"
_cFiltro+=".AND. F1_DOC >= '"+MV_PAR03+"' .AND. F1_DOC <= '"+MV_PAR04+"'"
_cFiltro+=".AND. F1_SERIE >= '"+MV_PAR05+"' .AND. F1_SERIE <= '"+MV_PAR06+"'"
sf1->(IndRegua(alias(),criatrab(,.f.),indexkey(),,_cFiltro))

cursorwait()
processa({||_fDesfl()},"Eliminando flags de contabilizacao")
cursorarrow()
sf1->(retindex(alias()))

*-------------------------------------------------------------------------------------------------------------
static Function _fDesfl()
*-------------------------------------------------------------------------------------------------------------

sf1->(dbgotop())
_nDesSf1:=0
do while sf1->(!eof())
	if !empty(sf1->f1_dtlanc)
		do while sf1->(!reclock(alias(),.f.))
		enddo
		sf1->f1_dtlanc:= Ctod("  /  /  ")
		sf1->(msunlock())
		_nDesSf1++
	endif
	
	incproc(_cMens:="Desmarcados SF1 ("+alltrim(str(_nDesSF1))+")")
	sf1->(dbskip(1))
enddo

procregua(1)
incproc()

msgbox("Concluido, "+_cMens)

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
AADD(aRegs,{_cPerg,"01","Dt. Digitacao de      :","mv_ch1","D",08,0,0,"G","","mv_par01",""    ,"","",""      ,"","","","","","","","","","",""})
AADD(aRegs,{_cPerg,"02","Dt. Digitacao ate     :","mv_ch2","D",08,0,0,"G","","mv_par02",""    ,"","",""      ,"","","","","","","","","","",""})
AADD(aRegs,{_cPerg,"03","Documento de          :","mv_ch3","C",06,0,0,"G","","mv_par03",""    ,"","",""      ,"","","","","","","","","","",""})
AADD(aRegs,{_cPerg,"04","Documento ate         :","mv_ch4","C",06,0,0,"G","","mv_par04",""    ,"","",""      ,"","","","","","","","","","",""})
AADD(aRegs,{_cPerg,"05","Serie de              :","mv_ch5","C",03,0,0,"G","","mv_par05",""    ,"","",""      ,"","","","","","","","","","",""})
AADD(aRegs,{_cPerg,"06","Serie ate             :","mv_ch6","C",03,0,0,"G","","mv_par06",""    ,"","",""      ,"","","","","","","","","","",""})
AADD(aRegs,{_cPerg,"07","Fornecedor de         :","mv_ch7","C",06,0,0,"G","","mv_par07",""    ,"","",""      ,"","","","","","","","","","","SA2"})
AADD(aRegs,{_cPerg,"08","Fornecedor até        :","mv_ch8","C",06,0,0,"G","","mv_par08",""    ,"","",""      ,"","","","","","","","","","","SA2"})

u__fAtuSx1(padr(_cPerg,len(sx1->x1_grupo)),aRegs)
Return