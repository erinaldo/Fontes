#Include "PROTHEUS.Ch"
#include "TOPCONN.ch"    
/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡„o    ³ ECSU002  ³ Autor ³ ROBERTO R.MEZZALIRA   ³ Data ³ 18.01.06 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡„o ³ EXECBLOCK PARA HISTORICO LANC.PADRAO DE COMPENSACAO ENTRE  ³±± 
±±³          ³ CARTEIRAS e CANCELAMENTO - 594 e 535                       ³±± 
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
User Function ECSU002()
                         
LOCAL aARECTK   := {} //ARMAZENA A POSICAO DO CTK
LOCAL aAreaSE5  := {} //ARMAZENA A POSICAO DO SE5
LOCAL nREGTRB   := 0  
LOCAL _cTITSE1  := "" //NUMERO DO TITULO A RECEBER
LOCAL _cTIPSE1  := "" //TIPO DO TITULO A RECEBER
LOCAL _cEMISE1  := "" //EMISSAO DO TITULO A RECEBER
LOCAL _cNOMA1   := "" //NOME DO CLIENTE DO TITULO A RECEBER
LOCAL _cTITSE2  := "" //NUMERO DO TITULO A PAGAR
LOCAL _cTIPSE2  := "" //TIPO DO TITULO A PAGAR
LOCAL _cEMISE2  := "" //EMISSAO DO TITULO A PAGAR
LOCAL _cNOMA2   := "" //NOME DO FONECEDOR DO TITULO A PAGAR
LOCAL _nREGSE5  := 0
LOCAL _cHISTCLI := ""  
LOCAL _cHIST    := ""  
LOCAL _cHIST1   := ""
LOCAL _aVetcli  := {} 
LOCAL _aVetfor  := {}
LOCAL _nC       := 0
LOCAL _nD       := 0

