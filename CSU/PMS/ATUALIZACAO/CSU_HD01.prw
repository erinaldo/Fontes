#include "Rwmake.ch"
/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �CSU_HD01  �Autor  �Microsiga           � Data �  09/11/06   ���
�������������������������������������������������������������������������͹��
���Desc.     � chamada principal de controle de help desk CSU             ���
���          �                                                            ���
�������������������������������������������������������������������������͹��
���Uso       � mp8                                                        ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/
User Function CSU_HD01()


Private cCadastro	:= "Help Desk - CSU CardSystem"
Private cUser       := GetMv("MV_USRHELP", ,"Administrador")
Private cSuperUser	:= GetMv("MV_USRECHA", ,"Administrador")
Private aRotina		:= {}

//If Alltrim(Substr(cusuario,7,15))$cUser
If Alltrim(UsrRetName(__cUserId))$cUser
	aRotina		:= 	menudef1()
	
//	{ {"Pesquisar"   ,"AxPesqui",0,1},;
//	{"Visualizar" 	 	,"AxVisual",0,2},;
//	{"Incluir"    	 	,"u_INSERT",0,3},;
//	{"Alterar"    	 	,"u_ALTER",0,3},;
//	{"Cancelar"    	 	,"u_Cancela",0,4},;
//	{"Anexa Docs"   	,"MsDocument",0,4},;
//	{"Inicia Atend." 	,"u_Atende()",0,4},;
//	{"Complem.Atend." 	,"u_Completa()",0,4},;
//	{"Transfere PMS" 	,"u_PMS()",0,4},;
//	{"Relat�rio" 		,"u_Relatorio()",0,4},;
//	{"Ocorrencias" 		,"axcadastro('ZA3')",0,4},;
//	{"Sistemas" 		,"axcadastro('ZA2')",0,4},;
//	{"Modulos	" 		,"axcadastro('ZA4')",0,4},;
//	{"Legenda     "	 	,"u_SUBS()",0,4} }

Else
	aRotina		:= 	menudef2()
	
//	{ {"Pesquisar"   ,"AxPesqui",0,1},;
//	{"Visualizar" 		 ,"AxVisual",0,2},;
//	{"Incluir"  	  	 ,"u_INSERT",0,3},;
//	{"Cancelar"	    	 ,"u_Cancela",0,4},;
//	{"Anexa Docs"		 ,"MsDocument",0,4},;
//	{"Legenda     "	 	 ,"u_SUBS()",0,4} }

Endif

//If Alltrim(Substr(cusuario,7,15))$cSuperUser
If Alltrim(UsrRetName(__cUserId))$cSuperUser
	aRotina		:= 	{ {"Pesquisar"   ,"AxPesqui",0,1},;
	{"Visualizar" 	 	,"AxVisual",0,2},;
	{"Incluir"    	 	,"u_INSERT",0,3},;
	{"Alterar"    	 	,"u_ALTER",0,3},;
	{"Cancelar"    	 	,"u_Cancela",0,4},;
	{"Anexa Docs"   	,"MsDocument",0,4},;
	{"Inicia Atend." 	,"u_Atende()",0,4},;
	{"Complem.Atend." 	,"u_Completa()",0,4},;
	{"Encerr.Atend." 	,"u_finaliza()",0,4},;
	{"Transfere PMS" 	,"u_PMS()",0,4},;
	{"Relat�rio" 		,"u_Relatorio()",0,4},;
	{"Ocorrencias" 		,"axcadastro('ZA3')",0,4},;
	{"Sistemas" 		,"axcadastro('ZA2')",0,4},;
	{"Modulos	" 		,"axcadastro('ZA4')",0,4},;
	{"Legenda     "	 	,"u_SUBS()",0,4} }
EndIf

aCores	:=	{	{'ZA1_STATUS=="1"','BR_VERDE'	},;
{'ZA1_STATUS=="2"','BR_AMARELO'	},;
{'ZA1_STATUS=="3"','BR_PRETO' },;
{'ZA1_STATUS=="5"','BR_AZUL' },;
{'ZA1_STATUS=="4"','BR_VERMELHO'	}}

