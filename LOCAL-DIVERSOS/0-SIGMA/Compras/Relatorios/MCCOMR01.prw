#Include "AP5MAIL.ch"
#INCLUDE "MSOLE.CH" 
#INCLUDE "PROTHEUS.CH"
#INCLUDE "RPTDEF.CH"
#INCLUDE "FWPrintSetup.ch"
  
/*                                                                        
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³ MCCOMR01                                         12/08/16  º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDescricao ³Imprimir Pedido de Compras Grafico                          º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ Especifico SELFIT                                          º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß 

*/

User Function MCCOMR01(cOpcEx, cNomFile)
Private cNomARQ
Private cDesc1
Private cDesc2
Private cDesc3
Private _cString
Private aOrd
Private j
Private oFont1
Private oFont2
Private oFont3
Private oFont4
Private oFont5
Private oFont6
Private oFont7
Private lAuto := .F.
Private nPag  := 1
Private nPagd := 0
Private NumPed   := Space(6)
Private cPFornec, cEmailForn, cEmailNome, cFornece, cObsPed, cPedEntr
Private cPerg   :="MCCOMR01", cMsg, nLinha, nLinhaD, nLinhaO, cObs   
Private oDlg,oGet
Private cGet1 := Space(2)
Private cCodIni,cCodFim
Private lAux := .F. 
Private nValIpi  := 0 
Private nVAlICMs := 0 
Private nLinMaxIte := 1600 // 1700 

Default cOpcEx   := '1'
Default cNomFile := ""

	cNomARQ := cNomFile

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Verifica as perguntas selecionadas                           ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Variaveis utilizadas para parametros                         ³
//³ mv_par01	     	  Do Pedido                                 ³
//³ mv_par02     	  	  Ate o Pedido 		                       ³
//³ mv_par03	     	  A partir da Data                          ³
//³ mv_par04           Ate a Data                  	     	     ³
//³ mv_par05           Unidade de Medida             	     	     ³
//³ mv_par06           Nr.Vias                                   ³
//³ mv_par07           Qual Moeda?                               ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ      

ValidPerg()  

If cOpcEx == '1' // Via menu ou ações relacionadas
	If !Pergunte(cPerg,.T.)
		Return
	EndIF                   

	cParam1 := MV_PAR01
	cParam2 := MV_PAR02
	dParam3 := MV_PAR03
	dParam4 := MV_PAR04
	nParam5 := MV_PAR05
	nParam6 := MV_PAR06
	nParam7 := MV_PAR07

Else	
	cParam1 := SC7->C7_NUM
	cParam2 := SC7->C7_NUM
	dParam3 := SC7->C7_EMISSAO
	dParam4 := SC7->C7_EMISSAO
	nParam5 := 1
	nParam6 := 1
	nParam7 := 1
End If

Relato()	
//RptStatus({||Relato()})


Return


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³ RELATO   ºAutor  ³ Leandro Eber    º Data ³  17/09/15   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³                                                            º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ AP8                                                        º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
Static Function Relato()

