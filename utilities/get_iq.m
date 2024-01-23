function [matrix, act_len] = get_iq(fileCategory, targetLength)
    % Initialize matrix for the category
    matrix = complex(zeros(length(fileCategory), targetLength));
    act_len = zeros(length(fileCategory), 1);

    % Process files in the category
    for i = 1:length(fileCategory)
        data = readCF32File(fileCategory{i}); % Assuming full path is in fileCategory
        
        % Ensure 'data' is a row vector
        if iscolumn(data)
            data = data.';
        end

        dataLength = length(data);
        act_len(i) = dataLength;

        if dataLength > targetLength
            % If data is longer than target, truncate it
            matrix(i, :) = data(1:targetLength);
        elseif dataLength < targetLength
            % If data is shorter than target, pad it with zeros
            matrix(i, :) = [data, zeros(1, targetLength - dataLength)];
        else
            % If data length matches target length, use as is
            matrix(i, :) = data;
        end
    end

    matrix = [zeros(length(fileCategory), 1000), matrix, zeros(length(fileCategory), 1000)];
end
