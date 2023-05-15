function cycle_peaks = peakFinder(out, type)
  
    if strcmp(type,'conj')
        threshold = medfilt1(out.conjMaxCff,100);
        output = out.conjMaxCff;
        thresh = 3*threshold ;
% 
%         figure
%         plot(output)
%         hold on
%         plot(thresh,'--')
    elseif strcmp(type,'nonconj')
        threshold = medfilt1(out.nonConjMaxCff,300);
        output = out.nonConjMaxCff;
        thresh = 2.3*threshold;
% 
%         figure
%         plot(output)
%         hold on
%         plot(thresh,'--')
    end

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
%         disp("No alphas detected!")
        cycle_peaks = 0;
    else
        % reject the first few and last few alphas as they are spurious
        if(strcmp(type,'conj'))
            midpoints = midpoints(midpoints>1000);
            midpoints = midpoints(midpoints<16000);
            cycle_peaks = round((out.alphas(midpoints)),2);
        else
            midpoints = midpoints(midpoints>1000);
            midpoints = midpoints(midpoints<15000);
            cycle_peaks = out.alphas(midpoints);
%             pos_ind = round(cycle_peaks(cycle_peaks>0),2);
%             neg_ind = round(abs(cycle_peaks(cycle_peaks<0)),2);
%             common_indices = intersect(pos_ind, neg_ind);
%             cycle_peaks = common_indices;
        end
      
    end 
end