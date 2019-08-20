clear all;
clc;

syms n
Pr = [0 -22 -38 -75];   %Potência recebida
di = [100 200 1000 3000];
d0 = 100;

E = Pr(1) - 10*n*log10(di./d0);  
j_n = sum((Pr - E).^2);

d_j_n = diff(j_n);

vpa(solve(d_j_n),5)