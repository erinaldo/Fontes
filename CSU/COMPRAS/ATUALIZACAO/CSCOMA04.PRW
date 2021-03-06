#include 'protheus.ch'

/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������Ŀ��
���Fun��o    � CSCOMA04 � Autor � Leonardo Soncin       � Data � 13.11.06 ���
�������������������������������������������������������������������������Ĵ��
���Descri��o � Programa de atualiza�ao do cadastro de Usuarios X Produtos ���
�������������������������������������������������������������������������Ĵ��
���Sintaxe   � CSCOMA04()                                                 ���
�������������������������������������������������������������������������Ĵ��
���Parametros� Nenhum                                                     ���
�������������������������������������������������������������������������Ĵ��
��� Uso      � SIGACOM                                                    ���
��������������������������������������������������������������������������ٱ�
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/
User Function CSCOMA04()

Local lUser		:= .T.
Local aUser		:= {}
Local cUser		:= ''
Local aCodUser	:= {}
Local nUser		:= 0
Local cCodUser	:= ''
Local cCodGroup	:= ''
Local aGroup	:= {''}
Local aCodGroup := {}
Local nGroup	:= 0
Local cGroup	:= ''
Local aArea		:= GetArea()
Local aAllUser	:= {}
Local aAllGroup	:= {}
Local aAreaSZJ	:= SZJ->(GetArea())
Local oUser,oGroup,oDlg,oButton1,oButton2,oButton3,oButton4,oButton5,oButton6

PRIVATE cCadastro	:= OemToAnsi('Amarra��o Usu�rios X Produtos')
PRIVATE bListRefresh:= {|| A085LRefresh(@oUser,@oGroup,@aUser,aAllUser,@aGroup,aAllGroup,@aCodUser,@aCodGroup) }
PRIVATE aRotina 	:= menudef()
//{	{ OemToAnsi('Pesquisar'),'AxPesqui', 0 , 1},;
//{ OemToAnsi('&Visualizar'),'A085Visual', 0 , 2},;
//{ OemToAnsi('&Incluir'),'A085Inclui', 0 , 3},;
//{ OemToAnsi('&Alterar'),'A085Altera', 0 , 4},;
//{ OemToAnsi('&Excluir'),'A085Deleta', 0 , 5,3} }

//����������������������������������������������������������������������Ŀ
//�  Monta os Arrays estaticos contendo todos os usuarios do sistema.    �
//������������������������������������������������������������������������
Processa({||A085AllUser(@aAllUser,@aAllGroup)},,"Verificando Usuarios...")
A085LRefresh(,,@aUser,aAllUser,@aGroup,aAllGroup,@aCodUser,@aCodGroup)
cUser	:= 0
cGroup	:= 0

DEFINE MSDIALOG oDlg TITLE OemToAnsi('Amarra��o Usu�rios X Produtos') FROM 0,0 TO 237,417 OF oMainWnd PIXEL

@01,05 SAY 'Usuario' PIXEL of oDlg
@10,05 LISTBOX oUser VAR cUser ITEMS aUser PIXEL SIZE 150,40 ON DBLCLICK {|| If(A085Seek(lUser,aCodUser,aCodGroup,nUser,nGroup),((A085Processa(lUser,SZJ->ZJ_USER,SZJ->ZJ_GRUSER,SZJ->(RecNo()),2)),Eval(bListRefresh)),Nil)}
oUser:bChange := {|| cGroup := 0,nUser:=oUser:nAT,oGroup:Refresh(),lUser := .T.}
oUser:bGotFocus:= {||lUser := .T.}


@55,05 SAY 'Grupos de Usuarios' PIXEL of oDlg
@64,05 LISTBOX oGroup VAR cGroup ITEMS aGroup PIXEL SIZE 150,46 ON DBLCLICK {||If(A085Seek(lUser,aCodUser,aCodGroup,nUser,nGroup),((A085Processa(lUser,SZJ->ZJ_USER,SZJ->ZJ_GRUSER,SZJ->(RecNo()),2)),Eval(bListRefresh)),Nil)}
oGroup:bChange:= {|| cUser := 0,nGroup:=oGroup:nAT,oUser:Refresh(),lUser := .F.}
oGroup:bGotFocus:= {||lUser := .F.}

