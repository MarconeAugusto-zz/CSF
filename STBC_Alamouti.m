clear all;
close all;
clc;

M = 2;
fd = 100;   %100 hertz, mobilidade elevada
Rs = 10e3;  %taxa de simbolo

info = randi([0 M-1], 4 , 1);
info_mod = pskmod(info,M);

%separa vetor em pares e impares
info_mod_i = info_mod(1:2:end); %impar
info_mod_p = info_mod(2:2:end); %par

info_tx_0 = zeros(1,length(info)); %cria vetor de zeros
info_tx_1 = zeros(1,length(info)); %cria vetor de zeros

%separar os vetores
info_tx_0(1:2:end) = info_mod_i;
info_tx_0(2:2:end) = -conj(info_mod_p);
info_tx_1(1:2:end) = info_mod_p;
info_tx_1(2:2:end) = conj(info_mod_i);

%criar os canais
canal1 = rayleighchan(1/Rs, fd); %canal 1
canal1.StoreHistory = 1;
canal2 = rayleighchan(1/Rs, fd); %canal 2
canal2.StoreHistory = 1;

%envia a informação modulada
h0 = filter(canal1, info_tx_0);
ganho_canal1 = canal1.PathGains;    %ganho canal 1
h1 = filter(canal2, info_tx_1);
ganho_canal2 = canal2.PathGains;    %ganho canal 1
sinal_rx0 = (h0.*info_tx_0) + (h1.*info_tx_1);
sinal_rx0 = sinal_rx0  + awgn(sinal_rx0, 10);
sinal_rx1 = -(h0.*conj(info_tx_1)) + (h1.*conj(info_tx_0));
sinal_rx1 = sinal_rx1 + awgn(sinal_rx1, 20);

s0 = conj(h0).*sinal_rx0 + h1.*conj(sinal_rx1);
s1 = conj(h1).*sinal_rx0 - h0.*conj(sinal_rx0);

s0_demod = pskdemod(s0,M);
s1_demod = pskdemod(s1,M);

figure(1)
plot(20*log10(abs(ganho_canal1)),'b');grid minor;hold on
plot(20*log10(abs(ganho_canal2)),'r');

