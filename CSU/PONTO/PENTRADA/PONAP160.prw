#include "TOPCONN.ch"
#include "rwmake.ch"
#include "protheus.ch"
#include "prtopdef.ch"

/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �PONAP160  �Autor  �Alexandre Eduardo   � Data �  09/10/2013 ���
�������������������������������������������������������������������������͹��
���Desc.     � Ponto de Entrada para troca de turno, quando houver troca  ���
���          � de turno fora do periodo do MV_PONMES, ele tamb�m vai      ���
���          � alterar os campos RA_REGRA e RA_TNOTRAB			          ���
�������������������������������������������������������������������������͹��
���Uso       � Troca de Turno - Ponto Eletronio                           ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/
User Function PONAP160

Local aArea  := GetArea()
Local nMesAtu
Local nAnoAtu
Private nAnoAnt
Private nMesAnt

fUltData(@nMesAnt,@nAnoAnt)

//If !lRodaPE
//RestArea(aArea)
//Return
//Endif

For nOk := 1 To Len( aCols )
	If !aCols[nOk][Len(aCols[nOk])] // Se nao estiver deletado considerar
		
		dDataPa  := aCols[nOk][GdFieldPos('PF_DATA')]
		cTnoPa   := aCols[nOk][GdFieldPos('PF_TURNOPA')]
		cSeqPa   := aCols[nOk][GdFieldPos('PF_SEQUEPA')]
		cRegraPa := aCols[nOk][GdFieldPos('PF_REGRAPA')]
		nMesAtu  := Month(dDataPa) 
		nAnoAtu  := Year(dDataPa)
		
		If nAnoAnt+1 == nAnoAtu
			
			If nMesAnt > nMesAtu //mes apontamento = 12 e data da transf = 01
				nMesAtu += 12
			Endif
			
		Endif
		
		If nAnoAnt+1 == nAnoAtu  .or. nAnoAnt == nAnoAtu
			
			If nMesAtu - nMesAnt <= 12
				
				RecLock("SRA",.F.)
				SRA->RA_TNOTRAB	:= cTnoPa
				SRA->RA_REGRA	:= cRegraPa
				SRA->RA_SEQTURN	:= cSeqPa
				SRA->RA_XENVALT	:= Space(8)
				MsUnlock()
				
				nMesAtu := 0
			Endif
			
		Else
			
			Loop
			
		Endif
		
		
	Endif
Next

RestArea(aArea)

Return


/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �FULTDATA  �Autor  �Isamu K             � Data �  29/04/2014 ���
�������������������������������������������������������������������������͹��
���Desc.     � Funcao que verificara a quantidade de periodos em aberto   ���
�������������������������������������������������������������������������͹��
���Uso       � Troca de Turno - Ponto Eletronio                           ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/
Static Function fUltData(nMesA,nAnoA)


Local cQr
//Local nMesAtual := Month(dDatabase)
Local nMesAnter
Local lRet      := .T.

cQr := " SELECT MAX(PO_DATAFIM) AS CDATAMAX "
cQr += " FROM "+RETSQLNAME("SPO")+" "
cQr += " WHERE "+RETSQLNAME("SPO")+".D_E_L_E_T_ <> '*' "

//�������������������������������������Ŀ
//� Verifica se nao esta aberto o alias �
//���������������������������������������
If Select("TPO") > 0
	DBSelectArea("TPO")
	DBCloseArea()
EndIf

dbUseArea(.T.,"TOPCONN", TCGENQRY(,,cQr),"TPO",.F.,.T.)

nMesAnt := Val(Subs(Tpo->cDataMax,5,2))
nAnoAnt := Val(Subs(Tpo->cDataMax,1,4))

//�������������������������������������������������������������������������������������Ŀ
//� Tratamento, caso o periodo aberto seja Out/Nov/Dez e a data base seja Jan/Fev/Mar   �
//���������������������������������������������������������������������������������������
//If nMesAnter > nMesAtual
//nMesAtual += 12
//Endif

//If nMesAtual - nMesAnter >= 2
//lRet := .F.
//Endif


Return
