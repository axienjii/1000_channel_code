function generate_electrode_sets_control_microstim_letter_task
%Written by Xing on 13/8/19
%Randomly assign channels with good current thresholds to new electrode
%sets for a control letter task, in which both microstimulation and visual
%versions are carried out.

electrodeNums=[8 3 11 29 7 51 3 12 21 30 64 7 15 40 48 57 58 61 63 64];
arrayNums=[9 12 12 12 12 13 14 14 14 14 14 15 15 15 15 16 16 16 16 16];
oddNums=1:2:length(electrodeNums);
evenNums=2:2:length(electrodeNums);
electrodeNumsShuffled=[electrodeNums(oddNums) electrodeNums(evenNums)];
arrayNumsShuffled=[arrayNums(oddNums) arrayNums(evenNums)];

allElectrodeSets={};
allArraySets={};
stepSize=floor(length(electrodeNumsShuffled)/20);
for setInd=1:10
    inds=(setInd-1)*stepSize+1:(setInd-1)*stepSize+10;
    electrodesTarg1=electrodeNumsShuffled(inds);
    arraysTarg1=arrayNumsShuffled(inds);
    electrodesTarg2=electrodeNumsShuffled;
    arraysTarg2=arrayNumsShuffled;
    electrodesTarg2(inds)=[];
    arraysTarg2(inds)=[];
    if length(electrodesTarg2)>10
        electrodesTarg2=electrodesTarg2(1:10);
        arraysTarg2=arraysTarg2(1:10);
    end
    if mod(setInd,2)==1
        allElectrodeSets(setInd,1:2)=[{electrodesTarg1} {electrodesTarg2}];
        allArraySets(setInd,1:2)=[{arraysTarg1} {arraysTarg2}];
    else
        allElectrodeSets(setInd,1:2)=[{electrodesTarg2} {electrodesTarg1}];
        allArraySets(setInd,1:2)=[{arraysTarg2} {arraysTarg1}];
    end
end
save('X:\best\120819_data\electrodeSets120819.mat','allElectrodeSets','allArraySets')