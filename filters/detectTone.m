function freqs = detectTone(in)

    in = reshape(in, 1, []);
    nfft = 1024;
    [~, ~, ~, psd] = spectrogram(in, 1024, 512, 1024, 1, 'centered');
    psd = psd.';
    spec = mean(psd,1);

    faxis = -0.5:1/nfft:0.5-1/nfft;
    flag = 0;

    % smoothen it
    spec = conv(ones(1,5),spec);
    thresh = medfilt1(spec,80);

    indices = find(spec>2.5*thresh);

    % find the set of consecutive indices and replace them by the average
    % value, convert to normalized frequency

    vector = indices;
    threshold = 1;  % Define the threshold for consecutive elements
    
    % Find the indices where the consecutive elements start and end
    diff_vector = diff(vector);
    consecutive_start = [1, find(diff_vector > threshold) + 1];
    consecutive_end = [find(diff_vector > threshold), numel(vector)];

    % Compute the average for consecutive elements and replace them
    for i = numel(consecutive_start):-1:1
        avg = mean(vector(consecutive_start(i):consecutive_end(i)));
        vector(consecutive_start(i):consecutive_end(i)) = avg;
    end

    freqs = faxis(unique(round(vector))-1);

    if length(freqs)>=1
        flag = 1;
    end

    if flag ==0
        freqs = [];
    end 
end 