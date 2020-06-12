#include "Protheus.ch"

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³PAGAR341  ºAutor  ³Marciane Gennari    º Data ³  26/12/08   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ Funcao unica para SISPAG ITAU                              º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ AP                                                         º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

/*
FORNECEDORES
+----------------------+----------+
| Nome Campo           | Parametro|                                            
+----------------------+----------+
| CODIGO AGENCIA       |   PP001  |                     
| VALOR PAGTO          |   PP002  |                     
| VALOR DESCONTO       |   PP003  |                   
| VALOR ACRESCIMO      |   PP004  |                   
| DV CODIGO DE BARRAS  |   PP005  |                     
| FATOR VENCTO E VALOR |   PP006  |                     
| CAMPO LIVRE (CODBAR) |   PP007  |                     
+----------------------+----------+

TRIBUTOS
+----------------------+----------+
| Nome Campo           | Parametro|                                            
+----------------------+----------+
| DADOS DARF / GPS     |   PT001  |                     
+----------------------+----------+
*/

User Function Pagar341(_cOpcao)   

Local _cTipo 		:= ""
Local _cRetorno 	:= ""
Local _cAgc 		:= ""             
Local _cDigcc 		:= ""
Local _cBanco 		:= ""
Local _cConta 		:= ""
Local _cCampo 		:= ""
Local _TtAbat 		:= 0.00
Local _Juros 		:= 0.00
Local _Liqui 		:= 0.00

_cTipo    := Alltrim(Upper(_cOpcao))

Do Case
	Case _cTipo == "PP001"	//  Agencia e Conta Corrente Favorecido
		// Numero da Conta Corrente
		_cBanco 	:= SE2->E2_BANCO 	//SA2->A2_BANCO
		_cAgc 		:= SE2->E2_AGEFOR 	//SA2->A2_AGENCIA
		_cConta 	:= SE2->E2_CTAFOR 	//SA2->A2_NUMCON
		_cDigAg 	:= SE2->E2_DVFOR 	//SA2->A2_E_DIGCC
		_cDigCc 	:= iif(At("-",SE2->E2_CTAFOR)>0, Substr(SE2->E2_CTAFOR, At("-",SE2->E2_CTAFOR)+1,1),"0") 	//SA2->A2_E_DIGCC
     
		// Formato banco ITAU (341)
		// Numero da Conta Corrente
                                                
		If _cBanco  == "341"
			_cRetorno := "0"+strzero(val(substr(_cAgc,1,4)),4)+" "+"0000000"
			_cRetorno += strzero(val(substr(_cConta,1,5)),5)+" "+substr(_cDigCc,1,1)
		ElseIf _cBanco  == "001"
			_cRetorno := "0"+strzero(val(substr(_cAgc,1,4)),4)	//024-028
			_cRetorno +=_cDigAg									//29
			_cRetorno +=Strzero(Val(Substr(_cConta,1,(At("-",_cConta)-1))),12) //30-41
			_cRetorno +=substr(_cDigCc,1,1)						//42
			_cRetorno +=" "										//43
		ElseIf _cBanco  == "033"
			_cRetorno := strzero(val(substr(_cAgc,1,5)),5)+" "
			_cRetorno += strzero(val(substr(_cConta,1,12)),12)
			If len(rtrim(ltrim(_cDigCc))) > 1
				_cRetorno += strzero(val(substr(_cDigCc,1,2)),2)
			Else
				_cRetorno += substr(_cDigCc,1,1)+" "
			EndIf
		Else
			_cRetorno := strzero(val(substr(_cAgc,1,5)),5)+" "
			_cRetorno += strzero(val(substr(_cConta,1,12)),12)
			If len(rtrim(ltrim(_cDigCc))) > 1
				_cRetorno += strzero(val(substr(_cDigCc,1,2)),2)
			Else
				_cRetorno += " "+substr(_cDigCc,1,1)
			EndIf                                     
		EndIf
       
		//--- Mensagem ALERTA
		If Empty(_cAgc) .or. Empty(_cConta) .or. Empty(_cDigcc)                            
			MsgAlert('Fornecedor '+alltrim(sa2->a2_cod)+"-"+alltrim(sa2->a2_loja)+" "+alltrim(sa2->a2_nome)+' sem banco/agência/conta corrente no titulo '+SE2->E2_PREFIXO+'-'+SE2->E2_NUM+'-'+SE2->E2_PARCELA+'. Atualize os dados no titulo e execute esta rotina novamente.')
		EndIf                  
  
		//--- Mensagem ALERTA
		If Empty(SA2->A2_CGC)
			MsgAlert('Fornecedor '+alltrim(sa2->a2_cod)+"-"+alltrim(sa2->a2_loja)+" "+alltrim(sa2->a2_nome)+' sem CNPJ no cadastro. Atualize os dados no cadastro do fornecedor e execute esta rotina novamente.')
		EndIf          
                 
	Case _cTipo == "PP002"	//  Valor Pagamento                    
		_TtAbat := 0.00
		_Juros  := 0.00

		//Funcao SOMAABAT totaliza todos os titulos com e2_tipo AB- relacionado ao titulo do parametro 
		_TtAbat 	:= somaabat(SE2->E2_PREFIXO,SE2->E2_NUM,SE2->E2_PARCELA,'P',SE2->E2_MOEDA,DDATABASE,SE2->E2_FORNECE,SE2->E2_LOJA)
		_TtAbat 	+= SE2->E2_DECRESC                       
		_Juros 		:= (SE2->E2_MULTA + SE2->E2_VALJUR + SE2->E2_ACRESC)
		_Liqui 		:= (SE2->E2_VALOR-_TtAbat+_Juros)
