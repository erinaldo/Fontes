#INCLUDE "RWMAKE.CH"
#INCLUDE "TBICONN.CH"
#INCLUDE "TOPCONN.CH"
#INCLUDE "PROTHEUS.CH"
#INCLUDE 'PARMTYPE.CH'
#INCLUDE 'FILEIO.CH'

User Function JOB001(_APARAMS)

_cEmpresa  :=  '01' //_APARAMS[1]
_cFilial   :=  '01GDAD0001' //_APARAMS[2]

PREPARE ENVIRONMENT EMPRESA Alltrim(_cEmpresa) FILIAL Alltrim(_cFilial) FUNNAME "JOB001"
RpcSetEnv(Alltrim(_cEmpresa),Alltrim(_cFilial))

// ROTINA PARA COPIAR O ARQUIVO 
	JOB001A()	
	JOB002A()
Return

// DDA
Static Function JOB001A()

Private nArqs    := 0
Private aArqs    := {}

//_cDirSrv:= GetSrvProfString ("StartPath","") // Retorna o RootPath definido no ini do server
//_cDirLid:= _cDirSrv

_cDirSrv:= 'C:\Temp\CNAB\DDA\NOVOS\*.*' 
//_cDirGrv:= _cDirLid+'\CNAB\DDA\LIDOS\' 

aArqs:= Directory(_cDirSrv ,)

If Len(aArqs) > 0
	JOB001B()
	//CPYS2T(_cDirSrv,_cDirGrv,.F.,)           
EndIf
                
Return

Static Function JOB001B()

	Local nx:= 0
	

//³ MV_PAR01: Mostra Lanc. Contab  ? Sim Nao           ³
//³ MV_PAR02: Aglutina Lanc. Contab? Sim Nao           ³
//³ MV_PAR03: Arquivo de Entrada   ?                   ³
//³ MV_PAR04: Arquivo de Config    ?                   ³
//³ MV_PAR05: Banco                ?                   ³
//³ MV_PAR06: Agencia              ?                   ³
//³ MV_PAR07: Conta                ?                   ³
//³ MV_PAR08: SubConta             ?                   ³
//³ MV_PAR09: Contabiliza          ?                   ³
//³ MV_PAR10: Padrao Cnab          ? Modelo1 Modelo 2  ³
//³ MV_PAR11: Processa filiais     ? Modelo1 Modelo 2  ³

	Private MV_PAR01:= '2'
	Private MV_PAR02:= '2'
	Private MV_PAR03:= ''
	Private MV_PAR04:= ''
	Private MV_PAR05:= ''
	Private MV_PAR06:= ''
	Private MV_PAR07:= ''
	Private MV_PAR08:= ''
	Private MV_PAR09:= '2'
	Private MV_PAR10:= 2
	Private MV_PAR11:= 2
	Private MV_PAR12 
	
	
	
	For nX:= 1 To Len(aArqs) 
		
		MV_PAR03:= 'C:\Temp\CNAB\DDA\NOVOS\'+aArqs[nX][1] 
		MV_PAR04:= 'DDA.2PR'
		
		 oFile := FWFileReader():New(Alltrim(MV_PAR03))
		 nTam:= 0
		 //Se o arquivo pode ser aberto
		    If (oFile:Open())
		        //Se não for fim do arquivo
		        If ! (oFile:EoF())
		        	While (oFile:HasLine())
		        		cLinAtu := oFile:GetLine()
		        		cBanco:= SubStr(cLinAtu,1,3)
		        		cContr:= SubStr(cLinAtu,19,14)
		        		
		        	/*	cQuery:= " SELECT * FROM " + RETSQLNAME('SEE') + " SEE"
		        		cQuery+= " WHERE SEE.D_E_L_E_T_ <> '*' "
		        		cQuery+= " AND SEE.EE_CODIGO = '" + cBanco + "' "
		        		cQuery+= " AND SEE.EE_NUNCTR = '" + cContr + "' "
		        		
		        		If (Select("QRY") <> 0)
							DbSelectArea("QRY")
							QRY->(DbCloseArea())
						Endif
							
						TCQuery cQuery new Alias "QRY"
					    If !QRY->(EOF())*/
					    	MV_PAR05:= '341'//QRY->EE_CODIGO
							MV_PAR06:= '0274'//QRY->EE_AGENCIA
							MV_PAR07:= '01210'//QRY->EE_CONTA
							MV_PAR08:= 'DDA'//QRY->EE_SUBCTA
		        		//EndIf
		        	EndDo
		        EndIf
		        U_xFinA430(1)
		    EndIf
		    
	Next nX
Return

// EXTRATO
Static Function JOB002A()

Private nArqs    := 0
Private aArqs    := {}

_cDirSrv:= GetSrvProfString ("ROOTPATH","") // Retorna o RootPath definido no ini do server
_cDirLid:= _cDirSrv

_cDirSrv+= '\CNAB\EXTRATO\NOVOS\*.*' 
_cDirGrv:= _cDirLid+'\CNAB\EXTRATO\LIDOS\' 

aArqs:= Directory( _cDirSrv , , , , )

If Len(aArqs) > 0
	JOB002B()
	//CPYS2T(_cDirSrv,_cDirGrv,.F.,)           
EndIf
                
Return

Static Function JOB002B()

	Local nx        := 0
	Private aLog    := {}
	Private aLogLanc:= {}
	Private aConfig1:= {}
	Private aConfig2:= {}

	For nX:= 1 To Len(aArqs) 	
			
		MV_PAR03:= aArqs[nX][1] 
		
		 oFile := FWFileReader():New(Alltrim(MV_PAR03))
		 nTam:= 0
		 //Se o arquivo pode ser aberto
		    If (oFile:Open())
		        //Se não for fim do arquivo
		        If ! (oFile:EoF())
		        	While (oFile:HasLine())
		        		cLinAtu := oFile:GetLine()
		        		cBanco:= SubStr(cLinAtu,1,3)
		        		cContr:= SubStr(cLinAtu,19,14)
		        		
		        		cQuery:= " SELECT * FROM '" + RETSQLNAME('SEE') + " ' SEE"
		        		cQuery+= " WHERE SEE.D_E_L_E_T_ <> '*' "
		        		cQuery+= " AND SEE.EE_CODIGO = '" + cBanco + "' "
		        		cQuery+= " AND SEE.EE_NUNCTR = '" + cContr + "' "
		        		
		        		If (Select("QRY") <> 0)
							DbSelectArea("QRY")
							QRY->(DbCloseArea())
						Endif
							
						TCQuery cQuery new Alias "QRY"
					    If !QRY->(EOF())
					    	aConfig1[2]  := QRY->EE_CODIGO
							aConfig1[3]  := QRY->EE_AGENCIA
							aConfig1[4]  := QRY->EE_CONTA
							aConfig1[5]  := QRY->EE_SUBCTA
							aConfig1[6]  := 'Executado Schedule'
		        		EndIf
		        	EndDo
		        EndIf
		    EndIf
		    aConfig2[1]:= ''
		    aConfig2[2]:= Alltrim(MV_PAR03)
		    U_FImpExt(aConfig1,aConfig2, '3', aLog, aLogLanc)
	Next nX
Return



