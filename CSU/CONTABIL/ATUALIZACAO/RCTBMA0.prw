#include "protheus.ch"                        
#include "topconn.ch"

#define CMD_OPENWORKBOOK			1
#define CMD_CLOSEWORKBOOK			2   
#define CMD_ACTIVEWORKSHEET			3    
#define CMD_READCELL				4
#DEFINE GD_INSERT					1
#DEFINE GD_DELETE					4	
#DEFINE GD_UPDATE					2
#DEFINE c_BR CHR(13)+CHR(10)

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³RCTBMA0   ºAutor  ³ Rafael Gama        º Data ³  04/01/11   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ Função que importa a planilha em XLS com os rateios de     º±±
±±º          ³ centro de custos                                           º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ CSU		                                                  º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
User Function RCTBMA0()

Local cType			:=	"Arquivos XLS|*.XLS|Todos os Arquivos|*.*"

Private aColsVar 	:= {} 
Private aHeaderVar	:= {} 
Private cArq		:= ""
Private oProcess  	:= MsNewProcess():New({|lEnd| CarrXLS()(lEnd)},"Carregando dados","Carregando...",.T.)
Private lProcess 	:= .F.

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Seleciona o arquivo                                                 ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
cArq := cGetFile(cType, OemToAnsi("Selecione a planilha excel com as informações dos rateios."),0,"",.F.,GETF_LOCALFLOPPY + GETF_LOCALHARD + GETF_NETWORKDRIVE)
If Empty(cArq)
	Aviso("Inconsistência","Selecione a planilha excel com as informações dos rateios.",{"Ok"},,"Atenção:")
	Return()
Endif
         
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Ativa o processo³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
While !lProcess
	oProcess:Activate()
End do                         

Return(aColsVar)  

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³CarrXLS   ºAutor  ³ Rafael Gama        º Data ³  04/01/11   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ Carrega os dados do excel                                  º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ CSU                                                        º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/                
Static Function CarrXLS()          
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Declaração de variáveis³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
Local nLoopDad		:= 0
Local aDados		:= {}
Local nValor		:= 0
Local aPosObj    	:= {} 
Local oDlgMain		:= Nil
Local nOpcA			:= 0
Local aObjects		:= {}  
Local aCampos		:= {}

Local cErro			:= ""//Posição para guardar ql o erro de validação dakla posição

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Variável que define o número de colunas na planilha³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
Local nNumCol		:= 5//numero de campos +!   
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Define o número das colunas de acordo com o XLS:³
//³                                                ³
//³1- Sequencia                                    ³
//³2- Percentual	                               ³
//³3- CCusto Debto       	                       ³
//³4- Item Debito     	                           ³
//³5- Classe de Valor  	                           ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

Local cTmpDesc		:= 0
Local nQuant		:= 0  
Local nX			:= 0
Local i				:= 0
Local cNomPlan		:= SuperGetMV("MV_XNOMPLN",,"tabela_de_rateio") 

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Correção para validação interna da combinação³
//³de entidades contábeis para a CSU.           ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
Local cValCCDebito	:= ""
Local cValItDebito	:= ""
Local cValClasValor	:= ""

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³VG - 2011.03.22³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
Local lErros		:= .T.

Private nColsSequen		:= 0 	
//Private nColsCDebito	:= 0	
Private nColsPercent	:= 0
Private nColsCCDebito	:= 0
Private nColsItDebito	:= 0
Private nColsClasVal	:= 0
//Private nColsObserv		:= 0
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Inicia o processo³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
lProcess	:= .T.

If IsInCallStack("U_RCTBA99")
	nNumCol := 5
Else
	nNumCol := 4
EndIf
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Realiza a interface com o excel                                     ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ               
If IsInCallStack("U_RCTBA99")
	aDados := GetExcel(cArq,Alltrim(cNomPlan),Padr("A",2)+Alltrim('2'),Padr("E",2)+Alltrim('1000'))
Else
	aDados := GetExcel(cArq,Alltrim(cNomPlan),Padr("A",2)+Alltrim('2'),Padr("D",2)+Alltrim('1000'))
EndIf
If Len(aDados) == 0                                         
	Aviso("Inconsistência","Não foi localizado um retorno para a planilha informada.",{"Ok"},,"Atenção:")
	Return()
