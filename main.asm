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

    divide_by_zero_msg db 10, "really dawg? divide by zero? be fr", 10
    divide_by_zero_msg_len equ $ - divide_by_zero_msg

    invalid_op_msg db 10, "invalid operation, use one of the + - * /", 10
    invalid_op_msg_len equ $ - invalid_op_msg

    invalid_num_msg db 10, "invalid number, use digits 0-9 only", 10
    invalid_num_msg_len equ $ - invalid_num_msg

    neg_result_msg db 10, "negative result not supported for now", 10
    neg_result_msg_len equ $ - neg_result_msg


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
    jc invalid_number
    mov [num1], rax

    mov rdi, input2
    call atoi
    jc invalid_number
    mov [num2], rax


    mov r12, operation
    cmp byte [r12], 43
    je addition

    cmp byte [r12], 45
    je subtraction

    cmp byte [r12], 42
    je multiplication

    cmp byte [r12], 47
    je division

    jmp invalid_operation


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
    jb negative_result

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

division:
    mov rax, [num1]
    xor rdx, rdx
    mov rcx, [num2]
    cmp rcx, 0
    je divide_by_zero

    div rcx

    mov rdi, rax
    lea rsi, [output]
    call itoa

    mov rdx, rax
    mov rax, 1
    mov rdi, 1
    mov rsi, output
    syscall

    jmp exit

divide_by_zero:
    mov rax, 1
    mov rdi, 2
    mov rsi, divide_by_zero_msg
    mov rdx, divide_by_zero_msg_len
    syscall

    jmp error_exit

invalid_operation:
    mov rax, 1
    mov rdi, 2
    mov rsi, invalid_op_msg
    mov rdx, invalid_op_msg_len
    syscall

    jmp error_exit

invalid_number:
    mov rax, 1
    mov rdi, 2
    mov rsi, invalid_num_msg
    mov rdx, invalid_num_msg_len
    syscall

    jmp error_exit

negative_result:
    mov rax, 1
    mov rdi, 2
    mov rsi, neg_result_msg
    mov rdx, neg_result_msg_len
    syscall
    jmp error_exit

exit:
    mov rax, 60
    xor rdi, rdi
    syscall ; exit


error_exit:
    mov rax, 60
    mov rdi, 1
    syscall



; ascii to integer conversion
atoi:
    mov rsi, rdi
    xor rax, rax
    xor r9, r9

.loop:
    movzx rcx, byte [rsi]
    cmp cl, 10
    je .done
    ; je .done

    cmp cl, '0'
    jb .error
    cmp cl, '9'
    ja .error

    sub rcx, '0'
    imul rax, rax, 10
    jc .error
    add rax, rcx
    jc .error


    inc rsi
    inc r9
    jmp .loop

.done:
    test r9, r9
    jz .error
    clc
    ret

.error:
    stc ; tuff function
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