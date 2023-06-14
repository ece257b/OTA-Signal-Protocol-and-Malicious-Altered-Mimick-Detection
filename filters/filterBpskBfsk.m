function detected_signal=filterBpskBfsk(in,out,non_conj_alphas)
% This function detects BPSK and BFSK modulations in the given input signal
% by implementing the rules for these 2 modulations.

    detected_signal = 'unknown';
    [~, locs_nconj, ~, ~] = findpeaks(out.nonConjMaxCff, "NPeaks",3,"SortStr","descend");
    [~, locs_conj, ~, ~] = findpeaks(out.conjMaxCff, "NPeaks",3,"SortStr","descend");
       
    % is the highest peak the middle one in both the cases?
    sort_locs_nconj = sort(locs_nconj);
    sort_locs_conj = sort(locs_conj);
    
    if isempty(detectTone(in))
        % distance between peaks in conj = symbol rate
        sym_rate_alpha = abs(round(out.alphas(locs_nconj(2)),2));
        conj_alpha_dist = computeAlphaDistance(out.alphas(locs_conj));
        condition =  abs(conj_alpha_dist - sym_rate_alpha) < 0.02 ;
        if any(condition)
            flag =1;
            if flag == 1
                detected_signal = 'bpsk';
                return
            else
                detected_signal = 'noise';
            end
        end
    elseif filterFsk(in,out) == 2
        detected_signal = 'g/fsk2';
        return 
    elseif length(detectTone(in)) ==1
        % distance between peaks in conj = symbol rate
        condition =  abs(abs(out.alphas(locs_conj(1))) - abs(2*detectTone(in))) < 0.03 ;
        if condition
            detected_signal = 'ook';
            return
        end
    end

    % Is the relative distance between the peaks same? 
    dist1 = diff(sort_locs_nconj);
    dist2 = diff(sort_locs_conj);

    if ~(abs(dist1 - dist2) <3)
        detected_signal = 'unknown';
    end

end