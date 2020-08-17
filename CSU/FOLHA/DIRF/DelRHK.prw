
User function DelRHK()

Local nCont := 0

RHK->(dbgotop())

While RHK->(!eof())

	If SRA->(dbseek(RHK->(RHK_FILIAL+RHK_MAT)))
	
		If  ( RHK->RHK_TPFORN == '1' .and. RHK->RHK_PLANO <> SRA->RA_ASMEDIC ) .or. ;
			( RHK->RHK_TPFORN == '2' .and. RHK->RHK_PLANO <> SRA->RA_ASODONT )			
			
			Reclock("RHK",.f.)
			RHK->(dbDelete())
			RHK->(MsUnLock())
			nCont++
			
		EndIf
		
	EndIF
		
	RHK->(dbskip())
		
EndDo

Alert("RHK - Duplicidades deletadas: "+strzero(nCont,6))

Return
			

