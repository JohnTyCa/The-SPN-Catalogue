clear
% DIRECTORY (THIS WILL NEED TO BE CHANGED TO A DIRECTORY ON YOUR COMPUTER
folder1 = '/Users/alexismakin/Desktop/Alexis Work/Symmetry EEG/SPN effect size and power/Project Folders V8/Project 24';
folder2 = '/Users/alexismakin/Desktop/Alexis Work/Symmetry EEG/SPN effect size and power/Project Folders V8/Project 24/Grand Averages';
cd(folder1);

%SUBJECTS
subjects = 48;
skip = []



%Hemisphere 
hemisphere= input('which hemisphere?')


% CONDITIONS
if strcmp(hemisphere, 'left') == 1;
    conditionNames={'LCRandRand','RCRandRand','LCRandSymm','RCRandSymm'}; % this is for when symmetry goes to left brain
end

if strcmp(hemisphere, 'right') == 1;
    conditionNames={'LCRandRand','RCRandRand','LCSymmRand','RCSymmRand'}; %this is for when symmetry goes to right brain
end

lowEarly = 250; 
highEarly = 350; 

lowLate = 500; 
highLate = 1000; 

%%% TIME WINDOWS
%timeWindows={[250,350],[500,1000]}
%timeWindows={[250,350]}
%timeWindows={[500,1000]}
load timeVector
iiE = find(timeVector >=lowEarly & timeVector <=highEarly);
iiL = find(timeVector >=lowLate & timeVector <=highLate);

% ELECTRODES
if strcmp(hemisphere, 'left') == 1;
    electrodes = [23 25 26 27]; % These will be used if no dogma selected
end

if strcmp(hemisphere, 'right') == 1;
    electrodes = [60 62 63 64]; % These will be used if no dogma selected
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
% 


% LOOP
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
        ResultsEarly(p,c) = mean(mean(condAVG(electrodes,iiE)));
        ResultsLate(p,c) = mean(mean(condAVG(electrodes,iiL)));
    end
end

Results = (ResultsEarly+ResultsLate)/2;


% % LOOP
% ResultsAll = [];
% for tw = 1:length(timeWindows);
%     low = timeWindows{tw}(1);
%     high= timeWindows{tw}(2);
%     ii = find(timeVector >=low & timeVector <=high);
%     for c = 1:length(conditionNames)
%         p = 0;
%         for i = 1:subjects;
%             if ismember(i,skip)
%                 continue
%             end
%             p = p+1;
%             k = num2str(i);
%             %n = ['S',k,conditionNames{c},'EyeFiltered2point5AVG.mat']; % used to be called this
%             n = ['S',k,conditionNames{c},'AVG.mat'];
%             load(n);
%             Results(p,c) = mean(mean(condAVG(electrodes,ii)));
%         end
%     end
%     ResultsAll = [ResultsAll,Results];
%     clear Results
% end


%CONDITIONS%
SPNcond= {[3 1],[4 2]};
AttendReg = 1;
condW = [0.875 0.875];
Project = 24;
Group = 54;
if strcmp(hemisphere, 'left') == 1;
    SPNIDs =[155 156];
    condNos = [1 2];
end

if strcmp(hemisphere, 'right') == 1;
    SPNIDs =[157 158];
    condNos = [3 4];
end

% firstSubjectNo = 1385;
% lmer = 0;
% for c = 1:length(SPNcond)
%     
%     for i = 1:length(ResultsAll);
%         lmer=lmer+1;
%         
%         SPNRegular = ResultsAll(i,SPNcond{c}(1)) - ResultsAll(i,SPNcond{c}(2));   
%         
%         
% 
%         thinResults(lmer,1) = SPNIDs(c);
%         thinResults(lmer,2) = Project;
%         thinResults(lmer,3) = condNos(c);
%         thinResults(lmer,4) = Group;
%         thinResults(lmer,5) = i+firstSubjectNo-1;
%         thinResults(lmer,6) = AttendReg;
%         thinResults(lmer,7) = condW(c);
%         thinResults(lmer,8) = SPNRegular;
%     end
% end
firstSubjectNo = 1385;
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


load thinResultsLeft
load thinResultsRight
thinResults = [thinResultsLeft;thinResultsRight];
save('thinSPNResults','thinResults');

clear all