Endif
 
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Define os campos a serem exibidos                                             ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
If IsInCallStack("U_RCTBA99")
	Aadd(aCampos,{"ZB8_SEQUEN"	,"V",OemToAnsi("Sequencia")})
	//Aadd(aCampos,{"ZB8_CDEBIT"	,"V",OemToAnsi("Conta Debito")})
	Aadd(aCampos,{"ZB8_PERCEN"	,"V",OemToAnsi("Percentual")})                                                                   
	Aadd(aCampos,{"ZB8_CCDBTO"	,"V",OemToAnsi("CCusto Debto")}) 
	Aadd(aCampos,{"ZB8_ITDBTO"	,"V",OemToAnsi("Un. Negocio")})
	Aadd(aCampos,{"ZB8_CLVLDB"	,"V",OemToAnsi("Operacao")})
	//Aadd(aCampos,{"A1_OBSERV"	,"V",OemToAnsi("Observação")})//posição para a descrição do problema
Else
	Aadd(aCampos,{"EZ_CCUSTO"	,"V",OemToAnsi("C. Custo")})
	Aadd(aCampos,{"EZ_PERC" 	,"V",OemToAnsi("Percentual")})                                                                   
	Aadd(aCampos,{"EZ_ITEMCTA"	,"V",OemToAnsi("Un. Negocio")})
	Aadd(aCampos,{"EZ_CLVL" 	,"V",OemToAnsi("Operacao")})
EndIf


//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Monta o aHeader da tabela de ITENS REGRA DE RATEIO    						³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
aHeadVar := {}
For nX := 1 to Len(aCampos)
	DbSelectArea("SX3")
	SX3->(dbSetOrder(2))
	If SX3->(DbSeek(aCampos[nX,1],.F.))
		Aadd(aHeaderVar,{	aCampos[nX,3],;
						aCampos[nX,1],; 
						SX3->X3_PICTURE,;
						SX3->X3_TAMANHO,;
						SX3->X3_DECIMAL,;
						SX3->X3_VALID,;
						SX3->X3_USADO,;
						SX3->X3_TIPO,;
						SX3->X3_F3,;
						SX3->X3_CONTEXT,;
						SX3->X3_CBOX,;
						"",;
						SX3->X3_WHEN,;
						aCampos[nX,2],;
						SX3->X3_VLDUSER,;
						SX3->X3_PICTVAR,;
						SX3->X3_OBRIGAT})
	Endif	
Next nX    

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Define as variáveis de posições do aColsVar³                             
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ                             
If IsInCallStack("U_RCTBA99")
	nColsSequen		:= aScan( aHeaderVar, { |x| AllTrim(x[2]) == "ZB8_SEQUEN"	})
	//nColsCDebito	:= aScan( aHeaderVar, { |x| AllTrim(x[2]) == "ZB8_CDEBIT"	})
	nColsPercent	:= aScan( aHeaderVar, { |x| AllTrim(x[2]) == "ZB8_PERCEN"	})
	nColsCCDebito	:= aScan( aHeaderVar, { |x| AllTrim(x[2]) == "ZB8_CCDBTO"	})
	nColsItDebito	:= aScan( aHeaderVar, { |x| AllTrim(x[2]) == "ZB8_ITDBTO"	})
	nColsClasVal	:= aScan( aHeaderVar, { |x| AllTrim(x[2]) == "ZB8_CLVLDB"	})
	//nColsObserv		:= aScan( aHeaderVar, { |x| AllTrim(x[1]) == OemToAnsi("Observação") 	})
Else
	nColsPercent	:= aScan( aHeaderVar, { |x| AllTrim(x[2]) == "EZ_PERC"	    })
	nColsCCDebito	:= aScan( aHeaderVar, { |x| AllTrim(x[2]) == "EZ_CCUSTO"	})
	nColsItDebito	:= aScan( aHeaderVar, { |x| AllTrim(x[2]) == "EZ_ITEMCTA"	})
	nColsClasVal	:= aScan( aHeaderVar, { |x| AllTrim(x[2]) == "EZ_CLVL"	    })
EndIf

If Aviso("Aviso","Deseja visualizar os erros durante a importação?",{"Sim","Não"},,"Atenção",,"BMPPERG") == 2//VG - 2011.03.22
	lErros	:= .F.
