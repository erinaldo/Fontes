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
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �RCTBMA0   �Autor  � Rafael Gama        � Data �  04/01/11   ���
�������������������������������������������������������������������������͹��
���Desc.     � Fun��o que importa a planilha em XLS com os rateios de     ���
���          � centro de custos                                           ���
�������������������������������������������������������������������������͹��
���Uso       � CSU		                                                  ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/
User Function RCTBMA0()

Local cType			:=	"Arquivos XLS|*.XLS|Todos os Arquivos|*.*"

Private aColsVar 	:= {} 
Private aHeaderVar	:= {} 
Private cArq		:= ""
Private oProcess  	:= MsNewProcess():New({|lEnd| CarrXLS()(lEnd)},"Carregando dados","Carregando...",.T.)
Private lProcess 	:= .F.

//���������������������������������������������������������������������Ŀ
//� Seleciona o arquivo                                                 �
//�����������������������������������������������������������������������
cArq := cGetFile(cType, OemToAnsi("Selecione a planilha excel com as informa��es dos rateios."),0,"",.F.,GETF_LOCALFLOPPY + GETF_LOCALHARD + GETF_NETWORKDRIVE)
If Empty(cArq)
	Aviso("Inconsist�ncia","Selecione a planilha excel com as informa��es dos rateios.",{"Ok"},,"Aten��o:")
	Return()
Endif
         
//����������������Ŀ
//�Ativa o processo�
//������������������
While !lProcess
	oProcess:Activate()
End do                         

Return(aColsVar)  

/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �CarrXLS   �Autor  � Rafael Gama        � Data �  04/01/11   ���
�������������������������������������������������������������������������͹��
���Desc.     � Carrega os dados do excel                                  ���
�������������������������������������������������������������������������͹��
���Uso       � CSU                                                        ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/                
Static Function CarrXLS()          
//�����������������������Ŀ
//�Declara��o de vari�veis�
//�������������������������
Local nLoopDad		:= 0
Local aDados		:= {}
Local nValor		:= 0
Local aPosObj    	:= {} 
Local oDlgMain		:= Nil
Local nOpcA			:= 0
Local aObjects		:= {}  
Local aCampos		:= {}

Local cErro			:= ""//Posi��o para guardar ql o erro de valida��o dakla posi��o

//���������������������������������������������������Ŀ
//�Vari�vel que define o n�mero de colunas na planilha�
//�����������������������������������������������������
Local nNumCol		:= 5//numero de campos +!   
//������������������������������������������������Ŀ
//�Define o n�mero das colunas de acordo com o XLS:�
//�                                                �
//�1- Sequencia                                    �
//�2- Percentual	                               �
//�3- CCusto Debto       	                       �
//�4- Item Debito     	                           �
//�5- Classe de Valor  	                           �
//��������������������������������������������������

Local cTmpDesc		:= 0
Local nQuant		:= 0  
Local nX			:= 0
Local i				:= 0
Local cNomPlan		:= SuperGetMV("MV_XNOMPLN",,"tabela_de_rateio") 

//���������������������������������������������Ŀ
//�Corre��o para valida��o interna da combina��o�
//�de entidades cont�beis para a CSU.           �
//�����������������������������������������������
Local cValCCDebito	:= ""
Local cValItDebito	:= ""
Local cValClasValor	:= ""

//���������������Ŀ
//�VG - 2011.03.22�
//�����������������
Local lErros		:= .T.

Private nColsSequen		:= 0 	
//Private nColsCDebito	:= 0	
Private nColsPercent	:= 0
Private nColsCCDebito	:= 0
Private nColsItDebito	:= 0
Private nColsClasVal	:= 0
//Private nColsObserv		:= 0
//�����������������Ŀ
//�Inicia o processo�
//�������������������
lProcess	:= .T.

If IsInCallStack("U_RCTBA99")
	nNumCol := 5
Else
	nNumCol := 4
EndIf
//���������������������������������������������������������������������Ŀ
//� Realiza a interface com o excel                                     �
//�����������������������������������������������������������������������               
If IsInCallStack("U_RCTBA99")
	aDados := GetExcel(cArq,Alltrim(cNomPlan),Padr("A",2)+Alltrim('2'),Padr("E",2)+Alltrim('1000'))
