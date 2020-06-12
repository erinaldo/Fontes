#Include 'Protheus.ch'
#include "TOPCONN.ch"
/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณDTMSJ001  บAutor  ณTOTVS               บ Data ณ  XX/XX/XX   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ Scheduler Processamento CT-e TMSIMPDOC                     บฑฑ
ฑฑ           ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ DHL                                                       บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

User Function DTMSJ001(aParam)
Local cEmp		:= ""
Local cFil		:= ""
Local aTables := {"SWN","DTC","DT6","DT8"}

If aParam == Nil
	CONOUT("Parametro invalido => DTMSJ001")
ELSE	
	cEmp := alltrim(aParam[1])
	cFil := alltrim(aParam[2])
	
	RpcSetType(3)
	IF RpcSetEnv( cEmp, cFil,/*"Administrador"*/,/*" "*/, "TMS", "TMSA050", aTables, , , ,  )                                                                                                            
		CONOUT("["+LEFT(DTOC(Date()),5)+"]["+LEFT(Time(),5)+"][DTMSJ001] Processo Iniciado para "+cEmp+"-"+cFil)
		U_DTMSJ01Run(cFil)  																											// Execucao
		CONOUT("["+LEFT(DTOC(Date()),5)+"]["+LEFT(Time(),5)+"][DTMSJ001] Processo Finalizado para "+cEmp+"-"+cFil)	
		RpcClearEnv()
	ENDIF	
EndIf
/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณDTMSJ01RunบAutor  ณTOTVS               บ Data ณ  XX/XX/XX   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ Run                                                        บฑฑ
ฑฑ           ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ DHL                                                       บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

User Function DTMSJ01Run(cFil)

Private cAliasZZ0	:=	GetNextAlias()

cCampos := "%*%"
cFiltro := "% ZZ0.ZZ0_STATUS = '1' AND "
cFiltro += "  ZZ0.ZZ0_FILDOC = '"+cFil+"' AND "
cFiltro += "  ZZ0.ZZ0_PROC = 'S' AND %"

BeginSql Alias cAliasZZ0
	SELECT
	%Exp:cCampos%
	FROM 
	%Table:ZZ0% ZZ0
	WHERE 
	%Exp:cFiltro%
	ZZ0.%NotDel%
	ORDER BY 
	//ZZ0.ZZ0_CTE, ZZ0.ZZ0_NUMERO
	ZZ0.ZZ0_NUMERO
EndSql

_cQuery := "UPDATE "+RetSqlName("ZZ0")+" SET ZZ0_STATUS = '4' "
_cQuery += "WHERE D_E_L_E_T_ = '' AND ZZ0_STATUS = '1' AND ZZ0_FILDOC = '"+cFil+"' AND ZZ0_PROC = 'S' "
TCSQLEXEC(_cQuery)

DbSelectArea (cAliasZZ0)
(cAliasZZ0)->(DbGoTop ())
If (cAliasZZ0)->(Eof ())
	Return
EndIf
Do While !(cAliasZZ0)->(Eof ())
	_cNumero 		:= (cAliasZZ0)->(ZZ0_NUMERO)
	_cZZ0FILDOC	:= (cAliasZZ0)->(ZZ0_FILDOC)
	DTMS01Mult(_cNumero,_cZZ0FILDOC,cEmpAnt,cFilAnt)
	(cAliasZZ0)->(DbSkip())
EndDo

Return
/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณDTMS01MultบAutor  ณTOTVS               บ Data ณ  XX/XX/XX   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ Chamada do Processamento com Multi-Thread                  บฑฑ
ฑฑ           ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ DHL                                                       บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

