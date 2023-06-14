function flag = filterToneCfs(in,out)
    tone_freqs = detectTone(in);
    nPks = length(tone_freqs);
    flag = 0;
    if nPks > 0
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
        flag = 1;
    else
        flag = 0;
    end 
    end 
end