#include "rwmake.ch"
#include "totvs.ch"
#include "TopConn.ch"
#INCLUDE "TBICONN.CH" 
#Include "parmtype.ch"

/*---------------------------------------------------------------------------+
!                         FICHA TECNICA DO PROGRAMA                          !
+----------------------------------------------------------------------------+
!   DADOS DO PROGRAMA                                                        !
+------------------+---------------------------------------------------------+
!Tipo              ! JOB                                                     !
+------------------+---------------------------------------------------------+
!Modulo            ! FAT - FATURAMENTO                                       !
+------------------+---------------------------------------------------------+
!Nome              ! MADERO_AFAT300	                                         !
+------------------+---------------------------------------------------------+
!Descricao         ! GERAÇÃO DE VENDAS       		    			         !
+------------------+---------------------------------------------------------+
!Atualizado por    ! ALAN LUNARDI                          			 		 !
+------------------+---------------------------------------------------------+
!Data de Criacao   ! 15/05/2018                                              !
+------------------+--------------------------------------------------------*/   
#Include 'Protheus.ch'
#Include "topconn.ch"
#Include "Protheus.ch"
#Include "rwmake.ch"
#Include "TBICONN.CH"        
User Function FAT300()
Local cEmpresa  := AllTrim(GetSrvProfString('Empresa',''))
Local cEmpAux   := AllTrim(GetSrvProfString('Filiais',''))
Local aEmp      := {}
Local nx        := 0
Local aParam    := {}
Local cAuxLog   := ""
Local lRet      := .F.
Local aDados    := {}
Local dDataProc := CtoD("  /  /  ")
Local oEventLog
Local nIdThrMast:= ThreadId()
Private lMsErroAuto := .F.

	/*  A tratativa abaixo foi colocada temporariamente
		pois a função está sendo chamada quando o execauto da mata250 é chamado
		via job. Assim que possível, investigar a causa, e remover o if abaixo.
		Filipe Nanclarez - TOTVS Vale do Paraiba
	*/ 
	If ProcName(6) == "MATA250"
		return
	end if

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

    	// -> Carrega os dados da empresa
		nModulo := 5
	    SM0->(dbSetOrder(1))
    	SM0->(dbSeek(aParam[nx,1]+aParam[nx,2]))
	    cEmpAnt  := SM0->M0_CODIGO
	    cFilAnt  := SM0->M0_CODFIL
		dDataProc:=StoD(u_F300LD2(cFilAnt))

		If !Empty(dDataProc)
			// -> inicializa o Log do Processo
			oEventLog:=EventLog():start("Vendas - ERP", dDataProc, "Iniciando processo de integracao de vendas no ERP...","FAT", "SF2")
			nRecLog  :=oEventLog:GetRecno()
		Else
			// -> inicializa o Log do Processo
			oEventLog:=EventLog():start("Vendas - ERP", dDataProc, "Sem dados para integracao.","FAT", "SF2")
			nRecLog  :=oEventLog:GetRecno()
			cAuxLog:=StrZero(nIdThrMast,10)+": Nao existem dados para integrar [Z01_DATA = "+DtoC(dDataProc)+"]"
			oEventLog:SetAddInfo(cAuxLog,"")
			Conout(cAuxLog)                
			oEventLog:finish()
			Loop
		EndIf	

	   	aDados:={}
		aadd(aDados,aParam[nx,1]) 
		aadd(aDados,aParam[nx,2]) 
		aadd(aDados,nRecLog)
		aadd(aDados,nIdThrMast)
		startJob("U_F300PROC", GetEnvServer(), .T., aDados)
		
		oEventLog:finish()

		RpcClearEnv()

	Next nx

Return()



/*
+------------------+---------------------------------------------------------+
!Nome              ! F300PROC                                                !
+------------------+---------------------------------------------------------+
!Descricao         ! F300PROC - Processamento dos dados                      !
+------------------+---------------------------------------------------------+
!Autor             ! Alan Lunardi                                            !
+------------------+---------------------------------------------------------+
!Data de Criacao   ! 27/07/2018                                              !
+------------------+---------------------------------------------------------+
*/
User Function F300PROC(paramixb) 
Local cEmp :=paramixb[1]
Local cFil :=paramixb[2]	   		   	
Local oEventLog
Local lErro    	:= .F.
Local cAuxLog  	:= ""
Local dDataProc	:= CtoD("  /  /  ")
Local cQuery   	:= ""
Local cAliasZ13	:= GetNextAlias()
Local cAliasSG1	:= GetNextAlias()
Local cAliasSG1A:= GetNextAlias()
Local cAliasSA1 := GetNextAlias()
Local cAliasZ04 := GetNextAlias()
Local cAliasZ04A:= GetNextAlias()
Local cAliasZ03 := GetNextAlias()
Local cAliasZWE := GetNextAlias()
Local nAux  	:= 0
Local lFoundSA1	:=.F.
Local lFoundSB1	:=.F.
Local lFoundSF7	:=.F.
Local lFoundGRT	:=.F.
Local aSF7     	:= {}
Local nStatus   := 0
Local _aPen	    := {} 
Local ny        := 0
Local cCodEmp   := ""
Local cCodFil   := ""
Local aBcAgCo   := ""
Local cBcLoja	:= ""
Local cAgLoja	:= ""
Local cCCLoja	:= ""
Local aBcAgCoP  := ""
Local cBcLojaP	:= ""
Local cAgLojaP	:= ""
Local cCCLojaP	:= ""
Local cAux      := ""
Local nxThread  := 3
Local nxThrdAux := 0
Local nRecLog   := paramixb[3]
Local nIdThrMast:= paramixb[4]
Local aParam    := {}
Local nxThread  := 3
Local nInExec	:= 0 
Private cMVXTPOPVD	:= ""
Private cMVCLIPAD 	:= ""
Private cMVLOJAPAD	:= "" 

	RpcClearEnv()
	RPcSetType(3)
    RpcSetEnv(cEmp,cFil, , ,'FAT' , GetEnvServer() )
    OpenSm0(cEmp, .f.)
	SM0->(dbSetOrder(1))
	SM0->(dbSeek(cEmp+cFil))
	nModulo   :=5
	cEmpAnt   :=SM0->M0_CODIGO
	cFilAnt   :=SM0->M0_CODFIL
	nxThread  := GetMv("MV_XTRF300",,4) 

	cCodEmp   :=IIF(AllTrim(xFilial("Z10"))=="",Space(TamSx3("Z03_CDEMP")[1]),xFilial("Z10"))
	cCodFil   :=IIF(AllTrim(xFilial("Z10"))=="",Space(TamSx3("Z03_CDFIL")[1]),xFilial("Z10"))
	aBcAgCo   := StrToKarr(GetMV("MV_CXLOJA",,""), '/')
	cBcLoja	:= aBcAgCo[1]+Space(TamSX3("A6_COD")[1]    -Len(aBcAgCo[1]))
	cAgLoja	:= aBcAgCo[2]+Space(TamSX3("A6_AGENCIA")[1]-Len(aBcAgCo[2]))
	cCCLoja	:= aBcAgCo[3]+Space(TamSX3("A6_NUMCON")[1] -Len(aBcAgCo[3]))
	aBcAgCoP  := StrToKarr(GetMV("MV_XBCCTP",,""), '/')
	cBcLojaP	:= aBcAgCoP[1]+Space(TamSX3("A6_COD")[1]    -Len(aBcAgCoP[1]))
	cAgLojaP	:= aBcAgCoP[2]+Space(TamSX3("A6_AGENCIA")[1]-Len(aBcAgCoP[2]))
	cCCLojaP	:= aBcAgCoP[3]+Space(TamSX3("A6_NUMCON")[1] -Len(aBcAgCoP[3]))

	// -> Posiciona nas eunidades de negócio
	DbSelectArea("ADK")
	ADK->(DbOrderNickName("ADKXFILI"))
	ADK->(ADK->(DbSeek(Space(TamSX3("ADK_FILIAL")[1])+cFilAnt)))
	If !ADK->(Found())
		cAuxLog:=StrZero(nIdThrMast,10)+":Erro :Filial não encontrada da tabela ADK: "+cFilAnt
		Conout(cAuxLog)                
		RpcClearEnv()
		Return(.F.)	
	EndIf   	

	cMVXTPOPVD:=GetMV("MV_XTPOPVD",,"")
	cMVCLIPAD :=GetMV("MV_CLIPAD" ,,"")
	cMVLOJAPAD:=GetMV("MV_LOJAPAD",,"") 

	// -> Busca vendas não integradas da base de dados importada do Teknisa.
	dDataProc:=StoD(u_F300LD2(cFilAnt))
	dDataBase:=dDataProc

	// -> Reinicializa log do processamento
	oEventLog :=EventLog():restart(nRecLog)
	oEventLog:setDetail("BEGIN PROC", "", "", 0, "Iniciando processamento.",.F.,"",CtoD("  /  /  "), 0, "INICIO", "", "", .F., nIdThrMast)
	cFunNamAnt := FunName()
	
	// -> Verifica se exsite dados para integrar
	If Empty(dDataProc) 
		cAuxLog:=StrZero(nIdThrMast,10)+": Nao existem dados para integrar [Z01_DATA = "+DtoC(dDataProc)+"]"
		oEventLog:SetAddInfo(cAuxLog,"")
		Conout(cAuxLog)                
		oEventLog:finish()
		RpcClearEnv()		
		Return(.F.)		
	EndIf

	// -> Antes de começar as validações, limpa a tabela ZWE
	cQuery := "DELETE FROM " + RetSqlName('ZWE') + " WHERE ZWE_FILIAL = '" + xFilial('ZWE') + "' AND ZWE_DATA = '" + DtoS(dDataBase) + "' AND ZWE_PROCES = 'Vendas - MRP' "
	nStatus := TCSqlExec(cQuery)
	
	if (nStatus < 0)
		conout("TCSQLError(): " + TCSQLError())
	endif
  
	cAuxLog:=StrZero(nIdThrMast,10)+": Validando parametros..."
	oEventLog:SetAddInfo(cAuxLog,"")
	Conout(cAuxLog)             

	// -> Verifica parâmetros obrigatórios para execução da rotina
	If !GetMv("MV_GERAOPI",,.F.)
		oEventLog:setDetail("MV_GERAOPI", "SX6", "E", 1,"O parametro MV_GERAOPI deve estar como true.",.T.   ,"",dDataBase , 0, "PARAMETROS", "", "", .F., nIdThrMast)
		lErro := .T.
	EndIf

	If !GetMv("MV_GERAPI",,.F.)
		oEventLog:setDetail("MV_GERAPI", "SX6", "E", 1, "O parametro MV_GERAPI deve estar como true.",.T.,"",dDataBase, 0, "PARAMETROS", "", "", .F., nIdThrMast)
		lErro := .T.
	EndIf

	If GetMv("MV_PRODAUT",,.T.)
		oEventLog:setDetail("MV_PRODAUT", "SX6", "E", 1, "O parametro MV_PRODAUT deve estar como false.",.T.,"",dDataBase, 0, "PARAMETROS", "", "", .F., nIdThrMast)
		lErro := .T.
	EndIf

	If GetMv("MV_ULMES",,.T.) > dDataBase
		oEventLog:setDetail("MV_ULMES", "SX6", "E", 1, "A data da venda e maior que o ultimo fechamento de estoque. Verifique o processo de fechamento do estoque.",.T.,"",dDataBase, 0, "PARAMETROS", "", "", .F., nIdThrMast)
		lErro := .T.
	EndIf

	cAuxLog:=StrZero(nIdThrMast,10)+": Validando cadastro de produtos..."
	oEventLog:SetAddInfo(cAuxLog,"")
	Conout(cAuxLog)             

	cQuery := "SELECT DISTINCT Z02_PROD "
	cQuery += "FROM " + RetSqlName("Z02") + " Z02   " 
	cQuery += "WHERE Z02.D_E_L_E_T_      <> '*' AND                       " 
	cQuery += "      Z02.Z02_FILIAL       = '" + xFilial("Z02")  + "' AND "
	cQuery += "      Z02.Z02_DATA         = '" + DtoS(dDataProc) + "' AND "
	cQuery += "      Z02.Z02_PROD    NOT IN (SELECT Z13_XCODEX FROM " + RetSqlName("Z13") + " WHERE D_E_L_E_T_ <> '*' AND Z13_FILIAL = '" + xFilial("Z13") + "')"
	dbUseArea(.T.,"TOPCONN",TcGenQry(,,cQuery),cAliasZ13,.T.,.T.)
	
	(cAliasZ13)->(dbGoTop())
	While !(cAliasZ13)->(Eof())
		
		// -> verficando se o produto possui codigo externo na B1
		SB1->(DbOrderNickName("B1XCODEXT"))  
		SB1->(DbSeek(xFilial("SB1")+(cAliasZ13)->Z02_PROD))
		lFoundSB1:=SB1->(Found())
		If !lFoundSB1
			oEventLog:setDetail((cAliasZ13)->Z02_PROD, "Z02", "E", 0, "Produto sem relacionamento com o Protheus. [Tabela Z13]",.T.,"",dDataBase, 0, "CADASTROS", "", "", .F., nIdThrMast)
			lErro := .T.
		end if
		(cAliasZ13)->(DbSkip())
	EndDo
	(cAliasZ13)->(DbCloseArea())

	cAuxLog:=StrZero(nIdThrMast,10)+": Validando integracao dos produtos das estruturas teknisa [Z04 vs Z13] ..."
	oEventLog:SetAddInfo(cAuxLog,"")
	Conout(cAuxLog)                

	// -> Verifica cadastro de produtos
	cQuery := "SELECT DISTINCT Z04_PRDUTO "
	cQuery += "FROM " + RetSqlName("Z04") + " Z04   " 
	cQuery += "WHERE Z04.D_E_L_E_T_      <> '*' AND                       " 
	cQuery += "      Z04.Z04_FILIAL       = '" + xFilial("Z04")  + "' AND "
	cQuery += "      Z04.Z04_DATA         = '" + DtoS(dDataProc) + "' AND "
	cQuery += "      Z04.Z04_PRDUTO 	NOT IN (SELECT Z13_XCODEX FROM " + RetSqlName("Z13") + " WHERE D_E_L_E_T_ <> '*' AND Z13_FILIAL = '" + xFilial("Z13") + "')"
	dbUseArea(.T.,"TOPCONN",TcGenQry(,,cQuery),cAliasZ04A,.T.,.T.)

	(cAliasZ04A)->(dbGoTop())
	While !(cAliasZ04A)->(Eof())
		
		oEventLog:setDetail((cAliasZ04A)->Z04_PRDUTO, "Z04", "E", 0, "Produto de estrutura sem relacionamento com o Protheus. [Tabela Z13 vs Z04]",.T.,"",dDataBase, 0, "CADASTROS", "", "", .F., nIdThrMast)
		lErro := .T.
	
		(cAliasZ04A)->(DbSkip())
	EndDo
	(cAliasZ04A)->(DbCloseArea())

	cAuxLog:=StrZero(nIdThrMast,10)+": Validando cadastro de estrutura (PA e PI)..."
	oEventLog:SetAddInfo(cAuxLog,"")
	Conout(cAuxLog)                

	// -> Verifica cadastro de estrutura de produtos - PA e PI
	cQuery := "SELECT DISTINCT B1_FILIAL, "
	cQuery += "                B1_COD   , "
	cQuery += "                B1_DESC    "
	cQuery += "FROM " + RetSqlName("Z02") + " Z02 INNER JOIN " + RetSqlName("Z13") + " Z13 "
	cQuery += "    ON Z13.Z13_FILIAL   = '" + xFilial("Z13") + "' AND "
	cQuery += "       Z13.Z13_XCODEX   = Z02.Z02_PROD             AND "
	cQuery += "       Z13.D_E_L_E_T_  <> '*'                          "
	cQuery += "JOIN " + RetSqlName("SB1") + " SB1 "
	cQuery += "    ON SB1.B1_FILIAL    = '" + xFilial("SB1") + "' AND "  
	cQuery += "       SB1.B1_COD       = Z13.Z13_COD              AND " 
	cQuery += "       SB1.B1_TIPO     IN ('PA','PI')              AND " 
	cQuery += "       SB1.D_E_L_E_T_     <> '*'                       "
	cQuery += "WHERE Z02.Z02_FILIAL   = '" + xFilial("Z02")  + "' AND "
	cQuery += "      Z02.Z02_DATA     = '" + DtoS(dDataProc) + "' AND "  
	cQuery += "      Z02.D_E_L_E_T_  <> '*'                       AND "
	cQuery += "      Z13.Z13_COD	NOT IN (SELECT G1_COD FROM " + RetSqlName("SG1") + " WHERE D_E_L_E_T_ <> '*' AND G1_FILIAL = '" + xFilial("SG1")  + "' AND G1_INI <= '" + DtoS(dDataProc) + "')" 
	cQuery += "ORDER BY B1_COD "                
	dbUseArea(.T.,"TOPCONN",TcGenQry(,,cQuery),cAliasSG1,.T.,.T.)
	 
	//conout('cquery 255: ' + cQuery)
	
	(cAliasSG1)->(dbGoTop())
	While !(cAliasSG1)->(Eof())
		oEventLog:setDetail((cAliasSG1)->B1_COD, "SG1", "E", 0, "Produto sem estrutura de producao no Protheus. [Tabela SG1]",.T.,"",dDataBase, 0, "CADASTROS", "", "", .F., nIdThrMast)
		lErro := .T.
		(cAliasSG1)->(DbSkip())
	EndDo
	(cAliasSG1)->(DbCloseArea())


	cAuxLog:=StrZero(nIdThrMast,10)+": Validando cadastro de estrutura (MP)..."
	oEventLog:SetAddInfo(cAuxLog,"")
	Conout(cAuxLog)                

	// -> Verifica cadastro de estrutura de produtos - MP
	cQuery := "SELECT B1_FILIAL, "
	cQuery += "       B1_COD   , "
	cQuery += "       B1_DESC  , "
	cQuery += "       G1_COMP    "
	cQuery += "FROM " + RetSqlName("Z02") + " Z02 INNER JOIN " + RetSqlName("Z13") + " Z13 " 
	cQuery += "    ON Z13.Z13_FILIAL   = '" + xFilial("Z13") + "' AND " 
	cQuery += "       Z13.Z13_XCODEX   = Z02.Z02_PROD             AND "
	cQuery += "       Z13.D_E_L_E_T_  <> '*'                          "
	cQuery += "JOIN " + RetSqlName("SB1") + " SB1 " 
	cQuery += "    ON SB1.B1_FILIAL    = '" + xFilial("SB1") + "' AND "  
	cQuery += "       SB1.B1_COD       = Z13.Z13_COD              AND "      
	cQuery += "       SB1.B1_TIPO      IN ('PA','PI')             AND " 
	cQuery += "       SB1.D_E_L_E_T_   <> '*'                         "
	cQuery += "JOIN " + RetSqlName("SG1") + " SG1                     "
	cQuery += "    ON SG1.G1_FILIAL    = '" + xFilial("SG1") + "' AND "
	cQuery += "       SG1.G1_COD       = SB1.B1_COD               AND "
	cQuery += "       SG1.D_E_L_E_T_  <> '*'                          "
	cQuery += "WHERE Z02.Z02_FILIAL       = '" + xFilial("Z02") + "' AND "
	cQuery += "      Z02.Z02_DATA         = '" + DtoS(dDataProc)+ "' AND "  
	cQuery += "      Z02.D_E_L_E_T_      <> '*'                      AND "
	cQuery += "      SG1.G1_COMP       NOT IN (SELECT Z13_COD FROM " + RetSqlName("Z13") + " WHERE D_E_L_E_T_ <> '*' AND Z13_FILIAL = '" + xFilial("Z13") + "') "
	cQuery += "      AND SG1.G1_COMP   NOT IN (SELECT B1_COD  FROM " + RetSqlName("SB1") + " WHERE D_E_L_E_T_ <> '*' AND B1_FILIAL  = '" + xFilial("SB1") + "' AND B1_XCODEXT <> ' ') "
	cQuery += "GROUP BY B1_FILIAL, B1_COD, B1_DESC, G1_COMP "	                 
	dbUseArea(.T.,"TOPCONN",TcGenQry(,,cQuery),cAliasSG1A,.T.,.T.)

	(cAliasSG1A)->(dbGoTop())
	While !(cAliasSG1A)->(Eof())
	oEventLog:setDetail((cAliasSG1A)->G1_COMP, "Z13", "E", 0, "Produto sem relacionamento com o Teknisa. [Tabela Z13]",.T.,"",dDataBase, 0, "CADASTROS", "", "", .F., nIdThrMast)
		lErro := .T.
		(cAliasSG1A)->(DbSkip())
	EndDo
	(cAliasSG1A)->(DbCloseArea())

	// -> Verifica cadastro tributacao 
	cQuery := "SELECT DISTINCT        "
	cQuery += "       SA1.A1_COD,     "
	cQuery += "       SA1.A1_LOJA,    "
	cQuery += "       SA1.A1_NOME,    "
	cQuery += "       SA1.A1_GRPTRIB, "
	cQuery += "       SA1.A1_EST,     "
	cQuery += "       SB1.B1_COD,     "
	cQuery += "       SB1.B1_DESC,    "
	cQuery += "       SB1.B1_GRTRIB   "
	cQuery += "FROM " + RetSqlName("Z01") + " Z01 INNER JOIN " + RetSqlName("Z02") + " Z02 " 
	cQuery += "    ON Z01.Z01_FILIAL   = Z02.Z02_FILIAL  AND " 
	cQuery += "       Z01.Z01_SEQVDA   = Z02.Z02_SEQVDA  AND "
	cQuery += "       Z01.Z01_CAIXA    = Z02.Z02_CAIXA   AND "
	cQuery += "       Z01.Z01_DATA     = Z02.Z02_DATA    AND "
	cQuery += "       Z01.D_E_L_E_T_  <> '*'                 "
	cQuery += "JOIN " + RetSqlName("SA1") + " SA1 "
	cQuery += "    ON SA1.A1_FILIAL    = '" + xFilial("SA1") + "' AND "  
	cQuery += "       SA1.A1_CGC       = Z01.Z01_CGC              AND " 
	cQuery += "       SA1.D_E_L_E_T_   <> '*'                         "
	cQuery += "JOIN " + RetSqlName("Z13") + " Z13 "          
	cQuery += "    ON Z13.Z13_FILIAL   = '" + xFilial("Z13") + "' AND "
	cQuery += "       Z13.Z13_XCODEX   = Z02.Z02_PROD             AND "
	cQuery += "       Z13.D_E_L_E_T_  <> '*'                          "
	cQuery += "JOIN " + RetSqlName("SB1") + " SB1 "
	cQuery += "    ON SB1.B1_FILIAL    = '" + xFilial("SB1") + "' AND "
	cQuery += "       SB1.B1_COD       = Z13.Z13_COD              AND "
	cQuery += "       SB1.D_E_L_E_T_  <> '*'                          "
	cQuery += "WHERE Z02.Z02_FILIAL    = '" + xFilial("Z02") + "' AND "
	cQuery += "      Z02.Z02_DATA      = '" + DtoS(dDataProc)+ "' AND " 
	cQuery += "      Z02.D_E_L_E_T_   <> '*'                      AND "         
	cQuery += "      SA1.A1_CGC       <> ' '                          "
	cQuery += "UNION ALL "
	cQuery += "SELECT DISTINCT        "
	cQuery += "       SA1.A1_COD,     "
	cQuery += "       SA1.A1_LOJA,    "
	cQuery += "       SA1.A1_NOME,    "
	cQuery += "       SA1.A1_GRPTRIB, "
	cQuery += "       SA1.A1_EST,     "
	cQuery += "       SB1.B1_COD,     "
	cQuery += "       SB1.B1_DESC,    "
	cQuery += "       SB1.B1_GRTRIB   "
	cQuery += "FROM " + RetSqlName("Z01") + " Z01 INNER JOIN " + RetSqlName("Z02") + " Z02 " 
	cQuery += "    ON Z01.Z01_FILIAL   = Z02.Z02_FILIAL  AND " 
	cQuery += "       Z01.Z01_SEQVDA   = Z02.Z02_SEQVDA  AND "
	cQuery += "       Z01.Z01_CAIXA    = Z02.Z02_CAIXA   AND "
	cQuery += "       Z01.Z01_DATA     = Z02.Z02_DATA    AND "
	cQuery += "       Z01.D_E_L_E_T_  <> '*'                 "
	cQuery += "JOIN " + RetSqlName("SA1") + " SA1 "
	cQuery += "    ON SA1.A1_FILIAL    = '" + xFilial("SA1") + "' AND "  
	cQuery += "       SA1.A1_COD       = '" + cMVCLIPAD      + "' AND " 
	cQuery += "       SA1.A1_LOJA      = '" + cMVLOJAPAD     + "' AND "
	cQuery += "       SA1.D_E_L_E_T_   <> '*'                         "
	cQuery += "JOIN " + RetSqlName("Z13") + " Z13 "          
	cQuery += "    ON Z13.Z13_FILIAL   = '" + xFilial("Z13") + "' AND "
	cQuery += "       Z13.Z13_XCODEX   = Z02.Z02_PROD             AND "
	cQuery += "       Z13.D_E_L_E_T_  <> '*'                          "
	cQuery += "JOIN " + RetSqlName("SB1") + " SB1 "
	cQuery += "    ON SB1.B1_FILIAL    = '" + xFilial("SB1") + "' AND "
	cQuery += "       SB1.B1_COD       = Z13.Z13_COD              AND "
	cQuery += "       SB1.D_E_L_E_T_  <> '*'                          "
	cQuery += "WHERE Z02.Z02_FILIAL    = '" + xFilial("Z02") + "' AND "
	cQuery += "      Z02.Z02_DATA      = '" + DtoS(dDataProc)+ "' AND " 
	cQuery += "      Z02.D_E_L_E_T_   <> '*'                      AND "         
	cQuery += "      SA1.A1_CGC       <> ' '                          "
	dbUseArea(.T.,"TOPCONN",TcGenQry(,,cQuery),cAliasSA1,.T.,.T.)
	
	(cAliasSA1)->(dbGoTop())
	lFoundSA1:=.F.
	lFoundSB1:=.F.
	lFoundSF7:=.F.
	lFoundGRT:=.F.
	aSF7     :={}
	While !(cAliasSA1)->(Eof())
		
		// -> Posiciona no cliente
		SA1->(DbSetOrder(1))
		SA1->(DbSeek(xFilial("SA1")+(cAliasSA1)->A1_COD+(cAliasSA1)->A1_LOJA))
		lFoundSA1:=SA1->(Found())
		If lFoundSA1
			// -> Verifica grupo de tributação do cliente
			If AllTrim((cAliasSA1)->A1_GRPTRIB) == ""
				oEventLog:setDetail((cAliasSA1)->A1_COD+(cAliasSA1)->A1_LOJA, "SA1", "E", 0, "Sem grupo de tributacao no cliente. [A1_GRPTRIB = Vazio]",.T.,"",dDataBase, 0, "CADASTROS", "", "", .F., nIdThrMast)
				lErro := .T.
			EndIf
			
			// -> Verifica uf do cliente
			If AllTrim((cAliasSA1)->A1_EST) == ""
				oEventLog:setDetail((cAliasSA1)->A1_COD+(cAliasSA1)->A1_LOJA, "SA1", "E", 0, "Sem grupo de tributacao no cliente. [A1_EST = Vazio]",.T.,"",dDataBase, 0, "CADASTROS", "", "", .F., nIdThrMast)
				lErro := .T.
			EndIf
		Else
			oEventLog:setDetail((cAliasSA1)->A1_COD+(cAliasSA1)->A1_LOJA, "SA1", "E", 0, "Cliente nao encontrado no Protheus. [Tabela SA1]",.T.,"",dDataBase, 0, "CADASTROS", "", "", .F., nIdThrMast)
			lErro := .T.
		EndIf
			
		// -> Posiciona no produto
		SB1->(DbSetOrder(1))
		SB1->(DbSeek(xFilial("SB1")+(cAliasSA1)->B1_COD))
		lFoundSB1:=SB1->(Found())
		If lFoundSB1
			// -> Verifica grupo de tributação do produto
			If AllTrim((cAliasSA1)->B1_GRTRIB) == ""
				oEventLog:setDetail((cAliasSA1)->B1_COD, "SB1", "E", 0, "Sem grupo de tributacao no cliente. [B1_GRTRIB = Vazio]",.T.,"",dDataBase, 0, "CADASTROS", "", "", .F., nIdThrMast)
				lErro := .T.
			Else
				// -> Verifica grupo de tributação para o estado e cliente
				SF7->(DbOrderNickName("SF7GRPEST"))  
				SF7->(DbSeek(xFilial("SF7")+SB1->B1_GRTRIB+SA1->A1_GRPTRIB+SA1->A1_EST))
				lFoundSF7:=SF7->(Found())
				If !lFoundSF7
					oEventLog:setDetail(SB1->B1_GRTRIB+SA1->A1_GRPTRIB+SA1->A1_EST, "SF7", "E", 0, "Excecao fiscal nao cadastrada para o produto, cliente e UF. [B1_COD="+SB1->B1_COD+", B1_GRTRIB="+SB1->B1_GRTRIB+", A1_GRPTRIB="+SA1->A1_GRPTRIB+" e A1_EST="+SA1->A1_EST+"]",.T.,"",dDataBase, 0, "CADASTROS", "", "", .F., nIdThrMast)
					lErro := .T.					
				EndIf
			EndIf	
		Else
			oEventLog:setDetail((cAliasSA1)->B1_COD, "SB1", "E", 0, "Produto nao encontrado no Protheus. [Tabela SB1]",.T.,"",dDataBase, 0, "CADASTROS", "", "", .F., nIdThrMast)
			lErro := .T.
		EndIf
		(cAliasSA1)->(DbSkip())
	EndDo
	(cAliasSA1)->(DbCloseArea())
	
	// - > Verifica o tipo de operação
	If AllTrim(cMVXTPOPVD) == ""
		oEventLog:setDetail("MV_XTPOPVD", "SX6", "E", 0, "Sem tipo de operacao para vendas nas unidades de negocio. [MV_XTPOPVD = Vazio]",.T.,"",dDataBase, 0, "CADASTROS", "", "", .F., nIdThrMast)
		lErro := .T.
	EndIf

	// - > Verifica cliente padrão 
	If AllTrim(cMVCLIPAD) == "" .or. AllTrim(cMVLOJAPAD) == ""	
		oEventLog:setDetail("MV_CLIPAD+MV_LOJAPAD", "SX6", "E", 0, "Cliente padrao nao informado nos parametros. [MV_CLIPAD = Vazio ou MV_LOJAPAD = Vazio]",.T.,"",dDataBase, 0, "CADASTROS", "", "", , .F., nIdThrMast)
		lErro := .T.
	Else
		// -> Verifica se o cliente padrão está cadastrado
		SA1->(DbSetOrder(1))
		If !SA1->(DbSeek(xFilial("SA1")+cMVCLIPAD+cMVLOJAPAD))
			oEventLog:setDetail(cMVCLIPAD+cMVLOJAPAD, "SA1", "E", 0, "Cliente padrao nao cadastrado. [Tabela SA1]",.T.,"",dDataBase, 0, "CADASTROS", "", "", .F., nIdThrMast)
			lErro := .T.
		EndIf	
	EndIf


	cAuxLog:=StrZero(nIdThrMast,10)+": Validando estrutura de producao teknisa (Z04) ..."
	oEventLog:SetAddInfo(cAuxLog,"")
	Conout(cAuxLog)                

	// -> Verifica se há itens com quantidade zero na Z04 sem ocorrencias	
	cQuery := "SELECT DISTINCT Z04_PRDUTO "
	cQuery += "		FROM " + RetSqlName("Z04") + " Z04 " 
	cQuery += "WHERE Z04.Z04_FILIAL    = '" + xFilial("Z04") + "' AND "
	cQuery += "      Z04.Z04_DATA      = '" + DtoS(dDataProc)+ "' AND " 
	cQuery += "      Z04.Z04_PRDUTO <> ' '                        AND "
	cQuery += "      Z04.Z04_QTDE = 0                             AND "
	cQuery += "      Z04.Z04_OCORR = ' '                          AND "
	cQuery += "      Z04.D_E_L_E_T_   <> '*'                      	  "         

	dbUseArea(.T.,"TOPCONN",TcGenQry(,,cQuery),cAliasZ04,.T.,.T.)
	While !(cAliasZ04)->(Eof())
		oEventLog:setDetail( (cAliasZ04)->Z04_PRDUTO, "Z04", "E", 0, "Produto com quantidade zero e sem codigo de ocorrencia no Teknisa. [Tabela Z04]",.T.,"",dDataBase, 0, "CADASTROS", "", "", .F., nIdThrMast)
		lErro := .T.
		(cAliasZ04)->(DbSkip())
	EndDo
	(cAliasZ04)->(DbCloseArea())

	cAuxLog:=StrZero(nIdThrMast,10)+": Validando condicoes de pagamento (Z03) ..."
	oEventLog:SetAddInfo(cAuxLog,"")
	Conout(cAuxLog)                
	
	// -> Verifica condição de pagamento - Teknisa
	cQuery := "SELECT DISTINCT Z03_FILIAL, Z03_CDEMP, Z03_CDFIL, Z03_COND "
	cQuery += "FROM " + RetSqlName("Z03") + " Z03                     "  
	cQuery += "WHERE Z03.Z03_FILIAL    = '" + xFilial("Z03") + "' AND "
	cQuery += "      Z03.Z03_DATA      = '" + DtoS(dDataProc)+ "' AND "
	cQuery += "      Z03.D_E_L_E_T_   <> '*'                      	  "

	dbUseArea(.T.,"TOPCONN",TcGenQry(,,cQuery),cAliasZ03,.T.,.T.)
	While !(cAliasZ03)->(Eof())

		// -> Verifica condição de pagamento - Protheus
		SE4->(DbOrderNickName("E4CODEXT"))
		If !SE4->(DbSeek(xFilial("SE4")+(cAliasZ03)->Z03_COND))
			lErro   := .T.
			cAuxLog	:=StrZero(nIdThrMast,10)+": Condicao de pagamento nao vinculada ao Teknisa. (SE4) [Z03_COD = "+(cAliasZ03)->Z03_COND+"]" 
			Conout(cAuxLog)
			(cAliasZ03)->(DbSkip())
			Loop
		ElseIf Empty(SE4->E4_XFORMA)
			// -> Verifica se existe a forma de pagamento cadastrada
			lErro   := .T.
			cAuxLog	:=StrZero(nIdThrMast,10)+": Forma de recebimento nao informada. [E4_XFORMA=Vazio, E4_CODIGO = "+SE4->E4_CODIGO+"]"
			Conout(cAuxLog)
			(cAliasZ03)->(DbSkip())
			Loop
		Else
			// -> Verifica se existe a natureza cadastrada para a condicao de pagamento
			SED->(DbSetOrder(1))
			If !SED->(DbSeek(xFilial("SED")+SE4->E4_XNATVDA))
				lErro   := .T.
				cAuxLog	:=StrZero(nIdThrMast,10)+": Natureza financeira nao cadastrada para a condicao de recebiemento. [E4_XNATVDA="+SE4->E4_XNATVDA+"]"
				Conout(cAuxLog)
				(cAliasZ03)->(DbSkip())
				Loop
			EndIf
		EndIf	

		(cAliasZ03)->(DbSkip())

	EndDo
	(cAliasZ03)->(DbCloseArea())
	
	// -> Pesquisa banco da 'unidade' 
	SA6->(DbSetOrder(1))
	If !SA6->(DbSeek(xFilial("SA6")+cBcLoja+cAgLoja+cCCLoja))
		cAuxLog	:= StrZero(nIdThrMast,10)+": Banco da unidade de negocio nao encontrado. [A6_COD="+IIF(Empty(cBcLoja),"Vazio",cBcLoja)+", A6_AGENCIA="+IIF(Empty(cAgLoja),"Vazio",cAgLoja)+" e A6_NUMCON="+IIF(Empty(cCCLoja),"Vazio",cCCLoja)+"]"
		lErro   := .T.
		Conout(cAuxLog)
	EndIf
	
	// -> Pesquisa banco para condição "vale presente" 
	SA6->(DbSetOrder(1))
	If !SA6->(DbSeek(xFilial("SA6")+cBcLojaP+cAgLojaP+cCCLojaP))
		cAuxLog	:= StrZero(nIdThrMast,10)+": Banco da unidade de negocio nao encontrado. [A6_COD="+IIF(Empty(cBcLojaP),"Vazio",cBcLojaP)+", A6_AGENCIA="+IIF(Empty(cAgLojaP),"Vazio",cAgLojaP)+" e A6_NUMCON="+IIF(Empty(cCCLojaP),"Vazio",cCCLojaP)+"]"
		lErro   := .T.
		Conout(cAuxLog)
	EndIf

	// -> Se Houve erro retorna os Erros e aborta o processo.
	If lErro
		cAuxLog:=StrZero(nIdThrMast,10)+": Processo abortado, corrija os cadastros para continuar."
		oEventLog:broken(cAuxLog, "", .T., .T.)
		Conout(cAuxLog)                
		oEventLog:finish()
		RpcClearEnv()		
		Return(.F.)			
	EndIf	
	
	// -> Carrega as sequencias de vendas para a data
	_aPen:=u_F300LD(cFilAnt,dDataProc,oEventLog) 
	
	// -> Exclui processos do log que devem ser reiniciados - Saldos de estoque
	ConOut(": Reiniciando processos do log..")
	cQuery := "SELECT R_E_C_N_O_ REC "
	cQuery += "FROM " + RetSqlName("ZWE") + " ZWE " 
	cQuery += "WHERE ZWE_FILIAL  = '" + xFilial("ZWE") + "'   AND "
	cQuery += "      ZWE_PROCES  = 'Vendas - ERP'             AND "
	cQuery += "      ZWE_DATA    = '" + DtoS(Date())   + "'   AND "
	cQuery += "      ZWE_ENTID   = 'SB2'                      AND "
	cQuery += "      ZWE_TIPO    = 'E'                        AND "
	cQuery += "      D_E_L_E_T_ <>  '*'                           "        
	dbUseArea(.T.,"TOPCONN",TcGenQry(,,cQuery),cAliasZWE,.T.,.T.)
	 
	(cAliasZWE)->(dbGoTop())
	While !(cAliasZWE)->(Eof())
		ZWE->(DbGoTo((cAliasZWE)->REC))	
		If RecLock("ZWE",.F.)
			ZWE->(DbDelete())
			ZWE->(MsUnlock())
		Else
		    lErro:=.T.
		EndIf	
		(cAliasZWE)->(DbSkip())
	EndDo
	(cAliasZWE)->(DbCloseArea())


	// -> Se Houve erro retorna os Erros e aborta o processo.
	If lErro
		cAuxLog:=StrZero(nIdThrMast,10)+": Erro na reinicializacao dos logs."
		oEventLog:broken(cAuxLog, "", .T., .T.)
		Conout(cAuxLog)                
		oEventLog:finish()
		RpcClearEnv()		
		Return(.F.)			
	Else
		Conout(" Ok.")                
	EndIf	
	
	ny      :=1
	lErro   :=.F.
	
	aadd(aParam,cEmpAnt)
	aadd(aParam,cFilAnt)
	aadd(aParam,cMVXTPOPVD)
	aadd(aParam,cMVCLIPAD)
	aadd(aParam,cMVLOJAPAD)
	aadd(aParam,"")
	aadd(aParam,"")
	aadd(aParam,"")
	aadd(aParam,nRecLog)
	aadd(aParam,dDataBase)
	aadd(aParam,0)
	aadd(aParam,0)
	aadd(aParam,"")
	aadd(aParam,nIdThrMast)


	/* 	 Array - _aPen
		Filial      -> Posicao 01
		cdempresa   -> Posicao 02
		cdfilial    -> Posicao 03
		caixa       -> Posicao 04
	    seqvenda    -> Posicao 05
		dataentrega -> Posicao 06
		tipodocum   -> Posicao 07
	    status      -> Posicao 08
		numero nfce -> Posicao 09
		prot canc   -> Posicao 10
		data venda  -> Posicao 11
	*/
	
	PutGlbValue("F300"+aParam[1]+aParam[2],"0")
	While !Empty(_aPen)

		nInExec := Val(GetGlbValue("F300"+aParam[1]+aParam[2]))
		If nInExec < nxThread
			nInExec++

			aParam[06]:=_aPen[1,5]
			aParam[07]:=_aPen[1,4]
			aParam[08]:=DtoS(_aPen[1,11])
			aParam[13]:="F300"+aParam[1]+aParam[2]+StrZero(nInExec,2)
			
			PutGlbValue("F300"+aParam[1]+aParam[2],StrZero(nInExec,2)) //-- Incrementa contador de threads
			GlbUnLock()
			
			startJob("u_F300VP", GetEnvServer(),.F., aParam)
			
			aDel(_aPen,1)
			aSize(_aPen,Len(_aPen)-1)
		Else
			//-- SEMAFORO DE THREAD: Monitora
			For nY := 1 To nxThread
				//-- Se criou arquivo e semaforo da thread ainda em execucao, é porque thread caiu com erro
				If FCreate("F300"+aParam[1]+aParam[2]+StrZero(nY,2)) # -1 .and. GetGlbValue("F300"+aParam[1]+aParam[2]+StrZero(nY,2)) == "1"
					//-- Libera thread para execução
					ClearGlbValue("F300"+aParam[1]+aParam[2]+StrZero(nY,2))
					nInExec := Val(GetGlbValue("F300"+aParam[1]+aParam[2])) - 1
					PutGlbValue("F300"+aParam[1]+aParam[2],StrZero(nInExec,2))
				EndIf
			Next nY
			ConOut("F300"+cEmpAnt+cFilAnt + ": Aguardando threads livres...")
			Sleep(50)
		EndIf
	EndDo
	
	// -> Aguarda o término do processamento das Threads e finaliza o log do processo 
	While GetGlbValue("F300"+aParam[1]+aParam[2]) <> "00"
		ConOut("Aguardando fim do processamento das threads: " + GetGlbValue("F300"+aParam[1]+aParam[2]))		
		Sleep(50)
	EndDo
	oEventLog:setDetail("END PROC", "", "", 0, "Finalizando processamento.",.F.,"",CtoD("  /  /  "), 0, "FIM", "", "", .F., nIdThrMast)

	// -> Finaliza a conexão para iniciar o processamento em Threads
	RpcClearEnv()


