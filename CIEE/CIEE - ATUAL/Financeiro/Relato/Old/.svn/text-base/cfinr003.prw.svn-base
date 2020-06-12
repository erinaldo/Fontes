#INCLUDE "CFINR003.Ch"
#Include "rwmake.Ch"
#include "_FixSX.ch"  // Biblioteca customizada.                                                                                        
                         
/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡„o    ³ CFINR003	³ Autor ³ Nadia C.D.Mamude      ³ Data ³ 28.08.02 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡„o ³ Bordero de Pagamento.				                  	  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Sintaxe e ³ cfinr003     				                       		  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Parametros³ 					  a	           							  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso 	 ³ Especifico CIEE											  ³±±
±±³          ³                                                            ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Autor    ³ Alteracoes     											  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Felipe    ³ - Inclusao de uma pergunta "Qtde de vias?"                 ³±±
±±³          ³ - Acerto para que a barra de progressao apareca apenas uma ³±±
±±³          ³ vez para todas as vias e nao uma vez a cada via.           ³±±
±±³          ³ - Reestruturacao da funcao ClasContab para facilitar alte- ³±±
±±³          ³ racoes requisitadas por usuarios.                          ³±±
±±³          ³ - Alteracao em alguns textos na biblioteca CFINR003.Ch     ³±±
±±³          ³ conforme solicitacao do usuario.                           ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Daniel GJr³ - Conforme solicitação da OS nr.13/0047, foi incluido o ti-³±±
±±³26/03/2013³   po 88 na tabela 58, e foi solicitado que o lay-out deste ³±±
±±³          ³   relatorio para o tipo 88 fosse equiparado ao do tipo 99  ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±³Daniel G.J³ Inclusão dos modelos	97 e 98 no lay-out do relatório, conf.³±±
±±³08/10/2013³ SSI.13/0217                                                ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
User Function CFINR003()
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Define Variaveis 														  ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ                  
LOCAL wnrel
LOCAL cDesc1 := STR0001  //"Este programa tem a fun‡„o de emitir os borderos de pagamen-"
LOCAL cDesc2 := STR0002  //"tos."
LOCAL cDesc3 := ""
LOCAL limite := 132
LOCAL Tamanho:= "M"
LOCAL cString:= "SEA"
Local _aPerg

PRIVATE titulo := STR0003 //"Emiss„o de Borderos de Pagamentos"
PRIVATE cabec1 := ""
PRIVATE cabec2 := ""
PRIVATE aReturn  := {OemToAnsi(STR0004), 1,OemToAnsi(STR0005), 1, 2, 1, "",1}  //"Zebrado"###"Administracao"
PRIVATE nomeprog := "CFINR003"  //"FINR710"
PRIVATE aLinha   := { },nLastKey := 0
PRIVATE cPerg	 := "FIN710    "
PRIVATE li       := 0
PRIVATE m_pag    := 1
Private lPerg    := .T. // Felipe Raposo 
Private _nPagina	:= 0

// Parametro(s) personalizado(s).
// Felipe Raposo.
_aPerg := {}
aAdd (_aPerg, {cPerg,"07","Vias               ?","¨Vias              ?","Vias               ?","mv_ch7","N",2,0,0,"G","","mv_par07","","","","4","","","","","","","","","","","","","","","","","","","","","","",""})
AjustaSX1(_aPerg) // _FixSX.ch

//ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Verifica as perguntas selecionadas   					     |
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
Pergunte(cPerg, .F.)
_nrpag  := 0
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Vari veis utilizadas para parametros		                ³
//³ mv_par01				// Do Bordero	         	        ³
//³ mv_par02				// At‚ o Bordero				    ³
//³ mv_par03				// Data para d‚bito				    ³
//ÃÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´
//³ Parametros customizados                                     ³
//³ mv_par07				// Qtde de vias    				    ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Inicia a data para debito com a data base do sistema         ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
dbSelectArea("SX1")
If dbSeek("FIN710"+"03")  // Busca a pergunta para mv_par03
	Reclock("SX1",.F.)
	Replace X1_CNT01 With "'"+dtoc(dDataBase)+"'"
	MsUnlock()
Endif

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Envia controle para a funcao SETPRINT            			 ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
wnrel := "CFINR003"  // "FINR710"          //Nome Default do relatorio em Disco
wnrel := SetPrint(cString,wnrel,cPerg,@titulo,cDesc1,cDesc2,cDesc3,.F.,"",,Tamanho)

If nLastKey == 27
	Return
Endif
SetDefault(aReturn,cString)
If nLastKey == 27
	Return
Endif

RptStatus({|lEnd| f710ImpBor(@lEnd,wnRel,cString,Tamanho)},titulo)


Set Device To Screen
dbSelectArea("SE5")
dbSetOrder(1)
dbSelectArea("SE2")
dbSetOrder(1)
Set Filter To
If aReturn[5] = 1
	Set Printer To
	dbCommit( )
	Ourspool(wnrel)
End
MS_FLUSH()

IF SELECT("SEA") > 0
	SEA->(DBCLOSEAREA())
ENDIF

u_CFINR003()    

