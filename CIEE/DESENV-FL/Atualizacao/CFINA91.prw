#INCLUDE 'protheus.ch'
#INCLUDE 'TOTVS.CH'
#INCLUDE 'Topconn.ch'

/*/{Protheus.doc} CFINA91
//Programa responsavel por Geração dos Titulos a Pagar (FL) origem da integração ESB x VIEW APDATA
//e geração automatica do arquivo CNAB modelo Folha de Pagamento
@author emerson.natali
@since 21/07/2017
@version undefined

@type function
/*/
user function CFINA91(_cCodigo)

	Local _cArqTrab	:= "" //Arquivo de Trabalho - query
	Local _cSE2Key	:= ''
	Local _cQuery	:= ''
	
	Default _cCodigo := '000001' //campo utilizado para trazer os registros da tabela ZAG
	
	If _cCodigo == Nil 
		Return
	EndIf
	
	_cArqTrab:= GetNextAlias()
	
	//ZAG_PROPGT - Processo de Pagamento (ex: FL-Folha; FE-Ferias; RE-Rescisão)
	
	BeginSQL Alias _cArqTrab
		SELECT SUM(ZAG.ZAG_VALOR) AS ZAG_VALOR , ZAG.ZAG_BANCO, ZAG.ZAG_PROPGT, SZL.ZL_FORNEC, SZL.ZL_ARQUIVO, SZL.ZL_PATH, SZL.ZL_MODELO, SZL.ZL_EXT, SZL.ZL_AGBOR, SZL.ZL_CCBOR
		FROM %Table:ZAG% ZAG, %Table:SZL% SZL
		WHERE ZAG.%NotDel% AND SZL.%NotDel% 
		AND ZAG.ZAG_BANCO = SZL.ZL_BANCO
		AND ZAG.ZAG_CODIGO = %Exp:_cCodigo%
		AND SZL.ZL_TIPO = '5'
		GROUP BY ZAG.ZAG_BANCO, ZAG.ZAG_PROPGT, SZL.ZL_FORNEC, SZL.ZL_ARQUIVO, SZL.ZL_PATH, SZL.ZL_MODELO, SZL.ZL_EXT, SZL.ZL_AGBOR, SZL.ZL_CCBOR
	EndSQL
	
	(_cArqTrab)->(dbSelectArea((_cArqTrab)))                    
	(_cArqTrab)->(dbGoTop())                               	
	While (_cArqTrab)->(!Eof())        		
		
		_cSE2Key := CFin91Inc((_cArqTrab)->(ZAG_VALOR), (_cArqTrab)->(ZAG_PROPGT), (_cArqTrab)->(ZL_FORNEC), (_cArqTrab)->(ZAG_BANCO), (_cArqTrab)->(ZL_AGBOR), (_cArqTrab)->(ZL_CCBOR), (_cArqTrab)->(ZL_MODELO)) //Inclusão do Titulo a Pagar

		If !Empty(_cSE2Key) //Se gerou titulo Financeiro - Atualiza a ZAG (controle de FL) com a chave do Titulo
			//Atualiza a tabela ZAG com o numero de Controle (Codigo) e o numero do Titulo SE2 gerado para o numero X de registros
			_cQuery := "UPDATE "+RetSqlName("ZAG")+" "
			_cQuery += "SET ZAG_CPREXT = '"+_cCodigo+"' , ZAG_TITSE2 = '"+_cSE2Key+"' "
			_cQuery += "WHERE "
			_cQuery += "ZAG_BANCO  = '"+(_cArqTrab)->(ZAG_BANCO) +"' AND "
			_cQuery += "ZAG_PROPGT = '"+(_cArqTrab)->(ZAG_PROPGT)+"'     "
			TcSqlExec(_cQuery)
		EndIf
		
		(_cArqTrab)->(dbSkip())
	EndDo
	
	(_cArqTrab)->(dbCloseArea())
	
return

