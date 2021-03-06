#Include "Rwmake.ch"
#Include "Protheus.ch"

/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  � Fa050Del � Autor � Cristiano Figueiroa� Data �  13/01/2006 ���
�������������������������������������������������������������������������͹��
���Descricao � Ponto de Entrada disparado apos a confirmacao da exclusao  ���
���          � do Titulo.                                                 ���
�������������������������������������������������������������������������͹��
���Uso       � Csu CardSystem                                             ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/

User Function Fa050Del() 

/*����������������������������������������������������������������������������Ŀ
  �               Declara as Variaveis Utilizadas na Rotina                    �
  ������������������������������������������������������������������������������*/

Local nValTit := SE2->E2_VALOR + SE2->E2_ISS + SE2->E2_IRRF + SE2->E2_INSS + SE2->E2_VRETPIS + SE2->E2_VRETCOF + SE2->E2_VRETCSL
Local lReturn := .F.

/*����������������������������������������������������������������������������Ŀ
  �          ------    Desenvolvido pela Csu Anteriormente        -------      �
  ������������������������������������������������������������������������������

         Impossibilitar a Exclusao do Titulo a pagar fora da Data de Emissao
         Alterado :  Roberto Rogerio Mezzalira                                                       

         Motivo OS 2421/05 - Nao permitir a exclusao do titulo quanda a database 
         for diferente da data de emissao do titulo  /*/

IF M->E2_EMISSAO < GetMv("MV_DATAFIN") 											
   Alert("Data de contabiliza��o � posterior ao par�metro MV_DATAFIN.")
   Return(lReturn)
EndIf																		

// Incluido por RRM - 12/05/06 OS 2421/06

If SE2->E2_EMIS1 <> DDATABASE
   Aviso("Operacao invalida","Altere a data base para "+Dtoc(SE2->E2_EMIS1),{"Ok"} ,1,"Nao pode excluir o Titulo ")
   Return(lReturn)
Endif

/*����������������������������������������������������������������������������Ŀ
  �          Caso o Titulo Possua Rateio , Chama a Rotina Customizada          �
  ������������������������������������������������������������������������������*/

If SE2->E2_RATESP == "1"
   // u_RFinA06( SE2->E2_PREFIXO ,  SE2->E2_NUM ,  SE2->E2_PARCELA,  SE2->E2_TIPO ,  SE2->E2_FORNECE ,  SE2->E2_LOJA ,  nValTit , 5 )  
Endif   

Return .T.