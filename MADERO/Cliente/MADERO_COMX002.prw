#INCLUDE "Protheus.CH"
#INCLUDE "rwmake.ch"
#INCLUDE "Topconn.ch"
/*
+----------------------------------------------------------------------------+
!                             FICHA TECNICA DO PROGRAMA                      !
+----------------------------------------------------------------------------+
!   DADOS DO PROGRAMA                                                        !
+------------------+---------------------------------------------------------+
!Tipo              ! Rotina                                                  !
+------------------+---------------------------------------------------------+
!Modulo            ! Compras                                                 !
+------------------+---------------------------------------------------------+
!Nome              ! COMX002                                                 !
+------------------+---------------------------------------------------------+
!Descricao         ! Seleciona as faixas de codigos dos fornecedores    	 !
+------------------+---------------------------------------------------------+
!Autor             ! Jair Matos de Andrade		                             !
+------------------+---------------------------------------------------------+
!Data de Criacao   ! 05/10/18                                                !
+------------------+---------------------------------------------------------+
!   Descricao detalhada da atualizacao      !Nome do    ! Analista  !Data da !
!                                           !Solicitante! Respons.  !Atualiz.!
+-------------------------------------------+-----------+-----------+--------+
! 											!           !           !		 !
! 			                                !   	    !           !        !
+-------------------------------------------+-----------+-----------+--------+
*/
User Function COMX002()
Local aArea 	:= GetArea()
Local aAreaSA2	:= SA2->(GetArea())
Local cCodigo :=""
Local nCodigo :=0
Local cFiltro:= Space(TamSx3("A2_COD")[1])
Local cFaixa := "" 
Local cEmp := 	Iif(cEmpAnt =="01","02","01")
//incluir parametros para todas as faixas e gravar o ultimo codigo quando for utilizar
//MV_XFX1FOR,MV_XFX2FOR,MV_XFX5FOR,MV_XFX6FOR,MV_XFX7FOR

nCodigo := M->A2_XFAIXA //seleciona a opção)

If nCodigo =="1"  //restaurantes  100000 - 199999
	cCodigo := GetMV("MV_XFX1FOR")
	PutMV("MV_XFX1FOR",Soma1(cCodigo)) 
	StartJob( "U_COMX002P" , GetEnvServer() , .T. , cEmp , "" , "MV_XFX1FOR" ,Soma1(cCodigo)  , .T. )//grava o mesmo codigo de fornecedor nas 02 empresas
ElseIf nCodigo =="2"//Fornecedores Diversos  200000-399999
	cCodigo := GetMV("MV_XFX2FOR")
	PutMV("MV_XFX2FOR",Soma1(cCodigo))
	StartJob( "U_COMX002P" , GetEnvServer() , .T. , cEmp , "" , "MV_XFX2FOR" ,Soma1(cCodigo)  , .T. )//grava o mesmo codigo de fornecedor nas 02 empresas
ElseIf nCodigo =="5"//Fornecedores Exterior  500000-599999
	cCodigo := GetMV("MV_XFX5FOR")
	PutMV("MV_XFX5FOR",Soma1(cCodigo)) 
		StartJob( "U_COMX002P" , GetEnvServer() , .T. , cEmp , "" , "MV_XFX5FOR" ,Soma1(cCodigo)  , .T. )//grava o mesmo codigo de fornecedor nas 02 empresas
ElseIf nCodigo =="6"//Secretarias Governamentais 600000-699999
	cCodigo := GetMV("MV_XFX6FOR")
	PutMV("MV_XFX6FOR",Soma1(cCodigo))  
		StartJob( "U_COMX002P" , GetEnvServer() , .T. , cEmp , "" , "MV_XFX6FOR" ,Soma1(cCodigo)  , .T. )//grava o mesmo codigo de fornecedor nas 02 empresas
ElseIf nCodigo =="7"//Bancos  700000-799999
	cCodigo := GetMV("MV_XFX7FOR")
	PutMV("MV_XFX7FOR",Soma1(cCodigo))
		StartJob( "U_COMX002P" , GetEnvServer() , .T. , cEmp , "" , "MV_XFX7FOR" ,Soma1(cCodigo)  , .T. )//grava o mesmo codigo de fornecedor nas 02 empresas
