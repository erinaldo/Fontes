#INCLUDE "Protheus.ch"
#INCLUDE "TopConn.ch"      
#INCLUDE "report.ch" 

/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �RCTBR99   �Autor  �Edival Alves Junior � Data �  06/01/11   ���
�������������������������������������������������������������������������͹��
���Desc.     � Relat�rio de documentos de entrada com o rateio �          ���
���          � processado.                                                ���
�������������������������������������������������������������������������͹��
���Uso       � CSU                                                        ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/
User Function RCTBR99()
//�����������������������Ŀ
//�Declara��o de vari�veis�
//�������������������������
Local aRegs	:= {}
Local cPerg := PADR("CTBR99",Len(SX1->X1_GRUPO))
Private Qry := GetNextAlias()

//���������������������������������������������������������������������Ŀ
//� Cria os parametros da rotina                                        �
//�����������������������������������������������������������������������   
//aAdd(aRegs,{cPerg,"01","Emiss�o De"				,"","","mv_ch1","D",08,0,0,"G","","MV_PAR01","","","","", "","","","","","","","","","","","","","","","","","","","","","","","","" })
//aAdd(aRegs,{cPerg,"02","Emiss�o At�"			,"","","mv_ch2","D",08,0,0,"G","","MV_PAR02","","","","", "","","","","","","","","","","","","","","","","","","","","","","","","" })
//���������������Ŀ
//�VG - 2011.06.06�
//�����������������
aAdd(aRegs,{cPerg,"01","Digita��o De"			,"","","mv_ch1","D",08,0,0,"G","","MV_PAR01","","","","", "","","","","","","","","","","","","","","","","","","","","","","","","" })
aAdd(aRegs,{cPerg,"02","Digita��o At�"			,"","","mv_ch2","D",08,0,0,"G","","MV_PAR02","","","","", "","","","","","","","","","","","","","","","","","","","","","","","","" })
aAdd(aRegs,{cPerg,"03","C�digo Rateio De"		,"","","mv_ch3","C",06,0,0,"G","","MV_PAR03","","","","", "","","","","","","","","","","","","","","","","","","","","ZB7COD","","","","" })
aAdd(aRegs,{cPerg,"04","C�dito Rateio At�"		,"","","mv_ch4","C",06,0,0,"G","","MV_PAR04","","","","", "","","","","","","","","","","","","","","","","","","","","ZB7COD","","","","" }) 
aAdd(aRegs,{cPerg,"05","NF De" 					,"","","mv_ch5","C",09,0,0,"G","","MV_PAR05","","","","", "","","","","","","","","","","","","","","","","","","","","SF1","","","","" })
aAdd(aRegs,{cPerg,"06","NF At�"					,"","","mv_ch6","C",09,0,0,"G","","MV_PAR06","","","","", "","","","","","","","","","","","","","","","","","","","","SF1","","","","" })
aAdd(aRegs,{cPerg,"07","Serie De"				,"","","mv_ch7","C",03,0,0,"G","","MV_PAR07","","","","", "","","","","","","","","","","","","","","","","","","","","","","","","" })
aAdd(aRegs,{cPerg,"08","Serie At�"				,"","","mv_ch8","C",03,0,0,"G","","MV_PAR08","","","","", "","","","","","","","","","","","","","","","","","","","","","","","","" })
Aadd(aRegs,{cPerg,"09","Status da Nota"			,"","","mv_ch9","C",01,0,1,"C","","MV_PAR09","Contabilizadas","","","","","Nao Contabilizadas","","","","","Ambas","","","","","","","","","","","","","","","","","",""})

CriaSx1(aRegs)                 

If !Pergunte(cPerg,.T.)  
	Return .F.
Endif

RCTBR99A()

Return .T.                                     

/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �RCTBR99A  �Autor  �Edival Alves Junior � Data �  06/01/10   ���
�������������������������������������������������������������������������͹��
���Desc.     � Processamento do relatorio de rateio.                      ���
���          �                                                            ���
�������������������������������������������������������������������������͹��
���Uso       � CSU                                                        ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/

