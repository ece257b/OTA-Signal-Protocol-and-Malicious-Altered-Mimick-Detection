function ssca_iface(category_in, fs, category_name, order)
    target_len = 12000;
    N = 8192;
    Np = 128;

    dir = "data/ssca/zigbee/";
    [in, act_len] = get_iq(category_in, target_len);

    S = sscaClass(N, Np, 100, 200); 

    for i = 1 : height(in)
        
        %  if length(in)<(2046+128) % This is the minimum resolution below which the algorithm will not run
        %     return
        % else
        %     [N, Np] = returnSscaParams(target_len); % Dynamically vary N, Np based on length of signal
        % end

        out = S.process(in(i, :)); 
        save(strcat(dir, category_name, "/", num2str(i), "_no_interpl"), "out");

    end

    % Plot the distribution of sample lengths
    % figure;
    % histogram(act_len);
    % title(['Distribution of Sample Lengths for ', category_name]);
    % xlabel('Sample Length');
    % ylabel('Frequency');
end 