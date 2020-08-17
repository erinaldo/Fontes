#Include 'Rwmake.ch'

/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �POEPRJ    �Autor  � Sergio Oliveira    � Data �  Jun/2006   ���
�������������������������������������������������������������������������͹��
���Desc.     � Verifica os rdmakes que estao no projeto e inclui na tabe- ���
���          � la de documentacao de Rdmakes (FA5).                       ���
�������������������������������������������������������������������������͹��
���Uso       � Vitarella.                                                 ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/

User Function PoePrj()
                  
cType := "POEPRJ     | *.PRJ"

cArquivo := cGetFile(cType, "Informe o arquivo de Projeto:",,,,GETF_LOCALHARD+GETF_LOCALFLOPPY+GETF_NETWORKDRIVE)

If Aviso('Processamento','Deseja Realmente processar o Projeto?',{'Abanconar','Confirmar'}) == 1
   Return
EndIf    

OkProc(cArquivo)

Return
      
/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Funcao    � OkrProc  �Autor  � Sergio Oliveira    � Data �  Jun/2006   ���
�������������������������������������������������������������������������͹��
���Desc.     � Verificar o arquivo txt.                                   ���
�������������������������������������������������������������������������͹��
���Uso       � Vitarella.                                                 ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/

Static Function OkProc(pcArquivo)

Private nHdl    := FT_FUse(pcArquivo)
Private cEOL    := CHR(13)+CHR(10)

If nHdl == -1
    MsgAlert("O arquivo de nome "+pcArquivo+" nao pode ser aberto! Verifique os parametros.","Atencao!")    
    Return
Endif

Processa( {|| RunCont() },"Processando o Projeto..." )

Return

/*/
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Fun��o    � RunCount � Autor � Sergio Oliveira    � Data �  Jun/2006   ���
�������������������������������������������������������������������������͹��
���Descri��o � Processamento do programa.                                 ���
�������������������������������������������������������������������������͹��
���Uso       � PoePrj.prw                                                 ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
/*/

Static Function RunCont()
      
Local cRdmk := "", cNotFile := ""
Local nInc  := 0

DbSelectArea('FA5')
DbSetOrder(1)

FT_FGotop()

While ! FT_FEof() 

   cLine := FT_FReadLN()
   
   nAt := At( ".PR",Upper(cLine) )
            
   If nAt > 0
   
      For _y := nAt To 1 Step -1
          If SubStr(cLine,_y,1) == '\'
             Exit
          EndIf
      Next
      
      cRdmk := Upper( SubStr( cLine,_y+1, nAt-1 ) )
      cRdmk := StrTran( cRdmk,".PRW","" )
      cRdmk := StrTran( cRdmk,".PRX","" )
      cRdmk := StrTran( cRdmk,".PRG","" )
/*      
      O trecho abaixo serve para verificar se o arquivo que esta no projeto
      consta no diretorio especificado:
      If !File("\\srv-jbgarq01\publico\microsiga\PMT_2005\sergio\rdmake\vitarella\"+cRdmk)
          cNotFile += cRdmk+Chr(13)+Chr(10)
      EndIf
*/      
      DbSelectArea('FA5')
      If !DbSeek( xFilial('FA5')+cRdmk )
         RecLock('FA5',.t.)
         FA5->FA5_FILIAL := xFilial('FA5') 
         FA5->FA5_RDMAKE := cRdmk
         MsUnLock()
         nInc ++
      EndIf
   EndIf

   FT_FSkip()

EndDo

FT_FUse()

Alert('Numero de inclusoes: '+Str(nInc))

Return

User Function RunCount2()

Local cProjeto   := MemoRead('c:\transfer\rdmkprod\rdmake 710 - vitarella.prj')
Local aDirectory := Directory("\\srv-jbgarq02\publico\microsiga\PMT_2005\sergio\rdmake\vitarella\*.pr*")
Local cNotFile   := ""

For _i := 1 To Len(aDirectory)

    If At( Upper(aDirectory[_i][1]), Upper(cProjeto) ) == 0
       cNotFile += Upper(aDirectory[_i][1])+Chr(13)+Chr(10)
    EndIf

Next

MemoWrite('c:\transfer\rdmkprod\notfound.txt',cNotFile)

Return