function [pull, action] = mle_evaluate(type,param_type,wholeses,nametofit)
% max likelihood estimation
% for Qlearning
%%
t = tiledlayout(length(wholeses),2);
for l = 1:length(wholeses)
    history = wholeses{l,2};
    history.airpuff = history.punish;
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
end
