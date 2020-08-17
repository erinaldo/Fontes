#INCLUDE "RWMAKE.CH"
/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±                                         
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄ¿±±
±±³Programa  ³ BOLBRA   ³ Autor   	  ³ Microsiga      ³ Data ³ 29/04/14  ³±±
±±³          ³          ³ Victor Ramon³ 					  ³           ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄ´±±
±±³Descri‡…o ³ IMPRESSAO DO BOLETO BANCO Bradesco COM CODIGO DE BARRAS    ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Uso       ³ Especifico para Clientes Plantec Distribuidora             ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
User Function BOLBRA()

                                     
LOCAL	aPergs 		:= {} 
Local	aVetor   	:= {}
Private aBCOBMP 
PRIVATE lExec    	:= .F.
PRIVATE cIndexName 	:= ''
PRIVATE cIndexKey  	:= ''
PRIVATE cFilter    	:= ''
Private cLogoBra  := "Bradesco.bmp"

Private cMV_PAR01 := ""
Private cMV_PAR02 := ""
Private cMV_PAR03 := ""
Private cMV_PAR04 := ""
Private cMV_PAR05 := ""
Private cMV_PAR06 := ""
Private cMV_PAR07 := ""
Private cMV_PAR08 := ""
Private cMV_PAR09 := ""
Private cMV_PAR10 := ""
Private cMV_PAR11 := ""
Private cMV_PAR12 := ""
Private cMV_PAR13 := ""
Private cMV_PAR14 := ""
Private cMV_PAR15 := ""
Private cMV_PAR16 := ""
Private cMV_PAR17 := ""
Private cMV_PAR18 := ""
Private cMV_PAR19 := ""
Private cMV_PAR20 := ""
Private lAUTO     := .F.


Tamanho  := "M"
titulo   := "Impressao de Boleto com Codigo de Barras - Bradesco"
cDesc1   := "Este programa destina-se a impressao do Boleto com Codigo de Barras - Bradesco"
cDesc2   := ""
cDesc3   := ""
cString  := "SE1"
wnrel    := "BOL0"
lEnd     := .F.
cPerg    :="BLT237    "
aReturn  := {"Zebrado", 1,"Administracao", 2, 2, 1, "",1 }   
nLastKey := 0

dbSelectArea("SE1")

Aadd(aPergs,{"De Prefixo","De Prefixo","De Prefixo","mv_ch1","C",3,0,0,"G","","MV_PAR01","","","","","","","","","","","","","","","","","","","","","","","","","","","","",""})
Aadd(aPergs,{"Ate Prefixo","Ate Prefixo","Ate Prefixo","mv_ch2","C",3,0,0,"G","","MV_PAR02","","","","ZZZ","","","","","","","","","","","","","","","","","","","","","","","","",""})
Aadd(aPergs,{"De Numero","De Numero","De Numero","mv_ch3","C",9,0,0,"G","","MV_PAR03","","","","","","","","","","","","","","","","","","","","","","","","","","","","",""})
Aadd(aPergs,{"Ate Numero","Ate Numero","Ate Numero","mv_ch4","C",9,0,0,"G","","MV_PAR04","","","","ZZZZZZZZZ","","","","","","","","","","","","","","","","","","","","","","","","",""})
Aadd(aPergs,{"De Parcela","De Parcela","De Parcela","mv_ch5","C",1,0,0,"G","","MV_PAR05","","","","","","","","","","","","","","","","","","","","","","","","","","","","",""})
Aadd(aPergs,{"Ate Parcela","Ate Parcela","Ate Parcela","mv_ch6","C",1,0,0,"G","","MV_PAR06","","","","Z","","","","","","","","","","","","","","","","","","","","","","","","",""})
Aadd(aPergs,{"Banco      ","Banco   ","Banco   ","mv_ch7","C",3,0,0,"G","MV_PAR07 == '237' .And. ExistCpo('SEE',MV_PAR07) ","MV_PAR07","","","","","","","","","","","","","","","","","","","","","","","","","SA6","","","",""})
Aadd(aPergs,{"Agencia  ","Agencia","Agencia","mv_ch8","C",5,0,0,"G","ExistCpo('SEE',MV_PAR07+MV_PAR08)","MV_PAR08","","","","","","","","","","","","","","","","","","","","","","","","","","","","",""})
Aadd(aPergs,{"Conta    ","Conta","Conta","mv_ch9","C",10,0,0,"G","ExistCpo('SEE',MV_PAR07+MV_PAR08+MV_PAR09)","MV_PAR09","","","","","","","","","","","","","","","","","","","","","","","","","","","","",""})
Aadd(aPergs,{"SubConta ","SubConta","SubConta","mv_cha","C",3,0,0,"G","ExistCpo('SEE',MV_PAR07+MV_PAR08+MV_PAR09+MV_PAR10)","MV_PAR10","","","","","","","","","","","","","","","","","","","","","","","","","","","","",""})
Aadd(aPergs,{"De Cliente","De Cliente","De Cliente","mv_chb","C",6,0,0,"G","","MV_PAR11","","","","","","","","","","","","","","","","","","","","","","","","","SA1","","","",""})
Aadd(aPergs,{"Ate Cliente","Ate Cliente","Ate Cliente","mv_chc","C",6,0,0,"G","","MV_PAR12","","","","ZZZZZZ","","","","","","","","","","","","","","","","","","","","","SA1","","","",""})
Aadd(aPergs,{"De Loja","De Loja","De Loja","mv_chd","C",2,0,0,"G","","MV_PAR13","","","","","","","","","","","","","","","","","","","","","","","","","","","","",""})
Aadd(aPergs,{"Ate Loja","Ate Loja","Ate Loja","mv_che","C",2,0,0,"G","","MV_PAR14","","","","ZZ","","","","","","","","","","","","","","","","","","","","","","","","",""})
Aadd(aPergs,{"De Emissao","De Emissao","De Emissao","mv_chf","D",8,0,0,"G","","MV_PAR15","","","","01/01/80","","","","","","","","","","","","","","","","","","","","","","","","",""})
Aadd(aPergs,{"Ate Emissao","Ate Emissao","Ate Emissao","mv_chg","D",8,0,0,"G","","MV_PAR16","","","","31/12/10","","","","","","","","","","","","","","","","","","","","","","","","",""})
Aadd(aPergs,{"De Vencimento","De Vencimento","De Vencimento","mv_chh","D",8,0,0,"G","","MV_PAR17","","","","01/01/80","","","","","","","","","","","","","","","","","","","","","","","","",""})
Aadd(aPergs,{"Ate Vencimento","Ate Vencimento","Ate Vencimento","mv_chi","D",8,0,0,"G","","MV_PAR18","","","","31/12/10","","","","","","","","","","","","","","","","","","","","","","","","",""})
Aadd(aPergs,{"Do Bordero","Do Bordero","Do Bordero","mv_chj","C",6,0,0,"G","","MV_PAR19","","","","","","","","","","","","","","","","","","","","","","","","","","","","",""})
Aadd(aPergs,{"Ate Bordero","Ate Bordero","Ate Bordero","mv_chk","C",6,0,0,"G","","MV_PAR20","","","","ZZZZZZ","","","","","","","","","","","","","","","","","","","","","","","","",""})

AjustaSx1("BLT237    ",aPergs)
IF lAUTO
	cPERG := ""
ELSE                       
	cPerg :="BLT237    "
	Pergunte (cPerg,.F.)
ENDIF

Wnrel := SetPrint(cString,Wnrel,cPerg,@Titulo,cDesc1,cDesc2,cDesc3,.F.,,,Tamanho,,)

If nLastKey == 27
	Set Filter to
	Return
Endif

SetDefault(aReturn,cString)

If nLastKey == 27
	Set Filter to
	Return
