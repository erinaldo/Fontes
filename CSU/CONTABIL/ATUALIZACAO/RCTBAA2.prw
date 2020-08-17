#INCLUDE "Protheus.ch"
#INCLUDE "TopConn.ch"       

#DEFINE c_BR Chr(13)+Chr(10)

/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �RCTBAA2   �Autor  �Vin�cius Greg�rio   � Data �  03/03/11   ���
�������������������������������������������������������������������������͹��
���Desc.     � C�pia m�ltipla de tabelas de rateio para uma �nica tabela  ���
���          �                                                            ���
�������������������������������������������������������������������������͹��
���Uso       � CSU                                                        ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/
User Function RCTBAA2()
//�����������������������Ŀ
//�Declara��o de vari�veis�
//�������������������������
Local aArea	:= GetArea()

Private aItens		:= {}

Private oOk	    	:= LoadBitmap( GetResources(), "BR_VERDE")
Private oNo	    	:= LoadBitmap( GetResources(), "BR_VERMELHO")

//�������������������������������������������������������������Ŀ
//�Garantir que a tabela destino esteja sem os itens preenchidos�
//���������������������������������������������������������������
If U_RCTB99Y()
	Aviso("Aviso","A tabela de destino j� tem itens preenchidos. Por favor, utilize uma tabela com o cadastro do cabe�alho somente.",{"OK"},,"Aten��o",,"NOCHECKED")			
	Return .F.
Endif         

//��������������������������������������������������������Ŀ
//�Chama a rotina que monta a tela de marca��o dos valores.�
//����������������������������������������������������������
MontaTela()

RestArea(aArea)
Return .T.


/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �MontaTela �Autor  �Vin�cius Greg�rio   � Data �  03/03/11   ���
�������������������������������������������������������������������������͹��
���Desc.     � Monta a tela para sele��o das tabelas de rateio que ser�o  ���
���          � importadas para a tabela principal                         ���
�������������������������������������������������������������������������͹��
���Uso       � CSU                                                        ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/
Static Function MontaTela()                     
//�����������������������Ŀ
//�Declara��o de vari�veis�
//�������������������������
//�����������������������������������������������������������������������������Ŀ
//� Declaracao de variaveis                									    �
//�������������������������������������������������������������������������������
Local aAreaZB7		:= ZB7->(GetArea())
Local nCpo,nCnt   
Local nLoop			:= 0
Local nOpcA 		:= 0
Local lSeek
Local aObjects  	:= {}
Local aSize     	:= MsAdvSize()
Local nI			:= 0

//Local bOk      		:= {|| If( Obrigatorio( oEncMain:aGets, oEncMain:aTela) .And. U_ZB8TudOk(), ( nOpcA := 1, oDlgMain:End() ), nOpcA := 0 ) }
Local bOk      		:= {|| IF(TudoOK(),(nOpca:=1,oDlgMain:End()),nOpcA:=0) }
Local bCancel  		:= {|| nOpcA := 0, oDlgMain:End() }
Local aAlias		:= {}

Private aHeader 	:= {}
Private aCols	 	:= {}
Private oDlgMain
Private oEncMain
Private oFolder
Private oGetD	
Private aCampos		:= {}
Private aVisual		:= {}
Private aGets		:= {}
Private aTela		:= {}
Private bCampo		:= { |nCPO| Field( nCPO ) }                             
Private aBotao		:= {}

//�����������������������������������������Ŀ
//�Vari�veis de posi��o de campos no aHeader�
//�������������������������������������������
Private nPMark		:= 0
Private nPCodRat	:= 0
Private nPDescri	:= 0
Private nPAnoMes	:= 0
Private nPRevisa	:= 0
Private nPAtivo		:= 0
Private nPCCTran	:= 0
Private nPItTran	:= 0
Private nPClTran	:= 0
Private nPProces	:= 0
Private nPPercent	:= 0
Private nPNomUser	:= 0
Private nPCompon	:= 0

//��������������������������������������������������Ŀ
//�Adicionar a funcionalidade de importa��o no aBotao�
//����������������������������������������������������
//AADD(aBotao, {"DBG06" 		, { || RCTB99I()}, "Importar cadastro", "Importar" }) 
//AADD(aBotao, {"PMSEXCEL" 	, { || RCTB99E()}, "Exportar cadastro", "Exportar" })
                                             
