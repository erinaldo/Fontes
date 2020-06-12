#Include 'Protheus.ch'
//---------------------------------------------------------------------------------------
/*/{Protheus.doc} LIMPTAB
Rotina de limpeza de tabelas
@author  	Carlos Henrique
@since     	01/01/2015
@version  	P.11.8      
@return   	Nenhum 
/*/
//---------------------------------------------------------------------------------------
User Function LIMPTAB()
LOCAL cEmp		:= "01"
LOCAL cFil		:= "0001"


RpcSetType(3)

IF RpcSetEnv(cEmp,cFil)

	oProcess:= MsNewProcess():New( { || LIMPPRO() }, "Atualizando", "Aguarde, limpando tabelas...", .F. )
	oProcess:Activate() 

endif

Return
/*------------------------------------------------------------------------
*
* LIMPPRO()
* Executa processamento de limpeza  
*
------------------------------------------------------------------------*/
static function LIMPPRO()
local cTab			:= ""
local aSX2			:= {} 
local cTabs		:= ""
local cNoTabs		:= "" 
local cTexto  	:= ""

oProcess:SetRegua1(3)

/*
// Contábil
oProcess:IncRegua1("Excluindo tabelas do contábil")
aSX2		:= {}
cTabs		:= "CTD,CV0,CT2,CT3,CT4,CT7,CTI,CTU,CTV,CTW,CTX,CTY,CT6,CTC,CTF,CTK,CTZ,CV1,CV2,CV3,CV4,CV6,CV7,CV8,CVO"
cNotTabs	:= ""
DBSELECTAREA("SX2")
DBGOTOP()	
dbEval(	{||	AADD(aSX2,SX2->X2_ARQUIVO) } ,;
 			{||	TRIM(SX2->X2_CHAVE)$cTabs .and.;
 				!TRIM(SX2->X2_CHAVE)$cNoTabs   } )
 		
oProcess:SetRegua2(LEN(aSX2)) 		
cTexto += "Inicio de limpeza das tabelas do Contábil:"+CRLF+CRLF 				
FOR nCnt:=1 to len(aSX2)
	oProcess:IncRegua2( "Excluindo tabela "+aSX2[nCnt]+"...")
	cQry := "DROP TABLE "+ TRIM(aSX2[nCnt])		
	if !(TCSQLEXEC(cQry) < 0)
		cTexto += "Tabela :"+ TRIM(aSX2[nCnt]) +" excluida."+CRLF
	else
		cTexto += "Tabela :"+ TRIM(aSX2[nCnt]) +" nâo excluida."+CRLF	
	endif
next nCnt 				

// PCO
oProcess:IncRegua1("Excluindo tabelas do PCO")
aSX2		:= {}
cTabs		:= "AK,AL"
cNotTabs	:= "AKF,AK6,AL1,AL2,AL3,AL4,AKW"
DBSELECTAREA("SX2")
DBGOTOP()	
dbEval(	{||	AADD(aSX2,SX2->X2_ARQUIVO) } ,;
 			{||	LEFT(SX2->X2_CHAVE,2)$cTabs .and.;
 				!TRIM(SX2->X2_CHAVE)$cNoTabs   } )

oProcess:SetRegua2(LEN(aSX2))
cTexto += CRLF+"Inicio de limpeza das tabelas do PCO:"+CRLF+CRLF 				
FOR nCnt:=1 to len(aSX2)
	oProcess:IncRegua2( "Excluindo tabela "+aSX2[nCnt]+"...")
	cQry := "DROP TABLE "+ TRIM(aSX2[nCnt])		
	if !(TCSQLEXEC(cQry) < 0)
		cTexto += "Tabela :"+ TRIM(aSX2[nCnt]) +" excluida."+CRLF
	else
		cTexto += "Tabela :"+ TRIM(aSX2[nCnt]) +" nâo excluida."+CRLF	
	endif
next nCnt 				
*/

// Ativo fixo
oProcess:IncRegua1("Excluindo tabelas do Ativo fixo")
aSX2		:= {}
cTabs		:= "SN"
cNotTabs	:= ""
DBSELECTAREA("SX2")
DBGOTOP()	
dbEval(	{||	AADD(aSX2,SX2->X2_ARQUIVO) } ,;
 			{||	LEFT(SX2->X2_CHAVE,2)$cTabs .and.;
 				!TRIM(SX2->X2_CHAVE)$cNoTabs   } )

oProcess:SetRegua2(LEN(aSX2))
cTexto += CRLF+"Inicio de limpeza das tabelas do ativo fixo:"+CRLF+CRLF 		
FOR nCnt:=1 to len(aSX2)
	oProcess:IncRegua2( "Excluindo tabela "+aSX2[nCnt]+"...")
	cQry := "DROP TABLE "+ TRIM(aSX2[nCnt])		
	if !(TCSQLEXEC(cQry) < 0)
		cTexto += "Tabela :"+ TRIM(aSX2[nCnt]) +" excluida."+CRLF
	else
		cTexto += "Tabela :"+ TRIM(aSX2[nCnt]) +" nâo excluida."+CRLF	
	endif
next nCnt

LIMPLOG(cTexto)

return
/*------------------------------------------------------------------------
*
* LIMPLOG()
* Exibe log de limpeza das tabelas 
*
------------------------------------------------------------------------*/
STATIC FUNCTION LIMPLOG(cTexto)
Local oDlg  	:= NIL
Local oFont     := NIL
Local oMemo     := NIL
Local cFileLog  := ""
Local cMask     := "Arquivos Texto" + "(*.TXT)|*.txt|"
local cFileLog	:= ""

Define Font oFont Name "Mono AS" Size 5, 12
Define MsDialog oDlg Title "Atualizacao concluida." From 3, 0 to 340, 417 Pixel

@ 5, 5 Get oMemo Var cTexto Memo Size 200, 145 Of oDlg Pixel
oMemo:bRClicked := { || AllwaysTrue() }
oMemo:oFont     := oFont

Define SButton From 153, 175 Type  1 Action oDlg:End() Enable Of oDlg Pixel // Apaga
Define SButton From 153, 145 Type 13 Action ( cFile := cGetFile( cMask, "" ), If( cFile == "", .T., ;
MemoWrite( cFile, cTexto ) ) ) Enable Of oDlg Pixel

Activate MsDialog oDlg Center

RETURN