Else
	aDados := GetExcel(cArq,Alltrim(cNomPlan),Padr("A",2)+Alltrim('2'),Padr("D",2)+Alltrim('1000'))
EndIf
If Len(aDados) == 0                                         
	Aviso("Inconsist�ncia","N�o foi localizado um retorno para a planilha informada.",{"Ok"},,"Aten��o:")
	Return()
Endif
 
//������������������������������������������������������������������������������Ŀ
//�Define os campos a serem exibidos                                             �
//��������������������������������������������������������������������������������
If IsInCallStack("U_RCTBA99")
	Aadd(aCampos,{"ZB8_SEQUEN"	,"V",OemToAnsi("Sequencia")})
	//Aadd(aCampos,{"ZB8_CDEBIT"	,"V",OemToAnsi("Conta Debito")})
	Aadd(aCampos,{"ZB8_PERCEN"	,"V",OemToAnsi("Percentual")})                                                                   
	Aadd(aCampos,{"ZB8_CCDBTO"	,"V",OemToAnsi("CCusto Debto")}) 
	Aadd(aCampos,{"ZB8_ITDBTO"	,"V",OemToAnsi("Un. Negocio")})
	Aadd(aCampos,{"ZB8_CLVLDB"	,"V",OemToAnsi("Operacao")})
	//Aadd(aCampos,{"A1_OBSERV"	,"V",OemToAnsi("Observa��o")})//posi��o para a descri��o do problema
Else
	Aadd(aCampos,{"EZ_CCUSTO"	,"V",OemToAnsi("C. Custo")})
	Aadd(aCampos,{"EZ_PERC" 	,"V",OemToAnsi("Percentual")})                                                                   
	Aadd(aCampos,{"EZ_ITEMCTA"	,"V",OemToAnsi("Un. Negocio")})
	Aadd(aCampos,{"EZ_CLVL" 	,"V",OemToAnsi("Operacao")})
EndIf


//�����������������������������������������������������������������������������Ŀ
//� Monta o aHeader da tabela de ITENS REGRA DE RATEIO    						�
//�������������������������������������������������������������������������������
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

//���������������������������������������������
//�Define as vari�veis de posi��es do aColsVar�                             
//���������������������������������������������                             
If IsInCallStack("U_RCTBA99")
	nColsSequen		:= aScan( aHeaderVar, { |x| AllTrim(x[2]) == "ZB8_SEQUEN"	})
	//nColsCDebito	:= aScan( aHeaderVar, { |x| AllTrim(x[2]) == "ZB8_CDEBIT"	})
	nColsPercent	:= aScan( aHeaderVar, { |x| AllTrim(x[2]) == "ZB8_PERCEN"	})
	nColsCCDebito	:= aScan( aHeaderVar, { |x| AllTrim(x[2]) == "ZB8_CCDBTO"	})
	nColsItDebito	:= aScan( aHeaderVar, { |x| AllTrim(x[2]) == "ZB8_ITDBTO"	})
	nColsClasVal	:= aScan( aHeaderVar, { |x| AllTrim(x[2]) == "ZB8_CLVLDB"	})
	//nColsObserv		:= aScan( aHeaderVar, { |x| AllTrim(x[1]) == OemToAnsi("Observa��o") 	})
Else
	nColsPercent	:= aScan( aHeaderVar, { |x| AllTrim(x[2]) == "EZ_PERC"	    })
	nColsCCDebito	:= aScan( aHeaderVar, { |x| AllTrim(x[2]) == "EZ_CCUSTO"	})
	nColsItDebito	:= aScan( aHeaderVar, { |x| AllTrim(x[2]) == "EZ_ITEMCTA"	})
	nColsClasVal	:= aScan( aHeaderVar, { |x| AllTrim(x[2]) == "EZ_CLVL"	    })
EndIf

If Aviso("Aviso","Deseja visualizar os erros durante a importa��o?",{"Sim","N�o"},,"Aten��o",,"BMPPERG") == 2//VG - 2011.03.22
	lErros	:= .F.
Endif				

