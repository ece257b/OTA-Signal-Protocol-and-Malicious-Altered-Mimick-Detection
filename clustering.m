close all; clear all;

awgn_files = '/mnt/intB-ssdr0-240gb/chenk/cycloModRec/data/ssca/awgn/altered-0';
example_files = '/mnt/intB-ssdr0-240gb/chenk/cycloModRec/data/ssca/example';
freqhopper_files = '/mnt/intB-ssdr0-240gb/chenk/cycloModRec/data/ssca/freq_hopper';
lora_files = '/mnt/intB-ssdr0-240gb/chenk/cycloModRec/data/ssca/lora';



datasets_to_cmp = {awgn_files, example_files, freqhopper_files, lora_files};
datasets_names = {"NOISE", "EXAMPLE", "FREQ HOPPER", "LORA"};


distance_to_cmp = {};


threshold = 0.1;
plot_xlim = [0 0.5];
plot_ylim = [0 0.3];

%% Load centroid
load('data/centriods/zigbee_pk_hgt.mat');
load('data/centriods/zigbee_range_starts.mat');
load('data/centriods/zigbee_range_ends.mat');
load("data/centriods/zigbee_pk_pos.mat");

%% Load zigbee set

% Specify the directory containing the .m files
directory = '/mnt/intB-ssdr0-240gb/chenk/cycloModRec/data/ssca/zigbee';

sub_directory = {'altered-0', 'altered-0.1', 'altered-0.2', 'altered-0.3', 'altered-0.4'};

% Initialize a cell array to hold data from all files
distance_testing = [];
for d = 1 : length(sub_directory)

    distance = getDistance(strcat(directory, "/", sub_directory{d}), cycle_peaks, cycle_peak_heights, range_begin, range_end);
    figure(2); subplot(length(sub_directory), 1, d); histogram(distance, 'BinMethod', 'scott', 'Normalization','probability', 'FaceAlpha', 0.5); hold on;
    xlim(plot_xlim); ylim(plot_ylim); title(strcat("Zigbee ", sub_directory{d}));
    xlabel("Similarity Distance"); ylabel("%");
    distance_testing = [distance_testing, distance];
end


figure(1); subplot(length(datasets_to_cmp)+2, 1, 1); histogram(distance_testing, 'BinMethod', 'scott', 'Normalization', 'probability', 'FaceAlpha', 0.5); 
title(strcat("ZIGBEE Peak Distance (Centroid = Zigbee)"));
xlim(plot_xlim); ylim(plot_ylim); hold on;
xlabel("Similarity Distance"); ylabel("%");
plot([threshold, threshold], [0, 0.5], 'r--');


%% Compare with other datasets


for f = 1:length(datasets_to_cmp)
    distance = getDistance(datasets_to_cmp{f}, cycle_peaks, cycle_peak_heights, range_begin, range_end);
    distance_to_cmp{f} = distance;

    figure(1);subplot(length(datasets_to_cmp)+2, 1, f+1); histogram(distance, 'BinMethod', 'scott', 'Normalization', 'probability', 'FaceAlpha', 0.5); 
    title(strcat(datasets_names{f}, " Peak Distance (Centroid = Zigbee)"));
    xlim(plot_xlim); ylim(plot_ylim); hold on;
    xlabel("Similarity Distance"); ylabel("%");
    plot([threshold, threshold], [0, 0.5], 'r--');
end



%% Radhika's dataset
radhika_dataset = '/mnt/intB-ssdr0-240gb/chenk/cycloModRec/data/ssca/sc_ssca';

dataset_mods = dir(radhika_dataset);

% Remove '.' and '..' directories
subFolders = dataset_mods(~ismember({dataset_mods.name}, {'.', '..'}));

distance_single_carrier = [];
% Display folder names
for k = 1 : length(subFolders)
    mod_path = strcat(radhika_dataset, "/", subFolders(k).name);

    distance = getDistance(mod_path, cycle_peaks, cycle_peak_heights, range_begin, range_end);

    distance_single_carrier = [distance_single_carrier, distance];
end

figure(1); subplot(length(datasets_to_cmp)+2, 1, length(datasets_to_cmp)+2); histogram(distance_single_carrier, 'BinMethod', 'scott', 'Normalization', 'probability', 'FaceAlpha', 0.5); hold on
title(strcat("SINGLE-CARRIER Peak Distance (Centroid = Zigbee)"));
xlim(plot_xlim); ylim(plot_ylim); hold on;
xlabel("Similarity Distance"); ylabel("%");
plot([threshold, threshold], [0, 0.5], 'r--');



%% Calculate TPR and FPR
TPR_zigbee = 100 * sum(distance_testing < threshold) / length(distance_testing)
FPR_noise = 100 * sum(distance_to_cmp{1} < threshold) / length(distance_to_cmp{1})
FPR_example = 100 * sum(distance_to_cmp{2} < threshold) / length(distance_to_cmp{2})
FPR_freq_hopper = 100 * sum(distance_to_cmp{3} < threshold) / length(distance_to_cmp{3})
FPR_lora = 100 * sum(distance_to_cmp{4} < threshold) / length(distance_to_cmp{4})
FPR_single_carrier = 100 * sum(distance_single_carrier < threshold) / length(distance_single_carrier)
