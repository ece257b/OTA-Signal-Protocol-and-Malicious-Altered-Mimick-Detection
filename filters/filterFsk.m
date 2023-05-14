function fskModOrder = filterFsk(in,out)
    % This function is the FSK family filter. It counts the number of tones in
    % the PSD, and sees if there are corresponding cycle frequencies at 2*fc in
    % the conjugate SSCA
    fskModOrder = [];
    tone_freqs = detectTone(in);
    if isempty(tone_freqs)
        return
    else
        nPks = length(tone_freqs);
        [~, locs, ~,~] = findpeaks(out.conjMaxCff, 'NPeaks',nPks,'SortStr','descend');
        tone_alphas = out.alphas(locs)';
        diff_vec = sort(2*tone_freqs) - sort(tone_alphas);
        cnt = 0;
        for i=1:length(diff_vec)
            if diff_vec(i)<0.01 && diff_vec(i)>-0.01
                cnt = cnt + 1;
            end
        end
        if cnt == length(diff_vec)
            fskModOrder = nPks;
        else
        end
    end
end