Return(.T.)


/*
+------------------+---------------------------------------------------------+
!Nome              ! F300LD                                                  !
+------------------+---------------------------------------------------------+
!Descricao         ! F300LD - Função usada para carregar os dados pendentes  !
+------------------+---------------------------------------------------------+
!Autor             ! Alan Lunardi                                            !
+------------------+---------------------------------------------------------+
!Data de Criacao   ! 15/05/2018                                              !
+------------------+---------------------------------------------------------+
*/
User Function F300LD(_Fil, _dDat, oEventLog)
Local aVendasP 	:= {}
Local _cAlias 	:= GetNextAlias()
Local cAuxLog 	:= ""
Local nCont     := 0
		
	/* 	 Array - aVendasP
		Filial      -> Posicao 01
		cdempresa   -> Posicao 02
	    cdfilial    -> Posicao 03
	    caixa       -> Posicao 04
	    seqvenda    -> Posicao 05
	    dataentrega -> Posicao 06
	    tipodocum   -> Posicao 07
	    status      -> Posicao 08
		numero nfce -> Posicao 09
		prot canc   -> Posicao 10
		data venda  -> Posicao 11
	*/

	cAuxLog:=": Selecionando vendas..."
	oEventLog:SetAddInfo(cAuxLog,"")
	Conout(cAuxLog)                

	_cQuery := "SELECT * "
	_cQuery += "  FROM " + RetSqlName("Z01") + "         "
	_cQuery += " WHERE Z01_XSTINT  = 'P'             AND "
	_cQuery += "	   Z01_FILIAL  = '" + _Fil + "'  AND "
	_cQuery += "	   Z01_DATA    = '" + DtoS(_dDat) + "' AND "    
	_cQuery += "	   Z01_DATA   <= '20181003' AND "    
	//_cQuery += "	   Z01_SEQVDA IN ('0000116951','0000116953','0000116954') AND "    
	//_cQuery += "	   Z01_CAIXA   = '001' AND "                           
	_cQuery += "       D_E_L_E_T_ <> '*'                 "
	_cQuery += "ORDER BY Z01_DATA                        "
	_cQuery := ChangeQuery(_cQuery)

	If ( Select(_cAlias) ) > 0
		DbSelectArea(_cAlias)
		(_cAlias)->(dbCloseArea())
	EndIf
	TCQUERY _cQuery NEW ALIAS &_cAlias
	
	// -> Carregando vendas
	While !(_cAlias)->(EOF())
	
		Aadd(aVendasP,{(_cAlias)->Z01_FILIAL, (_cAlias)->Z01_CDEMP, (_cAlias)->Z01_CDFIL, (_cAlias)->Z01_CAIXA, (_cAlias)->Z01_SEQVDA,StoD((_cAlias)->Z01_ENTREG), (_cAlias)->Z01_TIPO,(_cAlias)->Z01_CUPOMC, (_cAlias)->Z01_NFCE, (_cAlias)->Z01_PROCAN, StoD((_cAlias)->Z01_DATA) })	
	
		nCont := nCont + 1
		(_cAlias)->(DBSkip())
	Enddo
	
	(_cAlias)->(dbCloseArea())
	

	cAuxLog:=": " + AllTrim(Str(nCont)) + " vendas selecionadas..."
	oEventLog:setCountTot(nCont)
	oEventLog:SetAddInfo(cAuxLog,"")
	Conout(cAuxLog)                
	 

Return(aVendasP) 
                      