//�������������������������������������Ŀ
//�Montar os campos da ZB7 para a MsMGet�
//���������������������������������������
aAdd( aCampos, "ZB7_CODRAT" )
aAdd( aCampos, "ZB7_DESCRI" )
aAdd( aCampos, "ZB7_ANOMES" )
aAdd( aCampos, "ZB7_REVISA" )
aAdd( aCampos, "ZB7_ATIVO"  )
aAdd( aCampos, "ZB7_CCTRAN" )
aAdd( aCampos, "ZB7_ITTRAN" )
aAdd( aCampos, "ZB7_CLTRAN" )
aAdd( aCampos, "ZB7_PROCES" )
//���������������������������������Ŀ
//�VG - 2011.03.11                  �
//�Inclus�o do campo com o nome     �
//�do usu�rio que cadastrou a tabela�
//�de rateio.                       �
//�����������������������������������
aAdd( aCampos, "ZB7_USRNAM" )
//aAdd( aCampos, "ZB7_COMPON" )
aAdd( aCampos, "NOUSER" )

//������������������������������������������������������Ŀ
//�Define a area dos objetos                             �
//��������������������������������������������������������
aObjects := {}
AAdd( aObjects,{100,060, .t., .f. })
AAdd( aObjects,{100,100, .t., .t. })

aInfo := { aSize[ 1 ], aSize[ 2 ], aSize[ 3 ], aSize[ 4 ], 3, 3 }
aPosObj := MsObjSize( aInfo, aObjects )

RegToMemory("ZB7",.F.)

//������������������������������������������������������Ŀ
//�Corrigir a visualiza��o do m�s/ano no formato desejado�
//��������������������������������������������������������
M->ZB7_MESANO	:= Substr(M->ZB7_ANOMES,5,2)+Substr(M->ZB7_ANOMES,1,4) 

//������������������������������������Ŀ
//�VG - 2011.03.11                     �
//�Alterar o nome do usu�rio baseado no�
//�usu�rio que est� copiando a tabela. �
//��������������������������������������
M->ZB7_USRNAM	:= UsrRetName(__cUserId)

//���������������������������������������������������������������������������������Ŀ
//� Monta o aHeader 																�
//�����������������������������������������������������������������������������������   
aHeader := {}

Aadd(aHeader,{"OK",;
			"COR",;
			"@BMP",;
			1,;
            0,;
            .T.,;
            "",;
            "",;
            "",;
            "R",;
            "",;
            "",;
            .F.,;
            "V",;
          	"",;
           	"",;
           	"",;
           	""})      
           	
//�����������������������Ŀ
//�Coluna com o percentual�
//�������������������������
dbSelectArea("SX3")
SX3->( dbSetOrder(2) )//CAMPO
SX3->( dbSeek("ZB8_PERCEN") )
Aadd(aHeader,{	AllTrim(X3Titulo()),;
				SX3->X3_CAMPO,;
				SX3->X3_PICTURE,;
				SX3->X3_TAMANHO,;
				SX3->X3_DECIMAL,;
				SX3->X3_VALID,;
				SX3->X3_USADO,;
				SX3->X3_TIPO,;
				SX3->X3_F3,;
				SX3->X3_CONTEXT,;
				SX3->X3_CBOX,;
				SX3->X3_RELACAO,;
				SX3->X3_WHEN,;
				SX3->X3_VISUAL,;
				SX3->X3_VLDUSER,;
				SX3->X3_PICTVAR,;
				SX3->X3_OBRIGAT})

