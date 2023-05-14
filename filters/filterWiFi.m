function detected_signal = filterWiFi(out,fs)
    [~,locs,~,~] = findpeaks(out.nonConjMaxCff,"NPeaks",2,"SortStr","descend");
    wifi_alpha = abs(out.alphas(locs(2))*10e6/fs);
    if ismember(round(wifi_alpha,2),[0.21 0.22 0.15 0.16])
        detected_signal = 'wifi_ax';
    else
        detected_signal = 'unknown';
    end
end