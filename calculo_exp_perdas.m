close all;
clear all;
clc;

syms n;
P = [0 -22 -38 -75];
d = [100 200 1000 3000];

E = P(1) - 10*n*log10(d./d(1));
J_n = sum((P-E).^2);

eq_d = diff(J_n);
exp_perda = vpa(solve(eq_d),3)