dbSelectArea("SX3")
SX3->( dbSetOrder(1) )
SX3->( dbSeek("ZB7") )
While SX3->( !Eof()) .And. SX3->X3_ARQUIVO $ "ZB7" 
	If X3USO(X3_USADO) .And. cNivel >= X3_NIVEL .and.;                          
		( !Alltrim(SX3->X3_CAMPO) $ "ZB7_FILIAL")
		Aadd(aHeader,{	AllTrim(X3Titulo()),;
						SX3->X3_CAMPO,;
						SX3->X3_PICTURE,;
						SX3->X3_TAMANHO,;
						SX3->X3_DECIMAL,;
						SX3->X3_VALID,;
						SX3->X3_USADO,;
						SX3->X3_TIPO,;
						SX3->X3_F3,;
						SX3->X3_CONTEXT,;
						SX3->X3_CBOX,;
						SX3->X3_RELACAO,;
						SX3->X3_WHEN,;
						SX3->X3_VISUAL,;
						SX3->X3_VLDUSER,;
						SX3->X3_PICTVAR,;
						SX3->X3_OBRIGAT})
	Endif
	SX3->(dbSkip())
EndDo

//����������������������������Ŀ
//�Guardar posi��es da GetDados�
//������������������������������
nPMark		:= aScan( aHeader, { |x| AllTrim(x[2]) == "COR" 		})
nPCodRat	:= aScan( aHeader, { |x| AllTrim(x[2]) == "ZB7_CODRAT"	})
nPDescri	:= aScan( aHeader, { |x| AllTrim(x[2]) == "ZB7_DESCRI"	})
nPAnoMes	:= aScan( aHeader, { |x| AllTrim(x[2]) == "ZB7_ANOMES"	})
nPRevisa	:= aScan( aHeader, { |x| AllTrim(x[2]) == "ZB7_REVISA"	})
nPAtivo		:= aScan( aHeader, { |x| AllTrim(x[2]) == "ZB7_ATIVO"	})
nPCCTran	:= aScan( aHeader, { |x| AllTrim(x[2]) == "ZB7_CCTRAN"	})
nPItTran	:= aScan( aHeader, { |x| AllTrim(x[2]) == "ZB7_ITTRAN"	})
nPClTran	:= aScan( aHeader, { |x| AllTrim(x[2]) == "ZB7_CLTRAN"	})
nPProces	:= aScan( aHeader, { |x| AllTrim(x[2]) == "ZB7_PROCES"	})
nPPercent	:= aScan( aHeader, { |x| AllTrim(x[2]) == "ZB8_PERCEN"	})
//������������������������������������������������������Ŀ
//�VG - 2011.03.11                                       �
//�Nome do usu�rio que cadastrou as tabelas selecionadas.�
//��������������������������������������������������������
nPNomUser	:= aScan( aHeader, { |x| AllTrim(x[2]) == "ZB7_USRNAM"	})
nPCompon	:= aScan( aHeader, { |x| AllTrim(x[2]) == "ZB7_COMPON"	})

aCols := MontaAcols()
                             
/*aAdd( aCampos, "ZB7_CODRAT" )
aAdd( aCampos, "ZB7_DESCRI" )
aAdd( aCampos, "ZB7_ANOMES" )
aAdd( aCampos, "ZB7_REVISA" )
aAdd( aCampos, "ZB7_ATIVO"  )
aAdd( aCampos, "ZB7_CCTRAN" )
aAdd( aCampos, "ZB7_ITTRAN" )
aAdd( aCampos, "ZB7_CLTRAN" )
aAdd( aCampos, "ZB7_PROCES" )*/

//�����������������������������������Ŀ
//�Cria a tela de digitacao do usuario�
//�������������������������������������
oDlgMain := MSDIALOG():New(aSize[7],00,aSize[6],aSize[5],cCadastro,,,,,,,,/*oMainWnd*/,.T.)

oEncMain := MSMGet():New("ZB7", ZB7->(RecNo()),2,,,,aCampos,{15,5,97,620},aCampos,1,,,,oDlgMain,,,,,,.T.,,,)
                                                        
//�����������������������������������������������������������������������������Ŀ
//� MsNewGetDados															    �
//�������������������������������������������������������������������������������                                          
oGetD := MsNewGetDados():New(100,5,280,620,0,,"TudOk()",,,,9999,,,,oDlgMain,aHeader,@aCols)
oGetD:oBrowse:blDblClick	:= {||GetPercentual()}

ACTIVATE MSDIALOG oDlgMain ON INIT EnchoiceBar(oDlgMain,bOk,bCancel,,aBotao)

