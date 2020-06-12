#include "rwmake.ch"
#include "_FixSX.ch" // "AddSX1.ch"
#DEFINE _PL CHR(13) + CHR(10)

/*/
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �cmata01   � Autor � Felipe Raposo      � Data �  19/06/02   ���
�������������������������������������������������������������������������͹��
���Descricao � Filtra as solicitacoes de compras para o comprador.        ���
���          �                                                            ���
�������������������������������������������������������������������������͹��
���Uso       � CIEE.                                                      ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
/*/
User Function cmata01()

//���������������������������������������������������������������������Ŀ
//� Declaracao de variaveis.                                            �
//�����������������������������������������������������������������������
Local _cPerg, _aSX1, _aSXb, _cAreaSC1
Local _mFilComp, _mFilFech, _cFilSC, bFiltraBrw, aIndexSC1 := {}
//Public _cUsrAdm := "Administrador, Siga, Waldir, Juliana, Sue Hellen"

If Alltrim(cUserName) $ GetMV("CI_USERSC")
	_cUsrAdm:=cUserName
Else
	_cUsrAdm:=""
EndIf

// O bloco de comandos abaixo atualiza a tabela SX1 antes de abrir
// a caixa de perguntas (parametros) ao usuario.
_cPerg := "CMTA01    "
_aSX1 := {;
{_cPerg,"01","Exibe p/ comprador  ","Exibe p/ comprador  ","Exibe p/ comprador  ","mv_ch1","N",01,0,1,"C","","mv_par01","Sim","Si","Yes","","","Nao","No","No","","","","","","","","","","","","","","","","","","",""},;
{_cPerg,"02","Filtra SC atendida  ","Filtra SC atendida  ","Filtra SC atendida  ","mv_ch2","N",01,0,1,"C","","mv_par02","Sim","Si","Yes","","","Nao","No","No","","","","","","","","","","","","","","","","","","",""},;
{_cPerg,"03","Comprador           ","Comprador           ","Comprador           ","mv_ch3","C",20,0,1,"G","","mv_par03","","","","","","","","","","","","","","","","","","","","","","","","","USC","",""}}
AjustaSX1(_aSX1) // _FixSX.ch

// O bloco de comandos abaixo atualiza a tabela SXB antes de
// executar o programa.
_aSXb := {;
{"USC","1","01","US","Usuarios","Usuarios","Users",""},;
{"USC","5","01","","","","","NAME"}}
//AjustaSXB(_aSXb) // _FixSX.ch

// Exibe as perguntas ao usuario.
If Pergunte(_cPerg, .T.)
	
	// Considera os parametros digitados pelo usuario.
	_mFilComp := (mv_par01 == 1)
	_mFilFech := (mv_par02 == 1)
//	_cUser    := IIf(empty(mv_par03), SubStr(cUsuario, 7, 15), mv_par03)
	_cUser    := IIf(empty(mv_par03), cUserName, mv_par03)
	
	// Filtra por comprador.
	_cFilSC := IIf (_mFilComp, "(Upper(AllTrim(C1_SOLICIT)) == Upper(AllTrim('" + _cUser + "')))", "")
	
	// Filtra SC fechadas.
	_cFilSC += IIf (_mFilFech, IIf (!empty(_cFilSC), " .and. ", "") +;
	"(C1_QUJE != C1_QUANT .or. !U_cmata01a(C1_PEDIDO))", "")
	
	If !empty(_cFilSC)
		_cAreaSC1 := SC1->(GetArea())
		_cAlias   := Alias()
		dbSelectArea("SC1")
		// Set Filter to &_cFilSC
		// SC1->(dbSetFilter({|| &_cFilSC}, _cFilSC))
		bFiltraBrw := {|| FilBrowse("SC1", @aIndexSC1, @_cFilSC)}
		Eval(bFiltraBrw)
	Endif
	
	MATA110()  // Solicitacao de compras padrao do sistema.
	
	// Desativa o filtro.
	If !empty(_cFilSC)
		dbSelectArea("SC1")
		//Set Filter To
		//������������������������������������������������������������������������Ŀ
		//� Finaliza o uso da funcao FilBrowse e retorna os indices padroes.       �
		//��������������������������������������������������������������������������
		EndFilBrw("SC1", aIndexSC1)
		
		SC1->(RestArea(_cAreaSC1))
		dbSelectArea(_cAlias)
		// SC1->(dbClearFilter())
	Endif
Endif
Return


// Retorna .T. caso a SC ja tenha sido totalmente faturada.
User Function cmata01a(_cPedido)
Local _lRet, _aAreaC7
_aAreaC7 := SC7->(GetArea())
SC7->(dbSetOrder(1))

// Se existir o pedido relacionado a solicitacao e o pedido ja estiver
// totalmente entregue, retorna .T., caso contrario retorna .F.
_lRet := SC7->(dbSeek(xFilial("SC7") + _cPedido, .F.)) .and.;
(SC7->C7_QUANT - (SC7->C7_QUJE + SC7->C7_QTDACLA) <= 0)

SC7->(RestArea(_aAreaC7))
Return (_lRet)


