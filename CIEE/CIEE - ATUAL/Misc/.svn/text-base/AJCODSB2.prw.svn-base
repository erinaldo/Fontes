#INCLUDE "rwmake.ch"

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³AJCODSB2  º Autor ³ CLAUDIO BARROS     º Data ³  04/08/05   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDescricao ³ Rotina para alteracao do registros duplicados na           º±±
±±º          ³ tabela SB2010, para alteração de almox.                    º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ AP6 IDE                                                    º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/

User Function AJCODSB2()


//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Declaracao de Variaveis                                             ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

Local cQuery := " "
Private cString := ""

dbSelectArea("SB2")
dbSetOrder(1)
                 

cQuery := " SELECT   B2_COD,  COUNT(*) FROM "+RetSqlName("SB2")+" "  
cQuery += " WHERE D_E_L_E_T_ = ' ' AND B2_FILIAL = '"+xFilial("SB2")+"' "
//cQuery += " AND B2_COD = '01.0.090' "
cQuery += " GROUP BY B2_FILIAL, B2_COD HAVING COUNT(*) > 1 "
cQuery += " ORDER BY B2_COD "
cQuery := ChangeQuery(cQuery)
dbUseArea(.T.,"TOPCONN",TcGenQry(,,cQuery),'TRV',.T.,.T.)

WHILE !TRV->(EOF()) 
       AJCODSB2A(TRV->B2_COD)
       TRV->(DBSKIP())
END       

If Select("TRV") > 0
   TRV->(DBCLOSEAREA())
EndIf   

AJCODSB2C()

MsgInfo("Processamento OK!!!!!")
      

Return



STATIC FUNCTION AJCODSB2A(pCodigo)

Local cQuery := " "
Local cFl    := CHR(13)+CHR(10) 
Local nReg := 0

cQuery := " SELECT   B2_COD, B2_LOCAL , B2_QATU, R_E_C_N_O_  FROM "+RetSqlName("SB2")+" "  
cQuery += " WHERE D_E_L_E_T_ = ' ' AND B2_FILIAL = '"+xFilial("SB2")+"' "
cQuery += " AND B2_COD = '"+pCodigo+"' "
cQuery += " ORDER BY B2_COD, B2_LOCAL "
cQuery := ChangeQuery(cQuery)
dbUseArea(.T.,"TOPCONN",TcGenQry(,,cQuery),'TRI',.T.,.T.)


While !TRI->(EOF()) 

      IF TRI->B2_QATU == 0 
         nReg := TRI->R_E_C_N_O_
      ENDIF
      TRI->(DBSKIP())
End      
      
IF  nReg > 0 
    AJCODSB2B(nReg)
Endif    
      

If Select("TRI") > 0 
   TRI->(DBCLOSEAREA())
Endif   

      
      
Return


Static Function AJCODSB2B(pReg)


Local _cQuery := " "


_cQuery := " UPDATE "+RetSqlName("SB2")+" SET D_E_L_E_T_ = '*' "
_cQuery += " WHERE D_E_L_E_T_ = ' ' AND R_E_C_N_O_ = '"+str(pReg)+"'  "
tCSqlexec(_cQuery)



Return


Static Function AJCODSB2C()


Local _cQuery := " "


_cQuery := " UPDATE "+RetSqlName("SB2")+" SET B2_LOCAL = '01' "
_cQuery += " WHERE D_E_L_E_T_ = ' ' AND B2_LOCAL <> '01'  "
tCSqlexec(_cQuery)


Return
