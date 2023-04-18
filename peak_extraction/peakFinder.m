function cycle_peaks = peakFinder(output, alphas, config_path, type)

    % read in the config
    config = yaml.loadFile(config_path);
    offset_scale = config.filter_offset;
    order = config.filter_order;

    % remove alpha = 0 peak for non-conjugate
    if strcmp(type,'nonconj')==1
        [~, max_ind] = max(output);
        output(max_ind-50:max_ind+50) = output(max_ind-49);
    end

    threshold = medfilt1(output,order);
%     
%     figure
%     plot(output)
%     hold on
    thresh = 2.1*threshold ;
%     thresh = threshold+offset_scale*mean(output(1000:2000));
%     plot(thresh,'--')
    
    indices = find(output>thresh);
    diff_arr = diff(indices);
    if ~isrow(diff_arr)
        diff_arr = diff_arr';
    end
    pattern_starts = [1, find(diff_arr ~= 1)+1];
    pattern_ends = [pattern_starts(2:end)-1, length(indices)];
    
    midpoints = [];
    for i = 1:length(pattern_starts)
        pattern = indices(pattern_starts(i):pattern_ends(i));
        midpoint = round(mean(pattern));
        if ~ismember(midpoint, midpoints)
            midpoints = [midpoints, midpoint];
        end
    end
    
    if isnan(midpoints)
        disp("No alphas detected!")
        cycle_peaks = 0;
    else
        % reject the first few and last few alphas as they are spurious
        midpoints = midpoints(midpoints>3000);
        midpoints = midpoints(midpoints<14000);
        cycle_peaks = alphas(midpoints);
    end

end