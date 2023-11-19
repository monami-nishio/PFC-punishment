addpath(['..', filesep, 'scripts'])
addpath(['..', filesep, 'scripts', filesep,'SupFig1_fitting'])

tasks = {'airpuff', 'omission'};
types = {'SFP', 'SF'}; 

for i = 1:length(tasks)
    for j = 1:length(types)
        param = load(['..', filesep, 'result', filesep , tasks{i}, types{j}, '.mat']);
        if length(types{j})==3
            for m = 1:height(param)
                alpha_l = [];
                alpha_f = [];
                kappa_r = [];
                kappa_c = [];
                lambda_e = [];
                intlqp = [];
                intlqn = [];
                for t = 1:100
                    lm = param.ML_Q{m,1+t};
                    alpha_l = [alpha_l lm.alpha_l];
                    alpha_f = [alpha_f lm.alpha_f];
                    kappa_r = [kappa_r lm.kappa_r];
                    kappa_c = [kappa_c lm.kappa_c];
                    lambda_e = [lambda_e lm.lambda_e];
                    intlqp = [intlqp lm.intlqp];
                    intlqn = [intlqn lm.intlqn];
                end
                param.ML_Q{m,2}.alpha_l = median(alpha_l);
                param.ML_Q{m,2}.alpha_f = median(alpha_f);
                param.ML_Q{m,2}.kappa_r = median(kappa_r);
                param.ML_Q{m,2}.kappa_c = median(kappa_c);
                param.ML_Q{m,2}.lambda_e = median(lambda_e);
                param.ML_Q{m,2}.intlqp = median(intlqp);
                param.ML_Q{m,2}.intlqn = median(intlqn);

            end
        else
            for m = 1:height(param)
                alpha_l = [];
                alpha_f = [];
                kappa_r = [];
                lambda_e = [];
                intlqp = [];
                intlqn = [];
                for t = 1:100
                    lm = param.ML_Q{m,1+t};
                    alpha_l = [alpha_l lm.alpha_l];
                    alpha_f = [alpha_f lm.alpha_f];
                    kappa_r = [kappa_r lm.kappa_r];
                    lambda_e = [lambda_e lm.lambda_e];
                    intlqp = [intlqp lm.intlqp];
                    intlqn = [intlqn lm.intlqn];                    
                end
                param.ML_Q{m,2}.alpha_l = median(alpha_l);
                param.ML_Q{m,2}.alpha_f = median(alpha_f);
                param.ML_Q{m,2}.kappa_r = median(kappa_r);
                param.ML_Q{m,2}.lambda_e = median(lambda_e);
                param.ML_Q{m,2}.intlqp = median(intlqp);
                param.ML_Q{m,2}.intlqn = median(intlqn);
            end
        end
        ML_Q = param.ML_Q(:,1:2);
        save(append('..', filesep, 'param', filesep , 'original', filesep , tasks{i}, types{j}),'ML_Q')
    end
end