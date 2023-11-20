addpath(['..', filesep, 'scripts'])
addpath(['..', filesep, 'scripts', filesep,'SupFig1_fitting'])

airpuff = load(['..', filesep, 'result', filesep , 'airpuffRCNLDF.mat']);
omission = load(['..', filesep, 'result', filesep , 'omissionRNLDF.mat']);
airpuff_original = load(['..', filesep, 'param', filesep ,'original', filesep , 'airpuffSFP.mat']);
omission_original = load(['..', filesep, 'param', filesep ,'original', filesep , 'omissionSF.mat']);
sz=100;

figure('Name','Omission inQpn')
for i =1:7
   for j=1:100
       omission_params = omission.ML_Q{i,1+j};
       scatter(i, [omission_params.intlqn],sz, 'filled', 'MarkerFaceColor',[.5 .5 .5]) 
       hold on
   end
   scatter(i, median([omission_params.intlqn]),500,"_",'MarkerEdgeColor',[.5 .5 .5])
   scatter(i, omission_original.ML_Q{i,2}.intlqn, 500,"_",'MarkerEdgeColor',[1 0 0]) 
   disp(median([omission_params.intlqn]))
end
ylim([0, 100])
f = gcf;
export_figure_as_epsc_VectorFile('Omission inQpn')
hold off

figure('Name','Airpuff inQp')
for i =1:5
   for j=1:100
       airpuff_params = airpuff.ML_Q{i,1+j};
       scatter(i, [airpuff_params.intlqp],sz, 'filled', 'MarkerFaceColor',[.5 .5 .5]) 
       hold on
   end
   scatter(i, median([airpuff_params.intlqp]),500,"_",'MarkerEdgeColor',[.5 .5 .5]) 
   scatter(i, airpuff_original.ML_Q{i,2}.intlqp, 500,"_",'MarkerEdgeColor',[1 0 0]) 
end
ylim([0, 100])
f = gcf;
export_figure_as_epsc_VectorFile('Airpuff inQp')
hold off

figure('Name','Airpuff inQpn')
for i =1:5
   for j=1:100
       airpuff_params = airpuff.ML_Q{i,1+j};
       scatter(i, [airpuff_params.intlqn],sz, 'filled', 'MarkerFaceColor',[.5 .5 .5]) 
       hold on
   end
   scatter(i, median([airpuff_params.intlqn]),500,"_",'MarkerEdgeColor',[.5 .5 .5]) 
   scatter(i, airpuff_original.ML_Q{i,2}.intlqn, 500,"_",'MarkerEdgeColor',[1 0 0]) 
end
ylim([0, 20])
f = gcf;
export_figure_as_epsc_VectorFile('Airpuff inQpn')
hold off

figure('Name','Omission inQp')
for i =1:7
   for j=1:100
       omission_params = omission.ML_Q{i,1+j};
       scatter(i, [omission_params.intlqp],sz, 'filled', 'MarkerFaceColor',[.5 .5 .5]) 
       hold on
   end
   scatter(i, median([omission_params.intlqp]),500,"_",'MarkerEdgeColor',[.5 .5 .5])
   scatter(i, omission_original.ML_Q{i,2}.intlqp, 500,"_",'MarkerEdgeColor',[1 0 0]) 
end
ylim([0, 100])
f = gcf;
export_figure_as_epsc_VectorFile('Omission inQp')
hold off

figure('Name','Omission κr')
for i =1:7
   for j=1:100
       omission_params = omission.ML_Q{i,1+j};
       scatter(i, [omission_params.kappa_r],sz, 'filled', 'MarkerFaceColor',[.5 .5 .5]) 
       hold on
   end
   scatter(i, median([omission_params.kappa_r]),500,"_",'MarkerEdgeColor',[.5 .5 .5]) 
   scatter(i, omission_original.ML_Q{i,2}.kappa_r, 500,"_",'MarkerEdgeColor',[1 0 0]) 
end
ylim([0, 10])
f = gcf;
export_figure_as_epsc_VectorFile('Omission κr')
hold off

figure('Name','Airpuff κr')
for i =1:5
   for j=1:100
       airpuff_params = airpuff.ML_Q{i,1+j};
       scatter(i, [airpuff_params.kappa_r],sz, 'filled', 'MarkerFaceColor',[.5 .5 .5]) 
       hold on
   end
   scatter(i, median([airpuff_params.kappa_r]),500,"_",'MarkerEdgeColor',[.5 .5 .5]) 
   scatter(i, airpuff_original.ML_Q{i,2}.kappa_r, 500,"_",'MarkerEdgeColor',[1 0 0]) 
end
f = gcf;
ylim([0, 10])
export_figure_as_epsc_VectorFile('Airpuff κr')
hold off