@10,160 BUTTON oButton1 PROMPT 'Localizar' SIZE 44, 11 OF oDlg PIXEL ;
ACTION ((UserPesqui(,@oUser:nAT,@aUser,@oUser,'Usuario',oDlg)))

@25,160 BUTTON oButton1 PROMPT OemToAnsi('&Incluir') SIZE 44, 11 OF oDlg PIXEL ;
ACTION (If(A085GetUser(lUser,aAllUser,aAllGroup,@cCodUser,@cCodGroup,aCodUser,aCodGroup),(A085Processa(lUser,cCodUser,cCodGroup,SZJ->(RecNo()),3)),Nil ),(Eval(bListRefresh)))

@40,160 BUTTON oButton2 PROMPT OemToAnsi('&Visualizar') SIZE 44, 11 OF oDlg PIXEL ;
ACTION If(A085Seek(lUser,aCodUser,aCodGroup,nUser,nGroup),((A085Processa(lUser,SZJ->ZJ_USER,SZJ->ZJ_GRUSER,SZJ->(RecNo()),2)),Eval(bListRefresh)),Nil)

@55,160 BUTTON oButton3 PROMPT OemToAnsi('&Alterar') SIZE 44, 11 OF oDlg PIXEL ;
ACTION If(A085Seek(lUser,aCodUser,aCodGroup,nUser,nGroup),((A085Processa(lUser,SZJ->ZJ_USER,SZJ->ZJ_GRUSER,SZJ->(RecNo()),4)),Eval(bListRefresh)),Nil)

@70,160 BUTTON oButton4 PROMPT OemToAnsi('&Excluir') SIZE 44, 11 OF oDlg PIXEL ;
ACTION If(A085Seek(lUser,aCodUser,aCodGroup,nUser,nGroup),((A085Processa(lUser,SZJ->ZJ_USER,SZJ->ZJ_GRUSER,SZJ->(RecNo()),5)),Eval(bListRefresh)),Nil)

@85,160 BUTTON oButton5 PROMPT OemToAnsi('&Sair') SIZE 44, 11 OF oDlg PIXEL ;
ACTION oDlg:End()

@100,160 BUTTON oButton6 PROMPT OemToAnsi('&Usuarios do Grupo') SIZE 44, 11 OF oDlg PIXEL ;
ACTION If(A085Seek(lUser,aCodUser,aCodGroup,nUser,nGroup),(xUsrGrp(lUser,SZJ->ZJ_GRUSER,aAllUser),Eval(bListRefresh)),Nil)


ACTIVATE DIALOG oDlg CENTERED

RestArea(aAreaSZJ)
RestArea(aArea)

Return .T.

/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������Ŀ��
���Fun��o    �A085LRefresh� Autor � Edson Maricate      � Data � 30.09.98 ���
�������������������������������������������������������������������������Ĵ��
���Descri��o � Executa o refresh na lista de usuarios x produtos          ���
�������������������������������������������������������������������������Ĵ��
���Uso       � MATA085                                                    ���
��������������������������������������������������������������������������ٱ�
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/
Static Function A085LRefresh(oUser,oGroup,aUser,aAllUser,aGroup,aAllGroup,aCodUser,aCodGroup)
Local aArea		:= GetArea()
Local aAreaSZJ:= SZJ->(GetArea())
Local nX := 0

aGroup 		:= {}
aCodGroup	:= {}
aUser		:= {}
aCodUser	:= {}

//��������������������������������������������������������������Ŀ
//� Verifica a existencia de uma regra para TODOS os Usuarios.   �
//����������������������������������������������������������������
dbSelectArea('SZJ')
dbSetOrder(3)
If dbSeek(xFilial()+'************')
	aAdd(aGroup,OemToAnsi('Todos Usuarios'))
	aAdd(aCodGroup,'************')
EndIf


For nx	:= 1 to Len(aAllUser)
	dbSelectArea('SZJ')
	dbSetOrder(2)
	If dbSeek(xFilial()+aAllUser[nx][1][1])
		aAdd(aUser,aAllUser[nx][1][4])
		aAdd(aCodUser,'******'+aAllUser[nx][1][1])
	EndIf
