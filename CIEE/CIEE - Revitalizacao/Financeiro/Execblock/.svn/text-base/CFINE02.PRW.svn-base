#Include 'Protheus.ch'
/*---------------------------------------------------------------------------------------
{Protheus.doc} CFINE02
Leitura CNAB via Job/Schedule

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
user function CFINE02(aParam)  
Local cStartPath:= GetSrvProfString("Startpath","")
Local cEmp		:= ""
Local cFil		:= ""
Local cExtens   := "*.TXT"
Local cArqEnt   := ""
Local cModEnt   := ""
Local cDirPRC   := ""
Local aArqDir   := {}
Local nMaxLin   := 240
Local nXa       := 0         

If aParam == Nil
	CONOUT("Parametro invalido => CFINE02")
ELSE
	cEmp    := alltrim(aParam[1])
	cFil    := alltrim(aParam[2])
	
	RpcSetType(3)
	IF RPCSetEnv(cEmp,cFil)
	
		cArqEnt   := Alltrim(GetMv("CI_DRETFOL")) 				// Diretorio de leitura dos arquivos de retorno
		cModEnt   := cStartPath+Alltrim(GetMv("CI_NARQRET")) 	// Nome do layout de retorno 
		cDirPRC   := Alltrim(GetMv("CI_DPRCFOL")) 				// Diretorio destino dos arquivos Processados
		aArqDir   := DIRECTORY( Upper(Alltrim(cArqEnt)+cExtens) )
	
		ConOut("["+LEFT(DTOC(Date()),5)+"]["+LEFT(Time(),5)+"][CFINE02] Processo Iniciado para "+cEmp+"-"+cFil)
		For nXa := 1 To Len(aArqDir)
			ConOut("* Lendo CNAB Retorno " + Alltrim(aArqDir[nXa,1]))
			C6E02LER( Alltrim(cArqEnt)+Alltrim(aArqDir[nXa,1]), cModEnt, nMaxLin, SubStr(Alltrim(aArqDir[nXa,1]),1,At(".",Alltrim(aArqDir[nXa,1]))-1) , cDirPRC, SubStr(cExtens,2,Len(cExtens)))  		// Le cnab
		Next nXa                                                        
		ConOut("["+LEFT(DTOC(Date()),5)+"]["+LEFT(Time(),5)+"][CFINE02] Processo Finalizado para "+cEmp+"-"+cFil)
		RpcClearEnv()
	ENDIF
EndIf

return 
/*------------------------------------------------------------------------
*
* C6E0299()
* Teste 99
*
------------------------------------------------------------------------*/
user function C6E0299()
Local cStartPath:= GetSrvProfString("Startpath","")
Local cEmp		:= ""
Local cFil		:= ""
Local cExtens   := "*.TXT"
Local cArqEnt   := ""
Local cModEnt   := ""
Local cDirPRC   := ""
Local aArqDir   := {}
Local nMaxLin   := 240
Local nXa       := 0
local aParam	:= {"99","01"}         

If aParam == Nil
	CONOUT("Parametro invalido => CFINE02")
ELSE
	cEmp    := alltrim(aParam[1])
	cFil    := alltrim(aParam[2])
	
	RpcSetType(3)
	IF RPCSetEnv(cEmp,cFil)
	
		cArqEnt   := Alltrim(GetMv("CI_DRETFOL")) 				// Diretorio de leitura dos arquivos de retorno
		cModEnt   := cStartPath+Alltrim(GetMv("CI_NARQRET")) 	// Nome do layout de retorno 
		cDirPRC   := Alltrim(GetMv("CI_DPRCFOL")) 				// Diretorio destino dos arquivos Processados
		aArqDir   := DIRECTORY( Upper(Alltrim(cArqEnt)+cExtens) )
	
		ConOut("["+LEFT(DTOC(Date()),5)+"]["+LEFT(Time(),5)+"][CFINE02] Processo Iniciado para "+cEmp+"-"+cFil)
		For nXa := 1 To Len(aArqDir)
			ConOut("* Lendo CNAB Retorno " + Alltrim(aArqDir[nXa,1]))
			C6E02LER( Alltrim(cArqEnt)+Alltrim(aArqDir[nXa,1]), cModEnt, nMaxLin, SubStr(Alltrim(aArqDir[nXa,1]),1,At(".",Alltrim(aArqDir[nXa,1]))-1) , cDirPRC, SubStr(cExtens,2,Len(cExtens)))  		// Le cnab
		Next nXa                                                        
		ConOut("["+LEFT(DTOC(Date()),5)+"]["+LEFT(Time(),5)+"][CFINE02] Processo Finalizado para "+cEmp+"-"+cFil)
		RpcClearEnv()
	ENDIF
