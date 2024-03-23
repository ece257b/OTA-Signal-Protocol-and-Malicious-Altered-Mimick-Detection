clear all; close all; 


modulationAverages = struct;
modulationTypes = {};
typeCtr = 0;


%% Radhika's dataset
radhika_data = "/mnt/extC-hddr0-18tb/rmathuria/modulation/ota/dummy_searchlight";
nameFolds = getSubDirs(radhika_data);

for i = 1:length(nameFolds)
    nameSubFolds = getSubDirs(fullfile(radhika_data, nameFolds{i}));

    modulationType = nameFolds{i};
    modulationTypes{i} = {modulationType};
    typeCtr = typeCtr + 1;

    for j = 1:length(nameSubFolds)

        
        modulationPath = fullfile(radhika_data, nameFolds{i}, nameSubFolds{j});

        [O_t_all, t_all] = getDirectoryTFDistribution(modulationPath, "", ".json");

        modulationAverages.(modulationType).O_t = O_t_all;
        modulationAverages.(modulationType).t = t_all;
    end
end


%% ECTB-Example
ectb_example = "/mnt/intB-ssdr0-240gb/rsubbaraman/protocol_data/ectb_example";

modulationType = 'ectb_example';
modulationTypes{typeCtr + 1} = {modulationType};
typeCtr = typeCtr + 1;

[O_t_all, t_all] = getDirectoryTFDistribution(ectb_example, ".sigmf-data", '.sigmf-meta');
modulationAverages.(modulationType).O_t = O_t_all;
modulationAverages.(modulationType).t = t_all;


%% Plot
for i = 1:typeCtr
    modulationType = modulationTypes{i};
    subplot(length(modulationTypes), 1, i); 
    
    % Retrieve O_t and t for the current modulation type
    O_t_all = modulationAverages.(modulationType{1}).O_t;
    t_all = modulationAverages.(modulationType{1}).t;
    
    % Plot each O_t vs. t pair
    hold on; 
    for j = 1:length(O_t_all)
        plot(t_all{j}, O_t_all{j});
    end
    hold off;
    
    title(['Modulation Type: ', modulationType]);
    xlabel('Time (s)');
    ylabel('O_t');
  
end

sgtitle('O_t vs. Time for Different Modulation/Modality'); % Super title for the entire figure