//********//
Return


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºFuncao    ³f710ImpBorºAutor  ³Felipe Raposo       º Data ³  09/04/02   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ Controlar a exibicao e a progressao da regua de processa-  º±±
±±º          ³ mento enquanto imprime.                                    º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ CIEE                                                       º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
Static Function f710ImpBor(lEnd,wnRel,cString,Tamanho)
Local lFirst := .T.
SetRegua(mv_par07)
//For i := 1 to mv_par07  // Qtde de vias
//	IncRegua()
	IF lEnd
		@Prow()+1,001 PSAY OemToAnsi(STR0006)  //"CANCELADO PELO OPERADOR"
//		Exit
	EndIF
	li := 0  
	
	//PATRICIA FONTANEZI - TRATAMENTO PARA IMPRESSAO DE VIAS CONFORME PARAMETRO MV_PAR07
   //	Fa710Imp(@lFirst, @lEnd,wnRel,cString,Tamanho) 	
	If mv_par07 <> 0 
		For _nPagina := 1 to mv_par07 			 
			IF SELECT("SEA") > 0
				SEA->(DBCLOSEAREA())
			ENDIF  			  
		   	Fa710Imp(@lFirst, @lEnd,wnRel,cString,Tamanho)   			
		Next(_nPagina) 
	Endif 
//Next i
Return


/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡„o    |Fa710Imp  | Autor | Wagner Xavier	        ³ Data | 05.10.92 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡„o ³ Bordero de Pagamento.		    						  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Sintaxe e ³ fa710imp 												  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso		 ³ Especifico CIEE										 	  ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
Static Function FA710Imp(lFirst, lEnd,wnRel,cString, Tamanho)

LOCAL CbCont,CbTxt
LOCAL cModelo
LOCAL nTotValor:= 0
LOCAL lCheque		:= .f.
LOCAL lBaixa		:= .f.
LOCAL nTipo
LOCAL nColunaTotal
LOCAL cNumConta	    := CriaVar("EA_NUMCON")
Local cDVAg          
LOCAL lNew			:= .F.
LOCAL cNumBor, cModelo
LOCAL lAbatimento   := .F.
LOCAL nAbat 		:= 0
LOCAL _nTitulos     := 1
LOCAL _cQuery		:= ""
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Vari veis utilizadas para Impress„o do Cabe‡alho e Rodape	 |
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
cbtxt 	:= SPACE(10)
cbcont	:= 0
li		:= 80
m_pag 	:= 1  
lNew := .T. 
//_nrpag  := 0
//If _nrpag == 0
	dbSelectArea("SEA")
	dbSetOrder(1)
	dbSeek(cFilial + mv_par01, .T.)
	nTipo := aReturn[4]
	nContador := 0
	
	lNew := .T.  
	//PATRICIA FONTANEZI
	SEA->(DBCLOSEAREA())  
//Endif

_cQuery:= " SELECT * FROM "+RetSqlName("SEA")  
_cQuery+= " INNER JOIN " + RetSqlName("SE2") + " ON EA_NUMBOR = E2_NUMBOR " 
_cQuery+= " WHERE EA_NUMBOR BETWEEN '"+mv_par01+"' AND '"+mv_par02+"' "     
_cQuery+= " AND EA_NUM = E2_NUM " 
_cQuery+= " AND EA_PREFIXO = E2_PREFIXO "
_cQuery+= " AND EA_PARCELA = E2_PARCELA "
_cQuery+= " AND EA_FORNECE = E2_FORNECE "
_cQuery+= " AND EA_LOJA = E2_LOJA AND "
_cQuery+= RetSqlName("SE2") + ".D_E_L_E_T_ <> '*' AND "    
_cQuery+= RetSqlName("SEA") + ".D_E_L_E_T_ <> '*' "
_cQuery+= " ORDER BY E2_NUMBOR,((E2_VALOR+(E2_JUROS+E2_ACRESC))-(E2_DECRESC+E2_DESCONT)) "
_cQuery := ChangeQuery(_cQuery)
IF SELECT("SEA") > 0
	SEA->(DBCLOSEAREA())
ENDIF  

dbUseArea(.T.,"TOPCONN",TcGenQry(,,_cQuery),'SEA',.T.,.T.)   


