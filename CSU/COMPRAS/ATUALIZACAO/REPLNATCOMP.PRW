#INCLUDE "PROTHEUS.CH"
#INCLUDE "rwmake.ch"
#Include 'TopConn.ch'
#Define _cEnter Chr(13) + Chr(10)

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±± Funcao: REPLNAT 	Autor: Tatiana A. Barbosa	Data: 13/10/10	           ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±	Descricao: Funcao para permitir que as informacoes dos campos          ±± 
±± 				natureza e competencia se repitam para todos os itens 	   ±±  
±±					 		do documento.  OS 2623/10					   ±±
±±ÌÍÍÍÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±º Alterações  ³10/06/14 - OS 1474/14 - Mauricio de Barros               º±±
±±º             Alterado para efetuar ganho de performance no             º±±
±±º             preenchimento da replica de naturezas.                    º±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±				Uso:  CSU 	                                               ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
                      
User Function REPLNAT ()       

Local cNatFul_	:=	M->D1_NATFULL                                           
Local lRet		:= 	.T.              
Local ny                       
Local nx                       
Local nz                       
Local nPosNat	:= aScan( aHeader , { |x| Upper( Trim ( x[2] ) ) == "D1_NATFULL"  }) // Ver a Posicao do Campo no aHeader
Local nPosTES	:= aScan( aHeader , { |x| Upper( Trim ( x[2] ) ) == "D1_TES"  }) 	 // Ver a Posicao do Campo no aHeader
Local nPosPed	:= aScan( aHeader , { |x| Upper( Trim ( x[2] ) ) == "D1_PEDIDO"  })  // Ver a Posicao do Campo no aHeader
Local nPosItem	:= aScan( aHeader , { |x| Upper( Trim ( x[2] ) ) == "D1_ITEM"  }) 	 // Ver a Posicao do Campo no aHeader
Local nPosCf	:= aScan( aHeader , { |x| Upper( Trim ( x[2] ) ) == "D1_CF"  }) 	 // Ver a Posicao do Campo no aHeader
Local _CountNat	:= 0
Local cItem_    := "0001"
Local _cTes     := ""
Local _cCf      := Posicione("SF4",1,xFilial("SF4")+_cTes,"F4_CF")
Local _cNLinha	:= ""
Local _nACols	:= Len(aCols)
Local _nOldN	:= N      
Local _aArea     := GETAREA()   

ZA5->( DbsetOrder(3) )
SC7->( DbSetOrder(1) )  

For nx := 1 To _nAcols	//OS 3317/10
	If !GdDeleted(nx)
		_CountNat++
	EndIf     
	
	If nx = _nAcols
		//_cNLinha := aCols[nx][nPosItem]  
		_cNLinha := StrZero(nPosItem,4)
	EndIf	
