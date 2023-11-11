
addpath(['..', filesep, 'scripts'])
addpath(['..', filesep, 'scripts', filesep,'SupFig2_simulation'])

list = dir(['..', filesep, 'dataset', filesep , 'wholeses*.mat']);
tasks = {'airpuff', 'omission'};
types = {'RCNLDF', 'RNLDF'};

for i = 1:length(list)
    for j = 1:length(types)
        param = append('..', filesep, 'param', filesep , 'original', filesep, string(tasks(i)), string(types(j)), '.mat');
        x = load(param);
        paramall = [];
        for t = 1:length(x.ML_Q)
            xnew = x.ML_Q{t,2};
            xnew = struct2cell(xnew);
            xnew = cell2mat(xnew);
            paramall = [paramall xnew];
        end
        nametofit = append(list(i).folder, '/', list(i).name);
        wholeses = load(nametofit).wholeses;
        if i==1
            for t = 1:height(wholeses)
                wholeses{t,2}.punish = wholeses{t,2}.punish;
            end
        elseif i==2
            for t = 1:height(wholeses)
                wholeses{t,2}.punish = wholeses{t,2}.success - wholeses{t,2}.reward;
            end
        end
        [pull, action] = mle_evaluate_simulation(types{j},paramall,wholeses,append(string(tasks(i)),string(types(j))));
    end
end
 