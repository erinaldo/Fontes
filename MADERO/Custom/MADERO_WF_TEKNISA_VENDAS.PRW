/*                                          
+------------------+-------------------------------------------------------------------------------+
! Nome             ! FATWF02                                                                       !
+------------------+-------------------------------------------------------------------------------+
! Descrição        ! Função para executar a integração de vendas                                   !
!                  !                                                                               !
+------------------+-------------------------------------------------------------------------------+
! Autor            ! Márcio Zaguetti                                                               !
+------------------+-------------------------------------------------------------------------------+
! Data             ! 14/05/2018                                                                    !
+------------------+-------------------------------------------------------------------------------+
! Parametros       ! N/A                                                                           !
+------------------+-------------------------------------------------------------------------------+
! Retorno          ! N/A                                                                           !
+------------------+-------------------------------------------------------------------------------+
*/                                                                                
#Include 'Protheus.ch'
#Include "topconn.ch"
#Include "Protheus.ch"
#Include "rwmake.ch"
#Include "TBICONN.CH"
        
User Function FATWF02(lBatch)
Local dDataIni:= Date()
Local dDataFim:= Date()
Local cEmpresa := AllTrim(GetSrvProfString('Empresa',''))
Local cEmpAux  := AllTrim(GetSrvProfString('Filiais',''))
Local aEmp     := {}
Local nx       := 0
Local aParam   := {}
Local aDados   := {}
Default lBatch := .T.

	// -> Carrega parâmetros iniciais
	aParam := {{cEmpresa, SubStr(cEmpAux,1,10)}}
	RpcClearEnv()
		RPcSetType(3)
		RpcSetEnv( aParam[1,1],aParam[1,2], , ,'FAT' , GetEnvServer() )
	    OpenSm0(aParam[1,1], .f.)
    	nModulo := 5
	    SM0->(dbSetOrder(1))
    	SM0->(dbSeek(aParam[1,1]+aParam[1,2]))
	    cEmpAnt := SM0->M0_CODIGO
	    cFilAnt := SM0->M0_CODFIL
		dDataIni:=dDataFim-SuperGetMV("MV_XDVDINT",,2)

		// -> Busca todas as unidades de negócio
		DbSelectArea("ADK")
		ADK->(DbGoTop())
		aParam:={}
		While !ADK->(Eof())
		   If ADK->ADk_XFILI <> ""
	   	      Aadd(aParam,{cEmpresa,ADK->ADK_XFILI})
	   	   EndIf   
		ADK->(DbSkip())
		EndDo

	RpcClearEnv()

	// -> Verifica parâmetros da empresa
	If SubStr(cEmpAux,11,1) == "-"
	   // -> Seleciona as empresas informadas no parâmetro
	   aParam := {}
	   aEmp   := StrToKarr(cEmpAux,'-')
	   For nx:=1 to Len(aEmp)
	   	  Aadd(aParam,{cEmpresa,aEmp[nx]}) 
	   Next nx	  
	Endif

	// -> Executa processo para todas as empresas
	For nx:=1 to Len(aParam)

		aDados     := {} 
		dIniAux    := dDataFim-SuperGetMV("MV_XDVDINT",,2) // SuperGetMv("MV_XDATUTO",,2)	   	
	   	cFunNamAnt := FunName()
		SetFunName("FATWF02")
	   	
		dDataIni := dIniAux	   	
	   	While dDataIni <= dDataFim
	   		
	   		aDados:={}
			aadd(aDados,dDataIni)  
			aadd(aDados,aParam[nx,1]) 
			aadd(aDados,aParam[nx,2]) 

			startJob("u_StartVda", GetEnvServer(), .T., aDados)

			dDataIni:=dDataIni+1		

		EndDo
		
		SetFunName(cFunNamAnt)
			
	Next nx

Return()



 /*                                          
+------------------+-------------------------------------------------------------------------------+
! Nome             ! StartVda                                                                      !
+------------------+-------------------------------------------------------------------------------+
! Descrição        ! Inicia job para carga das vendas do teknisa                                   !
!                  !                                                                               !
+------------------+-------------------------------------------------------------------------------+
! Autor            ! Márcio Zaguetti                                                               !
+------------------+-------------------------------------------------------------------------------+
! Data             ! 14/05/2018                                                                    !
+------------------+-------------------------------------------------------------------------------+
*/                                                                                
User Function StartVda(paramixb)
Local dData:=paramixb[1]
Local cEmp :=paramixb[2]
Local cFil :=paramixb[3]	   		   	

	// -> Inicializa ambiente
	PREPARE ENVIRONMENT Empresa cEmp filial cFil Tables "Z01","Z02","Z03","Z04","Z05","ADK","SX5" Modulo "FAT"
	nModulo  := 5
	dDataBase:= dData     		   	
	
	// -> Posiciona nas eunidades de negócio : Unidade de negócio
	DbSelectArea("ADK")
	ADK->(DbOrderNickName("ADKXFILI"))
	ADK->(ADK->(DbSeek(Space(TamSX3("ADk_FILIAL")[1])+cFilAnt)))

	// -> Vendas
	u_TkGetPed(.T.,dData,dData)            
		
	// -> Fechamento do caixa
	u_TkGetFec(.T.,dData)
			
	RESET ENVIRONMENT
	
Return()