/*                                                    
+------------------+-------------------------------------------------------------------------------+
! Nome             ! FATWF01                                                                       !
+------------------+-------------------------------------------------------------------------------+
! Descri��o        ! Fun��o para executar o processo de integra��o dos cadastros em WF             !
!                  !                                                                               !
+------------------+-------------------------------------------------------------------------------+
! Autor            ! M�rcio Zaguetti                                                               !
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
        
User Function FATWF01()
Local cEmpresa  := "02"
Local aEmp   	:= {}
Local lAbre   	:= (Type('cEmpAnt') == 'U') .and. (Type('cFilAnt') == 'U')
Local cQuery    := ""
Local nx 		:= 0
       
    // -> Se a execu��o for por job    
    If lAbre
                     
    	// -> Seleciona empresa corrente
    	cEmpresa:=GetSrvProfString('Empresa','')       
    	
    	If SubStr(GetSrvProfString('Filiais',''),11,1) == "*"

		    // -> Seleciona as empresas informadas no par�metro
			aEmp:=StrToKarr(GetSrvProfString('Filiais',''),'*')

	        // -> Inicia o ambiente
    	    RpcClearEnv()        
        	RpcSetType(3) 
	        RpcSetEnv(cEmpresa,aEmp[1],,,'FAT',GetEnvServer())                           
    	    OpenSm0(cEmpresa,.f.)
	    	nModulo:=5                                  
	    	
            // -> Seleciona as filiais
			cQuery := "SELECT * FROM ADK010        	"
			cQuery += "WHERE D_E_L_E_T_ <> '*'     	"
			cQuery += "AND ADK_XFILI != '          '"
			cQuery += "AND ADK_XEMP != '01'			"
			cQuery += "AND ADK_XEMP != '06'			"
			cQuery += "ORDER BY ADK_XFILI, ADK_XEMP, ADK_XFIL "
	        dbUseArea(.T.,"TOPCONN",TcGenQry(,,cQuery),"TMPADKX",.T.,.T.)	
	        
	        aEmp:={}	        
    	    TMPADKX->(DbGoTop())
        	While !TMPADKX->(Eof())
				aadd(aEmp,TMPADKX->ADK_XFILI)   
				TMPADKX->(DbSkip())
	        EndDo
	        DbSelectArea("TMPADKX")
	        DbCloseArea()

		Else

		    // -> Seleciona as empresas informadas no par�metro
			aEmp:=StrToKarr(GetSrvProfString('Filiais',''),'-')

	        // -> Inicia o ambiente
    	    RpcClearEnv()        
        	RpcSetType(3) 
	        RpcSetEnv(cEmpresa,aEmp[1],,,'FAT',GetEnvServer())                           
    	    OpenSm0(cEmpresa,.f.)
	    	nModulo:=5                                  

        EndIf

	    // -> Executa o porcesso para todas as empresas selecionadas
	    For nx:=1 to Len(aEmp)

	    	// -> Posiciona na empresa / filial
	    	DbSelectArea("SM0")
	    	SM0->(DbSetOrder(1))
	    	SM0->(DbSeek(cEmpresa+aEmp[nx]))
	    	cEmpAnt:=SM0->M0_CODIGO
	    	cFilAnt:=SM0->M0_CODFIL

	    	// -> Cadastro de unidades de neg�cios
	    	u_TkPutUnid(.T.)           
	    	
	    	// -> Cadastro de recebimentos
	    	u_TkPutReceb(.T.)
                                          
			// -> Cadastro de produtos
            u_TkPutProds(.T.)

			// -> Ativa��o de produtos
            u_TkPutPAt(.T.)  
                                      
            // -> Cadastro de impostos
            u_TkPutImp(.T.)           
            
            // -> Cadastro de estrutura de produ��o
            u_TkPutCompo(.T.)
            
            // -> Cadastro de clientes
            u_TkPutClie(.T.)

		Next nx   
		             		
		// -> Finaiza o ambiente
		RpcClearEnv()
		
		ConOut("Executou as "+Time())
	
	Else
	      
	    	
	    // -> Cadastro de unidades de neg�cios
	    u_TkPutUnid(.T.)           
	    	
	    // -> Cadastro de recebimentos
	    u_TkPutReceb(.T.)
                                          
		// -> Cadastro de produtos
        u_TkPutProds(.T.)

		// -> Ativa��o de produtos
        u_TkPutPAt(.T.)  
                                      
        // -> Cadastro de impostos
        u_TkPutImp(.T.)           
            
        // -> Cadastro de estrutura de produ��o
        u_TkPutCompo(.T.)
            
        // -> Cadastro de clientes
        u_TkPutClie(.T.)
	
	
	Endif

Return()