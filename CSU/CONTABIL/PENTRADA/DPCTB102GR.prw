#Include 'Rwmake.ch'

/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �DPCTB102GR�Autor  � Sergio Oliveira    � Data �  Set/2009   ���
�������������������������������������������������������������������������͹��
���          � Ponto de entrada no momento da gravacao do estorno ou da   ���
���Descricao � exclusao do lancamento contabil. Esta sendo utilizado para ���
���          � informar a hora para que no momento da execucao do relato- ���
���          � rio exporta razao esta informacao devera ser incluida.     ���
�������������������������������������������������������������������������͹��
���Uso       � CSU                                                        ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/

User Function DPCTB102GR()

Local cTxtBlq, cExec, nExec
Local cEol := Chr(13)+Chr(10)
Local _cArea := GetArea()

//                 1     2        3       4      5
// ParamIxb => { nOpc,dDatalanc,cLote,cSubLote,cDoc }

If ParamIxb[1] # 3 .And. ParamIxb[1] # 7
	
	DbSelectArea("CT2")

	cExec := " UPDATE "+RetSqlName('CT2')+" SET CT2_X_HRUP = '"+Time()+"', CT2_X_USRA = '"+Left(UsrFullName(__cUserID),30)+"', "
	cExec += " CT2_X_DTAL = '"+Dtos(Date())+"' "
	cExec += " WHERE CT2_FILIAL = '"+xFilial('CT2')+"' "
	cExec += " AND   CT2_DATA   = '"+Dtos(ParamIxb[2])+"' "
	cExec += " AND   CT2_LOTE   = '"+ParamIxb[3]+"' "
	cExec += " AND   CT2_SBLOTE = '"+ParamIxb[4]+"' "
	cExec += " AND   CT2_DOC    = '"+ParamIxb[5]+"' "
	//cExec += " AND   D_E_L_E_T_ = ' ' "
	
	nExec := TcSqlExec( cExec )
	
	If nExec # 0
		cTxtBlq := "Ocorreu um problema no momento da gravacao do campo referente a hora deste "
		cTxtBlq += "evento. Entre em contato com a area de Sistemas ERP informando a mensagem "
		cTxtBlq += "a seguir: "+cEol+cEol+TcSqlError()
		Aviso("Gravacao da Ocorrencia",cTxtBlq,;
		{"&Fechar"},3,"Campos de LOG",,;
		"PCOLOCK")
	EndIf
	
	CT2->(DbCloseArea())
	
EndIf

RestArea(_cArea)

Return