If nOpcA == 1

	CalcPercent()
	Grava()
	
EndIf

Return

/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������Ŀ��
���Fun�ao    � MontaAcols �Autor�Vin�cius Greg�rio      � Data �22/12/2010���
�������������������������������������������������������������������������Ĵ��
���Descri�ao � Preenche o aCols a partir dos arquivos utilizados nas      ���
���          � amarracoes do cliente                                      ���
�������������������������������������������������������������������������Ĵ��
���Retorno	 � EXPA1 =	Copia do aCols									  ���
��������������������������������������������������������������������������ٱ�
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/
Static Function MontaAcols()
Local aRetorno	:= {}
Local nUsado   	:= Len(aHeader)
Local aArea    	:= ZB7->(GetArea())
Local nRecno	:= ZB7->(RecNo())
Local nLoop		:= 0
Local dtBase	:= dDataBase
Local dtBase2	:= dDataBase
DtBase:=MonthSub(dtbase,11)
DtBase:=AnoMes(dtbase)  
dtBase2:=AnoMes(dtbase2)  
dbSelectArea("ZB7")
dbSetOrder(1)
dbGoTop()                   
Do While !EOF()
	IF ZB7->ZB7_ANOMES>=DtBase .AND. ZB7->ZB7_ANOMES<=DtBase2
	//�������������������������������������������Ŀ
	//�Se tiver itens preenchidos, permite a c�pia�
	//���������������������������������������������
  		If U_RCTB99Y()                                                    
			aAdd(aRetorno,Array(nUsado+1))    
		
			For nLoop := 1 to Len(aHeader)            
				If Alltrim(aHeader[nLoop][2])=="COR"  
					aRetorno[Len(aRetorno)][nLoop]		:= oNo
				ElseIf Alltrim(aHeader[nLoop][2])=="ZB8_PERCEN"
					aRetorno[Len(aRetorno)][nLoop]		:= 0
				Else
					aRetorno[Len(aRetorno)][nLoop]		:= ZB7->&(Alltrim(aHeader[nLoop][2]))
				Endif
			Next nLoop		                             		
	
			aRetorno[Len(aRetorno)][nUsado+1]	:= .F.

		Endif	
		dbSelectArea("ZB7")
		dbSkip()
	ELSE
		dbSkip()
	endif
Enddo

//��������������������������������������Ŀ
//�Volta para a posi��o inicial na tabela�
//����������������������������������������
ZB7->(dbGoTo(nRecNo))

RestArea(aArea)
Return(aRetorno)

/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �TudoOK    �Autor  �Vin�cius Greg�rio   � Data �  03/03/11   ���
�������������������������������������������������������������������������͹��
���Desc.     �                                                            ���
���          �                                                            ���
�������������������������������������������������������������������������͹��
���Uso       � CSU                                                        ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/
Static Function TudoOK()
//�����������������������Ŀ
//�Declara��o de vari�veis�
//�������������������������
Local lRetorno	:= .T.
Local nLoop		:= 0
Local nSoma		:= 0

//�����������������������������������
//�Verifica se a soma � igual a 100%�
//�����������������������������������
aEval(oGetD:aCols,{|aItem| nSoma += aItem[nPPercent]})
If nSoma <> 100
	Aviso("Aviso",;
		"A soma do rateio � diferente de 100%. Por favor, verifique novamente os percentuais das tabelas de rateio selecionadas.",;
		{"OK"},,;
		"Aten��o",,;
		"NOCHECKED")				
	lRetorno	:= .F.
Endif

Return lRetorno