mBrowse(6,1,22,74,"ZA1",,,,,,aCores)

Return
/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �CSU_HD01  �Autor  �Microsiga           � Data �  09/11/06   ���
�������������������������������������������������������������������������͹��
���Desc.     � inclusao de chamado para help desk CSU                     ���
���          �                                                            ���
�������������������������������������������������������������������������͹��
���Uso       � mp8                                                        ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/
//Funcao de inclusao do chamado
User Function INSERT()

Local aCposInc := {}

Aadd (aCposInc,"ZA1_IDENT")
Aadd (aCposInc,"ZA1_USER")
Aadd (aCposInc,"ZA1_OCOR")
Aadd (aCposInc,"ZA1_DATAI")
Aadd (aCposInc,"ZA1_HORAI")
Aadd (aCposInc,"ZA1_SISTEM")
Aadd (aCposInc,"ZA1_CLASS")
Aadd (aCposInc,"ZA1_DESREM")
Aadd (aCposInc,"ZA1_MODULO")
Aadd (aCposInc,"ZA1_SITE")
Aadd (aCposInc,"ZA1_TELEF")
Aadd (aCposInc,"ZA1_EMAIL")


dbSelectArea("ZA1")
dbSetOrder(1)

AXInclui("ZA1", Recno(),3,aCposInc,,aCposInc,,,,)

dbSelectArea("ZA1")


Return

/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �CSU_HD01  �Autor  �Microsiga           � Data �  09/11/06   ���
�������������������������������������������������������������������������͹��
���Desc.     � Alteracao de chamado para help desk CSU                    ���
���          �                                                            ���
�������������������������������������������������������������������������͹��
���Uso       � mp8                                                        ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/
//Funcao de alteracao do chamado
User Function ALTER()

Local aCposAlt := {}

If ZA1->ZA1_STATUS >= "3"
	MsgBox("Somente os chamados em aberto poder�o ser alterados!!!")
	Return
Endif

// campos para alteracao
Aadd (aCposAlt,"ZA1_CLASS")
Aadd (aCposAlt,"ZA1_MODULO")

dbSelectArea("ZA1")
dbSetOrder(1)

//AXAltera("ZA1", Recno(),4,aCposInc,,aCposAlt,,,,)
AXaltera("ZA1",Recno(),4,aCposAlt,aCposAlt)

dbSelectArea("ZA1")


Return



/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �CSU_HD01  �Autor  �Microsiga           � Data �  09/11/06   ���
�������������������������������������������������������������������������͹��
���Desc.     � funcao de controle do numero do chamado                    ���
���          �                                                            ���
�������������������������������������������������������������������������͹��
���Uso       � mp8                                                        ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/
//Funcao para geracao do codigo do chamado (dia+mes+ano+hora+minuto+segundo)
User Function Ret_num_ch()

Local _cChamado

_cChamado:=  Substr(dtoc(ddatabase),7,2) + Substr(dtoc(ddatabase),4,2) + Substr(dtoc(ddatabase),1,2) + Substr(Time(),1,2) + Substr(Time(),4,2) + Substr(Time(),7,2)

Return(_cChamado)

/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �CSU_HD01  �Autor  �Microsiga           � Data �  09/11/06   ���
�������������������������������������������������������������������������͹��
���Desc.     � legenda do browse de chamados                              ���
���          �                                                            ���
�������������������������������������������������������������������������͹��
���Uso       � mp8                                                        ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/
//Funcao para controle de legenda
User Function SUBS()

Local aLegenda := 	{ 	{"BR_PRETO"   ,"Chamado Cancelado"      },;
{"BR_VERDE"   ,"Chamado Aberto"         },;
{"BR_AMARELO" ,"Chamado em Atendimento" },;
{"BR_AZUL" 	  ,"Chamado Transf. PMS" },;
{"BR_VERMELHO","Chamado Encerrado" } }

BrwLegenda("Status Chamados CSU","Legenda",aLegenda)

Return


