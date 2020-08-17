#INCLUDE "PROTHEUS.CH"
#INCLUDE "TBICONN.CH"

User Function TESTEROBO()
Return (u_MCTBROBO())

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡ao    ³ MCTBROBO ³ Autor ³ Carlos Tagliaferri Jr ³ Data ³ Mar/11   ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³Chamada para execucao via Schedulle da Planilha Razao       ³±±
±±³          |compras (Razario)                                           ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³ Especifico CSU                                             ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

User Function MCTBROBO()

Local _cContaI := ""
Local _cContaF := ""
Local _dDataIni  := Ctod("  /  /  ")
Local _dDataFim  := Ctod("  /  /  ")       
Local _lNoMov    := .T.
Local _dAdmDe    := Ctod("  /  /  ")
Local _dAdmAt    := Ctod("  /  /  ")
Local _cCCusDe   := ""
Local _cCCusAt   := ""
Local _cSituac   := ""
local _dDemde    := Ctod("  /  /  ")
Local _dDemAt    := Ctod("  /  /  ")

PREPARE ENVIRONMENT EMPRESA "05" FILIAL "01" MODULO "CTB"

	DbSelectArea("SX5")            
	dbSetOrder(1)
	dbSeek(xFilial("SX5") + "ZK" + "DADMDE")
	_dAdmde  := Ctod(X5Descri())
	dbSeek(xFilial("SX5") + "ZK" + "DADMAT")
	_dAdmAt := Ctod(X5Descri())
	dbSeek(xFilial("SX5") + "ZK" + "CCCUDE")
	_cCCusDe := Left(X5Descri(),20)
	dbSeek(xFilial("SX5") + "ZK" + "CCCUAT")
	_cCCusAt := Left(X5Descri(),20)
	dbSeek(xFilial("SX5") + "ZK" + "SITUAC")
	_cSituac := Left(X5Descri(),5)
	dbSeek(xFilial("SX5") + "ZK" + "DTDMDE")
	_dDemde  := Ctod(X5Descri())
	dbSeek(xFilial("SX5") + "ZK" + "DTDMAT")
	_dDemAt := Ctod(X5Descri())    


	U_CSARQAUTO(_dAdmde,_dAdmAt,_cCCusDe,_cCCusAt,_cSituac,_dDemde,	_dDemAt) 

	dbSelectArea("SX5")            
	dbSetOrder(1)
	dbSeek(xFilial("SX5") + "ZE" + "CTAINI")
	_cContaI := Left(X5Descri(),20)
	dbSeek(xFilial("SX5") + "ZE" + "CTAFIM")
	_cContaF := Left(X5Descri(),20)
	dbSeek(xFilial("SX5") + "ZE" + "DTAINI")
	_dDataIni := Ctod(X5Descri())
	dbSeek(xFilial("SX5") + "ZE" + "DTAFIM")
	_dDataFim := Ctod(X5Descri())
	dbSeek(xFilial("SX5") + "ZE" + "NAOMOV") // OS 0821-11 Incluir pergunta Imprimir Conta Sem Movimento
	_lNoMov := X5Descri() == "SIM"
	
	//_dDataIni := FirstDay(FirstDay(dDataBase) - 1)
	//_dDataFim := LastDay(_dDataIni)
	
//	U_yCTBR400(_cContaI,_cContaF,_dDataIni,_dDataFim,"01","1","   ",.T.,"         ","ZZZZZZZZZ",.T.,"         ","ZZZZZZZZZ",.T.,"         ","ZZZZZZZZZ",.T.,_lNoMov)
		U_RAZARIO(_cContaI,_cContaF,_dDataIni,_dDataFim,"01","1","   ",.T.,"         ","ZZZZZZZZZ",.T.,"         ","ZZZZZZZZZ",.T.,"         ","ZZZZZZZZZ",.T.,_lNoMov)
    

	

RESET ENVIRONMENT

Return




/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡ao    ³ MCFGROBO ³ Autor ³ Carlos Tagliaferri Jr ³ Data ³ Mar/11   ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³Gravacao dos parametros de execucao automatica da planilha  ³±±  
±±³          |Razao Compras (Razario)                                     ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³ Especifico CSU                                             ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/


User Function MCFGROBO()
                                                       
Local oDlg                      
Local oCombo
Local _lRet    := .F.
Local _cContaI := Space(20)
Local _cContaF := Space(20)
Local _dDataI  := Stod(Space(8))
Local _dDataF  := Stod(Space(8))
Local _cNoMov  := Space(3)
Local _aCombo  := {"SIM","NAO"}