Local nOrder                                                         `
Local cCondBus
Local nSavRec
Local aSavRec := {}
Local nRegSM0	:= SM0->(Recno())
Local cEmpAnt	:= SM0->M0_CODIGO
Local ncw 		:= 0           
Local i        := 0

Private lEnc    := .f.
Private cTitulo
Private oFont, cCode, oPrn
Private cCGCPict, cCepPict    
Private lPrimPag :=.t. 
Private nTotPag:=0
Private nReem
Private dDtEntrega

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Definir as pictures                                           ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
cCepPict:=PesqPict("SA2","A2_CEP")
cCGCPict:=PesqPict("SA2","A2_CGC")

oFont  := TFont():New( "Arial",,23,,.t.,,,,,.f. )
oFont1 := TFont():New( "Arial",,23,,.t.,,,,,.f. )
oFont2 := TFont():New( "Arial",,23,,.f.,,,,,.f. )
oFont3 := TFont():New( "Arial",,15,,.t.,,,,,.f. )
oFont4 := TFont():New( "Arial",,15,,.f.,,,,,.f. )
oFont5 := TFont():New( "Arial",,12,,.t.,,,,,.f. )  
oFont6 := TFont():New( "Arial",,10,,.f.,,,,,.f. )
oFont7 := TFont():New( "Arial",,21,,.t.,,,,,.f. )  
oFont8 := TFont():New( "Arial",,21,,.f.,,,,,.f. )
oFont9 := TFont():New( "Arial",,18,,.t.,,,,,.f. )  
oFont10:= TFont():New( "Arial",,18,,.f.,,,,,.f. ) 
oFont11:= TFont():New( "Arial",,11,,.t.,,,,,.f. )  
oFont12:= TFont():New( "Arial",,11,,.f.,,,,,.f. )

oFont1c := TFont():New( "Courier New",,24,,.t.,,,,,.f. )
oFont2c := TFont():New( "Courier New",,24,,.f.,,,,,.f. )
oFont3c := TFont():New( "Courier New",,15,,.t.,,,,,.f. )
oFont4c := TFont():New( "Courier New",,13,,.f.,,,,,.f. )
oFont5c := TFont():New( "Courier New",,14,,.t.,,,,,.f. )  
oFont6c := TFont():New( "Courier New",,14,,.T.,,,,,.f. )
oFont7c := TFont():New( "Courier New",,21,,.t.,,,,,.f. )  
oFont8c := TFont():New( "Courier New",,21,,.f.,,,,,.f. )
oFont9c := TFont():New( "Courier New",,18,,.t.,,,,,.f. )  
oFont10c:= TFont():New( "Courier New",,18,,.f.,,,,,.f. ) 

oFont6v := TFont():New( "Lucida Console",,12,,.f.,,,,,.f. )

nDescProd:= 0
nTotal   := 0
nTotMerc := 0
cCondBus := cParam1
nOrder	:=	1
nPagD:=1   
cObsPed  :=""      
cPedEntr :="" 
nValFrete2:=0   
cCodIni := cParam1
cCodFim := cParam2 

If Empty(cCodIni)
	cCodIni := SC7->C7_NUM
	cCodFim := SC7->C7_NUM 
	cCondBus := SC7->C7_NUM	
EndIf 
	
	dbSelectArea("SC7")
	dbSetOrder(nOrder)
	//SetRegua(nPagD)
	dbSeek(xFilial("SC7")+cCondBus,.T.) 
	
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Faz contagem de paginas                                           ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ	
	While !Eof() .And. C7_FILIAL == xFilial("SC7") .And. C7_NUM >= cCodIni .And. ;
			           C7_NUM <= cCodFim 
			           
		nTotPag++			           	    
		
			
		dbSkip()
	EndDo      
	
	nTotPag := nTotPag/15	
	
	If nTotPag > Int(nTotPag)
		nTotPag:=Int(nTotPag)+1			
	Else
		nTotPag	:= Int(nTotPag)
	EndIf
	
	If Empty(nTotPag)
		nTotPag:=1
	EndIf
	
	dbSelectArea("SC7")
	dbSetOrder(nOrder)
	//SetRegua(nPagD)
	dbSeek(xFilial("SC7")+cCondBus,.T.) 	                           
	

	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Faz manualmente porque nao chama a funcao Cabec()                 ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	While !Eof() .And. C7_FILIAL == xFilial("SC7") .And. C7_NUM >= cCodIni .And. ;
			           C7_NUM <= cCodFim
		
		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³ Cria as variaveis para armazenar os valores do pedido        ³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		nOrdem   := 1
		nReem    := 0
		nPag     := 1 

		If (C7_EMISSAO < dParam3) .Or. (C7_EMISSAO > dParam4)
			dbSkip()
			Loop
		Endif     
		
	
		If ! Empty(SC7->C7_FILENT) .And. SC7->C7_FILIAL <> SC7->C7_FILENT
			SM0->(dbSetOrder(1))
			SM0->(dbSeek(cEmpAnt+SC7->C7_FILENT))
			If SM0->(! Eof())
				aDadEmp := {	SM0->M0_NOMECOM,SM0->M0_TEL,SM0->M0_FAX,SM0->M0_CGC,SM0->M0_INSC,SM0->M0_ENDENT,SM0->M0_BAIRENT,SM0->M0_CIDENT,;
								SM0->M0_ESTENT,SM0->M0_CEPENT,SM0->M0_ENDCOB,SM0->M0_BAIRCOB,SM0->M0_CIDCOB,SM0->M0_ESTCOB,SM0->M0_CEPCOB}
			Else
				SM0->(dbGoTo(nRegSM0))
				aDadEmp := {	SM0->M0_NOMECOM,SM0->M0_TEL,SM0->M0_FAX,SM0->M0_CGC,SM0->M0_INSC,SM0->M0_ENDENT,SM0->M0_BAIRENT,SM0->M0_CIDENT,;
								SM0->M0_ESTENT,SM0->M0_CEPENT,SM0->M0_ENDCOB,SM0->M0_BAIRCOB,SM0->M0_CIDCOB,SM0->M0_ESTCOB,SM0->M0_CEPCOB}
			EndIf
		Else
			SM0->(dbGoTo(nRegSM0))
			aDadEmp := {	SM0->M0_NOMECOM,SM0->M0_TEL,SM0->M0_FAX,SM0->M0_CGC,SM0->M0_INSC,SM0->M0_ENDENT,SM0->M0_BAIRENT,SM0->M0_CIDENT,;
							SM0->M0_ESTENT,SM0->M0_CEPENT,SM0->M0_ENDCOB,SM0->M0_BAIRCOB,SM0->M0_CIDCOB,SM0->M0_ESTCOB,SM0->M0_CEPCOB}
		EndIf
		
		MaFisEnd()
		R110FIniPC(SC7->C7_NUM,,,)

		
		For ncw := 1 To nParam6		// Imprime o numero de vias informadas
			
			
			nTotal   := 0
			nTotMerc := 0
			nDescProd:= 0
   		nReem    := 1
			nSavRec  := SC7->(Recno())
			NumPed   := SC7->C7_NUM
	        li       := 465        
	        nTotDesc := 0
	        cFornece := SC7->(C7_FORNECE+C7_LOJA)
	        

			ImpCabec(aDadEmp)

			While !Eof() .And. SC7->C7_FILIAL == xFilial("SC7") .And. SC7->C7_NUM == NumPed 

				dbSelectArea("SC7")
				If Ascan(aSavRec,Recno()) == 0		// Guardo recno p/gravacao
					AADD(aSavRec,Recno())
				Endif

				//IncRegua()

				//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
				//³ Verifica se havera salto de formulario                       ³
				//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
				If li > 1500
					nOrdem++
//					nPag++
					ImpRodape()			// Imprime rodape do formulario e salta para a proxima folha
					ImpCabec(aDadEmp)
					li  := 465
				Endif

				If !Empty(SC7->C7_RESIDUO) .And. SC7->C7_QUJE == 0
				   dbSkip()
				   Loop 
				EndIf 
				
				If !Empty(SC7->C7_RESIDUO) .And. SC7->C7_QUJE <> 0
				   lAux := .T. 
				EndIf 
				
		        li:=li+60
				
				oPrn:Say( li, 0050, StrZero(Val(SC7->C7_ITEM),4)  ,oFont6,100 )
	            oPrn:Say( li, 0135, UPPER(SC7->C7_PRODUTO),oFont6,100 )
	
				//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
				//³ Pesquisa Descricao do Produto                                ³
				//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
				ImpProd()
	
				If SC7->C7_DESC1 != 0 .or. SC7->C7_DESC2 != 0 .or. SC7->C7_DESC3 != 0
					nDescProd+= CalcDesc(SC7->C7_TOTAL,SC7->C7_DESC1,SC7->C7_DESC2,SC7->C7_DESC3)
				Else
					nDescProd+=SC7->C7_VLDESC
				Endif            

				dbSkip()
			EndDo
			
			dbGoto(nSavRec)
	
			If li>1550
				nOrdem++
				ImpRodape()		// Imprime rodape do formulario e salta para a proxima folha
				ImpCabec(aDadEmp)
				li  := 465
			Endif
	
			FinalPed(aDadEmp)		// Imprime os dados complementares do PC
	
		Next
	
		MaFisEnd()  
      
      	dbSelectArea("SC7")
		If Len(aSavRec)>0
			For i:=1 to Len(aSavRec)
				dbGoto(aSavRec[i])
   //				RecLock("SC7",.F.)  //Atualizacao do flag de Impressao
	//			MsUnLock()
			Next
			dbGoto(aSavRec[Len(aSavRec)])		// Posiciona no ultimo elemento e limpa array
		Endif              	 
				
		dbGoto(aSavRec[Len(aSavRec)])		// Posiciona no ultimo elemento e limpa array
	
		aSavRec := {}
		
		dbSkip()
	EndDo

	dbSelectArea("SC7")
	Set Filter To
	dbSetOrder(1)

	dbSelectArea("SX3")
	dbSetOrder(1)

	If lEnc
		oPrn:EndPage()
		oPrn:Preview()

		if empty( cNomARQ )
			fErase( GetSrvProfString("Startpath","") + "MCCOMR01_"+__cUserID+".pdf")
		endif
	EndIf

	SM0->(dbGoTo(nRegSM0))

Return .T.

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡…o    ³ ImpCabec ³ Autor ³ Wagner Xavier         ³ Data ³          ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³ Imprime o Cabecalho do Pedido de Compra                    ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Sintaxe   ³ ImpCabec(Void)                                             ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³ MatR110                                                    ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
Static Function ImpCabec(aDadEmp)
Local nOrden, cCGC
LOCAL cMoeda
LOcal cAlter	:=	""
Local cCompr	:=	"" 
Local cAprov    :=	""
Local cTipoSC7  :=	""
Local oMainPrt
Local cStartPath := GetSrvProfString("Startpath","")

Public cAprovador := ""   
Private cSubject

	cMoeda := Iif(nParam7<10,Str(nParam7,1),Str(nParam7,2))

	If ! lPrimPag
		oPrn:EndPage()
		oPrn:StartPage() 
	Else
		lPrimPag := .f.
		lEnc     := .t.

		if empty( cNomARQ )
			if file(getTempPath()+"MCCOMR01_"+__cUserID+".pdf")
				fErase(getTempPath()+"MCCOMR01_"+__cUserID+".pdf")
			endif

			oPrn := FWMSPrinter():New("MCCOMR01_"+__cUserID,IMP_SPOOL,,,.T.)
			oPrn:SetLandscape()
			oPrn:SetPaperSize( 9 )	//9 - A4     210mm x 297mm  620 x 876
			oPrn:SetMargin( 40, 0, 0, -40 ) // nEsquerda, nSuperior, nDireita, nInferior

			oPrn:nDevice := IMP_PDF
			oPrn:cPathPDF := Alltrim( getTempPath() )
			oPrn:SetViewPDF( .T. )
		else
			oPrn:=FWMSPrinter():New( cNomARQ, IMP_PDF, .T., cStartPath, .T.)
			oPrn:SetLandscape()
			oPrn:SetPaperSize( 9 )
//			oPrn:SetMargin(20,20,20,20)
			oPrn:SetMargin( 40, 0, 0, -40 ) // nEsquerda, nSuperior, nDireita, nInferior
			oPrn:cPathPDF := Alltrim( cStartPath )
			oPrn:SetViewPDF( .F. )
		endif
		oPrn:StartPage()
	endif

//oPrn:Say( 0020, 0020, " ",oFont,100 ) // startando a impressora   
	cCompr:= LEFT(UsrFullName(SC7->C7_USER),20)           
	cTipoSC7:= IIF(SC7->C7_TIPO == 1,"PC","AE")	

	dbSelectArea("SCR")
	dbSetOrder(1)
	dbSeek(xFilial("SC7")+"PC"+SC7->C7_NUM)
	cAprov := "A G U A R.   L I B."
	While !Eof() .And. SCR->CR_FILIAL+Alltrim(SCR->CR_NUM) == xFilial("SC7")+SC7->C7_NUM .And. SCR->CR_TIPO == cTipoSC7
		cAprovador := AllTrim(UsrFullName(SCR->CR_USER))
		Do Case
			Case SCR->CR_STATUS=="03" //Liberado
				cAprov := "L I B E R A D O"
			Case SCR->CR_STATUS=="04" //Bloqueado
				cAprov := "B L O Q E A D O"
			Case SCR->CR_STATUS=="05" //Nivel Liberado
				cAprov := "N I V E L   L I B."
			OtherWise                 //Aguar.Lib
				cAprov := "A G U A R.   L I B."
		EndCase
		dbSelectArea("SCR")
		dbSkip()
	Enddo

//Cabecalho (Logomarca e Titulo)
	oPrn:Box( 0040, 0040, 0170,2920,"-5")
     
	oPrn:SayBitmap( 0030,0050,"selfitlogopc.jpg",0140,0135 ) 


//Cabecalho (Enderecos da Empresa e Fornecedor)
	oPrn:Box( 0170, 0040, 0420,0910,"-5")
	oPrn:Box( 0170, 0910, 0420,2300,"-5")
	oPrn:Box( 0170, 2300, 0420,2920,"-5")


//Cabecalho Produto do Pedido
	oPrn:Box( 0420, 0040, 0480,0125,"-5")//Item
	oPrn:Box( 0420, 0125, 0480,0340,"-5")//Codigo  
	oPrn:Box( 0420, 0340, 0480,1190,"-5")//Desc  
	oPrn:Box( 0420, 1190, 0480,1545,"-5")//Obs
	oPrn:Box( 0420, 1545, 0480,1650,"-5")//Un     
	oPrn:Box( 0420, 1650, 0480,1790,"-5")//Qtde
	oPrn:Box( 0420, 1790, 0480,2050,"-5")//Valor Total
	oPrn:Box( 0420, 2050, 0480,2160,"-5")//ICM
	oPrn:Box( 0420, 2160, 0480,2300,"-5")//IPI
	oPrn:Box( 0420, 2300, 0480,2490,"-5")//Valor Uni
	oPrn:Box( 0420, 2490, 0480,2655,"-5")//Dt Entr 
	oPrn:Box( 0420, 2635, 0480,2870,"-5")//Centro Custo
	oPrn:Box( 0420, 2810, 0480,2920,"-5")//Solic.

//Espaco dos Itens do Pedido                      
	oPrn:Box( 0480, 0040, nLinMaxIte,0125,"-5")  //Item 
	oPrn:Box( 0480, 0125, nLinMaxIte,0340,"-5")  //Codigo
	oPrn:Box( 0480, 0340, nLinMaxIte,1190,"-5")  //Descri
	oPrn:Box( 0480, 1190, nLinMaxIte,1545,"-5")  //Obs
	oPrn:Box( 0480, 1545, nLinMaxIte,1650,"-5") //UN
	oPrn:Box( 0480, 1650, nLinMaxIte,1790,"-5") //Qtde
	oPrn:Box( 0480, 1790, nLinMaxIte,2050,"-5") //Valor Total
	oPrn:Box( 0480, 2050, nLinMaxIte,2160,"-5") //ICM
	oPrn:Box( 0480, 2160, nLinMaxIte,2300,"-5") //IPI
	oPrn:Box( 0480, 2300, nLinMaxIte,2490,"-5") //Valor Uni
	oPrn:Box( 0480, 2490, nLinMaxIte,2655,"-5") //Dt Entr
	oPrn:Box( 0480, 2635, nLinMaxIte,2870,"-5") //Centro Custo
	oPrn:Box( 0480, 2810, nLinMaxIte,2920,"-5") //Solic.   
/*
//Cabecalho Produto do Pedido
	oPrn:Box( 0420, 0040, 0480,0125,"-5")//Item
	oPrn:Box( 0420, 0125, 0480,0340,"-5")//Codigo  
	oPrn:Box( 0420, 0340, 0480,1190,"-5")//Desc  
	oPrn:Box( 0420, 1190, 0480,1545,"-5")//Obs
	oPrn:Box( 0420, 1545, 0480,1650,"-5")//Un     
	oPrn:Box( 0420, 1650, 0480,1790,"-5")//Qtde
	oPrn:Box( 0420, 1790, 0480,2050,"-5")//Valor Total
	oPrn:Box( 0420, 2050, 0480,2160,"-5")//ICM
	oPrn:Box( 0420, 2160, 0480,2300,"-5")//IPI
	oPrn:Box( 0420, 2300, 0480,2490,"-5")//Valor Uni
	oPrn:Box( 0420, 2490, 0480,2655,"-5")//Dt Entr 
	oPrn:Box( 0420, 2700, 0480,2900,"-5")//Centro Custo
	oPrn:Box( 0420, 2810, 0480,3100,"-5")//Solic.

//Espaco dos Itens do Pedido                      
	oPrn:Box( 0480, 0040, nLinMaxIte,0125,"-5")  //Item 
	oPrn:Box( 0480, 0125, nLinMaxIte,0340,"-5")  //Codigo
	oPrn:Box( 0480, 0340, nLinMaxIte,1190,"-5")  //Descri
	oPrn:Box( 0480, 1190, nLinMaxIte,1545,"-5")  //Obs
	oPrn:Box( 0480, 1545, nLinMaxIte,1650,"-5") //UN
	oPrn:Box( 0480, 1650, nLinMaxIte,1790,"-5") //Qtde
	oPrn:Box( 0480, 1790, nLinMaxIte,2050,"-5") //Valor Total
	oPrn:Box( 0480, 2050, nLinMaxIte,2160,"-5") //ICM
	oPrn:Box( 0480, 2160, nLinMaxIte,2300,"-5") //IPI
	oPrn:Box( 0480, 2300, nLinMaxIte,2490,"-5") //Valor Uni
	oPrn:Box( 0480, 2490, nLinMaxIte,2655,"-5") //Dt Entr 
	oPrn:Box( 0480, 2700, nLinMaxIte,2900,"-5") //Centro Custo
	oPrn:Box( 0480, 2810, nLinMaxIte,3100,"-5") //Solic.

*/                    	
	dbSelectArea("SA2")
	dbSetOrder(1)
	dbSeek(xFilial("SA2")+SC7->C7_FORNECE+SC7->C7_LOJA)

//Titulo                       
	If SC7->C7_TIPO==1
		oPrn:Say( 0130, 0955, "P E D I D O   D E   C O M P R A S",oFont1,50 )
	Else
		oPrn:Say( 0130, 0955, "A U T O R I Z A Ç Ã O   D E   E N T R E G A",oFont1,100 )
	EndIf


//Numero do pedido
	oPrn:Say( 0120, 2650, "FOLHA:" ,oFont3,100 )
	oPrn:Say( 0120, 2790, Alltrim(StrZero(nPag,2))+"/"+Alltrim(StrZero(nTotPag,2)),oFont3,100 )
	oPrn:Say( 0235, 2360, "Nº "+SC7->C7_NUM,oFont7,100 )
	oPrn:Say( 0220, 2550, Str(nReem) + "º Via",oFont5,100 )
	oPrn:Say( 0315, 2360, "DATA EMISSÃO: " + DTOC(SC7->C7_EMISSAO) ,oFont6,100 )
    oPrn:Say( 0350, 2360, "PEDIDO: " + cAprov,        oFont6,100 )
//oP

 

//Dados da empresa coluna 1
	
	oPrn:Say( 0210, 0060, "EMPRESA: "+aDadEmp[01] ,oFont6,100 )
	oPrn:Say( 0245, 0060, "CNPJ/CPF" + " "+ Transform(aDadEmp[04],cCgcPict) ,oFont6,100 ) 
	oPrn:Say( 0280, 0060, "ENDEREÇO: "+SubStr(UPPER(aDadEmp[06]),1,25) ,oFont6,100 )
	oPrn:Say( 0315, 0060, "BAIRRO: " + UPPER(Substr(aDadEmp[07],1,25)),oFont6,100)
	oPrn:Say( 0350, 0060, UPPER("CEP: "+Trans(aDadEmp[10],cCepPict)),oFont6,100 )
	oPrn:Say( 0385, 0060, "TEL: " + aDadEmp[02] ,oFont6,100 )

//Dados da empresa coluna 2
	oPrn:Say( 0245, 0610, "IE: " + aDadEmp[05] ,oFont6,100 )
	oPrn:Say( 0315, 0610, UPPER(Trim("SBC")+"-"+aDadEmp[09]) ,oFont6,100 )
	oPrn:Say( 0385, 0610, "FAX: " + aDadEmp[03] ,oFont6,100 )

//Dados do fornecedor coluna 1
	oPrn:Say( 0210, 0950, "FORNECEDOR: "+Alltrim(Substr(SA2->A2_NOME,1,40))+" - ("+SA2->A2_COD+")",oFont6,100 )
	oPrn:Say( 0245, 0950, "CNPJ: " + Transform(SA2->A2_CGC,cCgcPict) ,oFont6,100 )
	oPrn:Say( 0280, 0950, "ENDEREÇO: "+UPPER(Substr(SA2->A2_END,1,40)) ,oFont6,100 )
	oPrn:Say( 0315, 0950, "CEP: "+ SA2->A2_CEP ,oFont6,100 )
	oPrn:Say( 0350, 0955, "FONE: " + "("+Substr(SA2->A2_DDD,1,3)+") "+Substr(SA2->A2_TEL,1,15) ,oFont6,100 )

//Dados do fornecedor coluna 2
	oPrn:Say( 0245, 1950, "IE: " + SA2->A2_INSCR ,oFont6,100 )
	oPrn:Say( 0280, 1950, "BAIRRO: " + Substr(SA2->A2_BAIRRO,1,25) ,oFont6,100 )
	oPrn:Say( 0315, 1950, Upper(Trim(SA2->A2_MUN)+" - "+SA2->A2_EST),oFont6,100 )
	oPrn:Say( 0350, 1950, "FAX: " + "("+Substr(SA2->A2_DDD,1,3)+") "+SA2->A2_FAX ,oFont6,100 )
	oPrn:Say( 0385, 1950, "VENDEDOR: " + Upper(Substr(SC7->C7_CONTATO,1,25)),oFont6,100 )

//Titulos
	oPrn:Say( 0465, 0050, "Item"  ,oFont3,100 )
	oPrn:Say( 0465, 0135, "Código" ,oFont3,100 )
	oPrn:Say( 0465, 0350, "Descrição do Material e/ou Serviço" ,oFont3,100 )
	oPrn:Say( 0465, 1200, "Observações" ,oFont3,100 )
	oPrn:Say( 0465, 1555, "UN" ,oFont3,100 )
	oPrn:Say( 0465, 1660, "Qtde"  ,oFont3,100 )
	oPrn:Say( 0465, 1800, "Valor Unit." ,oFont3,100 )
	oPrn:Say( 0465, 2060, "ICM%" ,oFont3,100 )
	oPrn:Say( 0465, 2170, "IPI%" ,oFont3,100 )
	oPrn:Say( 0465, 2310, "Valor Total" ,oFont3,100 )
	oPrn:Say( 0465, 2500, "Dt Entr" ,oFont3,100 )
	oPrn:Say( 0465, 2635, "Centro C." ,oFont3,100 )
	oPrn:Say( 0465, 2820, "SC" ,oFont3,100 )

	cSubject := "Pedido de Compras nr."+SC7->C7_NUM+" / "+AllTrim(Left(SA2->A2_NOME,30))

Return .T.

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡…o    ³ ImpProd  ³ Autor ³ Wagner Xavier         ³ Data ³          ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³ Pesquisar e imprimir  dados Cadastrais do Produto.         ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Sintaxe   ³ ImpProd(Void)                                              ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³ MatR110                                                    ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
Static Function ImpProd()
LOCAL cDesc, nLinRef := 1, nBegin := 0, cDescri := "", nLinha:=0,;
		nTamDesc := 50 , aColuna := Array(8)

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Impressao da descricao generica do Produto.                  ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ   

cObs    := Alltrim(SC7->C7_OBS)
cDescri := Alltrim(SC7->C7_DESCRI)

/*
if SC7->( fieldPos("C7_DESCRIC") ) > 0 .and. ! empty(SC7->C7_DESCRIC)	// Cristiam
	cDescri += " " + Alltrim(SC7->C7_DESCRIC)
endif

if SC7->( fieldPos("C7_ZOBSUS1") ) > 0 .and. ! empty(SC7->C7_ZOBSUS1)	// Cristiam
	cDescri += " " + Alltrim(SC7->C7_ZOBSUS1)
endif

if SC7->( fieldPos("C7_ZOBSUS2") ) > 0 .and. ! empty(SC7->C7_ZOBSUS2)	// Cristiam
	cDescri += " " + Alltrim(SC7->C7_ZOBSUS2)
endif

*/
SB1->( dbSetOrder(1) )
if SB1->( dbSeek( xFilial("SB1") + SC7->C7_PRODUTO ) )
		cDescri := alltrim(SB1->B1_DESC)
endif

dbSelectArea("SC7")
nLinhaD:= MLCount(cDescri,)
nLinhaO:= MLCount(cObs,20)
nLinha := If(nLinhaD>nLInhaO,nLinhaD,nLinhaO)
oPrn:Say( li, 0350, MemoLine(cDescri,nTamDesc,1) ,oFont6,100 )
oPrn:Say( li, 1200, MemoLine(cObs,nTamDesc,1),    oFont6,100 )

ImpCampos()

For nBegin := 2 To nLinha
	li+=35
	If nLinhaD>=nBegin
		oPrn:Say( li, 0350, MemoLine(cDescri,nTamDesc,nBegin) ,oFont6,100 )
	EndIf
	If nLinhaO>=nBegin
		oPrn:Say( li, 1200, MemoLine(cObs,20,nBegin),oFont6,100 )
	EndIf
Next nBegin

Return NIL

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡…o    ³ ImpCampos³ Autor ³ Wagner Xavier         ³ Data ³          ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³ Imprimir dados Complementares do Produto no Pedido.        ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Sintaxe   ³ ImpCampos(Void)                                            ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³ MatR110                                                    ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
Static Function ImpCampos()

dbSelectArea("SC7")   
     
//	Unidade
If nParam5 == 2 .And. !Empty(SC7->C7_SEGUM)
   oPrn:Say( li, 1555, SC7->C7_SEGUM ,oFont6,100 )
Else
   oPrn:Say( li, 1555, SC7->C7_UM ,oFont6,100 )
EndIf             
// Quantidade
If nParam5 == 2 .And. !Empty(SC7->C7_QTSEGUM) 
   If !lAux
      oPrn:Say( li,1660, Transform(SC7->C7_QTSEGUM,"@E 999,999.99") ,oFont6,100 )
   Else
      oPrn:Say( li,1660, Transform(SC7->C7_QUJE,"@E 999,999.99") ,oFont6,100 )   
   EndIf 
Else
   If !lAux 
      oPrn:Say( li,1660, Transform(SC7->C7_QUANT,"@E 999,999.99") ,oFont6,100 )
   Else 
      oPrn:Say( li,1660, Transform(SC7->C7_QUJE,"@E 999,999.9") ,oFont6,100 )   
   EndIf 
EndIf                                       

// Valor Unitario
If nParam5 == 2 .And. !Empty(SC7->C7_QTSEGUM)  
   If !lAux
      oPrn:Say( li, 1800, Transform(xMoeda((SC7->C7_TOTAL/SC7->C7_QTSEGUM),SC7->C7_MOEDA,nParam7,SC7->C7_DATPRF),PesqPict("SC7","C7_PRECO",14, nParam7)) ,oFont6,100 )
   Else 
      oPrn:Say( li, 1800, Transform(xMoeda((SC7->C7_PRECO),SC7->C7_MOEDA,nParam7,SC7->C7_DATPRF),PesqPict("SC7","C7_PRECO",14, nParam7)) ,oFont6,100 )   
   EndIf    
Else
   oPrn:Say( li, 1800, Transform(SC7->C7_PRECO,"@E 9,999,999.99") ,oFont6,100 )
EndIf

// ICM
//oPrn:Say( li, 2250, Transform(SC7->C7_PICM,"@E 99.9") ,oFont6,100 ) excluido solicitado pelo chamado 15666
// IPI
oPrn:Say( li, 2170, Transform(SC7->C7_IPI,"@E 99.9") ,oFont6,100 ) 
// Valor Total
If !lAux 
   oPrn:Say( li, 2310, Transform(SC7->C7_TOTAL,"@E 9,999,999.99") ,oFont6,100 )
Else
   oPrn:Say( li, 2310, Transform(SC7->C7_PRECO * SC7->C7_QUJE,"@E 9,999,999.99") ,oFont6,100 )
EndIf

 oPrn:Say( li, 2500, DTOC(SC7->C7_DATPRF) ,oFont6,100 )

// Centro de Custo
oPrn:Say( li, 2630, Transform(SC7->C7_CC,"@E 9999999999") ,oFont6,100 )
// Solic.
oPrn:Say( li, 2820, SC7->C7_NUMSC ,oFont6,100 )

//nTotal  :=nTotal+IIF(!lAux,SC7->C7_TOTAL,SC7->C7_PRECO * SC7->C7_QUJE)
nTotal     := nTotal + SC7->C7_TOTAL

nTotMerc:= nTotal // MaFisRet(,"NF_TOTAL") -> antes
nTotDesc+=SC7->C7_VLDESC

If lAux 
   nValIPI  += (SC7->C7_VALIPI /SC7->C7_QUANT)*SC7->C7_QUJE
Else
   nValIpi  += SC7->C7_VALIPI
EndIf  


lAux := .F. 
Return .T.  

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡…o    ³ ImpRodape³ Autor ³ Leandro Eber Ribeiro  ³ Data ³          ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³ Imprime o rodape do formulario e salta para a proxima folha³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Sintaxe   ³ ImpRodape(Void)   			         					  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Parametros³ 					                     				      ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³ MatR110                                                    ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
Static Function ImpRodape()

oPrn:Say( 1650, 1810, "***************  CONTINUA  ***************" ,oFont3,100 )
nPag++

Return .T. 

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡…o    ³ FinalPed ³ Autor ³ Leandro Eber Ribeiro  ³ Data ³          ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³ Imprime os dados complementares do Pedido de Compra        ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Sintaxe   ³ FinalPed(Void)                                             ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³ MatR110                                                    ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
Static Function FinalPed(aDadEmp)

Local nk 		:= 1,nG
Local nQuebra	:= 0
Local lNewAlc	:= .F.
Local lLiber 	:= .F.
Local lImpLeg	:= .T.
Local cComprador:=	""
LOcal cAlter	:=	""
Local cAprova	:=	""
Local cCompr	:=	""
Local cEmail	:=	""
Local cTele		:=	""
Local cObsPe	:=	""
Local aColuna   := Array(8), nTotLinhas 
Local nTotIpi	:= nValIPI
Local nTotIcms	:= 0
Local nTotDesp	:= MaFisRet(,'NF_DESPESA')
Local nTotFrete := 0//MaFisRet(,'NF_FRETE')
Local nTotalNF	:= MaFisRet(,'NF_TOTAL')
Local nTotSeguro:= MaFisRet(,'NF_SEGURO')
Local aValIVA   := MaFisRet(,"NF_VALIMP")
Local cTPFrete



//Rodape
oPrn:Box( nLinMaxIte, 0040, nLinMaxIte + 100,2250,"-5") // Desconto
oPrn:Box( nLinMaxIte, 2250, nLinMaxIte + 100,2920,"-5") // Sub Total  

oPrn:Box( nLinMaxIte + 100, 0040, nLinMaxIte + 200,0800,"-5") //Impostos IPI
oPrn:Box( nLinMaxIte + 100, 0800, nLinMaxIte + 200,1500,"-5") //Impostos Frete
oPrn:Box( nLinMaxIte + 100, 1500, nLinMaxIte + 200,2250,"-5") //Impostos Pagto
oPrn:Box( nLinMaxIte + 100, 2250, nLinMaxIte + 200,2920,"-5") //Total S IMpostos

oPrn:Box( nLinMaxIte + 200, 0040, nLinMaxIte + 350,1500,"-5") // Endereco
oPrn:Box( nLinMaxIte + 200, 1500, nLinMaxIte + 350,2250,"-5") //Comprador
oPrn:Box( nLinMaxIte + 200, 2250, nLinMaxIte + 350,2920,"-5") // Total geral

oPrn:Box( nLinMaxIte + 350, 0040, nLinMaxIte + 590,2920,"-5") //2130 Obs Finais   

If cPaisLoc <> "BRA" .And. !Empty(aValIVA)
   For nG:=1 to Len(aValIVA)
       nValIVA+=aValIVA[nG]
   Next
Endif   
   
    //Seleciona o Aprovador se existir
	dbSelectArea("SCR")
	dbSetOrder(1)
	dbSeek(xFilial("SC7")+"PC"+SC7->C7_NUM)
	While !Eof() .And. SCR->CR_FILIAL+Alltrim(SCR->CR_NUM)==xFilial("SC7")+SC7->C7_NUM .And. SCR->CR_TIPO == "PC"
		IF SCR->CR_STATUS=="03"
			cAprova += AllTrim(UsrFullName(SCR->CR_USER))
		EndIF
		dbSelectArea("SCR")
		dbSkip()
	Enddo  
	
	cAprova := "Não Aprovado"     
	
	//Seleciona o Comprador
	cCompr:= LEFT(UsrFullName(SC7->C7_USER),20)
	cObsPe:= SC7->C7_OBS                                         
	cEmail	:= Posicione("SY1", 3, xFilial("SY1")+SC7->C7_USER		, "Y1_EMAIL")
	cTele	:= Posicione("SY1", 3, xFilial("SY1")+SC7->C7_USER		, "Y1_TEL")

	
//nTotIpi	    := SC7->C7_VALIPI
//nTotIcms	:= SC7->C7_VALICM
//nTotDesp	:= SC7->C7_DESPESA
//nTotalNF	:= SC7->C7_TOTAL
//nTotSeguro  := SC7->C7_SEGURO
//aValIVA     := SC7->C7_VALIMP
	           

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Impressso de Descontos Logo abaixo dos itens                 ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

oPrn:Say( nLinMaxIte + 60, 0420, "D E S C O N T O -->" ,oFont3,100 ) 

oPrn:Say( nLinMaxIte + 60, 0850, Transform(SC7->C7_DESC1,"@E999.99")+" %" ,oFont4,100 )
oPrn:Say( nLinMaxIte + 60, 0950, Transform(SC7->C7_DESC2,"@E999.99")+" %" ,oFont4,100 )
oPrn:Say( nLinMaxIte + 60, 1050, Transform(SC7->C7_DESC3,"@E999.99")+" %" ,oFont4,100 ) 
                                                      
//Aglutina os desconto de itens com do pedido
//nTotDesc += SC7->C7_DESC1+SC7->C7_DESC1+SC7->C7_DESC1 

oPrn:Say( nLinMaxIte + 60, 1300, Transform(xMoeda(nTotDesc,SC7->C7_MOEDA,nParam7,SC7->C7_DATPRF),PesqPict("SC7","C7_VLDESC",14, nParam7)) ,oFont4,100 )


dbSelectArea("SM4")
dbSetOrder(1)
dbSelectArea("SC7")
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Impressso de dos impostos                                    ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

If SC7->C7_TPFRETE == 'C'
cTPFrete := "CIF"
nTotFrete2:= MaFisRet(,'NF_FRETE')
nTotFrete:= MaFisRet(,'NF_FRETE')
Else
cTPFrete := "FOB"        
nTotFrete2:= MaFisRet(,'NF_FRETE')
nTotFrete:= 0
EndIf

//Primeira Caixa de Impostos
oPrn:Say( nLinMaxIte + 140, 0060, "IPI :" ,oFont3,100 )
oPrn:Say( nLinMaxIte + 140, 0200, Transform(xMoeda(nTotIPI,SC7->C7_MOEDA,nParam7,SC7->C7_DATPRF),tm(nTotIpi,14,MsDecimais(nParam7))) ,oFont4c,100 )
oPrn:Say( nLinMaxIte + 180, 0060, "ICMS :" ,oFont3,100 )
oPrn:Say( nLinMaxIte + 180, 0200, Transform(xMoeda(nTotIcms,SC7->C7_MOEDA,nParam7,SC7->C7_DATPRF),tm(nTotIcms,14,MsDecimais(nParam7))) ,oFont4c,100 )
//Segunda Caixa de Impostos
oPrn:Say( nLinMaxIte + 140, 0820, "Frete + Despesas:" ,oFont3,100 )
oPrn:Say( nLinMaxIte + 140, 1100, Transform(xMoeda(nTotFrete2+nTotDesp,SC7->C7_MOEDA,nParam7,SC7->C7_DATPRF),tm(nTotFrete,14,MsDecimais(nParam7))) ,oFont4c,100 )
oPrn:Say( nLinMaxIte + 180, 0820, "Obs. Frete :" ,oFont3,100 )
oPrn:Say( nLinMaxIte + 180, 1100, Alltrim(cTPFrete),oFont4c,100 )
//Terceira Caixa de Impostos

dbSelectArea("SE4")
dbSetOrder(1)
dbSeek(xFilial("SC7")+SC7->C7_COND)     //Tabela de Condição de pagamentos compartilhada
dbSelectArea("SC7")

oPrn:Say( nLinMaxIte + 140, 1520, "Condição de Pagto :" ,oFont3,100 )
oPrn:Say( nLinMaxIte + 140, 1850, Alltrim(SE4->E4_DESCRI),oFont6,100 )
oPrn:Say( nLinMaxIte + 180, 1520, "Seguro :" ,oFont3,100 )
oPrn:Say( nLinMaxIte + 180, 1850, Transform(xMoeda(nTotSeguro,SC7->C7_MOEDA,nParam7,SC7->C7_DATPRF),tm(nTotSeguro,14,MsDecimais(nParam7))),oFont6,100 )

oPrn:Say( nLinMaxIte + 60, 2270, "SUB TOTAL: " ,oFont3,100 )
oPrn:Say( nLinMaxIte + 55, 2550, Transform(xMoeda(nTotal,SC7->C7_MOEDA,nParam7,SC7->C7_DATPRF),tm(nTotal,14,MsDecimais(nParam7))) ,oFont6,100 )

oPrn:Say( nLinMaxIte + 270 , 0060, "Local de Entrega  : " ,oFont3,100 )

//Verifica se foi digitado algo no local de entrega
If Empty(Alltrim(cPedEntr))
		oPrn:Say( nLinMaxIte + 270 , 0420, Alltrim(Substr(aDadEmp[06],1,30))+" - "+ Alltrim(Substr(aDadEmp[07],1,30))+" - " +Alltrim(Substr(aDadEmp[08],1,30))+" / "+aDadEmp[09]+ " - " + UPPER("CEP: "+Trans(aDadEmp[10],cCepPict)),oFont6,100 )
Else  
	   oPrn:Say( nLinMaxIte + 270 , 0420, Upper(Alltrim(cPedEntr)) ,oFont6,100 )            
EndIf	

oPrn:Say( nLinMaxIte + 330 , 0060, "Local de Cobrança  : ",oFont3,100 )
oPrn:Say( nLinMaxIte + 330 , 0420, Alltrim(Substr(aDadEmp[11],1,30))+" - "+ Alltrim(Substr(aDadEmp[12],1,30))+" - " +Alltrim(Substr(aDadEmp[13],1,30))+" / "+aDadEmp[14]+ " - " + UPPER("CEP: "+Trans(aDadEmp[15],cCepPict)),oFont6,100 )

oPrn:Say( nLinMaxIte + 140 , 2270, "TOTAL S/ IMP.: ",oFont3,100 )
oPrn:Say( nLinMaxIte + 140 , 2580, Transform(xMoeda((nTotal+nTotFrete+nTotDesp+nTotSeguro)-(nTotDesc+nTotIcms),SC7->C7_MOEDA,nParam7,SC7->C7_DATPRF),tm((nTotal+nTotFrete+nTotDesp+nTotSeguro)-(nTotDesc+nTotIcms),14,MsDecimais(nParam7))),oFont6,100 )

oPrn:Say( nLinMaxIte + 280 , 2270, "TOTAL GERAL: ",oFont9,100 )
oPrn:Say( nLinMaxIte + 280 , 2460, Transform(xMoeda((nTotal+nTotFrete+nTotDesp+nTotSeguro+nTotIpi)-nTotDesc,SC7->C7_MOEDA,nParam7,SC7->C7_DATPRF),tm((nTotal+nTotFrete+nTotDesp+nTotSeguro+nTotIpi)-nTotDesc,14,MsDecimais(nParam7))),oFont9c,100 )

oPrn:Say( nLinMaxIte + 230 , 1520, "COMPRADOR:",oFont5,100 )
oPrn:Say( nLinMaxIte + 230 , 1700, UPPER(Alltrim(cCompr)),oFont6,100 )
//oPrn:Say( nLinMaxIte + 280 , 1750, "E-MAIL: ",oFont5,100 )
oPrn:Say( nLinMaxIte + 280 , 1520, "E-MAIL:",oFont5,100 )
oPrn:Say( nLinMaxIte + 280 , 1700, UPPER(Alltrim(cEmail)),oFont6,100 ) 
oPrn:Say( nLinMaxIte + 330 , 1520, "TEL:",oFont5,100 )
oPrn:Say( nLinMaxIte + 330 , 1700, TransForm(cTele, "@R (99)9999.9999"),oFont6,100 ) 

// efetuado backup por Fernando Lins e esta na pasta: D:\Totvs 12\Microsiga\Protheus\Projeto\Relatorios
// backup foi efetuado em 21-03-2018 para atendimento ao chamado: 56606 - de Jessica Melo.
// Linhas Originas antes das alterações:
// ---------------------------------------------------------------------------------------------------------                                                     
// oPrn:Say( nLinMaxIte + 470 , 0040,  " NOTAS: ",oFont7,100 )
// oPrn:Say( nLinMaxIte + 420 , 0265,  "1) FAVOR MENCIONAR NOSSO NUMERO DE PEDIDO DE COMPRAS NA NF, NÃO ACEITAMOS TITULO DE FACTORING.",oFont4,100 ) 
// oPrn:Say( nLinMaxIte + 470 , 0265,  "2) OS MATERIAIS DEVERÃO ATENDER AS ESPECIFICACÕES ACIMA CASO HOUVER DIVERGENCIA NO RECEBIMENTO DO MATERIAL, O MESMO ESTARA SUJEITO A DEVOLUCÃO E SANCÕES CABIVEIS. ",oFont4,100 ) 
// oPrn:Say( nLinMaxIte + 520 , 0265,  "3) A SIGMA SO REALIZA PAGAMENTOS AS QUINTAS FEIRAS, LIMITADO A TERCEIRA QUINTA DE CADA MÊS.",oFont4,100 )
// oPrn:Say( nLinMaxIte + 570 , 0265,  "4) FICAM AUTOMATICAMENTE PRORROGADAS OS VENCIMENTOS DE FATURAS QUE VENÇAM EM DATA DIVERSA, PARA A PRÓXIMA QUINTA FEIRA ÚTIL.",oFont4,100 )
// oPrn:Say( nLinMaxIte + 620 , 0265,  "5) ENVIAR XML PARA FINANCEIRO@SIGMA.IND.BR",oFont4,100 )
// ---------------------------------------------------------------------------------------------------------


//  Alterardo abaixo por Fernando Lins em 21-03-2018 - Inicio 
oPrn:Say( nLinMaxIte + 450 , 0040,  " NOTAS: ",oFont7,100 )
oPrn:Say( nLinMaxIte + 390 , 0265,  "1) FAVOR MENCIONAR NOSSO NUMERO DE PEDIDO DE COMPRAS NA NF, NÃO ACEITAMOS TITULO DE FACTORING.",oFont5,100 ) 
oPrn:Say( nLinMaxIte + 440 , 0265,  "2) OS MATERIAIS DEVERÃO ATENDER AS ESPECIFICACÕES ACIMA CASO HOUVER DIVERGENCIA NO RECEBIMENTO DO MATERIAL, O MESMO ESTARA SUJEITO A DEVOLUCÃO E SANCÕES CABIVEIS",oFont5,100 ) 
oPrn:Say( nLinMaxIte + 490 , 0265,  "3) A SIGMA SO REALIZA PAGAMENTOS AS QUINTAS FEIRAS, LIMITADO A TERCEIRA QUINTA DE CADA MÊS.",oFont5,100 )
oPrn:Say( nLinMaxIte + 540 , 0265,  "4) FICAM AUTOMATICAMENTE PRORROGADAS OS VENCIMENTOS DE FATURAS QUE VENÇAM EM DATA DIVERSA, PARA A PRÓXIMA QUINTA FEIRA ÚTIL.",oFont5,100 )
oPrn:Say( nLinMaxIte + 580 , 0265,  "5) ENVIAR XML PARA FINANCEIRO@SIGMA.IND.BR, E O PAGAMENTO SO SERÁ REALIZADO COM A NF REGISTRADA EM NOSSO SISTEMA",oFont5,100 )
//  Alterardo abaixo por Fernando Lins em 21-03-2018 - Termino

Return .T.



/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³ Funcao   ³VALIDPERG ³ Autor³Adalberto Moreno Batista³ Data ³11.02.2000³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
Static Function ValidPerg()

Local _aAlias := Alias(), aRegs
Local i := 0
Local j := 0

dbSelectArea("SX1")
dbSetOrder(1)
aRegs:={}
// Grupo/Ordem/Pergunta/Variavel/Tipo/Tamanho/Decimal/Presel/GSC/Valid/Var01/Def01/Cnt01/Var02/Def02/Cnt02/Var03/Def03/Cnt03/Var04/Def04/Cnt04/Var05/Def05/Cnt05
aAdd(aRegs,{cPerg,"01","Do Pedido ?","¿De Pedido?","From Order ?","mv_ch1","C",6,0,0,"G","","MV_PAR01","","","","000001","","","","","","","","","","","","","","","","","","","","","","S","",""})
aAdd(aRegs,{cPerg,"02","Até o Pedido ?","¿A  Pedido?","To Order ?","mv_ch2","C",6,0,0,"G","","MV_PAR02","","","","000001","","","","","","","","","","","","","","","","","","","","","","S","",""})
aAdd(aRegs,{cPerg,"03","A partir da Data ?","¿De Fecha?","From Date ?","mv_ch3","D",8,0,0,"G","","mv_par03","","","","'01/01/2016'","","","","","","","","","","","","","","","","","","","","","","S","",""})
aAdd(aRegs,{cPerg,"04","Até a Data ?","¿A  Fecha?","To Date ?","mv_ch4","D",0,0,0,"G","","mv_par04","","","","'31/12/2016'","","","","","","","","","","","","","","","","","","","","","","S","",""})
aAdd(aRegs,{cPerg,"05","Qual Unid. de Med. ?","¿Cual Unidad Medida?","Which Unit of Meas. ?","mv_ch5","N",1,0,1,"C","","mv_par05","Primaria","Primaria","Primary","","","Secundaria","Secundaria","Secondary","","","","","","","","","","","","","","","","","","S","",""})
aAdd(aRegs,{cPerg,"06","Numero de Vias ?","¿Numero de Copias?","Number of Copies ?","mv_ch6","N",2,0,0,"G","","mv_par06","","",""," 1","","","","","","","","","","","","","","","","","","","","","","S","",""})
aAdd(aRegs,{cPerg,"07","Qual Moeda ?","¿Cual Moneda?","Currency ?","mv_ch7","N",1,0,1,"C","","mv_par07","Moeda 1","Moneda 1","Currency 1","","","Moeda 2","Moneda 2","Currency 2","","","Moeda 3","Moneda 3","Currency 3","","","Moeda 4","Moneda 4","Currency 4","","","Moeda 5","Moneda 5","Currency 5","","","S","",""})

For i:=1 to Len(aRegs)
   //	If !dbSeek(cPerg+aRegs[i,2])  
    If SX1->( !MsSeek(padr(cPerg,10)+aRegs[i,2]) )
		RecLock("SX1",.T.)
		For j:=1 to FCount()
			If j <= Len(aRegs[i])
				FieldPut(j,aRegs[i,j])
			Endif
		Next
		MsUnlock()
	Endif
Next
dbSelectArea(_aAlias)   

Return




/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Funcao    ³R110FIniPC³ Autor ³ Edson Maricate        ³ Data ³20/05/2000³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descricao ³ Inicializa as funcoes Fiscais com o Pedido de Compras      ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Sintaxe   ³ R110FIniPC(ExpC1,ExpC2)                                    ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Parametros³ ExpC1 := Numero do Pedido                                  ³±±
±±³          ³ ExpC2 := Item do Pedido                                    ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³ MATR110,MATR120,Fluxo de Caixa                             ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
Static Function R110FIniPC(cPedido,cItem,cSequen,cFiltro)

Local aArea                        := GetArea()
Local aAreaSC7		:= SC7->(GetArea())
Local cValid                        := ""
Local nPosRef                   := 0
Local nItem                        := 0
Local cItemDe                   := IIf(cItem==Nil,'',cItem)
Local cItemAte := IIf(cItem==Nil,Repl('Z',Len(SC7->C7_ITEM)),cItem)
Local cRefCols   := ''

DEFAULT cSequen  := ""
DEFAULT cFiltro  := ""

dbSelectArea("SC7")
dbSetOrder(1)
If dbSeek(xFilial("SC7")+cPedido+cItemDe+Alltrim(cSequen))
                MaFisEnd()
                MaFisIni(SC7->C7_FORNECE,SC7->C7_LOJA,"F","N","R",{})
                While !Eof() .AND. SC7->C7_FILIAL+SC7->C7_NUM == xFilial("SC7")+cPedido .AND. ;
                                               SC7->C7_ITEM <= cItemAte .AND. (Empty(cSequen) .OR. cSequen == SC7->C7_SEQUEN)

                               // Nao processar os Impostos se o item possuir residuo eliminado  
                               If &cFiltro
                                               dbSelectArea('SC7')
                                               dbSkip()
                                               Loop
                               EndIf
            
                               // Inicia a Carga do item nas funcoes MATXFIS  
                               nItem++
                               MaFisIniLoad(nItem)
                               dbSelectArea("SX3")
                               dbSetOrder(1)
                               dbSeek('SC7')
                               While !EOF() .AND. (X3_ARQUIVO == 'SC7')
							   		If X3_CONTEXT <> "V"
                                        cValid    := StrTran(UPPER(SX3->X3_VALID)," ","")
                                        cValid    := StrTran(cValid,"'",'"')
                                        If "MAFISREF" $ cValid
											If X3_CONTEXT <> "V"
                                                nPosRef  := AT('MAFISREF("',cValid) + 10
                                                cRefCols := Substr(cValid,nPosRef,AT('","MT120",',cValid)-nPosRef )
                                                // Carrega os valores direto do SC7.           
                                                MaFisLoad(cRefCols,&("SC7->"+ SX3->X3_CAMPO),nItem)
											EndIF
                                    	EndIf
									EndIF
                                    dbSkip()
                               End
                               MaFisEndLoad(nItem,2)
                               dbSelectArea('SC7')
                               dbSkip()
                End
EndIf

RestArea(aAreaSC7)
RestArea(aArea)

Return .T.