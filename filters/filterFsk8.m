function detected_signal = filterFsk8(in, out)
    detected_signal = 'unknown';
    in = reshape(in, 1, []);
    [~, ~, ~, psd] = spectrogram(in, 1024, 512, 1024, 1, 'centered');
    psd = psd.';
    spec = mean(psd,1);
    nfft = 1024;
    faxis = -0.5:1/nfft:0.5-1/nfft;
    
    [~, locs, ~, ~] = findpeaks(spec, 'NPeaks',8,'SortStr','descend');
    [~, locs_cf, ~, ~] = findpeaks(out.conjSumCff, 'NPeaks',8,'SortStr','descend');

    tone_alphas = out.alphas(locs_cf);

    if ~isrow(tone_alphas)
        tone_alphas = tone_alphas';
    end 
    diff_vec = sort(2*faxis(locs)) - sort(tone_alphas);
    cnt = 0;
    for i=1:length(diff_vec)
        if diff_vec(i)<0.01 && diff_vec(i)>-0.01
            cnt = cnt + 1;
        end
    end
    if cnt >= 2
        detected_signal = 'fsk8';
    end 
end 