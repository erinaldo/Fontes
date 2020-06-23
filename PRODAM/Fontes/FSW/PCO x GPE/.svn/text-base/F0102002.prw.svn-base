#INCLUDE 'PROTHEUS.CH'
#INCLUDE 'FWMVCDEF.CH'
/*/ {Protheus.doc} f0102002()

@Project     MAN00000011501_EF_020
@author      Jackson Capelato
@since       21/09/2015
@version     P12.5
@Return      Geração de Itens de Orçamento
@Obs         Preenche AK2
@menu		 Geração de Itens de Orcamento
/*/
User Function f0102002()
local cQuery  := ''
local lFarol  := .T.
local cPeriodo:=''
local cOld    :=''
local cGRP    :=''
local cID     :=''
local dPeIn   := dDatabase
local dPeFi   := dDatabase
local dPeReaj := dDatabase
local nPerct  := 0
local aORC    := {}
local aREL    := {}
local aStru   := {}
local aVLR    := {}
Local oReport
local nXX     := 0

Private cArqTemp := ''

IF Pergunte("FSW0102001",.T.)
	
	cQuery := " SELECT * FROM " + RetSqlName ("AK2") + " "
	cQuery += " WHERE D_E_L_E_T_ = '' AND AK2_ORCAME = '"+MV_PAR01+"' AND AK2_VERSAO = '"+MV_PAR02+"'  "
	
	Iif( Select("TRG1") > 0,TRG1->(dbCloseArea()),Nil)
	dbUseArea(.T.,"TOPCONN",TCGENQRY(,,cQuery),"TRG1",.F.,.T.)
	
	dbSelectArea("TRG1")
	dbgotop()
	
	IF !EOF()
		IF MsgYesNo("Esse Orçamento já existe - Recalcular?")
			cQuery := "DELETE FROM " + RetSqlName ("AK2") + " WHERE D_E_L_E_T_ = '' AND AK2_ORCAME = '"+MV_PAR01+"' AND AK2_VERSAO = '"+MV_PAR02+"'  "
			
			TCSQLExec(cQuery)
			
			cQuery := "COMMIT"
			
			TCSQLExec(cQuery)
			
			lFarol := .T.
		ELSE
			lFarol := .F.
		Endif
	Endif
	IF lFarol
		
		cQuery := " SELECT SUM(RC_VALOR) VALOR, RC_CC CUSTO,RC_PERIODO PERIODO, RV_XCTAORC CONTAO, RV_XGRUPO GRUPORC,RV_XATUALI CORRIGE "
		cQuery += " FROM " + RetSqlName ("SRV") + " A "
		cQuery += " INNER JOIN " + RetSqlName ("SRC") + " B ON RC_PD = RV_COD AND RC_PERIODO = '"+MV_PAR05+"' AND B.D_E_L_E_T_ = '' "
		cQuery += " WHERE RV_XCTAORC <> ''  AND A.D_E_L_E_T_ = '' "
		cQuery += " GROUP BY RC_CC ,RC_PERIODO, RV_XCTAORC , RV_XGRUPO,RV_XATUALI "
		
		Iif( Select("TRG2") > 0,TRG2->(dbCloseArea()),Nil)
		dbUseArea(.T.,"TOPCONN",TCGENQRY(,,cQuery),"TRG2",.F.,.T.)
		
		dbSelectArea("TRG2")
		dbgotop()
		
		IF EOF()
			cQuery := " SELECT SUM(RD_VALOR) VALOR, RD_CC CUSTO,RD_DATARQ PERIODO, RV_XCTAORC CONTAO, RV_XGRUPO GRUPORC,RV_XATUALI CORRIGE "
			cQuery += " FROM " + RetSqlName ("SRV") + " A "
			cQuery += " INNER JOIN " + RetSqlName ("SRD") + " B ON RD_PD = RV_COD  AND RD_DATARQ = '"+MV_PAR05+"' AND B.D_E_L_E_T_ = '' "
			cQuery += " WHERE RV_XCTAORC <> '' AND A.D_E_L_E_T_ = '' "
			cQuery += " GROUP BY RD_CC ,RD_DATARQ , RV_XCTAORC , RV_XGRUPO,RV_XATUALI "
			
			Iif( Select("TRG2") > 0,TRG2->(dbCloseArea()),Nil)
			dbUseArea(.T.,"TOPCONN",TCGENQRY(,,cQuery),"TRG2",.F.,.T.)
			
			dbSelectArea("TRG2")
			dbgotop()
		ENDIF
		IF EOF()
			ALERT('NAO EXISTE FOLHA NO PERIODO SELECIONADO')
		ELSE
			cID:='0001'
			cCO:= TRG2->CONTAO
			cOld:=TRG2->CUSTO
			cGRP:=TRG2->GRUPORC
			dPeIn:=CTOD('01'+SUBSTR(DTOC(MV_PAR03),3,8))
			dPeFi:=MV_PAR04
			DO WHILE !EOF()
				cQuery := " SELECT * FROM PA4990 WHERE D_E_L_E_T_ = '' AND PA4_CODGRU = '" +TRG2->GRUPORC + "' "
				Iif( Select("TRG3") > 0,TRG3->(dbCloseArea()),Nil)
				dbUseArea(.T.,"TOPCONN",TCGENQRY(,,cQuery),"TRG3",.F.,.T.)
				
				dbSelectArea("TRG3")
				dbgotop()
				
				dPeReaj:=CTOD('01/'+TRG3->PA4_PERIOD)
				nPerct :=(TRG3->PA4_PERCT/100)+1
				
				IF cOld#TRG2->CUSTO  .OR. cCO#TRG2->CONTAO .OR. cGRP#TRG2->GRUPORC
					cCO :=TRG2->CONTAO
					cOld:=TRG2->CUSTO 
					cGRP:=TRG2->GRUPORC
					cID:= STRZERO(VAL(cID)+1,4)
				ENDIF
				
				DO WHILE dPeFi >= dPeIn
					IF dPeIn < dPeReaj
						nVALOR:=TRG2->VALOR
					ELSE
					    IF TRG2->CORRIGE ='1'
						    nVALOR:=TRG2->VALOR*nPerct
						ELSE
							nVALOR:=TRG2->VALOR
						ENDIF   
					ENDIF
					
					IF nVALOR > 0
						AADD(aORC,{XFILIAL("AK2"),cID,MV_PAR01,MV_PAR02,TRG2->CONTAO,dPeIn ,TRG2->CUSTO   ,nVALOR , LASTDAY(dPeIn,0), dPeIn})
						AADD(aVLR,{dPeIn,nVALOR})
					ENDIF
					
					dPeIn:=dPeIn+31
					dPeIn:=CTOD('01'+SUBSTR(DTOC(dPeIn),3,8))
				ENDDO
				IF LEN(aVLR) > 0
					//           Conta Orc    C.Custo      Dt In        Dt Fim        Vlr 1.....
					AADD(aREL,{TRG2->CONTAO,TRG2->CUSTO,aVLR[01][01],aVLR[12][01],aVLR[01][02],aVLR[02][02],aVLR[03][02],aVLR[04][02],aVLR[05][02],aVLR[06][02],aVLR[07][02],aVLR[08][02],aVLR[09][02],aVLR[10][02],aVLR[11][02],aVLR[12][02]})
				ENDIF
				cOld:=TRG2->CUSTO
				cCO :=TRG2->CONTAO
				TRG2->(DBSKIP())
				dPeIn:=CTOD('01'+SUBSTR(DTOC(MV_PAR03),3,8))
				dPeFi:=MV_PAR04
				aVLR:={}
			ENDDO
			IF MV_PAR06 = 2
				FOR nXX := 1 TO LEN(aORC)
					DBSELECTAREA("AK2")
					AK2->( RecLock( "AK2" , .T. ) )
					AK2->AK2_FILIAL := aORC[nXX][01]
					AK2->AK2_ID     := aORC[nXX][02]
					AK2->AK2_ORCAME := aORC[nXX][03]
					AK2->AK2_VERSAO := aORC[nXX][04]
					AK2->AK2_CO     := aORC[nXX][05]
					AK2->AK2_PERIOD := aORC[nXX][06]
					AK2->AK2_CC		:= aORC[nXX][07]
					AK2->AK2_VALOR	:= aORC[nXX][08]
					AK2->AK2_DATAF  := aORC[nXX][09]
					AK2->AK2_DATAI  := aORC[nXX][10]
					AK2->(MsUnlock())
				NEXT
				
			ELSE
				
				aAdd( aStru, {"CTAORC"	, "C", TamSX3("AK2_CO")[1]   , 0})
				aAdd( aStru, {"CCUSTO"	, "C", TamSX3("AK2_CC")[1]   , 0})
				aAdd( aStru, {"DATAI"	, "D", 8, 0})
				aAdd( aStru, {"DATAF"	, "D", 8, 0})
				aAdd( aStru, {"VLR01"	, "N", TamSX3("AK2_VALOR")[1], 2})
				aAdd( aStru, {"VLR02"	, "N", TamSX3("AK2_VALOR")[1], 2})
				aAdd( aStru, {"VLR03"	, "N", TamSX3("AK2_VALOR")[1], 2})
				aAdd( aStru, {"VLR04"	, "N", TamSX3("AK2_VALOR")[1], 2})
				aAdd( aStru, {"VLR05"	, "N", TamSX3("AK2_VALOR")[1], 2})
				aAdd( aStru, {"VLR06"	, "N", TamSX3("AK2_VALOR")[1], 2})
				aAdd( aStru, {"VLR07"	, "N", TamSX3("AK2_VALOR")[1], 2})
				aAdd( aStru, {"VLR08"	, "N", TamSX3("AK2_VALOR")[1], 2})
				aAdd( aStru, {"VLR09"	, "N", TamSX3("AK2_VALOR")[1], 2})
				aAdd( aStru, {"VLR10"	, "N", TamSX3("AK2_VALOR")[1], 2})
				aAdd( aStru, {"VLR11"	, "N", TamSX3("AK2_VALOR")[1], 2})
				aAdd( aStru, {"VLR12"	, "N", TamSX3("AK2_VALOR")[1], 2})
				
				cArqTemp   := CriaTrab( aStru, .T. )
				
				dbUseArea(.T.,, cArqTemp, "cArqTemp", .T. )
				dbSelectArea( "cArqTemp" )
				
				FOR nXX := 1 TO LEN(aREL)
					
					RecLock( "cArqTemp", .T. )
					cArqTemp->CTAORC := aREL[nXX][01]
					cArqTemp->CCUSTO := aREL[nXX][02]
					cArqTemp->DATAI  := aREL[nXX][03]
					cArqTemp->DATAF  := aREL[nXX][04]
					cArqTemp->VLR01  := aREL[nXX][05]
					cArqTemp->VLR02  := aREL[nXX][06]
					cArqTemp->VLR03	 := aREL[nXX][07]
					cArqTemp->VLR04	 := aREL[nXX][08]
					cArqTemp->VLR05  := aREL[nXX][09]
					cArqTemp->VLR06  := aREL[nXX][10]
					cArqTemp->VLR07  := aREL[nXX][11]
					cArqTemp->VLR08  := aREL[nXX][12]
					cArqTemp->VLR09  := aREL[nXX][13]
					cArqTemp->VLR10  := aREL[nXX][14]
					cArqTemp->VLR11  := aREL[nXX][15]
					cArqTemp->VLR12  := aREL[nXX][16]
					cArqTemp->( msUnlock() )
				NEXT
				oReport := ReportDef()
				oReport:PrintDialog()
			ENDIF
		ENDIF
	ENDIF
