clear 

list = dir(['..', filesep, 'param', filesep, 'optimized', filesep, 'airpuffSFP*.mat']);
ML_Q = load(['..', filesep, 'param', filesep, 'original',filesep, 'airpuffSFP.mat']);
originalvalues = []; 
for i = 1:5
    df = ML_Q.ML_Q{i, 2};
    originalvalues = [originalvalues df.alpha_l, df.alpha_f, df.kappa_r, df.kappa_c, df.lambda_e];
end

fignames = ['E' 'F'];
minRMSE = [];
minkappar = [];
minQ = [];
for x = 1:length(list)
    mus = load(append(list(x).folder,'/',list(x).name));
    mus_all= mus.all_rs;
    musQ = mus.all_Q;
    muscimol_rcnldf = mus_all;
    minsum = [];
    originalsum = [];
    minvalues = [];
    originvalues = [];
    musoptimized_Q = [];
    for iParam = 1:5
        minsum_permouse=[];
        minq_permouse=[];
        minvalue_permouse=[];
        originalvalue_permouse=[];
        mouse = 1;
        for iMouse = iParam:5:25;
            tone = muscimol_rcnldf(iMouse,:)- muscimol_rcnldf(iMouse,201);
            originalvalue = originalvalues(iMouse);
            if iParam < 3
                minvalue = ceil(originalvalue/0.01);
                maxvalue = ceil((1-originalvalue)/0.01);
                tone = tone(201-minvalue:201+maxvalue);
                minvalue_permouse=[minvalue_permouse 0.01*(find(tone==min(tone)))];
            else
                minvalue = ceil(originalvalue/0.1);
                maxvalue = fix((20-originalvalue)/0.1);
                tone = tone(201-minvalue:201+maxvalue);
                minvalue_permouse=[minvalue_permouse, 0.1*(find(tone==min(tone)))];
            end
            minsum_permouse=[minsum_permouse min(tone)];  
            q = musQ((mouse-1)*5+iParam,(200-minvalue)*8+1:(201+maxvalue)*8);
            minq = q((find(tone==min(tone))-1)*8+5:(find(tone==min(tone))-1)*8+8);
            minq_permouse = [minq_permouse; minq];
            mouse = mouse + 1;
        end
        minsum = [minsum ; minsum_permouse];
        minvalues = [minvalues; minvalue_permouse];
        musoptimized_Q = [musoptimized_Q; minq_permouse];
    end
    f1 = figure('Position', [100 100 500 400], 'Name',strcat('Figure 6',fignames(x)));
    t=tiledlayout(1,1);
    for i = 1:height(minsum)
        plot(1:5, minsum(:,i), 'k')
        hold on 
    end
    ylim([-0.5,0])
    ylabel('△RMSE')
    xlim([1,5])
    xticks([1,2,3,4,5])
    xticklabels({'αl' 'αf' 'κr' 'κp' 'ψ'})
    t = gcf;
    %export_figure_as_epsc_VectorFile(char(append('/Users/monaminishio/Documents/MATLAB/modules/Fig6_optimization/result/', erase(list(x).name, '.'),string(x),'_a')))  
    hold off
    minRMSE = [minRMSE; min(minsum)];
    minkappar = [minkappar; minvalues(3,:)];
    for i = 1:5
        minQ = [minQ; musoptimized_Q(i+5*(find(minsum(:,i)==min(minsum(:,i)))-1),:)];
    end
end

f2 = figure('Position', [100 100 200 400], 'Name', 'Figure 6G');
[~,p] = ttest(minRMSE(1,:),minRMSE(2,:));
disp(p)
for i = 1:width(minRMSE)
    plot(1:2, [minRMSE(1,i),minRMSE(2,i)], 'k')
    hold on 
