    .486                                    ; create 32 bit code
    .model flat, stdcall                    ; 32 bit memory model
    option casemap :none                    ; case sensitive
 
    include \masm32\include\windows.inc     ; always first
    include \masm32\macros\macros.asm       ; MASM support macros
    include \masm32\include\masm32.inc
    include \masm32\include\gdi32.inc
    include \masm32\include\user32.inc
    include \masm32\include\kernel32.inc
    
    includelib \masm32\lib\masm32.lib
    includelib \masm32\lib\gdi32.lib
    includelib \masm32\lib\user32.lib
    includelib \masm32\lib\kernel32.lib
    
.data?

.data
    texto   db      0,13,10,0

    n1      db     'a',255,255,255,255   ; valor do nó, endereço do próximo nó (formato 32 bits)
    inp1    dd      00  ; <--- here
    n3      db     'b',255,255,255,255
    n2      db     'c',255,255,255,255
    n5      db     'd',0,0,0,0
    n4      db     'e',255,255,255,255

.code                       ; Tell MASM where the code starts
start:                      ; The CODE entry point to the program

    call inicializa         ; basicamente, os 4 procedimentos são chamados para inicializar a Lista Ligada,
    call exibelista         ; mostra como ela está, ordená-la e por último, mostrá-la Ordenada
    call ordenacao          ; Rafael Pak Bragagnolo
    call exibelista         ; 18206 - PD18

    exit

inicializa proc                 ; procedimento que inicializa a Lista Ligada

    xor     cl, cl              ; cl recebe quantos Nós a Lista vai ter

    lea     edx, OFFSET n1      ; edx recebe o endereço do primeiro Nó
    add     cl, 1               ; cl é incrementado a cada novo Nó inserido na Lista
    lea     edi, OFFSET n2      ; edi recebe o endereço do segundo Nó
    add     cl, 1
    inc     edx                 ; incrementa edx para armazenar o endereço do segundo Nó no primeiro
    mov     [edx], edi          ; (próximo da lista) primeiro Nó ([edx]) recebe o endereço do segundo Nó
    lea     edx, OFFSET n3      ; edx recebe o endereço do terceiro Nó
    add     cl, 1
    inc     edi                 ; incrementa edx para armazenar o endereço do terceiro Nó no segundo
    mov     [edi], edx          ; segundo Nó ([edi]) recebe o endereço do terceiro Nó
    lea     edi, OFFSET n4      ; edi recebe o endereço do quarto Nó
    add     cl, 1
    inc     edx                 ; incrementa edx para armazenar o endereço do quarto Nó no terceiro
    mov     [edx], edi          ; terceiro Nó ([edx]) recebe o endereço do quarto Nó
    lea     edx, OFFSET n5      ; edx recebe o endereço do quinto Nó
    add     cl, 1
    inc     edi                 ; incrementa edx para armazenar o endereço do quinto Nó no quarto
    mov     [edi], edx          ; quarto Nó ([edi]) recebe o endereço do quinto Nó
  
    ret                         ; retorna para a main proc

inicializa endp

ordenacao proc                  ; procedimento que ordena a Lista Ligada através de Bubble Sort

    xor     ch, ch              ; cria-se um contador com ch, para saber quantas vezes a lista foi percorrida

    inicio:
        cmp     ch, cl              ; comparamos se a Lista já foi percorrida todas as vezes necessárias
        je      fim                 ; finaliza o procedimento, caso tenha correspondido à condição anterior

        add     ch, 1               ; incrementa 1 no contador, pois a Lista foi percorrida 1x
        lea     edx, OFFSET n1      ; edx volta para o início, no primeiro Nó

        for1:
            mov     ebx, [edx + 1]      ; ebx recebe o valor do próximo Nó
            cmp     ebx, 0              ; verifica se o próximo Nó corresponde ao valor do fim da Lista
            je      inicio              ; se for o último Nó, volta para o início do procedimento

            mov     al, byte ptr[edx]   ; al recebe o valor do Nó atual
            push    edx                 ; armazena o endereço do Nó atual
            inc     edx                 ; incrementa o edx
            mov     edx, [edx]          ; edx -> endereço do próximo Nó
            mov     ah, byte ptr[edx]   ; ah recebe o valor do próximo Nó
            cmp     al, ah              ; compara o Nó atual com o próximo
            jg      troca               ; caso o atual seja maior que o próximo, eles vão trocar

            pop     edx                 ; caso não seja, ele retira esse valor
            inc     edx                 ; incrementa o edx
            mov     edx, [edx]          ; edx -> endereço do próximo Nó
            jmp     for1                ; volta ao início do for, para comparar os próximos Nós

    troca:  
        mov     byte ptr[edx], al   ; valor do próximo Nó -> valor do Nó atual
        pop     edx                 ; edx retorna ao endereço do Nó atual
        mov     byte ptr[edx], ah   ; valor do Nó atual -> valor do próximo Nó
        inc     edx                 ; incrementa edx
        mov     edx, [edx]          ; edx -> endereço do próximo Nó
        jmp     for1                ; volta ao for

    fim:
        xor     cl, cl              ; limpa o valor do tamanho da Lista no registrador
        xor     ch, ch              ; limpa o valor do contador no registrador
        
    ret                             ; retorna para a main proc

