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



%%% TIME WINDOWS
% timeWindows={[250,350],[500,1000]}
timeWindows={[250,350]}
%timeWindows={[500,1000]}
%timeWindows={[300,400]}
%timeWindows={[600,1000]}

load timeVector


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
            %n = ['S',k,conditionNames{c},'EyeFiltered2point5AVG.mat']; % used to be called this
            n = ['S',k,conditionNames{c},'AVG.mat'];
            load(n);
            Results(p,c) = mean(mean(condAVG(electrodes,ii)));
        end
    end
    ResultsAll = [ResultsAll,Results];
    clear Results
end


%%%% SAVE AND RELOAD
cd(folder2)
save('ResultsAll','ResultsAll');
clear all
load ResultsAll