dbSelectArea("SX5")            
dbSetOrder(1)
dbSeek(xFilial("SX5") + "ZE" + "CTAINI")
_cContaI := Left(X5Descri(),20)
dbSeek(xFilial("SX5") + "ZE" + "CTAFIM")
_cContaF := Left(X5Descri(),20)
dbSeek(xFilial("SX5") + "ZE" + "DTAINI")
_dDataI := Ctod(X5Descri())
dbSeek(xFilial("SX5") + "ZE" + "DTAFIM")
_dDataF := Ctod(X5Descri())
dbSeek(xFilial("SX5") + "ZE" + "NAOMOV") // OS 0821-11 Incluir pergunta Imprimir Conta Sem Movimento
_cNoMov := X5Descri()

DEFINE MSDIALOG oDlg TITLE "Configuração Razario" FROM 0,0 TO 300,552 OF oDlg PIXEL

@ 15, 15 SAY "Conta Inicio:" SIZE 45,8 PIXEL OF oDlg
@ 15, 85 MSGET _cContaI SIZE 80,10 PIXEL OF oDlg

@ 35, 15 SAY "Conta Fim:" SIZE 45,8 PIXEL OF oDlg
@ 35, 85 MSGET _cContaF SIZE 80,10 PIXEL OF oDlg

@ 55, 15 SAY "Data Inicio:" SIZE 45,8 PIXEL OF oDlg
@ 55, 85 MSGET  _dDataI SIZE 80,10 PIXEL OF oDlg

@ 75,15 SAY "Data Fim:"  SIZE 65,8 PIXEL OF oDlg
@ 75,85 MSGET _dDataF SIZE 80,10 PIXEL OF oDlg

@ 95,15 SAY "Imp. Conta S/Movto.:"  SIZE 65,8 PIXEL OF oDlg
@ 95,85 COMBOBOX oCombo VAR _cNoMov ITEMS _aCombo SIZE 80,10 PIXEL OF oDlg

@ 113,235 BUTTON "&Ok"       SIZE 36,16 PIXEL ACTION (_lRet:=.T., oDlg:End())
@ 133,235 BUTTON "&Cancelar" SIZE 36,16 PIXEL ACTION (_lRet:=.F., oDlg:End())

ACTIVATE MSDIALOG oDlg CENTER

                              
If _lRet
	dbSelectArea("SX5")            
	dbSetOrder(1)
	dbSeek(xFilial("SX5") + "ZE" + "CTAINI")
	RecLock("SX5",.F.)
		Replace X5_DESCRI  With _cContaI
		Replace X5_DESCSPA With _cContaI
		Replace X5_DESCENG With _cContaI
	MsUnlock()		
	
	dbSeek(xFilial("SX5") + "ZE" + "CTAFIM")
	RecLock("SX5",.F.)
		Replace X5_DESCRI  With _cContaF
		Replace X5_DESCSPA With _cContaF
		Replace X5_DESCENG With _cContaF
	MsUnlock()		

	dbSeek(xFilial("SX5") + "ZE" + "DTAINI")
	RecLock("SX5",.F.)
		Replace X5_DESCRI  With Dtoc(_dDataI)
		Replace X5_DESCSPA With Dtoc(_dDataI)
		Replace X5_DESCENG With Dtoc(_dDataI)
	MsUnlock()		

	dbSeek(xFilial("SX5") + "ZE" + "DTAFIM")
	RecLock("SX5",.F.)
		Replace X5_DESCRI  With Dtoc(_dDataF)
		Replace X5_DESCSPA With Dtoc(_dDataF)
		Replace X5_DESCENG With Dtoc(_dDataF)
	MsUnlock()		

	dbSeek(xFilial("SX5") + "ZE" + "NAOMOV")
	RecLock("SX5",.F.)
		Replace X5_DESCRI  With _cNoMov
		Replace X5_DESCSPA With _cNoMov
		Replace X5_DESCENG With _cNoMov
	MsUnlock()		
EndIf

Return



/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡ao    ³ MCFGHC   ³ Autor ³ Renato Carlos         ³ Data ³ Mar/11   ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³Gravacao dos parametros de execucao automatica do Head Count³±±  
±±³          |Razao Compras (Razario)                                     ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³ Especifico CSU                                             ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/


