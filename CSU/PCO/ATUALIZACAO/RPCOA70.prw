
/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³RPCOA70   ºAutor  ³Microsiga           º Data ³  11/28/06   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ Específico lançamentos de liberação por total do pedido    º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ AP                                                        º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/


#INCLUDE 'rwmake.ch'
Static aRet
Static nRecSC7
User Function RPCO070(cCampo,lFiltraCC)		
Local cAliasTrb
Local aRetLanc
Local cQuery
lFiltraCC	:=	IIf(lFiltraCC==Nil,.F.,lFiltraCC)
If cCampo == Nil                                          
	cAliasTrb	:=	CriaTrab(Nil,.F.)
	cQuery	:=	" SELECT MAX(R_E_C_N_O_) RECSC7, SUM(C7_TOTAL) C7_TOTAL,C7_CONTA, C7_CC, C7_EMISSAO, C7_ITEMCTA FROM "+RetSqlName('SC7')+' SC7 '
	cQuery	+=	" WHERE C7_FILIAL = '"+xFilial('SC7')+"' "
	cQuery	+=	" AND C7_NUM = '"+Substr(SCR->CR_NUM,1,len(SC7->C7_NUM))+"'" 
	cQuery	+=	" AND D_E_L_E_T_=' ' "
	cQuery	+=	" GROUP BY  C7_CONTA, C7_CC, C7_EMISSAO, C7_ITEMCTA,C7_NUM"
	dbUseArea( .T., "TopConn", TCGenQry(,,cQuery),cAliasTrb, .F., .F. )
	TcSetField(cAliasTRB,'C7_TOTAL','N',TamSx3('C7_TOTAL')[1],TamSx3('C7_TOTAL')[2])
	If !Eof()
		aRet		:= {{},{},{},{},{},Substr(SCR->CR_NUM,1,len(SC7->C7_NUM)),{},{}}
		nRecSC7	:=	RECSC7
	Else
		nRecSC7	:=	Nil
	Endif
   While !Eof() 
 //		If lFiltraCC  .Or. (Substr(C7_CC,1,4) == '2303' .Or. Substr(C7_CC,1,4) == '1605' ) 
			AAdd(aRet[1],C7_TOTAL			)
			AAdd(aRet[1],C7_TOTAL			)
			AAdd(aRet[2],Left(C7_CONTA,12))
			AAdd(aRet[2],Left(C7_CONTA,12))
			AAdd(aRet[3],C7_CC         	)
			AAdd(aRet[3],C7_CC         	)
			AAdd(aRet[4],Stod(C7_EMISSAO) )
			AAdd(aRet[4],Stod(C7_EMISSAO) )
			AAdd(aRet[5],C7_ITEMCTA       )
			AAdd(aRet[5],C7_ITEMCTA       )
			AAdd(aRet[7],"2")
			AAdd(aRet[7],"1")
			AAdd(aRet[8],"PT")
			AAdd(aRet[8],"EM")
   //		Endif
		DbSkip()			
	Enddo
	DbCloseArea()   

Else          
	If nRecSC7 <> Nil              
		SC7->(MsGoTo(nRecSC7))
	Endif
	Do Case
	Case cCampo == 'C7_TOTAL'
		aRetLanc		:=	aRet[1]
	Case cCampo == 'C7_CONTA'
		aRetLanc		:=	aRet[2]
	Case cCampo == 'C7_CC'
		aRetLanc		:=	aRet[3]
	Case cCampo == 'C7_EMISSAO'
		aRetLanc		:=	aRet[4]
	Case cCampo == 'C7_ITEMCTA'
		aRetLanc		:=	aRet[5]
	Case cCampo == 'C7_NUM'
		aRetLanc		:=	aRet[6]
	Case cCampo == 'TPMOV'
		aRetLanc		:=	aRet[7]
	Case cCampo == 'TPSALD'
		aRetLanc		:=	aRet[8]
	Otherwise
		aRetLanc	:=	Nil
	EndCase		
Endif
Return aRetLanc