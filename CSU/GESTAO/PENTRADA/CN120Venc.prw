#Include 'Rwmake.ch'

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³CN120VENC ºAutor  ³ Sergio Oliveira    º Data ³  Jan/2009   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDescricao ³ Ponto de entrada para validar o encerramento da medicao.   º±±
±±º          ³ Esta sendo utilizado para nao permitir o encerramento da   º±±
±±º          ³ medicao cuja competencia seja superior em 3 meses com rela-º±±
±±º          ³ cao a data do dia.                                         º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ AP                                                         º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

User Function CN120Venc()

Local _lPermit := .t.
Local cEol     := Chr(13)+Chr(10)
Local cData    :='01/'+(CND->CND_COMPET)

/*   
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±± Alterado a validacao do encerramento para a funcao abaixo. ±±   
±± Funcao nao permite o encerramento da medicao cuja          ±±
±± competencia seja superior em 3 meses com relacao a data    ±±
±± do dia atual.           									  ±±
±±ÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ±±
±± DATA:15/01/2013³ Autor: Fernando Barreto				      ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
if DateDiffMonth(dDataBase ,cData) > 3
	_lPermit := .F.
endif
/*

Competencias   Data do Dia( 20090101 ) [ * SubStr(Dtos(Date()),5,2)+'/'+Left(Dtos(Date()),4) = 01/2009 * ]

200809
200810 + 3 = ( 13 ) --| ( A partir de OUTUBRO somar mais tres no mes cai a partir de JANEIRO do proximo ano )
200811 + 3 = ( 14 ) --|
200812 + 3 = ( 15 ) --|
200901  (13)       <--| 200813
200902  (14)       <--| 200814
200903  (15)       <--| 200815



nMesC := Val( Left(CND->CND_COMPET,2) )
nMesD := Val( SubStr( Dtos(dDataBase),5,2)  ) // Date()
nAnoC := Val( Right(CND->CND_COMPET,4) )

If nMesC < 10 .And. Val( Right(CND->CND_COMPET,4) ) == Year( dDataBase ) // <- Ate o mes de setembro, verificar normalmente
   If nMesC > nMesD + 2
      _lPermit := .f.
   EndIf
Else                        // <- Transicao de Ano
   If Val( Right(CND->CND_COMPET,4) ) == Year( dDataBase ) // Date
      _lPermit := .t.       // Out/Nov/Dez - Depois de setembro, permitir estes meses no mesmo ano.
   Else
	  If nMesD - nMesC < 10 // Excedeu 3 meses
	     _lPermit := .f.
	  EndIf
   EndIf
EndIf   */

If !_lPermit
    cTxtBlq := "Nao e possivel encerrar medicoes cuja competencia x data do dia seja superior em tres meses!"
	Aviso("COMPETENCIA EXCEDIDA",cTxtBlq,;
		{"&Fechar"},3,"Periodo Inválido",,;
		"PCOLOCK")
EndIf
          
Return( _lPermit )