#INCLUDE "Protheus.ch"
#include "rwmake.ch"
#include "topconn.ch"

/*
===========================================================================
Funcao    : CSU001    | Autor: Claudinei E.N.     | Data: 17/08/07 Termino: 23/08/07
==========|================================================================
Descricao : Funcao principal que chamara a funcao que gerara o arquivo texto
             com dados dos funcionarios conveniados a Odontoprev.
==========|================================================================
Modulo    : SIGAGPE - Gestao de Pessoal
==========|================================================================      
OBS       :                                                               
==========|================================================================
Alterações solicitadas                                                    
===========================================================================
Descrição :                                    |Sol.por|Atend.por|Data    
===========================================================================*/
user function CSU001()
	//declaracao de variaveis
	local	oDlg := nil

	private cPrograma := "U_CSU001" //nome do programa principal que esta gerando os dados em arquivo texto
	private nLastKey := 0 //tecla selecionada pelo usuario, normalmente ESC para abortar a execucao de alguma rotina
	private cPerg := PADR("CSU001" ,LEN(SX1->X1_GRUPO)) //nome do grupo de perguntas inserido no arquivo SX1EE0
	private cAliasSRD := "SRD" //tabela principal para coleta de dados

	//exibe tela de principal para configuracao de parametros e chamada do programa que gerara o arquivo texto
	@ 000,000 To 217,375 Dialog oDlg Title OemToAnsi("Arquivo texto conveniados Odontoprev ") //Exibe titulo na barra horizontal superior da caixa de mensagem
	@ 004,010 To 084,182
	@ 018,020 Say OemToAnsi("Este programa gerara um arquivo texto com dados dos ") //Exibe detalhe no corpo da caixa de mensagem
	@ 028,020 Say OemToAnsi("funcionarios e seus dependentes, para ser importado ") //Exibe detalhe no corpo da caixa de mensagem
	@ 038,020 Say OemToAnsi("para o programa microsoft excel.                    ") //Exibe detalhe no corpo da caixa de mensagem
	@ 048,020 Say OemToAnsi("Nome do programa: " + cPrograma                        ) //Exibe nome do programa no corpo da caixa de mensagem
	@ 090,047 BMPButton Type 5 Action Eval( { || ValidPerg(), Pergunte(cPerg,.T.) } ) //Exibe botao que chamara a função para verificar as perguntas incluindo-as caso nao existam e exibí-las ao usuario, que selecionará o que deseja extrair
	@ 090,078 Button OemToAnsi("Gerar arquivo" ) Size 45,13 Action Eval( { || Pergunte(cPerg,.F.) , OkRunProc() }  ) //Exibe o botão que executará a rotina desejada
	@ 090,124 BmpButton TYPE 2 Action Close(oDlg)  //Exibe botao que fecha a tela que executara a rotina desejada.
	Activate Dialog oDlg Centered

return(nil)  //finaliza a funcao


/*
===========================================================================
Funcao    : OkRunProc        | Autor: Claudinei E.N.     | Data |17/08/07
==========|================================================================
Descricao : 
            
==========|================================================================
Modulo    : SIGAGPE - Gestão de Pessoal                                   
==========|================================================================
OBS       :                                                               
==========|================================================================
Alterações solicitadas                                                    
===========================================================================
Descrição :                                    |Sol.por|Atend.por|Data    
===========================================================================*/
static function OkRunProc()
	//Cria dialogo com uma regua de progressao com mensagem abaixo
	Processa({|| GeraArqTxt()}, "Selecionando registros.", "Por favor aguarde...", .T.)
return(nil)


