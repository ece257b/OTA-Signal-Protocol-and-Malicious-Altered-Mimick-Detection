function flag = filterSymmetricAlphas(non_conj_alphas)
    flag = 0;

    pos_alpha = round(non_conj_alphas(non_conj_alphas>0),2);
    neg_alpha = -1*round(non_conj_alphas(non_conj_alphas<0),2);
  
    diff_mat = abs(pos_alpha - neg_alpha.');
    idx = find(diff_mat(:) < 0.001);

    if any(idx)
        flag = 1;  
    end

end 