aARECTK :=CTK->(GETAREA())
aAreaSE5:=SE5->(GetArea())
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³EFETUA O HISTORICO CONFORME A FUNCAO UTILIZADA³
//³COMPENSACAO OU CANCELAMENTO                   ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
DO CASE
   CASE ALLTRIM(PROCNAME(4)) == "FA450CMP" 
     DBSELECTAREA("TRB") 
     nREGTRB  := RECNO("TRB")  
     DBGOTOP()
     DO WHILE !EOF()         
  
       IF TRB->MARCA == cMarca
           IF TRB->P_R == "R"
                aAdd(_aVetcli,{SUBSTR(TRB->CHAVE,6,6),SUBSTR(TRB->CHAVE,13,2),DTOC(TRB->EMISSAO),ALLTRIM(TRB->NOME)})
           ELSE
                aAdd(_aVetfor,{SUBSTR(TRB->CHAVE,6,6),SUBSTR(TRB->CHAVE,13,2),DTOC(TRB->EMISSAO),ALLTRIM(TRB->NOME)})
            
           ENDIF  
       Else
           DBSELECTAREA("TRB") 
           DBSKIP()
           Loop
       Endif 

       DBSELECTAREA("TRB") 
       DBSKIP()

     ENDDO
     DBSELECTAREA("TRB") 
     DBGOTO(nREGTRB)                                                                                                                                          
     
     FOR _nD :=1 TO LEN(_aVetfor)
     
         _cHIST += " COMP.DOC."+_aVetfor[_nD][2]+" NR. "+_aVetfor[_nD][1]+" DE "+_aVetfor[_nD][3]+" FORN : "+_aVetfor[_nD][4]
     
     NEXT _nD

     FOR _nC :=1 TO LEN(_aVetcli)
      
        _cHISTCLI += " C/DOC."+_aVetcli[_nC][2]+" NR."+_aVetcli[_nC][1]+" DE "+_aVetcli[_nC][3]+" CLIENTE : "+_aVetcli[_nC][4]
     
     NEXT _nC    
     _cHIST1 := _cHIST + _cHISTCLI 

   CASE ALLTRIM(PROCNAME(4)) == "FA450CAN" 
       
        IF SE5->E5_RECPAG == "P"
            
              DbSelectArea("SE2")
			  DbSetOrder(6)
			  DbSeek(xFilial("SE2")+SE5->(E5_CLIFOR+E5_LOJA+E5_PREFIXO+E5_NUMERO+E5_PARCELA+E5_TIPO))
        	  aAdd(_aVetfor,{SE2->E2_NUM,SE2->E2_TIPO,DTOC(SE2->E2_EMISSAO),ALLTRIM(SE2->E2_NOMFOR)})
        
        	  DbSelectArea("SE5")
        	  DBGOTOP()
              _cQueryc := "SELECT SE5.E5_CLIFOR,SE5.E5_LOJA,SE5.E5_PREFIXO,SE5.E5_NUMERO,"
              _cQueryc += " SE5.E5_PARCELA,SE5.E5_TIPO,SE5.E5_RECPAG"
	          _cQueryc += " FROM " + RetSqlName( "SE5" ) + " SE5 "
              _cQueryc += " WHERE SE5.E5_IDENTEE ='" +cCompCan+"' AND "
              _cQueryc += " SE5.E5_SITUACA = ' ' And SE5.D_E_L_E_T_ = ' '"

              If Select("TM2") > 0
                 DbSelectArea("TM2")
                 DbCloseArea()
              Endif

              TcQuery _cQueryc New Alias "TM2"
              DbSelectArea("TM2")
              DBGOTOP()             
              DO WHILE TM2->(!Eof())
                
                  IF TM2->E5_RECPAG == "R"
                 
                        DbSelectArea("SE1")
			            DbSetOrder(2)
			            DbSeek(xFilial("SE1")+TM2->(E5_CLIFOR+E5_LOJA+E5_PREFIXO+E5_NUMERO+E5_PARCELA+E5_TIPO))
			            DbSelectArea("SA1")
                        DbSetOrder(1)
         	            DbSeek(xFilial("SA1")+SE1->(E1_CLIENTE+E1_LOJA))
                        
                           aAdd(_aVetcli,{SE1->E1_NUM,SE1->E1_TIPO,DTOC(SE1->E1_EMISSAO),ALLTRIM(SA1->A1_NREDUZ)})
                        
                        DbSelectArea("TM2")
                        DBSKIP()
                        LOOP
              
                  ELSE  
              
                        DbSelectArea("SE2")
			            DbSetOrder(6)
			            DbSeek(xFilial("SE2")+TM2->(E5_CLIFOR+E5_LOJA+E5_PREFIXO+E5_NUMERO+E5_PARCELA+E5_TIPO))
        		        aAdd(_aVetfor,{SE2->E2_NUM,SE2->E2_TIPO,DTOC(SE2->E2_EMISSAO),ALLTRIM(SE2->E2_NOMFOR)})
                        DbSelectArea("TM2")
              
                  ENDIF  
              
                  DbSelectArea("TM2")
		          DbSkip()
         
              ENDDO 
              
              FOR _nD :=1 TO LEN(_aVetfor)
     
                    _cHIST += " CANC COMP.DOC."+_aVetfor[_nD][2]+" NR. "+_aVetfor[_nD][1]+" DE "+_aVetfor[_nD][3]+" FORN : "+_aVetfor[_nD][4]
       
              NEXT _nD

              FOR _nC :=1 TO LEN(_aVetcli)
       
                   _cHISTCLI += " C/DOC."+_aVetcli[_nC][2]+" NR."+_aVetcli[_nC][1]+" DE "+_aVetcli[_nC][3]+" CLIENTE : "+_aVetcli[_nC][4]
               
              NEXT _nC    
         
              _cHIST1 := _cHIST + _cHISTCLI 

              DbSelectArea("TM2")
              DbCloseArea()
        
        ELSE 
       
            DbSelectArea("SE1")
	        DbSetOrder(2)
	        DbSeek(xFilial("SE1")+SE5->(E5_CLIFOR+E5_LOJA+E5_PREFIXO+E5_NUMERO+E5_PARCELA+E5_TIPO))
	        DbSelectArea("SA1")
            DbSetOrder(1)
            DbSeek(xFilial("SA1")+SE1->(E1_CLIENTE+E1_LOJA))
            aAdd(_aVetcli,{SE1->E1_NUM,SE1->E1_TIPO,DTOC(SE1->E1_EMISSAO),ALLTRIM(SA1->A1_NREDUZ)})
           
            DbSelectArea("SE5")
        	DBGOTOP()
              _cQueryc := "SELECT SE5.E5_CLIFOR,SE5.E5_LOJA,SE5.E5_PREFIXO,SE5.E5_NUMERO,"
              _cQueryc += " SE5.E5_PARCELA,SE5.E5_TIPO,SE5.E5_RECPAG"
	          _cQueryc += " FROM " + RetSqlName( "SE5" ) + " SE5 "
              _cQueryc += " WHERE SE5.E5_IDENTEE ='" +cCompCan+"' AND "
              _cQueryc += " SE5.E5_SITUACA = ' ' And SE5.D_E_L_E_T_ = ' '"

            If Select("TM2") > 0
                 DbSelectArea("TM2")
                 DbCloseArea()
            Endif

            TcQuery _cQueryc New Alias "TM2"
            DbSelectArea("TM2")
            DBGOTOP()             
            DO WHILE TM2->(!Eof())
                
                  IF TM2->E5_RECPAG == "R"
                 
                        DbSelectArea("SE1")
			            DbSetOrder(2)
			            DbSeek(xFilial("SE1")+TM2->(E5_CLIFOR+E5_LOJA+E5_PREFIXO+E5_NUMERO+E5_PARCELA+E5_TIPO))
			            DbSelectArea("SA1")
                        DbSetOrder(1)
         	            DbSeek(xFilial("SA1")+SE1->(E1_CLIENTE+E1_LOJA))
                        
                           aAdd(_aVetcli,{SE1->E1_NUM,SE1->E1_TIPO,DTOC(SE1->E1_EMISSAO),ALLTRIM(SA1->A1_NREDUZ)})
                        
                        DbSelectArea("TM2")
                        DBSKIP()
                        LOOP
              
                  ELSE  
              
                        DbSelectArea("SE2")
			            DbSetOrder(6)
			            DbSeek(xFilial("SE2")+TM2->(E5_CLIFOR+E5_LOJA+E5_PREFIXO+E5_NUMERO+E5_PARCELA+E5_TIPO))
        		        aAdd(_aVetfor,{SE2->E2_NUM,SE2->E2_TIPO,DTOC(SE2->E2_EMISSAO),ALLTRIM(SE2->E2_NOMFOR)})
                        DbSelectArea("TM2")
              
                  ENDIF  
              
                  DbSelectArea("TM2")
		          DbSkip()
         
              ENDDO 
              
              DbSelectArea("SE5")
        	  DBGOTOP()
              _cQueryf := "SELECT SE5.E5_CLIFOR,SE5.E5_LOJA,SE5.E5_PREFIXO,SE5.E5_NUMERO,"
              _cQueryf += " SE5.E5_PARCELA,SE5.E5_TIPO,SE5.E5_RECPAG"
	          _cQueryf += " FROM " + RetSqlName( "SE5" ) + " SE5 "
              _cQueryf += " WHERE SE5.E5_IDENTEE ='" +cCompCan+"' AND SE5.E5_RECPAG = 'P'"
              _cQueryf += " AND SE5.E5_SITUACA = 'C' And SE5.D_E_L_E_T_ = ' '"

              IF Select("TM1") > 0
                 DbSelectArea("TM1")
                 DbCloseArea()
              Endif

              TcQuery _cQueryf New Alias "TM1"
              DbSelectArea("TM1")
              DBGOTOP()             
              DO WHILE TM1->(!Eof())
                        
                    DbSelectArea("SE2")
			        DbSetOrder(6)
			        DbSeek(xFilial("SE2")+TM1->(E5_CLIFOR+E5_LOJA+E5_PREFIXO+E5_NUMERO+E5_PARCELA+E5_TIPO))
        		    aAdd(_aVetfor,{SE2->E2_NUM,SE2->E2_TIPO,DTOC(SE2->E2_EMISSAO),ALLTRIM(SE2->E2_NOMFOR)})
                   
                    DbSelectArea("TM1")
                    Dbskip()
              
              Enddo
              FOR _nD :=1 TO LEN(_aVetfor)
     
                    _cHIST += " CANC COMP.DOC."+_aVetfor[_nD][2]+" NR. "+_aVetfor[_nD][1]+" DE "+_aVetfor[_nD][3]+" FORN : "+_aVetfor[_nD][4]
       
              NEXT _nD
              FOR _nC :=1 TO LEN(_aVetcli)
       
                   _cHISTCLI += " C/DOC."+_aVetcli[_nC][2]+" NR."+_aVetcli[_nC][1]+" DE "+_aVetcli[_nC][3]+" CLIENTE : "+_aVetcli[_nC][4]
               
              NEXT _nC    
         
              _cHIST1 := _cHIST + _cHISTCLI 
            
        
        ENDIF
   
   OTHERWISE

      _cHIST1 := "NAO FOI DEFINIDO HISTORICO PARA A OPERACAO,CONTATE A AREA DE SISTEMA"

ENDCASE
 
Restarea(aARECTK)
RestArea(aAreaSE5)

RETURN(_cHIST1)
