close all; clear all;

% Number of files
numFiles = 1000;

% Number of samples per file
numSamples = 10000;


targetDir = "./data/awgn_syn/";

% Loop for each file
for i = 1:numFiles
    % Generate AWGN samples - complex values
    awgnSamples = complex(randn(numSamples, 1), randn(numSamples, 1));

    % Specify the file name with unique index
    fileName = sprintf('iq-syn-test-awgn-0-%04d.32cf', i);

    % Open the file for writing in binary mode
    fileID = fopen(strcat(targetDir, fileName), 'wb');

    % Interleave real and imaginary parts for binary writing
    interleavedSamples = zeros(2*numSamples, 1, 'single');
    interleavedSamples(1:2:end) = real(awgnSamples);
    interleavedSamples(2:2:end) = imag(awgnSamples);

    % Write the interleaved samples to the file as binary
    fwrite(fileID, interleavedSamples, 'float32');

    % Close the file
    fclose(fileID);
end
