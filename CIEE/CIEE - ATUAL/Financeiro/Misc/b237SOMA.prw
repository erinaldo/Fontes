#include "rwmake.ch"        // incluido pelo assistente de conversao do AP6 IDE em 15/07/02

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³B237SOMA   ºAutor  ³Claudio Barros      º Data ³  04/14/05   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ Rotina para retornar o valor total dos titulo a pagar,     º±±
±±º          ³ fazendo as verificações dos decrescimos e acrecismos.      º±±
±±º          ³ Foi utilizado o campo valor devido os titulos estarem      º±±
±±º          ³ baixados. E2_VALLIQ (O padrão utiliza o E2_SALDO            º±±
±±ÈÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ Especifico CIEE - SIGAFIN - CNAB 237.CPE                   º±±
±±                                                                        º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

User Function b237SOMA()        // incluido pelo assistente de conversao do AP6 IDE em 15/07/02

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Declaracao de variaveis utilizadas no programa atraves da funcao    ³
//³ SetPrvt, que criara somente as variaveis definidas pelo usuario,    ³
//³ identificando as variaveis publicas do sistema utilizadas no codigo ³
//³ Incluido pelo assistente de conversao do AP6 IDE                    ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

Local nTOTVAL  := 0 
Local nTOTACRE := 0
Local nTOTDCRE := 0

SetPrvt("_Query,_nSoma,")  

_aArea := GetArea()  
_aAreaE2 := SE2->(GetArea())
_aAreaEA := SEA->(GetArea())

Pergunte("CIE420",.F.)

//_Query := " SELECT SUM(E2_VALOR) AS TOTVAL, SUM(E2_SDACRES) AS TOTACRE, SUM(E2_SDDECRE) AS TOTDCRE " 
/*
_Query := " SELECT E2_VALOR, E2_SDACRES, E2_SDDECRE, E5_RECPAG " 
_Query += " FROM "+RetSqlName("SE2")+" AS SE2 , "+RetSqlName("SE5")+" AS SE5 "
_Query += " WHERE SE2.D_E_L_E_T_ = ' '  AND SE2.E2_FILIAL = SE5.E5_FILIAL "
//_Query += " AND SE5.E5_RECPAG = 'P' "
_Query += " AND SE2.E2_PREFIXO = SE5.E5_PREFIXO "
_Query += " AND SE2.E2_NUM = SE5.E5_NUMERO "
_Query += " AND SE2.E2_FILIAL = '"+xFILIAL("SE2")+"' AND SE5.E5_RECONC = ' ' "
_Query += " AND SE2.E2_NUMBOR BETWEEN '"+MV_PAR01+"' AND '"+MV_PAR02+"' "  
*/

_Query := " SELECT * " 
_Query += " FROM "+RetSqlName("SE2")+" AS SE2 "
_Query += " WHERE SE2.D_E_L_E_T_ = ' '  "
_Query += " AND SE2.E2_FILIAL = '"+xFILIAL("SE2")+"' "
_Query += " AND SE2.E2_NUMBOR BETWEEN '"+MV_PAR01+"' AND '"+MV_PAR02+"' "  
_Query := ChangeQuery(_Query)
dbUseArea(.T.,"TOPCONN",TcGenQry(,,_Query),'TRB',.T.,.T.)


DbSelectarea("TRB")
TRB->(dbGoTop())
                                                                         
While !TRB->(EOF())
    DBSELECTAREA("SE5")
    SE5->(DBSETORDER(7))
    IF SE5->(DBSEEK(xFILIAL("SE5")+TRB->E2_PREFIXO+TRB->E2_PARCELA+TRB->E2_TIPO+TRB->E2_FORNECE+TRB->E2_LOJA))
	    IF SE5->E5_RECONC <> " "
    	   TRB->(DBSKIP())
      	 LOOP
    	ENDIF 
    ENDIF
    nTOTVAL  += TRB->E2_VALLIQ 
//    nTOTACRE += TRB->E2_ACRESC
//    nTOTDCRE += TRB->E2_DECRESC
    TRB->(DBSKIP())
END       


//_nSoma :=  StrZero((((TRB->TOTVAL+TRB->TOTACRE)-TOTDCRE)*100),17)  
//_nSoma :=  StrZero((((nTOTVAL+nTOTACRE)-nTOTDCRE)*100),17)  
_nSoma :=  StrZero((nTOTVAL*100),17)  


If Select("TRB") > 0
   TRB->(DbCloseArea())
Endif

SEA->(RestArea(_aAreaEA))
SE2->(RestArea(_aAreaE2))
RestArea(_aArea)

// Substituido pelo assistente de conversao do AP6 IDE em 15/07/02 ==> __Return(_Valor)
Return(_nSoma)        // incluido pelo assistente de conversao do AP6 IDE em 15/07/02