/*
+------------------+---------------------------------------------------------+
!Nome              ! F300VP                                                  !
+------------------+---------------------------------------------------------+
!Descricao         ! F300VP - Processo de gravação de vendas                 !
+------------------+---------------------------------------------------------+
!Autor             ! Alan Lunardi                                            !
+------------------+---------------------------------------------------------+
!Data de Criacao   ! 16/05/2018                                              !
+------------------+---------------------------------------------------------+
*/
User Function F300VP(aParamIbx)
Local nx		:= 0
Local aRetOP	:= {}   // Log das OP
Local aRetEMP	:= {}   // Log dos empenhos
Local aRetAPD	:= {}   // Apontamentos Diretos
Local axOPs     := {}   // Ordens de produção para apontar
Local aRetApon  := {}   // Log dos apontamentos
Local aRetSD3   := {}   // Log dos apontamentos diretos
Local aRetSF2   := {}   // Retorno do processamento dos documentos de saida
Local aRetM300  := {}   // Retorno do processamento do recálculo dos saldos de estoque
Local aRetM930  := {}   // Retorno do processamento do documento de saida
Local aRet3009  := {}   // Retorno do processamento financeiro
Local aRetSB2   := {}   // Retorna saldos de estoque pendentes
Local l300VP    := .T.
Local cAuxLog   := ""
Local cZWVPK    := ""
Local cxTime    := Time()
Local nxIDThread:= 0
Local oEventLog 
Local nTamDoc    :=0
Local lLock       
Local nHd1
Private cMVXTPOPVD:=aParamIbx[03]
Private cMVCLIPAD :=aParamIbx[04]
Private cMVLOJAPAD:=aParamIbx[05]
Private nIdThrMast:=aParamIbx[14]
Private cDocSF2	  := ""
Private cTipoDoc  := ""
Private cxSerSAT  := ""
Private cxSerie   := ""
Private cCRetSEFAZ:= ""

	// -> SEMAFORO DE THREAD
	// -> Apaga arquivo ja existente
	If File(aParamIbx[13])
		fErase(aParamIbx[13])
	EndIf
	
	// -> Criacao do arquivo de controle de threads
	nHd1 := MSFCreate(aParamIbx[13])
	PutGlbValue(aParamIbx[13],"1")
	GlbUnLock()

	// -> Inicializa ambiente da Thread
	RPcSetType(3)
    RpcSetEnv(aParamIbx[1],aParamIbx[2], , ,'FAT' , GetEnvServer() )
    OpenSm0(aParamIbx[01], .f.)
	SM0->(dbSetOrder(1))
	SM0->(dbSeek(aParamIbx[01]+aParamIbx[02]))
	nModulo  :=5
	cEmpAnt  :=SM0->M0_CODIGO
	cFilAnt  :=SM0->M0_CODFIL
	dDataBase:=aParamIbx[10]
	nTamDoc  :=TamSX3('F2_DOC')[1]

	// -> inicializa o Log do Processo
	oEventLog :=EventLog():restart(aParamIbx[9])
	nxIDThread:=ThreadId()

	cAuxLog:=StrZero(nxIDThread,10)+": -> "+aParamIbx[06]+"-"+aParamIbx[07]+": Gerando venda."
	oEventLog:SetAddInfo(cAuxLog,"")
	Conout(cAuxLog)                
	
	// -> Poiciona e reserva registro da venda
	DbSelectArea("Z01")
	Z01->(DbSetOrder(3))
	If Z01->(DbSeek(xFilial("Z01")+aParamIbx[06]+aParamIbx[07]+aParamIbx[08]))

		lLock:=LockByName(Z01->Z01_SEQVDA,.T.,.T.,.T.)
    	If !lLock
			cAuxLog:=StrZero(nxIDThread,10)+": Sequencia da venda ja esta em processamento. Aguarde."
			oEventLog:SetAddInfo(cAuxLog,"")
			Conout(cAuxLog)                
			RpcClearEnv()
			Return(lLock)	
		Endif
		
		cAuxLog:=StrZero(nxIDThread,10)+": Iniciando transacao no ERP..."
		oEventLog:SetAddInfo(cAuxLog,"")
		Conout(cAuxLog)

		// -> Carrega tipos e dados fiscaisi por tipo de documentos
		If SubStr(Z01->Z01_CHVNFCE,21,2) $ "59" // -> SAT
			cTipoDoc  :="SATCE"
			cDocSF2   :=SubStr(Z01->Z01_CHVNFCE,32,6)
			cDocSF2   := cDocSF2+Space(nTamDoc-Len(cDocSF2))
			cxSerSAT  :=SubStr(Z01->Z01_CHVNFCE,23,9) 
			cxSerie   :=Z01->Z01_CAIXA 
			cCRetSEFAZ:=IIF(Val(SubStr(Z01->Z01_OBSNFC,1,TamSx3("F3_CODRSEF")[1]))>0,SubStr(Z01->Z01_OBSNFC,1,TamSx3("F3_CODRSEF")[1]),"")
		ElseIf SubStr(Z01->Z01_CHVNFCE,21,2) $ "65" // -> CFE
			cTipoDoc:="NFCE"
			cDocSF2 :=SubStr(Z01->Z01_CHVNFCE,26,9)
			cxSerSAT:=""
			cxSerie :=SubStr(Z01->Z01_CHVNFCE,23,3) 
			cCRetSEFAZ:=IIF(Val(SubStr(Z01->Z01_OBSNFC,1,TamSx3("F3_CODRSEF")[1]))>0,SubStr(Z01->Z01_OBSNFC,1,TamSx3("F3_CODRSEF")[1]),"")
		Else
			cTipoDoc:="CF"
			cDocSF2 :=Z01->Z01_CUPOMC
			cDocSF2 :=cDocSF2+Space(nTamDoc-Len(cDocSF2))
			cxSerSAT:=""
			cxSerie :=Z01->Z01_CAIXA 
			cCRetSEFAZ:=""
		EndIf

		cZWVPK :=Z01->Z01_SEQVDA+Z01->Z01_CAIXA+DtoS(Z01->Z01_DATA)
		cZWVPK :=xFilial("ZWV")+cZWVPK+Space(TamSx3("ZWV_PK")[1]-Len(cZWVPK))

		DbSelectArea("SF2")
		SF2->(DbOrderNickName("SEQVDA"))
		SF2->(DbSeek(xFilial("SF2")+Z01->Z01_SEQVDA+Z01->Z01_CAIXA))
		If (!SF2->(Found())) .or. (SF2->(Found()) .and. Upper(Z01->Z01_CUPOMC) <> "S")			
			
			DbSelectArea("ZWV")
			ZWV->(DbSetOrder(1))
			ZWV->(DbSeek(xFilial("ZWV")+Z01->Z01_SEQVDA+Z01->Z01_CAIXA+DtoS(Z01->Z01_DATA)))
			If !ZWV->(Found())	
				BEGIN TRANSACTION
					If RecLock("ZWV",.T.)
						ZWV->ZWV_FILIAL := xFilial("ZWV")
						ZWV->ZWV_PK		:= Z01->Z01_SEQVDA+Z01->Z01_CAIXA+DtoS(Z01->Z01_DATA)
						ZWV->ZWV_DESCP	:= "GERACAO DE OP"
						ZWV->ZWV_SEQ	:= "1"
						ZWV->ZWV_STATUS := "P"
						ZWV->(MsUnlock())
					Else	
						cAuxLog:=StrZero(nxIDThread,10)+":Erro ao gerar a pendencia na tabela ZWV (Z01_SEQVDA=" + Z01->Z01_SEQVDA + "), verifique o log com os erros."
						oEventLog:broken(cAuxLog, "", .T., .T.)
						Conout(cAuxLog) 	
						l300VP := .F.
						DisarmTransaction()
						Break
					EndIf

					If RecLock("ZWV",.T.)
						ZWV->ZWV_FILIAL := xFilial("ZWV")
						ZWV->ZWV_PK		:= Z01->Z01_SEQVDA+Z01->Z01_CAIXA+DtoS(Z01->Z01_DATA)
						ZWV->ZWV_DESCP	:= "ALTERACAO DE EMPENHOS"
						ZWV->ZWV_SEQ	:= "2"
						ZWV->ZWV_STATUS := "P"
						ZWV->(MsUnlock())
					Else	
						cAuxLog:=StrZero(nxIDThread,10)+":Erro ao gerar a pendencia na tabela ZWV (Z01_SEQVDA=" + Z01->Z01_SEQVDA + "), verifique o log com os erros."
						oEventLog:broken(cAuxLog, "", .T., .T.)
						Conout(cAuxLog) 	
						l300VP := .F.
						DisarmTransaction()
						Break
					EndIf

					If RecLock("ZWV",.T.)
						ZWV->ZWV_FILIAL := xFilial("ZWV")
						ZWV->ZWV_PK		:= Z01->Z01_SEQVDA+Z01->Z01_CAIXA+DtoS(Z01->Z01_DATA)
						ZWV->ZWV_DESCP	:= "APONTAMENTO DIRETO"
						ZWV->ZWV_SEQ	:= "3"
						ZWV->ZWV_STATUS := "P"
						ZWV->(MsUnlock())
					Else	
						cAuxLog:=StrZero(nxIDThread,10)+":Erro ao gerar a pendencia na tabela ZWV (Z01_SEQVDA=" + Z01->Z01_SEQVDA + "), verifique o log com os erros."
						oEventLog:broken(cAuxLog, "", .T., .T.)
						Conout(cAuxLog) 	
						l300VP := .F.
						DisarmTransaction()
						Break
					EndIf	

					If RecLock("ZWV",.T.)
						ZWV->ZWV_FILIAL := xFilial("ZWV")
						ZWV->ZWV_PK		:= Z01->Z01_SEQVDA+Z01->Z01_CAIXA+DtoS(Z01->Z01_DATA)
						ZWV->ZWV_DESCP	:= "APONTAMENTO PRODUCAO"
						ZWV->ZWV_SEQ	:= "4"
						ZWV->ZWV_STATUS := "P"
						ZWV->(MsUnlock())
					Else	
						cAuxLog:=StrZero(nxIDThread,10)+":Erro ao gerar a pendencia na tabela ZWV (Z01_SEQVDA=" + Z01->Z01_SEQVDA + "), verifique o log com os erros."
						oEventLog:broken(cAuxLog, "", .T., .T.)
						Conout(cAuxLog) 	
						l300VP := .F.
						DisarmTransaction()
						Break
					EndIf

					If RecLock("ZWV",.T.)
						ZWV->ZWV_FILIAL := xFilial("ZWV")
						ZWV->ZWV_PK		:= Z01->Z01_SEQVDA+Z01->Z01_CAIXA+DtoS(Z01->Z01_DATA)
						ZWV->ZWV_DESCP	:= "DOCUMENTO FISCAL"
						ZWV->ZWV_SEQ	:= "5"
						ZWV->ZWV_STATUS := "P"
						ZWV->(MsUnlock())
					Else	
						cAuxLog:=StrZero(nxIDThread,10)+":Erro ao gerar a pendencia na tabela ZWV (Z01_SEQVDA=" + Z01->Z01_SEQVDA + "), verifique o log com os erros."
						oEventLog:broken(cAuxLog, "", .T., .T.)
						Conout(cAuxLog) 	
						l300VP := .F.
						DisarmTransaction()
						Break
					EndIf

					If RecLock("ZWV",.T.)
						ZWV->ZWV_FILIAL := xFilial("ZWV")
						ZWV->ZWV_PK		:= Z01->Z01_SEQVDA+Z01->Z01_CAIXA+DtoS(Z01->Z01_DATA)
						ZWV->ZWV_DESCP	:= "FINANCEIRO"
						ZWV->ZWV_SEQ	:= "6"
						ZWV->ZWV_STATUS := "P"
						ZWV->(MsUnlock())
					Else	
						cAuxLog:=StrZero(nxIDThread,10)+":Erro ao gerar a pendencia na tabela ZWV (Z01_SEQVDA=" + Z01->Z01_SEQVDA + "), verifique o log com os erros."
						oEventLog:broken(cAuxLog, "", .T., .T.)
						Conout(cAuxLog) 	
						l300VP := .F.
						DisarmTransaction()
						Break
					EndIf
				END TRANSACTION
			EndIf

			If l300VP
				cxTime:=Time()
				l300VP:=.F.
				BEGIN TRANSACTION
					ZWV->(DbSeek(cZWVPK+"1"))
					If ZWV->(Found())
						If UPPER(ZWV->ZWV_STATUS) == "P"
							aRetOP	:={}
							cAuxLog	:=StrZero(nxIDThread,10)+": -> Gerando ordem de producao..."
							aadd(aRetOP,{"","SC2","L",0,cAuxLog,.T.,"",CtoD("  /  /  "), 0, "GERACAO DE OP", "", "", nxIDThread})
							Conout(cAuxLog)
							l300VP := u_GRAVAOP(@aRetOP,oEventLog,nxIDThread)	
							If !l300VP
								DisarmTransaction()
								Break
							Else
								RecLock("ZWV", .F.)
								ZWV->ZWV_STATUS := "I"
								ZWV->ZWV_ELTIME := ELAPTIME(cxTime,Time())
								ZWV->(MsUnlock())
							EndIf
						Else
							l300VP:=.T.
						EndIf
					Else
						l300VP := .F.
					EndIf
					
				END TRANSACTION
			EndIf

			BEGIN TRANSACTION
				If l300VP
					l300VP:=.F.
					cxTime:=Time()
					ZWV->(DbSeek(cZWVPK+"2"))
					If ZWV->(Found())
						If UPPER(ZWV->ZWV_STATUS) == "P"
							aRetEMP	:={}
							cAuxLog	:=StrZero(nxIDThread,10)+": -> Atualizando empenhos..."
							aadd(aRetEMP,{"","SD4","L",0,cAuxLog,.F.,"",CtoD("  /  /  "), 0, "ALTERACAO DE EMPENHOS", "", "", nxIDThread})
							Conout(cAuxLog)
							l300VP:=u_AFAT300E(@aRetEMP,@aRetAPD,@axOPs,oEventLog,nxIDThread)
							If !l300VP
								DisarmTransaction()
								Break
							Else
								RecLock("ZWV", .F.)
								ZWV->ZWV_STATUS := "I"
								ZWV->ZWV_ELTIME := ELAPTIME(cxTime,Time())
								ZWV->(MsUnlock())
							EndIf
						Else
							l300VP:=.T.
						EndIf
					Else
						l300VP := .F.
					EndIf
				EndIf

				If l300VP
					l300VP:=.F.
					cxTime:=Time()
					ZWV->(DbSeek(cZWVPK+"3"))
					If ZWV->(Found())
						If UPPER(ZWV->ZWV_STATUS) == "P"
							aRetSD3:= {}
							cAuxLog	:=StrZero(nxIDThread,10)+": -> Gerando apontamentos diretos..."
							aadd(aRetSD3,{"","SD3","L",0,cAuxLog,.F.,"",CtoD("  /  /  "), 0, "APONTAMENTO DIRETO", "", "", nxIDThread})
							Conout(cAuxLog)
							l300VP :=u_FAT3004(@aRetSD3,aRetAPD,oEventLog,@aRetSB2,nxIDThread)
							If !l300VP
								DisarmTransaction()
								Break
							Else
								RecLock("ZWV", .F.)
								ZWV->ZWV_STATUS := "I"
								ZWV->ZWV_ELTIME := ELAPTIME(cxTime,Time())
								ZWV->(MsUnlock())
							EndIf
						Else
							l300VP:=.T.
						EndIf
					Else
						l300VP := .F.
					EndIf
				EndIf

				If l300VP
					l300VP:=.F.
					cxTime:=Time()
					ZWV->(DbSeek(cZWVPK+"4"))
					If ZWV->(Found())
						If UPPER(ZWV->ZWV_STATUS) == "P"
							aRetApon:={} 
							cAuxLog	:=StrZero(nxIDThread,10)+": -> Porcessando apontamentos..."
							aadd(aRetApon,{"","SD3","L",0,cAuxLog,.T.,"",CtoD("  /  /  "), 0, "APONTAMENTO PRODUCAO", "", "", nxIDThread})
							Conout(cAuxLog)
							l300VP:=u_FAT3003(@aRetApon,@axOPs,oEventLog,@aRetSB2,nxIDThread)
							If !l300VP
								DisarmTransaction()
								Break
							Else
								RecLock("ZWV", .F.)
								ZWV->ZWV_STATUS := "I"
								ZWV->ZWV_ELTIME := ELAPTIME(cxTime,Time())
								ZWV->(MsUnlock())
							EndIf
						Else
							l300VP:=.T.
						EndIf
					Else
						l300VP := .F.
					EndIf
				EndIf
			END TRANSACTION

			If l300VP
				l300VP:=.F.
				cxTime:=Time()
				BEGIN TRANSACTION
					ZWV->(DbSeek(cZWVPK+"5"))
					If ZWV->(Found())
						If UPPER(ZWV->ZWV_STATUS) == "P"
							aRetSF2  :={}
							cAuxLog	:=StrZero(nxIDThread,10)+": -> Gravando a venda..."
							aadd(aRetSF2,{"","SF2","L",0,cAuxLog,.T.,"",CtoD("  /  /  "), 0, "DOCUMENTO FISCAL", "", "", nxIDThread})
							Conout(cAuxLog)
							l300VP:=u_F300DS(@aRetSF2,oEventLog,@aRetSB2,nxIDThread)
							If !l300VP
								DisarmTransaction()
								Break
							Else
								RecLock("ZWV", .F.)
								ZWV->ZWV_STATUS := "I"
								ZWV->ZWV_ELTIME := ELAPTIME(cxTime,Time())
								ZWV->(MsUnlock())
							EndIf
						Else
							l300VP:=.T.
						EndIf
					Else
						l300VP := .F.
					EndIf
				END TRANSACTION
			EndIf

			If l300VP
				l300VP:=.F.
				cxTime:=Time()
				BEGIN TRANSACTION
					ZWV->(DbSeek(cZWVPK+"6"))
					If ZWV->(Found())
						If UPPER(ZWV->ZWV_STATUS) == "P"
							aRet3009:={}
							cAuxLog	:=StrZero(nxIDThread,10)+": -> Gerando titulos a receber..."
							aadd(aRet3009,{"","SE1","L",0,cAuxLog,.T.,"",CtoD("  /  /  "), 0, "FINANCEIRO", "", "", nxIDThread})
							Conout(cAuxLog)
							l300VP:= u_FAT3009(@aRet3009,oEventLog,nxIDThread)
							If !l300VP
								DisarmTransaction()
								Break
							Else
								RecLock("ZWV", .F.)
								ZWV->ZWV_STATUS := "I"
								ZWV->ZWV_ELTIME := ELAPTIME(cxTime,Time())
								ZWV->(MsUnlock())
							EndIf
						Else
							l300VP:=.T.
						EndIf
					Else
						l300VP := .F.
					EndIf
				END TRANSACTION
			EndIf
				
			// -> Se tudo foi ok, então grava a data da integração
			If l300VP
				l300VP:=.F.
				BEGIN TRANSACTION 
					If Upper(Z01->Z01_CUPOMC) != "S"
						If RecLock("Z01",.F.)
							// -> Atualiza status da venda
							Z01->Z01_XDTERP := Date()
							Z01->Z01_XHRERP := Time() 
							Z01->Z01_XSTINT := "I"
							Z01->(MsUnlock())
							l300VP:=.T.
						Else	
							l300VP := .F.
							cAuxLog:=StrZero(nxIDThread,10)+":Houveram erros no processamento (Z01_SEQVDA=" + Z01->Z01_SEQVDA + "), verifique o log com os erros."
							oEventLog:broken(cAuxLog, "", .T., .T.)
							Conout(cAuxLog) 	
							DisarmTransaction()
							Break
						EndIf
					Else
						l300VP:=.T.
					EndIf	
				END TRANSACTION	
			EndIf
		EndIf

		//-> Verifica cancelamentos 
		If Z01->(Found()) .and. Upper(Z01->Z01_CUPOMC) == "S" .and. l300VP
			cAuxLog	:=StrZero(nxIDThread,10)+": -> Efetundo cancelamento da venda..."
			aadd(aRetSF2,{"","SF2","L",0,cAuxLog,.T.,"",CtoD("  /  /  "), 0, "CANC DOCUMENTO FISCAL", "", "", nxIDThread})
			Conout(cAuxLog)				
			l300VP:=.F.
			BEGIN TRANSACTION 
				l300VP := u_FAT3010(@aRetSF2,oEventLog,nxIDThread)

				If !l300VP
					DisarmTransaction()
					Break
				EndIf

				If RecLock("Z01",.F.)
					// -> Atualiza status da venda
					Z01->Z01_XDTERP := Date()
					Z01->Z01_XHRERP := Time() 
					Z01->Z01_XSTINT := "I"
					Z01->(MsUnlock())
					l300VP:=.T.
				Else	
					l300VP:=.F.
					cAuxLog:=StrZero(nxIDThread,10)+" : Houve erro no cancelamento da venda (Z01_SEQVDA=" + Z01->Z01_SEQVDA + "), verifique o log com os erros."
					oEventLog:broken(cAuxLog, "", .T., .T.)
					Conout(cAuxLog) 	
					DisarmTransaction()
					Break
				EndIf

			END TRANSACTION                   
			
		ElseIf l300VP
			
			l300VP:=.T.

		EndIf

		// -> Atualiza registros processados
		If l300VP
			oEventLog:setCountInc()
		EndIf

		cAuxLog:=StrZero(nxIDThread,10)+": -> Gravando log do processamento..." + Chr(13) + Chr(10)
		oEventLog:SetAddInfo(cAuxLog,"")
		Conout(cAuxLog)

		For nx:=1 to Len(aRetOP)
			oEventLog:setDetail(aRetOP[nx,01],aRetOP[nx,02], aRetOP[nx,03], aRetOP[nx,04], aRetOP[nx,05], aRetOP[nx,06], aRetOP[nx,07], aRetOP[nx,08], aRetOP[nx,09],aRetOP[nx,10], aRetOP[nx,11], aRetOP[nx,012], .F., nxIDThread)
		Next nx

		For nx:=1 to Len(aRetEMP)
			oEventLog:setDetail(aRetEMP[nx,01],aRetEMP[nx,02], aRetEMP[nx,03], aRetEMP[nx,04], aRetEMP[nx,05], aRetEMP[nx,06], aRetEMP[nx,07], aRetEMP[nx,08], aRetEMP[nx,09], aRetEMP[nx,10], aRetEMP[nx,11], aRetEMP[nx,12], .F., nxIDThread)
		Next nx

		For nx:=1 to Len(aRetSD3)
			oEventLog:setDetail(aRetSD3[nx,01],aRetSD3[nx,02], aRetSD3[nx,03], aRetSD3[nx,04], aRetSD3[nx,05], aRetSD3[nx,06], aRetSD3[nx,07], aRetSD3[nx,08], aRetSD3[nx,09], aRetSD3[nx,10], aRetSD3[nx,11], aRetSD3[nx,12], .F., nxIDThread)
		Next nx

		For nx:=1 to Len(aRetApon)
			oEventLog:setDetail(aRetApon[nx,01],aRetApon[nx,02], aRetApon[nx,03], aRetApon[nx,04], aRetApon[nx,05], aRetApon[nx,06], aRetApon[nx,07], aRetApon[nx,08], aRetApon[nx,09], aRetApon[nx,10], aRetApon[nx,11], aRetApon[nx,12], .F., nxIDThread)
		Next nx

		For nx:=1 to Len(aRetSF2)
			oEventLog:setDetail(aRetSF2[nx,01],aRetSF2[nx,02], aRetSF2[nx,03], aRetSF2[nx,04], aRetSF2[nx,05], aRetSF2[nx,06], aRetSF2[nx,07], aRetSF2[nx,08], aRetSF2[nx,09], aRetSF2[nx,10], aRetSF2[nx,11], aRetSF2[nx,12], .F., nxIDThread)
		Next nx

		For nx:=1 to Len(aRetM300)
			oEventLog:setDetail(aRetM300[nx,01],aRetM300[nx,02], aRetM300[nx,03], aRetM300[nx,04], aRetM300[nx,05], aRetM300[nx,06], aRetM300[nx,07], aRetM300[nx,08], aRetM300[nx,09], aRetM300[nx,10], aRetM300[nx,11], aRetM300[nx,12], .F., nxIDThread)
		Next nx

		For nx:=1 to Len(aRetM930)
			oEventLog:setDetail(aRetM930[nx,01],aRetM930[nx,02], aRetM930[nx,03], aRetM930[nx,04], aRetM930[nx,05], aRetM930[nx,06], aRetM930[nx,07], aRetM930[nx,08], aRetM930[nx,09], aRetM930[nx,10], aRetM930[nx,11], aRetM930[nx,12], .F., nxIDThread)
		Next nx

		For nx:=1 to Len(aRet3009)
			oEventLog:setDetail(aRet3009[nx,01],aRet3009[nx,02], aRet3009[nx,03], aRet3009[nx,04], aRet3009[nx,05], aRet3009[nx,06], aRet3009[nx,07], aRet3009[nx,08], aRet3009[nx,09], aRet3009[nx,10], aRet3009[nx,11], aRet3009[nx,12], .F., nxIDThread)
		Next nx

		For nx:=1 to Len(aRetSB2)
			oEventLog:setDetail(aRetSB2[nx,01],aRetSB2[nx,02], aRetSB2[nx,03], aRetSB2[nx,04], aRetSB2[nx,05], aRetSB2[nx,06], aRetSB2[nx,07], aRetSB2[nx,08], aRetSB2[nx,09], aRetSB2[nx,10], aRetSB2[nx,11], aRetSB2[nx,12], .T., nIdThrMast)
		Next nx

		cAuxLog:=StrZero(nxIDThread,10)+": Fim da gravacao do log." + Chr(13) + Chr(10)
		oEventLog:SetAddInfo(cAuxLog,"")
		Conout(cAuxLog)

		UnLockByName(Z01->Z01_SEQVDA,.T.,.T.,.T.)

	EndIf

	// -> Finaliza a conexão 
	RpcClearEnv()

	// -> Sinaliza encerramento da thread
	nInExec := Val(GetGlbValue("F300"+cEmpAnt+cFilAnt)) - 1
	ClearGlbValue(aParamIbx[13])
	PutGlbValue("F300"+cEmpAnt+cFilAnt,StrZero(nInExec,2))
	GlbUnLock()

Return(l300VP)   


/*
+------------------+---------------------------------------------------------+
!Nome              ! GRAVAOP                                                 !
+------------------+---------------------------------------------------------+
!Descricao         ! GRAVAOP - Gera ordens de produção                       !
+------------------+---------------------------------------------------------+
!Autor             ! Alan Lunardi                                            !
+------------------+---------------------------------------------------------+
!Data de Criacao   ! 16/05/2018                                              !
+------------------+---------------------------------------------------------+
*/    
User Function GRAVAOP(aRetOP,oEventLog,nxIDThread)
Local cPathTmp   	:= "\temp\"
Local cFileErr      := ""
Local cErrorLog     := ""
Local aMATA650 		:= {}                          
Local cAliasZ04 	:= ""
Local cQuery        := ""
Local cAuxLog		:= ""
Local cAuxLogD		:= ""
Local lErro         := .F.
Local nAuxMod       := nModulo
Local cNumSC2       := ""
Local cSeqIt  		:= ""
Local cSeqOP  		:= ""
Local lEncontrou    := .F.
Private lMsErroAuto	:= .F.
	
	nAuxMod		:= nModulo
	nModulo		:= 4
	cAliasZ04 	:= u_F300QZ04()
	cNumSC2		:= ""

	(cAliasZ04)->(dbGoTop())
	While !(cAliasZ04)->(Eof())

		lEncontrou:=.T.

		// -> Pesquisa se o produto existe na estrutura de produtos
		SG1->(DbSetOrder(1))
		If !SG1->(DbSeek(xFilial("SG1")+(cAliasZ04)->B1_COD))
			lEncontrou:=.F.
			(cAliasZ04)->(DbSkip())
			Loop
		EndIf
		
		// -> Posiciona no Produto
		SB1->(DbSetOrder(1))
		If !SB1->(DbSeek(xFilial("SB1")+(cAliasZ04)->B1_COD))
			lErro	:=.T.
			cAuxLog	:=StrZero(nxIDThread,10)+": Produto nao encontrado no Protheus... [Tabela SB1]"
			cAuxLogD:="Produto "+(cAliasZ04)->B1_COD+" nao encontrado na tabela SB1."
			aadd(aRetOP,{(cAliasZ04)->B1_COD,"SB1","E",1,cAuxLog,.T.,Z01->Z01_SEQVDA+Z01->Z01_CAIXA,Z01->Z01_DATA, 0, "GERACAO DE OP", (cAliasZ04)->B1_COD, cAuxLogD})
			ConOut(cAuxLog)
			(cAliasZ04)->(DbSkip())
			Loop
		EndIf

		// -> Posiciona no item de venda
		Z02->(DbSetOrder(3))
		If !Z02->(DbSeek(Z01->Z01_FILIAL+Z01->Z01_SEQVDA+Z01->Z01_CAIXA+DtoS(Z01->Z01_DATA)+(cAliasZ04)->Z04_SEQIT))
			lErro	:=.T.
			cAuxLog	:=StrZero(nxIDThread,10)+": Item nao encontrado na tabela de vendas... [Tabela Z02]"
			cAuxLogD:="Item "+(cAliasZ04)->Z04_SEQIT+" nao encontrado na tabela tabela Z02 para a sequencia de venda " + Z01->Z01_SEQVDA + " e caixa " + Z01->Z01_CAIXA
			aadd(aRetOP,{Z01->Z01_FILIAL+Z01->Z01_SEQVDA+Z01->Z01_CAIXA+DtoS(Z01->Z01_DATA)+(cAliasZ04)->Z04_SEQIT,"Z02","W",2,cAuxLog,.T.,Z01->Z01_SEQVDA+Z01->Z01_CAIXA,Z01->Z01_DATA, 0, "GERACAO DE OP", (cAliasZ04)->B1_COD, cAuxLogD})
			ConOut(cAuxLog)
			(cAliasZ04)->(DbSkip())
			Loop
		EndIf

		// -> Cria ordem de produção
		DbSelectArea("SC2")		
		cNumSC2	:=GetNumSC2()
		cSeqIt  :=StrZero(1,TamSx3("C2_ITEM")[1])			
		cSeqOP	:= '001' // Z02->Z02_SEQIT /* como o numero das OPS será sempre diferente, mantive a sequencia como 001 */
		cFilInt := Z02->Z02_FILIAL
		
		// -> Se gerou numero da OP, continua
		If AllTrim(cNumSC2) <> ""
			cAuxLog	:=StrZero(nxIDThread,10)+": OP: " + cNumSC2+cSeqIt+cSeqOP
			cAuxLogD:="Iniciando a inclusão da OP "+cNumSC2+", item "+cSeqIt+" e sequencia "+cSeqOP+" e produto "+SB1->B1_COD+" para a sequencia de venda " + Z01->Z01_SEQVDA + " e caixa " + Z01->Z01_CAIXA
			aadd(aRetOP,{cNumSC2+cSeqIt+cSeqOP,"SC2","L",1,cAuxLog,.T.,Z01->Z01_SEQVDA+Z01->Z01_CAIXA,Z01->Z01_DATA, Z02->Z02_QTDE, "GERACAO DE OP", SB1->B1_COD, cAuxLogD})
			ConOut(cAuxLog)

			Pergunte("MTA650",.F.)			
			aMATA650:={	{'C2_FILIAL'   	,cFilInt			,NIL},;
						{'C2_PRODUTO'  	,SB1->B1_COD		,NIL},;
						{'C2_NUM'  	   	,cNumSC2			,NIL},;          
						{'C2_ITEM'     	,cSeqIt				,NIL},;          
						{'C2_SEQUEN'   	,cSeqOP				,NIL},;
						{'C2_QUANT'		,Z02->Z02_QTDE		,NIL},;
						{'C2_DATPRI'    ,dDataBase			,NIL},;
						{'C2_DATPRF'    ,dDataBase			,NIL},;
						{'C2_EMISSAO'   ,dDataBase			,NIL},;
						{'C2_TPOP'      ,'F'				,NIL},;
						{'C2_XSEQVDA'   ,Z02->Z02_SEQVDA	,NIL},;
						{'C2_XCAIXA'    ,Z02->Z02_CAIXA		,NIL},;
						{'C2_XSEQIT'    ,Z02->Z02_SEQIT		,NIL},;
						{'AUTEXPLODE'   ,'S'				,Nil} ;
					   }
			lMsErroAuto:=.F.
			msExecAuto({|x,Y| Mata650(x,Y)},aMATA650,3)
			// -> Se ocorreu erro, registra log
			If lMsErroAuto
				lErro    := .T.
				cFileErr := "sc2_"+cFilAnt+"_"+cNumSC2+cSeqIt+cSeqOP+"_"+strtran(time(),":","")
				MostraErro(cPathTmp, cFileErr)
				cErrorLog:=memoread(cPathTmp+cFileErr)
				cAuxLog  :=StrZero(nxIDThread,10)+"Erro na inclusao OP, verifique o detalhamento da ocorrencia."
				cAuxLogD :=cErrorLog
				aadd(aRetOP,{cNumSC2+cSeqIt+cSeqOP,"SC2","E",1,cAuxLog,.T.,Z01->Z01_SEQVDA+Z01->Z01_CAIXA,Z01->Z01_DATA, Z02->Z02_QTDE, "GERACAO DE OP", SB1->B1_COD, cAuxLogD})
				ConOut(cAuxLog)
			Else
				// -> Reposiciona na ordem de produção e atualiza OPs intermediárias
				SC2->(DbSetOrder(1))
				SC2->(DbSeek(cFilInt+cNumSC2+cSeqIt+cSeqOP))
				If SC2->(Found())				
					While !SC2->(Eof()) .and. SC2->C2_FILIAL == cFilInt .and. SC2->C2_NUM == cNumSC2 
						If RecLock("SC2",.F.)
							SC2->C2_XSEQVDA:=Z02->Z02_SEQVDA
							SC2->C2_XCAIXA :=Z02->Z02_CAIXA
							SC2->C2_XSEQIT :=Z02->Z02_SEQIT
					    	SC2->(MsUnlock())
							cAuxLog  :=StrZero(nxIDThread,10)+": Ok."
							cAuxLogD :="OP numero " + cNumSC2 + ", item " + cSeqIt + " e " + cSeqOP + " incluida com sucesso."
							aadd(aRetOP,{cNumSC2+cSeqIt+cSeqOP,"SC2","L",1,cAuxLog,.T.,Z01->Z01_SEQVDA+Z01->Z01_CAIXA,Z01->Z01_DATA, 0, "GERACAO DE OP", SB1->B1_COD, cAuxLogD})
						Else
							lErro    :=.T.
							cAuxLog  :=StrZero(nxIDThread,10)+":Erro na alteracao da OP. Verifique o detalhamento da ocorrencia."
							cAuxLogD :="Ocorreu erro na altercao dos campos de sequencia da venda, caixa e sequencia do item (Campos: C2_XSEQVDA, SC2->C2_XCAIXA e SC2->C2_XSEQIT)."
							aadd(aRetOP,{cNumSC2+cSeqIt+cSeqOP,"SC2","E",1,cAuxLog,.T.,Z01->Z01_SEQVDA+Z01->Z01_CAIXA,Z01->Z01_DATA, 0, "GERACAO DE OP", SB1->B1_COD, cAuxLogD})
							ConOut(cAuxLog)
						EndIf
						SC2->(DbSkip())
					EndDo
				Else
					lErro    :=.T.
					cAuxLog  :=StrZero(nxIDThread,10)+":Erro na alteracao da  OP. Verifique o detalhamento da ocorrencia."
					cAuxLogD :="OP numero " + cNumSC2 + ", item " + cSeqIt + " e " + cSeqOP + " nao encontrada na SC2."
					aadd(aRetOP,{cNumSC2+cSeqIt+cSeqOP,"SC2","E",1,cAuxLog,.T.,Z01->Z01_SEQVDA+Z01->Z01_CAIXA,Z01->Z01_DATA, 0, "GERACAO DE OP", SB1->B1_COD, cAuxLogD})
					ConOut(cAuxLog)
				EndIf
			EndIf
		Else
			lErro    :=.T.
			cAuxLog  :=StrZero(nxIDThread,10)+":Erro na inclusao da OP."
			cAuxLogD :="Nao foi possivel gerar o numero da proxima OP pela funcao GetNumSC2()."
			aadd(aRetOP,{"","SC2","E",1,cAuxLog,.T.,Z01->Z01_SEQVDA+Z01->Z01_CAIXA,Z01->Z01_DATA, 0, "GERACAO DE OP", SB1->B1_COD, cAuxLogD})
			ConOut(cAuxLog)
		EndIf
				
		(cAliasZ04)->(DbSkip())
	
	EndDo

	If !lEncontrou
		cAuxLog	:=StrZero(nxIDThread,10)+": Ok."
		cAuxLogD:="Nao existe OP para a venda."
		aadd(aRetOP,{"","SC2","L",0,cAuxLog,.T.,Z01->Z01_SEQVDA+Z01->Z01_CAIXA,Z01->Z01_DATA, 0, "GERACAO DE OP", SB1->B1_COD, cAuxLogD})
		ConOut(cAuxLog)
	EndIf

	(cAliasZ04)->(DbCloseArea())
	nModulo:=nAuxMod
	lErro  :=IIF(lErro,.F.,.T.)