Else
	cCodigo := cFiltro
EndIf

RestArea(aAreaSA2)
RestArea(aArea)
Return (cCodigo)
//---------------------------------------------------------------------
/*/{Protheus.doc} PesqCod
Rotina para selecionar o ultimo codigo utilizado no cadastro

@author Jair Matos
@since 05/10/2018
@version P12
@return cCodigo
/*/
//---------------------------------------------------------------------
Static function PesqCod(cOpc)

Local cCodigo
Local cQuery := ""

If cOpc =='2'
	cQuery := "SELECT MAX(A2_COD) as COD FROM "+RetSQLName("SA2") + " WHERE D_E_L_E_T_ = ' ' AND A2_COD LIKE '2%' OR A2_COD LIKE '3%'  "
Else
	cQuery := "SELECT MAX(A2_COD) as COD FROM "+RetSQLName("SA2") + " WHERE D_E_L_E_T_ = ' ' AND A2_COD LIKE '"+cOpc+"%'  "
EndIf

If Select("cAlias") > 0
	dbSelectArea("cAlias")
	dbCloseArea()
EndIf

TCQUERY cQuery NEW ALIAS cAlias
If !Empty(Alltrim(cAlias->COD))
	cCodigo := Soma1(cAlias->COD)
Else
	cCodigo := PADR(cOpc,TamSx3("A2_COD")[1],"0")
EndIf

return cCodigo
//---------------------------------------------------------------------
/*/{Protheus.doc} PesqCGC
Rotina que valida se fornecedor

@author Jair Matos
@since 05/10/2018
@version P12
@return Nil
/*/
//---------------------------------------------------------------------
User function COMX002C(nOpc)
Local cCodigo :=""
Local cCodAnt := M->A2_COD
Local lRet := .T.
Local cCGC 	 := M->A2_CGC
Local cFaixa := M->A2_XFAIXA
Local cQuery := ""

If M->A2_TIPO == "J"
	cCGC := SUBSTR(M->A2_CGC,1,8)
	cQuery := "SELECT A2_COD as COD FROM "+RetSQLName("SA2") + " WHERE D_E_L_E_T_ = ' ' AND SUBSTR(A2_CGC,1,8) = '"+cCGC+"' "
Else
	cQuery := "SELECT A2_COD as COD FROM "+RetSQLName("SA2") + " WHERE D_E_L_E_T_ = ' ' AND A2_CGC = '"+M->A2_CGC+"' "
EndIf

If Select("cAlias") > 0
	dbSelectArea("cAlias")
	dbCloseArea()
EndIf

TCQUERY cQuery NEW ALIAS cAlias
If !Empty(Alltrim(cAlias->COD))
	cCodigo := cAlias->COD
	M->A2_LOJA := "00"
Else
	cCodigo := cCodAnt
EndIf

Return Iif(nOpc==1,cCodigo,lRet)
//---------------------------------------------------------------------
/*/{Protheus.doc} PesqLoja
Rotina que valida se fornecedor

@author Jair Matos
@since 01/11/2018
@version P12
@return Nil
/*/
//---------------------------------------------------------------------
User function COMX002L()
Local cLoja :=""
Local lRet := .T.
Local cCGC 	 := M->A2_CGC
Local cQuery := ""

If Empty(M->A2_CGC)
	cLoja  :="01"