EndIf

return
/*------------------------------------------------------------------------
*
* C6E02LER()
* leitura do arquivo de retorno
*
------------------------------------------------------------------------*/
Static Function C6E02LER(cHandle, cLayOut, nMaxLn, cNomeArq, _cDirPRC, _cExtens)
Local nHdlLay   := 0
Local cBuffer   := ""
Local nPosIni   := 0
Local nPosFim   := 0
Local nTamanho  := 0
Local nDecimal  := 0
Local aHeader   := {}
Local aDetalhe  := {}
Local nLidos    := 0
Local lMoved    := .T.
Local nMoved    := 0
Local nPonteiro := 0
Local cKeyZA6   := ""
Local cKeyZA5   := ""
Local cOcorre   := "" 
Local aCompensa := {}
Local aFolhaXml := {} 
local nCnt		:= 0

If (File(cLayOut))
	FT_FUSE(cLayOut)
	FT_FGOTOP()
	While !FT_FEOF()
		cBuffer := FT_FREADLN()    
		
		IF SubStr(cBuffer,1,1) == CHR(1)
			FT_FSKIP()
			Loop
		EndIF
		IF SubStr(cBuffer,1,1) == CHR(3)
			Exit
		EndIF
				
		If ( !Empty(cBuffer) )
			nPosIni  := Val(SubStr(cBuffer,17,03))
			nPosFim  := Val(SubStr(cBuffer,20,03))
			nDecimal := Val(SubStr(cBuffer,23,01))
			nTamanho := nPosFim - nPosIni +1
			Do Case
				Case "Ocorrencias Det"$cBuffer
					Aadd(aDetalhe,{"Ocorrencias Det",nPosIni,nTamanho,nDecimal})
				Case "Seu Numero"$cBuffer
					Aadd(aDetalhe,{"Seu Numero",nPosIni,nTamanho,nDecimal})
			EndCase
		EndIf
		FT_FSKIP()
	EndDo
	FClose(nHdlLay)
EndIf
FT_FUSE()
FClose(cLayOut)
FT_FUSE(cHandle)
FT_FGOTOP()
While !FT_FEOF()
	cBuffer	:= FT_FREADLN()
	cKeyZA6 := ""
	cOcorre := ""	
	If (!Empty(cBuffer))
		Do Case
			Case Substr(cBuffer,8,1) == "3" // Detalhe
								
				if (nPonteiro := aScan(aDetalhe,{|x| "Seu Numero"$x[1]})) > 0
					cKeyZA6 := Alltrim(SubStr(cBuffer,aDetalhe[nPonteiro,2],aDetalhe[nPonteiro,3]))
					cKeyZA5	:= RIGHT(cKeyZA6,tamsx3("ZA5_FILIAL")[1]+tamsx3("ZA5_CODINT")[1]+tamsx3("ZA6_CODEST")[1])
					cKeyZA5	:= LEFT(cKeyZA5,tamsx3("ZA5_FILIAL")[1]+tamsx3("ZA5_CODINT")[1])
					cKeyZA6	:= RIGHT(cKeyZA6,tamsx3("ZA6_CODEST")[1])					
				endif	
				
				if (nPonteiro := aScan(aDetalhe,{|x| "Ocorrencias Det"$x[1]})) > 0
					cOcorre   := Alltrim(SubStr(cBuffer,aDetalhe[nPonteiro,2],aDetalhe[nPonteiro,3]))
				endif

				DbSelectArea("ZA5")
				ZA5->(DbSetOrder(2))
				ZA5->(DbGoTop())
				If ZA5->(DbSeek(cKeyZA5))					
					cKeyZA6	:= ZA5->ZA5_FILIAL+ZA5->ZA5_COD+cKeyZA6	
					DbSelectArea("ZA6")
					ZA6->(DbSetOrder(1))
					ZA6->(DbGoTop())
					If ZA6->(DbSeek(cKeyZA6))
						ZA6->(MsUnLockAll())
						If RecLock("ZA6",.F.)
							Replace ZA6->ZA6_OCORRE With cOcorre
							ZA6->(MsUnLock())
							nLidos++   
							if cOcorre == "00"
								aadd(aCompensa,ZA6->(RECNO()))
							endif
						Endif 
						
						if ascan(aFolhaXml,{|x| x==ZA5->ZA5_FILIAL+ZA5->ZA5_COD }) == 0
							aadd(aFolhaXml,ZA5->ZA5_FILIAL+ZA5->ZA5_COD)                
						endif
						
					Endif
				Endif
		EndCase
	EndIf
	FT_FSKIP()
