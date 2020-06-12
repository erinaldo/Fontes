#INCLUDE "rwmake.ch"    
#include "topconn.ch"
#include "protheus.ch"


/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณAFINRATEIO  บ Autor ณ Patricia Fontaneziบ Data ณ  14/06/12   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDescricao ณ Fun็ใo chamada na Validacao Sistema            (AFIN050TP) บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ CIEE                                                       บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿*/

User Function AFINRATEIO()  

Private _cForn 			:= M->PA9_FORNEC 
Private _cFornNome		    
Private _CNUM2			:= M->PA9_NUM
Private _cLoja			:= M->PA9_LOJA
Private _cPrefixo		:= M->PA9_PREFIX
Private _cVlTit			:= M->PA9_VALOR  
Private _cItemC
Private _cCCC
Private _cItemD
Private _cCCD
Private aArea  	  		:= GetArea()
Private aSize      		:= MsAdvSize()    
Private oGet 
Private oMSNewGetDados3    
Private _cLinhaok		:= .T.  
Private _cTudook		:= .T.
Private _aTmp 			:= {} 																	// Arquivo temporario
Private aFieldFill3 	:= {} 
Private aCols			:= {} 
Private aHeader			:= {}
Private aFields3 		:= {"PAA_ITEMD","PAA_CCD","PAA_ITEMC","PAA_CCC","PAA_CTACON","PAA_CTACOC","PAA_VALOR","PAA_HIST"}  // campos do mbrowse
Private aAlterFields3 	:= {"PAA_ITEMD","PAA_CCD","PAA_ITEMC","PAA_CCC","PAA_CTACON","PAA_CTACOC","PAA_VALOR","PAA_HIST"}  // campos que poderao ser alterados
Private _cNumRat		:= "" 

If M->PA9_RATEIO == 'S'   
	If Empty(M->PA9_VALOR)
		Alert("Preencha o campo Valor") 
		Return(.F.)
	ElseIf Empty(M->PA9_NUM)
		Alert("Preencha o campo Titulo")  
		Return(.F.) 
	ElseIf Empty(M->PA9_FORNEC)
		Alert("Preencha o campo Fornecedor")  
		Return(.F.)
	Else	
		DM001INC()	
	Endif	
Endif 

//TMP->(DbCloseArea())
//DbCloseArea("TCIEE")
Return(.T.)

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณDM001INC  บAutor  ณPatricia Fontanezi  บ Data ณ  14/06/12   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ                                                            บฑฑ
ฑฑบ          ณ Tela MSNEWGETDADOS com Dados do Rateio (PAA)               บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ AP                                                        บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

Static Function DM001INC( cAlias, nReg, nOpcx )

Static oMkwdlg
Static oDlg
Local oComboBo1 
Private _nVLRAT	:= 0  
Private onSaldoD:= 0   
Private _nVLRAT	:= 0

DBSELECTAREA("SA2")
DBGOTOP()
DBSETORDER(1)
If Dbseek(xFilial("SA2")+alltrim(_cForn))
	_cFornNome	:= SA2->A2_NOME	
Endif 

//aInfo := { aSize[ 1 ], aSize[ 2 ], aSize[ 3 ], aSize[ 4 ], 3, 3 }  
//aFolder		:= {"Rateio", "Inclusใo Tํtulos a Pagar"}  
/*_nSFld1		:= 122 //Linha Inicial
_nSFld2		:= 630 //Coluna Final
_nSFld3		:= 290 //Linha Final

_aSize  := MsAdvSize()
aObjects:= {}
aPosObj :={}

aInfo   := {_aSize[1],_aSize[2],_aSize[3],_aSize[4],3,3}

AADD(aObjects,{100,030,.T.,.F.,.F.})
AADD(aObjects,{100,100,.T.,.T.,.F.})

aPosObj:=MsObjSize(aInfo, aObjects)

oFolder		:= TFolder():New(_nSFld1,1,,{},oDlg,,,, .T., .F.,aPosObj[2,4]-5,aPosObj[2,3]-120,) */
//Montagem de Browse para interface com o usuario
DEFINE FONT 	oBold NAME "Arial" 				SIZE 0, -13 BOLD
DEFINE FONT 	oFnt  NAME "Times New Roman" 	SIZE 0, 32

