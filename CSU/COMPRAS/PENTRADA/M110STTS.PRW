#Include 'Rwmake.ch'
#Include 'TopConn.ch'

/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  � M110STTS �Autor  � Sergio Oliveira    � Data �  Out/2006   ���
�������������������������������������������������������������������������͹��
���Desc.     � Ponto de entrada apos a gravacao da solicitacao de compras ���
���          � tem como objetivo gerar o controle de alcadas.             ���
�������������������������������������������������������������������������͹��
���Uso       � CSU                                                        ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/

User Function M110STTS()

Local _cExec     := '', _cStatus := '02', cUpdSC1 := "", cExec
Local _aAreaAnt  := GetArea(), _aAprov := {}
Local _nNivel    := 1
Local cLog       := 'SC'+Trim(xFilial("SC1")+cA110Num)+'-'+Dtos(Date())+'-'+StrTran(Time(),":","_")+'.log'
Private nSc      := FCreate( '\workflow\'+cLog,1 )
Private cEol     := Chr(13)+Chr(10)

FWrite( nSC, "Inicio de gravacao da SC "+Trim(xFilial("SC1")+cA110Num)+cEol )

ChkFile('SAK')
ChkFile('SAL')

If !(Inclui .Or. Altera .Or. IsInCallStack('A110COPIA') ) .And. 'MATA110' $ FunName() .Or. Empty(cUsuario) // DELETAR SC
/*
�������������������������������������������������������������������������������������������������������Ŀ
� Limpar o controle de alcadas anterior:                                                                �
���������������������������������������������������������������������������������������������������������*/
	_cExec := " DELETE FROM "+RetSqlName('SCR')
	_cExec += " WHERE CR_FILIAL = '"+xFilial('SCR')+"' "
	_cExec += " AND   CR_TIPO   = 'SC' "
	_cExec += " AND   CR_NUM    = '"+cA110Num+"' "
	_cExec += " AND   D_E_L_E_T_ = ' ' "
	
	TcSqlExec( _cExec )
	
	RestArea(_aAreaAnt)
	
	FWrite( nSC, "SC "+Trim(xFilial("SC1")+cA110Num)+" - Excluida!"+cEol )
	
	Fclose(nSC)
	
	Return
	
EndIf
/*
�������������������������������������������������������������������������������������������������������Ŀ
� Sergio em Jun/2010: De acordo com a OS 0344/10, nao gerar alcadas de houver pelo menos um item da SC  �
�                     ja possuir Pedido de Compra relacionado. A rotina ChkPCSC esta sendo utilizada    �
�                     para este objetivo.                                                               �
���������������������������������������������������������������������������������������������������������*/
If 'MATA110' $ FunName() .And. (Inclui .Or. Altera .Or. U_SeEhCopia()) .And. !U_ChkPCSC()
    
    If SC1->( DbSetOrder(1), DbSeek( xFilial('SC1')+cA110Num ) ) .And. SC1->C1_APROV = 'X'
    
		cTxtBlq := "Esta Solicita��o de Compra havia sido devolvida por Procurement. "
		cTxtBlq += "Deseja digitar a sua justificativa para esta atualiza��o? "
		
        If Aviso("SC J� Devolvida",cTxtBlq, {"&Nao Informar","INFORMAR"},3,"Devolvida Anteriormente",,"PCOLOCK") == 2
			U_DevolvSC()    
		EndIf
		
    EndIf
    
    cUpdSC1 := " UPDATE "+RetSqlName('SC1')
    cUpdSC1 += " SET C1_APROV = 'B' "
    cUpdSC1 += " WHERE C1_FILIAL  = '"+xFilial('SC1')+"' "
    cUpdSC1 += " AND   C1_NUM     = '"+cA110Num+"' "
    cUpdSC1 += " AND   D_E_L_E_T_ = ' ' "
    
    If TcSqlExec( cUpdSC1 ) # 0
		cTxtBlq := "Ocorreu um problema no momento da gravacao desta Solicita��o. "
		cTxtBlq += "Entre em contato com a area de Sistemas ERP informando a mensagem "
		cTxtBlq += "a seguir: "+cEol+cEol+TcSqlError()
		Aviso("Atualiza��o da SC",cTxtBlq,	{"&Fechar"},3,"Atualiza��o da SC",,"PCOLOCK")
    EndIf
    
    If "GEEK" $ Upper( GetComputerName() )
	    Return
    EndIf
	
	DbSelectArea('SC1')
	DbSetOrder(1)
	DbSeek(xFilial('SC1')+cA110Num)
/*
�������������������������������������������������������������������������������������������������������Ŀ
� Limpar o controle de alcadas anterior:                                                                �
���������������������������������������������������������������������������������������������������������*/
	_cExec := " DELETE FROM "+RetSqlName('SCR')
	_cExec += " WHERE CR_FILIAL = '"+xFilial('SCR')+"' "
	_cExec += " AND   CR_TIPO   = 'SC' "
	_cExec += " AND   CR_NUM    = '"+cA110Num+"' "
	_cExec += " AND   D_E_L_E_T_ = ' ' "
	
	TcSqlExec( _cExec )
	
	_aUsuar := telausr1()
///	SZI->( DbSetOrder(5) ) // ZI_NMUSER+ZI_FLGCOM
	SZI->( DbSetOrder(1) ) // ZI_USUARIO+ZI_CCUSTO
	If !SZI->( DbSeek( xFilial("SZI")+_aUsuar[1]+_aUsuar[2] ) )          // Fernando de O. Lima OS 2159/13

		Aviso("Inconsistencia","Nao foi escolhido nenhum CC aprovador para essa solicitacao usuario  ["+ca110SOL+"]", {'Ok'} )  // Fernando de O. Lima OS 2159/13
		FWrite( nSC, "Nao foi escolhido nenhum CC aprovador para essa solicitacao usuario  ["+ca110SOL+"]"+cEol )  				// Fernando de O. Lima OS 2159/13
		
///		Aviso("Inconsistencia","Solicitante nao autorizado no cadastro de Solicitantes X Centro de custos. ["+ca110SOL+"]", {'Ok'} )
///		FWrite( nSC, "SC Solicitante nao autorizado no cadastro de Solicitantes X Centro de custos. ["+ca110SOL+"]"+cEol )
	Else
		If !ZA6->( DbSeek( xFilial("ZA6")+SZI->ZI_CCUSTO ) )
			Aviso("Inconsistencia","Solicitante sem centro de custos X Aprovador de solicitacao de compras.", {'Ok'} )
			FWrite( nSC, "Solicitante sem centro de custos X Aprovador de solicitacao de compras."+cEol )
		Else
			DbSelectArea('SAK')
			If !DbSeek(xFilial('SAK')+ZA6->ZA6_CAPSC1)
				Aviso( 'Inconsistencia','O cadastro de Aprovadores x Solicitantes esta Incoerente.', {'Ok'} )
				FWrite( nSC, "O cadastro de Aprovadores x Solicitantes esta Incoerente."+cEol )
			Else
				
				If Ascan( _aAprov, ZA6->ZA6_CAPSC1 ) == 0
/*
�������������������������������������������������������������������������������������������������������Ŀ
� Sergio em Mai/2007: Evitar que o usuario logado solicitante faca parte da alcada:                     �
���������������������������������������������������������������������������������������������������������*/
					lTemqTSup := .f.
					lTemSup   := .f.
					/*
					����������������������������������������������������������������������������Ŀ
					� # Chamado 003801: Correcao da verificacao do aprovador x solicitante na    �
					�                   Solicitacao de Compras.                                  �
					������������������������������������������������������������������������������*/
					PswOrder(2) // Ordem de nome do usuario
					PswSeek( ca110SOL )
					
					If SAK->AK_USER == PswId() //.Or. SAK->AK_USER == __cUserId  OS 2264/14
						lTemqTSup := .t.
/*
�����������������������������������������������������������������������������������
��������������������Ŀ
� Verificar quem e o superior imediato:                                                                 �
���������������������������������������������������������������������������������������������������������*/
						lTemSup := !Empty( SAK->AK_APROSUP )
						If lTemSup
							SAK->( DbSeek( xFilial('SAK')+SAK->AK_APROSUP ) )
							lTemSup := .t.
						Else
							lTemSup := .f.
						EndIf
					EndIf
					
					If !lTemqTSup .Or. ( lTemqTSup .And. lTemSup )
						
						Aadd( _aAprov, ZA6->ZA6_CAPSC1 )
						
						FWrite( nSC, "Gravando o aprovador => "+UsrFullName(SAK->AK_USER)+cEol )
						DbSelectArea('SCR')
						Reclock("SCR",.T.)
						SCR->CR_FILIAL	:= xFilial("SCR")
						SCR->CR_NUM		:= cA110Num
						SCR->CR_TIPO	:= "SC"
						SCR->CR_NIVEL	:= StrZero(_nNivel,2)
						SCR->CR_USER	:= SAK->AK_USER
						SCR->CR_APROV	:= SAK->AK_COD
						SCR->CR_STATUS	:= _cStatus
						SCR->CR_TOTAL	:= 0
						SCR->CR_EMISSAO := dDataBase
						SCR->CR_X_TPLIB := 'A'
						SCR->CR_MOEDA	:= 1
						SCR->CR_TXMOEDA := 1
						MsUnlock()
						_cStatus := '01'
						_nNivel  ++
					EndIf
					
					
				EndIf
			EndIf
		EndIf
	EndIf
	
	cExec := " UPDATE "+RetSqlName('SC1')
	
	lUpSpot := .f.
/*
�������������������������������������������������������������������������������������������������������Ŀ
� Chamado 3239/09: Criada a variavel publica l_TemCtr no ponto de entrada MA110Bar para definir se ha   �
� contrato.                                                                                             �
���������������������������������������������������������������������������������������������������������*/
	If l_TemCtr
		cCompl  := ", C1_X_CAPEX = 'CONTRATO' "
		cCompl  += ", C1_XCONT = 'S' "
	Else	
		cCompl  := ", C1_X_CAPEX = 'SPOT' "
	EndIf
	
	If ZA8->( DbSetOrder(1), DbSeek( xFilial('SC1')+"SC"+cA110Num ) )
		cCompl := ", C1_X_CAPEX = 'CAPEX' "
	Else
		
		lUpSpot := .t.
		
	EndIf
	
	cExec := " UPDATE "+RetSqlName('SC1')
	
	If Len(_aAprov) == 0
		_cMensagem := "Nao foram encontrados aprovadores para esta Solicitacao de Compras."
		_cMensagem += "Entre em contato o responsavel."
		
		Aviso('Sem Aprovadores',_cMensagem,{'Ok'})
		cExec += " SET C1_APROV = 'B', C1_WF = ' ' "+cCompl
		FWrite( nSC, "Nao h� aprovadores para esta SC. "+cEol )
	Else
		cExec += " SET C1_APROV = 'B', C1_WF = ' ', C1_XAPROV = '"+SAK->AK_USER+"' "+cCompl
	EndIf

	cExec += " , C1_CCAPROV = '"+_aUsuar[2]+"' "	  // Fernando de O. Lima OS 2159/13
	cExec += " , C1_FILENT = CASE C1_FILENT WHEN '  ' THEN '"+cFilAnt+"' ELSE C1_FILENT END "
	cExec += " WHERE C1_FILIAL = '"+xFilial('SC1')+"' "
	cExec += " AND   C1_NUM    = '"+cA110Num+"' "
	cExec += " AND   C1_PEDIDO = '      ' "
	cExec += " AND   D_E_L_E_T_ = ' ' "
	
	TcSqlExec(cExec)

	If lUpSpot
		
		SC1->( DbSetOrder(1), DbSeek( xFilial("SC1")+cA110Num ) )
		
		While !SC1->( Eof() ) .And. SC1->( C1_FILIAL+C1_NUM ) == xFilial("SC1")+cA110Num
			
			If ( SB1->( DbSeek( xFilial('SB1')+SC1->C1_PRODUTO ) ) .And.;
				Dtos(SC1->C1_EMISSAO) >= Dtos(SB1->B1_XDTINEG) .And. Dtos(SB1->B1_XDTFNEG) >= Dtos(SC1->C1_EMISSAO) .And.;
				SB1->B1_XPRVNEG > 0 ) .Or. SB1->B1_X_INDRH > 0
				
				cExec := " UPDATE "+RetSqlName('SC1')+" SET C1_X_CAPEX = 'SPOT@' WHERE R_E_C_N_O_ = "+Str( SC1->(Recno()) )
				FWrite( nSC, "Gravando SPOT@ para o produto "+SC1->C1_PRODUTO+cEol )
				
				TcSqlExec( cExec )
				
			EndIf
			
			SC1->( DbSkip() )
			
		EndDo
		
	EndIf
	
	FWrite( nSC, "Gravando o update => "+cExec+cEol )
	
EndIf

Fclose( nSC )

RestArea( _aAreaAnt )

Return


#Include 'Protheus.ch'

/*������������������������������������������������������������������������������
��������������������������������������������������������������������������������
����������������������������������������������������������������������������Ŀ��
���Programa   � TelaUsr1 � Autor  � Fernando de O. Lima    � Data �19/11/2013���
����������������������������������������������������������������������������Ĵ��
���Descricao  � Desenvolvido para atender demanda da OS 2159/13              ���
���           �                                                              ���
�����������������������������������������������������������������������������ٱ�
��������������������������������������������������������������������������������
������������������������������������������������������������������������������*/
STATIC Function TelaUsr1()

Local _aRet 	:= {}
Private oDlg

Private _oSolic
Private _cSolic	:= Space(14) //(06)

Private _oNome
Private _cNome		:= Space(30)

Private _oCC
Private _cCC		:= Space(15)

Private _oCCDesc
Private _cCCDesc	:= Space(30)

Private _oUser
Private _cUser		:= Space(06)

DEFINE MSDIALOG oDlg TITLE "Selecao de Solicitante" FROM 178,181 TO 365,867 PIXEL

@ 020,055 MsGet _oSolic	Var _cSolic F3 "SZISCR" Size 060,009 COLOR CLR_BLACK Picture "@!" PIXEL OF oDlg Valid VlSol1() When .T.
@ 019,120 MsGet _oNome	Var _cNome 				Size 200,009 COLOR CLR_BLACK Picture "@!" PIXEL OF oDlg READONLY When .T.
@ 021,008 Say "Solicitante" 						Size 040,008 COLOR CLR_BLACK PIXEL OF oDlg

@ 033,055 MsGet _oCC 	Var _cCC 				Size 060,009 COLOR CLR_BLACK Picture "@!" PIXEL OF oDlg When .F.
@ 034,008 Say "Centro de Custo" 					Size 040,008 COLOR CLR_BLACK PIXEL OF oDlg

@ 033,120 MsGet _oCCDesc Var _cCCDesc 			Size 200,009 COLOR CLR_BLACK Picture "@!" PIXEL OF oDlg When .F.

@ 047,008 Say "Cod. Usuario" 						Size 040,008 COLOR CLR_BLACK PIXEL OF oDlg
@ 046,055 MsGet _oUser	Var _cUser 				Size 060,009 COLOR CLR_BLACK Picture "@!" PIXEL OF oDlg When .F.

ACTIVATE MSDIALOG oDlg ON INIT EnchoiceBar(oDlg,{|| IIF(  !Empty(_cUser),(_aRet := {_cUser,_cCC},oDlg:End()),""  )  },{|| U_VlOk1()},,) CENTERED Valid U_VldBox(_aRet)
    
Return _aRet


/*������������������������������������������������������������������������������
��������������������������������������������������������������������������������
����������������������������������������������������������������������������Ŀ��
���Programa   � ValSolic� Autor   � Fernando de O. Lima    � Data �19/11/2013���
����������������������������������������������������������������������������Ĵ��
���Descricao  �   Desenvolvido para atender demanda da OS 2159/13            ���
���           �                                                              ���
�����������������������������������������������������������������������������ٱ�
���Altera��o � Douglas David    �      21/03/14      �    OS 0887/14       	 ���
����������������������������������������������������������������������������ͼ��
��������������������������������������������������������������������������������
������������������������������������������������������������������������������*/
STATIC Function VlSol1()

Local lRet     := .T.
Local aArea    := GetArea()
Local aAreaSZI := SZI->(GetArea()) 

_aUser := {}

//SZI->( DbSetOrder(5) )  

//cUsu := Posicione("SZI", 5, xFilial("SZI")+_cSolic+"1","ZI_USUARIO")  // OS 2264/14 By Douglas David
//cCust:= Posicione("SZI", 5, xFilial("SZI")+_cSolic+"1","ZI_CCUSTO") 

  //	PswOrder(2) // Ordem de nome do usuario
		    	
   //	If PswSeek( _cSolic ) 
			
			aAdd(_aUser,{SZI->ZI_USUARIO,SZI->ZI_CCUSTO, _cSolic })
				
		    				
				_cNome 	 := UsrFullName(SZI->ZI_USUARIO)
				_cCC	 := SZI->ZI_CCUSTO                                               	
				_cCCDesc := POSICIONE("CTT",1,xFILIAL("CTT")+SZI->ZI_CCUSTO,"CTT_DESC01") 
				_cUser	 := SZI->ZI_USUARIO
						
				
		_oNome	 :Refresh()
		_oCC	 :Refresh()
		_oCCDesc :Refresh()
		_oUser	 :Refresh()
//	Else   	       	
   	     
  // 		Aviso("USUARIO INVALIDO","O usuario digitado foi desligado ou est� bloqueado no cadastro de usu�rios. Selecione novamente o usu�rio.",;
//		{"&Fechar"},3,"Usu�rio",,;
 //		"PCOLOCK")
				
 //		lRet := .f.        
		
 //    Endif
////Else
	
///		Aviso("USUARIO INVALIDO","O usuario digitado � inv�lido. Selecione novamente o usu�rio.",;
///		{"&Fechar"},3,"Usu�rio",,;
///		"PCOLOCK")
	
///		lRet := .f.
	
///EndIf

SZI->(RestArea(aAreaSZI))
RestArea(aArea)

Return lRet

/*������������������������������������������������������������������������������
��������������������������������������������������������������������������������
����������������������������������������������������������������������������Ŀ��
���Programa   � VlOk1   � Autor   � Fabio Jadao Caires     � Data �21/11/2006���
����������������������������������������������������������������������������Ĵ��
���Descricao  �                                                              ���
���           �                                                              ���
�����������������������������������������������������������������������������ٱ�
��������������������������������������������������������������������������������
������������������������������������������������������������������������������*/
User Function VlOk1()

MsgAlert("Voce deve informar um solicitante!")

Return .F.



