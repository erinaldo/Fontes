#Include 'Protheus.ch'

/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �GFINA01   �Autor  �Lucas Riva Tsuda    � Data �  12/04/14   ���
�������������������������������������������������������������������������͹��
���Desc.     �Seleciona comiss�es para baixar, gerar contas a pagar e,    ���
���          �para os casos onde o cliente ret�m comiss�o, faz automatica-���
���          �mente a compensa��o entre carteiras						  ���
�������������������������������������������������������������������������͹��
���Uso       �Especifico GJP                                              ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/

User Function GFINA01
      
Local aArea    := GetArea()
Local aAreaSE3 := SE3->(GetArea())  
Local aCpos    := {}
Local aCampos  := {}

Private aRotina     := {}
Private cMarca      := ""
Private cCadastro   := OemToAnsi("Controle de Comiss�es")

//+----------------------------------------------------------------------------
//| Atribui as variaveis de funcionalidades
//+----------------------------------------------------------------------------
aAdd( aRotina ,{"Pesquisar"  ,"AxPesqui()"   ,0,1})
aAdd( aRotina ,{"Baixar"	 ,"u_baixaE3(cMarca)",0,3})
aAdd( aRotina ,{"Legenda"   ,"u_xLegend()"  ,0,4})

//+----------------------------------------------------------------------------
//| Atribui as variaveis os campos que aparecerao no mBrowse()
//+----------------------------------------------------------------------------
aCpos := {"E3_XOK","E3_VEND","E3_SERIE","E3_NUM","E3_EMISSAO","E3_CODCLI","E3_LOJA","E3_BASE","E3_PORC","E3_COMIS","E3_DATA","E3_PREFIXO"}

dbSelectArea("SX3")
dbSetOrder(2)
For nI := 1 To Len(aCpos)
   dbSeek(aCpos[nI])
   aAdd(aCampos,{X3_CAMPO,"",Iif(nI==1,"",Trim(X3_TITULO)),Trim(X3_PICTURE)})
Next

//+----------------------------------------------------------------------------
//| Apresenta o MarkBrowse para o usuario
//+----------------------------------------------------------------------------
cMarca := GetMark()
MarkBrow("SE3","E3_XOK","SE3->E3_DATA",aCampos,,cMarca,'U_AtuMark()',,,,"u_MarcaBox()")

RestArea(aArea)
RestArea(aAreaSE3)

Return     


/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �MARCABOX   �Autor  �Lucas Riva Tsuda   � Data �  12/04/14   ���
�������������������������������������������������������������������������͹��
���Desc.     �Marca o box com duplo click  							      ���
���          �                                                            ���
�������������������������������������������������������������������������͹��
���Uso       �Especifico GJP					                          ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/

User Function MarcaBox()

If IsMark("E3_XOK",cMarca )

	RecLock("SE3",.F.)
    SE3->E3_XOK := Space(2)
    MsUnLock()
    
Else

	RecLock("SE3",.F.)
    SE3->E3_XOK := cMarca
    MsUnLock()
	    
EndIf

Return .T.         

/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �AtuMark   �Autor  �Lucas Riva Tsuda    � Data �  12/04/14   ���
�������������������������������������������������������������������������͹��
���Desc.     �Atualiza Markbrowse				                          ���
���          �                										      ���
�������������������������������������������������������������������������͹��
���Uso       �Especifico GJP						                      ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/

User Function AtuMark()

MarkBRefresh()
              
Return 

/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �xLegenda  �Autor  �Lucas Riva Tsuda    � Data �  12/04/14   ���
�������������������������������������������������������������������������͹��
���Desc.     �Legenda das Comiss�es	                                      ���
���          �                                                            ���
�������������������������������������������������������������������������͹��
���Uso       �Especifico GJP						                      ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/

User Function xLegend()
Local aCor := {}

aAdd(aCor,{"BR_VERDE"   ,"Comiss�o em aberto"})
aAdd(aCor,{"BR_VERMELHO","Comiss�o Baixada"})

BrwLegenda(cCadastro,OemToAnsi("Status"),aCor)

Return    


/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �BaixaE3   �Autor  �Lucas Riva Tsuda    � Data �  12/04/14   ���
�������������������������������������������������������������������������͹��
���Desc.     �Rotina que efetua a baixa das comiss�es, gera o titulo a    ���
���          �pagar e faz a compensa��o entre carteiras                   ���
�������������������������������������������������������������������������͹��
���Uso       �Especifico GJP						                      ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/

User Function BaixaE3(cMark)   

