
addpath(['..', filesep, 'scripts'])
addpath(['..', filesep, 'scripts', filesep,'SupFig1_fitting'])

airpuff = load(['..', filesep, 'param', filesep , 'original', filesep , 'airpuffRCNLDF.mat']);
omission = load(['..', filesep, 'param', filesep , 'original', filesep , 'omissionRNLDF.mat']);
sz=100;

f1 = figure;
airpuffalpha_l = [];
for i =1:5
   airpuff_params = airpuff.ML_Q{i,2};
   scatter(1, [airpuff_params.alpha_l],sz, 'filled', 'MarkerFaceColor',[.5 .5 .5]) 
   hold on
   airpuffalpha_l = [airpuffalpha_l, airpuff_params.alpha_l];
end
scatter(1, [nanmean(airpuffalpha_l)], 500,'_', 'K')
omissionalpha_l = [];
for i =1:7
   omission_params = omission.ML_Q{i,2};
   scatter(2, [omission_params.alpha_l],sz, 'filled', 'MarkerFaceColor',[.5 .5 .5]) 
   omissionalpha_l = [omissionalpha_l, omission_params.alpha_l];
end
scatter(2, [nanmean(omissionalpha_l)], 500,'_', 'K')
ax = gca;
ax.XAxis.FontSize = 20;
ax.YAxis.FontSize = 20;
ylim([0,1])
xlim([0,3])
xticks([0 1 2 3])
xticklabels({'', 'Airpuff', 'Omission', ''})
ylabel({'αl'})
hold off

f2 = figure;
airpuffalpha_f= [];
for i =1:5
   airpuff_params = airpuff.ML_Q{i,2};
   scatter(1, [airpuff_params.alpha_f],sz, 'filled', 'MarkerFaceColor',[.5 .5 .5]) 
   hold on
   airpuffalpha_l = [airpuffalpha_l, airpuff_params.alpha_f];
end
scatter(1, [nanmean(airpuffalpha_l)], 500,'_', 'K')
omissionalpha_f = [];
for i =1:7
   omission_params = omission.ML_Q{i,2};
   scatter(2, [omission_params.alpha_f],sz, 'filled', 'MarkerFaceColor',[.5 .5 .5]) 
   omissionalpha_l = [omissionalpha_f, omission_params.alpha_f];
end
scatter(2, [nanmean(omissionalpha_f)], 500,'_', 'K')
ax = gca;
ax.XAxis.FontSize = 20;
ax.YAxis.FontSize = 20;
ylim([0,1])
xlim([0,3])
xticks([0 1 2 3])
xticklabels({'', 'Airpuff', 'Omission', ''})
ylabel({'αf'})
hold off

f3 = figure;
airpuffkappa_r= [];
for i =1:5
   airpuff_params = airpuff.ML_Q{i,2};
   scatter(1, [airpuff_params.kappa_r],sz, 'filled', 'MarkerFaceColor',[.5 .5 .5]) 
   hold on
   airpuffkappa_r = [airpuffkappa_r, airpuff_params.kappa_r];
end
scatter(1, [nanmean(airpuffkappa_r)], 500,'_', 'K')
omissionkappa_r = [];
for i =1:7
   omission_params = omission.ML_Q{i,2};
   scatter(2, [omission_params.kappa_r],sz, 'filled', 'MarkerFaceColor',[.5 .5 .5]) 
   omissionkappa_r = [omissionkappa_r, omission_params.kappa_r];
end
scatter(2, [nanmean(omissionkappa_r)], 500,'_', 'K')
ax = gca;
ax.XAxis.FontSize = 20;
ax.YAxis.FontSize = 20;
ylim([0,10])
xlim([0,3])
xticks([0 1 2 3])
xticklabels({'', 'Airpuff', 'Omission', ''})
ylabel({'κr'})
hold off

f4 = figure;
airpuffkappa_c= [];
for i =1:5
   airpuff_params = airpuff.ML_Q{i,2};
   scatter(1, [airpuff_params.kappa_c],sz, 'filled', 'MarkerFaceColor',[.5 .5 .5]) 
   hold on
   airpuffkappa_c = [airpuffkappa_c, airpuff_params.kappa_c];
end
scatter(1, [nanmean(airpuffkappa_c)], 500,'_', 'K')
ax = gca;
ax.XAxis.FontSize = 20;
ax.YAxis.FontSize = 20;
ylim([0,8])
xlim([0,2])
xticks([0 1 2])
xticklabels({'', 'Airpuff', ''})
ylabel({'κp'})
hold off

f5 = figure;
airpufflambda_e = [];
for i =1:5
   airpuff_params = airpuff.ML_Q{i,2};
   scatter(1, [airpuff_params.lambda_e],sz, 'filled', 'MarkerFaceColor',[.5 .5 .5]) 
   hold on
   airpufflambda_e = [airpufflambda_e, airpuff_params.lambda_e];
end
scatter(1, [nanmean(airpufflambda_e)], 500,'_', 'K')
omissionlambda_e = [];
for i =1:7
   omission_params = omission.ML_Q{i,2};
   scatter(2, [omission_params.lambda_e],sz, 'filled', 'MarkerFaceColor',[.5 .5 .5]) 
   omissionlambda_e = [omissionlambda_e, omission_params.lambda_e];
end
scatter(2, [nanmean(omissionlambda_e)], 500,'_', 'K')
ax = gca;
ax.XAxis.FontSize = 20;
ax.YAxis.FontSize = 20;
ylim([0,12])
xlim([0,3])
xticks([0 1 2 3])
xticklabels({'', 'Airpuff', 'Omission', ''})
ylabel({'ψ'})
hold off