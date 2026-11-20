L = 4       # Lanes por VALU
VLMAX = 16  # Comprimento máximo do vetor
B = 16      # Largura de banda da memória
N_VALU = 1  # Número de VALUs

n = 64 => vl = VMAX = 16

### VSPLAT
T = ⌈vl/L⌉ = 16/4 = 4
F = I + T - 1 = I + 3

| Instruçao       | vl | Unidade | E | I | F | Observaçao                                    |
|-----------------|----|---------|---|---|---|-----------------------------------------------|
| VSETVL x2, x1   | -  | ALU     | 1 | 1 | 1 | x1 = n = 64 => x2 = vl = VMAX = 16            |
| VSPLAT v1, x3   | 16 | VALU    | 2 | 2 | 5 | x3 = a                                        |
| LI x4, 1        | 16 | ALU     | 3 | 3 | 3 | x4 = 1                                        |
| LOOP:           |    | -       | - | - | - |                                               |
| VLOAD v2, (x3)  | 16 | LSU     |   |   |   | Carrega indices [x4+vl * (x4-1), x4+vl * x4)  |
| VLOAD v3, (x4)  | 16 | LSU     |   |   |   |                                               |
| VFMA v3, v1, v2 | 16 | VALU    |   |   |   |                                               |

Código
```
// x1 = n e x3 = a inicialmente carregados

    VSETVL x2, x1       // x1 = n, x2 = vl
    VSPLAT v1, x3       // x3 = a
    MULI x4, x2, 4      // x4 é x2 elementos em bytes
    LI x5, 1            // x5 = 1
LOOP:
    VLOAD v2, (x6)      // Carrega bytes de endereço no intervalo [x6+x4*(x5-1), x6+x4*x5-1] do vetor X
    VLOAD v3, (x7)      // Carrega bytes de endereço no intervalo [x7+x4*(x5-1), x7+x4*x5-1] do vetor Y
    VFMA v3, v2, v1     // Y[i] = Y[i] + X[i]*a
    ADD x7, x4          // Atualiza endereço x7 com deslocamento de x4 bytes
    VSTORE v3, (x7)     // Armazena x2 elementos do vetor Y, começando no endereço x7
    ADD x6, x4          // Atualiza endereço x6 com deslocamento de x4 bytes      
    MUL x8, x4, x2      // x8 representa quantos elementos dos vetores já foram carregados
    BNE x8, x1, LOOP    // termina o loop se x8 = n
```