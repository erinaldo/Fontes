#include "protheus.ch"
#include "TOPCONN.ch"
/*
+-----------+-------------+-----------+----------------+------+-------------+
| Programa  | u_F100DOC   | Autor     | Fabio Zanchim  | Data |    11/2013  |
+-----------+-------------+-----------+----------------+------+-------------+
| Descricao | P.E. na transferencia bancaria para controle da numeração   	|
|           | do documento													|
+-----------+---------------------------------------------------------------+
| Uso       | CIEE   														|
+-----------+---------------------------------------------------------------+
*/
User Function F100DOC()
Local _cDoc	:=Paramixb[8]
Local _cTipo:=Paramixb[7]                          
Local _cAno	:=''  
Local _nTam	:=0

If _cTipo=="TE" .And. cEmpAnt=="01"
            
		_nTam:=9//TamSx3("E5_NUMCHEQ")[1]

		_cAno:=Str(Year(dDataBase),4)
		cQuery := " SELECT Max(E5_DOCUMEN) E5_DOCUMEN"
		cQuery += " FROM "+RetSQLname('SE5')
		cQuery += " Where E5_FILIAL='"+xFilial('SE5')+"' AND (E5_TIPODOC = 'TR' Or E5_TIPODOC = 'TE') " 
		cQuery += " And SUBSTRING(E5_DOCUMEN,1,5)='TED"+Substr(_cAno,3,2)+"'"
		cQuery += " And E5_DATA>='"+_cAno+"0101'"
		cQuery += " And E5_DATA>='20131111'"
		cQuery += " And D_E_L_E_T_=' ' "
		TcQuery cQuery New Alias (cAlias:=GetNextAlias())
		If (cAlias)->(!Eof()) .And. !Empty((cAlias)->E5_DOCUMEN) 
			_cDoc:="TED"+Substr(_cAno,3,2)+	Soma1(ALLTRIM(SUBSTR((cAlias)->E5_DOCUMEN,6,_nTam-5)),10)
		Else
			_cDoc:="TED"+Substr(_cAno,3,2)+StrZero(1,_nTam-5)	
		EndIf
		(cAlias)->(dbCloseArea())
EndIf

Return(_cDoc)	