Static Function DTMS01Mult(_cNumero,_cZZ0FILDOC)
	// Verifica quantos processamentos paralelos ja estใo ativos 
	lVerifica:= .T.
	While lVerifica
		aThreads 		:= GetUserInfoArray()
		nContThread	:= 0    
		nLenThreads	:= Len(aThreads)

		For nQ:=1 to nLenThreads
			Do Case
				Case cFilAnt == "0101"
					If "U_GCTE0101"$Upper(Alltrim(aThreads[nQ,5]))
						nContThread++
					EndIf
				Case cFilAnt == "0102"
					If "U_GCTE0102"$Upper(Alltrim(aThreads[nQ,5]))
						nContThread++
					EndIf
				Case cFilAnt == "0103"
					If "U_GCTE0103"$Upper(Alltrim(aThreads[nQ,5]))
						nContThread++
					EndIf
				Case cFilAnt == "0104"
					If "U_GCTE0104"$Upper(Alltrim(aThreads[nQ,5]))
						nContThread++
					EndIf
				Case cFilAnt == "0105"
					If "U_GCTE0105"$Upper(Alltrim(aThreads[nQ,5]))
						nContThread++
					EndIf
				Case cFilAnt == "0106"
					If "U_GCTE0106"$Upper(Alltrim(aThreads[nQ,5]))
						nContThread++
					EndIf
				Case cFilAnt == "0107"
					If "U_GCTE0107"$Upper(Alltrim(aThreads[nQ,5]))
						nContThread++
					EndIf
				Case cFilAnt == "0108"
					If "U_GCTE0108"$Upper(Alltrim(aThreads[nQ,5]))
						nContThread++
					EndIf
				Case cFilAnt == "0109"
					If "U_GCTE0109"$Upper(Alltrim(aThreads[nQ,5]))
						nContThread++
					EndIf
				Case cFilAnt == "0110"
					If "U_GCTE0110"$Upper(Alltrim(aThreads[nQ,5]))
						nContThread++
					EndIf
				Case cFilAnt == "0111"
					If "U_GCTE0111"$Upper(Alltrim(aThreads[nQ,5]))
						nContThread++
					EndIf
				Case cFilAnt == "0112"
					If "U_GCTE0112"$Upper(Alltrim(aThreads[nQ,5]))
						nContThread++
					EndIf
				Case cFilAnt == "0113"
					If "U_GCTE0113"$Upper(Alltrim(aThreads[nQ,5]))
						nContThread++
					EndIf
				Case cFilAnt == "0114"
					If "U_GCTE0114"$Upper(Alltrim(aThreads[nQ,5]))
						nContThread++
					EndIf
				Case cFilAnt == "0115"
					If "U_GCTE0115"$Upper(Alltrim(aThreads[nQ,5]))
						nContThread++
					EndIf
				Case cFilAnt == "0116"
					If "U_GCTE0116"$Upper(Alltrim(aThreads[nQ,5]))
						nContThread++
					EndIf
				Case cFilAnt == "0117"
					If "U_GCTE0117"$Upper(Alltrim(aThreads[nQ,5]))
						nContThread++
					EndIf
				Case cFilAnt == "0118"
					If "U_GCTE0118"$Upper(Alltrim(aThreads[nQ,5]))
						nContThread++
					EndIf
				Case cFilAnt == "0119"
					If "U_GCTE0119"$Upper(Alltrim(aThreads[nQ,5]))
						nContThread++
					EndIf
				Case cFilAnt == "0120"
					If "U_GCTE0120"$Upper(Alltrim(aThreads[nQ,5]))
						nContThread++
					EndIf
				Case cFilAnt == "0121"
					If "U_GCTE0121"$Upper(Alltrim(aThreads[nQ,5]))
						nContThread++
					EndIf
				Case cFilAnt == "0122"
					If "U_GCTE0122"$Upper(Alltrim(aThreads[nQ,5]))
						nContThread++
					EndIf
				Case cFilAnt == "0123"
					If "U_GCTE0123"$Upper(Alltrim(aThreads[nQ,5]))
						nContThread++
					EndIf
				Case cFilAnt == "0126"
					If "U_GCTE0126"$Upper(Alltrim(aThreads[nQ,5]))
						nContThread++
					EndIf
				Case cFilAnt == "0127"
					If "U_GCTE0127"$Upper(Alltrim(aThreads[nQ,5]))
						nContThread++
					EndIf
			EndCase			

		Next nQ
		
		_nThread := 5 //Deixa processar no maximo 5 threads paralelas
		Do Case
			Case cFilAnt == "0101"
				If nContThread < _nThread
					Begin Transaction
					StartJob("U_GCTE0101",GetEnvServer(),.F.,{_cNumero,_cZZ0FILDOC,cEmpAnt,cFilAnt})
					END TRANSACTION
					lVerifica:=.F.
				EndIf
			Case cFilAnt == "0102"
				If nContThread < _nThread
					Begin Transaction
					StartJob("U_GCTE0102",GetEnvServer(),.F.,{_cNumero,_cZZ0FILDOC,cEmpAnt,cFilAnt})
					END TRANSACTION
					lVerifica:=.F.
				EndIF
			Case cFilAnt == "0103"
				If nContThread < _nThread
					Begin Transaction
					StartJob("U_GCTE0103",GetEnvServer(),.F.,{_cNumero,_cZZ0FILDOC,cEmpAnt,cFilAnt})
					END TRANSACTION
					lVerifica:=.F.
				EndIf
			Case cFilAnt == "0104"
				If nContThread < _nThread
					Begin Transaction
					StartJob("U_GCTE0104",GetEnvServer(),.F.,{_cNumero,_cZZ0FILDOC,cEmpAnt,cFilAnt})
					END TRANSACTION
					lVerifica:=.F.
				EndIF
			Case cFilAnt == "0105"
				If nContThread < _nThread
					Begin Transaction
					StartJob("U_GCTE0105",GetEnvServer(),.F.,{_cNumero,_cZZ0FILDOC,cEmpAnt,cFilAnt})
					END TRANSACTION
					lVerifica:=.F.
				EndIf
			Case cFilAnt == "0106"
				If nContThread < _nThread
					Begin Transaction
					StartJob("U_GCTE0106",GetEnvServer(),.F.,{_cNumero,_cZZ0FILDOC,cEmpAnt,cFilAnt})
					END TRANSACTION
					lVerifica:=.F.
				EndIF
			Case cFilAnt == "0107"
				If nContThread < _nThread
					Begin Transaction
					StartJob("U_GCTE0107",GetEnvServer(),.F.,{_cNumero,_cZZ0FILDOC,cEmpAnt,cFilAnt})
					END TRANSACTION
					lVerifica:=.F.
				EndIf
			Case cFilAnt == "0108"
				If nContThread < _nThread
					Begin Transaction
					StartJob("U_GCTE0108",GetEnvServer(),.F.,{_cNumero,_cZZ0FILDOC,cEmpAnt,cFilAnt})
					END TRANSACTION
					lVerifica:=.F.
				EndIF
			Case cFilAnt == "0109"
				If nContThread < _nThread
					Begin Transaction
					StartJob("U_GCTE0109",GetEnvServer(),.F.,{_cNumero,_cZZ0FILDOC,cEmpAnt,cFilAnt})
					END TRANSACTION
					lVerifica:=.F.
				EndIf
			Case cFilAnt == "0110"
				If nContThread < _nThread
					Begin Transaction
					StartJob("U_GCTE0110",GetEnvServer(),.F.,{_cNumero,_cZZ0FILDOC,cEmpAnt,cFilAnt})
					END TRANSACTION
					lVerifica:=.F.
				EndIF
			Case cFilAnt == "0111"
				If nContThread < _nThread
					Begin Transaction
					StartJob("U_GCTE0111",GetEnvServer(),.F.,{_cNumero,_cZZ0FILDOC,cEmpAnt,cFilAnt})
					END TRANSACTION
					lVerifica:=.F.
				EndIf
			Case cFilAnt == "0112"
				If nContThread < _nThread
					Begin Transaction
					StartJob("U_GCTE0112",GetEnvServer(),.F.,{_cNumero,_cZZ0FILDOC,cEmpAnt,cFilAnt})
					END TRANSACTION
					lVerifica:=.F.
				EndIF
			Case cFilAnt == "0113"
				If nContThread < _nThread
					Begin Transaction
					StartJob("U_GCTE0113",GetEnvServer(),.F.,{_cNumero,_cZZ0FILDOC,cEmpAnt,cFilAnt})
					END TRANSACTION
					lVerifica:=.F.
				EndIf
			Case cFilAnt == "0114"
				If nContThread < _nThread
					Begin Transaction
					StartJob("U_GCTE0114",GetEnvServer(),.F.,{_cNumero,_cZZ0FILDOC,cEmpAnt,cFilAnt})
					END TRANSACTION
					lVerifica:=.F.
				EndIF
			Case cFilAnt == "0115"
				If nContThread < _nThread
					Begin Transaction
					StartJob("U_GCTE0115",GetEnvServer(),.F.,{_cNumero,_cZZ0FILDOC,cEmpAnt,cFilAnt})
					END TRANSACTION
					lVerifica:=.F.
				EndIf
			Case cFilAnt == "0116"
				If nContThread < _nThread
					Begin Transaction
					StartJob("U_GCTE0116",GetEnvServer(),.F.,{_cNumero,_cZZ0FILDOC,cEmpAnt,cFilAnt})
					END TRANSACTION
					lVerifica:=.F.
				EndIF
			Case cFilAnt == "0117"
				If nContThread < _nThread
					Begin Transaction
					StartJob("U_GCTE0117",GetEnvServer(),.F.,{_cNumero,_cZZ0FILDOC,cEmpAnt,cFilAnt})
					END TRANSACTION
					lVerifica:=.F.
				EndIf
			Case cFilAnt == "0118"
				If nContThread < _nThread
					Begin Transaction
					StartJob("U_GCTE0118",GetEnvServer(),.F.,{_cNumero,_cZZ0FILDOC,cEmpAnt,cFilAnt})
					END TRANSACTION
					lVerifica:=.F.
				EndIF
			Case cFilAnt == "0119"
				If nContThread < _nThread
					Begin Transaction
					StartJob("U_GCTE0119",GetEnvServer(),.F.,{_cNumero,_cZZ0FILDOC,cEmpAnt,cFilAnt})
					END TRANSACTION
					lVerifica:=.F.
				EndIf
			Case cFilAnt == "0120"
				If nContThread < _nThread
					Begin Transaction
					StartJob("U_GCTE0120",GetEnvServer(),.F.,{_cNumero,_cZZ0FILDOC,cEmpAnt,cFilAnt})
					END TRANSACTION
					lVerifica:=.F.
				EndIf
			Case cFilAnt == "0121"
				If nContThread < _nThread
					Begin Transaction
					StartJob("U_GCTE0121",GetEnvServer(),.F.,{_cNumero,_cZZ0FILDOC,cEmpAnt,cFilAnt})
					END TRANSACTION
					lVerifica:=.F.
				EndIF
			Case cFilAnt == "0122"
				If nContThread < _nThread
					Begin Transaction
					StartJob("U_GCTE0122",GetEnvServer(),.F.,{_cNumero,_cZZ0FILDOC,cEmpAnt,cFilAnt})
					END TRANSACTION
					lVerifica:=.F.
				EndIf
			Case cFilAnt == "0123"
				If nContThread < _nThread
					Begin Transaction
					StartJob("U_GCTE0123",GetEnvServer(),.F.,{_cNumero,_cZZ0FILDOC,cEmpAnt,cFilAnt})
					END TRANSACTION
					lVerifica:=.F.
				EndIF
			Case cFilAnt == "0126"
				If nContThread < _nThread
					Begin Transaction
					StartJob("U_GCTE0126",GetEnvServer(),.F.,{_cNumero,_cZZ0FILDOC,cEmpAnt,cFilAnt})
					END TRANSACTION
					lVerifica:=.F.
				EndIf
			Case cFilAnt == "0127"
				If nContThread < _nThread
					Begin Transaction
					StartJob("U_GCTE0127",GetEnvServer(),.F.,{_cNumero,_cZZ0FILDOC,cEmpAnt,cFilAnt})
					END TRANSACTION
					lVerifica:=.F.
				EndIF
		EndCase			

		aCabDTC	:= {}
		aItemDTC 	:= {}
		aItem 		:= {}
					
		aVetDoc   := {}
		aVetVlr   := {}
		aVetNFc   := {}
					
		aDocOri	:= {}
		aDocAnul	:= {}
				
		X8_XALIQ  := 0
		X8_XTES   := ""
		X8_XCFOP  := ""
		X6_CHVCTE  := ""
		X6_CODNFE  := ""
					
		_lCTeComp := .F.
		_lCTeAnul := .F.
		lCont     := .F.

		If lVerifica
			Sleep(3000) //Aguarda 5 segundos
		EndIF
	End
	
