clear all; close all;


WINDOW = 200;
SCALE = 2.8;

%% Load data
% Specify the directory containing the .m files
directory = '/mnt/intB-ssdr0-240gb/chenk/cycloModRec/data/ssca/example';

% Get a list of all .m files in the directory
files = dir(fullfile(directory, '*.dat'));

% Initialize a cell array to hold data from all files
training = {};

% Loop through validFileCount = 0;each file
validFileCount = 0;
for k = 1:ceil(length(files))
    if endsWith(files(k).name, "alphas.dat")
        % Construct the full file path
        filePath = fullfile(directory, files(k).name);
    
        % Load the file
        fid = fopen(filePath, 'rb');
        alphas = fread(fid, inf, 'single');
        fclose(fid);

        continue;
    end

    if endsWith(files(k).name, "max_nonconj.dat")
        validFileCount = validFileCount + 1;

        % Construct the full file path
        filePath = fullfile(directory, files(k).name);
    
        % Load the file
        fid = fopen(filePath, 'rb');
        data = fread(fid, inf, 'single');
        fclose(fid);

        % Assuming the variable name is 'yourVariableName'
        % Store the data in the cell array
        training{validFileCount} = data;
    end
end


%% get nonConjSumCff, normalize and concatnate
training_nonConjSumCff = zeros(length(training), length(training{1}));
for i = 1 : length(training)
    minVal = min(training{i});
    maxVal = max(training{i});
    normalized_nonConjMaxCff = (training{i} - minVal) / (maxVal - minVal);
    training_nonConjSumCff(i, :) = normalized_nonConjMaxCff;
end


%% Find possibility of common eaks
fft_rslt = fft(training_nonConjSumCff, [], 1);
[numRows, numCols] = size(fft_rslt);
dcRatios = zeros(1, numCols);

for col = 1:numCols
    magnitudeSpectrum = abs(fft_rslt(:, col));
    dcPower = magnitudeSpectrum(1)^2;
    totalPower = sum(magnitudeSpectrum.^2);
    dcRatios(col) = dcPower*dcPower / totalPower;
end

pk_avg = fft_rslt(1, :);
alphas = linspace(-1, 1, length(dcRatios));
figure; plot(alphas, pk_avg); hold on;


%% Filter out the peaks 
threshold = medfilt1(dcRatios,WINDOW);
thresh = SCALE * threshold;

indices = find(dcRatios>thresh);
diff_arr = diff(indices);
if ~isrow(diff_arr)
    diff_arr = diff_arr';
end
pattern_starts = [1, find(diff_arr ~= 1)+1];
pattern_ends = [pattern_starts(2:end)-1, length(indices)];
    
midpoints = [];
filtered_pattern_starts = [];
filtered_pattern_ends = [];
for i = 1:length(pattern_starts)
    pattern = indices(pattern_starts(i):pattern_ends(i));
    midpoint = round(mean(pattern));
    if ~ismember(midpoint, midpoints)
        if midpoint >= 1000 && midpoint <= 16000
            filtered_pattern_starts = [filtered_pattern_starts, pattern_starts(i)];
            filtered_pattern_ends = [filtered_pattern_ends, pattern_ends(i)];
        end
        midpoints = [midpoints, midpoint];
    end
end
    
if isnan(midpoints)
    cycle_peaks = 0;
    cycle_peak_heights = 0;
else
    midpoints = midpoints(midpoints>1000);
    midpoints = midpoints(midpoints<16000);
    cycle_peaks = round((alphas(midpoints)),2);
    cycle_peak_heights = pk_avg(midpoints);

    plot(cycle_peaks, cycle_peak_heights, 'rv');
end

max_pk = max(cycle_peak_heights);
min_pk = min(cycle_peak_heights);
cycle_peak_heights = (cycle_peak_heights - min_pk) / (max_pk - min_pk);

save('data/centriods/example_pk_hgt.mat', "cycle_peak_heights");
save('data/centriods/example_pk_pos.mat', 'cycle_peaks');

range_begin = indices(filtered_pattern_starts);
range_end = indices(filtered_pattern_ends);

save("data/centriods/example_range_starts.mat", "range_begin");
save("data/centriods/example_range_ends.mat", "range_end");
