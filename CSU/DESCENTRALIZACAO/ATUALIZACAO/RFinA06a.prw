#Include "Rwmake.ch"
#Include "Protheus.ch"

#DEFINE c_BR Chr(13)+Chr(10)
/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  � RFinA06a � Autor � Cristiano Figueiroa� Data �  16/01/2006 ���
�������������������������������������������������������������������������͹��
���Descricao � Tela de Rateio por Centro de Custo                         ���
�������������������������������������������������������������������������͹��
���Parametros� Prefixo                                                    ���
���          � Numero                                                     ���
���          � Parcela                                                    ���
���          � Tipo                                                       ���
���          � Fornecedor                                                 ���
���          � Loja                                                       ���
���          � Valor a ser Rateado para a Natureza                        ���
���          � Opcao (2-Visualiza ; 3-Inclusao ; 4-Alteracao ; 5-Delecao) ���
���          � Natureza a ser Rateada por Centro de Custo                 ���
�������������������������������������������������������������������������͹��
���Uso       � Csu CardSystem                                             ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/

User Function RFinA06A( cPreTit , cNumTit , cParTit , cTipTit , cForTit , cLojTit , nVlRat , nOpc , cNatTit )

/*����������������������������������������������������������������������������Ŀ
  �              Declara as Variaveis Locais Utilizadas na Rotina              �
  ������������������������������������������������������������������������������*/

Local   cPic	    := PesqPict("SE2" , "E2_VALOR" , 19 )
Local   oDlg
Local   oGet
Local   aButton     := {}
Local   aHeadOld    := aClone( aHeader)
Local   aColsOld    := aClone( aCols  )                                          

//������������������������������������������������������������Ŀ
//�VG - 2011.02.28 - Vari�veis para a rotina de rateio externo.�
//��������������������������������������������������������������
Local cAnoMes		:= ""
Local cUltRev		:= ""

Local   nOldPos     := n 
n := 1 // Incluido por Flavio Novaes em 04/04/07 - Chamado 000000000923.
/*����������������������������������������������������������������������������Ŀ
  �              Declara as Variaveis Private Utilizadas na Rotina             �
  ������������������������������������������������������������������������������*/
Private cNaturez    := cNatTit
Private cNatTela    := "Natureza : ( " + Alltrim(cNaturez) + " ) - " +  Alltrim(Posicione("SED" , 1 , xFilial("SED") + cNaturez , "ED_DESCRIC"))
Private oValDRat
Private oPerDRat
Private nValRat     := nVlRat
Private nValDRat    := 0
Private nPerDRat    := 0
Private nPosCusEZ   := 0
Private nPosPerEZ   := 0
Private nPosValEZ   := 0
Private nPosDesEZ   := 0
Private nPosClaEZ   := 0
Private nPosIteEZ   := 0
Private nUsadoII    
Private aCols		:= {}
Private aHeader		:= {}
Private nRegs       := 0

Private cChave		:= cPreTit+cNumTit+cParTit+cTipTit+cForTit+cLojTit+cNatTit

//�����������������������������������Ŀ
//�VG - 2011.02.28                    �
//�Caso seja um documento com         �
//�rateio externo, verifica se existem�
//�itens preenchidos para a tabela    �
//�de rateio utilizada.               �
//�������������������������������������
If SF1->F1_XTABRAT == '1'

	//����������������������������������������Ŀ
	//�Verifica na SEV qual a tabela de rateio.�
	//������������������������������������������
	dbSelectArea("SEV")
	dbSetOrder(1)//EV_FILIAL+EV_PREFIXO+EV_NUM+EV_PARCELA+EV_TIPO+EV_CLIFOR+EV_LOJA+EV_NATUREZ
	If dbSeek(xFilial("SEV")+cPreTit+cNumTit+cParTit+cTipTit+cForTit+cLojTit+cNatTit,.F.)

		//������������������������������������������Ŀ
		//�VG - 2011.06.06 - altera��o para utilizar �
		//�a data de compet�ncia.                    �
		//��������������������������������������������
		//cAnoMes	:= SUBSTR(DTOS(SF1->F1_EMISSAO),1,6)
		cAnoMes	:= U_GetCompetencia(SF1->F1_FILIAL+SF1->F1_DOC+SF1->F1_SERIE+SF1->F1_FORNECE+SF1->F1_LOJA)
		cUltRev	:= U_RZB7ULTR(SEV->EV_XCODRAT,cAnoMes,.T.)
		
		//��������������������������Ŀ
		//�Procura a tabela de rateio�
		//����������������������������
		dbSelectArea("ZB8")
		dbSetOrder(1)//ZB8_FILIAL+ZB8_CODRAT+ZB8_ANOMES+ZB8_REVISA+ZB8_SEQUEN
		If !dbSeek(xFilial("ZB8")+SEV->EV_XCODRAT+cAnoMes+cUltRev,.F.)
		
			Aviso("Aviso","A tabela de rateios utilizada ainda n�o teve"+c_BR+;
				          "seus itens preenchidos. Por favor, entre em "+c_BR+;
				          "contato com o respons�vel pela manuten��o "+c_BR+;
				          "da tabela de rateio.",{"OK"},,"Aten��o",,"NOCHECKED")			
			Return .T.
		Endif
	Endif
Endif

/*����������������������������������������������������������������������������Ŀ
  �                    Adicao de Botoes na Enchoice Bar                        �
  ������������������������������������������������������������������������������*/

If Inclui .Or. Altera	
	Aadd( aButton , {'PESQUISA'	, { || TrazRateio()  } , "Externo" } )
   	SetKey(VK_F7,{||TrazRateio()})
	If SF1->F1_XTABRAT <> '1'
		Aadd( aButton , {"DBG06" 	, { || U_FinA06aImp()}, "Importar cadastro", "Importar" }) 
		Aadd( aButton , {"PMSEXCEL"	, { || U_FinA06aExp()}, "Exportar cadastro", "Exportar" })
		Aadd( aButton , {"EXCLUIR"	, { || U_FinA06aDel()}, "Excluir Todos", "Exc. Todos" })
	   	SetKey(VK_F6,{||U_FinA06aImp()})
	   	SetKey(VK_F5,{||U_FinA06aExp()})
	   	SetKey(VK_F4,{||U_FinA06aDel()})
	 EndIf
Endif

/*����������������������������������������������������������������������������Ŀ
  �                  Monta o Aheader conforme a Tabela SEZ                     �
  ������������������������������������������������������������������������������*/

GerAheSEZ()

/*����������������������������������������������������������������������������Ŀ
  �                  Monta o Acols conforme a Tabela SEZ                       �
  ������������������������������������������������������������������������������*/

GerAcoSEZ()

If lMostraTela	

/*����������������������������������������������������������������������������Ŀ
  �                 Monta a Tela das Naturezas por Titulos                     �
  ������������������������������������������������������������������������������*/

   Define MsDialog oDlg Title "Multipla Natureza por Centro de Custo" From 09.0 , 00.0 To 39.2 , 95.00 Of oMainWnd
   
   @ 027.6 , 010.0  Get cRazTela              	                   				Font oBold   Pixel  COLOR CLR_BLUE  Size 358 , 005 When .F.
   @ 039.6 , 010.0  Get cPreTela               	 	               	   			Font oBold   Pixel  COLOR CLR_BLUE  Size 070 , 005 When .F.
   @ 039.6 , 105.6  Get cNumTela                                   				Font oBold   Pixel  COLOR CLR_BLUE  Size 070 , 005 When .F.
