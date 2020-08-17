#Include 'Rwmake.ch'

/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �VAL_TRANSF|Autor  � Isamu Kawakami     � Data �  21/06/04   ���
�������������������������������������������������������������������������͹��
���Descricao �Ponto de Entrada que possibilita a inclusao de validacoes   ���
���          �nas Transferencias de Funcionarios                          ���
�������������������������������������������������������������������������͹��
���Uso       � EXCLUSIVO PARA CSU                                         ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/

User Function GP180MSG()

_aArea    := GetArea()
_FilDest  := cFilAte
_CCDest   := cCCuAte
_Valida   := .T.
_DataTra  := dDataTra
_MatDest  := cMatAte
_FilOrig  := cFilAnt
Private cFiltCTHs := ""  
Public _cUnidade, _cOper

//OS 1098/05 
//OS 0109/10 -  MANTER MATRICULA.
/*
If _FilOrig # _FilDest .and. Sra->Ra_Mat == _MatDest
	Alert("Nas Transferencias entre Filiais, a Matricula devera ser Alterada !!!")
	_Valida := .F.
Endif
*/
If Sra->Ra_Catfunc $ "E/G"
	_Valida := msgyesno("Voc� Est� Transferindo um Estagi�rio !!!. Verifique se a Nova Matricula � de Est�giario. CONFIRMA ??? ")
Endif

dBSelectArea("CTT")
dBSetOrder(1)
dBGoTop()
/*
dbSeek("  "+_CCDest)
If Ctt->Ctt_Fil # _FilDest
	ALERT("O Centro de Custo Destino nao pertence a essa Filial !!! Verifique o C.Custo Correto")
	_Valida := .F.
Endif

 */
dBSelectArea("SRE")
dBSetOrder(3)
dBGoTop()

dbSeek("05"+Sra->Ra_Filial+Sra->Ra_Mat+Dtos(dDataTra))

If Sre->Re_Data == _DataTra
	Alert("Ja existe Transferencia para esse Funcionario nessa Data !!! Verifique a Data Correta")
	_Valida := .F.
Endif

/*���������������������������������������������������������������������������Ŀ
� Sergio em Dez/2007:    Validacao dos bloqueios das entidades contabeis    �
�                        conforme o chamado 001214.                         �
� Sergio em Mar/2008:    Novo escopo: - Exibir a tela para digitar o Item   �
�                        e Classe de valor.                                 �
�����������������������������������������������������������������������������*/

If _Valida
	
	// Trazer somente a unidade e operacao passiveis de serem utilizadas conforme o CC
	// digitado atraves da funcao FiltCTT():
	
	// Sergio em 21/Jul/2008: Desabilitado conforme orientado pelo Sr. Marcos Milazo
	
	If GetNewPar( 'MV_X_BLQRH','1' ) == '1' // Fase I Ativa
		CTT->( DbSetOrder(1), DbSeek( xFilial('CTT')+_ccDest ) )
		_cContD := CTT->CTT_CCONTD
	Else
		_cContD := _ccDest
	EndIf
	
	cFiltCTHs := CTT->CTT_RGNV3
	FiltCTT('L')
	
	_lContinua := .f.
	oFont      := TFont():New("Tahoma",12,,,.T.,,,,,.F.) // Com Negrito
	_cUnidade  := Space(TamSX3('CTD_ITEM')[1])
	_cDescUni  := Space(TamSX3('CTD_DESC01')[1])
	_cOper     := Space(TamSX3('CTH_CLVL')[1])
	_cDescOper := Space(TamSX3('CTH_DESC01')[1])
	_cVldUni   := "Vazio().Or.( ExistCT('CTD',1)[1].And.( _cDescUni  := ExistCT('CTD',2)[2],.t. ) )"
	_cVldOpe   := "Vazio().Or.( ExistCT('CTH',1)[1].And.( _cDescOper := ExistCT('CTH',2)[2],.t. ) )"
	
	Define MsDialog oDlg_ Title "Transfer�ncia: "+_cContD+" - "+Posicione('CTT',1,xFilial('CTT')+_cContD,'CTT_DESC01') From 287,267 to 512,757 of oMainWnd Pixel
	@ 002,003 To 113,237
	@ 026,003 To 113,237
	@ 026,193 To 113,237
	@ 055,195 To 080,235
	
	@ 013,017 Say "   Informa��es complementares" Color 8388608 Object oMens1 Size 208,08
	@ 038,011 Say "Unidade"  Color 8388608 Object oMens2 Size 054,08
	@ 073,011 Say "Opera��o" Color 8388608 Object oMens3 Size 052,08
	@ 053,011 Get _cUnidade  F3 "CTD" Size 040,10 When .t. Valid( &_cVldUni )
	@ 053,054 Get _cDescUni  Size 137,10 When .f.
	@ 088,011 Get _cOper     F3 "CTH" Size 040,10 When .t. Valid( &_cVldOpe )
	@ 088,054 Get _cDescOper Size 137,10 When .f.
	@ 051,197 Button "_Prosseguir" Size 36,16 Action( &("IIF( VldTela(), ( _lContinua := .t., oDlg_:End() ), _lContinua := .f. ) ") )
	@ 071,197 Button "_Abandonar"  Size 36,16 Action( _Valida := .f., _lContinua := .t., oDlg_:End() )
	
	oMens1:ofont:=ofont
	oMens2:ofont:=ofont
	oMens3:ofont:=ofont
	
	Activate MsDialog oDlg_ Centered Valid( _lContinua )
	
	//
	
