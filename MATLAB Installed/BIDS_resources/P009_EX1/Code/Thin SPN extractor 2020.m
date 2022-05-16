clear
% DIRECTORY (THIS WILL NEED TO BE CHANGED TO A DIRECTORY ON YOUR COMPUTER
folder1='/Users/alexismakin/Desktop/Alexis Work/Symmetry EEG/SPN effect size and power/Project Folders V8/Project 9/EX1 Original';
folder2='/Users/alexismakin/Desktop/Alexis Work/Symmetry EEG/SPN effect size and power/Project Folders V8/Project 9/EX1 Original/Grand Averages';
cd(folder1);

cd(folder1);

% SUBJECTS
subjects = 24;
skip = [];

% CONDITIONS
conditionNames={'REFRAND','RANDREF'};
%conditionNames={'REFRANDDARK','RANDREFDDARK','REFRANDLIGHT','RANDREFLIGHT'};

% TIME WINDOWS
lowEarly = 200
highEarly = 600


lowLate = 600
highLate = 1000
load timeVector;
iiE = find(timeVector >=lowEarly & timeVector <=highEarly);
iiL = find(timeVector >=lowLate & timeVector <=highLate);
%ELECTRODES
leftelectrodes = [20 21 22 23 25 26]; % These will be used if no dogma selected
rightelectrodes = [57 58 59 60 62 63]; % These will be used if no dogma selected

d = input('which dogma?')

if d ==1;
    display 'dogma 1'
    leftelectrodes = [25 27];
    rightelectrodes =[62 64]; 
end

if d ==2;
    display 'dogma 2'
    leftelectrodes = [25];
    rightelectrodes =[62]; 
end

if d == 3;
    display 'dogma 3'
    leftelectrodes = [20 21 22 23 24 25 26 27];
    rightelectrodes = [57 58 59 60 61 62 63 64]; 
end

if d < 1|d> 5;
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
        ResultsEarly(p,c) = mean(mean(condAVG(leftelectrodes,iiE)));
        ResultsEarly(p,c+length(conditionNames)) = mean(mean(condAVG(rightelectrodes,iiE)));
        ResultsLate(p,c) = mean(mean(condAVG(leftelectrodes,iiL)));
        ResultsLate(p,c+length(conditionNames)) = mean(mean(condAVG(rightelectrodes,iiL)));
    end
end

Results = (ResultsEarly+ResultsLate)/2

%CONDITIONS
%conditionNames={'REFRAND','RANDREF'};

SPNcond= {[2 1],[3 4]};
AttendReg = 0;
condW = [0.75 0.75];
Project = 9;
Group = 20;
condNos = [1 2];
SPNIDs =[50 51];
firstSubjectNo = 420;
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


