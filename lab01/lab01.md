# Laboratório — Syscalls Linux em Assembly ARM

---

> **Importante:** este laboratório utiliza o Linux da BeagleBone Black. Não serão utilizados acesso direto aos periféricos ou programação bare-metal.

---

# 1. Introdução

Um programa executado no Linux normalmente não acessa diretamente determinados recursos do computador.

Por exemplo, para escrever no terminal, o programa solicita ao kernel que realize essa operação.

O fluxo simplificado é:

Uma **syscall** é uma interface através da qual um programa solicita ao kernel um serviço que requer recursos ou privilégios do sistema operacional.

---

# 2. Syscalls ARM Linux

Neste laboratório será utilizada a convenção de syscalls do **Linux ARM 32-bit EABI**.

Os principais registradores utilizados são:

| Registrador | Função                                |
| ----------- | ------------------------------------- |
| `r0`        | primeiro argumento / valor de retorno |
| `r1`        | segundo argumento                     |
| `r2`        | terceiro argumento                    |
| `r3`        | quarto argumento                      |
| `r7`        | número da syscall                     |

A chamada ao kernel é realizada através de:

```asm
svc #0
```
ou 

```asm
swi #0
```

De forma geral:

```text
r7 = número da syscall

r0 = argumento 1
r1 = argumento 2
r2 = argumento 3
r3 = argumento 4

svc #0

r0 = valor retornado
```

---

# 3. Principais syscalls utilizadas

| Syscall     | Número | Função                   |
| ----------- | -----: | ------------------------ |
| `exit`      |      1 | encerra o processo       |
| `fork`      |      2 | cria um processo         |
| `read`      |      3 | lê dados                 |
| `write`     |      4 | escreve dados            |
| `open`      |      5 | abre arquivo             |
| `close`     |      6 | fecha arquivo            |
| `getpid`    |     20 | obtém PID do processo    |
| `ioctl`     |     54 | controle de dispositivos |
| `nanosleep` |    162 | pausa a execução         |

Neste laboratório serão utilizadas principalmente:

```text
read
write
open
close
getpid
exit
```

---

# 4. Preparação do ambiente


Crie um diretório para o laboratório:

```bash
mkdir -p ~/lab_syscalls
cd ~/lab_syscalls
```

Crie um arquivo:

```bash
nano hello.s
```

ou utilize o VS Code:

```bash
code hello.s
```

Para montar e gerar o executável:

```bash
as hello.s -o hello.o
ld hello.o -o hello
```

Execute:

```bash
./hello
```

Para verificar o tipo do executável:

```bash
file hello
```

Também é possível examinar o cabeçalho ELF:

```bash
readelf -h hello
```

---

# 5. Exercício 1 — Hello BeagleBone

## Objetivo

Utilizar a syscall `write` para imprimir uma mensagem no terminal.

Crie o arquivo `hello.s`:

```asm
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
    .ascii "Hello Beagle!\n"
```

Compile:

```bash
as hello.s -o hello.o
ld hello.o -o hello
```

Execute:

```bash
./hello
```

Resultado esperado:

```text
Hello Beagle!
```

---

# Exercício 1.1 — Modificando a mensagem

Modifique o programa para imprimir seu nome.

Por exemplo:

```asm
mensagem:
    .ascii "Meu Nome!\n"
```

Compile e execute novamente.

---

# 6. Exercício 2 — Lendo dados do teclado

Agora utilizaremos a syscall `read`.

Para `read`:

```text
r0 = file descriptor
r1 = endereço do buffer
r2 = quantidade máxima de bytes
r7 = 3
```

Os principais file descriptors são:

| Valor | Nome     | Significado    |
| ----: | -------- | -------------- |
|   `0` | `stdin`  | entrada padrão |
|   `1` | `stdout` | saída padrão   |
|   `2` | `stderr` | saída de erro  |

Crie `read.s`:

```asm
.global _start

.section .text

_start:

    @ read(stdin, buffer, 100)

    mov r0, #0
    ldr r1, =buffer
    mov r2, #100
    mov r7, #3
    svc #0

    @ r0 contém a quantidade de bytes lidos

    mov r2, r0

    @ write(stdout, buffer, quantidade_lida)

    mov r0, #1
    ldr r1, =buffer
    mov r7, #4
    svc #0


    @ exit(0)

    mov r0, #0
    mov r7, #1
    svc #0


.section .bss

.lcomm buffer, 100
```

Compile:

```bash
as read.s -o read.o
ld read.o -o read
```

Execute:

```bash
./read
```

Digite:

```text
BeagleBone
```

O programa deverá repetir a entrada.

---

# 7. Entendendo o retorno de `read`

Uma característica importante das syscalls é que elas podem retornar um valor.

Depois de:

```asm
mov r7, #3
svc #0
```

o registrador `r0` contém a quantidade de bytes efetivamente lidos.

Por isso temos:

```asm
mov r2, r0
```

---

# 8. Exercício 3 — Eco do teclado

Modifique o programa anterior para apresentar:

```text
Digite uma mensagem:
```

Depois que o usuário digitar, o programa deverá imprimir:

