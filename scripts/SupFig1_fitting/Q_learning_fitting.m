function [cue1,cue2,action] = Q_learning_fitting(history,tr,initial_value,initial_value_n,alpha_l,alpha_f,lambda_e,kappa_c,kappa_r)
% history: binary data, tr: percentage of training trials
% initial_value, initial_value_n: initial Q value for pulling/no-pulling
% alpha_l: learning rate, alpha_f: forgetting rate
% lambda_e: saving of cost accompanying lever-pull, kappa_c: cost for pulling lever
% kappa_r: goodness of water drop, 0: aversiveness of no reward

%% Initialize
trial_tr = round(length(history.success)*tr);
% TD error
cue1.delta = []; cue2.delta = [];
cue1.delta_n = []; cue2.delta_n = [];
% Q value
cue1.Q = []; cue2.Q = [];
cue1.Q_n = []; cue2.Q_n = [];
% action selection
action = [];

%% First step
cue1.Q(1) = initial_value; cue2.Q(1) = initial_value;
cue1.Q_n(1) = initial_value_n; cue2.Q_n(1) = initial_value_n;
action(1) = rand;
%% Behavior Model
% value iteration

for i = 1:trial_tr
    Rw = kappa_r * history.reward(i) - 0 * (1 - history.reward(i));
    
    
    if history.Cue1(i) == 1
        s1 = 1; s2 = 0;
        if history.success(i) == 1
            cue1.delta(i) = Rw - kappa_c * history.punish(i) - cue1.Q(i);
            cue1.delta_n(i) = 0;
            cue1.Q(i+1) = cue1.Q(i) + alpha_l * cue1.delta(i);
            cue1.Q_n(i+1) = (1 - alpha_f) * cue1.Q_n(i);
        else
            cue1.delta(i) = 0;
            cue1.delta_n(i) = lambda_e - cue1.Q_n(i);
            cue1.Q(i+1) = (1 - alpha_f) * cue1.Q(i);
            cue1.Q_n(i+1) = cue1.Q_n(i) + alpha_l * cue1.delta_n(i);
        end
        cue2.delta(i) = 0;
        cue2.delta_n(i) = 0;
        cue2.Q(i+1) = cue2.Q(i);
        cue2.Q_n(i+1) = cue2.Q_n(i);
    else
        s1 = 0; s2 = 1;
        if history.success(i) == 1
            cue2.delta(i) = Rw - kappa_c * history.punish(i)- cue2.Q(i);
            cue2.delta_n(i) = 0;
            cue2.Q(i+1) = cue2.Q(i) + alpha_l * cue2.delta(i);
            cue2.Q_n(i+1) = (1 - alpha_f) * cue2.Q_n(i);
        else
            cue2.delta(i) = 0;
            cue2.delta_n(i) = lambda_e - cue2.Q_n(i);
            cue2.Q(i+1) = (1 - alpha_f) * cue2.Q(i);
            cue2.Q_n(i+1) = cue2.Q_n(i) + alpha_l * cue2.delta_n(i);
        end
        cue1.delta(i) = 0;
        cue1.delta_n(i) = 0;
        cue1.Q(i+1) = cue1.Q(i);
        cue1.Q_n(i+1) = cue1.Q_n(i);
    end
    
    action(i) = 1 / (1 + exp(s1 * (cue1.Q_n(i) - cue1.Q(i)) + s2 * (cue2.Q_n(i) - cue2.Q(i))));
    
end
end