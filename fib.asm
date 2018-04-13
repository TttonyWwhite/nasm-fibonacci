section .data
    inp1        dq 0
    inp2        dq 0
    msg         db "%ld", 0x0a, 0
    inputmsg    db "Enter a number: ", 0 
    scanfin     db "%d"  
	color_flag 	db 1

    color_red:      db  1Bh, '[31;1m', 0 ;红色
    .len            equ $ - color_red
    color_green:    db  1Bh, '[32;1m', 0 ;绿色
    .len            equ $ - color_green
    color_default:  db  1Bh, '[37;0m', 0 ;控制台默认颜色
    .len            equ $ - color_default  
 
section .text
    global main
    extern printf
    extern scanf
main:
    push    rbp
    mov     rbp, rsp

    ; print inputmsg
    lea     rdi, [inputmsg]  ; moves address of msg into rdi
    mov     rsi, rax
    xor     eax, eax    ; no floating point paramters
    call    printf
    ; get first input
    lea     rdi, [scanfin]
    lea     rsi, [inp1]  ; second parameter for scanf: address to inp
    xor     eax, eax
    call    scanf


    ;get second input
    lea     rdi, [scanfin]
    lea     rsi, [inp2]
    xor     eax, eax
    call    scanf

	;set default color to green
	mov		eax, 4
	mov 	ebx, 1
	mov 	ecx, color_green
	mov 	edx, color_green.len
	int		80h
   

loop:
	
    mov     eax, [inp1]
    mov     ebx, [inp2]
	add		ebx, 1
    cmp     eax, ebx
    je      end

	mov		al, byte[color_flag]
	cmp 	al, 0
	je		red
	call	set_green

calc:
    mov rdi, [inp1]
    call fib

    ;print
    lea     rdi, [msg]  ; moves address of msg into rdi
    mov     rdx, rax
    xor     eax, eax    ; no floating point paramters
    call    printf


    mov     eax, [inp1]
    add     eax, 1
    mov     [inp1], eax

	;change flag
	mov		eax, [color_flag]
	xor		eax, 1
	mov		[color_flag], eax

    xor     eax, eax

    jmp loop

red:
	call set_red
	jmp calc

set_red:
	mov 	eax, 4
	mov 	ebx, 1
	mov		ecx, color_red
	mov 	edx, color_red.len
	int 	80h
	
	mov		byte[color_flag], 0
	ret

set_green:
	mov 	eax, 4
	mov		ebx, 1
	mov		ecx, color_green
	mov 	edx, color_green.len
	int 	80h

	mov 	byte[color_flag], 1
	ret


end:
	ret



fib:
    push    rbp
    mov     rbp, rsp

    cmp     rdi, 0      ; n == 0
    jz      .iszero
    cmp     rdi, 1      ; n == 1
    jz      .isone

    sub     rsp, 0x20   ; space for local variables

    mov     [rbp-0x8], rdi ; save n

    sub     rdi, 1      ; n-1
    call    fib         ; fib(n-1)

    mov     [rbp-0x10], rax ; t = fib(n-1)
    mov     rdi, [rbp-0x8] ; restore n
    
    sub     rdi, 2      ; n-2 
    call    fib         ; fib(n-2)

    mov     rsi, [rbp - 0x10] ; fib(n-1) to rsi
    add     rax, rsi    ; fib(n-2) + fib(n-1)

    leave
    ret
.iszero:
    mov     rax, 0
    pop     rbp
    ret
.isone:
    mov     rax, 1
    pop     rbp
    ret