ordenacao endp

exibelista proc                 ; procedimento de printar a Lista na tela

    print   " ",13,10           ; printa um espaço em branco entre a Lista original e Ordenada (puramente estético)

    lea     edx, OFFSET n1      ; edx recebe o endereço do primeiro Nó
    mov     al, byte ptr [edx]  ; al recebe a informação do primeiro Nó
    inc     edx                 ; aumenta o edx para os próximos bytes do primeiro Nó que vão armazenar o endereço do proximo Nó
    mov     edx, [edx]          ; edx recebe o endereço do segundo Nó
    mov     ah, byte ptr [edx]  ; ah recebe a informação do segundo Nó
    push    edx                 ; guarda o valor atual de edx (endereço do segundo Nó) 
    push    eax                   
    lea     edx, OFFSET texto   ; edx recebe o endereço do texto
    mov     byte ptr[edx], al   ; a informação do texto recebe al (informação do primeiro Nó) 
    print   edx                 ; printa o valor do primeiro Nó na tela
    pop     eax                   
    lea     edx, OFFSET texto   ; edx recebe o novo endereço do texto
    mov     byte ptr[edx], ah   ; a informação do texto recebe ah (informação do segundo Nó)
    print   edx                 ; printa o valor do segundo Nó na tela
    pop     edx                 ; edx volta a ser o endereço do segundo Nó
    inc     edx                 ; aumenta o edx para os próximos bytes do segundo Nó que vão armazenar o endereço do proximo Nó
    mov     edx, [edx]          ; edx recebe o endereço do terceiro Nó
    mov     al, byte ptr [edx]  ; al recebe a informação do terceiro Nó
    inc     edx                 ; aumenta o edx para os próximos bytes do terceiro Nó que vão armazenar o endereço do proximo Nó
    mov     edx, [edx]          ; edx recebe o endereço do quarto Nó
    mov     ah, byte ptr [edx]  ; ah recebe a informação do quarto Nó
    push    edx                 ; guarda o valor atual em edx (endereço do quarto Nó)
    push    eax                   
    lea     edx, OFFSET texto   ; edx recebe o endereço do texto
    mov     byte ptr[edx], al   ; a informação do texto recebe al (informação do terceiro Nó)
    print   edx                 ; printa o valor do terceiro Nó na tela
    pop     eax                   
    lea     edx, OFFSET texto   ; edx recebe o novo endereço de texto
    mov     byte ptr[edx], ah   ; a informação do texto recebe ah (informação do quarto Nó)
    print   edx                 ; printa o valor do quarto Nó na tela
    pop     edx                 ; edx volta a ser o endereço do terceiro Nó
    inc     edx                 ; aumenta o edx para os próximos bytes do quarto Nó que vão armazenar o endereço do proximo Nó
    mov     edx, [edx]          ; edx recebe o endereço do quinto Nó
    mov     al, byte ptr [edx]  ; al recebe a informação do quinto Nó
    lea     edx, OFFSET texto   ; edx recebe o endereço do texto
    mov     byte ptr[edx], al   ; a informação do texto recebe al (informação do quinto Nó)
    print   edx                 ; printa o valor do quinto Nó na tela

    ret                         ; retorna para a main proc

exibelista endp

end start