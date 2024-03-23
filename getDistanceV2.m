function distance = getDistanceV2(src, cycle_peaks, cycle_peak_heights, range_begin, range_end)

 
    fid = fopen(src{1}, 'rb');
    ssca = fread(fid, inf, 'single');
    fclose(fid);
    
    fid = fopen(src{2}, 'rb');
    alphas = fread(fid, inf, 'single');
    fclose(fid);

    testing = reshape(ssca, length(alphas), []);



    %% get nonConjSumCff and calculate the distance
    distance = zeros(1, width(testing));
    for i = 1 : width(testing)
        minVal = min(testing(:, i));
        maxVal = max(testing(:, i));
        normalized_nonConjMaxCff = (testing(:, i) - minVal) / (maxVal - minVal);

        [this_cycle_peaks, this_cycle_peak_heights, this_peak_prominence] = peakFinderInRange(normalized_nonConjMaxCff, range_begin, range_end);

        distance(i) = max(abs(cycle_peak_heights - this_cycle_peak_heights));
 
        % if(i == 10)
           % figure; plot(linspace(-1, 1, length(normalized_nonConjMaxCff)), normalized_nonConjMaxCff); hold on;
           % plot(cycle_peaks, cycle_peak_heights, "rv"); 
           % (this_cycle_peaks, this_cycle_peak_heights, 'gv'); hold off;
           % display(filenames{i});
           % pause;
        % end
                
        % sum(abs(cycle_peak_heights - this_cycle_peak_heights .* mySigmoid(this_peak_prominence, 1, 1)));
    end
end