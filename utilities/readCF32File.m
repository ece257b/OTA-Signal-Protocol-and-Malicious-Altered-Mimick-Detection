function data = readCF32File(filename)
    % readCF32File - Reads a .cf32 file and returns complex float data

    % Check if the file exists
    if ~exist(filename, 'file')
        error('File does not exist: %s', filename);
    end

    % Open the file for reading
    fileId = fopen(filename, 'r');
    if fileId == -1
        error('Unable to open file: %s', filename);
    end

    % Read the file data
    fileData = fread(fileId, 'float32=>float32');

    % Close the file
    fclose(fileId);

    % Reshape the data into complex format
    data = fileData(1:2:end) + 1i * fileData(2:2:end);
end