//�����������������������������������������������������������������������������Ŀ
//� Monta o aColsVar                                       					    �
//�������������������������������������������������������������������������������                
oProcess:SetRegua1(len(aDados))
For nX	:= 1 to len(aDados)

	oProcess:IncRegua1("Processando linha: "+Alltrim(STR(nX))+" ...")

	cErro		:= ""                   
	cTmpDesc	:= ""   
	nValor		:= 0
	nQuant		:= 0
	
	//���������������������������������Ŀ
	//�Verifica se existe algo carregado�
	//�para essa coluna.                �
	//�����������������������������������
	If Len(aDados[nX]) <> nNumCol
		Loop
	Endif

	Aadd(aColsVar,Array(Len(aHeaderVar)+1))
	For i := 1 To Len(aHeaderVar)
		aColsVar[Len(aColsVar)][i]	:= CriaVar(aHeaderVar[i,2],.F.)
	Next i	                                          

	//aColsVar[Len(aColsVar)][nColsArquiv]			:= cArq//nome do arquivo		
	aColsVar[Len(aColsVar)][Len(aHeaderVar)+1] 	:= .F.//seta o Deleted como .F.
	
	
	//���������������������������������������������������Ŀ
	//�valida as posi��es do aDados e adiciona no aColsVar�
	//�����������������������������������������������������
	For nLoopDad := 1 to Len(aDados[nX])                         
	
		//�����������������������������Ŀ
		//�Formata o campo no formato   �
		//�correto para exibi��o e      �
		//�grava��o.                    �
		//�                             �
		//�Adicionar no aColsVar        �
		//�                             �
		//�Verificar se o cErro est�    �
		//�preenchido, se estiver, joga �
		//�na Observa��o                �
		//�������������������������������      	
		If nLoopDad==nColsSequen
			
			aColsVar[nX][nColsSequen]	:= Alltrim(aDados[nX][nColsSequen])
			Loop

  /*		ElseIf nLoopDad==nColsCDebito
	   		aColsVar[Len(aColsVar)][nColsCDebito]	:= Alltrim(aDados[nX][nColsCDebito])

			If Empty(Alltrim(aDados[nX][nColsCDebito]))
				cErro += OemToAnsi("C�digo da conta de Debito n�o preenchido. "	)
			Endif
			
			If Len(Alltrim(aDados[nX][nColsCDebito])) > TAMSX3("ZB8_CDEBIT")[1]
				cErro += OemToAnsi("C�digo da conta excede "+Alltrim(TAMSX3("ZB8_CDEBIT")[1])+" caracteres. "	)
			Endif                                   
			
			//����������������������������������������Ŀ
			//�Verificar se o c�digo da conta c. existe�
			//������������������������������������������			
			If !ValCContab(Alltrim(aDados[nX][nColsCDebito]))
				cErro += OemToAnsi("C�digo da conta cont�bil inexistente "	)
			Endif				
		   Loop*/
		   
		ElseIf  nLoopDad==nColsPercent
			
//			aColsVar[nX][nColsPercent]	:= Val(aDados[nX][nColsPercent])                
			aColsVar[nX][nColsPercent]	:= Val(STRTRAN(STRTRAN(aDados[nX][nColsPercent],".",""),",","."))

			//������������������������������������������Ŀ
			//�Tatiana A. Barbosa - OS 2256/11 - 08/2011 �
			//��������������������������������������������			
			If	aColsVar[nX][nColsPercent] < 0
				cErro += OemToAnsi("Percentual da linha menor que zero. "	)+c_BR
			EndIf
			
			Loop
			
		ElseIf  nLoopDad==nColsCCDebito
		   	
