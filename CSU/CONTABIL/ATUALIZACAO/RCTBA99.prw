#INCLUDE "Protheus.ch"
#INCLUDE "TopConn.ch"       

#DEFINE STR001 "Selecione o diretorio de grava��o do arquivo de rateio."
#DEFINE GD_INSERT	1
#DEFINE GD_DELETE	4	
#DEFINE GD_UPDATE	2
#DEFINE c_BR Chr(13)+Chr(10)

/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �RCTBA99   �Autor  �Vin�cius Greg�rio   � Data �  22/12/10   ���
�������������������������������������������������������������������������͹��
���Desc.     � Cadastro de Regras de Rateio - Modelo 3                    ���
���          �                                                            ���
�������������������������������������������������������������������������͹��
���Uso       � CSU                                                        ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/
User Function RCTBA99()
//�����������������������Ŀ
//�Declara��o de vari�veis�
//�������������������������
Local cAliaZB7		:= GetNextAlias() 
Local cUsrLog		:= __cUserID 
Local cCodRat		:= ""
Local cCodIN		:= "" 
Local cUserfull		:= ALLTRIM(SuperGetMV("MV_XUSRRAT",,""))

//��������������������������������������Ŀ
//�VG - 2011.02.17 - Inclus�o de legenda.�
//����������������������������������������
Local aCores    := {	{'ZB7_COMPON=="1"'						,'BR_AMARELO'	},;
						{'ZB7_PROCESS=="S"'						,'BR_VERMELHO'	},;	// Tabela j� processada
					 	{'ZB7_PROCESS=="N" .and. !U_RCTB99Y()'	,'BR_VERDE'		},;	// Tabela nunca processada e com os itens n�o preenchidos
					 	{'ZB7_PROCESS=="N" .and. U_RCTB99Y()'	,'BR_AZUL'		}}	// Tabela nunca processada e com os itens preenchidos

//���������������Ŀ
//�VG - 2011.08.03�
//�����������������
Local cPerg			:= "CTBA99"
Local aRegs			:= {}

Private cAnoMesD	:= ""
Private cAnoMesA	:= ""					 	
					 	
//���������������������������������������Ŀ
//�VG - 2011.03.25                        �
//�Altera��o para exibir os registro rec�m�
//�gravados.                              �
//�����������������������������������������
Private lDefTop		:= .F.
Private cAlias 		:= "ZB7"					 	

Private cFilterZB7	:= ""
Private cCadastro 	:= "Cadastro de Tabelas de Rateio"
Private aRotina 	:= MenuDef()
Private aIndexZB7	:= {}
Private bFiltraBrw	:= {|| FilBrowse(cAlias,@aIndexZB7,@cFilterZB7,.T.) }

//���������������������������������������Ŀ
//�Pergunte no in�cio da rotina.          �
//�Necess�rio para filtrar a quantidade de�
//�tabelas de rateio que far�o parte do   �
//�filtro de usu�rio.                     �
//�����������������������������������������
aAdd(aRegs,{cPerg,"01","Compet�ncia De"			,"","","mv_ch1","D",08,0,0,"G",""			,"MV_PAR01","","","","", "","","","","","","","","","","","","","","","","","","","","","","","","" })
aAdd(aRegs,{cPerg,"02","Compet�ncia At�"		,"","","mv_ch2","D",08,0,0,"G",""			,"MV_PAR02","","","","", "","","","","","","","","","","","","","","","","","","","","","","","","" })
aAdd(aRegs,{cPerg,"03","Tabela Rateio De"		,"","","mv_ch3","C",06,0,0,"G",""			,"MV_PAR03","","","","", "","","","","","","","","","","","","","","","","","","","","ZB7COD","","","","" })
aAdd(aRegs,{cPerg,"04","Tabela Rateio At�"		,"","","mv_ch4","C",06,0,0,"G",""			,"MV_PAR04","","","","", "","","","","","","","","","","","","","","","","","","","","ZB7COD","","","","" })

CriaSx1(aRegs)     
If !Pergunte(cPerg,.T.) 
	Return .F.
Endif

cAnoMesD	:= SubStr(DTOS(MV_PAR01),1,6)
cAnoMesA	:= SubStr(DTOS(MV_PAR02),1,6)

//If cUserfull != cUsrLog
//���������������������������������������������Ŀ
//�Permite mais de um administrador para a tela.�
//�����������������������������������������������
If !(cUsrLog$Alltrim(cUserfull))

   	BeginSql Alias cAliaZB7 
		Select ZB6_CODRAT,ZB7_ANOMES from %table:ZB6% ZB6 (NOLOCK), %table:ZB7% ZB7 (NOLOCK)
		WHERE ZB6_FILIAL = %xFilial:ZB6% AND ZB6_USUARI = %exp:cUsrLog% AND ZB6.%NotDel%
		AND ZB6_CODRAT = ZB7_CODRAT AND ZB6_CODRAT BETWEEN %exp:MV_PAR03% AND %exp:MV_PAR04% 
		AND ZB7_ANOMES BETWEEN %exp:cAnoMesD% AND %exp:cAnoMesA% AND ZB7.%NotDel%  
		                                                                                
	  /*	cQuery:=" SELECT DISTINCT ZB6_CODRAT,ZB7_ANOMES FROM ZB7050,ZB6050 "
	  	cQuery+=" WHERE ZB6_CODRAT = ZB7_CODRAT "
	 	cQuery+=" AND ZB6_USUARI='"+cUsrLog+"' "
	 	cQuery+=" AND ZB6_CODRAT BETWEEN '"+MV_PAR03+"' AND '"+MV_PAR04+"' "
  	    cQuery+=" AND ZB7_ANOMES BETWEEN '"+cAnoMesD+"' AND '"+cAnoMesA+"' "       */
  	    
  	  //  dbUseArea( .T., 'TOPCONN', TcGenQry(,,cQuery), cAliaZB7, .T., .F. ) 	
  	EndSQL	
	    
	(cAliaZB7)->(DbGoTop())
 	While !(cAliaZB7)->(EOF())
    	cCodRat += ALLTRIM((cAliaZB7)->ZB6_CODRAT)
		(cAliaZB7)->(DbSkip())
		If !(cAliaZB7)->(EOF())         
			cCodRat += ";"
		Endif	
	EndDo

	//������������������������Ŀ
	//�VG - 2011.03.25         �
	//�Fecha a �rea de trabalho�
	//��������������������������
	(cAliaZB7)->(dbCloseArea())                                                      	
	
	cCodIN := FormatIn(ALLTRIM(cCodRat), ";")	
	
	#IFDEF TOP
		lDefTop := !(TcSrvType() == "AS/400" .Or. TcSrvType() == "iSeries")
	#ENDIF
	
	lDefTop	:= .F.//VG - 2011.03.25 - Corre��o para exibir os registros rec�m gravados para o usu�rio.
  //	 cAno:="'"+cAnoMesD+"','"+cAnoMesA+"'"
	chkFile(cAlias) 
	If !lDefTop
		//Executa filtro automaticamente
		cFilterZB7	:= "ZB7_CODRAT $'"+STRTRAN(STRTRAN(STRTRAN(cCodIN,")",""),"(",""),"'","")+"'"
	  //	cFilterZB7	+= " .AND. ZB7_ANOMES $'"+STRTRAN(STRTRAN(STRTRAN(cAno,")",""),"(",""),"'","")+"'"
		If Len(cFilterZB7) > 1950//2000
			Aviso("Aviso","O filtro gerado � muito abrangente e os resultados n�o podem ser exibidos. Por favor, revise os par�metros de exibi��o.",{"OK"},,"Aten��o",,"BMPPERG")								
			Return .F.
		Endif
		
		DbSelectArea(cAlias)
		dbSetOrder(1)
		Eval(bFiltraBrw)
	Else
		DbSelectArea(cAlias)
		dbSetOrder(1)
		cFilterZB7	:= "ZB7_CODRAT IN"+cCodIN
	EndIf	

ElseIf (cUsrLog $Alltrim(cUserfull))
	cFilterZB7	:= "ZB7_CODRAT <> ' '" 
	Eval(bFiltraBrw)
	DbSelectArea(cAlias)
	dbSetOrder(1) 
Else                       
	DbSelectArea(cAlias)
	dbSetOrder(1) 	
Endif

//mBrowse( 6,1,22,75,cAlias,,,,,,,,,,,,,/*,Iif(lDefTop,cFilterZB7,Nil)*/)                      
mBrowse( 6,1,22,75,cAlias,,,,,,aCores,,,,,,,,Iif(lDefTop,cFilterZB7,Nil))

//Elimina arquivo temporario criado pelo filtro automatico acima
If !lDefTop
	EndFilBrw(cAlias,aIndexZB7)
Endif  

dbSelectArea(cAlias)
dbSetOrder(1)

Return

/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �RCTB99A   �Autor  �Vin�cius Greg�rio   � Data �  22/12/10   ���
�������������������������������������������������������������������������͹��
���Desc.     � Rotina para a manuten��o das regras de rateio              ���
���          �                                                            ���
�������������������������������������������������������������������������͹��
���Uso       � CSU                                                        ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/
User Function RCTB99A(cAlias,nRecn,nOpcx)
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
Local nStyle 		:= IIF(nOpcX == 2 .Or. nOpcX == 5,0,GD_INSERT+GD_UPDATE+GD_DELETE)

//����������������������������Ŀ
//�VG - 2011.03.22             �
//�Grupo para as informa��es de�
//�rodap�.                     �
//������������������������������
Local oGrpRod		:= Nil
Local oSayTot		:= Nil
Local oSayRest		:= Nil

Local bOk      		:= {|| If( Obrigatorio( oEncMain:aGets, oEncMain:aTela) .And. U_ZB8TudOk(), ( nOpcA := 1, oDlgMain:End() ), nOpcA := 0 ) }
Local bCancel  		:= {|| nOpcA := 0, oDlgMain:End() }
Local aAlias		:= {}

Local cUltRev		:= ""

Private aHeaderZB8 	:= {}
Private aColsZB8 	:= {}
Private oDlgMain
Private oEncMain
Private oFolder
Private oGetZB8	                

//����������������������������Ŀ
//�VG - 2011.03.22             �
//�Vari�vel para as informa��es�
//�de rodap�.                  �
//������������������������������
Private nTotPerc	:= 0       
Private oGetValTot	:= Nil

Private nRestPerc	:= 0
Private oGetValRest	:= Nil

Private aCampos		:= {}
Private aVisual		:= {}
Private aGets		:= {}
Private aTela		:= {}
Private bCampo		:= { |nCPO| Field( nCPO ) }                             
Private aBotao		:= {}
Private nOpc		:= nOpcx  

//����������������������������������������Ŀ
//�VG - 2011.03.22                         �
//�Defini��o da fonte para os totalizadores�
//������������������������������������������
Define Font oBoldIV  Name  "Arial"  Size 07 , -13 BOLD    

//����������������������������������������������Ŀ
//�VG - 2011.01.06                               �
//�Verifica se c�digo de rateio n�o foi utilizado�
//�anteriormente para permitir ou n�o a dele��o. �
//������������������������������������������������
If nOpcX == 5
	If !VerifDel(ZB7->ZB7_CODRAT)// .and. ZB7->ZB7_PROCES == 'S'//VG - 2011.06.09 - trecho de c�digo removido para impedir que os usu�rios
		//excluam tabelas j� utilizadas em notas fiscais - solicita��o feita pelo usu�rio Mafaldo.
		Aviso("Aviso","O c�digo de rateio j� foi utilizado anteriormente e portanto n�o pode ser removido.",{"OK"},,"Aten��o",,"BMPPERG")			
		Return .F.  
	Endif
Endif