Return

User Function GCTE0101(aParam)
	U_GCTE01THR(aParam)
Return

User Function GCTE0102(aParam)
	U_GCTE01THR(aParam)
Return

User Function GCTE0103(aParam)
	U_GCTE01THR(aParam)
Return

User Function GCTE0104(aParam)
	U_GCTE01THR(aParam)
Return

User Function GCTE0105(aParam)
	U_GCTE01THR(aParam)
Return

User Function GCTE0106(aParam)
	U_GCTE01THR(aParam)
Return

User Function GCTE0107(aParam)
	U_GCTE01THR(aParam)
Return

User Function GCTE0108(aParam)
	U_GCTE01THR(aParam)
Return

User Function GCTE0109(aParam)
	U_GCTE01THR(aParam)
Return

User Function GCTE0110(aParam)
	U_GCTE01THR(aParam)
Return

User Function GCTE0111(aParam)
	U_GCTE01THR(aParam)
Return

User Function GCTE0112(aParam)
	U_GCTE01THR(aParam)
Return

User Function GCTE0113(aParam)
	U_GCTE01THR(aParam)
Return

User Function GCTE0114(aParam)
	U_GCTE01THR(aParam)
Return

User Function GCTE0115(aParam)
	U_GCTE01THR(aParam)
Return

User Function GCTE0116(aParam)
	U_GCTE01THR(aParam)
Return

User Function GCTE0117(aParam)
	U_GCTE01THR(aParam)
Return

User Function GCTE0118(aParam)
	U_GCTE01THR(aParam)
Return

User Function GCTE0119(aParam)
	U_GCTE01THR(aParam)
Return

User Function GCTE0120(aParam)
	U_GCTE01THR(aParam)
Return

User Function GCTE0121(aParam)
	U_GCTE01THR(aParam)
Return

User Function GCTE0122(aParam)
	U_GCTE01THR(aParam)
Return

User Function GCTE0123(aParam)
	U_GCTE01THR(aParam)
Return

User Function GCTE0126(aParam)
	U_GCTE01THR(aParam)
Return

User Function GCTE0127(aParam)
	U_GCTE01THR(aParam)
Return


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณGCTE01THR   บAutor  ณTotvs               บ Data ณ  XX/XX/XX บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ Thread                                                     บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณDHL                                                         บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
User Function GCTE01THR(aParam)

Local _cNumero	 	:= aParam[01]
Local _cZZ0FILDOC 	:= aParam[02]
Local cEmpAnt			:= aParam[03]
Local cFilAnt			:= aParam[04]
Local aTables 		:= {"SWN","DTC","DT6","DT8"}

Local aCabLot   := {}
Local cLote     := ''
Local lCont     := .F.
Local aErrMsg   := {}

Private cLotNfc  := ''

Private aCabDTC	:= {}
Private aItemDTC 	:= {}
Private aItem 	:= {}

Private aVetDoc   := {}
Private aVetVlr   := {}
Private aVetNFc   := {}

Private aDocOri	:= {}
Private aDocAnul	:= {}

Private X8_XALIQ  := ""
Private X8_XTES   := ""		//Ponto de Entrada - TM200TES
Private X8_XCFOP  := ""		//Ponto de Entrada - M460FIM
Private X6_CHVCTE := ""		//Ponto de Entrada - M460FIM
Private X6_CODNFE := ""		//Ponto de Entrada - M460FIM

Private aLogAutoANU 	:= {}
Private aErrMsg  		:= {}

RpcSetType(3)
RpcSetEnv( cEmpAnt, cFilAnt,/*"Administrador"*/,/*" "*/, "TMS", "TMSA050", aTables, , , ,  )

_aAreaThr := GetArea()

ChkFile("ZZ0")
ChkFile("ZZA")
ChkFile("ZZB")
ChkFile("ZZC")

DbSelectArea("ZZ0")
DbOrderNickname("ZZ0IND2") //Numero
If DbSeek(xFilial("ZZ0")+_cNumero)
	RecLock("ZZ0",.F.)
	ZZ0->ZZ0_STATUS 	:= "4" //Em Processado
	ZZ0->ZZ0_DTINI 	:= Date()
	ZZ0->ZZ0_HRINI	:= Time()
	ZZ0->(MsUnLock())	
EndIf

DbSelectArea("ZZA")
DbOrderNickname("ZZAIND2") //Numero
DbGotop()
ProcRegua(RecCount())

DbSelectArea("ZZB")
DbOrderNickname("ZZBIND2") //Numero
DbGotop()

