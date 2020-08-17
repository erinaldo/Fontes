#INCLUDE "rwmake.ch"
#INCLUDE "common.ch"
#INCLUDE "topconn.ch"

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma³CSUCAPA_1.05ºAutor  ³Adriana e Danielle  º Data ³  10/03/02   º±±
±±ÉÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma³CSUCAPA_1.06ºAutor  ³Adriana             º Data ³  30/10/02   º±±
±±ÌÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºPrograma³CSUCAPA_1.07ºAutor  ³MTdO                º Data ³  30/12/03   º±±
±±ÉÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma³CSUCAPA_1.07aºAutor ³MTdO                º Data ³  30/12/03   º±±
±±ÌÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºPrograma³CSUCAPA_1.07bºAutor ³MTdO-revis.  josmar º Data ³  17/03/04   º±±
±±ÌÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºPrograma³CSUCAPA_1.07cºAutor ³MTdO-revis.  josmar º Data ³  17/05/04   º±±
±±ÌÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.   ³Impressão da Autorizacao de Pagamento                         º±±
±±º        ³                                                              º±±
±±ÌÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso     ³MARKETSYSTEM                                                  º±±
±±ÈÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/

User Function CSUCAPA()

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Declaracao de Variaveis                                             ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

Private empresa:=""
Private cPerg  := PADR("CAPA",LEN(SX1->X1_GRUPO))
Private Res,Conta,NatDesc,Desc,X,Nome_for,Cod_for,Conta_Reduz_for,ContaReduz,Descr_for,Cgc_for:= ""
Private	Tit_Emissao,Tit_Vencim,Tit_RatCSU,Tit_VencRea,Tit_Parc,tx_vencrea,Tit_VlBruto,Tit_Acresc,Tit_Decresc,Tit_VlIR,Tit_VlInss,Tit_Vlmp135:="" //ACRESCENTADO VARIAVEL (TIT_VLMP135) P/ CONTEMPLAR MP135 - DEZ/2003
Private Tit_VlIss,Tit_VlLiq,Tit_Hist,Tit_tipo,Tit_NumDoc,Tit_Naturez,Tit_Custo,Empresa,Tit_contareduz,Tit_Descr:=""
Private Courier, cCode
Private Linha,Soma,Vlrateio,Perc,Valrat :=0
Private Somabruto:=0
Private SomaIRRF:=0
Private SomaINSS:=0
Private SomaISS:=0
Private Somaliq:=0,vlbrutopai:=0
Private Tit_Conta_Debito:=""
Private Tit_Descricao:=""
Private Aglutina:={}
Private _vRateio:={}
_vPercs:={}
Private Pag:=1
Private TIT_MULTA   := 0
Private TIT_DESCONT := 0

_cCodArea:=""

_vSe2Keys:={}

nHeight:=15
lBold:= .F.
lUnderLine:= .F.
lPixel:= .T.
lPrint:=.F.

Private Courier   := TFont():New( "Courier New",,nHeight,,lBold,,,,,lUnderLine )
Private Courier08F:= TFont():New( "Courier New",,08,,.f.,,,,,.f. )
Private Courier08T:= TFont():New( "Courier New",,08,,.t.,,,,,.f. )
Private Courier10F:= TFont():New( "Courier New",,10,,.f.,,,,,.f. )
Private Courier10T:= TFont():New( "Courier New",,10,,.t.,,,,,.f. )
Private Courier12T:= TFont():New( "Courier New",,12,,.t.,,,,,.f. )
Private Courier12F:= TFont():New( "Courier New",,12,,.f.,,,,,.f. )
Private Courier14 := TFont():New( "Courier New",,14,,.t.,,,,,.f. )
Private Courier28 := TFont():New( "Courier New",,28,,.t.,,,,,.f. )

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Monta a interface padrao com o usuario...                           ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

validperg()

If !Pergunte(cPerg,.T.)
	
	Return
	
Endif

RptStatus({|| RunReport()})
if len(_vSe2Keys)>0
	processa({||_fAtuImpr()},"Aguarde, marcando titulos impressos")
endif
Return

// **********************************
// *           PARAMETROS           *
// **********************************
// * mv_par01  * Emissao de      ?  *
// * mv_par02  * Emissao ate     ?  *
// * mv_par03  * Tipo de         ?  *
// * mv_par04  * Tipo ate        ?  *
// * mv_par05  * Numero de       ?  *
// * mv_par06  * Mumero ate      ?  *
// * mv_par07  * Fornecedor de   ?  *
// * mv_par08  * Fornecedor ate  ?  *
// * mv_par09  * Loja de         ?  *
// * mv_par10  * Loja ate        ?  *
// **********************************

//********************************************************************

Static Function RunReport()

ProcRegua(3)
_lComRat:=.f.

#IFDEF TOP
	_cQuery := " SELECT * FROM "+RETSQLNAME("SE2")+" WHERE D_E_L_E_T_ <> '*' AND "
	_cQuery += " E2_FILIAL = '"+xFilial("SE2")+"' AND "
	_cQuery += " E2_EMISSAO BETWEEN '"+DTOS(MV_PAR01)+"' AND '"+DTOS(MV_PAR02)+"' AND "
	_cQuery += " E2_EMIS1 BETWEEN '"+DTOS(MV_PAR12)+"' AND '"+DTOS(MV_PAR13)+"' AND "   // aaj011204 os 3571/04
	_cQuery += " E2_TIPO BETWEEN '"+mv_par03+"' AND '"+mv_par04+"' AND "
	_cQuery += " E2_NUM BETWEEN '"+mv_par05+"' AND '"+mv_par06+"' AND "
	_cQuery += " E2_FORNECE BETWEEN '"+mv_par07+"' AND '"+mv_par08+"' AND "
	_cQuery += " E2_LOJA BETWEEN '"+mv_par09+"' AND '"+mv_par10+"' "
	//_cQuery += " AND E2_MULTNAT = '1'" // aaj021204 tirar isso daqui!!
	if mv_par11==1
		_cQuery+=" AND E2_CSIMPCA = ' '"
	endif
	
	_cQuery += " ORDER BY E2_FILIAL,E2_EMISSAO,E2_NUM,E2_TIPO,E2_FORNECE,E2_LOJA "
	
	IF Select("TRSE2")>0
		dbselectarea("TRSE2")
		dbclosearea()
	Endif
	
	IncProc("Obtendo Dados ")
	TCQUERY _cQuery NEW ALIAS "TRSE2"
