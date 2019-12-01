%Exemplo de interferência intersimbólica

clear all;
close all;
clc;

Rb = 100e3;                     %taxa de transmissão
Tb = 1/Rb;                      %tempo de simbolo, nesse caso tempo de bit, pois a transmissão é binária
doppler = 300;                  %simula 3 hertz = modelo de uma pessoa caminhando
k = 10;
num_bits = 1e6;
t = [0:1/Rb:num_bits/Rb-(1/Rb)];
info = randi([0,1],1,num_bits);     %Gera uma informa��o
info_mod = pskmod(info,2);
canal_ray = rayleighchan(1/Rb,30);
canal_ric = ricianchan(1/Rb,doppler,k);
canal_ray.StoreHistory = 1;
canal_ric.StoreHistory = 1;
sinal_recebido_ray = filter(canal_ray,info_mod);
sinal_recebido_ric = filter(canal_ric,info_mod);
ganho_ray = canal_ray.PathGains;
ganho_ric = canal_ric.PathGains;

figure(1)
subplot(211)
hist(abs(ganho_ray),500);     %Distribuição de probabilidade de Rayleigh, potência do sinal
title('Rayleigh');
subplot(212)
hist(abs(ganho_ric),500);     %Distribuição de probabilidade de Ricean, potência do sinal
title('Ricean');

figure(2)
plot(t,20*log10(abs(ganho_ray)));hold on;title('Distribui�oes');ylim([-50 30]);xlim([0 1]);grid on;
plot(t,20*log10(abs(ganho_ric)));
legend('Rayleigh','Ricean');
