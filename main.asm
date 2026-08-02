; basic calculator made for stardance.hackclub.com

bits 64


section .data
    wlcm_msg db "basic ahh calculator in asm", 10, 10
    wlcm_msg_len equ $ - wlcm_msg

    operation_msg db "enter operation (+ - * /): "
    operation_msg_len equ $ - operation_msg

    first_num_msg db "enter first number: "
    first_num_msg_len equ $ - first_num_msg

    second_num_msg db "enter second number: "
    second_num_msg_len equ $ - second_num_msg


section .bss
    operation resb 2
    input1 resb 32
    input2 resb 32
    num1 resq 1
    num2 resq 1
    output resb 32

section .text
    global _start


_start:
    mov rax, 1
    mov rdi, 1
    mov rsi, wlcm_msg
    mov rdx, wlcm_msg_len
    syscall ; welcome message


    ; operation 
    mov rax, 1
    mov rdi, 1
    mov rsi, operation_msg
    mov rdx, operation_msg_len
    syscall

    mov rax, 0
    mov rdi, 0
    mov rsi, operation
    mov rdx, 2
    syscall ; read operation




    ; first input
    mov rax, 1
    mov rdi, 1
    mov rsi, first_num_msg
    mov rdx, first_num_msg_len
    syscall

    mov rax, 0
    mov rdi, 0
    mov rsi, input1
    mov rdx, 32
    syscall ; read first input




    ; second input
    mov rax, 1
    mov rdi, 1
    mov rsi, second_num_msg
    mov rdx, second_num_msg_len
    syscall

    mov rax, 0
    mov rdi, 0
    mov rsi, input2
    mov rdx, 32
    syscall ; read second input


    ; itoa
    mov rdi, input1
    call atoi
    mov [num1], rax

    mov rdi, input2
    call atoi
    mov [num2], rax


    mov r12, operation
    cmp byte [r12], 43
    je addition

    cmp byte [r12], 45
    je subtraction

    cmp byte [r12], 42
    je multiplication


; duh, addition
addition:
    mov rax, [num1]
    add rax, [num2]
    ; mov [output], rax

    mov rdi, rax
    lea rsi, [output]
    call itoa
    
    mov rdx, rax
    mov rax, 1
    mov rdi, 1
    mov rsi, output
    syscall

    jmp exit

subtraction:
    mov rax, [num1]
    sub rax, [num2]

    mov rdi, rax
    lea rsi, [output]
    call itoa

    mov rdx, rax
    mov rax, 1
    mov rdi, 1
    mov rsi, output
    syscall

    jmp exit

multiplication:
    mov rax, [num1]
    mov rcx, [num2]
    mul rcx

    mov rdi, rax
    lea rsi, [output]
    call itoa

    mov rdx, rax
    mov rax, 1
    mov rdi, 1
    mov rsi, output
    syscall

    jmp exit


exit:
    mov rax, 60
    xor rdi, rdi
    syscall ; exit






; ascii to integer conversion
atoi:
    mov rsi, rdi
    xor rax, rax

.loop:
    cmp byte [rsi], 10
    je .done

    movzx rcx, byte [rsi]
    sub rcx, '0'

    imul rax, rax, 10
    add rax, rcx

    inc rsi
    jmp .loop

.done:
    ret


itoa:
    mov rax, rdi

    test rax, rax
    jnz .convert

    mov byte [rsi], '0'
    mov rax, 1
    ret

.convert:
    lea r8, [rsi + 31]
    xor r9, r9

.loop:
    xor rdx, rdx
    mov rcx, 10
    div rcx

    add dl, '0'
    dec r8
    mov [r8], dl

    inc r9

    test rax, rax
    jnz .loop

    mov rcx, r9
    mov rdx, r8
    mov r8, rsi

.copy:
    mov al, [rdx]
    mov [r8], al
    
    inc rdx
    inc r8
    loop .copy

    mov byte [r8], 10
    inc r9

    mov rax, r9
    ret