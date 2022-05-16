clear
% DIRECTORY (THIS WILL NEED TO BE CHANGED TO A DIRECTORY ON YOUR COMPUTER
folder1 =  '/Users/alexismakin/Desktop/Alexis Work/Symmetry EEG/SPN effect size and power/Project Folders V8/Project 40/EX1 Crowding HV';
folder2 = '/Users/alexismakin/Desktop/Alexis Work/Symmetry EEG/SPN effect size and power/Project Folders V8/Project 40/EX1 Crowding HV/Grand Averages';
cd(folder1);
load timeVector;
%SUBJECTS
subjects = 34;
skip = [];

%CONDITIONS
conditionNames={'TargetSym','TargetRand','SymFlankerV','RandFlankerV','SymFlankerH','RandFlankerH'};
%Hemisphere 
hemisphere= input('which hemisphere?')


% CONDITIONS
if strcmp(hemisphere, 'left') == 1;
    conditionNames={'TargetSymR','TargetRandR','SymFlankerVR','RandFlankerVR','SymFlankerHR','RandFlankerHR'}; % this is for when symmetry goes to left brain
end

if strcmp(hemisphere, 'right') == 1;
    conditionNames={'TargetSymL','TargetRandL','SymFlankerVL','RandFlankerVL','SymFlankerHL','RandFlankerHL'}; %this is for when symmetry goes to right brain
end



%%% TIME WINDOWS
low = 200;
high = 600;

ii = find(timeVector >=low & timeVector <=high);

% ELECTRODES
if strcmp(hemisphere, 'left') == 1;
        %electrodes = [20 21 22 23 25 26];
    electrodes = [23 24 25 27];

end

if strcmp(hemisphere, 'right') == 1;
       %electrodes = [57 58 59 60 62 63]; 
    electrodes = [60 61 62 64]; 
end

d = input('which dogma?')
if d ==1;
    display 'dogma 1'
    if strcmp(hemisphere, 'left') == 1;
        electrodes = [25 27]; 
    end
    
    if strcmp(hemisphere, 'right') == 1;
        electrodes = [62 64]; 
    end
end

if d ==2;
    display 'dogma 2'

    if strcmp(hemisphere, 'left') == 1;
        electrodes = [25]; 
    end
    if strcmp(hemisphere, 'right') == 1;
        electrodes = [62]; 
    end
end

if d == 3;
    display 'dogma 3'
    if strcmp(hemisphere, 'left') == 1;
        electrodes = [20 21 22 23 24 25 26 27];
    end
    if strcmp(hemisphere, 'right') == 1;
        electrodes = [57 58 59 60 61 62 63 64];
    end
end


if d < 1|d> 3;
    display('Original electrodes used');
end

%LOOP
for c = 1:length(conditionNames)
    p=0;
    for i = 1:subjects;
        if ismember(i,skip)
            continue
        end
        p = p+1;
        k = num2str(i); 
        n = ['S',k,conditionNames{c},'AVG.mat'];
        load(n);
        Results(p,c) = mean(mean(condAVG(electrodes,ii)));
       
    end
end



%CONDITIONS%
%conditionNames={'TargetSym','TargetRand','SymFlankerV','RandFlankerV','SymFlankerH','RandFlankerH'};
SPNcond= {[1 2],[3 4],[5 6]};
AttendReg = 1;
condW = [0.75 0.25 0.25];
Project = 40;
Group = 82;

if strcmp(hemisphere, 'left') == 1;
    SPNIDs =[228 229 230];
    condNos = [1 2 3];
end

%right
if strcmp(hemisphere, 'right') == 1;
    SPNIDs =[231 232 233];
    condNos = [4 5 6];
end
firstSubjectNo = 2134;
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
if strcmp(hemisphere, 'left') == 1;
    thinResultsLeft=thinResults;
    cd(folder2);
    save('thinResultsLeft','thinResultsLeft');
end

if strcmp(hemisphere, 'right') == 1;
    thinResultsRight=thinResults;
    cd(folder2);
    save('thinResultsRight','thinResultsRight');
end

clear all

