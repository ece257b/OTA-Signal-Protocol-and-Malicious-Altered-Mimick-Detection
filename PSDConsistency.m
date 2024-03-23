clear all; close all;

Fs = 4e6;

% Specify the directory containing the .m files
directory = '/mnt/intB-ssdr0-240gb/chenk/cycloModRec/data/zigbee_ota';

% Get a list of all files and folders in the directory
filesAndFolders = dir(directory);

% Filter out the directories
files = filesAndFolders(~[filesAndFolders.isdir]);



figure;
hold on;
colors = lines(10);
for i = 101:1:110
    iq = readCF32File(files(i).name);
    [psd, freq] = calculatePSD(iq, Fs);
    plot(freq, 10*log10(psd), 'Color', colors(i-100,:), 'LineWidth', 1.5, 'DisplayName', ['Sequence ' num2str(i)]);
end

xlabel('Frequency (Hz)');
ylabel('Power/Frequency (dB/Hz)');
title('Power Spectral Density of Multiple I/Q Samples');
legend('show');
grid on;
hold off;