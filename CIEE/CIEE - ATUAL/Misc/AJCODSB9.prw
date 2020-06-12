#INCLUDE "rwmake.ch"

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³AJCODSB9  º Autor ³ CLAUDIO BARROS     º Data ³  04/08/05   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDescricao ³ Rotina para alteracao do registros duplicados na           º±±
±±º          ³ tabela SB9010, para alteração de almox.                    º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ AP6 IDE                                                    º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/







User Function AJCODSB9()


Local lRet
Local _nData := {}

AADD(_nData,'20030531')
AADD(_nData,'20040331')
AADD(_nData,'20050228')
AADD(_nData,'20050731')
AADD(_nData,'20031130')
AADD(_nData,'20050430')
AADD(_nData,'20021031')
AADD(_nData,'20040831')
AADD(_nData,'20050131')
AADD(_nData,'20041130')
AADD(_nData,'20040227')
AADD(_nData,'20050630')
AADD(_nData,'20021231')
AADD(_nData,'20040531')
AADD(_nData,'20030930')
AADD(_nData,'20040430')
AADD(_nData,'20050331')
AADD(_nData,'20041031')
AADD(_nData,'20031031')
AADD(_nData,'20040731')
AADD(_nData,'20040930')
AADD(_nData,'20030731')
AADD(_nData,'20040130')
AADD(_nData,'20030630')
AADD(_nData,'20050301')
AADD(_nData,'20030831')
AADD(_nData,'20041231')
AADD(_nData,'20031231')
AADD(_nData,'20050531')
AADD(_nData,'20040630')


If Len(_nData) > 0
   For I=1 To Len(_nData)
            AJCODSB9A(_nData[I])
   Next
Endif

AJCODALL()
AJCODSB9D()

MsgInfo("Processamento OK!!!!!")

Return   
   


Static Function AJCODSB9A(pData)


//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Declaracao de Variaveis                                             ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

Local cQuery := " "
Private cString := ""

dbSelectArea("SB9")
dbSetOrder(1)
                 

cQuery := " SELECT   B9_COD,  COUNT(*) FROM "+RetSqlName("SB9")+" "  
cQuery += " WHERE D_E_L_E_T_ = ' ' AND B9_FILIAL = '"+xFilial("SB9")+"' "
cQuery += " AND B9_DATA = '"+pData+"' "
//cQuery += " AND B9_COD = '01.0.090' "
cQuery += " GROUP BY B9_FILIAL, B9_COD HAVING COUNT(*) > 1 "
cQuery += " ORDER BY B9_COD "
cQuery := ChangeQuery(cQuery)
dbUseArea(.T.,"TOPCONN",TcGenQry(,,cQuery),'TRV',.T.,.T.)

WHILE !TRV->(EOF()) 
       AJCODSB9B(TRV->B9_COD,pData)
       TRV->(DBSKIP())
END       

If Select("TRV") > 0
   TRV->(DBCLOSEAREA())
EndIf   


     

Return



STATIC FUNCTION AJCODSB9B(pCodigo,pData)

Local cQuery := " "
Local cFl    := CHR(13)+CHR(10) 
Local nReg := 0

cQuery := " SELECT   B9_COD, B9_LOCAL , B9_QINI, R_E_C_N_O_  FROM "+RetSqlName("SB9")+" "  
cQuery += " WHERE D_E_L_E_T_ = ' ' AND B9_FILIAL = '"+xFilial("SB9")+"' "
cQuery += " AND B9_COD = '"+pCodigo+"' AND B9_DATA = '"+pDATA+"' "
cQuery += " ORDER BY B9_COD, B9_LOCAL "
cQuery := ChangeQuery(cQuery)
dbUseArea(.T.,"TOPCONN",TcGenQry(,,cQuery),'TRI',.T.,.T.)


While !TRI->(EOF()) 

      IF TRI->B9_QINI == 0 
         nReg := TRI->R_E_C_N_O_
      ENDIF
      TRI->(DBSKIP())
End      
      
IF  nReg > 0 
    AJCODSB9C(nReg)
Endif    
      

If Select("TRI") > 0 
   TRI->(DBCLOSEAREA())
Endif   

      
      
Return


Static Function AJCODSB9C(pReg)


Local _cQuery := " "


_cQuery := " UPDATE "+RetSqlName("SB9")+" SET D_E_L_E_T_ = '*' "
_cQuery += " WHERE D_E_L_E_T_ = ' ' AND R_E_C_N_O_ = '"+str(pReg)+"'  "
tCSqlexec(_cQuery)


Return



Static Function AJCODALL()


Local _cQuery := " "


// Altera Almoxarifado SC1 
_cQuery := " UPDATE "+RetSqlName("SC1")+" SET C1_LOCAL = '01' "
_cQuery += " WHERE D_E_L_E_T_ = ' '  "
tCSqlexec(_cQuery)


// Altera Almoxarifado SC7 
_cQuery := " UPDATE "+RetSqlName("SC7")+" SET C7_LOCAL = '01' "
_cQuery += " WHERE D_E_L_E_T_ = ' '  "
tCSqlexec(_cQuery)


// Altera Almoxarifado SD1 
_cQuery := " UPDATE "+RetSqlName("SD1")+" SET D1_LOCAL = '01' "
_cQuery += " WHERE D_E_L_E_T_ = ' '  "
tCSqlexec(_cQuery)

// Altera Almoxarifado SD1 
_cQuery := " UPDATE "+RetSqlName("SD3")+" SET D3_LOCAL = '01' "
_cQuery += " WHERE D_E_L_E_T_ = ' '  "
tCSqlexec(_cQuery)

// Altera Almoxarifado SI3 
_cQuery := " UPDATE "+RetSqlName("SI3")+" SET I3_LOCAL = '01' "
_cQuery += " WHERE D_E_L_E_T_ = ' '  "
tCSqlexec(_cQuery)

// Altera Almoxarifado SB7 
_cQuery := " UPDATE "+RetSqlName("SB7")+" SET B7_LOCAL = '01' "
_cQuery += " WHERE D_E_L_E_T_ = ' '  "
tCSqlexec(_cQuery)

// Altera Almoxarifado SB1 
_cQuery := " UPDATE "+RetSqlName("SB1")+" SET B1_LOCPAD = '01' "
_cQuery += " WHERE D_E_L_E_T_ = ' '  "
tCSqlexec(_cQuery)


Return


Static Function AJCODSB9D()


Local _cQuery := " "


_cQuery := " UPDATE "+RetSqlName("SB9")+" SET B9_LOCAL = '01' "
_cQuery += " WHERE D_E_L_E_T_ = ' ' AND B9_LOCAL <> '01'  "
tCSqlexec(_cQuery)


Return
