
tasks = {'airpuff', 'omission'};
types = {'RCNLDF', 'RNLDF'};

for i = 1:length(tasks)
    list = dir(append('../../dataset/', string(tasks(i)), '*.mat'));
    param = append('../../param/original/', string(tasks(i)), string(types(i)), '.mat');
    x = load(param);
    paramall = [];
    for t = 1:length(x.ML_Q)
        xnew = x.ML_Q{t,2};
        xnew = struct2cell(xnew);
        xnew = cell2mat(xnew);
        paramall = [paramall xnew];
    end
    nametofit = append(list(i).folder, '/', list(i).name);
    wholeses = load(nametofit).meta_history;
    if i==1
        for t = 1:height(wholeses)
            wholeses{t,2}.punish = wholeses{t,2}.airpuff;
        end
    elseif i==2
        for t = 1:height(wholeses)
            wholeses{t,2}.punish = wholeses{t,2}.success - wholeses{t,2}.reward;
        end
    end
    [pull, action] = mle_evaluate(types{i},paramall,wholeses,string(tasks(i)));
end