Static Function RCTBR99A()
//�����������������������Ŀ
//�Declara��o de vari�veis�
//�������������������������
Local oReport
Local oBreak
Local oSection                  
Local cTitulo 	:= "Relat�rio de Rateio"

oReport := TReport():New("REPORT",cTitulo,,{|oReport| PrintReport(oReport)},"Imprime Relatorio de Rateio")
oReport:HideParamPage()

//��������������������������������Ŀ
//�VG - 2011.03.11                 �
//�Garantir a impress�o em paisagem�
//����������������������������������
oReport:SetLandScape(.T.)

DEFINE SECTION oSection OF oReport TABLES "SF1","SA2","ZB7" TITLE "Resumo Documentos de Entrada"

	DEFINE CELL NAME "F1_DOC" 		OF oSection ALIAS "SF1" SIZE TAMSX3("F1_DOC")[1]		TITLE "Documento" 		BLOCK {|| impLinha("F1_DOC")		} 
	DEFINE CELL NAME "F1_SERIE" 	OF oSection ALIAS "SF1" SIZE TAMSX3("F1_SERIE")[1] 		TITLE "Serie" 			BLOCK {|| impLinha("F1_SERIE")		} 
	DEFINE CELL NAME "F1_FORNECE" 	OF oSection ALIAS "SF1" SIZE TAMSX3("F1_FORNECE")[1] 	TITLE "Fornec"			BLOCK {|| impLinha("F1_FORNECE")	} 
	DEFINE CELL NAME "F1_LOJA" 		OF oSection ALIAS "SF1" SIZE TAMSX3("F1_LOJA")[1] 		TITLE "Loja" 			BLOCK {|| impLinha("F1_LOJA")		} 
	DEFINE CELL NAME "A2_NREDUZ"	OF oSection ALIAS "SA2" SIZE 15							TITLE "Nome" 			BLOCK {|| impLinha("A2_NREDUZ")		} //VG - 2011.01.11
//	DEFINE CELL NAME "F1_DUPL" 		OF oSection ALIAS "SF1" SIZE TAMSX3("F1_DUPL")[1] 		TITLE "Duplicata"		BLOCK {|| impLinha("F1_DUPL")		} //VG - 2011.01.22 - N�o � necess�rio para a usu�ria final.

	DEFINE CELL NAME "F1_EMISSAO" 	OF oSection ALIAS "SF1" SIZE TAMSX3("F1_EMISSAO")[1] 	TITLE "Emissao"			BLOCK {|| impLinha("F1_EMISSAO")	}
	DEFINE CELL NAME "F1_DTDIGIT" 	OF oSection ALIAS "SF1" SIZE TAMSX3("F1_DTDIGIT")[1] 	TITLE "Digitac"			BLOCK {|| impLinha("F1_DTDIGIT")	} //VG - 2011.03.22 - Solicita��o da usu�ria

	DEFINE CELL NAME "ZB7_CODRAT" 	OF oSection ALIAS "ZB7" SIZE TAMSX3("ZB7_CODRAT")[1] 	TITLE "Rateio"			BLOCK {|| impLinha("ZB7_CODRAT")	} 
//	DEFINE CELL NAME "ZB7_DESCRI" 	OF oSection ALIAS "ZB7" SIZE 15 						TITLE "Descricao"		BLOCK {|| impLinha("ZB7_DESCRI")	} //VG - 2011.01.22 - N�o � necess�ria para a usu�ria final.

	//����������������������������������������������Ŀ
	//�VG - 2011.03.11                               �
	//�Impress�o do respons�vel pela tabela de rateio�
	//������������������������������������������������
//	DEFINE CELL NAME "ZB7_USRNAM" 	OF oSection ALIAS "ZB7" SIZE TAMSX3("ZB7_USRNAM")[1] 	TITLE OemToAnsi("Respons�vel")		BLOCK {|| impLinha("ZB7_USRNAM")	}  
	//VG - 2011.03.22 - Imprimir o nome do usu�rio, limitando a quantidade de caracteres a 15
	DEFINE CELL NAME "ZB7_USRFNA" 	OF oSection ALIAS "ZB7" SIZE TAMSX3("ZB7_USRFNA")[1]	TITLE OemToAnsi("Respons�vel")		BLOCK {|| impLinha("ZB7_USRFNA")	}  
	
	DEFINE CELL NAME "ED_CODIGO" 	OF oSection ALIAS "SED" SIZE TAMSX3("ED_CODIGO")[1] 	TITLE "Natureza"					BLOCK {|| impLinha("ED_CODIGO")		} 
	DEFINE CELL NAME "ED_DESCRIC" 	OF oSection ALIAS "SED" SIZE TAMSX3("ED_DESCRIC")[1]	TITLE "Desc. Natureza"				BLOCK {|| impLinha("ED_DESCRIC")	} 

//VG - 2011.03.22 - Conta cont�bil relativa ao centro de custo transit�rio
	DEFINE CELL NAME "CT1_CONTA" 	OF oSection ALIAS "CT1" SIZE TAMSX3("CT1_CONTA")[1]		TITLE "Conta Contabil"				BLOCK {|| impLinha("CT1_CONTA")	} 
	DEFINE CELL NAME "CT1_DESC01" 	OF oSection ALIAS "CT1" SIZE TAMSX3("CT1_DESC01")[1]	TITLE "Desc. C.Contab"				BLOCK {|| impLinha("CT1_DESC01")	} 

//	DEFINE CELL NAME "F1_XPRORAT" 	OF oSection ALIAS "SF1" SIZE TAMSX3("F1_XPRORAT")[1] 	TITLE "Proc."						BLOCK {|| impLinha("F1_XPRORAT")	} 	
	DEFINE CELL NAME "F1_XPRORAT" 	OF oSection ALIAS "SF1" SIZE 04 						TITLE "Proc."						BLOCK {|| impLinha("F1_XPRORAT")	} 

	DEFINE BREAK oBreak OF oSection WHEN oSection:Cell("F1_DOC")
		
oReport:PrintDialog()

Return

/*
������������������������������������������������������������������������������
������������������������������������������������������������������������������
��������������������������������������������������������������������������ͻ��
���Programa  �PrintReport�Autor  �Edival Alves Junior � Data �  06/01/10   ���
��������������������������������������������������������������������������͹��
���Desc.     � Processamento da query relatorio de rateio.                 ���
���          �                                                             ���
��������������������������������������������������������������������������͹��
���Uso       � CSU                                                         ���
��������������������������������������������������������������������������ͼ��
������������������������������������������������������������������������������
������������������������������������������������������������������������������
*/
Static Function PrintReport(oReport) 
//�����������������������Ŀ
//�Declara��o de vari�veis�
//�������������������������
Local cDataDe 	:=	DtoS(MV_PAR01)
Local cDataAte	:= 	DtoS(MV_PAR02)
Local cRatDe	:= 	MV_PAR03
Local cRatAte	:= 	MV_PAR04
Local cNfDe 	:= 	MV_PAR05
Local cNfAte	:= 	MV_PAR06 
Local cSerieDe	:= 	MV_PAR07
Local cSerieAte	:= 	MV_PAR08  
Local cInvCodRat:=	Replicate(" ",TAMSX3("ZB7_CODRAT")[1])
Local cXproRat	:= "" 
Local cBranco	:= ""     

//��������������������������������Ŀ
//�VG - 2011.03.11                 �
//�Garantir a impress�o em paisagem�
//����������������������������������
oReport:SetLandScape(.T.)

If Empty(MV_PAR09) .Or. MV_PAR09 == 3
	cXproRat := " ' = ' "
