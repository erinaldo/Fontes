#include "rwmake.ch"

/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �CFINA52   �Autor  �Emerson Natali      � Data �  11/08/2008 ���
�������������������������������������������������������������������������͹��
���Desc.     � Tela (browse) da rotina de Fluxo de Caixa                  ���
���          �                                                            ���
�������������������������������������������������������������������������͹��
���Uso       � CIEE                                                       ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/

User Function CFINA52()

//Funcao abaixo retorna o numero do dia da semana
//1-Domingo
//2-Segunda
//3-Terca
//4-Quarta
//5-Quinta
//6-Sexta
//7-Sabado
//dow(ctod("09/08/08"))

Private cPrgCanc 	:= ""
Private aRotina 	:= {}
Private aCores	 	:= {}
Private cCadastro 	:= OemToAnsi("Fluxo de Caixa")

aAdd(aRotina, {"Pesquisar" 		, "AxPesqui"		, 0, 1})
aAdd(aRotina, {"Visualizar"		, "u_CFINA52a(2)"	, 0, 2})
aAdd(aRotina, {"Incluir"		, "AxInclui"		, 0, 3})
aAdd(aRotina, {"Alterar"		, "u_ValdFlx()"		, 0, 4})
aAdd(aRotina, {"Excluir"		, "u_ExcFlx()"		, 0, 5})
aAdd(aRotina, {"Acerto"			, "u_CFINA52a(3)"	, 0, 4})
aAdd(aRotina, {"Processar"		, "u_CFINA51"		, 0, 3})
aAdd(aRotina, {"Relatorios"		, "u_RelFlx"		, 0, 6})
aAdd(aRotina, {"Legenda"   		, "u_LEGFLX()"		, 0, 7})

aCores	:= {	{'ZZ_FLAG == "IMP" .and. ZZ_DEL == "DEL"' , 'BR_CANCEL'		},;
				{'ZZ_FLAG == "IMP" .and. ZZ_DEL == "   "' , 'BR_VERDE'		},;
				{'ZZ_FLAG == "MAN" .and. ZZ_DEL == "   "' , 'BR_AZUL'		},;
				{'ZZ_FLAG == "AJT" .and. ZZ_DEL == "   "' , 'BR_AMARELO'	}}

dbSelectArea("SZZ")
dbSetOrder(1)
dbGoTop()

mBrowse(6,1,22,74,"SZZ",,,,,,aCores)

Return


/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �CFINA40   �Autor  �Emerson Natali      � Data �  21/08/07   ���
�������������������������������������������������������������������������͹��
���Desc.     �                                                            ���
���          �                                                            ���
�������������������������������������������������������������������������͹��
���Uso       � AP                                                         ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/

User Function LEGFLX()

_aLeg := {	{"BR_VERDE" 	, "Importado"	},;
			{"BR_AZUL"    	, "Manual"		},;
			{"BR_AMARELO"  	, "Ajuste"		},;
			{"BR_CANCEL"  	, "Estornado"	}}

BrwLegenda(cCadastro, "Legenda", _aLeg)

Return

/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �CFINA52   �Autor  �Microsiga           � Data �  08/11/08   ���
�������������������������������������������������������������������������͹��
���Desc.     �                                                            ���
���          �                                                            ���
�������������������������������������������������������������������������͹��
���Uso       � AP                                                        ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/

User Function ValdFlx()

_lRet := .T.

If SZZ->ZZ_FLAG == "IMP" .or. SZZ->ZZ_FLAG == "AJT"
	_lRet := .F.
	MsgBox("Registro nao pode ser alterado pois o mesmo veio de importacao/ajuste!!!","Atencao")
Else
	AxAltera("SZZ",Recno(),4,,,,,)
EndIf

Return(_lRet)

/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �CFINA52   �Autor  �Microsiga           � Data �  08/11/08   ���
�������������������������������������������������������������������������͹��
���Desc.     �                                                            ���
���          �                                                            ���
�������������������������������������������������������������������������͹��
���Uso       � AP                                                        ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/

User Function ExcFlx()

_lRet := .T.

If SZZ->ZZ_FLAG == "IMP" .or. SZZ->ZZ_FLAG == "AJT"
	_lRet := .F.
	MsgBox("Registro nao pode ser deletado pois o mesmo veio de importacao/ajuste!!!","Atencao")
Else
	AxDeleta("SZZ", Recno(), 5)
EndIf

Return(_lRet)

/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �CFINA52   �Autor  �Microsiga           � Data �  06/05/07   ���
�������������������������������������������������������������������������͹��
���Desc.     �Chamada Relatorios Diversos Fluxo de Caixa (Crystal)        ���
���          �                                                            ���
�������������������������������������������������������������������������͹��
���Uso       � AP                                                         ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/

User Function RelFlx()

Local oOk   := LoadBitmap( GetResources(), "LBOK" )
Local oNo   := LoadBitmap( GetResources(), "LBNO" )
Local oDlg1

Private oLby1