Else
	//Verifica se O cnpj INTEIRO ja existe. Caso já exista, traz a loja correta.
	cQuery := "SELECT A2_LOJA as LOJA FROM "+RetSQLName("SA2") + " WHERE D_E_L_E_T_ = ' ' AND A2_CGC = '"+M->A2_CGC+"' "
	If Select("cAlias") > 0
		dbSelectArea("cAlias")
		dbCloseArea()
	EndIf
	
	TCQUERY cQuery NEW ALIAS cAlias
	If !Empty(Alltrim(cAlias->LOJA))
		cLoja :=cAlias->LOJA
		lRet := .F.
	EndIf
	
	If lRet //Se o CNPJ inteiro não existe, verificar a RAIZ do cnpj. Se achar o CNPJ , traz a ultima loja e acresce +1.
		
		If len(cCGC) == 14
			cCGC := SUBSTR(cCGC,1,8)
		EndIf
		
		cQuery := "SELECT MAX(A2_LOJA) as LOJA FROM "+RetSQLName("SA2") + " WHERE D_E_L_E_T_ = ' ' AND SUBSTR(A2_CGC,1,8) = '"+cCGC+"' "
		
		If Select("cAlias") > 0
			dbSelectArea("cAlias")
			dbCloseArea()
		EndIf
		
		TCQUERY cQuery NEW ALIAS cAlias
		If !Empty(Alltrim(cAlias->LOJA))
			cLoja := Soma1(cAlias->LOJA)
		Else
			cLoja := "01"
		EndIf
	EndIf
EndIf

Return cLoja
//---------------------------------------------------------------------
/*/{Protheus.doc} COMX002F()
Rotina que valida a faixa de codigos

@author Jair Matos
@since 05/11/2018
@version P12
@return Nil
/*/
//---------------------------------------------------------------------
User function COMX002F(cCodigo)
Local cCod := substr(cCodigo,1,1)
Local cCodRet := ""

If cCod =="2" .or. cCod =="3"//Fornecedores Diversos  200000-399999
	cCodRet := "2"
Else
	cCodRet := cCod
EndIf

Return cCodRet
//---------------------------------------------------------------------
/*/{Protheus.doc} COMX002U()
Rotina que valida a faixa de codigos

@author Jair Matos
@since 05/11/2018
@version P12
@return Nil
/*/
//---------------------------------------------------------------------
User function COMX002U(cCodigo)
Local cCod := substr(cCodigo,1,1)
Local lRet := .T.

IF INCLUI .AND. GETMV("MV_XUSUAPV")=RetCodUsr()
	If cCod =="1" .or. cCod =="2" .or. cCod =="3" .or. cCod =="5" .or. cCod =="6" .or. cCod =="7"//FAIXAS JÁ UTILIZADAS
		ApMsgAlert("Códigos com inicio 1,2,3,5,6,7 não podem ser utilizados.", "Atenção!")
		lRet := .F.
	EndIf
	
EndIf
Return lRet 
/*/
	Funcao:		U_PutMvPar
	Autor:		Jair Matos
	Data:		14/11/2018
	Descricao:	Grava o Conteudo Parametro de Acordo com a Empresa de Referencia
	Sintaxe:	U_PutMvPar( cEmp , cFil , uMvPar , uMvCntPut , lRpcSet )
/*/
User Function COMX002P( cEmp , cFil , uMvPar , uMvCntPut , lRpcSet )

	Local bPutMV	:= { |cMvPar,uMvPut| PutMv( @cMvPar , @uMvPut ) }
	
	Local cMvType	:= ValType( uMvPar )

	Local nMV
	Local nMVs

	Local uMvRet

	BEGIN SEQUENCE

		IF !(;  
			( IsInCallStack("U_	COMX002") );
				.or.;	
				( IsInCallStack("U_COMX002P") .and. Empty( ProcName(1) ) );
			)
			//Nao Permito a Chamada Direta
			BREAK
		EndIF		

		DEFAULT lRpcSet	:= .F.
	
		IF ( lRpcSet )
			RpcSetType( 3 )
			RpcSetEnv( cEmp , cFil )
		EndIF
	
		IF ( cMvType == "C" )
	        Eval( bPutMV , uMvPar , uMvCntPut )
	    ElseIF ( cMvType == "A" )
			nMvs	:= Len( uMvPar )
			For nMV := 1 To nMvs
				Eval( bPutMV , uMvPar[ nMV ] , uMvCntPut[ nMV ] )
			Next nMV
	    EndIF    

	END SEQUENCE

Return
