clear
% DIRECTORY (THIS WILL NEED TO BE CHANGED TO A DIRECTORY ON YOUR COMPUTER)
folder1 ='/Users/alexismakin/Desktop/Alexis Work/Symmetry EEG/SPN effect size and power/Project Folders V8/Project 39';
folder2 ='/Users/alexismakin/Desktop/Alexis Work/Symmetry EEG/SPN effect size and power/Project Folders V8/Project 39/Grand Averages1000';
cd(folder1);

%SUBJECTS
subjects = 40;
skip = [1 3 9 14 17 19 20 21 24 25 26 29 31 32 34 37]; 


% CONDITIONS
conditionNames={'RandRandRand', 'RefRefRef'};

%%% TIME WINDOWS
%timeWindows={[250,1100,[1450,2300],[2650,3500]}
timeWindows={[250,1100]}

load timeVector1000



% ELECTRODES
electrodes = [25 27 62 64];
d = input('which dogma?')

if d ==1;
    display 'dogma 1'
    electrodes = [25 27 62 64]; 
end
if d ==2;
    display 'dogma 2'
    electrodes = [25 62]; 
end
% %

if d == 3;
    display 'dogma 3'
    electrodes = [20 21 22 23 24 25 26 27 57 58 59 60 61 62 63 64]; 
end

if d == 4;
    display 'dogmatic left'
    electrodes = [25 27]; 
end

if d == 5;
    display 'dogmatic right'
    electrodes = [62 64]; 
end

% LOOP
ResultsAll = [];
for tw = 1:length(timeWindows);
    low = timeWindows{tw}(1);
    high= timeWindows{tw}(2);
    ii = find(timeVector >=low & timeVector <=high);
    for c = 1:length(conditionNames)
        
        p = 0;
        for i = 1:subjects;
            if ismember(i,skip)
                continue
            end
            p = p+1;
            k = num2str(i); 
            n = ['S',k,conditionNames{c},'1000AVG.mat'];
            load(n);
            Results(p,c) = mean(mean(condAVG(electrodes,ii)));
        end
    end
    ResultsAll = [ResultsAll,Results];
    clear Results
end
%CONDITIONS
%conditionNames={'RandRandRand', 'RefRefRef'};
SPNcond= {[2 1]};
AttendReg = 0;
condW = [0.9375];
Project = 39;
Group = 81;
condNos = [1];
SPNIDs =[227];
firstSubjectNo = 2110;
lmer = 0;
for c = 1:length(SPNcond)
    
    for i = 1:length(ResultsAll);
        lmer=lmer+1;
        
        SPNRegular = ResultsAll(i,SPNcond{c}(1)) - ResultsAll(i,SPNcond{c}(2));   
        
        

        thinResults(lmer,1) = SPNIDs(c);
        thinResults(lmer,2) = Project;
        thinResults(lmer,3) = condNos(c);
        thinResults(lmer,4) = Group;
        thinResults(lmer,5) = i+firstSubjectNo-1;
        thinResults(lmer,6) = AttendReg;
        thinResults(lmer,7) = condW(c);
        thinResults(lmer,8) = SPNRegular;
    end
end



% SAVE AND RELOAD
cd(folder2);
save('thinSPNResults','thinResults');
clear all;
load 'thinSPNResults';


