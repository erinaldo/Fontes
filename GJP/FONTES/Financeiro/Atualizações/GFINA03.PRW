#INCLUDE 'Protheus.ch'

/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �InforNF   �Autor  �Lucas Riva Tsuda    � Data �  12/12/14   ���
�������������������������������������������������������������������������͹��
���Desc.     �Tela chamada pelo ponto de entrada MT490MNU para informar   ���
���          �o numero da NF  de cobran�a da comiss�o e vincular no SE3   ���
�������������������������������������������������������������������������͹��
���Uso       �Especifico GJP                                              ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/

User Function InforNF

Local aArea    := GetArea()
Local aAreaSE3 := SE3->(GetArea())  
Local aCpos    := {}
Local aCampos  := {}

Private aRotina     := {}
Private cMarca      := ""
Private cCadastro   := OemToAnsi("Controle de Comiss�es")

//+----------------------------------------------------------------------------
//| Atribui as variaveis de funcionalidades
//+----------------------------------------------------------------------------
aAdd( aRotina ,{"Pesquisar"  ,"AxPesqui()"   ,0,1})
aAdd( aRotina ,{"Informar NF","u_NFCOB(cMarca)",0,3})
aAdd( aRotina ,{"Legenda"   ,"u_xLegen()"  ,0,4})

//+----------------------------------------------------------------------------
//| Atribui as variaveis os campos que aparecerao no mBrowse()
//+----------------------------------------------------------------------------
aCpos := {"E3_XOK","E3_XNFCOB","E3_VEND","E3_SERIE","E3_NUM","E3_EMISSAO","E3_CODCLI","E3_LOJA","E3_BASE","E3_PORC","E3_COMIS","E3_DATA","E3_PREFIXO"}

dbSelectArea("SX3")
dbSetOrder(2)
For nI := 1 To Len(aCpos)
   dbSeek(aCpos[nI])
   aAdd(aCampos,{X3_CAMPO,"",Iif(nI==1,"",Trim(X3_TITULO)),Trim(X3_PICTURE)})
Next

//+----------------------------------------------------------------------------
//| Apresenta o MarkBrowse para o usuario
//+----------------------------------------------------------------------------
cMarca := GetMark()
MarkBrow("SE3","E3_XOK","SE3->E3_XNFCOB",aCampos,,cMarca,'U_AtulBox()',,,,"u_MarcaCaixa()")

RestArea(aArea)
RestArea(aAreaSE3)

Return     

/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �MARCABOX   �Autor  �Lucas Riva Tsuda   � Data �  12/04/14   ���
�������������������������������������������������������������������������͹��
���Desc.     �Marca o box com duplo click  							      ���
���          �                                                            ���
�������������������������������������������������������������������������͹��
���Uso       �Especifico GJP					                          ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/

User Function MarcaCaixa()

If IsMark("E3_XOK",cMarca )

	RecLock("SE3",.F.)
    SE3->E3_XOK := Space(2)
    MsUnLock()
    
Else

	RecLock("SE3",.F.)
    SE3->E3_XOK := cMarca
    MsUnLock()
	    
EndIf

Return .T.         

/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �AtuMark   �Autor  �Lucas Riva Tsuda    � Data �  12/04/14   ���
�������������������������������������������������������������������������͹��
���Desc.     �Atualiza Markbrowse				                          ���
���          �                										      ���
�������������������������������������������������������������������������͹��
���Uso       �Especifico GJP						                      ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/

User Function AtualBox()

MarkBRefresh()
              
Return 

/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �xLegenda  �Autor  �Lucas Riva Tsuda    � Data �  12/04/14   ���
�������������������������������������������������������������������������͹��
���Desc.     �Legenda das Comiss�es	                                      ���
���          �                                                            ���
�������������������������������������������������������������������������͹��
���Uso       �Especifico GJP						                      ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/

User Function xLegen()
Local aCor := {}

aAdd(aCor,{"BR_VERDE"   ,"NF n�o informada"})
aAdd(aCor,{"BR_VERMELHO","NF informada"})

BrwLegenda(cCadastro,OemToAnsi("Status"),aCor)

Return    


/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �NFCOB     �Autor  �Lucas Riva Tsuda    � Data �  12/12/14   ���
�������������������������������������������������������������������������͹��
���Desc.     �Faz a grava��o do numero da NF de cobran�a da comissao nos  ���
���          �registros do SE3                                            ���
�������������������������������������������������������������������������͹��
���Uso       �Especifico GJP                                              ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/

User Function NFCOB(cMark)     

Local aArea       := GetArea()
Local aAreaSE3    := SE3->(GetArea()) 
Local cAlias  	  := GetNextAlias()   
Local oDlg1       := Nil    
Local oValor
Local cNota       := Space(9)
Local nOpcA       := 0  

//While nOpcA <> 1   

	DEFINE MSDIALOG oDlg1 TITLE "Informe a NF de Cobran�a da Comiss�o" OF oMainWnd PIXEL FROM 0,0 TO 150,300
	
    @ 020, 015 SAY "Nota " OF oDlg1 PIXEL
	@ 019, 050 MSGET oValor VAR cNota /*Picture '@E 999,999.99'*/ When .T. Size 40,07 OF oDlg1 PIXEL	
	oValor:bRClicked := {||AllwaysTrue()}
	    
	DEFINE SBUTTON FROM 50, 60 TYPE 1 ACTION (nOpcA:=1,oDlg1:End()) ENABLE OF oDlg1
	
	ACTIVATE MSDIALOG oDlg1 CENTERED
			
//EndDo     
If Empty(cNota)

	Return
	
EndIf

cQuery := "SELECT * FROM " + RetSqlName("SE3")
cQuery += " WHERE E3_XOK = '" + cMark + "' AND D_E_L_E_T_ <> '*'"
cQuery += " ORDER BY E3_VEND"
cQuery := ChangeQuery(cQuery)        

dbUseArea( .T., "TOPCONN", TCGENQRY(,,cQuery),cAlias, .T., .F.)  

DbSelectArea(cAlias)
(cAlias)->(dbGotop()) 
While (cAlias)->(!EOF())  

    SE3->(DbSetOrder(2))
    If SE3->(MsSeek((cAlias)->(E3_FILIAL+E3_VEND+E3_PREFIXO+E3_NUM+E3_PARCELA)))
    
    	RecLock("SE3",.F.)        	
		SE3->E3_XNFCOB := cNota    	
    	SE3->(MsUnlock())
    
    EndIf
	     
	(cAlias)->(DbSkip())

EndDo

RestArea(aArea)
RestArea(aAreaSE3) 

Return