EndDo
FT_FUSE()
FClose(cHandle)
If nLidos > 0
	While lMoved
		nMoved := fRename(cHandle,_cDirPRC+cNomeArq+_cExtens)
		If !(nMoved < 0)
			fErase(cHandle)
			lMoved := .F.
		Endif
	End
Endif

C6E02CMP(aCompensa)
                               
// Gera xml após retorno do CNAB
for nCnt:= 1 to len(aFolhaXml) 
	U_CEAIA26(aFolhaXml[nCnt])
next nCnt

Return       
/*------------------------------------------------------------------------
*
* C6E02CMP()
* Realiza a compensação
*
------------------------------------------------------------------------*/
Static Function C6E02CMP(aCompensa)
local nCnt		:= 0
local aRecNDC	:= {}   
local aRecRA	:= {}

for nCnt:= 1 to len(aCompensa)
	DbSelectArea("ZA6")
	ZA6->(dbgoto(aCompensa[nCnt]))
	
	if ZA6->(!eof())
		DbSelectArea("ZA5")
		ZA5->(DbSetOrder(1))
		ZA5->(DbGoTop())
		If ZA5->(DbSeek(xfilial("ZA5")+ZA6->ZA6_COD))		  
	 		aRecNDC	:= {}
	 		aRecRA	:= {}	                
			// Pega Recno do titulo NDC   
			DBSELECTAREA("SE1")
			DBSETORDER(1) 
			if DBSEEK(xFilial("SE1")+ZA5->ZA5_PRXTIT+ZA5->ZA5_NUMTIT+" "+"NDC")			
				aadd(aRecNDC,SE1->(RECNO()))
			Endif
			              
			dbselectarea("SZ8")
			dbsetorder(8)
			if SZ8->(dbseek(xfilial("SZ8")+ZA6->ZA6_CODEXT)) 			  
				// Pega Recno do titulo RA
				DBSELECTAREA("SE1")
				DBSETORDER(1) 
				if DBSEEK(xFilial("SE1")+SZ8->Z8_PRXTIT+SZ8->Z8_NUMTIT+" "+"RA ")			
					aadd(aRecRA,SE1->(RECNO()))
				Endif	    
			Endif  
			
			if !empty(aRecNDC) .and. !empty(aRecRA)			  	   		                                                                                                                                     
				if MaIntBxCR(3,aRecNDC,,aRecRA,,{.T.,.F.,.T.,.F.,.F.,.F.},,,,,DDATABASE,,{ZA6->ZA6_VLRCON})					   	                         					    
					conout("Compesação realizada com sucesso.")
		        else 
		        	conout("Não foi possível a compensação.")
				Endif				    
			Endif
	    endif
	endif

next nCnt

return 