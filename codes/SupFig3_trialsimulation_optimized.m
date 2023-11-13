
addpath(['..', filesep, 'scripts'])
addpath(['..', filesep, 'scripts', filesep,'SupFig3_trialsimulation'])

tasks = {'airpuff', 'omission'};
conditions = {'acsf', 'muscimol'};
types = {'RCNLDF', 'RNLDF'};

for i = 1:length(tasks)
    list = dir(append('..', filesep, 'dataset', filesep, string(tasks(i)), '*.mat'));
    param = append('..', filesep, 'param', filesep, 'original', filesep, string(tasks(i)), string(types(i)), '.mat');
    x = load(param);
    originalvalues = [];
    mousenum = length(x.ML_Q);
    mid = 201;
    if i == 1
        nParam = 5;
    else
        nParam = 4;
    end
    for t = 1:mousenum
        xnew = x.ML_Q{t,2};
        xnew = struct2cell(xnew);
        xnew = cell2mat(xnew);
        originalvalues = [originalvalues xnew];
    end
    for j = 1:length(list)
        optimizedparams = append('..', filesep, 'param', filesep, 'optimized', filesep, string(tasks(i)), string(types(i)), string(conditions(j)), '.mat');
        x = load(optimizedparams);
        for iParam = 1:nParam
            optimized = originalvalues;
            for iMouse = 1:mousenum
                originalvalue = originalvalues(iParam,iMouse);
                all_rs = x.all_rs;
                row = iParam+nParam*(iMouse-1);
                tone = all_rs(row,:)- all_rs(row,mid);
                if iParam < 3
                    minvalue = ceil(originalvalue/0.01);
                    maxvalue = ceil((1-originalvalue)/0.01);
                    tone = tone(mid-minvalue:mid+maxvalue);
                    gap = (-minvalue+find(tone==min(tone)))*0.01;
                else
                    minvalue = ceil(originalvalue/0.1);
                    maxvalue = ceil((20-originalvalue)/0.1);
                    tone = tone(mid-minvalue:mid+maxvalue);
                    gap = (-minvalue+find(tone==min(tone)))*0.1;
                end
                optimized(iParam,iMouse) = optimized(iParam,iMouse)+gap;
            end
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
            [pull, action] = mle_evaluate_trialsimulation(types{i},optimized,meta_history,string(tasks(i)),append(string(tasks(i)),string(types(i)),'_optimized'));
        end
    end
end
