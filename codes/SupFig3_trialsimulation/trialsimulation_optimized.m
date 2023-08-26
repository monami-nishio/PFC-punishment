
tasks = {'airpuff', 'omission'};
types = {'RCNLDF', 'RNLDF'};

for i = 1:length(tasks)
    list = dir(append('../../dataset/', string(tasks(i)), '*.mat'));
    param = append('../../param/original/', string(tasks(i)), string(types(i)), '.mat');
    x = load(param);
    originalvalues = [];
    mousenum = length(x.ML_Q);
    for t = 1:mounsenum
        xnew = x.ML_Q{t,2};
        xnew = struct2cell(xnew);
        xnew = cell2mat(xnew);
        originalvalues = [originalvalues xnew];
    end
    optimizedparams = append('../../param/optimized/', string(tasks(i)), string(types(i)), '.mat');
    %optimizedparams = '/Users/monaminishio/Documents/MATLAB/modules/Fig6_optimization/optimized_param/airpuff_muscimol_historya.mat';
    x = load(optimizedparams);
    for iParam = 1:5
        optimized = originalvalues;
        for iMouse = 1:mousenum
            originalvalue = originalvalues(iParam,iMouse);
            muscimol_RCNLDF = x.all_rs;
            row = iParam+5*(iMouse-1);
            tone = muscimol_RCNLDF(row,:)- muscimol_RCNLDF(row,101);
            if iParam < 3
                minvalue = ceil(originalvalue/0.01);
                maxvalue = ceil((1-originalvalue)/0.01);
                tone = tone(101-minvalue:101+maxvalue);
                gap = (-minvalue+find(tone==min(tone)))*0.01;
            else
                minvalue = ceil(originalvalue/0.1);
                maxvalue = ceil((20-originalvalue)/0.1);
                if minvalue > 101
                    tone = tone;
                else
                    tone = tone(101-minvalue:101+maxvalue);
                end
                gap = (-minvalue+find(tone==min(tone)))*0.1;
            end
            optimized(iParam,iMouse) = optimized(iParam,iMouse)+gap;
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
            [pull, action] = mle_evaluate(types{j},optimized,meta_history,string(tasks(i)),append(string(tasks(i)),string(types(j)),'_optimized'));
        end
    end
end