DEFINE MSDIALOG oDlg TITLE "RATEIOS"  From aSize[7],0 To aSize[6],aSize[5] COLORS 0, 16777215 PIXEL // era de 000,000 a 500,500
//primeira coluna 
@ 005, 003 SAY oSay1 PROMPT "Fornecedor" SIZE 030, 010  OF oDlg COLORS 0, 16777215 PIXEL
@ 012, 004 MSGET oGet1 VAR _cForn When .f.  SIZE 045, 010 OF oDlg COLORS 0, 16777215 PIXEL

//@ 005, 003 SAY oSay1 PROMPT "Fornecedor" SIZE 030, 010  OF oDlg COLORS 0, 16777215 PIXEL

@ 005, 070 SAY oSay4 PROMPT "Loja" SIZE 030, 007 OF oDlg COLORS 0, 16777215 PIXEL
@ 012, 070 MSGET oGet2 VAR _cLoja WHEN .F. SIZE 020, 010 OF oDlg COLORS 0, 16777215 PIXEL 

@ 012, 110 MSGET oGet1 VAR _cFornNome When .f.  SIZE 330, 010 OF oDlg COLORS 0, 16777215 PIXEL

@ 026, 003 SAY oSay2 PROMPT "Titulo" SIZE 030, 010 OF oDlg COLORS 0, 16777215 PIXEL
@ 033, 003 MSGET oGet3 VAR _cNum2 WHEN .F.  SIZE 030, 010 OF oDlg COLORS 0, 16777215 PIXEL

@ 026, 070 SAY oSay3 PROMPT "Prefixo" SIZE 051, 010 OF oDlg COLORS 0, 16777215 PIXEL
@ 033, 070 MSGET oGet4 VAR _cPrefixo When .f.  SIZE 020, 010 OF oDlg COLORS 0, 16777215 PIXEL   

@ 026, 110 SAY oSay3 PROMPT "Valor Titulo" SIZE 051, 010 OF oDlg COLORS 0, 16777215 PIXEL
@ 033, 110 MSGET oGet4 VAR _cVlTit Picture '@e 999,999,999.99' When .f.  SIZE 050, 010 OF oDlg COLORS 0, 16777215 PIXEL   

@ 026, 175 SAY oSay4 PROMPT "Somat๓rio Rateio" SIZE 051, 010 OF oDlg COLORS 0, 16777215 PIXEL
@ 033, 175 MSGET onSALDOD VAR _nVLRAT Picture '@e 999,999,999.99' When .f.  SIZE 050, 010 OF oDlg COLORS 0, 16777215 PIXEL   

/*@ 026, 160 SAY "Total Rateio : " of oFolder:aDialogs[1] PIXEL
@ 033, 160 SAY onSALDOD VAR _nVLRAT of oFolder:aDialogs[1]  Picture "@E 99,999,999.99" SIZE 60,40 PIXEL   */



NGetDs3()

DEFINE SBUTTON oSButton1 FROM 260, 245 TYPE 01 ACTION (nOpca:=1,GravaPAA()) OF oDlg ENABLE     //VERIFICAR SE TEM COMO GRAVAR SOMENTE QUANDO CONFIRMAR NO BOTAO ok DA INCLUSAO DE TITULOS
DEFINE SBUTTON oSButton2 FROM 260, 285 TYPE 02 ACTION (nOpca:=0,oDlg:End()) OF oDlg ENABLE


ACTIVATE MSDIALOG oDlg CENTERED  

