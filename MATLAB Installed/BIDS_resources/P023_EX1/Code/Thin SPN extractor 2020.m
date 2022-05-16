clear all

%DIRECTORY
folder1 = '/Users/alexismakin/Desktop/Alexis Work/Symmetry EEG/SPN effect size and power/Project Folders V8/Project 23';
folder2 = '/Users/alexismakin/Desktop/Alexis Work/Symmetry EEG/SPN effect size and power/Project Folders V8/Project 23/Grand Averages';
cd(folder1)
%SUBJECTS
subjects = 22;
skip  =[];


% CONDITIONS
conditionNames={'AntiSymmBW','SymmBW','RandBW','AntiSymmCol','SymmCol','RandCol'};
%TIME WINDOWS
low = 300;
high = 1000; % this simplifies the redundant bit about multiple time points
load timeVector
ii = find(timeVector >=low & timeVector <=high);

% ELECTRODES
electrodes = [25 62]; % Left and right
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
d = input('which dogma?')
% %Dogma 1
if d ==1;
    display 'dogma 1'
    electrodes = [25 27 62 64]; % put the electrodes here
end
if d ==2;
    % %Dogma 2
    display 'dogma 2'

    electrodes = [25 62]; % put the electrodes here
end
% %

if d == 3;
% % %Dogma 3
    display 'dogma 3'
    electrodes = [20 21 22 23 24 25 26 27 57 58 59 60 61 62 63 64]; % put the electrodes here
end


if d == 4;
    %Dogmatic left
    display 'dogmatic left'
    electrodes = [25 27]; % put the electrodes here
end

if d == 5;
    %Dogmatic right
    display 'dogmatic right'
    electrodes = [62 64]; % put the electrodes here
end
%%%%%%%%%%%%%%%%%%%%
% LOOP

for c = 1:length(conditionNames)
    p = 0;
    for i = 1:subjects;
        if ismember(i,skip)
            continue
        end
        p = p+1;
        k = num2str(i); % thisi is a hack to deal with the different experiments
        n = ['S',k,conditionNames{c},'AVG.mat'];
        load(n);
        Results(p,c) = mean(mean(condAVG(electrodes,ii)));
    end
end


%CONDITIONS%
%conditionNames={'AntiSymmBW','SymmBW','RandBW','AntiSymmCol','SymmCol','RandCol'};
SPNcond= {[1 3], [2 3], [4 6], [5 6]};
AttendReg = 0;
condW = [0.5 0.5 0.5 0.5];
Project = 23;
Group = 53;
condNos = [1 2 3 4];
SPNIDs =[151 152 153 154];
firstSubjectNo = 1363;
lmer = 0;
for c = 1:length(SPNcond)
    
    for i = 1:length(Results);
        lmer=lmer+1;
        
        SPNRegular = Results(i,SPNcond{c}(1)) - Results(i,SPNcond{c}(2));   
        
        

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