Endif
IF lAUTO     

	cMV_PAR01 := MV_PAR01
    cMV_PAR02 := MV_PAR02
    cMV_PAR03 := MV_PAR03
    cMV_PAR04 := MV_PAR04
    cMV_PAR05 := MV_PAR05
    cMV_PAR06 := MV_PAR06
    cMV_PAR07 := MV_PAR07
    cMV_PAR08 := MV_PAR08
    cMV_PAR09 := MV_PAR09
    cMV_PAR10 := MV_PAR10
    cMV_PAR11 := MV_PAR11
    cMV_PAR12 := MV_PAR12
    cMV_PAR13 := MV_PAR13
    cMV_PAR14 := MV_PAR14
    cMV_PAR15 := MV_PAR15
    cMV_PAR16 := MV_PAR16 
    cMV_PAR17 := MV_PAR17
    cMV_PAR18 := MV_PAR18
    cMV_PAR19 := MV_PAR19
    cMV_PAR20 := MV_PAR20

    MV_PAR01 := SE1->E1_PREFIXO
    MV_PAR02 := SE1->E1_PREFIXO
    MV_PAR03 := SE1->E1_NUM
    MV_PAR04 := SE1->E1_NUM
    MV_PAR05 := SE1->E1_PARCELA
    MV_PAR06 := "Z"
    MV_PAR07 := "237"
    MV_PAR08 := "3393 "
    MV_PAR09 := "44700     "
    MV_PAR10 := "001"
    MV_PAR11 := SE1->E1_CLIENTE
    MV_PAR12 := SE1->E1_CLIENTE    
    MV_PAR13 := SE1->E1_LOJA
    MV_PAR14 := SE1->E1_LOJA       
    MV_PAR15 := SE1->E1_EMISSAO
    MV_PAR16 := SE1->E1_EMISSAO 
    MV_PAR17 := SE1->E1_VENCREA
    MV_PAR18 := CTOD("31/12/49")
    MV_PAR19 := SE1->E1_NUMBOR
    MV_PAR20 := SE1->E1_NUMBOR

	WHILE !EOF() .AND. (SE1->E1_PREFIXO+SE1->E1_NUM+SE1->E1_CLIENTE+SE1->E1_LOJA)  == (MV_PAR01+MV_PAR03+MV_PAR11+MV_PAR13)    
	    
	    RECLOCK("SE1",.F.)    
		SE1->E1_PORTADO := MV_PAR07
		SE1->E1_AGEDEP  := MV_PAR08
		SE1->E1_CONTA   := MV_PAR09
		MsUnlock()         
		
		DBSKIP()
	END

ENDIF

cIndexName	:= Criatrab(Nil,.F.)
cIndexKey	:= "E1_CLIENTE+E1_PREFIXO+E1_NUM+E1_PARCELA+E1_TIPO+DTOS(E1_EMISSAO) "
cFilter		+= "E1_FILIAL=='"+xFilial("SE1")+"'.And.E1_SALDO>0.And. "
cFilter		+= "E1_PREFIXO>='" + MV_PAR01 + "'.And.E1_PREFIXO<='" + MV_PAR02 + "'.And. " 
cFilter		+= "E1_NUM>='" + MV_PAR03 + "'.And.E1_NUM<='" + MV_PAR04 + "'.And. "
cFilter		+= "E1_PARCELA>='" + MV_PAR05 + "'.And.E1_PARCELA<='" + MV_PAR06 + "'.And. "
cFilter		+= "E1_CLIENTE>='" + MV_PAR11 + "'.And.E1_CLIENTE<='" + MV_PAR12 + "'.And. "
cFilter		+= "E1_LOJA>='" + MV_PAR13 + "'.And.E1_LOJA<='"+MV_PAR14+"'.And. "
cFilter		+= "DTOS(E1_EMISSAO)>='"+DTOS(mv_par15)+"'.and.DTOS(E1_EMISSAO)<='"+DTOS(mv_par16)+"'.And. "
cFilter		+= "DTOS(E1_VENCREA)>='"+DTOS(mv_par17)+"'.and.DTOS(E1_VENCREA)<='"+DTOS(mv_par18)+"'.And. "
cFilter     += "E1_NUMBOR  >= '" + mv_par19  + "' .And. E1_NUMBOR <= '" + mv_par20 + "' .And. "
cFilter		+= "E1_PORTADO == '237' .AND."
cFilter		+= "!(E1_TIPO$MVABATIM)"
IndRegua("SE1", cIndexName, cIndexKey,, cFilter, "Aguarde selecionando registros....")

DbSelectArea("SE1")
#IFNDEF TOP
	DbSetIndex(cIndexName + OrdBagExt())
#ENDIF

@ 001,001 TO 400,700 DIALOG oDlg TITLE "Seleção de Titulos"
@ 001,001 TO 170,350 BROWSE "SE1" MARK "E1_OK"
@ 180,310 BMPBUTTON TYPE 01 ACTION (lExec := .T.,oDlg:End())
@ 180,280 BMPBUTTON TYPE 02 ACTION (lExec := .F.,oDlg:End())
ACTIVATE DIALOG oDlg CENTERED
	
SE1->(dbGoTop())
While SE1->(!EOF()) 
   If  Marked("E1_OK")
	AADD(aVetor, {SE1->E1_PREFIXO	,; 
				  SE1->E1_NUM       ,; 
 				  SE1->E1_PARCELA	,; 
				  SE1->E1_TIPO 		,; 
				  SE1->E1_CLIENTE	,; 
				  SE1->E1_LOJA}) 	
	EndIf
	SE1->(dbSkip())
Enddo                 

If lExec

	//Posiciona o SA6 (Bancos)

	DbSelectArea("SA6")
	DbSetOrder(1)
	If !DbSeek(xFilial("SA6") + MV_PAR07 + MV_PAR08 + MV_PAR09 )
       Aviso( "Atenção ! " , "O Banco : " + Alltrim(MV_PAR07) + " Agencia : " + Alltrim(SUBS(MV_PAR08,1,4)) + " e Conta : " + Alltrim(SUBS(MV_PAR09,1,6)) + " nào foram encontrados no cadastro de bancos !" , {"Ok"} , 1 , "Banco não encontrado !" )
       Return
	Endif
	
	//Posiciona na Arq de Parametros CNAB
	DbSelectArea("SEE")
	DbSetOrder(1)
	If !DbSeek(xFilial("SEE") + MV_PAR07 + MV_PAR08 + MV_PAR09 + MV_PAR10 )
      Aviso( "Atenção ! " , "Não existem parametros de bancos Cnab (SEE) cadastrados para a o Banco : " + Alltrim(MV_PAR07) + " Agencia : " + Alltrim(SUBS(MV_PAR08,1,4)) + " e Conta : " + Alltrim(SUBS(MV_PAR09,1,6)) + " . Cadastre os Parametros de Bancos antes de Imprimir o Boleto !" , {"Ok"} , 1 , "Parametros Bancos" )
       Return
    Endif   

	Processa({|lEnd|MontaRel(aVetor)})

Endif
RetIndex("SE1")
Ferase(cIndexName+OrdBagExt()) 

    MV_PAR01 := cMV_PAR01
    MV_PAR02 := cMV_PAR02
    MV_PAR03 := cMV_PAR03
    MV_PAR04 := cMV_PAR04
    MV_PAR05 := cMV_PAR05
    MV_PAR06 := cMV_PAR06
    MV_PAR07 := cMV_PAR07
    MV_PAR08 := cMV_PAR08
    MV_PAR09 := cMV_PAR09
    MV_PAR10 := cMV_PAR10
    MV_PAR11 := cMV_PAR11
    MV_PAR12 := cMV_PAR12
    MV_PAR13 := cMV_PAR13
    MV_PAR14 := cMV_PAR14
    MV_PAR15 := cMV_PAR15
    MV_PAR16 := cMV_PAR16 
    MV_PAR17 := cMV_PAR17
    MV_PAR18 := cMV_PAR18
    MV_PAR19 := cMV_PAR19
    MV_PAR20 := cMV_PAR20


