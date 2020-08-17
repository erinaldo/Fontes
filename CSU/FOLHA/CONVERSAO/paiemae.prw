#include "rwmake.ch"

User Function paiemae()

/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �PAIEMAE   |Autor  � Isamu Kawakami     � Data �  09/06/04   ���
�������������������������������������������������������������������������͹��
���Descricao �Os nomes dos pais est�o junto com os demais dependentes,    ���
���          �que foram importados do arquivo de Dependentes da RM.       ���
���          �Esse programa far� a inclus�o dos nomes dos pais no cadastro���
���          �de funcion�rios.                                             ���
�������������������������������������������������������������������������͹��
���Uso       � EXCLUSIVO PARA CSU                                         ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/

DBSELECTAREA("SRB")
DBSETORDER(1)
DBGOTOP()		// POSICIONA NO PRIMEIRO REGISTRO DOS DEPENDENTES.

//IF SRB->(DBSEEK(SRA->RA_FILIAL+SRA->RA_MAT))	// NAO PRECISO DESTAS DUAS LINHAS POIS EU JA ESTOU POSICIONADO NO INICIO DO CADASTRO DE DEPENDENTES.
//  WHILE !EOF() .AND. SRB->RB_FILIAL+SRB->RB_MAT==SRA->RA_FILIAL+SRA->RA_MAT

WHILE !EOF()		// VAI FAZER AT� TERMINAR DE CHECAR O CADASTRO INTEIRO DOS DEPENDENTES
	
	IF SRB->RB_GRAUPAR=="O"
		
		IF SRB->RB_SEXO=="F"
			DBSELECTAREA("SRA")							 // ABRO O CADASTRO DE FUNCIONARIOS
			DBSETORDER(1)
			//DBGOTOP()								 // PESQUISA O FUNCIONARIO PELA MATRICULA DO FUNCIONARIO NO CADASTRO DOS DEPENDENTES.
			IF SRA->(DBSEEK(SRB->RB_FILIAL+SRB->RB_MAT)) // ALTEREI O NOME DO CAMPO FILIAL
				IF EMPTY(sra->RA_MAE)
				RECLOCK("SRA",.F.)
				SRA->RA_MAE := SRB->RB_NOME
				MSUNLOCK()
				ENDIF
			ENDIF							// INCLUI O IF POIS SE NAO ACHAR O FUNCIONARIO NAO FAZ NADA.
		ENDIF								// ISSO SO PODE ACONTECER SE O DEPENDENTE NAO TIVER FUNCIONARIO VINCULADO. 
		
		IF SRB->RB_SEXO=="M"
			DBSELECTAREA("SRA")							 // ABRO O CADASTRO DE FUNCIONARIOS
			DBSETORDER(1)
			//DBGOTOP()								 // PESQUISA O FUNCIONARIO PELA MATRICULA DO FUNCIONARIO NO CADASTRO DOS DEPENDENTES.
			IF SRA->(DBSEEK(SRB->RB_FILIAL+SRB->RB_MAT)) // ALTEREI O NOME DO CAMPO FILIAL
				IF EMPTY(sra->RA_PAI)
				RECLOCK("SRA",.F.)
				SRA->RA_PAI := SRB->RB_NOME 
				MSUNLOCK()
				ENDIF
			ENDIF							// INCLUI O IF POIS SE NAO ACHAR O FUNCIONARIO NAO FAZ NADA.
		ENDIF								// ISSO SO PODE ACONTECER SE O DEPENDENTE NAO TIVER FUNCIONARIO VINCULADO. 
		
	ENDIF
	DBSELECTAREA("SRB")		// RETORNA PARA O CADASTRO DE DEPENDENTES
	DBSKIP()				// AVANCO PARA O PROXIMO REGISTRO.
	
ENDDO
     #IFDEF WINDOWS
    MsgAlert ("Importacao Finalizada")
 #ELSE
    Alert("Importacao Finalizada")
 #ENDIF        

//ENDIF        

 
 
Return 