//			aColsVar[nX][nColsCCDebito]	:= Alltrim(aDados[nX][nColsCCDebito])//VG - 2011.03.22 - Altera��o para facilitar o preenchimento do Excel
			aColsVar[nX][nColsCCDebito]	:= STRZERO(Val(Alltrim(aDados[nX][nColsCCDebito])),10)
			
			If Empty(Alltrim(aDados[nX][nColsCCDebito]))
				cErro += OemToAnsi("C�digo do centro de custo de Debito n�o preenchido. "	)+c_BR
			Endif
			
			If Len(Alltrim(aDados[nX][nColsCCDebito])) > TAMSX3("ZB8_CCDBTO")[1]
				cErro += OemToAnsi("C�digo do centro de custo excede "+Alltrim(STR(TAMSX3("ZB8_CCDBTO")[1]))+" caracteres. "	)+c_BR
			Endif  			
			 
			//����������������������������������������Ŀ
			//�Verificar se o c�digo da conta c. existe�
			//������������������������������������������			
			If !ValCCusto(Alltrim(aColsVar[nX][nColsCCDebito]))
				cErro += OemToAnsi("C�digo do centro de custo inexistente. "	)+c_BR
			Endif  	
			Loop
			
		ElseIf  nLoopDad==nColsItDebito
		
//			aColsVar[nX][nColsItDebito]	:= Alltrim(aDados[nX][nColsItDebito])  
			aColsVar[nX][nColsItDebito]	:= STRZERO(Val(Alltrim(aDados[nX][nColsItDebito])),4)
			
			If Empty(Alltrim(aDados[nX][nColsItDebito]))
				cErro += OemToAnsi("C�digo do Unidade de Neg�cio n�o preenchido. "	)+c_BR
			Endif
			
			If Len(Alltrim(aDados[nX][nColsItDebito])) > TAMSX3("ZB8_ITDBTO")[1]
				cErro += OemToAnsi("C�digo do Unidade de Neg�cio excede "+Alltrim(STR(TAMSX3("ZB8_ITDBTO")[1]))+" caracteres. "	)+c_BR
			Endif  
			//����������������������������������������Ŀ
			//�Verificar se o c�digo da conta c. existe�
			//������������������������������������������			
			If !ValItCont(Alltrim(aColsVar[nX][nColsItDebito]))
				cErro += OemToAnsi("C�digo do Unidade de Neg�cio inexistente. "	)+c_BR
			Endif 			 		   	                
			Loop
			
		ElseIf  nLoopDad==nColsClasVal
		
//			aColsVar[nX][nColsClasVal]	:= Alltrim(aDados[nX][nColsClasVal])  
			aColsVar[nX][nColsClasVal]	:= STRZERO(Val(Alltrim(aDados[nX][nColsClasVal])),9)
			
			If Empty(Alltrim(aDados[nX][nColsClasVal]))
				cErro += OemToAnsi("C�digo da Opera��o n�o preenchido. "	)+c_BR
			Endif

			//VG - 2011.01.18			
			If Len(Alltrim(aDados[nX][nColsClasVal]))-1 > TAMSX3("ZB8_CLVLDB")[1]
				cErro += OemToAnsi("C�digo da Opera��o excede "+Alltrim(STR(TAMSX3("ZB8_CLVLDB")[1]))+" caracteres. "	)+c_BR
			Endif  

			//����������������������������������������Ŀ
			//�Verificar se o c�digo da conta c. existe�
			//������������������������������������������			
			If !ValClasVal(Alltrim(aColsVar[nX][nColsClasVal]))
				cErro += OemToAnsi("C�digo da Opera��o inexistente. "	)+c_BR
			Endif 			 		   	                

			Loop
		Endif     
		
	Next nLoopDad
	
	//��������������������������������������������������������������Ŀ
	//�Valida��o do cliente para a combina��o das entidades cont�beis�
	//����������������������������������������������������������������
	//VG - 2011.02.09 - carregar a partir da segunda posi��o para remover o CHR(160)
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
	
	//������������������������������������������������������Ŀ
	//�Se cErro estiver preenchido joga o valor na Observa��o�
	//�e marca a posi��o do array como deletado.    		 �
	//��������������������������������������������������������
	If !Empty(Alltrim(cErro))
		//aColsVar[Len(aColsVar)][nColsObserv]			:= cErro
		aColsVar[Len(aColsVar)][Len(aHeaderVar)+1] 	:= .T.//seta o Deleted como .F.			
		If lErros
			Aviso("Aviso",cErro,{"OK"},,"Aten��o",,"BMPPERG")			
		Endif

	Endif	

Next nX

Return