Return Nil

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Programa  ³  MontaRel³ Autor ³ Microsiga             ³ Data ³ 06/06/06 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³IMPRESSAO DO BOLETO LASER DO INDUSTRIAL COM CODIGO DE BARRAS³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Uso       ³ Especifico para Clientes Microsiga                         ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
Static Function MontaRel(aVetor)
LOCAL oPrint
LOCAL nX := 0
LOCAL aDadosEmp    := {	SM0->M0_NOMECOM                                    						  ,; //[1]Nome da Empresa
						SM0->M0_ENDCOB                                     						  ,; //[2]Endereço
						AllTrim(SM0->M0_BAIRCOB)+", "+AllTrim(SM0->M0_CIDCOB)+", "+SM0->M0_ESTCOB ,; //[3]Complemento
						"CEP: "+Subs(SM0->M0_CEPCOB,1,5)+"-"+Subs(SM0->M0_CEPCOB,6,3)             ,; //[4]CEP
						"PABX/FAX: "+SM0->M0_TEL                                                  ,; //[5]Telefones
						"CNPJ: "+Subs(SM0->M0_CGC,1,2)+"."+Subs(SM0->M0_CGC,3,3)+"."+         	   ; //[6]
						Subs(SM0->M0_CGC,6,3)+"/"+Subs(SM0->M0_CGC,9,4)+"-"+                       ; //[7]
						Subs(SM0->M0_CGC,13,2)                                                    ,; //[8]CGC
						"I.E.: "+Subs(SM0->M0_INSC,1,3)+"."+Subs(SM0->M0_INSC,4,3)+"."+            ; //[9]
						Subs(SM0->M0_INSC,7,3)+"."+Subs(SM0->M0_INSC,10,3)                         } //[10]I.E

LOCAL aDadosTit
LOCAL aDadosBanco
LOCAL aDatSacado
LOCAL aBolText     := {"TÍTULO REGISTRADO - PROTESTO AUTOMÁTICO"	,;   //[1]Mensagem 1
 					   "NO CASO DO NÃO PAGAMENTO, 10 DIAS APÓS"		,;   //[2]Mora Diaria
					   "VENCIMENTO, NÃO PAGAR VALOR INFERIOR,"	    ,;	 //[3]Sujeito a Protesto
             		   "SE VENCIDO, COBRAR MULTA DE 2%"	            ,;   //[4]Recebimento sem desconto
                       "E JUROS DE 1% AO MÊS."						,;   //[5]Cobrar juros de
					   ""	 	 					                ,;   //[6]Multa de
                       ""			                                  }	 //[7]e protestar após

LOCAL nI		:= 1
LOCAL aCB_RN_NN	:= {}
LOCAL nVlrAbat	:= 0
Local aBCOLogo  := {}
Local cDVNrBanc
Local cCarNN
Local cNossoNum
Local cMsg     := "Referente Nota Fiscal Eletronica Nr: "
Local cNFEle   := ""    
Local cRet     := Space(30)

oPrint:= TMSPrinter():New( "Boleto Laser" )
oPrint:SetPortrait() 	// ou SetLandscape()
oPrint:StartPage()   	// Inicia uma nova página

ProcRegua(Len(aVetor))
For nI:=1 To Len(aVetor) 

	cPrefixo := aVetor[nI,1]
	cNum     := aVetor[nI,2]
	cParcela := aVetor[nI,3]
	cTipo    := aVetor[nI,4]
	cCLiente := aVetor[nI,5]
	cLoja    := aVetor[nI,6]
	
	//Posiciona o SA1 (Cliente)
	DbSelectArea("SA1")
	DbSetOrder(1) 
	DbSeek(xFilial("SA1") + cCliente + cLoja )
		    
	DbSelectArea("SE1")
	DbSetOrder(1) 
	If !DbSeek(xFilial("SE1") + cPrefixo + cNum + cParcela + cTipo + cCliente + cLoja)
		Alert("O Titulo: " + cPrefixo + " " + cNum + " " + cParcela + " nao existe!")
		Loop
	Endif
	
	aDadosBanco  := {SA6->A6_COD                        					,;	// [1] Numero do Banco
                    SA6->A6_NOME      	            	                  	,; 	// [2] Nome do Banco
                   	SUBSTR(SA6->A6_AGENCIA, 1, 4)                        	,;	// [3] Agência
                    strzero(val(SA6->A6_NUMCON),7)       					,; 	// [4] Conta Corrente 
                    SA6->A6_DVCTA 											,; 	// [5] Dígito da conta corrente
                    SEE->EE_CODCART    						  				,;  // [6] Codigo da Carteira
                    2                      			  			        	,;	// [7] Tx da Multa       
                    ((((SE1->E1_SALDO*10)+SE1->E1_ACRESC)/30)/100) 			,;  // [8] Tx de Mora Diaria 
                    Substr(SEE->EE_CODEMP,1,7)								}   // [9] Codigo do Cedente 
	If Empty(SA1->A1_ENDCOB)
		aDatSacado   := {AllTrim(SA1->A1_NOME)           ,;      	// [1]Razão Social
		AllTrim(SA1->A1_COD )+"-"+SA1->A1_LOJA           ,;      	// [2]Código
		AllTrim(SA1->A1_END )+"-"+AllTrim(SA1->A1_BAIRRO),;      	// [3]Endereço
		AllTrim(SA1->A1_MUN )                            ,;  		// [4]Cidade
		SA1->A1_EST                                      ,;    		// [5]Estado
		SA1->A1_CEP                                      ,;      	// [6]CEP
		SA1->A1_CGC										 ,;  		// [7]CGC
		SA1->A1_PESSOA}       										// [8]PESSOA
	Else
		aDatSacado   := {AllTrim(SA1->A1_NOME)            	,;   	// [1]Razão Social
		AllTrim(SA1->A1_COD )+"-"+SA1->A1_LOJA              ,;   	// [2]Código
		AllTrim(SA1->A1_ENDCOB)+"-"+AllTrim(SA1->A1_BAIRROC),;   	// [3]Endereço
		AllTrim(SA1->A1_MUNC)	                            ,;   	// [4]Cidade
		SA1->A1_ESTC	                                    ,;   	// [5]Estado
		SA1->A1_CEPC                                        ,;   	// [6]CEP
		SA1->A1_CGC											,;		// [7]CGC
		SA1->A1_PESSOA}												// [8]PESSOA
	Endif


	cBanco		:= Substr(aDadosBanco[1],1,3)								// [1] Numero do Banco
	cAgencia	:= SUBSTR(SA6->A6_AGENCIA,1,4)								// [3] Agência
	cConta		:= strzero(val(SA6->A6_NUMCON),7)							// [4] Conta Corrente
	cDacCC		:= aDadosBanco[5]											// [5] Dígito da conta corrente
	cCarNN		:= Alltrim(SUBSTR(SEE->EE_CODCART,1,2))						// Carteira
	nValor      := SE1->E1_SALDO + SE1->E1_ACRESC - SE1->E1_DECRESC - (SomaAbat(SE1->E1_PREFIXO,SE1->E1_NUM,SE1->E1_PARCELA,"R",1,,SE1->E1_CLIENTE,SE1->E1_LOJA))
	dVencto		:= SE1->E1_VENCTO

	If Empty (SE1->E1_NUMBCO)                         
/*
	   cNossoNum   := Strzero(Val(Alltrim(SEE->EE_FAXATU)),11)   
        
       //Calculo do Digito - Nosso Numero (Modulo 11)
       RecLock( "SE1" , .F. )
	   SE1->E1_NUMBCO := cNossoNum
	   MsUnlock()
	   cDVNrBanc	:= MODULO11(cCarNN+STRZERO(VAL(SE1->E1_NUMBCO),11),2,7)

	   RecLock( "SEE" , .F. )
	   SEE->EE_FAXATU := Strzero(Val(Alltrim(cNossoNum))+1,11) //cNossoNum
       MsUnlock()           
*/
		_aRetorno := U_xNossoNum(cCarNN,1) // retorno 1 igual array
		
		cNossoNum := _aRetorno[1] 
		cDVNrBanc := _aRetorno[2]
		
    Else
	   cNossoNum := Substr(SE1->E1_NUMBCO,1,11)
       //Calculo do Digito - Nosso Numero (Modulo 11)
// 	   cDVNrBanc	:= MODULO11(cCarNN+STRZERO(VAL(SE1->E1_NUMBCO),11),2,7)
   	   cDVNrBanc	:= Modulo11Nn( (cCarNN+STRZERO(VAL(SE1->E1_NUMBCO),11)) )
    EndIf   
	
	
	aCB_RN_NN   := Ret_cBarra(cBanco,cAgencia,cConta,cDacCC,cNossoNum,nValor,dVencto,cCarNN)

	aDadosTit	:= {AllTrim(SE1->E1_NUM)+AllTrim(SE1->E1_PARCELA)	,;  // [1] Número do título
					SE1->E1_EMISSAO                      			,;  // [2] Data da emissão do título
					dDataBase                    					,;  // [3] Data da emissão do boleto
					SE1->E1_VENCTO                       			,;  // [4] Data do vencimento
					(nValor + SE1->E1_ACRESC)		,;  // [5] Valor do título
					cNossoNum		,;  // [6] Nosso número (Ver fórmula para calculo)
					SE1->E1_PREFIXO                      			,;  // [7] Prefixo da NF
					SE1->E1_TIPO	                        		}	// [8] Tipo do Titulo

	// Retorna mensagem da nota fiscal eletronica
	If !Empty(SE1->E1_NFELETR)
		cRet := cMsg + SE1->E1_NFELETR
	Endif	
 	
	Impress(oPrint,aDadosEmp,aDadosTit,aDadosBanco,aDatSacado,aBolText,aCB_RN_NN,cNossoNum/*cNrBancario*/,cRet,cDVNrBanc)
	nX := nX + 1
	
	IncProc()