Endif				

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Monta o aColsVar                                       					    ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ                
oProcess:SetRegua1(len(aDados))
For nX	:= 1 to len(aDados)

	oProcess:IncRegua1("Processando linha: "+Alltrim(STR(nX))+" ...")

	cErro		:= ""                   
	cTmpDesc	:= ""   
	nValor		:= 0
	nQuant		:= 0
	
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³Verifica se existe algo carregado³
	//³para essa coluna.                ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	If Len(aDados[nX]) <> nNumCol
		Loop
	Endif

	Aadd(aColsVar,Array(Len(aHeaderVar)+1))
	For i := 1 To Len(aHeaderVar)
		aColsVar[Len(aColsVar)][i]	:= CriaVar(aHeaderVar[i,2],.F.)
	Next i	                                          

	//aColsVar[Len(aColsVar)][nColsArquiv]			:= cArq//nome do arquivo		
	aColsVar[Len(aColsVar)][Len(aHeaderVar)+1] 	:= .F.//seta o Deleted como .F.
	
	
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³valida as posições do aDados e adiciona no aColsVar³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	For nLoopDad := 1 to Len(aDados[nX])                         
	
		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³Formata o campo no formato   ³
		//³correto para exibição e      ³
		//³gravação.                    ³
		//³                             ³
		//³Adicionar no aColsVar        ³
		//³                             ³
		//³Verificar se o cErro está    ³
		//³preenchido, se estiver, joga ³
		//³na Observação                ³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ      	
		If nLoopDad==nColsSequen
			
			aColsVar[nX][nColsSequen]	:= Alltrim(aDados[nX][nColsSequen])
			Loop

  /*		ElseIf nLoopDad==nColsCDebito
	   		aColsVar[Len(aColsVar)][nColsCDebito]	:= Alltrim(aDados[nX][nColsCDebito])

			If Empty(Alltrim(aDados[nX][nColsCDebito]))
				cErro += OemToAnsi("Código da conta de Debito não preenchido. "	)
			Endif
			
			If Len(Alltrim(aDados[nX][nColsCDebito])) > TAMSX3("ZB8_CDEBIT")[1]
				cErro += OemToAnsi("Código da conta excede "+Alltrim(TAMSX3("ZB8_CDEBIT")[1])+" caracteres. "	)
			Endif                                   
			
			//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
			//³Verificar se o código da conta c. existe³
			//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ			
			If !ValCContab(Alltrim(aDados[nX][nColsCDebito]))
				cErro += OemToAnsi("Código da conta contábil inexistente "	)
			Endif				
		   Loop*/
		   
		ElseIf  nLoopDad==nColsPercent
			
//			aColsVar[nX][nColsPercent]	:= Val(aDados[nX][nColsPercent])                
			aColsVar[nX][nColsPercent]	:= Val(STRTRAN(STRTRAN(aDados[nX][nColsPercent],".",""),",","."))

			//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
			//³Tatiana A. Barbosa - OS 2256/11 - 08/2011 ³
			//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ			
			If	aColsVar[nX][nColsPercent] < 0
				cErro += OemToAnsi("Percentual da linha menor que zero. "	)+c_BR
			EndIf
			
			Loop
			
		ElseIf  nLoopDad==nColsCCDebito
		   	
//			aColsVar[nX][nColsCCDebito]	:= Alltrim(aDados[nX][nColsCCDebito])//VG - 2011.03.22 - Alteração para facilitar o preenchimento do Excel
			aColsVar[nX][nColsCCDebito]	:= STRZERO(Val(Alltrim(aDados[nX][nColsCCDebito])),10)
			
			If Empty(Alltrim(aDados[nX][nColsCCDebito]))
				cErro += OemToAnsi("Código do centro de custo de Debito não preenchido. "	)+c_BR
			Endif
			
			If Len(Alltrim(aDados[nX][nColsCCDebito])) > TAMSX3("ZB8_CCDBTO")[1]
				cErro += OemToAnsi("Código do centro de custo excede "+Alltrim(STR(TAMSX3("ZB8_CCDBTO")[1]))+" caracteres. "	)+c_BR
			Endif  			
			 
			//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
			//³Verificar se o código da conta c. existe³
			//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ			
			If !ValCCusto(Alltrim(aColsVar[nX][nColsCCDebito]))
				cErro += OemToAnsi("Código do centro de custo inexistente. "	)+c_BR
			Endif  	
			Loop
			
		ElseIf  nLoopDad==nColsItDebito
		