/*
��������������������������������������������������������������������������������
��������������������������������������������������������������������������������
����������������������������������������������������������������������������ͻ��
���Programa   �GetExcel  � Autor � Jaime Wikanski            �Data�04.11.2002���
����������������������������������������������������������������������������͹��
���Descricao  �Funcao para leitura e retorno em um array do conteudo         ���
���           �de uma planilha excel                                         ���
����������������������������������������������������������������������������ͼ��
��������������������������������������������������������������������������������
��������������������������������������������������������������������������������
*/
Static Function GetExcel(cArqPlan,cPlan,cCelIni,cCelFim)
//�������������������������������������������������������������������������Ŀ
//� Declaracao de variaveis                             		     	    �
//���������������������������������������������������������������������������
Local aReturn		:= {}

//��������������������������������������������������������������������������Ŀ
//� Processa a interface de leitura da planilha excel                        �
//����������������������������������������������������������������������������
Processa({|| aReturn := LeExcel(cArqPlan,cPlan,cCelIni,cCelFim)} ,"Planilha Excel")
Return(aReturn)
 
/*
��������������������������������������������������������������������������������
��������������������������������������������������������������������������������
����������������������������������������������������������������������������ͻ��
���Programa   �LeExcel   � Autor � Jaime Wikanski            �Data�04.11.2002���
����������������������������������������������������������������������������͹��
���Descricao  �Funcao para leitura e retorno em um array do conteudo         ���
���           �de uma planilha excel                                         ���
����������������������������������������������������������������������������ͼ��
��������������������������������������������������������������������������������
��������������������������������������������������������������������������������
*/
Static Function LeExcel(cArqPlan,cPlan,cCelIni,cCelFim)

//�������������������������������������������������������������������������Ŀ
//� Declaracao de variaveis                             		     	    �
//���������������������������������������������������������������������������
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

//�������������������������������������������������������������������������Ŀ
//� Valida os parametros informados pelo usuario        		     	    �
//���������������������������������������������������������������������������
If Empty(cArqPlan)
	Aviso("Inconsist�ncia","Informe o diret�rio e o nome da planilha a ser processada.",{"Sair"},,"Aten��o:")
	Return(aReturn)
Endif
If Empty(cPlan)
	Aviso("Inconsist�ncia","Informe nome do Folder da planilha a ser processada.",{"Sair"},,"Aten��o:")
	Return(aReturn)
Endif
If Empty(cCelIni)
	Aviso("Inconsist�ncia","Informe a refer�ncia da c�lula inicial a ser processada.",{"Sair"},,"Aten��o:")
	Return(aReturn)
Endif
If Empty(cCelFim)
	Aviso("Inconsist�ncia","Informe a refer�ncia da c�lula final a ser processada.",{"Sair"},,"Aten��o:")
	Return(aReturn)
Endif
If !File(cArqPlan)
	Aviso("Inconsist�ncia","N�o foi poss�vel localizar a planilha "+Alltrim(cArqPlan)+" especificada.",{"Sair"},,"Aten��o:")
	Return(aReturn)
Else
	cFile := Alltrim(cArqPlan)
Endif

//�������������������������������������������������������������������������Ŀ
//� Copia a DLL de interface com o excel                		     	    �
//���������������������������������������������������������������������������
If !CpDllXls()
	Return(aReturn)
Endif
//�������������������������������������������������������������������������Ŀ
//� Processa a coordenada inicial da celula             		     	    �
//���������������������������������������������������������������������������
nPosIni	:= 0
For nX := 1 to Len(Alltrim(cCelIni))
	If aScan(aNumbers, Substr(cCelIni,nX,1)) > 0
		nPosIni	:= nX
		Exit
	Endif
Next nX
If nPosIni == 0
	Aviso("Inconsist�ncia","N�o foi possivel determinar a refer�ncia num�rica da linha inicial a ser processada. Verifique a refer�ncia da c�lula inicial informada.",{"Sair"},,"Aten��o:")
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