User Function MCFGHC()

Local cPerg    := PADR("CFGHC",LEN(SX1->X1_GRUPO))
Local aRegs    := {} 

																										
aAdd(aRegs,{cPerg,'01','Data Admissao De       ?','','','mv_ch1','D',08,0,0,'G','           ','mv_par01',"","","","","","","","","","","","","","","","","","","","","","","","","","","","","",""})
aAdd(aRegs,{cPerg,'02','Data Admissao Ate      ?','','','mv_ch2','D',08,0,0,'G','           ','mv_par02',"","","","","","","","","","","","","","","","","","","","","","","","","","","","","",""})
aAdd(aRegs,{cPerg,'03','Centro de Custo De     ?','','','mv_ch3','C',20,0,0,'G','           ','mv_par03',"","","","","","","","","","","","","","","","","","","","","","","","","CTT","","","","",""})
aAdd(aRegs,{cPerg,'04','Centro de Custo Ate    ?','','','mv_ch4','C',20,0,0,'G','           ','mv_par04',"","","","","","","","","","","","","","","","","","","","","","","","","CTT","","","","",""})
aAdd(aRegs,{cPerg,'05','Situacoes              ?','','','mv_ch5','C',05,0,0,'G','fSituacao  ','mv_par05',"","","","","","","","","","","","","","","","","","","","","","","","","","","","","",""})
aAdd(aRegs,{cPerg,'06','Data Demissao De       ?','','','mv_ch6','D',08,0,0,'G','           ','mv_par06',"","","","","","","","","","","","","","","","","","","","","","","","","","","","","",""})
aAdd(aRegs,{cPerg,'07','Data Demissao Ate      ?','','','mv_ch7','D',08,0,0,'G','           ','mv_par07',"","","","","","","","","","","","","","","","","","","","","","","","","","","","","",""})

U_ValidPerg( cPerg, aRegs )

If Pergunte(cPerg,.t.)
	dbSelectArea("SX5")            
	dbSetOrder(1)
	dbSeek(xFilial("SX5") + "ZK" + "DADMDE")
	RecLock("SX5",.F.)
		Replace X5_DESCRI  With Dtoc(MV_PAR01)
		Replace X5_DESCSPA With Dtoc(MV_PAR01)
		Replace X5_DESCENG With Dtoc(MV_PAR01)
	MsUnlock()		
	
	dbSeek(xFilial("SX5") + "ZK" + "DADMAT")
	RecLock("SX5",.F.)
		Replace X5_DESCRI  With Dtoc(MV_PAR02)
		Replace X5_DESCSPA With Dtoc(MV_PAR02)
		Replace X5_DESCENG With Dtoc(MV_PAR02)
	MsUnlock()		

	dbSeek(xFilial("SX5") + "ZK" + "CCCUDE")
	RecLock("SX5",.F.)
		Replace X5_DESCRI  With MV_PAR03
		Replace X5_DESCSPA With MV_PAR03
		Replace X5_DESCENG With MV_PAR03
	MsUnlock()		

	dbSeek(xFilial("SX5") + "ZK" + "CCCUAT")
	RecLock("SX5",.F.)
		Replace X5_DESCRI  With MV_PAR04
		Replace X5_DESCSPA With MV_PAR04
		Replace X5_DESCENG With MV_PAR04
	MsUnlock()		

	dbSeek(xFilial("SX5") + "ZK" + "SITUAC")
	RecLock("SX5",.F.)
		Replace X5_DESCRI  With MV_PAR05
		Replace X5_DESCSPA With MV_PAR05
		Replace X5_DESCENG With MV_PAR05
	MsUnlock()
	
	dbSeek(xFilial("SX5") + "ZK" + "DTDMDE")
	RecLock("SX5",.F.)
		Replace X5_DESCRI  With Dtoc(MV_PAR06)
		Replace X5_DESCSPA With Dtoc(MV_PAR06)
		Replace X5_DESCENG With Dtoc(MV_PAR06)
	MsUnlock()
	
	dbSeek(xFilial("SX5") + "ZK" + "DTDMAT")
	RecLock("SX5",.F.)
		Replace X5_DESCRI  With Dtoc(MV_PAR07)
		Replace X5_DESCSPA With Dtoc(MV_PAR07)
		Replace X5_DESCENG With Dtoc(MV_PAR07)
	MsUnlock()
	
	
EndIf

Return