//			aColsVar[nX][nColsItDebito]	:= Alltrim(aDados[nX][nColsItDebito])  
			aColsVar[nX][nColsItDebito]	:= STRZERO(Val(Alltrim(aDados[nX][nColsItDebito])),4)
			
			If Empty(Alltrim(aDados[nX][nColsItDebito]))
				cErro += OemToAnsi("Código do Unidade de Negócio não preenchido. "	)+c_BR
			Endif
			
			If Len(Alltrim(aDados[nX][nColsItDebito])) > TAMSX3("ZB8_ITDBTO")[1]
				cErro += OemToAnsi("Código do Unidade de Negócio excede "+Alltrim(STR(TAMSX3("ZB8_ITDBTO")[1]))+" caracteres. "	)+c_BR
			Endif  
			//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
			//³Verificar se o código da conta c. existe³
			//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ			
			If !ValItCont(Alltrim(aColsVar[nX][nColsItDebito]))
				cErro += OemToAnsi("Código do Unidade de Negócio inexistente. "	)+c_BR
			Endif 			 		   	                
			Loop
			
		ElseIf  nLoopDad==nColsClasVal
		
//			aColsVar[nX][nColsClasVal]	:= Alltrim(aDados[nX][nColsClasVal])  
			aColsVar[nX][nColsClasVal]	:= STRZERO(Val(Alltrim(aDados[nX][nColsClasVal])),9)
			
			If Empty(Alltrim(aDados[nX][nColsClasVal]))
				cErro += OemToAnsi("Código da Operação não preenchido. "	)+c_BR
			Endif

			//VG - 2011.01.18			
			If Len(Alltrim(aDados[nX][nColsClasVal]))-1 > TAMSX3("ZB8_CLVLDB")[1]
				cErro += OemToAnsi("Código da Operação excede "+Alltrim(STR(TAMSX3("ZB8_CLVLDB")[1]))+" caracteres. "	)+c_BR
			Endif  

			//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
			//³Verificar se o código da conta c. existe³
			//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ			
			If !ValClasVal(Alltrim(aColsVar[nX][nColsClasVal]))
				cErro += OemToAnsi("Código da Operação inexistente. "	)+c_BR
			Endif 			 		   	                

			Loop
		Endif     
		
	Next nLoopDad
	
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³Validação do cliente para a combinação das entidades contábeis³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	//VG - 2011.02.09 - carregar a partir da segunda posição para remover o CHR(160)
/*	cValCCDebito	:= SUBSTR(Alltrim(aDados[nX][nColsCCDebito]),2)
	cValItDebito	:= SUBSTR(Alltrim(aDados[nX][nColsItDebito]),2)
	cValClasValor	:= SUBSTR(Alltrim(aDados[nX][nColsClasVal]),2)*/

	/*cValCCDebito	:= Alltrim(aDados[nX][nColsCCDebito])
	cValItDebito	:= Alltrim(aDados[nX][nColsItDebito])
	cValClasValor	:= Alltrim(aDados[nX][nColsClasVal])*/
	
	cValCCDebito	:= aColsVar[nX][nColsCCDebito]
	cValItDebito	:= aColsVar[nX][nColsItDebito]
	cValClasValor	:= aColsVar[nX][nColsClasVal]
	
//	If !U_VldCTBg( cValItDebito, cValCCDebito, cValClasValor, lErros )//VG - 2011.03.22
	If !U_VldCTBg( cValItDebito, cValCCDebito, cValClasValor,,,lErros )
	
		aDados[nX][nColsCCDebito]	:= cValCCDebito
		aDados[nX][nColsItDebito]	:= cValItDebito
		aDados[nX][nColsClasVal]	:= cValClasValor
		
		aColsVar[Len(aColsVar)][Len(aHeaderVar)+1] 	:= .T.
		
	EndIf
	
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³Se cErro estiver preenchido joga o valor na Observação³
	//³e marca a posição do array como deletado.    		 ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	If !Empty(Alltrim(cErro))
		//aColsVar[Len(aColsVar)][nColsObserv]			:= cErro
		aColsVar[Len(aColsVar)][Len(aHeaderVar)+1] 	:= .T.//seta o Deleted como .F.			
		If lErros
			Aviso("Aviso",cErro,{"OK"},,"Atenção",,"BMPPERG")			
		Endif

	Endif	