//�������������������������������������������������������������������������Ŀ
//� Processa a coordenada final   da celula             		     	    �
//���������������������������������������������������������������������������
nPosIni	:= 0
For nX := 1 to Len(Alltrim(cCelFim))
	If aScan(aNumbers, Substr(cCelFim,nX,1)) > 0
		nPosIni	:= nX
		Exit
	Endif
Next nX
If nPosIni == 0
	Aviso("Inconsist�ncia","N�o foi possivel determinar a refer�ncia num�rica da linha final a ser processada. Verifique a refer�ncia da c�lula final informada.",{"Sair"},,"Aten��o:")
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

//�������������������������������������������������������������������������Ŀ
//� Determina o total de linhas e colunas               		     	    �
//���������������������������������������������������������������������������
nMaxLin := nLinFim - nLinIni + 1
nMaxCol := nColFim - nColIni + 1

//��������������������������������������������������������������������������Ŀ
//� Abre a DLL de interface excel                                            �
//����������������������������������������������������������������������������
nHdl := ExecInDLLOpen(Alltrim(GetMv("MV_DRDLLXLS",,"c:\apexcel"))+'\readexcel.dll')

If nHdl < 0
	Aviso("Inconsist�ncia","N�o foi poss�vel carregar a DLL de interface com o Excel (readexcel.dll).",{"Sair"},,"Aten��o:")
	Return(aReturn)
Endif

//��������������������������������������������������������������������������Ŀ
//� Carrega o excel e abre o arquivo                                         �
//����������������������������������������������������������������������������
cBuffer := cFile+Space(512)
nBytes  := ExeDLLRun2(nHdl, CMD_OPENWORKBOOK, @cBuffer)
	
//��������������������������������������������������������������������������Ŀ
//� Valida se abriu a planilha corretamente                                  �
//����������������������������������������������������������������������������
If nBytes < 0
	Aviso("Inconsist�ncia","N�o foi poss�vel abrir a planilha Excel solicitada ("+Alltrim(cFile)+").",{"Sair"},,"Aten��o:")
	Return(aReturn)
ElseIf nBytes > 0
	//��������������������������������������������������������������������������Ŀ
	//� Erro critico na abertura do arquivo com msg de erro						 �
	//����������������������������������������������������������������������������
	Aviso("Inconsist�ncia","N�o foi poss�vel abrir a planilha Excel solicitada ("+Alltrim(cFile)+"). "+Chr(13)+Chr(10)+"Erro interno: "+Subs(cBuffer, 1, nBytes),{"Sair"},,"Aten��o:")
	Return(aReturn)
EndIf                           
	
//��������������������������������������������������������������������������Ŀ
//� Seleciona a worksheet                                  					 �
//����������������������������������������������������������������������������
cBuffer := Alltrim(cPlan)+Space(512)
nBytes 	:= ExeDLLRun2(nHdl,CMD_ACTIVEWORKSHEET,@cBuffer)   

//��������������������������������������������������������������������������Ŀ
//� Valida se selecionou o worksheet solicitado                              �
//����������������������������������������������������������������������������
If nBytes < 0
	Aviso("Inconsist�ncia","N�o foi poss�vel selecionar a WorkSheet solicitada ("+Alltrim(cPlan)+") na planilha Excel ("+Alltrim(cFile)+").",{"Sair"},,"Aten��o:")
	cBuffer := Space(512)
	ExeDLLRun2(nHdl, CMD_CLOSEWORKBOOK, @cBuffer)
	ExecInDLLClose(nHdl)
	Return(aReturn)
ElseIf nBytes > 0
	//��������������������������������������������������������������������������Ŀ
	//� Erro critico na abertura do arquivo com msg de erro						 �
	//����������������������������������������������������������������������������
	Aviso("Inconsist�ncia","N�o foi poss�vel selecionar a WorkSheet solicitada ("+Alltrim(cPlan)+") na planilha Excel ("+Alltrim(cFile)+")."+Chr(13)+Chr(10)+"Erro interno: "+Subs(cBuffer, 1, nBytes),{"Sair"},,"Aten��o:")
	cBuffer := Space(512)
	ExeDLLRun2(nHdl, CMD_CLOSEWORKBOOK, @cBuffer)
	ExecInDLLClose(nHdl)
	Return(aReturn)
EndIf                           

