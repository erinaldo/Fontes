#include "rwmake.ch"

/*                                                                                    
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±º Programa    ³CNABxFUN ³ Biblioteca de Funcoes genericas utilizadas nos Cnabs          º±±
±±ÌÍÍÍÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±º Observacoes ³ Aqui devem ser incluidas apenas as funcoes que serao utilizadas         º±±
±±º             ³ nos processos de CNAB receber ou pagar.                                 º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/




/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³CODBAR   ºAutor  ³TOTVS               º Data ³  31/03/06   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ PROGRAMA PARA TRATAMENTO DO CAMPO E2_CODBAR PARA UTILIZACAOº±±
±±º          ³ DO PAGFOR                                                  º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³                                                            º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±± Alteracao:                                                             ±±±
±±                                                                        ±±±
±±                                                                        ±±±
±±                                                                        ±±±
±±                                                                        ±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

///--------------------------------------------------------------------------\
//| Função: CODBAR				Autor: Flávio Novaes		Data: 19/10/2003 |
//|--------------------------------------------------------------------------|
//| Essa Função foi desenvolvida com base no Manual do Bco. Itaú e no RDMAKE:|
//| CODBARVL - Autor: Vicente Sementilli - Data: 26/02/1997.                 |
//|--------------------------------------------------------------------------|
//| Descrição: Função para Validação de Código de Barras (CB) e Representação|
//|            Numérica do Código de Barras - Linha Digitável (LD).	         |
//|                                                                          |
//|            A LD de Bloquetos possui três Digitos Verificadores (DV) que  |
//|				são consistidos pelo Módulo 10, além do Dígito Verificador   |
//|				Geral (DVG) que é consistido pelo Módulo 11. Essa LD têm 47  |
//|            Dígitos.                                                      |
//|                                                                          |
//|            A LD de Títulos de Concessinárias do Serviço Público e IPTU   |
//|				possui quatro Digitos Verificadores (DV) que são consistidos |
//|            pelo Módulo 10, além do Digito Verificador Geral (DVG) que    |
//|            também é consistido pelo Módulo 10. Essa LD têm 48 Dígitos.   |
//|                                                                          |
//|            O CB de Bloquetos e de Títulos de Concessionárias do Serviço  |
//|            Público e IPTU possui apenas o Dígito Verificador Geral (DVG) |
//|            sendo que a única diferença é que o CB de Bloquetos é         |
//|            consistido pelo Módulo 11 enquanto que o CB de Títulos de     |
//|            Concessionárias é consistido pelo Módulo 10. Todos os CB´s    |
//|            têm 44 Dígitos.                                               |
//|                                                                          |
//|            Para utilização dessa Função, deve-se criar o campo E2_CODBAR,|
//|            Tipo Caracter, Tamanho 48 e colocar na Validação do Usuário:  |
//|            EXECBLOCK("CODBAR",.T.).                                      |
//|                                                                          |
//|            Utilize também o gatilho com a Função CONVLD() para converter |
//|            a LD em CB.													 |
//\--------------------------------------------------------------------------/

USER FUNCTION CODBAR()       

SETPRVT("cStr,lRet,cTipo,nConta,nMult,nVal,nDV,cCampo,i,nMod,nDVCalc,lFgts,cFgts")


// Retorna .T. se o Campo estiver em Branco.
IF VALTYPE(M->E2_CODBAR) == NIL .OR. EMPTY(M->E2_CODBAR)
	RETURN(.T.)
ENDIF

cStr := LTRIM(RTRIM(M->E2_CODBAR))

// Se o Tamanho do String for 45 ou 46 está errado! Retornará .F.
lRet := IF(LEN(cStr)==45 .OR. LEN(cStr)==46,.F.,.T.)

// Se o Tamanho do String for menor que 44, completa com zeros até 47 dígitos. Isso é
// necessário para Bloquetos que NÂO têm o vencimento e/ou o valor informados na LD.
// Completa as 14 posicoes do valor do documento.
cStr := IF(LEN(cStr)<44,subs(cStr,1,33)+Strzero(val(Subs(cStr,34,14)),14),cStr)                            

// Verifica se a LD é de (B)loquetos ou (C)oncessionárias/IPTU. Se for CB retorna (I)ndefinido.
cTipo := IF(LEN(cStr)==47,"B",IF(LEN(cStr)==48,"C","I"))
                              
lFgts := .F.
If cTipo == "C"
   
   cFgts := Substr(cStr,17,4)  //--- Posicao 17 - 4 caracteres igual a 0179 ou 0180 ou 0181 significa FGTS
   If cFgts == "0179" .or. cFgts == "0180" .or. cFgts == "0181"                 
      lFgts := .T.
   EndIf
EndIf
// Verifica se todos os dígitos são numérios.
FOR i := LEN(cStr) TO 1 STEP -1
	lRet := IF(SUBSTR(cStr,i,1) $ "0123456789",lRet,.F.)
NEXT

If !lRet
   MsgAlert('Somente números devem ser informados no código de barras.')
EndIf

IF LEN(cStr) == 47 .AND. lRet
	// Consiste os três DV´s de Bloquetos pelo Módulo 10.
	nConta  := 1
	WHILE nConta <= 3
		nMult  := 2
		nVal   := 0
		nDV    := VAL(SUBSTR(cStr,IF(nConta==1,10,IF(nConta==2,21,32)),1))
		cCampo := SUBSTR(cStr,IF(nConta==1,1,IF(nConta==2,11,22)),IF(nConta==1,9,10))
		FOR i := LEN(cCampo) TO 1 STEP -1
			nMod  := VAL(SUBSTR(cCampo,i,1)) * nMult
			nVal  := nVal + IF(nMod>9,1,0) + (nMod-IF(nMod>9,10,0))
			nMult := IF(nMult==2,1,2)
		NEXT
		nDVCalc := 10-MOD(nVal,10)
		// Se o DV Calculado for 10 é assumido 0 (Zero).
		nDVCalc := IF(nDVCalc==10,0,nDVCalc)
		lRet    := IF(lRet,(nDVCalc==nDV),.F.)
		nConta  := nConta + 1
	ENDDO                                                              
   	// Se os DV´s foram consistidos com sucesso (lRet=.T.), converte o número para CB para consistir o DVG.
	cStr := IF(lRet,SUBSTR(cStr,1,4)+SUBSTR(cStr,33,15)+SUBSTR(cStr,5,5)+SUBSTR(cStr,11,10)+SUBSTR(cStr,22,10),cStr)
ENDIF

IF LEN(cStr) == 48 .AND. lRet
	// Consiste os quatro DV´s de Títulos de Concessionárias de Serviço Público e IPTU pelo Módulo 10.
	nConta  := 1
	WHILE nConta <= 4
                  
      If lFgts //--- Valida pelo Modulo 11  para FGTS
         
	     // Consiste o DV do FGTS pelo Módulo 11.
		 nDV    := VAL(SUBSTR(cStr,IF(nConta==1,12,IF(nConta==2,24,IF(nConta==3,36,48))),1))
		 cCampo := SUBSTR(cStr,IF(nConta==1,1,IF(nConta==2,13,IF(nConta==3,25,37))),11)
		 nMult  := 2
		 nVal   := 0
		 FOR i := 11 TO 1 STEP -1
		  	nMod  := VAL(SUBSTR(cCampo,i,1)) * nMult
		   	nVal  := nVal + nMod
			nMult := IF(nMult==9,2,nMult+1)
		 NEXT
		 nDVCalc := 11-MOD(nVal,11)
		 // Se o DV Calculado for 0,10 ou 11 é assumido 1 (Um).
		 nDVCalc := IF(nDVCalc==0 .OR. nDVCalc==10 .OR. nDVCalc==11,1,nDVCalc)
	
        
      Else
       
		nMult  := 2
		nVal   := 0
		nDV    := VAL(SUBSTR(cStr,IF(nConta==1,12,IF(nConta==2,24,IF(nConta==3,36,48))),1))
		cCampo := SUBSTR(cStr,IF(nConta==1,1,IF(nConta==2,13,IF(nConta==3,25,37))),11)
		FOR i := 11 TO 1 STEP -1
			nMod  := VAL(SUBSTR(cCampo,i,1)) * nMult
			nVal  := nVal + IF(nMod>9,1,0) + (nMod-IF(nMod>9,10,0))
			nMult := IF(nMult==2,1,2)
		NEXT
		nDVCalc := 10-MOD(nVal,10)
		// Se o DV Calculado for 10 é assumido 0 (Zero).
		nDVCalc := IF(nDVCalc==10,0,nDVCalc)
	 
	  EndIf

	  lRet    := IF(lRet,(nDVCalc==nDV),.F.)

	  nConta  := nConta + 1          
   	
       		
	ENDDO
   	// Se os DV´s foram consistidos com sucesso (lRet=.T.), converte o número para CB para consistir o DVG.
	cStr := IF(lRet,SUBSTR(cStr,1,11)+SUBSTR(cStr,13,11)+SUBSTR(cStr,25,11)+SUBSTR(cStr,37,11),cStr)
ENDIF

IF LEN(cStr) == 44 .AND. lRet
	IF cTipo $ "BI"
		// Consiste o DVG do CB de Bloquetos pelo Módulo 11.
		nMult  := 2
		nVal   := 0
		nDV    := VAL(SUBSTR(cStr,5,1))
		cCampo := SUBSTR(cStr,1,4)+SUBSTR(cStr,6,39)
		FOR i := 43 TO 1 STEP -1
			nMod  := VAL(SUBSTR(cCampo,i,1)) * nMult
			nVal  := nVal + nMod
			nMult := IF(nMult==9,2,nMult+1)
		NEXT
		nDVCalc := 11-MOD(nVal,11)
		// Se o DV Calculado for 0,10 ou 11 é assumido 1 (Um).
		nDVCalc := IF(nDVCalc==0 .OR. nDVCalc==10 .OR. nDVCalc==11,1,nDVCalc)
		lRet    := IF(lRet,(nDVCalc==nDV),.F.)
		// Se o Tipo é (I)ndefinido E o DVG NÂO foi consistido com sucesso (lRet=.F.), tentará
		// consistir como CB de Título de Concessionárias/IPTU no IF abaixo.
	ENDIF
	IF cTipo == "C" .OR. (cTipo == "I" .AND. !lRet)
		// Consiste o DVG do CB de Títulos de Concessionárias pelo Módulo 10.
		lRet   := .T.
		nMult  := 2
		nVal   := 0
		nDV    := VAL(SUBSTR(cStr,4,1))
		cCampo := SUBSTR(cStr,1,3)+SUBSTR(cStr,5,40)
		FOR i := 43 TO 1 STEP -1
			nMod  := VAL(SUBSTR(cCampo,i,1)) * nMult
			nVal  := nVal + IF(nMod>9,1,0) + (nMod-IF(nMod>9,10,0))
			nMult := IF(nMult==2,1,2)
		NEXT
		nDVCalc := 10-MOD(nVal,10)
		// Se o DV Calculado for 10 é assumido 0 (Zero).
		nDVCalc := IF(nDVCalc==10,0,nDVCalc)
		lRet    := IF(lRet,(nDVCalc==nDV),.F.)
	ENDIF
ENDIF

IF !lRet
   MsgAlert('O código de barras está inválido. Informe novamente.')

ENDIF

RETURN(lRet)





/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³CONVLD    ºAutor  ³TOTVS               º Data ³  31/03/06   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³CONVERSAO DE LINHA DIGITAVEL PARA CODIGO DE BARRAS          º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³                                                º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±± Alteracao:                                                             ±±±
±±                                                                        ±±±
±±                                                                        ±±±
±±                                                                        ±±±
±±                                                                        ±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/


///--------------------------------------------------------------------------\
//| Função: CONVLD				Autor: Microsiga            Data: 19/10/2003 |
//|--------------------------------------------------------------------------|
//| Descrição: Função para Conversão da Representação Numérica do Código de  |
//|            Barras - Linha Digitável (LD) em Código de Barras (CB).       |
//|                                                                          |
//|            Para utilização dessa Função, deve-se criar um Gatilho para o |
//|            campo E2_CODBAR, Conta Domínio: E2_CODBAR, Tipo: Primário,    |
//|            Regra: EXECBLOCK("CONVLD",.T.), Posiciona: Não.               |
//|                                                                          |
//|            Utilize também a Validação do Usuário para o Campo E2_CODBAR  |
//|            EXECBLOCK("CODBAR",.T.) para Validar a LD ou o CB.            |
//\--------------------------------------------------------------------------/
USER FUNCTION ConvLD()
SETPRVT("cStr,cFgts")

cStr := LTRIM(RTRIM(M->E2_CODBAR))

IF VALTYPE(M->E2_CODBAR) == NIL .OR. EMPTY(M->E2_CODBAR)
	// Se o Campo está em Branco não Converte nada.
	cStr := ""
ELSE
    // Se o Tamanho do String for menor que 44, completa com zeros até 47 dígitos. Isso é
    // necessário para Bloquetos que NÂO têm o vencimento e/ou o valor informados na LD.
    // Completa as 14 posicoes do valor do documento.
    cStr := IF(LEN(cStr)<44,subs(cStr,1,33)+Strzero(val(Subs(cStr,34,14)),14),cStr)                            
ENDIF

DO CASE
	CASE LEN(cStr) == 47
		cStr := SUBSTR(cStr,1,4)+SUBSTR(cStr,33,15)+SUBSTR(cStr,5,5)+SUBSTR(cStr,11,10)+SUBSTR(cStr,22,10)
	CASE LEN(cStr) == 48
   
       cFgts := Substr(cStr,17,4)  //--- Posicao 17 - 4 caracteres igual a 0179 ou 0180 ou 0181 significa FGTS
       If cFgts == "0179" .or. cFgts == "0180" .or. cFgts == "0181"                 
          cStr := cStr+SPACE(48-LEN(cStr)) 
       Else
          cStr := SUBSTR(cStr,1,11)+SUBSTR(cStr,13,11)+SUBSTR(cStr,25,11)+SUBSTR(cStr,37,11)
	   EndIf
	OTHERWISE
		cStr := cStr+SPACE(48-LEN(cStr))
ENDCASE


//--- Mostra mensagem da data do vencimento
If !Empty(cStr) 
   If Val(SubStr(cStr,6,4)) > 0
      _dDtPagto	:= DToS(CToD("07/10/97") + Val(SubStr(cStr,6,4)))
      If Dtos(M->E2_VENCREA) <> _dDtPagto
         MsgAlert('DATA DE VENCIMENTO DIVERGENTE. A data de vencimento no código de barras está '+Dtoc(Stod(_dDtPagto))+' e o Vencto Real digitado no título está '+Dtoc(M->E2_VENCREA)+'. Verifique.')
      EndIf
   EndIf   
   If Val(SubStr(cStr,10,10)) > 0
      _Valor := Val(Substr(cStr,10,10))/100
      If M->E2_VALOR <> _Valor
      
         MsgAlert('VALOR DIVERGENTE. O valor no código de barras está '+Alltrim(Str(_Valor))+' e o valor digitado no título está '+Alltrim(Str(M->E2_VALOR))+'. Verifique.')
      EndIf       
   EndIf   
EndIf
       
RETURN(cStr)
              
/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Rotina    ³ IDEMPRE.PRW                                                ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³ ExecBlock para retornar a identificacao da empresa cedente ³±±
±±³ 021 a 037 - Identificacao da Empresa Cedente no Banco                 ³±±
±±³ Deverá ser preenchido (esquerda para direita), da seguinte maneira:   ³±±
±±³    21 a 21 - Zero                                                     ³±±
±±³    22 a 24 - Codigo da carteira                                       ³±±
±±³    25 a 29 - Codigo da Agencia Cedente, sem o digito                  ³±±
±±³    30 a 36 - Conta corrente                                           ³±±
±±³    37 a 37 - Digito da Conta corrente                                 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Desenvolvi³ TOTVS                                                      ³±±
±±³mento     ³ 14/11/06.                                                  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Uso       ³ Cnab a Receber BRADESCO                                    ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/

User Function IdEmpre()        
   

Local _identemp := ""

_identemp := "0" 
_identemp := _identemp + "0" + Substr(SEE->EE_SUBCTA,1,2) //- SEE-->EE_SUBCTA - Codigo carteira cobrança 
_identemp := _identemp + STRZERO(VAL(SUBSTR(Alltrim(SA6->A6_AGENCIA),1,Len(AllTrim(SA6->A6_AGENCIA))-1)),5)  
_identemp := _identemp + STRZERO(VAL(Alltrim(SA6->A6_NUMCON)),8) 
                                                  
Return(_identemp)


/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Rotina    ³ VALCOBR.PRW                                                ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³ ExecBlock para retornar o valor dos boleto deduzindo os    ³±±
±±³            abatimentos concedidos nos titulos do contas a receber     ³±±
±±³          ³ a ser gravando no arquivo de remessa ao banco via Cnab.    ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Desenvolvi³ TOTVS                                                      ³±±
±±³mento     ³                                                            ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Uso       ³ Cnab a Receber BRADESCO                                    ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/

User Function Valcobr()     
   
Local _tTabat , _valor

_TtAbat := 0.00
_Valor  := 0.00

//--- Funcao SOMAABAT totaliza todos os titulos com e1_tipo AB- relacionado ao
//---        titulo do parametro 
_TtAbat  := somaabat(SE1->E1_PREFIXO,SE1->E1_NUM,SE1->E1_PARCELA,'R',SE1->E1_MOEDA,DDATABASE,SE1->E1_CLIENTE,SE1->E1_LOJA)

_Valor   := (SE1->E1_SALDO - _TtAbat -SE1->E1_DECRESC + SE1->E1_ACRESC - SE1->E1_PIS - SE1->E1_COFINS - SE1->E1_CSLL) 

Return(_Valor)       


/*   
+-----------------------------------------------------------------------------+
|Programa  : PAGAR237                                                         |
|Descrição : Função única para o Pagfor BRADESCO                              |
+-----------------------------------------------------------------------------+
|Autor     : TOTVS  - 17/06/2009                                              | 
|Observacao:                                                                  |
|                                                                             |
+-------------------------------------------------+--------+------------------+
|Alterado                                         |Em      | Por              |
|Incluir configuração Tributos                    |15/07/09| Marciane         |                                                                                                                             |
|Incluir tratamento conta complementar Bradesco   |19/08/09|                  |
|                                                 |DD/MM/AA|                  |
|                                                 |DD/MM/AA|                  |
|                                                 |DD/MM/AA|                  |
|                                                 |DD/MM/AA|                  |
|                                                 |DD/MM/AA|                  |
+-----------------------------------------------------------------------------+

+-----------------+-------+--------+
| Nome            |Pos.   | Parame-|                                            
| Campo           |Inicial| tro    | 
+-----------------+-------+--------+
| CNPJ FORNECEDOR |  003  |  PP003 |                     
| CODIGO BANCO    |  096  |  PP096 |                     
| CODIGO AGENCIA  |  099  |  PP099 |                     
| CONTA CORRENTE  |  105  |  PP105 |                     
| CARTEIRA        |  136  |  PP136 |                     
| NOSSO NUMERO    |  139  |  PP139 |                     
| DATA VENCIMENTO |  166  |  PP166 |                     
| VALOR DOCUMENTO |  195  |  PP195 |
| VALOR PAGAMENTO |  205  |  PP205 |
| VALOR DESCONTO  |  220  |  PP220 |
| VALOR ACRESCIMO |  235  |  PP235 |                     
| MOD PAGAMENTO   |  264  |  PP264 |  
| INFORM.COMPLEM  |  374  |  PP374 |                     
| TIPO CONTA      |  479  |  PP479 |  
| CTA COMPLEMENTAR|  480  |  PP480 |  
+-----------------+----------------+    
|GPS/DARF - TRIBUTOS               | 
+-----------------+-------+--------+
| NOME DO CLIENTE |  002  |  PT001 |                                             
| ENDERECO CLIENT |  042  |  PT002 |                                                 
| CEP CLIENTE     |  082  |  PT003 |                                                 
| TIPO CLIENTE    |  132  |  PT004 |                                                 
| CNPJ CLIENTE    |  133  |  PT005 |                                            
| CNPJ CONTRIBUIN |  243  |  PT005 |                                                
| NOME RECOLHEDOR |  343  |  PT006 |                                                
+-----------------+-------+--------+
*/

