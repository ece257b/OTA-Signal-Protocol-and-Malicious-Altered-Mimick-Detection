function flags = filterDsssLike(non_conj_alphas)

% This function takes in a list of non-conjugate cycle frequencies
% (obtained after thresholding a cyclic feature function) and identifies if
% they follow a dsss-like pattern or not. If so, it returns the symbol
% rate, chip rate and if not, it only returns the symbol rate
% Note: Some harmonics may be incomplete due to an estimation error during
% thresholding
%     
%     harmomic_threshold = 0.001;
%     non_conj_alphas = non_conj_alphas(non_conj_alphas>0);
%     freq_list = sort(non_conj_alphas);
%     data_rate_alpha = [];
%     chip_rate_alpha = [];
%     fundamentalFreq = freq_list(1);
%     freq_ratios = freq_list / fundamentalFreq;
%     harmonicIndices = find(mod(freq_ratios, 1) <= harmomic_threshold);
%     harmonics = {};
%     
%     for i = harmonicIndices
%         harmonics{end+1} = freq_list(mod(find(freq_ratios == i, 1)-1:length(freq_ratios)-1, length(freqRatio))+1);
%     end
    flags = 0;
end