Do While !Eof() .And. cFilial == EA_FILIAL .And. EA_NUMBOR <= mv_par02
	cNumBor := SEA->EA_NUMBOR
	cModelo := SEA->EA_MODELO
	IF lEnd
		@Prow()+1,001 PSAY OemToAnsi(STR0006)  //"CANCELADO PELO OPERADOR"
		Exit
	Endif
	
	lCheque := .f.
	lBaixa  := .f.
	cModelo := SEA->EA_MODELO
	dbSelectArea("SE2")
	cLoja := Iif ( Empty(SEA->EA_LOJA) , "" , SEA->EA_LOJA )
	dbSeek( cFilial+SEA->EA_PREFIXO+SEA->EA_NUM+SEA->EA_PARCELA+SEA->EA_TIPO+SEA->EA_FORNECE+cLoja )
    _nRegSE2:=RECNO()
	While !Eof() .And. ;
		cFilial	        == SE2->E2_FILIAL  .and. ;
		SEA->EA_PREFIXO == SE2->E2_PREFIXO .and. ;
		SEA->EA_NUM    	== SE2->E2_NUM 	   .and. ;
		SEA->EA_PARCELA	== SE2->E2_PARCELA .and. ;
		SEA->EA_TIPO	== SE2->E2_TIPO	   .and. ;
		SEA->EA_FORNECE	== SE2->E2_FORNECE .and. ;
		cLoja		    == SE2->E2_LOJA
		dbSelectArea("SE2")
		dbSkip( )                      
		If  cFilial	    == SE2->E2_FILIAL  .and. ;
		SEA->EA_PREFIXO == SE2->E2_PREFIXO .and. ;
		SEA->EA_NUM    	== SE2->E2_NUM 	   .and. ;
		SEA->EA_PARCELA	== SE2->E2_PARCELA .and. ;
		SEA->EA_TIPO	== SE2->E2_TIPO	   .and. ;
		SEA->EA_FORNECE	== SE2->E2_FORNECE .and. ;
		cLoja		    == SE2->E2_LOJA    
           _nRegSE2 := RECNO()		
		EndIf
		
	EndDo

    dbSelectArea("SE2")
	dbGoTo(_nRegSE2)                      
	
	dbSelectArea("SE5")
	dbSetOrder( 2 )
	dbSeek( cFilial+"VL"+SE2->E2_PREFIXO+SE2->E2_NUM+SE2->E2_PARCELA+SE2->E2_TIPO+DtoS(SE2->E2_BAIXA)+SE2->E2_FORNECE )
	
	While !Eof() .and. ;
		E5_FILIAL	== cFilial			 .and. ;
		E5_TIPODOC	== "VL"            .and. ;
		E5_PREFIXO	== SE2->E2_PREFIXO .and. ;
		E5_NUMERO	== SE2->E2_NUM 	 .and. ;
		E5_PARCELA	== SE2->E2_PARCELA .and. ;
		E5_TIPO		== SE2->E2_TIPO	 .and. ;
		E5_DATA		== SE2->E2_BAIXA	 .and. ;
		E5_CLIFOR	== SE2->E2_FORNECE .and. ;
		E5_LOJA		== cLoja
		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³ S¢ considera baixas que nao possuem estorno   ³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		If !TemBxCanc(E5_PREFIXO+E5_NUMERO+E5_PARCELA+E5_TIPO+E5_CLIFOR+E5_LOJA+E5_SEQ)
			If SubStr( E5_DOCUMEN,1,6 ) == cNumBor
				lBaixa := .t.
				Exit
			End
		EndIf
		dbSkip( )
	End
	If !lBaixa
		If (dbSeek( cFilial+"BA"+SE2->E2_PREFIXO+SE2->E2_NUM+SE2->E2_PARCELA+SE2->E2_TIPO+DtoS(SE2->E2_BAIXA)+SE2->E2_FORNECE))
			While !Eof() .and. ;
				E5_FILIAL	== cFilial			 .and. ;
				E5_TIPODOC	== "BA"            .and. ;
				E5_PREFIXO	== SE2->E2_PREFIXO .and. ;
				E5_NUMERO	== SE2->E2_NUM 	 .and. ;
				E5_PARCELA	== SE2->E2_PARCELA .and. ;
				E5_TIPO		== SE2->E2_TIPO	 .and. ;
				E5_DATA		== SE2->E2_BAIXA	 .and. ;
				E5_CLIFOR	== SE2->E2_FORNECE .and. ;
				E5_LOJA		== SE2->E2_LOJA
				
				//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
				//³ S¢ considera baixas que nao possuem estorno   ³
				//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
				If !TemBxCanc(E5_PREFIXO+E5_NUMERO+E5_PARCELA+E5_TIPO+E5_CLIFOR+E5_LOJA+E5_SEQ)
					If SubStr( E5_DOCUMEN,1,6 ) == cNumBor
						lBaixa := .t.
						Exit
					Endif
				EndIf
				dbSkip( )
			End
		End
	End
	dbSelectArea( "SEF" )
	If (dbSeek( cFilial+SE5->E5_BANCO+SE5->E5_AGENCIA+SE5->E5_CONTA+SE5->E5_NUMCHEQ))
		lCheque := .t.
	End
	dbSelectArea( "SA2" )
	dbSeek( cFilial+SE2->E2_FORNECE+SE2->E2_LOJA )
	dbSelectArea( "SEA" )
	
	IF li > 80 .or. lNew
		fr710Cabec(SEA->EA_MODELO, nTipo, Tamanho, @lFirst)
		m_pag++
		//_nrpag++ //mv_par07
		lNew := .F.
		_nTitulos:=1
	End
	
	lAbatimento := SEA->EA_TIPO $ MV_CPNEG .or. SEA->EA_TIPO $ MVABATIM
	If lAbatimento
		nAbat 	:= SE2->E2_SALDO 
	EndIf
	
	If !lAbatimento
		li++
