#include "topconn.ch"

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณ GPE550ICDบ Autor ณ Isamu Kawakami     บ Data ณ  21/02/11   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDescricao ณ Ponto de Entrada para regravar informacoes complementares  บฑฑ
ฑฑบ          ณ Equipe RH                                                  บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
/*/

User Function GPE550ICD()

Local _aBenef := aClone( ParamIxb[1] )
Local _aAux	  := {}
Local _aSRD   := SRD->(getarea())
Local aDados  := {}
Local _aNovo  := {}
Local cVerbaAm := ""
Local aAssMedTp2 := {}
Local cCNPJFor := ""                
Private lOdon_


//Executa somente para o ano 2010
If mv_par06 <> 2010
	Return( aClone( _aBenef ) )
EndIf


SRD->(dbsetorder(1))
cChaveSRD := SRA->(RA_FILIAL+RA_MAT)

//Executa linha a linha do array
For nY := 1 to Len(_aBenef)
	
	//Codigos de assistencia medica e odonto utilizados no ano
	//A VERBA 420 EH DE AGREGADOS, NAO TEM VALOR DE TITULAR.
	If _aBenef[nY,11] == 'R' .and. _aBenef[nY,10] $ "420,483,549,552,521"
		
		cVerbaAM  := _aBenef[nY,10] //Verba que conta no array, que existe devido ao campo RV_DIRF estar com "R"
		
		lOdon_ := .f.
		
		If cVerbaAM $ "420*483*549*552*" //Odonto
			lOdon_ := .t.
		EndIf
		
		RCC->(dbsetorder(1))
		
		If lOdon_ //Odonto
			
			//Busca detalhes da tabela customizada atual U001-ODONTO
			If RCC->(dbseek(xFilial("RCC")+"S013"))
				While RCC->(!EOF()) .and. RCC->RCC_CODIGO == "S013"
					If SRA->RA_ASODONT == left(RCC->RCC_CONTEU,2)
						//Carrega as Configuracoes de Desconto de Odonto
						aAssMedTp2 := GPCfgDesAM()
						exit
					EndIf
					RCC->(dbskip())
				EndDo
				
			EndIf
			
			
		EndIf
		
		//Se nใo encontrou a tabela, pula essa linha do array
		If len(	aAssMedTp2) == 0
			Loop
		EndIf
		
		
		//Busca o fornecedor
		
		If lOdon_ //Odonto
			
			If !(Empty(Sra->Ra_AsOdont) )
				cFor_ := Sra->Ra_AsOdont
			Endif
			
			If RCC->(dbseek(xFilial("RCC")+"S017"))
				While RCC->(!EOF()) .and. RCC->RCC_CODIGO == "S017"
					If cFor_ == left(RCC->RCC_CONTEU,2)
						cNomeFor := alltrim(substr(RCC->RCC_CONTEU,4,150))
						cCNPJFor := substr(RCC->RCC_CONTEU,154,14)
						exit
					EndIf
					RCC->(dbskip())
				EndDo
			Else
				//Se nao encontrar o fornecedor, pula essa linha do array
				Loop
			EndIf
			
		EndIf
		
		//Trocar aqui para quem paga a folha no dia 30
		cMesProc   := "12"
		cAnoProc   := "2009"
		cMesProFim := "11"
		cAnoProFim := "2010"
		
		//Executa para cada mes do periodo acima
		While cAnoProc+cMesProc <= cAnoProFim+cMesProFim
			
			nTotDesLan := 0
			nTotDesAgr := 0
			nQtde      := 0
			cVerbAM := ""
			
			//procura a verba da linha do array
			If SRD->( dbSeek(cChaveSRD+cAnoProc+cMesProc+cVerbaAM) )
				
				While SRD->(!Eof()) .And. SRD->(RD_FILIAL+RD_MAT+RD_DATARQ+RD_PD) == cChaveSRD+cAnoProc+cMesProc+cVerbaAM
					
					//Despreza se nao for Lancamentos com data de pagamento dentro da data Inicial e Final
					If SRD->RD_DATPGT < CTOD("01/01/2010") .or. SRD->RD_DATPGT > CTOD("31/12/2010")
						SRD->( dbSkip() )
						Loop
					Endif
					
					
					//Despreza os Lancamentos de transferencias de outras empresas
					If !Empty(SRD->RD_EMPRESA) .And. SRD->RD_EMPRESA # cEmpAnt
						SRD->( dbSkip() )
						Loop
					Endif
					
					dDtPgto    := SRD->RD_DATPGT
					nTotDesLan += SRD->RD_VALOR
					nQtde      += SRD->RD_HORAS
					cVerbAM := SRD->RD_PD
					
					SRD->(dbSkip())
					
				EndDo
				
				if nTotDesLan > 0
					
					//Consiste e Carrega somente os Dependentes de Assist. Medica ou Odonto
					lContinua := GPEVerDep(dDtPgto,@aDados,cAnoProc,cMesProc,lOdon_,cVerbAM)
					
					if lContinua
						
						GPRatAMTpX(aAssMedTp2[1],dDtPgto,nTotDesLan,@aDados,cMesProc,nQtde,cVerbAM)
						
						//Cria novo array
						
						//Titular
						//						cTit_ := "TITULAR - "+alltrim(cNomeFor)+" - "+Transform(cCNPJFor, "@R 99.999.999/9999-99")
						cTit_ := "TITULAR - "+alltrim(left(cNomeFor,10))+" - "+If(lOdon_,"Ass.Odont.","Ass.Medica")+" - "+Transform(cCNPJFor, "@R 99.999.999/9999-99")
						
						If (nPos_ := aScan( _aNovo, { |x| x[1] == cTit_ } )) == 0
							aadd(_aNovo,{cTit_, ;
							cCNPJFor,		;
							_aBenef[nY,3],	;
							_aBenef[nY,4],	;
							_aBenef[nY,5],	;
							_aBenef[nY,6],	;
							_aBenef[nY,7],	;
							_aBenef[nY,8],	;
							Iif(cVerbaAm <> "420",aDados[1,5],0),	;
							_aBenef[nY,10],	;
							_aBenef[nY,11],	;
							_aBenef[nY,12],	;
							_aBenef[nY,13],	;
							_aBenef[nY,14],	;
							_aBenef[nY,15],	;
							"TODO" })
							//	iif(lOdon_,"TODO","TMED") })
							
						Else
						   	If cVerbaAM <> "420"
							   _aNovo[nPos_,9] += aDados[1,5]
						   Endif
						EndIf
						
						//Dependentes
						If len(aDados) > 0
							
							If cVerbaAm == "420"
														
								For nZ := 1 to len(aDados)
								
								If aDados[nZ,6]
									
									//								cDep_ := left(aDados[nZ,10],30)+" - "+Transform(aDados[nZ,4], "@R 999.999.999-99")+" - Ass.Medica - "+left(cNomeFor,10)+" - "+Transform(cCNPJFor, "@R 99.999.999/9999-99")
									cDep_ := left(aDados[nZ,10],AT(" ",aDados[nZ,10]))+"- "+Transform(aDados[nZ,4], "@R 999.999.999-99")+" - "+If(lOdon_,"Ass.Odont.","Ass.Medica")+" - "+ALLTRIM(left(cNomeFor,10))
									
									If (nPos_ := aScan( _aNovo, { |x| x[1] == cDep_ } )) == 0
										
										While (nPosX_ := aScan( _aNovo, { |x| x[10] == aDados[nZ,12]} )) <> 0
											aDados[nZ,12] := left(aDados[nZ,12],1)+strzero(val(right(aDados[nZ,12],2))+10,2) //Acrescenta 10 no codigo da verba para que nao aglutive fornecedores diferentes. Ex: A02 -> A12 -> A22
										EndDo
										aadd(_aNovo,{cDep_, ;
										cCNPJFor,	;
										_aBenef[nY,3],	;
										_aBenef[nY,4],	;
										_aBenef[nY,5],	;
										_aBenef[nY,6],	;
										_aBenef[nY,7],	;
										_aBenef[nY,8],	;
										aDados[nZ,5],	;
										aDados[nZ,12],	;
										_aBenef[nY,11],	;
										_aBenef[nY,12],	;
										_aBenef[nY,13],	;
										_aBenef[nY,14],	;
										_aBenef[nY,15],	;
										aDados[nZ,11]+if(lOdon_,"ODO","MED")+aDados[nZ,3] })
										
									Else
										_aNovo[nPos_,9] += aDados[nZ,5]
									EndIf
								
								Endif
									
								Next nZ
								
							Else
								
								For nZ := 2 to len(aDados)
									
									If aDados[nZ,5] > 0
									//								cDep_ := left(aDados[nZ,10],30)+" - "+Transform(aDados[nZ,4], "@R 999.999.999-99")+" - Ass.Medica - "+left(cNomeFor,10)+" - "+Transform(cCNPJFor, "@R 99.999.999/9999-99")
									cDep_ := left(aDados[nZ,10],AT(" ",aDados[nZ,10]))+"- "+Transform(aDados[nZ,4], "@R 999.999.999-99")+" - "+If(lOdon_,"Ass.Odont.","Ass.Medica")+" - "+ALLTRIM(left(cNomeFor,10))
									
									If (nPos_ := aScan( _aNovo, { |x| x[1] == cDep_ } )) == 0
										
										While (nPosX_ := aScan( _aNovo, { |x| x[10] == aDados[nZ,12]} )) <> 0
											aDados[nZ,12] := left(aDados[nZ,12],1)+strzero(val(right(aDados[nZ,12],2))+10,2) //Acrescenta 10 no codigo da verba para que nao aglutive fornecedores diferentes. Ex: A02 -> A12 -> A22
										EndDo
										aadd(_aNovo,{cDep_, ;
										cCNPJFor,	;
										_aBenef[nY,3],	;
										_aBenef[nY,4],	;
										_aBenef[nY,5],	;
										_aBenef[nY,6],	;
										_aBenef[nY,7],	;
										_aBenef[nY,8],	;
										aDados[nZ,5],	;
										aDados[nZ,12],	;
										_aBenef[nY,11],	;
										_aBenef[nY,12],	;
										_aBenef[nY,13],	;
										_aBenef[nY,14],	;
										_aBenef[nY,15],	;
										aDados[nZ,11]+if(lOdon_,"ODO","MED")+aDados[nZ,3] })
									
									Else
										_aNovo[nPos_,9] += aDados[nZ,5]
									EndIf
									
									Endif
								
								Next nZ
								
							Endif
							
						EndIf
						
						
					Else
						
						Exit
						
					endif
					
				endif
				
			endif
			
			//Proximo Mes / Ano
			if cMesProc == "12"
				cAnoProc := alltrim(Str(Val(cAnoProc)+1))
				cMesProc := "01"
			else
				cMesProc := Soma1(cMesProc)
			endif
			
		End
		
		
	ElseIf _aBenef[nY,10]  $ "506*514*591*597*598*590*592*601*503*594"  .or.  Subs(_aBenef[nY,10],1,1) == "D" //CO PARTICIPACAO
		
		cCodFor_ := ""
		cquery := ""
		Grau_  := ""
		Cod_  := ""
		/*
		If !(Empty(Sra->Ra_AsMedic) )
		cFor_ := Sra->Ra_AsMedic
		Endif
		*/
		If _aBenef[nY,10]  $ "506*514*591*597*598*590*592*601*503"
			cFor_ := Sra->Ra_AsMedic
		ElseIf Subs(_aBenef[nY,10],1,1) == "D"
			cFor_ := Posicione("SRB",1,Sra->Ra_Filial+Sra->Ra_Mat,"RB_CODAMED")
		Endif
		
		cquery:=  "	SELECT SUBSTRING(RCC_CONTEU,92,2) AS CODFOR FROM "+ RETSQLNAME("RCC")+"  "
		cquery+= " WHERE SUBSTRING(RCC_CONTEU,1,2) = '"+cFor_+"' "
		cquery+= " AND RCC_CODIGO='S008'"
			cquery+= " AND "+RETSQLNAME("RCC")+".D_E_L_E_T_=' ' "
		
		//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
		//ณFecha alias caso esteja aberto ณ
		//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
		If Select("TRBFOR") > 0
			DBSelectArea("TRBFOR")
			DBCloseArea()
		EndIf
		
		//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
		//ณExecuta a Queryณ
		//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
		cQuery := changequery(cQuery)
		TCQUERY cQuery NEW ALIAS "TRBFOR"
		
		DBSelectArea("TRBFOR")
		DBGotop()
		
		If Eof() .and. Bof()
			Return
		Endif
		
		While !Eof()
			If !Empty(TrbFor->CodFor)
				cCodFor_ := TRBFOR->CODFOR
			Endif
			TrbFor->(dbSkip())
		EndDo
		
		If RCC->(dbseek(xFilial("RCC")+"S016"))
			While RCC->(!EOF()) .and. RCC->RCC_CODIGO == "S016"
				If cCodFor_ == left(RCC->RCC_CONTEU,2)
					cNomeFor := alltrim(substr(RCC->RCC_CONTEU,4,150))
					cCNPJFor := substr(RCC->RCC_CONTEU,154,14)
					exit
				EndIf
				RCC->(dbskip())
			EndDo
		Else
			//Se nao encontrar o fornecedor, pula essa linha do array
			Loop
		EndIf
		
		If _aBenef[nY,10]  $ "591*590*592*601*"   //TITULAR E AGREG  
		  
		 	//aadd(_aNovo,{		_aBenef[nY,1],	;
		    aadd(_aNovo,{	alltrim(left(cNomeFor,10))+" - Ass.Medica"+" - "+Transform(cCNPJFor, "@R 99.999.999/9999-99"),	;
				cCNPJFor,	;
			_aBenef[nY,3],	;
			_aBenef[nY,4],	;
			_aBenef[nY,5],	;
			_aBenef[nY,6],	;
			_aBenef[nY,7],	;
			_aBenef[nY,8],	;
			_aBenef[nY,9],	;
			_aBenef[nY,10],	;
			_aBenef[nY,11],	;
			_aBenef[nY,12],	;
			_aBenef[nY,13],	;  
			_aBenef[nY,14],	;
			_aBenef[nY,15],	;
			"TMED" })
			
		ElseIf _aBenef[nY,10]  $ "514*597*598*"    //CO PART
			
			//aadd(_aNovo,{	Left(_aBenef[nY,1],At(".",_aBenef[nY,1]))+"-CNPJ: "+Transform(cCnpjFor,"@R 99.999.999/9999-99"),	;
		 	aadd(_aNovo,{		_aBenef[nY,1]+" - CNPJ: "+Transform(cCNPJFor, "@R 99.999.999/9999-99"),	;
		   	  cCNPJFor, ;
			_aBenef[nY,3],	;
			_aBenef[nY,4],	;
			_aBenef[nY,5],	;
			_aBenef[nY,6],	;
			_aBenef[nY,7],	;
			_aBenef[nY,8],	;
			_aBenef[nY,9],	;
			_aBenef[nY,10],	;
			_aBenef[nY,11],	;
			_aBenef[nY,12],	;
			_aBenef[nY,13],	;
			_aBenef[nY,14],	;
			_aBenef[nY,15],	;
		   "TMED" })
		
		ElseIf _aBenef[nY,10]  $ "594"    //CO PART
			
			//aadd(_aNovo,{	Left(_aBenef[nY,1],At(".",_aBenef[nY,1]))+"-CNPJ: "+Transform(cCnpjFor,"@R 99.999.999/9999-99"),	;
		 	aadd(_aNovo,{		_aBenef[nY,1]+" - CNPJ: "+Transform(cCNPJFor, "@R 99.999.999/9999-99"),	;
		   	  cCNPJFor, ;
			_aBenef[nY,3],	;
			_aBenef[nY,4],	;
			_aBenef[nY,5],	;
			_aBenef[nY,6],	;
			_aBenef[nY,7],	;
			_aBenef[nY,8],	;
			_aBenef[nY,9],	;
			_aBenef[nY,10],	;
			_aBenef[nY,11],	;
			_aBenef[nY,12],	;
			_aBenef[nY,13],	;
			_aBenef[nY,14],	;
			_aBenef[nY,15],	;
		   	_aBenef[nY,16] })
		Else
                                             

			aadd(_aNovo,{		_aBenef[nY,1],	;
		        _aBenef[nY,2],	;
			_aBenef[nY,3],	;
			_aBenef[nY,4],	;
			_aBenef[nY,5],	;
			_aBenef[nY,6],	;
			_aBenef[nY,7],	;
			_aBenef[nY,8],	;
			_aBenef[nY,9],	;
			_aBenef[nY,10],	;
			_aBenef[nY,11],	;
			_aBenef[nY,12],	;
			_aBenef[nY,13],	;
			_aBenef[nY,14],	;
			_aBenef[nY,15],	;
			Subs(_aBenef[nY,10],1,1)+"MED"+Subs(_aBenef[nY,10],2,2)})
		
		Endif
		/*
		ElseIf _aBenef[nY,10]  == "506" //.and. Empty(_aBenef[nY,16])
		
		aadd(_aNovo,{		_aBenef[nY,1],	;
		_aBenef[nY,2],	;
		_aBenef[nY,3],	;
		_aBenef[nY,4],	;
		_aBenef[nY,5],	;
		_aBenef[nY,6],	;
		_aBenef[nY,7],	;
		_aBenef[nY,8],	;
		_aBenef[nY,9],	;
		_aBenef[nY,10],	;
		_aBenef[nY,11],	;
		_aBenef[nY,12],	;
		_aBenef[nY,13],	;
		_aBenef[nY,14],	;
		_aBenef[nY,15],	;
		"TMED" })
		*/
	Else
		
		aadd(_aNovo,{		_aBenef[nY,1],	;
		_aBenef[nY,2],	;
		_aBenef[nY,3],	;
		_aBenef[nY,4],	;
		_aBenef[nY,5],	;
		_aBenef[nY,6],	;
		_aBenef[nY,7],	;
		_aBenef[nY,8],	;
		_aBenef[nY,9],	;
		_aBenef[nY,10],	;
		_aBenef[nY,11],	;
		_aBenef[nY,12],	;
		_aBenef[nY,13],	;
		_aBenef[nY,14],	;
		_aBenef[nY,15],	;
		_aBenef[nY,16] })
		
		
	Endif
	