lRet := .T.
/*
//Atualiza as informacoes alteradas pelo usuario
_fAtualiza()
//Atualiza as informacoes alteradas pelo usuario no arquivo ARQ4 
Fc030Gera(4,.T.)
//Atualiza as informacoes alteradas pelo usuario no arquivo ARQ5
Fc030Gera(5,.T.)
*/
aRel	:= {}

aAdd(aRel,{.F.,OemToAnsi("Relat�rio Fluxo de Caixa Detalhada"			)	})
aAdd(aRel,{.F.,OemToAnsi("Relat�rio por Semana"							)	})
aAdd(aRel,{.F.,OemToAnsi("Relat�rio Fluxo de Caixa Acumulado"  			)	})
aAdd(aRel,{.F.,OemToAnsi("Relat�rio Fluxo de Caixa Acum. Apresenta��o"	)	})
aAdd(aRel,{.F.,OemToAnsi("Relat�rio Acumulado MES x MES"				)	})
aAdd(aRel,{.F.,OemToAnsi("Relat�rio Programa Aprendiz"  				)	})

DEFINE MSDIALOG oDlg1 FROM  31,58 TO 300,500 TITLE "Qual Relatorio Gerencial do Fluxo Deseja Imprimir?" PIXEL
@ 05,05 LISTBOX oLby1 FIELDS HEADER "","Relatorios Fluxo de Caixa" SIZE 215, 85 OF oDlg1 PIXEL ON DBLCLICK (U_MARK_REL())
	
oLby1:SetArray(aRel)
oLby1:bLine := { || {If(aRel[oLby1:nAt,1],oOk,oNo),aRel[oLby1:nAt,2] } }
oLby1:nFreeze  := 1
	
DEFINE SBUTTON FROM 94, 150 TYPE 1  ENABLE OF oDlg1 ACTION Processa({||  U_Exec_Rel() },"Processando Relatorio...")
DEFINE SBUTTON FROM 94, 190 TYPE 2  ENABLE OF oDlg1 ACTION (lRet :=.F.,oDlg1:End())
//DEFINE SBUTTON FROM 94, 190 TYPE 2  ENABLE OF oDlg1 ACTION _fFechaTela(oDlg1)
	
ACTIVATE MSDIALOG oDlg1 CENTERED

Return()

/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �CFINA41   �Autor  �Microsiga           � Data �  04/22/08   ���
�������������������������������������������������������������������������͹��
���Desc.     �                                                            ���
���          �                                                            ���
�������������������������������������������������������������������������͹��
���Uso       � AP                                                         ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/

User Function Exec_Rel()

//cParams := ""
//cOpcoes		:= "1;0;1;Relatorios Fluxo de Caixa"

If     aRel[oLby1:nAt,1] .and. oLby1:nAt == 1
	u_CFINR53(1)
ElseIf aRel[oLby1:nAt,1] .and. oLby1:nAt == 2
	u_CFINR53(2)
ElseIf aRel[oLby1:nAt,1] .and. oLby1:nAt == 3
	u_CFINR54(3)
ElseIf aRel[oLby1:nAt,1] .and. oLby1:nAt == 4
	u_CFINR54(4)
ElseIf aRel[oLby1:nAt,1] .and. oLby1:nAt == 5
	u_CFINR54(5)
ElseIf aRel[oLby1:nAt,1] .and. oLby1:nAt == 6
	u_CFINR55(5)
EndIf

/*
ElseIf aRel[oLby1:nAt,1] .and. oLby1:nAt == 2
	CALLCRYS("CRY042", cParams, cOpcoes)
*/

Return

/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �CFINA41   �Autor  �Microsiga           � Data �  04/22/08   ���
�������������������������������������������������������������������������͹��
���Desc.     �                                                            ���
���          �                                                            ���
�������������������������������������������������������������������������͹��
���Uso       � AP                                                        ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/

User Function MARK_REL()

If aRel[oLby1:nAt,1]
	aRel[oLby1:nAt,1] := .F.
Else
	For _nI := 1 to Len(aRel)
		aRel[_nI,1] := .F.	
	Next _nI
	aRel[oLby1:nAt,1] := .T.
EndIf
oLby1:Refresh(.T.)

Return
    
User Function CF52VldVl()
Local lRet:=.T.
Local aArea:=GetArea()
                 
If M->ZZ_VALOR<0
	dbSelectArea('SED')
	dbSetOrder(1)
	If dbSeek(xFilial('SED')+M->ZZ_NATUREZ) 
	     If !(AllTrim(ED_TIPO) == "2" .and. ED_COND=="D")               
	     	Alert('Valor n�o pode ser negativo para essa natureza.')
	     	lRet:=.F.
	     EndIf
	EndIf           
EndIf  
RestArea(aArea)
Return(lRet)         


User Function CF52GatVl()
Local _nVl:=M->ZZ_VALOR
Local aArea:=GetArea()

dbSelectArea('SED')
dbSetOrder(1)
If dbSeek(xFilial('SED')+M->ZZ_NATUREZ) 
     If AllTrim(ED_TIPO) == "2" .and. ED_COND=="D"               
     	_nVl:=Abs(M->ZZ_VALOR)*-1
	EndIf           
EndIf          
RestArea(aArea)
Return(_nVl)