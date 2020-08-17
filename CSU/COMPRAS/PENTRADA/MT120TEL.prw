#Include 'Protheus.ch'

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³MT120TEL  ºAutor  ³ Sergio Oliveira    º Data ³  Jan/2009   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDescricao ³ Ponto de entrada para criar campos no cabecalho do Pedido  º±±
±±º          ³ de Compras. Esta sendo utilizado para utilizacao da data doº±±
±±º          ³ provavel vencimento do pedido de compras atraves da condi- º±±
±±º          ³ cao de pagamento.                                          º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ CSU - Compras                                              º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

User Function MT120TEL()

Local _aSC7     := SC7->( GetArea() )
Public _dVencto := Date(08)

/*
ParamIxb[1] - Dialogo
ParamIxb[2] - Array com as Coordenadas dos Gets
ParamIxb[3] - aObj(?)
ParamIxb[4] - nOpcx
ParamIxb[5] - Registro
*/

If ParamIxb[4] == 3 .Or. ParamIxb[4] == 6 .Or. ParamIxb[4] == 4 // Inclusao/Alteracao/Copia
    _dVencto := Ctod('')
    If ParamIxb[4] == 6 .Or. ParamIxb[4] == 4                   // Alteracao/Copia

	    SC7->( DbSetOrder(1), DbSeek( xFilial('SC7')+cA120Num ) )

	    _dVencto := SC7->C7_X_DVENC

    EndIf
Else
    
    SC7->( DbSetOrder(1), DbSeek( xFilial('SC7')+cA120Num ) )

    _dVencto := SC7->C7_X_DVENC
    
EndIf

SC7->( RestArea( _aSC7 ) )
    
@ 044,ParamIxb[2][10][2] SAY "Vencimento" OF ParamIxb[1] PIXEL SIZE 030,006 
@ 043,ParamIxb[2][10][2]+40 MSGET oOper VAR _dVencto WHEN .f. OF ParamIxb[1] PIXEL SIZE 045,006 HASBUTTON

Return