#INCLUDE "PROTHEUS.CH"

///////////////////////////////////////////////////////////////////////////////\\
//+--------------------------------------------------------------------------- \\
//| Função     : CN200VLPLA.PRW    		                                       \\
//+--------------------------------------------------------------------------- \\
//| Autor      : TOTVS	                                                       \\
//+--------------------------------------------------------------------------- \\
//| Data       : Dezembro - 2013                                               \\
//+--------------------------------------------------------------------------- \\
//| Descricao  : Ponto Entrada executado na VALIDACAO do TudoOk da cabecalho   \\
//| 		   : da planilha do contrato									   \\	
//+--------------------------------------------------------------------------- \\
//| Cliente    : TEZBIV - FIESP 										       \\
//+--------------------------------------------------------------------------- \\
//| Observacoes:                                                               \\
//+--------------------------------------------------------------------------- \\
//| Alterações :                                                               \\
//+--------------------------------------------------------------------------- \\
///////////////////////////////////////////////////////////////////////////////\\

User Function CN200VLPLA()
Local aArea		:= GetArea()
Local lRet		:= .T.          
Local oGetDad	:= ParamIXB[1]
Local nX    

Local nPosIT  := AScan(oGetDad:aHeader,{|x| AllTrim(x[2]) == "CNB_ITEMCT" })
Local nPosCta := AScan(oGetDad:aHeader,{|x| AllTrim(x[2]) == "CNB_CONTA" })
Local nPosCC  := AScan(oGetDad:aHeader,{|x| AllTrim(x[2]) == "CNB_CC" })

For nX := 1 To Len(acols)
	If !GDDeleted( nX, aHeader, aCols )
		IF EMPTY( Acols[nX][GdFieldPos("CNB_XNUM")] )	
			IF EMPTY( oGetDad:aCols[nX,nPosIT] ) .OR. EMPTY(oGetDad:aCols[nX,nPosCta]) .OR. EMPTY(oGetDad:aCols[nX,nPosCC])
				Aviso("Campos Obrigatórios","Os campos (Item Conta, Conta Contab. e C.Custo) são obrigatórios."+Chr(13)+Chr(10),{"Sair"},3)
				lRet:=.F.  				
			ENDIF
        ENDIF
    ENDIF
Next nX

RestArea(aArea)
	
Return lRet