//		_Liqui 		:= (SE2->E2_SALDO-_TtAbat+_Juros)
         
		_cRetorno 	:= Left(StrZero((_Liqui*1000),16),15)

    Case _cTipo == "PP003"	//  Valor Abatimento/Desconto          
   
		/*
         _TtAbat   := somaabat(SE2->E2_PREFIXO,SE2->E2_NUM,SE2->E2_PARCELA,'P',SE2->E2_MOEDA,DDATABASE,SE2->E2_FORNECE,SE2->E2_LOJA)
         _TtAbat   += SE2->E2_DECRESC                          
         
         _cRetorno := Left(StrZero((_TtAbat*1000),16),15)
         */
         _TtAbat	:= 0
         _cRetorno := Left(StrZero((_TtAbat*1000),16),15)

    Case _cTipo == "PP004"	//  Valor Juros           

         /*   
         _Juros    := (SE2->E2_MULTA + SE2->E2_VALJUR + SE2->E2_ACRESC)
         _cRetorno := Left(StrZero((_Juros*1000),16),15)
         */
         _Juros    := 0
         _cRetorno := Left(StrZero((_Juros*1000),16),15)

	Case _cTipo == "PP005"	//  Digito Verificador (Codigo de Barras)
   
		If Len(Alltrim(SE2->E2_CODBAR)) < 44       // Antiga Codificacao (Numerica)
			_cRetorno := Substr(SE2->E2_CODBAR,33,1)
		ElseIf Len(Alltrim(SE2->E2_CODBAR)) == 47      // Nova Codificacao (Numerica)
			_cRetorno := Substr(SE2->E2_CODBAR,33,1)
		Else
			_cRetorno := Substr(SE2->E2_CODBAR,5,1)   // Codificacao Cod. Barras
		EndIf	

		If Empty(SE2->E2_CODBAR) 
			MsgAlert("Titulo "+alltrim(se2->e2_prefixo)+"-"+alltrim(se2->e2_num)+" "+alltrim(se2->e2_parcela)+" do fornecedor "+alltrim(sa2->a2_cod)+"-"+alltrim(sa2->a2_loja)+" "+alltrim(sa2->a2_nome)+" sem código de barras. Informe o código de barras no título indicado e execute esta rotina novamente.")
		EndIf 

	Case _cTipo == "PP006"	//  Fator de Vencimento e Valor do Titulo (Codigo de Barras)
   
		If Len(Alltrim(SE2->E2_CODBAR)) < 44
			_cCampo := "00000000000000" //Substr(SE2->E2_CODBAR,34,5)
		ElseIf Len(Alltrim(SE2->E2_CODBAR)) == 47        
			_cCampo := Substr(SE2->E2_CODBAR,34,14)
		Else
			_cCampo := Substr(SE2->E2_CODBAR,6,14)
		EndIf	

		_cRetorno := Strzero(Val(_cCampo),14)

    Case _cTipo == "PP007"	//  Campo Livre (Codigo de Barras)       
   
         If Len(Alltrim(SE2->E2_CODBAR)) < 44
        	_cRetorno := Substr(SE2->E2_CODBAR,5,5)+Substr(SE2->E2_CODBAR,11,10)+Substr(SE2->E2_CODBAR,22,10)
         ElseIf Len(Alltrim(SE2->E2_CODBAR)) == 47
        	_cRetorno := Substr(SE2->E2_CODBAR,05,05)+ Substr(SE2->E2_CODBAR,11,10)+ Substr(SE2->E2_CODBAR,22,10)
         Else
        	_cRetorno := Substr(SE2->E2_CODBAR,20,25)
         EndIf	

    Case _cTipo == "PP008"	//  Tipo de Conta para DOC (Conta Poupança)
         _cRetorno := ""

         If SEA->EA_MODELO=="03"
	          _cRetorno := "01"
         EndIf

    Case _cTipo == "PT001"	                           
 
         _cRetorno := ""
         //  Dados DARF  
     
         If (SEA->EA_MODELO == "16" .or. SEA->EA_MODELO == "18")   
   
            // Posicao 018 a 019: Identificacao do Tributo 02-Darf 03-Darf Simples
            _cRetorno := If(SEA->EA_MODELO=="18","03","02")                         

            // Posicao 020 a 023: Codigo da Receita                                 
            _cRetorno +=  If(!Empty(SE2->E2_E_CINSS),SE2->E2_E_CINSS,SE2->E2_CODRET)  
           
            // Posicao 024 a 024: Tp Inscricao  1-CPF /  2-CNPJ               
                                               
           If !Empty(SE2->E2_E_CNPJC)
               _cRetorno += Iif (len(alltrim(SE2->E2_E_CNPJC))>11,"2","1")
           Else               
              _cRetorno += "2"       
           EndIf
  
            // Posicao 025 a 038: N Inscricao  //--- CNPJ/CPF do Contribuinte
                                                  
            If !Empty(SE2->E2_E_CNPJC)
               _cRetorno += Strzero(Val(SE2->E2_E_CNPJC),14)
            Else
               _cRetorno += Subs(SM0->M0_CGC,1,14)
            EndIf
                                                 
            // Posicao 039 a 046: Periodo Apuracao
            _cRetorno += GravaData(SE2->E2_E_APUR,.F.,5) 
            
            // Posicao 047 a 063: Referencia   
            _cRetorno += Repl("0",17) 
            
            // Posicao 064 a 077: Valor Principal
            _cRetorno += Strzero(SE2->E2_VALOR*100,14)                               
