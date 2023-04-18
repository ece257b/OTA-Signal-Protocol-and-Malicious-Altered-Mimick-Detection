folder = "/storage/data/rmathuria/cyclo/QAM_searchlight/QAM/";
metadata_folder = "/storage/data/rmathuria/cyclo/QAM/";
prediction_save_folder = "/storage/data/rmathuria/modClass/QAM_preds/";
files = dir(folder);

cnt = 1;
for i = 3:length(files)
    if ~(files(i).name(end-3:end) == '.png')
        if ~(files(i).name(end-4:end) == '.json')
            in_iq = read_complex_binary(folder+files(i).name);
            fid = fopen(metadata_folder + files(i).name(1:end-9)+ '.json', 'r');
            metaStr = fread(fid, '*char');
            if (isempty(metaStr))
                continue;
            end
            fclose(fid);
            in_metadata =jsondecode(reshape(metaStr, 1, []));
            predicted_mod = decisionTree(in_iq);
            actual_mod = groundTruthModulation(in_metadata.sourceArray(1).signalArray(1).requiredMetadata.modulation);
            
            disp('actual')
            disp(actual_mod)
            disp('predicted')
            disp(predicted_mod)
            
            pred_list{cnt} = predicted_mod;
            truth_list{cnt} = actual_mod;
            cnt = cnt + 1;
            close all
        end
    end
end

% Create confusion matrix
cm = confusionchart(truth_list, pred_list);

% Set chart title and axis labels
cm.Title = 'Modulation Confusion Matrix';
cm.XLabel = 'Predicted Modulation';
cm.YLabel = 'Actual Modulation';