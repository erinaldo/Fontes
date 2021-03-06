#Include "rwmake.ch"

/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �VRVTFOL   �Autor  �Isamu Kawakami      � Data �  29/06/05   ���
�������������������������������������������������������������������������͹��
���Desc.     �Calculo de Beneficios (VR e VT) em dias que funcionario     ���
���          �trabalhar em dias de Folga                                  ���
�������������������������������������������������������������������������͹��
���Uso       � Especifico CSU                                             ���
�������������������������������������������������������������������������͹��
���Alteracoes� OS 0323/14-Adaptar busca dos valores de Vr e Vt nas novas  ���
���          � tabelas criadas  (ZTA, ZT6, ZT8)                           ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/

User Function VRVTFOL()

Local nValVR     := 0
Local nValVt     := 0            
Local cCodVr     := "" 
Local cQy  
Local cQ1     
Local cFil_      := Sra->Ra_filial
Local cMat_      := Sra->Ra_Mat
Private nDiasFolga := fBuscaPD("820","H")
 
If Sra->Ra_Sitfolh # "D" .and. nDiasFolga > 0
   //Busca o valor de VR
   cQy := " SELECT ZT8_VALOR AS VALREF_ "
   cQy += " FROM "+RetSQLName("ZT6")+","+RetSQLName("ZT8")+" "           
   cQy += " WHERE ZT6_FILIAL='"+cFil_+"' AND ZT6_MAT='"+cMat_+"' "
   cQy += " AND ZT8_COD=ZT6_COD "
   cQy += " AND ZT8_COD <= '300' "
   cQy += " AND "+RetSQLName("ZT6")+".D_E_L_E_T_ <> '*' "
   cQy += " AND "+RetSQLName("ZT8")+".D_E_L_E_T_ <> '*' "
    
   //�������������������������������������Ŀ
   //� Verifica se nao esta aberto o alias �
   //���������������������������������������
   If Select("TZR") >0
	  DBSelectArea("TZR")
	  DBCloseArea()
   EndIf         
   
   dbUseArea(.T.,"TOPCONN", TCGENQRY(,,cQy),"TZR",.F.,.T.)
   
   If Tzr->(Eof())
      dbSkip()
   Else
      nValVr := Tzr->ValRef_
      //Conf. retifica��o da OS, a verba 070 deve ser gerada para todas as filiais
      fGeraVerba("070",nDiasFolga*nValVR,nDiasFolga,,,,,,,,.T.)
   Endif
 
   //Gera valores para trabalho em Folga
   //If Sra->Ra_filial == "07"
      //fGeraVerba("070",nDiasFolga*nValVR,nDiasFolga,,,,,,,,.T.)
   //Else 
      //fGeraVerba("100",nDiasFolga*nValVR,nDiasFolga,,,,,,,,.T.)
   //Endif                                     
   
   //Busca Valores de VT
   cQ1 := " SELECT ZTA_QDEDIA AS QTDIA_, RN_VUNIATU AS VALVT_ "
   cQ1 += " FROM "+RetSQLName("SRN")+","+RetSQLName("ZTA")+" "    
   cQ1 += " WHERE ZTA_FILIAL = '"+cFil_+"' AND ZTA_MAT = '"+cMat_+"' "
   cQ1 += " AND ZTA_COD = RN_COD "
   cQ1 += " AND "+RetSQLName("SRN")+".D_E_L_E_T_ <> '*' "
   cQ1 += " AND "+RetSQLName("ZTA")+".D_E_L_E_T_ <> '*' "

   //�������������������������������������Ŀ
   //� Verifica se nao esta aberto o alias �
   //���������������������������������������
   If Select("TZT") >0
	  DBSelectArea("TZT")
	  DBCloseArea()
   EndIf         
   
   dbUseArea(.T.,"TOPCONN", TCGENQRY(,,cQ1),"TZT",.F.,.T.)
   
   If Tzt->(Eof())
      dBSkip()
   Endif

   While !(Tzt->(Eof()))
       nValVT   += Tzt->ValVt_*Tzt->QtDia_
       Tzt->(dbSkip())
   EndDo    

   //Gera valores para trabalho em folga	
   //If Sra->Ra_Filial == "07"
      //fGeraVerba("069",nValVT*nDiasFolga,nDiasFolga,,,,,,,,.T.)
   //Else
      //fGeraVerba("013",nValVT*nDiasFolga,nDiasFolga,,,,,,,,.T.)
   //Endif
   //Conf. retifica��o da OS, a verba 069 deve ser gerada para todas as filiais
   fGeraVerba("069",nValVT*nDiasFolga,nDiasFolga,,,,,,,,.T.)
   
   
Endif	

*---\/--------- OS 2276/05 --aaj240805-------------------------
nDiasFolga := fBuscaPD("829","H")
 
If Sra->Ra_Sitfolh # "D" .and. nDiasFolga > 0
 
   //Gera valores para trabalho em Folga
    fGeraVerba("222",nDiasFolga*nValVR,nDiasFolga,,,,,,,,.T.)
   //Gera valores para trabalho em folga	
	fGeraVerba("235",nDiasFolga*nValVT,nDiasFolga,,,,,,,,.T.)

Endif	
*---/\--------- OS 2276/05 --aaj240805-------------------------

Return("")