#INCLUDE 'Protheus.ch'

/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �MontaAlc  �Autor  �Lucas Riva Tsuda    � Data �  10/29/14   ���
�������������������������������������������������������������������������͹��
���Desc.     �Valida as regras para gera��o da al�ada e retorna o grupo   ���
���          �de aprovadores (SAL)                                        ���
�������������������������������������������������������������������������͹��
���Uso       �Especifico GJP                                              ���
�������������������������������������������������������������������������ͼ��   
���Parametros�[1]_cFilial = Filial                                        ���
���          �[2]_aItens [2][1] Produto     							  ���
���          �[2]_aItens [2][2] Centro de Custo							  ���
���          �[2]_aItens [2][3] Numero da SC ou do PC                     ���
�������������������������������������������������������������������������ͼ��   
���Retorno   �[1]aRet													  ���
���			 �[1][1]_cRet = 1-Al�ada Ok | 2-Falta Regra |3-Regra Inconsist���
���          �[1][2]_cGrupo = Grupo de Aprova��o                          ���
���          �[1][3]_aSemAlc = Array com informa��es da(s) regra(s) n�o   ���
���          �                 cadastradas                                ���
���          �[1][3][1] = Estocavel                                       ���
���          �[1][3][2] = Grupo                                           ���
���          �[1][3][3] = Centro de Custo                                 ���
���          �[1][4]_aDiver = Array com informa��es das regras conflitan- ���
���          �                tes dentro dos itens da SC ou PC            ���
���          �[1][4][1] = Grupo de Aprova��o 		                      ���
���          �[1][4][2] = Numero da SC ou do PC	                          ���
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
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
Local cRet      := "1"  //1-Al�ada Ok || 2-Falta regra cadastrada || 3-Regra inconsistente
Local aRet      := {}   
   
Local cGrupo    := ""    
                                   
AADD(aEstrut,{"FILIAL","C",TamSX3("C7_FILIAL")[1],0})
AADD(aEstrut,{"NUMERO","C",6,0})
AADD(aEstrut,{"CC","C",TamSX3("C7_CC")[1],0})                     
AADD(aEstrut,{"GRUPO","C",TamSX3("B1_GRUPO")[1],0})
AADD(aEstrut,{"ESTOCAV","C",1,0})

//���������������������������Ŀ
//� Cria o arquivo temporario �
//�����������������������������
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
		//||1� Valida��o|| Se � estocavel
		
		If SZ0->(MsSeek((cAliasTRB)->(FILIAL+ESTOCAV+GRUPO)))
			//||2� Valida��o|| Existe regra espec�fica por grupo de produto
			
			If SZ0->(MsSeek((cAliasTRB)->(FILIAL+ESTOCAV+GRUPO+CC)))
				//||3� Valida��o||  Existe regra espec�fica por grupo de produto e centro de custo
				
				AADD(aAlcada,{SZ0->Z0_GAPROV, (cAliasTRB)->NUMERO})
				
			ElseIf SZ0->(MsSeek((cAliasTRB)->(FILIAL+ESTOCAV+GRUPO+Padr('*',TamSx3("B1_CC")[1]))))
				//||3� Valida��o|| Regra espec�fica somente por grupo de produto
				
				AADD(aAlcada,{SZ0->Z0_GAPROV, (cAliasTRB)->NUMERO})
							
			Else
				//Regra n�o cadastrada
				// Inclu�do por Carlos Queiroz em 18/04/16 conforme nova orienta��o de envio para al�ada quando tiver item estoc�vel, grupo e o CC n�o estar cadastrado.
				AADD(aAlcada,{SZ0->Z0_GAPROV, (cAliasTRB)->NUMERO})