Next
For nx	:= 1 to Len(aAllGroup)
	dbSelectArea('SZJ')
	dbSetOrder(1)
	If dbSeek(xFilial()+aAllGroup[nx][1][1])
		aAdd(aGroup,aAllGroup[nx][1][2])
		aAdd(aCodGroup,aAllGroup[nx][1][1]+'******')
	EndIf
Next

If oUser != Nil
	oUser:SetItems(aUser)
EndIf
If oGroup != Nil
	oGroup:SetItems(aGroup)
EndIf

RestArea(aAreaSZJ)
RestArea(aArea)
Return .T.

/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������Ŀ��
���Fun��o    �A085GetUser� Autor � Edson Maricate       � Data � 30.09.98 ���
�������������������������������������������������������������������������Ĵ��
���Descri��o �Cria uma tela com os Usuarios/Grupos Disponiveis.           ���
�������������������������������������������������������������������������Ĵ��
���Uso       �MATA085                                                     ���
��������������������������������������������������������������������������ٱ�
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/
Static Function A085GetUser(lUser,aAllUser,aAllGroup,cUser,cGroup,aCodUser,aCodGroup)

Local oDlg
Local cTitle	:= If(lUser,OemToAnsi('Usuarios do Sistema'),OemToAnsi('Grupos do Sistema'))
Local cPesq		:= SPACE(50)
Local aList		:= {}
Local cList		:= 0
Local oBold
Local oList
Local aGroup	:= {}
Local aCodigo	:= {}
Local cRetorno	:= ''
Local nOpc		:= 0
Local lRet		:= .F.
Local nTodos,cSeek
Local nx

// Aki
If lUser
    // OS 0258/17 - By Douglas David
	aEval(aAllUser,{|x| 	If(aScan(aCodUser,"******"+x[1][1])==0 .And. (x[1][17]) == .F.,(aAdd(aList,x[1][4]),aAdd(aCodigo,{x[1][4],x[1][1]})),Nil)})
	//aEval(aAllUser,{|x| 	If(aScan(aCodUser,"******"+x[1][1])==0,(aAdd(aList,x[1][4]),aAdd(aCodigo,{x[1][4],x[1][1]})),Nil)})
Else
	Iif(aScan(aCodGroup,'************')==0,(aAdd(aList,OemToAnsi('Todos Usuarios')),aAdd(aCodigo,{OemToAnsi('Todos Usuarios'),'******'})),Nil)
	aEval(aAllGroup,{|x| If(aScan(aCodGroup,x[1][1]+"******")==0,(aAdd(aList,x[1][2]),aAdd(aCodigo,{x[1][2],x[1][1]})),Nil)})
EndIf

aSort(aList)

DEFINE FONT oBold NAME "Arial" SIZE 0, -12 BOLD
DEFINE MSDIALOG oDlg FROM 114,180 TO 335,600 TITLE cTitle Of oMainWnd PIXEL

@ 0, 0 BITMAP oBmp RESNAME "PROJETOAP" oF oDlg SIZE 90,255 NOBORDER WHEN .F. PIXEL
@ 12,60 TO 14,400 Label '' Of oDlg PIXEL
@ 4  ,66   SAY If(lUser,OemToAnsi('Selecione o Usuario:'),OemToAnsi('Selecione o Grupo:')) Of oDlg PIXEL SIZE 120,9 FONT oBold
@ 77, 70 SAY OemToAnsi('Pesquisar') of oDlg PIXEL SIZE 30,9
@ 18,70 LISTBOX oList VAR cList ITEMS aList PIXEL SIZE 127,56 OF oDlg ON DBLCLICK (If(!Empty(cList),(nOpc:=1,oDlg:End()),))
oList:bChange := {||nList := oList:nAT}

@ 75, 96 MSGET cPesq VALID If(aScan(aList,{|x| x=Alltrim(cPesq)})>0,;
((oList:nAT :=aScan(aList,{|x| x=Alltrim(cPesq)})),(oList:Refresh())),Nil)  of oDlg PIXEL SIZE 100,9

