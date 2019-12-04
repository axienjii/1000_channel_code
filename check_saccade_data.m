function check_saccade_data
%Written by Xing 14/10/19. Checks that lists of electrodes are correct,
%between 'uniqueElectrodeList' and 'uniqueElectrodeList_subset,' where the
%former list includes eye movement data across 4 months from both the current thresholding
%task combined with the saccade task in which suprathreshold current amplitudes were
%used and electrode identities were varied across trials; and the latter
%includes only the saccade task in which suprathreshold current amplitudes were
%used and electrode identities were varied across trials.

%Check that all electrodes that are present on subset are also present in
%larger set
for i=1:length(uniqueElectrodeList_subset)
   electrode=uniqueElectrodeList_subset(i);
   array=uniqueArrayList_subset(i);
   temp1=find(uniqueElectrodeList==electrode);
   temp2=find(uniqueArrayList==array);
   ind=intersect(temp1,temp2);
   if isempty(ind)
       electrode
       array
   end
end

%Check proportion of electrodes that are present on larger set are not present in
%subset
count=0;
for i=1:length(uniqueElectrodeList)
   electrode=uniqueElectrodeList(i);
   array=uniqueArrayList(i);
   temp1=find(uniqueElectrodeList_subset==electrode);
   temp2=find(uniqueArrayList_subset==array);
   ind=intersect(temp1,temp2);
   if isempty(ind)
       electrode
       array
       count=count+1;
   end
end
count