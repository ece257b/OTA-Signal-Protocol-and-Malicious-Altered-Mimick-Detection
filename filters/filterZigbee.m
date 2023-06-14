function detected_signal = filterZigbee(out, fs)
     detected_signal = 'unknown';
        [~,locs,~,~] = findpeaks(out.conjMaxCff,'NPeaks',3,'SortStr','descend');
        conj_alphas = sort(out.alphas(locs));
    
        for i=1:3
            for j = i+1:3
                condition = abs((conj_alphas(j) - conj_alphas(i))*fs*1e-6) >0.24 &&  abs((conj_alphas(j) - conj_alphas(i))*fs*1e-6) <0.26;
                if any(condition) 
                    detected_signal = 'zigbee';
                    return
                end 
            end 
        end 
end 