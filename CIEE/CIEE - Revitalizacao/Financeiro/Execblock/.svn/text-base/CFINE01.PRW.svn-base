#Include 'Protheus.ch'
/*---------------------------------------------------------------------------------------
{Protheus.doc} CFINE01
Gera CNAB via Job/Schedule

@class		Nenhum
@from 		Nenhum
@param    	Nenhum
@attrib    	Nenhum
@protected  Nenhum
@author     AF Custom
@version    P.11
@since      01/10/2014
@return    	Nenhum
@sample   	Nenhum
@obs      	Nenhum
@project    CIEE - Revitalização
@menu    	Nenhum
@history    Nenhum
---------------------------------------------------------------------------------------*/
user function CFINE01(aParam)
Local cEmp		:= ""
Local cFil		:= ""          

If aParam == Nil
	CONOUT("Parametro invalido => CFINE01")
ELSE
	cEmp    := alltrim(aParam[1])
	cFil    := alltrim(aParam[2])
	
	RpcSetType(3)
	IF RPCSetEnv(cEmp,cFil)
		CONOUT("["+LEFT(DTOC(Date()),5)+"]["+LEFT(Time(),5)+"][CFINE01] Processo Iniciado para "+cEmp+"-"+cFil)
		C6E01GER()  		// Gera cnab
		CONOUT("["+LEFT(DTOC(Date()),5)+"]["+LEFT(Time(),5)+"][CFINE01] Processo Finalizado para "+cEmp+"-"+cFil)
		RpcClearEnv()
	ENDIF
EndIf

return
/*------------------------------------------------------------------------
*
* C6E0199()
* Teste 99
*
------------------------------------------------------------------------*/
user function C6E0199()
Local cEmp		:= ""
Local cFil		:= ""
local aParam	:= {"99","01"}          

If aParam == Nil
	CONOUT("Parametro invalido => CFINE01")
ELSE
	cEmp    := alltrim(aParam[1])
	cFil    := alltrim(aParam[2])
	
	RpcSetType(3)
	IF RPCSetEnv(cEmp,cFil)
		CONOUT("["+LEFT(DTOC(Date()),5)+"]["+LEFT(Time(),5)+"][CFINE01] Processo Iniciado para "+cEmp+"-"+cFil)
		C6E01GER()  		// Gera cnab
		CONOUT("["+LEFT(DTOC(Date()),5)+"]["+LEFT(Time(),5)+"][CFINE01] Processo Finalizado para "+cEmp+"-"+cFil)
		RpcClearEnv()
	ENDIF
EndIf

return
/*------------------------------------------------------------------------
*
* C6E01GER()
* Gera Cnab
*
------------------------------------------------------------------------*/
Static Function C6E01GER()
Local cStartPath  := GetSrvProfString("Startpath","")
Local nLidos	  := 0
Local nTamArq	  := 0
Local xBuffer	  := ""
Local lFirst	  := .F.
Local lHeader	  := .F.
Local lGrava	  := .F.
Local nTam		  := 0
Local nDec		  := 0                               
Local cConteudo	  := ""                              
Private nSeq	  := 0
Private nModelo	  := GetMv("CI_MCNABFO",.F.,1)			 					// Modelo do cnab da folha
Private cArqEnt   := cStartPath+Alltrim(GetMv("CI_NARQREM",.F.,"")) 		// Nome do layout de remessa
Private cArqSaida := Alltrim(GetMv("CI_DREMFOL",.F.,"")) 					// Diretorio onde sera criado os arquivo de Remessa.
Private cArqExtc  := ".TXT"
Private nHdlBco   := 0
Private nHdlSaida := 0
Private xConteudo := Nil
Private fArquivo  := Nil   
Private nTotal    := 0   
Private cLoteFolha:= Alltrim(GetMv("CI_LOTEFOL",.F.,"0001"))

fArquivo  := C6E01ABR("REM_"+Dtos(Date())+"_"+ STRTRAN(Time(),":","_"))
IF !fArquivo[1]
	Return
ENDIF

DbSelectArea("ZA5")
ZA5->(DbSetOrder(1))
ZA5->(DbGoTop()) 

DbSelectArea("ZA6")
ZA6->(DbSetOrder(1))
ZA6->(DbGoTop())