/*
1234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890
          1         2         3         4         5         6         7         8         9         1
01234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890
    NUMERO P NATUREZA
    XXXXXX X X.XX.XX
*/
		@ li, 0 PSAY If(Empty(SE2->E2_PREFIXO),SE2->E2_TIPO,SE2->E2_PREFIXO)
		@ li, 4 PSAY SE2->E2_NUM
		@ li,11+3 PSAY SE2->E2_PARCELA
	EndIf
	cNumConta := SEA->EA_NUMCON
	
	If SEA->EA_MODELO $ "CH/02"
		dbSelectArea("SEA")
		If !lAbatimento
			@li,13+3 PSAY SubStr(SE2->E2_NATUREZ, 1, 10)
			If lCheque
				@li,23+3 PSAY SubStr(SEF->EF_BENEF,1, 30)
			Elseif lBaixa
				@li,23+3 PSAY SubStr(SE5->E5_BENEF,1, 30)
			Else
				@li,23+3 PSAY SubStr(SA2->A2_NOME,1, 30)
			End
		EndIf
		
		dbSelectArea( "SA6" )
		If lBaixa
			dbSeek(cFilial+SE5->E5_BANCO)
		Else
			dbSeek(cFilial+SE2->E2_PORTADO)
		End
		dbSelectArea( "SEA" )
		If !lAbatimento
			@li,55+3 PSAY SA6->A6_NREDUZ
			@li,71+3 PSAY SE2->E2_VENCREA
			If lCheque
				@li,82+3 PSAY "CH. " + SEF->EF_NUM
			End
		EndIf
		If lBaixa
			If !lAbatimento
				@li,102+3 PSAY SE5->E5_VALOR - nAbat 	Picture "@E 999,999,999.99"
				nAbat := 0
			EndIf
			nTotValor += SE5->E5_VALOR
		Else
			If !lAbatimento
				@li,102+3 PSAY SE2->E2_SALDO - nAbat - SE2->E2_DECRESC + SE2->E2_SDACRESC Picture "@E 999,999,999.99"
				nAbat := 0
				nTotValor := nTotValor + SE2->E2_SALDO - SE2->E2_DECRESC + SE2->E2_SDACRES
			Else
				nTotValor := nTotValor - SE2->E2_SALDO 
			End
		End
		nColunaTotal := 102
	Elseif SEA->EA_MODELO $ "CT/30"
		If ! lAbatimento
			@li,13+3 PSAY SubStr(SE2->E2_NATUREZ, 1, 10)
			@li,23+3 PSAY SubStr(SA2->A2_NOME,1, 30)
			@li,55+3 PSAY SE2->E2_VENCREA
			If lCheque
				@li,78+3 PSAY SEF->EF_NUM
			End
		EndIf
		If lBaixa
			If ! lAbatimento
				@li,94+3 PSAY SE5->E5_VALOR - nAbat Picture "@E 999,999,999.99"
				nAbat := 0
			EndIf
			nTotValor += SE5->E5_VALOR
		Else
			If !lAbatimento
				@li,094+3 PSAY SE2->E2_SALDO - nAbat - SE2->E2_DECRESC + SE2->E2_SDACRESC Picture "@E 999,999,999.99"
				nAbat := 0
				nTotValor := nTotValor + SE2->E2_SALDO - SE2->E2_DECRESC + SE2->E2_SDACRESC 
			Else
				nTotValor := nTotValor - SE2->E2_SALDO 
			End
		End
		nColunaTotal := 94
