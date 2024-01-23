function y = mySigmoid(data_in, x_0, k)
    % Custom sigmoid function
    % data_in: Input data (vector or scalar)
    % x_0: Midpoint of the sigmoid
    % k: Steepness of the sigmoid curve

    y = 1 - 1 ./ (1 + exp(-k * (data_in - x_0)));
end
