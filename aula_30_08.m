clear all;
close all;
clc;

Rs = 100e3;                              %taxa de transmissão de simbolos
Tb = 1/Rs;                               %tempo de simbolo, nesse caso tempo de bit, pois a transmissão é binária
doppler = 3;                           %simula 3 hertz = modelo de uma pessoa caminhando
k = 10;                                   %parâmetro Riciano
num_sym = 1e6;                           %número de simbolos a ser transmitido
M = 2;                                   %ordem da modulaçaõ
SNR = 10;

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%Trabalhando com a imagem
A = imread('img.jpg');
A_serial = reshape(A,1,(size(A,1)*size(A,2)*size(A,3)));
A_bin = de2bi(A_serial);
A_bin(1:10,:);
A_bin_serial = reshape(A_bin,1,(size(A_bin,1)*size(A_bin,2)));
info = double(A_bin_serial);
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%info = randi([0,1],num_sym,1);           %cria a informação aleatória, nesse caso cria uma informação aleatória binária
info_mod = pskmod(info,M);               %modula a informação, nesse caso PSK
%gera o objeto que representa o canal
canal_ray = rayleighchan(1/Rs,30);          
canal_ric = ricianchan(1/Rs,doppler,k);
%habilitando a gravação dos ganhos do canal
canal_ray.StoreHistory = 1;
canal_ric.StoreHistory = 1;
%filter representa o ato de transmitir por um canal sem fio
sinal_recebido_ray = filter(canal_ray,info_mod);
sinal_recebido_ric = filter(canal_ric,info_mod);
%salvando os ganhos do canal
ganho_ray = canal_ray.PathGains;
ganho_ric = canal_ric.PathGains;
  
%modelando a inserção do ruído nos sinais recebidos
sinalRx_ray_awgn = awgn(sinal_recebido_ray, SNR);
sinalRx_ric_awgn = awgn(sinal_recebido_ric, SNR);
%(equalização) = elimina os efeitos de rotação de fase e alteração de amplitude do sinal recebido
sinalEq_ray = sinalRx_ray_awgn./ganho_ray;      
sinalEq_ric = sinalRx_ric_awgn./ganho_ric;
%sinais demodulados
sinal_demodulado_ray = pskdemod(sinalEq_ray,M);
sinal_demodulado_ric = pskdemod(sinalEq_ric,M);
%comparando a sequência de informação gerada com a informação demodulada, para análise de erros
[num_ray, taxa_ray]= symerr(info,sinal_demodulado_ray)
[num_ric, taxa_ric]= symerr(info,sinal_demodulado_ric)


%plot
%semilogy([0:30],taxa_ray,'r',[0:30], taxa_ric,'b');grid on;
%title('Desempenho BER X SNR'); ylabel('BER');xlabel('SNR [dB]');