function [N, Np] = returnSscaParams(len)
    Np = 128;

    if len>9000
        N = 8192;
    elseif len>4000
        N = 4096;
    elseif len>2000
        N = 2048;
    elseif len>1000
        N = 1024;
    end 
end 