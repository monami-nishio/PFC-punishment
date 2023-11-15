function [pull, action] = mle_evaluate_optimization(type,param_type,wholeses,nametofit,condition)
%%
% rng(4)
var = [-2:0.01:2; -2:0.01:2; -20:0.1:20; -20:0.1:20; -20:0.1:20];

all_rs = [];
all_Q = [];
startrate = 0;
endrate = 6;
if nametofit == 'airpuff';
    mousemax = 5;
elseif nametofit == 'omission';
    mousemax = 7;
end
for l = 1:mousemax
    history = wholeses{l,2};
    rw_total = sum(history.reward);
    rs = round(rw_total*startrate/10);
    re = round(rw_total*endrate/10);
    analyzed = (rs<=cumsum(history.reward))&(cumsum(history.reward)<=re);
    history.success = history.success(analyzed);
    history.Cue1 = history.Cue1(analyzed);
    history.Cue2 = history.Cue2(analyzed);
    history.reward = history.reward(analyzed);
    history.airpuff = history.airpuff(analyzed);
    x = param_type(:,l);
    x_copy = x;
    var_rs = [];
    var_Q = [];
    if nametofit == 'airpuff';
        varmax = 5;
    elseif nametofit == 'omission';
        varmax = 4;
    end
    for iVar = 1:varmax
        whole_rs = [];
        whole_Q = [];
        for iParam = 1:width(var)
            x = x_copy;
            x(iVar) = x(iVar)+var(iVar,iParam);
            part_rs = [];
            part_Q = [];
            tr = 1;
            for t = 1:100
                if nametofit == 'airpuff';
                    [action,Qp,Qn] = Q_simulate_airpuff(history,tr,x(1),x(2),x(5),x(4),x(3),x(8),x(9),x(10),x(11));
                elseif nametofit == 'omission';
                    [action,Qp,Qn] = Q_simulate_omission(history,tr,x(1),x(2),x(4),0,x(3),x(7),x(8),x(9),x(10));
                end
                pull = history.success;
                rsquares = sqrt(immse(pull, action));
                part_rs = [part_rs rsquares];
                part_Q = [part_Q; [Qp(1,1) Qp(2,1) Qn(1,1) Qn(2,1) Qp(1,length(Qp)) Qp(2,length(Qp)) Qn(1,length(Qn)) Qn(2,length(Qn))]];
            end
            whole_rs = [whole_rs mean(part_rs)];
            whole_Q = [whole_Q mean(part_Q)];
        end
        var_rs = [var_rs; whole_rs];
        var_Q = [var_Q; whole_Q];
    end
    all_rs = [all_rs; var_rs];
    all_Q = [all_Q; var_Q];
end
save(append('..', filesep, 'result', filesep, nametofit, type, condition, '.mat'), 'all_rs', 'all_Q')    
end
