%Test sortering
% images = dir(fullfile('C:\Users\Mads_\OneDrive - Aarhus universitet\Bachelor\DICOM\BOLD Datasæt\197\CD-rom\A'));
% 
% wbar = waitbar(0,'Vi venter på indlæsning');
% for i = 3:length(images)
%     information{i} = dicominfo(fullfile(images(i).folder, images(i).name));
%     
%     waitbar(i/length(images),wbar);
% end
% 
% if exist('wbar','var')
%     close(wbar)
% end
% 
imCounter = 1;
locAndCalCounter = 1;
for i=3: length(information)
%     if(contains(lower(information{i}.SeriesDescription), 'loc')==1) || (contains(lower(information{i}.SeriesDescription), 'calibration')==1) || (contains(lower(information{i}.SeriesDescription), 'map')==1)
    if(contains(lower(information{i}.SeriesDescription), '2d ge epi ss 1')==0) 
        LocAndCal{locAndCalCounter} = information{i};
        locAndCalCounter = locAndCalCounter+1;
    else
        ims{imCounter} = information{i};
        imCounter = imCounter +1;
    end
end

c = 0;
sliceLocs(1) = ims{1}.SliceLocation;

for i=1: length(ims)
    curSliceLoc = ims{i}.SliceLocation;
    
    boolean = 0;
    for ii=1: length(sliceLocs)
        if(curSliceLoc==sliceLocs(ii))
            c = ii;
            boolean = 1;
        end
    end
    
    if(boolean == 0)
        sliceLocs(length(sliceLocs)+1) = curSliceLoc;
        slices{length(slices)+1}.images{1} = ims{i};
    else
        if(exist('slices','var'))
            if(isfield(slices{c}, 'images'))
                slices{c}.images{length(slices{c}.images)+1}= ims{i};
            else
                slices{c}.images{1}= ims{i};
            end
        else
            slices{1}.images{1}= ims{i}; 
        end
    end
end

[sortedSlice, idx] = sort(sliceLocs);
slices = slices(idx);

% currentFailCounter = 1;
% 
% for i=1:length(ims) 
%         if(strcmp(a,ims{i}.SeriesDescription) ==0)
%             bool=1; 
%             currentFail(currentFailCounter)=i;
%             currentFailCounter=currentFailCounter+1;
%         end
% end
% 
% 
% for j=1:length(currentFail)
%     allFails{j} = ims{currentFail(j)};
% end
% 
% 
% fiestaCounter = 1;
% for k=1: length(allFails)
%     if (contains(lower(allFails{k}.SeriesDescription),'fiesta')==0)   
%         fiestaFail(fiestaCounter) = k;
%         fiestaCounter = fiestaCounter+1;
%     end
% end 