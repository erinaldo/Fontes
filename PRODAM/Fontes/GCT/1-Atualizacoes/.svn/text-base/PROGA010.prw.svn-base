# Include "protheus.ch"
# include "TOTVS.CH"

User Function PROGA010()

Local oDlg
Local oGet   // para criacao do campo no dialog
local cCodDot1   	:= CN9_XDOTA1
local cDescDot1  	:= CN9_XATIV1 //CN9_XDSCD1

local cCodDotDois   := CN9_XDOTA2
local cDescDotDois  := CN9_XATIV2 //CN9_XDSCD2

local cCodDotTres   := CN9_XDOTA3
local cDescDotTres  := CN9_XATIV3 //CN9_XDSCD3

local cCodDot4  	:= CN9_XDOTA4
local cDescDot4  	:= CN9_XATIV4 //CN9_XDSCD4

local cCodDotCinco  := CN9_XDOTA5
local cDescDotCinco := CN9_XATIV5 //CN9_XDSCD5

local cMailGestor   := CN9_XEMLGC
local cMailFiscal   := CN9_XEMLFC
local cMailOutros   := CN9_XEMLOU

local cMailGerenc   := CN9_XEMLGE
local cMailDiret    := CN9_XEMLDI

Local oGroupDot
Local oGroupUsr
Local oBut
Local cTit:= "Alterar campos Contrato"

If BloqRevisao(M->CN9_FILIAL, M->CN9_NUMERO, M->CN9_REVISA)//APENAS PERMITE ALTERAR A ULTIMA REVISÃO

	Define MSDIALOG oDlg TITLE cTit From 0,0 to 550,700 Pixel     
	oGroupDot:= tGroup():New(10,10,140,340,"Dotação",oDlg,,,.T.)
	oGroupUsr:= tGroup():New(150,10,240,340,"Usuários (Gestor / Fiscal Contrato)",oDlg,,,.T.)
	
	//oGroupUsr
	@30,20 SAY "Cod. Dotação 1" OF oGroupDot PIXEL
	@30,60 GET oGet VAR cCodDot1 size 170,06			   			  			    OF oGroupDot PIXEL
	@30,240 SAY "Atividade Dotação 1" OF oGroupDot PIXEL
	@30,290 GET oGet VAR cDescDot1 size 20,06			   			  			OF oGroupDot PIXEL
	
	@50,20 SAY "Cod. Dotação 2" OF oGroupDot PIXEL
	@50,60 GET oGet VAR cCodDotDois size 170,06			   			  			OF oGroupDot PIXEL
	@50,240 SAY "Atividade Dotação 2" OF oGroupDot PIXEL
	@50,290 GET oGet VAR cDescDotDois size 20,06			   			  		OF oGroupDot PIXEL
	
	
	@70,20 SAY "Cod. Dotação 3" OF oGroupDot PIXEL
	@70,60 GET oGet VAR cCodDotTres size 170,06			   			  			OF oGroupDot PIXEL
	@70,240 SAY "Atividade Dotação 3" OF oGroupDot PIXEL
	@70,290 GET oGet VAR cDescDotTres size 20,06			   			  		OF oGroupDot PIXEL
	
	
	@90,20 SAY "Cod. Dotação 4" OF oGroupDot PIXEL
	@90,60 GET oGet VAR cCodDot4 size 170,06			   			  				OF oGroupDot PIXEL
	@90,240 SAY "Atividade Dotação 4" OF oGroupDot PIXEL
	@90,290 GET oGet VAR cDescDot4 size 20,06			   			  			OF oGroupDot PIXEL
	
	
	@110,20 SAY "Cod. Dotação 5" OF oGroupDot PIXEL
	@110,60 GET oGet VAR cCodDotCinco size 170,06			   			  		OF oGroupDot PIXEL
	@110,240 SAY "Atividade Dotação 5" OF oGroupDot PIXEL
	@110,290 GET oGet VAR cDescDotCinco size 20,06			   			  		OF oGroupDot PIXEL
	
	@170,20  SAY "Gestor Contrato" OF oGroupUsr PIXEL
	@170,65  MSGET oGet  VAR cMailGestor F3 "ESPUSR" size 70,06			   		OF oGroupUsr PIXEL VALID ValidUserProt(cMailGestor) //UsrExist(cMailGestor)
	@170,145 SAY "Fiscal Contrato" OF oGroupUsr PIXEL
	@170,185 MSGET oGet  VAR cMailFiscal F3 "ESPUSR" size 70,06			   		OF oGroupUsr PIXEL VALID ValidUserProt(cMailFiscal) //UsrExist(cMailFiscal)
	@190,20 SAY "Gerente Contrato" OF oGroupUsr PIXEL
	@190,65 MSGET oGet VAR cMailGerenc F3 "ESPUSR" size 70,06			  		OF oGroupUsr PIXEL VALID ValidUserProt(cMailGerenc) //UsrExist(cMailGerenc)
	@190,145 SAY "Diretor Contrato" OF oGroupUsr PIXEL
	@190,185 MSGET oGet VAR cMailDiret F3 "ESPUSR" size 70,06  			  		OF oGroupUsr PIXEL VALID ValidUserProt(cMailDiret) //UsrExist(cMailDiret)
	@210,20 SAY "Contrato Outros" OF oGroupUsr PIXEL
	@210,65 MSGET oGet VAR cMailOutros F3 "ESPUSR" size 70,06			   		OF oGroupUsr PIXEL VALID ValidUserProt(cMailOutros) //UsrExist(cMailOutros)
	
	
	@245,150 BUTTON oBut PROMPT "OK" action( GRVTIT(cCodDot1,cDescDot1, cCodDotDois, cDescDotDois, cCodDotTres, cDescDotTres, cCodDot4, cDescDot4, cCodDotCinco, cDescDotCinco, cMailGestor, cMailFiscal, cMailGerenc, cMailDiret, cMailOutros ), oDlg:End())  OF oDlg PIXEL  
	@245,180 BUTTON oBut PROMPT "CANCELAR" action(oDlg:End())  OF oDlg PIXEL  
	//-----------------------------------------------------------------------------
	ACTIVATE MSDIALOG oDlg CENTERED

