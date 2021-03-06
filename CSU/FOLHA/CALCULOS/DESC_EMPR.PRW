#INCLUDE "rwmake.ch"

User Function DESC_EMP()
/*���������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �DESC_EMP  |Autor  � Sandra R. Prada    � Data �  03/10/03   ���
�������������������������������������������������������������������������͹��
���Uso       � SIGAGPE                                                    ���
��� 			        												  															���
��� Objetivo  Gerar o valor de empr�stimo com apenas o valor de 1 parcela ���
���           e n�o com o saldo existente em lan�aments futuros.          ���
��� 			        												  															���
�������������������������������������������������������������������������ͼ��
��� 			        												  															���
��� AlexandreF - 21/02/07 - Passa a considerar a existencia do empr�stimo ���
��� 			 com a verba '522'- Conforme solicitado por MARCIA no cha-			���
��� 			 mado interno da CSU numero 1016.			              						���
��� 			        												  															���
��� AlexandreF - 21/02/07 - Passa a considerar corretamente as verbas 510,���
��� 			 515 e 522, quando o funcion�rio tiver mais de um empr�s- 			���
��� 			 timo - Conforme solicitado por MARCIA no chamado interno 			���
��� 			 da CSU numero 1016.									  												���
��� 			        												  															���
��� AlexandreF - 22/02/07 - Passa a gerar corretamente o valor de uma par-���
��� 			 cela na rescis�o e n�o o saldo existente em valores futu-			���
��� 			 ros, Obs: somente para as verbas "510 / 515 / 522".	  				���
��� 			        												  															���
��� 			        												  															���
��� Silvano - 10/01/08 - validacao para n�o gerar as verbas quando o      ���
��� 			 calculo for de rescis�o complementar.                        	���
��� 			        												  															���
�����������������������������������������������������������������������������
����������������������������������������������������������������������������*/

// Declaracao das Variaveis

SetPrvt("_nVal510,_nVal515,_nVal522")

_nVal510 := 0
_nVal515 := 0
_nVal522 := 0


DbSelectArea("SRK")
DbSetOrder(1)

If cCompl	<> "S"
	If DbSeek(XFILIAL("SRG") + M->RG_MAT + "510") .AND. Srk->Rk_ValorTo > Srk->Rk_VlrPago
		_nVal510 := SRK->RK_VALORPA
	Endif
	
	If DbSeek(XFILIAL("SRG") + M->RG_MAT + "515") .AND. Srk->Rk_ValorTo > Srk->Rk_VlrPago
		_nVal515 := SRK->RK_VALORPA
	Endif
	
	If DbSeek(XFILIAL("SRG") + M->RG_MAT + "522") .AND. Srk->Rk_ValorTo > Srk->Rk_VlrPago
		_nVal522 := SRK->RK_VALORPA
	Endif
Endif

If _nVal510 # 0
	FDELPD('510',,)     // Deleta verba 510 com o saldo de val futuros calculado conforme roteiro 00460
	fGeraVerba('510',_nVal510,,,,,,,,,.T.)
Endif

If _nVal515 # 0
	FDELPD('515',,)     // Deleta verba 515 com o saldo de val futuros calculado conforme roteiro 00460
	fGeraVerba('515',_nVal515,,,,,,,,,.T.)
Endif

If _nVal522 # 0
	FDELPD('522',,)     // Deleta verba 522 com o saldo de val futuros calculado conforme roteiro 00460
	fGeraVerba('522',_nVal522,,,,,,,,,.T.)
Endif

Return(" ")
