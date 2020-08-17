
User Function AjRHK_()

RHK->(dbgotop())

While RHK->(!eof())
	
	If RHK->RHK_TPFORN == '1'   .and. RHK->RHK_PLANO $ ("27/35/36/37")
		
		If SRA->(dbseek(RHK->(RHK_FILIAL+RHK_MAT)))
			
			RecLock("RHK",.f.)
			
			RHK->RHK_PERINI	:= if(!empty(SRA->RA_MDDTIN),strzero(month(SRA->RA_MDDTIN),2)+strzero(year(SRA->RA_MDDTIN),4),RHK->RHK_PERINI)
			RHK->RHK_PERFIM := if(!empty(SRA->RA_MDDTEX),strzero(month(SRA->RA_MDDTEX),2)+strzero(year(SRA->RA_MDDTEX),4),"")
			RHK->RHK_CRTIN_	:= SRA->RA_CTRINTE
			//RHK->RHK_MATIN_	:= SRA->RA_MATINTE
			RHK->RHK_MATIN_	:= "8941" + SRA->RA_CIC + "00"
			
			If !empty(RHK->RHK_PERFIM) .and. right(RHK->RHK_PERFIM,4)+left(RHK->RHK_PERFIM,2) < right(RHK->RHK_PERINI,4)+left(RHK->RHK_PERINI,2)
				RHK->RHK_PERINI	:= RHK->RHK_PERFIM
			EndIf
			
			RHK->(MsUnLock())
			
		EndIF
		
	ElseIf RHK->RHK_TPFORN == '2'
		
		If SRA->(dbseek(RHK->(RHK_FILIAL+RHK_MAT)))
			
			If RHK->RHK_PLANO == '02'
				RecLock("RHK",.f.)
				RHK->RHK_CRTOD_ := if(empty(SRA->RA_CSODOIN)," ","I") + if(empty(SRA->RA_CSODOEX)," ","E") + if(empty(SRA->RA_CSODOTR)," ","T")
				RHK->(MsUnLock())
			EndIf
			
		EndIf
		
	EndIf
	
	RHK->(dbskip())
	
EndDo

msgalert("Terminou a RHK  (passo 1/3) ")


RHL->(dbgotop())

While RHL->(!eof())
	
	If RHL->RHL_TPFORN == '1' .and. RHL->RHL_PLANO $ ("27/35/36/37")
		
		If SRB->(dbseek(RHL->(RHL_FILIAL+RHL_MAT)))
			
			While SRB->(!eof()) .and. SRB->(RB_FILIAL+RB_MAT) == RHL->(RHL_FILIAL+RHL_MAT)
				
				If SRB->RB_COD == RHL->RHL_CODIGO  .and. SRA->(dbseek(RHL->(RHL_FILIAL+RHL_MAT)))
					
					RecLock("RHL",.f.)
					
					RHL->RHL_PERINI	:= if(!empty(SRB->RB_MDDTIN),strzero(month(SRB->RB_MDDTIN),2)+strzero(year(SRB->RB_MDDTIN),4),RHL->RHL_PERINI)
					RHL->RHL_PERFIM := if(!empty(SRB->RB_MDDTEX),strzero(month(SRB->RB_MDDTEX),2)+strzero(year(SRB->RB_MDDTEX),4),"")
					RHL->RHL_CRTIN_	:= SRB->RB_CTRINTE
					//RHL->RHL_MATIN_	:= SRB->RB_MATINTE
					RHL->RHL_MATIN_	:= "8941" + SRA->RA_CIC + RHL->RHL_CODIGO
					
					If !empty(RHL->RHL_PERFIM) .and. right(RHL->RHL_PERFIM,4)+left(RHL->RHL_PERFIM,2) < right(RHL->RHL_PERINI,4)+left(RHL->RHL_PERINI,2)
						RHL->RHL_PERINI	:= RHL->RHL_PERFIM
					EndIf
					
					RHL->(MsUnLock())
					
					Exit
					
				EndIF
				
				SRB->(dbskip())
				
			EndDo
			
		EndIF
		
	ElseIf RHL->RHL_TPFORN == '2'
		
		If SRA->(dbseek(RHL->(RHL_FILIAL+RHL_MAT)))
			
			If RHL->RHL_PLANO <> SRA->RA_ASODONT
				RecLock("RHL",.f.)
				RHL->RHL_PLANO := SRA->RA_ASODONT
				RHL->(MsUnLock())
			EndIf
			
			If RHL->RHL_PLANO == '02'
				
				If SRB->(dbseek(RHL->(RHL_FILIAL+RHL_MAT)))
					
					While SRB->(!eof()) .and. SRB->(RB_FILIAL+RB_MAT) == RHL->(RHL_FILIAL+RHL_MAT)
						
						If SRB->RB_COD == RHL->RHL_CODIGO
							
							RecLock("RHL",.f.)
							RHL->RHL_CRTOD_ := if(empty(SRB->RB_CSODOIN)," ","I") + if(empty(SRB->RB_CSODOEX)," ","E") + " "
							RHL->(MsUnLock())
							
							Exit
							
						EndIF
						
						SRB->(dbskip())
						
					EndDo
					
				EndIF
				
			EndIf
			
		EndIf
		
	EndIf
	
	RHL->(dbskip())
	
