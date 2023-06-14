function constructAnalyticsVec(meta, folder, fname, gt, pred,symbol_rate)
    base_folder = "/mnt/ext_hdd18tb/rmathuria/modulation/simulated/analysis_jsons_real_final/";
    % Handle missing entries
    analysis_meta = meta;  
    analysis_meta.boxSize = meta.freqHi - meta.freqLo;
    analysis_meta.prediction = pred;
    analysis_meta.truth = gt;

%     extract channel through regex (temporary hack)
    pattern = '_([0-9]+)';
    match = regexp(fname, pattern, 'tokens', 'once');

    % Check if a match is found and retrieve the number
    if ~isempty(match)
        number = str2double(match{1});
        analysis_meta.channel = number;
    end
    matches = regexp(fname, '_(\d*\.?\d+)_', 'tokens');

    % Extract the matched substring
    number=matches{2};  
    analysis_meta.trueSymRate = str2double(number);
 
    analysis_meta.symRate = symbol_rate;
    jsonStr = jsonencode(analysis_meta);
    filename = strcat(fname, '.json');
       
    fullPath = fullfile(base_folder,folder, filename);
    fileID = fopen(fullPath, 'w');
    fprintf(fileID, jsonStr);
    fclose(fileID);
end
