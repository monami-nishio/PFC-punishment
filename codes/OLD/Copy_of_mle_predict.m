function ML_Q = Copy_of_mle_predict(type,wholeses)
%rng(1)
ML_Q = cell(length(wholeses),101);

for l = 1:height(wholeses)
    history = wholeses{l,2};
    ML_Q{l,1} = wholeses{l,1};
    for i = 1:100
        %% Maximum Log Likelihood
        rn = 50; % repeat number (パラメータ初期値の生成)
        nolimit = 0; %0: fmincon, 1: fminsearch
        switch type
            case 'SF'
                f = @(x)log_likelihood(x,history,'SF');
                tpcs = 6;
            case 'SFP'
                f = @(x)log_likelihood(x,history,'SFP');
                tpcs = 7;
        end
        
        if tpcs == 1
            x_1 = rand(1,rn);
            x_2 = 20*rand(1,rn);
            x_3 = 20*rand(1,rn);
            x_4 = 20*rand(1,rn);
            x0 = [x_1(1) x_2(1) x_3(1) x_4(1)];
            if nolimit
                [x,fun] = fminsearch(f,x0);
            else
                lb = [0 0 0 0];
                ub = [1 Inf Inf Inf];
                [x,fun] = fmincon(f,x0,[],[],[],[],lb,ub);
            end
            alpha_l = x(1);
            kappa_r = x(2);
            intlqp = x(3);
            intlqn = x(4);
            ml = fun;
            for n = 2:rn
                x0 = [x_1(n) x_2(n) x_3(n) x_4(n)];
                if nolimit
                    [x,fun] = fminsearch(f,x0);
                else
                    lb = [0 0 0 0];
                    ub = [1 Inf Inf Inf];
                    [x,fun] = fmincon(f,x0,[],[],[],[],lb,ub);
                end
                if fun < ml
                    alpha_l = x(1);
                    kappa_r = x(2);
                    intlqp = x(3);
                    intlqn = x(4);
                    ml = fun;
                end
            end
            max_lkh.alpha_l = alpha_l;
            max_lkh.kappa_r = kappa_r;
            max_lkh.intlqp = intlqp;
            max_lkh.intlqn = intlqn;
            
        elseif tpcs == 2
            x_1 = rand(1,rn);
            x_2 = 20*rand(1,rn);
            x_3 = 20*rand(1,rn);
            x_4 = 20*rand(1,rn);
            x_5 = 20*rand(1,rn);
            x0 = [x_1(1) x_2(1) x_3(1) x_4(1) x_5(1)];
            if nolimit
                [x,fun] = fminsearch(f,x0);
            else
                lb = [0 0 0 0 0];
                ub = [1 Inf Inf Inf Inf];
                [x,fun] = fmincon(f,x0,[],[],[],[],lb,ub);
            end
            alpha_l = x(1);
            kappa_r = x(2);
            kappa_c = x(3);
            intlqp = x(4);
            intlqn = x(5);
            ml = fun;
            for n = 2:rn
                x0 = [x_1(n) x_2(n) x_3(n) x_4(n) x_5(n)];
                if nolimit
                    [x,fun] = fminsearch(f,x0);
                else
                    lb = [0 0 0 0 0];
                    ub = [1 Inf Inf Inf Inf];
                    [x,fun] = fmincon(f,x0,[],[],[],[],lb,ub);
                end
                if fun < ml
                    alpha_l = x(1);
                    kappa_r = x(2);
                    kappa_c = x(3);
                    intlqp = x(4);
                    intlqn = x(5);
                    ml = fun;
                end
            end
            max_lkh.alpha_l = alpha_l;
            max_lkh.kappa_r = kappa_r;
            max_lkh.kappa_c = kappa_c;
            max_lkh.intlqp = intlqp;
            max_lkh.intlqn = intlqn;
            
        elseif tpcs == 3
            x_1 = rand(1,rn);
            x_2 = 20*rand(1,rn);
            x_3 = 20*rand(1,rn);
            x_4 = 20*rand(1,rn);
            x_5 = 20*rand(1,rn);
            x0 = [x_1(1) x_2(1) x_3(1) x_4(1) x_5(1)];
            if nolimit
                [x,fun] = fminsearch(f,x0);
            else
                lb = [0 0 0 0 0 0];
                ub = [1 Inf Inf Inf Inf Inf];
                [x,fun] = fmincon(f,x0,[],[],[],[],lb,ub);
            end
            alpha_l = x(1);
            kappa_r = x(2);
            lambda_e = x(3);
            intlqp = x(4);
            intlqn = x(5);
            ml = fun;
            for n = 2:rn
                x0 = [x_1(n) x_2(n) x_3(n) x_4(n) x_5(n)];
                % x(1): alpha_l, x(2): kappa_r, x(3): lambda_e, x(4): intlqp, x(5): intlqn
                if nolimit
                    [x,fun] = fminsearch(f,x0);
                else
                    lb = [0 0 0 0 0];
                    ub = [1 Inf Inf Inf Inf];
                    [x,fun] = fmincon(f,x0,[],[],[],[],lb,ub);
                end
                if fun < ml
                    alpha_l = x(1);
                    kappa_r = x(2);
                    lambda_e = x(3);
                    intlqp = x(4);
                    intlqn = x(5);
                    ml = fun;
                end
            end
            max_lkh.alpha_l = alpha_l;
            max_lkh.kappa_r = kappa_r;
            max_lkh.lambda_e = lambda_e;
            max_lkh.intlqp = intlqp;
            max_lkh.intlqn = intlqn;
        
        elseif tpcs == 4
            x_1 = rand(1,rn);
            x_2 = rand(1,rn);
            x_3 = 20*rand(1,rn);
            x_4 = 20*rand(1,rn);
            x_5 = 20*rand(1,rn);
            x0 = [x_1(1) x_2(1) x_3(1) x_4(1) x_5(1)];
            if nolimit
                [x,fun] = fminsearch(f,x0);
            else
                lb = [0 0 0 0 0];
                ub = [1 1 Inf Inf Inf];
                [x,fun] = fmincon(f,x0,[],[],[],[],lb,ub);
            end
            alpha_l = x(1);
            alpha_f = x(2);
            kappa_r = x(3);
            intlqp = x(4);
            intlqn = x(5);
            ml = fun;
            for n = 2:rn
                x0 = [x_1(n) x_2(n) x_3(n) x_4(n) x_5(n)];
                if nolimit
                    [x,fun] = fminsearch(f,x0);
                else
                    lb = [0 0 0 0 0];
                    ub = [1 1 Inf Inf Inf];
                    [x,fun] = fmincon(f,x0,[],[],[],[],lb,ub);
                end
                if fun < ml
                    alpha_l = x(1);
                    alpha_f = x(2);
                    kappa_r = x(3);
                    intlqp = x(4);
                    intlqn = x(5);
                    ml = fun;
                end
            end
            max_lkh.alpha_l = alpha_l;
            max_lkh.alpha_f = alpha_f;
            max_lkh.kappa_r = kappa_r;
            max_lkh.intlqp = intlqp;
            max_lkh.intlqn = intlqn;
    
        elseif tpcs == 5
            x_1 = rand(1,rn);
            x_2 = rand(1,rn);
            x_3 = 20*rand(1,rn);
            x_4 = 20*rand(1,rn);
            x_5 = 20*rand(1,rn);
            x_6 = 20*rand(1,rn);
            x0 = [x_1(1) x_2(1) x_3(1) x_4(1) x_5(1) x_6(1)];
            if nolimit
                [x,fun] = fminsearch(f,x0);
            else
                lb = [0 0 0 0 0 0];
                ub = [1 1 Inf Inf Inf Inf];
                [x,fun] = fmincon(f,x0,[],[],[],[],lb,ub);
            end
            alpha_l = x(1);
            alpha_f = x(2);
            kappa_r = x(3);
            kappa_c = x(4);
            intlqp = x(5);
            intlqn = x(6);
            ml = fun;
            for n = 2:rn
                x0 = [x_1(n) x_2(n) x_3(n) x_4(n) x_5(n) x_6(n)];
                if nolimit
                    [x,fun] = fminsearch(f,x0);
                else
                    lb = [0 0 0 0 0 0];
                    ub = [1 1 Inf Inf Inf Inf];
                    [x,fun] = fmincon(f,x0,[],[],[],[],lb,ub);
                end
                if fun < ml
                    alpha_l = x(1);
                    alpha_f = x(2);
                    kappa_r = x(3);
                    kappa_c = x(4);
                    intlqp = x(5);
                    intlqn = x(6);
                    ml = fun;
                end
            end
            max_lkh.alpha_l = alpha_l;
            max_lkh.alpha_f = alpha_f;
            max_lkh.kappa_r = kappa_r;
            max_lkh.kappa_c = kappa_c;
            max_lkh.intlqp = intlqp;
            max_lkh.intlqn = intlqn;
            
        elseif tpcs == 6
            x_1 = rand(1,rn);
            x_2 = rand(1,rn);
            x_3 = 20*rand(1,rn);
            x_4 = 20*rand(1,rn);
            x_5 = 20*rand(1,rn);
            x_6 = 20*rand(1,rn);
            x0 = [x_1(1) x_2(1) x_3(1) x_4(1) x_5(1) x_6(1)];
            if nolimit
                [x,fun] = fminsearch(f,x0);
            else
                lb = [0 0 0 0 0 0];
                ub = [1 1 Inf Inf Inf Inf];
                [x,fun] = fmincon(f,x0,[],[],[],[],lb,ub);
            end
            alpha_l = x(1);
            alpha_f = x(2);
            kappa_r = x(3);
            lambda_e = x(4);
            intlqp = x(5);
            intlqn = x(6);
            ml = fun;
            for n = 2:rn
                x0 = [x_1(n) x_2(n) x_3(n) x_4(n) x_5(n) x_6(n)];
                if nolimit
                    [x,fun] = fminsearch(f,x0);
                else
                    lb = [0 0 0 0 0];
                    ub = [1 1 Inf Inf Inf Inf];
                    [x,fun] = fmincon(f,x0,[],[],[],[],lb,ub);
                end
                if fun < ml
                    alpha_l = x(1);
                    alpha_f = x(2);
                    kappa_r = x(3);
                    lambda_e = x(4);
                    intlqp = x(5);
                    intlqn = x(6);
                    ml = fun;
                end
            end
            max_lkh.alpha_l = alpha_l;
            max_lkh.alpha_f = alpha_f;
            max_lkh.kappa_r = kappa_r;
            max_lkh.lambda_e = lambda_e;
            max_lkh.intlqp = intlqp;
            max_lkh.intlqn = intlqn;
        
        elseif tpcs == 7
            x_1 = rand(1,rn);
            x_2 = rand(1,rn);
            x_3 = 20*rand(1,rn);
            x_4 = 20*rand(1,rn);
            x_5 = 20*rand(1,rn);
            x_6 = 20*rand(1,rn);
            x_7 = 20*rand(1,rn);
            
            x0 = [x_1(1) x_2(1) x_3(1) x_4(1) x_5(1) x_6(1) x_7(1)];
            if nolimit
                [x,fun] = fminsearch(f,x0);
            else
                lb = [0 0 0 0 0 0 0];
                ub = [1 1 Inf Inf Inf Inf Inf Inf];
                [x,fun] = fmincon(f,x0,[],[],[],[],lb,ub);
            end
            alpha_l = x(1);
            alpha_f = x(2);
            kappa_r = x(3);
            kappa_c = x(4);
            lambda_e = x(5);
            intlqp = x(6);
            intlqn = x(7);
            ml = fun;
            for n = 2:rn
                x0 = [x_1(n) x_2(n) x_3(n) x_4(n) x_5(n) x_6(n) x_7(n)];
                if nolimit
                    [x,fun] = fminsearch(f,x0);
                else
                    lb = [0 0 0 0 0 0 0];
                    ub = [1 1 Inf Inf Inf Inf Inf];
                    [x,fun] = fmincon(f,x0,[],[],[],[],lb,ub);
                end
                if fun < ml
                    alpha_l = x(1);
                    alpha_f = x(2);
                    kappa_r = x(3);
                    kappa_c = x(4);
                    lambda_e = x(5);
                    intlqp = x(6);
                    intlqn = x(7);
                    ml = fun;
                end
            end
            max_lkh.alpha_l = alpha_l;
            max_lkh.alpha_f = alpha_f;
            max_lkh.kappa_r = kappa_r;
            max_lkh.kappa_c = kappa_c;
            max_lkh.lambda_e = lambda_e;
            max_lkh.intlqp = intlqp;
            max_lkh.intlqn = intlqn;
            
        end
        max_lkh.trials = length(history.success);
        max_lkh.log_likelihood = ml;
        
        ML_Q{l,1+i} = max_lkh;
    end
end