//   @ 039.6 , 203.0  Get cParTela                                   	 			Font oBold   Pixel  COLOR CLR_BLUE  Size 070 , 005 When .F.
   @ 039.6 , 300.0  Get cTipTela                                   	 	  		Font oBold   Pixel  COLOR CLR_BLUE  Size 068 , 005 When .F.
                                                                     	
   @ 013.6 , 000.5  To 16.08  , 23.00 Of oDlg
   @ 013.6 , 023.4  To 16.08  , 46.05 Of oDlg 
   @ 001.0 , 000.5  To 03.85  , 46.50 Of oDlg
	
   @ 017.0 , 010.0  Say "Dados do Titulo"                          	   			Font oBoldIII Pixel COLOR CLR_BLUE
   
   @ 197.6 , 046.4  Say "Valor a Ratear "                       	   			Font oBoldIV  Pixel COLOR CLR_HBLUE 
   @ 197.6 , 086.6  Say nValRat Picture cPic                       	   			Font oBoldIV  Pixel COLOR CLR_HBLUE 

   @ 209.6 , 046.0  Say "Valor Rateado  "                       	   			Font oBoldIV  Pixel COLOR CLR_HBLUE 
   @ 209.6 , 086.6  Say oValDRat Var nValDRat Picture cPic      	   			Font oBoldIV  Pixel COLOR CLR_HBLUE 

   @ 197.6 , 200.0  Say "Percentual Distribuido:                           %"  	Font oBoldIV  Pixel COLOR CLR_HBLUE 
   @ 197.6 , 290.6  Say oPerDRat Var nPerDRat Picture "@E 999.999999"  			Font oBoldIV  Pixel COLOR CLR_HBLUE

   @ 209.6 , 200.0  Say cNatTela                                	   			Font oBoldIV  Pixel COLOR CLR_HBLUE 

 /*����������������������������������������������������������������������������Ŀ
   �         Chama a Funcao que Atualiza o Campo do Valor Distribuido           �
   ������������������������������������������������������������������������������*/

   RecValSEZ()

