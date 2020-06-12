#INCLUDE "rwmake.ch"
/*/
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �GetXECus  � Autor � Felipe Raposo      � Data �  16/08/02   ���
�������������������������������������������������������������������������͹��
���Descricao �                                                            ���
���          �                                                            ���
�������������������������������������������������������������������������͹��
���Uso       � CIEE                                                       ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
/*/
User Function GetXECus(_cAlias, _cCampo, _cNivel)

//���������������������������������������������������������������������Ŀ
//� Declaracao de variaveis.                                            �
//�����������������������������������������������������������������������
_cTabXE := "XE"
_cTabXF := "XF"
Ver_XE_XF()  // Verifica se as tabelas existem no SX5 (cadastro de tabelas).

// Acerta o tamanho dos campos.
_cAlias := Transform(_cAlias, "@S3")
_cNivel := Transform(_cNivel, "@S2")

_cChave   := _cAlias + _cNivel + "A"
_nProxNum := Tabela(_cTabXE, _cChave)

// Se nao existir esse campo + nivel na tabela, cria.
If ValType(_nProxNum) == "N"
Endif
Return


Static Function Ver_XE_XF()
Begin Transaction
// Cria tabela XE.
If Tabela("00" + _cTabXE) == nil
	// Adiciona o cabecalho da tabela um.
	RecLock("SX5", .T.)
	SX5->X5_TABELA  := "00"
	SX5->X5_CHAVE   := _cTabXE
	SX5->X5_DESCRI  := "TABELA UM PARA AUTO NUMERACAO"
	SX5->X5_DESCSPA := "TABELA UM PARA AUTO NUMERACAO"
	SX5->X5_DESCENG := "TABELA UM PARA AUTO NUMERACAO"
	SX5->(msUnLock())
Endif
// Cria tabela XF.
If Tabela("00" + _cTabXF) == nil
	// Adiciona o cabecalho da tabela dois.
	RecLock("SX5", .T.)
	SX5->X5_TABELA  := "00"
	SX5->X5_CHAVE   := _cTabXF
	SX5->X5_DESCRI  := "TABELA DOIS PARA AUTO NUMERACAO"
	SX5->X5_DESCSPA := "TABELA DOIS PARA AUTO NUMERACAO"
	SX5->X5_DESCENG := "TABELA DOIS PARA AUTO NUMERACAO"
	SX5->(msUnLock())
Endif
End Transaction
Return