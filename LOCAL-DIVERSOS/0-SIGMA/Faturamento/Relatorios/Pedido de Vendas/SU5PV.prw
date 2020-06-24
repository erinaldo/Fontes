#Include "Protheus.ch"
#Include "Topconn.ch"

/*/{Protheus.doc} SU5PV

Seleciona os Contatos

@type function
@author Hermes Vieira Jr
@since 16/06/2007

@history 21/06/2016, Carlos Eduardo Niemeyer Rodrigues
/*/
User Function SU5PV(cPedido)
	Local oClassRelatorioPV	:= ClassRelatorioPV():newClassRelatorioPV()
	Local oDlg				:= Nil
	Local lRet				:= .t.  
	Local cQuery			:= ""
	Local bCancel 			:=	{ || oDlg:End()}
	Local oOk      			:=	LoadBitmap( GetResources(), "LBOK")
	Local oNo      			:=	LoadBitmap( GetResources(), "LBNO")
	Local bOk				:=	{ || iif( Checagem(@aDados) , oDlg:End() , Nil ) }         
	Local cCliente  		:= ""
	Local cLoja				:= ""         
	Local aDados 			:= {}  
	Private cMail   		:= ""         	                      

	aDados := CargaServicos(cPedido)   
		
	If Len(aDados) <> 0
		Setapilha()
		Define MsDialog oDlg Title "Selecione os Contatos" From 00,00 To 27,95 Of oMainWnd Style 128
		oDlg:lEscClose := .f.
		@ 015,005 ListBox oServ Var cVarQ Fields Header "","Codigo","Contato","Email" ColSizes 20,40,40,40 Size 365,170 Of oDlg Pixel
			oServ:SetArray(aDados)
			oServ:bLDblClick:= { || aDados[oServ:nAt,1] := !aDados[oServ:nAt,1] , Ver_Check(@aDados,oServ:nAt,@oDlg,@oServ,oOk,oNo) }
			oServ:bLine := { || {	iif(aDados[oServ:nAt,01],oOk,oNo),aDados[oServ:nAt,02],aDados[oServ:nAt,03],aDados[oServ:nAt,04]} }
			Activate MsDialog oDlg Centered On Init EnchoiceBar(oDlg,bOk,bCancel) 
		Setapilha()           
	EndIf

Return cMail

/*
	Atualiza a Grid
*/
Static Function Ver_Check(aDados,nPos,oDlg,oServ,oOk,oNo)

	oServ:SetArray(aDados)
	oServ:bLine := { || { iif(aDados[oServ:nAt,01],oOk,oNo),aDados[oServ:nAt,02],aDados[oServ:nAt,03],aDados[oServ:nAt,04] } }
	oServ:Refresh()
	oDlg:Refresh()

Return

/*
	Realiza a Valida��o dos Dados
*/
Static Function Checagem(aDados)
	Local lRet	:= .t.
	Local nCont	:= 0
								
	For t := 1 to Len(aDados)
		if	aDados[t,1] 
			cMail += Alltrim(aDados[t,4]) + ";"
			nCont 	:= 1
		endif
	Next t 
								
	If 	nCont < 1
		Alert("Selecione ao menos 1 Contato !!")
		lRet	:= .f.
	Endif

Return lRet
                            	
/*
	Carrega os dados
*/
Static Function CargaServicos(cPedido)
	Local cQuery
	Local aTemp		:=	{}      
	Local cCliente  := ""
	Local cLoja     := ""     

	//Query que retorna os dados do orcamento e os dados dos itens.
	cQuery := "SELECT "
	cQuery += "		SA1.A1_COD, SA1.A1_LOJA, SA1.A1_EMAIL "
	cQuery += "FROM " + RetSqlName("SC5") + " AS SC5 "
	cQuery += "		LEFT JOIN " + RetSqlName("SA1") + " AS SA1 ON "
	cQuery += "				SA1.A1_FILIAL = '" + xFilial("SA1")+ "' AND SC5.C5_CLIENTE = SA1.A1_COD AND SC5.C5_LOJACLI = SA1.A1_LOJA AND SA1.D_E_L_E_T_ = ' ' "
	cQuery += "WHERE SC5.C5_FILIAL = '" + xFilial("SC5")+ "' AND SC5.D_E_L_E_T_ = ' ' AND SC5.C5_NUM = '" + cPedido + "' "

	TCQUERY cQuery NEW ALIAS "SA1QRY"     

	cCliente := SA1QRY->A1_COD
	cLoja := SA1QRY->A1_LOJA

	cQuery := " SELECT SU5.U5_CODCONT, SU5.U5_CONTAT, SU5.U5_EMAIL  "
	cQuery += " FROM " + RetSQLName("AC8") + " AC8 "
	cQuery += " INNER JOIN " + RetSQLName("SU5") + " SU5 ON SU5.U5_FILIAL = '" + xFilial("SU5") + "' AND SU5.U5_CODCONT = AC8.AC8_CODCON AND SU5.D_E_L_E_T_ = '  ' "
	cQuery += " WHERE AC8.AC8_FILIAL = '" + xFilial("AC8") + "' AND AC8.AC8_ENTIDA = 'SA1' AND AC8.AC8_FILENT = '" + xFilial("SA1")+ "' AND AC8.AC8_CODENT = '" + cCliente + cLoja + "' AND AC8.D_E_L_E_T_ = ' ' "
	cQuery += " ORDER BY SU5.U5_CONTAT "

	/*
	cQuery := "SELECT SU5.U5_CODCONT, SU5.U5_CONTAT, SU5.U5_EMAIL "
	cQuery += "FROM " + RetSQLName("SA1") + " SA1 "
	cQuery +=	"INNER JOIN " + RetSQLName("SU5") + " SU5 ON SU5.U5_FILIAL = '" + xFilial("SU5") + "' "
	cQuery +=		"AND SU5.U5_CODCONT = SA1.A1_CONTATO "
	cQuery +=		"AND SU5.D_E_L_E_T_ = '  '  "
	cQuery += "WHERE SA1.A1_FILIAL = '" + xFilial("SA1") + "' "
	cQuery +=	"AND SA1.A1_COD = '" + cCliente + "' "
	cQuery +=	"AND SA1.A1_LOJA = '" + cLoja + "' "
	cQuery +=	"AND SA1.D_E_L_E_T_ = ' ' "
	cQuery += "ORDER BY SU5.U5_CONTAT "
	*/

	TcQuery cQuery New Alias "SU5QRY"

	Do While SU5QRY->(!Eof())
		aAdd( aTemp , { .F. , SU5QRY->U5_CODCONT, SU5QRY->U5_CONTAT,SU5QRY->U5_EMAIL } )
		SU5QRY->(dbskip())
	Enddo           

	SA1QRY->(dbCloseArea())
	SU5QRY->(dbclosearea())

Return ( aTemp )