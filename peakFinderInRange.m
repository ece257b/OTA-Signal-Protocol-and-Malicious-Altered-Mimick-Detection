function [cycle_peaks, cycle_peak_heights, pk_prominence] = peakFinderInRange(in_vec, pattern_starts, pattern_ends)

    alphas = linspace(-1, 1, length(in_vec));
    
    cycle_peaks = zeros(1, length(pattern_starts));
    cycle_peak_heights = zeros(1, length(pattern_starts));
    pk_prominence = zeros(1, length(pattern_starts));

    for i = 1:length(pattern_starts)
        pattern = in_vec(pattern_starts(i):pattern_ends(i));
        [pk, idx] = max(pattern);

        cycle_peaks(i) = alphas(pattern_starts(i) + idx);
        cycle_peak_heights(i) = pk;
        pk_prominence(i) = pk / min(pattern) - 1;

    end
    

end