/*
===========================================================================
Funcao    : GeraArqTxt        | Autor: Claudinei E.N.     | Data |17/08/07
==========|================================================================
Descricao : 
            
==========|================================================================
Modulo    : SIGAGPE - Gestão de Pessoal                                   
==========|================================================================
OBS       :                                                               
==========|================================================================
Alterações solicitadas                                                    
===========================================================================
Descrição :                                    |Sol.por|Atend.por|Data    
===========================================================================*/
static function GeraArqTxt()
	local cQry    := ""
	local cTRBSRD := ""
	local aAreaSRB := {}
	//Carrega as mv_par's para variaveis locais
	local cMvFolmes := GetMV("MV_FOLMES")
	local nOrdGerArq := mv_par01 //	aAdd(aRegs,{cPerg,"01","Gerar em ordem de?","¨Gerar em ordem de?","Gerar em ordem de?","mv_ch1","N",01,0,0,"C","","mv_par01","Matricula","","","","","Centro de custo","","","","","Nome","","","","","","","","","","","","","","","","","",""})
	local nLancto := mv_par02    //	aAdd(aRegs,{cPerg,"02","Lancamento      ","","","mv_ch2","n",01,0,0,"C","            ","mv_par02","Mensal   ","","","","","Acumulado","","","","","","","","","","","","","","","","","","","   ","","",".RHTPREL. "})
	local dDataDe :=  ALLTRIM(STR(YEAR(mv_par03))) + ALLTRIM(SUBSTR(DTOC(mv_par03),4,2)) + SUBSTR(DTOC(mv_par03),1,2)    //	aAdd(aRegs,{cPerg,"03","Per. MMAAAA de?","","","mv_ch3","D",06,00,0,"G","NaoVazio","mv_par03","","","","","","","","","","","","","","","","","","","","","","","","","","","","",""})
	local dDataAte := ALLTRIM(STR(YEAR(mv_par04))) + ALLTRIM(SUBSTR(DTOC(mv_par04),4,2)) + SUBSTR(DTOC(mv_par04),1,2)   //	aAdd(aRegs,{cPerg,"04","Per. MMAAAA ate?","","","mv_ch4","D",06,00,0,"G","NaoVazio","mv_par04","","","","","","","","","","","","","","","","","","","","","","","","","","","","",""})
	local cFilialDe := mv_par05  //	aAdd(aRegs,{cPerg,"05","Filial de?","","","mv_ch5","C",02,00,0,"G","NaoVazio","mv_par05","","","","","","","","","","","","","","","","","","","","","","","","","SM0","","","",""})
	local cFilialAte := mv_par06 //	aAdd(aRegs,{cPerg,"06","Filial ate?","","","mv_ch6","C",02,00,0,"G","NaoVazio","mv_par06","","","","","","","","","","","","","","","","","","","","","","","","","SM0","","","",""})
	local cCCustoDe := mv_par07  //	aAdd(aRegs,{cPerg,"07","C. custo de?","¨C. custo de?","C. custo de?","mv_ch7","C",09,0,0,"G","","mv_par07","","","","","","","","","","","","","","","","","","","","","","","","","CTT","","","",""})
	local cCCustoAte := mv_par08 //	aAdd(aRegs,{cPerg,"08","C. custo ate?","¨C. custo ate?","C. custo ate?","mv_ch8","C",09,0,0,"G","NaoVazio","mv_par08","","","","","","","","","","","","","","","","","","","","","","","","","CTT","","","",""})
	local	cMatDe := mv_par09    //	aAdd(aRegs,{cPerg,"09","Matr. de?","¨Matr. de?","Matr. de?","mv_ch9","C",06,0,0,"G","","mv_par09","","","","","","","","","","","","","","","","","","","","","","","","","SRA","","","",""})
	local cMatAte := mv_par10   //	aAdd(aRegs,{cPerg,"10","Matr. ate?","¨Matr. ate?","Matr. ate?","mv_cha","C",06,0,0,"G","NaoVazio","mv_par10","","","","","","","","","","","","","","","","","","","","","","","","","SRA","","","",""})
	local cSitua := mv_par11     //	aAdd(aRegs,{cPerg,"11","Situacoes?","¨Situacoes?","Matr. de?","mv_chb","C",05,0,0,"G","fSituacao","mv_par11","","","","","","","","","","","","","","","","","","","","","","","","","",""})
	local _cSitua := ""  //armazenara as situacoes com aspas simples entre as opcoes e virgula. Ex.: ' ','A','D','F','T'
	local cCatFunc := AllTrim(mv_par12)     //	aAdd(aRegs,{cPerg,"12","Categorias?","¨Categorias?","Matr. de?","mv_chc","C",12,0,0,"G","fCategoria","mv_par12","","","","","","","","","","","","","","","","","","","","","","","","","",""})
	local _cCatFunc := "" ////armazenara as situacoes com aspas simples entre as opcoes e virgula. Ex.: 'A','M','H','E','P'
	local cFuncDepen := mv_par13    //	aAdd(aRegs,{cPerg,"13","Caminho do arquivo?","¨Caminho do arquivo?","Path file?","mv_chd","C",40,0,0,"G","fOpenArq()","mv_par13","","","","","","","","","","","","","","","","","","","","","","","","","",""})
	local aSoma := {}
	
	if !Empty(cSitua)			//Colocar virgula entre as situacoes informadas
		for nFor := 1 to Len(cSitua) step 1
			_cSitua += "'"
			_cSitua += Substr(cSitua,nFor,1)
			if Len(cSitua) >= ( nFor+1 )
				_cSitua += "'"
				_cSitua += ","
			end
		next nFor
		if nFor > Len(AllTrim(cSitua))
			_cSitua += "'"
		end
	else
		return
	endif
	
	if !Empty(cCatFunc)			//Colocar virgula entre as categorias informadas
		for nFor := 1 to Len(AllTrim(cCatFunc)) step 1
			_cCatFunc += "'"
			_cCatFunc += Substr(cCatFunc,nFor,1)
			if Len(AllTrim(cCatFunc)) >= ( nFor+1 )
				_cCatFunc += "'"
				_cCatFunc += ","
			end
		next nFor
		if nFor > Len(AllTrim(cSitua))
			_cCatFunc += "'"
		end
	else
		return
	endif
	
	if cFuncDepen == 1 //se selecionado a primeira opcao, sera trazido os funcionarios com dependentes
		//Query para selecionar todas as informacoes referente aos funcionario e seus dependentes
		//Serao levados em consideracao a situacao e a categoria do funcionacio e data inicial e final informadas
		cQry := "SELECT SRA.RA_FILIAL FILIAL, SRA.RA_MAT MATRICULA, SRA.RA_NOME NOME, SRA.RA_RG RG, SRA.RA_CIC CPF, SRA.RA_MAE NOMEMAE, "
		cQry += "SRA.RA_SEXO SEXO, SRA.RA_CLVLDB OPERACAO, SRA.RA_ITEMD UNIDNEG, "
		cQry += "CTT.CTT_CCONTD CCUSTO, CTT.CTT_DESC01 DESCRICAO, "
   	cQry += "CTT.CTT_DESC01 DESCRICAO, "
		cQry += "SRB.RB_NOME DEPENDENTE, SRB.RB_SEXO SEXODEPEND, SRB.RB_GRAUPAR GRAUPAR, SRB.RB_MAE MAEDEPEND, "
		if nLancto == 1
			cQry += "SUBSTRING(SRC.RC_DATA,7,2)+'/'+SUBSTRING(SRC.RC_DATA,5,2)+'/'+SUBSTRING(SRC.RC_DATA,1,4) DATADESC, SRC.RC_VALOR DESCONTO "
		else
			cQry += "SUBSTRING(SRD.RD_DATPGT,7,2)+'/'+SUBSTRING(SRD.RD_DATPGT,5,2)+'/'+SUBSTRING(SRD.RD_DATPGT,1,4) DATADESC, SRD.RD_VALOR DESCONTO "
		end
		if nLancto == 1
			cQry += "FROM " + RetSqlName("SRC") + " SRC "
			cQry += "LEFT JOIN "+ RetSqlName("SRA") + " SRA ON (SRA.RA_FILIAL=SRC.RC_FILIAL) AND (SRA.RA_MAT=SRC.RC_MAT) "
			cQry += "LEFT JOIN "+ RetSqlName("SRB") + " SRB ON (SRB.RB_FILIAL=SRC.RC_FILIAL) AND (SRB.RB_MAT=SRC.RC_MAT) "
			cQry += "LEFT JOIN "+ RetSqlName("CTT") + " CTT ON (CTT.CTT_CUSTO=SRC.RC_CC) "
		else
			cQry += "FROM " + RetSqlName("SRD") + " SRD "
			cQry += "LEFT JOIN "+ RetSqlName("SRA") + " SRA ON (SRA.RA_FILIAL=SRD.RD_FILIAL) AND (SRA.RA_MAT=SRD.RD_MAT) "
			cQry += "LEFT JOIN "+ RetSqlName("SRB") + " SRB ON (SRB.RB_FILIAL=SRD.RD_FILIAL) AND (SRB.RB_MAT=SRD.RD_MAT) "
			cQry += "LEFT JOIN "+ RetSqlName("CTT") + " CTT ON (CTT.CTT_CUSTO=SRD.RD_CC) "
		end
		if nLancto == 1
			cQry += "WHERE SRC.RC_FILIAL BETWEEN '"+cFilialDe+"' AND '"+cFilialAte+"' "
			cQry += "  AND SRC.RC_MAT BETWEEN '"+cMatDe+" ' AND '"+cMatAte+"' "
			cQry += "  AND SRC.RC_DATA BETWEEN '"+dDataDe+"' AND '"+dDataAte+"' AND SRC.RC_PD='549' AND SRC.D_E_L_E_T_= '' "
			cQry += "  AND SRC.RC_CC BETWEEN '"+cCCustoDe+"' AND '"+cCCustoAte+"' "
		else
			cQry += "WHERE SRD.RD_FILIAL BETWEEN '"+cFilialDe+"' AND '"+cFilialAte+"' "
			cQry += "  AND SRD.RD_MAT BETWEEN '"+cMatDe+" ' AND '"+cMatAte+"' "
			cQry += "  AND SRD.RD_DATPGT BETWEEN '"+dDataDe+"' AND '"+dDataAte+"' AND SRD.RD_PD='549' AND SRD.D_E_L_E_T_= '' "
			cQry += "  AND SRD.RD_CC BETWEEN '"+cCCustoDe+"' AND '"+cCCustoAte+"' "
		end
		cQry += "  AND SRA.RA_SITFOLH IN ("+_cSitua+") "
		cQry += "  AND SRA.RA_CATFUNC IN ("+_cCatFunc+") "
		cQry += "  AND SRA.RA_CDODONT='02' "
		cQry += "  AND SRB.RB_ODONTO='S' "

	else //senao for igual a 1, selecionar somente os funcionarios que usam odontoprev e nao possuem dependentes
		//Query para selecionar todas as informacoes referente aos funcionario sem dependentes
		//Serao levados em consideracao a situacao e a categoria do funcionacio e data inicial e final informadas
		cQry := "SELECT SRA.RA_FILIAL FILIAL, SRA.RA_MAT MATRICULA, SRA.RA_NOME NOME, SRA.RA_RG RG, SRA.RA_CIC CPF, SRA.RA_MAE NOMEMAE, "
		cQry += "SRA.RA_SEXO SEXO, SRA.RA_CLVLDB OPERACAO, SRA.RA_ITEMD UNIDNEG, "
		cQry += "CTT.CTT_CCONTD CCUSTO, CTT.CTT_DESC01 DESCRICAO, "
	   cQry += "CTT.CTT_DESC01 DESCRICAO, "
		if nLancto == 1
			cQry += "SUBSTRING(SRC.RC_DATA,7,2)+'/'+SUBSTRING(SRC.RC_DATA,5,2)+'/'+SUBSTRING(SRC.RC_DATA,1,4) DATADESC, SRC.RC_VALOR DESCONTO "
		else
			cQry += "SUBSTRING(SRD.RD_DATPGT,7,2)+'/'+SUBSTRING(SRD.RD_DATPGT,5,2)+'/'+SUBSTRING(SRD.RD_DATPGT,1,4) DATADESC, SRD.RD_VALOR DESCONTO "
		end
		if nLancto == 1
			cQry += "FROM " + RetSqlName("SRC") + " SRC "
			cQry += "LEFT JOIN "+ RetSqlName("SRA") + " SRA ON (SRA.RA_FILIAL=SRC.RC_FILIAL) AND (SRA.RA_MAT=SRC.RC_MAT) "
			cQry += "LEFT JOIN "+ RetSqlName("CTT") + " CTT ON (CTT.CTT_CUSTO=SRC.RC_CC) "
		else
			cQry += "FROM " + RetSqlName("SRD") + " SRD "
			cQry += "LEFT JOIN "+ RetSqlName("SRA") + " SRA ON (SRA.RA_FILIAL=SRD.RD_FILIAL) AND (SRA.RA_MAT=SRD.RD_MAT) "
			cQry += "LEFT JOIN "+ RetSqlName("CTT") + " CTT ON (CTT.CTT_CUSTO=SRD.RD_CC) "
		end
		if nLancto == 1
			cQry += "WHERE SRC.RC_FILIAL BETWEEN '"+cFilialDe+"' AND '"+cFilialAte+"' "
			cQry += "  AND SRC.RC_MAT BETWEEN '"+cMatDe+" ' AND '"+cMatAte+"' "
			cQry += "  AND SRC.RC_DATA BETWEEN '"+dDataDe+"' AND '"+dDataAte+"' AND SRC.RC_PD='549' AND SRC.D_E_L_E_T_= '' "
			cQry += "  AND SRC.RC_CC BETWEEN '"+cCCustoDe+"' AND '"+cCCustoAte+"' "
		else
			cQry += "WHERE SRD.RD_FILIAL BETWEEN '"+cFilialDe+"' AND '"+cFilialAte+"' "
			cQry += "  AND SRD.RD_MAT BETWEEN '"+cMatDe+" ' AND '"+cMatAte+"' "
			cQry += "  AND SRD.RD_DATPGT BETWEEN '"+dDataDe+"' AND '"+dDataAte+"' AND SRD.RD_PD='549' AND SRD.D_E_L_E_T_= '' "
			cQry += "  AND SRD.RD_CC BETWEEN '"+cCCustoDe+"' AND '"+cCCustoAte+"' "
		end
		cQry += "  AND SRA.RA_SITFOLH IN ("+_cSitua+") "
		cQry += "  AND SRA.RA_CATFUNC IN ("+_cCatFunc+") "
		cQry += "  AND SRA.RA_CDODONT='02' "
	
	end //finaliza a condicao da variavel cFuncDepen

	if nLancto == 1
		if nOrdGerArq == 1	   						//Ordem Filial+Matricula
			cQry += "ORDER BY SRC.RC_FILIAL, SRC.RC_DATA, SRC.RC_MAT "
		elseif nOrdGerArq == 2							//Ordem Filial+Centro de Custo
			cQry += "ORDER BY SRC.RC_FILIAL, SRC.RC_DATA, SRC.RC_CC "
		elseif nOrdGerArq == 3							//Ordem Filial+Nome 
			cQry += "ORDER BY SRA.RA_FILIAL, SRC.RC_DATA, SRA.RA_NOME "
		end
	else
		if nOrdGerArq == 1	   						//Ordem Filial+Matricula
			cQry += "ORDER BY SRD.RD_FILIAL, SRD.RD_DATPGT, SRD.RD_MAT "
		elseif nOrdGerArq == 2							//Ordem Filial+Centro de Custo
			cQry += "ORDER BY SRD.RD_FILIAL, SRD.RD_DATPGT, SRD.RD_CC "
		elseif nOrdGerArq == 3							//Ordem Filial+Nome 
			cQry += "ORDER BY SRA.RA_FILIAL, SRD.RD_DATPGT, SRA.RA_NOME "
		end
	end

	ProcRegua(2)
	IncProc("Selecionando registros...")

   if Select("TRBSRD") > 0
		dbSelectArea("TRBSRD")
		("TRBSRD")->(dbCloseArea())
	end
		
	TCQUERY cQry NEW ALIAS "TRBSRD"
	IncProc("Gerando arquivo excel...")
	
	dbSelectArea("TRBSRD")

	cTRBSRD := CriaTrab(nil, .F.)
	
	copy to &(cTRBSRD)
	dbUseArea(.T., , cTRBSRD, "TRBEXC", .F., .F.)

	dbSelectArea("TRBEXC")
	("TRBEXC")->(dbGoTop())

   while ("TRBEXC")->(!Eof())

		if cFuncDepen != 1 //se selecionado a primeira opcao, sera trazido os funcionarios com dependentes
			dbSelectArea("SRB")
			aAreaSRB := GetArea()
			dbSetOrder(1)
			if dbSeek(xFIlial("SRB")+TRBEXC->MATRICULA)
				RecLock("TRBEXC", .F.)
				TRBEXC->(dbDelete())
				TRBEXC->(msUnLock())
			end
		RestArea(aAreaSRB)
		end

		cMatricula := TRBEXC->(FILIAL+MATRICULA) 
		nDesconto := 0.00

		If Ascan( aSoma, TRBEXC->MATRICULA+TRBEXC->DATADESC ) == 0
			nDesconto := TRBEXC->DESCONTO
	   	Aadd( aSoma, TRBEXC->MATRICULA+TRBEXC->DATADESC )
		EndIf
	
		TRBEXC->DESCONTO := nDesconto
	
		If cMatricula # TRBEXC->(FILIAL+MATRICULA)
		   aSoma := {}
		EndIf
     
	   dbSelectArea("TRBEXC")
   	("TRBEXC")->(dbSkip())
   enddo
   	
	("TRBEXC")->(dbCloseArea())
	
	OpExcel(cTRBSRD)
	
	fErase(cTRBSRD+".dbf")
