#INCLUDE "rwmake.ch"    
#include "topconn.ch"
#include "protheus.ch"

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³CT102CARR  º Autor ³ Patricia Fontaneziº Data ³  21/08/12   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDescricao ³  Ponto de Entrada para alterar o Historico gerado na tela  º±±
±±º          ³  Lancamento Automatico                                     º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ CIEE                                                       º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß*/


USER FUNCTION CT102CARR()

Local CLOTEGER      := (CLOTE+CSUBLOTE+CDOC)
Local CLOTECT2      := (CT2->CT2_LOTE+CT2->CT2_SBLOTE+CT2->CT2_DOC)
Local _nHist		:= VAL(TMP->CT2_LINHA)

IF CLOTEGER <> CLOTECT2 
	If SUBSTR(TMP->CT2_HIST,1,7) == "ESTORNO"          //Nesse momento eh identificado se o botão ESTORNO foi selecionado.
		TMP->CT2_HIST	:= "ESTORNO " + CT2->CT2_HIST
		
		_cQuery:= " "
		_cQuery:= "SELECT * FROM "+RetSqlName("CT2")+" "
		_cQuery+= "WHERE CT2_DATA = '"+DTOS(CT2->CT2_DATA)+"' "
		_cQuery+= "AND CT2_LOTE = '"+CT2->CT2_LOTE+"' "
		_cQuery+= "AND CT2_DOC = '"+CT2->CT2_DOC+"' "
		_cQuery+= "AND CT2_SEQLAN = '"+TMP->CT2_SEQLAN+"' "
		_cQuery+= "AND CT2_DC = '4' "
		_cQuery+= "ORDER BY CT2_DATA, CT2_LOTE, CT2_SBLOTE, CT2_DOC, CT2_LINHA "
		_cQuery := ChangeQuery(_cQuery)
		dbUseArea(.T.,"TOPCONN",TcGenQry(,,_cQuery),'TRBCT2',.T.,.T.)
		DbSelectarea("TRBCT2")
		TRBCT2->(dbGoTop())

		Do While !EOF()
			_nHist++
			RECLOCK("TMP",.T.)
			TMP->CT2_FILIAL		:= xFilial("CT2")
//			TMP->CT2_DATA		:= 
			TMP->CT2_LOTE		:= CLOTE
			TMP->CT2_SBLOTE		:= CSUBLOTE
			TMP->CT2_DOC		:= CDOC
			TMP->CT2_LINHA		:= STRZERO(_nHist,3)
			TMP->CT2_DC			:= "4"
			TMP->CT2_HIST		:= TRBCT2->CT2_HIST
			TMP->CT2_EMPORI		:= TRBCT2->CT2_EMPORI
			TMP->CT2_FILORI		:= TRBCT2->CT2_FILORI
			TMP->CT2_TPSALD		:= TRBCT2->CT2_TPSALD
			TMP->CT2_SEQHIS		:= TRBCT2->CT2_SEQHIS
			TMP->CT2_SEQLAN		:= TRBCT2->CT2_SEQLAN
			TMP->CT2_MOEDLC		:= TRBCT2->CT2_MOEDLC
			MSUNLOCK()
			DbSelectarea("TRBCT2")
			TRBCT2->(DbSkip())
		EndDo

		DbSelectarea("TRBCT2")
		TRBCT2->(DbCloseArea())
	ENDIF
ELSE
	If SUBSTR(TMP->CT2_HIST,1,7) == "ESTORNO"          //Nesse momento eh identificado se o botão ESTORNO foi selecionado.  
		TMP->CT2_HIST	:= CT2->CT2_HIST 
	Endif 
ENDIF

RETURN(.T.)