/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �CSU_HD01  �Autor  �Microsiga           � Data �  09/11/06   ���
�������������������������������������������������������������������������͹��
���Desc.     � inicio de atendimento                                      ���
���          �                                                            ���
�������������������������������������������������������������������������͹��
���Uso       � mp8                                                        ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/
User Function Atende()

Local aCposAlt := {}
Local pcAssunto:= ''
Local pcTitulo := ''
Local pcDetalhe:= ''
Local pcUsuario:= ''
Local pcAtachar:= ''

If ZA1->ZA1_STATUS <> "1"
	MsgBox("Somente chamados em aberto tem inicio de atendimento!!!")
	Return
Endif

DbSelectArea("ZA1")
nRec := Recno()

Aadd (aCposAlt,"ZA1_SOLUC")

If MsgYesNo("Confirma o inicio do atendimento do chamado - "+ ZA1->ZA1_IDENT + " ? ")
	nopc := AXaltera("ZA1",Recno(),4,aCposAlt,aCposAlt,,,,,,)
	//FUNCTION AxAltera(cAlias,nReg,nOpc,aAcho,aCpos,nColMens,cMensagem,cTudoOk,cTransact,cFunc,aButtons,aParam,aAuto,lVirtual,lMaximized)
	If nopc == 1
		If Reclock("ZA1",.f.)
//			ZA1->ZA1_TECNIC := Substr(cusuario,7,15)
			ZA1->ZA1_TECNIC := UsrRetName(__cUserId)
			ZA1->ZA1_DATAA  := DDATABASE
			ZA1->ZA1_HORAA  := Substr(Time(),1,5)
			ZA1->ZA1_STATUS := "2"
			ZA1->ZA1_CODTEC := __CUSERID
			ZA1->ZA1_NTEC 	:= UsrFullName(__cUserId)
			MsUnlock()
		Endif
	Endif
Endif
pcAssunto:= 'Ref. chamado de suporte: '+ZA1->ZA1_IDENT
pcTitulo := ZA1->ZA1_DESREM
pcDetalhe:= 'Chamado sendo atendido pelo analista: '+UsrFullName(__CUSERID)+Chr(13)
_cLinha  := Alltrim(ZA1->ZA1_SOLUC)
_nLinhas := mlcount(_cLinha,85)
for _nVezLinha:=1 to _nLinhas
	pcDetalhe += memoline(_cLinha,85,_nVezLinha,,.T.)+Chr(13)
next
pcDetalhe+= ' Data/Hora: '+ZA1->(Dtoc(ZA1_DATAA)+' '+ZA1_HORAA)
pcUsuario:= ZA1->ZA1_CODUSE
pcAtachar:= ''
u_RcomW06(pcAssunto, pcTitulo, pcDetalhe, pcUsuario, pcAtachar)
DbSelectArea("ZA1")

Return

/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �CSU_HD01  �Autor  �Microsiga           � Data �  09/11/06   ���
�������������������������������������������������������������������������͹��
���Desc.     � cancela chamado em aberto                                  ���
���          �                                                            ���
�������������������������������������������������������������������������͹��
���Uso       � mp8                                                        ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/
User Function Cancela()

DbSelectArea("ZA1")
nRec := Recno()

//If Substr(cusuario,7,15) == ZA1->ZA1_USER
If UsrRetName(__cUserId) == ZA1->ZA1_USER
	If ZA1->ZA1_STATUS <> "1"
		MsgBox("Somente os chamados sem atendimento podereao ser cancelados!!!")
	Else
		If MsgYesNo("Confirma o cancelamento do chamado - " + ZA1->ZA1_IDENT + " ?")
			DbSelectArea("ZA1")
			nRec := Recno()
			If Reclock("ZA1",.f.)
				ZA1->ZA1_STATUS := "3"
				MsUnlock()
			Endif
		Endif
	Endif
Else
	MsgBox("Somente o usuario respons�vel pela abertura do chamado poder� cancelar o mesmo!!!")
Endif

DbSelectArea("ZA1")
DbGoto(nRec)

Return


