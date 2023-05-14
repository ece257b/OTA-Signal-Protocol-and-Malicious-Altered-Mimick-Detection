function detected_signal = filterMskGmsk(out,non_conj_alphas_thresholded)
    detected_signal = 'unknown';
    [~, locs_non_conj, ~, ~] = findpeaks(out.nonConjMaxCff, "NPeaks",3,"SortStr","descend");
    [~, locs_conj, ~, ~] = findpeaks(out.conjMaxCff, "NPeaks",2,"SortStr","descend");
    conj_alphas = out.alphas(locs_conj);
    
    sym_rate_alpha = abs(out.alphas(locs_non_conj(2)));
    
    if sym_rate_alpha<0.1
        detected_signal = 'unknown';
    else
        if abs((max(conj_alphas)) - (min(conj_alphas))- sym_rate_alpha)<0.01
            detected_signal = 'msk/gmsk';
            return
        end
    end
    
    sym_rate_alpha = round(min(non_conj_alphas_thresholded(non_conj_alphas_thresholded>0.09)),2);
    if length(non_conj_alphas_thresholded)<5
        if abs((max(conj_alphas)) - (min(conj_alphas))- sym_rate_alpha)<0.01
            detected_signal = 'msk/gmsk';
            return
        end
    end
 end