#ELSE
	_cFiltro:="E2_FILIAL='"+xFilial("SE2")+"'"
	_cFiltro+=".and.dtos(e2_emissao)>='"+DTOS(MV_PAR01)+"'.and.dtos(e2_emissao)<='"+DTOS(MV_PAR02)+"'"
	_cFiltro+=".and.dtos(e2_emis1)>='"+DTOS(MV_PAR12)+"'.and.dtos(e2_emis1)<='"+DTOS(MV_PAR13)+"'"
	_cFiltro+=".and.e2_tipo>='"+mv_par03+"'.and.e2_tipo<='"+mv_par04+"'"
	_cFiltro+=".and.E2_NUM>='"+mv_par05+"'.and.e2_num<='"+mv_par06+"'"
	_cFiltro+=".and.E2_FORNECE>='"+mv_par07+"'.and.e2_FORNECE<='"+mv_par08+"'"
	_cFiltro+=".and.E2_LOJA>='"+mv_par09+"'.and.e2_LOJA<='"+mv_par10+"'"
	if mv_par11==1
		_cFiltro+=".and.E2_CSIMPCA=' '"
	endif
	_cOrdem:="E2_FILIAL+dtos(E2_EMISSAO)+E2_NUM+E2_TIPO+E2_FORNECE+E2_LOJA"
	se2->(indregua(alias(),criatrab(,.f.),_cOrdem,,_cFiltro))
	_vStruct:=se2->(dbstruct())
	_vSTructOrig:=aClone(_vStruct)
	for _nVez:=1 to len(_vStruct)
		if _vStruct[_nVez][2]=="D"
			_vStruct[_nVez][2]:="C"
		endif
	next
	se2->(dbgotop())
	_cArq:=criatrab(,.f.)
	dbcreate(_cArq,_vStruct)
	dbUseArea(.T.,,_cArq,"TRSE2",.T.)
	do while se2->(!eof())
		trse2->(reclock(alias(),.t.))
		for _nVez:=1 to len(_vStruct)
			_cCampo:=_vStruct[_nVez][1]
			if _vStructOrig[_nVez][2]=="D"
				_cComando:="trse2->"+_cCampo+":=dtos(se2->"+_cCampo+")"
			else
				_cComando:="trse2->"+_cCampo+":=se2->"+_cCampo
			endif
			_x:=&_cComando
		next
		trse2->(msunlock())
		se2->(dbskip(1))
	enddo
	se2->(retindex(alias()))
#ENDIF

dbSelectArea("TRSE2")
//dbsetorder(1) // aaj011204 os 3616/04
DBGOTOP()

SetRegua(RecCount())
_vSe2Keys:={}

