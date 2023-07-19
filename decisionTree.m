function [detected_signal,sym_rate] = decisionTree(in,fs)

    % default vals in case function exits early
    sym_rate = 0;
    detected_signal = "unknown";
    
    if length(in)<(2046+128) % This is the minimum resolution below which the algorithm will not run
        return
    else
        [N, Np] = returnSscaParams(length(in)); % Dynamically vary N, Np based on length of signal
    end

    S = sscaClass(N, Np, 100, 200);
    out = S.process(in);       
     
    [conj_alphas, ~] = peakFinder(out,'conj');
    [non_conj_alphas, non_conj_alphas_hts] = peakFinder(out,'nonconj');

    detected_signal = 'unknown'; % before starting, assign an unknown label to the modulation

    if strcmp(detected_signal,'unknown')
        if ~(filterToneCfs(in,out))
            detected_signal = filterDsssLike(non_conj_alphas,non_conj_alphas_hts,fs);
        end 
    else
        return
    end 

    if strcmp(detected_signal,'unknown')
        if length(conj_alphas)>=1
            detected_signal = filterBpskBfsk(in,out,non_conj_alphas);
        end 
    end
  
    if strcmp(detected_signal,'unknown')
        modOrder = filterFsk(in,out);
        if ~isempty(modOrder)
            if modOrder == 1
                modOrder =2;
            end 
            modOrder = 2^round(log2(modOrder));
            if modOrder == 2
                detected_signal = 'g/fsk2';
            else
                detected_signal = strcat('fsk',num2str(modOrder));
            end
        end 
    else
        return
    end 
 
    if strcmp(detected_signal,'unknown')
        if ~(filterToneCfs(in,out))
            detected_signal = filterMskGmsk(in, out,non_conj_alphas,conj_alphas);
        end
    else
        return
    end 
    if strcmp(detected_signal,'unknown')
        detected_signal = filterFsk8(in, out);
    end 

    if strcmp(detected_signal,'unknown')
        if ~isempty(non_conj_alphas)
            if ~(filterToneCfs(in,out))
                detected_signal =  filterDqam(in,conj_alphas,non_conj_alphas);
            end 
        end
    else
        return
    end     
end 
