clear all; close all;

%% Marcos
top_folder ="data/";
ectb_prefix = "iq-ota-ectb-";
altered_pwr = ["-0", "-0.1", "-0.2", "-0.3", "-0.4"];


%% Read all the files and classify by altered (power) and unaltered

files_altered_0 = {};
files_altered_1 = {}; 
files_altered_2 = {};
files_altered_3 = {};
files_altered_4 = {};

sprintf('Processing top-level folder %s', top_folder)
folders      = dir(top_folder);

for k = 1:length(folders)

    folder            = folders(k).name;

    % Process with only ota data
    if(~any(endsWith(folder, "_ota")))
        continue;
    end

    % Construct file name prefix list to distinguish altered/unaltered
    signal_type = split(folder, "_");
    signal_type = signal_type{1, 1};
  
    prefix = strcat(ectb_prefix, signal_type, "-", altered_pwr);

    final_folder_path = strcat(top_folder,folder);
    files             = dir(final_folder_path);

    % Clasiify all the files and store them to different cells
    for i = 1:length(files)
        filename = files(i).name;
        if startsWith(filename, strcat(ectb_prefix, signal_type, altered_pwr(2)))
            files_altered_1{end+1} = strcat(final_folder_path, "/", filename);
        elseif startsWith(filename, strcat(ectb_prefix, signal_type, altered_pwr(3)))
            files_altered_2{end+1} = strcat(final_folder_path, "/", filename);
        elseif startsWith(filename, strcat(ectb_prefix, signal_type, altered_pwr(4)))
            files_altered_3{end+1} = strcat(final_folder_path, "/", filename);
        elseif startsWith(filename, strcat(ectb_prefix, signal_type, altered_pwr(5)))
            files_altered_4{end+1} = strcat(final_folder_path, "/", filename);
        elseif startsWith(filename, strcat(ectb_prefix, signal_type, altered_pwr(1)))
            files_altered_0{end+1} = strcat(final_folder_path, "/", filename);
        end
    end

end


%% Get SSCA outputs 
ssca_iface(files_altered_0, 4e6, "zigbee_altered_0");
% ssca_iface(files_altered_1, 4e6, "zigbee_altered_1");
% ssca_iface(files_altered_2, 4e6, "zigbee_altered_2");
% ssca_iface(files_altered_3, 4e6, "zigbee_altered_3");
ssca_iface(files_altered_4, 4e6, "zigbee_altered_4");


