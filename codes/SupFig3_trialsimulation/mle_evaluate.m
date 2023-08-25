function [pull, action] = mle_evaluate(type,param_type,wholeses,condition,savefilename)

startrate = 0;
endrate = 6;

t = tiledlayout(length(wholeses),2);
tr = 1;
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
            [action] = QL_forget_simulate(history,tr,x(6),x(7),x(1),x(2),x(5),x(4),x(3),x(8),x(9),x(10),x(11));
        elseif condition == "omission"
            [action] = QL_forget_simulate_omission(history,tr,x(5),x(6),x(1),x(2),x(4),0,x(3),0,0,0,0);
        end
        actionAall = [actionAall; action(history.Cue1==1)];
        actionBall = [actionBall; action(history.Cue1==0)];
    end
    pull = history.success;
    pullA = pull(history.Cue1==1);
    pullB = pull(history.Cue1==0);
    pullAmean = [];
    pullBmean = [];
    actionAmean = [];
    actionBmean = [];
    actionAsem = [];
    actionBsem = [];
    for i=1:length(pullA)-10
        pullAmean = [pullAmean mean(pullA(i:i+10))];
        actionAmean = [actionAmean mean(mean(actionAall(:,i:i+10)))];
        actionAsem = [actionAsem std(reshape(actionAall(:,i:i+10), 1,[]))/sqrt(10)];
    end
    for i=1:length(pullB)-10
        pullBmean = [pullBmean mean(pullB(i:i+10))];
        actionBmean = [actionBmean mean(mean(actionBall(:,i:i+10)))];
        actionBsem = [actionBsem std(reshape(actionBall(:,i:i+10), 1,[]))/sqrt(10)];
    end
    nexttile
    plot(pullAmean, 'Color',[0.9290 0.6940 0.1250],'LineWidth',1)
    hold on 
    upper = actionAmean + actionAsem;
    lower = actionAmean - actionAsem;
    plot(actionAmean, 'Color', [0.8500 0.3250 0.0980],'LineWidth',1)
    hold on
    h = fill([1:length(upper) fliplr(1:length(upper))],[lower fliplr(upper)],[0.8500 0.3250 0.0980]);
    set(h,'facealpha',.5)
    ylim([0,1])
    yticks([])
    xticks([])
    hold off
    nexttile
    plot(pullBmean,'Color', [0.3010 0.7450 0.9330],'LineWidth',1)
    hold on 
    upper = actionBmean + actionBsem;
    lower = actionBmean - actionBsem;
    plot(actionBmean, 'Color', [0 0.4470 0.7410],'LineWidth',1)
    hold on
    h = fill([1:length(upper) fliplr(1:length(upper))],[lower fliplr(upper)],[0 0.4470 0.7410]);
    set(h,'facealpha',.5)
    ylim([0,1])
    yticks([])
    xticks([])
    hold off
    t=gcf;
end


