clear all
close all
clc

info = randi([0 1],20000,1); %Gera a informação aleatória
info_mod = pskmod(info, 2);  %modulação BPSK 
fd = 100;   %100 hertz, mobilidade elevada
Rs = 10e3;  %taxa de simbolo

canal1 = rayleighchan(1/Rs, fd); %canal 1
canal1.StoreHistory = 1;
canal2 = rayleighchan(1/Rs, fd); %canal 2
canal2.StoreHistory = 1;

sinal_rx1 = filter(canal1, info_mod); %sinal rx1 = informação x canal 1
ganho_canal1 = canal1.PathGains;    %ganho canal 1
sinal_rx2 = filter(canal2, info_mod); %sinal rx2 = informação x canal 2
ganho_canal2 = canal2.PathGains;    %ganho canal 1

for SNR = 0:25 %simular um ruido de 26 valores diferentes modificando a razão SNR
    sinal_rx1_awgn = awgn(sinal_rx1, SNR);
    sinal_rx2_awgn = awgn(sinal_rx2, SNR);
    %equalizar o sinal recebido, eliminando a rotação de fase inserida pelo canal 
    sinal_eq_1 = sinal_rx1_awgn./ganho_canal1;
    sinal_eq_2 = sinal_rx2_awgn./ganho_canal2;
    for t = 1:length(info_mod) %compara os sinais para obter o de maior ganho
        if abs(ganho_canal1(t)) > abs(ganho_canal2(t))
            sinal_demod(t) = pskdemod(sinal_eq_1(t), 2);
            ganho_eq(t) = ganho_canal1(t);
        else
            sinal_demod(t) = pskdemod(sinal_eq_2(t), 2);
            ganho_eq(t) = ganho_canal2(t);
        end
    end
    sinal_demod_1Tx1Rx = pskdemod(sinal_eq_1, 2);
    [num(SNR+1), taxa(SNR+1)] = biterr(info, transpose(sinal_demod));
    [num2(SNR+1), taxa2(SNR+1)] = biterr(info, (sinal_demod_1Tx1Rx));
end
figure(1)
plot(20*log10(abs(ganho_canal1)),'b');grid minor;xlim([0 500]);
hold on
plot(20*log10(abs(ganho_canal2)),'r')
hold on
plot(20*log10(abs(ganho_eq)),'y')
legend('Ganho canal 1','Ganho canal 2','Ganho equivalente');

figure(2)
semilogy([0:25],taxa,'b', [0:25],taxa2,'r');grid minor;
title('SNR');
legend('Antena 1', 'Antena 2');
    

