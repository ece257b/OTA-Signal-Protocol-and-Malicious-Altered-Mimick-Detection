function detected_signal = filterDqam(in, conj_alphas,non_conj_alphas)
% This function detects the presence of QAM/PSK type signals if no
% conjugate CFs are detected, and only non-conjugate (symmetric) CFs exist.

detected_signal = 'unknown';
    if filterSymmetricAlphas(non_conj_alphas)
        pos_non_conj_alphas = sort(non_conj_alphas(non_conj_alphas>0.09));
        if ~isempty(pos_non_conj_alphas)
            sym_rate_alpha = pos_non_conj_alphas(1);
            if filterConjugateQamPsk(conj_alphas,sym_rate_alpha)
                if length(conj_alphas)<=3
                    flag = 1;
                    if flag == 1
                        detected_signal = 'qam/psk';
                    else
                        detected_signal = 'noise';
                    end 
                end
            end
        end
    end
end