WHILE !EOF()
	
	// Ricardo - 05/08/2004
	_cChave:=trse2->(e2_filial+e2_prefixo+e2_num+e2_parcela+e2_tipo+e2_fornece+e2_loja)
	if ascan(_vSe2Keys,_cChave)==0
		aadd(_vSe2Keys,_cChave)
	endif
	
	IncRegua("Imprimindo os registros...")
	
	_aSM := GetArea()
	
	//Dados do fornecedor
	dbselectarea ("SA2")
	dbsetorder (1)
	dbseek (xFilial() + TRSE2->E2_FORNECE + TRSE2->E2_LOJA)
	
	//Dados do Fornecedor
	Nome_for	   := SA2->A2_NOME
	Cod_for		   := SA2->A2_COD
	Conta_Reduz_for:= ContaReduz(SA2->A2_CONTA)
	Descr_for	   := Desc(Conta_Reduz_For)
	Cgc_for 	   := SA2->A2_CGC
	
	//Dados do Titulo
	Tit_Digitac     := TRSE2->E2_EMIS1 // aaj011204 OS 3572/04
	Tit_Digitac     := SUBS(Tit_Digitac,7,2)+"/"+SUBS(Tit_Digitac,5,2)+"/"+SUBS(Tit_Digitac,1,4) // aaj011204 OS 3572/04
	Tit_Emissao    	:= TRSE2->E2_EMISSAO
	Tit_Emissao     := SUBS(Tit_Emissao,7,2)+"/"+SUBS(Tit_Emissao,5,2)+"/"+SUBS(Tit_Emissao,1,4)
	Tit_Vencim     	:= TRSE2->E2_VENCTO
	Tit_Vencim      := SUBS(Tit_Vencim,7,2)+"/"+SUBS(Tit_Vencim,5,2)+"/"+SUBS(Tit_Vencim,1,4)
	Tit_RatCSU	   	:= TRSE2->E2_MULTNAT
	Tit_VencRea    	:= TRSE2->E2_VENCREA
	Tit_VencRea     := SUBS(Tit_VencRea,7,2)+"/"+SUBS(Tit_VencRea,5,2)+"/"+SUBS(Tit_VencRea,1,4)
	Tit_Parc       	:= TRSE2->E2_PARCELA
	Tit_Acresc      := TRSE2->E2_ACRESC
	Tit_Decresc     := TRSE2->E2_DECRESC
	TIT_MULTA       := Iif(cNumEmp=="0601",0, TRSE2->E2_CSMULTA)
	TIT_DESCONT     := TRSE2->E2_DESCCSU
	
	If cNumEmp == "1001" // aaj221104 os 3175/04
		Tit_Vlmp135 := 0
		Tit_VlBruto	:= (TRSE2->E2_VALOR+TRSE2->E2_IRRF+TRSE2->E2_INSS+TRSE2->E2_ISS)
	Else
		Tit_Vlmp135	:= (TRSE2->E2_VRETPIS+TRSE2->E2_VRETCSL+TRSE2->E2_VRETCOF)
		Tit_VlBruto	:= (TRSE2->E2_VALOR+TRSE2->E2_IRRF+TRSE2->E2_INSS+TRSE2->E2_ISS+Tit_Vlmp135)
	Endif
	Tit_VlIR       	:= TRSE2->E2_IRRF
	Tit_VlInss     	:= TRSE2->E2_INSS
	Tit_VlIss   	:= TRSE2->E2_ISS
	Tit_VlLiq     	:= TRSE2->E2_VALOR+TRSE2->E2_ACRESC-TRSE2->E2_DECRESC-TRSE2->E2_DESCCSU+Iif(cNumEmp=="0601",0, TRSE2->E2_CSMULTA)
	Tit_Hist   	  	:= TRSE2->E2_HIST
	Tit_tipo      	:= TRSE2->E2_TIPO
	Tit_NumDoc    	:= TRSE2->E2_NUM
	
	if cNumEmp<>"1001"
		_cCodArea:=trse2->e2_codarea
	endif
	
	if !empty(TrSe2->e2_csukey)
		_vAmbSe2:=se2->(getarea())
		Se2->(dbseek(TRSE2->E2_CSUKEY))
		Tit_Conta_Debito:= NatDesc(SE2->E2_NATUREZ,SE2->E2_CCUSTO)
		Se2->(restarea(_vAmbSe2))
	else
		Tit_Conta_Debito:= NatDesc(TRSE2->E2_NATUREZ,TRSE2->E2_CCUSTO)
	endif
	
	//QUANDO MULTIPLANATUREZA FOR 2(NAO)
	IF TRSE2->(E2_MULTNAT=="2".or.(empty(e2_multnat).and.alltrim(e2_fornece)=="INPS"))
		
		
		Tit_Naturez		:= TRSE2->E2_NATUREZ
		Tit_Custo 		:= TRSE2->E2_CCUSTO
		_cCodArea:=Empresa			:= posicione("CTT",1,xfilial("CTT")+TRSE2->e2_ccusto,"ctt_empres")
		Tit_Descricao   := Desc(Tit_Conta_Debito)
		
		tit_vencrea:=trse2->e2_vencrea
		Tit_VencRea     := SUBS(Tit_VencRea,7,2)+"/"+SUBS(Tit_VencRea,5,2)+"/"+SUBS(Tit_VencRea,1,4)
		
		Tit_parc   :=trse2->e2_parcela
		Tit_Tipo   :=trse2->e2_tipo
		tx_prefixo :=trse2->e2_prefixo
		
		// Ricardo 18/02/05 - Tratamento para os rateios calculados para titulos de imposto
		// Se for um titulo-filho, calcula o rateio a partir do pai
		//_vRateio:={}
		_vPercs:={}
		if !empty(trse2->e2_csukey)
			_nLen:=len(se2->(e2_filial+e2_prefixo+e2_num+e2_parcela+e2_tipo+e2_fornece+e2_loja))
			_cKeyTit:=padr(left(trse2->e2_csukey,_nLen),_nLen)
			
			_vAmbSe2:=se2->(getarea())
			_vAmbSev:=sev->(getarea())
			_vAmbSez:=sez->(getarea())
			
			sev->(dbsetorder(1)) // EV_FILIAL+EV_PREFIXO+EV_NUM+EV_PARCELA+EV_TIPO+EV_CLIFOR+EV_LOJA+EV_NATUREZ
			sez->(dbsetorder(1)) // EZ_FILIAL+EZ_PREFIXO+EZ_NUM+EZ_PARCELA+EZ_TIPO+EZ_CLIFOR+EZ_LOJA+EZ_NATUREZ+EZ_CCUSTO
			sez->(dbseek(_cKeyTit,.f.))
			_vRateio1:={}
			do while sez->(!eof().and.EZ_FILIAL+EZ_PREFIXO+EZ_NUM+EZ_PARCELA+EZ_TIPO+EZ_CLIFOR+EZ_LOJA==_cKeyTit)
				if sez->ez_recpag=="P"
					// posicionar SEV
					sev->(dbseek(sez->(ez_filial+EZ_PREFIXO+EZ_NUM+EZ_PARCELA+EZ_TIPO+EZ_CLIFOR+EZ_LOJA+EZ_NATUREZ),.f.))
					
					aadd(_vRateio1,{sez->ez_naturez,;                                    //1
					trse2->e2_num,;                                          //2
					sez->ez_ccusto,;                                       //3
					Tit_contareduz:=sez->(natdesc(ez_naturez,ez_ccusto)),; //4
					Tit_Descr:=Desc(Tit_contareduz),;                      //5
					VLRATEIO:=0,;                      //6
					tit_vencrea,;                    //7
					Tit_parc,;                      //8
					Tit_Tipo,;                      //9
					tx_prefixo,;                    //10 EMPRESA
					sez->ez_empr,;                  //11
					trse2->(e2_fornece)})      //12
					
					aadd(_vPercs,sez->ez_cspercr)
					
				endif
				sez->(dbskip(1))
			enddo
			
			// Ajuste de eventuais diferencas de arredondamento
			_nDif:=tit_vlbruto
			for _nVez:=1 to len(_vRateio1)
				_nValLinha:=round(tit_vlbruto*_vPercs[_nVez],2)
				if _nVez==len(_vRateio1)
					_nValLinha:=_nDif
				else
					_nDif-=_nValLinha
				endif
				_vRateio1[_nVez][6]:=_nValLinha
			next
			
			for _nVez:=1 to len(_vRateio1)
				aadd(_vRateio,aClone(_vRateio1[_nVez]))
				_lComRat:=.t.
			next
			
			se2->(restarea(_vAmbSe2))
			sev->(restarea(_vAmbSev))
			sez->(restarea(_vAmbSez))
		endif
		
	Endif
	
	//QUANDO MULTIPLANATUREZA FOR 1(SIM)
	IF TRSE2->E2_MULTNAT == "1"
		
		Empresa			:= TRSE2->E2_PREFIXO
		Tit_Naturez		:= TRSE2->E2_NATUREZ
		Tit_Custo 		:= TRSE2->E2_CCUSTO
		tx_prefixo		:= TRSE2->E2_PREFIXO
		tx_Numero   	:= TRSE2->E2_NUM
		tx_parc         := TRSE2->E2_PARCELA
		tx_tipo         := TRSE2->E2_TIPO
		tx_codforn		:= TRSE2->E2_FORNECE
		tx_loja			:= TRSE2->E2_LOJA
		tx_vencrea      := TRSE2->E2_VENCREA
		tx_vencrea      := SUBS(tx_vencrea,7,2)+"/"+SUBS(tx_vencrea,5,2)+"/"+SUBS(tx_vencrea,1,4)
		
		//comparacao das soma dos rateios com o valor total do titulo
		VALRAT := Tit_VlBruto
		
		//ROTINA QUE VERIFICA SE O TITULO DE RATEIO TEM RATEIO DE NATUREZAS E CENTROS DE CUSTOS OU SÓ RATEIO DE NATUREZAS JUNTOS NO MESMO TITULO
		//VERIFICA SE TITULO DE RATEIO TEM RATEIO DE NATUREZAS E CENTRO DE CUSTOS
		dbselectarea("SEZ")
		dbsetorder(1)
		
		IF dbseek(xFilial()+tx_prefixo+tx_numero+tx_parc+tx_tipo+tx_codforn+tx_loja,.F.)
			SOMA:=0
			while xFilial()== SEZ->EZ_FILIAL .AND. tx_prefixo == SEZ->EZ_PREFIXO .AND.;
				tx_numero == SEZ->EZ_NUM .AND. tx_parc == SEZ->EZ_PARCELA .AND.;
				tx_tipo == SEZ->EZ_TIPO .AND. tx_codforn == SEZ->EZ_CLIFOR .AND.;
				tx_loja == SEZ->EZ_LOJA
				
				_cCodArea:=sez->ez_empr
				
				Tit_Custo     := SEZ->EZ_CCUSTO
				Tit_Naturez   := SEZ->EZ_NATUREZ
				PERC          := ROUND(SEZ->EZ_VALOR/VALRAT,6)
				//Ricardo 18/02/05
				//VLRATEIO      := ROUND(VALRAT*PERC,2)
				vlrateio:=sez->ez_valor
				
				SOMA := SOMA + VLRATEIO
				Tit_contareduz:= NatDesc(Tit_Naturez,Tit_Custo)
				Tit_Descr	  := Desc(Tit_contareduz)
				
				aadd(_vRateio,{Tit_Naturez,;      //1
				tx_numero,;                     //2
				Tit_Custo,;                     //3
				Tit_contareduz,;                //4
				Tit_Descr,;                     //5
				VLRATEIO,;                      //6
				tx_vencrea,;                    //7
				Tit_parc,;                      //8
				Tit_Tipo,;                      //9
				tx_Prefixo,;                    //10 EMPRESA
				_cCodArea,;                     //11
				sez->(ez_clifor)})      //12 Codigo area
				
				dbselectarea("SEZ")
				dbskip()
			enddo
			//VERIFICA SE TITULO DE RATEIO TEM RATEIO SO DE NATUREZAS
			dbselectarea("SEV")
			dbsetorder(1)
			IF dbseek(xFilial()+tx_prefixo+tx_numero+tx_parc+tx_tipo+tx_codforn+tx_loja,.F.)  //IF dbseek(TRSE2->E2_CSUKEY,.F.)
				
				while xFilial()== SEV->EV_FILIAL .AND. tx_prefixo == SEV->EV_PREFIXO .AND.;
					tx_numero==SEV->EV_NUM .AND. tx_parc == SEV->EV_PARCELA .AND.;
					tx_tipo==SEV->EV_TIPO .AND. tx_codforn == SEV->EV_CLIFOR .AND.;
					tx_loja==SEV->EV_LOJA
					
					IF SEV->EV_RATEICC == "2"
						
						Tit_Custo           := "Nao Rateado"
						Tit_naturez         := SEV->EV_NATUREZ
						PERC                := ROUND(SEV->EV_VALOR/VALRAT,6)
						VLRATEIO            := ROUND(VALRAT*PERC,2)
						
						SOMA := SOMA + VLRATEIO
						Tit_contareduz:= NatDesc(Tit_Naturez,Tit_Custo)
						Tit_Descr	  := Desc(Tit_contareduz)
						
						aadd(_vRateio,{Tit_Naturez,;      //1
						tx_numero,;                     //2
						Tit_Custo,;                     //3
						Tit_contareduz,;                //4
						Tit_Descr,;                     //5
						VLRATEIO,;                      //6
						tx_vencrea,;                    //7
						Tit_parc,;                      //8
						Tit_Tipo,;                      //9
						tx_prefixo,;                    //10 EMPRESA
						_cCodArea,;                     //11
						sez->(ez_clifor)})      //12
					ENDIF
					dbselectarea("SEV")
					dbskip()
				enddo
				If SOMA <> Tit_VlBruto
					
					VLRATEIO := _vRateio[len(_vRateio),6]
					
					IF soma > Tit_VlBruto
						VLRATEIO:= VLRATEIO-(soma-Tit_VlBruto)
					Else
						VLRATEIO:= VLRATEIO+(Tit_VlBruto-soma)
					Endif
					
					_vRateio[len(_vRateio),6]:=VLRATEIO
					
				Endif
				soma:=0
			Endif
		ELSE
			// SE NAO ACHOU O TITULO NO SEZ - TITULOS COM RATEIO SO DE NATUREZAS
			dbselectarea("SEV")
			dbsetorder(1)
			
			IF dbseek(xFilial()+tx_prefixo+tx_numero+tx_parc+tx_tipo+tx_codforn+tx_loja,.F.)  //IF dbseek(TRSE2->E2_CSUKEY,.F.)
				SOMA:=0
				while xFilial()== SEV->EV_FILIAL .AND. tx_prefixo == SEV->EV_PREFIXO .AND.;
					tx_numero == SEV->EV_NUM .AND. tx_parc == SEV->EV_PARCELA .AND.;
					tx_tipo == SEV->EV_TIPO .AND. tx_codforn == SEV->EV_CLIFOR .AND.;
					tx_loja == SEV->EV_LOJA
					
					Tit_Custo           := "Nao Rateado"
					Tit_naturez         := SEV->EV_NATUREZ
					PERC                := SEV->EV_PERC
					VLRATEIO            := ROUND(VALRAT*PERC,2)
					
					SOMA := SOMA + VLRATEIO
					Tit_contareduz:= NatDesc(Tit_Naturez,Tit_Custo)
					Tit_Descr	  := Desc(Tit_contareduz)
					
					aadd(_vRateio,{Tit_Naturez,;      //1
					tx_numero,;                     //2
					Tit_Custo,;                     //3
					Tit_contareduz,;                //4
					Tit_Descr,;                     //5
					VLRATEIO,;                      //6
					tx_vencrea,;                    //7
					Tit_parc,;                      //8
					Tit_Tipo,;                      //9
					tx_prefixo,;                    //10 EMPRESA
					_cCodArea,;                     //11
					sez->(ez_clifor)})      //12
					
					dbselectarea("SEV")
					dbskip()
				enddo
				If SOMA <> Tit_VlBruto
					
					VLRATEIO := _vRateio[len(_vRateio),6]
					
					IF soma > Tit_VlBruto
						VLRATEIO:= VLRATEIO-(soma-Tit_VlBruto)
					Else
						VLRATEIO:= VLRATEIO+(Tit_VlBruto-soma)
					Endif
					
					_vRateio[len(_vRateio),6]:=VLRATEIO
					
				Endif
				soma:=0
			Endif
		ENDIF
	ENDIF
	
	//QUANDO MULTIPLA NATUREZA FOR IGUAL A BRANCO
	If empty(TRSE2->E2_MULTNAT)
		
		If TRSE2->E2_TIPO$"INS/ISS/TX "
			if cNumEmp<>"1001"
				//_cCodArea :=trse2->e2_codarea
			endif
			Empresa			:= TRSE2->E2_PREFIXO
			Tit_Naturez		:= TRSE2->E2_NATUREZ
			Tit_Custo 		:= TRSE2->E2_CCUSTO
			tx_prefixo		:= TRSE2->E2_PREFIXO
			tx_Numero   	:= TRSE2->E2_NUM
			tx_parc         := TRSE2->E2_PARCELA
			tx_parcpric     := SUBSTR(TRSE2->E2_CSUKEY,12,1)
			tx_tipo         := SUBSTR(TRSE2->E2_CSUKEY,13,3)
			tx_codforn		:= SUBSTR(TRSE2->E2_CSUKEY,16,6)
			tx_loja			:= SUBSTR(TRSE2->E2_CSUKEY,22,2)
			tx_vencrea      := TRSE2->E2_VENCREA
			tx_vencrea      := SUBS(tx_vencrea,7,2)+"/"+SUBS(tx_vencrea,5,2)+"/"+SUBS(tx_vencrea,1,4)
			
			//comparacao das soma dos rateios com o valor total do titulo
			VALRAT      := TRSE2->E2_VALOR
			
			// BUSCA VALOR TOTAL DO TITULO PAI
			_AREA := GetArea()
			REG := RECNO() // POSICAO DO PONTEIRO ANTES DO DBSEEK
			dbselectarea("SE2")
			dbsetorder(1)
			
			IF dbseek(xFilial()+tx_prefixo+tx_numero+tx_parcpric+tx_tipo+tx_codforn+tx_loja,.F.)
				if cNumEmp == "1001" // aaj221104 os 3175/04
					VlBrutopai	:= (SE2->E2_VALOR+SE2->E2_IRRF+SE2->E2_INSS+SE2->E2_ISS)
				else
					VlBrutopai	:= (SE2->E2_VALOR+SE2->E2_IRRF+SE2->E2_INSS+SE2->E2_ISS+SE2->E2_VRETPIS+SE2->E2_VRETCSL+SE2->E2_VRETCOF)
				endif
			ENDIF
			
			_cCodArea:=Empresa			:= posicione("CTT",1,xfilial("CTT")+TRSE2->e2_ccusto,"ctt_empres")
			
			RestArea(_AREA)
			DBGOTO(REG) // VOLTA O PONTEIRO APOS O DBSEEK
			
			//Verifica se o titulo tem rateiro
			dbselectarea("SEZ")
			dbsetorder(1)
			
			IF dbseek(xFilial()+tx_prefixo+tx_numero+tx_parcpric+tx_tipo+tx_codforn+tx_loja,.F.)
				
				SOMA:=0
				Tit_RatCSU := "1" //SETA O TÍTULO PARA RATEIRO
				
				while xFilial()== SEZ->EZ_FILIAL .AND. tx_prefixo == SEZ->EZ_PREFIXO .AND.;
					tx_numero == SEZ->EZ_NUM .AND. tx_parcpric == SEZ->EZ_PARCELA .AND.;
					tx_tipo == SEZ->EZ_TIPO .AND. tx_codforn == SEZ->EZ_CLIFOR .AND.;
					tx_loja == SEZ->EZ_LOJA
					
					_cCodArea:=sez->ez_empr
					Tit_custo     := SEZ->EZ_CCUSTO
					Tit_naturez   := SEZ->EZ_NATUREZ
					PERC          := ROUND(SEZ->EZ_VALOR/VlBrutopai,6)
					VLRATEIO      := ROUND(VALRAT*PERC,2)
					
					SOMA := SOMA + VLRATEIO
					Tit_contareduz:= NatDesc(SEZ->EZ_NATUREZ,SEZ->EZ_CCUSTO)
					Tit_Descr	  := Desc(Tit_contareduz)
					
					aadd(_vRateio,{Tit_naturez,;      //1
					tx_numero,;                     //2
					Tit_custo,;                     //3
					Tit_contareduz,;                //4
					Tit_Descr,;                     //5
					VLRATEIO,;                      //6
					tx_vencrea,;                    //7
					Tit_parc,;                      //8
					Tit_Tipo,;                      //9
					tx_prefixo,;                    //10 EMPRESA
					_cCodArea,;
					sez->(ez_clifor)})
					dbselectarea("SEZ")
					dbskip()
				enddo
				//VERIFICA SE TITULO DE RATEIO TEM RATEIO SO DE NATUREZAS
				dbselectarea("SEV")
				dbsetorder(1)
				IF dbseek(xFilial()+tx_prefixo+tx_numero+tx_parcpric+tx_tipo+tx_codforn+tx_loja,.F.)  //IF dbseek(TRSE2->E2_CSUKEY,.F.)
					
					while xFilial()== SEV->EV_FILIAL .AND. tx_prefixo == SEV->EV_PREFIXO .AND.;
						tx_numero == SEV->EV_NUM .AND. tx_parcpric == SEV->EV_PARCELA .AND.;
						tx_tipo == SEV->EV_TIPO .AND. tx_codforn == SEV->EV_CLIFOR .AND.;
						tx_loja == SEV->EV_LOJA
						
						IF SEV->EV_RATEICC == "2"
							
							Tit_Custo           := "Nao Rateado"
							Tit_naturez         := SEV->EV_NATUREZ
							PERC                := ROUND(SEV->EV_VALOR/VlBrutopai,6)
							VLRATEIO            := ROUND(VALRAT*PERC,2)
							
							SOMA := SOMA + VLRATEIO
							Tit_contareduz:= NatDesc(Tit_Naturez,Tit_Custo)
							Tit_Descr	  := Desc(Tit_contareduz)
							
							aadd(_vRateio,{Tit_Naturez,;      //1
							tx_numero,;                     //2
							Tit_Custo,;                     //3
							Tit_contareduz,;                //4
							Tit_Descr,;                     //5
							VLRATEIO,;                      //6
							tx_vencrea,;                    //7
							Tit_parc,;                      //8
							Tit_Tipo,;                      //9
							tx_prefixo,;                    //10 EMPRESA
							_cCodArea,;
							sez->(ez_clifor)})
							
						ENDIF
						dbselectarea("SEV")
						dbskip()
					enddo
					If SOMA <> VALRAT
						
						VLRATEIO := _vRateio[len(_vRateio),6]
						
						IF soma > VALRAT
							VLRATEIO:= VLRATEIO-(soma-VALRAT)
						Else
							VLRATEIO:= VLRATEIO+(VALRAT-soma)
						Endif
						
						_vRateio[len(_vRateio),6]:=VLRATEIO
						
					Endif
					soma:=0
				Endif
			ELSE
				// SE NAO ACHOU O TITULO NO SEZ
				dbselectarea("SEV")
				dbsetorder(1)
				
				IF dbseek(xFilial()+tx_prefixo+tx_numero+tx_parcpric+tx_tipo+tx_codforn+tx_loja,.F.)  //IF dbseek(TRSE2->E2_CSUKEY,.F.)
					SOMA:=0
					Tit_RatCSU := "1" // SETA O TITULO PARA RATEIRO
					while xFilial()== SEV->EV_FILIAL .AND. tx_prefixo == SEV->EV_PREFIXO .AND.;
						tx_numero == SEV->EV_NUM .AND. tx_parcpric == SEV->EV_PARCELA .AND.;
						tx_tipo == SEV->EV_TIPO .AND. tx_codforn == SEV->EV_CLIFOR .AND.;
						tx_loja == SEV->EV_LOJA
						
						Tit_Custo           := "Nao Rateado"
						Tit_naturez         := SEV->EV_NATUREZ
						PERC                := SEV->EV_PERC
						VLRATEIO            := ROUND(VALRAT*PERC,2)
						
						SOMA := SOMA + VLRATEIO
						Tit_contareduz:= NatDesc(SEV->EV_NATUREZ,Tit_Custo)
						Tit_Descr	  := Desc(Tit_contareduz)
						
						aadd(_vRateio,{Tit_naturez,;      //1
						tx_numero,;                     //2
						Tit_Custo,;                     //3
						Tit_contareduz,;                //4
						Tit_Descr,;                     //5
						VLRATEIO,;                      //6
						tx_vencrea,;                    //7
						Tit_parc,;                      //8
						Tit_Tipo,;                      //9
						tx_prefixo,;                    //10 EMPRESA
						_cCodArea,;
						sez->(ez_clifor)})
						
						dbselectarea("SEV")
						dbskip()
					enddo
					If SOMA <> VALRAT
						
						VLRATEIO := _vRateio[len(_vRateio),6]
						
						IF soma > VALRAT
							VLRATEIO:= VLRATEIO-(soma-VALRAT)
						Else
							VLRATEIO:= VLRATEIO+(VALRAT-soma)
						Endif
						
						_vRateio[len(_vRateio),6]:=VLRATEIO
						
					Endif
					soma:=0
				Endif
			ENDIF
		Endif
	Endif
	
	RestArea(_aSM)
	if cNumEmp == "1001" // aaj221104 os 3175/04
		Somabruto	:=Somabruto+(TRSE2->E2_VALOR+TRSE2->E2_IRRF+TRSE2->E2_INSS+TRSE2->E2_ISS)
	else
		Somabruto	:=Somabruto+(TRSE2->E2_VALOR+TRSE2->E2_IRRF+TRSE2->E2_INSS+TRSE2->E2_ISS+TRSE2->E2_VRETPIS+TRSE2->E2_VRETCSL+TRSE2->E2_VRETCOF)
	endif
	SomaInss 	:=SomaInss+TRSE2->E2_INSS
	SomaIRRF 	:=SomaIRRF+TRSE2->E2_IRRF
	SomaIss  	:=SomaIss+TRSE2->E2_ISS
	SomaLiq  	:=SomaLiq+TRSE2->E2_VALOR+TRSE2->E2_ACRESC-TRSE2->E2_DECRESC
	
	IF tit_tipo == "TX "
		
		IF(_nPosic:=ascan(Aglutina,{|_vAux|_vAux[01]==Tit_Emissao.and.;
			_vAux[05]==Tit_Parc.and.;
			_vAux[12]==Tit_tipo.and.;
			_vAux[13]==Tit_Numdoc.and.;
			_vAux[14]==Tit_Naturez.and.;
			_vAux[19]==Cod_for.and.;
			_vAux[25]==empresa}))==0
			
			aadd(Aglutina,;
			{Tit_Emissao,;			//01
			Tit_Vencim,;    		//02
			Tit_RatCSU,;    		//03
			Tit_VencRea,;   		//04
			Tit_Parc,;      		//05
			Tit_VlBruto,;   		//06
			Tit_VlIR,;      		//07
			Tit_VlInss,;    		//08
			Tit_VlIss,;     		//09
			Tit_VlLiq,;     		//10
			Tit_Hist,;      		//11
			Tit_tipo,;      		//12
			Tit_NumDoc,;    		//13
			Tit_Naturez,;   		//14
			Tit_Custo,;     		//15
			Tit_Vlmp135,;			//16
			desc,;   				//17 CAMPO NAO UTILIZADO MANTER A ORDEM
			Nome_for,;	    		//18
			Cod_for,;					//19
			Conta_Reduz_for,; 		//20
			Descr_for,;	      		//21
			Cgc_for ,;      		//22
			Tit_Conta_Debito,;		//23
			Tit_Descricao,;		  	//24
			Empresa,;				//25
			Tit_Digitac,;   		//26  // aaj011204 os 3572/04
			_cCodArea,;             //27
			Tit_Acresc,;            //28
			Tit_Decresc,;           //29
			TIT_MULTA,;             //30
			TIT_DESCONT })           //31})
			
			if _lComRat
				aGlutina[len(aGlutina)][3]:="1"
				_lComrat:=.f.
			endif
			
		ELSE
			aGlutina[_nPosic][06]+=tit_vlBruto
			aGlutina[_nPosic][10]+=tit_vlLiq
			if _lComRat
				aGlutina[_nPosic][3]:="1"
				_lComrat:=.f.
			endif
		endif
	ELSE
	
		aTps := {}
		aParc := {}
		Aadd(aParc, TRSE2->E2_PARCPIS)
		Aadd(aParc, TRSE2->E2_PARCCOF)
		Aadd(aParc, TRSE2->E2_PARCSLL)
		Aadd(aTps , "TX ")
		Aadd(aTps , "TX ")
		Aadd(aTps , "TX ") // aTps deve ter o mesmo tamanho de aParc  
		
		
		Tit_VlBruto -= Tit_Vlmp135
		Tit_Vlmp135 := 0
		
		DbSelectArea("SE2")
		For x := 1 to Len(aTps)
			// Procura o titulo de imposto no alias alternativo.
			If SE2->(Dbseek(xFilial("SE2")+TRSE2->E2_PREFIXO+TRSE2->E2_NUM+aParc[x]+aTps[x]))
				Tit_Vlmp135+= SE2->E2_VALOR				
			Endif
		Next    
		
		Tit_VlBruto += Tit_Vlmp135
				
		aadd(Aglutina,;
		{Tit_Emissao,;			//01
		Tit_Vencim,;    		//02
		Tit_RatCSU,;    		//03
		Tit_VencRea,;   		//04
		Tit_Parc,;      		//05
		Tit_VlBruto,;   		//06
		Tit_VlIR,;      		//07
		Tit_VlInss,;    		//08
		Tit_VlIss,;     		//09
		Tit_VlLiq,;     		//10
		Tit_Hist,;      		//11
		Tit_tipo,;      		//12
		Tit_NumDoc,;    		//13
		Tit_Naturez,;   		//14
		Tit_Custo,;     		//15
		Tit_Vlmp135,;			//16
		desc,;   				//17 CAMPO NAO UTILIZADO MANTER A ORDEM
		Nome_for,;	    		//18
		Cod_for,;				//19
		Conta_Reduz_for,; 		//20
		Descr_for,;	      		//21
		Cgc_for ,;      		//22
		Tit_Conta_Debito,;		//23
		Tit_Descricao,;		  	//24
		Empresa,;   		  	//25
		Tit_Digitac,;   		//26  // aaj011204 os 3572/04
		_cCodArea,;             //27
		Tit_Acresc,;            //28
		Tit_Decresc,;           //29
		TIT_MULTA,;             //30
		TIT_DESCONT })           //31})
		
		if _lComRat
			aGlutina[len(aGlutina)][3]:="1"
			_lComrat:=.f.
		endif
	endif
	
	DBSelectArea("TRSE2")
	dbSkip()
