function [pull, action,ml] = mle_evaluate(type,param_type,wholeses,nametofit)
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
    session = history.ses_len;
    tr = 1;
    switch type
        case 'R' %'Reward' (simple)
            [cue1Q,cue1Q_n,cue2Q,cue2Q_n,action] = Q_learning(history,tr,x(3),0,x(1),0,0,0,x(2),0);
        case 'RF' %'Reward-Forgetting'
            [cue1Q,cue1Q_n,cue2Q,cue2Q_n,action] = Q_learning(history,tr,x(3),0,x(1),x(1),0,0,x(2),0);
        case 'RDF' %'Reward-DForgetting' (forgettning)
            [cue1Q,cue1Q_n,cue2Q,cue2Q_n,action] = Q_learning(history,tr,x(4),0,x(1),x(2),0,0,x(3),0);
        case 'RC' %'Reward-Cost' (simple cost)
            [cue1Q,cue1Q_n,cue2Q,cue2Q_n,action] = Q_learning(history,tr,x(4),0,x(1),0,0,x(3),x(2),0);
        case 'RCF' %'Reward-Cost-Forgetting'
            [cue1Q,cue1Q_n,cue2Q,cue2Q_n,action] = Q_learning(history,tr,x(4),0,x(1),x(1),0,x(3),x(2),0);
        case 'RCDF' %'Reward-Cost-DForgetting' (cost)
            [cue1Q,cue1Q_n,cue2Q,cue2Q_n,action] = Q_learning(history,tr,x(5),0,x(1),x(2),0,x(4),x(3),0);
        case 'RNL' %'Reward-NOP-Learning' (simple saving)
            [cue1Q,cue1Q_n,cue2Q,cue2Q_n,action] = Q_learning(history,tr,x(4),x(5),x(1),0,x(3),0,x(2),0);
        case 'RNLF' %'Reward-NOP-Learning-Forgetting' 
            [cue1Q,cue1Q_n,cue2Q,cue2Q_n,action] = Q_learning(history,tr,x(4),x(5),x(1),x(1),x(3),0,x(2),0);
        case 'RNLDF' %'Reward-NOP-Learning-DForgetting' (saving)
            [cue1Q,cue1Q_n,cue2Q,cue2Q_n,action] = Q_learning(history,tr,x(5),x(6),x(1),x(2),x(4),0,x(3),0);
        case 'RCNL' %'Reward-Cost_NOP-Learning'
            [cue1Q,cue1Q_n,cue2Q,cue2Q_n,action] = Q_learning(history,tr,x(5),x(6),x(1),0,x(4),x(3),x(2),0);
        case 'RCNLF' %'Reward-Cost_NOP-Learning-Forgetting'
            [cue1Q,cue1Q_n,cue2Q,cue2Q_n,action] = Q_learning(history,tr,x(5),x(6),x(1),x(1),x(4),x(3),x(2),0);
        case 'RCNLDF' %'Reward-Cost_NOP-Learning-DForgetting' (full)
            [cue1Q,cue1Q_n,cue2Q,cue2Q_n,action] = Q_learning(history,tr,x(6),x(7),x(1),x(2),x(5),x(4),x(3),0);
    end
    x(8) = cue1Q;
    x(9) = cue1Q_n;
    x(10) = cue2Q;
    x(11) = cue2Q_n;
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
    ylim([0,1])
    yticks([])
    plot(actionAmean, 'Color',[0.8500 0.3250 0.0980],'LineWidth',2)
    xlim([0,length(actionAmean)])
    hold off
    nexttile
    plot(pullBmean,'Color', [0.3010 0.7450 0.9330],'LineWidth',2)
    hold on 
    plot(actionBmean,'Color', [0 0.4470 0.7410],'LineWidth',2)
    ylim([0,1])
    yticks([])
    hold off
    max_lkh.alpha_l = x(1);
    max_lkh.alpha_f = x(2);
    max_lkh.kappa_r = x(3);
    max_lkh.kappa_c = x(4);
    max_lkh.lambda_e = x(5);
    max_lkh.intlqp = x(6);
    max_lkh.intlqn = x(7);
    max_lkh.Q1 = x(8);
    max_lkh.Qn1 = x(9);
    max_lkh.Q2 = x(10);
    max_lkh.Qn2 = x(11);
    ml.ML_Q{t,1} = param_type.ML_Q{l,1};
    ml.ML_Q{t,2} = max_lkh;
    t = t+1;
end
figurename = append('result/' ,nametofit, type);
gcf = f;
export_figure_as_epsc_VectorFile(figurename)