/*
If nOpca == 0   
	M->PA9_RATEIO	:= "N"
Endif
*/ 
Return()


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณNGetDs3  บAutor  ณPatricia Fontanezi  บ Data ณ  14/06/12   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ                                                            บฑฑ
ฑฑบ          ณ Montagem do MsNewGetDados                                  บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ AP                                                        บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

Static Function NGetDs3()

Local _cQR	:= ""

aCols			:= {}     
aCols1			:= {} 
//Verifica se ja existe o Titulo e tras os Acols com o conteudo existente
_cNumPAA	:= M->PA9_NUM 

DbSelectArea("SX3")
SX3->(DbSetOrder(2))
For nX := 1 to Len(aFields3)
	If SX3->(DbSeek(aFields3[nX]))
		Aadd(aHeader, {AllTrim(SX3->X3_TITULO),SX3->X3_CAMPO,SX3->X3_PICTURE,SX3->X3_TAMANHO,SX3->X3_DECIMAL,SX3->X3_VALID,;
		SX3->X3_USADO,SX3->X3_TIPO,SX3->X3_F3,SX3->X3_CONTEXT,SX3->X3_CBOX,SX3->X3_RELACAO})
	Endif
Next nX

// Define field values
For nX := 1 to Len(aFields3)
	If DbSeek(aFields3[nX])
		Aadd(aFieldFill3, CRIAVAR(SX3->X3_CAMPO))
	Endif
Next nX

/*DbSelectArea("PAA")	
PAA->(DbSetOrder(3))  
DBGOTOP()	
If Dbseek(xfilial("PAA")+ Alltrim(M->PA9_NUM +M->PA9_PREFIX + M->PA9_FORNEC + M->PA9_LOJA))
	While !EOF() .AND. M->PA9_NUM == _cNumPAA
   		AADD(aCols,{PAA->PAA_ITEMD,PAA->PAA_CCD,PAA->PAA_ITEMC,PAA->PAA_CCC,PAA->PAA_CTACON, PAA->PAA_CTACOC,PAA->PAA_VALOR,.F.})
   		_cNumPAA	:= PAA->PAA_TITULO
   		PAA->(DbSKIP())
 	Enddo
Endif*/

_cQR := " SELECT * FROM " + retsqlname("PAA") 
_cQR += " WHERE PAA_TITULO = '"+M->PA9_NUM+"' AND PAA_PREFIX = '"+M->PA9_PREFIX+"' AND PAA_FORNEC = '"+M->PA9_FORNEC+"' AND "
_cQR += retsqlname("PAA") + ".D_E_L_E_T_ = ' ' AND PAA_FILIAL = '"+xFilial("PAA")+"' "

If SELECT("QRY") > 0
	QRY->(DBCLOSEAREA())
Endif

_cQR := ChangeQuery(_cQR)
DbUsearea(.T.,"TOPCONN",TCGENQRY(,,_cQR),"QRY",.F.,.T.)

DbselectArea("QRY")
While QRY->(!EOF())   
	AADD(aCols,{QRY->PAA_ITEMD,QRY->PAA_CCD,QRY->PAA_ITEMC,QRY->PAA_CCC,QRY->PAA_CTACON, QRY->PAA_CTACOC,QRY->PAA_VALOR,QRY->PAA_HIST,.F.})
	QRY->(DBSKIP())
Enddo 

if len(aCols) == 0
	Aadd(aFieldFill3, .F.)
	Aadd(aCols, aFieldFill3) 
endif   

oGet := MsNewGetDados():New( 70, 010, 240, 650, GD_INSERT+GD_DELETE+GD_UPDATE, "U_LinhaOK()", "AllwaysTrue", "", aAlterFields3,, 999, "AllwaysTrue",,"u_delCONTCD()",oDlg, aHeader, aCols)

Return 

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณGravaPAA  บAutor  ณPatricia Fontanezi  บ Data ณ  14/06/12   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ Grava os dados digitados no MSGetdados numa Tabela Temporariaบฑฑ
ฑฑบ          ณ 				                                              บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ AP                                                        บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

