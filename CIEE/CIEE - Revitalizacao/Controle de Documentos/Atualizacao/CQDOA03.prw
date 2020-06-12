#INCLUDE "RWMAKE.CH"

/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �CIEE003   � Autor � Rubens Lacerda     � Data �  04/10/06   ���
�������������������������������������������������������������������������͹��
���Descricao � Cadastro de Responsaveis                                   ���
���          �                                                            ���
�������������������������������������������������������������������������͹��
���Uso       � CIEE                                                       ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/
User Function CQDOA03() //CIEE003

//���������������������������������������������������������������������Ŀ
//� Declaracao de Variaveis                                             �
//�����������������������������������������������������������������������
Private cCadastro := "Cadastro de Responsaveis"
Private aCores     := {}
aCores := {;
{'PA3_STATUS == I'    , "BR_VERMELHO" },;  // INATIVO
{'PA3_STATUS == A'    , "BR_VERDE"  }}	 // ATIVO

Private aRotina := { { "Pesquisar", "AxPesqui", 0, 1 } , ;
{ "Visualizar", "AxVisual", 0, 2 } , ;
{ "Incluir"   , "AxInclui", 0, 3 } , ;
{ "Alterar"   , "AxAltera", 0, 4 } , ;
{ "Excluir"   , "AxDeleta"   	 	, 0, 5 }, ;
{ "Legenda"   , 'u_PA3Legend()' 	, 0, 2 }  } //"Legenda"      

Private cDelFunc := "u_CIE03D()"
Private cString := "PA3"

dbSelectArea( "PA3" )
dbSetOrder( 1 )

dbSelectArea( cString )
mBrowse( 6, 1, 22, 75, cString,, 'PA3_STATUS == "I"' )

Return

/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �          �Autor  �Microsiga           � Data �  10/10/06   ���
�������������������������������������������������������������������������͹��
���Desc.     �                                                            ���
���          �                                                            ���
�������������������������������������������������������������������������͹��
���Uso       � CIEE                                                       ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/
//���������������������������������������������������������������������Ŀ
//� Funcao que testa se pode deletar o responsavel selecionado          �
//�����������������������������������������������������������������������
User Function CIE03D()
Local aArea  := GetArea()
Local lExist := .T.

dbSelectArea( "PA7" )
dbSetOrder( 2 )

If dbSeek( xFilial( "PA7" ) + PA3->PA3_MAT )
	APMsgStop( "Este registro nao pode ser excluido.", 'ATEN��O' )
	lExist := .F.
EndIf
         
dbSelectArea( "PA8" )
dbSetOrder( 2 )

If dbSeek( xFilial( "PA8" ) + PA3->PA3_MAT )
	APMsgStop( "Este registro nao pode ser excluido.", 'ATEN��O' )
	lExist := .F.
EndIf

RestArea( aArea )
Return lExist 

/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Rotina    � CIE03NIV �Autor  � Rubens Lacerda     � Data �  21/11/06   ���
�������������������������������������������������������������������������͹��
���Descricao � Verifica se o Nivel do usuario pode ser alterado           ���
���          �                                                            ���
�������������������������������������������������������������������������͹��
���Uso       � CIEE 						                              ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/
User Function CIE03NIV()
Local lRet     := .T. 
Local aArea    := GetArea()
Local aAreaPA7 := PA7->( GetArea() ) 

If ALTERA
	dbSelectArea( "PA7" ) 
	dbSetOrder( 2 )

	If dbSeek( xFilial( "PA8" ) + PA3->PA3_MAT )
		lRet := .F.
		ApMsgStop( 'Esse nivel nao pode ser alterado', 'ATEN��O' )
	EndIf
EndIf                                                  

RestArea( aAreaPA7 )
RestArea( aArea )

Return lRet  

/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Rotina    � CIE03STS �Autor  � Rubens Lacerda     � Data �  21/11/06   ���
�������������������������������������������������������������������������͹��
���Descricao � Verifica se o Status do usuario pode ser alterado          ���
���          �                                                            ���
�������������������������������������������������������������������������͹��
���Uso       � CIEE 						                              ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/
User Function CIE03STS()
Local lRet     := .T. 
Local aArea    := GetArea()
Local aAreaPA7 := PA7->( GetArea() ) 

If ALTERA
	dbSelectArea( "PA7" ) 
	dbSetOrder( 2 )

	If dbSeek( xFilial( "PA8" ) + PA3->PA3_MAT )
		lRet := .F.
		ApMsgStop( 'Esse Status nao pode ser alterado', 'ATEN��O' )
	EndIf
EndIf                                                  

RestArea( aAreaPA7 )
RestArea( aArea )
Return lRet 

/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  � Valmail  �Autor  � Ernani Forastieri  � Data �  13/02/07   ���
�������������������������������������������������������������������������͹��
���Desc.     � Validacao da digitacao de um e-mail                        ���
���          �                                                            ���
�������������������������������������������������������������������������͹��
���Uso       � CIEE                                                       ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/

User Function ValMail()
Local cLit   := ' {}()<>[]|\/&*$ %?!^~`,;:=#'
Local lRet   := .T.
Local nResto := 0
Local nI 
Local aArea    := GetArea()
Local aAreaPA7 := PA7->( GetArea() ) 
Local cEmail := M->PA3_EMAIL

cEmail := AllTrim( cEmail )

For nI := 1 To Len( cLit )
	If At( SubStr( cLit, nI, 1 ), cEmail )  >   0 
		ApMsgStop( 'Existe um caracter invalido para e-mail', 'ATEN��O' )
		lRet   := .F.
		Exit
	EndIf
Next

If lRet
	If ( nResto := At( "@", cEmail ) ) > 0 .AND. At( "@", Right( cEmail, Len( cEmail ) - nResto ) ) == 0
		If ( nResto := At( ".", Right( cEmail, nResto ) ) ) == 0
			lRet := .F.
		EndIf
	Else
		ApMsgStop( 'Endere�o de e-mail invalido', 'ATEN��O' )
		lRet := .F.
	EndIf
EndIf   

RestArea( aAreaPA7 )
RestArea( aArea )

Return lRet     

/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Rotina    � PA3LEGEND�Autor  � Rubens Lacerda     � Data �  17/11/06   ���
�������������������������������������������������������������������������͹��
���Descricao � Rotina para exibicao da legenda                            ���
���          �                                                            ���
�������������������������������������������������������������������������͹��
���Uso       � CIEE 						                              ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/
User Function PA3Legend()
Local aCores := {;
{"BR_VERDE"     , "Ativo"     },;
{"BR_VERMELHO"  , "Inativo"     } }

BrwLegenda( cCadastro, "Legenda", aCores ) //"Legenda"

Return NIL  