//            _cRetorno += Strzero(SE2->E2_SALDO*100,14)                               
            
            // Posicao 078 a 091: Multa             
            _cRetorno += STRZERO(SE2->E2_ACRESC*100,15)         
            
            // Posicao 092 a 105: Juros        
            _cRetorno += STRZERO(0,15)          
            
            // Posicao 106 a 119: Valor Total (Principal + Multa + Juros)
            _cRetorno += STRZERO((SE2->E2_VALOR+SE2->E2_ACRESC)*100,15)           
//            _cRetorno += STRZERO((SE2->E2_SALDO+SE2->E2_ACRESC)*100,15)           

            // Posicao 120 a 127: Data Vencimento                           
            _cRetorno += GravaData(SE2->E2_VENCTO,.F.,5)                             

            // Posicao 128 a 135: Data Pagamento                            
            _cRetorno += GravaData(SE2->E2_VENCREA,.F.,5)                            

            // Posicao 136 a 165: Compl.Registro                          
            _cRetorno += Space(30)                                                   

            // Posicao 166 a 195: Nome do Contribuinte                 
            If !Empty(SE2->E2_E_CNPJC)
               _cRetorno += Subs(SE2->E2_E_CONTR,1,30)
               If Empty(SE2->E2_E_CONTR)
                  MsgAlert('Nome do Contribuinte não informado para a DARF - Titulo '+alltrim(se2->e2_prefixo)+"-"+alltrim(se2->e2_num)+"-"+alltrim(se2->e2_parcela)+'. Atualize o Nome do Contribuinte no titulo indicado e execute esta rotina novamente.')
               EndIf
            Else
               _cRetorno += Subs(SM0->M0_NOMECOM,1,30)
            EndIf                                                                      
                                                             
            //--- Mensagem ALERTA que está sem periodo de apuração
            If Empty(se2->e2_e_apur)                              
        
               MsgAlert('Tributo sem Data de Apuracao. Informe o campo Per.Apuracao no titulo: '+alltrim(se2->e2_prefixo)+" "+alltrim(se2->e2_num)+" "+alltrim(se2->e2_parcela)+" Tipo: "+alltrim(se2->e2_tipo)+" Fornecedor/Loja: "+alltrim(se2->e2_fornece)+"-"+alltrim(se2->e2_loja)+' e execute esta rotina novamente.')

            EndIf     
  
            
         // Dados GPS
         ElseIf (SEA->EA_MODELO == "17")   
   

            // Posicao 018 a 019: Identificacao do Tributo 01-GPS                    
            _cRetorno := "01"                                                       

            // Posicao 020 a 023: Codigo Pagamento                                 
            _cRetorno +=  SE2->E2_E_CINSS  
                                                 
            // Posicao 024 a 029: Competencia     
            _cRetorno += STRZERO(YEAR(SE2->E2_E_APUR),4)+STRZERO(MONTH(SE2->E2_E_APUR),2)
            
            // Posicao 030 a 043: N Identificacao  //--- CNPJ/CPF do Contribuinte
            If !Empty(SE2->E2_E_CONTR)
                 If Empty(SE2->E2_E_CNPJC)
     
                     MsgAlert('O titulo de tributo '+alltrim(se2->e2_prefixo)+"-"+alltrim(se2->e2_num)+" "+alltrim(se2->e2_parcela)+' do fornecedor '+alltrim(se2->e2_fornece)+" "+alltrim(se2->e2_loja)+' está sem o CNPJ/CPF do Contribuinte. Atualize os dados no titulo e execute esta rotina novamente.')
                 EndIf
               _cRetorno += Strzero(Val(SE2->E2_E_CNPJC),14)
           Else
                _cRetorno += Strzero(Val(SM0->M0_CGC),14)
           EndIf
  
            // Posicao 044 a 057: Valor Principal (Valor Titulo - Outras Entidades)
            _cRetorno += Strzero((SE2->E2_VALOR-SE2->E2_E_VLENT)*100,14)                               