EndIf

FiltCTT('D')

RestArea(_aArea) //Retorna o ambiente inicial

Return(_Valida)

/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Funcao    � FiltCTT  �Autor  � Sergio Oliveira    � Data �  Jun/2008   ���
�������������������������������������������������������������������������͹��
���Desc.     � Funcao que liga ou desliga o filtro da unidade e operacao  ���
���          � conforme o Centro de Custo.                                ���
�������������������������������������������������������������������������͹��
���Uso       � Val_Transf.prw                                             ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/

Static Function FiltCTT(pcLigDes)

Local cFiltCTD, cFiltCTH

If pcLigDes == 'L'
	
	cFiltCTD := " CTD_FILIAL = '"+xFilial('CTD')+"' .And. SubStr( CTD_ITEM,1,2 ) = '"+Left(_cContD,2)+"' "
	
	DbSelectArea('CTD')
	Set Filter To &cFiltCTD
	
	CTD->( DbGoTop() )
	
	cFiltCTH := " CTH_FILIAL = '"+xFilial('CTH')+"' .And. CTH_CRGNV2 = '"+AllTrim(cFiltCTHs)+"' "
	
	DbSelectArea('CTH')
	If Left(_cContD,2) $ "03/04"
		Set Filter To &cFiltCTH
	Else
		cFiltCTH := " CTH_FILIAL = '"+xFilial('CTH')+"' .And. CTH_CLVL = '999999999' "
		Set Filter To &cFiltCTH
	EndIf
	
	CTH->( DbGoTop() )
	
Else
	DbSelectArea('CTD')
	Set Filter To
	
	DbSelectArea('CTH')
	Set Filter To
EndIf

Return

/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Funcao    � ExistCT  �Autor  � Sergio Oliveira    � Data �  Jun/2008   ���
�������������������������������������������������������������������������͹��
���Desc.     � Funcao que verifica a entidade passada no parametro.       ���
�������������������������������������������������������������������������͹��
���Uso       � Val_Transf.prw                                             ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/

Static Function ExistCT(pcEntidade, pnConsiste)

Local cCueri, cTxtBlq
Local cNextAlias := GetNextAlias()
Local cEntdd := &( ReadVar() )

cCueri := " SELECT "+pcEntidade+"_DESC01 "
cCueri += " FROM "+RetSqlNAme( pcEntidade )
cCueri += " WHERE "+pcEntidade+"_FILIAL = '"+xFilial(pcEntidade)+"' "
If pcEntidade == 'CTD'
	cCueri += " AND CTD_ITEM = '"+cEntDD+"' "