Next
ZA5->( DbSetOrder(4))                                         
If !(ZA5->(DbSeek( xFilial('ZA5')+cNatFul_)) .And. GdFieldGet("D1_TES",N) # ZA5->ZA5_TES) .And. _CountNat > 1 .And. cItem_ <> _cNLinha
	If MsgYesNo ("Deseja replicar a Natureza [ "+Alltrim(cNatFul_)+" ] para os demais itens do documento de entrada?"+_cEnter+_cEnter+"Obs: As Naturezas vinculadas ao TES de Ativo não serão substituidas.", "Atenção")	
		For ny := 1 To Len( aCols )
			If !GdDeleted(ny)	 
				If SC7->( DbSeek( xFilial('SC7')+aCols[ny][nPosPed] ) ) .And. ZA5->( DbSeek( xFilial('ZA5')+SC7->C7_COND ) ) .Or.;
					!(ZA5->( DbSetOrder(4), DbSeek( xFilial('ZA5')+aCols[ny][nPosNat]) ) ) .Or.;
					!(ZA5->( DbSetOrder(4), DbSeek( xFilial('ZA5')+aCols[ny][nPosNat])) .And. GdFieldGet("D1_TES",NY) # ZA5->ZA5_TES)
					nz := ny
					//For nz:=1 To Len(aCols) 
						If aCols[nz][nPosItem] >= cItem_			             
							N := ny       
							aCols[ny][nPosNat]  := Alltrim(cNatFul_)
							_cTes := U_Rcomg02()
							If FUNNAME() != "MATA140" // O.S 3041/15
								aCols[ny][nPosTES]  := _cTes
								aCols[ny][nPosCf]   := _cCf    
								a103Trigger("D1_TES")
							EndIf
						EndIf
					//Next nz
				EndIf
			EndIf
		Next ny
	EndIf
Else       
	If _CountNat > 1 .And. cItem_ <> _cNLinha
		MsgAlert("Não será permitido replicar a Natureza [ "+Alltrim(cNatFul_)+" ] para os demais itens do documento !"+_cEnter+_cEnter+"Trata-se de uma Natureza que deve ser usada com o TES de Ativo.","Natureza de Ativo")
	EndIf
EndIf

N := _nOldN                  

RestArea(_aArea)

Return (lRet)

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±± Funcao: REPLCOMP 	Autor: Tatiana A. Barbosa	Data: 13/10/10	       ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±	Descricao: Funcao para permitir que as informacoes dos campos          ±± 
±± 				natureza e competencia se repitam para todos os itens 	   ±±  
±±					 		do documento.  OS 2623/10					   ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±				Uso:  CSU 	                                               ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
                      
User Function REPLCOMP ()       

Local cCompet_		:= 	M->D1_XDTAQUI
Local lRetC			:= 	.T.              
Local nz                       
Local ny                       
Local nPosComp		:= aScan( aHeader , { |x| Upper( Trim ( x[2] ) ) == "D1_XDTAQUI"  }) // Ver a Posicao do Campo no aHeader
Local nPosItem 		:= aScan( aHeader , { |x| Upper( Trim ( x[2] ) ) == "D1_ITEM"  }) 	 // Ver a Posicao do Campo no aHeader
Local _CountComp	:= 0  
Local cItem_    := "0001"
Local _cNLinha	:= ""
Local _nACols	:= Len(aCols)

For nx := 1 To _nACols	//OS 3317/10
	If !GdDeleted(nx)
		_CountComp++
	EndIf       
	
	If nx=_nAcols
		_cNLinha :=	StrZero(nPosItem,4)
	EndIf
Next

If (Substr(Alltrim(D1_XDTAQUI),1,2)>="01" .And. Substr(Alltrim(D1_XDTAQUI),1,2)<="12" .And. (Substr(Alltrim(D1_XDTAQUI),4,4)>="1999"));
		.Or. (Substr(Alltrim(M->D1_XDTAQUI),1,2)>="01" .And. Substr(Alltrim(M->D1_XDTAQUI),1,2)<="12" .And. (Substr(Alltrim(M->D1_XDTAQUI),4,4)>="1999"))
	If _CountComp > 1 .And. cItem_ <> _cNLinha
		If MsgYesNo ("Deseja replicar a Competência [ "+Alltrim(cCompet_)+" ] para os demais itens do documento de entrada?", "Atenção")
			For nz := 1 To Len( aCols )
				If !GdDeleted(nz)
					For ny:=1 To Len(aCols) 
						If aCols[ny][nPosItem] >= cItem_			             
							aCols[ny][nPosComp] := Alltrim(cCompet_)
						EndIf
					Next ny				
			 	EndIf  
			Next nz              
		EndIf
	EndIf
Else

	MsgAlert("Verifique a competência digitada!"+_cEnter+"O mês da competência poderá ser entre 01 e 12, e o ano deverá ser maior que 1999.","Competência Inválida")
	lRetC	:=	.F.
		
EndIf
	
Return (lRetC)