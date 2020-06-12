#include "rwmake.ch"
#include "protheus.ch"
#include "TOPCONN.ch"  
//---------------------------------------------------------------------------------------
/*/{Protheus.doc} CESTE16
Preenche com zeros a esquerda o numero da RPS
@author     Totvs
@since     	01/01/2014
@version  	P.11      
@param 		Nenhum
@return    	Nenhum
@obs        Nenhum
Alterações Realizadas desde a Estruturação Inicial
------------+-----------------+----------------------------------------------------------
Data       	|Desenvolvedor    |Motivo                                                                                                                 
------------+-----------------+----------------------------------------------------------
		  	|				  | 
------------+-----------------+----------------------------------------------------------
/*/
//---------------------------------------------------------------------------------------
User Function CESTE16()   
Local cAlias:=''
Local cQuery:=''
Local _cNota:=''
Local _nTam:=TamSx3("F1_DOC")[1]
Local _aArea := GetArea()
               

If IsInCallStack("MATA920")
	Return(.T.)
EndIf
     
_cNota	:= iif(len(alltrim(cnfiscal))<9,strzero(0,9-len(alltrim(cnfiscal)))+alltrim(cnfiscal),cnfiscal)

IF Empty(CESPECIE)
	msgbox(OemToAnsi("O campo 'Espec.Docum.' é obrigatório o Preenchimento!!!"),OemToAnsi("Atenção"))
	Return(.F.)  
Else
	//Cristiano 31/10/13
	If 	Alltrim(CESPECIE)=='RPS'
		_cNota:=Substr(Str(Year(dDataBase),4),3,2)
		cQuery := " SELECT Max(F1_DOC) F1_DOC"
		cQuery += " FROM "+RetSQLname('SF1')
		cQuery += " Where F1_FILIAL='"+xFilial('SF1')+"' AND F1_ESPECIE = 'RPS' 
		cQuery += " And F1_EMISSAO>='20131031'"
		cQuery += " And D_E_L_E_T_=' ' "
		TcQuery cQuery New Alias (cAlias:=GetNextAlias())
		If (cAlias)->(!Eof()) .And. !Empty((cAlias)->F1_DOC)
			_cNota+=Soma1(Soma1(SUBSTR((cAlias)->F1_DOC,3,_nTam-2)))
		Else
			_cNota+=StrZero(1,_nTam-2)	
		EndIf
		(cAlias)->(dbCloseArea())
		cnfiscal:=_cNota
		Msgbox(OemToAnsi("Para Espec.Documento RPS será atribuida a numeração sequencial do ano corrente. O RPS incluído será o "+cnfiscal),OemToAnsi("Recibo Prov. Serviços"))
		Return(.T.)		
	EndIF
EndIf

cQuery := "SELECT * "
cQuery += "FROM "+RetSQLname('SF1')+" "
cQuery += "WHERE D_E_L_E_T_ <> '*' "
cQuery += "AND F1_DOC = '"+_cNota+"' "
cQuery += "AND F1_FORNECE = '"+CA100FOR+"' "
cQuery += "AND F1_LOJA = '"+CLOJA+"' "
cQuery += "AND F1_SERIE = '"+CSERIE+"' "
TcQuery cQuery New Alias "NFTMP"

If NFTMP->(EOF())
	cnfiscal:=iif(len(alltrim(cnfiscal))<9,strzero(0,9-len(alltrim(cnfiscal)))+alltrim(cnfiscal),cnfiscal)
	NFTMP->(DbCloseArea())
Else
	Help(" ", 1, "EXISTNF")
	NFTMP->(DbCloseArea()) 
	RestArea(_aArea)
	Return(.F.)
EndIf
 
If Alltrim(cEspecie)=='SPED' .And. Empty(M->F1_CHVNFE) .And. cFormul<>'S'
	msgbox(OemToAnsi("Obrigatório o Preenchimento do campo 'Chave NF-e' ."),OemToAnsi("Atenção"))
	RestArea(_aArea)	
	Return(.F.)
endIf

RestArea(_aArea)
Return(.T.)