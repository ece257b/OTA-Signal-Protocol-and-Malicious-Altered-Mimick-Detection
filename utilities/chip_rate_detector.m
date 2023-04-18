
iq = read_complex_binary("/storage/data/rmathuria/cyclo/dssspsk_searchlight/dssspsk/dssspsk4_1_10_12.4_5_31_5type1_1_energy_1");
tfplot(iq)
fid = fopen("/storage/data/rmathuria/cyclo/dssspsk_searchlight/dssspsk/dssspsk4_1_10_12.4_5_31_5type1_1_energy_1.json" , 'r');
metaStr = fread(fid, '*char');
fclose(fid);

metadataStruct = jsondecode(metaStr(:)');

fs = metadataStruct.sampleRate;
signal_duration = length(iq)/fs;
N = 8192;
Np = 128;

if length(in)<(N+Np)
    in = [in; zeros(10000-length(in),1)];
end

S = sscaClass(N, Np, 100, 200, 1);
conjScfEst = S.process(in);

S = sscaClass(N, Np, 100, 200, 0);
nonConjScfEst = S.process(in);

nonConjCohEst = S.getCoherence(nonConjScfEst,in);
conjCohEst = S.getCoherence(conjScfEst,in);

[alphas, ~] = S.getFrequencies();
alphas = unique(alphas(:));

nonConj1D = S.remapTo1DPlot(nonConjScfEst,0,"sum",0);
nonConj1D = nonConj1D(2:end);
conj1D = S.remapTo1DPlot(conjScfEst,0,"sum",0);
conj1D = conj1D(2:end);

conjCoh1D = S.remapTo1DPlot(conjCohEst,0,"sum",0);
nonConjCoh1D = S.remapTo1DPlot(nonConjCohEst,0,"sum",0);

conj_alphas = peakFinder(conjCoh1D,alphas,"../configs/conjugate.yaml");
non_conj_alphas = peakFinder(nonConjCoh1D,alphas,"../configs/non_conjugate.yaml");

% generate a random p-n sequence at chip rate
n_chips = round(fs / chip_rate); % Number of samples per chip
chip_sequence = sign(randn(1, n_chips)); % Random binary chip sequence
chip_sequence = repmat(chip_sequence, 1, round(signal_duration * chip_rate)); % Repeat for the duration of the signal


% compute its lag product 