User Function Pagar237(_cOpcao)   

Local  _cTipo     := ""
Local  _cRetorno  := ""
Local  _Agencia   := "000000"    		
Local  _NumCon    := ""              		


Local  _TtAbat    := 0.00       		
Local  _Juros     := 0.00       		 
Local  _Liqui     := 0.00       		
Local  TtAbat     := 0.00       		
Local  _RetDig    := ""              		
Local  _Dig1      := ""              		
Local  _Dig2      := ""              		
Local  _Dig3      := ""              		
Local  _Dig4      := ""              		
Local  _Dig5      := ""              		
Local  _Dig6      := ""              		
Local  _Dig7      := ""              		
Local  _CBanco    := ""              		
Local  _Mult                    		                                                
Local  _Resul                   		
Local  _Resto                   		
Local  _Digito                  		
Local  _Agc       := ""         		
Local  _DigAgc    := ""         		
Local  _CtaCed    := "000000000000000"          
Local  _nPosDV                  		
Local  _Digito                  		
Local  _cConta                  		
Local  _cDigCC                  		
Local  _RetCar    := "000"                      
Local  _VALOR                                   
Local  _Doc                                     
Local  _Mod                                     
Local  _dDtPagto                                
Local  _AMODEL
Local  _cCdRet                                  
Local  _TpCta     := ""
Local  aArea      := GetArea()