//	Elseif SEA->EA_MODELO $ "CP/31/99"			// alterado em 26/03/2013 conf. OS 13/0047
	Elseif SEA->EA_MODELO $ "CP/31/99/88"		// alterado em 26/03/2013 conf. OS 13/0047
		If ! lAbatimento
			@li,13+3 PSAY SubStr(SE2->E2_NATUREZ, 1, 10)
			@li,23+3 PSAY SubStr(SA2->A2_NOME,1, 30)
		EndIf
		dbSelectArea( "SA6" )
		dbSeek( cFilial+SE2->E2_PORTADO)
		dbSelectArea( "SEA" )
		If ! lAbatimento
			@li,55+3 PSAY SA6->A6_NREDUZ
			@li,71+3 PSAY SE2->E2_VENCREA
			@li,83+3 PSAY SE2->E2_NUMBCO
		EndIf
		If lBaixa
			If ! lAbatimento
				@li,99+3 PSAY SE5->E5_VALOR - nAbat Picture "@E 999,999,999.99"
				nAbat := 0
			EndIf
			nTotValor += SE5->E5_VALOR
		Else
			If !lAbatimento
				@li,099+3 PSAY SE2->E2_SALDO - nAbat - SE2->E2_DECRESC + SE2->E2_SDACRESC Picture "@E 999,999,999.99"
				nAbat := 0
				nTotValor := nTotValor + SE2->E2_SALDO - SE2->E2_DECRESC + SE2->E2_SDACRESC 
			Else
				nTotValor := nTotValor - SE2->E2_SALDO 
			End
		End
		nColunaTotal := 99
	Elseif SEA->EA_MODELO $ "CC/01/03/04/05/07/08/10/41/43"
		dbSelectArea("SA6")
		dbSeek(cFilial+SE2->E2_BANCO)         
		_cNREDUZ := SA6->A6_NREDUZ
		If Empty(_cNREDUZ)
		   dbSelectArea("SZ1")
		   If dbSeek(cFilial+SE2->E2_BANCO)
		      _cNREDUZ := SZ1->Z1_DREDUZ
		   EndIf
		EndIf      
		dbSelectArea("SEA")
		If ! lAbatimento
			@li,13+3  PSAY SubStr(SE2->E2_NATUREZ, 1, 10)
			@li,23+3  PSAY SubStr(_cNREDUZ, 1, 11)
			@li,35+3  PSAY SE2->E2_BANCO + " " + ALLTRIM(SE2->E2_AGEFOR) + IIF(!EMPTY(SE2->E2_DVFOR),"-"+SE2->E2_DVFOR,SE2->E2_DVFOR) 
            @li,46+3  PSAY Substr(ALLTRIM(SE2->E2_CTAFOR),1,16)
			@li,64    PSAY SubStr(SA2->A2_NOME, 1, 25)
			@li,90    PSAY SA2->A2_CGC Picture IIF(Len(Alltrim(SA2->A2_CGC))>11, "@R 99999999/9999-99", "@R 999999999-99")
			@li,108   PSAY SE2->E2_VENCREA
		EndIf
		If lBaixa
			If ! lAbatimento
				@li,117 PSAY SE5->E5_VALOR - nAbat Picture "@E 999,999,999.99"
				nAbat := 0
			EndIf
			nTotValor += SE5->E5_VALOR
		Else
			If !lAbatimento
				@li,117 PSAY SE2->E2_SALDO - nAbat - SE2->E2_DECRESC + SE2->E2_SDACRESC Picture "@E 999,999,999.99"
				nAbat := 0
				nTotValor := nTotValor + SE2->E2_SALDO - SE2->E2_DECRESC + SE2->E2_SDACRESC 
			Else
				nTotValor := nTotValor - SE2->E2_SALDO 
			End
		End
		nColunaTotal := 117
	Else
		If ! lAbatimento
			@li,13+3 PSAY SubStr(SE2->E2_NATUREZ, 1, 10)
			@li,20+3 PSAY SubStr(SA2->A2_NOME,1, 33)
		EndIf
		dbSelectArea( "SA6" )
		dbSeek( cFilial+SE2->E2_PORTADO)
		dbSelectArea( "SEA" )
		If ! lAbatimento
			@li,55+3 PSAY SA6->A6_NREDUZ
			@li,71+3 PSAY SE2->E2_VENCREA
			@li,84+3 PSAY SE2->E2_NUMBCO
		EndIf
		
		If lBaixa
			If ! lAbatimento
				@li,100+3 PSAY SE5->E5_VALOR - nAbat Picture "@E 999,999,999.99"
				nAbat := 0
			EndIf
			nTotValor += SE5->E5_VALOR
		Else
			If !lAbatimento
				@li,100+3 PSAY SE2->E2_SALDO - nAbat - SE2->E2_DECRESC + SE2->E2_SDACRESC Picture "@E 999,999,999.99"
				nAbat := 0
				nTotValor := nTotValor + SE2->E2_SALDO - SE2->E2_DECRESC + SE2->E2_SDACRESC 
			Else
				nTotValor := nTotValor - SE2->E2_SALDO 
			End
		End
		nColunaTotal := 100
	End
	dbSelectArea( "SEA" )
	dbSkip( )
	
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Verifica se n„o h  mais registros v lidos a analisar.    ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	DO WHILE !Eof() .And. cFilial == EA_FILIAL .And. EA_NUMBOR <= mv_par02 ;
		.and. (Empty(EA_NUMBOR) .or. SEA->EA_CART != "P")
		dbSkip( )
	ENDDO
	
	If cNumBor != SEA->EA_NUMBOR
		lNew := .T. 							// Novo bordero a ser impresso
		If li != 80
			li+=2
			@li,00 PSAY __PrtThinLine()
			li++
			@li,00 PSAY _nTitulos Picture "@E 999"
//			If cModelo == "99"					// alterado em 26/03/2013 conforme OS 13/0047
			If cModelo $ "99/88"				// alterado em 26/03/2013 conforme OS 13/0047
				@li,05 PSAY If(_nTitulos==1,"Relacao","Relacoes")
			Else
				@li,05 PSAY If(_nTitulos==1,"Titulo","Titulos")
			EndIf
			@li,75 PSAY OemToAnsi(STR0007) 
			@li,nColunaTotal PSAY nTotValor	Picture "@E 999,999,999.99"
			cExtenso := "("+Extenso( nTotValor, .F., 1 )+ ")"
			li+=2
			@li,	1 PSAY Trim(SubStr(cExtenso,1,100))
			If Len(Trim(cExtenso)) > 100
				li++
				@li, 0 PSAY SubStr(cExtenso,101,Len(Trim(cExtenso))-100)
			End
			li+=2
			cNumConta := AllTrim(cNumConta)
			If cModelo $ "CH/02"
				@li, 0 PSAY OemToAnsi(STR0008) + OemToAnsi(STR0009) + cNumConta + OemtoAnsi(STR0010)+" "+ DtoC(SE2->E2_VENCREA)
				li++
				li++
				@li, 0 PSAY SM0->M0_NOMECOM  
			Elseif cModelo $ "CT/30"
				@li, 0 PSAY OemToAnsi(STR0008) + OemToAnsi(STR0009) + cNumConta + OemtoAnsi(STR0010)+" "+ DtoC(SE2->E2_VENCREA)
				li++
				@li, 0 PSAY SM0->M0_NOMECOM  