Local aArea       := GetArea()
Local aAreaSE3    := SE3->(GetArea())  
Local aAreaSA1    := SA1->(GetArea())          
Local aAreaSA2	  := SA2->(GetArea())
Local aAreaSA3	  := SA3->(GetArea())
Local aAreaSE1	  := SE1->(GetArea())
Local aAreaSE2	  := SE2->(GetArea())
Local cAlias  	  := GetNextAlias()  
Local aFINA050    := {}   
Local aFINA450 	  := {}    
Local cPrefixo	  := ""
Local cNumNF      := ""
Local cTipo       := ""
Local cCliente    := ""
Local cLoja       := ""      
Local cMsg1       := ""   
Local cMsg2		  := ""   
Local cMsg3       := ""    
Local lRetCom	  := .T.   
//Local cUltParc    := ""

 
Private lMsErroAuto := .F.
                                              
cQuery := "SELECT * FROM " + RetSqlName("SE3")
cQuery += " WHERE E3_XOK = '" + cMark + "' AND D_E_L_E_T_ <> '*'"
cQuery += " ORDER BY E3_VEND"
cQuery := ChangeQuery(cQuery)        

dbUseArea( .T., "TOPCONN", TCGENQRY(,,cQuery),cAlias, .T., .F.)  

DbSelectArea(cAlias)
(cAlias)->(dbGotop()) 
While (cAlias)->(!EOF())   

	cPrefixo	:= (cAlias)->E3_SERIE
	cNumNF      := (cAlias)->E3_NUM  
	cParcela    := GetMv("MV_1DUP")
	cTipo       := (cAlias)->E3_TIPO
	cCliente    := (cAlias)->E3_CODCLI
	cLoja       := (cAlias)->E3_LOJA    
	
	lRetCom := .T.                  
	
	SE3->(DbSetOrder(2))
	SE3->(MsSeek((cAlias)->(E3_FILIAL+E3_VEND+E3_PREFIXO+E3_NUM+E3_PARCELA))) //Posiciona no SE3 de acordo com atual item da query

	SA1->(DbSetOrder(1))
	If SA1->(MsSeek(xFilial("SA1")+(cAlias)->(E3_CODCLI+E3_LOJA)))   
	
		If SA1->A1_XRETCOM == "2"  //Se cliente n�o retem comiss�o, n�o executa a compensa��o entre carteiras (FINA450)
		
			lRetCom := .F.
			
		EndIf
		
	EndIf

	SA3->(dbSetOrder(1))
	If SA3->(MsSeek(xFilial("SA3")+(cAlias)->E3_VEND))
	 
		//��������������������������������������������������������������Ŀ
		//� Pagamento de Comissao para Representantes PJ                 �
		//����������������������������������������������������������������
		If SA3->A3_GERASE2 == "S"
			//��������������������������������������������������������������Ŀ
			//� Identifica o fornecedor                                      �
			//����������������������������������������������������������������
			SA2->(dbSetOrder(1))
			If SA2->(MsSeek(xFilial("SA2")+SA3->A3_FORNECE+SA3->A3_LOJA))    
			    /*
				cUltParc   := TamParcela("E2_PARCELA","Z","ZZ","ZZZ")

				SE2->(dbSetOrder(1))
				MsSeek(xFilial("SE2")+cPrefixo+cNumNF+cParcela,.F.)
				While ( SE2->(Found()) )
					If ( cParcela == cUltParc )
						cParcela := GetMv("MV_1DUP")
						cNumero  := Soma1(cNumero,Len(SE2->E2_NUM))
					Else
						cParcela	:= Soma1(cParcela,Len(SE2->E2_PARCELA))
					EndIf
					MsSeek(xFilial("SE2")+cPrefixo+cNumero+cParcela,.F.)
				EndDo   
				*/   
				
				Begin Transaction 
							
				aFINA050 := {{"E2_PREFIXO",cPrefixo,Nil},;																	
							 {"E2_NUM",Padr( Alltrim((cAlias)->E3_NUM), TamSX3("E2_NUM")[1] ),Nil},;   //VERIFICAR   
							 {"E2_PARCELA",cParcela,Nil},;
							 {"E2_TIPO","DP ",Nil},; 
							 {"E2_FORNECE",SA2->A2_COD,Nil},;
							 {"E2_LOJA",SA2->A2_LOJA,Nil},;  
							 {"E2_NOMFOR",SA2->A2_NREDUZ,Nil},;
                             {"E2_VALOR",Abs((cAlias)->E3_COMIS),Nil},;     
                             {"E2_EMISSAO",dDataBase,Nil},;
                             {"E2_VENCTO",dDataBase,Nil},;	//Gera com a mesma data base, pois j� ser� baixado na sequencia
                             {"E2_VENCREA",DataValida(dDataBase,.T.),Nil},;     
                             {"E2_NATUREZ",SA2->A2_NATUREZ,Nil},;
                             {"E2_ORIGEM","GFINA01",Nil},;
				             {"E2_MOEDA",1,Nil},;   
				             {"E2_RATEIO","N",Nil},;  
				             {"E2_FLUXO","N",Nil}}		//Desconsidera para fluxo de caixa
						
                //Gera titulo a pagar
				MsExecAuto( { |x,y,z| FINA050(x,y,z)}, aFINA050,, 3)  
  
				If lMsErroAuto  
				
					cMsg1 := "N�o foi poss�vel baixar a comiss�o "+(cAlias)->E3_NUM+". Existem inconsist�ncias nos dados da integra��o."
				                         
					Aviso("Inconsistencia",cMsg1,{"Ok"},2)
			    	MostraErro() 
			    	DisarmTransaction()  
			    	
				Else         
				    
				    //Baixa Comiss�o
					RecLock("SE3",.F.)        
					SE3->E3_DATA := SE3->E3_VENCTO
					If FieldPos("E3_PROCCOM") > 0																		
						SE3->E3_PROCCOM := xFilial() + cPrefixo + cNumNF + cParcela
					Endif	
					SE3->(MsUnlock()) 
					
					If lRetCom	 
					
						aFINA450 := { {"AUTDVENINI450", dDataBase , nil},;
	  								{"AUTDVENFIM450", dDataBase + 90 , nil},;
				    				{"AUTNLIM450" , 999999999 , nil},;
	  								{"AUTCCLI450" , cCliente , nil},;
	  								{"AUTCLJCLI" , cLoja , nil},;
	  								{"AUTCFOR450" , SA2->A2_COD , nil},;
	  								{"AUTCLJFOR" , SA2->A2_LOJA , nil},;
	  								{"AUTCMOEDA450" , "01" , nil},; 
	  								{"AUTNDEBCRED" , 1 , nil},;
	  								{"AUTLTITFUTURO", .F. , nil},;
	  								{"AUTARECCHAVE" , {} , nil},;
	  								{"AUTAPAGCHAVE" , {} , nil}}
	  					
	  					//Localiza Titulos a Receber que ser�o compensados
	  					SE1->(dbSetOrder(2))
						If SE1->(MsSeek(xFilial("SE1")+cCliente+cLoja+cPrefixo+cNumNF)) 
						
							While SE1->(!EOF()) .And. SE1->(E1_FILIAL+E1_CLIENTE+E1_LOJA+E1_PREFIXO+E1_NUM) == xFilial("SE1")+cCliente+cLoja+cPrefixo+cNumNF
							                  
								AAdd(aFINA450[11,2], {xFilial("SE1")+SE1->(E1_PREFIXO+E1_NUM+E1_PARCELA+E1_TIPO)}) 
							     
								SE1->(DbSkip())
							
						 	EndDo				
					            
						EndIf   
						
						//Ja est� posicionado no SE2 que acabou de ser gerado
						AAdd( aFINA450[12,2], {SE2->(E2_FILIAL+E2_PREFIXO+E2_NUM+E2_PARCELA+E2_TIPO+E2_FORNECE+E2_LOJA)})
						
						//Faz a compensa��o entre carteiras
						MSExecAuto({|x,y,z| Fina450(x,y,z)}, nil , aFINA450 , 3 )
	 	 				
	 	 				If lMsErroAuto
						
							cMsg2 := "N�o foi poss�vel compensar a comiss�o "+(cAlias)->E3_NUM+" com o t�tulo a receber "+Alltrim(cPrefixo)+"/"
							cMsg2 += cNumNF+" do cliente "+SA1->A1_NOME
					                         
							Aviso("Inconsistencia",cMsg2,{"Ok"},3)
				    		MostraErro() 
				    		DisarmTransaction()  
	
	  					EndIf
					    
					Endif    
				
				EndIf
				
				End Transaction 
					
			Else
				
				cMsg3 := "N�o existe fornecedor vinculado ao cadastro de vendedor para a comiss�o "+(cAlias)->E3_NUM       
				Aviso("Inconsistencia",cMsg3,{"Ok"},2)

			EndIf
		Else
			msginfo("Baixa n�o executada decorrente do campo 'gerar SE2 (A3_GERASE2) est� com conte�do igual a n�o, verificar o cadastro do vendedor "+alltrim((cAlias)->E3_VEND)+" para que a baixa da comiss�o possa ser efetuada.")		
        EndIf
    
    EndIf
     
	(cAlias)->(DbSkip())

EndDo      

RestArea(aArea)
RestArea(aAreaSE3) 
RestArea(aAreaSA1)
RestArea(aAreaSA2)
RestArea(aAreaSA3)
RestArea(aAreaSE1)
RestArea(aAreaSE2)

Return   