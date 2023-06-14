function symbol_rate = estimateSymRate(non_conj_alphas,fs)
    symbol_rate = max(non_conj_alphas)*fs;
end 