EndDo

msgalert("Terminou a RHL  (passo 2/3) ")


RHM->(dbgotop())

While RHM->(!eof())
	
	If SRB->(dbseek(RHM->(RHM_FILIAL+RHM_MAT)))
		
		While SRB->(!eof()) .and. SRB->(RB_FILIAL+RB_MAT) == RHM->(RHM_FILIAL+RHM_MAT)
			
			If left(SRB->RB_NOME,30) == RHM->RHM_NOME
				
				RecLock("RHM",.f.)
				RHM->RHM_MAE_  := SRB->RB_MAE
				RHM->RHM_SEXO_ := SRB->RB_SEXO
				RHM->(MsUnLock())

				If RHM->RHM_TPFORN == '1'.and. RHM->RHM_PLANO $ ("27/35/36/37")
					
					RecLock("RHM",.f.)
					
					RHM->RHM_PERINI	:= if(!empty(SRB->RB_MDDTIN),strzero(month(SRB->RB_MDDTIN),2)+strzero(year(SRB->RB_MDDTIN),4),RHM->RHM_PERINI)
					RHM->RHM_PERFIM := if(!empty(SRB->RB_MDDTEX),strzero(month(SRB->RB_MDDTEX),2)+strzero(year(SRB->RB_MDDTEX),4),"")
					
					If !empty(RHM->RHM_PERFIM) .and. right(RHM->RHM_PERFIM,4)+left(RHM->RHM_PERFIM,2) < right(RHM->RHM_PERINI,4)+left(RHM->RHM_PERINI,2)
						RHM->RHM_PERINI	:= RHM->RHM_PERFIM
					EndIf
					
					RHM->(MsUnLock())
					
				ElseIf RHM->RHM_TPFORN == '2'
					
					If RHM->RHM_PLANO <> SRA->RA_ASODONT
						RecLock("RHM",.f.)
						RHM->RHM_PLANO := SRA->RA_ASODONT
						RHM->(MsUnLock())
					EndIf
					
					If RHM->RHM_PLANO == '02'
						
						RecLock("RHM",.f.)
						RHM->RHM_CRTOD_ := if(empty(SRB->RB_CSODOIN)," ","I") + if(empty(SRB->RB_CSODOEX)," ","E") + " "
						RHM->(MsUnLock())
						
					EndIF
					
				EndIf
				
				Exit
				
			EndIF
			
			SRB->(dbskip())
			
		EndDo
		
	EndIF
	
	RHM->(dbskip())
	
EndDo

msgalert("Terminou a RHM  (passo 3/3) ")

Return
