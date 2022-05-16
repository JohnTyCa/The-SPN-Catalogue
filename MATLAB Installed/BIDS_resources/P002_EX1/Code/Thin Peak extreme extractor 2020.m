clear
% DIRECTORY (THIS WILL NEED TO BE CHANGED TO A DIRECTORY ON YOUR COMPUTER
folder1 =  '/Users/alexismakin/Desktop/Alexis Work/Symmetry EEG/SPN effect size and power/Project Folders V8/Project 2/EX1 Oddball';
folder2 = '/Users/alexismakin/Desktop/Alexis Work/Symmetry EEG/SPN effect size and power/Project Folders V8/Project 2/EX1 Oddball/Grand Averages';
cd(folder1)

%SUBJECTS
subjects = 24;
skip = []

%CONDITIONS
%conditionNames={'Normal','Oddball'}
conditionNames={'Reflection','Translation','Rotation'}

% TIME WINDOWS
load timeVector
low = 100 
high = 200
iip = find(timeVector >=low & timeVector <=high);

low = 150 
high = 250
iin = find(timeVector >=low & timeVector <=high);


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
AttendReg = 0;
condW = [0.5, 0.04545454, 0.04545454];
Project = 2;
Group = 4;
condNos = [1 2 3];
SPNIDs =[4 5 6];
firstSubjectNo = 61;
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
cd(folder2);
save('thinPeakExtremeResults','thinResults');
clear all;
load 'thinPeakExtremeResults';


