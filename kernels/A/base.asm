// x1 proposta para vl
// x2 = a

VSETVL x3, x1 // x3 = vl = 16
VSPLAT v1, x2 // cria vetor de valor a em todas as entradas
VLOAD v2, (x4) // carregando vetor X
VLOAD v3, (x5) // carregando vetor Y
VFMA v3, v1, v2 // Y[i] = Y[i] + X[i] * a
