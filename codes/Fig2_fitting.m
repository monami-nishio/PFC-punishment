
addpath(['..', filesep, 'scripts'])
addpath(['..', filesep, 'scripts', filesep,'SupFig1_fitting'])

list = dir(['..', filesep, 'dataset', filesep , 'wholeses*.mat']);
tasks = {'airpuff', 'omission'};
types = {'SFP','SF'}; 

for i = 1:length(list)
    for j = 1:length(types)
        nametofit = append(list(i).folder, '/', list(i).name);
        wholeses = load(nametofit);
        ML_Q = mle_predict(types{j},wholeses.wholeses);
        save(append('..', filesep, 'result', filesep , string(tasks(i)), string(types(j))),'ML_Q')
    end
end