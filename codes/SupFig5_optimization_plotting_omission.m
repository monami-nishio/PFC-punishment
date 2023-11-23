clear 

list = dir('/Users/monaminishio/Documents/MATLAB/PFC-punishment/param/optimized/omissionSF*.mat');
ML_Q = load('/Users/monaminishio/Documents/MATLAB/PFC-punishment/param/original/omissionSF.mat');
originalvalues = []; 
for i = 1:7
    df = ML_Q.ML_Q{i, 2};
    originalvalues = [originalvalues df.alpha_l, df.alpha_f, df.kappa_r, df.lambda_e];
end

fignames = ['E' 'F'];
minRMSE = [];
minkappar = [];
for x = 1:length(list)
    mus = load(append(list(x).folder,'/',list(x).name));
    mus_all= mus.all_rs;
    muscimol_rcnldf = mus_all;
    minsum = [];
    originalsum = [];
    minvalues = [];
    originvalues = [];
    for iParam = 1:4
        minsum_permouse=[];
        minq_permouse=[];
        minvalue_permouse=[];
        originalvalue_permouse=[];
        mouse = 1;
        for iMouse = iParam:4:28;
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
        end
        minsum = [minsum ; minsum_permouse];
        minvalues = [minvalues; minvalue_permouse];
    end
    f1 = figure('Position', [100 100 500 400], 'Name',strcat('Supplementary Figure5',fignames(x)));
    t=tiledlayout(1,1);
    for i = 1:height(minsum)
        plot(1:4, minsum(:,i))
        hold on 
    end
    ylim([-0.5,0])
    ylabel('△RMSE')
    xlim([1,4])
    xticks([1,2,3,4])
    xticklabels({'αl' 'αf' 'κr' 'ψ'})
    t = gcf;
    %export_figure_as_epsc_VectorFile(char(append('/Users/monaminishio/Documents/MATLAB/modules/Fig6_optimization/result/', erase(list(x).name, '.'),string(x),'_a')))  
    hold off
    minRMSE = [minRMSE; min(minsum)];
    minkappar = [minkappar; minvalues(3,:)];
end

f2 = figure('Position', [100 100 200 400], 'Name', 'Figure 6G');
[~,p] = ttest(minRMSE(1,:),minRMSE(2,:));
disp(p)
for i = 1:width(minRMSE)
    plot(1:2, [minRMSE(1,i),minRMSE(2,i)])
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