Next nY


RestArea(_aSRD)

Return( aClone( _aNovo ) )

// F I M     D O    P R O G R A M A




Static Function GPCfgDesAM()
Local aRet_ := {}
cCodPlan 	:= left(RCC->RCC_CONTEU,2)
nVlTitular	:= Val(SubStr(RCC->RCC_CONTEU,35,12))
nVlrDepend	:= Val(SubStr(RCC->RCC_CONTEU,47,12))
nVlrAgreg      := Val(Subs(RCC->RCC_CONTEU,59,12))
nPercAM		:= Val(SubStr(RCC->RCC_CONTEU,78,07))
cFornec     := Subs(RCC->RCC_CONTEU,92,2)
aAdd( aRet_, { cCodPlan, nVlTitular, nVlrDepend, nVlRAgreg,nPercAM,  cFornec } )
Return(aRet_)




Static Function GPEVerDep(dDtPagto,aDados,cAno,cMes,lOdon_,cVerbAM)

Local lRet 		:= .T.
Local cFilSRB 	:= if(empty(xFilial("SRB")),Space(2),SRA->RA_FILIAL)
Local nIdade  	:= 0
Local lIsDepAM  := .F.
Local cAnoMesRef:= cAno+cMes
Local dDtVlIdade:= cToD("31/12/"+AllTrim(Str(Year(dDtPagto)))) //Data a ser considerada para verifica a idade do Dependente
Local cPDAM := cVerbAM

