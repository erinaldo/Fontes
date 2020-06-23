/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³PAGAR001  ºAutor  ³ 			   º Data ³  24/06/09   º±±
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


User Function Pagar002(_cOpcao)


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