/*/
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �MT110CON  � Autor � Felipe Raposo      � Data �  10/07/02   ���
�������������������������������������������������������������������������͹��
���Descricao � Valida se o usuario pode alterar a solicitacao de compra.  ���
���          � Ponto de entrada executado antes de gravar solicitacao de  ���
���          � compra (mata110 - SC1).                                    ���
���          �                                                            ���
�������������������������������������������������������������������������͹��
���Retorno   � .T. Grava normalmente as alteracoes.                       ���
���          � .F. Aborta a gravacao das alteracoes.                      ���
�������������������������������������������������������������������������͹��
���Uso       � CIEE.                                                      ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
/*/
User Function MT110CON
Local _lRet, _cMsg
// Nao verifica no caso de inclusao, somente de alteracao.
If !(_lRet := (CA110NUM != SC1->C1_NUM .or. VerUsr()))
	_cMsg := "Somente o pr�prio solicitante ou um usu�rio com esse privil�gio " +;
	"podem alterar a solicita��o de compra."
	MsgBox(OemToAnsi(_cMsg), OemToAnsi("Aten��o"))
Endif
Return (_lRet)


/*/
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �MSC1110D  � Autor � Felipe Raposo      � Data �  10/07/02   ���
�������������������������������������������������������������������������͹��
���Descricao � Filtra as solicitacoes de compras para o comprador.        ���
���          � Ponto de entrada executado antes de deletar solicitacao de ���
���          � compra (mata110 - SC1).                                    ���
���          �                                                            ���
�������������������������������������������������������������������������͹��
���Retorno   � .T. Permite a exclusao da solicitacao de compra.           ���
���          � .F. Aborta a exclusao da solicitacao de compra.            ���
�������������������������������������������������������������������������͹��
���Uso       � CIEE.                                                      ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
/*/
User Function MSC1110D
Local _lRet, _cMsg
If !(_lRet := VerUsr())
	_cMsg := "Somente o pr�prio solicitante ou um usu�rio com esse privil�gio " +;
	"podem excluir a solicita��o de compra."
	MsgBox(OemToAnsi(_cMsg), OemToAnsi("Aten��o"))
Endif
Return (_lRet)


/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Funcao    �VerUsr    �Autor  � Felipe Raposo      � Data �  10/07/02   ���
�������������������������������������������������������������������������͹��
���Descricao � Funcao para a validacao do usuario. Verifica se o usuario  ���
���          � logado pode ou nao alterar ou excluir uma SC.              ���
�������������������������������������������������������������������������͹��
���Retorno   � .T. caso o usuario esteja ok.                              ���
���          � .F. caso o usuario nao tenha privilegios.                  ���
���          �                                                            ���
�������������������������������������������������������������������������͹��
���Uso       � CIEE                                                       ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/
Static Function VerUsr()
Local _lRet, _cUsrAtu, _cUsrSC
_cUsrSC  := AllTrim(upper(SC1->C1_SOLICIT  + ", " + _cUsrAdm))
//_cUsrAtu := AllTrim(upper(SubStr(cUsuario, 7, 15)))
_cUsrAtu := AllTrim(upper(cUserName))
_lRet := (empty(upper(SC1->C1_SOLICIT)) .or. _cUsrAtu $ _cUsrSC)
//MsgBox(_cUsrSC)
//MsgBox(_cUsrAtu)
//MsgBox(IIf(_lRet, "T", "F"))
Return (_lRet)


/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �MT110LOK  �Autor  � Felipe Raposo      � Data �  12/20/02   ���
�������������������������������������������������������������������������͹��
���Desc.     � PROGRAMA....: MATA110                                      ���
���          � Ponto de entrada executado ao confirmar a inclusao da      ���
���          � solicitacao de compra.                                     ���
���          �                                                            ���
�������������������������������������������������������������������������͹��
���Uso       � CIEE                                                       ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/
User Function MT110LOK()
Local _lRet, _cMsg, _nAux1, _nPsProd, _nPsCC, _cProd, _cCCusco, _aAreaB1

// Localiza o posicionamento desses campos na matriz aCols.
_nPsProd := aScan(aHeader, {|x| AllTrim(x[2]) == "C1_PRODUTO"})
_nPsCC   := aScan(aHeader, {|x| AllTrim(x[2]) == "C1_CC"})

// Armazena as condicoes da tabela.
_aAreaB1 := SB1->(GetArea())

// Varre toda a matriz aCols conferindo se o produto eh de consumo
// e o centro de custo foi digitado.
SB1->(dbSetOrder(1))
_lRet := .T.
_cProd   := aCols[n, _nPsProd]
_cCCusco := aCols[n, _nPsCC]

// Verifica a linha. Se o produto for material de consumo
// e nao tiver centro de custo digitado, nao confirma.
If  !(_lRet := !(SB1->(dbSeek(xFilial("SB1") + _cProd, .F.)) .and.;
	SB1->B1_TIPO == "MC" .and. empty(_cCCusco)))
	_cMsg := "Digite um centro de custo para o produto " + AllTrim(SB1->B1_DESC)
	MsgAlert(_cMsg, OemToAnsi("Aten��o"))
Endif

// Retorna as condicoes anteriores da tabela.
SB1->(RestArea(_aAreaB1))
Return(_lRet)