Else
	If MV_PAR09 == 1
		cXproRat := " ' = ' ' AND F1_XPRORAT = '"+AllTrim(Str(MV_PAR09))+" "
	Else
		cXproRat := " ' = ' ' AND (F1_XPRORAT = '"+AllTrim(Str(MV_PAR09))+"' OR F1_XPRORAT = ' ' ) AND ' ' = ' "
	Endif
EndIf

#IFDEF TOP
	oSection := oReport:Section(1)

	MakeSqlExp("REPORT")

	//VG - 2011.04.29
	//clausula de filial removida
	//		WHERE F1_FILIAL = %xfilial:SF1%	
	
	oSection:BeginQuery()		
	
	BeginSql alias Qry

		SELECT F1_FILIAL,F1_DOC,F1_SERIE,F1_FORNECE,F1_LOJA,F1_DUPL,F1_EMISSAO, EV_XCODRAT ZB7_CODRAT, ED_CODIGO, ED_DESCRIC, F1_XPRORAT, F1_DTDIGIT
		FROM %table:SF1% SF1(NOLOCK),%table:SEV% SEV(NOLOCK), %table:SED% SED(NOLOCK)
		WHERE F1_FILIAL >= ' '
			AND F1_DOC BETWEEN %Exp:cNfDe% AND %Exp:cNfAte%
			AND F1_SERIE BETWEEN %Exp:cSerieDe% AND %Exp:cSerieAte%
			AND (%Exp:AllTrim(cXproRat)%)
			AND F1_DTDIGIT BETWEEN %Exp:cDataDe% AND %Exp:cDataAte%
			AND SF1.%notDel%             
	    	AND EV_FILIAL = %xfilial:SEV%
		    AND EV_NUM = F1_DOC 
    		AND EV_PREFIXO = F1_PREFIXO      
	    	AND EV_CLIFOR = F1_FORNECE
    		AND EV_LOJA = F1_LOJA
    		AND EV_XCODRAT BETWEEN %Exp:cRatDe% AND %Exp:cRatAte%  
    		AND EV_XCODRAT <> %Exp:cInvCodRat%
		    AND SEV.%notDel%
		    AND ED_FILIAL = %xfilial:SED%
		    AND ED_CODIGO = EV_NATUREZ
   		    AND SED.%notDel%
 		 ORDER BY F1_DTDIGIT, F1_FORNECE, F1_LOJA, F1_DOC, F1_SERIE
	    		
	EndSql            	
	
	oSection:EndQuery({})
#ENDIF                

MemoWrite("RCTBR99.QRY",GETLastQuery()[2])
        
oSection:Print()                                  

Return                  

/*���������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �impLinha  �Autor  �Fabio Simonetti     � Data �  04/30/08   ���
�������������������������������������������������������������������������͹��
���Desc.     �Query                                                       ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
����������������������������������������������������������������������������*/
Static Function impLinha(_cCampo)
//�����������������������Ŀ
//�Declara��o de vari�veis�
//�������������������������
Local _cRet 	:= " "
Local cAnoMes	:= ""
Local cUltRev	:= ""
Local cConta	:= ""

If _cCampo == "F1_DOC"
	_cRet := (Qry)->F1_DOC
	
ElseIf _cCampo == "F1_SERIE"
	_cRet := (Qry)->F1_SERIE
	
ElseIf _cCampo == "F1_FORNECE"
	_cRet := (Qry)->F1_FORNECE
	
ElseIf _cCampo == "F1_LOJA"
	_cRet := (Qry)->F1_LOJA
	
ElseIf _cCampo == "A2_NREDUZ"
	_cRet := Alltrim(Posicione("SA2",1,xFilial("SA2")+(Qry)->F1_FORNECE+(Qry)->F1_LOJA,"A2_NREDUZ"))
	
ElseIf _cCampo == "F1_DUPL"               		
	_cRet	:= (Qry)->F1_DUPL
	
ElseIf _cCampo == "F1_EMISSAO"	
	_cRet	:= (Qry)->F1_EMISSAO
	
ElseIf _cCampo == "F1_DTDIGIT"//VG - 2011.03.22
	_cRet	:= (Qry)->F1_DTDIGIT
	
