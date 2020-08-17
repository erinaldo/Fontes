#INCLUDE 'Protheus.ch'

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³MontaAlc  ºAutor  ³Lucas Riva Tsuda    º Data ³  10/29/14   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³Valida as regras para geração da alçada e retorna o grupo   º±±
±±º          ³de aprovadores (SAL)                                        º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³Especifico GJP                                              º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±   
±±ºParametros³[1]_cFilial = Filial                                        º±±
±±º          ³[2]_aItens [2][1] Produto     							  º±±
±±º          ³[2]_aItens [2][2] Centro de Custo							  º±±
±±º          ³[2]_aItens [2][3] Numero da SC ou do PC                     º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±   
±±ºRetorno   ³[1]aRet													  º±±
±±º			 ³[1][1]_cRet = 1-Alçada Ok | 2-Falta Regra |3-Regra Inconsistº±±
±±º          ³[1][2]_cGrupo = Grupo de Aprovação                          º±±
±±º          ³[1][3]_aSemAlc = Array com informações da(s) regra(s) não   º±±
±±º          ³                 cadastradas                                º±±
±±º          ³[1][3][1] = Estocavel                                       º±±
±±º          ³[1][3][2] = Grupo                                           º±±
±±º          ³[1][3][3] = Centro de Custo                                 º±±
±±º          ³[1][4]_aDiver = Array com informações das regras conflitan- º±±
±±º          ³                tes dentro dos itens da SC ou PC            º±±
±±º          ³[1][4][1] = Grupo de Aprovação 		                      º±±
±±º          ³[1][4][2] = Numero da SC ou do PC	                          º±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

User Function MontaAlc(_cFilial,_aItens)
      
Local aArea     := GetArea()
Local aAreaSC7  := SC7->(GetArea())    
Local aAreaSB1  := SB1->(GetArea())   
Local aEstrut 	:= {}//SC7->(dbStruct())
Local cNomArqTrb:= ""
Local cAliasTRB := GetNextAlias()
Local aAlcada   := {} 
Local aSemAlc   := {}   
Local aDiver	:= {}
Local cRet      := "1"  //1-Alçada Ok || 2-Falta regra cadastrada || 3-Regra inconsistente
Local aRet      := {}   
   
Local cGrupo    := ""    
                                   
AADD(aEstrut,{"FILIAL","C",TamSX3("C7_FILIAL")[1],0})
AADD(aEstrut,{"NUMERO","C",6,0})
AADD(aEstrut,{"CC","C",TamSX3("C7_CC")[1],0})                     
AADD(aEstrut,{"GRUPO","C",TamSX3("B1_GRUPO")[1],0})
AADD(aEstrut,{"ESTOCAV","C",1,0})

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Cria o arquivo temporario ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
cNomArqTRB := CriaTrab( aEstrut, .T. )
dbUseArea( .T.,,cNomArqTRB, cAliasTRB, .F., .F. )

IndRegua( cAliasTRB, cNomArqTRB,"FILIAL+NUMERO+ESTOCAV+GRUPO+CC",,,"Criando Indice, aguarde..." )
dbClearIndex()
dbSetIndex( cNomArqTRB + OrdBagExt() )   

For _nY := 1 To Len(_aItens)
	
	RecLock(cAliasTRB,.T.)
	(cAliasTRB)->FILIAL    := _cFilial
	(cAliasTRB)->NUMERO    := _aItens[_nY][3]
	(cAliasTRB)->ESTOCAV   := Posicione("SB1",1,xFilial("SB1")+_aItens[_nY][1],"B1_XESTOCA")
	(cAliasTRB)->GRUPO	   := Posicione("SB1",1,xFilial("SB1")+_aItens[_nY][1],"B1_GRUPO")
	(cAliasTRB)->CC        := _aItens[_nY][2]
	
	(cAliasTRB)->(MsUnlock())
	
Next

DbSelectArea(cAliasTRB)
(cAliasTRB)->(DbGoTop())
While (cAliasTRB)->(!EOF())
	
	SZ0->(DbSetOrder(1))
	
	If SZ0->(MsSeek((cAliasTRB)->(FILIAL+ESTOCAV)))
		//||1ª Validação|| Se é estocavel
		
		If SZ0->(MsSeek((cAliasTRB)->(FILIAL+ESTOCAV+GRUPO)))
			//||2ª Validação|| Existe regra específica por grupo de produto
			
			If SZ0->(MsSeek((cAliasTRB)->(FILIAL+ESTOCAV+GRUPO+CC)))
				//||3ª Validação||  Existe regra específica por grupo de produto e centro de custo
				
				AADD(aAlcada,{SZ0->Z0_GAPROV, (cAliasTRB)->NUMERO})
				
			ElseIf SZ0->(MsSeek((cAliasTRB)->(FILIAL+ESTOCAV+GRUPO+Padr('*',TamSx3("B1_CC")[1]))))
				//||3ª Validação|| Regra específica somente por grupo de produto
				
				AADD(aAlcada,{SZ0->Z0_GAPROV, (cAliasTRB)->NUMERO})
							
			Else
				//Regra não cadastrada
				// Incluído por Carlos Queiroz em 18/04/16 conforme nova orientação de envio para alçada quando tiver item estocável, grupo e o CC não estar cadastrado.
				AADD(aAlcada,{SZ0->Z0_GAPROV, (cAliasTRB)->NUMERO})
