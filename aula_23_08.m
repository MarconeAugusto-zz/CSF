%Exemplo de interferência intersimbólica

clear all;
close all;
clc;

%tau = [0 2 3 5]*1e-6;           %vetor de tempo - microsegundos
%pdb = [0 -10 0 -20];            %vetor de atenuações
Rb = 10e3;                      %taxa de transmissão
Tb = 1/Rb;                      %tempo de simbolo, nesse caso tempo de bit, pois a transmissão é binária
doppler = 3;                    %simula 3 hertz = modelo de uma pessoa caminhando
num_bits = 1e6;
t = [0:1/Rb:num_bits/Rb-(1/Rb)];
info = randi([0,1],1,1000000);     %Gera uma informação randômica de "1 e 0"
info_mod = pskmod(info,2);
%canal = rayleighchan(Tb,doppler,tau, pdb);
canal = rayleighchan(1/num_bits,30);
canal.StoreHistory = 1;
sinal_recebido = filter(canal,info_mod);
ganho = canal.PathGains;
figure(1)
subplot(311)
histogram(real(ganho),100);     %distribuição de probabilidade da parte real
subplot(312)
histogram(imag(ganho),100);     %distribuição de probabilidade da parte imaginária
subplot(313)
histogram(abs(ganho),100);     %distribuição de probabilidade de Rayleigh, potência do sinal
figure(2)
subplot(211)
plot(t,20*log10(abs(ganho)));
subplot(212)
plot(ganho);

plot(canal);