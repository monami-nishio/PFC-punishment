function [pull, action] = mle_evaluate_simulation(type,param_type,wholeses,nametofit)
% max likelihood estimation
% for Qlearning
%%
figure('Position', [100 100 500 100*length(wholeses)])
f = tiledlayout(length(wholeses),2);
for l = 1:length(wholeses)
    history = wholeses{l,2};
    history.airpuff = history.punish;
    sessions = history.ses_len;
    sessionA = sessions(history.Cue1==1);
    sessionB = sessions(history.Cue1==0);
    x = param_type(:,l);
    tr = 1;
    for i = 1:1000
        if nametofit=='airpuff';
            switch type 
                case 'RNLDF' 
                    [action] = Q_simulate_airpuff(history,tr,x(5),x(6),x(1),x(2),x(4),0,x(3));
                case 'RCNLDF'
                    [action] = Q_simulate_airpuff(history,tr,x(6),x(7),x(1),x(2),x(5),x(4),x(3));
            end
        else
            switch type 
                case 'RNLDF' 
                    [action] = Q_simulate_omission(history,tr,x(5),x(6),x(1),x(2),x(4),0,x(3));
                case 'RCNLDF'
                    [action] = Q_simulate_omission(history,tr,x(6),x(7),x(1),x(2),x(5),x(4),x(3));
            end
        end
    end
    pull = history.success;
    pullA = pull(history.Cue1==1);
    pullB = pull(history.Cue1==0);
    actionA = action(history.Cue1==1);
    actionB = action(history.Cue1==0);
    pullAmean = [];
    pullBmean = [];
    actionAmean = [];
    actionBmean = [];
    for i=1:length(pullA)-10
        pullAmean = [pullAmean mean(pullA(i:i+10))];
        actionAmean = [actionAmean mean(actionA(i:i+10))];
    end
    for i=1:length(pullB)-10
        pullBmean = [pullBmean mean(pullB(i:i+10))];
        actionBmean = [actionBmean mean(actionB(i:i+10))];
    end
    nexttile
    plot(pullAmean, 'Color',[0.9290 0.6940 0.1250],'LineWidth',2)
    hold on 
    session_change = find((sessionA - [1 sessionA(1:length(sessionA)-1)])==1);
    for change = 2:2:(length(session_change)-1)
        a = area([session_change(change) session_change(change+1)], [1 1], "FaceColor", "black");
        a.FaceAlpha = 0.2;
    end
    plot(actionAmean, 'Color',[0.8500 0.3250 0.0980],'LineWidth',2)
    ylim([0,1])
    yticks([0,1])
    ylabel('Pull choice')
    xlabel('Trial over training sessions')
    xlim([0,length(actionAmean)])
    xticks([1,length(actionAmean)])
    hold off
    nexttile
    plot(pullBmean,'Color', [0.3010 0.7450 0.9330],'LineWidth',2)
    hold on 
    session_change = find((sessionB - [1 sessionB(1:length(sessionB)-1)])==1);
    for change = 2:2:(length(session_change)-1)
        a = area([session_change(change) session_change(change+1)], [1 1], "FaceColor", "black");
        a.FaceAlpha = 0.2;
    end
    plot(actionBmean,'Color', [0 0.4470 0.7410],'LineWidth',2)
    ylim([0,1])
    yticks([0,1])
    ylabel('Pull choice')
    xlabel('Trial over training sessions')
    xlim([0,length(actionBmean)])
    xticks([1,length(actionBmean)])
    hold off
end
