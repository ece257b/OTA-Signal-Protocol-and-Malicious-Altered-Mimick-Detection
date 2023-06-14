function ssca1Dplot(in, N, Np)

if length(in)<N+Np
    in = [in; zeros(1,9000-length(in))'];
end

S = sscaClass(N, Np, 100, 200);
out = S.process((in));

figure('Units', 'inches', 'Position', [0, 0, 8, 10]);

% Adjust the spacing properties
spacing = 0.05; % Modify this value to control the spacing between subplots

subplot(311)
faxis = -0.5:1/1024:0.5-1/1024;
plot(faxis, fftshift(20*log10(pwelch(in', 1024, 512, 1024))), 'LineWidth', 1.5)
title('PSD Estimate', 'FontSize', 14)
xlabel('Normalized Frequency', 'FontSize', 13)
ylabel('Magnitude (dB/Hz)', 'FontSize', 13)
grid on
set(gca,'FontName','Arial','FontSize',12,'FontWeight','Bold',  'LineWidth', 2);
subplot(312)
plot(out.alphas, out.nonConjSumCff, 'LineWidth', 1.5)

xlabel('Normalized Cycle Frequency', 'FontSize', 13)
ylabel('Magnitude', 'FontSize', 13)
grid on
set(gca,'FontName','Arial','FontSize',12,'FontWeight','Bold',  'LineWidth', 2);title('Non-conjugate CFF', 'FontSize', 14)

subplot(313)
plot(out.alphas, out.conjSumCff, 'LineWidth', 1.5)
xlabel('Normalized Cycle Frequency', 'FontSize', 13)
ylabel('Magnitude', 'FontSize', 13)
grid on
set(gca,'FontName','Arial','FontSize',12,'FontWeight','Bold',  'LineWidth', 2);title('Conjugate CFF', 'FontSize', 14)

end