While ZA5->(!Eof()) 
	nLidos	  := 0
	nTamArq	  := 0
	xBuffer	  := ""
	lFirst	  := .F.
	lHeader	  := .F.
	lGrava	  := .T.
	nTam	  := 0
	nDec	  := 0
	cConteudo := ""
	xConteudo := Nil
	
	ZA6->(DbGoTop())
	While ZA6->(!Eof())
		If ZA6->ZA6_COD == ZA5->ZA5_COD .And. "S"$ZA6->ZA6_LIBPAG .and. ZA6->ZA6_CNAB!="S"
			nSeq++
			
			If ( nModelo == 1 )
				//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
				//³ Le Arquivo de Parametrizacao                                 ³
				//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
				nLidos := 0
				fSeek(nHdlBco,0,0)
				nTamArq:=FSEEK(nHdlBco,0,2)
				fSeek(nHdlBco,0,0)
				
				While nLidos <= nTamArq
					//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
					//³ Verifica o tipo qual registro foi lido                       ³
					//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
					xBuffer := Space(85)
					FREAD(nHdlBco,@xBuffer,85)
					
					Do case
						Case SubStr(xBuffer,1,1) == CHR(1)
							IF lHeader
								nLidos+=85
								Loop
							EndIF
						Case SubStr(xBuffer,1,1) == CHR(2)
							IF !lFirst
								lFirst := .T.
								FWRITE(nHdlSaida,CHR(13)+CHR(10))
							EndIF
						Case SubStr(xBuffer,1,1) == CHR(3)
							nLidos+=85
							Loop
						Otherwise
							nLidos+=85
							Loop
					EndCase
					
					nTam := 1+(Val(SubStr(xBuffer,20,3))-Val(SubStr(xBuffer,17,3)))
					nDec := Val(SubStr(xBuffer,23,1))
					cConteudo := SubStr(xBuffer,24,60)
					lGrava := C6E01GRV(nTam,nDec,cConteudo)
					IF !lGrava
						Exit
					End
					nLidos+=85
				EndDO
				IF !lGrava
					Exit
				End
				
			Else
				lGrava := C6E01GRV(,,,)
			EndIf
			
			If lGrava
				If ( nModelo == 1 )
					fWrite(nHdlSaida,CHR(13)+CHR(10))
					IF !lHeader
						lHeader := .T.
					EndIF
				EndIf         
				ZA6->(MsUnLockAll())
				If RecLock("ZA6",.F.)
					Replace ZA6->ZA6_CNAB With "S"
					ZA6->(MsUnLock())
				Endif
			EndIf
		Endif
	ZA6->(DbSkip())
	End			
ZA5->(DbSkip())
End 

If ( nModelo == 1 )
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Monta Registro Trailler                                      ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	nSeq++
	nLidos := 0
	FSEEK(nHdlBco,0,0)
	nTamArq:=FSEEK(nHdlBco,0,2)
	FSEEK(nHdlBco,0,0)
	
	While nLidos <= nTamArq
		
		IF !lGrava
			Exit
		End
		
		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³ Tipo qual registro foi lido                                  ³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		xBuffer:=Space(85)
		FREAD(nHdlBco,@xBuffer,85)
		
		IF SubStr(xBuffer,1,1) == CHR(3)
			nTam := 1+(Val(SubStr(xBuffer,20,3))-Val(SubStr(xBuffer,17,3)))
			nDec := Val(SubStr(xBuffer,23,1))
			cConteudo := SubStr(xBuffer,24,60)
			lGrava := C6E01GRV( nTam,nDec,cConteudo )
			IF !lGrava
				Exit
			End
		EndIF
		nLidos+=85
	EndDO
	If lGrava
		fWrite(nHdlSaida,CHR(13)+CHR(10))
	EndIf
Else
	RodaCnab2(nHdlSaida,cArqent,.t.)
EndIf    

if nSeq > 0   
 	PUTMV("CI_LOTEFOL", soma1(cLoteFolha))
endif           

fClose(nHdlSaida)

Return
/*------------------------------------------------------------------------
*
* C6E01GRV()
* Grava arquivo
*
------------------------------------------------------------------------*/
Static Function C6E01GRV( nTam,nDec,cConteudo )
Local lConteudo := .T.

While .T.
	If ( nModelo == 1 )
		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³ Analisa conteudo                                         ³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		IF Empty(cConteudo)
			cCampo:=Space(nTam)
		Else
			lConteudo := C6E01MCRO( cConteudo )
			IF !lConteudo
				Exit
			Else
				IF ValType(xConteudo)="D"
					cCampo := GravaData(xConteudo,.F.)
				Elseif ValType(xConteudo)="N"
					cCampo := Substr(Strzero(xConteudo,nTam,nDec),1,nTam)
				Else
					cCampo := Substr(xConteudo,1,nTam)
				End
			End
		End
		IF Len(cCampo) < nTam  //Preenche campo a ser gravado, caso menor
			cCampo := cCampo+Space(nTam-Len(cCampo))
		End
		Fwrite( nHdlSaida,cCampo,nTam )
	Else
		DetCnab2(nHdlSaida,cArqent)
	EndIf
	Exit
End

Return lConteudo
/*------------------------------------------------------------------------
*
* C6E01ABR()
* Abre arquivo
*
------------------------------------------------------------------------*/
Static Function C6E01ABR(cNumCnab)

IF !FILE(cArqEnt)
	ConOut("Arquivo "+cArqEnt+" nao encotrado!")
	Return .F.
Else
	If ( nModelo == 1 )
		nHdlBco := FOPEN(cArqEnt,0+64)
	EndIf
EndIF

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Cria Arquivo Saida                                       ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
If ( nModelo == 1 )
	nHdlSaida := MSFCREATE(cArqSaida+cNumCnab+cArqExtc,0)
Else
	nHdlSaida := HeadCnab2(cArqSaida+cNumCnab+cArqExtc,cArqent)
EndIf

Return {.T.,cArqSaida+cNumCnab+cArqExtc}
/*------------------------------------------------------------------------
*
* C6E01MCRO()
* Executa macro
*
------------------------------------------------------------------------*/
Static Function C6E01MCRO( cForm )
Local bBlock := ErrorBlock(),bErro := ErrorBlock( { |e| ChecErr260(e,cForm) } )
Private lRet := .T.

BEGIN SEQUENCE
xConteudo := &cForm
END SEQUENCE
ErrorBlock(bBlock)

Return lRet