#INCLUDE "Protheus.ch" 
#include "topconn.ch"

/*/
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �ATUDIRF11 � Autor � RENATO cARLOS      � Data �  16/02/10   ���
�������������������������������������������������������������������������͹��
���Descricao �                     ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
/*/
USER FUNCTION ATUDIRF11()

Processa( { || ProcQry() }, "Efetuando Update" )

Return

/*/
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �ProcQry   � Autor � RENATO cARLOS      � Data �  16/02/10   ���
�������������������������������������������������������������������������͹��
���Descricao �                     ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
/*/


Static Function ProcQry

Local _cAlias := "DIRF11"
Local _AreaAnt:= GetArea()
Local nCont   := 0
Local _cQuery := ""
Local _Perg   := "CSATDIRF"

ValidPerg( _Perg)

Pergunte(_Perg,.T.)

DbSelectArea("SRB")
DbSetOrder(1)
DbGotop()

If Select(_cAlias) >0
	DBSelectArea(_cAlias)
	DBCloseArea()
EndIf

_cQuery := "SELECT RA_FILIAL,RA_MAT,RA_ASMEDIC,RA_ASODONT FROM "+RetSqlName("SRA")+" "
_cQuery += "WHERE D_E_L_E_T_ <> '*' "
_cQuery += "AND RA_FILIAL = '"+MV_PAR01+"'"
_cQuery += "GROUP BY RA_FILIAL,RA_MAT,RA_ASMEDIC,RA_ASODONT "
_cQuery += "ORDER BY RA_FILIAL,RA_MAT "  
_cQuery := ChangeQuery(_cQuery)

//���������������Ŀ
//�Executa a Query�
//�����������������
dbUseArea(.T.,"TOPCONN",TcGenQry(,,_cQuery),_cAlias)
//TCQUERY _cQuery NEW ALIAS _cAlias

ProcRegua( (_cAlias)->( RecCount() ) )

While (_cAlias)->(!EOF())
	IncProc((_cAlias)->RA_FILIAL+" "+(_cAlias)->RA_MAT)
	If SRB->(DbSeek((_cAlias)->RA_FILIAL+(_cAlias)->RA_MAT))
		While SRB->RB_FILIAL+SRB->RB_MAT == (_cAlias)->RA_FILIAL+(_cAlias)->RA_MAT
			If SRB->RB_ASSIMED <> 'N' .AND. EMPTY(SRB->RB_CODAMED)
				RecLock('SRB',.F.)
				SRB->RB_CODAMED := (_cAlias)->RA_ASMEDIC
				SRB->(MsUnLock())
			EndIf
			If SRB->RB_ODONTO <> 'N' .AND. EMPTY(SRB->RB_ASODONT)
				RecLock('SRB',.F.)
				SRB->RB_ASODONT := (_cAlias)->RA_ASODONT
				SRB->(MsUnLock())
			EndIf
			SRB->(dBSkip())		
		EndDo	
    EndIf
     
     (_cAlias)->(DbSkip())
     nCont++
EndDo

If Select(_cAlias) >0
	DBSelectArea(_cAlias)
	DBCloseArea()
EndIf

RestArea(_AreaAnt)

MsgStop("Atualiza��o conclu�da, favor validar os cadastros"+"  "+str(nCont))

Return

/*/
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Fun��o    � VALIDPERG� Autor � Adalberto Althoff  � Data �  15/09/04   ���
�������������������������������������������������������������������������͹��
���Descri��o � Funcao auxiliar, VALIDADA PARA AP7                         ���
���          �                                                            ���
�������������������������������������������������������������������������͹��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
/*/

Static Function ValidPerg(Pg)

_sAlias := Alias()

dbSelectArea("SX1")
dbSetOrder(1)
_cPerg := PADR(Pg,LEN(SX1->X1_GRUPO))
aRegs:={}

aAdd(aRegs,{_cPerg,"01","Filial       ","","","mv_ch1","C",02,0,0,"G","            ","mv_par01","         ","","","","","         ","","","","","","","","","","","","","","","","","","","","","","          "})


For i:=1 to Len(aRegs)
	If !dbSeek(_cPerg+aRegs[i,2])
		RecLock("SX1",.T.)     //RESERVA DENTRO DO BANCO DE PERGUNTAS
		For j:=1 to FCount()
			If j <= Len(aRegs[i])
				FieldPut(j,aRegs[i,j])
			Endif
		Next
		MsUnlock()    //SALVA O CONTEUDO DO ARRAY NO BANCO
	Endif
Next

dbSelectArea(_sAlias)

Pergunte(Pg,.F.)

Return

