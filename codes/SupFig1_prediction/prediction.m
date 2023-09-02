list = dir('../../dataset/wholeses*.mat');
tasks = {'airpuff', 'omission'};
types = {'RNLDF', 'RCNLDF'};

for i = 1:length(list)
    for j = 1:length(types)
        param = append('../../param/original/', string(tasks(i)), string(types(j)), '.mat');
        nametofit = append(list(i).folder, '/', list(i).name);
        wholeses = load(nametofit);
        x = load(param);
        [pull,action,ml] = mle_evaluate(types{j},x,wholeses.wholeses,string(tasks(i)));
        ML_Q = ml.ML_Q;
        save(append('../../param/original/', string(tasks(i)), string(types(j))),'ML_Q')
    end
end

