function constructAnalyticsVec(meta,folder,fname,gt,pred)
    analysis_meta = struct();
    analysis_meta.trueEsNo = meta.trueEsNo;
    analysis_meta.SNR = meta.SNR;
    analysis_meta.ENR = meta.ENR;
    analysis_meta.snrAfter = meta.snrAfter;
    analysis_meta.trueBandwidth = meta.trueBandwidth;
    analysis_meta.boxSize = meta.freqHi-meta.freqLo;
    analysis_meta.prediction = pred;
    analysis_meta.truth = gt;

    jsonStr = jsonencode(analysis_meta);
    filename = strcat(fname,'.json');
    fullPath = fullfile('/mnt/ext_hdd_18tb/rmathuria/analysis_jsons/',folder, filename);

    fileID = fopen(fullPath, 'w');
    fprintf(fileID, jsonStr);
    fclose(fileID);
end 