DbSelectArea("ZZC")
DbOrderNickname("ZZCIND2") //Numero
DbGotop()

	//-------------------------------------------------------------------
	//Troca a Filial para Processar no Lugar correto
	cFilBkp	:= cFilAnt
	cFilAnt	:= _cZZ0FILDOC

	ZZA->(DbSeek(_cNumero))
	ZZB->(DbSeek(_cNumero))
	ZZC->(DbSeek(_cNumero))
	
	//CriaLote
	//-------------------------------------------------------------------
	lMsErroAuto := .F.
	AAdd(aCabLot,{'DTP_QTDLOT',999,NIL})
	AAdd(aCabLot,{'DTP_QTDDIG',0,NIL})
	AAdd(aCabLot,{'DTP_STATUS','1',NIL})	//-- Em aberto
	MsExecAuto({|x,y|cLote := TmsA170(x,y)},aCabLot,3)
	If lMsErroAuto
		DisarmTransaction()
		lMsErroAuto := .F.
	Else
		cLotNfc     := cLote
	EndIf

	//CANAL A
	//-------------------------------------------------------------------
	Do While ZZA->ZZA_NUMERO == _cNumero

		If ZZA->ZZA_DEVFRE == "3" //Quando o Devedor for o Consignatario
			RecLock("ZZA",.F.)
			ZZA->ZZA_CLICON	:= ZZA->ZZA_CLIDEV
			ZZA->ZZA_LOJCON	:= ZZA->ZZA_LOJDEV
			ZZA->(MsUnLock())
		EndIf
		
		RecLock("ZZA",.F.)
		ZZA->ZZA_SELORI := "1" 	//transportadora (Selecio.Origem) a op็ใo 3 ้ Local Coleta que nใo cabe na DHL
		ZZA->(MsUnLock())
		
		If ZZA->ZZA_TIPNFC == "3" //Documento NรO FISCAL
			RecLock("ZZA",.F.)
			ZZA->ZZA_NUMNFC := cLotNfc+substr(alltrim(str(int(SECONDS()))),3,3)//Gera um Numero aleatorio pois nao Tem Numero do Documento do Cliente
			ZZA->ZZA_EMINFC := ZZA->ZZA_DATENT
			ZZA->(MsUnLock())
		Else //Documento FISCAL
			//TRATAR NOTAS SEM O NUMNFC E PREENCHER DO NFEID (SUBSTRING)
			If Empty(ZZA->ZZA_NUMNFC) .and. !Empty(ZZA->ZZA_NFEID)
				RecLock("ZZA",.F.)
				ZZA->ZZA_NUMNFC := Substr(ZZA->ZZA_NFEID,26,9) //NUMERO DA NOTA
				ZZA->ZZA_SERNFC := Substr(ZZA->ZZA_NFEID,23,3) //SERIE
				ZZA->ZZA_EMINFC := DTOS(CTOD("01/"+Substr(ZZA->ZZA_NFEID,5,2)+"/"+Substr(ZZA->ZZA_NFEID,3,2))) //AAMM - CONSIDERAMOS SEMPRE DIA 01
				ZZA->(MsUnLock())
			EndIF
		EndIf
		
		aCabDTC := {{"DTC_FILIAL" ,xFilial("DTC")	, Nil},;
		{"DTC_FILORI" ,ZZA->ZZA_FILIAL  		, Nil},;
		{"DTC_LOTNFC" ,cLotNfc 			, Nil},;
		{"DTC_CLIREM" ,ZZA->ZZA_CLIREM 		, Nil},;
		{"DTC_LOJREM" ,ZZA->ZZA_LOJREM		, Nil},;
		{"DTC_DATENT" ,STOD(ZZA->ZZA_DATENT) , Nil},;
		{"DTC_CLIDES" ,ZZA->ZZA_CLIDES 		, Nil},;
		{"DTC_LOJDES" ,ZZA->ZZA_LOJDES	    , Nil},;
		{"DTC_CLICON" ,ZZA->ZZA_CLICON 		, Nil},;
		{"DTC_LOJCON" ,ZZA->ZZA_LOJCON 		, Nil},;
		{"DTC_DEVFRE" ,ZZA->ZZA_DEVFRE		, Nil},;
		{"DTC_CLIDEV" ,ZZA->ZZA_CLIDEV 		, Nil},;
		{"DTC_LOJDEV" ,ZZA->ZZA_LOJDEV 		, Nil},;
		{"DTC_CLICAL" ,ZZA->ZZA_CLICAL	 	, Nil},;
		{"DTC_LOJCAL" ,ZZA->ZZA_LOJCAL		, Nil},;
		{"DTC_TIPFRE" ,ZZA->ZZA_TIPFRE		, Nil},;
		{"DTC_SERTMS" ,ZZA->ZZA_SERTMS		, Nil},;
		{"DTC_TIPTRA" ,ZZA->ZZA_TIPTRA		, Nil},;
		{"DTC_SERVIC" ,ZZA->ZZA_SERVIC		, Nil},;
		{"DTC_TIPNFC" ,ZZA->ZZA_TIPNFC		, Nil},;
		{"DTC_SELORI" ,ZZA->ZZA_SELORI		, Nil},;
		{"DTC_CDRORI" ,ZZA->ZZA_CDRORI 		, Nil},;
		{"DTC_CDRDES" ,ZZA->ZZA_CDRDES 		, Nil},;
		{"DTC_CDRCAL" ,ZZA->ZZA_CDRCAL 		, Nil}}
		
		aItem := {	{"DTC_NUMNFC" ,ZZA->ZZA_NUMNFC 		, Nil},;
		{"DTC_SERNFC" ,ZZA->ZZA_SERNFC		, Nil},;
		{"DTC_CODPRO" ,ZZA->ZZA_CODPRO 		, Nil},;
		{"DTC_CODEMB" ,ZZA->ZZA_CODEMB		, Nil},;
		{"DTC_EMINFC" ,STOD(ZZA->ZZA_EMINFC)  , Nil},;
		{"DTC_QTDVOL" ,VAL(ZZA->ZZA_QTDVOL)		, Nil},;
		{"DTC_PESO"   ,VAL(ZZA->ZZA_PESO)		, Nil},;
		{"DTC_PESOM3" ,0 				, Nil},;
		{"DTC_VALOR"  ,VAL(ZZA->ZZA_VALOR)		, Nil},;
		{"DTC_BASSEG" ,0 				, Nil},;
		{"DTC_QTDUNI" ,0 				, Nil},;
		{"DTC_EDI"    ,"2" 				, Nil}}
		
		AAdd(aVetNFc,{	{"DTC_FILIAL",xFilial("DTC")	},;
		{"DTC_NUMNFC",ZZA->ZZA_NUMNFC			},;
		{"DTC_SERNFC",ZZA->ZZA_SERNFC			},;
		{"DTC_CODPRO",ZZA->ZZA_CODPRO	},;
		{"DTC_CLIREM",ZZA->ZZA_CLIREM	},;
		{"DTC_LOJREM",ZZA->ZZA_LOJREM		},;
		{"DTC_QTDVOL",VAL(ZZA->ZZA_QTDVOL)	},;
		{"DTC_PESO"  ,VAL(ZZA->ZZA_PESO)		},;
		{"DTC_PESOM3", 0			},;
		{"DTC_METRO3", 0			},;
		{"DTC_VALOR" ,VAL(ZZA->ZZA_VALOR)	}})
		
		
		AAdd(aItemDTC,aClone(aItem))
		
		XC_DEVFRE := ZZA->ZZA_DEVFRE //Devedor do Frete
		
		ZZA->(dbSkip())
	EndDo 

	//CANAL B
	//-------------------------------------------------------------------
	Do While ZZB->ZZB_NUMERO == _cNumero

		X6_FILDOC  := ZZB->ZZB_FILDOC
		X6_DOC     := ZZB->ZZB_DOC
		X6_SERIE   := ZZB->ZZB_SERIE

		xChvCteOrig 	:= ZZB->ZZB_XCNORI //Chave Cte NF Origem
		xDocTMS		:= ZZB->ZZB_DOCTMS //Documento de Transporte ( 2=CTRC;5=NF;8=COMPLEMENTAR;M=ANULAวรO;P=SUBSTITUIวรO )
		xDocOri    	:= Substr(Substr(ZZB->ZZB_XCNORI,537,044),26,9) //NUMERO DA NOTA Dentro da Chave CTe NF Origem
		xSerOri    	:= Substr(Substr(ZZB->ZZB_XCNORI,537,044),23,3) //SERIE Dentro da Chave CTe NF Origem
		xCodNFe		:= ZZB->ZZB_CODNFE //Codigo do SEFAZ (100 - Normal ou 101|102 Cancelado e Inutilizado

		_lCTeComp	:= .F.
		_lCTeAnul	:= .F.
		_lCTeCanc	:= .F.
	
		If !Empty(xChvCteOrig)
			If (xDocTMS == "8" .or. xDocTMS == "P") //Se este campo estiver preenchido ้ CT-e Complementar ou Substitui็ใo
				_lCTeComp	:= .T.
			ElseIf xDocTMS == "M" //Se este campo estiver preenchido ้ CT-e Anula็ใo
				_lCTeAnul	:= .T.
			EndIf
		EndIf
	
		If substr(alltrim(xCodNFe),1,3) $ "101|102" //Cancelado e Inutilizado
			_lCTeCanc := .T.
		EndIf

		If empty(alltrim(ZZB->ZZB_PRZENT))
			RecLock("ZZB",.F.)
			ZZB->ZZB_PRZENT := ZZB->ZZB_DATEMI
			ZZB->(MsUnLock())
		EndIf
		RecLock("ZZB",.F.)
		ZZB->ZZB_TABFRE := "0002" 			//tiram em Produ็ใo. Somente para HOMOLOGACAO
		ZZB->ZZB_NCONTR := "000000000000002"  //tiram em Produ็ใo. Somente para HOMOLOGACAO
		ZZB->(MsUnLock())
		
		If !_lCTeComp //Se for CT-e Normal
			If XC_DEVFRE == "3" //Quando o Devedor for o Consignatario
				RecLock("ZZB",.F.)
				ZZB->ZZB_CLICON	:= ZZB->ZZB_CLIDEV
				ZZB->ZZB_LOJCON	:= ZZB->ZZB_LOJDEV
				ZZB->(MsUnLock())
			EndIf
		EndIf
		
		AAdd(aVetDoc,{"DT6_FILIAL",xFilial("DT6")})
		AAdd(aVetDoc,{"DT6_FILORI",ZZB->ZZB_FILORI	})
		AAdd(aVetDoc,{"DT6_LOTNFC",cLotNfc		})
		AAdd(aVetDoc,{"DT6_FILDOC",ZZB->ZZB_FILDOC	})
		AAdd(aVetDoc,{"DT6_DOC"   ,ZZB->ZZB_DOC		})
		AAdd(aVetDoc,{"DT6_SERIE" ,ZZB->ZZB_SERIE	})
		AAdd(aVetDoc,{"DT6_DATEMI",STOD(ZZB->ZZB_DATEMI)	})
		AAdd(aVetDoc,{"DT6_HOREMI",ZZB->ZZB_HOREMI	})
		AAdd(aVetDoc,{"DT6_VOLORI",VAL(ZZB->ZZB_VOLORI)})
		AAdd(aVetDoc,{"DT6_QTDVOL",VAL(ZZB->ZZB_QTDVOL)})
		AAdd(aVetDoc,{"DT6_PESO"  ,VAL(ZZB->ZZB_PESO)	})
		AAdd(aVetDoc,{"DT6_PESOM3", 0			})
		AAdd(aVetDoc,{"DT6_PESCOB", 0			})
		AAdd(aVetDoc,{"DT6_METRO3", 0			})
		AAdd(aVetDoc,{"DT6_VALMER",VAL(ZZB->ZZB_VALMER)	})
		AAdd(aVetDoc,{"DT6_QTDUNI", 0			})
		AAdd(aVetDoc,{"DT6_VALFRE",VAL(ZZB->ZZB_VALFRE)	})		//VALOR MERCADORIA
		AAdd(aVetDoc,{"DT6_VALIMP",VAL(ZZB->ZZB_VALIMP)	})		//VALOR ICMS
		AAdd(aVetDoc,{"DT6_VALTOT",VAL(ZZB->ZZB_VALTOT)	})		//VALOR DA NOTA FISCAL
		AAdd(aVetDoc,{"DT6_BASSEG", 0.00		})
		AAdd(aVetDoc,{"DT6_SERTMS",ZZB->ZZB_SERTMS	})
		AAdd(aVetDoc,{"DT6_TIPTRA",ZZB->ZZB_TIPTRA	})
		AAdd(aVetDoc,{"DT6_DOCTMS",ZZB->ZZB_DOCTMS	})
		AAdd(aVetDoc,{"DT6_CDRORI",ZZB->ZZB_CDRORI	})
		AAdd(aVetDoc,{"DT6_CDRDES",ZZB->ZZB_CDRDES	})
		AAdd(aVetDoc,{"DT6_CDRCAL",ZZB->ZZB_CDRCAL	})
		AAdd(aVetDoc,{"DT6_TABFRE",ZZB->ZZB_TABFRE	})
		AAdd(aVetDoc,{"DT6_TIPTAB",ZZB->ZZB_TIPTAB	})
		AAdd(aVetDoc,{"DT6_SEQTAB","00"			})
		AAdd(aVetDoc,{"DT6_TIPFRE",ZZB->ZZB_TIPFRE	})
		AAdd(aVetDoc,{"DT6_FILDES",ZZB->ZZB_FILDES	})
		AAdd(aVetDoc,{"DT6_BLQDOC",ZZB->ZZB_BLQDOC	})
		AAdd(aVetDoc,{"DT6_PRIPER",ZZB->ZZB_PRIPER	})
		AAdd(aVetDoc,{"DT6_PERDCO", 0.00000		})
		AAdd(aVetDoc,{"DT6_FILDCO",""			})
		AAdd(aVetDoc,{"DT6_DOCDCO",""			})
		AAdd(aVetDoc,{"DT6_SERDCO",""			})
		AAdd(aVetDoc,{"DT6_CLIREM",ZZB->ZZB_CLIREM	})
		AAdd(aVetDoc,{"DT6_LOJREM",ZZB->ZZB_LOJREM	})
		AAdd(aVetDoc,{"DT6_CLIDES",ZZB->ZZB_CLIDES	})
		AAdd(aVetDoc,{"DT6_LOJDES",ZZB->ZZB_LOJDES	})
		AAdd(aVetDoc,{"DT6_CLIDEV",ZZB->ZZB_CLIDEV	})
		AAdd(aVetDoc,{"DT6_LOJDEV",ZZB->ZZB_LOJDEV	})
		AAdd(aVetDoc,{"DT6_CLICAL",ZZB->ZZB_CLICAL	})
		AAdd(aVetDoc,{"DT6_LOJCAL",ZZB->ZZB_LOJCAL	})
		AAdd(aVetDoc,{"DT6_DEVFRE",ZZB->ZZB_DEVFRE	})
		AAdd(aVetDoc,{"DT6_FATURA",""			})
		AAdd(aVetDoc,{"DT6_SERVIC",ZZB->ZZB_SERVIC	})
		AAdd(aVetDoc,{"DT6_CODMSG",ZZB->ZZB_CODMSG	})
		AAdd(aVetDoc,{"DT6_STATUS",ZZB->ZZB_STATUS	})
		AAdd(aVetDoc,{"DT6_DATEDI",CToD("//")	})
		AAdd(aVetDoc,{"DT6_NUMSOL",""			})
		AAdd(aVetDoc,{"DT6_VENCTO",CToD("//")	})
		AAdd(aVetDoc,{"DT6_FILDEB",ZZB->ZZB_FILDEB	})
		AAdd(aVetDoc,{"DT6_PREFIX",""			})
		AAdd(aVetDoc,{"DT6_NUM"   ,""			})
		AAdd(aVetDoc,{"DT6_TIPO"  ,""			})
		AAdd(aVetDoc,{"DT6_MOEDA" , 1			})
		AAdd(aVetDoc,{"DT6_BAIXA" ,CToD("//")	})
		AAdd(aVetDoc,{"DT6_FILNEG",""			})
		AAdd(aVetDoc,{"DT6_ALIANC",""			})
		AAdd(aVetDoc,{"DT6_REENTR", 0			})
		AAdd(aVetDoc,{"DT6_TIPMAN",""			})
		AAdd(aVetDoc,{"DT6_PRZENT",STOD(ZZB->ZZB_PRZENT)	})
		AAdd(aVetDoc,{"DT6_FIMP"  ,ZZB->ZZB_FIMP	})
		AAdd(aVetDoc,{"DT6_CHVCTE" ,ZZB->ZZB_CHVCTE	})
		AAdd(aVetDoc,{"DT6_CLICON" ,ZZB->ZZB_CLICON	})
		AAdd(aVetDoc,{"DT6_LOJCON" ,ZZB->ZZB_LOJCON	})
		AAdd(aVetDoc,{"DT6_NFELET" ,ZZB->ZZB_NFELET	})
		AAdd(aVetDoc,{"DT6_EMINFE" ,STOD(ZZB->ZZB_EMINFE)	})
		AAdd(aVetDoc,{"DT6_CODNFE" ,ZZB->ZZB_CODNFE	})
		AAdd(aVetDoc,{"DT6_IDRCTE" ,ZZB->ZZB_IDRCTE	})
		AAdd(aVetDoc,{"DT6_PROCTE" ,ZZB->ZZB_PROCTE	})
		AAdd(aVetDoc,{"DT6_SITCTE" ,ZZB->ZZB_SITCTE	})
		
		If _lCTeComp
			//-- Array aDocOri                                         ณฑฑ
			//-- [1] - Filial Docto Original  (caracter)               ณฑฑ
			//-- [2] - No. Docto Original     (caracter)               ณฑฑ
			//-- [3] - Serie Docto Original   (caracter)               ณฑฑ
			//-- [4] - % Docto. Orignal       (numerico)               ณฑฑ
			//-- [5] - Complemento de Imposto (l๓gico)                 ณฑฑ
			//
			//TMSA500 - MANUTENCAO
			//DT6 - FILDCO
			//    - DOCDCO
			//    - SERDCO
			
			AAdd(aDocOri,ZZB->ZZB_FILIAL)
			AAdd(aDocOri,alltrim(xDocOri) )
			AAdd(aDocOri,alltrim(xSerOri) )
			AAdd(aDocOri,100)
			AAdd(aDocOri,.F.) //.F. Complemento de Valor ; .T. Complemento de Imposto
		ElseIf _lCTeAnul
			AADD(aDocAnul,ZZB->ZZB_DOC)				//DOC
			AADD(aDocAnul,ZZB->ZZB_FILIAL)				//FILDOC
			AADD(aDocAnul,alltrim(xDocOri))		//DOC ORI
			AADD(aDocAnul,alltrim(xSerOri))		//SERIE ORI
		EndIf
		
		X6_CHVCTE  := ZZB_CHVCTE
		X6_CODNFE  := ZZB_CODNFE
		
		ZZB->(dbSkip())
	EndDo 

	//CANAL C
	//-------------------------------------------------------------------
	Do While ZZC->ZZC_NUMERO == _cNumero

		X8_XALIQ  := ZZC->ZZC_XALIQ
		X8_XTES   := ZZC->ZZC_XTES		//Ponto de Entrada - TM200TES
		X8_XCFOP  := ZZC->ZZC_XCFOP		//Ponto de Entrada - M460FIM

		RecLock("ZZC",.F.)
		ZZC->ZZC_TABFRE := "0002" //tiram em Produ็ใo. Somente para HOMOLOGACAO
		ZZC->ZZC_FILORI := "    "
		ZZC->(MsUnLock())
		
		AAdd(aVetVlr,{	{"DT8_FILIAL",xFilial("DT8")},;
		{"DT8_CODPAS",ZZC->ZZC_CODPAS	},;
		{"DT8_VALPAS",VAL(ZZC->ZZC_VALPAS)	},;
		{"DT8_VALIMP",VAL(ZZC->ZZC_VALIMP)	},;
		{"DT8_VALTOT",VAL(ZZC->ZZC_VALTOT)	},;
		{"DT8_FILORI",ZZC->ZZC_FILORI	},;
		{"DT8_TABFRE",ZZC->ZZC_TABFRE	},;
		{"DT8_TIPTAB",ZZC->ZZC_TIPTAB	},;
		{"DT8_FILDOC",ZZC->ZZC_FILDOC	},;
		{"DT8_CODPRO",ZZC->ZZC_CODPRO	},;
		{"DT8_DOC"   ,ZZC->ZZC_DOC		},;
		{"DT8_SERIE" ,ZZC->ZZC_SERIE	},;
		{"VLR_ICMSOL",0}})
		
		AAdd(aVetVlr,{	{"DT8_FILIAL",xFilial("DT8")},;
		{"DT8_CODPAS","TF"			},;
		{"DT8_VALPAS",VAL(ZZC->ZZC_VALPAS)	},;
		{"DT8_VALIMP",VAL(ZZC->ZZC_VALIMP)	},;
		{"DT8_VALTOT",VAL(ZZC->ZZC_VALTOT)	},;
		{"DT8_FILORI",ZZC->ZZC_FILORI	},;
		{"DT8_TABFRE",ZZC->ZZC_TABFRE	},;
		{"DT8_TIPTAB",ZZC->ZZC_TIPTAB	},;
		{"DT8_FILDOC",ZZC->ZZC_FILDOC	},;
		{"DT8_CODPRO",ZZC->ZZC_CODPRO	},;
		{"DT8_DOC"   ,ZZC->ZZC_DOC		},;
		{"DT8_SERIE" ,ZZC->ZZC_SERIE	},;
		{"VLR_ICMSOL",0}})
		
		ZZC->(dbSkip())
		
		lCont     := .T.
		Exit
	EndDo 

	//Documento do Cliente - Se for CT-e Normal
	//-------------------------------------------------------------------
	aLogAutoDTC		:= {}
	lMsErroAuto 		:= .F.
	lMsHelpAuto 		:= .T.
	lAutoErrNoFile 	:= .T.
	If !_lCTeComp
		MSExecAuto({|u,v,x,y,z| TMSA050(u,v,x,y,z)},aCabDTC,aItemDTC,,,3)
		If lMsErroAuto
			CONOUT("["+LEFT(DTOC(Date()),5)+"]["+LEFT(Time(),5)+"][DTMSA006] Erro DTC "+cEmpAnt+"-"+cFilAnt)
			aLogAutoDTC := GetAutoGRLog()
			//For _nY := 1 to Len(aLogAutoDTC)
			//	CONOUT("["+LEFT(DTOC(Date()),5)+"]["+LEFT(Time(),5)+"][DTMSA006] LOG "+aLogAutoDTC[_nY])
			//Next _nY
			DisarmTransaction()
			lMsErroAuto := .F.
			lCont := .F.
		EndIf
	EndIf

	//CT-e Anula็ใo
	//-------------------------------------------------------------------
	aLogAutoANU := {}
	If _lCTeAnul
		LTM500CON := .F.
		dbSelectArea("DT6")
		dbSetorder(1)
		If dbseek(xFilial("DT6")+aDocAnul[2]+aDocAnul[3]+aDocAnul[4])
			Reclock("DT6",.F.)
			DT6->DT6_STATUS := "7"
			MsUnLock() //EndIf
			U_TmsA_500Anu()
		EndIf
	EndIf

	//TMSIMPDOC (Finaliza o processo Gravando as demais tabelas (LIVROS)
	//-------------------------------------------------------------------
	If lCont
	//  Executa o Calculo do Frete para gera็ใo da Nota Fiscal (SF2,SD2,SF3,SFT)
		aErrMsg := TMSImpDoc(aVetDoc,aVetVlr,aVetNFc,cLotNfc,.F.,val(X8_XALIQ),1,.F.,.F.,.F.,.F.,aDocOri) //alterado para .F. pois as msg estao sendo gravas em um LOG.
		If !Empty(aErrMsg)
			DisarmTransaction()
		Else
			_xAreaDT6 := GetArea()
			dbSelectArea("DT6")
			dbSetorder(1) //FILIAL + FILDOC + DOC + SERIE
			_nPosFil := ascan(aVetDoc, {|x| x[1] == "DT6_FILDOC"})
			_nPosDoc := ascan(aVetDoc, {|x| x[1] == "DT6_DOC"})
			_nPosSer := ascan(aVetDoc, {|x| x[1] == "DT6_SERIE"})
			If DT6->(dbseek(xFilial("DT6")+ aVetDoc[_nPosFil,2]+aVetDoc[_nPosDoc,2]+aVetDoc[_nPosSer,2]))
				_nPosNfe := ascan(aVetDoc, {|x| x[1] == "DT6_NFELET"}) 
				_nPosEmi := ascan(aVetDoc, {|x| x[1] == "DT6_EMINFE"}) 
				_nPosCod := ascan(aVetDoc, {|x| x[1] == "DT6_CODNFE"}) 
				_nPosID  := ascan(aVetDoc, {|x| x[1] == "DT6_IDRCTE"}) 
				_nPosPro := ascan(aVetDoc, {|x| x[1] == "DT6_PROCTE"}) 
				_nPosChv := ascan(aVetDoc, {|x| x[1] == "DT6_CHVCTE"}) 
				_nPosSit := ascan(aVetDoc, {|x| x[1] == "DT6_SITCTE"}) 
				Reclock("DT6",.F.)
				DT6->DT6_NFELET  := aVetDoc[_nPosNfe,2]
				DT6->DT6_EMINFE  := aVetDoc[_nPosEmi,2]
				DT6->DT6_CODNFE  := aVetDoc[_nPosCod,2]
				DT6->DT6_IDRCTE  := aVetDoc[_nPosID,2]
				DT6->DT6_PROCTE  := aVetDoc[_nPosPro,2]
				DT6->DT6_CHVCTE  := aVetDoc[_nPosChv,2]
				DT6->DT6_SITCTE  := aVetDoc[_nPosSit,2]
				MsUnLock()