@ 92,155 BUTTON '&Confirma >> ' SIZE 40 ,10  FONT oDlg:oFont ACTION If(!Empty(cList),(nOpc:=1,oDlg:End()),)  OF oDlg PIXEL
@ 92,110 BUTTON '&Sair' SIZE 40,10  FONT oDlg:oFont ACTION (oDlg:End())  OF oDlg PIXEL


ACTIVATE MSDIALOG oDlg CENTERED

If nOpc == 1
	cCodigo := aCodigo[aScan(aCodigo,{|x|x[1]==aList[nList]})][2]
	If lUser
		dbSelectArea('SZJ')
		dbSetOrder(2)
		If dbSeek(xFilial()+cCodigo)
			HELP('   ',1,'A085USER')
		Else
			cUser := cCodigo
			cGroup:= '******'
			lRet   := .T.
		EndIf
	Else
		dbSelectArea('SZJ')
		dbSetOrder(3)
		If dbSeek(xFilial()+cCodigo+'******')
			HELP('   ',1,'A085USER')
		Else
			cGroup := cCodigo
			cUser  := '******'
			lRet   := .T.
		EndIf
	EndIf
EndIf

Return(lRet)

/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������Ŀ��
���Fun��o    �A085AllUser� Autor � Edson Maricate       � Data � 30.09.98 ���
�������������������������������������������������������������������������Ĵ��
���Descri��o �Monta o array contendo tosod usuarios do sistema            ���
�������������������������������������������������������������������������Ĵ��
���Uso       �MATA085                                                     ���
��������������������������������������������������������������������������ٱ�
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/
Static Function A085AllUser(aAllUser,aAllGroup)

ProcRegua(4)
IncProc()
IncProc()
aAllUser := AllUsers()
IncProc()
IncProc()
aAllGroup := AllGroups()

Return

/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������Ŀ��
���Fun��o    �A085Seek� Autor � Edson Maricate          � Data � 30.09.98 ���
�������������������������������������������������������������������������Ĵ��
���Descri��o �Posiciona o arquivo no usuario/grupo selecionado            ���
�������������������������������������������������������������������������Ĵ��
���Uso       �MATA085                                                     ���
��������������������������������������������������������������������������ٱ�
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/
Static Function A085Seek(lUser,aCodUser,aCodGroup,nUser,nGroup)
Local lSeek	:= .F.
Local cSeek	:= ''

If nUser+nGroup > 0
	If lUser
		cSeek := aCodUser[nUser]
	Else
		cSeek := aCodGroup[nGroup]
	EndIf
	dbSelectArea('SZJ')
	dbSetOrder(3)
	lSeek := dbSeek(xFilial()+cSeek)
Else
	lSeek := .F.
EndIf

Return lSeek


/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������Ŀ��
���Fun��o    �A085Processa� Autor � Edson Maricate      � Data � 30.09.98 ���
�������������������������������������������������������������������������Ĵ��
���Descri��o �Executa o processamento de acordo com as opcoes             ���
�������������������������������������������������������������������������Ĵ��
���Uso       �MATA085                                                     ���
��������������������������������������������������������������������������ٱ�
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/
Static Function A085Processa(lUser,cCodUser,cCodGroup,nRecno,nOpcx)
Local l085Inclui	:= .F.
Local l085Altera	:= .F.
Local l085Exclui	:= .F.
Local l085Visual	:= .F.
Local lContinua		:= .T.
Local aRecSZJ		:= {}
Local cOperacao		:= aRotina[nOpcx][1]
Local nOpca		:= 0
Local cGetName	:= If(!lUser,GrpRetName(cCodGroup),UsrRetName(cCodUser))
Local oBold
Local nX := 0
Local nY := 0
Private aCols	:= {}
Private aHeader	:= {}
Private cUser	:= cCodUser
Private cGrUser	:= cCodGroup

Do Case
	Case nOpcx == 2
		l085Visual := 	.T.
	Case nOpcx == 3
		l085Inclui := .T.
	Case nOpcx == 4
		l085Altera := .T.
	Case nOpcx == 5
		l085Exclui := .T.
		l085Visual := .T.
