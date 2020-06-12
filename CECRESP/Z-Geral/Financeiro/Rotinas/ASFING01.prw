#include "rwmake.ch"


//-----------------------------------------------------------------------
/*/{Protheus.doc} ASFING01()

Programa para valida��o do campo E2_CODBAR para 
utiliza��o do pagfor.

Fun��o chamada por gatilho do campo E2_CODBAR

Fun��o para Valida��o de C�digo de Barras (CB) e Representa��o|

Num�rica do C�digo de Barras - Linha Digit�vel (LD).

A LD de Bloquetos possui tr�s Digitos Verificadores (DV) que
s�o consistidos pelo M�dulo 10, al�m do D�gito Verificador
Geral (DVG) que � consistido pelo M�dulo 11. Essa LD t�m 47
D�gitos.

A LD de T�tulos de Concessin�rias do Servi�o P�blico e IPTU   
possui quatro Digitos Verificadores (DV) que s�o consistidos  
pelo M�dulo 10, al�m do Digito Verificador Geral (DVG) que    
tamb�m � consistido pelo M�dulo 10. Essa LD t�m 48 D�gitos.   

O CB de Bloquetos e de T�tulos de Concession�rias do Servi�o  
P�blico e IPTU possui apenas o D�gito Verificador Geral (DVG) 
sendo que a �nica diferen�a � que o CB de Bloquetos �         
consistido pelo M�dulo 11 enquanto que o CB de T�tulos de     
Concession�rias � consistido pelo M�dulo 10. Todos os CB�s    
t�m 44 D�gitos.                                               

Para utiliza��o dessa Fun��o, deve-se criar o campo E2_CODBAR,
Tipo Caracter, Tamanho 48 e colocar na Valida��o do Usu�rio:  
EXECBLOCK("ASFING01",.T.).                                      

@param		Nenhum
@return		lRet
@author 	Fabiano Albuquerque
@since 		23/06/2016
@version 	1.0
@project	MAN0000001 - Aguassanta - Integra
/*/
//------------------------------------------------------------------------

USER FUNCTION ASFING01()

Local i:= 0

SETPRVT("cStr,lRet,cTipo,nConta,nMult,nVal,nDV,cCampo,i,nMod,nDVCalc")

// Retorna .T. se o Campo estiver em Branco.
//IF VALTYPE(M->E2_CODBAR) == NIL .OR. EMPTY(M->E2_CODBAR)
IF VALTYPE(M->E2_LINDIG) == NIL .OR. EMPTY(M->E2_LINDIG)
	RETURN(.T.)
ENDIF

//cStr := LTRIM(RTRIM(M->E2_CODBAR))
cStr := LTRIM(RTRIM(M->E2_LINDIG))

// Se o Tamanho do String for 45 ou 46 est� errado! Retornar� .F.
lRet := IF(LEN(cStr)==45 .OR. LEN(cStr)==46,.F.,.T.)

// Se o Tamanho do String for menor que 44, completa com zeros at� 47 d�gitos. Isso �
// necess�rio para Bloquetos que N�O t�m o vencimento e/ou o valor informados na LD.
cStr := IF(LEN(cStr)<44,cStr+REPL("0",47-LEN(cStr)),cStr)

// Verifica se a LD � de (B)loquetos ou (C)oncession�rias/IPTU. Se for CB retorna (I)ndefinido.
cTipo := IF(LEN(cStr)==47,"B",IF(LEN(cStr)==48,"C","I"))

// Verifica se todos os d�gitos s�o num�rios.
FOR i := LEN(cStr) TO 1 STEP -1
	lRet := IF(SUBSTR(cStr,i,1) $ "0123456789",lRet,.F.)
NEXT

IF LEN(cStr) == 47 .AND. lRet
	// Consiste os tr�s DV�s de Bloquetos pelo M�dulo 10.
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
		// Se o DV Calculado for 10 � assumido 0 (Zero).
		nDVCalc := IF(nDVCalc==10,0,nDVCalc)
		lRet    := IF(lRet,(nDVCalc==nDV),.F.)
		nConta  := nConta + 1
	ENDDO
	// Se os DV�s foram consistidos com sucesso (lRet=.T.), converte o n�mero para CB para consistir o DVG.
	cStr := IF(lRet,SUBSTR(cStr,1,4)+SUBSTR(cStr,33,15)+SUBSTR(cStr,5,5)+SUBSTR(cStr,11,10)+SUBSTR(cStr,22,10),cStr)
ENDIF

IF LEN(cStr) == 48 .AND. lRet
	// Consiste os quatro DV�s de T�tulos de Concession�rias de Servi�o P�blico e IPTU pelo M�dulo 10.
	nConta  := 1
	WHILE nConta <= 4
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
		// Se o DV Calculado for 10 � assumido 0 (Zero).
		nDVCalc := IF(nDVCalc==10,0,nDVCalc)
		lRet    := IF(lRet,(nDVCalc==nDV),.F.)
		nConta  := nConta + 1
	ENDDO
	// Se os DV�s foram consistidos com sucesso (lRet=.T.), converte o n�mero para CB para consistir o DVG.
	cStr := IF(lRet,SUBSTR(cStr,1,11)+SUBSTR(cStr,13,11)+SUBSTR(cStr,25,11)+SUBSTR(cStr,37,11),cStr)
ENDIF

IF LEN(cStr) == 44 .AND. lRet
	IF cTipo $ "BI"
		// Consiste o DVG do CB de Bloquetos pelo M�dulo 11.
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
		// Se o DV Calculado for 0,10 ou 11 � assumido 1 (Um).
		nDVCalc := IF(nDVCalc==0 .OR. nDVCalc==10 .OR. nDVCalc==11,1,nDVCalc)
		lRet    := IF(lRet,(nDVCalc==nDV),.F.)
		// Se o Tipo � (I)ndefinido E o DVG N�O foi consistido com sucesso (lRet=.F.), tentar�
		// consistir como CB de T�tulo de Concession�rias/IPTU no IF abaixo.
	ENDIF
	IF cTipo == "C" .OR. (cTipo == "I" .AND. !lRet)
		// Consiste o DVG do CB de T�tulos de Concession�rias pelo M�dulo 10.
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
		// Se o DV Calculado for 10 � assumido 0 (Zero).
		nDVCalc := IF(nDVCalc==10,0,nDVCalc)
		lRet    := IF(lRet,(nDVCalc==nDV),.F.)
	ENDIF
ENDIF

IF !lRet
	HELP(" ",1,"ONLYNUM")
ENDIF

RETURN(cStr)