Static Function GravaPAA() 

Local _nz		:= 0 
Local _na		:= 0
Private _cTudoOK	:= .T.	 

_cTudook	:= TUDOOK()
//-----------------------------------------
// Prepara Arquivo Temporario
//-----------------------------------------

If _cTudoOK 
	
	If SELECT("TCIEE")>0 	
		DbSelectArea("PAA")	
		PAA->(DbSetOrder(3))  	
	   	If Dbseek(xfilial("PAA")+ Alltrim(TCIEE->xNum +TCIEE->xPref +TCIEE->xForn + TCIEE->xLoja))
			While PAA->(!EOF()) .and. Alltrim(TCIEE->xNum +TCIEE->xPref +TCIEE->xForn + TCIEE->xLoja) == PAA->(PAA_TITULO+PAA_PREFIX+PAA_FORNEC+PAA_LOJA)
				PAA->(RecLock("PAA",.F.)) 
				DBDELETE()
				PAA->(MSUNLOCK()) 
				PAA->(DBSKIP())   
			Enddo
		Endif   			
		TCIEE->(DBCLOSEAREA())
		FErase(CARQ+".DBF")   
	Endif

	aAdd(_aTmp,{"xITEMD"	,"C", 09,0})
	aAdd(_aTmp,{"xCCD"		,"C", 09,0})
	aAdd(_aTmp,{"xITEMC"	,"C", 09,0})
	aAdd(_aTmp,{"xCCC"		,"C", 09,0})  
	aAdd(_aTmp,{"xCtaCon"  	,"C", 20,0})
	aAdd(_aTmp,{"xCtaCoc"  	,"C", 20,0})
	aAdd(_aTmp,{"xVALOR"   	,"N", 17,2}) 
	aAdd(_aTmp,{"xNum"   	,"C", 09,0})
	aAdd(_aTmp,{"xForn"   	,"C", 06,0}) 
	aAdd(_aTmp,{"xLoja"   	,"C", 02,0})
	aAdd(_aTmp,{"xPref"   	,"C", 03,0})
	aAdd(_aTmp,{"xHIST"   	,"C", 40,0})
	
	cArq	:= Criatrab(_aTmp,.T.)  
	//-----------------------------------------
	// Cria Arquivo Temporario
	//-----------------------------------------   
	dbUseArea(.T., "DBFCDX",  cArq,"TCIEE",.T.,.F.)    
	
	//-----------------------------------------
	// Copia dados para Arquivo Temporario
	//-----------------------------------------
	DbSelectArea("TCIEE")
	DbGotop()
	For _na	:= 1 To Len(oGet:aCols)
		If oGet:aCols[_na][9] <> .T.    	//Verifica se o aCols foi deletado (.T. = Deletado)
		 	DbSelectArea("TCIEE")
		  	RecLock("TCIEE",.T.)
		   	TCIEE->xITEMD	:= oGet:aCols[_na][1]  
		   	TCIEE->xCCC		:= oGet:aCols[_na][4] 
		   	TCIEE->xITEMC	:= oGet:aCols[_na][3] 
		   	TCIEE->xCCD     := oGet:aCols[_na][2] 
		   	TCIEE->xCTACON	:= oGet:aCols[_na][5] 
		   	TCIEE->xVALOR	:= oGet:aCols[_na][7]   
		   	TCIEE->xCTACOC	:= oGet:aCols[_na][6] 
		   	TCIEE->xNum		:= _CNUM2
		   	TCIEE->xForn	:= _cForn
		   	TCIEE->xLoja	:= _cLoja
		   	TCIEE->xPref	:= _cPrefixo
		   	TCIEE->xHIST	:= oGet:aCols[_na][8] 
		   	MsUnlock() 
		   	
		   	If !Empty(oGet:aCols[_na][3]) .AND. Empty(oGet:aCols[_na][1])  		   	
			   	DbSelectArea("TCIEE")
				dBGOTOP()			
				DbSelectArea("PAA")		
				PAA->(DbSetOrder(4))  			
				If !Dbseek(xfilial("PAA")+ Alltrim(_CNUM2 + _cPrefixo +_cForn + _cLoja + oGet:aCols[_na][3] + oGet:aCols[_na][4]))    //ITEM CONTABIL CREDITO
				    PAA->(RecLock("PAA",.T.))
					PAA->PAA_ITEMD	:= oGet:aCols[_na][1] //aCols[_nz][1]
					PAA->PAA_CCD	:= oGet:aCols[_na][2]  //aCols[_nz][2]
					PAA->PAA_ITEMC	:= oGet:aCols[_na][3] 
					PAA->PAA_CCC	:= oGet:aCols[_na][4] 
					PAA->PAA_VALOR	:= oGet:aCols[_na][7]   
					PAA->PAA_CTACON	:= oGet:aCols[_na][5] 
					PAA->PAA_CTACOC := oGet:aCols[_na][6] 
					PAA->PAA_TITULO	:= _cNUM2
					PAA->PAA_PREFIX := _cPrefixo
					PAA->PAA_FORNEC	:= TCIEE->xForn
					PAA->PAA_LOJA	:= _cLoja  
					PAA->PAA_FILIAL	:= xFilial("PAA")
					PAA->PAA_HIST	:= oGet:aCols[_na][8] 
					PAA->(MsUnlock()) 		   
				   
				Endif   			   	
			//Endif
			
			ElseIf !Empty(oGet:aCols[_na][1]) .AND. Empty(oGet:aCols[_na][3])  
				DbSelectArea("TCIEE")
				dBGOTOP()			
				DbSelectArea("PAA")		
				PAA->(DbSetOrder(5))  			
				If !Dbseek(xfilial("PAA")+ Alltrim(_CNUM2 + _cPrefixo +_cForn + _cLoja + oGet:aCols[_na][1] + oGet:aCols[_na][2]))    //ITEM CONTABIL CREDITO
				    PAA->(RecLock("PAA",.T.))
					PAA->PAA_ITEMD	:= oGet:aCols[_na][1] //aCols[_nz][1]
					PAA->PAA_CCD	:= oGet:aCols[_na][2]  //aCols[_nz][2]
					PAA->PAA_ITEMC	:= oGet:aCols[_na][3] 
					PAA->PAA_CCC	:= oGet:aCols[_na][4] 
					PAA->PAA_VALOR	:= oGet:aCols[_na][7]   
					PAA->PAA_CTACON	:= oGet:aCols[_na][5] 
					PAA->PAA_CTACOC := oGet:aCols[_na][6] 
					PAA->PAA_TITULO	:= _cNUM2
					PAA->PAA_PREFIX := _cPrefixo
					PAA->PAA_FORNEC	:= TCIEE->xForn
					PAA->PAA_LOJA	:= _cLoja  
					PAA->PAA_FILIAL	:= xFilial("PAA")
					PAA->PAA_HIST	:= oGet:aCols[_na][8]
					PAA->(MsUnlock()) 
				Endif
			Else
		  		DbSelectArea("TCIEE")
				dBGOTOP()			
				DbSelectArea("PAA")		
				PAA->(DbSetOrder(5))  			
				If !Dbseek(xfilial("PAA")+ Alltrim(_CNUM2 + _cPrefixo +_cForn + _cLoja + oGet:aCols[_na][1] + oGet:aCols[_na][2]))    //ITEM CONTABIL DEBITO
				    PAA->(RecLock("PAA",.T.))
					PAA->PAA_ITEMD	:= oGet:aCols[_na][1] //aCols[_nz][1]
					PAA->PAA_CCD	:= oGet:aCols[_na][2]  //aCols[_nz][2]
					PAA->PAA_ITEMC	:= oGet:aCols[_na][3] 
					PAA->PAA_CCC	:= oGet:aCols[_na][4] 
					PAA->PAA_VALOR	:= oGet:aCols[_na][7]   
					PAA->PAA_CTACON	:= oGet:aCols[_na][5] 
					PAA->PAA_CTACOC := oGet:aCols[_na][6] 
					PAA->PAA_TITULO	:= _cNUM2
					PAA->PAA_PREFIX := _cPrefixo
					PAA->PAA_FORNEC	:= TCIEE->xForn
					PAA->PAA_LOJA	:= _cLoja  
					PAA->PAA_FILIAL	:= xFilial("PAA")
					PAA->PAA_HIST	:= oGet:aCols[_na][8] 
					PAA->(MsUnlock()) 
				Endif				
			Endif
			   	
		Endif
	Next     
	oDLG:End()
