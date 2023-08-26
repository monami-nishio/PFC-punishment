list = dir('../../dataset/wholeses*.mat');
tasks = {'airpuff', 'omission'};
types = {'RNLDF','RCNLDF'}; 

for i = 1:length(list)
    for j = 1:length(types)
        nametofit = append(list(i).folder, '/', list(i).name);
        wholeses = load(nametofit);
        ML_Q = mle_predict(types{j},wholeses.wholeses);
        save(append('result/', string(tasks(i)), string(types(j))),'ML_Q')
    end
end