//				AADD(aSemAlc,{(cAliasTRB)->ESTOCAV, (cAliasTRB)->GRUPO, (cAliasTRB)->CC}) // alterado por Carlos Queiroz em 18/04/16
				
			EndIf
			
			
		ElseIf SZ0->(MsSeek((cAliasTRB)->(FILIAL+ESTOCAV+Padr('*',TamSx3("B1_GRUPO")[1]))))
			//||2� Valida��o|| N�o existe regra espec�fica por grupo de produto
			
			If SZ0->(MsSeek((cAliasTRB)->(FILIAL+ESTOCAV+Padr('*',TamSx3("B1_GRUPO")[1])+CC)))
				//||3� Valida��o|| N�o Existe regra espec�fica por grupo de produto mas possui especifica por centro de custo
				
				AADD(aAlcada,{SZ0->Z0_GAPROV, (cAliasTRB)->NUMERO})
				
			ElseIf SZ0->(MsSeek((cAliasTRB)->(FILIAL+ESTOCAV+Padr('*',TamSx3("B1_GRUPO")[1])+Padr('*',TamSx3("B1_CC")[1]))))
				//||3� Valida��o|| Regra gen�rica
				
				AADD(aAlcada,{SZ0->Z0_GAPROV, (cAliasTRB)->NUMERO})
				
			Else
				//Regra n�o cadastrada
				
				AADD(aSemAlc,{(cAliasTRB)->ESTOCAV, (cAliasTRB)->GRUPO, (cAliasTRB)->CC})
				
			EndIf
			
		EndIf
		
	Else
		//||1� Valida��o|| Se � estocavel
		
		If SZ0->(MsSeek((cAliasTRB)->(FILIAL+ESTOCAV+GRUPO)))
			//||2� Valida��o|| Existe regra espec�fica por grupo de produto
			
			If SZ0->(MsSeek((cAliasTRB)->(FILIAL+ESTOCAV+GRUPO+CC)))
				//||3� Valida��o||  Existe regra espec�fica por grupo de produto e centro de custo
				
				AADD(aAlcada,{SZ0->Z0_GAPROV, (cAliasTRB)->NUMERO})
				
			ElseIf SZ0->(MsSeek((cAliasTRB)->(FILIAL+ESTOCAV+GRUPO+Padr('*',TamSx3("B1_CC")[1]))))
				//||3� Valida��o|| Regra espec�fica somente por grupo de produto
				
				AADD(aAlcada,{SZ0->Z0_GAPROV, (cAliasTRB)->NUMERO})
				
			Else
				//Regra n�o cadastrada
				
				AADD(aSemAlc,{(cAliasTRB)->ESTOCAV, (cAliasTRB)->GRUPO, (cAliasTRB)->CC})
				
			EndIf
			
			
		ElseIf SZ0->(MsSeek((cAliasTRB)->(FILIAL+ESTOCAV+Padr('*',TamSx3("B1_GRUPO")[1]))))
			//||2� Valida��o|| N�o existe regra espec�fica por grupo de produto
			
			If SZ0->(MsSeek((cAliasTRB)->(FILIAL+ESTOCAV+Padr('*',TamSx3("B1_GRUPO")[1])+CC)))
				//||3� Valida��o|| N�o Existe regra espec�fica por grupo de produto mas possui especifica por centro de custo
				
				AADD(aAlcada,{SZ0->Z0_GAPROV, (cAliasTRB)->NUMERO})
				
			ElseIf SZ0->(MsSeek((cAliasTRB)->(FILIAL+ESTOCAV+Padr('*',TamSx3("B1_GRUPO")[1])+Padr('*',TamSx3("B1_CC")[1]))))
				//||3� Valida��o|| Regra gen�rica
				
				AADD(aAlcada,{SZ0->Z0_GAPROV, (cAliasTRB)->NUMERO})
				
			Else
				//Regra n�o cadastrada
				
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
	//Este la�o verifica se a regra � consistente (mesmo grupo de aprova��o) para todos os itens.
	
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
	//Todos os itens possuem regra, e estas, est�o consistentes 
	
		AADD(aRet,{cRet,cGrupo,/*aSemAlc*/,/*aDiver*/})
	
	EndIf
	
EndIf

RestArea(aArea)                  
RestArea(aAreaSC7)                
RestArea(aAreaSB1)

Return aRet