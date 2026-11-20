## Configuração Base

* `L = 4`  
* `VLMAX = 16`
* `B = 16`
* `N_VALU = 1`
* `n = 64` então `vl = VMAX = 16`

#### Instruções

| Instruçao | T | N_FLOPS |
|:---------:|:-:|:-------:|
|   VSETVL  | 1 |    0    |
|   VLOAD   | 4 |    0    |
|   VSTORE  | 4 |    0    |
|    VFMA   | 4 |    32   |
|   VSPLAT  | 4 |    0    |
|    ADD    | 1 |    0    |
|    SLLI   | 1 |    0    |
|    BNE    | 1 |    0    |

### Trace

Para essa congiguração, como `n/vl = 64/16 =4`, o loop deve ser executado 4 vezes para que o kernel seja finalizado.

|     Instruçao    | vl | Unidade |  E |  I |  F |
|:----------------:|:--:|:-------:|:--:|:--:|:--:|
|   VSETVL x2, x1  |  - |   ALU   |  1 |  1 |  1 |
|   VSPLAT v1, f1  | 16 |   VALU  |  2 |  2 |  5 |
|  SLLI x3, x2, 2  | 16 |   ALU   |  3 |  3 |  3 |
|  ADD x4, x0, x0  |  - |   ALU   |  4 |  4 |  4 |
|  ADD x4, x4, x2  |  - |   ALU   |  5 |  5 |  5 |
|  VLOAD v2, (x5)  | 16 |   LSU   |  6 |  6 |  9 |
|  VLOAD v3, (x6)  | 16 |   LSU   | 10 | 10 | 13 |
|  VFMA v3, v2, v1 | 16 |   VALU  | 11 | 14 | 17 |
|  VSTORE v3, (x6) | 16 |   LSU   | 14 | 18 | 21 |
|  ADD x5, x5, x3  |  - |   ALU   | 15 | 15 | 15 |
|  ADD x6, x6, x3  |  - |   ALU   | 16 | 16 | 16 |
| BNE x4, x1, LOOP |  - |   ALU   | 17 | 17 | 17 |
|  ADD x4, x4, x2  |  - |   ALU   | 18 | 18 | 18 |
|  VLOAD v2, (x5)  | 16 |   LSU   | 22 | 22 | 25 |
|  VLOAD v3, (x6)  | 16 |   LSU   | 26 | 26 | 29 |
|  VFMA v3, v2, v1 | 16 |   VALU  | 27 | 30 | 33 |
|  VSTORE v3, (x6) | 16 |   LSU   | 30 | 34 | 37 |
|  ADD x5, x5, x3  |  - |   ALU   | 31 | 31 | 31 |
|  ADD x6, x6, x3  |  - |   ALU   | 32 | 32 | 32 |
| BNE x4, x1, LOOP |  - |   ALU   | 33 | 33 | 33 |

### Extrapolação Analítica

Podemos dividir o algorítmo em duas partes:

1. **Fora do loop**: a sequência executada apenas uma vez.

| k |     Instruçao    |  E |  F |
|:-:|:----------------:|:--:|:--:|
| 1 |   VSETVL x2, x1  |  1 |  1 |
| 2 |   VSPLAT v1, f1  |  2 |  5 |
| 3 |  SLLI x3, x2, 2  |  3 |  3 |
| 4 |  ADD x4, x0, x0  |  4 |  4 |

> Portanto, temos `F_4-E_1+1=4` ciclos fora do loop.

2. **Dentro do loop:** A sequência executada `n/vl` vezes. Na primeira execução do loop, temos:

| k  |     Instruçao    |  E |  F |
|:--:|:----------------:|:--:|:--:|
| 5  |  ADD x4, x4, x2  |  5 |  5 |
| 6  |  VLOAD v2, (x5)  |  6 |  9 |
| 7  |  VLOAD v3, (x6)  | 10 | 13 |
| 8  |  VFMA v3, v2, v1 | 11 | 17 |
| 9  |  VSTORE v3, (x6) | 14 | 21 |
| 10 |  ADD x5, x5, x3  | 15 | 15 |
| 11 |  ADD x6, x6, x3  | 16 | 16 |
| 12 | BNE x4, x1, LOOP | 17 | 17 |

Da emissão da instrução 5 à finalização da instrução 12, temos `F_12 - E_5+1 = 13`. Agora, olhando para o segundo loop:

| k  |     Instruçao    |  E |  F |
|:--:|:----------------:|:--:|:--:|
| 13 |  ADD x4, x4, x2  | 18 | 18 |
| 14 |  VLOAD v2, (x5)  | 22 | 25 |
| 15 |  VLOAD v3, (x6)  | 26 | 29 |
| 16 |  VFMA v3, v2, v1 | 27 | 33 |
| 17 |  VSTORE v3, (x6) | 30 | 37 |
| 18 |  ADD x5, x5, x3  | 31 | 31 |
| 19 |  ADD x6, x6, x3  | 32 | 32 |
| 20 | BNE x4, x1, LOOP | 33 | 33 |


