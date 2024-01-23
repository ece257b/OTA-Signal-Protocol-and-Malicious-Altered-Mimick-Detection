% main_classifier.m 
% Main 1D feature classifier script 
% 
% Author: Radhika Mathuria
% Date created: 20 April 2023
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

top_folder ="/mnt/extC-hddr0-18tb/rmathuria/modulation/ota/real_searchlight/";
sprintf('Processing top-level folder %s', top_folder)
folders      = dir(top_folder);
folders(1:2) = [];
cnt          = 1;
pred_list = [];
truth_list = [];
for k = 1:3

    folder            = folders(k).name;
    subfolder         = dir(top_folder + folder);
    final_folder_path = strcat(top_folder,folder,'/',subfolder(3).name,'/');
    files             = dir(final_folder_path);
    files(1:2)        = [];

    sprintf('Processing folder: %s .....',folder)

    for i = 3:5
        if ~(files(i).name(end-4:end) == '.json')

            in_iq = read_complex_binary(fullfile(final_folder_path, files(i).name)); 
            searchlight_metadata = readSearchlightMetadata(final_folder_path+files(i).name+ '.json');
            ssca_out = ssca_iface(in_iq, searchlight_metadata.sampleRate);
	        filename = strcat(files(i).name, "_ssca.mat");
	        % save(filename, "-struct", "ssca_out");    
            figure; plot(ssca_out.alphas, ssca_out.conjMaxCff);
        end
    end
end

% figure

% cm = confusionchart(truth_list, pred_list,'Normalization','row-normalized');
% cm.Title = 'Modulation Confusion Matrix';
% cm.XLabel = 'Predicted Modulation';
% cm.YLabel = 'Actual Modulation';



