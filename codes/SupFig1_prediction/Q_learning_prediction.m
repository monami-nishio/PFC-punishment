
function [cue1Q,cue1Q_n,cue2Q,cue2Q_n,action] = Q_learning_prediction(history,tr,initial_value,initial_value_n,alpha_l,alpha_f,lambda_e,kappa_c,kappa_r)
% history: binary data, tr: percentage of training trials
% initial_value, initial_value_n: initial Q value for pulling/no-pulling
% alpha_l: learning rate, alpha_f: forgetting rate
% lambda_e: saving of cost accompanying lever-pull, kappa_c: cost for pulling lever
% kappa_r: goodness of water drop

%% Initialize
trial_tr = round(length(history.success)*tr);
% TD error
cue1.delta = []; cue2.delta = [];
cue1.delta_n = []; cue2.delta_n = [];
% Q value
cue1.Q = []; cue2.Q = [];
cue1.Q_n = []; cue2.Q_n = [];
action = [];

%% First step
cue1.Q(1) = initial_value; cue2.Q(1) = initial_value;
cue1.Q_n(1) = initial_value_n; cue2.Q_n(1) = initial_value_n;
action(1) = rand;

%% Behavior Model
for i = 1:trial_tr
    Rw = kappa_r * history.reward(i);
    
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
cue1Q = cue1.Q(trial_tr);
cue1Q_n = cue1.Q_n(trial_tr);
cue2Q = cue2.Q(trial_tr);
cue2Q_n = cue2.Q_n(trial_tr);
end
