function flag=filterRealMods(nonConj1D, conj1D)
    % This function checks if the 2 1D CFFs are identical or not - This
    % would happen in the case of real signals 

    prominence_tolerance = 0.3;
    flag = 0;
    [pks_nconj, locs_nconj, ~, p_nonconj] = findpeaks(nonConj1D, "NPeaks",3,"SortStr","descend");
    [pks_conj, locs_conj, ~, p_conj] = findpeaks(conj1D, "NPeaks",3,"SortStr","descend");
   
    % later - apply CFO correction 
    % check the prominences
    if abs(p_nonconj(1) - p_conj(1)) < prominence_tolerance*max(p_nonconj(1),p_conj(1))
        flag = 1;
    end 
end