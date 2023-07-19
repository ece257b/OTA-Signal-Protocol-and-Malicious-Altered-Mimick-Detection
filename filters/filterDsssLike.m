function detected_signal = filterDsssLike(non_conj_alphas,non_conj_alpha_hts,fs)
detected_signal = 'unknown';
if ~isempty(non_conj_alphas)

    % get max height
    [~, ind] = max(non_conj_alpha_hts);
    non_conj_alpha_hts = non_conj_alpha_hts(ind+1:end);
    if ~issorted(non_conj_alpha_hts,'descend')
        % round them off to two places post decimal, take only the unique
        % values
        non_conj_alphas = unique((round(non_conj_alphas,3)));
        non_conj_alphas = non_conj_alphas(non_conj_alphas>0);
        if length(non_conj_alphas)>=3
            % compute ratios between all alphas wrt first one
            ratios = non_conj_alphas/non_conj_alphas(1);
            rounded_ratios = round(ratios);
            rounded_ratios_diff = rounded_ratios(2:end) - rounded_ratios(1:end-1);
            % if all or one less of them are ones, then it is DSSS
            cnt = 0;
            for i = 1:length(rounded_ratios_diff)
                if ~(rounded_ratios_diff(i)==1)
                    cnt = cnt +1;
                end
            end
            if cnt <ceil(0.3*length(rounded_ratios))
%                 flags = 1;
                if non_conj_alphas(1)*fs < 1.8e6 && non_conj_alphas(1)*fs > 1.7e6
                    detected_signal = 'wifidsss';
                else
                    detected_signal='dsss';
                end
            end
        end
    end
end
end