Enddo

//inicia a impressão dos títulos...
oPrn := TMSPrinter():New()
oPrn :Setup()

For x:=1 to Len(Aglutina)
	
	oPrn:Say( 10, 10, " ",Courier,100 ) // startando a impressora
	cabecalho()
	OPrn:Say(600,380,"NOME      : "+Aglutina[X,18],Courier12T,0)
	oPrn:Say(650,380,"FORNECEDOR: "+Aglutina[X,19],Courier12T,0)
	oPrn:Say(650,1100,"CNPJ       : "+TRANSFORM((Aglutina[X,22]),"@R 99.999.999/9999-99"),Courier12T,0)
	oPrn:Say(700,380,"TIPO   : " +(Aglutina[X,12]),Courier12T,0)
	
	oPrn:Say(750,380,"DIGITAÇÃO: " +(Aglutina[X,26]),Courier12T,0)	  // aaj011204 os 3572/04
	
	oPrn:Say(700,1100,"NUM.DOC : " +(Aglutina[X,13]),Courier12T,0)
	OPrn:Say(900,100,"DT.EMISSAO " ,Courier12T,0)
	OPrn:Say(950,100,TRANSFORM((Aglutina [X,1]),"@E"),Courier12F,0)
	OPrn:Say(900,600,"VENCIMENTO " ,Courier12T,0)
	OPrn:Say(950,600,TRANSFORM((Aglutina [X,2]),"@E"),Courier12F,0)
	OPrn:Say(900,1100,"VENC.REAL " ,Courier12T,0)
	OPrn:Say(950,1100,TRANSFORM((Aglutina [X,4]),"@E"),Courier12F,0)
	OPrn:Say(900,1600,"PARCELA",Courier12T,0)
	OPrn:Say(950,1600,(Aglutina [X,05]),Courier12F,0)
	OPrn:Say(900,1900,"VL. BRUTO R$",Courier12T,0)
	OPrn:Say(950,1865, TRANSFORM((Aglutina[X,6]),"@E 999,999,999.99"),Courier12F,0)
	OPrn:Say(1100,100,"LEI 10833/03 R$",Courier12T,0)
	OPrn:Say(1150,115, TRANSFORM((Aglutina[X,16]),"@E 999,999,999.99"),Courier12F,0)
	OPrn:Say(1100,560,"VL. I.R. R$",Courier12T,0)
	OPrn:Say(1150,575, TRANSFORM((Aglutina[X,7]),"@E 999,999.99"),Courier12F,0)
	OPrn:Say(1100,1000,"VL. I.N.S.S. R$",Courier12T,0)
	OPrn:Say(1150,1020, TRANSFORM((Aglutina[X,8]),"@E 999,999,999.99"),Courier12F,0)
	OPrn:Say(1100,1450,"VL.I.S.S. R$",Courier12T,0)
	OPrn:Say(1150,1415,TRANSFORM((Aglutina[X,9]),"@E 999,999,999.99"),Courier12F,0)
	OPrn:Say(1100,1900,"VL. LIQUIDO R$",Courier12T,0)
	OPrn:Say(1150,1900, TRANSFORM((Aglutina[X,10]),"@E 999,999,999.99"),Courier12F,0)
	OPrn:Say(1250,100,"VL. DESCONTO R$",Courier12T,0)
	OPrn:Say(1300,135, TRANSFORM((Aglutina[X,31]),"@E 999,999,999.99"),Courier12F,0)
	OPrn:Say(1250,550,"VL. MULTA R$",Courier12T,0)
	OPrn:Say(1300,515, TRANSFORM((Aglutina[X,30]),"@E 999,999,999.99"),Courier12F,0)
	/*
	OPrn:Say(1250,100,"VL. ACRESCIMO R$",Courier12T,0)
	OPrn:Say(1300,150, TRANSFORM((Aglutina[X,28]),"@E 999,999,999.99"),Courier12F,0)
	OPrn:Say(1250,550,"VL. DECRESCIMO R$",Courier12T,0)
	OPrn:Say(1300,600, TRANSFORM((Aglutina[X,29]),"@E 999,999,999.99"),Courier12F,0)
	*/
	OPrn:Say(1400,100,"HISTORICO :"+SubStr(Aglutina[X,11],1,76),Courier12T,0)
	OPrn:Say(1450,100,"           "+SubStr(Aglutina[X,11],77,158),Courier12T,0)
	OPrn:Say(1500,050,REPLICATE("_",140),Courier12T,0)
	OPrn:Say(1600,050,"C/CREDITO  ",Courier12T,0)
	OPrn:Say(1650,050,Aglutina [X,20],Courier12F,0)
	OPrn:Say(1600,800,"DESCRICAO  ",Courier12T,0)
	OPrn:Say(1650,800,Aglutina [X,21],Courier12F,0)
	OPrn:Say(1800,50,"EMPRESA ",Courier08T,0)
	OPrn:Say(1800,200,"NATUREZA ",Courier08T,0)
	OPrn:Say(1800,450,"NUMERO ",Courier08T,0)
	OPrn:Say(1800,650,"C/CUSTO ",Courier08T,0)
	OPrn:Say(1800,850,"C/DEBITO ",Courier08T,0)
	OPrn:Say(1800,1050,"DESCRICAO",Courier08T,0)
	OPrn:Say(1800,1850,"VALOR R$",Courier08T,0)
	OPrn:Say(1800,2100,"VENC.REAL",Courier08T,0)
	linha:=1850
	
	If  AGLUTINA[X,3]=="1" // TITULO COM RATEIRO
		
		FOR J:=1 TO LEN(_vRateio)
			//tipo                            //numero                         //parcela                                                     // prefixo            //fornecedor
			If _vRateio[J,9]==AGLUTINA[X,12] .AND. _vRateio[J,2]==AGLUTINA[X,13] .AND. _vRateio[J,8]==AGLUTINA[X,5].and.(alltrim(_vRateio[j,9])$"ISS/INS/TX".or._vRateio[j,10]==aGlutina[x,25]).and._vRateio[j,12]==aGlutina[x,19]
				
				OPrn:Say(linha,50,_vRateio[J,11],Courier08F,0) // Ricardo 18/01/05
				OPrn:Say(linha,200,_vRateio[J,1],Courier08F,0)
				OPrn:Say(linha,450,_vRateio[J,2],Courier08F,0)
				OPrn:Say(linha,650,_vRateio[J,3],Courier08F,0)
				OPrn:Say(linha,850,_vRateio[J,4],Courier08F,0)
				OPrn:Say(linha,1050,_vRateio[J,5],Courier08F,0)
				OPrn:Say(linha,1760,TRANSFORM(_vRateio[J,6],"@E 999,999,999.99"),Courier08F,0)
				OPrn:Say(linha,2105,TRANSFORM(_vRateio[J,7],"@E"),Courier08F,0)
				linha:=linha+50
				
				if linha>2860
					PAG:=PAG+1
					oPrn:EndPage()
					oPrn:StartPage()
					cabecalho()
					cabecalho2()
					linha:=480
				Endif
				
			Endif
		NEXT
		
	Else
		
		OPrn:Say(linha,50,Aglutina[X,27],Courier08F,0)
		OPrn:Say(linha,200,Aglutina[X,14],Courier08F,0)
		OPrn:Say(linha,450,Aglutina[X,13],Courier08F,0)
		OPrn:Say(linha,650,Aglutina[X,15],Courier08F,0)
		OPrn:Say(linha,850,Aglutina[X,23],Courier08F,0)
		OPrn:Say(linha,1050,Aglutina[X,24],Courier08F,0)
		OPrn:Say(linha,1760,TRANSFORM(Aglutina[X,06],"@E 999,999,999.99"),Courier08F,0)
		OPrn:Say(linha,2105,TRANSFORM(Aglutina[X,4],"@E"),Courier08F,0)
	Endif
	
	linha:=linha+200
	OPrn:Say(Linha,050,REPLICATE("_",40),Courier12T,0)
	OPrn:Say(Linha,1500,REPLICATE("_",40),Courier12T,0)
	linha:=linha+50
	OPrn:Say(Linha,400,"AUTORIZADO",Courier12T,0)
	
	oPrn:EndPage()
	
	if len(aglutina)>1.AND.(x)<len(aglutina)
		oPrn:StartPage()
	Endif
	
