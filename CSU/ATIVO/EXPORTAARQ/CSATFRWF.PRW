#INCLUDE "protheus.ch"
#INCLUDE "rwmake.ch"
#INCLUDE "tbiconn.ch"
#INCLUDE "topconn.ch"
#DEFINE      cSep     ";"
#DEFINE      cEol     Chr(13) + Chr(10)

User Function WFATFRWF()
Return u_CSATFRWF()

/*ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณCSATFR01  บAutor  ณAlexandre Avelino   บ Data ณ  09/03/17   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ  Gera via schedule o relatorio "Relacao de Ativos" que     บฑฑ
ฑฑบ          ณ  encontra-se no caminho SIGAATF->Relatorios->Especificos   บฑฑ
ฑฑบ          ณ  CSU->Relacao de Ativos. O arquivo e gerado no diretorio   บฑฑ
ฑฑบ          ณ  Protheus_Data\razarios. Desenvolvimento da OS 0221/17.    บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿*/

User Function CSATFRWF
                      

PREPARE ENVIRONMENT EMPRESA "05" FILIAL "01" MODULO "ATF"

Private aArea := GetArea()
Private oGeraTxt
Private oHTML
Private cDirDocs := MsDocPath()            // Diretorio de docs do servidor
Private cTmpTxt  := CriaTrab(Nil,.f.)
Private cCmd     := cDirDocs+"\"+cTmpTxt+".txt"

fGerarq(cCmd)

RESET ENVIRONMENT

RestArea(aArea)

Return


/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบFuno    ณ OKGERATXTบ Autor ณ AP5 IDE            บ Data ณ  08/05/07   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDescrio ณ Funcao chamada pelo botao OK na tela inicial de processamenบฑฑ
ฑฑบ          ณ to. Executa a geracao do arquivo texto.                    บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ Programa principal                                         บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
/*/
Static Function fGerarq(cCmd)

Processa( { || OkProc() }, "Executando o Processamento..." )

Return

/*ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณOKPROC    บAutor  ณAlexandre Avelino   บ Data ณ  09/03/17   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ  Processa o relatorio excel.                               บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ CSATFR01                                                   บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿*/
Static Function OkProc()

Local cSelekt, cQryCpos, nCntView
Local cArquivo  := "\razarios\"
Private cData   := dTos(dDataBase)
Private cData1
Private cData2
Private ultimo_dia
Private valor
Private txdepre
Private acumul

//O If abaixo faz a trativa para o relatorio trazer as informacoes do mes corrente menos 1
//incluido pela OS 2160/17
cData2 := Dtos(Stod(Subs(Dtos(dDataBase),1,6)+"01")-1)
cData1 := Subs(cData2,1,6)+"01"

//If Month(dDataBase) == 01 
	//cData1  := dTos(Year(dDataBase)-1)+"1201" 
	//cData2  := dTos(Year(dDataBase)-1)+"1231" 
//Else
	//cData1  := cValToChar(Year(dDataBase))+"0"+cValToChar((Month(dDataBase)-1))+"01" 
	//ultimo_dia := CTOD(Subs(cData1, 7, 2)+"/"+Subs(cData1, 5, 2)+"/"+Subs(cData1, 1, 4)) 
	//cData2  := cValToChar(Year(dDataBase))+"0"+cValToChar((Month(dDataBase)-1))+Strzero(f_ultdia(ultimo_dia), 2)
//EndIf

cArquivo := cArquivo+"relacao_ativos"+cData+".csv"

nHdl  := fCreate( cArquivo )

If nHdl == -1
	MsgAlert("O arquivo de nome "+cArquivo+" nao pode ser executado! Verifique os parametros.","Atencao!")
	Return
EndIf

//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
//ณMonta o cabecalho        ณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
cLin := "FILIAL" + cSep
cLin += "CODIGO" + cSep
cLin += "AQUISICAO" + cSep
cLin += "CHAPA" + cSep
cLin += "CCUSTO" + cSep
cLin += "OPERACAO" + cSep
cLin += "CONTA" + cSep
cLin += "DESCRICAO" + cSep
cLin += "VALOR" + cSep
cLin += "TXDEPRE" + cSep
cLin += "ACUMUL" + cSep
cLin += "FIMDEPR" + cSep
cLin += "LOJA" + cSep
cLin += "NFISCAL" + cSep
cLin += "RAZAO" + cSep
cLin += "PROJETO" + cEol

