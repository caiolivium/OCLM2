# Lab 01 — Syscalls Linux em Assembly ARM

**Objetivo:** Compreender e utilizar syscalls do Linux (ARM 32-bit EABI) na BeagleBone Black sem acesso direto aos periféricos (não é bare-metal).

**Syscalls abordadas:**
- `exit` (1)
- `read` (3)
- `write` (4)
- `open` (5)
- `close` (6)
- `getpid` (20)

**Comandos úteis para compilação e execução:**
```bash
as arquivo.s -o arquivo.o  # Montagem
ld arquivo.o -o arquivo    # Linkagem
./arquivo                  # Execução
```

---

## 📝 Resolução dos Exercícios (Journal)

### 1. Hello BeagleBone (`hello.s`)
*Referente aos Exercícios 1 e 1.1*

**Descrição:** 
Programa simples que utiliza a syscall `write` (4) para imprimir uma mensagem no terminal (`stdout` = 1) e depois encerra com `exit` (1). Modificado para imprimir o meu nome.

**Minhas observações / Explicação do código:**
> *Acho que aqui não tem muito o que falar, é um Hello World, mas me mostrou que eu teria que ver uma tabela mostrando a diferença entre os "comandos" e funções que usei em arquivos .asm*

---

### 2. Lendo e Ecoando do Teclado (`read.s`)
*Referente aos Exercícios 2 e 3*

**Descrição:** 
Utiliza a syscall `read` (3) lendo do `stdin` (0) e armazenando em um buffer. Em seguida, imprime "Voce digitou: " seguido do conteúdo do buffer usando a syscall `write`.

**Minhas observações / Explicação do código:**
> *Aqui é um scanf e printf. Como fazia em arquivos .asm eu anotava em comentários o que eu fazia no codigo, principalmente para lembrar o que eu estava fazendo e o que cada coisa que escrevi significava. No fim, o codigo funcionou corretamente. O codigo base que o professor deu é muito bom, lendo ele entendi como funciona a leitura e escrita, então só apliquei com o que devia ser feito na questão.*

---

### 3. Manipulação de Arquivos (`file.s`)
*Referente ao Exercício 4*

**Descrição:** 
Abre (ou cria) um arquivo chamado `teste.txt` usando a syscall `open` (5), escreve uma mensagem nele usando o file descriptor retornado, e por fim fecha o arquivo com `close` (6).

**Minhas observações / Explicação do código:**
> *(Escreva aqui como você lidou com as flags O_WRONLY | O_CREAT e como guardou o File Descriptor)*

---

### 4. Obtendo e Exibindo o PID (`pid.s`)
*Referente aos Exercícios 5 e 13*

**Descrição:** 
Chama o `getpid` (20). Como o PID é retornado como um número binário inteiro em `r0`, foi implementada a função `int_to_ascci` para converter o valor para caracteres ASCII antes de imprimir na tela.

**Minhas observações / Explicação do código:**
> *(Explique a lógica matemática usada na sua função `int_to_ascci` para separar os dígitos e somar 48 / 0x30)*

---

### 5. Menu Interativo (`menu.s`)
*Referente ao Exercício 14 (Entrega Final)*

**Descrição:** 
Programa principal que integra todas as funcionalidades anteriores em um loop contínuo. Ele exibe um menu com 6 opções e utiliza desvios condicionais para executar a ação correspondente.

**Minhas observações / Explicação do código:**
> *(Explique como você estruturou o loop principal e a leitura da opção do usuário)*

---

## 🚀 Entrega

Os códigos-fonte desenvolvidos e documentados acima estão salvos nesta mesma pasta:
- [X] `hello.s`
- [X] `read.s`
- [ ] `file.s`
- [ ] `pid.s`
- [ ] `menu.s`