Endif	
	   	
Return()
 

//********************************************************
//********************************************************
//Validacao do Tudo OK dentro do MSGetDados
//********************************************************
//********************************************************

User Function LinhaOK()

Local n2   	   		:= 0     
Local _nVl			:= 0 
Local _nTotal		:= 0
Private _cLinhaok	:= .T.

For n2 := 1 To Len(aCols) 
	If oGet:aCols[n2][9] <> .T.    	//Verifica se o aCols foi deletado (.T. = Deletado)
		If empty(oGet:aCols[n2][1]) .AND. empty(oGet:aCols[n2][3])  			
			MSGINFO("Necessแrio o preenchimento de um dos Itens Contแbeis")
			_cLinhaok	:= .F.
			Exit
		Endif 
		
		If !empty(oGet:aCols[n2][1]).AND. empty(oGet:aCols[n2][2])
			DbSelectArea("CT1") 					
			CT1->(DbSetOrder(1))
			dBGOTOP()
			If DbSeek(xFilial("CT1")+oGet:aCols[n2][5]) 
			    IF CT1->CT1_CCOBRG == '1'
			    	MSGINFO("Obrigat๓rio o Preenchimento do Centro de Custo") 
			    	_cLinhaok	:= .F.
		    	Else
		    		oGet:aCols[n2][2]	:= ""      //TERMINAR
		    	Endif
			Endif
		Endif 
		
		If !empty(oGet:aCols[n2][3]) .AND. empty(oGet:aCols[n2][4])
			DbSelectArea("CT1") 					
			CT1->(DbSetOrder(1))
			dBGOTOP()
			If DbSeek(xFilial("CT1")+oGet:aCols[n2][6]) 
			    IF CT1->CT1_CCOBRG == '1'
			    	MSGINFO("Obrigat๓rio o Preenchimento do Centro de Custo") 
			    	_cLinhaok	:= .F.
		        Else
		    		oGet:aCols[n2][4] := ""       //TERMINAR
		    	Endif
			Endif
		Endif
		
		If oGet:aCols[n2][7] == 0
			MSGINFO("Digite o Valor !!")  
			_cLinhaok	:= .F.
		Endif 
	Endif
