%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% main_classifier.m 
% Main 1D feature classifier script 
% 
% Author: Radhika Mathuria
% Date created: 20 April 2023
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

top_folder ="/mnt/ext_hdd18tb/rmathuria/modulation/simulated/real_searchlight/";

sprintf('Processing top-level folder %s', top_folder)
folders      = dir(top_folder);
folders(1:2) = [];
cnt          = 1;
pred_list = [];
truth_list = [];
for k = 1:length(folders)

    folder            = folders(k).name;
    subfolder         = dir(top_folder + folder);
    final_folder_path = strcat(top_folder,folder,'/',subfolder(3).name,'/');
    files             = dir(final_folder_path);
    files(1:2)        = [];

    sprintf('Processing folder: %s .....',folder)

    for i = 1:length(files)
        if ~(files(i).name(end-4:end) == '.json')

            in_iq = read_complex_binary(fullfile(final_folder_path, files(i).name)); 
            searchlight_metadata = readSearchlightMetadata(final_folder_path+files(i).name+ '.json');
            [pred_mod, symbol_rate] = decisionTree(in_iq,searchlight_metadata.sampleRate);
            gt_mod   = cell2mat(regexp(files(i).name,'^[^_]*', 'match'));
            gt_mod   = groundTruthModulation(gt_mod);
%             disp(gt_mod)
%             disp(pred_mod)
                      
            pred_list{cnt}  = pred_mod;

            if strcmp(gt_mod,'g/fsk')
                match = regexp(files(i).name, '^(?:[^_]*_){6}([^_])', 'tokens', 'once');
                truth_list{cnt} = strcat(gt_mod,match{1});
            else
                truth_list{cnt} = gt_mod;
            end 
           
            correct_flag = 0;
            if strcmp(pred_mod,gt_mod)
                correct_flag = 1;
            end

            constructAnalyticsVec(searchlight_metadata, folder, files(i).name, gt_mod, pred_mod,symbol_rate);
            cnt = cnt + 1;
        end
    end
end

figure

cm = confusionchart(truth_list, pred_list,'Normalization','row-normalized');
cm.Title = 'Modulation Confusion Matrix';
cm.XLabel = 'Predicted Modulation';
cm.YLabel = 'Actual Modulation';