//			Elseif cModelo $ "CP/31/99"					// alterado em 26/03/2013 conforme OS 13/0047
//			Elseif cModelo $ "CP/31/99/88"				// alterado em 08/10/2013 conforme SSI. 13/0217
			Elseif cModelo $ "CP/31/97/98/99/88"		// alterado em 08/10/2013 conforme SSI. 13/0217
				@li, 0 PSAY OemToAnsi(STR0008) + OemToAnsi(STR0009) + cNumConta + OemtoAnsi(STR0010)+" "+ DtoC(SE2->E2_VENCREA)
				li++
				@li, 0 PSAY SM0->M0_NOMECOM  
			Elseif cModelo $ "CC/01/03/04/05/07/08/10/41/43"
				@li, 0 PSAY OemToAnsi(STR0008) + OemToAnsi(STR0009) + cNumConta + OemtoAnsi(STR0010)+" "+ DtoC(SE2->E2_VENCREA)
				li++
				@li, 0 PSAY SM0->M0_NOMECOM  
			Else
				@li, 0 PSAY OemToAnsi(STR0008) + OemToAnsi(STR0009) + cNumConta + OemtoAnsi(STR0010)+" "+ DtoC(SE2->E2_VENCREA)
				li++
				@li, 0 PSAY SM0->M0_NOMECOM  
			Endif
			li+=6
			@li,15 PSAY "---------------------------------"
			@li,88 PSAY "---------------------------------"   
			li++
			@li, 0 PSAY " "
			nTotValor := 0
			// O usuario solicitou a impressao da planilha somente em duas das
			// quatro vias. Por isso a condicao IF.
			// Depois foi solicitada a alteracao para a planilha ser impressa
			// em todas as vias. Tambem foi solicitada uma alteracao pra que
			// o programa nao imprimisse quatro vias e sim a quantidade de
			// vias informada pelo usuario por parametro.
			// if i > 2
			ClasContab()
			// Endif
		End
	  /*	If _nrpag == mv_par07
			_nrpag:=1
		Else
			_nrpag++
			//dbSelectArea( "SEA" ) 
			//PATRICIA FONTANEZI - 
		   //	dbSetOrder(1)    
			//dbSeek(cFilial + cNumBor, .T.)
			//Loop
			//DBCLOSEAREA("SEA")   
		EndIf*/
	EndIf  
	dbSelectArea("SEA")
	_nTitulos+=1
End
m_pag++ 


Return


/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡„o	 ³fr710cabec³ Autor ³ Wagner Xavier 		³ Data ³ 24.05.93 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡„o ³ Cabe‡alho do Bordero 									  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Sintaxe e ³fr710cabec() 												  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Parametros³ 															  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso		 ³ Generico			 										  ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
Static Function fr710cabec(cModelo, nTipo, Tamanho, lFirst)
Local cCabecalho
Local cTexto

If cModelo $ "CH/02" // Tabela("58",cModelo)
	cTexto := Tabela("58",@cModelo)
//	cCabecalho := OemToAnsi(STR0025)  //"PRF NUMERO PC B E N E F I C I A R I O                  BANCO           DT.VENC  HISTORICO               VALOR A PAGAR"
	cCabecalho := OemToAnsi("PRF NUMERO PC B E N E F I C I A R I O                  BANCO           DT.VENC  HISTORICO               VALOR A PAGAR")
Elseif cModelo $ "CT/30"
	cTexto := Tabela("58",@cModelo)
//	cCabecalho := OemToAnsi(STR0027)  //"PRF NUMERO PC B E N E F I C I A R I O                   DT.VENC BCO AGENCIA NUM CHEQUE         VALOR A PAGAR"
	cCabecalho := OemToAnsi("PRF NUMERO PC B E N E F I C I A R I O                   DT.VENC BCO AGENCIA NUM CHEQUE         VALOR A PAGAR")
//Elseif cModelo $ "CP/31/99"				// alterado em 26/03/2013 conforme OS 13/0047
//Elseif cModelo $ "CP/31/99/88"			// alterado em 08/10/2013 conforme SSI. 13/0217
Elseif cModelo $ "CP/31/97/98/99/88"				// alterado em 08/10/2013 conforme SSI. 13/0217
	cTexto := Tabela("58",@cModelo)
//	cCabecalho := OemToAnsi(STR0029)  //"PRF NUMERO PC B E N E F I C I A R I O                  BANCO           DT.VENC  NUM.CHEQUE        VALOR  A PAGAR"
//	cCabecalho := OemToAnsi("PRF NUMERO PC B E N E F I C I A R I O                  BANCO           DT.VENC  NUM.CHEQUE        VALOR  A PAGAR")
	cCabecalho := OemToAnsi("PRF NUMERO      NATUREZA  B E N E F I C I A R I O         BANCO           DT.VENC  NUM.CHEQUE         VALOR  A PAGAR")
ElseIf cModelo $ "CC/01/03/04/05/07/08/10/41/43"
	cTexto := Tabela("58",@cModelo)
//	cCabecalho := OemToAnsi(STR0031)  //"PRF NUMERO       PC B A N C O       BCO AGENC  NUMERO CONTA       BENEFICIARIO              CNPJ/CPF        DT.VENC    VALOR A PAGAR"
	cCabecalho := OemToAnsi("PRF NUMERO      NATUREZA  BANCO       BCO AGENC  NUMERO CONTA   BENEFICIARIO              CNPJ/CPF          DT.VENC   VALOR A PAGAR")
