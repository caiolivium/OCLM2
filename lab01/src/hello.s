.global _start

.section .text

_start:

    @ stdout
    mov r0, #1

    @ endereço da mensagem
    ldr r1, =mensagem

    @ quantidade de bytes
    mov r2, #14

    @ syscall write
    mov r7, #4

    @ chama o kernel
    svc #0


    @ exit(0)
    mov r0, #0
    mov r7, #1
    svc #0


.section .data

mensagem:
    .ascii "caiolalacints!\n"