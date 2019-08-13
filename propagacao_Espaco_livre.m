clear all;
close all;
clc;

d = [1:1:500e3]; % vetor distancia
Pt_dBm = 14;     % potencia de transmissão
Gt_dBi = 2.55;   % ganho da antena TX
Gr_dBi = 2.55;   % ganho de antena RX
L_dB = 6;        % fator de perda do sistema
fc = 2.4e9;      % frequencia

lambda = 3e8/fc;           %comprimento de onda
Pt = 10^(Pt_dBm/10)*1e-3;
Gt = 10^(Gt_dBi/10);
Gr = 10^(Gr_dBi/10);
L = 10^(L_dB/10);

Pr = (Pt*Gr*Gt*(lambda^2))./((4*pi)^2*d.^2*L); % potencia recebida

Pr_dBm = 10*log10(Pr./1e-3);

figure(1)
plot(d,Pr);

figure(2)
plot(d,Pr_dBm);

figure(3)
semilogx(d,Pr_dBm);

PL_dB = 10*log10(Pt./Pr); %Perda de percurso - (Path Loss)

figure(4)
semilogx(d,PL_dB);