Next nX

Return

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma   ³GetExcel  º Autor ³ Jaime Wikanski            ºData³04.11.2002º±±
±±ÌÍÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDescricao  ³Funcao para leitura e retorno em um array do conteudo         º±±
±±º           ³de uma planilha excel                                         º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
Static Function GetExcel(cArqPlan,cPlan,cCelIni,cCelFim)
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Declaracao de variaveis                             		     	    ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
Local aReturn		:= {}

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Processa a interface de leitura da planilha excel                        ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
Processa({|| aReturn := LeExcel(cArqPlan,cPlan,cCelIni,cCelFim)} ,"Planilha Excel")
Return(aReturn)
 
/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma   ³LeExcel   º Autor ³ Jaime Wikanski            ºData³04.11.2002º±±
±±ÌÍÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDescricao  ³Funcao para leitura e retorno em um array do conteudo         º±±
±±º           ³de uma planilha excel                                         º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
Static Function LeExcel(cArqPlan,cPlan,cCelIni,cCelFim)

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Declaracao de variaveis                             		     	    ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
Local aReturn		:= {}
Local nLin			:= 0
Local nCol			:= 0
Local nLinIni		:= 0
Local nLinFim		:= 0
Local nColIni		:= 0
Local nColFim		:= 0
Local nMaxLin		:= 0
Local nMaxCol		:= 0
Local cDigCol1		:= ""
Local cDigCol2		:= ""
Local nHdl 			:= 0
Local cBuffer		:= "'
Local cCell 		:= ""     
Local cFile			:= ""
Local nPosIni		:= 0
Local aNumbers		:= {"0","1","2","3","4","5","6","7","8","9"}
Local nX			:= 0
Local nColArr		:= 0 
Local nCont			:= 0
Default cArqPlan	:= ""
Default cPlan		:= ""
Default cCelIni		:= ""
Default cCelFim		:= ""

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Valida os parametros informados pelo usuario        		     	    ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
If Empty(cArqPlan)
	Aviso("Inconsistência","Informe o diretório e o nome da planilha a ser processada.",{"Sair"},,"Atenção:")
	Return(aReturn)
Endif
If Empty(cPlan)
	Aviso("Inconsistência","Informe nome do Folder da planilha a ser processada.",{"Sair"},,"Atenção:")
	Return(aReturn)
Endif
If Empty(cCelIni)
	Aviso("Inconsistência","Informe a referência da célula inicial a ser processada.",{"Sair"},,"Atenção:")
	Return(aReturn)
Endif
If Empty(cCelFim)
	Aviso("Inconsistência","Informe a referência da célula final a ser processada.",{"Sair"},,"Atenção:")
	Return(aReturn)
Endif
If !File(cArqPlan)
	Aviso("Inconsistência","Não foi possível localizar a planilha "+Alltrim(cArqPlan)+" especificada.",{"Sair"},,"Atenção:")
	Return(aReturn)
Else
	cFile := Alltrim(cArqPlan)
Endif

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Copia a DLL de interface com o excel                		     	    ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
If !CpDllXls()
	Return(aReturn)
Endif
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Processa a coordenada inicial da celula             		     	    ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
nPosIni	:= 0
For nX := 1 to Len(Alltrim(cCelIni))
	If aScan(aNumbers, Substr(cCelIni,nX,1)) > 0
		nPosIni	:= nX
		Exit
	Endif
Next nX
If nPosIni == 0
	Aviso("Inconsistência","Não foi possivel determinar a referência numérica da linha inicial a ser processada. Verifique a referência da célula inicial informada.",{"Sair"},,"Atenção:")
	Return(aReturn)
Endif
nLinIni := Val(Substr(cCelIni,nPosIni,(Len(cCelIni)-nPosIni)+1))

cDigCol1 := Alltrim(Substr(cCelIni,1,nPosIni-1))
If Len(cDigCol1) == 2
	cDigCol1 	:= Substr(cCelIni,1,1)
	cDigCol2 	:= Substr(cCelIni,2,1)
	nColIni		:= ((Asc(cDigCol1)-64)*26) + (Asc(cDigCol2)-64) 
Else
	cDigCol1 	:= Substr(cCelIni,1,1)
	cDigCol2 	:= ""
	nColIni		:= Asc(cDigCol1)-64