//************************************************* 
				_nPosCli := ascan(aVetDoc, {|x| x[1] == "DT6_CLIDEV"})
				_nPosLoj := ascan(aVetDoc, {|x| x[1] == "DT6_LOJDEV"})
				
				_Cliente := aVetDoc[_nPosCli,2]
				_Loja    := aVetDoc[_nPosLoj,2]
				
				cTESAnula  := SuperGetMv("MV_TESANUL",,"")
				_cCFAnul := Posicione("SF4", 1, xFilial("SF4")+cTESAnula, "F4_CF")
				_cEstCli := Posicione("SA1", 1, xFilial("SA1")+_Cliente+_Loja, "A1_EST")
				_cEstEmp := SM0->M0_ESTCOB
				
				X6_FILDOC := aVetDoc[_nPosFil,2]
				X6_DOC    := aVetDoc[_nPosDoc,2]
				X6_SERIE  := aVetDoc[_nPosSer,2]
				
				_nPosDTMS := ascan(aVetDoc, {|x| x[1] == "DT6_DOCTMS"})
				
				X6_DOCTMS := aVetDoc[_nPosDTMS,2]
				
				X6_CHVCTE := aVetDoc[_nPosChv,2]
				X6_CODNFE := aVetDoc[_nPosCod,2]
				
				_xCFOP		:= X8_XCFOP
				
				DbSelectArea("SF2")
				DbSetOrder(1)
				If DbSeek(X6_FILDOC+X6_DOC+X6_SERIE+_Cliente+_Loja)
					If ALLTRIM(X6_DOCTMS) == "8" //Complementar
						RecLock("SF2",.F.)
						SF2->F2_TIPO := "C"
						MsUnLock()
					EndIf
				EndIf
					
				DbSelectArea("SD2")
				DbSetOrder(3)
				If DbSeek(X6_FILDOC+X6_DOC+X6_SERIE+_Cliente+_Loja)
					Do While !EOF() .and. X6_FILDOC+X6_DOC+X6_SERIE+_Cliente+_Loja == SD2->(D2_FILIAL+D2_DOC+D2_SERIE+D2_CLIENTE+D2_LOJA)
						RecLock("SD2",.F.)
						SD2->D2_CF := _xCFOP
						If ALLTRIM(X6_DOCTMS) == "8" //Complementar
							SD2->D2_TIPO := "C"
						EndIf
						MsUnLock()
						SD2->(DbSkip())
					EndDo
				EndIf
					
				DbSelectArea("SF3")
				DbSetOrder(5)
				If DbSeek(X6_FILDOC+X6_SERIE+X6_DOC+_Cliente+_Loja)
					RecLock("SF3",.F.)
					SF3->F3_CFO     := _xCFOP
					SF3->F3_CHVNFE  := IIF(alltrim(X6_CODNFE) == "102", "", X6_CHVCTE) //Codigo de CT-e Inutilizado. Para esses casos a Chave tem que ser Branca
					SF3->F3_CODRSEF := X6_CODNFE
					If ALLTRIM(X6_DOCTMS) == "8" //Complementar
						SF3->F3_TIPO := "C"
					EndIf
					MsUnLock()
				EndIf
						
				DbSelectArea("SFT")
				DbSetOrder(1)
				If DbSeek(X6_FILDOC+"S"+X6_SERIE+X6_DOC+_Cliente+_Loja)
					Do While !EOF() .and. X6_FILDOC+"S"+X6_SERIE+X6_DOC+_Cliente+_Loja == SFT->(FT_FILIAL+FT_TIPOMOV+FT_SERIE+FT_NFISCAL+FT_CLIEFOR+FT_LOJA) 
						RecLock("SFT",.F.)
						SFT->FT_CFOP    := _xCFOP
						SFT->FT_CHVNFE  := IIF(alltrim(X6_CODNFE) == "102", "", X6_CHVCTE) //Codigo de CT-e Inutilizado. Para esses casos a Chave tem que ser Branca
						If ALLTRIM(X6_DOCTMS) == "8" //Complementar
							SFT->FT_TIPO := "C"
						EndIf
						MsUnLock()
						SFT->(DbSkip())
					EndDo
				EndIf	
				
				If ALLTRIM(X6_DOCTMS) == "M" //Anula็ใo
					If _cEstCli == "EX"
						_cCFAnul := "3"+Substr(_cCFAnul,2,3)
					ElseIf _cEstCli == _cEstEmp
						_cCFAnul := "1"+Substr(_cCFAnul,2,3)
					ElseIf _cEstCli <> _cEstEmp
						_cCFAnul := "2"+Substr(_cCFAnul,2,3)
					Else
						_cCFAnul := _cCFAnul
					EndIf
			
					DbSelectArea("SD1")
					DbSetOrder(1)
					If DbSeek(X6_FILDOC+X6_DOC+X6_SERIE+_Cliente+_Loja)
						Do While !EOF() .and. X6_FILDOC+X6_DOC+X6_SERIE+_Cliente+_Loja == SD1->(D1_FILIAL+D1_DOC+D1_SERIE+D1_FORNECE+D1_LOJA)
							RecLock("SD1",.F.)
							SD1->D1_CF      := _cCFAnul
							MsUnLock()
							SD1->(DbSkip())
						EndDo
					EndIf
			
					DbSelectArea("SF3")
					DbSetOrder(5)
					If DbSeek(X6_FILDOC+X6_SERIE+X6_DOC+_Cliente+_Loja)
						RecLock("SF3",.F.)
						SF3->F3_CFO     := _cCFAnul
						MsUnLock()
					EndIf
			
					DbSelectArea("SFT")
					DbSetOrder(1)
					If DbSeek(X6_FILDOC+"E"+X6_SERIE+X6_DOC+_Cliente+_Loja)
						Do While !EOF() .and. X6_FILDOC+"E"+X6_SERIE+X6_DOC+_Cliente+_Loja == SFT->(FT_FILIAL+FT_TIPOMOV+FT_SERIE+FT_NFISCAL+FT_CLIEFOR+FT_LOJA) 
							RecLock("SFT",.F.)
							SFT->FT_CFOP    := _cCFAnul
							MsUnLock()
						SFT->(DbSkip())
						EndDo
					EndIf	
			
				EndIf

