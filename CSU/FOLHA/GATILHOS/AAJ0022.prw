/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÅÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡…o    ³ GPM040CO ³ Autor ³ Adalberto Althoff          ³ Data ³ 14/02/05 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³ Validacao do inicio do calculo de rescisao                      ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³ Especifico CSU                                                  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³         ATUALIZACOES SOFRIDAS DESDE A CONSTRU€AO INICIAL.                  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÅÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Programador      ³ Data   ³  OS  ³  Motivo da Alteracao                     ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÅÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Isamu           ³27/04/05³095005³ idade do Funcionário                     ´±±
±±³                 ³        ³      ³ Caso tenha 40 anos ou mais, terá mensagem´±±
±±³ Isamu           ³26/06/06³160606³ Verifica se o funcionário é portador de  ´±±
±±³                 ³        ³      ³ deficiencia fisica                       ´±±                                       
±±³ Sandra          ³24/07/06³160606³ Verifica se funcionario tem estabilidade ´±±                                       
±±³                 ³        ³      ³ e o motivo.                              ´±±                                       
±±³ Alexandre Souza ³18/07/07³      ³ Verifica se funcionario tem os dois perí-´±±                                       
±±³                 ³        ³      ³ odos                                     ´±±                                       
±±ÀÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß*/

User Function GPM040CO


_aArea    := GetArea()
_Valida   := .T.
_DataDem  := dDataDem1    
_DataEst  := SRA->RA_DTVTEST 
_motivo   := ' '


IF SRA->RA_VCTOEXP >= DDATADEM1 .AND. !(CTIPRES$"08,14")
	_Valida := MSGYESNO("Confirma rescisão de funcionário em experiência com cód "+ctipres+" ?")
endif

IF SRA->RA_VCTEXP2 >= DDATADEM1 .AND. !(CTIPRES$"08,14")
	_Valida := MSGYESNO("Confirma rescisão de funcionário em experiência com cód "+ctipres+" ?")
endif


If (_DataDem - Sra->Ra_Nasc)  > 14610            
	_Valida := MsgYesNo("O Funcionário tem mais de 40 anos !!!. Deseja continuar ??? ")
Endif     

If Sra->Ra_DefiFis == "1"
	_Valida := MsgYesNo("O Funcionário é portador de Deficiencia Fisica !!!. Deseja continuar ??? ")
Endif

//OS 1606/06 - SRP 
If _DataEst >= _Datadem 
   If SRA->RA_MOTESTB = "1"
      _motivo := "Ferias" 
   Elseif SRA->RA_MOTESTB = "2"
	  _motivo := "Maternidade" 
   Elseif SRA->RA_MOTESTB = "3"
	  _motivo := "CIPA" 
   Elseif SRA->RA_MOTESTB = "4"
	  _motivo := "Ac. Trabalho" 
   Elseif SRA->RA_MOTESTB = "5"
	  _motivo := "Doenca" 
   Elseif SRA->RA_MOTESTB = "6"
	  _motivo := "Aposentadoria"    
   Elseif SRA->RA_MOTESTB = "7"
	  _motivo := "Outros Motivos"
   Elseif SRA->RA_MOTESTB = "9"
	  _motivo := "CityHall" 	  
   Else 
      _motivo := "Não Informado"
   Endif 	                             

   _msg := "Funcionario com data de Estabilidade até: " + dtoc(SRA->RA_DTVTEST)+ ". Motivo Cadastro: " + _motivo +". Verifique!!! "
   _Valida := MsgYesNo(_msg + "Deseja continuar ?")

Endif   

RestArea(_aArea) //Retorna o ambiente inicial

Return(_Valida) 