Next nI

oPrint:EndPage()     // Finaliza a página
oPrint:Preview()     // Visualiza antes de imprimir

Return nil

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Programa  ³  Impress ³ Autor ³ Microsiga             ³ Data ³ 06/06/12 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³ IMPRESSAO DO BOLETO LASERDO SANTANDER COM CODIGO DE BARRAS ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Uso       ³ Especifico para Clientes Microsiga                         ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
Static Function Impress(oPrint,aDadosEmp,aDadosTit,aDadosBanco,aDatSacado,aBolText,aCB_RN_NN,cNossoNum/*cNrBancario*/,cRet,cDVNrBanc)
LOCAL oFont8
LOCAL oFont9
LOCAL oFont11c
LOCAL oFont10
LOCAL oFont13
LOCAL oFont13n
LOCAL oFont14
LOCAL oFont16n
LOCAL oFont15
LOCAL oFont14n
LOCAL oFont24
LOCAL nI := 0

//Parametros de TFont.New()
//1.Nome da Fonte (Windows)
//3.Tamanho em Pixels
//5.Bold (T/F)
oFont8   := TFont():New("Arial"      ,9,8,.T.,.F.,5,.T.,5,.T.,.F.)
oFont9   := TFont():New("Arial"      ,9,8,.T.,.F.,5,.T.,5,.T.,.F.)
oFont11c := TFont():New("Courier New",9,11,.T.,.T.,5,.T.,5,.T.,.F.)
oFont10  := TFont():New("Arial"      ,9,10,.T.,.T.,5,.T.,5,.T.,.F.)
oFont13  := TFont():New("Arial"      ,9,13,.T.,.T.,5,.T.,5,.T.,.F.)
oFont14  := TFont():New("Arial"      ,9,14,.T.,.T.,5,.T.,5,.T.,.F.)
oFont19  := TFont():New("Arial"      ,9,20,.T.,.T.,5,.T.,5,.T.,.F.)
oFont20  := TFont():New("Arial"      ,9,20,.T.,.T.,5,.T.,5,.T.,.F.)
oFont21  := TFont():New("Arial"      ,9,21,.T.,.T.,5,.T.,5,.T.,.F.)
oFont16n := TFont():New("Arial"      ,9,16,.T.,.F.,5,.T.,5,.T.,.F.)
oFont15  := TFont():New("Arial"      ,9,15,.T.,.T.,5,.T.,5,.T.,.F.)
oFont15n := TFont():New("Arial"      ,9,15,.T.,.F.,5,.T.,5,.T.,.F.)
oFont14n := TFont():New("Arial"      ,9,14,.T.,.F.,5,.T.,5,.T.,.F.)
oFont24  := TFont():New("Arial"      ,9,24,.T.,.T.,5,.T.,5,.T.,.F.)

oPrint:StartPage()   // Inicia uma nova página


/******************/
/* PRIMEIRA PARTE */
/******************/

nRow2 := 0

oPrint:Line (nRow2+0210,100,nRow2+0210,2300)
oPrint:Line (nRow2+0210,500,nRow2+0130, 500)
oPrint:Line (nRow2+0210,710,nRow2+0130, 710)

oPrint:SayBitmap(nRow2+0100,100,cLogoBra,400,100) // Imprime o Logo do Banco
oPrint:Say  (nRow2+0135,513, "237-2",oFont19 )	  // Numero do Banco
oPrint:Say  (nRow2+0155,1930,"Recibo do Sacado",oFont13)

oPrint:Line (nRow2+0300,100,nRow2+0300,2300 )
oPrint:Line (nRow2+0400,100,nRow2+0400,2300 )
oPrint:Line (nRow2+0500,100,nRow2+0500,2300 )
oPrint:Line (nRow2+0580,100,nRow2+0580,2300 ) 
oPrint:Line (nRow2+0650,100,nRow2+0650,2300 )

oPrint:Line (nRow2+0500,500 ,nRow2+0650,500)
oPrint:Line (nRow2+0580,750 ,nRow2+0650,750)
oPrint:Line (nRow2+0500,1000,nRow2+0650,1000)
oPrint:Line (nRow2+0500,1300,nRow2+0580,1300)
oPrint:Line (nRow2+0500,1480,nRow2+0650,1480)

oPrint:Say  (nRow2+0210,100 ,"Local de Pagamento",oFont8)
//oPrint:Say  (nRow2+0250,100 ,"Pagavel em qualquer banco até o vencimento. Após, somente no banco BRADESCO.",oFont10)
oPrint:Say  (nRow2+0250,100 ,"Pagável preferencialmente na Rede Bradesco ou Bradesco Expresso",oFont10) 

oPrint:Say  (nRow2+0210,1810,"Vencimento" ,oFont8)
cString	:= StrZero(Day(aDadosTit[4]),2) +"/"+ StrZero(Month(aDadosTit[4]),2) +"/"+ Right(Str(Year(aDadosTit[4])),4)

nCol := 1810+(460-(len(cString)*22))
oPrint:Say  (nRow2+0250,nCol,cString,oFont11c)

oPrint:Say  (nRow2+0310,100 ,"Beneficiário" ,oFont8)
//cString := Alltrim(aDadosEmp[1]) //Nome + CNPJ     
cString := Alltrim(aDadosEmp[1])+" "+Alltrim(aDadosEmp[6])

nCol := 1810+(460-(len(cString)*22))
//oPrint:Say  (nRow2+0350,100,cString, oFont11c)
oPrint:Say  (nRow2+0344,100,cString, oFont8)
oPrint:Say  (nRow2+0374,100,Alltrim(aDadosEmp[2]), oFont8)
       
oPrint:Say  (nRow2+0310,1810,"Agência/Código Beneficiário",oFont8)
cString := Alltrim(aDadosBanco[3]+"-" +SA6-> A6_DVAGE +"/"+SubStr(aDadosBanco[4],1,7) +"-" + SA6->A6_DVCTA)

nCol := 1810+(460-(len(cString)*22))
oPrint:Say  (nRow2+0350,nCol,cString,oFont11c)    

oPrint:Say  (nRow2+0410,100 ,"Endereço Beneficiário / Sacador Avalista",oFont8)   
cString := Alltrim(Substr(aDadosEmp[2],1,18) +" - "+ aDadosEmp[3] +" - "+ Alltrim (aDadosEmp[4]))  

nCol := 1810+(460-(len(cString)*22))
oPrint:Say  (nRow2+0450,100,cString,oFont11c)
                       
oPrint:Say  (nRow2+0510,100 ,"Data do Documento",oFont8)
oPrint:Say  (nRow2+0540,205, StrZero(Day(aDadosTit[2]),2) +"/"+ StrZero(Month(aDadosTit[2]),2) +"/"+ Right(Str(Year(aDadosTit[2])),4),oFont10)

oPrint:Say  (nRow2+0510,505 ,"Número do Documento",oFont8)
oPrint:Say  (nRow2+0540,605 , aDadosTit[1]+"/"+aDadosTit[7],oFont10) //Prefixo +Numero+Parcela

oPrint:Say  (nRow2+0510,1005,"Espécie Documento",oFont8)
oPrint:Say  (nRow2+0540,1050,"DM",oFont10) //Tipo do Titulo

oPrint:Say  (nRow2+0510,1305,"Aceite",oFont8)
oPrint:Say  (nRow2+0540,1350,"N",oFont10)