_cTipo    := Alltrim(Upper(_cOpcao))

Do Case
	
    Case _cTipo == "PP003"	//  CNPJ do Fornecedor para Deposito

       If SA2->A2_TIPO = "F"
		  _cRetorno := Substr(SA2->A2_CGC,1,9)+"0000"+Substr(SA2->A2_CGC,10,2)
	   Else
	  	 _cRetorno := Strzero(Val(SA2->A2_CGC),15)
	   EndIf

       
    Case _cTipo == "PP205"	//  Valor do Pagamento
       _TtAbat   := somaabat(SE2->E2_PREFIXO,SE2->E2_NUM,SE2->E2_PARCELA,'P',SE2->E2_MOEDA,DDATABASE,SE2->E2_FORNECE,SE2->E2_LOJA)
	   _TtAbat   += SE2->E2_DECRESC 
	   _Juros    := SE2->E2_ACRESC
	   _Liqui    := (SE2->E2_SALDO-_TtAbat+_Juros)

	   _cRetorno := Left(StrZero((_Liqui*1000),16),15)

    Case _cTipo == "PP220"  // Valor do Desconto
	   _TtAbat   := somaabat(SE2->E2_PREFIXO,SE2->E2_NUM,SE2->E2_PARCELA,'P',SE2->E2_MOEDA,DDATABASE,SE2->E2_FORNECE,SE2->E2_LOJA)
	   _TtAbat   += SE2->E2_DECRESC 
	   _cRetorno := Left(StrZero((_TtAbat*1000),16),15)      

    Case _cTipo == "PP235"  //  Valor do Acrescimo
	   _Juros    := SE2->E2_ACRESC
	   _cRetorno := Left(StrZero((_Juros*1000),16),15)   

    Case _cTipo == "PP096"  //  Codigo do Banco

      If SEA->EA_MODELO == "31" .or. SEA->EA_MODELO == "30"  //--- Boletos
    	   _cBanco := Substr(SE2->E2_CODBAR,1,3)
   
   	       If Empty(SE2->E2_CODBAR) 
              MsgAlert("Filial: "+se2->e2_filial+" "+"Titulo "+alltrim(se2->e2_prefixo)+"-"+alltrim(se2->e2_num)+" "+alltrim(se2->e2_parcela)+" do fornecedor "+alltrim(sa2->a2_cod)+"-"+alltrim(sa2->a2_loja)+" "+alltrim(sa2->a2_nome)+" sem código de barras. Informe o código de barras no título indicado e execute esta rotina novamente.")
       	   EndIf                  
	   
	  Else           
	      
	      If SE2->E2_XCONTA == "2"  //--- Utilizar 2.conta para pagamento

             _cBanco := SA2->A2_XBANCO2
                                             
              If SEA->EA_MODELO == "04" .or. SEA->EA_MODELO == "10"

	             If Empty(SA2->A2_XAGENC2) .or. Empty(SA2->A2_XBANCO2)
                     MsgAlert("Filial: "+se2->e2_filial+" "+"Titulo "+alltrim(se2->e2_prefixo)+"-"+alltrim(se2->e2_num)+" "+alltrim(se2->e2_parcela)+" do fornecedor "+alltrim(sa2->a2_cod)+"-"+alltrim(sa2->a2_loja)+" "+alltrim(sa2->a2_nome)+;
              	     	' sem agencia 2 informada no cadastro do fornecedor. Atualize os dados no cadastro do fornecedor e execute esta rotina novamente.')
      	         EndIf
              
              Else

	             If Empty(SA2->A2_XAGENC2) .or. Empty(SA2->A2_XNUMCO2) .or. Empty(SA2->A2_XBANCO2)
                     MsgAlert("Filial: "+se2->e2_filial+" "+"Titulo "+alltrim(se2->e2_prefixo)+"-"+alltrim(se2->e2_num)+" "+alltrim(se2->e2_parcela)+" do fornecedor "+alltrim(sa2->a2_cod)+"-"+alltrim(sa2->a2_loja)+" "+alltrim(sa2->a2_nome)+;
              	     	' sem agencia 2 ou sem conta corrente 2 informada no cadastro do fornecedor. Atualize os dados no cadastro do fornecedor e execute esta rotina novamente.')
      	         EndIf                         
      	         
      	      EndIf
      	   
	      Else
	      
             _cBanco := SA2->A2_BANCO
           
              If SEA->EA_MODELO == "04" .or. SEA->EA_MODELO == "10"
	          
	             If Empty(SA2->A2_AGENCIA) .or. Empty(SA2->A2_BANCO)
                     MsgAlert("Filial: "+se2->e2_filial+" "+"Titulo "+alltrim(se2->e2_prefixo)+"-"+alltrim(se2->e2_num)+" "+alltrim(se2->e2_parcela)+" do fornecedor "+alltrim(sa2->a2_cod)+"-"+alltrim(sa2->a2_loja)+" "+alltrim(sa2->a2_nome)+;
              		' sem agencia 1 informada no cadastro do fornecedor. Atualize os dados no cadastro do fornecedor e execute esta rotina novamente.')
      	         EndIf
      	      
      	      Else 

	             If Empty(SA2->A2_AGENCIA) .or. Empty(SA2->A2_NUMCON) .or. Empty(SA2->A2_BANCO)
                     MsgAlert("Filial: "+se2->e2_filial+" "+"Titulo "+alltrim(se2->e2_prefixo)+"-"+alltrim(se2->e2_num)+" "+alltrim(se2->e2_parcela)+" do fornecedor "+alltrim(sa2->a2_cod)+"-"+alltrim(sa2->a2_loja)+" "+alltrim(sa2->a2_nome)+;
              		' sem agencia 1 ou sem conta corrente 1 informada no cadastro do fornecedor. Atualize os dados no cadastro do fornecedor e execute esta rotina novamente.')
      	         EndIf
      	      
      	      EndIf
      	  EndIf
      	   
      EndIf	   
       
       _cRetorno:= _cBanco


    Case _cTipo == "PP099"  // Código da Agência
   		If Substr(SEA->EA_MODELO,1,2) == "31" .or. Substr(SEA->EA_MODELO,1,2) == "30"
      		_cBanco := Substr(SE2->E2_CODBAR,1,3)
   		Else                           
   		    If SE2->E2_XCONTA == "2"  //--- Utilizar 2.conta para pagamento

       		   _cBanco  := SA2->A2_XBANCO2 
       		   _Agc     := Alltrim(SA2->A2_XAGENC2) 
       		   _DigAgc  := SA2->A2_XDVAGE2

       		Else

       		   _cBanco  := SA2->A2_BANCO 
       		   _Agc     := Alltrim(SA2->A2_AGENCIA) 
       		   _DigAgc  := SA2->A2_XDVAGE

       		EndIf  
     	EndIf   
	      
   		If _cBanco == "237"	// BRADESCO
  
       		If Substr(SEA->EA_MODELO,1,2) == "31" .or. Substr(SEA->EA_MODELO,1,2) == "30"
         	
         		_Agencia :=  "0" + SUBSTR(SE2->E2_CODBAR,20,4)
         	
         		_DIG1    := SUBSTR(SE2->E2_CODBAR,20,1)
         		_DIG2    := SUBSTR(SE2->E2_CODBAR,21,1)
         		_DIG3    := SUBSTR(SE2->E2_CODBAR,22,1)
         		_DIG4    := SUBSTR(SE2->E2_CODBAR,23,1)

         	Else
         	
         	    //--- Vou calcular sempre o digito da agencia para o Banco Bradesco
         	    //--- Variavel _Agc é SA2->A2_AGENCIA para campo E2_XCONTA em branco ou 1 /
         	    //---              ou SA2->A2_XAGENC2 para campo E2_XCONTA igual a 2
        		_Agencia :=  "0" + Substr(_Agc,1,4)
        		
         		_DIG1    := SUBSTR(_Agc,1,1)
         		_DIG2    := SUBSTR(_Agc,2,1)
         		_DIG3    := SUBSTR(_Agc,3,1)
         		_DIG4    := SUBSTR(_Agc,4,1)
           		
      		EndIf

         	_RETDIG := " "
         	_MULT   := (VAL(_DIG1)*5) +  (VAL(_DIG2)*4) +  (VAL(_DIG3)*3) +   (VAL(_DIG4)*2)
         	_RESUL  := INT(_MULT /11 )
         	_RESTO  := INT(_MULT % 11)
         	_DIGITO := 11 - _RESTO

         	_RETDIG := IF( _RESTO == 0,"0",IF(_RESTO == 1,"0",ALLTRIM(STR(_DIGITO))))
   		    
   			_Agencia := _Agencia + _RETDIG
      		
   		Else
     	
     		_Agencia := STRZERO(VAL(_Agc),5)+_DigAgc
   		
   		EndIf

   		_cRetorno := _Agencia     

    Case _cTipo == "PP105"  //  Conta Corrente
        _CtaCed := "000000000000000"          // PP105
		_cBanco := SUBSTR(SE2->E2_CODBAR,1,3)
		
		IF _cBanco == "237"	// BRADESCO
		
			_CtaCed  :=  STRZERO(VAL(SUBSTR(SE2->E2_CODBAR,37,7)),13,0)
		
			_RETDIG := " "
			_DIG1   := SUBSTR(SE2->E2_CODBAR,37,1)
			_DIG2   := SUBSTR(SE2->E2_CODBAR,38,1)
			_DIG3   := SUBSTR(SE2->E2_CODBAR,39,1)
			_DIG4   := SUBSTR(SE2->E2_CODBAR,40,1)
			_DIG5   := SUBSTR(SE2->E2_CODBAR,41,1)
			_DIG6   := SUBSTR(SE2->E2_CODBAR,42,1)
			_DIG7   := SUBSTR(SE2->E2_CODBAR,43,1)
		
			_MULT   := (VAL(_DIG1)*2) +  (VAL(_DIG2)*7) +  (VAL(_DIG3)*6) +   (VAL(_DIG4)*5) +  (VAL(_DIG5)*4) +  (VAL(_DIG6)*3)  + (VAL(_DIG7)*2)
			_RESUL  := INT(_MULT /11 )
			_RESTO  := INT(_MULT % 11)
			_DIGITO := STRZERO((11 - _RESTO),1,0)
		
			_RETDIG := IF( _resto == 0,"0",IF(_resto == 1,"P",_DIGITO))
		
			_CtaCed := _CtaCed + _RETDIG
		
		ELSE

			IF SUBSTR(SEA->EA_MODELO,1,2) <> "31" .AND. SUBSTR(SEA->EA_MODELO,1,2) <> "30"        

   		        If SE2->E2_XCONTA == "2"  //--- Utilizar 2.conta para pagamento
           		
           		   _cConta := Alltrim(SA2->A2_XNUMCO2) 
           		   _cDigCc := SA2->A2_XDVCTA2
       	  	    
       	  	    Else
           		   
           		   _cConta := Alltrim(SA2->A2_NUMCON)
           		   _cDigCc := SA2->A2_XDVCTA
       	  	    
       	  	    EndIf
       	  		
       	  		_CtaCed := strzero(val(_cConta),13,0)+_cDigCc                                                  
       	  	    
       	  	ENDIF
		
		ENDIF

		_cRetorno:=_CtaCed

    Case _cTipo == "PP136"  //  Carteira
         _RetCar := "000"
		 If SEA->EA_MODELO == "31" .OR. SEA->EA_MODELO == "30"
   		  	IF SUBS(SE2->E2_CODBAR,01,3) == "237"
       			_Retcar := "0" + SUBS(SE2->E2_CODBAR,24,2)
   			EndIf
		 EndIf

		 _cRetorno := _Retcar      

    Case _cTipo == "PP139"  //  Nosso Número

		_cRetorno := "000000000000"
        
		If SEA->EA_MODELO == "31" .OR. SEA->EA_MODELO == "30"
   			If SUBS(SE2->E2_CODBAR,01,3) == "237"
      		   _cRetorno := "0" + SUBS(SE2->E2_CODBAR,26,11) 
   			EndIf
		EndIf

    Case _cTipo == "PP195"  //  Valor Documento
        _Valor :=Replicate("0",10)

		If SEA->EA_MODELO == "31" .OR. SEA->EA_MODELO == "30"
		    _Valor := Substr(SE2->E2_CODBAR,10,10)
		Else
    		_Valor := Strzero((SE2->E2_SALDO*100),10,0)
		Endif

        _cRetorno := _Valor

    Case _cTipo == "PP374"  //  Informações Complementares

		_Mod := alltrim(SEA->EA_MODELO)
		_Doc := SPACE(40)
        _xTpCta := IF(SE2->E2_XCONTA=="2",SA2->A2_XTIPCT2,SA2->A2_XTIPCTA) //-- 1-Conta Corrente, 2-Conta Poupança, 3-Ordem de Pagamento
       
		IF (_Mod == "03") .OR. (_Mod == "07") .OR. (_Mod == "08") .or. (_Mod == "41") .or.(_Mod == "43")       
		
		   IF SA2->A2_CGC == SM0->M0_CGC           
		      _Doc:="D"+"000000"+IF(!EMPTY(SE2->E2_XJUDICI),"1203"+Strzero(Val(SE2->E2_XJUDICI),18)+SPACE(11),"01"+Strzero(Val(_xTpCta),2)+SPACE(29) )
		   ELSE
		      _Doc:="C"+"000000"+IF(!EMPTY(SE2->E2_XJUDICI),"1203"+Strzero(Val(SE2->E2_XJUDICI),18)+SPACE(11),"01"+Strzero(Val(_xTpCta),2)+SPACE(29) )
           ENDIF       
               
		ELSE 
		   IF _Mod == "31" .OR. _Mod == "30"
 		        _Doc := SUBSTR(SE2->E2_CODBAR,20,25)+SUBSTR(SE2->E2_CODBAR,5,1)+SUBSTR(SE2->E2_CODBAR,4,1)+SPACE(13)
		   ELSE
		        _Doc := SPACE(40)
		   ENDIF 
       	ENDIF  	        	 

		_cRetorno:=_Doc
		
    Case _cTipo == "PP166"  //  Data Vencimento
         //  PROGRAMA PARA INDICAR A DATA DE PAGAMENTOS DOS TITULOS

         // 01 - Depositos em Conta Corrente
         // 03 - DOCs para outros Bancos
         // 30 - Titulos do Banco Bradesco - Rastreamento
         //      O Bradesco ira procurar todos os titulos do proprio banco contra o
         //      seu CGC e enviara para sua confirmacao de pagamento
         // 31 - Titulos de Outros Bancos

         If SEA->EA_MODELO == "31" .or. SEA->EA_MODELO == "30" // Boletos com código de barras
            If !Empty(SE2->E2_CODBAR) .And. Val(SubStr(SE2->E2_CODBAR,6,4)) > 0
               _dDtPagto	:= DToS(CToD("07/10/97") + Val(SubStr(SE2->E2_CODBAR,6,4)))
            Else
               _dDtPagto := Dtos(SE2->E2_VENCREA)
            EndIf                
         Else	
             _dDtPagto := Dtos(SE2->E2_VENCREA)
         Endif
         _cRetorno := _dDtPagto

    Case _cTipo == "PP264"  //  Mod Pagamento

		_aModel := SEA->EA_MODELO               

		If SEA->EA_MODELO == "30"
   			_aModel := "31"
		ElseIF SEA->EA_MODELO == "41"  .or. SEA->EA_MODELO == "43"  // TED
			_aModel := "08"                                                            
		ElseIF SEA->EA_MODELO == "05"  .or. SEA->EA_MODELO == "10"  // OP a disposicao do favorecido
			_aModel := "02"                                                            
		EndIf

		_cRetorno := _aModel     

    Case _cTipo == "PP479"  //  Tipo Cliente

		If(SEA->EA_MODELO=="01" .OR. SEA->EA_MODELO=="05") 

            _cRetorno := IF(SE2->E2_XCONTA=="2",SA2->A2_XTIPCT2,SA2->A2_XTIPCTA) //-- 1-Conta Corrente, 2-Conta Poupança, 3-Ordem de Pagamento
   
            If Empty(_cRetorno) 
               _cRetorno := "1"
               MsgAlert('Fornecedor '+alltrim(sa2->a2_cod)+"-"+alltrim(sa2->a2_loja)+" "+alltrim(sa2->a2_nome)+' com tipo de conta corrente em Branco no cadastro do fornecedor para o banco '+IF(SE2->E2_XCONTA=="2",SA2->A2_XBANCO2,SA2->A2_BANCO)+'. Atualize os dados no cadastro do fornecedor, o sistema está assumindo CONTA CORRENTE.')
            EndIf                  

		Else  //--- Nao é credito em conta

       		_cRetorno := "0"

		EndIf               
		
	 //Case _cTipo == "PP480" // Obtem o numero da conta corrente da empresa (SA6) - Conta complementar
	
	 //     _cRetorno  := Strzero(Val(SA6->A6_NUMCON),7) 
	
     Case _cTipo == "PT001"  //  Nome Contribuinte

                                              
          If !Empty(SE2->E2_XCONTR)
             _cRetorno := Subs(SE2->E2_XCONTR,1,40)
          Else
             _cRetorno := Subs((Alltrim(SM0->M0_NOMECOM)+" - "+SM0->M0_NOME),1,40)
          EndIf
 
      Case _cTipo == "PT002"  //  Endereco Contribuinte

           If !Empty(SE2->E2_XCONTR)
  
              //--- Pesquisa o endereco do contribuinte pelo CNPJ na tabela SA2.
              _cRetorno := GetAdvFval("SA2","A2_END",xFilial("SA2")+SE2->E2_XCNPJC,3)
               
              If Empty(_cRetorno)
     
                 MsgAlert('Não foi encontrado endereço cadastrado para o CNPJ/Contribuinte: '+alltrim(se2->e2_xcnpjc)+"-"+alltrim(se2->e2_xcontr)+' . Atualize os dados no cadastro do fornecedor e execute esta rotina novamente.')

              EndIf

          Else

             _cRetorno := Subs(SM0->M0_ENDCOB,1,40) 
 
          EndIf
  
      Case _cTipo == "PT003"  //  CEP Contribuinte

           If !Empty(SE2->E2_XCONTR)
  
  
              //--- Pesquisa o endereco do contribuinte pelo CNPJ na tabela SA2.
              _cRetorno := GetAdvFval("SA2","A2_CEP",xFilial("SA2")+SE2->E2_XCNPJC,3)
               
              If Empty(_cRetorno)
     
                 MsgAlert('Não foi encontrado CEP cadastrado para o CNPJ/Contribuinte: '+alltrim(se2->e2_xcnpjc)+"-"+alltrim(se2->e2_xcontr)+' . Atualize os dados no cadastro do fornecedor e execute esta rotina novamente.')

              EndIf

           Else

             _cRetorno := Subs(SM0->M0_CEPCOB,1,8) 
 
           EndIf
           _cRetorno := Strzero(Val(_cRetorno),8)
  
      Case _cTipo == "PT004"  //  Tipo da Inscricao

           If !Empty(SE2->E2_XCONTR)
              _cRetorno := Iif (len(alltrim(SE2->E2_XCNPJC))>11,"2","1")
           Else               
              _cRetorno := "2"       
           EndIf

     Case _cTipo == "PT005"  //  CNPJ Contribuinte
          If !Empty(SE2->E2_XCONTR)
  
             If Empty(SE2->E2_XCNPJC)
     
                MsgAlert('O titulo de tributo '+alltrim(se2->e2_prefixo)+"-"+alltrim(se2->e2_num)+" "+alltrim(se2->e2_parcela)+' do fornecedor '+alltrim(se2->e2_fornece)+" "+alltrim(se2->e2_loja)+' está sem o CNPJ/CPF do Contribuinte. Atualize os dados no titulo do imposto e execute esta rotina novamente.')
 
             EndIf
     
             _cRetorno := Strzero(Val(SE2->E2_XCNPJC),14)
     
          Else

             _cRetorno := Strzero(Val(SM0->M0_CGC),14)
 
          EndIf

    Case _cTipo == "PT006"  //  Nome Recolhedor  
        _cRetorno := ""               
     
        _cCdRet := If(!Empty(SE2->E2_XINSS),SE2->E2_XINSS,SE2->E2_CODRET)
                                            
        If _cCdRet == "2631" .or. _cCdRet == "2658" 
  
           _cRetorno := AllTrim(SM0->M0_NOMECOM)+" - "+AllTrim(SM0->M0_NOME)
     
        EndIf   
        

        
    OtherWise  //  Parametro não existente
        
			MsgAlert('Não foi encontrado o Parametro '+ _cTipo + "."+;
        		 'Solicite à informática para verificar a função PAGAR237 no fonte CNABXFUN, ou o arquivo de configuração do CNAB.')

