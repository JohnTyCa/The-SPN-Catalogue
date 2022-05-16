clear
% you will need to set this to a directory on your computer
folder1 = '/Users/alexismakin/Desktop/Alexis Work/Symmetry EEG/SPN effect size and power/Project Folders V8/Project 13/EX3 Sound Col Cong';
folder2 = '/Users/alexismakin/Desktop/Alexis Work/Symmetry EEG/SPN effect size and power/Project Folders V8/Project 13/EX3 Sound Col Cong/Grand Averages';
cd(folder1);
subjects = 26;
%ELECTRODES
electrodes = [25 27 62 64];
d = input('which dogma?');

if d ==1
    disp 'dogma 1'
    electrodes = [25 27 62 64]; 
end

if d ==2
    disp 'dogma 2'
    electrodes = [25 62]; 
end

if d ==3
    disp 'dogma 3'
    electrodes = [20 21 22 23 24 25 26 27 57 58 59 60 61 62 63 64]; 
end

if d == 4
    disp 'dogmatic left'
    electrodes = [25 27]; 
end

if d == 5
    disp 'dogmatic right'
    electrodes = [62 64];
end

if d < 1||d> 5
    disp('Original electrodes used');
end

%smoothWindow = 10;

ConfidenceInterval = 0.95;
CIconstant = tinv(1-(1-ConfidenceInterval)/2,subjects-1);



load timeVector;


conditionNames={'Rand', 'Ref20','Ref40','Ref60','Ref80','Ref100'};

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

ERPerror.SPN20.amplitudes = ERPerror.Ref20.amplitudes- ERPerror.Rand.amplitudes;
ERPerror.SPN40.amplitudes = ERPerror.Ref40.amplitudes- ERPerror.Rand.amplitudes;
ERPerror.SPN60.amplitudes = ERPerror.Ref60.amplitudes- ERPerror.Rand.amplitudes;
ERPerror.SPN80.amplitudes = ERPerror.Ref80.amplitudes- ERPerror.Rand.amplitudes;
ERPerror.SPN100.amplitudes = ERPerror.Ref100.amplitudes- ERPerror.Rand.amplitudes;

conditionNames={'Rand', 'Ref20','Ref40','Ref60','Ref80','Ref100','SPN20','SPN40','SPN60','SPN80','SPN100'};

for x = 1:length(conditionNames)
        c = conditionNames{x};
        ERPerror.(c).SD = std(ERPerror.(c).amplitudes)';
        ERPerror.(c).SEM = (ERPerror.(c).SD)/sqrt(subjects)';
        ERPerror.(c).CI = (ERPerror.(c).SEM)*CIconstant';
end

cd(folder2);
save('ERPerror','ERPerror');
clear all