EndCase

//�����������������������������������������������Ŀ
//� Monta o aHeader                               �
//�������������������������������������������������
dbSelectArea('SX3')
dbSetOrder(1)
dbSeek('SZJ')
While !EOF() .And. X3_ARQUIVO == 'SZJ'
	IF 	X3USO(X3_USADO) .And. cNivel >= X3_NIVEL .And.;
		!(Trim(X3_CAMPO)$'ZJ_GRUSER/ZJ_USER')
		aADD(aHeader,{	TRIM(X3Titulo()),X3_CAMPO,X3_PICTURE,X3_TAMANHO,X3_DECIMAL,;
		X3_VALID,X3_USADO,X3_TIPO,X3_ARQUIVO,X3_CONTEXT} )
	Endif
	dbSkip()
End

If l085Inclui
	//��������������������������������������������������������������Ŀ
	//� Faz a montagem de uma linha em branco no aCols.              �
	//����������������������������������������������������������������
	aadd(aCols,Array(Len(aHeader)+1))
	For ny := 1 to Len(aHeader)
		If Trim(aHeader[ny][2]) == 'ZJ_ITEM'
			aCols[1][ny] 	:= '01'
		Else
			aCols[1][ny] := CriaVar(aHeader[ny][2])
		EndIf
		aCols[1][Len(aHeader)+1] := .F.
	Next ny
Else
	dbSelectArea('SZJ')
	dbSetOrder(3)
	dbSeek(xFilial()+cGrUser+cUser)
	While !Eof() .And. ZJ_FILIAL+ZJ_GRUSER+ZJ_USER == xFilial()+cGrUser+cUser .And. lContinua
		//��������������������������������������������������������Ŀ
		//� Trava os registros do SZJ - Alteracao e Exclusao       �
		//����������������������������������������������������������
		If l085Altera .Or. l085Exclui
			If !SoftLock('SZJ')
				lContinua := .F.
			Else
				aADD(aRecSZJ,RecNo())
			Endif
		EndIf
		aADD(aCols,Array(Len(aHeader)+1))
		For nx := 1 To Len(aHeader)
			If aHeader[nx][10] != 'V'
				aCols[Len(aCols)][nx] := FieldGet(FieldPos(aHeader[nx][2]))
			EndIf
		Next nx
		aCols[Len(aCols)][Len(aHeader)+1] := .F.
		dbSelectArea('SZJ')
		dbSkip()
	EndDo
EndIf

If lContinua
	DEFINE FONT oBold NAME "Arial" SIZE 0, -12 BOLD
	DEFINE MSDIALOG oDlg TITLE "Propriedades do Usu�rio "  +If(lUser," - Usuario"," - Grupo de Usuarios")+cOperacao From 9,0 To 30,80
	@ 0, 0 BITMAP oBmp RESNAME "PROJETOAP" oF oDlg SIZE 90,255 NOBORDER WHEN .F. PIXEL
	@ 17,50 TO 19,400 Label '' Of oDlg PIXEL
	@ 08,55  SAY cGetName of oDlg PIXEL FONT oBold SIZE 120,10
	oGet := MSGetDados():New(26,50,140,315,nOpcx,'u_A085LinOK','u_A085TudOK','+ZJ_ITEM',.T.,,,,10000)
	If l085Altera .Or. l085Exclui .Or. l085Inclui
		@ 145,220 BUTTON '<< Ca&ncelar' SIZE 40,10  FONT oDlg:oFont ACTION (oDlg:End())  OF oDlg PIXEL
		@ 145,265 BUTTON '&Confirma >> '  SIZE 40 ,10  FONT oDlg:oFont ACTION (If(oGet:TudoOk(),(nOpcA:=1,oDlg:End()),Nil)) OF oDlg PIXEL
	Else
		@ 145,265 BUTTON '&Fechar'	SIZE 40 ,10  FONT oDlg:oFont ACTION (oDlg:End()) OF oDlg PIXEL
	EndIf
	
	ACTIVATE MSDIALOG oDlg CENTERED
EndIf

