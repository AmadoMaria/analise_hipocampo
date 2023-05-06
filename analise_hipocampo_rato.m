load("Dados.mat")

sr = Dados.SR; % taxa de amostragem
dt = 1/sr; % período infinitesimal
tt = 0:dt:60; % tempo
full_signal=sin(2*pi*12*tt);

amostra_completo = Dados.Completo(1:length(tt));
amostra_estado1 = Dados.Estado1(1:length(tt));
amostra_estado2 = Dados.Estado2(1:length(tt));

hold on
plot(tt, amostra_completo)
plot(tt, amostra_estado1)
plot(tt, amostra_estado2)
hold off

%%
% 1) Espectograma do dado "Completo"

[s,f,t]=spectrogram(Dados.Completo,2*sr,sr/2,[],sr);
imagesc(t,f,abs(s))
ylim([0 50])
ylabel('Frequencia (Hz)')
xlabel('Time (s)')
axis xy

%%
% 2) Plotando o PSD dos dois estados na mesma figura
estado1_filtered = eegfilt(Dados.Estado1, sr, 0, 20);
estado2_filtered = eegfilt(Dados.Estado2, sr, 0, 20);
hold on
pwelch(estado1_filtered,2*sr,sr/2,[],sr);
pwelch(estado2_filtered,2*sr,sr/2,[],sr);
hold off
legend('estado1','estado2')

