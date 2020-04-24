clear all; close all; clc;
%% select simulation
sim = 'demo';

%% select exp index [1-3]
% Exp 1: Sweep fraction of observed entries
% Exp 2: Sweep rank
% Exp 3: Sweep noise sigma
exp = 3;

%% select err index [1-6]... this only matters for Experiment.m, not demo.m
% [1-4] Method 1: Combined Nuclear & Infinity Norm 
%       * [1] norm(M-xhat,'fro');
%       * [2] norm(M-x1_debias,'fro');
%       * [3] sum(sign(xhat(:)) ~= sign(M(:)));
%       * [4] Hellinger Distance
% [5-8] Method 2: Nuclear Norm Only
%       * [5] norm(M-xhat,'fro');
%       * [6] norm(M-x1_debias,'fro');
%       * [7] sum(sign(xhat(:)) ~= sign(M(:)));
%       * [8] Hellinger Distance
y_axis = 5; 


%% Load Relevant Variables for Chosen Exp
switch exp
    case 1
        if sim == 'demo'
            load('6254_data/exp1_demo.mat')
        else
            load('6254_data/exp1.mat');
            err = exp1_err;
            obsErr = exp1_obsErr;
            normM = exp1_normM;
        end
        x = 0.05:0.05:0.95;
        figure; title('Recovery Error vs. Fraction of Observed Entries');
        xlabel('Fraction of Observed Entries')
    case 2
        if sim == 'demo'
            load('6254_data/exp2_demo.mat')
        else
            load('6254_data/exp2.mat');
            err = exp2_err;
            obsErr = exp2_obsErr;
            normM = exp2_normM;
        end
        x = 1:1:15;
        figure; title('Recovery Error vs. Rank');
        xlabel('Rank of X')
    case 3
        if sim == 'demo'
            load('6254_data/exp3_demo.mat')
        else
            load('6254_data/exp3.mat');
            err = exp3_err;
            obsErr = exp3_obsErr;
            normM = exp3_normM;
        end
        x = 0.1:0.1:1;
        figure; title('Recovery Error vs. Noise Floor (sigma)');
        xlabel('sigma')
end
hold on

%% Select ylabel Based on Error Metric Used
switch y_axis
    case 1
        ylabel('norm(M-xhat,''fro''); [Combined Nuclear & Infinity Norm]')
    case 2
        ylabel('norm(M-x1_debias,''fro''); [Combined Nuclear & Infinity Norm]')
    case 3
        ylabel('sum(sign(xhat(:)) ~= sign(M(:))); [Combined Nuclear & Infinity Norm]')
    case 4
        ylabel('Hellinger Distance [Combined Nuclear & Infinity Norm]')
    case 5
        ylabel('Relative Recovery Error')
    case 6
        ylabel('norm(M-x1_debias,''fro''); [Nuclear Norm Only]')
    case 7
        ylabel('sum(sign(xhat(:)) ~= sign(M(:))); [Nuclear Norm Only]')
    case 8
        ylabel('Hellinger Distance [Nuclear Norm Only]')
end

%% Select Relevant Data for Error Metric Chosen
I = length(err); % total length of parameter sweep
data = zeros(20,I);
if sim == 'demo'
    data = err;
else
    for i = 1:I
        param_data = err{i};                            % select all metrics for parameter value t in sweep
        data(:,i) = param_data(:,y_axis)./normM{i};     % select & normalize error metric y
        data = mean(data,1);                            % take average across all 20 trials for each param
    end
end




width=550;
height=400;
set(gcf,'position',[10,10,width,height])
plot(x,data)
legend('1BMC w/ Nuclear Norm only')
grid on
if sim == 'demo'
    filename = ['6254_plots/1BMC_exp',num2str(exp),'_err',num2str(y_axis),'_demo.png'];
else
    filename = ['6254_plots/1BMC_exp',num2str(exp),'_err',num2str(y_axis),'_exp.png'];
end
saveas(gcf,filename)


        
    