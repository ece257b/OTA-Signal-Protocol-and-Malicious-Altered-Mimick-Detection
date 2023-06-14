function sscaplot(in, N, Np)
    
    if length(in)<N+Np
        in = [in; zeros(1,9000-length(in))'];
    end

    S = sscaClass(N, Np, 100, 200);
    out = S.process(in);
    
    figure
    subplot(221)
    S.plotInKQDomain(this, out.nonConjScf)
    title('Non conj KQ')
    
    subplot(222)
    S.plotInKQDomain(this,out.conjScf)
    title('Conj KQ')
    
    subplot(223)
    plot(out.alphas, out.nonConjMaxCff)
    grid on
    title('Non conj CFF')
    
    subplot(224)
    plot(out.alphas, out.conjMaxCff)
    grid on
    title('Conj CFF')

end