Return(lErro)


/*
+------------------+---------------------------------------------------------+
!Nome              ! F300DS                                                  !
+------------------+---------------------------------------------------------+
!Descricao         ! Geração das vendas                                      !
+------------------+---------------------------------------------------------+
!Autor             ! Alan Lunardi                                            !
+------------------+---------------------------------------------------------+
!Data de Criacao   ! 21/05/2018                                              !
+------------------+---------------------------------------------------------+
*/       
User Function F300DS(aRetSF2,oEventLog,aRetSB2,nxIDThread)
Local cPathTmp  := "\temp\"
Local cFileErr  := ""
Local cFileName := ""
Local lErro		:= .F.
Local cAuxLog	:= ""
Local cAuxLogD	:= ""
Local cOpVda	:= GetMV("MV_XTPOPVD",,"01")
Local aSF2		:= {}
Local aSD2		:= {}
Local aItens	:= {}
Local cTes		:= ""
Local cItem     := CriaVar("D2_ITEM", .T.)
Local nTamDoc   := TamSx3("F2_DOC")[1]
Local aCabec    := {}
Local aLinha    := {}
Local nVrItemV  := 0
Local nVrDescSD2:= 0
Local nCoutItens:= 0
Local cFunNamAnt:= FunName()
Local nAux      := 0
Local cMvEstNeg := GetMV("MV_ESTNEG",,"N")
Local nTamDecSD2:= TamSX3("D2_QUANT")[2]
Private lMsErroAuto := .F.

	cAuxLog	:=StrZero(nxIDThread,10)+": Documento "+Z01->Z01_SEQVDA+" do caixa " + Z01->Z01_CAIXA
	cAuxLogD:="Incluindo documento "+Z01->Z01_SEQVDA+" do caixa " + Z01->Z01_CAIXA
	aadd(aRetSF2,{Z01->Z01_SEQVDA+Z01->Z01_CAIXA+DtoS(Z01->Z01_DATA),"Z01","L",3,cAuxLog,.T.,Z01->Z01_SEQVDA+Z01->Z01_CAIXA,Z01->Z01_DATA, 0, "DOCUMENTO FISCAL", "", cAuxLogD})
	Conout(cAuxLog)

	// -> Pesquisa cliente e, caso nao exista pega o cliente padrão		
	SA1->(DbSetOrder(3))
	SA1->(DbSeek(xFilial("SA1")+Z01->Z01_CGC))		
	If !SA1->(Found()) .or. Empty(Z01->Z01_CGC)
		// -> Verifica se o cliente padrão está cadastrado
		SA1->(DbSetOrder(1))
		If !SA1->(DbSeek(xFilial("SA1")+cMVCLIPAD+cMVLOJAPAD))
			lErro 	:= .T.
			cAuxLog	:=StrZero(nxIDThread,10)+": Cliente nao encontrado."
			cAuxLogD:="Nao encontrado cliente "+cMVCLIPAD+" e loja " + cMVLOJAPAD + " na tabela SA1. Verifique os parametros MV_CLIPAD e MV_LOJAPAD."
			aadd(aRetSF2,{Z01->Z01_CGC,"SA1","E",1,cAuxLog,.T.,Z01->Z01_SEQVDA+Z01->Z01_CAIXA,Z01->Z01_DATA, 0, "DOCUMENTO FISCAL", "", cAuxLogD})
			Conout(cAuxLog)
		EndIf	
	EndIf		

	If !lErro
		aSF2    := {}
		aSD2    := {}
		aadd(aSF2,{"F2_TIPO"   ,"N"														,Nil})
		aadd(aSF2,{"F2_DOC"    ,cDocSF2													,Nil})
		aadd(aSF2,{"F2_SERIE"  ,cxSerie					    						    ,Nil})
		aadd(aSF2,{"F2_EMISSAO",Z01->Z01_DATA											,Nil})
		aadd(aSF2,{"F2_DTDIGIT",Z01->Z01_DATA											,Nil})
		aadd(aSF2,{"F2_HORA"   ,Z01->Z01_HORA											,Nil})
		aadd(aSF2,{"F2_CLIENTE",SA1->A1_COD												,Nil})
		aadd(aSF2,{"F2_LOJA"   ,SA1->A1_LOJA											,Nil})
		aadd(aSF2,{"F2_ESPECIE",cTipoDoc												,Nil})
		aadd(aSF2,{"F2_DESCONT",0														,Nil})
		aadd(aSF2,{"F2_FIMP"   ,"S"														,Nil})
		aadd(aSF2,{"F2_CHVNFE" ,Z01->Z01_CHVNFCE										,Nil})
		aadd(aSF2,{"F2_XSEQVDA",Z01->Z01_SEQVDA											,Nil}) 
		aadd(aSF2,{"F2_XCAIXA" ,Z01->Z01_CAIXA											,Nil})     
 		
		// -> Grava itens do documento
		nVrDescSD2:=0
		Z02->(DbSetOrder(3)) 
		Z02->(DbSeek(Z01->Z01_FILIAL+Z01->Z01_SEQVDA+Z01->Z01_CAIXA+DtoS(Z01->Z01_DATA)))
		While !Z02->(Eof()) .and. Z01->Z01_FILIAL == Z02->Z02_FILIAL .and. Z01->Z01_SEQVDA == Z02->Z02_SEQVDA .and. Z01->Z01_CAIXA == Z02->Z02_CAIXA .and. DtoS(Z01->Z01_DATA) == DtoS(Z02->Z02_DATA)
			nCoutItens:=nCoutItens+1
				
			// -> Posiciona produto			
			SB1->(DbOrderNickName("B1XCODEXT"))
			If !SB1->(DbSeek(xFilial("SB1")+Z02->Z02_PROD))
				lErro 	:= .T.
				cAuxLog	:=StrZero(nxIDThread,10)+": Produto nao encontrado."
				cAuxLogD:="Nao encontrado produto "+Z02->Z02_PROD+" na tabela SB1."
				aadd(aRetSF2,{Z02->Z02_PROD,"SB1","E",1,cAuxLog,.T.,Z01->Z01_SEQVDA+Z01->Z01_CAIXA,Z01->Z01_DATA, 0, "DOCUMENTO FISCAL", "", cAuxLogD})
				Conout(cAuxLog)
			EndIf
				
			// -> Pega TES				
			cTes:=MaTESInt(2,cOpVda,SA1->A1_COD,SA1->A1_LOJA,"C",SB1->B1_COD)
			If AllTrim(cTes) == ""
				lErro 	:= .T.
				cAuxLog	:=StrZero(nxIDThread,10)+": TES nao encontrada."
				cAuxLogD:="TES nao encontrada para o cliente e produto. [A1_COD="+SA1->A1_COD+", A1_LOJA="+SA1->A1_LOJA+" e B1_COD="+SB1->B1_COD+"]"
				aadd(aRetSF2,{"","SF4","E",1,cAuxLog,.T.,Z01->Z01_SEQVDA+Z01->Z01_CAIXA,Z01->Z01_DATA, 0, "DOCUMENTO FISCAL", "", cAuxLogD})
				Conout(cAuxLog)
			EndIf
						
			cItem := Soma1(cItem)					
			aItens   := {}
			nVrItemV := IIF(Z02->Z02_VRITEM<=0,Z02->Z02_VRACRE,Z02->Z02_VRITEM)
			aadd(aItens,{"D2_ITEM" 		,cItem															,Nil})
			aadd(aItens,{"D2_COD"  		,SB1->B1_COD													,Nil})
			aadd(aItens,{"D2_LOCAL"  	,SB1->B1_LOCPAD													,Nil})
			aadd(aItens,{"D2_QUANT"		,NoRound(Z02->Z02_QTDE,TamSX3("Z02_QTDE")[2])					,Nil})
			aadd(aItens,{"D2_PRCVEN"	,NoRound(nVrItemV,TamSX3("D2_PRCVEN")[2])				        ,Nil})
			aadd(aItens,{"D2_PRUNIT"	,NoRound(Z02->Z02_PRCTAB,TamSX3("D2_PRUNIT")[2])				,Nil})
			aadd(aItens,{"D2_DESC"		,Z02->Z02_PERDESC												,Nil})
			aadd(aItens,{"D2_DESCON"	,Z02->Z02_VRDESC												,Nil})
			aadd(aItens,{"D2_TOTAL"		,NoRound(Z02->Z02_QTDE*nVrItemV,TamSX3("D2_PRCVEN")[2])	        ,Nil})
			aadd(aItens,{"D2_TES"		,cTes															,Nil})
			aadd(aItens,{"D2_CF"		,Z02->Z02_CFOP													,Nil})
			aadd(aItens,{"D2_BASEICM"	,Z02->Z02_BASCAL												,Nil})
			aadd(aItens,{"D2_PICMS"		,Z02->Z02_ALIQIC												,Nil})
			aadd(aItens,{"D2_VALICM"	,Z02->Z02_VRIMP													,Nil})
			aadd(aItens,{"D2_BASEIMP5"	,Z02->Z02_BASCOF												,Nil})
			aadd(aItens,{"D2_ALIQIMP5"	,Z02->Z02_PCOFIN												,Nil})
			aadd(aItens,{"D2_VALIMP5"	,Z02->Z02_VRCOFI												,Nil})
			aadd(aItens,{"D2_BASEIMP6"	,Z02->Z02_BASPIS												,Nil})
			aadd(aItens,{"D2_ALIQIMP6"	,Z02->Z02_PPIS													,Nil})
			aadd(aItens,{"D2_VALIMP6"	,Z02->Z02_VRPIS													,Nil})
			aadd(aItens,{"D2_ESTOQUE"	,"S"															,Nil})
			aadd(aSD2,aItens)			  		
			
			nVrDescSD2+=Z02->Z02_VRDESC
			
			Z02->(DbSkip())
	 		
		EndDo
	
	EndIf

	If !lErro
	
		// -> Atualiza compo de desconto no cabeçalho do documento discal
		nAux:=aScan(aSF2,{|xz| AllTrim(xz[1]) == "F2_DESCONT"})
		If nAux > 0
			aSF2[nAux,2]:=nVrDescSD2
		EndIf
		
		SB1->(DbSetOrder(1))	/* há um bug na MATA920 em que ela só acha o produto, se a B1 já estiver ordenada no primeiro indice */
		
		lMsErroAuto := .F.
		SetFunName("MATA920")
	 	MATA920(aSF2,aSD2,3)
	 	SetFunName(cFunNamAnt)
		If lMsErroAuto
			lErro	 := .T.
			cFileName:= "sf2_"+cFilAnt+"_"+AllTrim(cDocSF2)+Z01->Z01_CAIXA+SA1->A1_COD+SA1->A1_LOJA+"_"+strtran(time(),":","")
			MostraErro(cPathTmp, cFileName)
			cFileErr :=memoread(cPathTmp+cFileName)
			cAuxLog  :=StrZero(nxIDThread,10)+":Erro na geracao do documento fiscal. Verifique o detalhe da ocorrencia."
			cAuxLogD :=cFileErr
			aadd(aRetSF2,{cDocSF2+cxSerie+SA1->A1_COD+SA1->A1_LOJA,"SF2","E",1,cAuxLog,.T.,Z01->Z01_SEQVDA+Z01->Z01_CAIXA,Z01->Z01_DATA, 0, "DOCUMENTO FISCAL", "", cAuxLogD})
			ConOut(cAuxLog,cFileErr)
		Else
			//faz o ajuste para gravar campos adicionais na SF2 (não estão sendo gravados no execauto)
			SF2->(DbSetOrder(1))
			cChave := xFilial('SF2') + cDocSF2 + cxSerie + SA1->A1_COD + SA1->A1_LOJA //+ ' ' + cTipoDoc			
			If !SF2->(DbSeek(cChave))
				lErro	 := .T.
				cAuxLog  := StrZero(nxIDThread,10)+":Erro na alteracao do documento fiscal."
				cAuxLogD := "Documento fiscal " + cDocSF2 + " para o caixa " + Z01->Z01_CAIXA + " nao encontrado na tabela SF2." 
				aadd(aRetSF2,{cDocSF2+cxSerie+SA1->A1_COD+SA1->A1_LOJA,"SF2","E",1,cAuxLog,.T.,Z01->Z01_SEQVDA+Z01->Z01_CAIXA,Z01->Z01_DATA, 0, "DOCUMENTO FISCAL", "", cAuxLogD})
				ConOut(cAuxLog)
			else
				// -> Atualiza dados complementares da NF
				RecLock('SF2',.F.)
					SF2->F2_XSEQVDA := Z01->Z01_SEQVDA
					SF2->F2_XCAIXA  := Z01->Z01_CAIXA
					SF2->F2_SERSAT  := cxSerSAT
					SF2->F2_ECF     := IIF(cTipoDoc=="CF","S","N")
					SF2->F2_PDV     := IIF(cTipoDoc=="CF","Z01->Z01_CAIXA","")
				    SF2->(MsUnlock())
				// -> Atualiza os dados adicionais dos itns para movimentação de estoque 
				SD2->(DbGoTop())
				SD2->(DbSetOrder(3))
				SD2->(DbSeek(SF2->F2_FILIAL+SF2->F2_DOC+SF2->F2_SERIE+SF2->F2_CLIENTE+SF2->F2_LOJA))
				While !SD2->(Eof()) .and. SF2->F2_FILIAL == SD2->D2_FILIAL .and. SF2->F2_DOC == SD2->D2_DOC .and. SF2->F2_SERIE == SD2->D2_SERIE .and. SF2->F2_CLIENTE == SD2->D2_CLIENTE .and. SF2->F2_LOJA == SD2->D2_LOJA
					RecLock("SD2",.F.)
					SD2->D2_ORIGLAN:="  "
					SD2->D2_ESTOQUE:="S"
					SD2->D2_PDV    := IIF(cTipoDoc=="CF","Z01->Z01_CAIXA","")					
					SD2->(MsUnlock())
					//-- Realiza atualização de custos e saldos
					If !F300AtuSld(cMvEstNeg,nTamDecSD2,@aRetSB2,nxIDThread)
						lErro:=.T.
					EndIf
					SD2->(DbSkip())
				EndDo

				// -> Atualiza log
				If lErro
					cAuxLog	:=StrZero(nxIDThread,10)+": Erro na geracao do documento fiscal."
					aadd(aRetSF2,{Z01->Z01_SEQVDA+Z01->Z01_CAIXA+DtoS(Z01->Z01_DATA),"Z01","E",3,cAuxLog,.T.,Z01->Z01_SEQVDA+Z01->Z01_CAIXA,Z01->Z01_DATA, 0, "DOCUMENTO FISCAL", "", ""})
					Conout(cAuxLog)
				Else	
					cAuxLog  := StrZero(nxIDThread,10)+": Ok. "+AllTrim(Str(nCoutItens))+ " registros processados."
					cAuxLogD := "Documento fiscal " + cDocSF2 + " para o caixa " + Z01->Z01_CAIXA + " incluido com sucesso." 
					aadd(aRetSF2,{cDocSF2+cxSerie+SA1->A1_COD+SA1->A1_LOJA,"SF2","L",1,cAuxLog,.T.,Z01->Z01_SEQVDA+Z01->Z01_CAIXA,Z01->Z01_DATA, 0, "DOCUMENTO FISCAL", "", cAuxLogD})
					ConOut(cAuxLog)	
				EndIf

				// -> Atualiza a SFT
				If !lErro
					cAuxLog	:=StrZero(nxIDThread,10)+": Atualizando complementos fiscais - SFT."
					aadd(aRetSF2,{Z01->Z01_SEQVDA+Z01->Z01_CAIXA+DtoS(Z01->Z01_DATA),"Z01","L",3,cAuxLog,.T.,Z01->Z01_SEQVDA+Z01->Z01_CAIXA,Z01->Z01_DATA, 0, "DOCUMENTO FISCAL", "", ""})
					Conout(cAuxLog)

					SFT->(DbSetOrder(1))
					SFT->(DbSeek(SF2->F2_FILIAL+"S"+SF2->F2_SERIE+SF2->F2_DOC+SF2->F2_CLIENTE+SF2->F2_LOJA))	
					If SFT->(Found())
						While !SFT->(eOF()) .and. SFT->FT_FILIAL == SF2->F2_FILIAL .and. SFT->FT_TIPOMOV == "S" .and. SFT->FT_SERIE == SF2->F2_SERIE .and. SFT->FT_NFISCAL == SF2->F2_DOC .and. SFT->FT_CLIEFOR == SF2->F2_CLIENTE .and. SFT->FT_LOJA == SF2->F2_LOJA 
						If RecLock("SFT",.F.)
							SFT->FT_PDV    :=SF2->F2_PDV
							SFT->FT_SERSAT :=SF2->F2_SERSAT
							SFT->(MsUnlock())						
						Else
							lErro:=IIF(!lErro,.T.,lErro)
						EndIf
						SFT->(DbSkip())
						EndDo	
					EndIf	
				
					// -> Atualiza log de complementos fiscais - SFT
					If lErro
						cAuxLog	:=StrZero(nxIDThread,10)+": Erro na atualizacao do complemento fisal - SFT."
						aadd(aRetSF2,{Z01->Z01_SEQVDA+Z01->Z01_CAIXA+DtoS(Z01->Z01_DATA),"Z01","E",3,cAuxLog,.T.,Z01->Z01_SEQVDA+Z01->Z01_CAIXA,Z01->Z01_DATA, 0, "DOCUMENTO FISCAL", "", ""})
						Conout(cAuxLog)
					Else	 
						cAuxLog	:=StrZero(nxIDThread,10)+": Ok."
						aadd(aRetSF2,{Z01->Z01_SEQVDA+Z01->Z01_CAIXA+DtoS(Z01->Z01_DATA),"Z01","L",3,cAuxLog,.T.,Z01->Z01_SEQVDA+Z01->Z01_CAIXA,Z01->Z01_DATA, 0, "DOCUMENTO FISCAL", "", ""})
						Conout(cAuxLog)
					EndIf	
				
				EndIf

				// -> Atualiza a SF3
				If !lErro
					cAuxLog	:=StrZero(nxIDThread,10)+": Atualizando complementos fiscais - SF3."
					aadd(aRetSF2,{Z01->Z01_SEQVDA+Z01->Z01_CAIXA+DtoS(Z01->Z01_DATA),"Z01","L",3,cAuxLog,.T.,Z01->Z01_SEQVDA+Z01->Z01_CAIXA,Z01->Z01_DATA, 0, "DOCUMENTO FISCAL", "", ""})
					Conout(cAuxLog)

					SF3->(DbSetOrder(1))
					SF3->(DbSeek(SF2->F2_FILIAL+DtoS(SF2->F2_EMISSAO)+SF2->F2_DOC+SF2->F2_SERIE+SF2->F2_CLIENTE+SF2->F2_LOJA))	
					If SF3->(Found())
						While !SF3->(Eof()) .and. SF3->F3_FILIAL == SF2->F2_FILIAL .and. DtoS(SF3->F3_ENTRADA) == DtoS(SF2->F2_EMISSAO) .and. SF3->F3_NFISCAL == SF2->F2_DOC .and. SF3->F3_SERIE == SF2->F2_SERIE .and. SF3->F3_CLIEFOR == SF2->F2_CLIENTE .and. SF3->F3_LOJA == SF2->F2_LOJA 
						If RecLock("SF3",.F.)
							SF3->F3_PDV    :=SF2->F2_PDV
							SF3->F3_ECF    :=SF2->F2_ECF
							SF3->F3_SERSAT :=SF2->F2_SERSAT
							SF3->F3_CODRSEF:=cCRetSEFAZ
							SF3->(MsUnlock())						
						Else
							lErro:=IIF(!lErro,.T.,lErro)
						EndIf
						SF3->(DbSkip())
						EndDo	
					EndIf	

					// -> Atualiza log de complementos fiscais - SF3
					If lErro
						cAuxLog	:=StrZero(nxIDThread,10)+": Erro na atualizacao do complemento fisal - SF3."
						aadd(aRetSF2,{Z01->Z01_SEQVDA+Z01->Z01_CAIXA+DtoS(Z01->Z01_DATA),"Z01","E",3,cAuxLog,.T.,Z01->Z01_SEQVDA+Z01->Z01_CAIXA,Z01->Z01_DATA, 0, "DOCUMENTO FISCAL", "", ""})
						Conout(cAuxLog)
					Else 
						cAuxLog	:=StrZero(nxIDThread,10)+": Ok."
						aadd(aRetSF2,{Z01->Z01_SEQVDA+Z01->Z01_CAIXA+DtoS(Z01->Z01_DATA),"Z01","L",3,cAuxLog,.T.,Z01->Z01_SEQVDA+Z01->Z01_CAIXA,Z01->Z01_DATA, 0, "DOCUMENTO FISCAL", "", ""})
						Conout(cAuxLog)
					EndIf
				EndIf			
			EndIf
		EndIf
	EndIf

	lErro:=IIF(lErro,.F.,.T.)

Return(lErro)


/*
+------------------+---------------------------------------------------------+
!Nome              ! F300LD2                                                 !
+------------------+---------------------------------------------------------+
!Descricao         ! F300LD2 - Verifica para quais dias existe item          !
!                  ! pendente de integração									 !
+------------------+---------------------------------------------------------+
!Autor             ! Alan Lunardi                                            !
+------------------+---------------------------------------------------------+
!Data de Criacao   ! 04/06/2018                                              !
+------------------+---------------------------------------------------------+
*/
User Function F300LD2(_Fil)
Local cRet    := "" 
Local _cAlias := GetNextAlias()
Local nxInt   := 0
Local nxNInt  := 0
Local dAux    := CtoD("  /  /  ")
Local nDias   := 1

	// -> Busca a última data que foi integrado
	If ( Select(_cAlias) ) > 0
		DbSelectArea(_cAlias)
		(_cAlias)->(dbCloseArea())
	EndIf	

	_cQuery := "SELECT NVL(MAX(Z01_DATA),' ') Z01_DATA "  
	_cQuery += "FROM " + RetSqlName("Z01")    + "      "    
	_cQuery += "WHERE D_E_L_E_T_ <> '*'            AND "
	_cQuery += "      Z01_FILIAL  = '" + _Fil + "' AND "
    _cQuery += "      Z01_XSTINT  = 'I'                "
	TCQUERY _cQuery NEW Alias (_cAlias)
	
	(_cAlias)->(DbGoTop())
	cRet:=(_cAlias)->Z01_DATA

	// -> Verifica se todos os itens foram integrados, caso tenha itens faltando, retorna como última data de integração
	If !Empty(cRet)

		If ( Select(_cAlias) ) > 0
			DbSelectArea(_cAlias)
			(_cAlias)->(dbCloseArea())
		EndIf	

		_cQuery := "SELECT COUNT(*) INTEG, 0        NINTEG "
		_cQuery += "FROM " + RetSqlName("Z01")    + "      " 
		_cQuery += "WHERE D_E_L_E_T_ <> '*'            AND "
      	_cQuery += "Z01_FILIAL        = '" + _Fil + "' AND "
      	_cQuery += "Z01_DATA          = '" + cRet + "'     "
		_cQuery += "UNION ALL                              "
		_cQuery += "SELECT 0        INTEG, COUNT(*) NINTEG "
		_cQuery += "FROM " + RetSqlName("Z01")    + "      " 
		_cQuery += "WHERE D_E_L_E_T_ <> '*'            AND "
      	_cQuery += "Z01_FILIAL        = '" + _Fil + "' AND "
      	_cQuery += "Z01_DATA          = '" + cRet + "' AND "
      	_cQuery += "Z01_XSTINT        = 'P'                " 

		TCQUERY _cQuery NEW Alias (_cAlias)
		(_cAlias)->(DbGoTop())
		While !(_cAlias)->(Eof())
			
			nxInt +=(_cAlias)->INTEG
			nxNInt+=(_cAlias)->NINTEG		
			
			(_cAlias)->(DbSkip())
		
		EndDo
		
		// -> Verifica se ainda existem vendas pendentes de integração para a data
		If nxNInt <= 0
			
			// -> Busca a próxima data para integrar
			dAux :=StoD(cRet)
			nDias:=1
			cRet :="" 
			While nDias <= 50

				// -> Verifica se existe vendas para a próxima data. Se existir, retorna a próxima data na função
				dAux:=dAux+nDias
			 	
				If ( Select(_cAlias) ) > 0
					DbSelectArea(_cAlias)
					(_cAlias)->(dbCloseArea())
				EndIf

				_cQuery := " SELECT NVL(MIN(Z01_DATA), ' ') AS Z01_DATA   "
				_cQuery += " FROM " + RetSqlName("Z01")          + "      "
				_cQuery += " WHERE Z01_FILIAL  = '" + _Fil       + "' AND "    
		      	_cQuery += "       Z01_DATA    = '" + DtoS(dAux) + "' AND "
				_cQuery += "       D_E_L_E_T_ <> '*'                      " 
	
				TCQUERY _cQuery NEW Alias (_cAlias)
				(_cAlias)->(DbGoTop())
				If !Empty((_cAlias)->Z01_DATA)
					cRet := (_cAlias)->Z01_DATA
					Exit
				EndIf

				nDias:=nDias + 1

			EndDo

		EndIf

	Else

	 	// -> Se não integrou nenhuma venda, dusaca a primeira data da venda a integrar
		If ( Select(_cAlias) ) > 0
			DbSelectArea(_cAlias)
			(_cAlias)->(dbCloseArea())
		EndIf

		_cQuery := " SELECT MIN(Z01_DATA) AS Z01_DATA       "
		_cQuery += " FROM " + RetSqlName("Z01")    + "      "
		_cQuery += " WHERE Z01_FILIAL  = '" + _Fil + "' AND "    
		_cQuery += "       D_E_L_E_T_ <> '*'                " 
		_cQuery += " ORDER BY Z01_DATA                      " 
	
		TCQUERY _cQuery NEW Alias (_cAlias)
		(_cAlias)->(DbGoTop())
		cRet := (_cAlias)->Z01_DATA

	EndIf

	(_cAlias)->(dbCloseArea()) 

