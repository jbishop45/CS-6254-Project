exp1_bool = 0;
exp2_bool = 0;
exp3_bool = 1;

experiment_bool = 0;
demo_bool = 1;

if experiment_bool
    %% Experiment 1: Sweep % Observed Entries
    if (exp1_bool)
        d = 100;
        r = 10;
        maxInner = 1000;
        sigmaVals = 0.3;
        trials = 20;

        exp1_err = cell(19,1);
        exp1_obsErr = cell(19,1);
        exp1_normM = cell(19,1);
        i = 1;

        for pct = 0.05:0.05:0.95
            result = Experiment(pct,d,r,maxInner, sigmaVals, trials);
            exp1_err{i} = result.err;
            exp1_obsErr{i} = result.obsErr;
            exp1_normM{i} = result.normM
            i = i+1;
        end
        save('6254_data/exp1.mat','exp1_err','exp1_obsErr','exp1_normM')
    end

    %% Experiment 2: Sweep Rank
    if (exp2_bool)
        pct = 0.5;
        d = 100;
        maxInner = 1000;
        sigmaVals = 0.3;
        trials = 20;

        exp2_err = cell(15,1);
        exp2_obsErr = cell(15,1);
        exp2_normM = cell(15,1);
        i = 1;

        for r = 1:1:15
            result = Experiment(pct,d,r,maxInner, sigmaVals, trials);
            exp2_err{i} = result.err;
            exp2_obsErr{i} = result.obsErr;
            exp2_normM{i} = result.normM
            i = i+1;
        end
        save('6254_data/exp2.mat','exp2_err','exp2_obsErr','exp2_normM')
    end

    %% Experiment 3: Sweep Noise Sigma
    if (exp3_bool)
        pct = 0.5;
        d = 100;
        r = 10;
        maxInner = 1000;
        trials = 20;

        exp3_err = cell(11,1);
        exp3_obsErr = cell(11,1);
        exp3_normM = cell(11,1);
        i = 1;

        for sigmaVals = 0:0.1:1
            result = Experiment(pct,d,r,maxInner, sigmaVals, trials);
            exp3_err{i} = result.err;
            exp3_obsErr{i} = result.obsErr;
            exp3_normM{i} = result.normM
            i = i+1;
        end
        save('6254_data/exp3.mat','exp3_err','exp3_obsErr','exp3_normM')
    end
end

trials = 20;
if demo_bool
   percent = 0.5;
   d = 100;
   rank = 10;
   maxInner = 1000;
   sigma = 0.3;
   trials = 20;
   if (exp1_bool)
       err = zeros(1,19);
       for t = 1:trials
           err_trial = [];
           for pct = 0.05:0.05:0.95
               err_new = demo(pct,d,rank,maxInner,sigma);
               err_trial = [err_trial,err_new];
           end
           err = err + err_trial/trials;
       end
       save('6254_data/exp1_demo.mat','err')
   end  
   if (exp2_bool)
       err = zeros(1,15);
       for t = 1:trials
           err_trial = [];
           for r = 1:1:15
               err_new = demo(percent,d,r,maxInner,sigma);
               err_trial = [err_trial,err_new];
           end
           err = err + err_trial/trials;
       end
       save('6254_data/exp2_demo.mat','err')
   end
   if (exp3_bool)
       err = zeros(1,10);
       for t = 1:trials
           err_trial = [];
           for s = 0.1:0.1:1
               err_new = demo(percent,d,rank,maxInner,s);
               err_trial = [err_trial,err_new];
           end
           err = err + err_trial/trials;
       end
       save('6254_data/exp3_demo.mat','err')
   end
end