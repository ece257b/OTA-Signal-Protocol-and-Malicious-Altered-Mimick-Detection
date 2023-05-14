function detected_signal=filterBpskBfsk(in,out,non_conj_alphas)

    detected_signal = 'unknown';
    [~, locs_nconj, ~, ~] = findpeaks(out.nonConjMaxCff, "NPeaks",3,"SortStr","descend");
    [~, locs_conj, ~, ~] = findpeaks(out.conjMaxCff, "NPeaks",3,"SortStr","descend");
       
    % is the highest peak the middle one in both the cases?
    sort_locs_nconj = sort(locs_nconj);
    sort_locs_conj = sort(locs_conj);
    
    if isempty(detectTone(in))
        if length(non_conj_alphas)<4
        % distance between peaks in conj = symbol rate
        sym_rate_alpha = abs(round(out.alphas(locs_nconj(2)),2));
        conj_alpha_dist = computeAlphaDistance(out.alphas(locs_conj));
        condition =  abs(conj_alpha_dist - sym_rate_alpha) < 0.03 ;
        if any(condition)
            detected_signal = 'bpsk';
            return
        end
        end 
    elseif filterFsk(in,out) == 2
        detected_signal = 'g/fsk2';
        return
    end

    % Is the relative distance between the peaks same? 
    dist1 = diff(sort_locs_nconj);
    dist2 = diff(sort_locs_conj);

    if ~(abs(dist1 - dist2) <3)
        detected_signal = 'unknown';
    end

end