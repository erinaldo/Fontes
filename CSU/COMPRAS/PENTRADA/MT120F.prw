#Include 'Rwmake.ch'

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³MT120F    ºAutor  ³ Sergio Oliveira    º Data ³  Jan/2009   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDescricao ³ Ponto de entrada apos a gravacao do pedido de compras antesº±±
±±º          ³ do fechamento da transacao. Esta sendo utilizado para gra- º±±
±±º          ³ var a data do vencimento do pedido de compras quando este  º±±
±±º          ³ estiver sendo gerado por alguem da area de procurement.    º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ CSU                                                        º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

User Function MT120F()

Local _aArea := GetArea(), _aAreaSY1 := SY1->( Getarea() ), _aAreaSC7 := SC7->( Getarea() )

If SY1->( DbSetOrder(3), DbSeek( xFilial('SY1')+__cUserId ) )

   SC7->( DbSetOrder(1), DbSeek( ParamIxb ) )

   While !SC7->( Eof() ) .And. SC7->( C7_FILIAL+C7_NUM ) == ParamIxb
   
         SC7->( RecLock('SC7',.f.) )
         SC7->C7_X_DVENC := Condicao(10,SC7->C7_COND,,SC7->C7_EMISSAO)[1][1]
         SC7->( MsUnLock() )
   
         SC7->( DbSkip() )
   
   EndDo

EndIf

_dVencto := Nil // Destruir a variavel somente por seguranca.

SY1->( RestArea( _aAreaSY1 ) )
SC7->( RestArea( _aAreaSC7 ) )
RestArea( _aArea )

Return