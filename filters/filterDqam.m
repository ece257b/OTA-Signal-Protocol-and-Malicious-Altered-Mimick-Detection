function detected_signal = filterDqam(conj_alphas,non_conj_alphas)
detected_signal = 'unknown';
% disp(conj_alphas)
    if filterSymmetricAlphas(non_conj_alphas)
        pos_non_conj_alphas = sort(non_conj_alphas(non_conj_alphas>0.09));
        if ~isempty(pos_non_conj_alphas)
            sym_rate_alpha = pos_non_conj_alphas(1);
            if filterConjugateQamPsk(conj_alphas,sym_rate_alpha)
                if length(conj_alphas)<2
                    detected_signal = 'qam/psk';
                end
            end
        end
    end
end