//��������������������������������������������������Ŀ
//�Adicionar a funcionalidade de importa��o no aBotao�
//����������������������������������������������������
AADD(aBotao, {"DBG06" 		, { || RCTB99I()}, "Importar cadastro", "Importar" }) 
AADD(aBotao, {"PMSEXCEL" 	, { || RCTB99E()}, "Exportar cadastro", "Exportar" })
AADD(aBotao, {"EXCLUIR"		, { || RCTB99K()}, "Excluir Todos", "Exc. Todos" })
                                             
//�������������������������������������Ŀ
//�Montar os campos da ZB7 para a MsMGet�
//���������������������������������������
aAdd( aCampos, "ZB7_CODRAT" )
aAdd( aCampos, "ZB7_DESCRI" )
//aAdd( aCampos, "ZB7_ANOMES" )//VG - 2011.01.17 - Altera��o para visualizar M�s/Ano
aAdd( aCampos, "ZB7_MESANO" )
aAdd( aCampos, "ZB7_REVISA" )
aAdd( aCampos, "ZB7_ATIVO" )
aAdd( aCampos, "ZB7_CCTRAN" )
//����������������������������������������������Ŀ
//�VG - 2011.02.21 - Altera��o para recolocar as �
//�entidades cont�beis de Unidade de Neg�cio     �
//�e Opera��o.                                   �
//������������������������������������������������
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
aAdd( aCampos, "ZB7_USRFNA" )//VG - 2011.03.22
aAdd( aCampos, "NOUSER" )

//������������������������������������������������������Ŀ
//�Define a area dos objetos                             �
//��������������������������������������������������������
aObjects := {}
AAdd( aObjects,{100,060, .t., .f. })
AAdd( aObjects,{100,100, .t., .t. })

aInfo := { aSize[ 1 ], aSize[ 2 ], aSize[ 3 ], aSize[ 4 ], 3, 3 }
aPosObj := MsObjSize( aInfo, aObjects )

RegToMemory("ZB7",nOpcx == 3)

//�����������������Ŀ
//�Carrega o ano/m�s�
//�������������������
If nOpcX <> 3
	M->ZB7_MESANO	:= Substr(M->ZB7_ANOMES,5,2)+Substr(M->ZB7_ANOMES,1,4)
Endif

//���������������������������������������������������������������������������������Ŀ
//� Monta o aCampos 																�
//�����������������������������������������������������������������������������������   
dbSelectArea("SX3")
SX3->( dbSetOrder(1) )
SX3->( dbSeek("ZB8") )
aHeaderZB8 := {}
While SX3->( !Eof()) .And. SX3->X3_ARQUIVO $ "ZB8" 
	If X3USO(X3_USADO) .And. cNivel >= X3_NIVEL .and.;                          
		( !Alltrim(SX3->X3_CAMPO) $ "ZB8_FILIAL/ZB8_CODRAT/ZB8_ANOMES/ZB8_REVISA/ZB8_CDEBIT")//VG - 2011.01.17 - remover a conta de d�bito
