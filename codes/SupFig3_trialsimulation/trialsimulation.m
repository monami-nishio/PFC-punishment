
tasks = {'airpuff', 'omission'};
conditions = {'acsf', 'muscimol'};
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
    for j = 1:length(list)
        nametofit = append(list(j).folder, '/', list(j).name);
        meta_history = [];
        load(nametofit)
        if i==1
            for t = 1:height(meta_history)
                meta_history{t,2}.punish = meta_history{t,2}.airpuff;
            end
        elseif i==2
            for t = 1:height(meta_history)
                meta_history{t,2}.punish = meta_history{t,2}.success - meta_history{t,2}.reward;
            end
        end
        [pull, action] = mle_evaluate(types{j},paramall,meta_history,string(tasks(i)),append(string(tasks(i)),string(conditions(j))));
    end
end
