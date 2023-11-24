function [pull, action] = mle_evaluate_trialsimulation(type,param_type,wholeses,condition,savefilename, figid)
rng(1)

fignames = ['B' 'C' 'E' 'F'];
fig6names = {'Fig6', 'Fig6', 'Supplementary Figure 5', 'Supplementary Figure 5'};
if figid < 3
    mouseid='AM';
else
    mouseid='OM';
end
startrate = 0;
endrate =  6;
figure('Position', [100 100 250 120*length(wholeses)], 'Name',strcat('Supplementary Figure 3',fignames(figid)))
t = tiledlayout(length(wholeses),2);
tr = 1;
pullAall = [];
pullBall = [];
pullAs = [];
pullBs = [];
actionAs = [];
actionBs = [];
for l = 1:length(wholeses)
    history = wholeses{l,2};
    rw_total = sum(history.reward);
    rs = fix(rw_total*startrate/10);
    re = fix(rw_total*endrate/10);
    analyzed = (rs<=cumsum(history.reward))&(cumsum(history.reward)<=re);
    history.success = history.success(analyzed);
    history.Cue1 = history.Cue1(analyzed);
    history.Cue2 = history.Cue2(analyzed);
    history.reward = history.reward(analyzed);
    history.airpuff = history.airpuff(analyzed);
    rmse_all = [];
    actionAall = [];
    actionBall = [];
    for j = 1:1000
        x = param_type(:,l);
        if condition == "airpuff"
            [action] = QL_forget_simulate_airpuff(history,tr,x(1),x(2),x(5),x(4),x(3),x(8),x(9),x(10),x(11));
        elseif condition == "omission"
            [action] = QL_forget_simulate_omission(history,tr,x(1),x(2),x(4),0,x(3),x(7),x(8),x(9),x(10));
        end
        actionAall = [actionAall; action(history.Cue1==1)];
        actionBall = [actionBall; action(history.Cue1==0)];
    end
    pull = history.success;
    pullA = pull(history.Cue1==1);
    pullB = pull(history.Cue1==0);
    pullAall = [pullAall mean(pullA)];
    pullBall = [pullBall mean(pullB)];
    pullAmean = [];
    pullBmean = [];
    actionAmean = [];
    actionBmean = [];
    actionAsem = [];
    actionBsem = [];
    for i=1:length(pullA)-10
        pullAmean = [pullAmean mean(pullA(i:i+10))];
        actionAmean = [actionAmean mean(mean(actionAall(:,i:i+10),2))];
        actionAsem = [actionAsem std(mean(actionAall(:,i:i+10),2))];
    end
    for i=1:length(pullB)-10
        pullBmean = [pullBmean mean(pullB(i:i+10))];
        actionBmean = [actionBmean mean(mean(actionBall(:,i:i+10),2))];
        actionBsem = [actionBsem std(mean(actionBall(:,i:i+10),2))];
    end
    nexttile
    title(strcat(mouseid, string(l)))
    hold on 
    plot(pullAmean, 'Color',[0.9290 0.6940 0.1250],'LineWidth',1)
    upper = actionAmean + actionAsem;
    lower = actionAmean - actionAsem;
    plot(actionAmean, 'Color', [0.8500 0.3250 0.0980],'LineWidth',1)
    hold on
    h = fill([1:length(upper) fliplr(1:length(upper))],[lower fliplr(upper)],[0.8500 0.3250 0.0980]);
    set(h,'facealpha',.5)
    ylim([0,1])
    yticks([0,1])
    ylabel('Pull choice')
    xlabel('Trials')
    xlim([1,length(actionAmean)])
    xticks([1,length(actionAmean)])
    xticklabels({1,length(actionAmean)+10})
    hold off
    nexttile
    title(strcat(mouseid, string(l)))
    hold on 
    plot(pullBmean,'Color', [0.3010 0.7450 0.9330],'LineWidth',1) 
    upper = actionBmean + actionBsem;
    lower = actionBmean - actionBsem;
    plot(actionBmean, 'Color', [0 0.4470 0.7410],'LineWidth',1)
    hold on
    h = fill([1:length(upper) fliplr(1:length(upper))],[lower fliplr(upper)],[0 0.4470 0.7410]);
    set(h,'facealpha',.5)
    ylim([0,1])
    yticks([0,1])
    ylabel('Pull choice')
    xlabel('Trials')
    xlim([1,length(actionBmean)])
    xticks([1,length(actionBmean)])
    xticklabels({1,length(actionBmean)+10})
    hold off

    pullAsampled = [];
    actionAsampled = [];
    pullBsampled = [];
    actionBsampled = [];
    if condition == "airpuff"
        Abin = 10;
        Bbin = 40;
    elseif condition == "omission"
        Abin = 20;
        Bbin = 30;
    end
    for i = 1:fix(length(pullAmean)/Abin):fix(length(pullAmean)/Abin)*(Abin-1)
        pullAsampled = [pullAsampled pullAmean(i)];
        actionAsampled = [actionAsampled actionAmean(i)];
    end
    if length(pullAsampled)<Abin+1
        for t = 1:(11-length(pullAsampled))
            pullAsampled = [pullAsampled pullAmean(i)];
            actionAsampled = [actionAsampled actionAmean(i)];
        end
    end
    for i = 1:fix(length(pullBmean)/Bbin):fix(length(pullBmean)/Bbin)*(Bbin-1)
        pullBsampled = [pullBsampled pullBmean(i)];
        actionBsampled = [actionBsampled actionBmean(i)];
    end
    if length(pullBsampled)<Bbin+1
        for t = 1:(41-length(pullBsampled))
            pullBsampled = [pullBsampled pullBmean(i)];
            actionBsampled = [actionBsampled actionBmean(i)];
        end
    end
    if length(pullAsampled)>0
        pullAs = [pullAs; pullAsampled];
        pullBs = [pullBs; pullBsampled];
        actionAs = [actionAs; actionAsampled];
        actionBs = [actionBs; actionBsampled];
    end
