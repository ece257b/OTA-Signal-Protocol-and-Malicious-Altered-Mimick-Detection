function detected_signal = filterGsm(out,fs)
    detected_signal = 'unknown';
    if strcmp(detected_signal, 'unknown')
         [~,locs,~,~] = findpeaks(out.conjSumCff,'NPeaks',3,'SortStr','descend');
         conj_alphas = sort(out.alphas(locs));

            for i=1:3
                for j = i+1:3
                    condition = abs((conj_alphas(j) - conj_alphas(i))*fs*1e-3) >66 &&  abs((conj_alphas(j) - conj_alphas(i))*fs*1e-3) <68;
                    if any(condition) 
                        detected_signal = 'gsm';
                        return
                    end 
                end 
            end 
    end 
end 