close all

folder = "/mnt/ext_hdd_18tb/rmathuria/dsss_updated_searchlight/DSSS_searchlight/DSSS/";
metadata_folder = "/mnt/ext_hdd_18tb/rmathuria/dsss_updated/dsss_ota/";
files = dir(folder);
cnt = 1;

for i = 3:length(files)
    if ~(files(i).name(end-3:end) == '.png')
        if ~(files(i).name(end-4:end) == '.json')

            close all
            in_iq = read_complex_binary(folder+files(i).name);

            if length(in_iq) < 9000
                continue;
            end  

            fid = fopen(metadata_folder + files(i).name(1:end-13)+ '.json', 'r');
%             fid = fopen(metadata_folder + files(i).name+ '.json', 'r');
            metaStr = fread(fid, '*char');

            if (isempty(metaStr))
                continue;
            end
            fclose(fid);
            in_metadata =jsondecode(reshape(metaStr, 1, []));


            % grab sample rate             
            fid = fopen(folder + files(i).name+ '.json', 'r');
            metaStr_searchlight = fread(fid, '*char');
            if (isempty(metaStr))
                continue;
            end
            fclose(fid);
            
            searchlight_metadata =jsondecode(reshape(metaStr_searchlight, 1, []));
            predicted_mod = decisionTree(in_iq,searchlight_metadata.sampleRate);
            gt_mod = cell2mat(regexp(files(i).name,'^[^_]*', 'match'));
            actual_mod = groundTruthModulation(gt_mod);
%             actual_mod = groundTruthModulation(in_metadata.sourceArray(1).signalArray(1).requiredMetadata.modulation);
            disp('actual')
            disp(actual_mod)
            disp('predicted')
            disp(predicted_mod)

            pred_list{cnt} = predicted_mod;
            truth_list{cnt} = actual_mod;
            cnt = cnt + 1;

            % debug mode
            if(~strcmp(predicted_mod,'qam/psk'))
                k=1;
                predicted_mod = decisionTree(in_iq);
            else
                disp('correct')
            end 
        end
    end
end

figure

cm = confusionchart(truth_list, pred_list);
cm.Title = 'Modulation Confusion Matrix';
cm.XLabel = 'Predicted Modulation';
cm.YLabel = 'Actual Modulation';