ElseIf _cCampo == "ZB7_CODRAT"	
	If Empty((Qry)->ZB7_CODRAT)
//		_cRet	:= 	"<--N�o"
		_cRet	:= 	Replicate("-",TAMSX3("ZB7_CODRAT")[1])
	Else
		_cRet	:= (Qry)->ZB7_CODRAT
	EndIf
	
ElseIf _cCampo == "ZB7_DESCRI"
	If Empty((Qry)->ZB7_CODRAT)
//   		_cRet	:=  "preenchido-->"
   		_cRet	:=  Replicate("-",TAMSX3("ZB7_DESCRI")[1])
	Else
		_cRet	:= Alltrim(Posicione("ZB7",1,xFilial("ZB7")+(Qry)->ZB7_CODRAT,"ZB7_DESCRI"))
	EndIf	                                   
	
ElseIf _cCampo == "ZB7_USRFNA"//VG - 2011.03.11
	If !Empty((Qry)->ZB7_CODRAT)           	
		//cAnoMes	:= SUBSTR(DTOS((Qry)->F1_EMISSAO),1,6)
		//��������������������������������������Ŀ
		//�VG - 2011.06.06 - Altera��o para pegar�
		//�o ano/m�s da tabela de rateio com base�
		//�na compet�ncia da nota.               �
		//����������������������������������������
		cAnoMes	:= U_GetCompetencia((Qry)->F1_FILIAL+(Qry)->F1_DOC+(Qry)->F1_SERIE+(Qry)->F1_FORNECE+(Qry)->F1_LOJA)
		cUltRev	:= U_RZB7ULTR((Qry)->ZB7_CODRAT,cAnoMes,.T.)	
		//������������������������������������������������������������������Ŀ
		//�VG - 2011.03.22 - pegar a �ltima revis�o dispon�vel para o per�odo�
		//��������������������������������������������������������������������	
		_cRet	:= Alltrim(Posicione("ZB7",1,xFilial("ZB7")+(Qry)->ZB7_CODRAT+cAnoMes+cUltRev+'A',"ZB7_USRFNA"))			
	Else
		_cRet	:= Replicate("-",TAMSX3("ZB7_USRFNA")[1])
	EndIf
	
ElseIf _cCampo == "ED_CODIGO"
	_cRet	:=  (Qry)->ED_CODIGO
	
ElseIf _cCampo == "ED_DESCRIC"
	_cRet	:=  (Qry)->ED_DESCRIC
	
ElseIf _cCampo == "CT1_CONTA"              
	If !Empty((Qry)->ZB7_CODRAT)           	
		//cAnoMes	:= SUBSTR(DTOS((Qry)->F1_EMISSAO),1,6)
		//��������������������������������������Ŀ
		//�VG - 2011.06.06 - Altera��o para pegar�
		//�o ano/m�s da tabela de rateio com base�
		//�na compet�ncia da nota.               �
		//����������������������������������������
		cAnoMes	:= U_GetCompetencia((Qry)->F1_FILIAL+(Qry)->F1_DOC+(Qry)->F1_SERIE+(Qry)->F1_FORNECE+(Qry)->F1_LOJA)		
		cUltRev	:= U_RZB7ULTR((Qry)->ZB7_CODRAT,cAnoMes,.T.)	
		//�������������������������������������������������������������������������������Ŀ
		//�VG - 2011.03.22 - pegar a conta cont�bil com base na natureza e centro de custo�
		//���������������������������������������������������������������������������������	
		_cRet	:= u_RetCtaNfe( (Qry)->ED_CODIGO , Posicione("ZB7",1,xFilial("ZB7")+(Qry)->ZB7_CODRAT+cAnoMes+cUltRev+'A',"ZB7_CCTRAN"))
	Else
		_cRet	:= Replicate("-",TAMSX3("CT1_CONTA")[1])
	EndIf
	