/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �CSU_HD01  �Autor  �Microsiga           � Data �  09/11/06   ���
�������������������������������������������������������������������������͹��
���Desc.     � complementa historico de atendiemnto de chamado            ���
���          �                                                            ���
�������������������������������������������������������������������������͹��
���Uso       � mp8                                                        ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/
User Function Completa()

Local aCposAlt := {}

If ZA1->ZA1_STATUS <> "2"
	MsgBox("Somente chamados em atendimento tem complemento de atendimento!!!")
	Return
Endif

DbSelectArea("ZA1")

nRec := Recno()

Aadd (aCposAlt,"ZA1_SOLUC")

nopc := AXaltera("ZA1",Recno(),4,aCposAlt,aCposAlt)

DbSelectArea("ZA1")

nRec := Recno()

Return

/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �CSU_HD01  �Autor  �Microsiga           � Data �  09/11/06   ���
�������������������������������������������������������������������������͹��
���Desc.     � encerra atendiemnto de chamado.                            ���
���          �                                                            ���
�������������������������������������������������������������������������͹��
���Uso       � mp8                                                        ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/

User Function finaliza()

If ZA1->ZA1_STATUS == "4"
	MsgBox("Chamado j� foi encerrado anteriormente!!!")
	Return
Endif

If ZA1->ZA1_STATUS == "3"
	MsgBox("Chamado j� foi cancelado anteriormente!!!")
	Return
Endif

If ZA1->ZA1_STATUS == "1"
	MsgBox("Chamado n�o sofreu atendimento, n�o poder� ser encerrado!!!")
	Return
Endif

DbSelectArea("ZA1")
nRec := Recno()

If MsgYesNo("Confirma o encerramento do chamado - " + ZA1->ZA1_IDENT + " ?")
	DbSelectArea("ZA1")
	If Reclock("ZA1",.f.)
		ZA1->ZA1_STATUS := "4"
		ZA1->ZA1_DATAF  := DDATABASE
		ZA1->ZA1_HORAF  := Substr(Time(),1,5)
		MsUnlock()
	Endif
Endif

pcAssunto:= 'Ref. chamado de suporte: '+ZA1->ZA1_IDENT
pcTitulo := ZA1->ZA1_DESREM
pcDetalhe:= 'Ocorrencia: '
_cLinha  := Alltrim(ZA1->ZA1_OCOR)
_nLinhas := mlcount(_cLinha,85)
for _nVezLinha:=1 to _nLinhas
	pcDetalhe += memoline(_cLinha,85,_nVezLinha,,.T.)+Chr(13)
next
pcDetalhe:= 'Solucao: '
_cLinha  := Alltrim(ZA1->ZA1_SOLUC)
_nLinhas := mlcount(_cLinha,85)
for _nVezLinha:=1 to _nLinhas
	pcDetalhe += memoline(_cLinha,85,_nVezLinha,,.T.)+Chr(13)
next
pcDetalhe+= ' Chamado foi atendido pelo analista: '+UsrFullName(__CUSERID)
pcDetalhe+= ' Data/Hora do encerramento: '+ZA1->(Dtoc(ZA1_DATAF)+' '+ZA1_HORAF)
pcUsuario:= ZA1->ZA1_CODUSE
pcAtachar:= ''
u_RcomW06(pcAssunto, pcTitulo, pcDetalhe, pcUsuario, pcAtachar)

DbSelectArea("ZA1")
DbGoto(nRec)

Return

/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �CSU_HD01  �Autor  �Microsiga           � Data �  09/11/06   ���
�������������������������������������������������������������������������͹��
���Desc.     � emite relatorio de chamados                                ���
���          �                                                            ���
�������������������������������������������������������������������������͹��
���Uso       � mp8                                                        ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/
User Function Relatorio()
Local cPerg		:= PADR("PMSR02",LEN(SX1->X1_GRUPO)) // grupo de perguntas do relatorio
Local __aAreas  := GetArea()
Pergunte(cPerg,.f.)
dbSelectArea("SX1")
if dbSeek(cPerg+"09")
	RecLock("SX1",.F.)
	SX1->X1_CNT01 := ZA1->ZA1_IDENT
	msUnlock()
