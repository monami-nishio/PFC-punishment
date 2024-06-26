
addpath(['..', filesep, 'scripts'])
addpath(['..', filesep, 'scripts', filesep,'SupFig2_simulation'])

list = dir(['..', filesep, 'dataset', filesep , 'wholeses*.mat']);
tasks = {'airpuff', 'omission'};
types = {'SF', 'SFP'};

figid = 1;
for i = 1:length(list)
    rmseall = [];
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
        [pull, action, rmse] = mle_evaluate_simulation(types{j},paramall,wholeses,append(string(tasks(i)),string(types(j))),figid);
        figid = figid+1;
        rmseall = [rmseall; rmse];
    end
    if i == 1
        figure('Position', [100 100 200 500], 'Name','Figure 3C');
    else
        figure('Position', [100 100 200 500], 'Name','Figure 3F');
    end
    for mice=1:t
        plot([rmseall(1,mice) rmseall(2,mice)], 'k')
        hold on
    end
    [~,p]=ttest(rmseall(1,:), rmseall(2,:));
    disp(p)
    scatter([ones(t) repmat(2,t)], [rmseall(1,:) rmseall(2,:)], 'k')
    ax = gca;
    ax.XAxis.FontSize = 20;
    ax.YAxis.FontSize = 20;
    ylim([0,0.6])
    xlim([0,3])
    xticks([0 1 2 3])
    xticklabels({'', 'S-F', 'P-S-F', ''})
    hold off
end
 