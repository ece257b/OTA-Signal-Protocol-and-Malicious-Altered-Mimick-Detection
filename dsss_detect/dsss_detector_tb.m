folder ="/mnt/ext_hdd_18tb/rmathuria/dsss_below_noise_floor_psk/dsss_ota/";
files = dir(folder+"*.32cf");
% detections = 0;
% detections = containers.Map('KeyType', 'double', 'ValueType', 'double');
% esnos = -20:2:0;
% 
% total = containers.Map('KeyType', 'double', 'ValueType', 'double');
% for i = 1:length(esnos)
%     esno = esnos(i);
%     detections(esno) = 0;
%     total(esno) = 0;
% end

for i=1:length(files)

      iq = read_complex_binary(folder+files(i).name);
      fid = fopen(folder+files(i).name(1:end-5) + '.json', 'r');
      metaStr = fread(fid, '*char');
      if (isempty(metaStr))
            continue;
      end
      fclose(fid);
      metadata =jsondecode(reshape(metaStr, 1, []));
      fs = metadata.rxObj.sampleRate_Hz;
      energy = Searchlight.quickProcess("config/settings.yaml", single(iq), fs, 2.45e9, true);

%     match = regexp(files(i).name, '^(?:[^_]*_){2}([^_]*)', 'tokens');
%     esno =  str2num(match{1}{1});
%     S = sscaClass(8192, 128, 100, 200, 0);
%     alphas = S.getFrequencies();
%     alphas = unique(alphas(:));
% 
%     nonConjScfEst = S.process(iq);
%     nonConj1D = S.remapTo1DPlot(nonConjScfEst,"","max",0);
%     nonConj1D = nonConj1D(2:end);
% 
%     [~,locs,~,~] = findpeaks(nonConj1D, "NPeaks",2,"SortStr","descend");
%     data_rate_alpha = alphas(locs(2));
%     slice_freq = abs(round(data_rate_alpha,1))+0.05;
%     if slice_freq>0
%         [iq_slice1, fs_sup1] = channslice(iq, 1,[0 length(iq) -1*slice_freq slice_freq]);
% 
%         nonConjScfEst = S.process(iq_slice1);
%         nonConj1D = S.remapTo1DPlot(nonConjScfEst,"","max",0);
%         nonConj1D = nonConj1D(12:end);
% 
%         % apply the threshold
%         cycle_peaks = peakFinder(nonConj1D, alphas, "../configs/dsss.yaml", "dsss");
%         if length(cycle_peaks)>1
%             detections(esno) = detections(esno) + 1;
% %               detections = detections + 1;
%         else
%             disp('here')
%         end 
%     end
%     total(esno) = total(esno) + 1;
end 

% Create the ROC curve 
cnt = 1;
for i=-20:2:0
    Pd(cnt) = detections(i)/total(i);
    cnt = cnt + 1;
end

figure
plot(esnos, Pd,'LineWidth',2,'Marker','o')
xlabel('Es/No (in dB)')
ylabel('Probability of detection (Pd)')
grid on
set(gca,'FontName','Arial','FontSize',12,'FontWeight','Bold',  'LineWidth', 2);