Endif             

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Processa a coordenada final   da celula             		     	    ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
nPosIni	:= 0
For nX := 1 to Len(Alltrim(cCelFim))
	If aScan(aNumbers, Substr(cCelFim,nX,1)) > 0
		nPosIni	:= nX
		Exit
	Endif
Next nX
If nPosIni == 0
	Aviso("Inconsistência","Não foi possivel determinar a referência numérica da linha final a ser processada. Verifique a referência da célula final informada.",{"Sair"},,"Atenção:")
	Return(aReturn)
Endif
nLinFim := Val(Substr(cCelFim,nPosIni,(Len(cCelFim)-nPosIni)+1))

cDigCol1 := Alltrim(Substr(cCelFim,1,nPosIni-1))
If Len(cDigCol1) == 2
	cDigCol1 	:= Substr(cCelFim,1,1)
	cDigCol2 	:= Substr(cCelFim,2,1)
	nColFim		:= ((Asc(cDigCol1)-64)*26) + (Asc(cDigCol2)-64) 
Else
	cDigCol1 	:= Substr(cCelFim,1,1)
	cDigCol2 	:= ""
	nColFim		:= Asc(cDigCol1)-64
Endif             

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Determina o total de linhas e colunas               		     	    ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
nMaxLin := nLinFim - nLinIni + 1
nMaxCol := nColFim - nColIni + 1

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Abre a DLL de interface excel                                            ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
nHdl := ExecInDLLOpen(Alltrim(GetMv("MV_DRDLLXLS",,"c:\apexcel"))+'\readexcel.dll')

If nHdl < 0
	Aviso("Inconsistência","Não foi possível carregar a DLL de interface com o Excel (readexcel.dll).",{"Sair"},,"Atenção:")
	Return(aReturn)
Endif

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Carrega o excel e abre o arquivo                                         ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
cBuffer := cFile+Space(512)
nBytes  := ExeDLLRun2(nHdl, CMD_OPENWORKBOOK, @cBuffer)
	
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Valida se abriu a planilha corretamente                                  ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
If nBytes < 0
	Aviso("Inconsistência","Não foi possível abrir a planilha Excel solicitada ("+Alltrim(cFile)+").",{"Sair"},,"Atenção:")
	Return(aReturn)
ElseIf nBytes > 0
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Erro critico na abertura do arquivo com msg de erro						 ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	Aviso("Inconsistência","Não foi possível abrir a planilha Excel solicitada ("+Alltrim(cFile)+"). "+Chr(13)+Chr(10)+"Erro interno: "+Subs(cBuffer, 1, nBytes),{"Sair"},,"Atenção:")
	Return(aReturn)
EndIf                           
	
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Seleciona a worksheet                                  					 ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
cBuffer := Alltrim(cPlan)+Space(512)
nBytes 	:= ExeDLLRun2(nHdl,CMD_ACTIVEWORKSHEET,@cBuffer)   

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Valida se selecionou o worksheet solicitado                              ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
If nBytes < 0
	Aviso("Inconsistência","Não foi possível selecionar a WorkSheet solicitada ("+Alltrim(cPlan)+") na planilha Excel ("+Alltrim(cFile)+").",{"Sair"},,"Atenção:")
	cBuffer := Space(512)
	ExeDLLRun2(nHdl, CMD_CLOSEWORKBOOK, @cBuffer)
	ExecInDLLClose(nHdl)
	Return(aReturn)
ElseIf nBytes > 0
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Erro critico na abertura do arquivo com msg de erro						 ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	Aviso("Inconsistência","Não foi possível selecionar a WorkSheet solicitada ("+Alltrim(cPlan)+") na planilha Excel ("+Alltrim(cFile)+")."+Chr(13)+Chr(10)+"Erro interno: "+Subs(cBuffer, 1, nBytes),{"Sair"},,"Atenção:")
	cBuffer := Space(512)
	ExeDLLRun2(nHdl, CMD_CLOSEWORKBOOK, @cBuffer)
	ExecInDLLClose(nHdl)
	Return(aReturn)
