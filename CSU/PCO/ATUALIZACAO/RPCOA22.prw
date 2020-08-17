/*
���������������������������������������������������������������������������������������������
���������������������������������������������������������������������������������������������
�����������������������������������������������������������������������������������������ͻ��
��� Programa    � RPCOA22  � Efetua manuten��o da amarracao CO X CC                       ���
�����������������������������������������������������������������������������������������͹��
��� Autor       � 20.12.06 � Rodney U. Mignanelli                                         ���
�����������������������������������������������������������������������������������������͹��
��� Produ��o    � ??.??.?? � Ignorado                                                     ���
�����������������������������������������������������������������������������������������͹��
��� Par�metros  � ExpC1: c�digo da tabela                                                 ���
�����������������������������������������������������������������������������������������͹��
��� Retorno     � Nil                                                                     ���
�����������������������������������������������������������������������������������������͹��
��� Observa��es �                                                                         ���
���             �                                                                         ���
�����������������������������������������������������������������������������������������͹��
��� Altera��es  � 99.99.99 - Consultor - Descri��o da altera��o                           ���
���             �                                                                         ���
�����������������������������������������������������������������������������������������ͼ��
���������������������������������������������������������������������������������������������
���������������������������������������������������������������������������������������������
*/
User Function RPCOA22()
Local aTabelas := {}
Local oDlgTabe

Private NOPCX,NUSADO,AHEADER,ACOLS,ARECNO
Private _CCODFIL,_CCHAVE,_CDESCRI,NQ,_NITEM,NLINGETD
Private CTITULO,AC,AR,ACGD,CLINHAOK,CTUDOOK
Private LRETMOD2,N

//���������������������������������Ŀ
//� Opcao de acesso para o Modelo 2 �
//�����������������������������������
// 3,4 Permitem alterar getdados e incluir linhas
// 6 So permite alterar getdados e nao incluir linhas
// Qualquer outro numero so visualiza
nOpcx    := 3
nUsado   := 0
aHeader  := {}
aCols    := {}
aRecNo   := {}
_cTabela := "ZU6"  // cTabela // Defina aqui a Tabela para edicao

//�����������������������������Ŀ
//� Posiciona a filial corrente �
//�������������������������������
_cCodFil := xFilial("ZU6")

//������������������Ŀ
//� Montando aHeader �
//��������������������
dbSelectArea("SX3")
dbSetOrder(1)
dbSeek("ZU6")
While !Eof() .And. (X3_ARQUIVO == "ZU6")
	If X3USO(X3_USADO) .And. cNivel >= X3_NIVEL
		If AllTrim(X3_CAMPO) $ "ZU6_CO*ZU6_CC&ZU6_DESCCC*ZU6_DESCCO"
			nUsado:=nUsado+1
			Aadd(aHeader,{ AllTrim(x3_titulo), x3_campo, x3_Picture,;
			x3_tamanho, x3_decimal, x3_Valid ,;
			x3_usado, x3_tipo, x3_arquivo, x3_context } )
		EndIf
	EndIf
	dbSkip()
End

//����������������������������������������������������������Ŀ
//� Posiciona o Cabecalho da Tabela a ser editada (_cTabela) �
//������������������������������������������������������������
dbSelectArea("ZU6")
dbSetOrder(1)
//�������������������������������������Ŀ
//� Cabecalho da tabela, filial � vazio �
//���������������������������������������
//If !dbSeek("  "+"00"+_cTabela)
//	Help(" ",1,"RFATAA21")
//   MsgStop("Cadastrar Cabecalho da Tabela")
//	Return
//EndIf
_cChave  := " " // AllTrim(ZU6->ZU6_FILIAL+ZU6->ZU6_CO+ZU6->ZU6_CC)
_cDescri := " " // SubStr(ZU6->ZU6_DESCCC,1,40)

//��������������������������������������������������������������������������Ŀ
//� Montando aCols - Posiciona os itens da tabela conforme a filial corrente �
//����������������������������������������������������������������������������
dbSeek(_cCodFil)
While !Eof() .And. ZU6->ZU6_FILIAL == _cCodFil // .And. SX5->X5_TABELA==_cTabela
	Aadd(aCols ,Array(nUsado+1))
	Aadd(aRecNo,Array(nUsado+1))
	For nQ:=1 to nUsado
		aCols[Len(aCols),nQ]  := FieldGet(FieldPos(aHeader[nQ,2]))
		aRecNo[Len(aCols),nQ] := FieldGet(FieldPos(aHeader[nQ,2]))
	Next
	aRecNo[Len(aCols),nUsado+1] := RecNo()
	aCols[Len(aCols),nUsado+1]  := .F.
	dbSelectArea("ZU6")
	dbSkip()
EndDo

