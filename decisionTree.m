function detected_signal = decisionTree(in,fs)

    N = 8192;
    Np = 128;
    
    S = sscaClass(N, Np, 100, 200);
    out = S.process(in);       
     
    conj_alphas = peakFinder(out,"configs/conjugate.yaml",'conj');
    non_conj_alphas = peakFinder(out,"configs/non_conjugate.yaml",'nonconj');

    detected_signal = 'unknown';
    
    if strcmp(detected_signal,'unknown')
        if length(conj_alphas)>2
            detected_signal = filterBpskBfsk(in,out,non_conj_alphas);
        end 
    end 
    if strcmp(detected_signal,'unknown')
        if isempty(detectTone(in))
        detected_signal = filterDsssLike(non_conj_alphas);
        end 
    else
        return
    end
    if strcmp(detected_signal,'unknown')
        modOrder = filterFsk(in,out);
        if ~isempty(modOrder)
            if modOrder == 1
                modOrder =2;
            end 
            detected_signal = 'g/fsk'+2^round(log2(modOrder));
        end 
    else
        return
    end 
 
%     if isempty(conj_alphas)
%         detected_signal = filterWiFi(out,fs);
%     end 
    
    if strcmp(detected_signal,'unknown')
        if length(conj_alphas)>1
            if fs>=1e6 && fs<=3.5e6
                detected_signal = filterBle(out,fs);
            end
        end
    else
        return
    end 
    if strcmp(detected_signal,'unknown')
        detected_signal = filterMskGmsk(out,non_conj_alphas);
    else
        return
    end 

    if strcmp(detected_signal,'unknown')
        if ~isempty(non_conj_alphas)
            if isempty(detectTone(in))
                detected_signal =  filterDqam(conj_alphas,non_conj_alphas);
            end 
        end
    else
        return
    end

    
end 