ENDCASE

RestArea(aArea)		      
RETURN(_cRetorno)  

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³PAGAR001  ºAutor  ³Marciane Gennari    º Data ³  24/06/09   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ Gera as informacoes para o cnab a pagar o banco do brasil. º±±
±±º          ³ Utiliza o SISPAG para gerar o arquivo                      º±±
±±º                                                                       º±±
±±ºParametros:                                                            º±±
±±º                                                                       º±±
±±º   1 - Retorna codigo agencia (SA6)                                    º±±
±±º   2 - Retorna digito do codigo agencia (SA6)                          º±±
±±º   3 - Retorna conta corrente (SA6)                                    º±±
±±º   4 - Retorna digito da conta corrente (SA6)                          º±±
±±º   5 - Retorna o endereco da empresa (SM0)                             º±±
±±º   6 - Retorna o numero do endereco da empresa (SM0)                   º±±
±±º   7 - Retorna o codigo da camara centralizadora                       º±±
±±º   8 - Retorna o valor do pagamento                                    º±±
±±º   9 - Retorna o valor do desconto                                     º±±
±±º  10 - Retorna o valor dos juros                                       º±±
±±º  11 - Retorna o nome do contribuinte (segmento N)                     º±±
±±º  12 - Retorna os detalhes do segmento N (depende do tipo do tributo)  º±±
±±º  13 - Retorna o tipo de inscricao do favorecido                       º±±
±±º  14 - Retorna o CNPJ do favorecido                                    º±±
±±º  15 - Retorna o digito da agencia do fornecedor (SA2)                 º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³                                                            º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/


