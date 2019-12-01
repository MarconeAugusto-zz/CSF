clear all;
close all;
clc;

rs = 100e3;                 % taxa de simbolo da entrada do canal/taxa de transmissao 
ts = 1/rs;                  % tempo de simbolo
num_sim = 1e6;              % numero de simbolos a ser transmitidos
t = [0:ts:num_sim/rs-(ts)];
doppler = 300;              %fd 
k = 0;                      %fator rice                                                                                   ; % parametro Riciano
M = 2;                      %ordem da modula��o M = representa gera��o de bits

info = randi(M,num_sim,1)-1;                %gerando informa��o a ser transmitida
info_mod = pskmod(info,M);                  %utilizando uma fun��o que faz a modula��o PSK (modula��o digital em fase)
canal_ray = rayleighchan(ts, doppler);      % gerando o objeto que representa o canal
canal_ric = ricianchan(ts, doppler, k);
canal_ray.StoreHistory = 1;                 % hablitando a grava��o dos ganhos de canal
canal_ric.StoreHistory = 1;
sinal_rec_ray = filter(canal_ray, info_mod);%esta fun��o representa  o ato de transmitir um sinal modulado por um canal sem fio
sinal_rec_ric = filter(canal_ric, info_mod);
ganho_ray = canal_ray.PathGains;            % salvando os ganhos do canal
ganho_ric = canal_ric.PathGains;

for SNR = 0:15                                          %este loop representa a varia��o da SNR
    sinal_rec_ray_awgn = awgn(sinal_rec_ray,SNR);       % Modelando a inser��o do ruido branco no sinal recebido
    sinal_rec_ric_awgn = awgn(sinal_rec_ric,SNR);
    sinalEqRay = sinal_rec_ray_awgn./ganho_ray;         % (equalizando)eliminando os efeitos de rota��o de fase e altera��o de amplite no sinal recebido
    sinalEqRic = sinal_rec_ric_awgn./ganho_ric;
    sinalDemRay = pskdemod(sinalEqRay,M);               % demodulando o sinal equalizado
    sinalDemRic = pskdemod(sinalEqRic,M);
    [num_ray(SNR+1), taxa_ray(SNR+1)]  =symerr(info,sinalDemRay); % comparando a sequencia de informa��o gerada com a informa��o demodulada
    [num_ric(SNR+1), taxa_ric(SNR+1)]  =symerr(info,sinalDemRic);
end

semilogy([0:15],taxa_ray,'r',[0:15],taxa_ric,'b');grid on;
title('BER');xlabel('EbN0 [dB]');ylabel('BER');
legend('Rayleigh', 'Ricean (fator = 100)');