end
%export_figure_as_epsc_VectorFile(['..', filesep, 'result', filesep, strcat('Supplementary Figure 3',fignames(figid))])
figure('Position', [100 100 250 120], 'Name', fig6names{figid})
t = tiledlayout(1,2);
nexttile
upper = mean(pullAs) + std(pullAs)/sqrt(length(wholeses));
lower = mean(pullAs) - std(pullAs)/sqrt(length(wholeses));
plot(mean(pullAs), 'Color', [0.9290 0.6940 0.1250])
hold on
h= fill([1:length(upper) fliplr(1:length(upper))],[lower fliplr(upper)],[0.9290 0.6940 0.1250]);
set(h,'facealpha',.5)
upper = mean(actionAs) + std(actionAs)/sqrt(length(wholeses));
lower = mean(actionAs) - std(actionAs)/sqrt(length(wholeses));
plot(mean(actionAs), 'Color', [0.8500 0.3250 0.0980])
h = fill([1:length(upper) fliplr(1:length(upper))],[lower fliplr(upper)],[0.8500 0.3250 0.0980]);
set(h,'facealpha',.5)
ylim([0,1])
nexttile
upper = mean(pullBs) + std(pullBs)/sqrt(length(wholeses));
lower = mean(pullBs) - std(pullBs)/sqrt(length(wholeses));
plot(mean(pullBs), 'Color', [0.3010 0.7450 0.9330])
hold on
h = fill([1:length(upper) fliplr(1:length(upper))],[lower fliplr(upper)],[0.3010 0.7450 0.9330]);
set(h,'facealpha',.5)
upper = mean(actionBs) + std(actionBs)/sqrt(length(wholeses));
lower = mean(actionBs) - std(actionBs)/sqrt(length(wholeses));
plot(mean(actionBs), 'Color', [0 0.4470 0.7410])
h = fill([1:length(upper) fliplr(1:length(upper))],[lower fliplr(upper)],[0 0.4470 0.7410]);
set(h,'facealpha',.5)
ylim([0,1])
hold off
t=gcf;
%export_figure_as_epsc_VectorFile(['..', filesep, 'result', filesep, strcat('Figure 6',fig6names(figid))])