Return (cRet)


/*
+------------------+---------------------------------------------------------+
!Nome              ! AFAT300E                                                !
+------------------+---------------------------------------------------------+
!Descricao         ! Ajusta empenhos                                         !
+------------------+---------------------------------------------------------+
!Autor             ! Alan Lunardi                                            !
+------------------+---------------------------------------------------------+
!Data de Criacao   ! 13/06/2018                                              !
+------------------+---------------------------------------------------------+
*/
User Function AFAT300E(aRetEMP,aRetAPD,axOPs,oEventLog,nxIDThread) 
Local nx, ny 	:= 0 
Local cPathTmp  := "\temp\"
Local cFileErr  := ""
Local cFileName := ""
Local lErro     := .F.
Local nAuxMod   := 0
Local nAux      := 0
Local cAuxLog	:= ""
Local cAuxLogD  := ""
Local cAliasZ04 := ""
Local cAliasZ04O:= ""
Local aZ04Prod  := {}
Local aZ04POBS  := {}
Local aMata380  := {}
Local lEncontrou:=.F.
Local aOpsAux   := {}
Local nQtdAdc   := 0
Local lEofZ04   := .F.
Local cFilZ13   := xFilial("Z13")
Local cEmpZ13   := IIF(Empty(cFilZ13),Space(TamSx3("ADK_XEMP")[1]),ADK->ADK_XEMP)
Local cxFilZ13  := IIF(Empty(cFilZ13),Space(TamSx3("ADK_XFIL")[1]),ADK->ADK_XFIL)
Local nTamD4_OP := TamSx3("D4_OP")[1]
Local cFunNamAnt:= FunName()
	
	nAuxMod	   :=nModulo
	nModulo	   :=4
	cAliasZ04  :=u_F300QZ04()
	cNumSC2	   :=""
	lEofZ04    := (cAliasZ04)->(Eof())
	SetFunName("MATA380")

	(cAliasZ04)->(dbGoTop())
	While !(cAliasZ04)->(Eof())
			
		// -> Posiciona no Produto
		SB1->(DbSetOrder(1))
		SB1->(DbSeek(xFilial("SB1")+(cAliasZ04)->B1_COD))
		
		// -> Posiciona no item da venda
		Z02->(DbSetOrder(3))
		Z02->(DbSeek(Z01->Z01_FILIAL+Z01->Z01_SEQVDA+Z01->Z01_CAIXA+DtoS(Z01->Z01_DATA)+(cAliasZ04)->Z04_SEQIT))

		// -> Pesquisa se o produto existe na estrutura de produtos
		SG1->(DbSetOrder(1))
		If !SG1->(DbSeek(xFilial("SG1")+(cAliasZ04)->B1_COD))
			(cAliasZ04)->(DbSkip())
			lEncontrou:=.F.
			Loop
		EndIf
		
		// -> Seleciona ordens de produção que devem ser apontadas
		aOpsAux:={}
		SC2->(DbOrderNickname("SEQVDA"))	/* C2_FILIAL+C2_XSEQVDA+C2_XCAIXA+DTOS(C2_EMISSAO)+C2_XSEQIT */                                                                                                       
		SC2->(DbSeek(xFilial("SC2") + Z01->Z01_SEQVDA + Z01->Z01_CAIXA + DtoS(dDataBase) + Z02->Z02_SEQIT ))
		While !SC2->(Eof()) .and. SC2->C2_FILIAL == Z01->Z01_FILIAL .and. SC2->C2_XSEQVDA == Z01->Z01_SEQVDA .and. SC2->C2_XCAIXA == Z01->Z01_CAIXA .and. DtoS(SC2->C2_EMISSAO) == DtoS(dDataBase) .and. SC2->C2_XSEQIT == Z02->Z02_SEQIT
			// -> Atuliza OPs a serem "apontadas"
			aadd(axOPs   ,{SC2->C2_NUM+SC2->C2_ITEM+SC2->C2_SEQUEN,.F.,SC2->C2_XSEQIT})
			aadd(aOpsAux,{SC2->C2_NUM+SC2->C2_ITEM+SC2->C2_SEQUEN,SC2->C2_PRODUTOS,SC2->C2_NUM,SC2->C2_ITEM,SC2->C2_SEQUEN,SC2->C2_XSEQIT})
			SC2->(DbSkip())
    	EndDo

		// -> Atualiza os empenhos das ordens de produção
		lEncontrou:=.F.
		aZ04Prod  :={}
		For ny:=1 to Len(aOpsAux)

			// -> Reposiciona na OP
			SC2->(DbSetOrder(1))
			SC2->(DbSeek(xFilial("SC2")+aOpsAux[ny,01]))	    	

			// -> Posiciona nos empenhos da OP
			nAux:=0
			SD4->(DbSetOrder(2))
			SD4->(DbSeek(SC2->C2_FILIAL+SC2->C2_NUM+SC2->C2_ITEM+SC2->C2_SEQUEN))
			If SD4->(Found())		
				// -> Atualiza empenhos do produto
				While !SD4->(Eof()) .and. SD4->D4_FILIAL == SC2->C2_FILIAL .and. AllTrim(SD4->D4_OP) == AllTrim(SC2->C2_NUM+SC2->C2_ITEM+SC2->C2_SEQUEN)
					// -> Posiciona na SB1 e verifica se o porduto é diferente de PI
					SB1->(DbSetOrder(1))
					SB1->(DbSeek(xFilial("SB1")+SD4->D4_COD))
					If AllTrim(SB1->B1_TIPO) <> "PI"
						nAux:=aScan(aZ04Prod,{|kb| kb[7]==SC2->C2_NUM+SC2->C2_ITEM+SC2->C2_SEQUEN+SD4->D4_COD+SC2->C2_XSEQIT})
						If nAux <=0
							aadd(aZ04Prod,{SD4->D4_COD,0,"SD4",SD4->D4_QUANT,SC2->C2_PRODUTO,SC2->C2_NUM+SC2->C2_ITEM+SC2->C2_SEQUEN,SC2->C2_NUM+SC2->C2_ITEM+SC2->C2_SEQUEN+SD4->D4_COD+SC2->C2_XSEQIT,SD4->D4_COD+SC2->C2_XSEQIT})
							nAux:=Len(aZ04Prod)
						Else
							aZ04Prod[nAux,04]:=aZ04Prod[nAux,04]+SD4->D4_QUANT
							aZ04Prod[nAux,06]:=SC2->C2_NUM+SC2->C2_ITEM+SC2->C2_SEQUEN
						EndIf
					EndIf
					SD4->(DbSkip())
				EndDo
			EndIf	
		Next ny

    	// -> Podiciona no item de produção do Teknisa e, carrega os produtos para comparar com os empenhos    		
		dbSelectArea("Z04")
    	Z04->(DbSetOrder(3))
    	Z04->(DbSeek(Z01->Z01_FILIAL+Z01->Z01_SEQVDA+Z01->Z01_CAIXA+DtoS(Z01->Z01_DATA)+(cAliasZ04)->Z04_SEQIT))
    	While !Z04->(Eof()) .and. Z04->Z04_FILIAL == Z01->Z01_FILIAL .and.  Z04->Z04_SEQVDA == Z01->Z01_SEQVDA .and. Z04->Z04_CAIXA == Z01->Z01_CAIXA .and. DTOS(Z04->Z04_DATA) == DtoS(Z01->Z01_DATA) .and. Z04->Z04_SEQIT == (cAliasZ04)->Z04_SEQIT                                                                                                       
			// -> Posiciona na Z13 para "pegar" o código do Protheus			
			Z13->(DbSetOrder(2))
			Z13->(DbSeek(cFilZ13+cEmpZ13+cxFilZ13+Z04->Z04_CODMP))
			If Z13->(Found()) .and. !Empty(Z04->Z04_CODMP)
				nAux:=aScan(aZ04Prod,{|kb| AllTrim(kb[8])==Z13->Z13_COD+(cAliasZ04)->Z04_SEQIT})
				If nAux <=0
					aadd(aZ04Prod,{Z13->Z13_COD,Z04->Z04_QTDE,"Z04",0,SB1->B1_COD,""                                     ,"",Z13->Z13_COD+(cAliasZ04)->Z04_SEQIT})
					nAux:=Len(aZ04Prod)
				Else
					aZ04Prod[nAux,02]:=aZ04Prod[nAux,02]+Z04->Z04_QTDE
				EndIf
			EndIf
			Z04->(DbSkip())
		EndDo
		
		// -> Carrega as observações dos itens de venda 
		aZ04POBS  := {}
		cAliasZ04O:=u_F300Z04O((cAliasZ04)->Z04_SEQIT)
		(cAliasZ04O)->(dbGoTop())
		While !(cAliasZ04O)->(Eof())
			Aadd(aZ04POBS,{(cAliasZ04O)->Z04_PRDUTO,(cAliasZ04O)->Z04_CODMP,(cAliasZ04O)->Z04_SEQIT,(cAliasZ04O)->Z04_CONTR,(cAliasZ04O)->Z04_IDCOBS,(cAliasZ04O)->Z04_QTDE,IIF(Empty((cAliasZ04O)->Z04_CODMP),(cAliasZ04O)->Z04_PRDUTO,(cAliasZ04O)->Z04_CODMP),.F.})
			// -> Posiciona na Z13 para "pegar" o código componente no Protheus			
			Z13->(DbSetOrder(2))
			Z13->(DbSeek(cFilZ13+cEmpZ13+cxFilZ13+aZ04POBS[Len(aZ04POBS),07]))
			If Z13->(Found()) .and. !Empty(aZ04POBS[Len(aZ04POBS),07])
				aZ04POBS[Len(aZ04POBS),07]:=Z13->Z13_COD
			EndIf
			(cAliasZ04O)->(DbSkip())
		Enddo
		(cAliasZ04O)->(DbCloseArea())

		// -> Atualiza os empenhos, se as quantidades utilizadas são diferentes dos empenhos
		lEncontrou:=.F.
		For nx:=1 to Len(aZ04Prod)

			// -> Posiciona no cadstro de produto
			SB1->(DbSetOrder(1))
			SB1->(DbSeek(xFilial("SB1")+aZ04Prod[nx,01]))

			nQtdAdc:=0
			nAux   :=aScan(aZ04POBS,{|kb| AllTrim(kb[7])==AllTrim(SB1->B1_COD)})
			If nAux > 0
				// -> Se retira
				If aZ04POBS[nAux,05] == "R"
					nQtdAdc:=aZ04POBS[nAux,06]*(-1)
					aZ04POBS[nAux,07]:=.T.
					aZ04Prod[nx,02]  :=IIF(nQtdAdc<=0,0,IIF(aZ04Prod[nx,02]+nQtdAdc,0,aZ04Prod[nx,02]+nQtdAdc))
					aZ04Prod[nx,03]  :=IIF(aZ04Prod[nx,02]<=0,"SD4",aZ04Prod[nx,03])
				EndIf
				// -> Se Adiciona
				If aZ04POBS[nAux,05] == "A"
					nQtdAdc:=aZ04POBS[nAux,06]
					aZ04POBS[nAux,07]:=.T.
					aZ04Prod[nx,02]  :=aZ04Prod[nx,02]+nQtdAdc
				EndIf
			EndIf

			// -> Reposiciona na OP
			SC2->(DbSetOrder(1))
			SC2->(DbSeek(xFilial("SC2")+aZ04Prod[nx,06]))	    	
			If SC2->(Found()) .and. !Empty(aZ04Prod[nx,06])

				// -> Se foi empenhado e as quantidades forem diferentes, atualiza o empenho
				If (NoRound(aZ04Prod[nx,02],TamSx3("D4_QUANT")[2]) > 0 .and. NoRound(aZ04Prod[nx,04],TamSx3("D4_QUANT")[2]) > 0) .and. (NoRound(aZ04Prod[nx,02],TamSx3("D4_QUANT")[2]) <> NoRound(aZ04Prod[nx,04],TamSx3("D4_QUANT")[2])) 
					lEncontrou:=.T.
					// -> Posiciona no empenho
					SD4->(DbSetOrder(1))
					If SD4->(DbSeek(SC2->C2_FILIAL+SB1->B1_COD+SC2->C2_NUM+SC2->C2_ITEM+SC2->C2_SEQUEN+Space(nTamD4_OP-Len(SC2->C2_NUM+SC2->C2_ITEM+SC2->C2_SEQUEN))))

						cAuxLog:=StrZero(nxIDThread,10)+": OP "+aZ04Prod[nx,06]+":"+SB1->B1_COD
						cAuxLogD:="Atualizando empenhos da OP no "+SC2->C2_NUM+", item "+SC2->C2_ITEM+", sequencia "+SC2->C2_SEQUEN+" e materia prima "+SB1->B1_COD
						aadd(aRetEMP,{SB1->B1_COD+SC2->C2_NUM+SC2->C2_ITEM+SC2->C2_SEQUEN,"SD4","L",1,cAuxLog,.T.,Z01->Z01_SEQVDA+Z01->Z01_CAIXA,Z01->Z01_DATA, 0, "ALTERACAO DE EMPENHOS", SC2->C2_PRODUTO, cAuxLogD})
						ConOut(cAuxLog)

						aMata380 :={}
						aEmpenI	 :={}									
						aadd(aMata380,{"D4_COD"     ,SD4->D4_COD      	,Nil}) 
						aadd(aMata380,{"D4_LOCAL"   ,SD4->D4_LOCAL    	,Nil})
						aadd(aMata380,{"D4_OP"      ,SD4->D4_OP       	,Nil})
						aadd(aMata380,{"D4_DATA"    ,SD4->D4_DATA     	,Nil})
						// -> Verifica se a quantidade utilizada é maior que a empenhada
						If NoRound(aZ04Prod[nx,02],TamSx3("D4_QUANT")[2]) > NoRound(aZ04Prod[nx,04],TamSx3("D4_QUANT")[2])
							aadd(aMata380,{"D4_QTDEORI" ,NoRound(aZ04Prod[nx,02],TamSx3("D4_QUANT")[2]),Nil})
							aadd(aMata380,{"D4_QUANT"   ,NoRound(aZ04Prod[nx,02],TamSx3("D4_QUANT")[2]),Nil})
						Else
							aadd(aMata380,{"D4_QUANT"   ,NoRound(aZ04Prod[nx,04],TamSx3("D4_QUANT")[2]),Nil})
							aadd(aMata380,{"D4_QTDEORI" ,NoRound(aZ04Prod[nx,04],TamSx3("D4_QUANT")[2]),Nil})
						EndIf
						aadd(aMata380,{"D4_TRT"     ,SD4->D4_TRT      	,Nil})
						aadd(aMata380,{"D4_QTSEGUM" ,SD4->D4_QTSEGUM  	,Nil})
				
						// -> Atualiza os empenhos
						lMsErroAuto:=.F.
						Pergunte("MTA380")
						mata380(aMata380,4,aEmpenI)
				    	If lMsErroAuto
							lErro    := .T.
							cFileName:= "SD4_"+cFilAnt+"_"+SC2->C2_NUM+SC2->C2_ITEM+SC2->C2_SEQUEN+"_"+strtran(time(),":","")
							MostraErro(cPathTmp, cFileName)
							cFileErr :=memoread(cPathTmp+cFileName)
							cAuxLog  :=": Erro na alteracao do empenho do produto. Verifique o detalhamento da ocorrencia."
							cAuxLogD:="Erro na atualização do empenho do produto "+SB1->B1_COD+" para OP "+SC2->C2_NUM+", item " + SC2->C2_ITEM + " e sequencia " + SC2->C2_SEQUEN+Chr(13)+Chr(10)+Chr(13)+Chr(10)+cFileErr
							aadd(aRetEMP,{SB1->B1_COD+SC2->C2_NUM+SC2->C2_ITEM+SC2->C2_SEQUEN,"SD4","E",1,cAuxLog,.T.,Z01->Z01_SEQVDA+Z01->Z01_CAIXA,Z01->Z01_DATA, 0, "ALTERACAO DE EMPENHOS", SB1->B1_COD, cAuxLogD})
							ConOut(cAuxLog)
						Else
							cAuxLog	:=StrZero(nxIDThread,10)+": Ok."
							aadd(aRetEMP,{SB1->B1_COD+SC2->C2_NUM+SC2->C2_ITEM+SC2->C2_SEQUEN,"SD4","L",1,cAuxLog,.T.,Z01->Z01_SEQVDA+Z01->Z01_CAIXA,Z01->Z01_DATA, 0, "ALTERACAO DE EMPENHOS", SB1->B1_COD, cAuxLogD})
							ConOut(cAuxLog)
						EndIf
					EndIf
				EndIf	
			
				// -> Se foi empenhado e as quantidades utilizadas forem iguais a zero
				If aZ04Prod[nx,03] == "SD4" .and. NoRound(aZ04Prod[nx,02],TamSx3("D4_QUANT")[2]) <= 0 .and. NoRound(aZ04Prod[nx,04],TamSx3("D4_QUANT")[2]) > 0 
					lEncontrou:=.T.
					// -> Posiciona no empenho
					SD4->(DbSetOrder(1))
					If SD4->(DbSeek(SC2->C2_FILIAL+SB1->B1_COD+SC2->C2_NUM+SC2->C2_ITEM+SC2->C2_SEQUEN+Space(nTamD4_OP-Len(SC2->C2_NUM+SC2->C2_ITEM+SC2->C2_SEQUEN))))
						
						cAuxLog:=StrZero(nxIDThread,10)+": OP "+aZ04Prod[nx,06]+":"+SB1->B1_COD
						cAuxLogD:="Excluindo empenhos da OP no "+SC2->C2_NUM+", item "+SC2->C2_ITEM+", sequencia "+SC2->C2_SEQUEN+" e materia prima "+SB1->B1_COD
						aadd(aRetEMP,{SB1->B1_COD+SC2->C2_NUM+SC2->C2_ITEM+SC2->C2_SEQUEN,"SD4","L",1,cAuxLog,.T.,Z01->Z01_SEQVDA+Z01->Z01_CAIXA,Z01->Z01_DATA, 0, "ALTERACAO DE EMPENHOS", SC2->C2_PRODUTO, cAuxLogD})
						ConOut(cAuxLog)
						
						aMata380 :={}
						aEmpenI	 :={}									
						aadd(aMata380,{"D4_COD"     ,SD4->D4_COD      	,Nil}) 
						aadd(aMata380,{"D4_LOCAL"   ,SD4->D4_LOCAL    	,Nil})
						aadd(aMata380,{"D4_OP"      ,SD4->D4_OP       	,Nil})
						aadd(aMata380,{"D4_DATA"    ,SD4->D4_DATA     	,Nil})
						aadd(aMata380,{"D4_QTDEORI" ,SD4->D4_QTDEORI	,Nil})
						aadd(aMata380,{"D4_QUANT"   ,SD4->D4_QUANT		,Nil})
						aadd(aMata380,{"D4_TRT"     ,SD4->D4_TRT      	,Nil})
						aadd(aMata380,{"D4_QTSEGUM" ,SD4->D4_QTSEGUM  	,Nil})

						// -> Atualiza os empenhos
						lMsErroAuto:=.F.
						Pergunte("MTA380")
						mata380(aMata380,5,aEmpenI) 
			    		If lMsErroAuto
							lErro    := .T.
							cFileName:= "SD4_"+cFilAnt+"_"+SC2->C2_NUM+SC2->C2_ITEM+SC2->C2_SEQUEN+"_"+strtran(time(),":","")
							MostraErro(cPathTmp, cFileName)
							cFileErr :=memoread(cPathTmp+cFileName)
							cAuxLog  :=StrZero(nxIDThread,10)+": Erro na exclusao do empenho da OP. Verifique o detalhamento da ocorrencia."
							cAuxLogD :="Erro na exclusao do empenho do produto "+SB1->B1_COD+" para OP "+SC2->C2_NUM+", item " + SC2->C2_ITEM + " e sequencia " + SC2->C2_SEQUEN+Chr(13)+Chr(10)+Chr(13)+Chr(10)+cFileErr
							aadd(aRetEMP,{SB1->B1_COD+SC2->C2_NUM+SC2->C2_ITEM+SC2->C2_SEQUEN,"SD4","E",1,cAuxLog,.T.,Z01->Z01_SEQVDA+Z01->Z01_CAIXA,Z01->Z01_DATA, 0, "ALTERACAO DE EMPENHOS", SB1->B1_COD, cAuxLogD})
							ConOut(cAuxLog)
						Else
							cAuxLog  :=StrZero(nxIDThread,10)+": Ok."
							cAuxLogD :="Excluido empenho do produto "+SB1->B1_COD+" para OP "+SC2->C2_NUM+", item " + SC2->C2_ITEM + " e sequencia " + SC2->C2_SEQUEN
							aadd(aRetEMP,{SB1->B1_COD+SC2->C2_NUM+SC2->C2_ITEM+SC2->C2_SEQUEN,"SD4","L",1,cAuxLog,.T.,Z01->Z01_SEQVDA+Z01->Z01_CAIXA,Z01->Z01_DATA, 0, "ALTERACAO DE EMPENHOS", SB1->B1_COD, cAuxLogD})
							ConOut(cAuxLog)
						EndIf

					EndIf
				
				EndIf	
			
			// -> Se nao foi empenhado e a quantidade utilizada for maior que zero
			ElseIf NoRound(aZ04Prod[nx,02],TamSx3("D4_QUANT")[2]) > 0

				// -> Busca a OP relacionada ao produto e armazena para apontamento direto
				nAux:=aScan(aOpsAux,{|kb| AllTrim(kb[2])==AllTrim(aZ04Prod[nx,05])})
				If nAux > 0
					aadd(aRetAPD,{aZ04Prod[nx,05],aZ04Prod[nx,01],aOpsAux[nAux,03],aOpsAux[nAux,04],aOpsAux[nAux,05],NoRound(aZ04Prod[nx,02],TamSx3("D4_QUANT")[2])})
					cAuxLog  :=StrZero(nxIDThread,10)+": Ok."
					cAuxLogD :="O apontamento do produto "+SB1->B1_COD+" para OP "+aOpsAux[nAux,03]+", item " + aOpsAux[nAux,04] + " e sequencia " + aOpsAux[nAux,05] + " sera a feito por apontamento direto."
					aadd(aRetEMP,{SB1->B1_COD+aOpsAux[nAux,03]+aOpsAux[nAux,04]+aOpsAux[nAux,05],"SD4","L",1,cAuxLog,.T.,Z01->Z01_SEQVDA+Z01->Z01_CAIXA,Z01->Z01_DATA, 0, "ALTERACAO DE EMPENHOS", SB1->B1_COD, cAuxLogD})
				EndIf		

			EndIf
		
		Next nx

		(cAliasZ04)->(DbSkip())
	
	EndDo

	(cAliasZ04)->(DbCloseArea())

	SetFunName(cFunNamAnt)

	If !lEncontrou .or. lEofZ04
		cAuxLog  :=StrZero(nxIDThread,10)+": Ok."
		cAuxLogD :="Sem empenhos para alteracao."
		aadd(aRetEMP,{"","SC2","L",0,cAuxLog,.T.,Z01->Z01_SEQVDA+Z01->Z01_CAIXA,Z01->Z01_DATA, 0, "ALTERACAO DE EMPENHOS", "", cAuxLogD})
	   	ConOut(cAuxLog)
	EndIf

	lErro:=IIF(lErro,.F.,.T.)

Return(lErro)
                       



