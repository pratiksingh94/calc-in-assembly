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
    num2 resq 2

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