Else
	MsgInfo("Contrato não pode ser alterado, apenas a última revisão poderá ser alterada")
	Return
EndIf

Return

Static Function GRVTIT(cCodDot1,cDescDot1, cCodDotDois, cDescDotDois, cCodDotTres, cDescDotTres, cCodDot4, cDescDot4, cCodDotCinco, cDescDotCinco, cMailGestor, cMailFiscal, cMailGerenc, cMailDiret, cMailOutros)

RECLOCK("CN9",.F.)

	CN9->CN9_XDOTA1:= cCodDot1   
	CN9->CN9_XATIV1:= cDescDot1
	//CN9->CN9_XDSCD1 := cDescDot1
	CN9->CN9_XDOTA2:= cCodDotDois   
	CN9->CN9_XATIV2:= cDescDotDois
	//CN9->CN9_XDSCD2 := cDescDotDois  
	CN9->CN9_XDOTA3:= cCodDotTres   
	CN9->CN9_XATIV3:= cDescDotTres
	//CN9->CN9_XDSCD3 := cDescDotTres  
	CN9->CN9_XDOTA4:= cCodDot4  
	CN9->CN9_XATIV4:= cDescDot4
	//CN9->CN9_XDSCD4 := cDescDot4  
	CN9->CN9_XDOTA5:= cCodDotCinco  
	CN9->CN9_XATIV5:= cDescDotCinco
	//CN9->CN9_XDSCD5 := cDescDotCinco 
	CN9->CN9_XEMLGC:= cMailGestor   
	CN9->CN9_XEMLFC:= cMailFiscal   
	CN9->CN9_XEMLOU:= cMailOutros   
	CN9->CN9_XEMLGE:= cMailGerenc
	CN9->CN9_XEMLDI:= cMailDiret	
	
	MsgInfo("Dados Alterados com sucesso")

MsUnlock()
Return


Static Function BloqRevisao(cFil, cNumero, nRevisa)
Local cAlias 	:= GetNextAlias()
Local cQuery    := ""
Local lReturn 	:= .F.

cQuery += " SELECT MAX(CN9.CN9_REVISA) as CN9_REVISA  FROM "+RetSqlName("CN9")+" CN9 "
cQuery += " 	WHERE CN9.CN9_FILIAL = '"+cFil+"' "			
cQuery += " 	AND CN9.D_E_L_E_T_   = ''	 "			
cQuery += " 	AND CN9.CN9_NUMERO   = '"+cNumero+"'	 "

cQuery := ChangeQuery(cQuery)

If Select("TMPQRY") > 0
    Dbselectarea("TMPQRY")
    TMPQRY->(DbClosearea())
EndIf

dbUsearea(.T.,"TOPCONN",TCGenQry(,,cQuery), "TMPQRY") 

If  TMPQRY->(!Eof())      
	If TMPQRY->CN9_REVISA = nRevisa
		lReturn := .T.
	EndIf
EndIf

Return lReturn


Static Function ValidUserProt(cUser)
Local nOrder := 2
Local lRet  := .T.
Local _aArray := {}

PswOrder(nOrder) 
If !PswSeek(cUser,.T.) 
	lRet  := .F.
Else
	_aArray := PswRet()
EndIf

Return lRet

//Static Function BloqRevisao(cFil, cNumero, nRevisa)
//Local cAlias 	:= GetNextAlias()
//Local cQuery    := ""
//Local lReturn 	:= .F.

//cQuery += " SELECT MAX(CN9.CN9_REVISA) as CN9_REVISA  FROM "+RetSqlName("CN9")+" CN9 "
//cQuery += " 	INNER JOIN "+RetSqlName("CNK")+" CNK ON CNK.CNK_CONTRA = CN9.CN9_NUMERO "
//cQuery += " 	WHERE CN9.CN9_FILIAL = '"+cFil+"' "			
//cQuery += " 	AND CNK.CNK_FILIAL   = '"+cFil+"' "		
//cQuery += " 	AND CN9.D_E_L_E_T_   = ''	 "			
//cQuery += " 	AND CNK.D_E_L_E_T_   = ''	 "
//cQuery += " 	AND CN9.CN9_NUMERO   = '"+cNumero+"'	 "


//cQuery := ChangeQuery(cQuery)

//If Select("TMPQRY") > 0
//    Dbselectarea("TMPQRY")
//    TMPQRY->(DbClosearea())
//EndIf

//dbUsearea(.T.,"TOPCONN",TCGenQry(,,cQuery), "TMPQRY") 

//If  TMPQRY->(!Eof())      
//	If TMPQRY->CN9_REVISA = nRevisa
//		lReturn := .T.
//	EndIf
//EndIf

//Return lReturn