//		( !Alltrim(SX3->X3_CAMPO) $ "ZB8_FILIAL/ZB8_CODRAT/ZB8_ANOMES/ZB8_REVISA")
		Aadd(aHeaderZB8,{	AllTrim(X3Titulo()),;
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

MontaAcols(aHeaderZB8,"ZB8",1,"ZB7",M->ZB7_CODRAT+M->ZB7_ANOMES+M->ZB7_REVISA,"ZB8_CODRAT+ZB8_ANOMES+ZB8_REVISA",aColsZB8,nOpcX) 

aSort(aColsZB8,,,{|x,y| val(x[1]) < val(y[1])})

//����������������������������������������������Ŀ
//�Verifica se a �ltima revis�o j� foi processada�
//������������������������������������������������
If nOpcX == 4            

	cUltRev	:= U_RZB7ULTR(M->ZB7_CODRAT,M->ZB7_ANOMES,.F.)  

	dbSelectArea("ZB7")
	dbSetOrder(1)
	If dbSeek(xFilial("ZB7")+M->ZB7_CODRAT+M->ZB7_ANOMES+cUltRev,.F.)
	
		If ZB7->ZB7_PROCESS == 'S'
					
			Aviso("Aviso","Ser� gerada uma nova revis�o para a tabela de rateio. Por favor, comunique o administrador das tabelas para ativa-la.",{"OK"},,"Aten��o",,"BMPPERG")			
		
			M->ZB7_REVISA	:= SOMA1(cUltRev)		
			//�������������������������������������������������Ŀ
			//�VG - 2011.03.18                                  �
			//�Altera��o para gravar como inativa a nova revis�o�
			//���������������������������������������������������
			M->ZB7_ATIVO	:= 'I'
			M->ZB7_PROCESS	:= 'N'

		ElseIf ZB7->ZB7_PROCESS <> 'S' .and. ZB7->ZB7_REVISA <> Replicate('0', TAMSX3("ZB7_REVISA")[1] )//VG - 2011.04.29 Se n�o tiver sido processada e se n�o for a primeira vers�o da tabela
		
			Aviso("Aviso","Existe uma revis�o gerada para essa tabela de rateio no per�odo que ainda n�o foi processada. Por favor, entre em contato com o administrador das tabelas para maiores informa��es.",{"OK"},,"Aten��o",,"BMPPERG")
			Return .F.
					
		Endif	
	Endif

Endif

//�����������������������������������Ŀ
//�Cria a tela de digitacao do usuario�
//�������������������������������������
oDlgMain := MSDIALOG():New(aSize[7],00,aSize[6],aSize[5],cCadastro,,,,,,,,/*oMainWnd*/,.T.)

//oEncMain := MSMGet():New("ZB7", ZB7->(RecNo()),/*If(nOpcx==4,2,nOpcx)*/nOpcX,,,,aCampos,{15,5,97,620},If(nOpcX==4,{"ZB7_ATIVO"/*,"ZB7_CCTRAN"*/,"NOUSER"},aCampos),1,,,,oDlgMain,,,,,,.T.,,,)
//oEncMain := MSMGet():New("ZB7", ZB7->(RecNo()),/*If(nOpcx==4,2,nOpcx)*/nOpcX,,,,aCampos,{15,5,97,620},If(nOpcX==4,{"ZB7_ATIVO"/*,"ZB7_CCTRAN"*/,"NOUSER"},aCampos),1,,,,oDlgMain,,,,,,.T.,,,)    
//�������������������������������������������������������Ŀ
//�VG - 2011.03.18 - Altera��o para que novas revis�es    �
//�sejam geradas como inativas. Para torn�-las ativas, �  �
//�necess�rio que o usu�rio administrador utilize a rotina�
//�de habilita��o de revis�o.                             �
//���������������������������������������������������������
oEncMain := MSMGet():New("ZB7", ZB7->(RecNo()),/*If(nOpcx==4,2,nOpcx)*/nOpcX,,,,aCampos,{15,5,97,620},If(nOpcX==4,If(M->ZB7_REVISA <> "000",{"NOUSER"},{"ZB7_ATIVO"/*,"ZB7_CCTRAN"*/,"NOUSER"}),aCampos),1,,,,oDlgMain,,,,,,.T.,,,)

//�������������������������Ŀ
//�VG - 2011.03.22          �
//�Inclus�o de rodap� com o �
//�percentual j� rateado.   �                                                                            
//���������������������������   
oGrpRod		:= TGroup():New(253,05,270,620,"",oDlgMain,,,.T.)
oSayTot		:= TSay():New(258,370,{||'Perc. Distribu�do:'},oDlgMain,,oBoldIV,,,,.T.,CLR_BLUE,CLR_WHITE,60,20)  
oGetValTot	:= TGet():New(255,433,{|u| if(PCount()>0,nTotPerc:=u,nTotPerc)}, oDlgMain,55,10,PesqPict("ZB8","ZB8_PERCEN"),/*valid*/,,,oBoldIV,,,.T.,,,{||.F.},,,,,,,'nTotPerc')

oSayRest	:= TSay():New(258,520,{||'Falta %:'},oDlgMain,,,,,,.T.,CLR_RED,CLR_WHITE,30,20)  
oGetValRest	:= TGet():New(255,553,{|u| if(PCount()>0,nRestPerc:=u,nRestPerc)}, oDlgMain,55,10,PesqPict("ZB8","ZB8_PERCEN"),/*valid*/,,,,,,.T.,,,{||.F.},,,,,,,'nRestPerc')
                                                        
//�����������������������������������������������������������������������������Ŀ
//� MsNewGetDados															    �
//�������������������������������������������������������������������������������                                          
oGetZB8 := MsNewGetDados():New(100,05,250,620,nStyle,"U_ZB8LinOk()","U_ZB8TudOk()","+ZB8_SEQUEN",,,9999,,,,oDlgMain,aHeaderZB8,@aColsZB8)
//�������������������������������Ŀ
//�VG - 2011.03.22                �
//�OnChange da GetDados atualiza o�
//�percentual j� rateado.         �
//���������������������������������
oGetZB8:bChange	:= {||RCTB99Z()}

ACTIVATE MSDIALOG oDlgMain ON INIT EnchoiceBar(oDlgMain,bOk,bCancel,,aBotao)

If nOpcA == 1 .And. ( nOpcx == 5 .or. nOpcx == 4 .or. nOpcx == 3 )

	Begin Transaction       
	
		If nOpcX == 5 .or. nOpcX == 4

			If nOpcX == 5      
			
				dbSelectArea("ZB7")
				ZB7->( dbSetOrder(1) )//ZB7_FILIAL+ZB7_CODRAT+ZB7_ANOMES+ZB7_REVISA+ZB7_ATIVO
				If dbSeek(xFilial("ZB7")+M->ZB7_CODRAT+M->ZB7_ANOMES+M->ZB7_REVISA+M->ZB7_ATIVO,.F.)
					RecLock("ZB7",.F.)
					ZB7->( dbDelete() )
					MsUnLock()
//					FKCOMMIT()
				Endif
				
				//�����������������������������������Ŀ
				//�VG - 2011.06.06                    �
				//�Altera��o que verifica se existem  �
				//�registros da tabela de rateio para �
				//�outras compet�ncias. Caso n�o      �
				//�exista, remove todas as permiss�es �
				//�ligadas � tabela.                  �
				//�������������������������������������
				dbSelectArea("ZB7")
				ZB7->( dbSetOrder(1) )//ZB7_FILIAL+ZB7_CODRAT+ZB7_ANOMES+ZB7_REVISA+ZB7_ATIVO
				If !dbSeek(xFilial("ZB7")+M->ZB7_CODRAT,.F.)
					dbSelectArea("ZBA")
					dbSetOrder(1)//ZBA_FILIAL+ZBA_CODRAT+ZBA_USUARI
					If dbSeek(xFilial("ZBA")+M->ZB7_CODRAT,.F.)
						Do While !EOF() .and. xFilial("ZBA")+M->ZB7_CODRAT==ZBA->(ZBA_FILIAL+ZBA_CODRAT)
							RecLock("ZBA",.F.)
								ZBA->(dbDelete())							
							MsUnlock()							
							dbSelectArea("ZBA")
							ZBA->(dbSkip())						
						EndDo
					Endif					
				Endif				
				
			Endif    
			
			dbSelectArea("ZB8")
			ZB8->( dbSetOrder(1) )//ZB8_FILIAL+ZB8_CODRAT+ZB8_ANOMES+ZB8_REVISA+ZB8_SEQUEN
			If dbSeek(xFilial("ZB8")+M->ZB7_CODRAT+M->ZB7_ANOMES+M->ZB7_REVISA,.F.)    
				Do While !EOF() .and. xFilial("ZB8")==ZB8->ZB8_FILIAL .and. M->ZB7_CODRAT==ZB8->ZB8_CODRAT ;
					.and. M->ZB7_ANOMES==ZB8->ZB8_ANOMES .and. M->ZB7_REVISA==ZB8->ZB8_REVISA
					
					RecLock("ZB8",.F.)
					ZB8->( dbDelete() )
					MsUnlock()
					 
					dbSelectArea("ZB8")
					dbSkip()
				EndDo			
			Endif			
		
		Endif
		
		If nOpcX == 3 .or. nOpcX ==4
		
			dbSelectArea("ZB7")  
			
			If M->ZB7_REVISA <> ZB7->ZB7_REVISA	
				RecLock("ZB7",.T.)
			Else
				RecLock("ZB7",nOpcX==3)
			Endif
			
			ZB7->ZB7_FILIAL := 	xFilial("ZB7")				
			ZB7->ZB7_CODRAT	:= 	M->ZB7_CODRAT
			ZB7->ZB7_DESCRI	:=	M->ZB7_DESCRI
//			ZB7->ZB7_ANOMES	:=	M->ZB7_ANOMES
			ZB7->ZB7_ANOMES	:=	U_RZB7AnoMes(M->ZB7_MESANO)
			ZB7->ZB7_REVISA	:=	M->ZB7_REVISA
			ZB7->ZB7_ATIVO	:=	M->ZB7_ATIVO
			ZB7->ZB7_CCTRAN	:= 	M->ZB7_CCTRAN
			//VG - 2011.02.21
			ZB7->ZB7_ITTRAN	:= 	M->ZB7_ITTRAN
			ZB7->ZB7_CLTRAN	:= 	M->ZB7_CLTRAN			
			ZB7->ZB7_PROCES	:= 	M->ZB7_PROCES
			//���������������������������������Ŀ
			//�VG - 2011.03.11                  �
			//�Inclus�o do campo com o nome     �
			//�do usu�rio que cadastrou a tabela�
			//�de rateio.                       �
			//�����������������������������������
			ZB7->ZB7_USRNAM	:= M->ZB7_USRNAM  
			//���������������������������������������Ŀ
			//�VG - 2011.06.09                        �
			//�Grava��o da data de inclus�o da tabela.�
			//�����������������������������������������
			If nOpcX	== 3
				ZB7->ZB7_DTDIGI	:= dDataBase
			Endif			
			ZB7->ZB7_USRFNA	:= M->ZB7_USRFNA//VG - 2011.03.22
			
			MsUnlock()			
		
			//�������������������������������������������������������������Ŀ
			//�Gravar os itens da getDados somente se eles forem informados.�
			//���������������������������������������������������������������
			If !Empty(Alltrim(oGetZB8:aCols[1,BuscaHeader(oGetZB8:aHeader,"ZB8_CCDBTO")]+;
				oGetZB8:aCols[1,BuscaHeader(oGetZB8:aHeader,"ZB8_ITDBTO")]+;
				oGetZB8:aCols[1,BuscaHeader(oGetZB8:aHeader,"ZB8_CLVLDB")]))

				For nLoop	:= 1 to Len(oGetZB8:aCols)
				
					If oGetZB8:aCols[nLoop,Len(oGetZB8:aHeader)+1]
						Loop
					Endif

					dbSelectArea("ZB8")
					RecLock("ZB8",.T.)
					ZB8->ZB8_FILIAL 	:= 	xFilial("ZB8")				
					ZB8->ZB8_CODRAT		:= 	M->ZB7_CODRAT
//					ZB8->ZB8_ANOMES		:=	M->ZB7_ANOMES
					ZB8->ZB8_ANOMES		:=	U_RZB7AnoMes(M->ZB7_MESANO)
					ZB8->ZB8_REVISA		:=	M->ZB7_REVISA
					ZB8->ZB8_SEQUEN    	:=	oGetZB8:aCols[nLoop,BuscaHeader(oGetZB8:aHeader,"ZB8_SEQUEN")]
					ZB8->ZB8_PERCEN    	:=	oGetZB8:aCols[nLoop,BuscaHeader(oGetZB8:aHeader,"ZB8_PERCEN")]
					ZB8->ZB8_CCDBTO    	:=	oGetZB8:aCols[nLoop,BuscaHeader(oGetZB8:aHeader,"ZB8_CCDBTO")]				
					ZB8->ZB8_ITDBTO    	:=	oGetZB8:aCols[nLoop,BuscaHeader(oGetZB8:aHeader,"ZB8_ITDBTO")]
					ZB8->ZB8_CLVLDB    	:=	oGetZB8:aCols[nLoop,BuscaHeader(oGetZB8:aHeader,"ZB8_CLVLDB")]
					MsUnlock()										
			
				Next nLoop
			Endif
		
			If nOpcX==3
				
				//�����������������������������������������Ŀ
				//�VG - 2011.01.06                          �
				//�Em caso de inclus�o, insere uma permiss�o�
				//�de manuten��o na tabela de rateio para o �
				//�usu�rio que a cadastrou.                 �
				//�������������������������������������������			
				dbSelectArea("ZB6")
				RecLock(Alias(),.T.)
				
				ZB6->ZB6_FILIAL	:= xFilial("ZB6")
				ZB6->ZB6_CODRAT	:= M->ZB7_CODRAT
				ZB6->ZB6_USUARI	:= __cUserId
				
				ZB6->(MsUnlock())				

				//����������������������������������Ŀ
				//�VG - 2011.01.14                   �
				//�Insere uma permiss�o de utiliza��o�
				//�da tabela para o usu�rio que a    �
				//�cadastrou                         �
				//������������������������������������
				dbSelectArea("ZBA")
				RecLock(Alias(),.T.)
				
				ZBA->ZBA_FILIAL	:= xFilial("ZBA")
				ZBA->ZBA_CODRAT	:= M->ZB7_CODRAT
				ZBA->ZBA_DESCRI	:= M->ZB7_DESCRI
				ZBA->ZBA_USUARI	:= __cUserId
				
				ZBA->(MsUnlock())
				
				//������������������������������������������Ŀ
				//�VG - 2011.01.10                           �
				//�Em caso de inclus�o, verifica se ja existe�
				//�o codigo incluido na tabela ZB9, se n�o   �
				//�inclui o codigo novo.   			         �
				//��������������������������������������������				
				dbSelectArea("ZB9")
				DbSetOrder(1)
				If !DbSeek(xFilial("ZB9")+M->ZB7_CODRAT)
					RecLock("ZB9",.T.)
					
					ZB9->ZB9_FILIAL	:= xFilial("ZB9")
					ZB9->ZB9_CODRAT	:= M->ZB7_CODRAT
					ZB9->ZB9_DESCRI	:= M->ZB7_DESCRI
					
					ZB9->(MsUnlock())
				Endif					
				
			Endif
		
		Endif		

	End Transaction     
	
	//���������������������������Ŀ
	//�VG - 2011.03.25            �
	//�Atualiza o filtro do browse�
	//�����������������������������			
	EditFiltro()

EndIf


Return

/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������Ŀ��
���Fun�ao    � ZB8LinOk   �Autor�Vin�cius Greg�rio      � Data �04/01/2011���
�������������������������������������������������������������������������Ĵ��
���Descri�ao � Valida os dados de Agente de Vendas da linha digitada      ���
�������������������������������������������������������������������������Ĵ��
���Sintaxe	 � ZZZTudOk                                                   ���
�������������������������������������������������������������������������Ĵ��
���Parametros� Nenhum                                                     ���
�������������������������������������������������������������������������Ĵ��
���Retorno	 � EXPL1 =	Verdadeiro na validacao                           ���
�������������������������������������������������������������������������Ĵ��
��� Uso		 � CSU                              						  ���
��������������������������������������������������������������������������ٱ�
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/
User Function ZB8LinOk()
//�����������������������Ŀ
//�Declara��o de vari�veis�
//�������������������������
Local x             := 1 
Local lRet			:= .T.
Local aArea         := ZB7->(GetArea())
Local nLinha		:= oGetZB8:nAt
Local nPercentual	:= 0

If oGetZB8:aCols[nLinha,Len(aHeaderZB8)+1]
	Return lRet
EndIf                

//������������������������������������������������������������Ŀ
//�Valida se tem alguma coisa preenchida junto com o percentual�
//��������������������������������������������������������������
If oGetZB8:aCols[nLinha,BuscaHeader(oGetZB8:aHeader,"ZB8_PERCEN")]==0 .or. ;
	Empty(Alltrim(oGetZB8:aCols[nLinha,BuscaHeader(oGetZB8:aHeader,"ZB8_CCDBTO")])) .or.;			
	Empty(Alltrim(oGetZB8:aCols[nLinha,BuscaHeader(oGetZB8:aHeader,"ZB8_ITDBTO")])) .or.;
	Empty(Alltrim(oGetZB8:aCols[nLinha,BuscaHeader(oGetZB8:aHeader,"ZB8_CLVLDB")])) .and. nOpc <> 5

	Aviso("Aviso","Os seguintes campos s�o obrigat�rios: "+RetTitle("ZB8_PERCEN")+", "+;
		RetTitle("ZB8_CCDBTO")+", "+;
		RetTitle("ZB8_ITDBTO")+" e "+;
		RetTitle("ZB8_CLVLDB")+". Por favor, verifique o preenchimento. ",{"OK"},,"Aten��o",,"BMPPERG")	
	lRet	:= .F.
	Return lRet

Endif

//���������������������������������������������������������������������������������������Ŀ
//�Valida se existe percentual com valor menor que zero - Tatiana A. Barbosa - OS 2256-11 �
//�����������������������������������������������������������������������������������������
If oGetZB8:aCols[nLinha,BuscaHeader(oGetZB8:aHeader,"ZB8_PERCEN")]<0

	Aviso("Aviso","O percentual do rateio n�o pode ser menor que zero. Por favor, verifique o preenchimento. ",{"OK"},,"Aten��o",,"BMPPERG")	
	lRet	:= .F.
	Return lRet

Endif

//�������������������������������������Ŀ
//�Valida se a combina��o est� d�plicada�
//���������������������������������������   
For x := 1 To Len(oGetZB8:aCols)

	If !oGetZB8:aCols[x][Len(oGetZB8:aHeader)+1]
		nPercentual	+= oGetZB8:aCols[x,BuscaHeader(oGetZB8:aHeader,"ZB8_PERCEN")]
	Endif
	
	If x != nLinha                                       

		If oGetZB8:aCols[nLinha,BuscaHeader(oGetZB8:aHeader,"ZB8_CCDBTO")]+;
			oGetZB8:aCols[nLinha,BuscaHeader(oGetZB8:aHeader,"ZB8_ITDBTO")]+;
			oGetZB8:aCols[nLinha,BuscaHeader(oGetZB8:aHeader,"ZB8_CLVLDB")];
			 == ;
			oGetZB8:aCols[x,BuscaHeader(oGetZB8:aHeader,"ZB8_CCDBTO")]+;
			oGetZB8:aCols[x,BuscaHeader(oGetZB8:aHeader,"ZB8_ITDBTO")]+;
			oGetZB8:aCols[x,BuscaHeader(oGetZB8:aHeader,"ZB8_CLVLDB")] .and.;
			!oGetZB8:aCols[nLinha,Len(oGetZB8:aHeader)+1] .and.;
			!oGetZB8:aCols[x,Len(oGetZB8:aHeader)+1]			
			
			Aviso("Aviso","A combina��o "+;
				"C. de Custo: "+Alltrim(oGetZB8:aCols[nLinha,BuscaHeader(oGetZB8:aHeader,"ZB8_CCDBTO")])+","+c_BR+;
				"Un. Neg�cio: "+Alltrim(oGetZB8:aCols[nLinha,BuscaHeader(oGetZB8:aHeader,"ZB8_ITDBTO")])+" e "+;
				"Opera��o: "+Alltrim(oGetZB8:aCols[nLinha,BuscaHeader(oGetZB8:aHeader,"ZB8_CLVLDB")])+c_BR+;
				"est� duplicado na lista.",;
				{"OK"},,"Aten��o",,"BMPPERG")
	
			lRet := .F.						
			Return lRet
		
		Endif                                                                   
	Endif
	
Next x

//������������������������������������������������������Ŀ
//�Verificar se o valor do percentual est� acima de 100%.�
//��������������������������������������������������������
/*If nPercentual > 100 
	Aviso("Aviso","A somat�ria do percentual � igual a "+Alltrim(STR(nPercentual))+"%. O somat�ria dos valores dever� totalizar 100%.",{"OK"},,"Aten��o",,"BMPPERG")
	lRet	:= .F.
	Return lRet	     	
EndIf*/

//��������������������������������������������������������������Ŀ
//�Valida��o do cliente para a combina��o das entidades cont�beis�
//����������������������������������������������������������������
If !U_VldCTBg( oGetZB8:aCols[nLinha,BuscaHeader(oGetZB8:aHeader,"ZB8_ITDBTO")], oGetZB8:aCols[nLinha,BuscaHeader(oGetZB8:aHeader,"ZB8_CCDBTO")], oGetZB8:aCols[nLinha,BuscaHeader(oGetZB8:aHeader,"ZB8_CLVLDB")], Nil )
	lRet	:= .F.
	Return lRet	     	
EndIf
	
RestArea(aArea)
Return lRet

/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������Ŀ��
���Fun�ao    � ZB8TudOk   �Autor�Vin�cius Greg�rio      � Data �12/07/2010���
�������������������������������������������������������������������������Ĵ��
���Descri�ao � Valida os dados de Agente de Vendas da linha digitada      ���
�������������������������������������������������������������������������Ĵ��
���Sintaxe	 � ZB8TudOk                                                   ���
�������������������������������������������������������������������������Ĵ��
���Parametros� Nenhum                                                     ���
�������������������������������������������������������������������������Ĵ��
���Retorno	 � EXPL1 =	Verdadeiro na validacao                           ���
�������������������������������������������������������������������������Ĵ��
��� Uso		 � CSU														  ���
��������������������������������������������������������������������������ٱ�
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/

User Function ZB8TudOk()
//���������������������������������������������������������������������������Ŀ
//� Declaracao de variaveis                                                   �
//�����������������������������������������������������������������������������
Local aArea			:= GetArea()
Local aAreaZB7		:= ZB7->( GetArea())
Local lReturn		:= .T.
Local nLoop			:= 0
Local nOri			:= 0
Local nPercTot		:= 0

If nOpc == 5 .or. nOpc==2
	Return(lReturn)
Endif	

//���������������������������������������Ŀ
//�VG - 2011.02.21 - Valida a combina��o  �
//�de Centro de Custo Transit�rio, Unidade�
//�de Neg�cio Transit�ria Opera��o Transi-�
//�t�ria.                                 �
//�����������������������������������������
If !U_VldCTBg( M->ZB7_ITTRAN, M->ZB7_CCTRAN, M->ZB7_CLTRAN, Nil )           
//	VG - 2011.02.21 - Ignorar essa mensagem pois a fun��o do cliente j� exibe um aviso de inconsist�ncia.
//	Aviso("Aviso","A combina��o de Centro de Custo Transit�rio, Unidade de Neg�cio Transit�ria e Opera��o Transit�ria n�o � v�lida."+;
//	"Por favor, utilize outra combina��o.",{"OK"},,"Aten��o",,"BMPPERG")
	lReturn	:= .F.
EndIf

//����������������������������������������Ŀ
//�Verifica se existem registros duplicados�
//������������������������������������������
If lReturn 
	
//	If ZB7->(DbSeek(xFilial("ZB7")+M->(ZB7_CODRAT+ZB7_ANOMES+ZB7_REVISA))) .and. nOpc==3
	If ZB7->(DbSeek(xFilial("ZB7")+M->ZB7_CODRAT+U_RZB7AnoMes(M->ZB7_MESANO)+M->ZB7_REVISA)) .and. nOpc==3
		Aviso("Aviso","J� existe um cadastro com o Codigo: "+Alltrim(ZB7_CODRAT)+" -Ano/Mes: "+Alltrim(ZB7_ANOMES)+" e Revis�o: "+ALLTRIM(ZB7_REVISA)+;
		". Por favor, utilize outro.",{"OK"},,"Aten��o",,"BMPPERG")
		lReturn := .F.		
    Endif      
    
Endif 


//������������������������������������������������������Ŀ
//�Verifica se � a inclus�o da tabela de rateio. Se for, �
//�permite que o usu�rio cadastre apenas o cabe�alho     �
//�da tabela ou a tabela inteira.                        �
//��������������������������������������������������������
If lReturn
	If nOpc==3 .and. (Empty(Alltrim(oGetZB8:aCols[1,BuscaHeader(oGetZB8:aHeader,"ZB8_CCDBTO")]+;
		oGetZB8:aCols[1,BuscaHeader(oGetZB8:aHeader,"ZB8_ITDBTO")]+;
		oGetZB8:aCols[1,BuscaHeader(oGetZB8:aHeader,"ZB8_CLVLDB")])))

		Aviso("Aviso","A tabela de rateios ser� criada sem a defini��o de seus itens. Ela s� poder� ser "+c_BR+;
				"utilizada para contabiliza��o depois que as regras de rateio forem definidas.",{"OK"},,"Aten��o",,"BMPPERG")	
		
	Else
		//�������������������Ŀ
		//� Valida cada linha �
		//���������������������
		For nLoop := 1 to Len(oGetZB8:aCols)
			nOri 			:= oGetZB8:nAt
			oGetZB8:nAt 	:= nLoop
			lReturn			:= U_ZB8LinOk()
			If !lReturn
				Exit
			Endif
		Next nLoop

		For nLoop := 1 to Len(oGetZB8:aCols)		
			If !oGetZB8:aCols[nLoop][Len(oGetZB8:aHeader)+1]//VG - 2011.03.18 - Corre��o somat�ria da porcentagem ignorando as linhas deletadas.
				nPercTot		+= oGetZB8:aCols[nLoop][BuscaHeader(oGetZB8:aHeader,"ZB8_PERCEN")]
			Endif
		Next nLoop
		
		//�������������������������������������������������Ŀ
		//�Verifica se a somat�ria dos percentuais dos itens�
		//�� igual a 100%                                   �
		//���������������������������������������������������
		If nPercTot <> 100
			Aviso("Aviso","A somat�ria dos percentuais nos itens � diferente de 100%. Por favor, verifique os valores novamente. Somat�ria Atual: "+Alltrim(STR(nPercTot)),;
				{"OK"},,"Aten��o",,"NOCHECKED")	
			lReturn := .F.
		Endif
		
	Endif
Endif

RestArea(aAreaZB7)
RestArea(aArea)
Return(lReturn)

/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������Ŀ��
���Fun�ao    � MontaAcols �Autor�Vin�cius Greg�rio      � Data �22/12/2010���
�������������������������������������������������������������������������Ĵ��
���Descri�ao � Preenche o aCols a partir dos arquivos utilizados nas      ���
���          � amarracoes do cliente                                      ���
�������������������������������������������������������������������������Ĵ��
���Parametros� EXPA1 = aHeader 										      ���
���			 � EXPC2 = Alias a ser pesquisado						      ���
���			 � EXPN3 = Ordem da chave de pesquisa 						  ���
���			 � EXPC4 = Alias do cabe�alho    							  ���
���			 � EXPC5 = Chave para a pesquisa							  ���
���			 � EXPC6 = Condicao para a busca							  ���
���			 � EXPA7 = Array de retorno     							  ���
���			 � EXPN8 = numero com a opcao do cadastro					  ���
�������������������������������������������������������������������������Ĵ��
���Retorno	 � EXPA1 =	Copia do aCols									  ���
��������������������������������������������������������������������������ٱ�
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/
Static Function MontaAcols(aHeader,cAliasCol,nOrder,cAliasCab,cChave,cCondicao,aColsRet,nOpcX)
Local nX
Local nDec     := 0
Local nUsado   := Len(aHeader)
Local aArea    := ZB7->( GetArea())

Default aColsRet := {} //Define o tipo da variavel, caso o valor seja nulo

//�����������������������������������������������������������������Ŀ
//�Se n�o for inclus�o, carrega o aCols com as informa��es do banco.�
//�������������������������������������������������������������������
If nOpcX <> 3

	dbSelectArea(cAliasCol)
	dbSetorder(nOrder)
	MsSeek(xFilial(cAliasCol)+cChave)
	
	While !Eof() .And. xFilial(cAliasCol)==&(cAliasCol+"_FILIAL") .And. &(cCondicao)==cChave
  
	    Aadd(aColsRet,Array(nUsado+1))
	    
	    For nX := 1 to Len(aHeader) 
	
			If aHeader[nX,10] <> "V"
		        aColsRet[Len(aColsRet),nX] := &(FieldName(FieldPos(cAliasCol+SubStr(AllTrim(aHeader[nX,2]),4))))    
			Else   
				If Empty(aHeader[nX,18]) //Nao possui IniBrowse
					aColsRet[Len(aColsRet),nX] := CriaVar(AllTrim(aHeader[nX,2]),.T.)
				Else
					aColsRet[Len(aColsRet),nX] := &(aHeader[nX,18])
				Endif
		   EndIf 
			    
	    Next nX
		    
		aColsRet[Len(aColsRet),nUsado+1] := .F.    
		
		(cAliasCol)->(dbSkip())                                               
				
	EndDo          
	
EndIf

//��������������������������������������������������������������Ŀ
//� Cria o aCols Vazio, caso nao haja dados para edicao          �
//����������������������������������������������������������������
If Len(aColsRet)==0
	Aadd(aColsRet,Array(nUsado+1))
	Aeval(aHeader,{|x,y|aColsRet[Len(aColsRet),y]:=If(AllTrim(aHeader[y,2])=="ZB8_SEQUEN","01",CriaVar(AllTrim(aHeader[y,2])))})
	
	aColsRet[Len(aColsRet),nUsado+1] := .F.    
EndIf

RestArea(aArea)
Return(aColsRet)

/*�������������������������������������������������������������������������������������������
���������������������������������������������������������������������������������������������
�����������������������������������������������������������������������������������������ͻ��
���                            Oficina1                                                   ���
�����������������������������������������������������������������������������������������͹��
���Programa    �MenuDef �Defini��o das rotinas para o programa                            ���
���            �        �                                                                 ���
�����������������������������������������������������������������������������������������͹��
���Projeto/PL  � Defini��o de op��es para o cadastro de regras de rateio.                 ���
�����������������������������������������������������������������������������������������͹��
���Solicitante �99.99.99�                                                                 ���
�����������������������������������������������������������������������������������������͹��
���Autor       �22.12.10�Vin�cius Greg�rio                                                ���
�����������������������������������������������������������������������������������������͹��
���Par�metros  �Nil                                                                       ���
�����������������������������������������������������������������������������������������͹��
���Retorno     �Nil.                                                                      ���
�����������������������������������������������������������������������������������������͹��
���Observa��es �                                                                          ���
�����������������������������������������������������������������������������������������͹��
���Altera��es  � 99.99.99 - Consultor - Descri��o da Altera��o                            ���
�����������������������������������������������������������������������������������������ͼ��
���������������������������������������������������������������������������������������������
�������������������������������������������������������������������������������������������*/
Static Function MenuDef()
     
Private aRotina   := {	{ "Pesquisar"		,"PesqBrw"   			 	 	,  	0, 1},;
			            { "Visualizar"		,"U_RCTB99A('ZB7',Recno(),2)"	,	0, 2},;
		            	{ "Incluir"			,"U_RCTB99A('ZB7',Recno(),3)"	,	0, 3},;
						{ "Alterar"			,"U_RCTB99A('ZB7',Recno(),4)"	,	0, 4},;
						{ "Excluir"			,"U_RCTB99A('ZB7',Recno(),5)"	,	0, 5},;
						{ "Copiar"			,"U_RCTB99C"				 	,	0, 2},;
						{ "Cp. Mult."		,"U_RCTBAA2"				 	,	0, 2},;
						{ "Hab.Revis."		,"U_RCTB99R"					, 	0, 2},;
						{ "Legenda"			,"U_RCTB99L"					, 	0, 2}}
						
Return(aRotina)

/*/
�������������������������������������������������������������������������������
�������������������������������������������������������������������������������
���������������������������������������������������������������������������Ŀ��
���Fun��o    �BuscaHeader� Autor �Jaime Wikanski        � Data �            ���
���������������������������������������������������������������������������Ĵ��
���Descri��o �Pesquisa a posicao do campo no aheader                        ���
���������������������������������������������������������������������������Ĵ��
���Uso       �                                                              ���
����������������������������������������������������������������������������ٱ�
�������������������������������������������������������������������������������
�������������������������������������������������������������������������������
/*/
Static Function BuscaHeader(aArrayHeader,cCampo)

Return(AScan(aArrayHeader,{|aDados| AllTrim(Upper(aDados[2])) == Alltrim(Upper(cCampo))}))

/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �RCTB99VA  �Autor  �Vin�cius Greg�rio   � Data �  23/12/10   ���
�������������������������������������������������������������������������͹��
���Desc.     � Valida o ano e m�s informados.                             ���
���          �                                                            ���
�������������������������������������������������������������������������͹��
���Uso       � CSU                                                        ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/
User Function RCTB99VA(cAnoRef)
//�����������������������Ŀ
//�Declara��o de vari�veis�
//�������������������������
Local aArea		:= GetArea()
Local lRetorno	:= .T.
Local cAno		:= ""
Local cMes		:= ""

If Len(Alltrim(cAnoRef)) <> 6
//	Aviso("Aviso","A data de refer�ncia deve ser completamente preenchida (Ex.: 2010/12)",{"OK"},,"Aten��o",,"BMPPERG")		
	Aviso("Aviso","A data de refer�ncia deve ser completamente preenchida (Ex.: 12/2010)",{"OK"},,"Aten��o",,"BMPPERG")		
	lRetorno	:= .F.
	Return lRetorno
Endif

//���������������Ŀ
//�Verifica o  ano�
//�����������������
//cAno	:= Substr(cAnoRef,1,4)
cAno	:= Substr(cAnoRef,3,4)

If Empty(cAno)
	Aviso("Aviso","O ano deve ser informado.",{"OK"},,"Aten��o",,"BMPPERG")		
	lRetorno	:= .F.
	Return lRetorno
Endif

//�����������������Ŀ
//�Verifica os meses�
//�������������������         
//cMes	:= Substr(cAnoRef,5,2)
cMes	:= Substr(cAnoRef,1,2)

If Empty(cAno)
	Aviso("Aviso","O m�s deve ser informado.",{"OK"},,"Aten��o",,"BMPPERG")		
	lRetorno	:= .F.
	Return lRetorno
ElseIf Val(cMes) < 0 .or. Val(cMes) > 12
	Aviso("Aviso","M�s informado inv�lido.",{"OK"},,"Aten��o",,"BMPPERG")		
	lRetorno	:= .F.
	Return lRetorno
Endif

RestArea(aArea)
Return lRetorno

/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �RCTB99C   �Autor  �Vin�cius Greg�rio   � Data �  28/12/10   ���
�������������������������������������������������������������������������͹��
���Desc.     � Tela para a c�pia de um rateio                             ���
���          �                                                            ���
�������������������������������������������������������������������������͹��
���Uso       � CSU                                                        ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/
User Function RCTB99C()
//�����������������������Ŀ
//�Declara��o de vari�veis�
//�������������������������
Local aRet 		:= {}
Local aPar 		:= {}
Local cCpyZB7	:= GetNextAlias()  
Local cCpyZB8	:= GetNextAlias()  
Local cCodRat	:= ""
Local cAnoMes	:= ""
Local cRevisa	:= ""
Local cStatus	:= ""

//aAdd(aPar,{1,"Qual o novo per�odo"	,Space(06),"@R 9999/99","","","",0,.F.}) 	// Tipo caractere
aAdd(aPar,{1,"Qual o novo per�odo"	,Space(06),"@R 99/9999","","","",0,.F.}) 	// Tipo caractere

// ParamBox(aParamBox, cTitulo			, aRet	  ,bOk, aButtons, lCentered, nPosx, nPosy, /*oMainDlg*/ , cLoad, lCanSave, lUserSave)
If !ParamBox(aPar,"Parametros do processamento",@aRet, ,, , , , ,"RCTB99C",.F., .F.)
	Return
Endif

//��������������������������Ŀ
//�Valida o M�s/Ano informado�
//����������������������������
If !U_RCTB99VA(aRet[1])
	Return
Endif
	    
cCodRat := ZB7_CODRAT
cAnoMes	:= ZB7_ANOMES
cRevisa := ZB7_REVISA
cStatus := ZB7_ATIVO 

//�������������������������������������������������������������������Ŀ
//� Verifica se a data eh diferente do cadastro que esta sendo copiado�
//���������������������������������������������������������������������
If ZB7->(DbSeek(xFilial("ZB7")+ZB7_CODRAT+U_RZB7AnoMes(aRet[1])+ZB7_REVISA+"A"))	
//	Aviso("Aten��o","A data "+substr(aRet[1],1,4)+"/"+substr(aRet[1],5,2)+" n�o pode ser a mesma da linha copiada, escolha outra por favor.",{"OK"},,"Aten��o",,"BMPPERG")
	Aviso("Aten��o","A data "+substr(aRet[1],1,2)+"/"+substr(aRet[1],3,4)+" n�o pode ser a mesma da linha copiada, escolha outra por favor.",{"OK"},,"Aten��o",,"BMPPERG")
	Return
Endif

	BeginSql Alias cCpyZB7
		Select * from %table:ZB7% ZB7
		WHERE ZB7.ZB7_FILIAL = %xFilial:ZB7% 
		AND ZB7.ZB7_CODRAT = %exp:cCodRat% 		
		AND ZB7.ZB7_ANOMES = %exp:cAnoMes% 		
		AND ZB7.ZB7_REVISA = %exp:cRevisa% 
		AND ZB7.ZB7_ATIVO = %exp:cStatus% 
		AND ZB7.%notDel%	
	EndSQL         
  
	(cCpyZB7)->(DbGoTop())	
	
	ZB7->(RecLock("ZB7",.T.))
		
		ZB7->ZB7_FILIAL 	:= xFilial("ZB7")
		ZB7->ZB7_CODRAT 	:= (cCpyZB7)->ZB7_CODRAT
		ZB7->ZB7_DESCRI 	:= (cCpyZB7)->ZB7_DESCRI
//		ZB7->ZB7_ANOMES 	:= aRet[1]
		ZB7->ZB7_ANOMES 	:= U_RZB7AnoMes(aRet[1])
		ZB7->ZB7_REVISA 	:= (cCpyZB7)->ZB7_REVISA
		ZB7->ZB7_ATIVO  	:= "A"
		ZB7->ZB7_CCTRAN  	:= (cCpyZB7)->ZB7_CCTRAN
		ZB7->ZB7_ITTRAN  	:= (cCpyZB7)->ZB7_ITTRAN
		ZB7->ZB7_CLTRAN  	:= (cCpyZB7)->ZB7_CLTRAN
		ZB7->ZB7_PROCES  	:= 'N'
		//������������������������������������������Ŀ
		//�VG - 2011.03.11                           �
		//�Coloca o nome do usu�rio que est� copiando�
		//��������������������������������������������
		ZB7->ZB7_USRNAM  	:= UsrRetName(__cUserId)
		ZB7->ZB7_USRNAM  	:= UsrFullName(__cUserId)//VG - 2011.03.22
	
	ZB7->(MsUnlock())    
	
	BeginSql Alias cCpyZB8
		Select * from %table:ZB8% ZB8
		WHERE ZB8.ZB8_FILIAL = %xFilial:ZB8% 
		AND ZB8.ZB8_CODRAT = %exp:cCodRat% 		
		AND ZB8.ZB8_ANOMES = %exp:cAnoMes% 		
		AND ZB8.ZB8_REVISA = %exp:cRevisa% 
		AND ZB8.%notDel%	
	EndSQL            	
	
	(cCpyZB8)->(DbGoTop())	
	
	While !(cCpyZB8)->(Eof())    
		ZB8->(RecLock("ZB8",.T.))	     
	    
	    	ZB8->ZB8_FILIAL := xFilial("ZB8")
	    	ZB8->ZB8_CODRAT := (cCpyZB8)->ZB8_CODRAT
//	    	ZB8->ZB8_ANOMES := aRet[1]
	    	ZB8->ZB8_ANOMES := U_RZB7AnoMes(aRet[1])
	    	ZB8->ZB8_REVISA := (cCpyZB8)->ZB8_REVISA
	    	ZB8->ZB8_SEQUEN := (cCpyZB8)->ZB8_SEQUEN
	    	ZB8->ZB8_CDEBIT := (cCpyZB8)->ZB8_CDEBIT
	    	ZB8->ZB8_PERCEN := (cCpyZB8)->ZB8_PERCEN
	    	ZB8->ZB8_CCDBTO := (cCpyZB8)->ZB8_CCDBTO
	    	ZB8->ZB8_ITDBTO := (cCpyZB8)->ZB8_ITDBTO
	    	ZB8->ZB8_CLVLDB	:= (cCpyZB8)->ZB8_CLVLDB
		
		ZB8->(MsUnlock())
		(cCpyZB8)->(DbSkip())
	EndDo            

	//���������������������Ŀ
	//�VG - 2011.03.25      �
	//�Reinicializa o filtro�
	//�����������������������
	EditFiltro()
	

Aviso("Aten��o","Tabela de Rateios copiada com sucesso!",{"OK"},,"Aten��o",,"BMPPERG")

Return
/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �RCTB99I   �Autor  �Rafael Gama		 � Data �  05/01/11   ���
�������������������������������������������������������������������������͹��
���Desc.     � Importacao dos itens do excel para o aCols                 ���
���          �                                                            ���
�������������������������������������������������������������������������͹��
���Uso       � CSU                                                        ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/
Static Function RCTB99I()

Local aImport	:= {}
Local nI		:= 0
Local nJ		:= 0
Local nK		:= 0

aImport := U_RCTBMA0() 

If Empty(aImport)
	Return
Endif

If Empty(oGetZB8:aCols[1][3])
//���������������������������������������������������������������Ŀ
//�se o acosl estiver vazio, importa do jeito que esta na planilha�
//�����������������������������������������������������������������
	oGetZB8:aCols := {}	
   	For nI := 1 to Len(aImport)
   		Aadd(oGetZB8:aCols,Array(Len(aHeaderZB8)+1))
		For nK := 1 To Len(aHeaderZB8)
			oGetZB8:aCols[nI][nK]	:= CriaVar(aHeaderZB8[nK,2],.F.)
		Next nK
   	
		For nJ := 1 to Len(oGetZB8:aCols[nI])                  			
	    	oGetZB8:aCols[nI][nJ] := If(VALTYPE(aImport[nI][nJ])=="C",STRTRAN(aImport[nI][nJ],CHR(160),""),aImport[nI][nJ])	
		Next nJ
	Next nI	
Else  
//���������������������������������������������������������������������Ŀ
//�se o acosl estiver preenchido, importa seguindo a sequencida do acols�
//�����������������������������������������������������������������������
	For nI := 1 to Len(aImport)	
		Aadd(oGetZB8:aCols,Array(Len(aHeaderZB8)+1))
		For nK := 1 To Len(aHeaderZB8)
			oGetZB8:aCols[Len(oGetZB8:aCols)][nK]	:= CriaVar(aHeaderZB8[nK,2],.F.)
		Next nK
	
		For nJ := 1 to Len(oGetZB8:aCols[nI]) 
			If nJ == 1
				oGetZB8:aCols[Len(oGetZB8:aCols)][nJ] := SOMA1(oGetZB8:aCols[Len(oGetZB8:aCols)-1][nJ])
			Else
		   		oGetZB8:aCols[Len(oGetZB8:aCols)][nJ] := If(VALTYPE(aImport[nI][nJ])=="C",STRTRAN(aImport[nI][nJ],CHR(160),""),aImport[nI][nJ])
		   	Endif	
	    Next nJ
	Next nI	
Endif         

Return 
/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  � RCTB99E  �Autor  �Rafael Gama		 � Data �  03/01/11   ���
�������������������������������������������������������������������������͹��
���Desc.     � Exportacao dos itens da modelo 3 para excel                ���
���          �                                                            ���
�������������������������������������������������������������������������͹��
���Uso       � CSU                                                        ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/
Static Function RCTB99E()

Local aItensEx 	:= {} 
Local nI		:= 0
Local nJ		:= 0

aItensEx := aClone(oGetZB8:aCols)
  
//���������������������������������������������������������������������������������Ŀ
//�Faz a varredura do acols para adicionar o espa�o em branco(CHR(160)) nos campos  �
//� que sao caracteres para o excel reconhecer como caractere						�
//�����������������������������������������������������������������������������������
/*If !Empty(oGetZB8:aCols)
	For nI := 1 to Len(oGetZB8:aCols)		
		For nJ := 1 to Len(oGetZB8:aCols[nI])
	    	If Valtype(oGetZB8:aCols[nI][nJ]) == "C"
	        	aItensEx[nI][nJ] := CHR(160)+Alltrim(oGetZB8:aCols[nI][nJ])
			Endif	
	    Next
	Next
Endif*/


MsgRun("Favor Aguardar.....", "Exportando os Registros para o Excel",{||GeraExcel({{"GETDADOS","CONTAS DE RATEIO",oGetZB8:aHeader,aItensEx}})})

Return      
/*/
�������������������������������������������������������������������������������
�������������������������������������������������������������������������������
���������������������������������������������������������������������������Ŀ��
���Fun��o    � GeraExcel� Autor �  Rafael Gama          � Data � 04/01/2011 ���
���������������������������������������������������������������������������Ĵ��
���Descri��o �Funcao que exporta os valores da tela para o Microsoft Excel  ���
���          �no formato .CSV                                               ���
���������������������������������������������������������������������������Ĵ��
���Par�metros� Array contendo os objetos a serem exportados                 ���
���������������������������������������������������������������������������Ĵ��
���Retorno   � Nil                                                          ���
���������������������������������������������������������������������������Ĵ��
��� Uso      � CSU			                                                ���
����������������������������������������������������������������������������ٱ�
�������������������������������������������������������������������������������
�������������������������������������������������������������������������������
*/
Static Function GeraExcel(aExport)

Local aArea		:= GetArea()
Local cDirDocs	:= MsDocPath() 
Local cPath		:= AllTrim(GetTempPath())
Local aCampos	:= {}
Local ny		:= 0
Local nX        := 0
Local nz		:= 0
Local cBuffer   := ""
Local oExcelApp := Nil
Local nHandle   := 0
Local cArquivo  := SuperGetMV("MV_XNOMPLN",,"tabela_de_rateio")
Local _cArquivo	:= ""
Local aHeader	:= {}
Local aCols		:= {}
Local cAuxTxt
Local aParamBox	:= {}
Local aRet		:= {}
Local lArqLocal := ExistBlock("DIRDOCLOC") 
Local cType			:=	"Arquivos XLS|*.XLS|Todos os Arquivos|*.*"

aTamSX3 := TAMSX3("ZB8_SEQUEN")
Aadd(aCampos, { "SEQUENC"		,aTamSX3[3],aTamSX3[1],aTamSX3[2]})

aTamSX3 := TAMSX3("ZB8_PERCEN")
Aadd(aCampos, { "PERCENT"		,aTamSX3[3],aTamSX3[1],aTamSX3[2]})

aTamSX3 := TAMSX3("ZB8_CCDBTO")
Aadd(aCampos, { "CCUSTO"		,aTamSX3[3],aTamSX3[1],aTamSX3[2]})

aTamSX3 := TAMSX3("ZB8_ITDBTO")
Aadd(aCampos, { "UNNEGOC"		,aTamSX3[3],aTamSX3[1],aTamSX3[2]})

aTamSX3 := TAMSX3("ZB8_CLVLDB")
Aadd(aCampos, { "OPERACA"		,aTamSX3[3],aTamSX3[1],aTamSX3[2]})

cArq := CriaTrab(aCampos,.T.)
dbUseArea(.T.,"DBFCDX",cArq,"TMPTRB",.f.)
DbSelectArea("TMPTRB")                                           

//���������������������������������������������������������Ŀ
//� Cria os indices temporarios								�
//�����������������������������������������������������������
aInd	:= {}
Aadd(aInd,{CriaTrab(Nil,.F.),"SEQUENC","Sequencia"})

For nA := 1 to Len(aInd)
	IndRegua("TMPTRB",aInd[nA,1],aInd[nA,2],,,OemToAnsi("Criando �ndice Tempor�rio...") )
Next nA
DbClearIndex()

For nA := 1 to Len(aInd)
	dbSetIndex(aInd[nA,1]+OrdBagExt())
Next nA

For nLoop := 1 to Len(aExport[1,4])
	RecLock("TMPTRB",.T.)
	TMPTRB->SEQUENC	:= aExport[1,4,nLoop,BuscaHeader(oGetZB8:aHeader,"ZB8_SEQUEN")]
	TMPTRB->PERCENT	:= aExport[1,4,nLoop,BuscaHeader(oGetZB8:aHeader,"ZB8_PERCEN")]
	TMPTRB->CCUSTO	:= aExport[1,4,nLoop,BuscaHeader(oGetZB8:aHeader,"ZB8_CCDBTO")]
	TMPTRB->UNNEGOC	:= aExport[1,4,nLoop,BuscaHeader(oGetZB8:aHeader,"ZB8_ITDBTO")]
	TMPTRB->OPERACA	:= aExport[1,4,nLoop,BuscaHeader(oGetZB8:aHeader,"ZB8_CLVLDB")]
	MsUnlock()
Next nLoop
                                  
//_cArquivo := __RELDIR+cArquivo+".xls"//VG - 2011.02.28 - na homologa��o o __RELDIR � no C:\ do usu�rio!!!
_cArquivo := cDirDocs+ "\" +cArquivo+".xls"

Copy to &_cArquivo
dbCloseArea("TMPTRB")

//���������������������������������������������������Ŀ
//� Carrega o Excel com o Arquivo Criado              �
//�����������������������������������������������������
//If lArqLocal
//	cArquivo := cPath + "\" + cArquivo
//Else
//	cArquivo := cDirDocs + "\" + cArquivo
//Endif

//cPath  := AllTrim(GetTempPath())
CpyS2T( _cArquivo , cPath, .T. )
If ! ApOleClient( 'MsExcel' )
	MsgStop( "MsExcel nao instalado" )
	Return
EndIf
oExcelApp := MsExcel():New()
oExcelApp:WorkBooks:Open( cPath+cArquivo+".xls" ) // Abre uma planilha
oExcelApp:SetVisible(.T.)

RestArea(aArea)
Return

/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �VerifDel  �Autor  �V. Greg�rio         � Data �  06/01/11   ���
�������������������������������������������������������������������������͹��
���Desc.     � Verifica se n�o existe nenhum registro de SEV que utiliza  ���
���          � esse c�digo de rateio.                                     ���
�������������������������������������������������������������������������͹��
���Uso       � CSU                                                        ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/
Static Function VerifDel(cCodRat)
//�����������������������Ŀ
//�Declara��o de vari�veis�
//�������������������������
Local lRetorno	:= .T.     
Local cQry		:= ""

//�������������Ŀ
//�Monta a query�
//���������������
cQry	:= "SELECT count(*) CONTADOR FROM "+RetSQLName("SEV")+" "+c_BR
cQry	+= "WHERE EV_FILIAL = '"+xFilial("SEV")+"' "+c_BR
cQry	+= "AND EV_XCODRAT = '"+cCodRat+"' "+c_BR
cQry	+= "AND D_E_L_E_T_ <> '*' "+c_BR

If Select("TMPDEL") > 0
	DbSelectArea("TMPDEL")
	DbCloseArea()
Endif
MsAguarde({|| DbUseArea(.T., "TOPCONN", TCGenQry(,,cQry),"TMPDEL", .F., .T.)}, "Verificando se n�o foi utilizado anteriormente...")

If TMPDEL->CONTADOR > 0
	lRetorno	:= .F.
Endif

Return lRetorno 
/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  � RCTBMA2  �Autor  �Rafael Gama         � Data �  11/01/11   ���
�������������������������������������������������������������������������͹��
���Desc.     � Verifica se a descricao do registro da ZB7 esta igual a    ���
���          � outra descricao com o mesmo c�digo de rateio.		      ���
�������������������������������������������������������������������������͹��
���Uso       � CSU                                                        ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/
User Function RCTBMA2()

Local lRet 		:= .T.  
Local cAliasZB7	:= GetNextAlias()

     
	If Select(cAliasZB7) > 0
		DbSelectArea(cAliasZB7)
		DbCloseArea()
	Endif  

	BeginSql Alias cAliasZB7 
	
		Select Distinct ZB7_CODRAT, ZB7_DESCRI from %table:ZB7% (NOLOCK)
		Where ZB7_FILIAL = %xFilial:ZB7% AND ZB7_CODRAT = %exp:M->ZB7_CODRAT% AND %notDel%	
		
	EndSQL
    
    If !(cAliasZB7)->(Eof())
		If ALLTRIM(M->ZB7_DESCRI) <> ALLTRIM((cAliasZB7)->ZB7_DESCRI)
			Aviso("Aviso","A descri��o n�o pode ser diferente do Rateio "+ALLTRIM(M->ZB7_CODRAT)+".!",{"OK"},,"Aten��o",,"BMPPERG")
		    lRet := .F.
		Endif
	Endif				    
	
	DbSelectArea(cAliasZB7)
	DbCloseArea()

Return(lRet)
/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  � RCTBMA3  �Autor  �Rafael Gama         � Data �  11/01/11   ���
�������������������������������������������������������������������������͹��
���Desc.     � Verifica se o codigo a cadastrar eh permito para o usuario ���
���          � que esta logado.										      ���
�������������������������������������������������������������������������͹��
���Uso       � CSU                                                        ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/
User Function RCTBMA3()

Local lRet 			:= .T.  
Local cUserfull		:= ALLTRIM(SuperGetMV("MV_XUSRRAT",,""))

If cUserfull <> __cUserID
	ZB6->(Dbsetorder(1))
	If ZB6->(DbSeek(xFilial("ZB6")+M->ZB7_CODRAT))
		If !ZB6->(DbSeek(xFilial("ZB6")+M->ZB7_CODRAT+__cUserID,))
			Aviso("Aviso","C�digo utilizado anteriormente e o usu�ro n�o tem permiss�o para inclus�o do codigo "+ALLTRIM(M->ZB7_CODRAT)+".",{"OK"},,"Aten��o",,"BMPPERG")
			lRet := .F.  
		Endif
	Endif
Endif

Return(lRet)                                     

/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �RZB7AnoMes�Autor  �Vin�cius Greg�rio   � Data �  17/01/11   ���
�������������������������������������������������������������������������͹��
���Desc.     � Inverter o ano e m�s para gravar na base de dados.         ���
���          �                                                            ���
�������������������������������������������������������������������������͹��
���Uso       � CSU                                                        ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/
User Function RZB7ANOMES(cMesAno)
//�����������������������Ŀ
//�Declara��o de vari�veis�
//�������������������������
Local aArea		:= GetArea()
Local cRetorno	:= ""

cRetorno	:= Substr(cMesAno,3,4)+Substr(cMesAno,1,2)

RestArea(aArea)
Return cRetorno


/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �RCTB99L   �Autor  �Vin�cius Greg�rio   � Data �  17/02/11   ���
�������������������������������������������������������������������������͹��
���Desc.     � Exibe a legenda do browse                                  ���
���          �                                                            ���
�������������������������������������������������������������������������͹��
���Uso       � CSU                                                        ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/
User Function RCTB99L()                
//�����������������������Ŀ
//�Declara��o de vari�veis�
//�������������������������
Local aLegenda := {}
               
aAdd(aLegenda, {"BR_VERDE"  	,"Tabela pendente de atualiza��o"}) 	
aAdd(aLegenda, {"BR_VERMELHO"	,"Tabela processada"})
aAdd(aLegenda, {"BR_AZUL"		,"Tabela atualizada"})  
aAdd(aLegenda, {"BR_AMARELO"	,"Tabela componente"})//VG - 2011.06.09

BrwLegenda("Tabelas de Rateio","Legenda" ,aLegenda) //"Legenda"        
Return .T.

/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  � RCTB99Y  �Autor  �Vin�cius Greg�rio   � Data �  17/02/11   ���
�������������������������������������������������������������������������͹��
���Desc.     � Rotina para valida��o de legenda                           ���
���          �                                                            ���
�������������������������������������������������������������������������͹��
���Uso       � CSU                                                        ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/
User Function RCTB99Y()
//�����������������������Ŀ
//�Declara��o de vari�veis�
//�������������������������
Local aArea		:= GetArea()
Local lRetorno	:= .F.

dbSelectArea("ZB8")
dbSetOrder(1)//ZB8_FILIAL+ZB8_CODRAT+ZB8_ANOMES+ZB8_REVISA+ZB8_SEQUEN
If dbSeek(ZB7->ZB7_FILIAL+ZB7->ZB7_CODRAT+ZB7->ZB7_ANOMES+ZB7->ZB7_REVISA,.F.)
	lRetorno	:= .T.
Endif          

dbSelectArea("ZB7")

Return lRetorno

/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  � RCTB99Z  �Autor  �Vin�cius Greg�rio   � Data �  03/03/11   ���
�������������������������������������������������������������������������͹��
���Desc.     � Calcular a somat�ria dos percentuais                       ���
���          �                                                            ���
�������������������������������������������������������������������������͹��
���Uso       � CSU                                                        ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/
Static Function RCTB99Z()
//�����������������������Ŀ
//�Declara��o de vari�veis�
//�������������������������
Local aArea		:= GetArea()
Local nLoop		:= 0 
Local nPercTot	:= 0

For nLoop := 1 to Len(oGetZB8:aCols)		
	If !oGetZB8:aCols[nLoop][Len(oGetZB8:aHeader)+1]//VG - 2011.03.18 - Corre��o somat�ria da porcentagem ignorando as linhas deletadas.
		nPercTot		+= oGetZB8:aCols[nLoop][BuscaHeader(oGetZB8:aHeader,"ZB8_PERCEN")]
	Endif
Next nLoop

//�������������������������
//�VG - 2011.03.22        �
//�Atualiza as informa��es�
//�de totaliza��o.        �
//�������������������������
nTotPerc	:=	nPercTot 
nRestPerc	:= 100-nPercTot
If oGetValTot <> Nil .and. oGetValRest <> Nil
	oGetValTot:Refresh()                     
	oGetValRest:Refresh()
Endif

Return                      

/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  � RCTB99K  �Autor  �Vin�cius Greg�rio   � Data �  03/03/11   ���
�������������������������������������������������������������������������͹��
���Desc.     � Rotina para deletar todos os itens.                        ���
���          �                                                            ���
�������������������������������������������������������������������������͹��
���Uso       � CSU                                                        ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/
Static Function RCTB99K()
//�����������������������Ŀ
//�Declara��o de vari�veis�
//�������������������������                       
Local nLoop	:= 0

//����������������������������������������������������Ŀ
//�Marcar todos os registros da GetDados como deletados�
//������������������������������������������������������
For nLoop := 1 to Len(oGetZB8:aCols)
	oGetZB8:aCols[nLoop][Len(aHeaderZB8)+1]	:= .T.
Next nLoop

Return 


/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �RCTB99R   �Autor  �Vin�cius Greg�rio   � Data �  18/03/11   ���
�������������������������������������������������������������������������͹��
���Desc.     � Rotina para habilitar novas revis�es                       ���
���          �                                                            ���
�������������������������������������������������������������������������͹��
���Uso       � CSU                                                        ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/
User Function RCTB99R()
//�������������������������
//�Declara��o de vari�veis�
//�������������������������
Local aArea		:= GetArea()
Local cUserAdm	:= ALLTRIM(SuperGetMV("MV_XRATBLQ",,""))//usu�rio com prermiss�o para desbloquear revis�es

//�����������������������������������������������������������Ŀ
//�Verifica se o usu�rio tem permiss�o para habilitar revis�es�
//�������������������������������������������������������������
If __cUserId <> cUserAdm
	Aviso("Aviso","Usu�rio sem permiss�es para essa opera��o.",{"OK"},,"Aten��o",,"BMPPERG")			
	Return .F.	
Endif

//��������������������������Ŀ
//�Verifica se � uma revis�o.�
//����������������������������
If ZB7->ZB7_REVISA == "000"
	Aviso("Aviso","O registro selecionado n�o � uma revis�o de tabela de rateio.",{"OK"},,"Aten��o",,"BMPPERG")			
	Return .F.	
Endif

//��������������������������Ŀ
//�Verifica se est� inativa  �
//����������������������������
If ZB7->ZB7_ATIVO <> 'I'
	Aviso("Aviso","A revis�o j� est� ativa.",{"OK"},,"Aten��o",,"BMPPERG")			
	Return .F.	
Endif

//���������������Ŀ
//�Ativa a revis�o�
//�����������������
dbSelectArea("ZB7")
RecLock("ZB7",.F.)
	ZB7->ZB7_ATIVO := 'A'
MsUnlock()

//��������������������������������������Ŀ
//�Pergunta se o usu�rio deseja estornar �
//�todas as contabiliza��es de rateio j� �
//�processadas para aquela tabela.       �
//����������������������������������������
If Aviso("Estorno","Deseja estornar todos os documentos de entradas com rateio j� processado para essa tabela no per�odo?",;
	{"Sim","N�o"},,"Aten��o",,"BMPPERG")==1
	//���������������������������������������������������������������������������Ŀ
	//�Estorna todas notas contabilizadas para aquela tabela de rateio no per�odo.�
	//�����������������������������������������������������������������������������
	ProcEst()	
Endif

RestArea(aArea)
Return

/*
�����������������������������������������������������������������������������������������������
�����������������������������������������������������������������������������������������������
�������������������������������������������������������������������������������������������ͻ��
���Programa  �ProcEst   �Autor  �Vin�cius Greg�rio                     � Data �  07/01/11   ���
�������������������������������������������������������������������������������������������͹��
���Descri��o � Processa o estorno das notas rateadas para a tabela de rateio na vig�ncia.   ���
���          �                                                                              ���
�������������������������������������������������������������������������������������������͹��
���Retorno   �                                                                              ���
�������������������������������������������������������������������������������������������͹��
���Uso       �CSU        		                                                            ���
�������������������������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������������������������
�����������������������������������������������������������������������������������������������
*/
                                                                    
Static Function ProcEst()
//�����������������������Ŀ
//�Declara��o de vari�veis�
//�������������������������
Local nTotRegs		:= 0
Local cQry			:= ""
Local nX			:= 0
Local nCountReg		:= 1

Local cDataDe 	:=	"01/"+Substr(ZB7->ZB7_ANOMES,5,2)+"/"+Substr(ZB7->ZB7_ANOMES,1,4)
Local cDataAte	:= 	LastDay(CTOD("01/"+Substr(ZB7->ZB7_ANOMES,5,2)+"/"+Substr(ZB7->ZB7_ANOMES,1,4)))
Local cRatDe	:= 	ZB7->ZB7_CODRAT
Local cBranco	:= ""

Local aIndisp	:= {}

Local cUltRev	:= ""
Local cAnoMes	:= ""       

Local nA 			:= 0
Local aCampos 		:= {}
Local aDescCpo		:= {}
Local aTamSX3		:= {}
Local cArq 			:= ""
Private aInd  		:= {}
Private Qry 		:= GetNextAlias()
                         
//�������������������������������������������������������Ŀ
//� Monta os campos do arquivo temporario para markbrowse �
//��������������������������������������������������������� 
Aadd(aCampos, { "TMP_OK"    	,"C",02,0 })                        

aTamSX3 := TAMSX3("F1_FILIAL")
Aadd(aCampos, { "TMP_FILIAL"	,aTamSX3[3],aTamSX3[1],aTamSX3[2]})    

aTamSX3 := TAMSX3("F1_DOC")
Aadd(aCampos, { "TMP_DOC"		,aTamSX3[3],aTamSX3[1],aTamSX3[2]})

aTamSX3 := TAMSX3("F1_SERIE")
Aadd(aCampos, { "TMP_SERIE"		,aTamSX3[3],aTamSX3[1],aTamSX3[2]})

aTamSX3 := TAMSX3("F1_FORNECE")
Aadd(aCampos, { "TMP_FORNEC"	,aTamSX3[3],aTamSX3[1],aTamSX3[2]})

aTamSX3 := TAMSX3("F1_LOJA")
Aadd(aCampos, { "TMP_LOJA"		,aTamSX3[3],aTamSX3[1],aTamSX3[2]})

aTamSX3 := TAMSX3("A2_NREDUZ")
Aadd(aCampos, { "TMP_NREDUZ"	,aTamSX3[3],aTamSX3[1],aTamSX3[2]})

aTamSX3 := TAMSX3("ZB7_CODRAT")
Aadd(aCampos, { "TMP_CODRAT"	,aTamSX3[3],aTamSX3[1],aTamSX3[2]})    

aTamSX3 := TAMSX3("ZB7_DESCRI")
Aadd(aCampos, { "TMP_DESCRI"	,aTamSX3[3],aTamSX3[1],aTamSX3[2]})    

aTamSX3 := TAMSX3("F1_DUPL")
Aadd(aCampos, { "TMP_DUPL"		,aTamSX3[3],aTamSX3[1],aTamSX3[2]})

aTamSX3 := TAMSX3("F1_EMISSAO ")
Aadd(aCampos, { "TMP_EMISSA "	,aTamSX3[3],aTamSX3[1],aTamSX3[2]})    

aTamSX3 := TAMSX3("ED_CODIGO")
Aadd(aCampos, { "TMP_NATURE"	,aTamSX3[3],aTamSX3[1],aTamSX3[2]})    

aTamSX3 := TAMSX3("ED_DESCRIC")
Aadd(aCampos, { "TMP_NATDES"	,aTamSX3[3],aTamSX3[1],aTamSX3[2]})    

Aadd(aCampos, { "TMP_MARCA"    	,"C",01,0 })//VG - campo que ir� permitir marcar ou n�o

//���������������������������������������������������������Ŀ
//� Monta array com a descricao dos campos a serem exibidos �
//�����������������������������������������������������������
aCpos := { {"TMP_OK"		,,""},; //"OK" 
	  	   {"TMP_FILIAL"	,,"Filial"},; //"Filial"	 
	  	   {"TMP_DOC"		,,"Documento"},; //"Documento"	 
	  	   {"TMP_SERIE"		,,"Serie"},; //"Serie"
   		   {"TMP_DUPL"		,,"Duplicata"},; //"Duplicata"
   	  	   {"TMP_FORNEC"	,,"Fornecedor"},; //"Forneceodr"
		   {"TMP_LOJA"		,,"Loja"},; //"Loja"
   		   {"TMP_NREDUZ"	,,"Nome"},; //"Nome"
   		   {"TMP_NATURE"	,,"Cod Natureza"},; //"Cod Natureza"
   		   {"TMP_NATDES"	,,"Nome Natureza"},; //"Descricao Natureza"
   		   {"TMP_CODRAT"	,,"Cod. Rateio"},; //"Nome"
   		   {"TMP_DESCRI"	,,"Descr. Rateio"},; //"Nome"
   		   {"TMP_EMISSA"	,,"Emissao"} }  //"Nome" 

//���������������������������������������������������������Ŀ
//� Cria o arquivo temporario								�
//�����������������������������������������������������������
cArq := CriaTrab(aCampos,.T.)
dbUseArea(.T.,"DBFCDX",cArq,"TRB",.f.)
DbSelectArea("TRB")

//���������������������������������������������������������Ŀ
//� Cria os indices temporarios								�
//�����������������������������������������������������������
aInd	:= {}
Aadd(aInd,{CriaTrab(Nil,.F.),"TMP_FILIAL+TMP_DOC+TMP_SERIE+TMP_FORNEC+TMP_LOJA","Filial+Doc+Serie+Fornece+Loja"})

For nA := 1 to Len(aInd)
	IndRegua("TRB",aInd[nA,1],aInd[nA,2],,,OemToAnsi("Criando �ndice Tempor�rio...") )
Next nA
DbClearIndex()

For nA := 1 to Len(aInd)
	dbSetIndex(aInd[nA,1]+OrdBagExt())
Next nA

//�������������������������������������������������������Ŀ
//� Alimenta a variavel utilizada para marcacao           �
//���������������������������������������������������������
cMarca := GetMark(,"TRB","TMP_OK")

//�����������������������������������������Ŀ
//�Query para pegar os Documentos de Entrada�
//�que ainda n�o foram processados.         �
//�������������������������������������������
//VG - 2011.03.03 - Removi a filial da query na SF1 a pedido da usu�ria Mirian. As tabelas SEV e SED s�o compartilhadas.
//Isso pode atrapalhar consideravelmente a performance dessa consulta na tabela SF1!!!
BeginSql alias Qry

	SELECT F1_FILIAL, F1_DOC,F1_SERIE,F1_FORNECE,F1_LOJA,F1_DUPL,F1_EMISSAO, EV_XCODRAT ZB7_CODRAT, ED_CODIGO, ED_DESCRIC 
	FROM %table:SF1% SF1(NOLOCK),%table:SEV% SEV(NOLOCK), %table:SED% SED(NOLOCK)
	WHERE F1_XPRORAT = '1'
		AND F1_EMISSAO BETWEEN %Exp:cDataDe% AND %Exp:cDataAte%
		AND F1_DTLANC <> '        '
		AND SF1.%notDel%             
    	AND EV_FILIAL = %xfilial:SEV%
	    AND EV_NUM = F1_DOC 
    	AND EV_PREFIXO = F1_PREFIXO      
    	AND EV_CLIFOR = F1_FORNECE
    	AND EV_LOJA = F1_LOJA
    	AND EV_XCODRAT = %Exp:cRatDe%
	    AND SEV.%notDel%   
       	AND ED_FILIAL = %xfilial:SED%
	    AND ED_CODIGO = EV_NATUREZ
   	    AND SED.%notDel%   
	    		
EndSql                              

//���������������������������������������������������������Ŀ
//� Define a quantidade de registros a processar			�
//�����������������������������������������������������������
(Qry)->( DbEval( {|| nTotRegs++},,{ || !Eof()} ))

//���������������������������������������������������������Ŀ
//� Alimenta o arquivo de trabalho                			�
//�����������������������������������������������������������
DbSelectArea(Qry)
DbGoTop()
ProcRegua(nTotRegs)
While !Eof()
	
	//���������������������������������������������������������Ŀ
	//� Incrementa a regua de processanto            			�
	//�����������������������������������������������������������
	IncProc("Processando registro "+Alltrim(Str(nCountReg))+" de "+Alltrim(Str(nTotRegs))+".")
	
	//���������������������������������������������������������Ŀ
	//� Grava os registros na tabela temporaria      			�
	//�����������������������������������������������������������
	DbSelectArea("TRB")
	DbSetOrder(1)
	RecLock("TRB",.T.)
	
	TRB->TMP_FILIAL	:= (QRY)->F1_FILIAL
	TRB->TMP_OK		:= cMarca//Space(02)
	TRB->TMP_DOC	:= (QRY)->F1_DOC
	TRB->TMP_SERIE	:= (QRY)->F1_SERIE
	TRB->TMP_FORNEC	:= (QRY)->F1_FORNECE
	TRB->TMP_LOJA 	:= (QRY)->F1_LOJA
	TRB->TMP_NREDUZ	:= Posicione("SA2",1,xFilial("SA2")+(QRY)->F1_FORNECE+(QRY)->F1_LOJA,"A2_NREDUZ")
	TRB->TMP_CODRAT	:= (QRY)->ZB7_CODRAT
	TRB->TMP_DESCRI	:= Posicione("ZB7",1,xFilial("ZB7")+(QRY)->ZB7_CODRAT,"ZB7_DESCRI")
	TRB->TMP_DUPL	:= (QRY)->F1_DUPL
	TRB->TMP_EMISSA	:= Stod((QRY)->F1_EMISSAO)
	TRB->TMP_NATURE	:= (QRY)->ED_CODIGO
	TRB->TMP_NATDES	:= (QRY)->ED_DESCRIC
	TRB->TMP_MARCA	:= Space(01)
    
	MsUnlock()
	
	nCountReg++
	
	DbSelectArea(QRY)
	DbSkip()
	
Enddo

//�������������������������������������������������Ŀ
//� Finaliza a area do arquivo de execucao da query �
//���������������������������������������������������
If Select(QRY) > 0
	DbSelectArea(QRY)
	DbCloseArea()
Endif        

//�������������������������������������������������Ŀ
//�Buscar os lan�amentos cont�beis relativos � nota.�
//���������������������������������������������������
dbSelectArea("TRB")
dbSetOrder(1)//TMP_FILIAL+TMP_DOC+TMP_SERIE+TMP_FORNEC+TMP_LOJA
dbGoTop()

//�������������������������������Ŀ
//�Processa o estorno dos rateios.�
//���������������������������������
U_CTBMA4PR(.T.)

//���������������������������Ŀ
//�Apaga a tabela tempor�ria. �
//�����������������������������
If Select("TRB") > 0
	DbSelectArea("TRB")
	DbCloseArea()
	FErase(cArq+GetDbExtension())
	For nA := 1 to Len(aInd)
		FErase(aInd[nA,1]+OrdBagExt())
	Next nA
Endif

Return(Nil)  


/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �EditFiltro�Autor  �Vin�cius Greg�rio   � Data �  25/03/11   ���
�������������������������������������������������������������������������͹��
���Desc.     �                                                            ���
���          �                                                            ���
�������������������������������������������������������������������������͹��
���Uso       � AP                                                         ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/
Static Function EditFiltro()
//�����������������������Ŀ
//�Declara��o de vari�veis�
//�������������������������
Local cAliaZB7		:= GetNextAlias() 
Local cUsrLog		:= __cUserID 
Local cCodRat		:= ""
Local cCodIN		:= "" 
Local cUserfull		:= ALLTRIM(SuperGetMV("MV_XUSRRAT",,""))

If !lDefTop

	//��������������������������Ŀ
	//�Encerra o filtro anterior.�
	//����������������������������
	EndFilBrw(cAlias,aIndexZB7)
    
	//����������������Ŀ
	//�Remonta o filtro�
	//������������������
	If !(cUsrLog$Alltrim(cUserfull))

		BeginSql Alias cAliaZB7 
			Select ZB6_CODRAT from %table:ZB6% ZB6 (NOLOCK), %table:ZB7% ZB7 (NOLOCK)
			WHERE ZB6_FILIAL = %xFilial:ZB6% AND ZB6_USUARI = %exp:cUsrLog% AND ZB6.%NotDel%
			AND ZB6_CODRAT = ZB7_CODRAT AND ZB6_CODRAT BETWEEN %exp:MV_PAR03% AND %exp:MV_PAR04% 
			AND ZB7_ANOMES BETWEEN %exp:cAnoMesD% AND %exp:cAnoMesA% AND ZB7.%NotDel%
		EndSQL	
	    
		(cAliaZB7)->(DbGoTop())
	
		While !(cAliaZB7)->(EOF())
    		cCodRat += ALLTRIM((cAliaZB7)->ZB6_CODRAT)
			(cAliaZB7)->(DbSkip())
			If !(cAliaZB7)->(EOF())         
				cCodRat += ";"
			Endif	
		EndDo       
		
		(cAliaZB7)->(dbCloseArea())
	
		cCodIN := FormatIn(ALLTRIM(cCodRat), ";")	
	
//		cFilterZB7	:= "ZB7_CODRAT $ "+cCodIN
		cFilterZB7	:= "ZB7_CODRAT $'"+STRTRAN(STRTRAN(STRTRAN(cCodIN,")",""),"(",""),"'","")+"'"
		
		If Len(cFilterZB7) > 2000
			Aviso("Aviso","O filtro gerado � muito abrangente e os resultados n�o podem ser exibidos. Por favor, revise os par�metros de exibi��o.",{"OK"},,"Aten��o",,"BMPPERG")								
			Return .F.
		Endif
		
		DbSelectArea(cAlias)
		dbSetOrder(1)
		Eval(bFiltraBrw)

	ElseIf (cUsrLog $Alltrim(cUserfull))
		cFilterZB7	:= "ZB7_CODRAT <> ' '" 
		Eval(bFiltraBrw)
		DbSelectArea(cAlias)
		dbSetOrder(1) 
	
	Endif
   
Endif

Return .T.

/*
���������������������������������������������������������������������������������������������
���������������������������������������������������������������������������������������������
�����������������������������������������������������������������������������������������ͻ��
��� Programa    � CriaSx1  � Verifica e cria um novo grupo de perguntas com base nos      ���
���             �          � par�metros fornecidos                                        ���
�����������������������������������������������������������������������������������������͹��
��� Solicitante � 23.05.05 � Modelagem de Dados                                           ���
�����������������������������������������������������������������������������������������͹��
��� Autor       � 28.04.04 � TI0607 - Almir Bandina                                       ���
�����������������������������������������������������������������������������������������͹��
��� Produ��o    � 99.99.99 � Ignorado                                                     ���
�����������������������������������������������������������������������������������������͹��
��� Par�metros  � ExpA1 = array com o conte�do do grupo de perguntas (SX1)                ���
�����������������������������������������������������������������������������������������͹��
��� Retorno     � Nil                                                                     ���
�����������������������������������������������������������������������������������������͹��
��� Observa��es �                                                                         ���
���             �                                                                         ���
�����������������������������������������������������������������������������������������͹��
��� Altera��es  � 99/99/99 - Consultor - Descricao da altera��o                           ���
���             �                                                                         ���
�����������������������������������������������������������������������������������������ͼ��
���������������������������������������������������������������������������������������������
���������������������������������������������������������������������������������������������
*/
Static Function CriaSx1(aRegs)

Local aAreaAtu	:= GetArea()
Local aAreaSX1	:= SX1->(GetArea())
Local nJ		:= 0
Local nY		:= 0

dbSelectArea("SX1")
dbSetOrder(1)

For nY := 1 To Len(aRegs)
	If !MsSeek(Padr(aRegs[nY,1],Len(SX1->X1_GRUPO))+aRegs[nY,2])
		RecLock("SX1",.T.)
		For nJ := 1 To FCount()
			If nJ <= Len(aRegs[nY])
				FieldPut(nJ,aRegs[nY,nJ])
			EndIf
		Next nJ
		MsUnlock()
	EndIf
Next nY

RestArea(aAreaSX1)
RestArea(aAreaAtu)
Return(Nil)