oPrint:Say  (nRow2+0510,1485,"Data do Processamento",oFont8)
oPrint:Say  (nRow2+0540,1550,StrZero(Day(aDadosTit[3]),2) +"/"+ StrZero(Month(aDadosTit[3]),2) +"/"+ Right(Str(Year(aDadosTit[3])),4),oFont10) // Data impressao

oPrint:Say  (nRow2+0510,1810,"Nosso Número",oFont8)
cString :=  aDadosBanco[6] +"/" + Alltrim(Substr(aDadosTit[6],1,12) +  '-' + cDVNrBanc )
nCol := 1810+(444-(len(cString)*22))
oPrint:Say  (nRow2+0540,nCol,cString,oFont11c)

oPrint:Say  (nRow2+0580,100 ,"Uso do Banco    ",oFont8)

oPrint:Say  (nRow2+0580,505 ,"Carteira    ",oFont8)
oPrint:Say  (nRow2+0610,555 ,aDadosBanco[6],oFont10)

oPrint:Say  (nRow2+0580,755 ,"Espécie",oFont8)
oPrint:Say  (nRow2+0610,805 ,"R$",oFont10)

oPrint:Say  (nRow2+0580,1005,"Quantidade",oFont8)
oPrint:Say  (nRow2+0580,1485,"Valor",oFont8)

oPrint:Say  (nRow2+0580,1810,"(=) Valor do Documento",oFont8)
cString := Alltrim(Transform(aDadosTit[5],"@E 99,999,999.99"))

nCol := 1810+(460-(len(cString)*22))
oPrint:Say  (nRow2+0610,nCol,cString ,oFont11c)
oPrint:Say  (nRow2+0650,100 ,"Instruções (Todas as informações deste boletão são de exclusiva responsabilidade do beneficiário)",oFont8)
oPrint:Say  (nRow2+0700,100 ,aBolText[1],oFont9)
oPrint:Say  (nRow2+0730,100 ,aBolText[2],oFont9)
oPrint:Say  (nRow2+0760,100 ,aBolText[3],oFont9)
oPrint:Say  (nRow2+0790,100 ,aBolText[4],oFont9)
oPrint:Say  (nRow2+0820,100 ,aBolText[5],oFont9)

oPrint:Say  (nRow2+0650,1810,"(-)Desconto/Abatimento",oFont8)
oPrint:Say  (nRow2+0720,1810,"(-)Outras Deduções",oFont8)
oPrint:Say  (nRow2+0790,1810,"(+)Mora/Multa",oFont8)
oPrint:Say  (nRow2+0860,1810,"(+)Outros Acréscimos",oFont8)
oPrint:Say  (nRow2+0930,1810,"(=)Valor Cobrado",oFont8)  

oPrint:Say  (nRow2+1000,100 ,"Pagador",oFont8)
oPrint:Say  (nRow2+1030,120 ,aDatSacado[1]+" ("+aDatSacado[2]+")",oFont9)
oPrint:Say  (nRow2+1060,120 ,aDatSacado[3],oFont9)
oPrint:Say  (nRow2+1090,120 ,aDatSacado[4]+" - "+aDatSacado[5]+ "   CEP: " + aDatSacado[6],oFont9) // Cidade+Estado+CEP
               
oPrint:Say  (nRow2+1000,1795 ,"CPF/CNPJ do Sacado",oFont8)

if aDatSacado[8] = "F"
	oPrint:Say  (nRow2+1030,1820 ,"CPF: "+TRANSFORM(aDatSacado[7],"@R 999.999.999-99"),oFont9) 	// CPF
Else
	oPrint:Say  (nRow2+1030,1820 ,"CNPJ: "+TRANSFORM(aDatSacado[7],"@R 99.999.999/9999-99"),oFont9) // CGC
EndIf                                                                                                        

oPrint:Say  (nRow2+1130,100 ,"Pagador/Avalista",oFont8)   
oPrint:Say  (nRow2+1165,100,"Recebimento através do cheque núm.	do banco ",oFont8)
oPrint:Say  (nRow2+1190,100,"Esta quisição só terá validade após o pagamento do cheque pelo ",oFont8) 
oPrint:Say  (nRow2+1215,100,"banco sacado.",oFont8)
oPrint:Say  (nRow2+1165,1720,"Autenticação Mecânica - Ficha de Compensação",oFont8)

oPrint:Line (nRow2+0210,1800,nRow2+1000,1800 ) 

oPrint:Line (nRow2+0720,1800,nRow2+0720,2300 )
oPrint:Line (nRow2+0790,1800,nRow2+0790,2300 )
oPrint:Line (nRow2+0860,1800,nRow2+0860,2300 )
oPrint:Line (nRow2+0930,1800,nRow2+0930,2300 )
oPrint:Line (nRow2+1000,100 ,nRow2+1000,2300 ) 

oPrint:Line (nRow2+1160,100 ,nRow2+1160,2300 )       

oPrint:Say  (nRow2+1100,1795,"Código de Baixa",oFont8)
 
cString := aDadosBanco[6]+"/" + Alltrim(Substr(aDadosTit[6],1,12) +  ' ' + cDVNrBanc )
oPrint:Say  (nRow2+1130,1820+5,cString,oFont9)


/*****************/
/* SEGUNDA PARTE */
/*****************/

nRow2 := 1150

oPrint:Line (nRow2+0210,100,nRow2+0210,2300)
oPrint:Line (nRow2+0210,500,nRow2+0130, 500)
oPrint:Line (nRow2+0210,710,nRow2+0130, 710)

oPrint:SayBitmap(nRow2+0100,100,cLogoBra,400,100)	// Imprime o Logo do Banco
oPrint:Say  (nRow2+0135,513, "237-2",oFont19 )		// [1]Numero do Banco
oPrint:Say  (nRow2+0155,2020,"Ficha de Caixa",oFont13)

oPrint:Line (nRow2+0310,100,nRow2+0310,2300 )
oPrint:Line (nRow2+0410,100,nRow2+0410,2300 )
oPrint:Line (nRow2+0480,100,nRow2+0480,2300 )
oPrint:Line (nRow2+0550,100,nRow2+0550,2300 )

oPrint:Line (nRow2+0410,500,nRow2+0550,500)
oPrint:Line (nRow2+0480,750,nRow2+0550,750)
oPrint:Line (nRow2+0410,1000,nRow2+0550,1000)
oPrint:Line (nRow2+0410,1300,nRow2+0480,1300)
oPrint:Line (nRow2+0410,1480,nRow2+0550,1480)

oPrint:Say  (nRow2+0210,100 ,"Local de Pagamento",oFont8)
oPrint:Say  (nRow2+0250,100 ,"Pagável preferencialmente na Rede Bradesco ou Bradesco Expresso",oFont10)

oPrint:Say  (nRow2+0210,1810,"Vencimento",oFont8)
cString	:= StrZero(Day(aDadosTit[4]),2) +"/"+ StrZero(Month(aDadosTit[4]),2) +"/"+ Right(Str(Year(aDadosTit[4])),4)
nCol := 1810+(460-(len(cString)*22))
oPrint:Say  (nRow2+0250,nCol,cString,oFont11c)

oPrint:Say  (nRow2+0310,100 ,"Beneficiário",oFont8)
//cString := Alltrim(aDadosEmp[1]) //Nome + CNPJ     
cString := Alltrim(aDadosEmp[1])+" "+Alltrim(aDadosEmp[6])

nCol := 1810+(460-(len(cString)*22))
//oPrint:Say  (nRow2+0350,100,cString, oFont11c)
oPrint:Say  (nRow2+0346,100,cString, oFont8)
oPrint:Say  (nRow2+0376,100,Alltrim(aDadosEmp[2]), oFont8)


oPrint:Say  (nRow2+0310,1810,"Agência/Código Beneficiário",oFont8)
cString := Alltrim(aDadosBanco[3]+"-" +SA6-> A6_DVAGE +"/"+SubStr(aDadosBanco[4],1,7) +"-" + SA6->A6_DVCTA)
nCol := 1810+(460-(len(cString)*22))
oPrint:Say  (nRow2+0350,nCol,cString,oFont11c)

oPrint:Say  (nRow2+0410,100 ,"Data do Documento",oFont8)
oPrint:Say  (nRow2+0440,205, StrZero(Day(aDadosTit[2]),2) +"/"+ StrZero(Month(aDadosTit[2]),2) +"/"+ Right(Str(Year(aDadosTit[2])),4),oFont10)