figure('Name','Airpuff αl')
for i =1:5
   for j=1:100
       airpuff_params = airpuff.ML_Q{i,1+j};
       scatter(i, [airpuff_params.alpha_l],sz, 'filled', 'MarkerFaceColor',[.5 .5 .5]) 
       hold on
   end
   scatter(i, median([airpuff_params.alpha_l]),500,"_",'MarkerEdgeColor',[.5 .5 .5]) 
   scatter(i, airpuff_original.ML_Q{i,2}.alpha_l, 500,"_",'MarkerEdgeColor',[1 0 0]) 
end
f = gcf;
ylim([0, 1])
export_figure_as_epsc_VectorFile('Airpuff αl')
hold off

figure('Name','Airpuff αf')
for i =1:5
   for j=1:100
       airpuff_params = airpuff.ML_Q{i,1+j};
       scatter(i, [airpuff_params.alpha_f],sz, 'filled', 'MarkerFaceColor',[.5 .5 .5]) 
       hold on
   end
   scatter(i, median([airpuff_params.alpha_f]),500,"_",'MarkerEdgeColor',[.5 .5 .5]) 
   scatter(i, airpuff_original.ML_Q{i,2}.alpha_f, 500,"_",'MarkerEdgeColor',[1 0 0]) 
end
f = gcf;
ylim([0, 1])
export_figure_as_epsc_VectorFile('Airpuff αf')
hold off

figure('Name','Airpuff κp')
for i =1:5
   for j=1:100
       airpuff_params = airpuff.ML_Q{i,1+j};
       scatter(i, [airpuff_params.kappa_c],sz, 'filled', 'MarkerFaceColor',[.5 .5 .5]) 
       hold on
   end
   scatter(i, median([airpuff_params.kappa_c]),500,"_",'MarkerEdgeColor',[.5 .5 .5]) 
   scatter(i, airpuff_original.ML_Q{i,2}.kappa_c, 500,"_",'MarkerEdgeColor',[1 0 0]) 
end
f = gcf;
export_figure_as_epsc_VectorFile('Airpuff κp')
hold off

figure('Name','Airpuff ψ')
for i =1:5
   for j=1:100
       airpuff_params = airpuff.ML_Q{i,1+j};
       scatter(i, [airpuff_params.lambda_e],sz, 'filled', 'MarkerFaceColor',[.5 .5 .5]) 
       hold on
   end
   scatter(i, median([airpuff_params.lambda_e]),500,"_",'MarkerEdgeColor',[.5 .5 .5]) 
   scatter(i, airpuff_original.ML_Q{i,2}.lambda_e, 500,"_",'MarkerEdgeColor',[1 0 0]) 
end
ylim([0, 19])
f = gcf;
export_figure_as_epsc_VectorFile('Airpuff ψ')
hold off

figure('Name','Omission αl')
for i =1:7
   for j=1:100
       omission_params = omission.ML_Q{i,1+j};
       scatter(i, [omission_params.alpha_l],sz, 'filled', 'MarkerFaceColor',[.5 .5 .5]) 
       hold on
   end
   scatter(i, median([omission_params.alpha_l]),500,"_",'MarkerEdgeColor',[.5 .5 .5]) 
   scatter(i, omission_original.ML_Q{i,2}.alpha_l, 500,"_",'MarkerEdgeColor',[1 0 0]) 
end
f = gcf;
ylim([0, 1])
export_figure_as_epsc_VectorFile('Omission αl')
hold off

figure('Name','Omission αf')
for i =1:7
   for j=1:100
       omission_params = omission.ML_Q{i,1+j};
       scatter(i, [omission_params.alpha_f],sz, 'filled', 'MarkerFaceColor',[.5 .5 .5]) 
       hold on
   end
   scatter(i, median([omission_params.alpha_f]),500,"_",'MarkerEdgeColor',[.5 .5 .5]) 
   scatter(i, omission_original.ML_Q{i,2}.alpha_f, 500,"_",'MarkerEdgeColor',[1 0 0]) 
end
f = gcf;
ylim([0, 1])
export_figure_as_epsc_VectorFile('Omission αf')
hold off


figure('Name','Omission ψ')
for i =1:7
   for j=1:100
       omission_params = omission.ML_Q{i,1+j};
       scatter(i, [omission_params.lambda_e],sz, 'filled', 'MarkerFaceColor',[.5 .5 .5]) 
       hold on
   end
   scatter(i, median([omission_params.lambda_e]),500,"_",'MarkerEdgeColor',[.5 .5 .5])
   scatter(i, omission_original.ML_Q{i,2}.lambda_e, 500,"_",'MarkerEdgeColor',[1 0 0]) 
end
ylim([0, 19])
f = gcf;
export_figure_as_epsc_VectorFile('Omission ψ')
hold off