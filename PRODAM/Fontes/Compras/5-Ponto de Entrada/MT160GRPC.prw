#Include 'Protheus.ch'

User Function MT160GRPC()

SC7->C7_XDESCCO := Posicione("SB1",1,xFilial("SB1")+SC7->C7_PRODUTO,"B1_XDESCCO")
SC7->C7_XDESCCC := Posicione("CTT",1,xFilial("CTT")+SC7->C7_CC,"CTT_DESC01")

Return NIL

