#Include "rwmake.ch"

/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �SF2460i   �Autor  �                    � Data �  24/08/04   ���
�������������������������������������������������������������������������͹��
���Descricao �  Ponto de entrada para atender necessidade especifica de   ���
���          �  Grava��o de Campos Especificos na Nota Fiscal de Saida    ���
���          �  e Titulos a Receber.                                      ���
�������������������������������������������������������������������������͹��
���Uso       � Csu CardSystem                                             ���
�������������������������������������������������������������������������ͼ��
�� Atualiza��o : 10/01/07 - Ednei C. Mauriz - Desabilitado Grava��o       ���
�� a partir dos campos C5_ITEM/C5_CLVL passando a ser gravado do SD2      ���
��                                                                        ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/

User Function SF2460i

/*����������������������������������������������������������������������������Ŀ
  �                 Declara as Variaveis Utilizadas na Rotina                  �
  ������������������������������������������������������������������������������*/

Local aArea    :=        GetArea() 
Local aAreaD2  := SD2->( GetArea() )
Local aAreaF2  := SF2->( GetArea() )
Local aAreaC5  := SC5->( GetArea() )
Local aAreaE1  := SE1->( GetArea() )
Local nRecPrin := 0
Local cKey1    := ""
Local cKey2    := ""
Local cParcela := ""
Local cCodArea := ""

/*����������������������������������������������������������������������������Ŀ
  �              Posiciona na Tabela de Itens da Nota Fiscal de Saida          �
  ������������������������������������������������������������������������������*/

DbSelectArea("SD2")
DBSetOrder(3) 

If DbSeek( xFilial () + SF2->F2_DOC + SF2->F2_SERIE + SF2->F2_CLIENTE + SF2->F2_LOJA , .F. ) 

    _cCCusto    := SD2->D2_CCUSTO
    _cItemD     := SD2->D2_ITEMD
    _cClasseD	:= SD2->D2_CLVLDB
	
/*����������������������������������������������������������������������������Ŀ
  �            Posiciona na Tabela de Cabecalho de Pedido de Vendas            �
  ������������������������������������������������������������������������������*/

   DbSelectArea("SC5")
   
   If DbSeek( xFilial() + SD2->D2_PEDIDO, .F. )

      cCodArea := Posicione( "SBM" , 1 ,xFilial("SBM") + SC5->C5_AREA , "BM_TIPGRU" )
      
   /*����������������������������������������������������������������������������Ŀ
     �      Grava os campos especificos no Cabecalho da Nota Fiscal de Saida      �
     ������������������������������������������������������������������������������*/

      DbSelectArea("SF2")
      Reclock( "SF2" , .F. )
       SF2->F2_AREA    := SC5->C5_AREA
	   SF2->F2_CODAREA := cCodArea
      MsUnlock()
   
	/*����������������������������������������������������������������������������Ŀ
     �      Grava os campos no item da Nota Fiscal de Saida / OS 2206/15           �
     ������������������������������������������������������������������������������*/

      DbSelectArea("SD2")
      Reclock( "SD2" , .F. )
       SD2->D2_GRUPO    := SC5->C5_AREA 
	
	/*�������������������������������������������������������������������������Ŀ
     � OS 3406/15 - Eduardo Dias/Totvs - Gravar Numero de Resgate da MKTSystem �
     ��������������������������������������������������������������������������*/
       SD2->D2_X_RESG	:= SC5->C5_X_RESG     
              
      MsUnlock()

   /*����������������������������������������������������������������������������Ŀ
     �             Grava os campos especificos no Titulo a Receber                �
     ������������������������������������������������������������������������������*/

      DbSelectArea("SE1")
      Reclock("SE1" , .F. )
      SE1->E1_AREAN       := SC5->C5_AREA
      SE1->E1_CODAREA     := cCodArea
	  SE1->E1_COMPETE     := SC5->C5_COMPETE
 	  SE1->E1_CSCUSTO     := _cCCusto   
	  SE1->E1_ITEMD       := _cItemD
	  SE1->E1_CLVLDB      := _cClasseD
	  
      MsUnlock()
                                       
	  nRecPrin := SE1->( Recno() )
      cKey1    := SE1->E1_FILIAL + SE1->E1_PREFIXO + SE1->E1_NUM + SE1->E1_PARCELA 
      cKey2    := SE1->E1_CLIENTE + SE1->E1_LOJA + DTOS( SE1->E1_EMISSAO ) 
      cParcela := SE1->E1_PARCELA
		
	EndIf

EndIf         


/*����������������������������������������������������������������������������Ŀ
  �      Caso haja Titulos de Impostos Derivados Desta Parcela , Atualiza      �
  ������������������������������������������������������������������������������*/

DbSelectArea("SE1")
DbSetOrder(1)

Dbseek( cKeySe1 := xFilial() + SF2->F2_PREFIXO + SF2->F2_DOC + cParcela ) 

/*����������������������������������������������������������������������������Ŀ
  �         Processa Todos os Titulos Relacionados ao Principal                �
  ������������������������������������������������������������������������������*/

Do While SE1->( !Eof() ) .And. SE1->E1_FILIAL + SE1->E1_PREFIXO + SE1->E1_NUM + SE1->E1_PARCELA == cKeySe1 
   If SE1->E1_CLIENTE + SE1->E1_LOJA + DTOS(SE1->E1_EMISSAO) == cKey2
      If SE1->( Recno() ) <> nRecPrin
         If SE1->(Reclock(Alias(), .F. ) )
                SE1->E1_CODAREA   := cCodArea
  	           	SE1->E1_COMPETE   := SC5->C5_COMPETE
                SE1->E1_CSCUSTO   := _cCCusto   
	         	SE1->E1_ITEMD     := _cItemD
	            SE1->E1_CLVLDB    := _cClasseD
	            SE1->E1_AREAN     := SC5->C5_AREA  // OS 2206/15 - Douglas 
            SE1->( MsUnlock() )
         Endif
   Endif
Endif
   SE1->( DbSkip(1) )
Enddo      
     
/*����������������������������������������������������������������������������Ŀ
  �         Restaura as Areas Utilizadas antes da Execucao da Rotina           �
  ������������������������������������������������������������������������������*/

RestArea( aAreaD2)
RestArea( aAreaF2)
RestArea( aAreaC5)
RestArea( aAreaE1)
RestArea( aArea )

Return