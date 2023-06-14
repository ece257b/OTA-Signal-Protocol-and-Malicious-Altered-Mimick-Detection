function detected_signal = filterBle(out,fs)
% This function detects whether the given MSK/GMSK signal it gets has
% cyclic features coresponding to BLE or not. Both 1 MHz and 2 MHz BLE are
% considered, and the cycle frequencies based on these sample rates are
% looked for.

    detected_signal = 'unknown';
    [~,locs,~,~] = findpeaks(out.conjMaxCff,'NPeaks',3,'SortStr','descend');
    conj_alphas = sort(out.alphas(locs));

    for i=1:3
        for j = i+1:3
            condition = abs((conj_alphas(j) - conj_alphas(i))*fs*1e-6) >0.9 &&  abs((conj_alphas(j) - conj_alphas(i))*fs*1e-6) <1.01;
            condition1 = abs((conj_alphas(j) - conj_alphas(i))*fs*1e-6) >1.9 &&  abs((conj_alphas(j) - conj_alphas(i))*fs*1e-6) <2;
            if any(condition) || any(condition1)
                detected_signal = 'ble';
                return
            end 
        end 
    end 

    if strcmp(detected_signal, 'unknown')
         [~,locs,~,~] = findpeaks(out.conjSumCff,'NPeaks',3,'SortStr','descend');
         conj_alphas = sort(out.alphas(locs));

            for i=1:3
                for j = i+1:3
                    condition = abs((conj_alphas(j) - conj_alphas(i))*fs*1e-6) >0.9 &&  abs((conj_alphas(j) - conj_alphas(i))*fs*1e-6) <1.01;
                    condition1 = abs((conj_alphas(j) - conj_alphas(i))*fs*1e-6) >1.9 &&  abs((conj_alphas(j) - conj_alphas(i))*fs*1e-6) <2;
                    if any(condition) || any(condition1)
                        detected_signal = 'ble';
                        return
                    end 
                end 
            end 
    end 
end