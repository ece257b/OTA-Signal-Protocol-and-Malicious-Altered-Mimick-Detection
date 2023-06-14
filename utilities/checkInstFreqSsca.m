function flag = checkInstFreqSsca(in,sym_rate_alpha) 
    [N, Np] = returnSscaParams(length(in));
    S = sscaClass(N, Np, 100, 200);
    unwrapped_phase = unwrap(angle(in));
    pd = unwrapped_phase(2:end) - unwrapped_phase(1:end-1);
    out = S.process(pd);

    % grab most dominant peaks in the ssca

    [~,l,~,~]=findpeaks(out.nonConjSumCff, "NPeaks",3,"SortStr","descend");
    
    % threshold the pd 
    [alphas, hts] = peakFinder(out,'nonconj');
    diff = abs(abs(out.alphas(l)) - sym_rate_alpha);
    condition = diff<0.01;
%     condition2 = [];
%     for i=1:length(alphas)
%             condition2 =  [condition2 , (abs(abs(alphas(i)) - abs(out.alphas(l))))<0.01];
%     end 
    if any(condition) 
        flag=1;
    else
        flag=0;
    end    
end 