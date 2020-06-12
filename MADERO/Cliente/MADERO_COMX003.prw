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
!Nome              ! COMX003                                                 !
+------------------+---------------------------------------------------------+
!Descricao         ! Seleciona as faixas de codigos dos clientes	    	 !
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
User Function COMX003()
Local aArea 	:= GetArea()
Local aAreaSA1	:= SA1->(GetArea())
Local cCodigo :=""
Local nCodigo :="0"
Local cFiltro:= Space(TamSx3("A1_COD")[1])
Local nCod := 0 
Local cEmp := 	Iif(cEmpAnt =="01","02","01")

//incluir parametros para todas as faixas e gravar o ultimo codigo quando for utilizar
//MV_XFX1CLI,MV_XFX2CLI,MV_XFX3CLI,MV_XFX4CLI,MV_XFX9CLI

nCodigo := M->A1_XFAIXA //seleciona a opção)

If nCodigo =="1"  //Clientes Intercompany  100000 - 199999
	cCodigo := GetMV("MV_XFX1CLI")
	PutMV("MV_XFX1CLI",Soma1(cCodigo))  
		StartJob( "U_COMX002P" , GetEnvServer() , .T. , cEmp , "" , "MV_XFX1CLI" ,Soma1(cCodigo)  , .T. )//grava o mesmo codigo de fornecedor nas 02 empresas
ElseIf nCodigo =="2"//Clientes Diversos  200000-299999
	cCodigo := GetMV("MV_XFX2CLI")
	PutMV("MV_XFX2CLI",Soma1(cCodigo)) 
			StartJob( "U_COMX002P" , GetEnvServer() , .T. , cEmp , "" , "MV_XFX2CLI" ,Soma1(cCodigo)  , .T. )//grava o mesmo codigo de fornecedor nas 02 empresas
ElseIf nCodigo =="3"//Operadoras de Cartões  300000-399999
	cCodigo := GetMV("MV_XFX3CLI")
	PutMV("MV_XFX3CLI",Soma1(cCodigo))  
			StartJob( "U_COMX002P" , GetEnvServer() , .T. , cEmp , "" , "MV_XFX3CLI" ,Soma1(cCodigo)  , .T. )//grava o mesmo codigo de fornecedor nas 02 empresas
ElseIf nCodigo =="4"//Consumidor Final 400000-499999
	cCodigo := GetMV("MV_XFX4CLI")
	PutMV("MV_XFX4CLI",Soma1(cCodigo)) 
			StartJob( "U_COMX002P" , GetEnvServer() , .T. , cEmp , "" , "MV_XFX4CLI" ,Soma1(cCodigo)  , .T. )//grava o mesmo codigo de fornecedor nas 02 empresas
ElseIf nCodigo =="9"//Cliente Padrão Restaurantes  900000-999999
	cCodigo := GetMV("MV_XFX9CLI")
	PutMV("MV_XFX9CLI",Soma1(cCodigo))
			StartJob( "U_COMX002P" , GetEnvServer() , .T. , cEmp , "" , "MV_XFX9CLI" ,Soma1(cCodigo)  , .T. )//grava o mesmo codigo de fornecedor nas 02 empresas
Else
	cCodigo := cFiltro
EndIf

RestArea(aAreaSA1)
RestArea(aArea)
Return (cCodigo)
//---------------------------------------------------------------------
/*/{Protheus.doc} PesqCod
Rotina para selecionar o ultimo codigo utilizado no cadastro

@author Jair Matos
@since 05/10/2018
@version P12
@return cCodGer
/*/
//---------------------------------------------------------------------
Static function PesqCod(cOpc)

Local cCodGer
Local cQuery := ""

cQuery := "SELECT MAX(A1_COD) as COD FROM "+RetSQLName("SA1") + " WHERE D_E_L_E_T_ = ' ' AND A1_COD LIKE '"+cOpc+"%'  "

If Select("cAlias") > 0
	dbSelectArea("cAlias")
	dbCloseArea()
EndIf

TCQUERY cQuery NEW ALIAS cAlias
If !Empty(Alltrim(cAlias->COD))
	cCodGer := Soma1(cAlias->COD)
Else
	cCodGer := PADR(cOpc,TamSx3("A1_COD")[1],"0")
