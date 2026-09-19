# Configuração do Compilador Cruzado ARM

## 1. Atualizar os pacotes

No computador Linux:

```bash
sudo apt update
sudo apt upgrade
```

---

## 2. Instalar o compilador ARM

Instale o toolchain para ARM Linux 32-bit:

```bash
sudo apt install gcc-arm-linux-gnueabihf binutils-arm-linux-gnueabihf
```

---

## 3. Verificar o compilador

Execute:

```bash
arm-linux-gnueabihf-gcc --version
```

Também podemos verificar o assembler:

```bash
arm-linux-gnueabihf-as --version
```

E o linker:

```bash
arm-linux-gnueabihf-ld --version
```

---

## 4. Verificar a arquitetura do compilador

Execute:

```bash
arm-linux-gnueabihf-gcc -dumpmachine
```

O resultado esperado é:

```text
arm-linux-gnueabihf
```

Isso indica que o compilador está configurado para gerar programas **ARM 32-bit para Linux**.

---

## 5. Criar um programa Assembly de teste

Crie:

```bash
nano hello.s
```

Use:

```asm
.global _start

.section .text

_start:
    mov r0, #1
    ldr r1, =mensagem
    mov r2, #14
    mov r7, #4
    svc #0

    mov r0, #0
    mov r7, #1
    svc #0

.section .data

mensagem:
    .ascii "Hello Beagle!\n"
```

---

## 6. Montar o código

```bash
arm-linux-gnueabihf-as hello.s -o hello.o
```

---

## 7. Fazer o link

```bash
arm-linux-gnueabihf-ld hello.o -o hello
```

---

## 8. Verificar o executável

```bash
file hello
```

O resultado deverá indicar algo semelhante a:

```text
ELF 32-bit LSB executable, ARM, EABI5
```

---

## 9. Transferir para a BeagleBone

Utilizando `scp`:

```bash
scp hello debian@IP_DA_BEAGLEBONE:/home/debian/
```

Por exemplo:

```bash
scp hello debian@192.168.7.2:/home/debian/
```

---

## 10. Executar na BeagleBone

Conecte-se:

```bash
ssh debian@IP_DA_BEAGLEBONE
```

Dê permissão:

```bash
chmod +x hello
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

