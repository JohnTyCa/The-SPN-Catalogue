clear
% DIRECTORY (THIS WILL NEED TO BE CHANGED TO A DIRECTORY ON YOUR COMPUTER
folder1 =  '/Users/alexismakin/Desktop/Alexis Work/Symmetry EEG/SPN effect size and power/Project Folders V8/Project 40/EX2 Crowding Matched';
folder2 = '/Users/alexismakin/Desktop/Alexis Work/Symmetry EEG/SPN effect size and power/Project Folders V8/Project 40/EX2 Crowding Matched/Grand Averages';
cd(folder1);
load timeVector;
%SUBJECTS
subjects = 24;
skip = [];

%CONDITIONS
conditionNames={'TargetSym','SymFlankerS','SymFlankerR'};
%Hemisphere 
hemisphere= input('which hemisphere?')


% CONDITIONS
if strcmp(hemisphere, 'left') == 1;
    conditionNames={'TargetSymRight','SymFlankerSRight','SymFlankerRRight','RandFlankerSRight'}; % this is for when symmetry goes to left brain
end

if strcmp(hemisphere, 'right') == 1;
    conditionNames={'TargetSymLeft','SymFlankerSLeft','SymFlankerRLeft','RandFlankerSLeft'}; %this is for when symmetry goes to right brain
end


% TIME WINDOWS
load timeVector
low = 100 
high = 200
iip = find(timeVector >=low & timeVector <=high);

low = 150 
high = 250
iin = find(timeVector >=low & timeVector <=high);


% ELECTRODES
if strcmp(hemisphere, 'left') == 1;
    electrodes = [23 25 26 27]; %P7 PO3 PO7 O1 left electrodes
end

if strcmp(hemisphere, 'right') == 1;
    electrodes = [60 62 63 64]; %P8 PO4 PO8 O2 right electrodes
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
    p = 0;
    for i = 1:subjects;
        if ismember(i,skip)
            disp(['excluded' num2str(i)])
            continue
        end
        p = p+1;
        k = num2str(i);
        n = ['S',k,conditionNames{c},'AVG.mat'];
        load(n);
        
        a = mean(condAVG(electrodes,iip));
        PositivePeakResults(p,c) = max(a);
        
        b = mean(condAVG(electrodes,iin));
        NegativePeakResults(p,c) = min(b);
        
    end
end


AttendReg = 1;
condW = [0.75 0.75 0.25 0.5];
Project = 40;
Group = 83;

if strcmp(hemisphere, 'left') == 1;
    SPNIDs =[234 235 236 237];
    condNos = [1 2 3 4];
end

%right
if strcmp(hemisphere, 'right') == 1;
    SPNIDs =[238 239 240 241];
    condNos = [5 6 7 8];
end


firstSubjectNo = 2168;
lmer = 0;
for c = 1:length(conditionNames)
    
    for i = 1:length(PositivePeakResults);
        lmer=lmer+1;
        
        P = PositivePeakResults(i,c);   
        N = NegativePeakResults(i,c); 
        

        thinResults(lmer,1) = SPNIDs(c);
        thinResults(lmer,2) = Project;
        thinResults(lmer,3) = condNos(c);
        thinResults(lmer,4) = Group;
        thinResults(lmer,5) = i+firstSubjectNo-1;
        thinResults(lmer,6) = AttendReg;
        thinResults(lmer,7) = condW(c);
        thinResults(lmer,8) = P;
        thinResults(lmer,9) = N;
    end
end



% SAVE AND RELOAD

if strcmp(hemisphere, 'left') == 1;
    thinPeakExtremeResultsLeft = thinResults;
    cd(folder2)
    save('thinPeakExtremeResultsLeft','thinPeakExtremeResultsLeft')
    
end

if strcmp(hemisphere, 'right') == 1;
    thinPeakExtremeResultsRight = thinResults;
    cd(folder2)
    save('thinPeakExtremeResultsRight','thinPeakExtremeResultsRight')
end

clear
load thinPeakExtremeResultsLeft
load thinPeakExtremeResultsRight

thinResults = [thinPeakExtremeResultsLeft;thinPeakExtremeResultsRight];
save('thinPeakExtremeResults','thinResults');
clear



