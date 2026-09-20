.global _start

.section .text

_start:

    @ Retorna "Digite uma mensagem: "
    @ write(stdout, msg_input, 21)
    mov r0, #1
    ldr r1, =msg_input
    mov r2, #21
    mov r7, #4
    svc #0

    @ lê os dados do teclado
    @ read(stdin, buffer, 100)
    mov r0, #0
    ldr r1, =buffer
    mov r2, #100
    mov r7, #3
    svc #0

    @ r0 contém a quantidade de bytes lidos
    @ guarda em r4 para não perder no prox write
    mov r4, r0

    @ retonra "Você digitou: "
    @ write(stdout, msg_output, 14)
    mov r0, #1
    ldr r1, =msg_output
    mov r2, #14
    mov r7, #4
    svc #0

    @ retorna o que digitou
    @ write(stdout, buffer, quantidade_lida em r4)
    mov r0, #1
    ldr r1, =buffer
    mov r2, r4
    mov r7, #4
    svc #0

    @ exit(0)
    mov r0, #0
    mov r7, #1
    svc #0

.section .data

msg_input:
    .ascii "Digite uma mensagem: " @ tem 21 bytes
msg_output:
    .ascii "Você digitou: " @ tem 14 bytes


.section .bss

.lcomm buffer, 100 @reserva 100 na mem