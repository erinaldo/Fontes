/*                                                    
+------------------+-------------------------------------------------------------------------------+
! Nome             ! FATWF02A                                                                      !
+------------------+-------------------------------------------------------------------------------+
! Descrição        ! Função para executar o processo de atualização das venda e fechamento de caixa!
!                  ! em job                                                                        !
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
        
User Function FATWF02A(lBatch)
Local dDataFim  := Date() //StoD("20180615")
Local dDataIni  
Local cEmpresa := AllTrim(GetSrvProfString('Empresa',''))
Local cEmpAux  := AllTrim(GetSrvProfString('Filiais',''))
Local aEmp     := {}
Local nx       := 0
Local aParam   := {}
Default lBatch := .T.

	// -> Verifica parâmetros da empresa
	If lBatch
	   If SubStr(cEmpAux,11,1) == "-"
	      // -> Seleciona as empresas informadas no parâmetro
	      aEmp := StrToKarr(cEmpAux,'-')
	      For nx:=1 to Len(aEmp)
	   	     Aadd(aParam,{cEmpresa,aEmp[nx]})
	      Next nx	  
	   Else
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
	   Endif
	Else
	   aParam := {{cEmpAnt, cFilAnt}}
	Endif

	// -> Executa processo para todas as empresas
	For nx:=1 to Len(aParam)

		If lBatch
			RpcClearEnv()
			RPcSetType(3)
    		RpcSetEnv( aParam[nx,1],aParam[nx,2], , ,'FAT' , GetEnvServer() )
    		OpenSm0(aParam[nx,1], .f.)
			nModulo := 5
			SM0->(dbSetOrder(1))
			SM0->(dbSeek(aParam[nx,1]+aParam[nx,2]))
			cEmpAnt  := SM0->M0_CODIGO
			cFilAnt  := SM0->M0_CODFIL
	    EndIf
	    		   	
	   	// -> Posiciona nas eunidades de negócio : Unidade de negócio
	   	DbSelectArea("ADK")
	   	ADK->(DbOrderNickName("ADKXFILI"))
	   	ADK->(ADK->(DbSeek(Space(TamSX3("ADk_FILIAL")[1])+cFilAnt)))

		dIniAux    := dDataFim-SuperGetMV("MV_XDVDINT",,2) // SuperGetMv("MV_XDATUTO",,2)	   	
	   	cFunNamAnt := FunName()
		SetFunName("FATWF02A")
	   	
        dDataIni := dIniAux
        While dDataIni <= dDataFim    
            
			// -> Autorização de vendas
		    //u_AWS012(DtoS(dDataIni))  
		    //dDataIni:=dDataIni+1       
		    	
		    // -> Fechamento do caixa
		    u_TkGetFec(.T.,dDataIni)   
		    	
		    dDataIni := dDataIni + 1

        EndDo
		
		SetFunName(cFunNamAnt)
		
		If lBatch		
			RpcClearEnv()
		EndIf	
	
	Next nx

Return()