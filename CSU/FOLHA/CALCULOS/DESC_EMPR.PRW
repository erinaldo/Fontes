#INCLUDE "rwmake.ch"

User Function DESC_EMP()
/*ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณDESC_EMP  |Autor  ณ Sandra R. Prada    บ Data ณ  03/10/03   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบUso       ณ SIGAGPE                                                    บฑฑ
ฑฑบ 			        												  															บฑฑ
ฑฑบ Objetivo  Gerar o valor de empr้stimo com apenas o valor de 1 parcela บฑฑ
ฑฑบ           e nใo com o saldo existente em lan็aments futuros.          บฑฑ
ฑฑบ 			        												  															บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑบ 			        												  															บฑฑ
ฑฑบ AlexandreF - 21/02/07 - Passa a considerar a existencia do empr้stimo บฑฑ
ฑฑบ 			 com a verba '522'- Conforme solicitado por MARCIA no cha-			บฑฑ
ฑฑบ 			 mado interno da CSU numero 1016.			              						บฑฑ
ฑฑบ 			        												  															บฑฑ
ฑฑบ AlexandreF - 21/02/07 - Passa a considerar corretamente as verbas 510,บฑฑ
ฑฑบ 			 515 e 522, quando o funcionแrio tiver mais de um empr้s- 			บฑฑ
ฑฑบ 			 timo - Conforme solicitado por MARCIA no chamado interno 			บฑฑ
ฑฑบ 			 da CSU numero 1016.									  												บฑฑ
ฑฑบ 			        												  															บฑฑ
ฑฑบ AlexandreF - 22/02/07 - Passa a gerar corretamente o valor de uma par-บฑฑ
ฑฑบ 			 cela na rescisใo e nใo o saldo existente em valores futu-			บฑฑ
ฑฑบ 			 ros, Obs: somente para as verbas "510 / 515 / 522".	  				บฑฑ
ฑฑบ 			        												  															บฑฑ
ฑฑบ 			        												  															บฑฑ
ฑฑบ Silvano - 10/01/08 - validacao para nใo gerar as verbas quando o      บฑฑ
ฑฑบ 			 calculo for de rescisใo complementar.                        	บฑฑ
ฑฑบ 			        												  															บฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿*/

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