aDados := {}

If cPdAM <> "420"
	aAdd( aDados, { SRA->RA_FILIAL, SRA->RA_MAT, "  ", SRA->RA_CIC, 0 } )
Endif

dbSelectArea("SRB")
SRB->(DbSetOrder(1))
if SRB->( dbSeek(cFilSRB+SRA->RA_MAT) )
	while SRB->( !EoF() ) .and. SRB->(RB_FILIAL+RB_MAT) == cFilSRB+SRA->RA_MAT
		
		
		If lOdon_
			
			if !empty(SRB->RB_ASODONT)  .and. SRB->RB_TPDPODO $ "1/2"  .and. !EMPTY(SRB->RB_TPASODO)//Eh Dependente de Odonto
				
				//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
				//ณVerifica se a Odonto esta vigente na data de pagto. em questaoณ
				//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
				if !empty(SRB->RB_DTINIAO) .and. cAnoMesRef < AllTrim(Str(Year(SRB->RB_DTINIAO)))+StrZero(Month(SRB->RB_DTINIAO),2)
					
					SRB->( dbSkip() )
					Loop
				endif
				
				if !empty(SRB->RB_DTFIMAO) .and. cAnoMesRef > AllTrim(Str(Year(SRB->RB_DTFIMAO)))+StrZero(Month(SRB->RB_DTFIMAO),2)
					SRB->( dbSkip() )
					Loop
				endif
				
				//Verifica a idade do dependente
				nIdade := Calc_Idade( dDtVlIdade , SRB->RB_DTNASC )
				
				//Se for maior de Idade, obriga ter o CPF informado para o Dependente
				lRatTit := .T.
				if nIdade >= 18 .and. empty(SRB->RB_CIC)
					lRatTit := .F.
				EndIf
				
				If anomes(SRB->RB_DTNASC) > cAnoMesRef
					SRB->( dbSkip() )
					Loop
				endif
				//Filial        Mat. Func   Cod Depend.  CPF Depend   Vlr 	Rateio p/Tit.	AnoMes		Dt Envio Adm    Dt.Envio Demiss   Nome            Grau Parentesco                  Verba Desconto Odonto
				//   01            02            03           04       05         06            07             08              09          10               11                                    12
				aAdd( aDados, { SRB->RB_FILIAL, SRB->RB_MAT, SRB->RB_COD, SRB->RB_CIC, 0,	lRatTit, 	cAnoMesRef, SRB->RB_DTINIAO, SRB->RB_DTFIMAO, SRB->RB_NOME, SRB->RB_GRAUPAR, 	If(!empty(SRB->RB_VBDESAO),SRB->RB_VBDESAO,"B"+SRB->RB_COD),SRB->RB_TPDPODO  } )
				
			EndIf
			
		EndIf
		
		SRB->( dbSkip() )
	end
	