oPrint:Say  (nRow2+0410,505 ,"Número do Documento",oFont8)
oPrint:Say  (nRow2+0440,605 , aDadosTit[1]+"/"+aDadosTit[7],oFont10) //Prefixo +Numero+Parcela

oPrint:Say  (nRow2+0410,1005,"Espécie Documento",oFont8)
oPrint:Say  (nRow2+0440,1050,"DM",oFont10) //Tipo do Titulo

oPrint:Say  (nRow2+0410,1305,"Aceite",oFont8)
oPrint:Say  (nRow2+0440,1350,"N",oFont10)

oPrint:Say  (nRow2+0410,1485,"Data do Processamento",oFont8)
oPrint:Say  (nRow2+0440,1550,StrZero(Day(aDadosTit[3]),2) +"/"+ StrZero(Month(aDadosTit[3]),2) +"/"+ Right(Str(Year(aDadosTit[3])),4),oFont10) // Data impressao

oPrint:Say  (nRow2+0410,1810,"Nosso Número",oFont8)
cString :=  aDadosBanco[6] +"/" + Alltrim(Substr(aDadosTit[6],1,12) +  '-' + cDVNrBanc )
nCol := 1810+(444-(len(cString)*22))
oPrint:Say  (nRow2+0440,nCol,cString,oFont11c)

oPrint:Say  (nRow2+0480,100 ,"Uso do Banco    ",oFont8)

oPrint:Say  (nRow2+0480,505 ,"Carteira    ",oFont8)
oPrint:Say  (nRow2+0510,555 ,aDadosBanco[6],oFont10)

oPrint:Say  (nRow2+0480,755 ,"Espécie",oFont8)
oPrint:Say  (nRow2+0510,805 ,"R$",oFont10)

oPrint:Say  (nRow2+0480,1005,"Quantidade",oFont8)
oPrint:Say  (nRow2+0480,1485,"Valor",oFont8)

oPrint:Say  (nRow2+0480,1810,"(=) Valor do Documento",oFont8)
cString := Alltrim(Transform(aDadosTit[5],"@E 99,999,999.99"))
nCol := 1810+(460-(len(cString)*22))
oPrint:Say  (nRow2+0510,nCol,cString ,oFont11c)

oPrint:Say  (nRow2+0550,100 ,"Instruções (Todas as informações deste boletão são de exclusiva responsabilidade do beneficiário)",oFont8)
oPrint:Say  (nRow2+0600,100 ,aBolText[1],oFont9)
oPrint:Say  (nRow2+0630,100 ,aBolText[2],oFont9)
oPrint:Say  (nRow2+0660,100 ,aBolText[3],oFont9)
oPrint:Say  (nRow2+0690,100 ,aBolText[4],oFont9)
oPrint:Say  (nRow2+0720,100 ,aBolText[5],oFont9)

oPrint:Say  (nRow2+0550,1810,"(-)Desconto/Abatimento",oFont8)
oPrint:Say  (nRow2+0620,1810,"(-)Outras Deduções",oFont8)
oPrint:Say  (nRow2+0690,1810,"(+)Mora/Multa",oFont8)
oPrint:Say  (nRow2+0760,1810,"(+)Outros Acréscimos",oFont8)
oPrint:Say  (nRow2+0830,1810,"(=)Valor Cobrado",oFont8)  

oPrint:Say  (nRow2+0900,100 ,"Pagador",oFont8)
oPrint:Say  (nRow2+0930,120 ,aDatSacado[1]+" ("+aDatSacado[2]+")",oFont9)
oPrint:Say  (nRow2+0960,120 ,aDatSacado[3],oFont9)
oPrint:Say  (nRow2+0990,120 ,aDatSacado[4]+" - "+aDatSacado[5]+ "   CEP: " + aDatSacado[6],oFont9) // Cidade+Estado+CEP
               
oPrint:Say  (nRow2+0900,1795 ,"CPF/CNPJ do Sacado",oFont8)

if aDatSacado[8] = "F"
	oPrint:Say  (nRow2+0930,1820 ,"CPF: "+TRANSFORM(aDatSacado[7],"@R 999.999.999-99"),oFont9) 	// CPF
Else
	oPrint:Say  (nRow2+0930,1820 ,"CNPJ: "+TRANSFORM(aDatSacado[7],"@R 99.999.999/9999-99"),oFont9) // CGC
EndIf                                                                                                       

oPrint:Say  (nRow2+1030,100 ,"Pagador/Avalista",oFont8)
oPrint:Say  (nRow2+1065,1720,"Autenticação Mecânica - Ficha de Compensação",oFont8)

oPrint:Line (nRow2+0210,1800,nRow2+0900,1800 ) 
oPrint:Line (nRow2+0620,1800,nRow2+0620,2300 )
oPrint:Line (nRow2+0690,1800,nRow2+0690,2300 )
oPrint:Line (nRow2+0760,1800,nRow2+0760,2300 )
oPrint:Line (nRow2+0830,1800,nRow2+0830,2300 )
oPrint:Line (nRow2+0900,100 ,nRow2+0900,2300 )
oPrint:Line (nRow2+1060,100 ,nRow2+1060,2300 )     

oPrint:Say  (nRow2+1000,1795,"Código de Baixa",oFont8)
 
cString := aDadosBanco[6]+"/" + Alltrim(Substr(aDadosTit[6],1,12) +  ' ' + cDVNrBanc )
oPrint:Say  (nRow2+1030,1820+5,cString,oFont9)

/******************/
/* TERCEIRA PARTE */
/******************/

nRow3 :=880

For nI := 100 to 2300 step 50
	oPrint:Line(nRow3+1380, nI, nRow3+1380, nI+30)
Next nI

oPrint:Line (nRow3+1500,100,nRow3+1500,2300)
oPrint:Line (nRow3+1500,500,nRow3+1420, 500)
oPrint:Line (nRow3+1500,710,nRow3+1420, 710)

oPrint:SayBitmap(nRow3+1400,100,cLogoBra,400,100)  // Imprime o Logo do Banco
oPrint:Say  (nRow3+1425,513,"237-2",oFont21 )	   // [1]Numero do Banco


/**********************/
/*Linha Digitavel     */

oPrint:Say  (nRow3+1434,755,aCB_RN_NN[1],oFont14n) //-> Linha Digitavel

/**********************/

oPrint:Line (nRow3+1600,100,nRow3+1600,2300 )
oPrint:Line (nRow3+1700,100,nRow3+1700,2300 )
oPrint:Line (nRow3+1770,100,nRow3+1770,2300 )
oPrint:Line (nRow3+1840,100,nRow3+1840,2300 )

oPrint:Line (nRow3+1700,500 ,nRow3+1840,500 )
oPrint:Line (nRow3+1770,750 ,nRow3+1840,750 )
oPrint:Line (nRow3+1700,1000,nRow3+1840,1000)
oPrint:Line (nRow3+1700,1300,nRow3+1770,1300)
oPrint:Line (nRow3+1700,1480,nRow3+1840,1480)

oPrint:Say  (nRow3+1500,100 ,"Local de Pagamento",oFont8)
oPrint:Say  (nRow3+1540,100 ,"Pagável preferencialmente na Rede Bradesco ou Bradesco Expresso",oFont10)
           
oPrint:Say  (nRow3+1500,1810,"Vencimento",oFont8)
cString := StrZero(Day(aDadosTit[4]),2) +"/"+ StrZero(Month(aDadosTit[4]),2) +"/"+ Right(Str(Year(aDadosTit[4])),4)
nCol	 	 := 1810+(460-(len(cString)*22))
oPrint:Say  (nRow3+1540,nCol,cString,oFont11c)

oPrint:Say  (nRow3+1600,100 ,"Beneficiário",oFont8)
//cString := Alltrim(aDadosEmp[1]) //Nome + CNPJ     
cString := Alltrim(aDadosEmp[1])+" "+Alltrim(aDadosEmp[6])

nCol := 1810+(460-(len(cString)*22))
//oPrint:Say  (nRow3+1640,100,cString, oFont11c)
oPrint:Say  (nRow3+1638,100,cString, oFont8)
oPrint:Say  (nRow3+1668,100,Alltrim(aDadosEmp[2]), oFont8)

