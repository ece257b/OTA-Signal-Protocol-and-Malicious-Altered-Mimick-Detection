clear all; close all;


%% Marcos
medfilt_window = 200;
th_scale = 1.15;
directoryPath = "./data/signatures/example_new"; 


%% Read alphas and sum nonconj

signatures = dir(fullfile(directoryPath, '*.32f'));

alphas = [];
sum_nonconj = [];
for i = 1:length(signatures)

    filePath = fullfile(directoryPath, signatures(i).name);
    fid = fopen(filePath, 'rb');

    if endsWith(filePath, "cycles.32f")
        alphas = fread(fid, inf, 'single');
    elseif endsWith(filePath, "merged_ssca.32f")
        sum_nonconj = fread(fid, inf, 'single');
    end

    fclose(fid);

end


figure(1); plot(alphas, sum_nonconj); hold on;




%% Peaker Finder
threshold = medfilt1(sum_nonconj, medfilt_window);
thresh = th_scale * threshold;

indices = find(sum_nonconj>thresh);
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
    cycle_peaks = alphas(midpoints);
    cycle_peak_heights = sum_nonconj(midpoints);

    plot(cycle_peaks, cycle_peak_heights, 'rv');
end


%% Write indices of interest into a file
% Open a file named 'data.32f' for writing in binary mode
fileID = fopen(fullfile(directoryPath, "cycles_of_interest.32f"), 'wb');

% Check if file was opened successfully
if fileID == -1
    error('Failed to open file.');
end

% Write the array to the file as 32-bit floats
fwrite(fileID, cycle_peaks, 'single');

% Close the file
fclose(fileID);
