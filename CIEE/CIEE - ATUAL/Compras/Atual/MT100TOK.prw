#include "rwmake.ch"
#include "protheus.ch"
#include "TOPCONN.ch"

/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �MT100TOK  �Autor  �Emerson             � Data �  26/11/07   ���
�������������������������������������������������������������������������͹��
���Desc.     �Ponto de Entrada da NF para padronizar o numero com zeros   ���
���          �a esquerda (tam 06 caracteres)                              ���
�������������������������������������������������������������������������͹��
���Uso       � Protheus 8                                                 ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/

User Function MT100TOK()
      
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
	msgbox(OemToAnsi("O campo 'Espec.Docum.' � obrigat�rio o Preenchimento!!!"),OemToAnsi("Aten��o"))
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
		Msgbox(OemToAnsi("Para Espec.Documento RPS ser� atribuida a numera��o sequencial do ano corrente. O RPS inclu�do ser� o "+cnfiscal),OemToAnsi("Recibo Prov. Servi�os"))
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
	msgbox(OemToAnsi("Obrigat�rio o Preenchimento do campo 'Chave NF-e' ."),OemToAnsi("Aten��o"))
	RestArea(_aArea)	
	Return(.F.)
endIf

RestArea(_aArea)

Return(.T.)