EndIf                           

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Define a regua de processamento                                          ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
ProcRegua(nMaxLin*nMaxCol)

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Gera o array com todas as coordenadas necessarias   		     	    ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
For nLin := nLinIni to nLinFim
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Adiciona no array a lina a ser importada                                ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	if nLin > 1//VG - 2011.02.28 - Tira a linha de cabeçalho
   		Aadd(aReturn, Array(nMaxCol))
   		nCont++
   	Endif	
	
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Processa as colunas da linha atual                                       ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	nColArr := 0
	For nCol := nColIni to nColFim
		nColArr++	
		If Int((nCol/26)-0.01) > 0
			cDigCol1 := Chr(Int((nCol/26)-0.01)+64)
		Else
			cDigCol1 := " "
		Endif
		If nCol - (Int((nCol/26)-0.01)*26) > 0
			cDigCol2 := Chr((nCol - (Int((nCol/26)-0.01)*26))+64)
		Else
			cDigCol2 := " "
		Endif
		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³ Incrementa a regua de processamento                                      ³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		IncProc("Importando planilha...")                                

		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³ Compoe a coordenada da celula a ser importada                            ³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		cCell := Alltrim(cDigCol1)+Alltrim(cDigCol2)+Alltrim(Str(nLin))

		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³ Realiza a leitura da celula no excel                                     ³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		cBuffer := cCell+Space(1024)
		nBytes 	:= ExeDLLRun2(nHdl, CMD_READCELL, @cBuffer)
		
/*		If nLin = 3 .AND. nBytes > 0
			If nCol == 1  
				SX3->(DBSetORder(2))
				SX3->(DBSeek("ZB8_SEQUEN"))
				If !ALLTRIM(X3TITULO()) == ALLTRIM(cBuffer)
					Aviso("Inconsistência","O Título "+ALLTRIM(X3TITULO())+" não é igual da planilha Excel.",{"Sair"},,"Atenção:")
					//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
					//³ Fecha a interface com o excel                                            ³
					//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
					cBuffer := Space(512)
					ExeDLLRun2(nHdl, CMD_CLOSEWORKBOOK, @cBuffer)
					ExecInDLLClose(nHdl)
					
					Return(aReturn)
				Endif
			ElseIf nCol == 2 
				//ZB8_CDEBIT
			ElseIf nCol == 3
				//ZB8_PERCEN			
			ElseIf nCol == 4
			    //ZB8_CCDBTO
			ElseIf nCol == 5
			    //ZB8_ITDBTO
			Endif 
			loop
		Endif*/
		
		If nBytes == 0 
			nCont--
			ASIZE(aReturn,nCont)
			exit
		Endif
		//aReturn[nLin,nCol] := Subs(cBuffer, 1, nBytes)      
		aReturn[Len(aReturn),nColArr] := Subs(cBuffer, 1, nBytes)
	Next nCol
	   
	If nBytes == 0
		exit
	Endif
Next nLin      

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Fecha a interface com o excel                                            ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
cBuffer := Space(512)
ExeDLLRun2(nHdl, CMD_CLOSEWORKBOOK, @cBuffer)
ExecInDLLClose(nHdl)

Return(aReturn)

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³CpDllXls  ºAutor  ³Jaime Wikanski      º Data ³  05/17/06   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³Funcao para copiar a DLL para a estação do usuario          º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³                                                            º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
Static Function CpDllXls()

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Declaracao de variaveis                                                        ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
Local cDirDest	:= Alltrim(GetMv("MV_DRDLLXLS",,"c:\apexcel"))
Local nResult	:= 0
Local lReturn	:= .T.
                                                  
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Cria o diretorio de destino da DLL na estacao do usuario                       ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
If !lIsDir(cDirDest)
	nResult := MakeDir(cDirDest)
Endif
If nResult <> 0
	Aviso("Inconistência","Não foi possível criar o diretório "+cDirDest+" para a DLL de leitura da planilha Excel.",{"Sair"},,"Atenção:")
	lReturn := .F.
Else
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³Copia a DLL para o diretorio na estacao do usuario                             ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	If !File("ReadExcel.dll")
		Aviso("Inconistência","Não foi possível localizar a DLL de leitura da planilha excel (ReadExcel.dll) no diretório SYSTEM ou SIGAADV.",{"Sair"},,"Atenção:")
		lReturn := .F.
	Else		
		If !File(cDirDest+"\ReadExcel.dll")
			COPY FILE ("ReadExcel.dll") TO (cDirDest+"\ReadExcel.dll")
			If !File(cDirDest+"\ReadExcel.dll")
				Aviso("Inconistência","Não foi possível copiar a DLL de leitura da planilha excel para o diretório "+cDirDest+".",{"Sair"},,"Atenção:")
				lReturn := .F.
			Endif
		Endif
	Endif
