clear all; close all;

% Specify the directory where the .sigmf-psd files are stored
directoryPath = '/mnt/intB-ssdr0-240gb/chenk/cycloModRec/data/example_psd'; % Update this path as necessary

% Get a list of .sigmf-psd files in the directory
files = dir(fullfile(directoryPath, '*.psd'));

% Determine the number of files to plot
numFilesToPlot = min(10, length(files)); % Plot up to 10 files

% Prepare the figure for plotting
figure;
hold on; % Enable holding of multiple plots on the same figure

% Define a colormap or manually specify colors for each plot to differentiate them
colors = lines(numFilesToPlot); % Generates a set of colors

for i = length(files)-numFilesToPlot+1:length(files)-1
    % Open the current PSD file for reading
    fileID = fopen(fullfile(directoryPath, files(i).name), 'r');
    
    % Check if the file was successfully opened
    if fileID == -1
        error('Failed to open the file: %s', files(i).name);
    end
    
    % Read the PSD data from the file (float32, little-endian format)
    psdData = fread(fileID, inf, 'float32', 'ieee-le');
    
    % Close the file after reading
    fclose(fileID);
    
    % Convert PSD data to dB
    psdData_dB = 10 * log10(psdData + eps); % Adding eps to avoid log10(0)
    
    % Plot the PSD data in dB
    plot(psdData_dB, 'Color', colors(-length(files)+numFilesToPlot+i+1, :));
    
    % Optionally, add a legend entry for this file
    legendEntries{-length(files)+numFilesToPlot+i+1} = sprintf('File %d: %s', i, files(i).name); % Customize as needed
end


% Finalize the figure
hold off; % No more plots to add
title('Overlayed PSD Data');
xlabel('Frequency Bin');
ylabel('Power/Frequency (dB/Hz)');
grid on; % Turn on the grid
legend(legendEntries, 'Interpreter', 'none', 'Location', 'bestoutside'); % Show legend