fGravaTxt(cLin)
//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
//ณQuery com os dados dos funcionarios, conforme os parametros.ณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
cSelekt := "SELECT         "
cSelekt += "N1_FILIAL AS FILIAL,  "
cSelekt += "N1_CBASE AS CODIGO,   "
cSelekt += "N1_AQUISIC AS AQUISICAO, "
cSelekt += "N1_CHAPA AS CHAPA,   "
cSelekt += "N3_CUSTBEM AS CCUSTO, "
cSelekt += "N3_CLVL AS OPERACAO,    "
cSelekt += "N3_CCONTAB AS CONTA, "
cSelekt += "N1_DESCRIC AS DESCRICAO, "
cSelekt += "N3_VORIG1 AS VALOR,  "
cSelekt += "N3_TXDEPR1 AS TXDEPRE, "
cSelekt += "N3_VRDACM1 AS ACUMUL, "
cSelekt += "N3_FIMDEPR AS FIMDEPR, "
cSelekt += "A2_COD AS CODIGO,     "
cSelekt += "A2_LOJA AS LOJA,    "
cSelekt += "N1_NFISCAL AS NFISCAL, "
cSelekt += "A2_NOME AS RAZAO,     "
cSelekt += "N3_X_PRJ AS PROJETO "
cSelekt += "FROM "+RetSqlName("SN1")+" AS N1 "
cSelekt += "INNER JOIN "+RetSqlName("SN3")+" AS N3 ON N1.N1_FILIAL = N3.N3_FILIAL "
cSelekt += " AND N1.N1_CBASE = N3.N3_CBASE "
cSelekt += " AND N1.N1_ITEM = N3.N3_ITEM   "
cSelekt += " INNER JOIN "+RetSqlName("SA2")+" AS A2 ON N1.N1_FORNEC = A2.A2_COD "
cSelekt += " AND N1.N1_FORNEC = A2.A2_COD  "
cSelekt += " AND N1.N1_LOJA = A2.A2_LOJA	"
cSelekt += " WHERE N1.N1_FILIAL BETWEEN '00' AND 'ZZ' "
cSelekt += " AND N1.N1_AQUISIC BETWEEN '"+cData1+"' AND '"+cData2+"' "
//cSelekt += " AND N1.N1_AQUISIC BETWEEN '20161101' AND '20161130' "
cSelekt += " AND N3.N3_CCONTAB BETWEEN '00000000000000000000' AND 'zzzzzzzzzzzzzzzzzzzz' "
cSelekt += " AND N1.N1_FORNEC BETWEEN '000000' AND 'ZZZZZZ' "
cSelekt += " AND N3.N3_BAIXA <> '1' "
cSelekt += " AND N3.N3_CCUSTO BETWEEN '00000000000000000000' AND 'ZZZZZZZZZZZZZZZZZZZZ' "
cSelekt += " AND N1.D_E_L_E_T_ = '' "
cSelekt += " AND N3.D_E_L_E_T_ = '' "
cSelekt += " AND A2.D_E_L_E_T_ = '' "
cSelekt += " ORDER BY N1.N1_CHAPA "

//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
//ณGera o arquivo temporario da query acima.ณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
nCntView := U_MontaView( cSelekt, "QryMestre" ) 

If QryMestre->(Eof()) .and. QryMestre->(bof())
	
	Memowrite("\razarios\relacao_ativos"+cData+".csv","NAO EXISTEM DADOS A SEREM GERADOS NESSE PERIODO.")
	
	RETURN

Endif   

ProcRegua( nCntView )

QryMestre->( DbGoTop() )

//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
//ณAlimenta o arquivo que sera gerado para o usuario. ณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
While !QryMestre->( Eof() )
		
	// Grava o Arquivo Texto para o Excel
	cLin := "'"+QryMestre->FILIAL + cSep
	cLin += "'"+QryMestre->CODIGO + cSep
	cLin += QryMestre->AQUISICAO + cSep
	cLin += "'"+QryMestre->CHAPA + cSep
	cLin += "'"+QryMestre->CCUSTO + cSep
	cLin += "'"+QryMestre->OPERACAO + cSep
	cLin += "'"+QryMestre->CONTA + cSep
	cLin += QryMestre->DESCRICAO + cSep
	cLin += TRANSFORM(QryMestre->VALOR, "@E 999999999.99") + cSep
	cLin += TRANSFORM(QryMestre->TXDEPRE, "@E 999999999.9999") + cSep
	cLin += TRANSFORM(QryMestre->ACUMUL, "@E 999999999.99") + cSep
	cLin += "'"+QryMestre->FIMDEPR + cSep
	cLin += "'"+QryMestre->LOJA + cSep
	cLin += "'"+QryMestre->NFISCAL + cSep
	cLin += QryMestre->RAZAO + cSep
	cLin += "'"+QryMestre->PROJETO + cEol
	
	fGravaTxt(cLin) 
	
	DBSKIP()
	
EndDo

fClose( nHdl )

__CopyFile( GetSrvProfString("StartPath","")+cArquivo, "relacao_ativos"+cData+".csv" )


Return


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณRGPEM02   บAutor  ณMicrosiga           บ Data ณ  01/25/06   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ                                                            บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ MP8                                                        บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿ */
Static Function fGravaTxt( cLinha )

If fWrite(nHdl,cLinha,Len(cLinha)) != Len(cLinha)
	If !MsgAlert("Ocorreu um erro na gravacao do arquivo. Continua?","Atencao!")
		Return
	Endif
Endif

Return