Else
	cTexto := Tabela("58",@cModelo)
//	cCabecalho := OemToAnsi(STR0033)  //"PRF NUMERO PC B E N E F I C I A R I O                  BANCO           DT.VENC  NUM.CHEQUE        VALOR  A PAGAR"
	cCabecalho := OemToAnsi("PRF NUMERO PC B E N E F I C I A R I O                  BANCO           DT.VENC  NUM.CHEQUE        VALOR  A PAGAR")
End

dbSelectArea( "SA6" )
dbSeek( cFilial+SEA->EA_PORTADO+SEA->EA_AGEDEP+SEA->EA_NUMCON )
aCabec := {Sm0->M0_NOME,;
PadC(OemToAnsi(STR0034),97),;
OemToAnsi(STR0035)+DtoC(dDataBase),;
PadC(cTexto,97),;
OemToAnsi(STR0036)+SEA->EA_NUMBOR,;
Pad(OemToAnsi(STR0037) + SA6->A6_NOME,130),;
Pad(OemToAnsi(STR0038) + SA6->A6_AGENCIA,130),;
Pad(SA6->A6_END + " "  + SA6->A6_MUN + " " + SA6->A6_EST,130)}

Cabec1 := cCabecalho
li := Cabec710(Titulo,Cabec1,NomeProg,tamanho,Iif(aReturn[4]==1,GetMv("MV_COMP"),;
GetMv("MV_NORM")), aCabec, @lFirst)
Return


/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡„o	 ³fa710DtDeb³ Autor ³ Mauricio Pequim Jr.   ³ Data ³ 12.01.98 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡„o ³ Validacao da data de d‚bito para o bordero				  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Sintaxe e ³fa710DtDeb() 												  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso		 ³ Generico													  ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
Static Function fa710DtDeb()

Local lRet := .T.
lRet := IIf (mv_par03 < dDataBase, .F. , .T. )
Return lRet

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡„o	 ³Cabec170  ³ Autor ³ Mauricio Pequim Jr.	³ Data ³ 14.07.01 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡„o ³ Validacao da data de d‚bito para o bordero				  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Sintaxe e ³Cabec170()												  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso		 ³ Generico													  ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
Static Function cabec710(cTitulo,cCabec1,cNomPrg,nTamanho,nChar,aCustomText,lFirst)

Local cAlias,nLargura,nLin:=0, aDriver := ReadDriver(),nCont:= 0, cVar,uVar,cPicture
Local lWin := .f.
Local nI := 0
Local oFntCabec
Local nRow, nCol
aCustomText := Nil // Parâmetro que se passado suprime o texto padrao desta função por outro customizado

#DEFINE INIFIELD    Chr(27)+Chr(02)+Chr(01)
#DEFINE FIMFIELD    Chr(27)+Chr(02)+Chr(02)
#DEFINE INIPARAM    Chr(27)+Chr(04)+Chr(01)
#DEFINE FIMPARAM    Chr(27)+Chr(04)+Chr(02)

lPerg := lPerg .and. If(GetMv("MV_IMPSX1") == "S" ,.T.,.F.)

cNomPrg := Alltrim(cNomPrg)

Private cSuf:=""

//lFirst := .T.

If TYPE("__DRIVER") == "C"
	If "DEFAULT"$__DRIVER
		lWin := .t.
	EndIf
EndIf

nLargura:=132

IF aReturn[5] == 1   // imprime em disco
	lWin := .f.    // Se eh disco , nao eh windows
Endif

If lFirst
	nRow := PRow()
	nCol := PCol()
	SetPrc(0,0)
	If aReturn[5] <> 2 // Se nao for via Windows manda os caracteres para setar a impressora
		If nChar == NIL .and. !lWin .and. __cInternet == Nil
			@ 0,0 PSAY &(If(aReturn[4]=1,aDriver[3],aDriver[4]))
		ElseIf !lWin .and. __cInternet == Nil
			If nChar == 15
				@ 0,0 PSAY &(If(aReturn[4]=1,aDriver[3],aDriver[4]))
			Else
				@ 0,0 PSAY &(aDriver[4])
			EndIf
		EndIf
	EndIF
	If GetMV("MV_CANSALT",,.T.) // Saltar uma página na impressão
		If GetMv("MV_SALTPAG",,"S") != "N"
			Setprc(nRow,nCol)
		EndIf
	Endif
Endif

