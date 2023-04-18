function detected_signal = decisionTree(in)

    N = 8192;
    Np = 128;
    
    if length(in)<(N+Np)
        in = [in; zeros(10000-length(in),1)];
    end 
    
    S = sscaClass(N, Np, 100, 200, 1);
    conjScfEst = S.process(in);
    
    S = sscaClass(N, Np, 100, 200, 0);
    nonConjScfEst = S.process(in);
    
    nonConjCohEst = S.getCoherence(nonConjScfEst,in);
    conjCohEst = S.getCoherence(conjScfEst,in);
    
    [alphas, ~] = S.getFrequencies();
    alphas = unique(alphas(:));
  
    nonConj1D = S.remapTo1DPlot(nonConjScfEst,0,"sum",0);
    nonConj1D = nonConj1D(2:end);
    conj1D = S.remapTo1DPlot(conjScfEst,0,"sum",0);
    conj1D = conj1D(2:end);
    
    conjCoh1D = S.remapTo1DPlot(conjCohEst,0,"sum",0);
    nonConjCoh1D = S.remapTo1DPlot(nonConjCohEst,0,"sum",0);
    
    conj_alphas = peakFinder(conj1D,alphas,"../configs/conjugate.yaml",'conj');
    non_conj_alphas = peakFinder(nonConjCoh1D,alphas,"../configs/non_conjugate.yaml",'nonconj');
    
    % step 1: filter out using conjugate peaks into 2 groups
    % Group 1: QAM, PSK, OFDM, DSSS QPSK, DSSS QAM
    % Group 2: FSK family, BPSK, DSSS BPSK
    detected_signal  = 'NOTA';
    
    if length(conj_alphas)>1 && length(non_conj_alphas) >1
        % Check 1: identical conj and non conj functions - BPSK
        if filterSameScfs(nonConj1D, conj1D)
            detected_signal = 'bpsk';
        else 
            % Check 2: for DSSS BPSK - multiple CFs, some harmonics 
            if filterDsssLike(non_conj_alphas)
                detected_signal = 'dsss bpsk';
            else
                % Check 3: for FSK, GFSK Peak at CFO?
                detected_signal = filterFskFamily(nonConjCoh1D, conjCoh1D, alphas);
            end
        end 
    % Now running the non_conjugate side 
    else 
        if isempty(non_conj_alphas)
            if filterOfdm(in)
                detected_signal = 'ofdm';
            else
                detected_signal = 'NOTA';
            end
        elseif filterDsssLike(non_conj_alphas)
            detected_signal = 'dsss';
        else
            detected_signal = 'qam/psk';
        end 
    end 

end 
