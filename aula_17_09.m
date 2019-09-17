clear all;
close all;
clc;

Rb = 100e3;                      %taxa de transmissão
Tb = 1/Rb;                      %tempo de simbolo, nesse caso tempo de bit, pois a transmissão é binária
doppler = 10;                    %simula 3 hertz = modelo de uma pessoa caminhando
num_bits = 1e5;
%t = [0:1/Rb:num_bits/Rb-(1/Rb)];
info = randi([0,1],1,num_bits);     %Gera uma informação randômica de "1 e 0"
info_mod = pskmod(info,2);

canal_ray = rayleighchan(1/Rb,doppler);
canal_ray2 = rayleighchan(1/Rb,doppler);
canal_ray3 = rayleighchan(1/Rb,doppler);
canal_ray4 = rayleighchan(1/Rb,doppler);
canal_ray5 = rayleighchan(1/Rb,doppler);

canal_ray.StoreHistory = 1;
canal_ray2.StoreHistory = 1;
canal_ray3.StoreHistory = 1;
canal_ray4.StoreHistory = 1;
canal_ray5.StoreHistory = 1;

sinal_recebido_ray = filter(canal_ray,info_mod);
sinal_recebido_ray2 = filter(canal_ray2,info_mod);
sinal_recebido_ray3 = filter(canal_ray3,info_mod);
sinal_recebido_ray4 = filter(canal_ray4,info_mod);
sinal_recebido_ray5 = filter(canal_ray5,info_mod);

ganho_ray = canal_ray.PathGains;
ganho_ray2 = canal_ray2.PathGains;
ganho_ray3 = canal_ray3.PathGains;
ganho_ray4 = canal_ray4.PathGains;
ganho_ray5 = canal_ray5.PathGains;

ganho = max(ganho_ray,ganho_ray2);
ganho = max(ganho_ray3,ganho);
ganho = max(ganho_ray4,ganho);
ganho = max(ganho_ray5,ganho);

figure(1)
subplot(411)
hist(abs(ganho_ray),200);     %Distribuição de probabilidade de Rayleigh, potência do sinal
title('Rayleigh');
subplot(412)
hist(abs(ganho_ray2),200);     %Distribuição de probabilidade de Ricean, potência do sinal
title('Rayleigh 2');
subplot(413)
hist(abs(ganho_ray3),200);     %Distribuição de probabilidade de Ricean, potência do sinal
title('Rayleigh 3');
subplot(414)
hist(abs(ganho),200);     %Distribuição de probabilidade de Ricean, potência do sinal
title('Rayleigh 3');

figure(2)
plot(20*log10(abs(ganho_ray)));hold on;title('Distribui��es, Tecnicas de diversidade');ylim([-50 15]);grid minor;
plot(20*log10(abs(ganho_ray2)));
plot(20*log10(abs(ganho_ray3)));
plot(20*log10(abs(ganho_ray4)));
plot(20*log10(abs(ganho_ray5)));
plot(20*log10(abs(ganho)),'--','LineWidth',1);
legend('Rayleigh','Rayleigh 2','Rayleigh 3','Rayleigh 4','Rayleigh 5','Ganho Equivalente');