#INCLUDE "protheus.ch"
#INCLUDE "topconn.ch"
#DEFINE          cEol         CHR(13)+CHR(10)

/*/
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  � FCARGAZP5� Autor � Isamu K.           � Data � 23/12/2015  ���
�������������������������������������������������������������������������͹��
���Descricao � Carga inicial da tabela SZ%, a partir das informa��es da   ���
���          � tabela SPJ                                                 ���
�������������������������������������������������������������������������͹��
���Uso       � Exclusivo da CSU                                           ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
/*/

User Function fCargaZP5

Local bProcesso

Private cCadastro  := "CARGA INICIAL DA TABELA ZP5, A PARTIR DA TABELA SPJ   "
Private cStartPath := GetSrvProfString("StartPath","")
Private cDescricao
Private nContad    := 0

bProcesso := {|oArq| fProc1( oArq )}

cDescricao := "Este programa ir� realizar a carga inicial da tabela ZP5    " + Chr(13) + Chr(10)
cDescricao += "a partir de informa��es da tabela SPJ.                      "

tNewProcess():New( "SPJ" , cCadastro , bProcesso , cDescricao ,,,,,,.T.,.F. )

Return

/*/
�����������������������������������������������������������������������������
����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Fun��o    � RUNCONT  � Autor � AP5 IDE            � Data �  15/08/07   ���
�������������������������������������������������������������������������͹��
���Descri��o � Funcao auxiliar chamada pela PROCESSA.  A funcao PROCESSA  ���
���          � monta a janela com a regua de processamento.               ���
�������������������������������������������������������������������������͹��
���Uso       � Programa principal                                         ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
/*/
Static Function fProc1( oArq )

Local nContad   := 0


dbSelectArea("SPJ")
dbGotop()

While Spj->(!Eof())
	
	nContad++
	
	oArq:IncRegua1( "Processando Registros -> " + StrZero(nContad,8) )
	
	dbSelectArea("ZP5")
	dbSetOrder(1)
	
	If dbSeek(Spj->(Pj_Filial+Pj_Turno+Pj_Semana+Pj_Dia))
		RecLock("ZP5",.F.)
	Else
		RecLock("ZP5",.T.)
	Endif
	
	Zp5->Zp5_Filial := Spj->Pj_Filial
	Zp5->Zp5_Turno  := Spj->Pj_Turno
	Zp5->Zp5_Semana := Spj->Pj_Semana
	Zp5->Zp5_Dia    := Spj->Pj_Dia
	Zp5->Zp5_TpDia  := Spj->Pj_TpDia
	Zp5->Zp5_Hormen := Spj->Pj_Hormeno
	Zp5->Zp5_Entra1 := Spj->Pj_Entra1
	Zp5->Zp5_Saida1 := Spj->Pj_Saida1
	Zp5->Zp5_Entra2 := Spj->Pj_Entra2
	Zp5->Zp5_Saida2 := Spj->Pj_Saida2
	Zp5->Zp5_Entra3 := Spj->Pj_Entra3
	Zp5->Zp5_Saida3 := Spj->Pj_Saida3
	Zp5->Zp5_Entra4 := Spj->Pj_Entra4
	Zp5->Zp5_Saida4 := Spj->Pj_Saida4
	Zp5->Zp5_Hormai := Spj->Pj_HorMais
	Zp5->Zp5_CodRef := Spj->Pj_CodRef
	Zp5->Zp5_TpExt  := Spj->Pj_TpExt
	Zp5->Zp5_TpExtn := Spj->Pj_TpExtN
	Zp5->Zp5_NonaHo := Spj->Pj_NonaHor
	Zp5->Zp5_Interv := Spj->Pj_Interv1
	Zp5->Zp5_Inter2 := Spj->Pj_Interv2
	Zp5->Zp5_Inter3 := Spj->Pj_Interv3
	Zp5->Zp5_Jnd1Co := Spj->Pj_Jnd1Con
	Zp5->Zp5_Jnd2Co := Spj->Pj_Jnd2Con
	Zp5->Zp5_Jnd3Co := Spj->Pj_Jnd3Con
	Zp5->Zp5_Jnd4Co := Spj->Pj_Jnd4Con
	Zp5->Zp5_HrInt1 := Spj->Pj_HrSInt1
	Zp5->Zp5_HrInt2 := Spj->Pj_HrSInt2
	Zp5->Zp5_HrInt3 := Spj->Pj_HrSInt3
	Zp5->Zp5_HrTrab := Spj->Pj_HrsTrab
	Zp5->Zp5_HrTra2 := Spj->Pj_HrsTra2
	Zp5->Zp5_HrTra3 := Spj->Pj_HrsTra3
	Zp5->Zp5_HrTra4 := Spj->Pj_HrsTra4
	Zp5->Zp5_HrTot  := Spj->Pj_HrTotal
	Zp5->Zp5_NMarcs := Spj->Pj_NMarcs
	Zp5->Zp5_IntSre := Spj->Pj_IntSrep
	Zp5->Zp5_RhExp  := Spj->Pj_RhExp
	Zp5->Zp5_Moutdi := Spj->Pj_Moutdia
	Zp5->Zp5_Status := "0"
	
	Zp5->(MsUnlock())
	
	Spj->(dbSkip())
	
EndDo

Alert("CARGA INICIAL DA TABELA ZP5 CONCLUIDO !!!")

Return