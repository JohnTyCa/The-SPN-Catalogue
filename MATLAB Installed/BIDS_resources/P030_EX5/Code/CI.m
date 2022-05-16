clear
% you will need to set this to a directory on your computer
folder1 = '/Users/alexismakin/Desktop/Alexis Work/Symmetry EEG/SPN effect size and power/Project Folders V8/Project 30/EX5 Gerbino PNG1and3';
folder2 = '/Users/alexismakin/Desktop/Alexis Work/Symmetry EEG/SPN effect size and power/Project Folders V8/Project 30/EX5 Gerbino PNG1and3/Grand Averages';
cd(folder1)

%SUBJECTS
nSubjects =30;
skip = [];
subjects = nSubjects-length(skip);

% CONDITIONS


%ELECTRODES
electrodes = [25 26 27 62 63 64];  % These will be used if no dogma selected
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




conditionNames = {'RandomConvex1','RandomConcave1','RefConvex1','RefConcave1','RandomConvex3','RandomConcave3','RefConvex3','RefConcave3'}; 
for i = 1:nSubjects
    if ismember(i,skip)
       continue
    end
    for x = 1:length(conditionNames)
        c = conditionNames{x};
        k = num2str(i);
        n = ['S',k,c,'AVGBF.mat'];
        load(n)
        data = mean(condAVG(electrodes,1:end),1)';
        %data = smooth(data,smoothWindow,'moving'); % could pre-smooth for
        %each subject here. 
        ERPerror.(c).amplitudes(i,:) = data';
    end  
end


% What diffrence waves do you want? 

ERPerror.ConvexSPN1.amplitudes = ERPerror.RefConvex1.amplitudes- ERPerror.RandomConvex1.amplitudes;
ERPerror.ConcaveSPN1.amplitudes = ERPerror.RefConcave1.amplitudes- ERPerror.RandomConcave1.amplitudes;

ERPerror.ConvexSPN3.amplitudes = ERPerror.RefConvex3.amplitudes- ERPerror.RandomConvex3.amplitudes;
ERPerror.ConcaveSPN3.amplitudes = ERPerror.RefConcave3.amplitudes- ERPerror.RandomConcave3.amplitudes;




conditionNames = {'RandomConvex1','RandomConcave1','RefConvex1','RefConcave1','RandomConvex3','RandomConcave3','RefConvex3','RefConcave3','ConvexSPN1','ConcaveSPN1','ConvexSPN3','ConcaveSPN3'}; 
for x = 1:length(conditionNames)
        c = conditionNames{x};
        ERPerror.(c).SD = std(ERPerror.(c).amplitudes)';
        ERPerror.(c).SEM = (ERPerror.(c).SD)/sqrt(subjects)';
        ERPerror.(c).CI = (ERPerror.(c).SEM)*CIconstant';
end

cd(folder2);
save('ERPerror','ERPerror');
clear all