/*
+------------------+---------------------------------------------------------+
!Nome              ! FAT3003                                                 !
+------------------+---------------------------------------------------------+
!Descricao         ! Apotamento das ordens de produção                       !
+------------------+---------------------------------------------------------+
!Autor             ! Alan Lunardi                                            !
+------------------+---------------------------------------------------------+
!Data de Criacao   ! 14/06/2018                                              !
+------------------+---------------------------------------------------------+
*/
User Function FAT3003(aRetApon,axOPs,oEventLog,aRetSB2,nxIDThread)
Local aMata250	:= {}
Local lEncerra	:=.T.
Local nx   		:= 0
Local ny        := 0
Local lErro     := .F.
Local cPathTmp  := "\temp\"
Local cFileErr  := ""
Local cFileName := ""
Local aOPsAuxPI := {}
Local aOPsAuxPA := {}
Local lEncontrou:= .F.
Local cAuxLog	:= "" 
Local cAuxLogD  := ""
Local aAux      := {}
PRIVATE lMsErroAuto := .F.

	/* 
		Array axOPs		
		Numero, Item e sequencia da OP 	-> Posicao 01
		Se a op foi encerrada			-> Posicao 02

	*/ 

	//-> Ordena ordens de produção para fazer primeiro o apontamento do tipo PI
	For nx:=1 to Len(axOPs)

		// -> Posiciona na ordem de produção
		SC2->(DbSetOrder(1))
		If SC2->(DbSeek(xFilial("SC2")+axOPs[nx,1]))

			// -> Posiciona no cadastro do produto
			SB1->(DbSetOrder(1))
			SB1->(DbSeek(xFilial("SB1")+SC2->C2_PRODUTO)) 

			// -> Armazena dados do PI / PA
			If SB1->B1_TIPO $ "PI"
				AADD(aOPsAuxPI,{axOPs[nx,1],axOPs[nx,2],SB1->B1_TIPO})
			Else
				AADD(aOPsAuxPA,{axOPs[nx,1],axOPs[nx,2],SB1->B1_TIPO})
			Endif

		EndIf

	Next nx

	// -> Atualiza ordens de producao priorizando os apontamentos de produtos PI
	axOPs:={}
	For nx:=1 to Len(aOPsAuxPI)
		AADD(axOPs,{aOPsAuxPI[nx,1],aOPsAuxPI[nx,2],aOPsAuxPI[nx,3]})
	Next nx

	// -> Atualiza ordens de producao dos demais apontamentos
	For nx:=1 to Len(aOPsAuxPA)
		AADD(axOPs,{aOPsAuxPA[nx,1],aOPsAuxPA[nx,2],aOPsAuxPA[nx,3]})
	Next nx

	nAuxMod		:=nModulo
	nModulo		:=4
	lEncontrou  :=.F.
	lErro       :=.F.
	For nx:=1 to Len(axOPs)

		lMsErroAuto := .F.
		lEncontrou  := .T.

		// -> Posiciona na ordem de produção
		SC2->(DbSetOrder(1))
		If !SC2->(DbSeek(xFilial("SC2")+axOPs[nx,1]))			
			lErro   := .T.
			cAuxLog	:=StrZero(nxIDThread,10)+": OP nao encontrada. 
			cAuxLogD:="OP no. " + axOPs[nx,1] + " nao encontrada."
			aadd(aRetApon,{axOPs[nx,1],"SC2","E",1,cAuxLog,.T.,Z01->Z01_SEQVDA+Z01->Z01_CAIXA,Z01->Z01_DATA, 0, "APONTAMENTO PRODUCAO", "", cAuxLogD})
			Conout(cAuxLog)
			Loop
		EndIf
	
		cAuxLog	:=StrZero(nxIDThread,10)+": OP " + SC2->C2_NUM+SC2->C2_ITEM+SC2->C2_SEQUEN 
		cAuxLogD:="Apontando OP no. " + SC2->C2_NUM + ", item " + SC2->C2_ITEM + " e sequencia " + SC2->C2_SEQUEN
		aadd(aRetApon,{axOPs[nx,1],"SC2","L",1,cAuxLog,.T.,Z01->Z01_SEQVDA+Z01->Z01_CAIXA,Z01->Z01_DATA, SC2->C2_QUANT, "APONTAMENTO PRODUCAO", SC2->C2_PRODUTO, cAuxLogD})
		Conout(cAuxLog)

		// -> Marca OP para encerramento (fechamento total)
		lEncerra	:=.T.
		axOPs[nx,02]	:=lEncerra			
		
		aMata250	:={;               
						{"D3_OP" 		,SC2->C2_NUM + SC2->C2_ITEM + SC2->C2_SEQUEN	,NIL},;
						{"D3_TM" 		,GetMV("MV_TMPAD" ,,"010")						,NIL},;
						{"D3_COD" 		,SC2->C2_PRODUTO 								,NIL},;
						{"D3_QUANT" 	,SC2->C2_QUANT 									,NIL},;
						{"D3_XSEQVDA" 	,SC2->C2_XSEQVDA 								,NIL},;
						{"D3_XCAIXA" 	,SC2->C2_XCAIXA 								,NIL},;
						{"D3_XSEQIT" 	,SC2->C2_XSEQIT									,NIL},;
						{"D3_EMISSAO" 	,SC2->C2_EMISSAO 								,NIL},;
						{"D3_PARCTOT"	,IIF(lEncerra,"T","P")							,NIL} ;
					  }                                                     
		lMsErroAuto := .F.
		MSExecAuto({|x, y| mata250(x, y)},aMata250,3) 
		If lMsErroAuto
			lErro    := .T.
			cFileName:= "SD3OP"+cFilAnt+"_"+SC2->C2_NUM+SC2->C2_ITEM+SC2->C2_SEQUEN+AllTrim(SC2->C2_PRODUTO)+SC2->C2_LOCAL+"_"+strtran(time(),":","")
			MostraErro(cPathTmp, cFileName)
			cFileErr :=memoread(cPathTmp+cFileName)
			cAuxLog	 :=StrZero(nxIDThread,10)+":Erro no apontamento da OP. Verifique o detalhe da ocorrencia." 
			cAuxLogD :=cFileErr
			aadd(aRetApon,{SC2->C2_NUM+SC2->C2_ITEM+SC2->C2_SEQUEN,"SC2","E",1,cAuxLog,.T.,Z01->Z01_SEQVDA+Z01->Z01_CAIXA,Z01->Z01_DATA, SC2->C2_QUANT, "APONTAMENTO PRODUCAO", SC2->C2_PRODUTO, cAuxLogD})
			Conout(cAuxLog)
			// -> Processa arquivo de retorno do erro do apontamento e verifica e gera logs de falta de saldos
			aAux   :=GetSB2Log(cPathTmp+cFileName)
			cAuxLog:=StrZero(nxIDThread,10)+":Falta saldo de estoque."
			For ny:=1 to Len(aAux)
				aadd(aRetSB2,{aAux[ny,1]+aAux[ny,2],"SB2","E",1,cAuxLog,.T.,"ALL",Z01->Z01_DATA,Val(aAux[ny,2]), "SALDO DE ESTOQUE", SC2->C2_PRODUTO, ""})
			Next ny
		Else
			cAuxLog	 :=StrZero(nxIDThread,10)+": Ok." 
			cAuxLogD :="Apontamento da OP no. " + SC2->C2_NUM + ", item " + SC2->C2_ITEM + " e sequencia " + SC2->C2_SEQUEN + " finalizado com sucesso."
			aadd(aRetApon,{SC2->C2_NUM+SC2->C2_ITEM+SC2->C2_SEQUEN,"SC2","L",1,cAuxLog,.T.,Z01->Z01_SEQVDA+Z01->Z01_CAIXA,Z01->Z01_DATA, SC2->C2_QUANT, "APONTAMENTO PRODUCAO", SC2->C2_PRODUTO, cAuxLogD})
			Conout(cAuxLog)
		EndIf
 
 	Next nx

	If !lEncontrou
		cAuxLog	 :=StrZero(nxIDThread,10)+": Ok." 
		cAuxLogD :="Sem OP para este produto."
		aadd(aRetApon,{"","SC2","L",1,cAuxLog,.T.,Z01->Z01_SEQVDA+Z01->Z01_CAIXA,Z01->Z01_DATA, 0, "APONTAMENTO PRODUCAO", "", cAuxLogD})
		Conout(cAuxLog)
	EndIf

	lErro:=IIF(lErro,.F.,.T.)
	
Return(lErro)  



/*
+------------------+---------------------------------------------------------+
!Nome              ! FAT3004                                                 !
+------------------+---------------------------------------------------------+
!Descricao         ! Apotamento direto na OP                                 !
+------------------+---------------------------------------------------------+
!Autor             ! Alan Lunardi                                            !
+------------------+---------------------------------------------------------+
!Data de Criacao   ! 14/06/2018                                              !
+------------------+---------------------------------------------------------+
*/
User Function FAT3004(aRetSD3,aRetAPD,oEventLog,aRetSB2,nxIDThread)
Local nx		:= 0
Local ny 		:= 0 
Local lErro     := .F.
Local aMATA240	:= {}
Local cTAAD   	:=GetMV("MV_XTMAD",,"")
Local cPathTmp  := "\temp\"
Local cFileErr  := ""
Local cFileName := ""
Local lEncontrou:= .F.
Local cAuxLog	:= ""
Local aAux      := {}
Private lMsErroAuto	:= .F.

	/* 
		Array aRetAPD		
		Produto PA/PI					-> Posicao 01
		Produto MP						-> Posicao 02
		Numero da OP                   	-> Posicao 03
		Item da OP						-> Posicao 04
		Sequenca da OP					-> Posicao 05
		Quantidade a ser apontada		-> Posicao 06
	*/ 

	// -> Executa proceso de apontamentos diretos para os produtos que não foram encontrados na estrutura de produção original do produto PA/PI
	lEncontrou:=.F.
	For nx:=1 to Len(aRetAPD)
		// -> Posiciona na ordem de produção
		SC2->(DbSetOrder(1))
		If SC2->(DbSeek(xFilial("SC2")+aRetAPD[nx,3]+aRetAPD[nx,4]+aRetAPD[nx,5]))

			// -> Posiciona no cadastro do produto
			SB1->(DbSetOrder(1))
			SB1->(DbSeek(xFilial("SB1")+aRetAPD[nx,2])) 
			If SB1->(Found()) .and. !Empty(aRetAPD[nx,2])

				cAuxLog	  :=StrZero(nxIDThread,10)+": OP "+aRetAPD[nx,3]+aRetAPD[nx,4]+aRetAPD[nx,5]+":"+aRetAPD[nx,2]
				aadd(aRetSD3,{SC2->C2_NUM + SC2->C2_ITEM + SC2->C2_SEQUEN + SB1->B1_COD,"SD3","L",1,cAuxLog,.T.,Z01->Z01_SEQVDA+Z01->Z01_CAIXA,Z01->Z01_DATA,0 , "APONTAMENTO DIRETO", SB1->B1_COD, ""})
				Conout(cAuxLog)

				// -> Faz apontamento
				lMsErroAuto := .F.
				aMATA240	:= {} 							  
				aadd(aMATA240,{"D3_TM"		,cTAAD											,Nil})	
				aadd(aMATA240,{"D3_COD"		,SB1->B1_COD									,Nil})	
				aadd(aMATA240,{"D3_LOCAL"	,SB1->B1_LOCPAD									,Nil})	
				aadd(aMATA240,{"D3_QUANT"	,aRetAPD[nx,6]									,Nil})	
				aadd(aMATA240,{"D3_EMISSAO"	,SC2->C2_EMISSAO								,Nil})
		 		aadd(aMATA240,{"D3_OP" 		,SC2->C2_NUM + SC2->C2_ITEM + SC2->C2_SEQUEN	,Nil})
				aadd(aMATA240,{"D3_XCAIXA" 	,SC2->C2_XCAIXA									,Nil})
				aadd(aMATA240,{"D3_XSEQIT" 	,SC2->C2_XSEQIT									,Nil})
				aadd(aMATA240,{"D3_XSEQVDA" ,SC2->C2_XSEQVDA								,Nil})
				lMsErroAuto := .F.
				MSExecAuto({|x,y| mata240(x,y)},aMATA240,3)
				If !lMsErroAuto
					cAuxLog	:="Ok"
					cAuxLogD:="Realizando apontamento direto do produto "+SB1->B1_COD+" na OP " + SC2->C2_NUM + SC2->C2_ITEM + SC2->C2_SEQUEN
					aadd(aRetSD3,{SC2->C2_NUM + SC2->C2_ITEM + SC2->C2_SEQUEN + SB1->B1_COD,"SD3","L",1,cAuxLog,.T.,Z01->Z01_SEQVDA+Z01->Z01_CAIXA,Z01->Z01_DATA, aRetAPD[nx,6], "APONTAMENTO DIRETO", SB1->B1_COD, cAuxLogD})
					Conout(cAuxLog)
				Else
					lErro	 := .T.
					cFileName:= "SD3ADOP"+cFilAnt+"_"+SC2->C2_NUM+SC2->C2_ITEM+SC2->C2_SEQUEN+SB1->B1_COD+SB1->B1_LOCPAD+"_"+strtran(time(),":","")
					MostraErro(cPathTmp, cFileName)
					cFileErr :=memoread(cPathTmp+cFileName)
					cAuxLog	:=StrZero(nxIDThread,10)+"Erro no apontamento direto. Verifique o detalhe da ocorrencia."
					cAuxLogD:=cFileErr
					aadd(aRetSD3,{SC2->C2_NUM + SC2->C2_ITEM + SC2->C2_SEQUEN + SB1->B1_COD,"SD3","E",1,cAuxLog,.T.,Z01->Z01_SEQVDA+Z01->Z01_CAIXA,Z01->Z01_DATA, aRetAPD[nx,6], "APONTAMENTO DIRETO", SB1->B1_COD, cAuxLogD})
					ConOut(cAuxLog)

					// -> Processa arquivo de retorno do erro do apontamento direto e gera logs de falta de saldos
					aAux   :=GetSB2Log(cPathTmp+cFileName)
					cAuxLog:=StrZero(nxIDThread,10)+":Falta saldo de estoque."
					For ny:=1 to Len(aAux)
						aadd(aRetSB2,{aAux[ny,1]+aAux[ny,2],"SB2","E",1,cAuxLog,.T.,"ALL",Z01->Z01_DATA,Val(aAux[ny,2]), "SALDO DE ESTOQUE", SC2->C2_PRODUTO, ""})
					Next ny

				EndIf

			EndIf
			
		Else
			
			lErro:=.T.
			cAuxLog	:=StrZero(nxIDThread,10)+":Erro no apontamento direto."
			cAuxLogD:="OP " + aRetAPD[nx,3]+aRetAPD[nx,4]+aRetAPD[nx,5] + " nao encontrada na tabela SC2."
			aadd(aRetSD3,{SC2->C2_NUM + SC2->C2_ITEM + SC2->C2_SEQUEN + SB1->B1_COD,"SD3","E",1,cAuxLog,.T.,Z01->Z01_SEQVDA+Z01->Z01_CAIXA,Z01->Z01_DATA, 0, "APONTAMENTO DIRETO", "", cAuxLogD})
			ConOut(cAuxLog)

		EndIf

	Next nx

	If !lEncontrou
		cAuxLog	:=StrZero(nxIDThread,10)+": Ok."
		cAuxLogD:="Sem OP para apontamento."
		aadd(aRetSD3,{"","SD3","L",1,cAuxLog,.T.,Z01->Z01_SEQVDA+Z01->Z01_CAIXA,Z01->Z01_DATA, 0, "APONTAMENTO DIRETO", "", cAuxLogD})
		ConOut(cAuxLog)
	EndIf

	lErro:=IIF(lErro,.F.,.T.)

Return(lErro)