ElseIf _cCampo == "CT1_DESC01"
	If !Empty((Qry)->ZB7_CODRAT)           	
		//cAnoMes	:= SUBSTR(DTOS((Qry)->F1_EMISSAO),1,6)
		//��������������������������������������Ŀ
		//�VG - 2011.06.06 - Altera��o para pegar�
		//�o ano/m�s da tabela de rateio com base�
		//�na compet�ncia da nota.               �
		//����������������������������������������
		cAnoMes	:= U_GetCompetencia((Qry)->F1_FILIAL+(Qry)->F1_DOC+(Qry)->F1_SERIE+(Qry)->F1_FORNECE+(Qry)->F1_LOJA)
		cUltRev	:= U_RZB7ULTR((Qry)->ZB7_CODRAT,cAnoMes,.T.)	
		//�������������������������������������������������������������������������������Ŀ
		//�VG - 2011.03.22 - pegar a conta cont�bil com base na natureza e centro de custo�
		//���������������������������������������������������������������������������������	
		cConta	:= u_RetCtaNfe( (Qry)->ED_CODIGO, Posicione("ZB7",1,xFilial("ZB7")+(Qry)->ZB7_CODRAT+cAnoMes+cUltRev+'A',"ZB7_CCTRAN") )
		_cRet	:= Posicione("CT1",1,xFilial("CT1")+cConta,"CT1_DESC01")
	Else
		_cRet	:= Replicate("-",TAMSX3("CT1_DESC01")[1])
	EndIf
		
ElseIf _cCampo == "F1_XPRORAT"
	_cRet	:=  If((Qry)->F1_XPRORAT=='2' .or. Empty(Alltrim((Qry)->F1_XPRORAT)),"N�o","Sim")
	
Endif                               

Return _cRet

/*
���������������������������������������������������������������������������������������������
���������������������������������������������������������������������������������������������
�����������������������������������������������������������������������������������������ͻ��
��� Programa    � CriaSx1  � Verifica e cria um novo grupo de perguntas com base nos      ���
���             �          � par�metros fornecidos                                        ���
�����������������������������������������������������������������������������������������͹��
��� Solicitante � 23.05.05 � Modelagem de Dados                                           ���
�����������������������������������������������������������������������������������������͹��
��� Autor       � 28.04.04 � TI0607 - Almir Bandina                                       ���
�����������������������������������������������������������������������������������������͹��
��� Produ��o    � 99.99.99 � Ignorado                                                     ���
�����������������������������������������������������������������������������������������͹��
��� Par�metros  � ExpA1 = array com o conte�do do grupo de perguntas (SX1)                ���
�����������������������������������������������������������������������������������������͹��
��� Retorno     � Nil                                                                     ���
�����������������������������������������������������������������������������������������͹��
��� Observa��es �                                                                         ���
���             �                                                                         ���
�����������������������������������������������������������������������������������������͹��
��� Altera��es  � 99/99/99 - Consultor - Descricao da altera��o                           ���
���             �                                                                         ���
�����������������������������������������������������������������������������������������ͼ��
���������������������������������������������������������������������������������������������
���������������������������������������������������������������������������������������������
*/
Static Function CriaSx1(aRegs)
//�����������������������Ŀ
//�Declara��o de vari�veis�
//�������������������������
Local aAreaAtu	:= GetArea()
Local aAreaSX1	:= SX1->(GetArea())
Local nJ		:= 0
Local nY		:= 0

dbSelectArea("SX1")
dbSetOrder(1)

For nY := 1 To Len(aRegs)
	If !MsSeek(Padr(aRegs[nY,1],Len(SX1->X1_GRUPO))+aRegs[nY,2])
		RecLock("SX1",.T.)
		For nJ := 1 To FCount()
			If nJ <= Len(aRegs[nY])
				FieldPut(nJ,aRegs[nY,nJ])
			EndIf
		Next nJ
		MsUnlock()
	EndIf
Next nY

RestArea(aAreaSX1)
RestArea(aAreaAtu)

Return(Nil)                       