User Function Pagar001(_cOpcao)


Local _cReturn := ""
Local _Posicao := 0
Local _TtAbat  := 0.00
Local _Juros   := 0.00
Local _Liqui   := 0.00
Local _Dig1    := ""                           
Local _Dig2    := ""                             
Local _Dig3    := ""                         
Local _Dig4    := ""                             
Local _Retdig  := " "
Local _Multa 
Local _Resul
Local _Resto
Local _Digito

If _cOpcao == "1"  // Obtem o numero da agencia da empresa (SA6)
	
	_cReturn := Strzero(Val(Substr(SA6->A6_AGENCIA,1,Len(Alltrim(SA6->A6_AGENCIA))-1)),5,0)
	
ElseIf _cOpcao =="2"  // Obtem o digito da agencia da empresa (SA6)
	
	_cReturn := Substr(SA6->A6_AGENCIA,Len(Alltrim(SA6->A6_AGENCIA)),1)
	
ElseIf _cOpcao == "3"    // Obtem o numero da conta corrente da empresa (SA6)
	
	_cReturn  := Strzero(Val(Substr(SA6->A6_NUMCON,1,Len(Alltrim(SA6->A6_NUMCON))-1)),12,0) 

elseIf _cOpcao =="4"     // Obtem o digito da conta corrente da empresa (SA6)
	
	_cReturn := Substr(SA6->A6_NUMCON,Len(Alltrim(SA6->A6_NUMCON)),1)
	
