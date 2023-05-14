function detected_signal = filterDsssLike(non_conj_alphas)
flags = 0;
detected_signal = 'unknown';
if ~isempty(non_conj_alphas) 
    
    % round them off to two places post decimal, take only the unique
    % values
    non_conj_alphas = unique((round(non_conj_alphas,2)));
    non_conj_alphas = non_conj_alphas(non_conj_alphas>0);
    if length(non_conj_alphas)>=4
    % compute ratios between all alphas wrt first one
    ratios = non_conj_alphas/non_conj_alphas(1);
    rounded_ratios = round(ratios);

    %     for i=1:length(ratios)
    %         if rem(ratios(i),1)<1.2 || rem(ratios(i),1)>0.8
    %             pos_cnt = pos_cnt + 1;
    %         else
    %             neg_cnt = neg_cnt + 1;
    %         end
    %     end
    %     if pos_cnt > neg_cnt
    %         flags = 1;
    %     end
    %     end
    rounded_ratios_diff = rounded_ratios(2:end) - rounded_ratios(1:end-1);
    % if all or one less of them are ones, then it is DSSS
    cnt = 0;
    for i = 1:length(rounded_ratios_diff)
        if ~(rounded_ratios_diff(i)==1)
            cnt = cnt +1;
        end
    end
    if cnt <=2
        flags = 1;
        detected_signal='dsss';
    end
    end
end
end