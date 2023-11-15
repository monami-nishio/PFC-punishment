function [pull, action, rmse_allmice] = mle_evaluate_simulation(type,param_type,wholeses,nametofit,figid)
% max likelihood estimation
% for Qlearning
%%
% rng(4)

fignames = ['A' 'B' 'C' 'D'];
if figid < 3
    mouseid='AM';
else
    mouseid='OM';
end
figure('Position', [100 100 500 120*length(wholeses)], 'Name',strcat('Supplementary Figure 2',fignames(figid)))
f = tiledlayout(length(wholeses),2);
rmse_allmice = [];
for l = 1:length(wholeses)
    history = wholeses{l,2};
    history.airpuff = history.punish;
    sessions = history.ses_len;
    sessionA = sessions(history.Cue1==1);
    sessionB = sessions(history.Cue1==0);
    x = param_type(:,l);
    tr = 1;
    actionAall = [];
    actionBall = [];
    rmseall = [];
    pull = history.success;
    for i = 1:2
        if nametofit=='airpuff';
            switch type 
                case 'SF' 
                    [action] = Q_simulate_airpuff(history,tr,x(5),x(6),x(1),x(2),x(4),0,x(3));
                case 'SFP'
                    [action] = Q_simulate_airpuff(history,tr,x(6),x(7),x(1),x(2),x(5),x(4),x(3));
            end
        else
            switch type 
                case 'SF' 
                    [action] = Q_simulate_omission(history,tr,x(5),x(6),x(1),x(2),x(4),0,x(3));
                case 'SFP'
                    [action] = Q_simulate_omission(history,tr,x(6),x(7),x(1),x(2),x(5),x(4),x(3));
            end
        end
        actionAall = [actionAall; action(history.Cue1==1)];
        actionBall = [actionBall; action(history.Cue1==0)];
        %rmse = sum(pull==(action>0.5), 'all')/numel(action);
        rmse = sqrt(immse(pull, action));
        rmseall = [rmseall rmse];
    end
    rmse_allmice = [rmse_allmice mean(rmseall)];
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
    title(strcat(mouseid, string(l)))
    hold on 
    plot(pullAmean, 'Color',[0.9290 0.6940 0.1250],'LineWidth',2)
    session_change = find((sessionA - [1 sessionA(1:length(sessionA)-1)])==1);
    for change = 2:2:(length(session_change)-1)
        a = area([session_change(change) session_change(change+1)], [1 1], "FaceColor", "black");
        a.FaceAlpha = 0.2;
    end
    upper = actionAmean + actionAsem;
    lower = actionAmean - actionAsem;
    plot(actionAmean, 'Color',[0.8500 0.3250 0.0980],'LineWidth',2)
    h = fill([1:length(upper) fliplr(1:length(upper))],[lower fliplr(upper)],[0.8500 0.3250 0.0980]);
    set(h,'facealpha',.5)
    ylim([0,1])
    yticks([0,1])
    ylabel('Pull choice')
    xlabel('Trial over training sessions')
    xlim([1,length(actionAmean)])
    xticks([1,length(actionAmean)])
    xticklabels({1,length(actionAmean)+10})
    hold off
    nexttile
    title(strcat(mouseid, string(l)))
    hold on 
    plot(pullBmean,'Color', [0.3010 0.7450 0.9330],'LineWidth',2)
    session_change = find((sessionB - [1 sessionB(1:length(sessionB)-1)])==1);
    for change = 2:2:(length(session_change)-1)
        a = area([session_change(change) session_change(change+1)], [1 1], "FaceColor", "black");
        a.FaceAlpha = 0.2;
    end
    plot(actionBmean,'Color', [0 0.4470 0.7410],'LineWidth',2)
    upper = actionBmean + actionBsem;
    lower = actionBmean - actionBsem;
    h = fill([1:length(upper) fliplr(1:length(upper))],[lower fliplr(upper)],[0 0.4470 0.7410]);
    set(h,'facealpha',.5)
    ylim([0,1])
    yticks([0,1])
    ylabel('Pull choice')
    xlabel('Trial over training sessions')
    xlim([1,length(actionBmean)])
    xticks([1,length(actionBmean)])
    xticklabels({1,length(actionBmean)+10})
    hold off
end
