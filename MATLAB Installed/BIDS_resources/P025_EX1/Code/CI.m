clear
% you will need to set this to a directory on your computer
folder1 = '/Users/alexismakin/Desktop/Alexis Work/Symmetry EEG/SPN effect size and power/Project Folders V8/Project 25/EX1 Color and Shape';
folder2 = '/Users/alexismakin/Desktop/Alexis Work/Symmetry EEG/SPN effect size and power/Project Folders V8/Project 25/EX1 Color and Shape/Grand Averages';
cd(folder1)

%SUBJECTS
subjects = 24;
skip = [];
% CONDITIONS

%TIME WINDOWS
low = 250;
high = 450;

% low = 450
% high = 750

% low = 300
% high = 400

load timeVector
%load timeVectorSamplePlusProbe
ii = find(timeVector >=low & timeVector <=high);


%ELECTRODES
electrodes =[25 27 62 64];  % These will be used if no dogma selected
d = input('which dogma?');

if d ==1
    disp 'dogma 1';
    electrodes = [62 64 27 25]; 
end

if d ==2
    disp 'dogma 2';
    electrodes = [25 62]; 
end

if d ==3
    disp 'dogma 3';
    electrodes = [20 21 22 23 24 25 26 27 57 58 59 60 61 62 63 64]; 
end

if d == 4
    disp 'dogmatic left';
    electrodes = [25 27]; 
end

if d == 5
    disp 'dogmatic right';
    electrodes = [62 64];
end

if d < 1||d> 5
    disp('Original electrodes used');
end

%LOOP
%smoothWindow = 10;

ConfidenceInterval = 0.95;
CIconstant = tinv(1-(1-ConfidenceInterval)/2,subjects-1);



load timeVector;
conditionNames={'SymmetryColorMem','RandomColorMem','SymmetryColorPassive','RandomColorPassive','SymmetryShapeMem','RandomShapeMem','SymmetryShapePassive','RandomShapePassive'};

for i = 1:subjects
    for x = 1:length(conditionNames)
        c = conditionNames{x};
        k = num2str(i);
        n = ['S',k,c,'AVG.mat'];
        load(n)
        data = mean(condAVG(electrodes,1:end),1)';
        %data = smooth(data,smoothWindow,'moving'); % could pre-smooth for
        %each subject here. 
        ERPerror.(c).amplitudes(i,:) = data';
    end  
end


% What diffrence waves do you want? 

ERPerror.ColorMemSPN.amplitudes = ERPerror.SymmetryColorMem.amplitudes- ERPerror.RandomColorMem.amplitudes;
ERPerror.ColorPassiveSPN.amplitudes = ERPerror.SymmetryColorPassive.amplitudes- ERPerror.RandomColorPassive.amplitudes;
ERPerror.ShapeMemSPN.amplitudes = ERPerror.SymmetryShapeMem.amplitudes- ERPerror.RandomShapeMem.amplitudes;
ERPerror.ShapePassiveSPN.amplitudes = ERPerror.SymmetryShapePassive.amplitudes- ERPerror.RandomShapePassive.amplitudes;



conditionNames={'SymmetryColorMem','RandomColorMem','SymmetryColorPassive','RandomColorPassive','SymmetryShapeMem','RandomShapeMem','SymmetryShapePassive','RandomShapePassive','ColorMemSPN','ColorPassiveSPN','ShapeMemSPN','ShapePassiveSPN'};

for x = 1:length(conditionNames)
        c = conditionNames{x};
        ERPerror.(c).SD = std(ERPerror.(c).amplitudes)';
        ERPerror.(c).SEM = (ERPerror.(c).SD)/sqrt(subjects)';
        ERPerror.(c).CI = (ERPerror.(c).SEM)*CIconstant';
end

cd(folder2);
save('ERPerror','ERPerror');
clear all