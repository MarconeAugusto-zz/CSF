%Exemplo de interferência intersimbólica

clear all;
close all;
clc;

tau = [0 2 3 5]*1e-6;           %vetor de tempo - microsegundos
pdb = [0 -10 0 -20];            %vetor de atenuações
Rb = 10e3;                      %taxa de transmissão
Tb = 1/Rb;                      %tempo de simbolo, nesse caso tempo de bit, pois a transmissão é binária
doppler = 3;                    %simula 3 hertz = modelo de uma pessoa caminhando
info = randi([0,1],1,5000);     %Gera uma informação randômica de "1 e 0"
info_mod = pskmod(info,2);
canal = rayleighchan(Tb,doppler,tau, pdb);
canal.StoreHistory = 1;

sinal_recebido = filter(canal,info_mod);

plot(canal);