ElseIf _cOpcao =="5"   // Obtem o endereco da empresa       
	
  _posicao   := at(",",sm0->m0_endcob)
  if _posicao == 0
     _cReturn := sm0->m0_endcob
  else
     _cReturn := substr(sm0->m0_endcob,1,(_posicao-1))
  endif

ElseIf _cOpcao == "6"  // Obtem Numero do endereco da empresa (SM0)                                                                 
  _posicao   := at(",",sm0->m0_endcob)
  if _posicao == 0
     _cReturn := "0"
  else
     _cReturn := substr(sm0->m0_endcob,(_posicao+1),30)
  endif
  _cReturn := alltrim(_cReturn)
  _cReturn := StrZero(val(_cReturn),5,0) 	
       
ElseIf _cOpcao == "7"   // Obtem codigo da camara centralizadora

   If SEA->EA_MODELO == "41" .or. SEA->EA_MODELO == "43" 
     _cReturn := "018"
   ElseIf SEA->EA_MODELO == "03"
     _cReturn := "700"
   Else
     _cReturn := "000"
   EndIf
		
ElseIf _cOpcao == "8"   // Obtem Valor Pagamento

   //--- Funcao SOMAABAT totaliza todos os titulos com e2_tipo AB- relacionado ao
   //---        titulo do parametro 
   _TtAbat  := somaabat(SE2->E2_PREFIXO,SE2->E2_NUM,SE2->E2_PARCELA,'P',SE2->E2_MOEDA,DDATABASE,SE2->E2_FORNECE,SE2->E2_LOJA)
   _TtAbat  += SE2->E2_DECRESC                       
   _Juros   := (SE2->E2_MULTA + SE2->E2_VALJUR + SE2->E2_ACRESC)
   _Liqui   := (SE2->E2_SALDO-_TtAbat+_Juros)
   
   _cReturn := Left(StrZero((_Liqui*1000),16),15)