/*/{Protheus.doc} CFin91Inc
//Função para inclusão do Titulo a Pagar. Utilizado com EXECAUTO
@author emerson.natali
@since 21/07/2017
@version undefined

@type function
/*/
Static Function CFin91Inc(_nValor, _xProPgt, _xFornec, _xBanco, _xAgencia, _xConta, _xModelo)

	Local _aArea 	:= GetArea()
	Local _nOpcExec	:= 3 //Inclusão
	Local _aTitulo	:= {}
	Local _lRet		:= .T.
	Local _cSE2Key	:= ""
	Local _cNaturez	:= ""
	Local _nNumTit	:= SUBS(STRZERO(YEAR(DDATABASE),4),3,2)+SUBS(GETSXENUM("SE2","E2_NUM","FL_"+cEmpAnt),3,7) //Controle de numeração dos Titulos FL (Contas a Pagar - SE2)

	Private lMsErroAuto := .F.

/*
****************************
**        APDATA          **
****************************
501,502 				: Processo := 'FE'; //ferias
401,402 				: Processo := 'RE'; //rescisao
71,61,81,91,79,80,75 	: Processo := 'FP'; //folha
Else Processo 			:= 'BE';			//beneficios

**********************************
**  Classificação das naturezas **
**********************************
Férias 		- 04020110
Rescisão 	- 04020109
Pagamento 	- 04020101
VA 			- 04020105 (Aguardando o Bruno passar a DEFINICAO do codigo especifico para esses Beneficios)
VT			- 04020106 (Aguardando o Bruno passar a DEFINICAO do codigo especifico para esses Beneficios)
*/

	//Regra para pegar a Natureza Financeira
	Do Case
		Case _xProPgt $ ('501|502') //Ferias
			_cNaturez := "04020110"
		Case _xProPgt $ ('401|402') //Rescisao
			_cNaturez := "04020109"
		Case _xProPgt $ ('71|61|81|91|79|80|75') //Folha
			_cNaturez := "04020101"
		OtherWise //Beneficios
			_cNaturez := "04020105"
	EndCase

	_aTitulo := {{"E2_PREFIXO", "FL" 				, NIL},;
				{"E2_NUM"     , _nNumTit			, NIL},;
				{"E2_PARCELA" , ""					, NIL},;
				{"E2_TIPO"    , "FL"				, NIL},;
				{"E2_HIST"    , "FL - "+_xProPgt	, NIL},;
				{"E2_NATUREZ" , _cNaturez			, NIL},;
				{"E2_FORNECE" , _xFornec			, NIL},; 
				{"E2_LOJA"    , "01"				, NIL},;
				{"E2_EMISSAO" , dDataBase			, NIL},;
				{"E2_VENCTO"  , dDataBase			, NIL},;
				{"E2_VENCREA" , dDataBase			, NIL},;
				{"E2_VALOR"   , _nValor				, NIL},;
				{"E2_XBCOBOR" , _xBanco				, NIL},;
				{"E2_XAGBOR"  , _xAgencia			, NIL},;
				{"E2_XCCBOR"  , _xConta				, NIL},;
				{"E2_XMODELO" , "01"			    , NIL} }
				
	Begin Transaction
	
	MsExecAuto({|x,y,z| FINA050(x,y,z)},_aTitulo,,_nOpcExec)   	//MSEXECAUTO DE INCLUSAO DE TITULO
	
	If lMsErroAuto
		//Restaura o ambiente, desarma a Transação, RollBack no numero
		RestArea(_aArea)
		DisarmTransaction()
		RollBackSx8()
		MostraErro()
		break
	Else
		//Confirma a numeração
		ConfirmSX8()
		//Guarda a chave para atualizar a tabela ZAG (registros individuais)
		_cSE2Key := SE2->(E2_PREFIXO+E2_NUM+E2_PARCELA+E2_TIPO+E2_FORNECE+E2_LOJA)
	EndIf
	
	End Transaction

	RestArea(_aArea)

Return(_cSE2Key)