// Impressão da lista de parametros quando solicitada
If lPerg .and. Substr(cAcesso,101,1) == "S"
	If lFirst
		// Imprime o cabecalho padrao
		nLin := SendCabec(lWin, nLargura, cNomPrg, RptParam+" - "+Alltrim(cTitulo), "", "", .F.)
		cAlias := Alias()
		DbSelectArea("SX1")
		DbSeek(cPerg)
		@ nLin+=2, 5 PSAY INIPARAM
		While !EOF() .AND. X1_GRUPO = cPerg
			cVar := "MV_PAR"+StrZero(Val(X1_ORDEM),2,0)
			@(nLin+=2),5 PSAY INIFIELD+RptPerg+" "+ X1_ORDEM + " : "+ AllTrim(X1Pergunt())+FIMFIELD
			If X1_GSC == "C"
				xStr:=StrZero(&cVar,2)
				If ( &(cVar)==1 )
					@ nLin,Pcol()+3 PSAY INIFIELD+X1Def01()+FIMFIELD
				ElseIf ( &(cVar)==2 )
					@ nLin,Pcol()+3 PSAY INIFIELD+X1Def02()+FIMFIELD
				ElseIf ( &(cVar)==3 )
					@ nLin,Pcol()+3 PSAY INIFIELD+X1Def03()+FIMFIELD
				ElseIf ( &(cVar)==4 )
					@ nLin,Pcol()+3 PSAY INIFIELD+X1Def04()+FIMFIELD
				ElseIf ( &(cVar)==5 )
					@ nLin,Pcol()+3 PSAY INIFIELD+X1Def05()+FIMFIELD
				Else
					@ nLin,Pcol()+3 PSAY INIFIELD+''+FIMFIELD
				EndIf
			Else
				uVar := &(cVar)
				If ValType(uVar) == "N"
					cPicture:= "@E "+Replicate("9",X1_TAMANHO-X1_DECIMAL-1)
					If( X1_DECIMAL>0 )
						cPicture+="."+Replicate("9",X1_DECIMAL)
					Else
						cPicture+="9"
					EndIf
					@nLin,Pcol()+3 PSAY INIFIELD+Transform(Alltrim(Str(uVar)),cPicture)+FIMFIELD
				Elseif ValType(uVar) == "D"
					@nLin,Pcol()+3 PSAY INIFIELD+DTOC(uVar)+FIMFIELD
				Else
					@nLin,Pcol()+3 PSAY INIFIELD+uVar+FIMFIELD
				EndIf
			EndIf
			DbSkip()
		Enddo
		cFiltro := Iif (!Empty(aReturn[7]),MontDescr("SEA",aReturn[7]),"")
		nCont := 1
		If !Empty(cFiltro)
			nLin+=2
			@ nLin,5  PSAY  INIFIELD+ STR0039 + Substr(cFiltro,nCont,nLargura-19)+FIMFIELD  // "Filtro      : "
			While Len(AllTrim(Substr(cFiltro,nCont))) > (nLargura-19)
				nCont += nLargura - 19
				nLin+=1
				@ nLin,19	PSAY	INIFIELD+Substr(cFiltro,nCont,nLargura-19)+FIMFIELD
			Enddo
			nLin++
		EndIf
		nLin++
		@ nLin ,00  PSAY __PrtFatLine()+FIMPARAM
		DbSelectArea(cAlias)
	Endif
EndIf


@ 00,00 PSAY __PrtFatLine()
@ 01,00 PSAY __PrtLogo()
@ 02,00 PSAY __PrtFatLine()
@ 04,00 PSAY __PrtLeft(ALLTRIM(SM0->M0_NOME))
//If SEA->EA_MODELO == "99"							// alterado em 26/03/2013 conf. OS 13/0047
If SEA->EA_MODELO $ "99/88"							// alterado em 26/03/2013 conf. OS 13/0047
	@ 04,00 PSAY __PrtCenter("BORDERO ELETRONICO PARA PAGAMENTO DE COMPROMISSOS ")
Else
	@ 04,00 PSAY __PrtCenter("BORDERO PARA PAGAMENTO DE COMPROMISSOS ")
EndIf
@ 04,00 PSAY __PrtRight("EMISSÃO : "+dtoc(dDataBase))
@ 05,00 PSAY __PrtCenter(Tabela("58", SEA->EA_MODELO))  //descri‡Æo do tipo de bordero
@ 05,00 PSAY __PrtRight("RELAÇÃO : "+SEA->EA_NUMBOR)
@ 08,00 PSAY __PrtLeft(SA6->A6_NOME)		// Ao Banco
@ 09,00 PSAY __PrtLeft("AGENCIA : "+ SEA->EA_AGEDEP)   // Agencia
@ 10,00 PSAY __PrtLeft(SA6->A6_END+" "+ ALLTRIM(SA6->A6_MUN)+"   "+ ALLTRIM(SA6->A6_EST)) //Endereco Banco

If LEN(Trim(cCabec1)) != 0
	@ 11,00  PSAY __PrtThinLine()
	@ 12,00  PSAY cCabec1
	@ 13,00  PSAY __PrtThinLine()
EndIf
nLin :=14
m_pag++
lFirst := .F.
If Subs(__cLogSiga,4,1) == "S"
	__LogPages()
EndIf
Return (nLin)

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡„o    ³ClasContab| Autor ³ Nadia C.D.Mamude      ³ Data ³ 28.08.02 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡„o ³ Bordero de Pagamento.				                  	  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Sintaxe e ³ ClasContab()    				                       		  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Parametros³ 						           							  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso		 ³ Especifico CIEE											  ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
Static Function ClasContab()

Local _cCab, _cLin1, _cLin2

_cDet1  := "Pagamento(s) Analisado(s) Anteriormente "
_cDet2  := "Pela Analise de Desembolso  "


li += 4       
@li, 00 PSAY _cDet1
li += 1
@li, 00 PSAY _cDet2

Return