If nOpcA == 1 .And. (l085Altera .Or. l085Exclui .Or. l085Inclui)
	Begin Transaction
	u_A085Grava(l085Exclui,aRecSZJ)
	EvalTrigger()
	End Transaction
Endif

//��������������������������������������������������������Ŀ
//� Destrava os registros na alteracao e exclusao          �
//����������������������������������������������������������
If l085Altera .Or. l085Exclui
	MsUnlockAll()
EndIf

Return .T.

/*
�����������������������������������������������������������������������������
�������������������������������������������������������������������������Ŀ��
���Fun��o    � A085Prod � Autor � Edson Maricate        � Data � 30.09.98 ���
�������������������������������������������������������������������������Ĵ��
���Descri��o � Validacao do codigo do produto                             ���
�������������������������������������������������������������������������Ĵ��
��� Uso      � MATA085, GetDados                                          ���
��������������������������������������������������������������������������ٱ�
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/
User Function A085Prod()
Local lRet	:= .T.
Local nX    := 0
Local cVar	:= &(ReadVar())
Local nPosGrupo	:=  ASCAN(aHeader,{|x|AllTrim(x[2])== 'ZJ_GRUPO'})
Local nPosProd	:=  ASCAN(aHeader,{|x|Alltrim(x[2])== 'ZJ_PRODUTO'})

If !Empty(cVar) .And. AllTrim(cVar) != '*'
	dbSelectArea("SB1")
	dbSetOrder(1)
	If !dbSeek(xFilial()+cVar)
		HELP(" ",1,"REGNOIS")
		lRet := .F.
	EndIf
	
	//���������������������������������������Ŀ
	//� Verifica se o Registro esta Bloqueado.�
	//�����������������������������������������
	If lRet .And. !RegistroOk("SB1")
		lRet := .F.
	EndIf
	
	If lRet
		For nx := 1 to Len(aCols)
			If !aCols[nx][Len(aHeader)+1].And.nx!=n
				If aCols[nx][nPosProd]==cVar
					Aviso("O produto informado ja foi cadastrado anteriormente. Verifique o codigo informado.","Erro!",{'Voltar'})
					lRet := .F.
				Endif
			EndIf
		Next
	EndIf
	
EndIf

Return lRet

/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������Ŀ��
���Fun��o    �A085Grava� Autor  � Edson Maricate        � Data �          ���
�������������������������������������������������������������������������Ĵ��
���Descri��o � Executa a gravacao do cadastro de usuarios x produtos      ���
�������������������������������������������������������������������������Ĵ��
���Sintaxe e � A085Grava(ExpL1,ExpA2)                                     ���
�������������������������������������������������������������������������Ĵ��
���Parametros� ExpL1 = Flag de Exclusao                                   ���
���          � ExpN1 = Array contendo os registros Alterados/Excluidos    ���
�������������������������������������������������������������������������Ĵ��
��� Uso      � MATA085                                                    ���
��������������������������������������������������������������������������ٱ�
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/
User Function A085Grava(lDeleta,aRecSZJ)
Local nx, nY  := 0
Local lAltera := !Empty(aRecSZJ)

dbSelectArea("SZJ")

If !lDeleta
	For nx := 1 to Len(aCols)
		//����������������������������������������������������������Ŀ
		//� Verifica se esta deletado                                �
		//������������������������������������������������������������
		If !aCols[nx][Len(aCols[nx])]
			If lAltera .And. nx <= Len(aRecSZJ)
				dbGoto(aRecSZJ[nx])
				RecLock('SZJ',.F.)
			Else
				RecLock('SZJ',.T.)
			EndIf
			SZJ->ZJ_FILIAL	:= xFilial("SZJ")
			SZJ->ZJ_USER	:= cUser
			SZJ->ZJ_GRUSER	:= cGrUser
			//����������������������������������������������������������Ŀ
			//� Atualiza os dados contidos na GetDados                   �
			//������������������������������������������������������������
			For ny := 1 to Len(aHeader)
				If aHeader[ny][10] # 'V'
					SZJ->(FieldPut(FieldPos(Trim(aHeader[ny][2])),aCols[nx][ny]))
				Endif
			Next
			MsUnlock()
		Else
			If lAltera .And. nx <= Len(aRecSZJ)
				//����������������������������������������������������������Ŀ
				//� Exclui o registro do SZJ                                 �
				//������������������������������������������������������������
				dbSelectArea('SZJ')
				dbGoto(aRecSZJ[nx])
				RecLock('SZJ',.F.,.T.)
				dbDelete()
				MsUnlock()
			EndIf
		EndIf
	Next
Else
	For nx := 1 to Len(aCols)
		//����������������������������������������������������������Ŀ
		//� Exclui o registro do SZJ                                 �
		//������������������������������������������������������������
		dbSelectArea('SZJ')
		dbGoto(aRecSZJ[nx])
		RecLock('SZJ',.F.,.T.)
		dbDelete()
		MsUnlock()
	Next
EndIf


Return .T.
/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������Ŀ��
���Fun��o    �A085LinOk� Rev   � Edson Maricate         � Data �31.10.2000���
�������������������������������������������������������������������������Ĵ��
���Descri��o � Critica se a linha digitada esta' Ok                       ���
�������������������������������������������������������������������������Ĵ��
���Parametros� ExpC1 = Objeto a ser verificado.                           ���
�������������������������������������������������������������������������Ĵ��
��� Uso      � MATA085                                                    ���
��������������������������������������������������������������������������ٱ�
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/
User Function A085LinOk()

Local nx
Local lRet		:= .T.
Local nPosProd	:=  ASCAN(aHeader,{|x|Alltrim(x[2])== 'ZJ_PRODUTO'})

If !aCols[n][Len(aHeader)+1]
	If Empty(aCols[n][nPosProd])
		Aviso("Alguns campos de preenchimento obrigatorio estao em branco. Verifique o preenchimento correto do cadastro.","Erro!",{'Voltar'})
		lRet := .F.
	Endif
	For nx := 1 to Len(aCols)
		If !aCols[nx][Len(aHeader)+1].And.nx!=n
			If aCols[nx][nPosProd]==aCols[n][nPosProd]
				Aviso("O produto informado ja foi cadastrado anteriormente. Verifique o codigo informado.","Erro",{'Voltar'})
				lRet := .F.
			Endif
		EndIf
	Next
EndIf

Return lRet

/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������Ŀ��
���Fun��o    �A085TudOk � Autor � Edson Maricate        � Data �          ���
�������������������������������������������������������������������������Ĵ��
���Descri��o � Critica se a nota toda esta' Ok                            ���
�������������������������������������������������������������������������Ĵ��
���Parametros� ExpC1 = Objeto a ser verificado.                           ���
�������������������������������������������������������������������������Ĵ��
��� Uso      � MatA085                                                    ���
��������������������������������������������������������������������������ٱ�
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/
User Function A085TudOk(o)
Local nx,lRet := .T.,lDeleted := .F., cSavOrd := IndexOrd()
Local nPosProd :=  ASCAN(aHeader,{|x|x[2] = 'ZJ_PRODUTO'})

For nx := 1 to Len(aCols)
	If ValType(aCols[nx,Len(aCols[nx])]) == 'L'  /// Verifico se posso Deletar
		lDeleted := aCols[nx,Len(aCols[nx])]      /// Se esta Deletado
	EndIf
	If !lDeleted
		If Empty(aCols[nx][nPosProd]) .And. lRet
			Aviso("Alguns campos de preenchimento obrigatorio estao em branco. Verifique o preenchimento correto do cadastro.","Erro!",{'Voltar'})
			lRet := .F.
		Endif
	EndIf
Next


dbSetOrder(cSavOrd)
Return lRet

/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������Ŀ��
���Fun��o    �A085TudOk � Autor � Edson Maricate        � Data �          ���
�������������������������������������������������������������������������Ĵ��
���Descri��o � Critica se a nota toda esta' Ok                            ���
�������������������������������������������������������������������������Ĵ��
���Parametros� ExpC1 = Objeto a ser verificado.                           ���
�������������������������������������������������������������������������Ĵ��
��� Uso      � MatA085                                                    ���
��������������������������������������������������������������������������ٱ�
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/
Static Function xUsrGrp(lUser,cGrupo,aAlluser)

Local oDlg
Local cTitle	:= OemToAnsi('Usuarios do Grupo')
Local cPesq		:= SPACE(50)
Local aList		:= {}
Local cList		:= 0
Local oBold
Local oList
Local aGroup	:= {}
Local aCodigo	:= {}
Local cRetorno	:= ''
Local nOpc		:= 0
Local lRet		:= .F.
Local nx

// Aki
If lUser
	Return
Else
	 
	For nX := 1 to Len(aAllUser)
		For nY := 1 to Len (aAlluser[nX][1][10])
			If aAlluser[nX][1][10][nY] == cGrupo  
				aAdd(aList,aAllUser[nX][1][4])						
			Endif
		Next nY	
	Next nX 
		
	DEFINE FONT oBold NAME "Arial" SIZE 0, -12 BOLD
	DEFINE MSDIALOG oDlg FROM 114,180 TO 335,600 TITLE cTitle Of oMainWnd PIXEL
	
	@ 0, 0 BITMAP oBmp RESNAME "PROJETOAP" oF oDlg SIZE 90,255 NOBORDER WHEN .F. PIXEL
	@ 12,60 TO 14,400 Label '' Of oDlg PIXEL
	@ 4  ,66   SAY OemToAnsi('Nome dos Usu�rios:') Of oDlg PIXEL SIZE 120,9 FONT oBold
	@ 77, 70 SAY OemToAnsi('Pesquisar') of oDlg PIXEL SIZE 30,9
	@ 18,70 LISTBOX oList VAR cList ITEMS aList PIXEL SIZE 127,56 OF oDlg
	oList:bChange := {||nList := oList:nAT}
	
	@ 75, 96 MSGET cPesq VALID If(aScan(aList,{|x| x=Alltrim(cPesq)})>0,;
	((oList:nAT :=aScan(aList,{|x| x=Alltrim(cPesq)})),(oList:Refresh())),Nil)  of oDlg PIXEL SIZE 100,9
	
	//	@ 92,155 BUTTON '&Confirma >> ' SIZE 40 ,10  FONT oDlg:oFont ACTION If(!Empty(cList),(nOpc:=1,oDlg:End()),)  OF oDlg PIXEL
	@ 92,110 BUTTON '&Sair' SIZE 40,10  FONT oDlg:oFont ACTION (oDlg:End())  OF oDlg PIXEL
	
	
	ACTIVATE MSDIALOG oDlg CENTERED
	
EndIf

Return .T.


/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  � MenuDEF  � Autor �Eduardo de Souza    � Data �12/Jan/2007  ���
�������������������������������������������������������������������������͹��
���Descricao � Implementa menu funcional                                  ���
�������������������������������������������������������������������������͹��
���Uso       � Menus                                                      ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/
//��������������������������������������������������������������Ŀ
//� Define Array contendo as Rotinas a executar do programa      �
//� ----------- Elementos contidos por dimensao ------------     �
//� 1. Nome a aparecer no cabecalho                              �
//� 2. Nome da Rotina associada                                  �
//� 3. Usado pela rotina                                         �
//� 4. Tipo de Transa��o a ser efetuada                          �
//�    1 - Pesquisa e Posiciona em um Banco de Dados             �
//�    2 - Simplesmente Mostra os Campos                         �
//�    3 - Inclui registros no Bancos de Dados                   �
//�    4 - Altera o registro corrente                            �
//�    5 - Remove o registro corrente do Banco de Dados          �
//�    3 - Duplica o registro corrente do Banco de Dados         �
//����������������������������������������������������������������
Static Function MenuDef()
Local aRotina 	:= {	{ OemToAnsi('Pesquisar'),'AxPesqui', 0 , 1},;
						{ OemToAnsi('&Visualizar'),'A085Visual', 0 , 2},;
						{ OemToAnsi('&Incluir'),'A085Inclui', 0 , 3},;
						{ OemToAnsi('&Alterar'),'A085Altera', 0 , 4},;
						{ OemToAnsi('&Excluir'),'A085Deleta', 0 , 5} }
Return aRotina