endif

Return lRet





/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณGPRatAMTpXบAutor  ณIsamu Kawakami      บ Data ณ 22/02/2011  บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ Calcula o Rateio da Assistencia Medica Customizada         บฑฑ
ฑฑบ          ณ (CSU)                                                      บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ SIGAGPE                                                    บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
Static Function GPRatAMTpX(aAssistMed,dDtRefPag,nVlrAMLanc,aDados,cMes,nQtde,cVerbAM)
Local nSalFunc 	:= fBuscaSal(dDtRefPag,,,.T.,) //Busca Salario do funcionario na data de referencia
Local nInd 		:= 0
Local nX 		:= 0
Local cPDAM := cVerbAM
Local nValorPlan:= If (cPdAM <> "420",aAssistMed[2],aAssistMed[4]) //Valor do Plano
Local nPerDesFun:= 0
Local nPerDesDep:= 0
Local nVlrDesFun:= 0
Local nVlrDesDep:= 0
Local nTotDesDep:= 0
Local nTotRatDep:= 0
Local nTotDesCal:= 0
Local nPerRatFun:= 0
Local nPerRatDep:= 0
Local nDesRatFun:= 0 //Armazena o desconto rateado de Assis. Medica Lancado para o Funcionaio
Local nDesRatDep:= 0 //Armazena o desconto rateado de Assis. Medica Lancado para os Dependentes
Local nDifQt    := 0


