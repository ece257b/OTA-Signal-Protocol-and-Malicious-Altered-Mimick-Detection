folder = "/storage/data/rmathuria/cyclo/dssspsk_searchlight/dssspsk/";
metadata_folder = "/storage/data/rmathuria/cyclo/dssspsk/";
files = dir(folder);
truth_list = [];
pred_list = [];

for i = 3:length(files)
    if ~(files(i).name(end-3:end) == '.png')
        if ~(files(i).name(end-4:end) == '.json')
            in_iq = read_complex_binary(folder+files(i).name);
            fid = fopen(metadata_folder+files(i).name(1:end-9) + '.json', 'r');
            metaStr = fread(fid, '*char');
            if (isempty(metaStr))
                continue;
            end
            fclose(fid);
            in_metadata =jsondecode(reshape(metaStr, 1, []));
            predicted_mod = decisionTree(in_iq);
            actual_mod = groundTruthModulation(in_metadata.sourceArray(1).signalArray(1).requiredMetadata.modulation);

            pred_list = [pred_list predicted_mod];
            truth_list = [truth_list actual_mod];
        end
    end
end

% Create confusion matrix
cm = confusionchart(truth_list, pred_list);

% Set chart title and axis labels
cm.Title = 'Modulation Confusion Matrix';
cm.XLabel = 'Predicted Modulation';
cm.YLabel = 'Actual Modulation';