NEXT

oPrn:Preview()

MS_FLUSH()
DBCloseArea("TRSE2")

Return

//********************************************************************

Static Function Cabecalho()

linha:=30
OPrn:Say(Linha,050,REPLICATE("_",140),Courier12T,0)
linha:=linha+100

Empresa := SM0->M0_CODIGO

IF Empresa=="05" // MARKETSYSTEM
	oPrn:Say(linha,100,"CSU CARDSYSTEM",Courier14,0  )
ElseIf Empresa=="30" // MARKETSYSTEM
	oPrn:Say(linha,100,"MARKETSYSTEM",Courier14,0  ) 
ElseIF Empresa=="31"
	oPrn:Say(linha,100,"ANAPURUS",Courier14,0  )
ElseIF Empresa=="32"
	oPrn:Say(linha,100,"CRIEFF",Courier14,0  )
ElseIF Empresa=="33"
	oPrn:Say(linha,100,"GLOBAL",Courier14,0  )
ElseIF Empresa=="34"
	oPrn:Say(linha,100,"B2C",Courier14,0  )
ElseIF Empresa=="35"
	oPrn:Say(linha,100,"MONTALCINO",Courier14,0  )
ElseIF Empresa=="36"
	oPrn:Say(linha,100,"TALENTO",Courier14,0  )
