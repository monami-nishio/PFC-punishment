
tasks = {'airpuff', 'omission'};
types = {'RCNLDF', 'RNLDF'};

for i = 1:length(tasks)
    list = dir(append('../../dataset/', string(tasks(i)), '*.mat'));
    param = append('../../param/', string(tasks(i)), string(types(i)), '.mat');
    x = load(param);
    paramall = [];
    if i == 1;
        cord = [4 1 5 2 3];
    elseif i ==2;
        cord = [1 2 3 7 4 5 6];
    end
    for t = 1:length(x.ML_Q)
        xnew = x.ML_Q{cord(t),2};
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