If len(aDados) <> nQtde
	nDifQt := len(aDados) - nQtde
endif

nValVida := round(nVlrAMLanc/nQtde,2)

If nQtde == 1 .and. cPDAM <> "420"
	
	//Valor do Funcionario (Titular)
	aDados[1][5] := nVlrAMLanc
	
Else
	
	If cPdAm == "420"
		//Valor dos Dependentes
		For nX:=1 to len(aDados) //For nX:=2 to len(aDados)
			
			If (nTotRatDep + nValVida) > nVlrAMLanc
				exit
			EndIf
			
			If nDifQt > 0
				
				nDifQt--
				
				If !empty(aDados[nX][8]) .and. anomes(aDados[nX][8]) >= aDados[nX][7] .or. ;
					!empty(aDados[nX][9]) .and. anomes(aDados[nX][9]) <= aDados[nX][7]
					
					Loop
					
				EndIf
				
			EndIf
			
			If aDados[nX][6] .and. aDados[nX][13] =="2"
				aDados[nX][5] := nValVida
				nTotRatDep += nValVida
			EndIf
			
		Next nX
		
	Else
		//Valor dos Dependentes
		For nX:=2 to len(aDados) //For nX:=2 to len(aDados)
			
			If (nTotRatDep + (nValVida*2)) > nVlrAMLanc
				exit
			EndIf
			
			If nDifQt > 0
				
				nDifQt--
				
				If !empty(aDados[nX][8]) .and. anomes(aDados[nX][8]) >= aDados[nX][7] .or. ;
					!empty(aDados[nX][9]) .and. anomes(aDados[nX][9]) <= aDados[nX][7]
					
					Loop
					
				EndIf
				
			EndIf
			
			If aDados[nX][6] .and. aDados[nX][13] =="1"
				aDados[nX][5] := nValVida
				nTotRatDep += nValVida
			EndIf
			
		Next nX
		
	Endif
	
	If cPdAM <> "420"  //nao rateio verba de agregados
		//Valor do Funcionario (Titular)
		aDados[1][5] := nVlrAMLanc - nTotRatDep
	Endif
	
EndIf

Return
