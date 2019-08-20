clear all;
close all;
clc;

tempoAmostragem = 10e3;
doppler = 3; %%simula 3 hertz - pessoa caminhando
info = randi([0,1],1,5000);
info_mod = pskmod(info,2);
canal = rayleighchan(1/tempoAmostragem,doppler);
canal.StoreHistory = 1;

sinal_recebido = filter(canal,info_mod);