ElseIf _cOpcao == "9"   // Obtem Valor do Desconto

   _TtAbat  := somaabat(SE2->E2_PREFIXO,SE2->E2_NUM,SE2->E2_PARCELA,'P',SE2->E2_MOEDA,DDATABASE,SE2->E2_FORNECE,SE2->E2_LOJA)
   _TtAbat  += SE2->E2_DECRESC                          
   
   _cReturn := Left(StrZero((_TtAbat*1000),16),15)

ElseIf _cOpcao == "10"   // Obtem Valor de Juros

   _Juros   := (SE2->E2_MULTA + SE2->E2_VALJUR + SE2->E2_ACRESC)
   _cReturn := Left(StrZero((_Juros*1000),16),15)

ElseIf _cOpcao == "11"   // Nome do Contribuinte
   
   If !Empty(SE2->E2_XCNPJC)
     _cReturn := Subs(SE2->E2_XCONTR,1,30)
     If Empty(_cReturn)
        MsgAlert('Nome do Contribuinte não informado para a DARF - Titulo '+alltrim(se2->e2_prefixo)+"-"+alltrim(se2->e2_num)+"-"+alltrim(se2->e2_parcela)+'. Atualize o Nome do Contribuinte no titulo indicado e execute esta rotina novamente.')
     EndIf
  Else
     _cReturn := Subs(SM0->M0_NOMECOM,1,30)
  EndIf   
   