/*
+------------------+---------------------------------------------------------+
!Nome              ! FAT3009                                                 !
+------------------+---------------------------------------------------------+
!Descricao         ! Gera titulos a receber                                  !
+------------------+---------------------------------------------------------+
!Autor             ! Alan Lunardi                                            !
+------------------+---------------------------------------------------------+
!Data de Criacao   ! 14/06/2018                                              !
+------------------+---------------------------------------------------------+
*/
User Function FAT3009(aRet3009,oEventLog,nxIDThread)
Local cPathTmp  := "\temp\"
Local cFileName := ""
Local lErro	   	:= .F. 
Local nAux	   	:= 0
Local nModAnt  	:= nModulo
Local cAuxLog  	:= ""
Local cAuxLogD  := ""
Local dEmisSE1 	:= dDataBase
Local aVctoSE1 	:= {}
Local aDadosSE1	:= {}
Local aBaixa	:= {}
Local nl       	:= 0 
Local nTamParc  := TamSX3("E1_PARCELA")[1]
Local aBcAgCo   := StrToKarr(GetMV("MV_CXLOJA",,""), '/')
Local cBcLoja	:= aBcAgCo[1]+Space(TamSX3("A6_COD")[1]    -Len(aBcAgCo[1]))
Local cAgLoja	:= aBcAgCo[2]+Space(TamSX3("A6_AGENCIA")[1]-Len(aBcAgCo[2]))
Local cCCLoja	:= aBcAgCo[3]+Space(TamSX3("A6_NUMCON")[1] -Len(aBcAgCo[3]))
Local aBcAgCoP  := StrToKarr(GetMV("MV_XBCCTP",,""), '/')
Local cBcLojaP	:= aBcAgCoP[1]+Space(TamSX3("A6_COD")[1]    -Len(aBcAgCoP[1]))
Local cAgLojaP	:= aBcAgCoP[2]+Space(TamSX3("A6_AGENCIA")[1]-Len(aBcAgCoP[2]))
Local cCCLojaP	:= aBcAgCoP[3]+Space(TamSX3("A6_NUMCON")[1] -Len(aBcAgCoP[3]))
Local cTipoSE1  := ""
Local nTamTipo  := TamSX3("E1_TIPO")[1]
Local cTipoCart := "CA/CM/CC/CD"
Local cAux		:= ""
Local cCodCli   := ""
Local cCodLCli  := ""
Local cNomCli   := ""
Local cCodAdm   := ""
Local cCodLAdm  := ""
Local cNomAdm   := ""
Local nTaxaAdm	:= 0
Local cNatTxAdm := ""
Local cNatSE1	:= ""
Local cEmpZ10   := ""
Local cFilZ10   := ""
Local nTamDoc   := TamSX3('E1_NUM')[1]
Local nParc     := 0
Local cFunNamAnt:= FunName()
Private lMsErroAuto	:= .F.
   	
	SetFunName("FINA040")
	   			
	// -> Seleciona as tabelas utilizadas no processo
	DbSelectArea("SA1")
	DbSelectArea("SA6")
	DbSelectArea("SAE")
	DbSelectArea("SE4")
	DbSelectArea("SED")
	DbSelectArea("Z10")
	DbSelectArea("Z03")
	DbSelectArea("SE1")
	DbSelectArea("SE5")
	DbSelectArea("FKF")

	cCodCli   := ""
	cCodLCli  := ""
	cNomCli   := ""
	cCodAdm   := ""
	cCodLAdm  := ""
	cNomAdm   := ""
	cNatSE1	  := ""

	// -> Pesquisa cliente e, caso nao exista pega o cliente padrão		
	SA1->(DbSetOrder(3))
	SA1->(DbSeek(xFilial("SA1")+Z01->Z01_CGC))		
	If !SA1->(Found()) .or. Empty(Z01->Z01_CGC)
		// -> Verifica se o cliente padrão está cadastrado
		SA1->(DbSetOrder(1))
		SA1->(DbSeek(xFilial("SA1")+cMVCLIPAD+cMVLOJAPAD))
		If !SA1->(Found())
			lErro   :=.T.
			cAuxLog	:=StrZero(nxIDThread,10)+": Cliente nao encontrado."
			cAuxLogD:="Cliente "+cMVCLIPAD+" e loja "+cMVLOJAPAD+" nao encontrado na tabela SA1. Verifique os parametros MV_CLIPAD e MV_LOJAPAD."
			aadd(aRet3009,{Z01->cMVCLIPAD+cMVLOJAPAD,"SA1","E",1,cAuxLog,.T.,Z01->Z01_SEQVDA+Z01->Z01_CAIXA,Z01->Z01_DATA, 0, "FINANCEIRO", "", cAuxLogD})
			Conout(cAuxLog)
		Else
			cCodCli   := SA1->A1_COD
			cCodLCli  := SA1->A1_LOJA
			cNomCli   := SA1->A1_NOME
			cCodAdm   := ""
			cCodLAdm  := ""
			cNomAdm   := ""	
		EndIf	
	Else
		cCodCli   := SA1->A1_COD
		cCodLCli  := SA1->A1_LOJA
		cNomCli   := SA1->A1_NOME
		cCodAdm   := ""
		cCodLAdm  := ""
		cNomAdm   := ""	
	EndIf
	
	// -> Pesquisa banco da 'unidade' 
	SA6->(DbSetOrder(1))
	If !SA6->(DbSeek(xFilial("SA6")+cBcLoja+cAgLoja+cCCLoja))
		lErro   :=.T.
		cAuxLog	:=StrZero(nxIDThread,10)+": Banco da unidade de negocio."
		cAuxLogD:="Banco da unidade de negocio nao encontrado na tabela SA6. Verifique os dados de banco, agencia e conta: A6_COD="+IIF(Empty(cBcLoja),"Vazio",cBcLoja)+", A6_AGENCIA="+IIF(Empty(cAgLoja),"Vazio",cAgLoja)+" e A6_NUMCON="+IIF(Empty(cCCLoja),"Vazio",cCCLoja)
		aadd(aRet3009,{cBcLoja+cAgLoja+cCCLoja,"SA6","E",1,cAuxLog,.T.,Z01->Z01_SEQVDA+Z01->Z01_CAIXA,Z01->Z01_DATA, 0, "FINANCEIRO", "", cAuxLogD})		
		Conout(cAuxLog)
	Else
		cBcLoja:=SA6->A6_COD
		cAgLoja:=SA6->A6_AGENCIA
		cCCLoja:=SA6->A6_NUMCON	
	EndIf
	
	// -> Pesquisa banco para condição "vale presente" 
	SA6->(DbSetOrder(1))
	If !SA6->(DbSeek(xFilial("SA6")+cBcLojaP+cAgLojaP+cCCLojaP))
		lErro   :=.T.
		cAuxLog	:=StrZero(nxIDThread,10)+": Banco 'cartao vale presente' nao encontrado."
		cAuxLogD:="Banco 'cartao vale presente' nao encontrado na tabela SA6. Verifique os dados de banco, agencia e conta: A6_COD="+IIF(Empty(cBcLojaP),"Vazio",cBcLojaP)+", A6_AGENCIA="+IIF(Empty(cAgLojaP),"Vazio",cAgLojaP)+" e A6_NUMCON="+IIF(Empty(cCCLojaP),"Vazio",cCCLojaP)
		aadd(aRet3009,{cBcLojaP+cAgLojaP+cCCLojaP,"SA6","E",1,cAuxLog,.T.,Z01->Z01_SEQVDA+Z01->Z01_CAIXA,Z01->Z01_DATA, 0, "FINANCEIRO", "", cAuxLogD})
		Conout(cAuxLog)
	Else
		cBcLojaP:=SA6->A6_COD
		cAgLojaP:=SA6->A6_AGENCIA
		cCCLojaP:=SA6->A6_NUMCON
	EndIf

	// -> Se o retorno for falso, sai da função
	If lErro
		nModulo :=nModAnt
		cAuxLog	:=StrZero(nxIDThread,10)+":Erro nos dados financeiros. Verifique as ocorrencias registradas no log."
		cAuxLogD:="Houve erros no processamento dos recebimentos para a venda con sequencia " + Z01->Z01_SEQVDA + " e caixa " + Z01->Z01_CAIXA
		aadd(aRet3009,{Z01->Z01_CAIXA+cDocSF2,"SE1","E",1,cAuxLog,.T.,Z01->Z01_SEQVDA+Z01->Z01_CAIXA,Z01->Z01_DATA, 0, "FINANCEIRO", "", cAuxLogD})
		Conout(cAuxLog)
		Return(.F.) 
	EndIf
	
	nModulo:=6
	// -> Posiciona na condição de recebimento da venda
	Z03->(DbSetOrder(3))
	Z03->(DbSeek(Z01->Z01_FILIAL+Z01->Z01_SEQVDA+Z01->Z01_CAIXA+DtoS(Z01->Z01_DATA)))
	While !Z03->(Eof()) .and. Z03->Z03_FILIAL == Z01->Z01_FILIAL .and. Z03->Z03_SEQVDA == Z01->Z01_SEQVDA .and. Z03->Z03_CAIXA == Z01->Z01_CAIXA .and. DtoS(Z03->Z03_DATA) == DtoS(Z01->Z01_DATA)
	
		nTaxaAdm  :=0
		cNatTxAdm :=""
		cEmpZ10   := IIF(Empty(xFilial("Z10")),Space(TamSx3("Z03_CDEMP")[1]),Z03->Z03_CDEMP)
		cFilZ10   := IIF(Empty(xFilial("Z10")),Space(TamSx3("Z03_CDFIL")[1]) ,Z03->Z03_CDFIL)

		// -> Verifica condição de pagamento - Protheus
		SE4->(DbOrderNickName("E4CODEXT"))
		If !SE4->(DbSeek(xFilial("SE4")+Z03->Z03_COND))			
			cAuxLog	:=StrZero(nxIDThread,10)+": Consicao de pagamento nao encontrada."
			cAuxLogD:="A Condicao de pagamento "+Z03->Z03_COND+" nao está vinculada ao Teknisa. (SE4)"			
			aadd(aRet3009,{cBcLojaP+cAgLojaP+cCCLojaP,"SA6","E","E4CODEXT",cAuxLog,.T.,Z01->Z01_SEQVDA+Z01->Z01_CAIXA,Z01->Z01_DATA, 0, "FINANCEIRO", "", cAuxLogD})
			Conout(cAuxLog)
			Z03->(DbSkip())
			Loop
		ElseIf Empty(SE4->E4_XFORMA)
			// -> Verifica se existe a forma de pagamento cadastrada
			cAuxLog	:=StrZero(nxIDThread,10)+": Forma de recebimento nao encontrada."
			cAuxLogD:="A forma de recebimento "+SE4->E4_CODIGO+" nao foi informada no campo E4_XFORMA."			
			aadd(aRet3009,{SE4->E4_CODIGO,"SE4","E",1,cAuxLog,.T.,Z01->Z01_SEQVDA+Z01->Z01_CAIXA,Z01->Z01_DATA, 0, "FINANCEIRO", "", cAuxLogD})
			Conout(cAuxLog)
			Z03->(DbSkip())
			Loop
		Else
			// -> Verifica se existe a natureza cadastrada para a condicao de pagamento
			SED->(DbSetOrder(1))
			If !SED->(DbSeek(xFilial("SED")+SE4->E4_XNATVDA))
				cAuxLog	:=StrZero(nxIDThread,10)+": Natureza financeira nao cadastrada na tabela SED."
				cAuxLogD:="A natureza financeira "+SE4->E4_XNATVDA+" cadastrada na condicao de recebimento nao foi encontrada na tabela SED."			
				aadd(aRet3009,{SE4->E4_XNATVDA,"SED","E",1,cAuxLog,.T.,Z01->Z01_SEQVDA+Z01->Z01_CAIXA,Z01->Z01_DATA, 0, "FINANCEIRO", "", cAuxLogD})
				Conout(cAuxLog)
				Z03->(DbSkip())
				Loop
			Else
				cNatSE1:=SED->ED_CODIGO
			EndIf
			// -> Verifica administradora de cartao
			If UPPER(SE4->E4_XFORMA) $ cTipoCart	
				// -> Pesquisa administradora
				SAE->(DbOrderNickName("AEXCOD"))
				If !SAE->(DbSeek(xFilial("SE4")+SE4->E4_CODIGO))
					cAuxLog	:=StrZero(nxIDThread,10)+": Condicao de recebimento nao relacionada a administradora financeira."
					cAuxLogD:="Nao ha condicao de recebimento relacionada na administradora financeira: AE_XCOD="+SE4->E4_CODIGO
					aadd(aRet3009,{SED->E4_XNATVDA,"SAE","E","AEXCOD",cAuxLog,.T.,Z01->Z01_SEQVDA+Z01->Z01_CAIXA,Z01->Z01_DATA, 0, "FINANCEIRO", "", cAuxLogD})
					Conout(cAuxLog)
					Z03->(DbSkip())
					Loop
				Else
					// -> Posiciona no cliente da administradora
					cAux:="01"
					SA1->(DbSetOrder(1))					
					SA1->(DbSeek(xFilial("SA1")+SAE->AE_CODCLI))
					If !SA1->(Found())
						cAuxLog	:=StrZero(nxIDThread,10)+": Cliente relacionado a administradora nao cadastrada."
						cAuxLogD:="O cliente "+SAE->AE_CODCLI+" e loja "+cAux+" relacionado a administradora financeira nao foi encontrado na tabela SA1."
						aadd(aRet3009,{SAE->AE_CODCLI+cAux,"SA1","E",1,cAuxLog,.T.,Z01->Z01_SEQVDA+Z01->Z01_CAIXA,Z01->Z01_DATA, 0, "FINANCEIRO", "", cAuxLogD})
						Conout(cAuxLog)
						Z03->(DbSkip())
						Loop
					Else
						cCodAdm   := SA1->A1_COD
						cCodLAdm  := SA1->A1_LOJA
						cNomAdm   := SA1->A1_NOME
						nTaxaAdm  := SAE->AE_TAXA
						cNatTxAdm := SAE->AE_XNTXADM						
						// -> Verifica se ataxa de administracao estiver zerada, gera aviso
						If nTaxaAdm <= 0
							cAuxLog	:=StrZero(nxIDThread,10)+": Taxa da aministradora zerada."
							cAuxLogD:="A taxa de administracao está zerada para a administradora financeira: AE_COD="+SAE->AE_COD
							aadd(aRet3009,{SAE->AE_CODCLI,"SAE","W",1,cAuxLog,.T.,Z01->Z01_SEQVDA+Z01->Z01_CAIXA,Z01->Z01_DATA, 0, "FINANCEIRO", "", cAuxLogD})
							Conout(cAuxLog)
						Else
							// -> Verifica se existe a natureza cadastrada para a taxa de administracao
							SED->(DbSetOrder(1))
							If !SED->(DbSeek(xFilial("SED")+cNatTxAdm))
								cAuxLog	:=StrZero(nxIDThread,10)+": Natureza da taxa da aministradora invalida."
								cAuxLogD:="A natureza da taxa de administracao para a administradora financeira é invalida: AE_XNTXADM="+SAE->AE_XNTXADM
								aadd(aRet3009,{SAE->AE_XNTXADM,"SAE","E",1,cAuxLog,.T.,Z01->Z01_SEQVDA+Z01->Z01_CAIXA,Z01->Z01_DATA, 0, "FINANCEIRO", "", cAuxLogD})								
								Conout(cAuxLog)
								Z03->(DbSkip())
								Loop
							EndIf	
						EndIf
					EndIf
				EndIf
			EndIf
		EndIf	
				
		dEmisSE1:=IIF(Z03->Z03_DATA < dEmisSE1,dEmisSE1,Z03->Z03_DATA) 
	    // -> Calcula vencimento e valores da condicao de pagamento    
	    aVctoSE1 := CONDICAO(Z03->Z03_VRREC,SE4->E4_CODIGO,,dEmisSE1)
	    
		nParcs := Len(aVctoSE1)
		nValParc := 0
		nValAux  := 0
		
	    // -> Atualiza consicao de pagamento
	    For nl:=1 to Len(aVctoSE1) 
	    	
			nParc :=nParc+1 
			aVenc := {}	
			
			If nl == Len(aVctoSE1)
				nValParc := Z03->Z03_VRREC - nValAux 
			Else	
				nValParc := Z03->Z03_VRREC / nParcs
				nValAux += nValParc
			EndIf 
				
			aadd(aVenc,{nValParc,aVctoSE1[nl,1]}) 

	    	// -> Gera títulos a receber - Recebimento a vista
	    	If UPPER(SE4->E4_XFORMA) $ "AV"
	    	
	    		cTipoSE1:="R$"
	    		cTipoSE1:=cTipoSE1+Space(nTamTipo-Len(cTipoSE1))
				cAuxLog	:=StrZero(nxIDThread,10)+": Incluindo titulo "+Z01->Z01_CAIXA+":"+cDocSF2+":"+StrZero(nParc,nTamParc)+":"+cTipoSE1"
				cAuxLogD:="Incluindo titulo "+cDocSF2+", prefixo " + Z01->Z01_CAIXA + " e parcela "+StrZero(nParc,nTamParc)
				aadd(aRet3009,{Z01->Z01_CAIXA+cDocSF2+StrZero(nParc,nTamParc)+cTipoSE1,"SE1","L",1,cAuxLog,.T.,Z01->Z01_SEQVDA+Z01->Z01_CAIXA,Z01->Z01_DATA, 0, "FINANCEIRO", "", cAuxLogD})
				Conout(cAuxLog)

		    	aDadosSE1 :={ 	{ "E1_PREFIXO"  , cxSerie        													, NIL },;
		    					{ "E1_NUM"      , cDocSF2												           	, NIL },;
		    					{ "E1_PARCELA"  , StrZero(nParc,nTamParc)              								, NIL },;
		    					{ "E1_TIPO"     , cTipoSE1              											, NIL },;
		    					{ "E1_NATUREZ"  , cNatSE1			   												, NIL },;
		    					{ "E1_CLIENTE"  , cCodCli	         											   	, NIL },;
		    					{ "E1_LOJA"     , cCodLCli          												, NIL },;
		    					{ "E1_XCLIENT"  , cCodCli       	   											   	, NIL },;
		    					{ "E1_XLOJA"    , cCodLCli		          											, NIL },;
		    					{ "E1_XNOME"    , cNomCli  		        											, NIL },;
		    					{ "E1_EMISSAO"  , dEmisSE1															, NIL },;
		    					{ "E1_VENCTO"   , aVenc[nl,2]														, NIL },;
		    					{ "E1_VENCREA"  , aVenc[nl,2]														, NIL },;
								{ "E1_XDTCAIX"  , Z03->Z03_DTABER													, NIL },;
		    					{ "E1_VALOR"    , aVenc[nl,1]  		  												, NIL },;
		    					{ "E1_HIST"     , "Venda a vista"													, NIL },;
		    					{ "E1_NUMNOTA"  , cDocSF2															, NIL },;
		    					{ "E1_SERIE"    , cxSerie       													, NIL },;
		    					{ "E1_ORIGEM"   , "MATA920"															, NIL },;
		    					{ "E1_XSEQVDA"  , Z03->Z03_SEQVDA													, NIL },;
		    					{ "E1_XCAIXA"   , Z03->Z03_CAIXA   													, NIL },;
		    					{ "E1_XCODEXT"  , Z03->Z03_COND   											        , NIL },;
		    					{ "E1_XHORAV"   , Z03->Z03_HRVDA													, NIL },;
		    					{ "E1_XCONC"    , "N"																, NIL } ;
		    				}
		    				
		    	// -> Inclui recebiemnto a 'vista'
		    	lMsErroAuto:=.F.
		    	MsExecAuto({|x,y| FINA040(x,y)},aDadosSE1,3)
		    	If lMsErroAuto
		    		lErro	 :=.T.
					cFileName:= "se1_"+cFilAnt+"_"+cxSerie+"_"+AllTrim(cDocSF2)+"_"+strtran(time(),":","")
					MostraErro(cPathTmp, cFileName)
					cFileErr :=memoread(cPathTmp+cFileName)
					cAuxLog	:=StrZero(nxIDThread,10)+": Erro na inclusao do titulo. Verifique o detalhamento da ocorrencia."
					cAuxLogD:=cFileErr					
					aadd(aRet3009,{cxSerie+cDocSF2+StrZero(nParc,nTamParc)+cTipoSE1,"SE1","E",1,cAuxLog,.T.,Z01->Z01_SEQVDA+Z01->Z01_CAIXA,Z01->Z01_DATA, 0, "FINANCEIRO", "", cAuxLogD})
					Conout(cAuxLog)
				Else
					// -> Baixa o titulo.
					SA6->(DbSetOrder(1))
	                SA6->(DbSeek(xFilial("SA6")+cBcLoja+cAgLoja+cCCLoja))
					Pergunte("FIN070",.F.)
					aBaixa :={	{"E1_PREFIXO"  ,SE1->E1_PREFIXO                  							,Nil    },;
								{"E1_NUM"      ,SE1->E1_NUM												    ,Nil    },;
								{"E1_PARCELA"  ,SE1->E1_PARCELA										        ,NIL    },;
								{"E1_TIPO"     ,SE1->E1_TIPO               									,Nil    },;
							    {"E1_CLIENTE"  ,SE1->E1_CLIENTE                                             ,Nil    },;
			   					{"E1_LOJA"     ,SE1->E1_LOJA                                                ,Nil    },;
			   					{"E1_NATUREZ"  ,SE1->E1_NATUREZ                                             ,Nil    },;
								{"AUTMOTBX"    ,"NOR"                  										,Nil    },;
								{"AUTBANCO"    ,SA6->A6_COD                  								,Nil    },;
								{"AUTAGENCIA"  ,SA6->A6_AGENCIA   		            						,Nil    },;
								{"AUTCONTA"    ,SA6->A6_NUMCON      										,Nil    },;
								{"AUTDTBAIXA"  ,SE1->E1_VENCREA              								,Nil    },;
								{"AUTDTCREDITO",SE1->E1_VENCREA       										,Nil    },;
								{"AUTHIST"     ,"Recbto venda a vista"          							,Nil    },;
								{"AUTJUROS"    ,0                      										,Nil,.T.},;
								{"AUTVALREC"   ,aVenc[nl,1]                    								,Nil    } }

					// -> Executa a baixa do titulo
					lMsErroAuto:=.F.
					MSExecAuto({|x,y| Fina070(x,y)},aBaixa,3)
					If lMsErroAuto
						lErro    :=.T.
						cFileName:= "se1_"+cFilAnt+"_"+cxSerie+"_"+AllTrim(cDocSF2)+"_"+strtran(time(),":","")
						MostraErro(cPathTmp, cFileName)
						cFileErr :=memoread(cPathTmp+cFileName)
						cAuxLog	:=StrZero(nxIDThread,10)+": Erro na baixa do titulo recebido em dinheiro. Verifique o detalhamento da ocorrencia."
						cAuxLogD:=cFileErr					
						aadd(aRet3009,{cxSerie+cDocSF2+StrZero(nParc,nTamParc)+cTipoSE1,"SE5","E",7,cAuxLog,.T.,Z01->Z01_SEQVDA+Z01->Z01_CAIXA,Z01->Z01_DATA, 0, "FINANCEIRO", "", cAuxLogD})
						Conout(cAuxLog)
					Else
						cAuxLog	:=StrZero(nxIDThread,10)+": Ok."
						cAuxLogD:="Titulo "+cDocSF2+", prefixo " + cxSerie + " e parcela "+StrZero(nParc,nTamParc) + " incluido com sucesso."
						aadd(aRet3009,{cxSerie+cDocSF2+StrZero(nParc,nTamParc)+cTipoSE1,"SE1","L",1,cAuxLog,.T.,Z01->Z01_SEQVDA+Z01->Z01_CAIXA,Z01->Z01_DATA, 0, "FINANCEIRO", "", cAuxLogD})
						Conout(cAuxLog)
					Endif	 
				EndIf			
			
			// -> Vendas com cartao 	
	    	ElseIf UPPER(SE4->E4_XFORMA) $ cTipoCart
	    		cTipoSE1:=SAE->AE_TIPO
	    		cTipoSE1:=cTipoSE1+Space(nTamTipo-Len(cTipoSE1))	    	
								
				cAuxLog	:=StrZero(nxIDThread,10)+": Incluindo titulo "+cxSerie+":"+cDocSF2+":"+StrZero(nParc,nTamParc)+":"+cTipoSE1"
				cAuxLogD:="Incluindo titulo "+cDocSF2+", prefixo " + cxSerie + " e parcela "+StrZero(nParc,nTamParc)
				aadd(aRet3009,{cxSerie+cDocSF2+StrZero(nParc,nTamParc)+cTipoSE1,"SE1","L",1,cAuxLog,.T.,Z01->Z01_SEQVDA+Z01->Z01_CAIXA,Z01->Z01_DATA, 0, "FINANCEIRO", "", cAuxLogD})
				Conout(cAuxLog)

				aDadosSE1 :={ 	{ "E1_PREFIXO"  , cxSerie       													, NIL },;
		    					{ "E1_NUM"      , cDocSF2												           	, NIL },;
		    					{ "E1_PARCELA"  , StrZero(nParc,nTamParc)              								, NIL },;
		    					{ "E1_TIPO"     , cTipoSE1              											, NIL },;
		    					{ "E1_NATUREZ"  , cNatSE1			   												, NIL },;
		    					{ "E1_CLIENTE"  , cCodAdm	         											   	, NIL },;
		    					{ "E1_LOJA"     , cCodLAdm          												, NIL },;
		    					{ "E1_XCLIENT"  , cCodCli       	   											   	, NIL },;
		    					{ "E1_XLOJA"    , cCodLCli		          											, NIL },;
		    					{ "E1_XNOME"    , cNomCli  		        											, NIL },;
		    					{ "E1_EMISSAO"  , dEmisSE1															, NIL },;
		    					{ "E1_VENCTO"   , aVenc[nl,2]														, NIL },;
		    					{ "E1_VENCREA"  , aVenc[nl,2]														, NIL },;
								{ "E1_XDTCAIX"  , Z03->Z03_DTABER													, NIL },;
		    					{ "E1_VALOR"    , aVenc[nl,1]  		  												, NIL },;
		    					{ "E1_HIST"     , "Venda cartao :" + SAE->AE_TIPO 									, NIL },;
		    					{ "E1_NUMNOTA"  , cDocSF2															, NIL },;
		    					{ "E1_SERIE"    , cxSerie       													, NIL },;
		    					{ "E1_ORIGEM"   , "MATA920"															, NIL },;
		    					{ "E1_XSEQVDA"  , Z03->Z03_SEQVDA													, NIL },;
		    					{ "E1_XCAIXA"   , Z03->Z03_CAIXA   													, NIL },;
		    					{ "E1_XCODEXT"  , Z03->Z03_COND   											        , NIL },;
								{ "E1_XADMIN"   , SAE->AE_COD														, NIL },;
								{ "E1_XDESCAD"  , SAE->AE_DESC														, NIL },;
		    					{ "E1_DOCTEF"   , Z03->Z03_NSU														, NIL },;
		    					{ "E1_XNUMCAR"  , Z03->Z03_NCART													, NIL },;
		    					{ "E1_XHORAV"   , Z03->Z03_HRVDA													, NIL },;
		    					{ "E1_XCONC"    , "N"																, NIL } ;
		    				}
		    				
		    	// -> Inclui recebiemnto com cartao
		    	lMsErroAuto:=.F.
		    	MsExecAuto({|x,y| FINA040(x,y)},aDadosSE1,3)
		    	If lMsErroAuto
		    		lErro	 :=.T.
					cFileName:= "se1_"+cFilAnt+"_"+cxSerie+"_"+AllTrim(cDocSF2)+"_"+strtran(time(),":","")
					MostraErro(cPathTmp, cFileName)
					cFileErr :=memoread(cPathTmp+cFileName)
					cAuxLog	:=StrZero(nxIDThread,10)+": Erro na inclusao do titulo. Verifique o detalhamento da ocorrencia."
					cAuxLogD:=cFileErr
					aadd(aRet3009,{SE1->E1_PREFIXO+SE1->E1_NUM+SE1->E1_PARCELA+cTipoSE1,"SE1","E",1,cAuxLog,.T.,Z01->Z01_SEQVDA+Z01->Z01_CAIXA,Z01->Z01_DATA, 0, "FINANCEIRO", "", cAuxLogD})
					Conout(cAuxLog)
				Else
					// -> Inclui título de abatimento
					If nTaxaAdm > 0 
						cTipoSE1:="AB-"
						cTipoSE1:=cTipoSE1+Space(nTamTipo-Len(cTipoSE1))	    	
						Conout(cAuxLog)
						aDadosSE1 :={ 	{ "E1_PREFIXO"  , SE1->E1_PREFIXO													, NIL },;
										{ "E1_NUM"      , SE1->E1_NUM											           	, NIL },;
										{ "E1_PARCELA"  , SE1->E1_PARCELA              										, NIL },;
										{ "E1_TIPO"     , cTipoSE1              											, NIL },;
										{ "E1_NATUREZ"  , cNatTxAdm			   												, NIL },;
										{ "E1_CLIENTE"  , cCodAdm	         											   	, NIL },;
										{ "E1_LOJA"     , cCodLAdm          												, NIL },;
										{ "E1_XCLIENT"  , cCodCli       	   											   	, NIL },;
										{ "E1_XLOJA"    , cCodLCli		          											, NIL },;
										{ "E1_XNOME"    , cNomCli  		        											, NIL },;
										{ "E1_EMISSAO"  , dEmisSE1															, NIL },;
										{ "E1_VENCTO"   , aVenc[nl,2]														, NIL },;
										{ "E1_VENCREA"  , aVenc[nl,2]														, NIL },;
										{ "E1_XDTCAIX"  , SE1->E1_XDTCAIX													, NIL },;
										{ "E1_VALOR"    , (aVenc[nl,1]/100)*nTaxaAdm   		  								, NIL },;
										{ "E1_HIST"     , "Taxa adm."  														, NIL },;
										{ "E1_XSEQVDA"  , Z03->Z03_SEQVDA													, NIL },;
										{ "E1_XCAIXA"   , Z03->Z03_CAIXA   													, NIL },;
										{ "E1_XCODEXT"  , Z03->Z03_COND   											        , NIL },;
										{ "E1_XADMIN"   , SAE->AE_COD														, NIL },;
										{ "E1_XDESCAD"  , SAE->AE_DESC														, NIL },;
										{ "E1_DOCTEF"   , Z03->Z03_NSU														, NIL },;
										{ "E1_XNUMCAR"  , Z03->Z03_NCART													, NIL },;
										{ "E1_XHORAV"   , Z03->Z03_HRVDA													, NIL },;
										{ "E1_XCONC"    , "N"																, NIL } ;
									}

						// -> Inclui titulo de abatimento com a taxa de adminstracao
						lMsErroAuto:=.F.

						/* inicializa as variaveis de memoria, com os dados do título, pois 
						 	há um problema no execauto da 12, que usa variaveis de memória para 
							buscar o titulo
						*/
						RegToMemory("SE1",.F.) 
						MsExecAuto({|x,y| FINA040(x,y)},aDadosSE1,3)
						If lMsErroAuto
							lErro	 :=.T.
							cFileName:= "se1_"+cFilAnt+"_"+cxSerie+"_"+AllTrim(cDocSF2)+"_"+strtran(time(),":","")
							MostraErro(cPathTmp, cFileName)
							cFileErr :=memoread(cPathTmp+cFileName)
							cAuxLog	 :=StrZero(nxIDThread,10)+":Erro na inclusao do titulo de abatimento. Verifique o detalhamento da ocorrencia.
							cAuxLogD :=cFileErr
							aadd(aRet3009,{cxSerie+cDocSF2+StrZero(nParc,nTamParc)+cTipoSE1,"SE1","E",1,cAuxLog,.T.,Z01->Z01_SEQVDA+Z01->Z01_CAIXA,Z01->Z01_DATA, 0, "FINANCEIRO", "", cAuxLogD})
							Conout(cAuxLog)
						Else
							cAuxLog	:=StrZero(nxIDThread,10)+": Ok."
							cAuxLogD:="Titulo "+cDocSF2+", prefixo " + cxSerie + " e parcela "+StrZero(nParc,nTamParc) + " incluido com sucesso."
							aadd(aRet3009,{SE1->E1_PREFIXO+SE1->E1_NUM+SE1->E1_PARCELA+cTipoSE1,"SE1","L",1,cAuxLog,.T.,Z01->Z01_SEQVDA+Z01->Z01_CAIXA,Z01->Z01_DATA, 0, "FINANCEIRO", "", cAuxLogD})
							Conout(cAuxLog)
						EndIf
					Else			
						cAuxLog	:=StrZero(nxIDThread,10)+": Ok."
						cAuxLogD:="Titulo "+cDocSF2+", prefixo " + cxSerie + " e parcela "+StrZero(nParc,nTamParc) + " incluido com sucesso."
						aadd(aRet3009,{SE1->E1_PREFIXO+SE1->E1_NUM+SE1->E1_PARCELA+cTipoSE1,"SE1","L",1,cAuxLog,.T.,Z01->Z01_SEQVDA+Z01->Z01_CAIXA,Z01->Z01_DATA, 0, "FINANCEIRO", "", cAuxLogD})
						Conout(cAuxLog)
					EndIf
				EndIf			
			
			// -> Vendas para "eventos", "consumidor" e "vale presente" 	
	    	ElseIf UPPER(SE4->E4_XFORMA) $ "EV/VC/VP"
	    		cTipoSE1:="DP"
	    		cTipoSE1:=cTipoSE1+Space(nTamTipo-Len(cTipoSE1))	    	

				cAuxLog	:=StrZero(nxIDThread,10)+": Incluindo titulo "+cxSerie+":"+cDocSF2+":"+StrZero(nParc,nTamParc)+":"+cTipoSE1"
				cAuxLogD:="Incluindo titulo "+cDocSF2+", prefixo " + cxSerie + " e parcela "+StrZero(nParc,nTamParc)
				aadd(aRet3009,{cxSerie+cDocSF2+StrZero(nParc,nTamParc)+cTipoSE1,"SE1","L",1,cAuxLog,.T.,Z01->Z01_SEQVDA+Z01->Z01_CAIXA,Z01->Z01_DATA, 0, "FINANCEIRO", "", cAuxLogD})
				Conout(cAuxLog)

		    	aDadosSE1 :={ 	{ "E1_PREFIXO"  , cxSerie															, NIL },;
		    					{ "E1_NUM"      , cDocSF2												           	, NIL },;
		    					{ "E1_PARCELA"  , StrZero(nParc,nTamParc)              								, NIL },;
		    					{ "E1_TIPO"     , cTipoSE1              											, NIL },;
		    					{ "E1_NATUREZ"  , cNatSE1			   												, NIL },;
		    					{ "E1_CLIENTE"  , cCodCli	         											   	, NIL },;
		    					{ "E1_LOJA"     , cCodLCli          												, NIL },;
		    					{ "E1_XCLIENT"  , cCodCli       	   											   	, NIL },;
		    					{ "E1_XLOJA"    , cCodLCli		          											, NIL },;
		    					{ "E1_XNOME"    , cNomCli  		        											, NIL },;
		    					{ "E1_EMISSAO"  , dEmisSE1															, NIL },;
		    					{ "E1_VENCTO"   , aVenc[nl,2]														, NIL },;
		    					{ "E1_VENCREA"  , aVenc[nl,2]														, NIL },;
								{ "E1_XDTCAIX"  , Z03->Z03_DTABER													, NIL },;
		    					{ "E1_VALOR"    , aVenc[nl,1]  		  												, NIL },;
		    					{ "E1_HIST"     , "Venda a prazo :" + SE4->E4_XFORMA 								, NIL },;
		    					{ "E1_NUMNOTA"  , cDocSF2															, NIL },;
		    					{ "E1_SERIE"    , cxSerie															, NIL },;
		    					{ "E1_ORIGEM"   , "MATA920"															, NIL },;
		    					{ "E1_XSEQVDA"  , Z03->Z03_SEQVDA													, NIL },;
		    					{ "E1_XCAIXA"   , Z03->Z03_CAIXA   													, NIL },;
		    					{ "E1_XCODEXT"  , Z03->Z03_COND   											        , NIL },;
		    					{ "E1_XADMIN"   , ""																, NIL },;
								{ "E1_XDESCAD"  , ""																, NIL },;
		    					{ "E1_DOCTEF"   , ""																, NIL },;
		    					{ "E1_XNUMCAR"  , ""																, NIL },;
		    					{ "E1_XHORAV"   , Z03->Z03_HRVDA													, NIL },;
		    					{ "E1_XNUMVP"   , IIF(SE4->E4_XFORMA $ "VP",Z03->Z03_NUMVP,"")						, NIL },;
		    					{ "E1_XCONC"    , "N"																, NIL } ;
		    				}
		    				
		    	// -> Inclui recebiemnto com cartao
		    	lMsErroAuto:=.F.
		    	MsExecAuto({|x,y| FINA040(x,y)},aDadosSE1,3)
		    	If lMsErroAuto
		    		lErro	 :=.T.
					cFileName:= "se1_"+cFilAnt+"_"+cxSerie+"_"+AllTrim(cDocSF2)+"_"+strtran(time(),":","")
					MostraErro(cPathTmp, cFileName)
					cFileErr :=memoread(cPathTmp+cFileName)					
					cAuxLog  :=StrZero(nxIDThread,10)+":Erro na inclusao do titulo. Verifique o detalhamento da ocorrencia."	
					cAuxLogD :=cFileErr				
					aadd(aRet3009,{cxSerie+cDocSF2+StrZero(nParc,nTamParc)+cTipoSE1,"SE1","E",1,cAuxLog,.T.,Z01->Z01_SEQVDA+Z01->Z01_CAIXA,Z01->Z01_DATA, 0, "FINANCEIRO", "", cAuxLogD})
					Conout(cAuxLog)
				Else
					// -> Verifica se o título é do tipo VP (vale presente). Caso seja, procura pelo RA e faz a compensação
					If UPPER(SE4->E4_XFORMA) $ "VP" .and. !Empty(Z03->Z03_NUMVP)
						// -> Baixa o titulo no banco do vale presente.
						aBaixa :={	{"E1_PREFIXO"  ,cxSerie			                  							,Nil    },;
									{"E1_NUM"      ,cDocSF2														,Nil    },;
									{"E1_PARCELA"  ,StrZero(nParc,nTamParc)										,NIL    },;
									{"E1_TIPO"     ,cTipoSE1               										,Nil    },;
									{"AUTMOTBX"    ,"NOR"                  										,Nil    },;
									{"AUTBANCO"    ,cBcLojaP                  									,Nil    },;
									{"AUTAGENCIA"  ,cAgLojaP   		            								,Nil    },;
									{"AUTCONTA"    ,cCCLojaP      												,Nil    },;
									{"AUTDTBAIXA"  ,dEmisSE1              										,Nil    },;
									{"AUTDTCREDITO",dEmisSE1              										,Nil    },;
									{"AUTHIST"     ,"Recebto vale presente:"+Z03->Z03_NUMVP          			,Nil    },;
									{"AUTJUROS"    ,0                      										,Nil,.T.},;
									{"AUTVALREC"   ,aVenc[nl,1]                    								,Nil    }}
						// -> Executa a baixa do titulo
						lMsErroAuto:=.F.
						MSExecAuto({|x,y| Fina070(x,y)},aBaixa,3)
						If lMsErroAuto
							lErro    :=.T.
							cFileName:="se1_"+cFilAnt+"_"+cxSerie+"_"+AllTrim(cDocSF2)+"_"+strtran(time(),":","")
							MostraErro(cPathTmp, cFileName)
							cFileErr :=memoread(cPathTmp+cFileName)
							cAuxLog  :=StrZero(nxIDThread,10)+":Erro na baixa do titulo relacionado ao 'cartao presente'. Verifique o detalhamento da ocorrencia."					
							cAuxLogD :=cFileErr											
							aadd(aRet3009,{cxSerie+cDocSF2+StrZero(nParc,nTamParc)+cTipoSE1,"SE5","E",7,cAuxLog,.T.,Z01->Z01_SEQVDA+Z01->Z01_CAIXA,Z01->Z01_DATA, 0, "FINANCEIRO", "", cAuxLogD})
							Conout(cAuxLog)
						Else
							cAuxLog	:=StrZero(nxIDThread,10)+": Ok."
							cAuxLogD:="Incluido titulo "+cDocSF2+", prefixo " + cxSerie + " e parcela "+StrZero(nParc,nTamParc) + " com sucesso."
							aadd(aRet3009,{cxSerie+cDocSF2+StrZero(nParc,nTamParc)+cTipoSE1,"SE5","L",7,cAuxLog,.T.,Z01->Z01_SEQVDA+Z01->Z01_CAIXA,Z01->Z01_DATA, 0, "FINANCEIRO", "", cAuxLogD})
							Conout(cAuxLog)
						EndIf	 
					Else
						cAuxLog	:=StrZero(nxIDThread,10)+": Ok."
						cAuxLogD:="Incluido titulo "+cDocSF2+", prefixo " + cxSerie + " e parcela "+StrZero(nParc,nTamParc) + " com sucesso."
						aadd(aRet3009,{cxSerie+cDocSF2+StrZero(nParc,nTamParc)+cTipoSE1,"SE5","L",7,cAuxLog,.T.,Z01->Z01_SEQVDA+Z01->Z01_CAIXA,Z01->Z01_DATA, 0, "FINANCEIRO", "", cAuxLogD})
						Conout(cAuxLog)
					EndIf									
				EndIf			
			
			// -> Vendas para "eventos", "consumidor" e "vale presente" 	
	    	Else
	    		cTipoSE1:="DP"
	    		cTipoSE1:=cTipoSE1+Space(nTamTipo-Len(cTipoSE1))	    	
				
				cAuxLog	:=StrZero(nxIDThread,10)+": Incluindo titulo "+cxSerie+":"+cDocSF2+":"+StrZero(nParc,nTamParc)+":"+cTipoSE1"
				cAuxLogD:="Incluindo titulo "+cDocSF2+", prefixo " + cxSerie + " e parcela "+StrZero(nParc,nTamParc)
				aadd(aRet3009,{cxSerie+cDocSF2+StrZero(nParc,nTamParc)+cTipoSE1,"SE1","L",1,cAuxLog,.T.,Z01->Z01_SEQVDA+Z01->Z01_CAIXA,Z01->Z01_DATA, 0, "FINANCEIRO", "", cAuxLogD})
				Conout(cAuxLog)

		    	aDadosSE1 :={ 	{ "E1_PREFIXO"  , cxSerie															, NIL },;
		    					{ "E1_NUM"      , cDocSF2												           	, NIL },;
		    					{ "E1_PARCELA"  , StrZero(nParc,nTamParc)              								, NIL },;
		    					{ "E1_TIPO"     , cTipoSE1              											, NIL },;
		    					{ "E1_NATUREZ"  , cNatSE1			   												, NIL },;
		    					{ "E1_CLIENTE"  , cCodCli	         											   	, NIL },;
		    					{ "E1_LOJA"     , cCodLCli          												, NIL },;
		    					{ "E1_XCLIENT"  , cCodCli       	   											   	, NIL },;
		    					{ "E1_XLOJA"    , cCodLCli		          											, NIL },;
		    					{ "E1_XNOME"    , cNomCli  		        											, NIL },;
		    					{ "E1_EMISSAO"  , dEmisSE1															, NIL },;
		    					{ "E1_VENCTO"   , aVenc[nl,2]														, NIL },;
		    					{ "E1_VENCREA"  , aVenc[nl,2]														, NIL },;
								{ "E1_XDTCAIX"  , Z03->Z03_DTABER													, NIL },;
		    					{ "E1_VALOR"    , aVenc[nl,1]  		  												, NIL },;
		    					{ "E1_HIST"     , "Venda a prazo :" + SE4->E4_XFORMA 								, NIL },;
		    					{ "E1_NUMNOTA"  , cDocSF2															, NIL },;
		    					{ "E1_SERIE"    , cxSerie															, NIL },;
		    					{ "E1_ORIGEM"   , "MATA920"															, NIL },;
		    					{ "E1_XSEQVDA"  , Z03->Z03_SEQVDA													, NIL },;
		    					{ "E1_XCAIXA"   , Z03->Z03_CAIXA   													, NIL },;
		    					{ "E1_XCODEXT"  , Z03->Z03_COND   											        , NIL },;
		    					{ "E1_XADMIN"   , ""																, NIL },;
								{ "E1_XDESCAD"  , ""	 															, NIL },;
		    					{ "E1_DOCTEF"   , ""																, NIL },;
		    					{ "E1_XNUMCAR"  , ""																, NIL },;
		    					{ "E1_XHORAV"   , Z03->Z03_HRVDA													, NIL },;
		    					{ "E1_XNUMVP"   , ""																, NIL },;
		    					{ "E1_XCONC"    , "N"																, NIL } ;
		    				}
		    				
		    	// -> Inclui recebimento
		    	lMsErroAuto:=.F.
		    	MsExecAuto({|x,y| FINA040(x,y)},aDadosSE1,3)
		    	If lMsErroAuto
		    		lErro	 :=.T.					
					cFileName:= "se1_"+cFilAnt+"_"+cxSerie+"_"+AllTrim(cDocSF2)+"_"+strtran(time(),":","")
					MostraErro(cPathTmp, cFileName)
					cFileErr :=memoread(cPathTmp+cFileName)
					cAuxLog  :=StrZero(nxIDThread,10)+":Erro na inclusao do titulo. Verifique detalhamento da ocorrencia."					
					cAuxLogD :=cFileErr
					aadd(aRet3009,{cxSerie+cDocSF2+StrZero(nParc,nTamParc)+cTipoSE1,"SE1","E",1,cAuxLog,.T.,Z01->Z01_SEQVDA+Z01->Z01_CAIXA,Z01->Z01_DATA, 0, "FINANCEIRO", "", cAuxLogD})
					Conout(cAuxLog)
				Else
					cAuxLog	:=StrZero(nxIDThread,10)+": Ok."
					cAuxLogD:="Incluido titulo "+cDocSF2+", prefixo " + cxSerie + " e parcela "+StrZero(nParc,nTamParc) + " com sucesso."
					aadd(aRet3009,{cxSerie+cDocSF2+StrZero(nParc,nTamParc)+cTipoSE1,"SE1","L",1,cAuxLog,.T.,Z01->Z01_SEQVDA+Z01->Z01_CAIXA,Z01->Z01_DATA, 0, "FINANCEIRO", "", cAuxLogD})
					Conout(cAuxLog)
				EndIf			
			EndIf	    
	    
	    Next nl

	    Z03->(DbSkip())
	
	EndDo    

	SetFunName(cFunNamAnt)

	lErro:=IIF(lErro,.F.,.T.)