ElseIF Empresa=="37"
	oPrn:Say(linha,100,"TVSYSTEM",Courier14,0  )    
ElseIF Empresa=="06"  
	oPrn:Say(linha,100,"INSTITUTO CSU",Courier14,0  )			
Endif                                                       

oPrn:Say(linha,2100,"DATA "+TRANSFORM(DATE(),"@E"),Courier12T,0)
linha:=linha+50
oPrn:Say(linha,2100,"HORA "+TIME(),Courier12T,0  )
linha:=linha+50
oPrn:Say(linha,900,"AUTORIZACAO DE PAGAMENTO",Courier14,0  )
oPrn:Say(linha,2100,"PAG. "+Alltrim(STR(PAG)),Courier12T,0  )
linha:=linha+100
oPrn:Say(Linha,050,REPLICATE("_",140),Courier12T,0)

Return

//********************************************************************

Static Function Cabecalho2()

linha:=linha+100
OPrn:Say(1800,50,"EMPRESA ",Courier08T,0)
OPrn:Say(1800,200,"NATUREZA ",Courier08T,0)
OPrn:Say(1800,450,"NUMERO ",Courier08T,0)
OPrn:Say(1800,650,"C/CUSTO ",Courier08T,0)
OPrn:Say(1800,850,"C/DEBITO ",Courier08T,0)
OPrn:Say(1800,1050,"DESCRICAO",Courier08T,0)
OPrn:Say(1800,1850,"VALOR R$",Courier08T,0)
OPrn:Say(1800,2150,"VENC.REAL",Courier08T,0)
linha:=linha+50

