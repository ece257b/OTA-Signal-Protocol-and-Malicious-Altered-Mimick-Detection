close all

N = 8192;
Np = 128;
in = read_complex_binary("/storage/data/rmathuria/cyclo/dssspsk_searchlight/dssspsk/dssspsk4_1_10_6_5_15_2type2_1_energy_1");

S = sscaClass(N, Np, 100, 200, 1);
conjScfEst = S.process(in);

S = sscaClass(N, Np, 100, 200, 0);
nonConjScfEst = S.process(in);

nonConjCohEst = S.getCoherence(nonConjScfEst,in);
conjCohEst = S.getCoherence(conjScfEst,in);

[alphas, ~] = S.getFrequencies();
alphas = unique(alphas(:));

figure
S.plotAll(conjScfEst, nonConjScfEst,"sum")

nonConj1D = S.remapTo1DPlot(nonConjScfEst,0,"sum",0);
nonConj1D = nonConj1D(2:end);
conj1D = S.remapTo1DPlot(conjScfEst,0,"sum",0);
conj1D = conj1D(2:end);

conjCoh1D = S.remapTo1DPlot(conjCohEst,0,"sum",0);
nonConjCoh1D = S.remapTo1DPlot(nonConjCohEst,0,"sum",0);
% 
figure
S.plotAll(conjCohEst, nonConjCohEst,"sum")

conj_alphas = S.findpeaks(conjCohEst);
non_conj_alphas = S.findpeaks(nonConjCohEst);

% step 1: filter out using conjugate peaks into 2 groups
% Group 1: QAM, PSK, OFDM, DSSS QPSK, DSSS QAM
% Group 2: FSK family, BPSK, DSSS BPSK
detected_signal  = 'NOTA';

if length(conj_alphas)>1
    % Check 1: identical conj and non conj functions - BPSK
    if filterSameScfs(nonConj1D, conj1D)
        detected_signal = 'BPSK';
    else 
        % Check 2: for DSSS BPSK - multiple CFs, some harmonics 
        if filterDsssLike(conj_alphas, non_conj_alphas)
            detected_signal = 'DSSS BPSK';
        else
            % Check 3: for FSK, GFSK Peak at CFO?
            detected_signal = filterFskFamily(nonConjCoh1D, conjCoh1D, alphas);
        end
    end 
% Now running the non_conjugate side 
else
    if non_conj_alphas == 0
        if additionalOfdmCheck(samplesIQ)
            detected_signal = 'OFDM';
        else
            detected_signal = 'NOTA';
        end
    elseif filterDsssLike(non_conj_alphas)
        detected_signal = 'DSSS';
    else
        detected_signal = 'QAM/PSK';
    end 
end 

disp(detected_signal)
