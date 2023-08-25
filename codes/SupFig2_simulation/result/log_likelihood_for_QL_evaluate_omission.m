function [pull,action] = log_likelihood_for_QL_evaluate(x,history,type)

% v: [initial value for pulling; initial value for no pulling]

tr = 1;
% cost = 0.3;

pull = history.success;
% pull_1 = pull(history.~==1);
% pull_2 = pull(history.~==1);


switch type 
% [cue1,cue2,action] = QL_forget_s(history,tr,initial_value,initial_value_n,alpha_l,alpha_f,cost,cost_s,kappa_r,kappa_a)
    case 'R' %'Reward' (simple)
        [~,~,action] = QL_forget_s(history,tr,x(3),0,x(1),0,0,0,x(2),0);
    case 'RF' %'Reward-Forgetting'
        [~,~,action] = QL_forget_s(history,tr,x(3),0,x(1),x(1),0,0,x(2),0);
    case 'RDF' %'Reward-DForgetting' (forgettning)
        [~,~,action] = QL_forget_s(history,tr,x(4),0,x(1),x(2),0,0,x(3),0);
    case 'RC' %'Reward-Cost' (simple cost)
        [~,~,action] = QL_forget_s(history,tr,x(4),0,x(1),0,0,x(3),x(2),0);
    case 'RCF' %'Reward-Cost-Forgetting'
        [~,~,action] = QL_forget_s(history,tr,x(4),0,x(1),x(1),0,x(3),x(2),0);
    case 'RCDF' %'Reward-Cost-DForgetting' (cost)
        [~,~,action] = QL_forget_s(history,tr,x(5),x(6),x(1),x(2),0,x(4),x(3),0);
    case 'RNL' %'Reward-NOP-Learning' (simple saving)
        [~,~,action] = QL_forget_s_full(history,tr,x(4),x(5),x(1),0,x(3),0,x(2),0);
    case 'RNLF' %'Reward-NOP-Learning-Forgetting' 
        [~,~,action] = QL_forget_s_full(history,tr,x(4),x(5),x(1),x(1),x(3),0,x(2),0);
    case 'RNLDF' %'Reward-NOP-Learning-DForgetting' (saving)
        [action] = QL_forget_simulate_omission(history,tr,x(5),x(6),x(1),x(2),x(4),0,x(3),0,0,0,0);
        %[action] = QL_forget_s(history,tr,x(5),x(6),x(1),x(2),x(4),0,x(3),0,0,0,0);
    case 'RCNL' %'Reward-Cost_NOP-Learning'
        [~,~,action] = QL_forget_s(history,tr,x(5),x(6),x(1),0,x(4),x(3),x(2),0);
    case 'RCNLF' %'Reward-Cost_NOP-Learning-Forgetting'
        [~,~,action] = QL_forget_s(history,tr,x(5),x(6),x(1),x(1),x(4),x(3),x(2),0);
    case 'RCNLDF' %'Reward-Cost_NOP-Learning-DForgetting' (full)
        [action] = QL_forget_simulate_omission(history,tr,x(6),x(7),x(1),x(2),x(5),x(4),x(3),0,0,0,0); %x(8),x(9),x(10),x(11)
end
% fminsearch‚ðŽg‚¢‚½‚¢‚Ì‚Å-‚ð‚©‚¯‚Ä‚¢‚é
