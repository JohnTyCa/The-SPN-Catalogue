clear all
close all
subjects = 26;

cd '/Users/alexismakin/Desktop/Alexis Work/Symmetry EEG/SPN effect size and power/Project Folders V8/Project 13/EX1 Reg Task'

set(0,'DefaultAxesFontSize', 12)

set(0,'DefaultAxesColorOrder',[0 0 1; 0.2 0 0; 0.4 0 0; 0.6 0 0;0.8 0 0;1 0 0])
conditionNames={'Rand', 'Ref20','Ref40','Ref60','Ref80','Ref100'}

electrodes = [25 27 62 64];
load timeVector

for i = 1:subjects
    
        
    k = num2str(i);
    for c = 1:length(conditionNames)
        n = ['S',k,conditionNames{c},'AVG.mat'];
        load(n);
        Wave(c,:) = mean(condAVG(electrodes,1:end),1)';
    
    end

    
    subplot(6,5,i),plot(timeVector,[Wave(1,:)', Wave(2,:)', Wave(3,:)', Wave(4,:)',Wave(5,:)',Wave(6,:)'],'LineWidth',2);
    title (k)
    axis([-200 500 -10 10]);
    clear Wave
end





clear all
close all
subjects = 26;
cd '/Users/alexismakin/Desktop/Alexis Work/Symmetry EEG/SPN effect size and power/Project Folders V8/Project 13/EX1 Reg Task'
set(0,'DefaultAxesFontSize', 12)
set(0,'DefaultAxesColorOrder',[0 0 1; 0.2 0 0; 0.4 0 0; 0.6 0 0;0.8 0 0;1 0 0])
conditionNames={'Ref100'}
electrodes = [25 27 62 64];
load timeVector

for i = 1:subjects
    
        
    k = num2str(i);
    for c = 1:length(conditionNames)
        n = ['S',k,conditionNames{c},'AVG.mat'];
        load(n);
        Wave(c,:) = mean(condAVG(electrodes,1:end),1)';
    
    end

    
    subplot(7,4,i),plot(timeVector,[Wave(1,:)'],'LineWidth',2);
    title (k)
    axis([-200 1000 -10 10]);
    clear Wave
end


clear all
close all
subject = 2;
cd '/Users/alexismakin/Desktop/Alexis Work/Symmetry EEG/SPN effect size and power/Project Folders V8/Project 13/EX1 Reg Task'
set(0,'DefaultAxesFontSize', 12)
set(0,'DefaultAxesColorOrder',[0 0 1; 1 0 0])
conditionNames={'Ref100'}
electrodes = [25 27 62 64];
load timeVector


    
k = num2str(subject)     
for c = 1:length(conditionNames)
    n = ['S',k,conditionNames{c},'AVG.mat'];
    load(n);
    WaveAVG(c,:) = mean(condAVG(electrodes,1:end),1)';
    n = ['S',k,conditionNames{c},'Med.mat'];
    load(n);
    WaveMed(c,:) = mean(condMed(electrodes,1:end),1)';
end


plot(timeVector,[WaveAVG(1,:)',WaveMed(1,:)'],'LineWidth',2);
legend('Average of included trials','Median of included trials')
title (num2str(electrodes))
axis([-200 1000 -10 10]);



    
    