ENDIF

RETURN

Static Function ReportDef()

Local oReport
Local oSection1
local aMeses := {"Janeiro","Fevereiro","Março","Abril","Maio","Junho","Julho","Agosto","Setembro","Outubro","Novembro","Dezembro"}

oReport:=TReport():New("F102002",'Previsao de Orcamento Folha',"",{|oReport| PrintReport(oReport)},'')
oReport:SetPortrait()

oSection1 := TRSection():New(oReport,'Orçamento',{"cArqTemp"},/*aOrdem*/,/*Campos do SX3*/,/*Campos do SIX*/)
oSection1:SetTotalInLine(.F.)
oSection1:SetHeaderBreak(.F.)
oSection1:lHeaderSection :=.f.

TRCell():New(oSection1,"CTAORC"  ,"cArqTemp","Cta Orc"          ,"9999999"     		 ,20,,)
TRCell():New(oSection1,"CCUSTO"  ,"cArqTemp","C.Custo"          ,"999999999"  		 ,20,,)
TRCell():New(oSection1,"VLR01"   ,"cArqTemp",aMeses[month(cArqTemp->DATAI)]  ,"@E 999,999,999.99"	,20,,)
TRCell():New(oSection1,"VLR02"   ,"cArqTemp", aMeses[month(cArqTemp->DATAI)+1],"@E 999,999,999.99"	,20,,)
TRCell():New(oSection1,"VLR03"   ,"cArqTemp", aMeses[month(cArqTemp->DATAI)+2],"@E 999,999,999.99"	,20,,)
TRCell():New(oSection1,"VLR04"   ,"cArqTemp", aMeses[month(cArqTemp->DATAI)+3],"@E 999,999,999.99" ,20,,)
TRCell():New(oSection1,"VLR05"   ,"cArqTemp", aMeses[month(cArqTemp->DATAI)+4],"@E 999,999,999.99" ,20,,)
TRCell():New(oSection1,"VLR06"   ,"cArqTemp", aMeses[month(cArqTemp->DATAI)+5],"@E 999,999,999.99" ,20,,)
TRCell():New(oSection1,"VLR07"   ,"cArqTemp", aMeses[month(cArqTemp->DATAI)+6],"@E 999,999,999.99" ,20,,)
TRCell():New(oSection1,"VLR08"   ,"cArqTemp", aMeses[month(cArqTemp->DATAI)+7],"@E 999,999,999.99" ,20,,)
TRCell():New(oSection1,"VLR09"   ,"cArqTemp", aMeses[month(cArqTemp->DATAI)+8],"@E 999,999,999.99" ,20,,)
TRCell():New(oSection1,"VLR10"   ,"cArqTemp", aMeses[month(cArqTemp->DATAI)+9],"@E 999,999,999.99" ,20,,)
TRCell():New(oSection1,"VLR11"   ,"cArqTemp", aMeses[month(cArqTemp->DATAI)+10],"@E 999,999,999.99",20,,)
TRCell():New(oSection1,"VLR12"   ,"cArqTemp", aMeses[month(cArqTemp->DATAI)+11],"@E 999,999,999.99",20,,)

Return oReport


Static Function PrintReport(oReport)

Local oSection1 := oReport:Section(1)

Local nPos		:= 0

oReport:SetTitle('Reajuste Tabela de Gratificações de Funções')

dbSelectArea("cArqTemp")
dbGotop()

DO While cArqTemp->( !Eof() )
	
	oReport:IncMeter()
	
	If oReport:Cancel()
		Exit
	EndIf
	if nPos # osection1:oreport:opage:npage
	   oSection1:lHeaderSection := .t.
	   nPos+=1
    else 
       oSection1:lHeaderSection :=.f.
    endif
	oSection1:Init()
	oSection1:PrintLine()
	
	oreport:Thinline()
	oSection1:Finish()
	dbSelectArea("cArqTemp")
	cArqTemp->(dbSkip())
EndDo
dbclosearea("cArqTemp")
Return