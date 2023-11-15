
addpath(['..', filesep, 'scripts'])
addpath(['..', filesep, 'scripts', filesep,'SupFig1_prediction'])

list = dir(['..', filesep, 'dataset', filesep , 'wholeses*.mat']);
tasks = {'airpuff', 'omission'};
types = {'SF', 'SFP'};

figid = 1;
for i = 1:length(list)
    for j = 1:length(types)
        param = append('..', filesep, 'param', filesep , 'original', filesep, string(tasks(i)), string(types(j)), '.mat');
        nametofit = append(list(i).folder, '/', list(i).name);
        wholeses = load(nametofit);
        x = load(param);
        [pull,action,ml] = mle_evaluate_prediction(types{j},x,wholeses.wholeses,string(tasks(i)),figid);
        ML_Q = ml.ML_Q;
        save(append('..', filesep, 'param', filesep , 'original', filesep, string(tasks(i)), string(types(j))),'ML_Q')
        figid = figid+1;
    end
end

