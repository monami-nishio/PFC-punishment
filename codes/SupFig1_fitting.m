
addpath(['..', filesep, 'scripts'])
addpath(['..', filesep, 'scripts', filesep,'SupFig1_fitting'])

list = dir(['..', filesep, 'dataset', filesep , 'wholeses*.mat']);
tasks = {'airpuff', 'omission'};
types = {'SFP','SF'}; 

for i = 2:length(list)
    nametofit = append(list(i).folder, '/', list(i).name);
    wholeses = load(nametofit);
    ML_Q = mle_predict(types{i},wholeses.wholeses);
    save(append('..', filesep, 'result', filesep , string(tasks(i)), string(types(i))),'ML_Q')
end