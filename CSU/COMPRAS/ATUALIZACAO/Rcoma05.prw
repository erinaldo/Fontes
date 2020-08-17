#Include 'Rwmake.ch'

/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �Rcoma05   �Autor  � Sergio Oliveira    � Data �  Jul/2007   ���
�������������������������������������������������������������������������͹��
���Desc.     � Programa que efetua a manutencao do parametro das naturezas���
���          � para Competencia de NFE.                                   ���
�������������������������������������������������������������������������͹��
���Uso       � CSU                                                        ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/

User Function Rcoma05()
                  
Local _nTamTot := 150
Local _nTamPre := Len( AllTrim( GetMV('MV_X_NATCP') ) )
Local _cEmails := AllTrim( GetMV('MV_X_NATCP') )+Space( _nTamTot - _nTamPre )

@ 222,248 To 373,726 Dialog mkwdlg Title "Excecao de Naturezas para Competencia da NFE"
@ 009,009 To 055,230
@ 030,016 Say OemToAnsi("Digite o Conteudo") Size 131,8
@ 030,065 Get _cEmails  Picture( '@!S' ) Size 150,10
@ 060,190 BMPBUTTON TYPE 1 ACTION (Gravar(_cEmails))
				
Activate Dialog mkwdlg
		
Return                                     

Static Function Gravar(pnVal) 

Close(MkwDlg)

PutMV('MV_X_NATCP' , pnVal )

Return