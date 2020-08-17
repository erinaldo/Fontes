#include 'Protheus.ch'                         
#include 'rwmake.ch'
#IFNDEF WINDOWS
	#DEFINE PSAY SAY
#ENDIF

User Function MTDESCRNFE
Local aArea:= GetArea()
Local _cDescr := ""
Local creturn := ""
Local _dVencto := SC5->C5_DATA1
Local _lTemIrrf  := .F.
Local _lTemContr := .F.
Local _lTemISS   := .F.
Local _lTemINSS  := .F.
Local _nValCsl    := 0
Local _nValPis    := 0
Local _nValCof    := 0
Local _nValIrf    := 0
Local _nTotRet    := 0
Local _nValIns    := 0

SD2->(DbSetOrder(3))
IF SD2->(DbSeek( xFilial( "SD2" ) + SF3->F3_NFISCAL + SF3->F3_SERIE))
	SC6->(DbSetOrder(1))
	SC6->(dbSeek(xFilial("SC6")+SD2->D2_PEDIDO))
		_cdescr += "Serviço: "+SC6->C6_DESCRI+"|"		
	SC5->(DbSetOrder(1))
	SC5->(dbSeek(xFilial("SC5")+SD2->D2_PEDIDO))
		_dVencto := SC5->C5_DATA1
		_cDescr += "Vencimento: "+Dtoc(_dVencto)+"|"
		_cdescr += Alltrim(SC5->C5_COMPETE)+"|"
		If !Empty(SC5->C5_MENNOT2)
			_cdescr += Alltrim(SC5->C5_MENNOT2)+"|"
		EndIf	
		If !Empty(SC5->C5_MENNOTA)
			_cdescr += Alltrim(SC5->C5_MENNOTA)+"|"
		EndIf	
		If !Empty(SC5->C5_MENNOT3)	
			_cdescr += Alltrim(SC5->C5_MENNOT3)+"|"
		EndIf
		If !Empty(SC5->C5_MENNOT4)
			_cdescr += Alltrim(SC5->C5_MENNOT4)+"|"
		EndIf	
		If !Empty(SC5->C5_MENNOT5)
			_cdescr += Alltrim(SC5->C5_MENNOT5)+"|"
		EndIf
		If !Empty(SC5->C5_MENNOT6)
			_cdescr += Alltrim(SC5->C5_MENNOT6)+"|"
		EndIf
		If !Empty(SC5->C5_MENNOT7)
			_cdescr += Alltrim(SC5->C5_MENNOT7)+"|"
		EndIf
		If !Empty(SC5->C5_MENNOT8)
			_cdescr += Alltrim(SC5->C5_MENNOT8)+"|"
		EndIf
		
		_cdescr := Substr(_cDescr,1,999)
//Else
	
		//	Alert( "Achei a nota")
	
ENDIF

SE1->(DbSetOrder(1))
SE1->(DbSeek(xFilial("SE1")+SF3->F3_SERIE+SF3->F3_NFISCAL))
While !SE1->(EOF("SE1")).And. SE1->E1_FILIAL==xFilial("SE1") .and. SE1->E1_NUM==SF3->F3_NFISCAL .and. SE1->E1_PREFIXO==SF3->F3_SERIE

	If (SE1->E1_TIPO == "NF " .AND. SE1->E1_IRRF > 0)
		_nValIrf += SE1->E1_IRRF		
	Endif
	If SE1->E1_TIPO == "CS-" 
		_nValCsl += SE1->E1_VALOR
	Endif                        

	If SE1->E1_TIPO == "PI-" 
		_nValPis += SE1->E1_VALOR
	Endif                        

	If SE1->E1_TIPO == "CF-"
		_nValCof += SE1->E1_VALOR
	Endif             
	
	If SE1->E1_TIPO == "IN-"
		_nValIns += SE1->E1_VALOR
	Endif             
	
	SE1->(dbSkip())
EndDo         

_nTotRet:=(_nValIrf+_nValCof+_nValPis+_nValCsl+_nValIns)           

SD2->(DbSetOrder(3))
SD2->(DbSeek(xFilial("SD2")+SF3->F3_NFISCAL+SF3->F3_SERIE))
SF2->(DbSetOrder(1))
SF2->(DbSeek(xFilial("SF2")+SF3->F3_NFISCAL+SF3->F3_SERIE))
SED->(DbSetOrder(1))
SED->(dbSeek(xFilial("SED")+SA1->A1_NATUREZ))

_cdescr+= "T. Retenção: R$" + Str(_nTotRet,14,2) + "  IRRF-" + Str(_nValIrf,14,2)+ "  CSLL-" + Str(_nValCsl,14,2)+"|"
_cdescr+= "COFINS-"+Str(_nValCof,14,2)+"  PIS-"+Str(_nValpIS,14,2)+ "|"+" INSS-"+Str(_nValIns,14,2)+ "|"
_cdescr := Substr(_cDescr,1,999)                                                                        
RestArea(aArea)
Return _cDescr