Return

//********************************************************************

Static Function Natdesc(Natureza,Ccusto)

Res:=""
dbselectarea("SED")
dbsetorder(1)

if cNumEmp == "1001" // aaj221104 os 3175/04
	// Ricardo 18/01/2005
	_cConta:=posicione("SZ1",1,xfilial("SZ1")+natureza,"z1_ccontab")
	res:=posicione("CT1",1,xfilial("CT1")+_cConta,"ct1_res")
	return(res)
endif

If dbseek (xFilial("SED")+Natureza)// Natureza recebe o codigo para localizar se e despesa, receita ou patrimonial
	
	If SED->ED_RECDEP$"D"
		
		dbselectarea("CTT")
		dbsetorder(1)
		If dbseek (xFilial("CTT")+Ccusto)//Posiciona o centro de custo para saber o grupo
			grupo:=CTT->CTT_GRUPO
			
			Dbselectarea("SZ1")
			DBsetorder(1)
			If dbseek (XFilial("SZ1")+Natureza+Grupo)//Posiciona a natureza e o grupo de centro de custo para achar a conta contabil
				Conta:=SZ1->Z1_CCONTAB
				
				dbselectarea ("CT1")
				dbsetorder(1)
				If dbseek (XFilial()+Conta)//Posiciona a conta para achar o codigo reduzido e a descricao
					
					Res :=CT1->CT1_RES
					
				Endif
			Else
				
				Res:=""
				
			Endif
		Else
			Res:=""
			
		Endif
		
	Elseif SED->ED_RECDEP$"P/R"
		
		dbselectarea("SZ1")
		dbsetorder(1)
		If dbseek (XFilial("SZ1")+Natureza)//Posiciona a natureza  para achar a conta contabil
			Conta:=SZ1->Z1_CCONTAB
			
			dbselectarea ("CT1")
			dbsetorder(1)
			If dbseek (XFilial("CT1")+Conta)//Posiciona a conta para achar o codigo reduzido e a descricao
				
				Res :=CT1->CT1_RES
				
			Endif
		Else
			
			Res:=""
			
		Endif
	Endif