Return(lErro)





/*
+------------------+---------------------------------------------------------+
!Nome              ! FAT3010                                                 !
+------------------+---------------------------------------------------------+
!Descricao         ! Rotina de cancelamento das notas fiscais                !
+------------------+---------------------------------------------------------+
!Autor             ! Paulo Gabriel                                           !
+------------------+---------------------------------------------------------+
!Data de Criacao   ! 23/11/2018                                              !
+------------------+---------------------------------------------------------+
*/
User Function FAT3010(aRetSF2,oEventLog,nxIDThread)
Local aCabec 	:= {}
Local aItens 	:= {}
Local aLinha 	:= {}
Local lErro    	:= .F.
Local cPathTmp  := "\temp\"
Local cAuxLog	:= ""
Local cFileErr	:= ""
Local cFileName := ""
Local cDoc   	:= ""
Local nTamDoc   := TamSx3("F2_DOC")[1]
Local cF2FILIAL := ""
Local cF2SERIE  := ""
Local cF2DOC    := ""
Local cF2CLIENTE:= ""
Local cF2LOJA   := ""
Private lMsErroAuto := .F.

	DbSelectArea("SF2")  
	SF2->(DbOrderNickName("SEQVDA"))	
	SF2->(DbSeek(xFilial("SF2")+Z01->Z01_SEQVDA+Z01->Z01_CAIXA+DtoS(Z01->Z01_DATA)))
	If SF2->(Found())

		cF2FILIAL := SF2->F2_FILIAL
		cF2SERIE  := SF2->F2_SERIE
		cF2DOC    := SF2->F2_DOC
		cF2CLIENTE:= SF2->F2_CLIENTE
		cF2LOJA   := SF2->F2_LOJA
		cF2EMISSAO:= DtoS(SF2->F2_EMISSAO)

		aadd(aCabec,{"F2_TIPO"   	,"N"				})
		aadd(aCabec,{"F2_DOC"    	,SF2->F2_DOC		})
		aadd(aCabec,{"F2_SERIE"  	,SF2->F2_SERIE		})
		aadd(aCabec,{"F2_EMISSAO"	,SF2->F2_EMISSAO	})
		aadd(aCabec,{"F2_CLIENTE"	,SF2->F2_CLIENTE	})
		aadd(aCabec,{"F2_LOJA"   	,SF2->F2_LOJA		})
		aadd(aCabec,{"F2_CHVNFE"	,SF2->F2_CHVNFE	    })
		aadd(aCabec,{"F2_HORA"		,SF2->F2_CHVNFE		})

		aLinha := {}
		SD2->(dbSetOrder(3))
		SD2->(dbGoTop())
		SD2->(dbSeek(xFilial("SD2") + SF2->F2_DOC + SF2->F2_SERIE + SF2->F2_CLIENTE + SF2->F2_LOJA))

		While !SD2->( Eof() ) .And. (SD2->(D2_FILIAL+D2_DOC+D2_SERIE+D2_CLIENTE) == (xFilial("SD2") + SF2->F2_DOC + SF2->F2_SERIE+ SF2->F2_CLIENTE))
			RecLock("SD2",.F.)
			SD2->D2_ORIGLAN:="LF"
			SD2->D2_ESTOQUE:=" "
			SD2->(MsUnlock())

			aadd(aLinha,{"D2_COD"  	,SD2->D2_COD	,Nil})
			aadd(aLinha,{"D2_ITEM" 	,SD2->D2_ITEM	,Nil})
			aadd(aLinha,{"D2_QUANT"	,SD2->D2_QUANT	,Nil})
			aadd(aLinha,{"D2_PRCVEN",SD2->D2_PRCVEN	,Nil})
			aadd(aLinha,{"D2_TOTAL"	,SD2->D2_TOTAL	,Nil})
			aadd(aItens,aLinha)

			SD2->(DbSkip())
		EndDo
		
		MATA920(aCabec,aItens,5)		
	 	If !lMsErroAuto
			cAuxLog	:=StrZero(nxIDThread,10)+": Ok."
			aadd(aRetSF2,{Z01->Z01_SEQVDA+Z01->Z01_CAIXA+DtoS(Z01->Z01_DATA),"Z01","L",3,cAuxLog,.T.,Z01->Z01_SEQVDA+Z01->Z01_CAIXA,Z01->Z01_DATA, 0, "CANC DOCUMENTO FISCAL", "", ""})
			Conout(cAuxLog)
		 Else
			lErro	 := .T.
			cFileName:= "SF2_"+cFilAnt+"_"+AllTrim(cF2DOC)+cF2SERIE+cF2CLIENTE+cF2LOJA+"_"+strtran(time(),":","")
			MostraErro(cPathTmp, cFileName)
			cFileErr :=memoread(cPathTmp+cFileName)
			cAuxLog  :=": Erro no cancelamento documento fiscal. Verifique o detalhe da ocorrencia."
			aadd(aRetSF2,{Z01->Z01_SEQVDA+Z01->Z01_CAIXA+DtoS(Z01->Z01_DATA),"Z01","E",3,cAuxLog,.T.,Z01->Z01_SEQVDA+Z01->Z01_CAIXA,Z01->Z01_DATA, 0, "CANC DOCUMENTO FISCAL", "", ""})
			Conout(cAuxLog)
	 	EndIf
	
		// -> Atualiza os complementos fiscais do cancelamento - SFT
		// If !lErro
		// 	cAuxLog	:=StrZero(nxIDThread,10)+": Atualizando complementos fiscais - SFT."
		// 	aadd(aRetSF2,{Z01->Z01_SEQVDA+Z01->Z01_CAIXA+DtoS(Z01->Z01_DATA),"Z01","L",3,cAuxLog,.T.,Z01->Z01_SEQVDA+Z01->Z01_CAIXA,Z01->Z01_DATA, 0, "CANC DOCUMENTO FISCAL", "", ""})
		// 	Conout(cAuxLog)
		// 	SFT->(DbSetOrder(1))
		// 	SFT->(DbSeek(cF2FILIAL+"S"+cF2SERIE+cF2DOC+cF2CLIENTE+cF2LOJA))	
		// 	If SFT->(Found())
		// 		While !SFT->(Eof()) .and. SFT->FT_FILIAL == cF2FILIAL .and. SFT->FT_TIPOMOV == "S" .and. SFT->FT_SERIE == cF2SERIE .and. SFT->FT_NFISCAL == cF2DOC .and. SFT->FT_CLIEFOR == cF2CLIENTE .and. SFT->FT_LOJA == cF2LOJA 
		// 			If RecLock("SFT",.F.)
		// 				SFT->(MsUnlock())						
		// 			Else
		// 				lErro:=IIF(!lErro,.T.,lErro)
		// 			EndIf
		// 			SFT->(DbSkip())
		// 		EndDo	
		// 	EndIf	
				
		// 	// -> Atualiza log de complementos fiscais - SFT
		// 	If lErro
		// 		cAuxLog	:=StrZero(nxIDThread,10)+": Erro na atualizacao do complemento fisal - SFT."
		// 		aadd(aRetSF2,{Z01->Z01_SEQVDA+Z01->Z01_CAIXA+DtoS(Z01->Z01_DATA),"Z01","E",3,cAuxLog,.T.,Z01->Z01_SEQVDA+Z01->Z01_CAIXA,Z01->Z01_DATA, 0, "CANC DOCUMENTO FISCAL", "", ""})
		// 		Conout(cAuxLog)
		// 	Else	 
		// 		cAuxLog	:=StrZero(nxIDThread,10)+": Ok."
		// 		aadd(aRetSF2,{Z01->Z01_SEQVDA+Z01->Z01_CAIXA+DtoS(Z01->Z01_DATA),"Z01","L",3,cAuxLog,.T.,Z01->Z01_SEQVDA+Z01->Z01_CAIXA,Z01->Z01_DATA, 0, "CANC DOCUMENTO FISCAL", "", ""})
		// 		Conout(cAuxLog)
		// 	EndIf	
				
		//EndIf

		// -> Atualiza a SF3
		If !lErro
			cAuxLog	:=StrZero(nxIDThread,10)+": Atualizando complementos fiscais - SF3."
			aadd(aRetSF2,{Z01->Z01_SEQVDA+Z01->Z01_CAIXA+DtoS(Z01->Z01_DATA),"Z01","L",3,cAuxLog,.T.,Z01->Z01_SEQVDA+Z01->Z01_CAIXA,Z01->Z01_DATA, 0, "CANC DOCUMENTO FISCAL", "", ""})
			Conout(cAuxLog)

			SF3->(DbSetOrder(1))
			SF3->(DbSeek(cF2FILIAL+cF2EMISSAO+cF2DOC+cF2SERIE+cF2CLIENTE+cF2LOJA))	
			If SF3->(Found())
				While !SF3->(Eof()) .and. SF3->F3_FILIAL == cF2FILIAL .and. DtoS(SF3->F3_ENTRADA) == cF2EMISSAO .and. SF3->F3_NFISCAL == cF2DOC .and. SF3->F3_SERIE == cF2SERIE .and. SF3->F3_CLIEFOR == cF2CLIENTE .and. SF3->F3_LOJA == cF2LOJA
					If RecLock("SF3",.F.)
						SF3->F3_CODRSEF:=cCRetSEFAZ
						SF3->(MsUnlock())						
					Else
						lErro:=IIF(!lErro,.T.,lErro)
					EndIf
					SF3->(DbSkip())
				EndDo	
			EndIf	

			// -> Atualiza log de complementos fiscais - SF3
			If lErro
				cAuxLog	:=StrZero(nxIDThread,10)+": Erro na atualizacao do complemento fisal - SF3."
				aadd(aRetSF2,{Z01->Z01_SEQVDA+Z01->Z01_CAIXA+DtoS(Z01->Z01_DATA),"Z01","E",3,cAuxLog,.T.,Z01->Z01_SEQVDA+Z01->Z01_CAIXA,Z01->Z01_DATA, 0, "CANC DOCUMENTO FISCAL", "", ""})
				Conout(cAuxLog)
			Else 
				cAuxLog	:=StrZero(nxIDThread,10)+": Ok."
				aadd(aRetSF2,{Z01->Z01_SEQVDA+Z01->Z01_CAIXA+DtoS(Z01->Z01_DATA),"Z01","L",3,cAuxLog,.T.,Z01->Z01_SEQVDA+Z01->Z01_CAIXA,Z01->Z01_DATA, 0, "CANC DOCUMENTO FISCAL", "", ""})
				Conout(cAuxLog)
			EndIf
		
		EndIf			
	
	EndIf

Return(lErro)




/*
+------------------+---------------------------------------------------------+
!Nome              ! F300QZ04                                                !
+------------------+---------------------------------------------------------+
!Descricao         ! Consulta dados de produção da venda importaos do Teknisa!
+------------------+---------------------------------------------------------+
!Autor             ! Marcio Zaguetti                                         !
+------------------+---------------------------------------------------------+
!Data de Criacao   ! 28/07/2018                                              !
+------------------+---------------------------------------------------------+
*/
User Function F300QZ04() 
Local cAliasZ04 := GetNextAlias()
Local cQuery    := ""

	cQuery := "SELECT SB1.B1_COD,                "
	cQuery += "       SB1.B1_DESC,               "
	cQuery += "       Z04.Z04_SEQIT,             "
	cQuery += "       SUM(Z04.Z04_QTDE) Z04_QTDE "
	cQuery += "FROM " + RetSqlName("Z04") + " Z04 INNER JOIN " + RetSqlName("Z13") + " Z13 "
	cQuery += "    ON Z13.Z13_FILIAL   = '" + xFilial("Z13") + "' AND "
	cQuery += "       Z13.Z13_XCODEX   = Z04.Z04_PRDUTO           AND "
	cQuery += "       Z13.D_E_L_E_T_  <> '*'                          "
	cQuery += "JOIN " + RetSqlName("SB1") + " SB1 " 
	cQuery += "    ON SB1.B1_FILIAL    = '" + xFilial("SB1") + "' AND "
	cQuery += "       SB1.B1_COD       = Z13.Z13_COD              AND "
	cQuery += "       SB1.D_E_L_E_T_  <> '*'                          "
	cQuery += "WHERE Z04.Z04_FILIAL   = '" + Z01->Z01_FILIAL        + "' AND " 
	cQuery += "      Z04.Z04_SEQVDA   = '" + Z01->Z01_SEQVDA        + "' AND "
	cQuery += "      Z04.Z04_CAIXA    = '" + Z01->Z01_CAIXA         + "' AND "
	cQuery += "      Z04.Z04_DATA     = '" + DtoS(Z01->Z01_DATA)    + "' AND "
	cQuery += "      Z04.Z04_CONTR    = ' '                              AND "
	cQuery += "      Z04.Z04_PRDUTO  <> ' '                              AND "
	cQuery += "      Z04.Z04_QTDE > 0		                             AND "            
	cQuery += "      Z04.D_E_L_E_T_  <> '*'                                  "            
	cQuery += "GROUP BY SB1.B1_COD, SB1.B1_DESC, Z04.Z04_SEQIT               "
	dbUseArea(.T.,"TOPCONN",TcGenQry(,,cQuery),cAliasZ04,.T.,.T.)

Return(cAliasZ04)




/*
+------------------+---------------------------------------------------------+
!Nome              ! F300Z04O                                                !
+------------------+---------------------------------------------------------+
!Descricao         ! Consulta dados de observações (retira/adiciona) nos     !
!                  ! itens utilizados na composição dos produtos             !
+------------------+---------------------------------------------------------+
!Autor             ! Marcio Zaguetti                                         !
+------------------+---------------------------------------------------------+
!Data de Criacao   ! 28/11/2018                                              !
+------------------+---------------------------------------------------------+
*/
User Function F300Z04O(cItemZ04) 
Local cAliasZ04O:= GetNextAlias()
Local cQuery    := ""

	cQuery := "SELECT Z04.Z04_PRDUTO, "               
	cQuery += "       Z04.Z04_CODMP,  "             
	cQuery += "       Z04.Z04_SEQIT,  "           
	cQuery += "       Z04.Z04_CONTR,  "
	cQuery += "       Z04.Z04_IDCOBS, "
	cQuery += "       SUM(Z04.Z04_QTDE) Z04_QTDE "
	cQuery += "FROM " + RetSqlName("Z04") + " Z04 " 
	cQuery += "WHERE Z04.Z04_FILIAL   = '" + Z01->Z01_FILIAL     + "' AND "
	cQuery += "      Z04.Z04_SEQVDA   = '" + Z01->Z01_SEQVDA     + "' AND "
	cQuery += "	     Z04.Z04_CAIXA    = '" + Z01->Z01_CAIXA      + "' AND "
	cQuery += "	     Z04.Z04_DATA     = '" + DtoS(Z01->Z01_DATA) + "' AND "
	cQuery += "	     Z04.Z04_DATA     = '" + DtoS(Z01->Z01_DATA) + "' AND "
	cQuery += "	     Z04.Z04_SEQIT    = '" + cItemZ04            + "' AND "
	cQuery += "	     Z04.Z04_IDCOBS  IN('R','A')                      AND "
	cQuery += "	     Z04.D_E_L_E_T_  <> '*'                               "              
	cQuery += "GROUP BY Z04_PRDUTO, Z04_CODMP, Z04_SEQIT, Z04_CONTR, Z04_IDCOBS "
	
	dbUseArea(.T.,"TOPCONN",TcGenQry(,,cQuery),cAliasZ04O,.T.,.T.)

Return(cAliasZ04O)




/*
+------------------+---------------------------------------------------------+
!Nome              ! F300AtuSld                                              !
+------------------+---------------------------------------------------------+
!Descricao         ! Função criada para processar a atualização de custo no  !
!                  ! movimento da SD2 gerado pela integração com Tecknisa    !
!                  ! (originalmente sem atualização de estoque)  e consequen-!
!                  ! te atualização de saldos.te atualização de saldos.      !
+------------------+---------------------------------------------------------+
!Autor             ! André Oliveira                                          !
+------------------+---------------------------------------------------------+
!Data de Criacao   ! 28/07/2018                                              !
+------------------+---------------------------------------------------------+
*/

Static Function F300AtuSld(cEstNegat,nTamDecSD2,aRetSB2,nxIDThread)
Local aCM 		:= {}
Local aCusto	:= {}
Local lRet      := .T.
Local nSaldoSB2 := 0
Local cAuxLog   := ""

	// -> Verifica se a TES movimenta estoque
	SF4->(DbSetOrder(1))
	SF4->(DbSeek(xFilial("SF4")+SD2->D2_TES))
	If SF4->F4_ESTOQUE = "S"

		// -> Verifica se existe saldo, controle de lote e localização para o produto e, caso não existir saldo ou existir controle de endereço ou localização, retorna erro
		// -> Posiciona no cadastro de produto
		SB1->(DbSetOrder(1))
		SB1->(DbSeek(xFilial("SB1")+SD2->D2_COD))
		If SB1->B1_RASTRO <> "S" .and. SB1->B1_LOCALIZ <> "S"

			SB2->(DbSetOrder(1))
			SB2->(DbSeek(xFilial("SB2")+SD2->D2_COD+SD2->D2_LOCAL))
			nSaldoSB2:=SaldoSb2()

			// -> Verifica se o saldo é maior ou igual a quantidade do documento, caso contrário, retorna erro.
			If (NoRound(nSaldoSB2,nTamDecSD2) >= NoRound(SD2->D2_QUANT,nTamDecSD2)) .or. (Upper(cEstNegat) == "S")
				// -> Obtém custo médio do produto
				aCM	:= PegaCMAtu(SD2->D2_COD,SD2->D2_LOCAL,SD2->D2_TIPO)
				// -> Atualiza valores de custo no movimento da SD2
				aCusto := GravaCusD2(aCM,SD2->D2_TIPO)
				// -> Atualiza saldos nas tabelas SB2, SB8 e SBF
				B2AtuComD2(aCusto)
			Else
				lRet   :=.F.
				cAuxLog:=StrZero(nxIDThread,10)+":Falta saldo de estoque para o produto "+AllTrim(SD2->D2_COD)+". Favor verificar o log."
				aadd(aRetSB2,{SD2->D2_COD+SD2->D2_LOCAL,"SB2","E",1,cAuxLog,.T.,"ALL",Z01->Z01_DATA,SD2->D2_QUANT, "SALDO DE ESTOQUE", SD2->D2_COD, ""})
				ConOut(cAuxLog)
			EndIf
		Else
			lRet   :=.F.
			// -> Se o lote está ativado
			If SB1->B1_RASTRO <> "N"
				cAuxLog:=StrZero(nxIDThread,10)+":Produto "+SD2->D2_COD+" com lote habilitado no cadastro de produtos. Favor retirar o controle."
				aadd(aRetSB2,{SD2->D2_COD+SD2->D2_LOCAL,"SB2","E",1,cAuxLog,.T.,"ALL",Z01->Z01_DATA, SD2->D2_QUANT, "SALDO DE ESTOQUE", SD2->D2_COD, ""})
				ConOut(cAuxLog)
			EndIf
			// -> Se o controle de colalização está ativado
			If SB1->B1_LOCPAD <> "N"
				cAuxLog:=StrZero(nxIDThread,10)+":Produto "+SD2->D2_COD+" com controle de localizcao habilitado no cadastro de produtos. Favor retirar o controle."
				aadd(aRetSB2,{SD2->D2_COD+SD2->D2_LOCAL,"SB2","E",1,cAuxLog,.T.,"ALL",Z01->Z01_DATA, SD2->D2_QUANT, "SALDO DE ESTOQUE", SD2->D2_COD, ""})
				ConOut(cAuxLog)
			EndIf
		EndIf
	
	EndIf	

Return(lRet)




/*
+------------------+---------------------------------------------------------+
!Nome              ! GetSB2Log                                               !
+------------------+---------------------------------------------------------+
!Descricao         ! Pega saldo de estoque no momento do apontamento da OP.  !
+------------------+---------------------------------------------------------+
!Autor             ! Marcio Zaguetti                                         !
+------------------+---------------------------------------------------------+
!Data de Criacao   ! 28/07/2018                                              !
+------------------+---------------------------------------------------------+
!Observações       ! Registrado em documento que o processo executado por    !
!                  ! atende a versao atual da rotina MATA240 que registra a  !
!                  ! falta de estoque 'em texo'. Caso a rotina mude, deverá  !
!                  ! ser atualizado esta função                              !
+------------------+---------------------------------------------------------+

 Layout atual do retorno da função MATA240 por falta de estoque:

AJUDA:MA240NEGAT
Não existe quantidade suficiente em estoque para atender esta requisição.

Itens Sem Sld / Bloqs. / Empenhos Pendentes
Produto              Armazem                       Saldo Ocorrencia
20103570012500       01                          -0,0500 Sem Saldo em Estoque
*/

Static Function GetSB2Log(cxFile)
Local aRet    :={}
Local cLinha  := ""
Local lErro   :=.F.
Local nPosIQtd:=30
Local nPosFQtd:=28
Local nPosIPro:=1
Local nPosIArm:=22
Local nTamProd:=TamSx3("B1_COD")[1]
Local nTamArm :=TamSx3("B1_LOCPAD")[1]
	// -> Abre o arquivo em que o log foi registrado
	FT_FUSE(cxFile)
  
  	// -> Verifica se o arquivo possui dados
	lErro:=FT_FEOF()
    
	// -> Se não deu erro, continua
	If !lErro
		// Le a primeira linha
		cLinha:=alltrim(FT_FREADLN())    
		// -> Verifica se é falta de estoque 
		lErro:=!("AJUDA:MA240NEGAT" $ cLinha)
	EndIf

	// -> Se não deu erro, le o arquivo e reorna os dados
	If !lErro
		FT_FSKIP()
  		While !FT_FEOF()
			cLinha := FT_FREADLN()
			// -> Verifica se a mensagem do texto se refere a 'falta de estoque' (posição 58 a 77). Se ok, armazenda as informações do log em array
			If "Sem Saldo em Estoque" $ cLinha
				aadd(aRet,{SubStr(cLinha,nPosIPro,nTamProd),SubStr(cLinha,nPosIArm,nTamArm),AllTrim(SubStr(cLinha,nPosIQtd,nPosFQtd))})
			EndIf
			FT_FSKIP()
		EndDO
	EndIf
	FT_FUSE()
Return(aRet)