#Include 'Rwmake.ch'

/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �Sour001   �Autor  �Sergio Oliveira     � Data �  04/06/03   ���
�������������������������������������������������������������������������͹��
���Desc.     � Cadastro de Rdmakes.                                       ���
�������������������������������������������������������������������������͹��
���Uso       � Projeto Source Safe.                                       ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/

User Function Sour001()

cTitulo   := "Manutencao dos Rdmakes."
cCadastro := "Manutencao dos Rdmakes."
// Tratar campo para cor
aCor      := {{"FA5->FA5_STATUS == .F.","BR_VERDE" },;  // Rdmake Livre    
			  {"FA5->FA5_STATUS == .T.","BR_VERMELHO"}} // Rdmake Requisitado

aRotina   := menudef()

//{  { "Pesquisar" ,"U_SourPesq()" , 0 , 1 } , ;
//{ "Visualizar",'AXVISUAL', 0 , 2 } , ;
//{ "Incluir"   ,'AXINCLUI', 0 , 3 } , ;
//{ "Alterar"   ,'AXALTERA', 0 , 4 } , ;
//{ "Excluir"   ,'AXDELETA', 0 , 5 } , ;
//{ "Legenda"	 ,'U_Sour001Leg("cCadastro")',	0,9}  }

mBrowse(,,,,"FA5",,,,,,aCor)

Return

User Function Sour001Leg(cCadastro)

_aLegenda := {}
aAdd(_aLegenda,{ 'BR_VERDE'    , "Rdmake Livre" })
aAdd(_aLegenda,{ 'BR_VERMELHO' , "Rdmake Requisitado" })

BrwLegenda(cCadastro,'Legenda',_aLegenda)

Return          

/*/
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������Ŀ��
���Fun��o    �SourPesq  � Autor � Sergio Oliveira       � Data � 05/2003  ���
�������������������������������������������������������������������������Ĵ��
���Descri��o � Pesquisa especial por Partes do nome.                      ���
�������������������������������������������������������������������������Ĵ��
��� Uso      � YrFataaa.prw                                               ���
��������������������������������������������������������������������������ٱ�
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
/*/

User Function SourPesq()

_aOp  	:= {"Convencional","Especial","Cancelar"}
_cTit 	:= "Tipo de Pesquisa"
_cMsg   := 'Qual o tipo de pesquisa deseja'+Chr(13)
_cMsg   += 'Fazer? Escolha uma das Opcoes abaixo:'
_nOp    := Aviso(_cTit,_cMsg,_aOp)

If _nOp == 1      // Convencional
	AxPesqui()
	Return
ElseIf _nOp == 3  // Cancelar
	Return
EndIf

_aStru    := {}
Aadd( _aStru, {'FA5_RDMAKE','C',20,0} )
Aadd( _aStru, {'FA5_DESCRI','C',80,0} )
Aadd( _aStru, {'FA5_RESPON','C',20,0} )

_xTmp     := U_CriaTmp( _aStru, 'Work' )

aCampos   := {}
Aadd( aCampos, {'FA5_RDMAKE','Nome do Rdmake'       ,'@!','20','0'} )
Aadd( aCampos, {'FA5_DESCRI','Descricao do Rdmake'  ,'@!','80','0'} )
Aadd( aCampos, {'FA5_RESPON','Nome do Representante','@!','20','0'} )

_cPesq  := Space(80)
_cCombo := ""
_aCombo := {}
Private oObj

@ 187,108 To 611,916 Dialog mkwdlg Title OemToAnsi("Pesquisa Especial")
@ 002,003 To 210,398
@ 002,003 To 210,113
@ 007,118 To 206,394 Title OemToAnsi("Resultados da Pesquisa")
@ 177,118 To 205,394
@ 024,006 To 094,110 Title OemToAnsi("Digite a Pesquisa")
@ 014,120 To 174,392 Browse "Work" Fields aCampos Object oObj
@ 047,008 Get _cPesq Size 100,10
@ 068,038 Button OemToAnsi("_Pesquisar") Size 36,16 Action(_Pesquisar())
@ 185,208 BmpButton Type 19 Action(_Atualiza())
@ 185,279 BmpButton Type 02 Action(Close(mkwdlg))

Activate Dialog mkwdlg Centered

Return

Static Function _Pesquisar()

If Empty(_cPesq)
	Return
EndIf

DbSelectArea('Work')
DbGoTop()
While !Eof()
	RecLock('Work',.f.)
	DbDelete()
	MsUnLock()
	DbSkip()
EndDo

_xSelect := "FA5_FILIAL = '  ' .And. ('"+AllTrim(Upper(_cPesq))+"' $ FA5_DESCRI) "

DbSelectArea('FA5')
Set Filter To &_xSelect
DbGoTop()
While !Eof()
	
	DbSelectArea('Work')
	RecLock('Work',.t.)
	Field->FA5_RDMAKE:= FA5->FA5_RDMAKE
	Field->FA5_DESCRI:= FA5->FA5_DESCRI
	Field->FA5_RESPON:= FA5->FA5_RESPON
	MsUnLock()
	
	DbSelectArea('FA5')
	DbSkip()
EndDo

DbSelectArea('FA5')
Set Filter To

DbSelectArea('Work')
DbGoTop()

oObj:oBrowse:Refresh()

Return

Static Function _Atualiza()

DbSelectArea('FA5')
DbSetOrder(1)
DbSeek(xFilial('FA5')+Work->FA5_RDMAKE)

Close(mkwDlg)

Return
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
Local aRotina :=	{  { "Pesquisar" ,"U_SourPesq()" , 0 , 1 } , ;
						{ "Visualizar",'AXVISUAL', 0 , 2 } , ;
						{ "Incluir"   ,'AXINCLUI', 0 , 3 } , ;
						{ "Alterar"   ,'AXALTERA', 0 , 4 } , ;
						{ "Excluir"   ,'AXDELETA', 0 , 5 } , ;
						{ "Legenda"	 ,'U_Sour001Leg("cCadastro")',	0,9}  }

Return aRotina
