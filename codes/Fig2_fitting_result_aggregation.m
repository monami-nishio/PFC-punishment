addpath(['..', filesep, 'scripts'])
addpath(['..', filesep, 'scripts', filesep,'SupFig1_fitting'])

tasks = {'airpuff', 'omission'};
types = {'SFP', 'SF'}; 

for i = 1:length(tasks)
    for j = 1:length(types)
        param = load(['..', filesep, 'param', filesep , 'fitting', filesep , tasks{i}, types{j}, '.mat']);
        if length(types{j})==3
            for m = 1:height(param.ML_Q)
                alpha_l = [];
                alpha_f = [];
                kappa_r = [];
                kappa_c = [];
                lambda_e = [];
                intlqp = [];
                intlqn = [];
                likelihood = [];                
                for t = 1:100
                    lm = param.ML_Q{m,1+t};
                    alpha_l = [alpha_l lm.alpha_l];
                    alpha_f = [alpha_f lm.alpha_f];
                    kappa_r = [kappa_r lm.kappa_r];
                    kappa_c = [kappa_c lm.kappa_c];
                    lambda_e = [lambda_e lm.lambda_e];
                    intlqp = [intlqp lm.intlqp];
                    intlqn = [intlqn lm.intlqn];
                    likelihood = [likelihood lm.log_likelihood];
                end
                minindex = find(likelihood==min(likelihood));
                minindex = minindex(1);
                param.ML_Q{m,2}.alpha_l = alpha_l(minindex);
                param.ML_Q{m,2}.alpha_f = alpha_f(minindex);
                param.ML_Q{m,2}.kappa_r = kappa_r(minindex);
                param.ML_Q{m,2}.kappa_c = kappa_c(minindex);
                param.ML_Q{m,2}.lambda_e = lambda_e(minindex);
                param.ML_Q{m,2}.intlqp = intlqp(minindex);
                param.ML_Q{m,2}.intlqn = intlqn(minindex);
                param.ML_Q{m,2}.log_likelihood = likelihood(minindex);
            end
        else
            for m = 1:height(param.ML_Q)
                alpha_l = [];
                alpha_f = [];
                kappa_r = [];
                lambda_e = [];
                intlqp = [];
                intlqn = [];
                likelihood = [];    
                for t = 1:100
                    lm = param.ML_Q{m,1+t};
                    alpha_l = [alpha_l lm.alpha_l];
                    alpha_f = [alpha_f lm.alpha_f];
                    kappa_r = [kappa_r lm.kappa_r];
                    lambda_e = [lambda_e lm.lambda_e];
                    intlqp = [intlqp lm.intlqp];
                    intlqn = [intlqn lm.intlqn];         
                    likelihood = [likelihood lm.log_likelihood];
                end
                minindex = find(likelihood==min(likelihood));
                minindex = minindex(1);
                param.ML_Q{m,2}.alpha_l = alpha_l(minindex);
                param.ML_Q{m,2}.alpha_f = alpha_f(minindex);
                param.ML_Q{m,2}.kappa_r = kappa_r(minindex);
                param.ML_Q{m,2}.lambda_e = lambda_e(minindex);
                param.ML_Q{m,2}.intlqp = intlqp(minindex);
                param.ML_Q{m,2}.intlqn = intlqn(minindex);
                param.ML_Q{m,2}.log_likelihood = likelihood(minindex);
            end
        end
        ML_Q = param.ML_Q(:,1:2);
        save(append('..', filesep, 'result', tasks{i}, types{j}),'ML_Q')
    end
end