Endif
Return(Res)

//********************************************************************

Static Function Desc(Res)

//Desc:="VERIFICAR AMARRAÇÃO CONTÁBIL"

/*IF !EMPTY(RES)
dbselectarea("CT1")
dbsetorder(2)
If dbseek (XFilial("CT1")+RES)//Posiciona a conta para achar a descricao
Desc:=CT1->CT1_DESC01
Endif
Else
Desc:="VERIFICAR AMARRAÇÃO CONTÁBIL"
Endif
*/
Dbselectarea("CT1")
Desc:=CT1->CT1_DESC01
Return (Desc)


//********************************************************************
Static function _fAtuImpr()

if cNumEmp == "1001" // aaj221104 os 3175/04
	return
endif

* Marca os registros impressos
se2->(dbsetorder(1))
procregua(len(_vSe2Keys))
for _nVez:=1 to len(_vSe2Keys)
	if se2->(dbseek(_vSe2Keys[_nVez],.f.).and.empty(e2_csimpca).and.reclock(alias(),.f.))
		se2->e2_csimpca:="x"
		se2->(msunlock())
	endif
	incproc(se2->e2_nomfor)
next

return

//********************************************************************

Static Function ContaReduz(Conta)
Private reduz:=""

dbselectarea ("CT1")
dbsetorder(1)

If dbseek (XFilial()+Conta)//Posiciona a conta para achar o codigo reduzido
	Reduz:=CT1->CT1_RES
Endif

Return (Reduz)

//********************************************************************

Static Function ValidPerg()

_sAlias := Alias()

dbSelectArea("SX1") // abre arquivo sx1 de perguntas
dbSetOrder(1)       // coloca na ordem 1 do sindex
cPerg := PADR(cPerg,LEN(SX1->X1_GRUPO))
aRegs:={}

// Grupo/Ordem/Pergunta/Variavel/Tipo/Tamanho/Decimal/Presel/GSC/Valid/Var01/Def01/Cnt01/Var02/Def02/Cnt02/Var03/Def03/Cnt03/Var04/Def04/Cnt04/Var05/Def05/Cnt05
AADD(aRegs,{cPerg,"01"," Emissao de      ?","","","mv_ch1","D",08,0,0,"G","","mv_par01","","","","","","","","","","","","","","","","","","","","","","","","","",""})
AADD(aRegs,{cPerg,"02"," Emissao ate     ?","","","mv_ch2","D",08,0,0,"G","","mv_par02","","","","","","","","","","","","","","","","","","","","","","","","","",""})
AADD(aRegs,{cPerg,"03"," Tipo de         ?","","","mv_ch3","C",03,0,0,"G","","mv_par03","","","","","","","","","","","","","","","","","","","","","","","","","",""})
AADD(aRegs,{cPerg,"04"," Tipo ate        ?","","","mv_ch4","C",03,0,0,"G","","mv_par04","","","","","","","","","","","","","","","","","","","","","","","","","",""})
AADD(aRegs,{cPerg,"05"," Numero de       ?","","","mv_ch5","C",06,0,0,"G","","mv_par05","","","","","","","","","","","","","","","","","","","","","","","","","",""})
AADD(aRegs,{cPerg,"06"," Numero ate      ?","","","mv_ch6","C",06,0,0,"G","","mv_par06","","","","","","","","","","","","","","","","","","","","","","","","","",""})
AADD(aRegs,{cPerg,"07"," Fornecedor de   ?","","","mv_ch7","C",06,0,0,"G","","mv_par07","","","","","","","","","","","","","","","","","","","","","","","","","SA2",""})
AADD(aRegs,{cPerg,"08"," Fornecedor ate  ?","","","mv_ch8","C",06,0,0,"G","","mv_par08","","","","","","","","","","","","","","","","","","","","","","","","","SA2",""})
AADD(aRegs,{cPerg,"09"," Loja de         ?","","","mv_ch9","C",02,0,0,"G","","mv_par09","","","","","","","","","","","","","","","","","","","","","","","","","",""})
AADD(aRegs,{cPerg,"10"," Loja ate        ?","","","mv_chA","C",02,0,0,"G","","mv_par10","","","","","","","","","","","","","","","","","","","","","","","","","",""})
AADD(aRegs,{cPerg,"11"," Considerar      :","","","mv_chB","N",01,0,0,"C","","mv_par11","Somente novos","","","","","Todos","","","","","","","","","","","","","","","","","","","",""})
AADD(aRegs,{cPerg,"12"," Digitacao de    ?","","","mv_chC","D",08,0,0,"G","","mv_par12","","","","","","","","","","","","","","","","","","","","","","","","","",""})  // aaj011204 os 3571/04
AADD(aRegs,{cPerg,"13"," Digitacao ate   ?","","","mv_chD","D",08,0,0,"G","","mv_par13","","","","","","","","","","","","","","","","","","","","","","","","","",""})  // aaj011204 os 3571/04
For i:=1 to Len(aRegs)
	If !dbSeek(cPerg+aRegs[i,2])
		RecLock("SX1",.T.)
		For j:=1 to FCount()
			If j <= Len(aRegs[i])
				FieldPut(j,aRegs[i,j])
			Endif
		Next
		MsUnlock()
	Endif
Next

dbSelectArea(_sAlias)

Return
