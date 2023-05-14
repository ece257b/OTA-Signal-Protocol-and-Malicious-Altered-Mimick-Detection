function distance = computeAlphaDistance(alphas)

alphas = sort(alphas);
distance = abs(alphas(3) - alphas(1:2));
end 