oPrint:Say  (nRow3+1600,1810,"Agência/Código Beneficiário",oFont8)
cString := Alltrim(aDadosBanco[3]+"-" +SA6-> A6_DVAGE +"/"+SubStr(aDadosBanco[4],1,7) +"-" + SA6->A6_DVCTA)
nCol 	 := 1810+(460-(len(cString)*22))
oPrint:Say  (nRow3+1640,nCol,cString ,oFont11c)

oPrint:Say  (nRow3+1700,100 ,"Data do Documento",oFont8)
oPrint:Say (nRow3+1730,100, StrZero(Day(aDadosTit[2]),2) +"/"+ StrZero(Month(aDadosTit[2]),2) +"/"+ Right(Str(Year(aDadosTit[2])),4), oFont10)

oPrint:Say  (nRow3+1700,505 ,"Número do Documento",oFont8)
oPrint:Say  (nRow3+1730,605 , aDadosTit[1]+"/"+aDadosTit[7],oFont10) //Prefixo +Numero+Parcela

oPrint:Say  (nRow3+1700,1005,"Espécie Documento",oFont8)
oPrint:Say  (nRow3+1730,1050,"DM",oFont10) //Tipo do Titulo

oPrint:Say  (nRow3+1700,1305,"Aceite",oFont8)
oPrint:Say  (nRow3+1730,1350,"N",oFont10)

oPrint:Say  (nRow3+1700,1485,"Data do Processamento",oFont8)
oPrint:Say  (nRow3+1730,1550,StrZero(Day(aDadosTit[3]),2) +"/"+ StrZero(Month(aDadosTit[3]),2) +"/"+ Right(Str(Year(aDadosTit[3])),4)                               ,oFont10) // Data impressao

oPrint:Say  (nRow3+1700,1810,"Nosso Número",oFont8)
cString :=  aDadosBanco[6] +"/" + Alltrim(Substr(aDadosTit[6],1,12) +  '-' + cDVNrBanc )
nCol:= 		1810+(444-(len(cString)*22))
oPrint:Say  (nRow3+1730,nCol,cString,oFont11c)

oPrint:Say  (nRow3+1770,100 ,"Uso do Banco    ",oFont8)

oPrint:Say  (nRow3+1770,505 ,"Carteira    ",oFont8)
oPrint:Say  (nRow3+1800,555 ,aDadosBanco[6],oFont10)     

oPrint:Say  (nRow3+1770,755 ,"Espécie",oFont8)
oPrint:Say  (nRow3+1800,805 ,"R$",oFont10)

oPrint:Say  (nRow3+1770,1005,"Quantidade",oFont8)
oPrint:Say  (nRow3+1770,1485,"Valor",oFont8)

oPrint:Say  (nRow3+1770,1810,"(=) Valor do Documento",oFont8)
cString:=   Alltrim(Transform(aDadosTit[5],"@E 99,999,999.99"))
nCol:=      1810+(460-(len(cString)*22))
oPrint:Say  (nRow3+1800,nCol,cString,oFont11c)

oPrint:Say  (nRow3+1840,100 ,"Instruções (Todas as informações deste boletão são de exclusiva responsabilidade do beneficiário)",oFont8)
oPrint:Say  (nRow3+1890,100 ,aBolText[1],oFont9)
oPrint:Say  (nRow3+1920,100 ,aBolText[2],oFont9)
oPrint:Say  (nRow3+1950,100 ,aBolText[3],oFont9)
oPrint:Say  (nRow3+1980,100 ,aBolText[4],oFont9)
oPrint:Say  (nRow3+2010,100 ,aBolText[5],oFont9)
oPrint:Say  (nRow3+2140,100 ,aBolText[7],oFont9)

oPrint:Say  (nRow3+1840,1810,"(-)Desconto",oFont8)
oPrint:Say  (nRow3+1910,1810,"(-)Abatimento",oFont8)
oPrint:Say  (nRow3+1980,1810,"(+)Mora",oFont8)
oPrint:Say  (nRow3+2050,1810,"(+)Outros Acréscimos",oFont8)
oPrint:Say  (nRow3+2120,1810,"(=)Valor Cobrado",oFont8)
 
oPrint:Say  (nRow3+2190,100 ,"Pagador",oFont8)
oPrint:Say  (nRow3+2220,120 ,aDatSacado[1]+" ("+aDatSacado[2]+")",oFont9)
oPrint:Say  (nRow3+2250,120 ,aDatSacado[3],oFont9)
oPrint:Say  (nRow3+2280,120 ,aDatSacado[4]+" - "+aDatSacado[5]+ "   CEP: " + aDatSacado[6]	,oFont9) // Cidade+Estado+CEP     

oPrint:Say  (nRow3+2190,1795 ,"CPF/CNPJ do Sacado",oFont8)

if aDatSacado[8] = "F"
	oPrint:Say  (nRow3+2220,1820,"CPF: "+TRANSFORM(aDatSacado[7],"@R 999.999.999-99"),oFont9) 	// CPF
Else
	oPrint:Say  (nRow3+2220,1820,"CNPJ: "+TRANSFORM(aDatSacado[7],"@R 99.999.999/9999-99"),oFont9) // CGC
EndIf 

oPrint:Say  (nRow3+2320,100 ,"Pagador/Avalista",oFont8)
oPrint:Say  (nRow3+2395,1720,"Autenticação Mecânica - Ficha de Compensação",oFont8)

oPrint:Line (nRow3+1500,1800,nRow3+2190,1800 )
oPrint:Line (nRow3+1910,1800,nRow3+1910,2300 )
oPrint:Line (nRow3+1980,1800,nRow3+1980,2300 )
oPrint:Line (nRow3+2050,1800,nRow3+2050,2300 )
oPrint:Line (nRow3+2120,1800,nRow3+2120,2300 )
oPrint:Line (nRow3+2190,100 ,nRow3+2190,2300 )
oPrint:Line (nRow3+2350,100 ,nRow3+2350,2300 )

oPrint:Say  (nRow3+2290,1795,"Código de Baixa"                                   ,oFont8)

cString := 	Alltrim (aDadosBanco[6] +"/"+ Alltrim(Substr(aDadosTit[6],1,12) +  ' ' + cDVNrBanc ))
oPrint:Say  (nRow3+2320,1820+5,cString,oFont9)

//-> Codigo de Barras
//MSBAR("INT25" , 28.5 ,1.3 ,aCB_RN_NN[2], oPrint  , .F.,    ,.T. , 0.02   , 1.2, Nil, Nil,Nil,.F.) //alterado 11/10/16 - emerson natali
MSBAR3("INT25" , 28.5  ,1    ,aCB_RN_NN[2], oPrint  , .F.,    ,.T. , 0.028 , 1.0, Nil, Nil,Nil,.F.) //alterado 11/10/16 - emerson natali

oPrint:EndPage() // Finaliza a página

Return Nil

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Programa  ³Ret_cBarra³ Autor ³ Microsiga             ³ Data ³ 06/06/12 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³ IMPRESSAO DO BOLETO LASE DO SANTANDER COM CODIGO DE BARRAS ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Uso       ³ Especifico para Clientes Microsiga                         ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
Static Function Ret_cBarra(cBanco,cAgencia,cConta,cDacCC,cNossoNum/*cNossNum*/,nValor,dVencto,cCarNN/*,cCedente*/)

LOCAL cValorFinal 	:= strzero(nValor*100,10)  
LOCAL nDvnn			:= 0
LOCAL nDvcb			:= 0
LOCAL nDv			:= 0
LOCAL cNN			:= ''
LOCAL cRN			:= ''
LOCAL cCB			:= ''
LOCAL cS			:= ''
LOCAL cFator        := strzero(dVencto - ctod("07/10/97"),4)  

//-----------------------------
// Definicao do Codigo de Barras
// ----------------------------

cBarr := cBanco + "9" + cFator + cValorFinal + cAgencia + cCarNN + cNossoNum + strzero(val(cConta),7) + "0"

cDBar := Modulo11CB( cBarr )
nDvcb := AllTrim(Str(cDBar))
cCB := Substr(cBarr,01,04) + nDvcb + Substr(cBarr,5)

//-----------------------------
// Definicao da Linha Digitavel
// ----------------------------
cRN := LinhaDigitavel( cCB, cValorFinal )

