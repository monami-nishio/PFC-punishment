function ML_Q=model_comparison_evaluate(types,grp,nametofit,param)

% nametofit = 'middle_180919_analyzed';
meta_history = [];
load(nametofit)
%wholeses = meta_history;
if grp(12)=='a'
    disp('airpuff')
    for i = 1:height(wholeses)
        wholeses{i,2}.punish = wholeses{i,2}.punish;
    end
elseif grp(12)=='o'
    disp('omission')
    for i = 1:height(wholeses)
        wholeses{i,2}.punish = wholeses{i,2}.success - wholeses{i,2}.reward;
    end
end

[pull, action] = mle_evaluate_copy_reward(types{1},param,wholeses, grp, 'a');

%end
end
