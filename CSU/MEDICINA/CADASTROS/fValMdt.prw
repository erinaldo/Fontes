#Include 'Protheus.ch'

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³FVALMDT   º Autor ³ Isamu K.           º Data ³ 30/10/2017  º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDescricao ³ Validação dos lançamento de Atestado Médico no módulo de   º±±
±±º          ³ Medicina e Segurança  do Trabalho                          º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ Exclusivo da CSU                                           º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±                 3
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
User Function fValMdt()

Local cQry                  
Local cMatAtu := M->TNY_NUMFIC
Local cCidAtu := M->TNY_CID 
Local dDataRef:= M->TNY_DTINIC             
Local nDiasAf_:= M->TNY_QTDIAS
Local lExec_  := .T. 

dDataRef -= 59                     

cQry := " SELECT SUM(TNY_QTDIAS) AS NATEST "
cQry += " FROM "+RetSqlName("TNY")+ " "
cQry += " WHERE TNY_NUMFIC ='"+cMatAtu+"' AND "
cQry += " TNY_CID = '"+cCidAtu+"' AND "
cQry += " TNY_DTFIM  >= '"+DTOS(dDataRef)+"' "
cQry += " AND "+RETSQLNAME("TNY")+".D_E_L_E_T_ <> '*' "

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Fecha alias caso esteja aberto ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
If Select("TMY") > 0
	DBSelectArea("TMY")
	DBCloseArea()
EndIf

dbUseArea(.T.,"TOPCONN", TCGENQRY(,,cQrY),"TMY",.F.,.T.)

If Tmy->nAtest+nDiasAf_ > 15
   lExec_ := MsgNoYes("Já existem outros Atestados com o mesmo CID, dentro do prazo de 60 dias. Deseja continuar ? ")     
   If !lExec_
      Alert("Clique na opção 'FECHAR' e saia da rotina")
   Endif    
Endif   


Return(lExec_)



Return