/*����������������������������������������������������������������������������Ŀ
  �             Chama a GetDados para Receber as Linhas do Acols               �
  ������������������������������������������������������������������������������*/

   oGet := MSGetDados():New( 60 , 4 , 188 , 371 , nOpcao ,"U_VldLinCC", .T. ,, nOpcao # 2 ,,,,9999 )       
   
/*����������������������������������������������������������������������������Ŀ
  �             Ativa a Janela de Dialogo da Multipla Natureza                 �
  ������������������������������������������������������������������������������*/
	
   Activate MsDialog oDlg On Init EnchoiceBar( oDlg , {||nOpca := 1 , If( VldTudCC() , oDlg:End() , nOpca := 0 )},{||nOpca:=0,oDlg:End()},, aButton ) Center 

Endif

/*������������������������������������������������������������������������������Ŀ
  � Caso nao tenha ocorrido o Rateio por Centro de Custo volta o Flag para "Nao" �
  ��������������������������������������������������������������������������������*/

If nRegs == 0
   M->EV_RATEICC := "2"
Endif

/*���������������������������������������������������������������������Ŀ
  �                  Retorna as Variaveis Originais                     �
  �����������������������������������������������������������������������*/

aHeader := aHeadOld
aCols   := aColsOld
n       := nOldPos

Return .T.

/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  � GerAheSEZ � Autor � Cristiano Figueiroa� Data � 16/01/2006 ���
�������������������������������������������������������������������������͹��
���Descricao � Gera o aHeader para a Tela de Centro de Custo              ���
�������������������������������������������������������������������������͹��
���Uso       � Csu CardSystem                                             ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/

Static Function GerAheSEZ()

/*��������������������������������������������������������������Ŀ
  �                     Zera as Variaveis                        �
  ����������������������������������������������������������������*/

nUsadoII  := 0
aHeader   := {}

/*��������������������������������������������������������������Ŀ
  �                     Monta o aHeader                          �
  ����������������������������������������������������������������*/

DbSelectArea("SX3")
DbSetOrder(1)
DbSeek("SEZ")

/*��������������������������������������������������������������Ŀ
  �                     Monta o aHeader                          �
  ����������������������������������������������������������������*/

Do While !Eof() .And. ( X3_ARQUIVO == "SEZ" )

/*����������������������������������������������������������������Ŀ
  �Ignora alguns campos que nao deverao ser adicionados no aHeader �
  ������������������������������������������������������������������*/

   If  !( Alltrim(X3_CAMPO) $ ( "EZ_CCUSTO;EZ_PERC;EZ_VALOR;EZ_DESCRIC;EZ_ITEMCTA;EZ_CLVL" ) )
	   DbSkip()
	   Loop
   EndIf

/*����������������������������������������������������������������Ŀ
  �               Adiciona os Campos no aHeader                    �
  ������������������������������������������������������������������*/

   If X3Uso(X3_USADO) .And. cNivel >= X3_NIVEL
      Aadd( aHeader , { TRIM(X3_TITULO) , X3_CAMPO , X3_PICTURE , X3_TAMANHO , X3_DECIMAL , X3_VLDUSER , X3_USADO , X3_TIPO , X3_ARQUIVO , X3_CONTEXT } )
   Endif

/*����������������������������������������������������������������Ŀ
  �               Adiciona algumas Validacoes                      �
  ������������������������������������������������������������������*/

   If     Alltrim(aHeader[Len(aHeader)][2]) == "EZ_PERC" 
      aHeader[Len(aHeader)][6] := 'u_CalValEZ() .And. M->EZ_PERC > 0 .And. M->EZ_PERC < 100.01'
      aHeader[Len(aHeader)][3] := '@E 999.999999'
   ElseIf Alltrim(aHeader[Len(aHeader)][2]) == "EZ_VALOR"
      aHeader[Len(aHeader)][6] := 'u_CalPerEZ() .And. M->EZ_VALOR > 0'
   ElseIf Alltrim(aHeader[Len(aHeader)][2]) == "EZ_CCUSTO"
      //aHeader[Len(aHeader)][6] := 'ExistCpo("CTT") .And. u_VerCCBloq(M->EZ_CCUSTO) .And. Ctb105CC()'
      aHeader[Len(aHeader)][6] := 'ExistCpo("CTT") .And. u_VerCCBloq(M->EZ_CCUSTO)'
   ElseIf Alltrim(aHeader[Len(aHeader)][2]) == "EZ_ITEMCTA"
      //aHeader[Len(aHeader)][6] := 'ExistCpo("CTD") .And. Ctb105Item()'
      aHeader[Len(aHeader)][6] := 'ExistCpo("CTD")'
   ElseIf Alltrim(aHeader[Len(aHeader)][2]) == "EZ_CLVL"
      //aHeader[Len(aHeader)][6] := 'ExistCpo("CTH") .And. Ctb105ClVl()'
      aHeader[Len(aHeader)][6] := 'ExistCpo("CTH")'
   Endif   

/*����������������������������������������������������������������Ŀ
  �            Processa o Proximo Registro do SX3                  �
  ������������������������������������������������������������������*/

   DbSkip()
   Loop

EndDo

/*��������������������������������������������������������������Ŀ
  �           Verifica a Quantidade de Itens no AHeader          �
  ����������������������������������������������������������������*/

nUsadoII := Len(aHeader)

Return                        

/*
������������������������������������������������������������������������������
������������������������������������������������������������������������������
��������������������������������������������������������������������������ͻ��
���Programa  � GerAcoSEZ � Autor � Cristiano Figueiroa� Data �  16/01/2006 ���
��������������������������������������������������������������������������͹��
���Descricao � Gera o aCols de Acordo a Tela de Centro de Custos           ���
��������������������������������������������������������������������������͹��
���Uso       � Csu CardSystem                                              ���
��������������������������������������������������������������������������ͼ��
������������������������������������������������������������������������������
������������������������������������������������������������������������������
*/

Static Function GerAcoSEZ()

/*����������������������������������������������������������������������������Ŀ
  �              Declara as Variaveis Locais Utilizadas na Rotina              �
  ������������������������������������������������������������������������������*/

Local c := 1

/*��������������������������������������������������������������Ŀ
  �         Verifica a Posicao dos Campos no aHeader             �
  ����������������������������������������������������������������*/

VerPosSez()

/*��������������������������������������������������������������Ŀ
  �   Caso seja Inclusao inclui uma linha em Branco no Acols     �
  ����������������������������������������������������������������*/

If nOpcao == 3 .And. CUS->( Reccount() ) == 0

   N := 1

  /*��������������������������������������������������������������Ŀ
    �    Chama a funcao que adiciona uma nova linha no Acols       �
    ����������������������������������������������������������������*/
   
   AdicCols()
   
Else

	//���������������������������������������������Ŀ
	//�VG - 2011.02.28                              �
	//�Verificar se utiliza tabela de rateio externo�
	//�����������������������������������������������
	If SF1->F1_XTABRAT == '1'
		//����������������������������������������Ŀ
		//�Verifica na SEV qual a tabela de rateio.�
		//������������������������������������������
		dbSelectArea("SEV")
		dbSetOrder(1)//EV_FILIAL+EV_PREFIXO+EV_NUM+EV_PARCELA+EV_TIPO+EV_CLIFOR+EV_LOJA+EV_NATUREZ
		If dbSeek(xFilial("SEV")+cChave,.F.)
	
			//������������������������������������������Ŀ
			//�VG - 2011.06.06 - altera��o para utilizar �
			//�a data de compet�ncia.                    �
			//��������������������������������������������
			//cAnoMes	:= SUBSTR(DTOS(SF1->F1_EMISSAO),1,6)
			cAnoMes	:= U_GetCompetencia(SF1->F1_FILIAL+SF1->F1_DOC+SF1->F1_SERIE+SF1->F1_FORNECE+SF1->F1_LOJA)
			cUltRev	:= U_RZB7ULTR(SEV->EV_XCODRAT,cAnoMes,.T.)
		
			//��������������������������Ŀ
			//�Procura a tabela de rateio�
			//����������������������������
			dbSelectArea("ZB8")
			dbSetOrder(1)//ZB8_FILIAL+ZB8_CODRAT+ZB8_ANOMES+ZB8_REVISA+ZB8_SEQUEN
			If dbSeek(xFilial("ZB8")+SEV->EV_XCODRAT+cAnoMes+cUltRev,.F.)
		
				//������������������������������������������Ŀ
				//�Carregar o aCols com base nos itens da ZB8�
				//��������������������������������������������
				Do While ZB8->(ZB8_FILIAL+ZB8_CODRAT+ZB8_ANOMES+ZB8_REVISA)==xFilial("ZB8")+SEV->EV_XCODRAT+cAnoMes+cUltRev
				
					Aadd ( aCols , Array( nUsadoII + 1) )

					/*�����������������������������������������������������������������������������Ŀ
					  �                 Atribui as Colunas os Valores Ja Existentes                 �
					  �������������������������������������������������������������������������������*/
					aCols[Len(aCols)][nPosCusEZ    ] := ZB8->ZB8_CCDBTO
					aCols[Len(aCols)][nPosDesEZ    ] := Posicione("CTT",1,xFilial("CTT")+ZB8->ZB8_CCDBTO,"CTT_DESC01")
					aCols[Len(aCols)][nPosClaEZ    ] := ZB8->ZB8_CLVLDB          
					aCols[Len(aCols)][nPosIteEZ    ] := ZB8->ZB8_ITDBTO            
					aCols[Len(aCols)][nPosValEZ    ] := (nValRat*ZB8->ZB8_PERCEN)/100
					aCols[Len(aCols)][nPosPerEZ    ] := ZB8->ZB8_PERCEN
//					aCols[Len(aCols)][nUsadoII + 1 ] := CUS->FLAG					
				     
					dbSelectArea("ZB8")
					dbSkip()
				EndDo
		
			Endif
		Endif
		
	Else

		/*��������������������������������������������������������������Ŀ
		  �     Abre a Tabela Temporaria de Rateio de Centro de Custo    �
		  ����������������������������������������������������������������*/

		DbSelectArea("CUS")       
		DbGoTop()

		/*����������������������������������������������������������������������������Ŀ
		  �               Pesquisa no Temporario de ja existe a Natureza               �
		  ������������������������������������������������������������������������������*/

		If DbSeek ( cNaturez  )

		/*����������������������������������������������������������������������������Ŀ
		  �    Carrega no Acols todos os Centros de Custos Rateados para a Natureza    �
		  ������������������������������������������������������������������������������*/

			Do While CUS->( !Eof() ) .And. CUS->NATUREZ == cNaturez

				If CUS->FLAG
					DbSkip()   
					Loop
				EndIf	
				/*�����������������������������������������������������������������������������Ŀ
				  |   Adiciona um Array no aCols Contendo o Numero de Colunas Usadas na Rotina  �
				  �������������������������������������������������������������������������������*/

				Aadd ( aCols , Array( nUsadoII + 1) )

				/*�����������������������������������������������������������������������������Ŀ
				  �                 Atribui as Colunas os Valores Ja Existentes                 �
				  �������������������������������������������������������������������������������*/

				aCols[c][nPosCusEZ    ] := CUS->CCUSTO
				aCols[c][nPosDesEZ    ] := CUS->DESCUS 
				aCols[c][nPosClaEZ    ] := CUS->CLASSE          
				aCols[c][nPosIteEZ    ] := CUS->ITEM            
				aCols[c][nPosValEZ    ] := CUS->VALOR 
				aCols[c][nPosPerEZ    ] := CUS->PERC
				aCols[c][nUsadoII + 1 ] := CUS->FLAG
        
				c++

				DbSkip()   
				Loop
			Enddo

		Endif   
  	Endif
         
Endif

Return

/*
���������������������������������������������������������������������������������
���������������������������������������������������������������������������������
�����������������������������������������������������������������������������ͻ��
���Programa  � VerPosCpoSez � Autor � Cristiano Figueiroa� Data �  26/12/2005 ���
�����������������������������������������������������������������������������͹��
���Descricao � Ver a Posicao dos Campos no aHeader do Centro de Custo         ���
�����������������������������������������������������������������������������͹��
���Uso       � Csu CardSystem                                                 ���
�����������������������������������������������������������������������������ͼ��
���������������������������������������������������������������������������������
���������������������������������������������������������������������������������
*/

Static Function VerPosSez()

/*��������������������������������������������������������������Ŀ
  �         Verifica a Posicao dos Campos no aHeader             �
  ����������������������������������������������������������������*/

nPosCusEZ   := aScan( aHeader , { |x| Upper( Trim ( x[2] ) ) == "EZ_CCUSTO"  })
nPosPerEZ   := aScan( aHeader , { |x| Upper( Trim ( x[2] ) ) == "EZ_PERC"    })
nPosValEZ   := aScan( aHeader , { |x| Upper( Trim ( x[2] ) ) == "EZ_VALOR"   })
nPosDesEZ   := aScan( aHeader , { |x| Upper( Trim ( x[2] ) ) == "EZ_DESCRIC" })
nPosClaEZ   := aScan( aHeader , { |x| Upper( Trim ( x[2] ) ) == "EZ_CLVL"    })
nPosIteEZ   := aScan( aHeader , { |x| Upper( Trim ( x[2] ) ) == "EZ_ITEMCTA" })

Return

/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �RecValSEZ � Autor � Cristiano Figueiroa� Data �  12/01/2006 ���
�������������������������������������������������������������������������͹��
���Descricao � Recalcula o Valor Distribuido no Acols                     ���
�������������������������������������������������������������������������͹��
���Uso       � Csu CardSystem                                             ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/

Static Function RecValSEZ()

/*����������������������������������������������������������������������������Ŀ
  �              Declara as Variaveis Locais Utilizadas na Rotina              �
  ������������������������������������������������������������������������������*/

Local i

/*����������������������������������������������������������������������������Ŀ
  �                   Zera a Variavel do Valor Distribuido                     �
  ������������������������������������������������������������������������������*/

nValDRat := 0
nPerDRat := 0

/*����������������������������������������������������������������������������Ŀ
  �                 Zera a Variavel da Quantidade de Registros                 �
  ������������������������������������������������������������������������������*/

nRegs    := 0 

/*����������������������������������������������������������������������������Ŀ
  �                        Calcula o Valor Distribuido                         �
  ������������������������������������������������������������������������������*/

For i := 1 To Len(aCols)

   /*����������������������������������������������������������������������������Ŀ
     �       Se a linha nao estiver deletada , acumula o valor digitado           �
     ������������������������������������������������������������������������������*/

   If !aCols[i][nUsadoII + 1]
      nValDRat += aCols[i][nPosValEZ ]
      nPerDRat += aCols[i][nPosPerEZ ]

      If aCols [ i , nPosValEZ ] <> 0
         nRegs  ++
      Endif   

   EndIf

Next

nPerDRat := Round(nPerDRat,2)

/*����������������������������������������������������������������������������Ŀ
  �                        Atualiza o Objeto na Tela                           �
  ������������������������������������������������������������������������������*/

oValDRat:Refresh() 
oPerDRat:Refresh() 

Return
/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �CalValEZ  � Autor � Cristiano Figueiroa� Data �  11/01/2006 ���
�������������������������������������������������������������������������͹��
���Descricao � Calcula o Valor com Base no Percentual Informado           ���
�������������������������������������������������������������������������͹��
���Uso       � Csu CardSystem                                             ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/

User Function CalValEZ()

/*����������������������������������������������������������������������������Ŀ
  �              Declara as Variaveis Locais Utilizadas na Rotina              �
  ������������������������������������������������������������������������������*/

Local lRet   := .F. 
Local cAlias := Alias()

/*����������������������������������������������������������������������������Ŀ
  �            Calcula o Valor de Acordo com o Percentual Digitado             �
  ������������������������������������������������������������������������������*/

If !Empty( M->EZ_PERC )

   aCols[n][nPosValEZ] := Round( ( M->EZ_PERC / 100 ) * nValRat , 2 )
   aCols[n][nPosPerEZ] := Round( M->EZ_PERC,6 )
   
 /*����������������������������������������������������������������������������Ŀ
   �         Chama a Funcao que Atualiza o Campo do Valor Distribuido           �
   ������������������������������������������������������������������������������*/

   RecValSEZ()
   lRet := .T.

Endif

Return lRet

/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �CalPerEZ  � Autor � Cristiano Figueiroa� Data �  11/01/2006 ���
�������������������������������������������������������������������������͹��
���Descricao � Calcula o Percentual com Base no Valor Informado           ���
�������������������������������������������������������������������������͹��
���Uso       � Csu CardSystem                                             ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/

User Function CalPerEZ()

/*����������������������������������������������������������������������������Ŀ
  �              Declara as Variaveis Locais Utilizadas na Rotina              �
  ������������������������������������������������������������������������������*/

Local lRet   := .F. 
Local cAlias := Alias()

/*����������������������������������������������������������������������������Ŀ
  �            Calcula o Valor de Acordo com o Percentual Digitado             �
  ������������������������������������������������������������������������������*/

If !Empty( M->EZ_VALOR )

   aCols[n][nPosPerEZ]  := Round( M->EZ_VALOR / nValRat * 100 , 6 )
   aCols[n][nPosValEZ]  := Round( ( aCols[n][nPosPerEZ] / 100 ) * nValRat , 2 )

 /*����������������������������������������������������������������������������Ŀ
   �         Chama a Funcao que Atualiza o Campo do Valor Distribuido           �
   ������������������������������������������������������������������������������*/

   RecValSEZ()
   lRet := .T.

Endif

Return lRet

/*
������������������������������������������������������������������������������
������������������������������������������������������������������������������
��������������������������������������������������������������������������ͻ��
���Programa  � VldLinCC  � Autor � Cristiano Figueiroa� Data �  16/01/2006 ���
��������������������������������������������������������������������������͹��
���Descricao � Valida a Linha Digitada no Rateio por Centro de Custo       ���
��������������������������������������������������������������������������͹��
���Uso       � Csu CardSystem                                              ���
��������������������������������������������������������������������������ͼ��
������������������������������������������������������������������������������
������������������������������������������������������������������������������
*/

User Function VldLinCC()

/*����������������������������������������������������������������������������Ŀ
  �              Declara as Variaveis Utilizadas na Rotina                     �
  ������������������������������������������������������������������������������*/

Local cObrig     := "EZ_PERC�EZ_VALOR�EZ_CCUSTO�EZ_ITEMCTA�EZ_CLVL" // Campos Obrigatorios
Local cContCC    := ""
Local nContPerc  := 0
Local nContVlr   := 0 
Local cItemCta   := "" // validar a unidade de negocio contra o CC

/*����������������������������������������������������������������������������Ŀ
  �         Chama a Funcao que Atualiza o Campo do Valor Distribuido           �
  ������������������������������������������������������������������������������*/

RecValSEZ()

/*���������������������������������������������������������������������Ŀ
  �      Caso a linha esteja deletada nao efetua qualquer validacao     �
  �����������������������������������������������������������������������*/

If aCols[ n , Len(aHeader) + 1 ]
   Return .T.
Endif

/*���������������������������������������������������������������������Ŀ
  � Inicia a Validacao da Linha Atual na Tela Rateio de Natureza        �
  �����������������������������������������������������������������������*/

For x := 1 to Len(aHeader)

 /*���������������������������������������������������������������������Ŀ
   � Valida as linhas nao deletadas e obrigatorias                       �
   �����������������������������������������������������������������������*/

   If Trim(aHeader[x , 2] ) $ cObrig 
	
   /*���������������������������������������������������������������������Ŀ
     � Valida os campos obrigatorios e numericos                           �
     �����������������������������������������������������������������������*/

      If Trim(aHeader[ x , 8 ]) == "N" .And. aCols[ n , x ] == 0
	     ApMsgInfo("O Campo : " + Trim(aHeader[ x , 1 ]) + " � obrigat�rio !" , "Aten��o !" )
	     Return .F.
	  Endif				

   /*���������������������������������������������������������������������Ŀ
     � Valida os campos obrigatorios e caractere                           �
     �����������������������������������������������������������������������*/

      If Trim(aHeader[ x , 8 ]) == "C" .and. Trim(aCols[ n , x ]) == ""
	     ApMsgInfo("O Campo : " + Trim(aHeader[ x , 1 ]) + " � obrigat�rio !" , "Aten��o !" )
         Return .F.     
      Endif				

   Endif
 
 /*���������������������������������������������������������������������Ŀ
   �         Verifica o conteudo dos campos digitados                    �
   �����������������������������������������������������������������������*/

   If     Trim(aHeader[ x , 2]) == "EZ_PERC"
          nContPerc    := aCols[ n, x ]
   ElseIf Trim(aHeader[ x , 2]) == "EZ_VALOR"
          nContVlr     := aCols[ n, x ]
   ElseIf Trim(aHeader[ x , 2]) == "EZ_CCUSTO"
          cContCC      := aCols[ n , x ]
   ElseIf Trim(aHeader[ x , 2]) == "EZ_ITEMCTA" // unidade de negocio
          cItemCta     := aCols[ n , x ]          
   Endif  

Next

/*���������������������������������������������������������������������Ŀ
  �               Valida as informacoes digitadas                       �
  �����������������������������������������������������������������������*/

If nContVlr > nValRat
   MsgInfo("O Valor informado nao pode ser Maior que o Valor a ser Rateado !" , "Aten��o !" )
   Return .F.
Endif

//CVerneque 17/Jan
If SubStr(cContCC,1,2) <> SubStr(cItemCta,1,2)
   MsgInfo("Unidade de negocio nao pertence ao centro de custo informado !" , "Aten��o !" )
   Return .F.
Endif


Return .T.

/*
������������������������������������������������������������������������������
������������������������������������������������������������������������������
��������������������������������������������������������������������������ͻ��
���Programa  � VldTudCC  � Autor � Cristiano Figueiroa� Data �  16/01/2006 ���
��������������������������������������������������������������������������͹��
���Descricao � Valida todos os Dados digitados no Rateio                   ���
��������������������������������������������������������������������������͹��
���Uso       � Csu CardSystem                                              ���
��������������������������������������������������������������������������ͼ��
������������������������������������������������������������������������������
������������������������������������������������������������������������������
*/

Static Function VldTudCC()

/*����������������������������������������������������������������������������Ŀ
  �              Declara as Variaveis Utilizadas na Rotina                     �
  ������������������������������������������������������������������������������*/

Local nValTotal  := 0 
Local nValPerc   := 0              
Local cCCusto    := ""
Local cItemCta   := ""
Local cObrig     := "EZ_PERC�EZ_VALOR�EZ_CCUSTO�EZ_ITEMCTA�EZ_CLVL" // Campos Obrigatorios

/*����������������������������������������������������������������������������Ŀ
  �         Chama a Funcao que Aglutina os Registros iguais do Acols           �
  ������������������������������������������������������������������������������*/

SomaAcols()

/*���������������������������������������������������������������������Ŀ
  �   Caso seja Visualizacao ou Exclusao nao valida as informacoes      �
  �����������������������������������������������������������������������*/

If nOpcao == 2 .Or. nOpcao == 5
   Return .T.
Endif
   
/*���������������������������������������������������������������������Ŀ
  � Inicia a Validacao da Linha Atual na Tela Rateio de Natureza        �
  �����������������������������������������������������������������������*/

For x := 1 to Len(aCols) 

 /*���������������������������������������������������������������������Ŀ
   � Soma o Valor Total dos Movimentos                                   �
   �����������������������������������������������������������������������*/

   If ! aCols[ x , Len(aHeader) + 1 ]

   /*���������������������������������������������������������������������Ŀ
     �         Verifica se o Item e a Classe de Valor estao em Branco      �
     �����������������������������������������������������������������������*/

      If Empty( Acols [x][nPosIteEZ] )
         Aviso("Campo Obrigat�rio" , "O Campo Unidade de Neg�cio ( Item Cont�bil ) � Obrigat�rio ! Preencha a Unidade de Neg�cio para antes de realizar a Grava��o !" , {"Ok"} , 1 , "Campo Obrigat�rio !" )      
         Return .F.         
      Endif
      
      If Empty( Acols [x][nPosClaEZ] )
         Aviso("Campo Obrigat�rio" , "O Campo Opera��o ( Classe de Valor ) � Obrigat�rio ! Preencha a Opera��o antes de realizar a Grava��o !" , {"Ok"} , 1 , "Campo Obrigat�rio !" )
         Return .F.         
      Endif


   /*���������������������������������������������������������������������Ŀ
     �         Verifica se o Item e o Centro de Custo estao em sincronia   �
     �����������������������������������������������������������������������*/

      If SubStr( Acols [x][nPosIteEZ],1,2 ) <> SubStr( Acols [x][nPosCusEZ],1,2 )
         Aviso("Unidade de Negocio" , "A unidade de negocio nao pertence ao centro de custo informado !" , {"Ok"} , 1 , "Campo Incorreto !" )      
         Return .F.         
      Endif
      
    /*���������������������������������������������������������������������Ŀ
      � Soma o Valor Total dos Movimentos                                   �
      �����������������������������������������������������������������������*/

      nValTotal += Acols [x][nPosValEZ]
      nValPerc  += Acols [x][nPosPerEZ]

      // Sergio em Jan/2009: 0069/09 - No rateio da NFE nao permitir a utilizacao de entidades invalidas
            
      If !U_VldCTBg( aCols[x][nPosIteEz], aCols[x][nPosCusEz], aCols[x][nPosClaEz], Str(x) )
         Return .f.
      EndIf
      
    /*���������������������������������������������������������������������Ŀ
      �          Valida as Linhas Duplicadas dentro do Rateio               �
      �����������������������������������������������������������������������*/

      For v := 1 to Len(aCols)

         If !aCols[ v , Len(aHeader) + 1 ]

            If v <> x .And. aCols[x][nPosCusEz] + aCols[x][nPosIteEz] + aCols[x][nPosClaEz] == aCols[v][nPosCusEz] + aCols[v][nPosIteEz] + aCols[v][nPosClaEz]
               MsgInfo("J� existe uma linha rateada com o mesmo Centro de Custo + Unidade de Negocio + Operacao Cadastrado !" ,  "Aten��o ! " )
               Return .f.
            EndIf
            
         Endif  
                                  
      Next v

   Endif   
 
Next x

/*���������������������������������������������������������������������Ŀ
  �               Valida as informacoes digitadas                       �
  �����������������������������������������������������������������������*/

If Round( nValPerc,2 ) <> 100.00
   MsgInfo("O Percentual Rateado devera ser 100 % !" , "Aten��o !" )
   Return .F.
Else

/*���������������������������������������������������������������������������Ŀ
  � Caso o Rateio seja 100 % e houver divergencia de valores , chama a rotina �
  � que ajusta a Diferenca encontrada.                                        �
  �����������������������������������������������������������������������������*/

   If Round( nValRat,2) <> Round( nValTotal,2 )
//      AjustaDif ( nValRat , nValTotal )
//Alterado por Tatiana A. Barbosa em 08/02/10
//      Aviso("Arredondamento de Valores" , "Por quest�es de arredondamento nos percentuais distribu�dos o �ltimo �tem do rateio sofreu um ajuste autom�tico !" , {"Ok"} , 1 , "Informa��o !! " )
	MsgInfo("Por quest�es de arredondamento nos percentuais distribu�dos o valor rateado � diferente do valor a ratear. � necess�rio ajustar os valores para grava��o do rateio!" , "Aten��o !" )
	Return .F.
   Endif

Endif

/*���������������������������������������������������������������������Ŀ
  �              Chama a Funcao de Gravacao do Rateio                   �
  �����������������������������������������������������������������������*/

GrvTmpMulCC()

Return .T.

/*
��������������������������������������������������������������������������������
��������������������������������������������������������������������������������
����������������������������������������������������������������������������ͻ��
���Programa  � GrvTmpMulCC  � Autor � Cristiano Figueiroa� Data � 18/01/2006 ���
����������������������������������������������������������������������������͹��
���Descricao � Grava o  Arquivo Temporario de Rateio de Centro de Custo      ���
����������������������������������������������������������������������������͹��
���Uso       � Csu CardSystem                                                ���
����������������������������������������������������������������������������ͼ��
��������������������������������������������������������������������������������
��������������������������������������������������������������������������������
*/

Static Function GrvTmpMulCC()

/*����������������������������������������������������������������������������Ŀ
  �                    Declara as variaveis utilizadas                         �
  ������������������������������������������������������������������������������*/

Local l

/*����������������������������������������������������������������������������Ŀ
  �            Abre a Tabela Temporaria do Rateio por Centro de Custo          �
  ������������������������������������������������������������������������������*/

DbSelectArea("CUS")

/*����������������������������������������������������������������������������Ŀ
  �             Processa todos os Registros do Acols do Rateio                 �
  ������������������������������������������������������������������������������*/

For l := 1 to Len(aCols)

/*����������������������������������������������������������������������������Ŀ
  �      Pesquisa no Temporario de ja existe a Natureza e o Centro de Custo    �
  ������������������������������������������������������������������������������*/

   If DbSeek ( cNaturez + aCols[l][nPosCusEz] + aCols[l][nPosIteEz]  + aCols[l][nPosClaEz] )
      Reclock("CUS" , .F.)
   Else
      Reclock("CUS" , .T.)      
   Endif   

/*����������������������������������������������������������������������������Ŀ
  �                 Grava as Informacoes no Arquivo Temporario                 �
  ������������������������������������������������������������������������������*/
         
   CUS->NATUREZ := cNaturez
   CUS->CCUSTO  := aCols[l][nPosCusEz]
   CUS->DESCUS  := Posicione("CTT" , 1 , xFilial("CTT") + CUS->CCUSTO , "CTT_DESC01") 
   CUS->ITEM    := aCols[l][nPosIteEz]
   CUS->CLASSE  := aCols[l][nPosClaEz]
   CUS->VALOR   := aCols[l][nPosValEz]
   CUS->PERC    := aCols[l][nPosPerEz]
   CUS->FLAG    := aCols[l][nUsadoII + 1]
   MsUnLock()

Next l   


Return

/*
��������������������������������������������������������������������������������
��������������������������������������������������������������������������������
����������������������������������������������������������������������������ͻ��
���Programa  �  TrazRateio  � Autor � Cristiano Figueiroa� Data � 23/01/2006 ���
����������������������������������������������������������������������������͹��
���Descricao � Traz o Rateio Externo conforme codigo informado               ���
����������������������������������������������������������������������������͹��
���Uso       � Csu CardSystem                                                ���
����������������������������������������������������������������������������ͼ��
��������������������������������������������������������������������������������
��������������������������������������������������������������������������������
*/

Static Function TrazRateio()

/*����������������������������������������������������������������������������Ŀ
  �                    Declara as variaveis utilizadas                         �
  ������������������������������������������������������������������������������*/

Local   oDlg2
Local   cCodRateio	:= CriaVar("CTJ_RATEIO")
Local   nOpca 		:= 0
Local   cItem	    := "00"
Private nPercent  	:= 100

/*����������������������������������������������������������������������������Ŀ
  �                Solicita o Posicionamento na Linha Superior                 �
  ������������������������������������������������������������������������������*/

If aCols[Len(aCols)][nPosValEZ] == 0 .And. Len(aCols) > 1
   Alert("N�o � possivel a execu��o da Rotina de Rateio Externo em Linhas em Branco !!!")
   Return .T.
Endif

/*����������������������������������������������������������������������������Ŀ
  �                Monta a Tela para Receber o Codigo do Rateio                �
  ������������������������������������������������������������������������������*/

Define MsDialog oDlg2 From  094 , 001 To 240 , 226 Title "Selecione o Rateio Externo" Pixel

@ 005 , 003 To 040 , 110 Of oDlg2 Pixel
@ 042 , 003 To 072 , 110 Of oDlg2 Pixel

@ 010 , 005 Say "Rateio"       Font oBoldIII Pixel COLOR CLR_HBLUE
@ 025 , 005 Say "Percentual"   Font oBoldIII Pixel COLOR CLR_HBLUE

@ 010 , 055 MsGet cCodRateio F3 "CTJ" Picture "@!"        Size 040 , 010 Of oDLG2 Pixel Valid VldCodRat( cCodRateio )
@ 025 , 055 MsGet nPercent            Picture "@E 999.99" Size 040 , 010 Of oDLG2 Pixel Valid VldPerRat( cCodRateio , nPercent )

/*����������������������������������������������������������������������������Ŀ
  �                Monta a Tela para Receber o Codigo do Rateio                �
  ������������������������������������������������������������������������������*/

Define SButton From 051 , 025 Type 1 Enable Of oDlg2 Action (nOpca := 1 , Iif( CarregaRat( cCodRateio , nPercent ) , oDlg2:End(),nOpca := 0))
Define SButton From 051 , 067 Type 2 Enable Of oDlg2 Action (oDlg2:End() , nOpca := 0)
			
/*����������������������������������������������������������������������������Ŀ
  �                Monta a Tela para Receber o Codigo do Rateio                �
  ������������������������������������������������������������������������������*/

Activate MsDialog oDlg2 Centered

Return

/*
��������������������������������������������������������������������������������
��������������������������������������������������������������������������������
����������������������������������������������������������������������������ͻ��
���Programa  � CarregaRat   � Autor � Cristiano Figueiroa� Data � 23/01/2006 ���
����������������������������������������������������������������������������͹��
���Descricao � Traz o Rateio Externo conforme codigo informado               ���
����������������������������������������������������������������������������͹��
���Uso       � Csu CardSystem                                                ���
����������������������������������������������������������������������������ͼ��
��������������������������������������������������������������������������������
��������������������������������������������������������������������������������
*/

Static Function CarregaRat( cCodRat , nPerRat )

/*����������������������������������������������������������������������������Ŀ
  �              Declara as Variaveis Locais Utilizadas na Rotina              �
  ������������������������������������������������������������������������������*/

Local nCols  := 1
Local nValor := 0

/*����������������������������������������������������������������������������Ŀ
  �       Calcula o Valor a ser Rateado com Base no Percentual Informado       �
  ������������������������������������������������������������������������������*/

nValor := Round( nValRat * (nPerRat / 100 ),2 )

/*������������������������������������������������������������������������������Ŀ
  �Carrega Todos os Registros no Acols de acordo com o codigo do Rateio digitado �
  ��������������������������������������������������������������������������������*/

Do While !Eof() .And. CTJ->CTJ_RATEIO == cCodRat
      
/*������������������������������������������������������������������������Ŀ
  �             Verifica se o Centro de Custo esta Bloqueado               �
  ��������������������������������������������������������������������������*/

   If U_VerCCBloq(CTJ->CTJ_CCD) .And. U_VerCCBloq(CTJ->CTJ_CCC)

    /*������������������������������������������������������Ŀ
      �           Adiciona mais uma Linha no Acols           �
      ��������������������������������������������������������*/

      If aCols[Len(aCols)][nPosValEZ] == 0
         nCols := Len(aCols)
      Else

       /*��������������������������������������������������������������Ŀ
         �    Chama a funcao que adiciona uma nova linha no Acols       �
         ����������������������������������������������������������������*/
   
         AdicCols()

         nCols := Len(aCols)
  
      Endif

   /*������������������������������������������������������������������������Ŀ
     �               Atribui os Dados do Rateio no Acols                      �
     ��������������������������������������������������������������������������*/

      If !Empty( CTJ->CTJ_CCD )
         aCols[nCols][nPosCusEZ]  := CTJ->CTJ_CCD
      Else   
         aCols[nCols][nPosCusEZ]  := CTJ->CTJ_CCC
      Endif

      If !Empty( CTJ->CTJ_ITEMD )
         aCols[nCols][nPosIteEZ]  := CTJ->CTJ_ITEMD
      Else   
         aCols[nCols][nPosIteEZ]  := CTJ->CTJ_ITEMC
      Endif


      If !Empty( CTJ->CTJ_CLVLDB )
         aCols[nCols][nPosClaEZ]  := CTJ->CTJ_CLVLDB
      Else   
         aCols[nCols][nPosClaEZ]  := CTJ->CTJ_CLVLCR
      Endif

      aCols[nCols][nPosValEZ]     := Round( nValor * (CTJ->CTJ_PERCEN / 100),2 )
      aCols[nCols][nPosPerEZ]     := Round( CTJ->CTJ_PERCEN,6 )
      aCols[nCols][nPosDesEZ]     := Posicione("CTT" , 1 , xFilial("CTT") +  aCols[nCols][nPosCusEZ] , "CTT_DESC01") 
      aCols[nCols][nUsadoII + 1 ] := .F.

   /*�����������������������������������������������������������������Ŀ
     �               Processa o Proximo Registro                       �
     �������������������������������������������������������������������*/
   
   EndIf
  
   DbSkip()
   Loop

Enddo

/*����������������������������������������������������������������������������Ŀ
  �         Chama a Funcao que Aglutina os Registros iguais do Acols           �
  ������������������������������������������������������������������������������*/

SomaAcols()

/*����������������������������������������������������������������������������Ŀ
  �         Chama a Funcao que Atualiza o Campo do Valor Distribuido           �
  ������������������������������������������������������������������������������*/

RecValSEZ()


Return .T.

/*
��������������������������������������������������������������������������������
��������������������������������������������������������������������������������
����������������������������������������������������������������������������ͻ��
���Programa  �   VldCodRat  � Autor � Cristiano Figueiroa� Data � 27/01/2006 ���
����������������������������������������������������������������������������͹��
���Descricao � Valida o Codigo do Rateio Informado                           ���
����������������������������������������������������������������������������͹��
���Uso       � Csu CardSystem                                                ���
����������������������������������������������������������������������������ͼ��
��������������������������������������������������������������������������������
��������������������������������������������������������������������������������
*/

Static Function VldCodRat( cCodRat )

/*����������������������������������������������������������������������������Ŀ
  �              Declara as Variaveis Locais Utilizadas na Rotina              �
  ������������������������������������������������������������������������������*/

Local lRet := .T.

/*����������������������������������������������������������������������������Ŀ
  �                    Abre a Tabela de Rateios Externos                       �
  ������������������������������������������������������������������������������*/

DbSelectArea("CTJ")
DbSetOrder(1)

/*����������������������������������������������������������������������������Ŀ
  �        Pesquisa o Codigo informado na Tabela de Rateios Externos           �
  ������������������������������������������������������������������������������*/

If !DbSeek( xFilial("CTJ") + cCodRat ) .And. !Empty(cCodRat)
   MsgInfo("O C�digo de Rateio Informado n�o existe !" , "Aten��o !")
   lRet := .F.
Else
   If !Empty( CTJ->CTJ_QTDTOTAL )
      nPercent := CTJ->CTJ_QTDTOTAL
   Endif   
Endif

/*����������������������������������������������������������������������������Ŀ
  �              Verifica se o Codigo do Rateio Esta Preenchido                �
  ������������������������������������������������������������������������������*/

If Empty(cCodRat)
   MsgInfo("O Codigo do Rateio dever� ser informado !!" , "Aten��o !")   
   lRet := .F.
Endif

Return lRet

/*
��������������������������������������������������������������������������������
��������������������������������������������������������������������������������
����������������������������������������������������������������������������ͻ��
���Programa  �   VldPerRat  � Autor � Cristiano Figueiroa� Data � 27/01/2006 ���
����������������������������������������������������������������������������͹��
���Descricao � Valida o Percentual Informado na Tela do Rateio               ���
����������������������������������������������������������������������������͹��
���Uso       � Csu CardSystem                                                ���
����������������������������������������������������������������������������ͼ��
��������������������������������������������������������������������������������
��������������������������������������������������������������������������������
*/

Static Function VldPerRat( cCodRat , nPerRat )

/*����������������������������������������������������������������������������Ŀ
  �              Declara as Variaveis Locais Utilizadas na Rotina              �
  ������������������������������������������������������������������������������*/

Local lRet := .T.

/*����������������������������������������������������������������������������Ŀ
  �                    Abre a Tabela de Rateios Externos                       �
  ������������������������������������������������������������������������������*/

If nPerRat <= 0
   MsgInfo("O Percentual de Rateio deve ser Maior que 0 e Menor que 100 !" , "Aten��o !")
   lRet := .F.
Endif   

/*����������������������������������������������������������������������������Ŀ
  �                    Abre a Tabela de Rateios Externos                       �
  ������������������������������������������������������������������������������*/

DbSelectArea("CTJ")
DbSetOrder(1)

/*����������������������������������������������������������������������������Ŀ
  �        Pesquisa o Codigo informado na Tabela de Rateios Externos           �
  ������������������������������������������������������������������������������*/

If !DbSeek( xFilial("CTJ") + cCodRat )
   MsgInfo("O C�digo de Rateio Informado n�o existe !" , "Aten��o !")
   lRet := .F.
Else

/*������������������������������������������������������������������������������������������Ŀ
  � Caso a quantidade total seja diferente de 0 pergunta se deseja efetuar a aplicacao de um �
  � percentual sobre o percentual j� configurado para o Rateio                               �
  ��������������������������������������������������������������������������������������������*/

/*   If CTJ->CTJ_QTDTOTAL <> 0 .And. nPerRat <> 100
      If !MsgYesNo("Confirma a Aplica��o de " + Alltrim(Str(nPerRat)) + "% sobre " + Alltrim(Str(CTJ->CTJ_QTDTOTAL)) + " %" ) 
         lRet := .F.
      Endif
   Endif*/

Endif

/*����������������������������������������������������������������������������Ŀ
  �              Verifica se o Codigo do Rateio Esta Preenchido                �
  ������������������������������������������������������������������������������*/

If Empty(cCodRat)
   MsgInfo("O Codigo do Rateio dever� ser informado !!" , "Aten��o !")   
   lRet := .F.
Endif

Return lRet

/*
��������������������������������������������������������������������������������
��������������������������������������������������������������������������������
����������������������������������������������������������������������������ͻ��
���Programa  �  SomaAcols   � Autor � Cristiano Figueiroa� Data � 27/01/2006 ���
����������������������������������������������������������������������������͹��
���Descricao � Aglutina as Colunas do Acols com o mesmo Codigo               ���
����������������������������������������������������������������������������͹��
���Uso       � Csu CardSystem                                                ���
����������������������������������������������������������������������������ͼ��
��������������������������������������������������������������������������������
��������������������������������������������������������������������������������
*/

Static Function SomaAcols()

/*����������������������������������������������������������������������������Ŀ
  �              Declara as Variaveis Locais Utilizadas na Rotina              �
  ������������������������������������������������������������������������������*/

Local aColsNew := {}
Local aNewProc := {}
Local nValCus  := 0
Local nPerCus  := 0
Local e        := 1

/*����������������������������������������������������������������������������Ŀ
  �              Declara as Variaveis Locais Utilizadas na Rotina              �
  ������������������������������������������������������������������������������*/

aCols := aSort(aCols,,,{|x,y| x[nPosCusEZ] + x[nPosIteEZ] + x[nPosClaEZ]  <   y[nPosCusEZ] + y[nPosIteEZ] + y[nPosClaEZ]  } )

/*����������������������������������������������������������������������������Ŀ
  �              Declara as Variaveis Locais Utilizadas na Rotina              �
  ������������������������������������������������������������������������������*/


For j := 1 to Len(aCols)

   nValCus := 0
   nPerCus := 0

   If !aCols[ j , Len(aHeader) + 1 ]
   
      For m := 1 to Len(aCols)
      
         If !aCols[ j , Len(aHeader) + 1 ] .And. aCols[ j , nPosCusEZ ] + aCols[ j , nPosIteEZ ] + aCols[ j , nPosClaEZ ]  ==  aCols[ m , nPosCusEZ ]  + aCols[ m , nPosIteEZ ] + aCols[ m , nPosClaEZ ] .And. !aCols[ m , Len(aHeader) + 1 ]
            nValCus += Round(aCols[ m , nPosValEZ ],2)
            nPerCus := Round(nValCus * 100 / nValRat,6)
         Endif

      Next m
   
  /*�����������������������������������������������������������������������������Ŀ
    �   Verifica se o Centro de Custo + Item + Classe ja foram Aglutinados. Caso  �
    �   ja tenham sido aglutinados nao adiciona no novo Acols                     �
    �������������������������������������������������������������������������������*/

      If Ascan ( aNewProc , aCols[ j , nPosCusEZ ] + aCols[ j , nPosIteEZ ] + aCols[ j , nPosClaEZ ] ) == 0
      
      /*If Ascan( AcolsNew , {|x| x[nPosCusEZ] == aCols[ j , nPosCusEZ ] }) == 0  .Or. ; 
         Ascan( AcolsNew , {|x| x[nPosClaEZ] == aCols[ j , nPosClaEZ ] }) == 0  .Or. ;       
         Ascan( AcolsNew , {|x| x[nPosIteEZ] == aCols[ j , nPosIteEZ ] }) == 0          
         
      /*�����������������������������������������������������������������������������Ŀ
        �   Adiciona um Array no aCols Contendo o Numero de Colunas Usadas na Rotina  �
        �������������������������������������������������������������������������������*/

         Aadd ( aColsNew , Array( nUsadoII + 1 ) )

      /*�����������������������������������������������������������������������������Ŀ
        �                 Atribui as Colunas os Valores Ja Existentes                 �
        �������������������������������������������������������������������������������*/

         aColsNew[e][nPosCusEZ    ] := aCols [ j , nPosCusEZ ]
         aColsNew[e][nPosPerEZ    ] := nPerCus
         aColsNew[e][nPosValEZ    ] := nValCus 
         aColsNew[e][nPosDesEZ    ] := aCols [ j , nPosDesEZ ]
         aColsNew[e][nPosIteEZ    ] := aCols [ j , nPosIteEZ ]
         aColsNew[e][nPosClaEZ    ] := aCols [ j , nPosClaEZ ]         
         aColsNew[e][nUsadoII + 1 ] := .F.
         
         e++
      
      /*�����������������������������������������������������������������������������Ŀ
        �       Adiciona no Array o Centro de Custo + Item + Classe ja processados    �
        �������������������������������������������������������������������������������*/

         Aadd ( aNewProc , aCols[ j , nPosCusEZ ] + aCols[ j , nPosIteEZ ] + aCols[ j , nPosClaEZ ] )
      
      Endif   
      
   Else

      DbSelectArea("CUS")

    /*����������������������������������������������������������������������������Ŀ
      �             Processa todos os Registros do Acols do Rateio                 �
      ������������������������������������������������������������������������������*/

      If DbSeek ( cNaturez + aCols[j][nPosCusEz] + aCols[j][nPosIteEz]  + aCols[j][nPosClaEz]  )
         Reclock("CUS" , .F.)
         CUS->FLAG  := aCols[j][nUsadoII + 1]
         MSUnLock()
      Endif   

   
   Endif

Next j

/*��������������������������������������������������������������Ŀ
  �    Atribui ao Acols o AcolsNew com as colunas aglutinadas    �
  ����������������������������������������������������������������*/

aCols := aColsNew

/*��������������������������������������������������������������Ŀ
  �    Caso o novo acols esteja vazio , adiciona nova linha      �
  ����������������������������������������������������������������*/

If Len(aCols) == 0
   AdicCols()
Endif


Return

/*
��������������������������������������������������������������������������������
��������������������������������������������������������������������������������
����������������������������������������������������������������������������ͻ��
���Programa  �  AdicCols    � Autor � Cristiano Figueiroa� Data � 30/01/2006 ���
����������������������������������������������������������������������������͹��
���Descricao � Adiciona linha em branco no Acols                             ���
����������������������������������������������������������������������������͹��
���Uso       � Csu CardSystem                                                ���
����������������������������������������������������������������������������ͼ��
��������������������������������������������������������������������������������
��������������������������������������������������������������������������������
*/

Static Function AdicCols

/*����������������������������������������������������������������������������Ŀ
  �              Declara as Variaveis Locais Utilizadas na Rotina              �
  ������������������������������������������������������������������������������*/

Local nNum 

/*����������������������������������������������������������������������������Ŀ
  �                     Adiciona Nova Linha no Acols                           �
  ������������������������������������������������������������������������������*/

Aadd( aCols , Array( nUsadoII + 1) )

/*����������������������������������������������������������������������������Ŀ
  �                     Adiciona Nova Linha no Acols                           �
  ������������������������������������������������������������������������������*/

For nNum := 1 to nUsadoII
   aCols[ Len( aCols ) , nNum        ] :=  CriaVar( aHeader [ nNum , 2 ] )
   aCols[ Len( aCols ) , nUsadoII + 1] := .F.
Next 

Return

/*
��������������������������������������������������������������������������������
��������������������������������������������������������������������������������
����������������������������������������������������������������������������ͻ��
���Programa  �  AjustaDif   � Autor � Cristiano Figueiroa� Data � 15/03/2006 ���
����������������������������������������������������������������������������͹��
���Descricao � Efetua um ajuste na ultima linha do Rateio caso haja          ���
���          � divergencia entr eo Valor a Ratear e Valor Rateado.           ���
���          � Vale apontar que tal rotina somente devera ser disparado      ���
���Descricao � quando o Percentual Rateado ja tiver atingido os 100 %        ���
����������������������������������������������������������������������������͹��
���Uso       � Csu CardSystem                                                ���
����������������������������������������������������������������������������ͼ��
��������������������������������������������������������������������������������
��������������������������������������������������������������������������������
*/

Static Function AjustaDif( _nValRat , _nValTotal )

/*����������������������������������������������������������������������������Ŀ
  �              Declara as Variaveis Locais Utilizadas na Rotina              �
  ������������������������������������������������������������������������������*/

Local q    
Local nNumColunas := Len( aCols )
Local lAjuste     := .F.
Local nValAjuste  := _nValRat - _nValTotal 

/*���������������������������������������������������������������������Ŀ
  � Inicia a Validacao da Linha Atual na Tela Rateio de Natureza        �
  �����������������������������������������������������������������������*/

For q := Len( aCols ) to 1 Step -1

/*���������������������������������������������������������������������Ŀ
  �       Executa o ajuste enquando o Flag estiver igual a Falso        �
  �����������������������������������������������������������������������*/

   If !lAjuste

   /*���������������������������������������������������������������������Ŀ
     �             Desconsidera os Itens do Acols Deletados                �
     �����������������������������������������������������������������������*/

      If ! aCols[ q , Len(aHeader) + 1 ]

      /*����������������������������������������������������������������������������������Ŀ
        �   Caso o Ajuste seja Negativo Verifica se Tenho Valor Disponivel para Subtrair   �
        ������������������������������������������������������������������������������������*/

         If nValAjuste < 0
 
            If aCols[q][nPosValEZ ] > nValAjuste * -1 
               aCols[q][nPosValEZ ] += nValAjuste
               lAjuste := .T.
            Endif   
         
         Else

      /*����������������������������������������������������������������������������������Ŀ
        �   Caso o Ajuste seja Positivo soma o Valor na Ultima Linha do Rateio             �
        ������������������������������������������������������������������������������������*/

            aCols[q][nPosValEZ ] += nValAjuste
            lAjuste := .T.         
         
         Endif   

		 aCols[q][nPosPerEZ ] := ( aCols[q][nPosValEZ ] / _nValTotal ) * 100
      Endif

   Endif   

Next q

Return

/*
��������������������������������������������������������������������������������
��������������������������������������������������������������������������������
����������������������������������������������������������������������������ͻ��
���Programa  �  VerCCBloq   � Autor � Cristiano Figueiroa� Data � 13/04/2006 ���
����������������������������������������������������������������������������͹��
���Descricao � Verifica se o Centro de Custo Utilizado esta ou nao Bloqueado ���
���          � para uso ou esta fora da Data de Vigencia                     ���
����������������������������������������������������������������������������͹��
���Uso       � Csu CardSystem                                                ���
����������������������������������������������������������������������������ͼ��
��������������������������������������������������������������������������������
��������������������������������������������������������������������������������
*/

User Function VerCCBloq( cCusto )

/*����������������������������������������������������������������������������Ŀ
  �              Declara as Variaveis Locais Utilizadas na Rotina              �
  ������������������������������������������������������������������������������*/

Local lRet      := .T.
Local aArea     := GetArea()
Local aAreaCTT  := CTT->( GetArea() )

/*����������������������������������������������������������������������������Ŀ
  �                 Abre o Cadastro de Centros de Custos                       �
  ������������������������������������������������������������������������������*/

DbSelectArea("CTT")
DbSetOrder(1)       // Filial + Centro de Custo

/*����������������������������������������������������������������������������Ŀ
  �                 Posiciona no Cadastro de Centros de Custos                 �
  ������������������������������������������������������������������������������*/

If DbSeek ( xFilial("CTT") + cCusto )

 /*�������������������������������������������������������������Ŀ
   �     Verifica se o Centro de Custo esta ou nao  Bloqueado    �
   ���������������������������������������������������������������*/

   If CTT->CTT_BLOQ == "1" 
      Aviso("Atencao" , "O Centro de Custo (" + AllTrim(cCusto) + ") nao pode ser utilizado por estar bloqueado !" , {"Ok"} , 1 , "Centro de Custo Invalido" )
      lRet := .F.
   Endif   

 /*����������������������������������������������������������������Ŀ
   �     Verifica a Data Inicial de Existencia do Centro de Custo   �
   ������������������������������������������������������������������*/

   If !Empty( CTT->CTT_DTEXIS )
      If dDatabase < CTT->CTT_DTEXIS
         Aviso("Atencao" , "O Centro de Custo (" + AllTrim(cCusto) + ") nao pode ser utilizado pois a Data Inicial de Existencia e " + DtoC(CTT->CTT_DTEXIS) + " !" , {"Ok"} , 1 , "Centro de Custo Invalido" )
         lRet := .F.
      Endif   
   Endif   

 /*����������������������������������������������������������������Ŀ
   �      Verifica a Data Final de Existencia do Centro de Custo    �
   ������������������������������������������������������������������*/

   If !Empty( CTT->CTT_DTEXSF )
      If dDatabase < CTT->CTT_DTEXSF
         Aviso("Atencao" , "O Centro de Custo (" + AllTrim(cCusto) + ") nao pode ser utilizado pois o mesmo expirou no dia " + DtoC(CTT->CTT_DTEXSF) + " !" , {"Ok"} , 1 , "Centro de Custo Invalido" )
         lRet := .F.
      Endif   
   Endif   

Endif

/*����������������������������������������������������������������������������Ŀ
  �                 Restaura as Areas utilizadas Anteriormente                 �
  ������������������������������������������������������������������������������*/

RestArea(aAreaCTT)
RestArea(aArea)

Return lRet