EndIf
//Memowrite("c:\temp\codigo.txt",cCodGer)
return cCodGer
//---------------------------------------------------------------------
/*/{Protheus.doc} COMX003C
Rotina que valida se CGC existe

@author Jair Matos
@since 05/10/2018
@version P12
@return Nil
/*/
//---------------------------------------------------------------------
User function COMX003C(nOpc)
Local cCodigo :=""
Local cCodAnt := M->A1_COD
Local lRet := .T.
Local cCGC 	 := M->A1_CGC
Local cFaixa := M->A1_XFAIXA
Local cQuery := ""

If len(cCGC) == 14
	cCGC := SUBSTR(M->A1_CGC,1,8)
	cQuery := "SELECT A1_COD as COD FROM "+RetSQLName("SA1") + " WHERE D_E_L_E_T_ = ' ' AND SUBSTR(A1_CGC,1,8) = '"+cCGC+"' "
Else
	cQuery := "SELECT A1_COD as COD FROM "+RetSQLName("SA1") + " WHERE D_E_L_E_T_ = ' ' AND A1_CGC = '"+M->A1_CGC+"' "
EndIf

If Select("cAlias") > 0
	dbSelectArea("cAlias")
	dbCloseArea()
EndIf

TCQUERY cQuery NEW ALIAS cAlias
If !Empty(Alltrim(cAlias->COD))
	cCodigo := cAlias->COD
	M->A1_LOJA := "00"
Else
	cCodigo := cCodAnt
EndIf

Return Iif(nOpc==1,cCodigo,lRet)
//---------------------------------------------------------------------
/*/{Protheus.doc} COMX003L
Rotina que valida se cliente ja existe

@author Jair Matos
@since 01/11/2018
@version P12
@return Nil
/*/
//---------------------------------------------------------------------
User function COMX003L()
Local cLoja :=""
Local lRet := .T.
Local cCGC 	 := M->A1_CGC
Local cQuery := ""

If Empty(cCGC)
	cLoja  :="01"
Else
	//Verifica se O cnpj INTEIRO ja existe. Caso já exista, traz a loja correta.
	cQuery := "SELECT A1_LOJA as LOJA FROM "+RetSQLName("SA1") + " WHERE D_E_L_E_T_ = ' ' AND A1_CGC = '"+M->A1_CGC+"' "
	If Select("cAlias") > 0
		dbSelectArea("cAlias")
		dbCloseArea()
	EndIf
	
	TCQUERY cQuery NEW ALIAS cAlias
	If !Empty(Alltrim(cAlias->LOJA))
		cLoja :=cAlias->LOJA
		lRet := .F.
	EndIf
	
	If lRet //Se o CNPJ inteiro não existe, verificar a RAIZ do cnpj. Se achar o CNPJ , traz a ultima loja e acresce +1
		
		If len(cCGC) == 14
			cCGC := SUBSTR(cCGC,1,8)
		EndIf
		
		cQuery := "SELECT MAX(A1_LOJA) as LOJA FROM "+RetSQLName("SA1") + " WHERE D_E_L_E_T_ = ' ' AND SUBSTR(A1_CGC,1,8) = '"+cCGC+"' "
		
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
/*/{Protheus.doc} COMX003F()
Rotina que valida a faixa de codigos

@author Jair Matos
@since 05/11/2018
@version P12
@return Nil
/*/
//---------------------------------------------------------------------
User function COMX003F(cCodigo)
Local cCod := substr(cCodigo,1,1)
Local cCodRet := ""
cCodRet := cCod

Return cCodRet
//---------------------------------------------------------------------
/*/{Protheus.doc} COMX003U()
Rotina que valida a faixa de codigos

@author Jair Matos
@since 05/11/2018
@version P12
@return Nil
/*/
//---------------------------------------------------------------------
User function COMX003U(cCodigo)
Local cCod := ""
Local lRet := .T.

If !Empty(cCodigo)
	cCod := substr(cCodigo,1,1)
EndIf

IF INCLUI .AND. GETMV("MV_XUSUAPV")=RetCodUsr()
	If cCod =="1" .or. cCod =="2" .or. cCod =="3" .or. cCod =="4" .or. cCod =="9" //FAIXAS JÁ UTILIZADAS
		ApMsgAlert("Códigos com inicio 1,2,3,4,9 não podem ser utilizados.", "Atenção!")
		lRet := .F.
	EndIf
	
EndIf
Return lRet