Else
	cCueri += " AND CTH_CLVL = '"+cEntDD+"' "
EndIf
cCueri += " AND  D_E_L_E_T_ = ' ' "

U_MontaView( cCueri, cNextAlias )

(cNextAlias)->( DbGoTop() )

If Empty( ( cNextAlias )->&(pcEntidade+"_DESC01 ") ) .And. pnConsiste == 1
	cTxtBlq := "C�digo inv�lido."
	Aviso("C�DIGO DE ENTIDADE INV�LIDA",cTxtBlq,;
	{"&Fechar"},3,"Digite um c�digo v�lido",,;
	"PCOLOCK")
EndIf

Return( { !Empty( ( cNextAlias )->&(pcEntidade+"_DESC01 ") ), ( cNextAlias )->&(pcEntidade+"_DESC01 ") } )

/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Funcao    � FiltOper �Autor  � Sergio Oliveira    � Data �  Set/2008   ���
�������������������������������������������������������������������������͹��
���Desc.     � Filtro na consulta padrao dos campos RA_ITEMD e RA_CLVLDB. ���
�������������������������������������������������������������������������͹��
���Uso       � Val_Transf.prw                                             ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/

User Function FiltOper()

Local cRgNv := ""
CTT->( DbSetOrder(1), DbSeek( xFilial('CTT')+M->RA_CC ) )
cRgNv := CTT->CTT_RGNV3

If GetNewPar( 'MV_X_BLQRH','1' ) == '1' // Fase I Ativa
	CTT->( DbSetOrder(1), DbSeek( xFilial('CTT')+M->RA_CC ) )
	_cContD := CTT->CTT_CCONTD
Else
	_cContD := M->RA_CC
EndIf

/*
cFiltCTD := " CTD_FILIAL = '"+xFilial('CTD')+"' .And. SubStr( CTD_ITEM,1,2 ) = '"+Left(_cContD,2)+"' "

DbSelectArea('CTD')
Set Filter To &cFiltCTD

CTD->( DbGoTop() )
*/

If "CTH" $ ReadVar()
	If Left(_cContD,2) $ "03/04"
		cFilt := " CTH_CRGNV2 = '"+AllTrim(cRgNv)+"' "
	Else
		cFilt := " CTH_CLVL = '999999999' "
	EndIf
Else
	cFilt := " SubStr( CTD->CTD_ITEM,1,2 ) = '"+Left(_cContD,2)+"' "
EndIf

Return( &cFilt )

/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Funcao    � VldTela  �Autor  � Sergio Oliveira    � Data �  Set/2008   ���
�������������������������������������������������������������������������͹��
���Desc.     � Valida o botao Prosseguir.                                 ���
�������������������������������������������������������������������������͹��
���Uso       � Val_Transf.prw                                             ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/

Static Function VldTela()

Local _lxRet   := .f.
Local cMsg     := '', cDepois := ' nao informado(s)'
Local cConta   := CriaVar("CT1_CONTA")

/*
�������1930/10: Validar a regra de amarracao de forma diferente porque a    �
�               CTBAmarra() nao tah funcionando.                            �
�����������������������������������������������������������������������������*/

_lxRet := U_VldCTBg( _cUnidade, _cContD, _cOper, Nil,Nil, .t. )

If !CTH->( DbSetOrder(1), DbSeek( xFilial('CTH')+_cOper ) ) .AND. !Empty(cFiltCTHs)
   Help(" ",1,"NOAMARRA01")
   _lxRet := .f.
EndIf

If Empty( _cUnidade )
    cMsg += "Unidade de Neg�cio"
EndIf   

If Empty(_cOper)
    cMsg   += IIF( Empty(_cUnidade)," e ","" )+"Opera��o"
EndIf

If !Empty( cMsg )
	Aviso("C�DIGO DE ENTIDADE INV�LIDA",cMsg+cDepois,;
	{"&Fechar"},3,"Digite um c�digo v�lido",,;
	"PCOLOCK")
    _lxRet := .f.
EndIf

Return( _lxRet )