/*
��������������������������������������������������������������������������������
��������������������������������������������������������������������������������
����������������������������������������������������������������������������ͻ��
���Programa  �GetPercentual�Autor  �Vin�cius Greg�rio   � Data �  03/03/11   ���
����������������������������������������������������������������������������͹��
���Desc.     � Fun��o para pegar o percentual relativo aos itens da tabela   ���
���          �                                                               ���
����������������������������������������������������������������������������͹��
���Uso       � CSU                                                           ���
����������������������������������������������������������������������������ͼ��
��������������������������������������������������������������������������������
��������������������������������������������������������������������������������
*/
Static Function GetPercentual()
//�����������������������Ŀ
//�Declara��o de vari�veis�
//�������������������������
Local oDlg, oGroup, oBtnOK, oBtnCn, oGetPerc
Local oSayPerc
Local nGetPerc		:= If(oGetD:aCols[oGetD:nAt][nPPercent]==0,CriaVar("ZB8_PERCEN",.F.),oGetD:aCols[oGetD:nAt][nPPercent])  
Local cTitDialog	:= "Porcentagem para a tabela"
Local cTitGroup		:= ""    
Local nOpcA			:= 0   

//�������������������������������������������������Ŀ
//�Dialog principal. Na ativa��o ela � centralizada.�
//���������������������������������������������������
DEFINE MSDIALOG oDlg FROM 0,0 TO 100,250 PIXEL TITLE cTitDialog

oGroup:= TGroup():New(05,05,(oDlg:nClientHeight/3)-10,(oDlg:nClientWidth/2)-5,cTitGroup,oDlg,,,.T.)

oSayPerc	:= tSay():New(10,10,{||'Porcentagem:'},oDlg,,,,,,.T.,CLR_BLUE,CLR_WHITE,33,20)  
oGetPerc	:= TGet():New(10,52,{|u| if(PCount()>0,nGetPerc:=u,nGetPerc)}, oDlg,30,10,PesqPict("ZB8","ZB8_PERCEN"),{||nGetPerc >= 0 .and. nGetPerc <= 100},,,,,,.T.,,,,,,,,,,'nGetPerc')

//���������������������������������������������Ŀ
//�Bot�o para o controle de fechamento da janela�
//�����������������������������������������������
oBtnOK:=tButton():New((oDlg:nClientHeight/3.2),10,"OK",oDlg,{||nOpcA:=1,oDlg:End()},40,10,,,,.T.)
oBtnCN:=tButton():New((oDlg:nClientHeight/3.2),(oDlg:nClientWidth/3.2),"Cancelar",oDlg,{||oDlg:End()},40,10,,,,.T.)

ACTIVATE MSDIALOG oDlg CENTERED

//����������������������������������������������Ŀ
//�Processa a inclus�o do apontamento de produ��o�
//������������������������������������������������
If nOpcA==1
	If nGetPerc == 0
		oGetD:aCols[oGetD:nAt][nPPercent]  	:= nGetPerc
		oGetD:aCols[oGetD:nAt][nPMark]		:= oNo
	Else
		oGetD:aCols[oGetD:nAt][nPPercent]  	:= nGetPerc
		oGetD:aCols[oGetD:nAt][nPMark]		:= oOk
	Endif
	oGetD:Refresh()
Endif             

Return .T.


/*
�������������������������������������������������������������������������������
�������������������������������������������������������������������������������
���������������������������������������������������������������������������ͻ��
���Programa  �CalcPercent �Autor  �Vin�cius Greg�rio   � Data �  03/03/11   ���
���������������������������������������������������������������������������͹��
���Desc.     � Fun��o respons�vel por recalcular os percentuais dos itens   ���
���          �                                                              ���
���������������������������������������������������������������������������͹��
���Uso       � CSU                                                          ���
���������������������������������������������������������������������������ͼ��
�������������������������������������������������������������������������������
�������������������������������������������������������������������������������
*/
Static Function CalcPercent()
//�����������������������Ŀ
//�Declara��o de vari�veis�
//�������������������������
Local aArea    	:= ZB7->(GetArea())
Local nRecno	:= ZB7->(RecNo())
Local aCampos	:= {"ZB8_SEQUEN","ZB8_PERCEN","ZB8_CCDBTO","ZB8_ITDBTO","ZB8_CLVLDB"}
Local aTrab		:= {}
Local nLoop		:= 0
Local nLoop2	:= 0
Local nSequen	:= 0

aItens	:= {}