//��������������������������������������������������������������������������Ŀ
//� Define a regua de processamento                                          �
//����������������������������������������������������������������������������
ProcRegua(nMaxLin*nMaxCol)

//�������������������������������������������������������������������������Ŀ
//� Gera o array com todas as coordenadas necessarias   		     	    �
//���������������������������������������������������������������������������
For nLin := nLinIni to nLinFim
	//��������������������������������������������������������������������������Ŀ
	//� Adiciona no array a lina a ser importada                                �
	//����������������������������������������������������������������������������
	if nLin > 1//VG - 2011.02.28 - Tira a linha de cabe�alho
   		Aadd(aReturn, Array(nMaxCol))
   		nCont++
   	Endif	
	
	//��������������������������������������������������������������������������Ŀ
	//� Processa as colunas da linha atual                                       �
	//����������������������������������������������������������������������������
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
		//��������������������������������������������������������������������������Ŀ
		//� Incrementa a regua de processamento                                      �
		//����������������������������������������������������������������������������
		IncProc("Importando planilha...")                                

		//��������������������������������������������������������������������������Ŀ
		//� Compoe a coordenada da celula a ser importada                            �
		//����������������������������������������������������������������������������
		cCell := Alltrim(cDigCol1)+Alltrim(cDigCol2)+Alltrim(Str(nLin))

		//��������������������������������������������������������������������������Ŀ
		//� Realiza a leitura da celula no excel                                     �
		//����������������������������������������������������������������������������
		cBuffer := cCell+Space(1024)
		nBytes 	:= ExeDLLRun2(nHdl, CMD_READCELL, @cBuffer)
		