//Retorno
//linha digital (cRN) e codigo de barras (cCB)
Return({cRN, cCB})

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³BRADESCO  ºAutor  ³Microsiga           º Data ³  10/11/16   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³                                                            º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ AP                                                        º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

STATIC FUNCTION LinhaDigitavel( cBarr, cValorFinal )
Local nCampo1, nCampo2, nCampo3, nCampo4

nCampo1 := SUBS(cBarr,01,04)+SUBS( cBarr, 20, 5 )
nCampo1 += alltrim(str(modulo10( nCampo1 )))
nCampo2 := SUBS( cBarr, 25, 10 )
nCampo2 += alltrim(str(modulo10( nCampo2 )))
nCampo3 := SUBS( cBarr, 35, 10 )
nCampo3 += alltrim(str(modulo10( nCampo3 )))
nCampo4 := SUBS( cBarr, 05, 01 )
nCampo5 := SUBS( cBarr, 06, 04 ) + SUBS ( cBarr, 10, 10)

RETURN TRANSFORM( nCampo1+nCampo2+nCampo3+nCampo4, "@R 99999.99999  99999.999999  99999.999999  9" ) + "  " + nCAMPO5

/*/
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡…o    ³ AjustaSx1    ³ Autor ³ Microsiga            	³ Data ³ 06/06/12 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³ Verifica/cria SX1 a partir de matriz para verificacao          ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Uso       ³ Especifico para Clientes Microsiga                    	  	  ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
Static Function AjustaSX1(cPerg, aPergs)

Local _sAlias	:= Alias()
Local aCposSX1	:= {}
Local nX 		:= 0
Local lAltera	:= .F.
Local nCondicao
Local cKey		:= ""
Local nJ			:= 0

aCposSX1:={"X1_PERGUNT","X1_PERSPA","X1_PERENG","X1_VARIAVL","X1_TIPO","X1_TAMANHO",;
			"X1_DECIMAL","X1_PRESEL","X1_GSC","X1_VALID",;
			"X1_VAR01","X1_DEF01","X1_DEFSPA1","X1_DEFENG1","X1_CNT01",;
			"X1_VAR02","X1_DEF02","X1_DEFSPA2","X1_DEFENG2","X1_CNT02",;
			"X1_VAR03","X1_DEF03","X1_DEFSPA3","X1_DEFENG3","X1_CNT03",;
			"X1_VAR04","X1_DEF04","X1_DEFSPA4","X1_DEFENG4","X1_CNT04",;
			"X1_VAR05","X1_DEF05","X1_DEFSPA5","X1_DEFENG5","X1_CNT05",;
			"X1_F3", "X1_GRPSXG", "X1_PYME","X1_HELP" }

dbSelectArea("SX1")
dbSetOrder(1)
For nX:=1 to Len(aPergs)
	lAltera := .F.
	If MsSeek(cPerg+Right(aPergs[nX][11], 2))
		If (ValType(aPergs[nX][Len(aPergs[nx])]) = "B" .And.;
			 Eval(aPergs[nX][Len(aPergs[nx])], aPergs[nX] ))
			aPergs[nX] := ASize(aPergs[nX], Len(aPergs[nX]) - 1)
			lAltera := .T.
		Endif
	Endif
	
	If ! lAltera .And. Found() .And. X1_TIPO <> aPergs[nX][5]	
 		lAltera := .T.		// Garanto que o tipo da pergunta esteja correto
 	Endif	
	
	If ! Found() .Or. lAltera
		RecLock("SX1",If(lAltera, .F., .T.))
		Replace X1_GRUPO with cPerg
		Replace X1_ORDEM with Right(aPergs[nX][11], 2)
		For nj:=1 to Len(aCposSX1)
			If 	Len(aPergs[nX]) >= nJ .And. aPergs[nX][nJ] <> Nil .And.;
				FieldPos(AllTrim(aCposSX1[nJ])) > 0
				Replace &(AllTrim(aCposSX1[nJ])) With aPergs[nx][nj]
			Endif
		Next nj
		MsUnlock()
		cKey := "P."+AllTrim(X1_GRUPO)+AllTrim(X1_ORDEM)+"."

		If ValType(aPergs[nx][Len(aPergs[nx])]) = "A"
			aHelpSpa := aPergs[nx][Len(aPergs[nx])]
		Else
			aHelpSpa := {}
		Endif
		
		If ValType(aPergs[nx][Len(aPergs[nx])-1]) = "A"
			aHelpEng := aPergs[nx][Len(aPergs[nx])-1]
		Else
			aHelpEng := {}
		Endif

		If ValType(aPergs[nx][Len(aPergs[nx])-2]) = "A"
			aHelpPor := aPergs[nx][Len(aPergs[nx])-2]
		Else
			aHelpPor := {}
		Endif

		PutSX1Help(cKey,aHelpPor,aHelpEng,aHelpSpa)
	Endif
Next
/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Programa  ³ Modulo10 ³ Autor ³ Microsiga             ³ Data ³ 06/06/12 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³ IMPRESSAO DO BOLETO LASE DO SANTANDER COM CODIGO DE BARRAS ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Uso       ³ Especifico para Clientes Microsiga                         ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
Static Function Modulo10(cData)
LOCAL L,D,P := 0
LOCAL B     := .F.
L := Len(cData)
B := .T.
D := 0
While L > 0
	P := Val(SubStr(cData, L, 1))
	If (B)
		P := P * 2
		If P > 9
			P := P - 9
		End
	End
	D := D + P
	L := L - 1
	B := !B
End
D := 10 - (Mod(D,10))
If D = 10
	D := 0
End
Return(D)

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Programa  ³ Modulo11 ³ Autor ³ Microsiga             ³ Data ³ 13/10/03 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³ IMPRESSAO DO BOLETO LASER DO SANTANDER COM CODIGO DE BARRAS³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Uso       ³ Especifico para Clientes Microsiga                         ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
Static Function Modulo11CB(cData)
LOCAL L, D, P := 0
L := Len(cdata)
D := 0
P := 1
While L > 0
	P := P + 1
	D := D + (Val(SubStr(cData, L, 1)) * P)
	If P = 9
		P := 1
	End
	L := L - 1
End
D := 11 - (mod(D,11))
If (D == 0 .Or. D == 1 .Or. D == 10 .Or. D == 11)
	D := 1
End
Return(D)


User Function xNossoNum(cCarNN, nOpcNret)

cDVNrBanc := "" 

If Empty(SE1->E1_NUMBCO)
	cNossoNum   := Strzero(Val(Alltrim(SEE->EE_FAXATU)),11)   
	
	//Calculo do Digito - Nosso Numero (Modulo 11)
	RecLock( "SE1" , .F. )
	SE1->E1_NUMBCO := cNossoNum
	MsUnlock()
			
	RecLock( "SEE" , .F. )
	SEE->EE_FAXATU := Strzero(Val(Alltrim(cNossoNum))+1,11) //cNossoNum
	MsUnlock()
EndIf
	
If nOpcNret == 1 //Opção dentro do Boleto
//	cDVNrBanc := MODULO11(cCarNN+STRZERO(VAL(SE1->E1_NUMBCO),11),2,7)
	cDVNrBanc := Modulo11Nn( (cCarNN+STRZERO(VAL(SE1->E1_NUMBCO),11)) )
	_aRetorno := {cNossoNum, cDVNrBanc}
ElseIf nOpcNret == 2 //Opção dentro do CNAB - somente para o Nosso Numero
	_aRetorno := SE1->E1_NUMBCO
ElseIf nOpcNret == 3 //Opção dentro do CNAB - somente para o Digito do Nosso Numero
	_aRetorno := Modulo11Nn(("09"+alltrim(SE1->E1_NUMBCO)))
EndIf

Return(_aRetorno)

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³BRADESCO  ºAutor  ³Microsiga           º Data ³  12/19/16   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³                                                            º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ AP                                                        º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

Static Function Modulo11Nn(cData)
LOCAL L, D, P,R := 0
L := Len(cdata)
D := 0
P := 1
While L > 0
 P := P + 1
 D := D + (Val(SubStr(cData, L, 1)) * P)
 If P = 7
  P := 1
 End
 L := L - 1
End

R := mod(D,11)
If (R == 10)
 D := "1"
ElseIf (R == 0)
    D := "0"
ElseIf (R == 1)
    D := "P"
Else
    D := alltrim(str((11 - R)))
End              

Return(D)