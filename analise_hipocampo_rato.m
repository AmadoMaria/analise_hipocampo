load("Dados.mat")

sr = Dados.SR; % taxa de amostragem
dt = 1/sr; % período infinitesimal
tt = 0:dt:60; % tempo
full_signal=sin(2*pi*12*tt);

amostra_completo = Dados.Completo(1:length(tt));
amostra_estado1 = Dados.Estado1(1:length(tt));
amostra_estado2 = Dados.Estado2(1:length(tt));

figure(1)
hold on
plot(tt, amostra_completo)
plot(tt, amostra_estado1)
plot(tt, amostra_estado2)
hold off

%%
% 1) Espectograma do dado "Completo"
figure(2)
[s,f,t]=spectrogram(Dados.Completo,2*sr,sr/2,[],sr);
imagesc(t,f,abs(s))
colorbar
clim([0 50]) %caxis não é recomendado
ylim([0 50])
ylabel('Frequencia (Hz)')
xlabel('Time (s)')
axis xy

%%
% 2) Plotando o PSD dos dois estados na mesma figura
estado1_filtered = eegfilt(Dados.Estado1, sr, 0, 20);
estado2_filtered = eegfilt(Dados.Estado2, sr, 0, 20);

figure(3)
hold on
[pxx1,f1]=pwelch(estado1_filtered,2*sr,sr/2,[],sr);
[pxx2,f2]=pwelch(estado2_filtered,2*sr,sr/2,[],sr);

plot(f1, pxx1)
plot(f2, pxx2)
set(gca,'XLim',[0 30])
hold off
legend('estado1','estado2')
% O estado1 representa o REM, já que a densidade espectral no intervalo de
% 4Hz a 12Hz é maior em comparação ao estado2, e de acordo com o artigo
% (adicionar referência) existe um aumento significativo do theta no REM em
% comparação com o SWS
%%
% 3) 
estado1_filtered_theta = eegfilt(Dados.Estado1, sr, 4, 12);
tt_est1 = (1:length(Dados.Estado1))*dt;
hilb_theta = hilbert(estado1_filtered_theta);

figure(4)
hold on
plot(tt_est1, Dados.Estado1)
plot(tt_est1, estado1_filtered_theta)
hold off

figure(5)
plot(angle(hilb_theta))

estado1_filtered_hfo = eegfilt(Dados.Estado1, sr, 100, 160);
hilb_hfo = hilbert(estado1_filtered_hfo);

figure(6)
hold on
plot(tt_est1, estado1_filtered_hfo)
plot(abs(hilb_hfo))
hold off

