#include "rwmake.ch"
#include "protheus.ch"
#include "TOPCONN.ch"

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³MT140FIL  ºAutor  ³Lígia Sarnauskas    º Data ³  22/11/13   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ Ponto de entrada executado para aplicar filtro nas         º±±
±±º          ³ Pre Notas carregadas no browse.                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ FIESP                                                      º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/


user Function MT140FIL()

Local cFiltraSF1
Local cCRLF			:= CRLF
Private _cUserLib	:= GetMv("FI_XVISPNF",,.F.) // Usuários que poderão ver todo o browse de pré notas (sem nenhum filtro)

_cCodUser	:=__CUSERID

iF _cCodUser $ _cUserLib
	cFiltraSF1:=""
Else
	// Verifica se o usuário faz parte de algum grupo de compras
	If Select("TMP") > 0     // Verificando se o alias esta em uso
		dbSelectArea("TMP")
		dbCloseArea()
	EndIf	
	cQuery := "SELECT SAJ.AJ_GRCOM GRCOM "
	cQuery := cQuery + " FROM "
	cQuery := cQuery + RetSQLname("SAJ")+" SAJ    "
	cQuery := cQuery + " WHERE "
	cQuery := cQuery + " SAJ.D_E_L_E_T_ = ' ' "
	cQuery := cQuery + " AND SAJ.AJ_USER = '"+_cCodUser+"'
	TCQuery cQuery NEW ALIAS "TMP"
	
	dbSelectArea("TMP")
	dbGotop()
	If !EOF()
		_cGrupCom:=TMP->GRCOM
		
		cFiltraSF1	:= "F1_FILIAL+F1_DOC+F1_SERIE+F1_FORNECE+F1_LOJA+F1_TIPO"
		cFiltraSF1	+= "			IN" + cCRLF
		cFiltraSF1	+= "			(" + cCRLF
		cFiltraSF1	+= "				SELECT"+ cCRLF
		cFiltraSF1	+= "					SF1.F1_FILIAL+SF1.F1_DOC+SF1.F1_SERIE+SF1.F1_FORNECE+SF1.F1_LOJA+SF1.F1_TIPO"+cCRLF
		cFiltraSF1	+= "				FROM                                      " + cCRLF
		cFiltraSF1	+= "					" + RetSqlName( "SF1" ) + " SF1,      " + cCRLF
		cFiltraSF1	+= "					" + RetSqlName( "SD1" ) + " SD1,      " + cCRLF
		cFiltraSF1	+= "					" + RetSqlName( "SC7" ) + " SC7       " + cCRLF
		cFiltraSF1	+= "				WHERE                                     " + cCRLF
		cFiltraSF1	+= "					SF1.D_E_L_E_T_ = ' '                  " + cCRLF
		cFiltraSF1	+= "					AND SD1.D1_FILIAL = SF1.F1_FILIAL     " + cCRLF
		cFiltraSF1	+= "					AND SD1.D1_DOC    = SF1.F1_DOC        " + cCRLF
		cFiltraSF1	+= "					AND SD1.D1_SERIE = SF1.F1_SERIE       " + cCRLF
		cFiltraSF1	+= "					AND SD1.D_E_L_E_T_ = '  '             " + cCRLF
		cFiltraSF1	+= "					AND SC7.C7_FILIAL = SD1.D1_FILIAL     " + cCRLF
		cFiltraSF1	+= "					AND SC7.C7_NUM = SD1.D1_PEDIDO        " + cCRLF
		cFiltraSF1	+= "					AND SC7.C7_GRUPCOM = '"+_cGrupCom+"' )" + cCRLF		
	Else
	     
	      	cFiltraSF1	:= "F1_FILIAL+F1_DOC+F1_SERIE+F1_FORNECE+F1_LOJA+F1_TIPO"
	      	cFiltraSF1	+= "			IN" + cCRLF
     		cFiltraSF1	+= "			(" + cCRLF
    		cFiltraSF1	+= "				SELECT"+ cCRLF
	    	cFiltraSF1	+= "					SD1.D1_FILIAL+SD1.D1_DOC+SD1.D1_SERIE+SD1.D1_FORNECE+SD1.D1_LOJA+SD1.D1_TIPO"+cCRLF
        	cFiltraSF1	+= "				FROM                                                      " + cCRLF
			cFiltraSF1	+= "					" + RetSqlName( "SD1" ) + " SD1,                      " + cCRLF
			cFiltraSF1	+= "					" + RetSqlName( "SC7" ) + " SC7,                      " + cCRLF
			cFiltraSF1	+= "					" + RetSqlName( "SC1" ) + " SC1                       " + cCRLF
			cFiltraSF1	+= "				WHERE                                                     " + cCRLF
			cFiltraSF1	+= "					SD1.D_E_L_E_T_ = ' '                                  " + cCRLF	
			cFiltraSF1	+= "					AND SC7.C7_FILIAL = SD1.D1_FILIAL                     " + cCRLF
			cFiltraSF1	+= "					AND SC7.C7_NUM = SD1.D1_PEDIDO                        " + cCRLF 
			cFiltraSF1	+= "					AND SC7.D_E_L_E_T_ = ' '                              " + cCRLF	
			cFiltraSF1	+= "					AND SC1.C1_NUM   = SC7.C7_NUMSC                       " + cCRLF
   			cFiltraSF1	+= "					AND SC1.C1_USER   = '"+ALLTRIM(__CUSERID)+"'          " + cCRLF
   			cFiltraSF1	+= "					AND SC1.D_E_L_E_T_ = ' '                              " + cCRLF	   			
   			cFiltraSF1	+= "					GROUP BY SD1.D1_FILIAL,SD1.D1_DOC,SD1.D1_SERIE,SD1.D1_FORNECE,SD1.D1_LOJA,SD1.D1_TIPO )" + cCRLF		      
	
	Endif	
Endif
return (cFiltraSF1)