Next 

For n2 := 1 To Len(oGet:aCols) 
	If oGet:aCols[n2][9] <> .T.    	//Verifica se o aCols foi deletado (.T. = Deletado)
		_nVl	:= oGet:aCols[n2][7]
	   	_nTotal += _nVl			
	Endif
Next  
_nvlrat	:= _nTotal
onSaldoD:Refresh()     

If M->PA9_VALOR < _nTotal 
	MSGINFO("Somat๓rio MAIOR que o valor total do Tํtulo") 
	_cLinhaok	:= .F.
Endif  


Return(_cLinhaok)

                     
//********************************************************
//********************************************************
//Validacao do Tudo OK dentro do MSGetDados
//********************************************************
//********************************************************

Static Function TudoOK()

Local n2		:= 0
Local _nVl		:= 0 
Local _nTotal	:= 0   
Local _lSoma	:= .T.
Private _cTudoOk:= .T.
 
//VALIDAR A LINHA SE ESTA DELETADA = .T.

For n2 := 1 To Len(oGet:aCols) 
	If oGet:aCols[n2][9] <> .T.    	//Verifica se o aCols foi deletado (.T. = Deletado)
		_nVl	:= oGet:aCols[n2][7]
		_nTotal += _nVl	 		
	Endif
Next  

