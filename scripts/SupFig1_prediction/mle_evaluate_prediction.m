function [pull, action,ml] = mle_evaluate_prediction(type,param_type,wholeses,nametofit,figid)
% max likelihood estimation
% for Q_learning
rng(4)

fignames = ['A' 'B' 'C' 'D'];
if figid < 3
    mouseid='AM';
else
    mouseid='OM';
end
%%
all_pullA = zeros(200,length(wholeses));
all_actionA = zeros(200,length(wholeses));
all_pullB = zeros(200,length(wholeses));
all_actionB = zeros(200,length(wholeses));
t = 1;
figure('Position', [100 100 500 120*length(wholeses)], 'Name',strcat('Supplementary Figure 1',fignames(figid)))
f = tiledlayout(length(wholeses),2,'TileSpacing','Compact','Padding','Compact');
for l = 1:height(wholeses)
    history = wholeses{l,2};
    x = struct2cell(param_type.ML_Q{l,2});
    x = cell2mat(x);
    x = x(1:length(x)-1);
    sessions = history.ses_len;
    sessionA = sessions(history.Cue1==1);
    sessionB = sessions(history.Cue1==0);
    tr = 1;
    switch type
        case 'SF' 
            [cue1Q,cue1Q_n,cue2Q,cue2Q_n,action] = Q_learning_prediction(history,tr,x(5),x(6),x(1),x(2),x(4),0,x(3));
            max_lkh.alpha_l = x(1);
            max_lkh.alpha_f = x(2);
            max_lkh.kappa_r = x(3);
            max_lkh.lambda_e = x(4);
            max_lkh.intlqp = x(5);
            max_lkh.intlqn = x(6);
        case 'SFP' 
            [cue1Q,cue1Q_n,cue2Q,cue2Q_n,action] = Q_learning_prediction(history,tr,x(6),x(7),x(1),x(2),x(5),x(4),x(3));
            max_lkh.alpha_l = x(1);
            max_lkh.alpha_f = x(2);
            max_lkh.kappa_r = x(3);
            max_lkh.kappa_c = x(4);
            max_lkh.lambda_e = x(5);
            max_lkh.intlqp = x(6);
            max_lkh.intlqn = x(7);
    end
    pull = history.success;
    action = action>0.5;
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
    title(strcat(mouseid, string(l)))
    hold on 
    plot(pullAmean, 'Color',[0.9290 0.6940 0.1250],'LineWidth',2)
    session_change = find((sessionA - [1 sessionA(1:length(sessionA)-1)])==1);
    session_change = [session_change length(sessionA)];
    for change = 1:2:(length(session_change)-1)
        a = area([session_change(change) session_change(change+1)], [1 1], "FaceColor", "black");
        a.FaceAlpha = 0.2;
    end

    ylim([0,1])
    yticks([0,1])
    ylabel('Pa,pull')
    xlabel('Trial over training sessions')
    plot(actionAmean, 'Color',[0.8500 0.3250 0.0980],'LineWidth',2)
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
        a = area([session_change(change) session_change(change+1)], [1 1], "FaceColor", "black");
        a.FaceAlpha = 0.2;
    end
    plot(actionBmean,'Color', [0 0.4470 0.7410],'LineWidth',2)
    ylim([0,1])
    yticks([0,1])
    ylabel('Pb,pull')
    xlabel('Trial over training sessions')
    xlim([1,length(actionBmean)])
    xticks([1,length(actionBmean)])
    xticklabels({1,length(actionBmean)+10})
    hold off
    max_lkh.Q1 = cue1Q;
    max_lkh.Qn1 = cue1Q_n;
    max_lkh.Q2 = cue2Q;
    max_lkh.Qn2 = cue2Q_n;
    ml.ML_Q{t,1} = param_type.ML_Q{l,1};
    ml.ML_Q{t,2} = max_lkh;
    t = t+1;
end