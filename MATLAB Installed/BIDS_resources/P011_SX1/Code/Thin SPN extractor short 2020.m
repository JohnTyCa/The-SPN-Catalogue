clear
% DIRECTORY (THIS WILL NEED TO BE CHANGED TO A DIRECTORY ON YOUR COMPUTER
folder1 = '/Users/alexismakin/Desktop/Alexis Work/Symmetry EEG/SPN effect size and power/Project Folders V8/Project 11/Sup Ex1'
folder2 = '/Users/alexismakin/Desktop/Alexis Work/Symmetry EEG/SPN effect size and power/Project Folders V8/Project 11/Sup Ex1/Grand Averages'
cd(folder1)

%SUBJECTS
subjects = 36;
skip = []

%CONDITIONS
conditionNames={'SymmetryShort','RandomShort'}


%TIME WINDOWS
low = 200;
high = 350; 

load timeVector
ii = find(timeVector >=low & timeVector <=high);

%ELECTRODES
electrodes = [25 62]; % These will be used if no dogma selected
d = input('which dogma?')

if d ==1;
    display 'dogma 1'
    electrodes = [25 27 62 64]; 
end

if d ==2;
    display 'dogma 2'
    electrodes = [25 62]; 
end

if d ==3;
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

if d < 1|d> 5;
    display('Original electrodes used');
end

% LOOP
for c = 1:length(conditionNames)
    p = 0;
    for i = 1:subjects;
        if ismember(i,skip)
            disp(['excluded' num2str(i)])
            continue
        end
        p = p+1;
        k = num2str(i); % thisi is a hack to deal with the different experiments
        n = ['S',k,conditionNames{c},'AVG.mat'];
        load(n);
        Results(p,c) = mean(mean(condAVG(electrodes,ii)));
    end
end

%CONDITIONS
%conditionNames={'SymmetryShort','RandomShort'};

SPNcond= {[1 2]};
AttendReg = 1;
condW = [0.75];
Project = 11;
Group = 30;
condNos = [1];
SPNIDs =[63];
firstSubjectNo = 671;
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

thinResultsShort = thinResults;

% SAVE AND RELOAD
cd(folder2);
save('thinSPNResultsShort','thinResultsShort');
clear all;
load 'thinSPNResultsShort';


