
User Function xTeste()

	aItens	:= {}
	aRotAuto	:= {}
	lMsErroAuto := .F.

		aadd(aRotAuto	,{'E5_DATA'		,ddatabase			,Nil})//2
		aadd(aRotAuto	,{'E5_MOEDA' 	,"M1"								,Nil})//4
		aadd(aRotAuto	,{'E5_VALOR'	,1000					,Nil})//7
		aadd(aRotAuto	,{'E5_NATUREZ'	,"1"		,Nil})//8 
		aadd(aRotAuto	,{'E5_BANCO'	,"001"				,Nil})//9 
		aadd(aRotAuto	,{'E5_AGENCIA'	,"00000"	,Nil})//10 
		aadd(aRotAuto	,{'E5_CONTA'	,"0000000000"	,Nil})//11  
		aadd(aRotAuto	,{'E5_NUMCHEQ' 	,""				,Nil})//12
		aadd(aRotAuto	,{'E5_DOCUMEN' 	,""			,Nil})//13
		aadd(aRotAuto	,{'E5_HISTOR' 	,""				,Nil})//16 
		
 		aadd(aItens	,aRotAuto)
  		aRotAuto := {}
  		
  		nOpc := 4
		MSExecAuto({|x,y,z| FINA100(x,y,z)},0,aItens[1],nOpc)	
		               	
		If lMsErroAuto		               	
			mostraerro()
		EndIf
Return