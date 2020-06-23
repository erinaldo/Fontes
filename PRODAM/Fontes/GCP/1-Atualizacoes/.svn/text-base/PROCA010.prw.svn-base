#INCLUDE "TOTVS.CH"
#INCLUDE "PROTHEUS.CH"
#INCLUDE "REPORT.CH"  
#INCLUDE "Topconn.ch"


User Function PROCA010()

Local oDlg
Local oGet   // para criacao do campo no dialog
Local oGroupDot
Local oGroupUsr
Local oBut
Local cCodGrupo    :=  SPACE(2)
Local cCodSubGrupo :=  SPACE(3)
Local cEspProd     :=  SPACE(2)
Local cTit:= "Sugestão de novo código de produto - Prodam"

Define MSDIALOG oDlg TITLE cTit From 0,0 to 300,800 Pixel     
oGroupProd:= tGroup():New(10,10,100,390,"Código do Produto",oDlg,,,.T.)

//oGroupUsr
@30,20 SAY "Grupo de Produto" OF oGroupDot PIXEL
@30,70 MSGET oGet  VAR cCodGrupo F3 "SBM1" size 40,06   OF oDlg PIXEL VALID EXISTCPO("SBM",cCodGrupo)
@30,130 SAY "SubGrupo de Produto" OF oDlg PIXEL
@30,190 MSGET oGet VAR cCodSubGrupo size 40,06 F3 "SZ1"	OF oDlg PIXEL VALID EXISTCPO("SZ1",cCodSubGrupo)
@30,255 SAY "Especificação de Produto" OF oDlg PIXEL
@30,320 MSGET oGet VAR cEspProd size 40,06  			OF oDlg PIXEL


@125,200 BUTTON oBut PROMPT "GERAR CÓDIGO" action( GRVTIT(SUBSTR(cCodGrupo,1,2), SUBSTR(cCodSubGrupo,1,3), cEspProd))  OF oDlg PIXEL  
@125,300 BUTTON oBut PROMPT "CANCELAR" action(oDlg:End())  OF oDlg PIXEL  
//-----------------------------------------------------------------------------
ACTIVATE MSDIALOG oDlg CENTERED

Return

Static Function GRVTIT(cGrupo, cSubGrupo, cEsp)
Local cSeqCodProd   := BuscaSeqProd(cGrupo, cSubGrupo)
	
	MSGINFO("Código Gerado: "+cGrupo+"."+cSubGrupo+"."+cSeqCodProd+"."+cEsp)

Return


Static Function BuscaSeqProd(cGrupo, cSubGrupo)
Local cQuery     := ""
Local cNextAlias := GetNextAlias()
Local cSeqProd   := ""

cQuery += " SELECT  MAX(SUBSTRING(B1_COD,8,5)) + 1 as Seq    "+ CRLF
cQuery += " FROM "+RetSqlName("SB1")+" SB1	 "+ CRLF
cQuery += "  WHERE SB1.D_E_L_E_T_ = ''    "+ CRLF
cQuery += " AND SUBSTRING(SB1.B1_COD,1,6)= '"+ALLTRIM(cGrupo)+"."+ALLTRIM(cSubGrupo)+"'"

cQuery := ChangeQuery(cQuery)

If Select("QRY") > 0
    Dbselectarea("QRY")  
    QRY->(DbClosearea())
EndIf

TcQuery cQuery New Alias "QRY"
 
IF !Empty(QRY->Seq)
	cSeqProd := PADL(QRY->Seq,5,"0")
ELSE
	cSeqProd := "00001"
ENDIF 
 
 
Return cSeqProd       