endif
if dbSeek(cPerg+"10")
	RecLock("SX1",.F.)
	SX1->X1_CNT01 := ZA1->ZA1_IDENT
	msUnlock()
endif
//MsgBox("Em Desenvolvimento!")

U_CSPMSR01()                

RestArea(__aAreas)
Return

/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �FTMSREL   �Autor  �                    � Data �             ���
�������������������������������������������������������������������������͹��
���Desc.     � Integracao com o Banco de Conhecimento                     ���
���          �                                                            ���
�������������������������������������������������������������������������͹��
���Uso       �                                                            ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/

User Function FTMSREL()

Local _aEntidade := {}

AAdd( _aEntidade, { "ZA1", { "ZA1_IDENT" }, { || ZA1->ZA1_USER } } )

Return(_aEntidade)


/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �PMS       �Autor  �Microsiga           � Data �  09/11/06   ���
�������������������������������������������������������������������������͹��
���Desc.     � Amarra chamado com o PMS.                                  ���
���          �                                                            ���
�������������������������������������������������������������������������͹��
���Uso       � mp8                                                       ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/
User Function PMS()

Local aCposAlt := {}

If ZA1->ZA1_STATUS <> "4"
	MsgBox("Somente os chamados encerrado poder�o ser transferidos para o PMS!!!")
	Return
Endif

//If Alltrim(Substr(cusuario,7,15)) <> Alltrim(ZA1->ZA1_TECNIC)
If Alltrim(UsrRetName(__cUserId)) <> Alltrim(ZA1->ZA1_TECNIC)
	MsgBox("Somente o usuario respons�vel pelo atendimento do chamado poder� transferir o mesmo para o PMS!!!")
	Return
Endif

DbSelectArea("ZA1")
nRec := Recno()

Aadd (aCposAlt,"ZA1_CODPMS")

If MsgYesNo("Confirma a transferencia para o PMS do chamado - "+ ZA1->ZA1_IDENT + " ? ")
	nopc := AXaltera("ZA1",Recno(),4,aCposAlt,aCposAlt,,,,,,)
	If nopc == 1
		If Reclock("ZA1",.f.)
			//			ZA1->ZA1_DATPMS    := DDATABASE
			ZA1->ZA1_STATUS     := "5"
			MsUnlock()
		Endif
	Endif
Endif

DbSelectArea("ZA1")
DbGoto(nRec)

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
Static Function MenuDef1()
Local 	aRotina		:= 	{ {"Pesquisar"   ,"AxPesqui",0,1},;
						{"Visualizar" 	 	,"AxVisual",0,2},;
						{"Incluir"    	 	,"u_INSERT",0,3},;
						{"Alterar"    	 	,"u_ALTER",0,3},;
						{"Cancelar"    	 	,"u_Cancela",0,4},;
						{"Anexa Docs"   	,"MsDocument",0,4},;
						{"Inicia Atend." 	,"u_Atende()",0,4},;
						{"Complem.Atend." 	,"u_Completa()",0,4},;
						{"Transfere PMS" 	,"u_PMS()",0,4},;
						{"Relat�rio" 		,"u_Relatorio()",0,4},;
						{"Ocorrencias" 		,"axcadastro('ZA3')",0,4},;
					 	{"Sistemas" 		,"axcadastro('ZA2')",0,4},;
						{"Modulos	" 		,"axcadastro('ZA4')",0,4},;
						{"Legenda     "	 	,"u_SUBS()",0,4} }

Return aRotina



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
Static Function MenuDef2()
Local 	aRotina		:= 	{ {"Pesquisar"   ,"AxPesqui",0,1},;
						{"Visualizar" 		 ,"AxVisual",0,2},;
						{"Incluir"  	  	 ,"u_INSERT",0,3},;
						{"Cancelar"	    	 ,"u_Cancela",0,4},;
						{"Anexa Docs"		 ,"MsDocument",0,4},;
						{"Legenda     "	 	 ,"u_SUBS()",0,4} }
Return aRotina



