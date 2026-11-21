## Configuração Base

* `L = 4`  
* `VLMAX = 16`
* `B = 16`
* `N_VALU = 1`
* `n = 64` então `vl = VMAX = 16`
* `P_peak = 8`
* `I_inf = 0,5`

#### Instruções

| Instruçao | T | N_FLOPS |
|:---------:|:-:|:-------:|
|   VSETVL  | 1 |    0    |
|   VLOAD   | 4 |    0    |
|    VFMA   | 4 |    32   |
|   VSPLAT  | 4 |    0    |
|   VZERO   | 4 |    0    |
|  VREDSUM  | 6 |    0    |
|    FSW    | 1 |    0    |
|    ADD    | 1 |    0    |
|    SLLI   | 1 |    0    |
|    BNE    | 1 |    0    |


### Trace


|  k  |      Instruçao      | vl | Unidade |  E  |  I  |  F  |
|:---:|:-------------------:|:--:|:-------:|:---:|:---:|:---:|
|  1  |    VSETVL x2, x1    |  - |   ALU   |  1  |  1  |  1  |
|  2  |      VZERO v1       | 16 |   VALU  |  2  |  2  |  5  |
|  3  |   SLLI x3, x2, 2    | 16 |   ALU   |  3  |  3  |  3  |
|  4  |   ADD x4, x0, x0    |  - |   ALU   |  4  |  4  |  4  |

|  5  |   ADD x4, x4, x2    |  - |   ALU   |  5  |  5  |  5  |
|  6  |   VLOAD v2, (x5)    | 16 |   LSU   |  6  |  6  |  9  |
|  7  |   VLOAD v3, (x6)    | 16 |   LSU   |  10 |  10 |  13 |
|  8  |   VFMA v1, v2, v3   | 16 |   VALU  |  11 |  14 |  17 |
|  9  |   ADD x5, x5, x3    |  - |   ALU   |  12 |  12 |  12 |
|  10 |   ADD x6, x6, x3    |  - |   ALU   |  13 |  13 |  13 |
|  11 |   BNE x4, x1, LOOP  |  - |   ALU   |  14 |  14 |  14 |

|  12 |   ADD x4, x4, x2    |  - |   ALU   |  15 |  15 |  15 |
|  13 |   VLOAD v2, (x5)    | 16 |   LSU   |  16 |  18 |  21 |
|  14 |   VLOAD v3, (x6)    | 16 |   LSU   |  22 |  22 |  25 |
|  15 |   VFMA v1, v2, v3   | 16 |   VALU  |  23 |  26 |  29 |
|  16 |   ADD x5, x5, x3    |  - |   ALU   |  24 |  24 |  24 |
|  17 |   ADD x6, x6, x3    |  - |   ALU   |  25 |  25 |  25 |
|  18 |   BNE x4, x1, LOOP  |  - |   ALU   |  26 |  26 |  26 |

|  19 |   ADD x4, x4, x2    |  - |   ALU   |  27 |  27 |  27 |
|  20 |   VLOAD v2, (x5)    | 16 |   LSU   |  28 |  30 |  33 |
|  21 |   VLOAD v3, (x6)    | 16 |   LSU   |  34 |  34 |  37 |
|  22 |   VFMA v1, v2, v3   | 16 |   VALU  |  35 |  38 |  41 |
|  23 |   ADD x5, x5, x3    |  - |   ALU   |  36 |  36 |  36 |
|  24 |   ADD x6, x6, x3    |  - |   ALU   |  37 |  37 |  37 |
|  25 |   BNE x4, x1, LOOP  |  - |   ALU   |  38 |  38 |  38 |

|  26 |   ADD x4, x4, x2    |  - |   ALU   |  39 |  39 |  39 |
|  27 |   VLOAD v2, (x5)    | 16 |   LSU   |  40 |  42 |  45 |
|  28 |   VLOAD v3, (x6)    | 16 |   LSU   |  46 |  46 |  49 |
|  29 |   VFMA v1, v2, v3   | 16 |   VALU  |  47 |  50 |  53 |
|  30 |   ADD x5, x5, x3    |  - |   ALU   |  48 |  48 |  48 |
|  31 |   ADD x6, x6, x3    |  - |   ALU   |  49 |  49 |  49 |
|  32 |   BNE x4, x1, LOOP  |  - |   ALU   |  50 |  50 |  50 |

|  33 |  VREDSUM f1, v1, f0 | 16 |   VALU  |  54 |  54 |  59 |
|  34 |  FSW f1 0(x7)       |  - |   LSU   |  60 |  60 |  60 |
