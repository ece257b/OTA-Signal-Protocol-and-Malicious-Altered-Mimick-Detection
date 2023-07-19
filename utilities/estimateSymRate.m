function symbol_rate = estimateSymRate(non_conj_alphas,fs)
    symbol_rate.thresholded = max(non_conj_alphas)*fs;
    symbol_rate.dominant_peak = 
end 