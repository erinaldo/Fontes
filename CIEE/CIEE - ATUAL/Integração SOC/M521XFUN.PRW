/*
+-----------+-------------+-----------+----------------+------+-------------+
| Programa  | M521XFUN    | Autor     | Fabio Zanchim  | Data |    07/2013  |
+-----------+-------------+-----------+----------------+------+-------------+
| Descricao | Integração SOC x Protheus                              		|
|           | 														 		|
+-----------+---------------------------------------------------------------+
| Uso       | CIEE   														|
+-----------+---------------------------------------------------------------+
*/
Static lShowMsg:=.F.
  
/*
+-----------+-------------+-----------+----------------+------+-------------+
| Programa  | u_M520BROW  | Autor     | Fabio Zanchim  | Data |    07/2013  |
+-----------+-------------+-----------+----------------+------+-------------+
| Descricao | P.E na abertura da tela de exclusao de Doc. de Saida          |
|           | Deixa statica .F. para apresentar msg na proxima exclusao.    |
+-----------+---------------------------------------------------------------+
| Uso       | CIEE   														|
+-----------+---------------------------------------------------------------+
*/
User Function M520BROW()
lShowMsg:=.F.
Return       

/*
+-----------+-------------+-----------+----------------+------+-------------+
| Programa  | u_M521CDEL  | Autor     | Fabio Zanchim  | Data |    07/2013  |
+-----------+-------------+-----------+----------------+------+-------------+
| Descricao | P.E validacao do Doc. de Saida                                |
|           | Para 1a. NF a ser escluido alerto para fazer a transmissao.   |
+-----------+---------------------------------------------------------------+
| Uso       | CIEE   														|
+-----------+---------------------------------------------------------------+
*/
User Function M521CDEL()

If !lShowMsg
	If SF2->F2_SERIE=='RPS' .and. !Empty(SF2->F2_NFELETR)
		lShowMsg:=.T.
		Aviso( "M521CDEL", "Após a exclusão do RPS é necessário fazer a transmissão do cancelamento para a Prefeitura.", {"Ok"}, 2) 
	EndIF
EndIf

Return(.T.)

/*
+-----------+-------------+-----------+----------------+------+-------------+
| Programa  | u_M521DNFS  | Autor     | Fabio Zanchim  | Data |    07/2013  |
+-----------+-------------+-----------+----------------+------+-------------+
| Descricao | Apos exclusão da NF, exclui o RPS de origem SOC               |
+-----------+---------------------------------------------------------------+
| Uso       | CIEE   														|
+-----------+---------------------------------------------------------------+
*/
User Function M521DNFS()
                           
Local nX:=0
Local aArea:=GetArea()
Local aPedidos:=ParamIXB[1]   
Local lPedidos:=.T.
Private lMsErroAuto  :=.F.

lPedidos:=(Len(aPedidos)>0)
IF !lPedidos//Nao esta preenchido com o pedido que teve a NF excluida
	If Empty(SC5->C5_NOTA) .And. !Empty(SC5->C5_XRPSSOC) 
		Aadd(aPedidos,SC5->C5_NUM)
	EndIf
EndIF

For nX:=1 to Len(aPedidos)
              
	dbSelectArea('SC5')
	dbSetOrder(1)
	If dbSeek(xFilial('SC5')+aPedidos[nX])
		If !Empty(C5_XRPSSOC)
		                              
			//Estorna a liberação antes de excluir
			dbSelectArea('SC9')
			dbSetOrder(1)
			If DbSeek( xFilial('SC9')+SC5->C5_NUM )
				a460Estorna()
			EndIf
			
			dbSelectArea('SC5')	
			lMsErroAuto  :=.F.
			MSExecAuto({|x,y,z| Mata410(x,y,z)},{{"C5_NUM",SC5->C5_NUM,NIL}},{},5)
			
			If lMsErroAuto  
				MostraErro()
			EndIf
		EndIf
	EndIf
	
Next nX
      
RestArea(aArea)

Return