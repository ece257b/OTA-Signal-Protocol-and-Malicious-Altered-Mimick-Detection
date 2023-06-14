function flag = filterConjugateQamPsk(conj_alphas,sym_rate_alpha)
% This function filters out the thresholded conjugate CFs for detecting
% QAM/PSK signals. There migh be false CFs thresholded out, and hence this
% function checks if any conjugate CFs are corresponding to the symbol
% rate. 

flag = 1;

% do any of the two alphas have difference equal to sym rate alpha?
for i = 1:length(conj_alphas)
    for j = 1:length(conj_alphas)
        if i~=j
            if abs(abs(abs(conj_alphas(i)) - abs(conj_alphas(j))) - sym_rate_alpha) <0.01
                flag = 0;
                break;
            end
        end 
    end
end 