```text
Voce digitou:
```

seguido da mensagem digitada.


---

# 9. Exercício 4 — Arquivos

Agora vamos utilizar três syscalls:

```text
open
write
close
```

Crie `file.s`:

```asm
.global _start

.section .text

_start:

    @ open("teste.txt", O_WRONLY | O_CREAT, 0644)

    ldr r0, =arquivo

    @ O_WRONLY | O_CREAT
    mov r1, #65

    @ permissões 0644
    mov r2, #420

    @ syscall open
    mov r7, #5
    svc #0

    @ guardar file descriptor
    mov r4, r0


    @ write(fd, mensagem, 14)

    mov r0, r4
    ldr r1, =mensagem
    mov r2, #14
    mov r7, #4
    svc #0


    @ close(fd)

    mov r0, r4
    mov r7, #6
    svc #0


    @ exit(0)

    mov r0, #0
    mov r7, #1
    svc #0


.section .data

arquivo:
    .asciz "teste.txt"

mensagem:
    .ascii "Hello arquivo!\n"
```

Compile:

```bash
as file.s -o file.o
ld file.o -o file
```

Execute:

```bash
./file
```

Verifique:

```bash
cat teste.txt
```

Resultado esperado:

```text
Hello arquivo!
```

---

# 10. File descriptors

Quando o programa executa:

```asm
mov r7, #5
svc #0
```

o kernel tenta abrir o arquivo. Se funcionar, o kernel retorna um número em `r0`.

Esse número é o **file descriptor**.

O programa então guarda esse valor:

```asm
mov r4, r0
```

Por exemplo, se o retorno do descritor for `3`, então:

```text
r0 = 3
```

Se após o retorno fizermos:

```asm
mov r0, r4
mov r7, #4
svc #0
```

isso é o mesmo que:

```text
write(3, ...)
```

Ou seja, estamos escrevendo no arquivo associado ao descritor `3`.

---


# 11. Exercício 5 — Obtendo o PID

Agora vamos utilizar:

```text
getpid = 20
```

Crie:

```asm
.global _start

.section .text

_start:

    @ getpid()
    mov r7, #20
    svc #0

    @ PID retornado em r0
    mov r4, r0

    @ terminar
    mov r0, #0
    mov r7, #1
    svc #0
```

Compile:

```bash
as pid.s -o pid.o
ld pid.o -o pid
```

Execute:

```bash
./pid
```

O programa não exibirá nada.

Por quê?

Porque o PID foi retornado como um **número binário em `r0`**, e não como uma sequência de caracteres ASCII.

---



Considere:

```text
r0 = 1234
```

Isso não significa que `r0` contém:

```text
'1' '2' '3' '4'
```

Ele contém o valor inteiro:

```text
1234
```

Para imprimir esse número no terminal, precisamos convertê-lo para ASCII.
Ou seja 1324 deve ser convertido para "1234"

---

# 13. Mostrar o PID

Modifique o programa anterior para imprimir:

```text
Meu PID: 1234
```

Para isso, você deverá:

1. executar `getpid`;
2. obter o PID em `r0`;
3. converter o número para ASCII;
4. armazenar o resultado em um buffer;
5. utilizar `write` para imprimir o resultado.

Inclua no seu programa a conversão de inteiro para ASCII criando uma função. Use `bl`para chamar a função.

```text
bl int_to_ascci
```

e implemente a função em algum lugar do código.

```text
int_to_ascci: 
   @ código da função

   mov pc, lr 

```


---

# 14. Menu interativo

Desenvolva um programa Assembly que apresente:

```text
=========================
       MENU
=========================

1 - Mostrar mensagem
2 - Ler nome
3 - Mostrar PID
4 - Salvar nome em arquivo
5 - Mostrar nome
6 - Sair

Opcao:
```

O programa deverá apresentar as cinco opções e executá-las de acordo com a escolha do usuário.
Ao final da execução o programa deve voltar a exibir o menu, exceto quando a opção 6 for escolhida.

---

## Opção 1 — Mostrar mensagem

Imprimir:

```text
Hello BeagleBone!
```
---

## Opção 2 — Ler nome

Solicitar:

```text
Digite seu nome:
```

Ler o nome utilizando `read` e armazenar o resultado em um buffer.

---

## Opção 3 — Mostrar PID

Obter o PID, converter o valor para ASCII e mostrar:

```text
PID: <pid>
```

---

## Opção 4 — Salvar nome

Criar o aquivo:

```text
nome.txt
```

e gravar nele o nome digitado.

---

## Opção 5 — Mostrar nome

Exibir o nome digitado na tela:

```text
<nome>
```

Se nenhum nome tiver sido digitado ainda, exiba a mensagem:

```text
Nenhum nome para ser exibido!
```

---

## Opção 6 — Sair

Encerrar o programa utilizando `exit`.

---


# 15. Entrega

O aluno deverá entregar:

### 1. Código-fonte

Arquivos:

```text
hello.s
read.s
file.s
pid.s
menu.s
```

### 2. Demonstração

Os programas deverão ser demonstrados na BeagleBone Black.

---