If _cTudoOK ==.T.
	For n2 := 1 To Len(oGet:aCols) 
		If oGet:aCols[n2][9] <> .T.
			If empty(oGet:aCols[n2][1]) .AND. empty(oGet:aCols[n2][3])  
				MSGINFO("Necessแrio o preenchimento de um dos Itens Contแbeis")
				_cTudook	:= .F.  
				Exit						
			Endif   
		Endif
	Next  
Endif

If _nTotal < M->PA9_VALOR 
	MSGINFO("Somat๓rio MENOR que o valor total do Tํtulo") 
	_cTudook	:= .F.
Endif 

If M->PA9_VALOR < _nTotal 
	MSGINFO("Somat๓rio MAIOR que o valor total do Tํtulo") 
	_cTudook	:= .F.
Endif   	           

Return(_cTudook) 

//**************************************************************
//VALIDACAO NO CAMPO CENTRO DE CUSTO DE DEBITO                  *
//VERIFICA SE HOUVE CENTRO DE CUSTO + CONTA REPITIDOS NO ACOLS  *
//************************************************************** 

USER FUNCTION CONTCD()

Local _cOK	:= .T.  

/*
//O Processo abaixo foi tirado em 12/03/13 pelo analista Emerson, pois o usuario informou que pode digitar a mesma conta e o mesmo CR
//varias vezes neste tela de RATEIO
For n4 := 1 To Len(oGet:aCols)

	If oGet:aCols[n4][9] <> .T.		
		If oGet:aCols[n4][2] == M->PAA_CCD
			If oGet:aCols[n4][1] ==	oGet:aCols[N][1]
	    		Alert("Conta Contแbil e Centro de Custo iguais ao Registro acima")
				_cOK	:= .F. 
				Exit
			EndIf
		EndIf
	Endif 

Next*/

RETURN(_cOK)   


USER FUNCTION delCONTCD()

Local _cOK	:= .T.  
/*
//O Processo abaixo foi tirado em 12/03/13 pelo analista Emerson, pois o usuario informou que pode digitar a mesma conta e o mesmo CR
//varias vezes neste tela de RATEIO
For n4 := 1 To Len(oGet:aCols)

	If oGet:aCols[n4][9] <> .T.
		If n4 <> n
			If oGet:aCols[n4][1]+oGet:aCols[n4][2] == oGet:aCols[N][1]+oGet:aCols[N][2]
		   		Alert("DELETADO Conta Contแbil e Centro de Custo iguais ao Registro acima")
				_cOK	:= .F. 
				Exit
			Endif
		EndIf
	EndIf

Next

For n4 := 1 To Len(oGet:aCols)

	If oGet:aCols[n4][9] <> .T.
		If n4 <> n
			If oGet:aCols[n4][1]+oGet:aCols[n4][3] == oGet:aCols[N][1]+oGet:aCols[N][4]
		   		Alert("DELETADO Conta Contแbil e Centro de Custo iguais ao Registro acima")
				_cOK	:= .F. 
				Exit
			Endif
		EndIf
	EndIf

Next
*/

RETURN(_cOK)


//**************************************************************
//VALIDACAO NO CAMPO CENTRO DE CUSTO DE CREDITO                 *
//VERIFICA SE HOUVE CENTRO DE CUSTO + CONTA REPITIDOS NO ACOLS  *
//************************************************************** 

USER FUNCTION CONTCC()