Endif

Return(lReturn)


/*
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡…o    ³ ValCContab	  ³ Autor ³ Rafael Gama           ³ Data ³ 04.01.11 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³ Verifica a existencia da Conta Contabil.		                    ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Sintaxe   ³ ValCContab()                                                     ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Parametros³ Nenhum                                                           ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Retorno   ³ .T. / .F.                                                        ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³ RCTBMA0                                                          ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
Static Function ValCContab(cVar)

LOCAL cSavAlias := Alias(), lRet := .T.

If Substr(cVar,1,1) == CHR(160)
	cVar := padr(substr(cvar,2,len(cvar)-1),TAMSX3("CT1_CONTA")[1])  
Else
	cVar := padr(ALLTRIM(cvar),TAMSX3("CT1_CONTA")[1])  		
Endif

dbSelectArea("CT1")
dbSetOrder(1)
dbSeek(xFilial("CT1")+cVar,.F.)

If !Found()
	lRet := .F.
EndIf

dbSelectArea(cSavAlias)
Return(lRet)
/*
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡…o    ³ ValCCusto	  ³ Autor ³ Rafael Gama           ³ Data ³ 04.01.11 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³ Verifica a existencia da Centro de Custo.	                    ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Sintaxe   ³ ValCCusto()                                                      ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Parametros³ Nenhum                                                           ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Retorno   ³ .T. / .F.                                                        ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³ RCTBMA0                                                          ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
Static Function ValCCusto(cVar)

LOCAL cSavAlias := Alias(), lRet := .T.

If Substr(cVar,1,1) == CHR(160)
	cVar := padr(substr(cVar,2,len(cvar)-1),TAMSX3("CTT_CUSTO")[1])  
Else
	cVar := padr(ALLTRIM(cVar),TAMSX3("CTT_CUSTO")[1])  		
Endif

dbSelectArea("CTT")
dbSetOrder(1)
dbSeek(xFilial("CTT")+cVar,.F.)

If !Found()
	lRet := .F.
EndIf

dbSelectArea(cSavAlias)
Return(lRet)       

/*
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡…o    ³ ValItCont	  ³ Autor ³ Rafael Gama           ³ Data ³ 04.01.11 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³ Verifica a existencia do Item Contabil.		                    ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Sintaxe   ³ ValItCont()                                                      ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Parametros³ Nenhum                                                           ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Retorno   ³ .T. / .F.                                                        ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³ RCTBMA0                                                          ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
Static Function ValItCont(cVar)

LOCAL cSavAlias := Alias(), lRet := .T.

If Substr(cVar,1,1) == CHR(160)
	cVar := padr(substr(cvar,2,len(cvar)-1),TAMSX3("CTD_ITEM")[1])  
Else
	cVar := padr(ALLTRIM(cvar),TAMSX3("CTD_ITEM")[1])  		
Endif

dbSelectArea("CTD")
dbSetOrder(1)
dbSeek(xFilial("CTD")+cVar,.F.)

If !Found()
	lRet := .F.
EndIf

dbSelectArea(cSavAlias)
Return(lRet)

/*
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡…o    ³ ValClasVal	  ³ Autor ³ Rafael Gama           ³ Data ³ 04.01.11 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³ Verifica a existencia da Classe de Valor		                    ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Sintaxe   ³ ValClasVal()                                                     ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Parametros³ Nenhum                                                           ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Retorno   ³ .T. / .F.                                                        ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³ RCTBMA0                                                          ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
Static Function ValClasVal(cVar)

LOCAL cSavAlias := Alias(), lRet := .T.

If Substr(cVar,1,1) == CHR(160)
	cVar := padr(substr(cvar,2,len(cvar)-1),TAMSX3("CTH_CLVL")[1])  
Else
	cVar := padr(ALLTRIM(cvar),TAMSX3("CTH_CLVL")[1])  		
Endif

dbSelectArea("CTH")
dbSetOrder(1)
dbSeek(xFilial("CTH")+cVar,.F.)

If !Found()
	lRet := .F.
EndIf

dbSelectArea(cSavAlias)
Return(lRet)
          
