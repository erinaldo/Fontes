#INCLUDE "rwmake.ch"

/*/
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  � M030INC  � Autor � Leonardo Soncin    � Data �  17/10/06   ���
�������������������������������������������������������������������������͹��
���Descricao � Objetivo: Replicar as informacoes do centro de custo       ���
���          � incluidas alteradas ou excluidas nas empresa 02 para as    ���
���          � empresas 03,04,09 e 90                                     ���
�������������������������������������������������������������������������͹��
���Uso       � AP5 IDE                                                    ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������                                           
/*/

User Function M020ALT()

Local _aVariaveis  :={}
Local _aEmpresas   :={"01"}  // Para quais empresas serao copiadas as informacoes
Local _aArea       :=GetArea()
Local _nNumEmp     :=Len(_aEmpresas)
Local _cEmprAutor  :=GetNewPar("MV_EMPRMAE","05")    // Empresa escolhida como empresa mae para cadastramentos

If (Ascan(_aEmpresas,cEmpAnt) = 0) .And. (cEmpAnt # _cEmprAutor) // Verifica se a Empresa atual esta autorizada fazer inclus�es 
	Return .t.
Endif

DbSelectArea("SA2")
//��������������������������������������������������������������Ŀ
//� Carrega Variaveis de Memoria                                 �
//����������������������������������������������������������������
_nFCount :=FCount()

For i:=1 to _nFCount
	AADD(_aVariaveis,{FieldName(i),FieldGet(i)})
Next

For x:=1 To _nNumEmp
	_cEmpresa :="SA2"+_aEmpresas[x]+"0"
	
	DBUSEAREA(.T.,"TOPCONN",_cEmpresa,_cEmpresa,.T.)   
	TcCanOpen(_cEmpresa,_cEmpresa+"1")
	ORDLISTADD(_cEmpresa+"1")
	nPos := Ascan(_aVariaveis, {|aVal|aVal[1] == "A2_COD"})
	
	If !MsSeek(xFilial("SA2")+_aVariaveis[nPos,2])
		MsgAlert("O Fornecedor "+_aVariaveis[nPos,2]+" n�o existe no cadastro de fornecedores da empresa "+_aEmpresas[x]+". Contate o administrador.","ATEN��O")
    Else
		_nItens :=Len(_aVariaveis)
		Reclock(_cEmpresa,.F.)
		FOR i := 1 TO _nItens
			if ascan(_aVariaveis,{|_vAux|_vAux[1]==FieldName(i)}) # 0
				&(_aVariaveis[i,1]) := _aVariaveis[i,2]
			Endif
		NEXT i
		MsUnlock()
	Endif
	DbCloseArea()
Next

RestArea(_aArea)

Return .T.