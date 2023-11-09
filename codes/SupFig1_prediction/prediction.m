
addpath(['..', filesep, '..', filesep, 'scripts'])

list = dir(['..', filesep, '..', filesep, 'dataset', filesep , 'wholeses*.mat']);
tasks = {'airpuff', 'omission'};
types = {'RNLDF', 'RCNLDF'};

for i = 1:length(list)
    for j = 1:length(types)
        param = append('..', filesep, '..', filesep, 'param', filesep , 'original', filesep, string(tasks(i)), string(types(j)), '.mat');
        nametofit = append(list(i).folder, '/', list(i).name);
        wholeses = load(nametofit);
        x = load(param);
        [pull,action,ml] = mle_evaluate_prediction(types{j},x,wholeses.wholeses,string(tasks(i)));
        ML_Q = ml.ML_Q;
        save(append('..', filesep, '..', filesep, 'param', filesep , 'original', filesep, string(tasks(i)), string(types(j))),'ML_Q')
    end
end