Local _cOK	:= .T.
/*
//O Processo abaixo foi tirado em 12/03/13 pelo analista Emerson, pois o usuario informou que pode digitar a mesma conta e o mesmo CR
//varias vezes neste tela de RATEIO

For n4 := 1 To Len(oGet:aCols) 
	If oGet:aCols[n4][9] <> .T.		
		If n4 >= 2 //.AND. N4 < Len(oGet:aCols)  
	   		n5	:= (n4 - 1)
			If oGet:aCols[n5][4] == M->PAA_CCC
				If oGet:aCols[n5][3] == oGet:aCols[Len(oGet:aCols)][3]
			    	Alert("Conta Contแbil e Centro de Custo iguais ao Registro acima")
					_cOK	:= .F. 
					Exit
				Endif 
			Endif
		Endif
	Endif
Next
*/
RETURN(_cOK)   


//**************************************************************
//VALIDACAO NO CAMPO CENTRO DE CUSTO DE CREDITO                 *
//VERIFICA SE HOUVE CENTRO DE CUSTO + CONTA REPITIDOS NO ACOLS  *
//************************************************************** 

USER FUNCTION VALORPAA()
  
Local _lOK 		:= .T.
Local n2		:= 0
Local _nVl		:= 0 
Local _nTotal	:= 0   

If M->PAA_VALOR == 0 
	MSG("Preencha o Campo Valor")  
	_lOk	:= .F.
Else
	For n2 := 1 To Len(oGet:aCols) 
		If oGet:aCols[n2][9] <> .T.    	//Verifica se o aCols foi deletado (.T. = Deletado)
			_nVl	:= oGet:aCols[n2][7]
			_nTotal += _nVl
		Endif
	Next
	
	If M->PA9_VALOR < _nTotal 
		Alert("Somat๓rio maior que o valor total do Tํtulo") 
		_lOK	:= .F.		
	Endif   
Endif     

RETURN(_lOK)


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณITCCD บAutor  ณPatricia Fontanezi  บ Data ณ      14/06/12   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ Validacao para identificar se o item contabil Debito tem   บฑฑ
ฑฑบ          ณ centro custo	 - VALIDACAO NO CAMPO X3_WHEN                 บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ AP                                                         บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

USER FUNCTION ITCCD()

Local _lRet	:= .T.   
Local _cCC

DbSelectArea("CT1") 					
CT1->(DbSetOrder(2))
DBGOTOP()
If DbSeek(xFilial("CT1")+oGet:aCols[n][1]) 
	_cCC	:= CT1->CT1_CCOBRG
	If _cCC == '2'
		_lRet	:= .F.
	Endif
Endif

RETURN(_lRet) 

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณITCCD บAutor  ณPatricia Fontanezi  บ Data ณ      14/06/12   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ Validacao para identificar se o item contabil Debito tem   บฑฑ
ฑฑบ          ณ centro custo	 - VALIDACAO NO CAMPO X3_WHEN                 บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ AP                                                         บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

USER FUNCTION ITCCC()

Local _lRet	:= .T.   
Local _cCC

DbSelectArea("CT1") 					
CT1->(DbSetOrder(2))
DBGOTOP()
If DbSeek(xFilial("CT1")+oGet:aCols[n][3]) 
	_cCC	:= CT1->CT1_CCOBRG
	If _cCC == '2'
		_lRet	:= .F.
	Endif
Endif

RETURN(_lRet) 

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณSOMARAT:Autor  ณPatricia Fontanezi  บ Data ณ      14/06/12   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ Gatilho para Somatorio do Rateio digitado pelo usuario     บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ AP                                                         บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

USER FUNCTION SOMARAT()

Local n2		:= 0
Local _nVL2		:= 0
Local _nTotal2	:= 0

For n2 := 1 To Len(oGet:aCols) 
	If oGet:aCols[n2][9] <> .T.    	//Verifica se o aCols foi deletado (.T. = Deletado)
		_nVl2	:= oGet:aCols[n2][7]
		_nTotal2 += _nVl2			
	Endif
Next  
_nvlrat	:= _nTotal2
onSaldoD:Refresh() 

RETURN(_NVL2)