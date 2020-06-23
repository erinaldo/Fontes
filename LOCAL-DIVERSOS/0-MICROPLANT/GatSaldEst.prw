#include 'protheus.ch'
#include 'parmtype.ch'

user function GatSaldEst(cProd,cLocal)

	Local nSaldo    := 0 //Saldo em Estoque
	Local aArea     := GetArea() //Area
	Local aAreaSB2  := SB2->(GetArea())
	Local nSaldoAtu := 0
	Local cProd     := ""
	Local nPosLocal := ""
	Local cLocal    := ""

	If IsInCallStack("MATA415")
		cProd	  := TMP1->CK_PRODUTO
		cLocal    := TMP1->CK_LOCAL
	Else
		cProd     := aCols[n,Ascan(aHeader,{|x| AllTrim(x[2]) == "C6_PRODUTO"})]
		nPosLocal := Ascan(aHeader,{|x| AllTrim(x[2]) == "C6_LOCAL"})
		cLocal    := aCols[n][nPosLocal]
	Endif


	SB2->( dbSetOrder(1) )
	If SB2->( dbSeek(xFilial("SB2") + cProd+cLocal ) )

		nSaldoAtu := SaldoSB2()

		If nSaldoAtu <= 0
			MsgInfo("(SALDOSB2)->Produto "+cProd+" no Armazem "+cLocal+" sem saldo ou com saldo negativo")
			Return nSaldoAtu
		Else
			If IsInCallStack("MATA415")
				TMP1->CK_XQTDSLD := nSaldoAtu
				TMP1->CK_XRESSLD := SB2->B2_RESERVA
			Else
				M->C6_XQTDEST := nSaldoAtu
			Endif
		Endif
	Else
		MsgInfo("(SB2)->Produto "+cProd+" no Armazem "+cLocal+" sem movimenta��o no estoque")
		Return nSaldoAtu
	Endif


	RestArea(aArea)
	RestArea(aAreaSB2)
Return nSaldoAtu