//*************************************************

			EndIf
	
			//Processa Notas Fiscal Cancelada (exclusใo do Documento)
			//-------------------------------------------------------------------
			If substr(alltrim(DT6->DT6_CODNFE),1,3) $ "101|102" //conforme Informa็ใo do Retorno do SEFAZ
				u_DelCTRC() //Efetua a Exclusใo dos Registros no sistema
			EndIf
	
			RestArea(_xAreaDT6)
		EndIf
	EndIf

	//Volta Filial selecionada
	cFilAnt := cFilBkp
	_cLogDTC:= ""
	_cLogAnu:= ""
	DbSelectArea("ZZ0")
	DbOrderNickname("ZZ0IND2") //Numero
	If DbSeek(xFilial("ZZ0")+_cNumero)
		RecLock("ZZ0",.F.)
		ZZ0->ZZ0_STATUS 	:= "2" //Processado
		ZZ0->ZZ0_DTFIM 	:= Date()
		ZZ0->ZZ0_HRFIM	:= Time()
		If !Empty(aLogAutoDTC)
			For _nY := 1 to Len(aLogAutoDTC)
				_cLogDTC+= aLogAutoDTC[_nY]+chr(13)+chr(10)
			Next _nY

			ZZ0->ZZ0_STATUS := "3" //Pendente
			ZZ0->ZZ0_DETAL	:= _cLogDTC
		ElseIf !Empty(aErrMsg)
			ZZ0->ZZ0_STATUS 	:= "3" //Pendente
			ZZ0->ZZ0_DETAL	:= aErrMsg[1,1]
		ElseIf !Empty(aLogAutoANU)
			For _nY := 1 to Len(aLogAutoANU)
				_cLogAnu+= aLogAutoANU[_nY]+chr(13)+chr(10)
			Next _nY

			ZZ0->ZZ0_STATUS 	:= "3" //Pendente
			ZZ0->ZZ0_DETAL	:= _cLogAnu
		EndIf
		ZZ0->ZZ0_PROC := "N"
		ZZ0->(MsUnLock())	
	EndIf

	If Empty(aLogAutoDTC) .and. Empty(aLogAutoANU) .and. Empty(aErrMsg)
		RecLock("ZZ0",.F.)
		dbDelete()
		ZZ0->(MsUnLock())
	EndIf

RestArea(_aAreaThr)

RpcClearEnv()

Return