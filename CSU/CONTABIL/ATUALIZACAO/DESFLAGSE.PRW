#include "rwmake.ch"

*---------------------------------------------------------------------------------------------------------------
User Function DesflagSe()
* Batch para conversao dos registros em SZ6 para SEV e SEZ
* Ricardo Luiz da Rocha - Dts Consulting - 01/11/2004 GNSJC
*---------------------------------------------------------------------------------------------------------------
private _cPerg:=PADR("DESFL",LEN(SX1->X1_GRUPO))
Private _cMens := ""
validperg(_cPerg)

@ 100,091 To 250,610 Dialog oBase Title OemToAnsi("Eliminacao do flag de contabilizacao - Compras, Faturamento, Financeiro")
@ 012,016 Say u__fAjTxt('Esta rotina elimina os flags de contabilizacao das tabelas dos modulos citados,')
@ 022,016 Say u__fAjTxt('no periodo definido pelos parametros.')	// O lote ao qual o movimento se refere e 008850')

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

cursorwait()
processa({||_fDesfl()},"Eliminando flags de contabilizacao")
cursorarrow()
se2->(retindex(alias()))
se5->(retindex(alias()))
sf1->(retindex(alias()))
se1->(retindex(alias()))

*-------------------------------------------------------------------------------------------------------------
static Function _fDesfl()
*-------------------------------------------------------------------------------------------------------------
sev->(dbsetorder(1)) // EV_FILIAL+EV_PREFIXO+EV_NUM+EV_PARCELA+EV_TIPO+EV_CLIFOR+EV_LOJA+EV_NATUREZ
sez->(dbsetorder(1)) // EZ_FILIAL+EZ_PREFIXO+EZ_NUM+EZ_PARCELA+EZ_TIPO+EZ_CLIFOR+EZ_LOJA+EZ_NATUREZ+EZ_CCUSTO
se5->(dbsetorder(7)) // EZ_FILIAL+EZ_PREFIXO+EZ_NUM+EZ_PARCELA+EZ_TIPO+EZ_CLIFOR+EZ_LOJA+EZ_NATUREZ+EZ_CCUSTO

// Desflega SE2, SEV, SEZ

procregua(se2->(lastrec()))

If MV_PAR09 == 2 // Financeiro
	
	//Filtra SE2
	_cFiltro:="DtoS(E2_EMISSAO)>='"+dtos(mv_par01)+"'.And.DtoS(E2_EMISSAO)<='"+dtos(mv_par02)+"'"
	se2->(IndRegua(alias(),criatrab(,.f.),indexkey(),,_cFiltro))
	
	se2->(dbgotop())
	_nDesSe2:=_nDesSev:=_nDesSez:=_nDesSe5:=0
	do while se2->(!eof())
		if !empty(se2->e2_la)
			do while se2->(!reclock(alias(),.f.))
			enddo
			se2->e2_la:=""
			se2->(msunlock())
			_nDesSe2++
		endif
		sev->(dbseek(xfilial()+se2->(e2_prefixo+e2_num+e2_parcela+e2_tipo+e2_fornece+e2_loja),.f.))
		do while sev->(ev_filial==xfilial()).and.;
			se2->(e2_prefixo+e2_num+e2_parcela+e2_tipo+e2_fornece+e2_loja)==;
			sev->(EV_PREFIXO+EV_NUM+EV_PARCELA+EV_TIPO+EV_CLIFOR+EV_LOJA)
			if sev->ev_recpag=="P".and.!empty(sev->ev_la)
				do while sev->(!reclock(alias(),.f.))
				enddo
				sev->ev_la:=""
				sev->(msunlock())
				_nDesSev++
			endif
			sev->(dbskip(1))
		enddo
		sez->(dbseek(xfilial()+se2->(e2_prefixo+e2_num+e2_parcela+e2_tipo+e2_fornece+e2_loja),.f.))
		do while sez->(ez_filial==xfilial()).and.;
			se2->(e2_prefixo+e2_num+e2_parcela+e2_tipo+e2_fornece+e2_loja)==;
			sez->(Ez_PREFIXO+Ez_NUM+Ez_PARCELA+Ez_TIPO+Ez_CLIFOR+Ez_LOJA)
			if sez->ez_recpag=="P".and.!empty(sez->ez_la)
				do while sez->(!reclock(alias(),.f.))
				enddo
				sez->ez_la:=""
				sez->(msunlock())
				_nDesSez++
			endif
			sez->(dbskip(1))
		enddo
		
		incproc(_cMens:="Desmarcados SE2 ("+alltrim(str(_nDesSe2))+") SEV ("+alltrim(str(_nDesSev))+") SEZ ("+alltrim(str(_nDesSez))+") SE5 ("+alltrim(str(_nDesSe5))+")")
		se2->(dbskip(1))
		
	enddo
	
	//Filtra SE2
	_cFiltro:="DtoS(E2_BAIXA)>='"+dtos(mv_par01)+"'.And.DtoS(E2_BAIXA)<='"+dtos(mv_par02)+"'"
	se2->(IndRegua(alias(),criatrab(,.f.),indexkey(),,_cFiltro))
	
	// Filtra SE5
	_cFiltro:="DtoS(E5_DATA)>='"+dtos(mv_par01)+"'.And.DtoS(E5_DATA)<='"+dtos(mv_par02)+"'"
	se5->(IndRegua(alias(),criatrab(,.f.),indexkey(),,_cFiltro))                                                   
	
	dbSelectArea("SE2")
	SE2->(dbGoTop())
	While SE2->(!Eof())
		
		// Desflega SE5
		//se5->(dbgotop())
		se5->(dbseek(xfilial()+se2->(e2_prefixo+e2_num+e2_parcela+e2_tipo+e2_fornece+e2_loja),.f.))
		do while se5->(!eof()) .AND. se5->e5_filial == xFilial() .and.;
			se2->(e2_prefixo+e2_num+e2_parcela+e2_tipo+e2_fornece+e2_loja)==;
			se5->(E5_PREFIXO+E5_NUMERO+E5_PARCELA+E5_TIPO+E5_CLIFOR+E5_LOJA)
			if !empty(se5->e5_la)
				do while se5->(!reclock(alias(),.f.))
				enddo
				se5->e5_la:=""
				se5->(msunlock())
				_nDesSe5++
			endif
			
			se5->(dbskip(1))
		enddo
		
		SE2->(dbSkip())
		
	end
	// Desflega SF1, SD1
	
