#include "rwmake.ch"

*---------------------------------------------------------------------------------------------------------------
User Function DflagFat()
* Batch para conversao dos registros em SZ6 para SEV e SEZ
* Ricardo Luiz da Rocha - Dts Consulting - 01/11/2004 GNSJC
*---------------------------------------------------------------------------------------------------------------
private _cPerg:=PADR("DSFFAT",LEN(SX1->X1_GRUPO))
Private _cMens := "Nenhum dado foi desmarcado. Verifique os parametros da rotina."
validperg(_cPerg)

@ 100,091 To 250,610 Dialog oBase Title OemToAnsi("Eliminacao do flag de contabilizacao - Faturamento")
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
pergunte(_cPerg,.f.)

// Filtra SE5
_cFiltro:="dtos(e5_data)>='"+dtos(mv_par01)+"'.and.dtos(e5_data)<='"+dtos(mv_par02)+"'"
se5->(IndRegua(alias(),criatrab(,.f.),indexkey(),,_cFiltro))

// Filtra SE1
_cFiltro:="dtos(e1_emissao)>='"+dtos(mv_par01)+"'.and.dtos(e1_emissao)<='"+dtos(mv_par02)+"'"
_cFiltro+=".and. e1_cliente >= '"+mv_par07+"' .and. e1_cliente <= '"+mv_par08+"'"
_cFiltro+=".and. e1_num >= '"+mv_par03+"' .and. e1_num <= '"+mv_par04+"'"
_cFiltro+=".and. e1_prefixo >= '"+mv_par05+"' .and. e1_prefixo <= '"+mv_par06+"'"

se1->(IndRegua(alias(),criatrab(,.f.),indexkey(),,_cFiltro))

// Filtra SF2
_cFiltro:="dtos(F2_emissao)>='"+dtos(mv_par01)+"'.and.dtos(F2_emissao)<='"+dtos(mv_par02)+"'"
_cFiltro+=".and. F2_cliente >= '"+mv_par07+"' .and. F2_cliente <= '"+mv_par08+"'"
_cFiltro+=".and. F2_DOC >= '"+mv_par03+"' .and. F2_DOC <= '"+mv_par04+"'"
_cFiltro+=".and. F2_SERIE >= '"+mv_par05+"' .and. F2_SERIE <= '"+mv_par06+"'"

sf2->(IndRegua(alias(),criatrab(,.f.),indexkey(),,_cFiltro))

cursorwait()
processa({||_fDesfl()},"Eliminando flags de contabilizacao")
cursorarrow()
se5->(retindex(alias()))
se1->(retindex(alias()))
sf2->(retindex(alias()))

*-------------------------------------------------------------------------------------------------------------
static Function _fDesfl()
*-------------------------------------------------------------------------------------------------------------


se1->(dbgotop())
_nDesSe1:=_nDesSe5:=0
do while se1->(!eof())
	if !empty(se1->e1_la) .and. se1->e1_tipo <> "NDC"
		do while se1->(!reclock(alias(),.f.))
		enddo
		se1->e1_la:=""
		se1->(msunlock())
		_nDesSe1++
	endif
	
	// Desflega SE5
	//se5->(dbgotop())
	se5->(dbseek(xfilial()+se1->(e1_prefixo+e1_num+e1_parcela+e1_tipo+e1_cliente+e1_loja),.f.))
	do while se5->(!eof()) .AND. se5->e5_filial == xFilial() .and.;
		se1->(e1_prefixo+e1_num+e1_parcela+e1_tipo+e1_cliente+e1_loja)==;
		se5->(E5_PREFIXO+E5_NUMERO+E5_PARCELA+E5_TIPO+E5_CLIFOR+E5_LOJA)
		if !empty(se5->e5_la)
			do while se5->(!reclock(alias(),.f.))
			enddo
			se5->e5_la:="" .and. se5->e5_tipo <> "NDC"
			se5->(msunlock())
			_nDesSe5++
		endif
		
		se5->(dbskip(1))
	enddo
	
	incproc(_cMens:="Desmarcados  SE1 ("+alltrim(str(_nDesSe1))+")")
	se1->(dbskip(1))
enddo 

sf2->(dbgotop())
_nDesSf2:=0
do while sf2->(!eof())
	if !empty(sf2->f2_dtlanc)
		do while sf2->(!reclock(alias(),.f.))
		enddo
		sf2->f2_dtlanc:= Ctod("  /  /  ")
		sf2->(msunlock())
		_nDesSf2++
	endif
	
	incproc(_cMens:= "Desmarcados SF2 ("+alltrim(str(_nDesSF2))+"), SE1 ("+alltrim(str(_nDesSe1))+")")
	sf2->(dbskip(1))
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
AADD(aRegs,{_cPerg,"07","Cliente de            :","mv_ch7","C",06,0,0,"G","","mv_par07",""    ,"","",""      ,"","","","","","","","","","","SA1"})
AADD(aRegs,{_cPerg,"08","Cliente até           :","mv_ch8","C",06,0,0,"G","","mv_par08",""    ,"","",""      ,"","","","","","","","","","","SA1"})

u__fAtuSx1(padr(_cPerg,len(sx1->x1_grupo)),aRegs)
Return
