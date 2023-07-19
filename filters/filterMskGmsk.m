function detected_signal = filterMskGmsk(in, out,non_conj_alphas_thresholded,conj_alphas_thresholded)
    detected_signal = 'unknown';
    [~, locs_non_conj, ~, ~] = findpeaks(out.nonConjMaxCff, "NPeaks",3,"SortStr","descend");
    [~, locs_conj, ~, ~] = findpeaks(out.conjMaxCff, "NPeaks",2,"SortStr","descend");
%     conj_alphas = out.alphas(locs_conj);
    
    sym_rate_alpha = abs(out.alphas(locs_non_conj(2)));
    
    if sym_rate_alpha<0.1
        detected_signal = 'unknown';
    else
    
        detected_signal = 'msk/gmsk';
        return
    end
    
    [~, locs_non_conj, ~, ~] = findpeaks(out.nonConjSumCff, "NPeaks",3,"SortStr","descend");
    [~, locs_conj, ~, ~] = findpeaks(out.conjSumCff, "NPeaks",2,"SortStr","descend");
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
    if abs((max(conj_alphas)) - (min(conj_alphas))- sym_rate_alpha)<0.01
        detected_signal = 'msk/gmsk';
        return
    end
    
    if strcmp(detected_signal,'unknown')
        arr = conj_alphas_thresholded;
        for i = 1:numel(arr)
            smallerElements = arr < arr(i);
            result(smallerElements) = arr(i) - arr(smallerElements);
            if abs(any(result) - sym_rate_alpha)<0.01
                detected_signal = 'msk/gmsk';
                return
            end
        end
    end
end