/*		If nLin = 3 .AND. nBytes > 0
			If nCol == 1  
				SX3->(DBSetORder(2))
				SX3->(DBSeek("ZB8_SEQUEN"))
				If !ALLTRIM(X3TITULO()) == ALLTRIM(cBuffer)
					Aviso("Inconsist�ncia","O T�tulo "+ALLTRIM(X3TITULO())+" n�o � igual da planilha Excel.",{"Sair"},,"Aten��o:")
					//��������������������������������������������������������������������������Ŀ
					//� Fecha a interface com o excel                                            �
					//����������������������������������������������������������������������������
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

//��������������������������������������������������������������������������Ŀ
//� Fecha a interface com o excel                                            �
//����������������������������������������������������������������������������
cBuffer := Space(512)
ExeDLLRun2(nHdl, CMD_CLOSEWORKBOOK, @cBuffer)
ExecInDLLClose(nHdl)

Return(aReturn)

/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �CpDllXls  �Autor  �Jaime Wikanski      � Data �  05/17/06   ���
�������������������������������������������������������������������������͹��
���Desc.     �Funcao para copiar a DLL para a esta��o do usuario          ���
���          �                                                            ���
�������������������������������������������������������������������������͹��
���Uso       �                                                            ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/
Static Function CpDllXls()

//�������������������������������������������������������������������������������Ŀ
//�Declaracao de variaveis                                                        �
//���������������������������������������������������������������������������������
Local cDirDest	:= Alltrim(GetMv("MV_DRDLLXLS",,"c:\apexcel"))
Local nResult	:= 0
Local lReturn	:= .T.
                                                  
//�������������������������������������������������������������������������������Ŀ
//�Cria o diretorio de destino da DLL na estacao do usuario                       �
//���������������������������������������������������������������������������������
If !lIsDir(cDirDest)
	nResult := MakeDir(cDirDest)
Endif
If nResult <> 0
	Aviso("Inconist�ncia","N�o foi poss�vel criar o diret�rio "+cDirDest+" para a DLL de leitura da planilha Excel.",{"Sair"},,"Aten��o:")
	lReturn := .F.
Else
	//�������������������������������������������������������������������������������Ŀ
	//�Copia a DLL para o diretorio na estacao do usuario                             �
	//���������������������������������������������������������������������������������
	If !File("ReadExcel.dll")
		Aviso("Inconist�ncia","N�o foi poss�vel localizar a DLL de leitura da planilha excel (ReadExcel.dll) no diret�rio SYSTEM ou SIGAADV.",{"Sair"},,"Aten��o:")
		lReturn := .F.
	Else		
		If !File(cDirDest+"\ReadExcel.dll")
			COPY FILE ("ReadExcel.dll") TO (cDirDest+"\ReadExcel.dll")
			If !File(cDirDest+"\ReadExcel.dll")
				Aviso("Inconist�ncia","N�o foi poss�vel copiar a DLL de leitura da planilha excel para o diret�rio "+cDirDest+".",{"Sair"},,"Aten��o:")
				lReturn := .F.
			Endif
		Endif
	Endif
Endif

Return(lReturn)


/*
�����������������������������������������������������������������������������������
�������������������������������������������������������������������������������Ŀ��
���Fun��o    � ValCContab	  � Autor � Rafael Gama           � Data � 04.01.11 ���
�������������������������������������������������������������������������������Ĵ��
���Descri��o � Verifica a existencia da Conta Contabil.		                    ���
�������������������������������������������������������������������������������Ĵ��
���Sintaxe   � ValCContab()                                                     ���
�������������������������������������������������������������������������������Ĵ��
���Parametros� Nenhum                                                           ���
�������������������������������������������������������������������������������Ĵ��
���Retorno   � .T. / .F.                                                        ���
�������������������������������������������������������������������������������Ĵ��
��� Uso      � RCTBMA0                                                          ���
��������������������������������������������������������������������������������ٱ�
�����������������������������������������������������������������������������������
�����������������������������������������������������������������������������������
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
�����������������������������������������������������������������������������������
�������������������������������������������������������������������������������Ŀ��
���Fun��o    � ValCCusto	  � Autor � Rafael Gama           � Data � 04.01.11 ���
�������������������������������������������������������������������������������Ĵ��
���Descri��o � Verifica a existencia da Centro de Custo.	                    ���
�������������������������������������������������������������������������������Ĵ��
���Sintaxe   � ValCCusto()                                                      ���
�������������������������������������������������������������������������������Ĵ��
���Parametros� Nenhum                                                           ���
�������������������������������������������������������������������������������Ĵ��
���Retorno   � .T. / .F.                                                        ���
�������������������������������������������������������������������������������Ĵ��
��� Uso      � RCTBMA0                                                          ���
��������������������������������������������������������������������������������ٱ�
�����������������������������������������������������������������������������������
�����������������������������������������������������������������������������������
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
�����������������������������������������������������������������������������������
�������������������������������������������������������������������������������Ŀ��
���Fun��o    � ValItCont	  � Autor � Rafael Gama           � Data � 04.01.11 ���
�������������������������������������������������������������������������������Ĵ��
���Descri��o � Verifica a existencia do Item Contabil.		                    ���
�������������������������������������������������������������������������������Ĵ��
���Sintaxe   � ValItCont()                                                      ���
�������������������������������������������������������������������������������Ĵ��
���Parametros� Nenhum                                                           ���
�������������������������������������������������������������������������������Ĵ��
���Retorno   � .T. / .F.                                                        ���
�������������������������������������������������������������������������������Ĵ��
��� Uso      � RCTBMA0                                                          ���
��������������������������������������������������������������������������������ٱ�
�����������������������������������������������������������������������������������
�����������������������������������������������������������������������������������
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
�����������������������������������������������������������������������������������
�������������������������������������������������������������������������������Ŀ��
���Fun��o    � ValClasVal	  � Autor � Rafael Gama           � Data � 04.01.11 ���
�������������������������������������������������������������������������������Ĵ��
���Descri��o � Verifica a existencia da Classe de Valor		                    ���
�������������������������������������������������������������������������������Ĵ��
���Sintaxe   � ValClasVal()                                                     ���
�������������������������������������������������������������������������������Ĵ��
���Parametros� Nenhum                                                           ���
�������������������������������������������������������������������������������Ĵ��
���Retorno   � .T. / .F.                                                        ���
�������������������������������������������������������������������������������Ĵ��
��� Uso      � RCTBMA0                                                          ���
��������������������������������������������������������������������������������ٱ�
�����������������������������������������������������������������������������������
�����������������������������������������������������������������������������������
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
          
