close all; clear all; figure;

threshold = 1.5;


%% Load centroid
load('data/centriods/zigbee.mat');
load('data/centriods/zigbee_range_starts.mat');
load('data/centriods/zigbee_range_ends.mat');

%% Load testing set

% Specify the directory containing the .m files
directory = '/mnt/intB-ssdr0-240gb/chenk/cycloModRec/data/ssca/zigbee/';
sub_directory = {'altered-0', 'altered-0.1', 'altered-0.2', 'altered-0.3', 'altered-0.4'};

% Initialize a cell array to hold data from all files
distance_testing = [];
for d = 1 : length(sub_directory)

    distance = getDistance(strcat(directory, sub_directory{d}), cycle_peak_heights, range_begin, range_end);
    
    distance_testing = [distance_testing, distance];
end
subplot(3, 1, 1); histogram(distance_testing, 'BinMethod', 'scott', 'Normalization', 'probability', 'FaceAlpha', 0.5); 
title(strcat("ZIGBEE Peak Distance (Centroid = Zigbee-Non-Altered)"));
xlim([0, 2]); ylim([0, 0.5]); hold on;
plot([threshold, threshold], [0, 0.5], 'r--');


%% generate 1000 awgn and compare
awgn_files = '/mnt/intB-ssdr0-240gb/chenk/cycloModRec/data/ssca/awgn/altered-0';

distance_awgn = getDistance(awgn_files, cycle_peak_heights, range_begin, range_end);

subplot(3, 1, 2); histogram(distance_awgn, 'BinMethod', 'scott', 'Normalization', 'probability', 'FaceAlpha', 0.5); 
title(strcat("NOISE Peak Distance (Centroid = Zigbee-Non-Altered)"));
xlim([0, 2]); ylim([0, 0.5]); hold on;
plot([threshold, threshold], [0, 0.5], 'r--');

%% Radhika's dataset
radhika_dataset = '/mnt/intA-ssdr0-1tb/chenk/dataset/radhika_ssca';

dataset_mods = dir(radhika_dataset);

% Remove '.' and '..' directories
subFolders = dataset_mods(~ismember({dataset_mods.name}, {'.', '..'}));

distance_single_carrier = [];
% Display folder names
for k = 1 : length(subFolders)
    mod_path = strcat(radhika_dataset, "/", subFolders(k).name);

    distance = getDistance(mod_path, cycle_peak_heights, range_begin, range_end);

    distance_single_carrier = [distance_single_carrier, distance];

end

subplot(3, 1, 3); histogram(distance_single_carrier, 'BinMethod', 'scott', 'Normalization', 'probability', 'FaceAlpha', 0.5); hold on
title(strcat("SINGLE-CARRIER Peak Distance (Centroid = Zigbee-Non-Altered)"));
xlim([0, 2]); ylim([0, 0.5]); hold on;
plot([threshold, threshold], [0, 0.5], 'r--');


%% Calculate TPR and FPR
TPR_noise = 100 * sum(distance_testing < threshold) / length(distance_testing)
FPR_noise = 100 * sum(distance_awgn < threshold) / length(distance_awgn)

TPR_single_carrier = 100 * sum(distance_testing < threshold) / length(distance_testing)
FPR_single_carrier = 100 * sum(distance_single_carrier < threshold) / length(distance_single_carrier)