ElseIf MV_PAR09 == 1     // Compras
	
	// Filtra SF1
	_cFiltro:="dtos(f1_dtdigit)>='"+dtos(mv_par01)+"'.and.dtos(f1_dtdigit)<='"+dtos(mv_par02)+"'"
	_cFiltro+=".AND. F1_FORNECE >= '"+MV_PAR07+"' .AND. F1_FORNECE <= '"+MV_PAR08+"'"
	_cFiltro+=".AND. F1_DOC >= '"+MV_PAR03+"' .AND. F1_DOC <= '"+MV_PAR04+"'"
	_cFiltro+=".AND. F1_SERIE >= '"+MV_PAR05+"' .AND. F1_SERIE <= '"+MV_PAR06+"'"
	sf1->(IndRegua(alias(),criatrab(,.f.),indexkey(),,_cFiltro))
	
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
	
	
	// Desflega SE1
	
ElseIf MV_PAR09 == 3   // Faturamento
	
	DBSELECTAREA("SE1")
	// Filtra SE1
	_cFiltro:="dtos(E1_EMISSAO)>='"+dtos(mv_par01)+"'.and.dtos(E1_EMISSAO)<='"+dtos(mv_par02)+"'"
	se1->(IndRegua(alias(),criatrab(,.f.),indexkey(),,_cFiltro))
	

	se1->(dbgotop())
	_nDesSe1:=_nDesSe5:=0
	do while se1->(!eof())
		if !empty(se1->e1_la)
			do while se1->(!reclock(alias(),.f.))
			enddo
			se1->e1_la:=""
			se1->(msunlock())
			_nDesSe1++
		endif
		
		incproc(_cMens:="Desmarcados  SE1 ("+alltrim(str(_nDesSe1))+")")
		se1->(dbskip(1))
		
	enddo
	
	//Filtra SE2
	_cFiltro:="DtoS(E1_BAIXA)>='"+dtos(mv_par01)+"'.And.DtoS(E1_BAIXA)<='"+dtos(mv_par02)+"'"
	se1->(IndRegua(alias(),criatrab(,.f.),indexkey(),,_cFiltro))
	
	// Filtra SE5
	_cFiltro:="DtoS(E5_DATA)>='"+dtos(mv_par01)+"'.And.DtoS(E5_DATA)<='"+dtos(mv_par02)+"'"
	se5->(IndRegua(alias(),criatrab(,.f.),indexkey(),,_cFiltro))
	
	dbSelectArea("SE1")
	SE1->(dbGoTop())
	
	While SE1->(!Eof())
		
		// Desflega SE5
		//se5->(dbgotop())
		se5->(dbseek(xfilial()+se1->(e1_prefixo+e1_num+e1_parcela+e1_tipo+e1_cliente+e1_loja),.f.))
		do while se5->(!eof()) .AND. se5->e5_filial == xFilial() .and.;
			se1->(e1_prefixo+e1_num+e1_parcela+e1_tipo+e1_cliente+e1_loja)==;
			se5->(E5_PREFIXO+E5_NUMERO+E5_PARCELA+E5_TIPO+E5_CLIFOR+E5_LOJA)
			if !empty(se5->e5_la)
				do while se5->(!reclock(alias(),.f.))
				enddo
				se5->e5_la:=""
				se5->(msunlock())
				_nDesSe5++
			endif
			
			se5->(dbskip(1))
		enddo
		
		SE1->(dbSkip())
		
	end
	
Endif

dbSelectArea("SE1")
SET FILTER TO
dbSelectArea("SE2")
SET FILTER TO
dbSelectArea("SE5")
SET FILTER TO

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
AADD(aRegs,{_cPerg,"08","Fornecedor ate        :","mv_ch8","C",06,0,0,"G","","mv_par08",""    ,"","",""      ,"","","","","","","","","","","SA2"})
AADD(aRegs,{_cPerg,"09","Modulo:               :","mv_ch9","N",01,0,0,"C","","mv_par09","Compras (NFE)","","","Ctas.a Pagar","","","Ctas.a Receber","","","","","","","",""})

u__fAtuSx1(padr(_cPerg,len(sx1->x1_grupo)),aRegs)
Return
