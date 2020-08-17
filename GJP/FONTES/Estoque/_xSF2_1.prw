#Include 'Protheus.ch'
#include "TopConn.ch"
#include "Ap5Mail.ch"

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณ_XSF2_1   บAutor  ณMicrosiga           บ Data ณ  02/02/17   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ Ajuste ISS, PIS, COF RPS cujo o XML veio sem a informacao  บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบExecucao  ณ foi executado dia 02/02/2017                               บฑฑ
ฑฑบ          ณ executado novamente dia 02/06/2017                         บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑบUso       ณ GJP                                                        บฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

User Function _xSF2_1
          
Default lEnd := .F.

If msgyesno("Confirma atualiza็ใo do ISS/PIS/COFINS ?")
	//Processamento
	oProcess := MsNewProcess():New({|lEnd| GAJU01Exec(@oProcess, @lEnd) },"Atualizando a Base",.T.) 
	oProcess:Activate()
	msginfo("Processo Finalizado com Sucesso!")
Else
	alert("CANCELADO!!!")
	Return
EndIf
Return


Static Function GAJU01Exec()

_cQuery := "SELECT SF3.F3_NFISCAL, SF3.F3_SERIE, SF3.F3_CLIEFOR, SF3.F3_LOJA "
_cQuery += "FROM SF3040 SF3 "
_cQuery += "WHERE SF3.D_E_L_E_T_ = '' "
_cQuery += "AND SF3.F3_ESPECIE = 'RPS' "
_cQuery += "AND SF3.F3_ENTRADA BETWEEN '20170501' AND '20170531' "
_cQuery += "AND SF3.F3_VALCONT <> SF3.F3_BASEICM "
_cQuery += "ORDER BY SF3.F3_ENTRADA, SF3.F3_NFISCAL, SF3.F3_SERIE "
_cQuery := ChangeQuery(_cQuery)
dbUseArea(.T.,"TOPCONN",TcGenQry(,,_cQuery),"SF3TRB",.T.,.T.)

nCount := SF3TRB->(RecCount())
oProcess:SetRegua1(nCount)

Do While SF3TRB->(!EOF())


	If lEnd	//houve cancelamento do processo		
		Exit	
	EndIf	       	

	oProcess:IncRegua1("SF3 " )
	//---ISS---
	//D2_BASEISS
	//D2_VALISS
	//D2_ALIQISS
	_nTtBasIss	:= 0
	_nTtValIss	:= 0

	//---COFINS---
	//D2_BASIMP5
	//D2_VALIMP5
	//D2_ALQIMP5
	_nTtBsImp5	:= 0
	_nTtVlImp5	:= 0

	//---PIS---
	//D2_BASIMP6
	//D2_VALIMP6
	//D2_ALQIMP6
	_nTtBsImp6	:= 0
	_nTtVlImp6	:= 0

	//PROCESSA OS ITENS DA NOTA FISCAL DE SAIDA
	DbSelectArea("SD2")
	DbSetOrder(3)
	If DbSeek(xFilial("SD2")+SF3TRB->(F3_NFISCAL+F3_SERIE+F3_CLIEFOR+F3_LOJA))

		nCountSD2 := 1
		oProcess:SetRegua2(nCountSD2)
		
		Do While !EOF() .and. SF3TRB->(F3_NFISCAL+F3_SERIE+F3_CLIEFOR+F3_LOJA) == SD2->(D2_DOC+D2_SERIE+D2_CLIENTE+D2_LOJA)
		
			oProcess:IncRegua2("SD2 ")
			
			nCountSD2++

			If SD2->D2_BASEISS = 0
				Reclock("SD2",.F.)
				SD2->D2_BASEISS := SD2->D2_TOTAL
				SD2->D2_ALIQISS := 2
				SD2->D2_VALISS	:= ROUND((SD2->D2_TOTAL * 2)/100,2)

				SD2->D2_BASIMP5 := SD2->D2_TOTAL
	 			SD2->D2_ALQIMP5 := 3
				SD2->D2_VALIMP5 := ROUND((SD2->D2_TOTAL * 3)/100,2)

				SD2->D2_BASIMP6	:= SD2->D2_TOTAL
				SD2->D2_ALQIMP6 := 0.65
				SD2->D2_VALIMP6	:= ROUND((SD2->D2_TOTAL * 0.65)/100,2)

				MsUnLock()
				
				_nTtBasIss		+= SD2->D2_TOTAL
				_nTtValIss		+= ROUND((SD2->D2_TOTAL * 2)/100,2)
			
				_nTtBsImp5	+= SD2->D2_TOTAL
				_nTtVlImp5	+= ROUND((SD2->D2_TOTAL * 3)/100,2)

				_nTtBsImp6	+= SD2->D2_TOTAL
				_nTtVlImp6	+= ROUND((SD2->D2_TOTAL * 0.65)/100,2)
								
			Else
				_nTtBasIss		+= SD2->D2_BASEISS
				_nTtValIss		+= SD2->D2_VALISS
			
				_nTtBsImp5	+= SD2->D2_BASIMP5
				_nTtVlImp5	+= SD2->D2_VALIMP5

				_nTtBsImp6	+= SD2->D2_BASIMP6
				_nTtVlImp6	+= SD2->D2_VALIMP6
			EndIf

			SD2->(DbSkip())
		EndDo
	EndIf

	//PROCESSA O CABECALHO DA NOTA FISCAL DE SAIDA
	DbSelectArea("SF2")
	DbSetOrder(1)
	If DbSeek(xFilial("SF2")+SF3TRB->(F3_NFISCAL+F3_SERIE+F3_CLIEFOR+F3_LOJA))

		nCountSF2 := 1
		oProcess:SetRegua2(nCountSF2)

		Do While !EOF() .and. SF3TRB->(F3_NFISCAL+F3_SERIE+F3_CLIEFOR+F3_LOJA) == SF2->(F2_DOC+F2_SERIE+F2_CLIENTE+F2_LOJA)

			oProcess:IncRegua2("SF2 ")
			
			nCountSF2++

			RecLock("SF2",.F.)
			SF2->F2_BASEISS	:= IIF(_nTtBasIss > 0, _nTtBasIss, SF2->F2_BASEISS)
			SF2->F2_VALISS	:= IIF(_nTtValIss > 0, _nTtValIss, SF2->F2_VALISS)

			SF2->F2_BASIMP5	:= IIF(_nTtBsImp5 > 0, _nTtBsImp5, SF2->F2_BASIMP5)
			SF2->F2_VALIMP5 := IIF(_nTtVlImp5 > 0, _nTtVlImp5, SF2->F2_VALIMP5)

			SF2->F2_BASIMP6 := IIF(_nTtBsImp6 > 0, _nTtBsImp6, SF2->F2_BASIMP6)
			SF2->F2_VALIMP6 := IIF(_nTtVlImp6 > 0, _nTtVlImp6, SF2->F2_VALIMP6)
			
			SF2->F2_MENNOTA := "AJUSTE ISS/PIS/COFINS - 02-06-2017" //"AJUSTE ISS/PIS/COFINS - 02-02-2017"

			MsUnLock()
			
			SF2->(DbSkip())
		EndDo
	EndIf


	SF3TRB->(DbSkip())

EndDo

SF3TRB->(dbCloseArea())

Return