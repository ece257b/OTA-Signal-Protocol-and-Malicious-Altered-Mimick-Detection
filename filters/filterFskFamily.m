function detected_signal = filterFskFamily(nonConj1D, conj1D, alphas)

    % Use findpeaks to get the symbol rate
    [~, locs_non_conj , ~, ~] = findpeaks(nonConj1D, 'NPeaks',3,'SortStr','descend');
    [~, locs_conj, ~, ~] = findpeaks(conj1D, 'NPeaks',3,'SortStr','descend');

    % For GFSK/FSK, the distance between 2 peaks in conjugate wont be half
    % the symbol rate ever, while for MSK/GMSK it is not so.

    sym_rate_alpha = (abs(alphas(locs_non_conj(2))) + abs(alphas(locs_non_conj(3))))/2;

    for i=1:2
        if abs((abs(alphas(locs_conj(i))) + abs(alphas(locs_conj(i+1)))) - sym_rate_alpha)<0.05
            detected_signal = 'MSK/GMSK';
            break;
        else
            detected_signal = 'FSK/GFSK';
        end
    end

end