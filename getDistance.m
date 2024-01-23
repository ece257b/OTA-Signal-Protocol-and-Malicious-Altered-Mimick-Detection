function distance = getDistance(src_dir, cycle_peak_heights, range_begin, range_end)

    testing = {};
    % Get a list of all .dat files in the directory
    files = dir(fullfile(src_dir, '*.dat'));
    
    validFileCount = 0;
    % Loop through each file
    for k = 1:length(files)
        if endsWith(files(k).name, "sum_nonconj.dat")
            validFileCount = validFileCount + 1;
            % Construct the full file path
            filePath = fullfile(src_dir, files(k).name);
    
            % Load the file
            fid = fopen(filePath, 'rb');
            data = fread(fid, inf, 'single');
            fclose(fid);
    
            % Assuming the variable name is 'yourVariableName'
            % Store the data in the cell array
            testing{validFileCount} = data;
        end
    end



    %% get nonConjSumCff and calculate the distance
    distance = zeros(1, length(testing));
    for i = 1 : length(testing)
        minVal = min(testing{i});
        maxVal = max(testing{i});
        normalized_nonConjMaxCff = (testing{i} - minVal) / (maxVal - minVal);

        [this_cycle_peaks, this_cycle_peak_heights, this_peak_prominence] = peakFinderInRange(normalized_nonConjMaxCff, range_begin, range_end);

        %if(distance(i) < 0.2)
        %    figure(2); plot(normalized_nonConjMaxCff); hold on;
        %end
        
        distance(i) = sum(abs(cycle_peak_heights - this_cycle_peak_heights .* mySigmoid(this_peak_prominence, 1, 1)));
    end
end