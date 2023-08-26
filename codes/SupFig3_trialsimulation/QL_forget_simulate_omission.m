
function [Pt_sim] = QL_forget_simulate_omission(history,tr,alpha_l,alpha_f,lambda_e,kappa_c,kappa_r,Q1,Qn1,Q2,Qn2)
% history: binary data, tr: percentage of training trials
% initial_value, initial_value_n: initial Q value for pulling/no-pulling
% alpha_l: learning rate, alpha_f: forgetting rate
% lambda_e: saving of cost accompanying lever-pull, kappa_c: cost for pulling lever
% kappa_r: goodness of water drop, 0: aversiveness of no reward

%% Initialize
trial_tr = round(length(history.success)*tr);
P_sim = zeros(2,trial_tr);

%% Behavior Model
% value iteration
if (sum(history.Cue1+history.success+history.reward==3)/(sum(history.Cue1+history.success==2)+1e-3)) > (sum(history.Cue2++history.success+history.reward==3)/(sum(history.Cue2+history.success==2)+1e-3))
    RewardProb = [0.9, 0.1];
else
    RewardProb = [0.1, 0.9];
end
Q = P_sim; Q(1,1) = Q1-Qn1; Q(2,1) = Q2-Qn2;
Qp = P_sim; Qp(1,1) = Q1; Qp(2,1) = Q2;
Qn = P_sim; Qn(1,1) = Qn1; Qn(2,1) = Qn2; 

reward_sim = zeros(1,trial_tr);
action_sim = zeros(1,trial_tr);
reward_sim(1) = history.reward(1);
action_sim(1) = history.success(1);
Pt_sim = zeros(1,trial_tr);

for i = 1:(trial_tr-1)
    if action_sim(i) == 1
        if history.success(i) == 1
            reward_sim(i) = history.reward(i);
        elseif RewardProb(2-history.Cue1(i)) >= rand
            reward_sim(i) = 1;
        else
            reward_sim(i) = 0;
        end
        R = kappa_r * reward_sim(i);
        Qp(2-history.Cue1(i), i+1) = Qp(2-history.Cue1(i), i) + alpha_l * (R - Qp(2-history.Cue1(i),i));
        Qn(2-history.Cue1(i), i+1) = (1-alpha_f) * Qn(2-history.Cue1(i), i);
    else
        Qp(2-history.Cue1(i),i+1) = (1-alpha_f) * Qp(2-history.Cue1(i),i); % alpha_f
        Qn(2-history.Cue1(i),i+1) = Qn(2-history.Cue1(i),i) + alpha_l * (lambda_e - Qn(2-history.Cue1(i),i)); 
    end
    Qp(history.Cue1(i)+1,i+1) = Qp(history.Cue1(i)+1,i);
    Qn(history.Cue1(i)+1,i+1) = Qn(history.Cue1(i)+1,i);
    Q(:,i+1) = Qp(:,i+1) - Qn(:,i+1);
    P_sim(:,i+1) = 1 ./ (1 + exp(-1 * (Q(:,i+1)))); 
    Pt_sim(i+1) = P_sim(2-history.Cue1(i+1),i+1);
    if P_sim(2-history.Cue1(i+1),i+1) >= rand
        action_sim(i+1) = 1;
    end
end