return(nil)


/*
===========================================================================
Funcao    : OpExcel         | Autor: Claudinei E.N.     | Data |17/08/07
==========|================================================================
Descricao : Integracao entre excel e microsiga
==========|================================================================
Modulo    : SIGAGPE - Gestão de Pessoal                                   
==========|================================================================
OBS       :                                                               
==========|================================================================
Alterações solicitadas                                                    
===========================================================================
Descrição :                                    |Sol.por|Atend.por|Data    
===========================================================================*/
static function OpExcel(cArqTRB)
	local cDirDocs := MsDocPath()
	local cPath := AllTrim(GetTempPath())

	//Copia DBF para pasta TEMP do sistema operacional da estacao
	if File(cArqTRB+".DBF")
		COPY File(cArqTRB+".DBF") TO (cPath+cArqTRB+".DBF")
	end

	if !ApOleClient("MsExcel")
		MsgStop("MsExcel nao instalado.")
		return
	end

	//Cria link com o excel
	oExcelApp := MsExcel():New()
	
	//Abre uma planilha
	oExcelApp:WorkBooks:Open(cPath+cArqTRB+".DBF")
	oExcelApp:SetVisible(.T.)
	
return(nil)


/*
===========================================================================
Funcao    : ValidPerg        | Autor: Claudinei E.N.     | Data |17/08/07
==========|================================================================
Descricao : Verifica as perguntas incluindo-as caso nao existam, para serem
            exibidas ao usuario, que selecionara o que deseja extrair.
==========|================================================================
Modulo    : SIGAGPE - Gestão de Pessoal                                   
==========|================================================================
OBS       :                                                               
==========|================================================================
Alterações solicitadas                                                    
===========================================================================
Descrição :                                    |Sol.por|Atend.por|Data    
===========================================================================*/
static function ValidPerg()
	local _sAlias := Alias() //
	local aRegs := {} //Variavel tipo vetor
	local i,j //contador para controlar i-Controlar aRegs e j-Controlar cPerg que esta dentro de aRegs
	
	dbSelectArea("SX1")
	dbSetOrder(1)
	cPerg := PADR(cPerg,LEN(SX1->X1_GRUPO))

	aAdd(aRegs,{cPerg,"01","Gerar em ordem de?","¨Gerar em ordem de?","Gerar em ordem de?","mv_ch1","N",01,0,0,"C","","mv_par01","Matricula","","","","","Centro de custo","","","","","Nome","","","","","","","","","","","","","","","","","",""})
	
	aAdd(aRegs,{cPerg,"02","Lancamento      ","","","mv_ch2","N",01,0,0,"C","            ","mv_par02","Mensal   ","","","","","Acumulado","","","","","","","","","","","","","","","","","","","   ","",""," "})

	aAdd(aRegs,{cPerg,"03","Per. MMAAAA de?","","","mv_ch3","D",08,00,0,"G","NaoVazio","mv_par03","","","","","","","","","","","","","","","","","","","","","","","","","","","","",""})
	aAdd(aRegs,{cPerg,"04","Per. MMAAAA ate?","","","mv_ch4","D",08,00,0,"G","NaoVazio","mv_par04","","","","","","","","","","","","","","","","","","","","","","","","","","","","",""})

	aAdd(aRegs,{cPerg,"05","Filial de?","","","mv_ch5","C",02,00,0,"G","NaoVazio","mv_par05","","","","","","","","","","","","","","","","","","","","","","","","","XM0","","","",""})
	aAdd(aRegs,{cPerg,"06","Filial ate?","","","mv_ch6","C",02,00,0,"G","NaoVazio","mv_par06","","","","","","","","","","","","","","","","","","","","","","","","","XM0","","","",""})

	aAdd(aRegs,{cPerg,"07","C. custo de?","¨C. custo de?","C. custo de?","mv_ch7","C",20,0,0,"G","","mv_par07","","","","","","","","","","","","","","","","","","","","","","","","","CTT","","","",""})
	aAdd(aRegs,{cPerg,"08","C. custo ate?","¨C. custo ate?","C. custo ate?","mv_ch8","C",20,0,0,"G","NaoVazio","mv_par08","","","","","","","","","","","","","","","","","","","","","","","","","CTT","","","",""})

	aAdd(aRegs,{cPerg,"09","Matr. de?","¨Matr. de?","Matr. de?","mv_ch9","C",06,0,0,"G","","mv_par09","","","","","","","","","","","","","","","","","","","","","","","","","SRA","","","",""})
	aAdd(aRegs,{cPerg,"10","Matr. ate?","¨Matr. ate?","Matr. ate?","mv_cha","C",06,0,0,"G","NaoVazio","mv_par10","","","","","","","","","","","","","","","","","","","","","","","","","SRA","","","",""})
	                                                                         
	aAdd(aRegs,{cPerg,"11","Situacoes?","¨Situacoes?","Matr. de?","mv_chb","C",05,0,0,"G","fSituacao","mv_par11","","","","","","","","","","","","","","","","","","","","","","","","","",""})
	aAdd(aRegs,{cPerg,"12","Categorias?","¨Categorias?","Matr. de?","mv_chc","C",12,0,0,"G","fCategoria","mv_par12","","","","","","","","","","","","","","","","","","","","","","","","","",""})

	aAdd(aRegs,{cPerg,"13","Funcionarios?          ","","","mv_chd","C",01,0,0,"C","","mv_par13","com dependentes","com dependentes","com dependentes","","","sem dependentes","sem dependentes","sem dependentes","","","","","","","","","","","","","","","","","","","",""} )

	for i:=1 to Len(aRegs)
		if !dbSeek(cPerg+aRegs[i,2])
			RecLock("SX1",.T.)
			for j:=1 to FCount()
				if j <= Len(aRegs[i])
					FieldPut(j,aRegs[i,j])
				end
			next
			MsUnlock()
			SX1->(dbCommit()) //Salva em disco todas as modificações da tabela corrente no SX1EE0.
		end
	next

	dbSelectArea(_sAlias)

return(nil)