For nLoop:=1 to Len(oGetD:aCols)

	If oGetD:aCols[nLoop][nPMark]==oOk

		dbSelectArea("ZB8")
		dbSetOrder(1)//ZB8_FILIAL+ZB8_CODRAT+ZB8_ANOMES+ZB8_REVISA+ZB8_SEQUEN
		If dbSeek(xFilial("ZB8")+oGetD:aCols[nLoop][nPCodRat]+oGetD:aCols[nLoop][nPAnoMes]+oGetD:aCols[nLoop][nPRevisa],.F.)
			Do While !EOF() .and. ZB8->(ZB8_FILIAL+ZB8_CODRAT+ZB8_ANOMES+ZB8_REVISA)==xFilial("ZB8")+oGetD:aCols[nLoop][nPCodRat]+oGetD:aCols[nLoop][nPAnoMes]+oGetD:aCols[nLoop][nPRevisa]
				aAdd(aItens,Array(Len(aCampos)))
			
				//�����������������������������������������Ŀ
				//�Alimenta o array e recalcula o percentual�
				//�������������������������������������������
				For nLoop2 := 1 to Len(aCampos)
					If aCampos[nLoop2]=="ZB8_SEQUEN"
					    aItens[Len(aItens)][nLoop2]	:= STRZERO(nSequen+1,TAMSX3("ZB8_SEQUEN")[1])
				    	nSequen++
					ElseIf aCampos[nLoop2]=="ZB8_PERCEN"
						//Recalculo de percentual
						aItens[Len(aItens)][nLoop2]	:= (oGetD:aCols[nLoop][nPPercent]*ZB8->ZB8_PERCEN)/100				
					Else 
						aItens[Len(aItens)][nLoop2]	:= ZB8->&(aCampos[nLoop2])
					Endif							
				Next nLoop2
			
				ZB8->(dbSkip())
			EndDo
		Endif
		
	Endif
	
Next nLoop	

ZB7->(dbGoTo(nRecNo))
RestArea(aArea)
Return


/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �Grava     �Autor  �V. Greg�rio         � Data �  03/03/11   ���
�������������������������������������������������������������������������͹��
���Desc.     � Realiza a grava��o dos itens para a tabela de rateio       ���
���          � destino                                                    ���
�������������������������������������������������������������������������͹��
���Uso       � CSU                                                        ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/
Static Function Grava()
//�����������������������Ŀ
//�Declara��o de vari�veis�
//�������������������������
Local nLoop		:= 0       
Local nLoop2	:= 0
Local aCampos	:= {"ZB8_SEQUEN","ZB8_PERCEN","ZB8_CCDBTO","ZB8_ITDBTO","ZB8_CLVLDB"}

For nLoop:=1 to Len(aItens)

	dbSelectArea("ZB8")
	RecLock("ZB8",.T.)
    ZB8->ZB8_FILIAL	:= xFilial("ZB8")
    ZB8->ZB8_CODRAT	:= M->ZB7_CODRAT
    ZB8->ZB8_ANOMES	:= M->ZB7_ANOMES
    ZB8->ZB8_REVISA	:= M->ZB7_REVISA
    For nLoop2	:= 1 to Len(aItens[nLoop])
    	ZB8->&(aCampos[nLoop2])	:= aItens[nLoop][nLoop2]
	Next nLoop2
	MsUnlock()        
	
Next nLoop

//�����������������������������Ŀ
//�VG - 2011.06.09              �
//�Grava o flag ZB7_COMPON em   �
//�todas as tabelas que fizeram �
//�parte da tabela principal.   �
//�������������������������������
For nLoop	:= 1 to Len(oGetD:aCols)
	If oGetD:aCols[nLoop][nPMark]==oOk
		dbSelectArea("ZB7")
		dbSetOrder(1)//ZB7_FILIAL+ZB7_CODRAT+ZB7_ANOMES+ZB7_REVISA+ZB7_ATIVO		
		If dbSeek(xFilial("ZB7")+oGetD:aCols[nLoop][nPCodRat]+oGetD:aCols[nLoop][nPAnoMes]+oGetD:aCols[nLoop][nPRevisa]+oGetD:aCols[nLoop][nPAtivo],.F.)
			Reclock("ZB7",.F.)
			ZB7->ZB7_COMPON	:= '1'
			MsUnlock()
		Endif
	Endif
Next nLoop

Return .T.