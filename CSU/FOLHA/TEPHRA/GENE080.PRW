#INCLUDE "protheus.ch"
#INCLUDE "topconn.ch"

/*/
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  � PNA08001 � Autor � Isamu K.           � Data � 28/12/2015  ���
�������������������������������������������������������������������������͹��
���Descricao � Ponto de entrada que carrega as variaveis publicas que     ���
���          � servir�o para buscar informa��es na query                  ���
�������������������������������������������������������������������������͹��
���Uso       � Exclusivo da CSU                                           ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
/*/
User Function PNA08001

Public PonaFil := ""
Public PonaTno := ""


PonaFil := cFilSr6
PonaTno := cTnoSR6


Return(.T.)

/*/
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �CSPONA080 � Autor � Isamu K.           � Data � 11/11/2015  ���
�������������������������������������������������������������������������͹��
���Descricao � Rotina que ser� acionada no menu SIGAPON em substitui��o   ���
���          � ao original PONA080 que fara o preenchimento da ZP5        ���
�������������������������������������������������������������������������͹��
���Uso       � Exclusivo da CSU                                           ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
/*/
User Function CSPONA080

PONA080()

fAtuZP5()

Return


/*/
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  � FATUZP5  � Autor � Isamu K.           � Data � 11/11/2015  ���
�������������������������������������������������������������������������͹��
���Descricao � Atualizar� a tabela ZP5.                                   ���
���          �                                                            ���
�������������������������������������������������������������������������͹��
���Uso       � Exclusivo da CSU                                           ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
/*/
Static Function fAtuZp5

Local cQr   := ""
Local aArea := GetArea()

cQr := "SELECT * "
cQr += "FROM "+RetSQLName("SPJ")+" SPJ "
cQr += "WHERE SPJ.PJ_FILIAL = '"+PonaFil+"' "
cQr += "AND SPJ.PJ_TURNO = '"+PonaTno+"' "
cQr += "AND SPJ.D_E_L_E_T_ <> '*'"

If Select("WSPJ") > 0
	WSPJ->(dbCloseArea())
Endif

dbUseArea(.T.,"TOPCONN", TCGENQRY(,,cQr),"WSPJ",.T.,.F.)

dbSelectArea("WSPJ")
dbGotop()

While WSpj->(!Eof())
	
	dbSelectArea("ZP5")
	dbSetOrder(1)
	
	If dbSeek(WSpj->(Pj_Filial+Pj_Turno+Pj_Semana+Pj_Dia))
		RecLock("ZP5",.F.)
	Else
		RecLock("ZP5",.T.)
	Endif
	
	Zp5->Zp5_Filial := WSpj->Pj_Filial
	Zp5->Zp5_Turno  := WSpj->Pj_Turno
	Zp5->Zp5_Semana := WSpj->Pj_Semana
	Zp5->Zp5_Dia    := WSpj->Pj_Dia
	Zp5->Zp5_TpDia  := WSpj->Pj_TpDia
	Zp5->Zp5_Hormen := WSpj->Pj_Hormeno
	Zp5->Zp5_Entra1 := WSpj->Pj_Entra1
	Zp5->Zp5_Saida1 := WSpj->Pj_Saida1
	Zp5->Zp5_Entra2 := WSpj->Pj_Entra2
	Zp5->Zp5_Saida2 := WSpj->Pj_Saida2
	Zp5->Zp5_Entra3 := WSpj->Pj_Entra3
	Zp5->Zp5_Saida3 := WSpj->Pj_Saida3
	Zp5->Zp5_Entra4 := WSpj->Pj_Entra4
	Zp5->Zp5_Saida4 := WSpj->Pj_Saida4
	Zp5->Zp5_Hormai := WSpj->Pj_HorMais
	Zp5->Zp5_CodRef := WSpj->Pj_CodRef
	Zp5->Zp5_TpExt  := WSpj->Pj_TpExt
	Zp5->Zp5_TpExtn := WSpj->Pj_TpExtN
	Zp5->Zp5_NonaHo := WSpj->Pj_NonaHor
	Zp5->Zp5_Interv := WSpj->Pj_Interv1
	Zp5->Zp5_Inter2 := WSpj->Pj_Interv2
	Zp5->Zp5_Inter3 := WSpj->Pj_Interv3
	Zp5->Zp5_Jnd1Co := WSpj->Pj_Jnd1Con
	Zp5->Zp5_Jnd2Co := WSpj->Pj_Jnd2Con
	Zp5->Zp5_Jnd3Co := WSpj->Pj_Jnd3Con
	Zp5->Zp5_Jnd4Co := WSpj->Pj_Jnd4Con
	Zp5->Zp5_HrInt1 := WSpj->Pj_HrSInt1
	Zp5->Zp5_HrInt2 := WSpj->Pj_HrSInt2
	Zp5->Zp5_HrInt3 := WSpj->Pj_HrSInt3
	Zp5->Zp5_HrTrab := WSpj->Pj_HrsTrab
	Zp5->Zp5_HrTra2 := WSpj->Pj_HrsTra2
	Zp5->Zp5_HrTra3 := WSpj->Pj_HrsTra3
	Zp5->Zp5_HrTra4 := WSpj->Pj_HrsTra4
	Zp5->Zp5_HrTot  := WSpj->Pj_HrTotal
	Zp5->Zp5_NMarcs := WSpj->Pj_NMarcs
	Zp5->Zp5_IntSre := WSpj->Pj_IntSrep
	Zp5->Zp5_RhExp  := WSpj->Pj_RhExp
	Zp5->Zp5_Moutdi := WSpj->Pj_Moutdia
	Zp5->Zp5_Status := "0"
	
	Zp5->(msUnlock())
	
	WSpj->(dbSkip())
	
EndDo

RestArea(aArea)

Return