//            _cRetorno += Strzero((SE2->E2_SALDO-SE2->E2_E_VLENT)*100,14)                               
            
            // Posicao 058 a 071: Valor Outras Entidades
            _cRetorno += Strzero(SE2->E2_E_VLENT*100,14)            
            
            // Posicao 072 a 085: Multa        
            _cRetorno += Strzero(SE2->E2_ACRESC*100,14)            
            
            // Posicao 086 a 099: Valor Total (Principal + Multa)
            _cRetorno += Strzero((SE2->E2_VALOR+SE2->E2_ACRESC)*100,14)              
//            _cRetorno += Strzero((SE2->E2_SALDO+SE2->E2_ACRESC)*100,14)              

            // Posicao 100 a 107: Data Vencimento                           
            _cRetorno += GravaData(SE2->E2_VENCREA,.F.,5)                             

            // Posicao 108 a 115: Compl.Registro                          
            _cRetorno += Space(8)                                                   

            // Posicao 116 a 165: Informacoes Complementares              
            _cRetorno += Space(50)                                                  

            // Posicao 166 a 195: Nome do Contribuinte                                                  
            If !Empty(SE2->E2_E_CNPJC)
               _cRetorno += Subs(SE2->E2_E_CONTR,1,30)
               If Empty(SE2->E2_E_CONTR)
                  MsgAlert('Nome do Contribuinte não informado para a DARF - Titulo '+alltrim(se2->e2_prefixo)+"-"+alltrim(se2->e2_num)+"-"+alltrim(se2->e2_parcela)+'. Atualize o Nome do Contribuinte no titulo indicado e execute esta rotina novamente.')
               EndIf
            Else
               _cRetorno += Subs(SM0->M0_NOMECOM,1,30)
            EndIf                                                                      
                                                             
            //--- Mensagem ALERTA que está sem periodo de apuração
            If Empty(se2->e2_e_apur)                             
        
               MsgAlert('Tributo sem Competencia. Informe o campo Competencia no titulo: '+alltrim(se2->e2_prefixo)+" "+alltrim(se2->e2_num)+" "+alltrim(se2->e2_parcela)+" Tipo: "+alltrim(se2->e2_tipo)+" Fornecedor/Loja: "+alltrim(se2->e2_fornece)+"-"+alltrim(se2->e2_loja)+' e execute esta rotina novamente.')

            EndIf     


         EndIf     
  
  
    Otherwise  //  Parametro não existente
      
	 MsgAlert('Não foi encontrado o Parametro '+ _cTipo + "."+;
                  'Solicite à informática para verificar o fonte PAGAR341, ou o arquivo de configuração do CNAB.')

EndCase		      

return(_cRetorno)


  

