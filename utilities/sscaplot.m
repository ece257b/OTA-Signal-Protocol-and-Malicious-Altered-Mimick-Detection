function sscaplot(in, N, Np)

    S = sscaClass(N, Np, 100, 200, 1);
    conjScfEst = S.process(in);
    
    S = sscaClass(N, Np, 100, 200, 0);
    nonConjScfEst = S.process(in);

    figure
    S.plotAll(conjScfEst, nonConjScfEst,"sum")

%    figure
 %   S.plotOtherThree(in,"sum")

    nonConjCoh = S.getCoherence(nonConjScfEst,in);
    conjCoh = S.getCoherence(conjScfEst,in);

    figure
    S.plotAll(conjCoh, nonConjCoh,"max");
    peak_loc_nonconj = S.findAlphaPeaks(nonConjCoh);

end