_nItem := Len(aCols)
If Len(aCols)==0
	Aadd(aCols,Array(nUsado+1))
	For nQ:=1 to nUsado
		aCols[Len(aCols),nQ]:= CriaVar(FieldName(FieldPos(aHeader[nQ,2])))
	Next
	aCols[Len(aCols),nUsado+1] := .F.
EndIf

//���������������������������������Ŀ
//� Variaveis do Rodape do Modelo 2 �
//�����������������������������������
nLinGetD:=0

//������������������Ŀ
//� Titulo da Janela �
//��������������������
cTitulo := _cDescri

//��������������������������������������������������������������Ŀ
//� Array com descricao dos campos do Cabecalho do Modelo 2      �
//����������������������������������������������������������������
aC:={}
//Aadd(aC,{"_cChave" ,{15,10} ,""   ,"@!"," ","",.f.})
//Aadd(aC,{"_cDescri",{15,58} ,"","@!"," ","",.f.})

//��������������������������������������������������������������Ŀ
//� Nao utiliza o rodape, apesar de passar para Modelo 2         �
//����������������������������������������������������������������
aR:={}

//����������������������������������������������Ŀ
//� Array com coordenadas da GetDados no modelo2 �
//������������������������������������������������
aCGD:={44,5,118,315}

//������������������������������������Ŀ
//� Validacoes na GetDados da Modelo 2 �
//��������������������������������������
cLinhaOk:= "(!Empty(aCols[n,2]) .AND. !Empty(aCols[n,1]))"
cTudoOk := "AllwaysTrue()"

//��������������������Ŀ
//� Chamada da Modelo2 �
//����������������������
lRetMod2 := .F.
N        := 1
lRetMod2 := Modelo2(	cTitulo,;								// Titulo da Janela
						aC,;									// Array com os campos do cabe�alho
						aR,;									// Array com os campos do rodap�
						aCGD,;									// Array com as coordenadas da getdados
						nOpcx,;									// Modo de opera��o (3=Incluir;4=Alterar;5=Excluir)
						cLinhaOk,;								// Valida��o da LinhaOk
						cTudoOk,;								// Valida��o do TudoOk
						{"ZU6_CO","ZU6_CC"},;				// Array com os campos da getdados que ser�o edit�veis
						Nil,;									// Bloco de c�digo para a tecla F4
						Nil,;									// String com os campos que ser�o inicializados quando seta para baixo
						900,;									// N�mero m�ximo de elementos da getdados
						Nil,;									// Coordenados windows
						.T.	;									// Permitie deletar itens da Getdados
						)

If lRetMod2
	
	Begin Transaction
	
	dbSelectAre("ZU6")
	dbSetOrder(1)
	For n := 1 to Len(aCols)
		If aCols[n,Len(aHeader)+1] == .T.
			//����������������������������������������������������������Ŀ
			//� Filial e Chave e a chave indepEndente da descricao		 �
			//� que pode ter sido alterada               					 �
			//������������������������������������������������������������
			If dbSeek(_cCodFil+aCols[n,1]+aCols[n,3])
				RecLock("ZU6",.F.,.T.)
				dbDelete()
				MsUnlock()
			EndIf
		Else
			If dbSeek(xFilial("ZU6")+aCols[n,1]+aCols[n,3])
				If aCols[n,2] != ZU6->ZU6_DESCCC
					RecLock("ZU6",.F.)        
//					ZU6->ZU6_ITEM := aCols[n,1]
					ZU6->ZU6_CO  := aCols[n,1]                      
					ZU6->ZU6_DESCCO := aCols[n,2]										
					ZU6->ZU6_CC := aCols[n,3]
					ZU6->ZU6_DESCCC := aCols[n,4]					
					MsUnlock()
				EndIf
			Else
				If _nItem >= n
					dbGoto(aRecNo[n,nusado+1])
					RecLock("ZU6",.F.)
					ZU6->ZU6_CO  := aCols[n,1]                      
					ZU6->ZU6_DESCCO := aCols[n,2]										
					ZU6->ZU6_CC := aCols[n,3]                       
					ZU6->ZU6_DESCCC := aCols[n,4]										
					MsUnlock()
				ElseIf (!Empty(aCols[n,1]))
					RecLock("ZU6",.T.)
					ZU6->ZU6_FILIAL := _cCodFil
//					ZU6->ZU6_ITEM   := n+1
					ZU6->ZU6_CO  := aCols[n,1]                      
					ZU6->ZU6_DESCCO := aCols[n,2]										
					ZU6->ZU6_CC := aCols[n,3]                       
					ZU6->ZU6_DESCCC := aCols[n,4]										
					MsUnlock()
				EndIf
			EndIf
		EndIf
	Next
	
	End Transaction
EndIf

Return(Nil)