//				AADD(aSemAlc,{(cAliasTRB)->ESTOCAV, (cAliasTRB)->GRUPO, (cAliasTRB)->CC}) // alterado por Carlos Queiroz em 18/04/16
				
			EndIf
			
			
		ElseIf SZ0->(MsSeek((cAliasTRB)->(FILIAL+ESTOCAV+Padr('*',TamSx3("B1_GRUPO")[1]))))
			//||2ª Validação|| Não existe regra específica por grupo de produto
			
			If SZ0->(MsSeek((cAliasTRB)->(FILIAL+ESTOCAV+Padr('*',TamSx3("B1_GRUPO")[1])+CC)))
				//||3ª Validação|| Não Existe regra específica por grupo de produto mas possui especifica por centro de custo
				
				AADD(aAlcada,{SZ0->Z0_GAPROV, (cAliasTRB)->NUMERO})
				
			ElseIf SZ0->(MsSeek((cAliasTRB)->(FILIAL+ESTOCAV+Padr('*',TamSx3("B1_GRUPO")[1])+Padr('*',TamSx3("B1_CC")[1]))))
				//||3ª Validação|| Regra genérica
				
				AADD(aAlcada,{SZ0->Z0_GAPROV, (cAliasTRB)->NUMERO})
				
			Else
				//Regra não cadastrada
				
				AADD(aSemAlc,{(cAliasTRB)->ESTOCAV, (cAliasTRB)->GRUPO, (cAliasTRB)->CC})
				
			EndIf
			
		EndIf
		
	Else
		//||1ª Validação|| Se é estocavel
		
		If SZ0->(MsSeek((cAliasTRB)->(FILIAL+ESTOCAV+GRUPO)))
			//||2ª Validação|| Existe regra específica por grupo de produto
			
			If SZ0->(MsSeek((cAliasTRB)->(FILIAL+ESTOCAV+GRUPO+CC)))
				//||3ª Validação||  Existe regra específica por grupo de produto e centro de custo
				
				AADD(aAlcada,{SZ0->Z0_GAPROV, (cAliasTRB)->NUMERO})
				
			ElseIf SZ0->(MsSeek((cAliasTRB)->(FILIAL+ESTOCAV+GRUPO+Padr('*',TamSx3("B1_CC")[1]))))
				//||3ª Validação|| Regra específica somente por grupo de produto
				
				AADD(aAlcada,{SZ0->Z0_GAPROV, (cAliasTRB)->NUMERO})
				
			Else
				//Regra não cadastrada
				
				AADD(aSemAlc,{(cAliasTRB)->ESTOCAV, (cAliasTRB)->GRUPO, (cAliasTRB)->CC})
				
			EndIf
			
			
		ElseIf SZ0->(MsSeek((cAliasTRB)->(FILIAL+ESTOCAV+Padr('*',TamSx3("B1_GRUPO")[1]))))
			//||2ª Validação|| Não existe regra específica por grupo de produto
			
			If SZ0->(MsSeek((cAliasTRB)->(FILIAL+ESTOCAV+Padr('*',TamSx3("B1_GRUPO")[1])+CC)))
				//||3ª Validação|| Não Existe regra específica por grupo de produto mas possui especifica por centro de custo
				
				AADD(aAlcada,{SZ0->Z0_GAPROV, (cAliasTRB)->NUMERO})
				
			ElseIf SZ0->(MsSeek((cAliasTRB)->(FILIAL+ESTOCAV+Padr('*',TamSx3("B1_GRUPO")[1])+Padr('*',TamSx3("B1_CC")[1]))))
				//||3ª Validação|| Regra genérica
				
				AADD(aAlcada,{SZ0->Z0_GAPROV, (cAliasTRB)->NUMERO})
				
			Else
				//Regra não cadastrada
				
				AADD(aSemAlc,{(cAliasTRB)->ESTOCAV, (cAliasTRB)->GRUPO, (cAliasTRB)->CC})
				
			EndIf
			
		Else
			AADD(aSemAlc,{(cAliasTRB)->ESTOCAV, (cAliasTRB)->GRUPO, (cAliasTRB)->CC}) // Teste cq
		EndIf
		
	EndIf
	
	(cAliasTRB)->(DbSkip())
	
EndDo

(cAliasTRB)->(DbCloseArea())

If Len(aSemAlc) > 0   
//Retorno de falta de regra cadastrada para algum dos itens

	cRet := "2"
	AADD(aRet,{cRet,/*cGrupo*/,aSemAlc,/*aDiver*/})

Else 
//Todos os itens possuem regras cadastradas

	aSort(aAlcada,,,{|x,y| x[1] < y[1]})
	For _nZ := 1 To Len(aAlcada)
	//Este laço verifica se a regra é consistente (mesmo grupo de aprovação) para todos os itens.
	
		If _nZ == 1
		
			cGrupo := aAlcada[_nZ][1]
			AADD(aDiver,{aAlcada[_nZ][1],aAlcada[_nZ][2]})
			
		Else
		     
			If cGrupo <> aAlcada[_nZ][1]
			//Existe inconsistencia
			    
				If AScan(aDiver,{|x| x[1] == aAlcada[_nZ][1]}) == 0
				 
					AADD(aDiver,{aAlcada[_nZ][1],aAlcada[_nZ][2]}) 
					cGrupo := aAlcada[_nZ][1]
					
				EndIf
			
			EndIf
		
		EndIf    
	
	Next  
	
	If Len(aDiver) > 1   
	//Retorno de regra inconsistente
	
		cRet := "3"
		AADD(aRet,{cRet,/*cGrupo*/,/*aSemAlc*/,aDiver})
	
	Else 
	//Todos os itens possuem regra, e estas, estão consistentes 
	
		AADD(aRet,{cRet,cGrupo,/*aSemAlc*/,/*aDiver*/})
	
	EndIf
	
EndIf

RestArea(aArea)                  
RestArea(aAreaSC7)                
RestArea(aAreaSB1)

Return aRet