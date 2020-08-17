#Include 'Protheus.ch'
#include "TopConn.ch"
#include "Ap5Mail.ch"

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³_XSF2_2   ºAutor  ³Microsiga           º Data ³  02/02/17   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ Ajuste ISS, PIS, COF RPS cujo o XML veio sem a informacao  º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ GJP                                                       º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

User Function _xSF2_2
          
Default lEnd := .F.

If msgyesno("Confirma atualização do PIS/COFINS TAXA TURISMO ?")
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

_cQuery := "SELECT SFT.FT_NFISCAL AS F3_NFISCAL , SFT.FT_SERIE AS F3_SERIE, SFT.FT_CLIEFOR AS F3_CLIEFOR, SFT.FT_LOJA AS F3_LOJA "
_cQuery += "FROM SFT040 SFT "
_cQuery += "WHERE SFT.D_E_L_E_T_ = '' "
_cQuery += "AND SFT.FT_PRODUTO = 'VHF61-29' "
_cQuery += "AND SFT.FT_ALIQPIS = 0.65 "
_cQuery += "AND SFT.FT_ALIQCOF = 3 "
_cQuery += "GROUP BY SFT.FT_NFISCAL, SFT.FT_SERIE, SFT.FT_CLIEFOR, SFT.FT_LOJA "
_cQuery += "ORDER BY SFT.FT_NFISCAL, SFT.FT_SERIE, SFT.FT_CLIEFOR, SFT.FT_LOJA "
_cQuery := ChangeQuery(_cQuery)
dbUseArea(.T.,"TOPCONN",TcGenQry(,,_cQuery),"SF3TRB",.T.,.T.)

nCount := SF3TRB->(RecCount())
oProcess:SetRegua1(nCount)

Do While SF3TRB->(!EOF())


	If lEnd	//houve cancelamento do processo		
		Exit	
	EndIf	       	

	oProcess:IncRegua1("SF3 " )

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
		
			oProcess:IncRegua2("SD2 NOTA--->"+ SF3TRB->(F3_NFISCAL) )
			
			nCountSD2++

			If ALLTRIM(SD2->D2_COD) = 'VHF61-29' .AND. SD2->D2_ALQIMP5 == 3
				Reclock("SD2",.F.)
				SD2->D2_BASIMP5 := SD2->D2_TOTAL
	 			SD2->D2_ALQIMP5 := 7.6
				SD2->D2_VALIMP5 := ROUND((SD2->D2_TOTAL * 7.6)/100,2)

				SD2->D2_BASIMP6	:= SD2->D2_TOTAL
				SD2->D2_ALQIMP6 := 1.65
				SD2->D2_VALIMP6	:= ROUND((SD2->D2_TOTAL * 1.65)/100,2)

				MsUnLock()
				
				_nTtBsImp5	+= SD2->D2_TOTAL
				_nTtVlImp5	+= ROUND((SD2->D2_TOTAL * 7.6)/100,2)

				_nTtBsImp6	+= SD2->D2_TOTAL
				_nTtVlImp6	+= ROUND((SD2->D2_TOTAL * 1.65)/100,2)
								
			Else
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
			SF2->F2_BASIMP5	:= IIF(_nTtBsImp5 > 0, _nTtBsImp5, SF2->F2_BASIMP5)
			SF2->F2_VALIMP5 := IIF(_nTtVlImp5 > 0, _nTtVlImp5, SF2->F2_VALIMP5)

			SF2->F2_BASIMP6 := IIF(_nTtBsImp6 > 0, _nTtBsImp6, SF2->F2_BASIMP6)
			SF2->F2_VALIMP6 := IIF(_nTtVlImp6 > 0, _nTtVlImp6, SF2->F2_VALIMP6)
			
			SF2->F2_MENNOTA := "AJUSTE PIS/COFINS - 16-02-2017"

			MsUnLock()
			
			SF2->(DbSkip())
		EndDo
	EndIf


	SF3TRB->(DbSkip())

EndDo

SF3TRB->(dbCloseArea())

Return