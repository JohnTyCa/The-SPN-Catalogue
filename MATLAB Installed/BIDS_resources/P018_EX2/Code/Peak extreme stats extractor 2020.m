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
    conditionNames={'RANDREFS','REFrREFlREFr'};
end

if strcmp(hemisphere, 'right') == 1;
    conditionNames={'REFRANDS','REFlREFrREFl'};
end


if strcmp(hemisphere, 'both') == 1;
    conditionNames={'Consistent','Changing'};
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
if strcmp(hemisphere, 'both') == 1;
    electrodes = [21 22 25 26 58 59 62 63]; % BEST FROM TOPOPLOT (POST HOC) P3 P5 PO3 PO7 and P4 P6 PO4 PO8
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

cd(folder2)
save('PositivePeakResults','PositivePeakResults');
save('NegativePeakResults','NegativePeakResults');
clear all
load 'PositivePeakResults';
load 'NegativePeakResults';