ElseIf _cOpcao == "12"   // Detalhes Segmento N 
   
  //--- Mensagem ALERTA que está sem periodo de apuração
  If Empty(se2->e2_xapur)                              
     
     MsgAlert('Tributo sem Periodo de Apuracao. Informe o campo Per.Apuracao no Titulo: '+alltrim(se2->e2_prefixo)+" "+alltrim(se2->e2_num)+" "+alltrim(se2->e2_parcela)+" Tipo: "+alltrim(se2->e2_tipo)+" Fornecedor/Loja: "+alltrim(se2->e2_fornece)+"-"+alltrim(se2->e2_loja)+' e execute esta rotina novamente.')

  EndIf
  

  //--- Codigo Receita do Tributo - Posicao 111 a 116
  _cReturn := If(!Empty(SE2->E2_XINSS),Strzero(Val(SE2->E2_XINSS),6),Strzero(Val(SE2->E2_CODRET),6))
   
  //--- Tipo de Identificacao do Contribuinte - Posicao 117 a 118
  //--- CNPJ (1) /  CPF (2)             
  If !Empty(SE2->E2_XCNPJC)
     _cReturn += Iif (len(alltrim(SE2->E2_XCNPJC))>11,"01","02")
  Else               
     _cReturn += "01"           
  EndIf
             
  //--- Identificacao do Contribuinte - Posicao 119 a 132
  //--- CNPJ/CPF do Contribuinte
  If !Empty(SE2->E2_XCNPJC)
     _cReturn += Strzero(Val(SE2->E2_XCNPJC),14)
  Else
     _cReturn += Subs(SM0->M0_CGC,1,14)
  EndIf
                                              
  //--- Identificacao do Tributo - Posicao 133 a 134  
  //--- 16 - DARF Normal   
  //--- 17 - GPS 
  _cReturn += SEA->EA_MODELO 


  //--- GPS                  
  If SEA->EA_MODELO == "17" //--- GPS
     
     //--- Competencia (Mes/Ano) - Posicao 135 a 140  Formato MMAAAA
     _cReturn += Strzero(Month(SE2->E2_XAPUR),2)+Strzero(Year(SE2->E2_XAPUR),4)  

     //--- Valor do Tributo - Posicao 141 a 155
     _cReturn += Strzero((SE2->E2_SALDO-SE2->E2_XVLENT)*100,15)
     
     //--- Valor Outras Entidades - Posicao 156 a 170             
     _cReturn += Strzero(SE2->E2_XVLENT*100,15)     
     
     //--- Atualizacao Monetaria - Posicao 171 a 185                        
     _cReturn += Strzero(SE2->E2_ACRESC*100,15)                              

     //--- Mensagem ALERTA que está sem Codigo da Receita
     If Empty(se2->e2_xinss)                              
     
        MsgAlert('Tributo sem Codigo Receita. Informe o campo Cod.Rec/Pag no Titulo: '+alltrim(se2->e2_prefixo)+" "+alltrim(se2->e2_num)+" "+alltrim(se2->e2_parcela)+" Tipo: "+alltrim(se2->e2_tipo)+" Fornecedor/Loja: "+alltrim(se2->e2_fornece)+"-"+alltrim(se2->e2_loja)+' e execute esta rotina novamente.')

     EndIf
     
  //--- DARF Normal                  
  ElseIf SEA->EA_MODELO == "16" //--- DARF Normal
  
     //--- Periodo de Apuracao - Posicao 135 a 142  Formato DDMMAAAA
     _cReturn += Gravadata(SE2->E2_XAPUR,.F.,5)                               

     //--- Referencia - Posicao 143 a 159                     
     _cReturn += Repl("0",17)                               

     //--- Valor Principal - Posicao 160 a 174
     _cReturn += Strzero(SE2->E2_SALDO*100,15)
     
     //--- Valor da Multa - Posicao 175 a 189             
     _cReturn += Strzero((SE2->E2_ACRESC-SE2->E2_XJUROS)*100,15)     
     
     //--- Valor Juros/Encargos - Posicao 190 a 204                        
     _cReturn += Strzero(SE2->E2_XJUROS*100,15)                              
   
     //--- Data de Vencimento - Posicao 205 a 212  Formato DDMMAAAA
     _cReturn += Gravadata(SE2->E2_VENCTO,.F.,5)                               
 
  EndIf           
  

ElseIf _cOpcao == "13"   // Obtem Tipo de Inscrição do Contribuinte
                        
  If Empty(SA2->A2_XCGCDEP)
     _cReturn := IF(Length(Alltrim(SA2->A2_CGC))==14,"2","1")                                  
  Else
	 _cReturn := If(Length(Alltrim(SA2->A2_XCGCDEP))==14,"2","1")  
  EndIf
 
ElseIf _cOpcao == "14"   // Obtem CNPJ do Contribuinte
                        
  If Empty(SA2->A2_XCGCDEP)
     _cReturn := Strzero(Val(SA2->A2_CGC),14,0)                                  
  Else
	 _cReturn := Strzero(Val(SA2->A2_XCGCDEP),14,0)  
  EndIf

           
ElseIf _cOpcao == "15"   // Obtem Digito do Codigo da Agencia  

    //--- Vou calcular sempre o digito da agencia para o Banco Bradesco
	If SA2->A2_BANCO == "237"	// BRADESCO
        		
       _DIG1    := SUBSTR(SA2->A2_AGENCIA,1,1)
       _DIG2    := SUBSTR(SA2->A2_AGENCIA,2,1)
       _DIG3    := SUBSTR(SA2->A2_AGENCIA,3,1)
       _DIG4    := SUBSTR(SA2->A2_AGENCIA,4,1)

       _RETDIG := " "
       _MULT   := (VAL(_DIG1)*5) +  (VAL(_DIG2)*4) +  (VAL(_DIG3)*3) +   (VAL(_DIG4)*2)
       _RESUL  := INT(_MULT /11 )
       _RESTO  := INT(_MULT % 11)
       _DIGITO := 11 - _RESTO

       _RETDIG := IF( _RESTO == 0,"0",IF(_RESTO == 1,"0",ALLTRIM(STR(_DIGITO))))
   		    
       _cReturn := _RETDIG
                    
    Else
       
       //--- Para os demais bancos, pega o digito da agencia que está na posicao 6 do campo A2_AGENCIA
       _cReturn := Substr(SA2->A2_AGENCIA,6,1)     

    EndIf


EndIf       

Return(_cReturn)      


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³ CNAB2    ºAutor  ³Marciane Gennari    º Data ³  06/08/09   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ Incrementa 1 (Hum) no sequencial de linha detalhe          º±±
±±º                                                                       º±±
±±ºObservacao³ Deve ser utilizado em conjunto com o P.E. FIN150_1, para   º±±
±±º          ³ que nÆo seja acrescentado 2 (dois) quando mudar de t¡tulo. º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³                                                            º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

User Function Cnab2

If MV_PAR09 == 2 //--- Para Modelo 2 - controla o sequencial
   nSeq := nSeq+1
EndIf

Return(nSeq)