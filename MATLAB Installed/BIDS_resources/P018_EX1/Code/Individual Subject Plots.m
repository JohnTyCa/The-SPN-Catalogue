clear all
close all
subjects = 48;

cd '/Users/alexismakin/Desktop/Alexis Work/Symmetry EEG/SPN effect size and power/Project Folders V8/Project 18/EX1 Ref and Ident';


set(0,'DefaultAxesFontSize', 12)
set(0,'DefaultAxesColorOrder',[0 0 0;1 0 0;0 1 0;0 0 1;0 1 1])
conditionNames={'RandRandRand', 'RefRefRef','RandIdent','RefIdent','RandRandRef'};
electrodes = [25 27 62 64];
load timeVector

for i = 1:subjects
    k = num2str(i);
    for c = 1:length(conditionNames)
        n = ['S',k,conditionNames{c},'AVG.mat'];
        load(n);
        Wave(c,:) = mean(condAVG(electrodes,1:end),1)';
    
    end
    subplot(6,8,i),plot(timeVector,[Wave(1,:)', Wave(2,:)', Wave(3,:)', Wave(4,:)',Wave(5,:)'],'LineWidth',2);
    title (k)
    axis([-200 2100 -10 10]);
    clear Wave
end





clear all
close all
subjects = 48
cd '/Users/alexismakin/Desktop/Alexis Work/Symmetry EEG/SPN effect size and power/Project Folders V8/Project 18/EX1 Ref and Ident';
set(0,'DefaultAxesFontSize', 12)
set(0,'DefaultAxesColorOrder',[0 0 0;1 0 0;0 1 0;0 0 1;0 1 1])
conditionNames={'RefRefRef'}
electrodes = [25 27 62 64];
load timeVector
for i = 1:subjects    
    k = num2str(i);
    for c = 1:length(conditionNames)
        n = ['S',k,conditionNames{c},'AVG.mat'];
        load(n);
        Wave(c,:) = mean(condAVG(electrodes,1:end),1)'; 
    end
    subplot(6,8,i),plot(timeVector,[Wave(1,:)'],'LineWidth',2);
    title (k)
    axis([-200 2100 -10 10]);
    clear Wave
end


% just one wave Eloise use this
clear all
close all

cd '/Users/alexismakin/Desktop/Alexis Work/Symmetry EEG/SPN effect size and power/Project Folders V8/Project 18/EX1 Ref and Ident';
set(0,'DefaultAxesFontSize', 12)
set(0,'DefaultAxesColorOrder',[0 0 0;1 0 0;0 1 0;0 0 1;0 1 1])
electrodes = [25 27 62 64];
load timeVector

subject = 1
k = num2str(subject)
n = ['S',k,'RefRefRefAVG.mat'];
load(n);
Wave = mean(condAVG(electrodes,1:end),1)';
zeroline = Wave-Wave;
plot(timeVector,[Wave,zeroline]);
axis([-500 2100 -13 1]);