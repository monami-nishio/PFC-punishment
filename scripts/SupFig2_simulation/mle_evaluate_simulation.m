function [pull, action, rmse_allmice] = mle_evaluate_simulation(type,param_type,wholeses,nametofit,figid)
% max likelihood estimation
% for Qlearning
%%
addpath(['..', filesep, 'scripts'])
rng(1)

fignames = ['A' 'B' 'C' 'D'];
if figid < 3
    mouseid='AM';
else
    mouseid='OM';
end
figure('Position', [100 100 500 120*length(wholeses)], 'Name',strcat('Supplementary Figure 2',fignames(figid)))
f = tiledlayout(length(wholeses),2);
rmse_allmice = [];
all_sessions = [];
for l = 1:length(wholeses)
    history = wholeses{l,2};
    history.airpuff = history.punish;
    ses_len = history.ses_len;
    Cue1 = history.Cue1;
    Cue2 = history.Cue2;
    sessions = history.ses_len;
    sessionA = sessions(history.Cue1==1);
    sessionB = sessions(history.Cue1==0);
    x = param_type(:,l);
    tr = 1;
    actionAall = [];
    actionBall = [];
    rmseall = [];
    pull = history.success;
    for i = 1:1000
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
    plot(pullAmean, 'Color',[0.9290 0.6940 0.1250],'LineWidth',2)
    session_change = find((sessionA - [1 sessionA(1:length(sessionA)-1)])==1);
    session_change = [session_change length(sessionA)];
    for change = 1:2:(length(session_change)-1)
        a = area([session_change(change) session_change(change+1)], [1 1], "FaceColor", "black", "EdgeColor", "none");
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
    session_change = [session_change length(sessionB)];
    for change = 1:2:(length(session_change)-1)
        a = area([session_change(change) session_change(change+1)], [1 1], "FaceColor", "black", "EdgeColor", "none");
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
    action = int8(action>0.5);
    sessions = [];
    for ses = 1:max(ses_len)
        cue1 = int8(ses_len==ses)+int8(Cue1)==2;
        cue2 = int8(ses_len==ses)+int8(Cue2)==2;
        sessions = [sessions [mean(pull(cue1)); mean(action(cue1)); mean(pull(cue2)); mean(action(cue2))]];
    end
    for i = 1:15-width(sessions)
        sessions = [sessions [NaN; NaN; NaN; NaN]];
    end
    all_sessions = [all_sessions; sessions];
end
%export_figure_as_epsc_VectorFile(nametofit)

%fignames = {'B-SF', 'B-SFP', 'E-SF', 'E-SFP'};
%if figid < 3
%    sum = 5;
%else
%    sum = 7;
%end
%figure('Name',strcat('Figure 3',fignames{figid}))
%colors = {[0.9290 0.6940 0.1250],[0.8500 0.3250 0.0980],[0.3010 0.7450 0.9330], [0 0.4470 0.7410]};
%for i = 1:4
%    e = errorbar([1:width(all_sessions)], nanmean(all_sessions(i:4:height(all_sessions), :)), nanstd(all_sessions(i:4:height(all_sessions), :))/sqrt(sum));
%    e.Color = colors{i};
%    hold on
%end
%hold off
%t=gcf;
