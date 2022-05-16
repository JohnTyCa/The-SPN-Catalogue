clear
% DIRECTORY (THIS WILL NEED TO BE CHANGED TO A DIRECTORY ON YOUR COMPUTER
folder1 = '/Users/alexismakin/Desktop/Alexis Work/Symmetry EEG/SPN effect size and power/Project Folders V8/Project 4/EX1 Reg or Valence (first 24)';
folder2 = '/Users/alexismakin/Desktop/Alexis Work/Symmetry EEG/SPN effect size and power/Project Folders V8/Project 4/EX1 Reg or Valence (first 24)/Grand Averages';
cd(folder1);

%SUBJECTS
subjects = 24;
skip  =[];

%CONDITIONS
conditionNames = {'RandomGoodValence','RandomBadValence','ReflectionGoodValence','ReflectionBadValence','RandomGoodRegularity','RandomBadRegularity','ReflectionGoodRegularity','ReflectionBadRegularity'};

%TIME WINDOWS
low = 250;
%low = 300;
high = 1000; 
load timeVector
ii = find(timeVector >=low & timeVector <=high);

% ELECTRODES
electrodes = [22 23 24 25 59 60 61 62]; % Left and right (Scott et al. 2009)

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
        clear condAVG
    end
end

%CONDITIONS
%conditionNames = {'RandomGoodValence','RandomBadValence','ReflectionGoodValence','ReflectionBadValence','RandomGoodRegularity','RandomBadRegularity','ReflectionGoodRegularity','ReflectionBadRegularity'};

%SPNcond= {[1 2]}
SPNcond= {[3 1],[4 2],[7 5],[8 6]};
AttendReg = [0 0 1 1];
condW = [0.75,0.75,0.75,0.75];
Project = 4;
Group = 8;
condNos = [1 2 3 4];
SPNIDs =[14 15 16 17];
firstSubjectNo = 149;
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
        thinResults(lmer,6) = AttendReg(c);
        thinResults(lmer,7) = condW(c);
        thinResults(lmer,8) = SPNRegular;
    end
end



% SAVE AND RELOAD
cd(folder2);
save('thinSPNResults','thinResults');
clear all;
load 'thinSPNResults';


