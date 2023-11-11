function [pull, action,ml] = mle_evaluate_prediction(type,param_type,wholeses,nametofit)
% max likelihood estimation
% for Q_learning

%%
all_pullA = zeros(200,length(wholeses));
all_actionA = zeros(200,length(wholeses));
all_pullB = zeros(200,length(wholeses));
all_actionB = zeros(200,length(wholeses));
f = tiledlayout(length(wholeses),2,'TileSpacing','Compact','Padding','Compact');
t = 1;
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
        case 'RNLDF' 
            [cue1Q,cue1Q_n,cue2Q,cue2Q_n,action] = Q_learning_prediction(history,tr,x(5),x(6),x(1),x(2),x(4),0,x(3));
            max_lkh.alpha_l = x(1);
            max_lkh.alpha_f = x(2);
            max_lkh.kappa_r = x(3);
            max_lkh.lambda_e = x(4);
            max_lkh.intlqp = x(5);
            max_lkh.intlqn = x(6);
        case 'RCNLDF' 
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
    plot(pullAmean, 'Color',[0.9290 0.6940 0.1250],'LineWidth',2)
    hold on 
    plot((sessionA-min(sessionA))/(max(sessionA)-min(sessionA)))
    ylim([0,1])
    yticks([])
    plot(actionAmean, 'Color',[0.8500 0.3250 0.0980],'LineWidth',2)
    xlim([0,length(actionAmean)])
    hold off
    nexttile
    plot(pullBmean,'Color', [0.3010 0.7450 0.9330],'LineWidth',2)
    hold on 
    plot((sessionB-min(sessionB))/(max(sessionB)-min(sessionB)))
    plot(actionBmean,'Color', [0 0.4470 0.7410],'LineWidth',2)
    ylim([0,1])
    yticks([])
    hold off
    max_lkh.Q1 = cue1Q;
    max_lkh.Qn1 = cue1Q_n;
    max_lkh.Q2 = cue2Q;
    max_lkh.Qn2 = cue2Q_n;
    ml.ML_Q{t,1} = param_type.ML_Q{l,1};
    ml.ML_Q{t,2} = max_lkh;
    t = t+1;
end
figurename = append('..', filesep, '..', filesep, 'result', filesep, nametofit, type);
gcf = f;
export_figure_as_epsc_VectorFile(figurename)