end
ylim([-0.5,0])
xticks([1,2])
ylabel('△RMSE')
xlim([0,3])
xticks([1,2])
xticklabels({'ACSF' 'Muscimol'})
t = gcf;
%export_figure_as_epsc_VectorFile(char(append('/Users/monaminishio/Documents/MATLAB/modules/Fig6_optimization/result/', erase(list(x).name, '.'),string(x),'_paramcomparison')))   
hold off

f3 = figure('Position', [100 100 200 400], 'Name', 'Figure 6H');
[~,p] = ttest(minkappar(1,:),minkappar(2,:));
disp(p)
for i = 1:width(minkappar)
    plot(1:2, [minkappar(1,i),minkappar(2,i)], 'k')
    hold on 
end
ylim([0,20])
xticks([1,2])
ylabel('κr')
xlim([0,3])
xticks([1,2])
xticklabels({'ACSF' 'Muscimol'})
t = gcf;
%export_figure_as_epsc_VectorFile(char(append('/Users/monaminishio/Documents/MATLAB/modules/Fig6_optimization/result/', erase(list(x).name, '.'),string(x),'_paramcomparison')))   
hold off

f4 = figure('Position', [100 100 200 400], 'Name', 'Figure 6I QA,pull');
[~,p] = ttest(minQ(1:5,1),minQ(6:10,1));
disp(p)
for i = 1:5
    plot(1:2, [minQ(i,1),minQ(i+5,1)], 'k')
    hold on 
end
ylim([0,20])
xticks([1,2])
ylabel('QA,pull')
xlim([0,3])
xticks([1,2])
xticklabels({'ACSF' 'Muscimol'})
t = gcf;
%export_figure_as_epsc_VectorFile(char(append('/Users/monaminishio/Documents/MATLAB/modules/Fig6_optimization/result/', erase(list(x).name, '.'),string(x),'_paramcomparison')))   
hold off

f5 = figure('Position', [100 100 200 400], 'Name', 'Figure 6I QA,non-pull');
[~,p] = ttest(minQ(1:5,3),minQ(6:10,3));
disp(p)
for i = 1:5
    plot(1:2, [minQ(i,3),minQ(i+5,3)], 'k')
    hold on 
end
ylim([0,20])
xticks([1,2])
ylabel('QA,non-pull')
xlim([0,3])
xticks([1,2])
xticklabels({'ACSF' 'Muscimol'})
t = gcf;
%export_figure_as_epsc_VectorFile(char(append('/Users/monaminishio/Documents/MATLAB/modules/Fig6_optimization/result/', erase(list(x).name, '.'),string(x),'_paramcomparison')))   
hold off

f6 = figure('Position', [100 100 200 400], 'Name', 'Figure 6I QB,pull');
[~,p] = ttest(minQ(1:5,2),minQ(6:10,2));
disp(p)
for i = 1:5
    plot(1:2, [minQ(i,2),minQ(i+5,2)], 'k')
    hold on 
end
ylim([0,20])
xticks([1,2])
ylabel('QB,pull')
xlim([0,3])
xticks([1,2])
xticklabels({'ACSF' 'Muscimol'})
t = gcf;
%export_figure_as_epsc_VectorFile(char(append('/Users/monaminishio/Documents/MATLAB/modules/Fig6_optimization/result/', erase(list(x).name, '.'),string(x),'_paramcomparison')))   
hold off

f7 = figure('Position', [100 100 200 400], 'Name', 'Figure 6I QB,non-pull');
[~,p] = ttest(minQ(1:5,4),minQ(6:10,4));
disp(p)
for i = 1:5
    plot(1:2, [minQ(i,4),minQ(i+5,4)], 'k')
    hold on 
end
ylim([0,20])
xticks([1,2])
ylabel('QB,non-pull')
xlim([0,3])
xticks([1,2])
xticklabels({'ACSF' 'Muscimol'})
t = gcf;
%export_figure_as_epsc_VectorFile(char(append('/Users/monaminishio/Documents/MATLAB/modules/Fig6_optimization/result/', erase(list(x).name, '.'),string(x),'_paramcomparison')))   
hold off



