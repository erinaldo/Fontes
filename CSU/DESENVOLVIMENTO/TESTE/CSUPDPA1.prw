#INCLUDE "PROTHEUS.CH"
#INCLUDE "rwmake.ch"
/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡…o    ³ CSUPDPA1 ³ Autor ³ Renato Carlos    ³ Data ³ 23/10/2009      	 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³ Programa para ajuste de batidas da tabela PA1                	 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³ Específico CSU                                               	 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/

User Function CSUPDPA1()

Local c_Query := ""
Local c_Chave := ""
Local c_IndPA1 := ""
Local c_2S := "2S"
Local c_4S := "4S"
Local n_Cnt := 0
Local a_AreaAnt := GetArea()


c_Query := "SELECT PA1_FILIAL,PA1_MAT,PA1_DATA FROM "+RetSqlName('PA1')+" "
c_Query += "WHERE PA1_FILIAL IN ('06','12') AND PA1_DATA BETWEEN '20091018' AND '20091022' "
c_Query += "AND D_E_L_E_T_='' " 
c_Query += "GROUP BY PA1_FILIAL,PA1_MAT,PA1_DATA "
c_Query += "HAVING COUNT(1)=4 "
c_Query += "ORDER BY PA1_FILIAL,PA1_MAT,PA1_DATA " 

/*
c_Query := "SELECT PA1_FILIAL,PA1_MAT,PA1_DATA,PA1_HORA FROM "+RetSqlName('PA1')+" "
c_Query += "WHERE PA1_FILIAL IN ('06','12') AND PA1_DATA BETWEEN '20091018' AND '20091022' "
c_Query += "AND D_E_L_E_T_=' ' AND PA1_TPMARC='4S' "
c_Query += "ORDER BY PA1_FILIAL,PA1_MAT,PA1_DATA "
*/
U_MontaView( c_Query, "UPDPA1" )

UPDPA1->(DbGotop())

DbSelectArea("PA1")
c_IndPA1 := Criatrab(Nil,.F.)
c_Chave := "PA1->PA1_FILIAL + PA1->PA1_MAT + PA1->PA1_DATA + PA1->PA1_TPMARC"
IndRegua("PA1",c_IndPA1,c_Chave,,,"Selecionando Registros...")

Procregua( UPDPA1->( RecCount() ) )

While !UPDPA1->(Eof())
    
	IncProc("Executando Update...")

	//IF DbSeek(UPDPA1->PA1_FILIAL + UPDPA1->PA1_MAT + UPDPA1->PA1_DATA + c_4S)
	IF DbSeek(UPDPA1->PA1_FILIAL + UPDPA1->PA1_MAT + UPDPA1->PA1_DATA + c_2S)
	        // Tratar a troca de dia:
	        // Horas gravadas: 
	        //
	        // 22:00
	        // 23:00
	        // 00:00  => Testar se a hora eh igual a 00:00
	        //
	        // Se for igual a 00:00, considerar 24:00
	        //
	        
			RecLock("PA1",.F.)
			cHora := AllTrim(StrZero(PA1->PA1_HORA,4))
			If Left( cHora,2 ) == '00'
				cHora := '23'
				cMin  := Right( cHora,2 )
				PA1->PA1_HORA := Val(cHora + cMin)
			Else
				PA1->PA1_HORA := PA1->PA1_HORA - 1
			EndIf
			PA1->(MsUnLock()) 
    EndIf
	
	UPDPA1->(DbSkip())
	n_Cnt++
EndDo	

UPDPA1->(DbCloseArea())
RestArea(a_AreaAnt)
Alert( 'Concluído. Total de Registros Processados: '+Str(n_Cnt) )

Return Nil
