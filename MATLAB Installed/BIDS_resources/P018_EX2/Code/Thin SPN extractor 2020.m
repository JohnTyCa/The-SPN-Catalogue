clear
% DIRECTORY (THIS WILL NEED TO BE CHANGED TO A DIRECTORY ON YOUR COMPUTER
folder1 =  '/Users/alexismakin/Desktop/Alexis Work/Symmetry EEG/SPN effect size and power/Project Folders V8/Project 18/EX2 Left and Right With Eye Tracking';
folder2 = '/Users/alexismakin/Desktop/Alexis Work/Symmetry EEG/SPN effect size and power/Project Folders V8/Project 18/EX2 Left and Right With Eye Tracking/Grand Averages';

cd(folder1)

%SUBJECTS
subjects = 48;
skip = []

%HEMISPHERE
hemisphere = input('which hemisphere?')

% CONDITIONS
if strcmp(hemisphere, 'left') == 1;
    conditionNames={'RandRandRand','RANDREFS','REFrREFlREFr'};
end

if strcmp(hemisphere, 'right') == 1;
    conditionNames={'RandRandRand','REFRANDS','REFlREFrREFl'};
end


if strcmp(hemisphere, 'both') == 1;
    conditionNames={'RandRandRand','Consistent','Changing'};
end

%%% TIME WINDOWS
%timeWindows={[250,600],[950,1300],[1650,2000]}
timeWindows={[250,600]}
load timeVector


% ELECTRODES
if strcmp(hemisphere, 'both') == 1;
    electrodes = [25 27 62 64]; % BEST FROM TOPOPLOT (POST HOC) P3 P5 PO3 PO7 and P4 P6 PO4 PO8
end

if strcmp(hemisphere, 'left') == 1;
    electrodes = [21 22 25 26];
end

if strcmp(hemisphere, 'right') == 1;
    electrodes = [58 59 62 63]; % BEST FROM TOPOPLOT (POST HOC) P3 P5 PO3 PO7 and P4 P6 PO4 PO8
end


d = input('which dogma?')
if d ==1;
    display 'dogma 1'
    if strcmp(hemisphere, 'both') == 1;
        electrodes = [25 27 62 64];
    end
    
    if strcmp(hemisphere, 'left') == 1;
        electrodes = [25 27];
    end
    
    if strcmp(hemisphere, 'right') == 1;
        electrodes = [62 64]; 
    end
end

if d ==2;
    display 'dogma 2'
    
    if strcmp(hemisphere, 'both') == 1;
        electrodes = [25 62]; 
    end
    
    if strcmp(hemisphere, 'left') == 1;
        electrodes = [25]; 
    end
    
    if strcmp(hemisphere, 'right') == 1;
        electrodes = [62]; 
    end
end
% %

if d == 3;
    display 'dogma 3'
    if strcmp(hemisphere, 'both') == 1;
        electrodes = [20 21 22 23 24 25 26 27 57 58 59 60 61 62 63 64]; 
    end
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

% LOOP
ResultsAll = []
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
            n = ['S',k,conditionNames{c},'AVG.mat'];
            load(n);
            Results(p,c) = mean(mean(condAVG(electrodes,ii)));
        end
    end
    ResultsAll = [ResultsAll,Results];
    clear Results
end


%CONDITIONS%
SPNcond= {[2 1],[3 1]};
AttendReg = 0;
condW = [0.9375,0.9375];
Project = 18;
Group = 45;

if strcmp(hemisphere, 'left') == 1;
    condNos = [1 2];
    SPNIDs =[119 120];
    
end


if strcmp(hemisphere, 'right') == 1;
    condNos = [3 4];
    SPNIDs =[121 122];
   
end

firstSubjectNo = 1055;
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
