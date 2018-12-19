classdef Reader < handle
    %Reader This class handles the loaded DICOM-files
    %   This class has functionality to sort the loaded dicomfiles. They
    %   are sorted by frame and slice based on hardcoded dicom-tags. This
    %   means that not any dicom-files can be sorted, if they do not
    %   contain the correct DICOM tags. The dicomtags used are: 
    %   TemporalPositionIdentifier for sorting framewise
    %   SliceLocation for sorting slicewise.
    %   The dicom-tag "LOC" is also used to identify localizer images. The
    %   reason for this is that there might be opportinity to expand the
    %   application to also show the localizer images some day.
    
    properties
        dataAccessor;
    end
    
    methods
        
        function obj = Constructor(obj)
            %Construct an instance of the Reader class
            obj.dataAccessor = DataAccessor;
        end
        
        function [DICOM_files_Sorted, dicomLocalizers] = ReadDicomFiles(obj,paths)
            %ReadDicomFiles This function returns the sorted dicomfiles.
            %   This function returns an array of sorted dicomfiles DTOs,
            %   and the localizers. It handles the reading and calls
            %   subfunctions to sort the files.
            
            %Waitbar reference:
            %https://se.mathworks.com/matlabcentral/fileexchange/22161-waitbar-with-time-estimation 
            wbar = waitbar(0, 'Reading images');
            for i = 1: length(paths)
                d = DICOM_File_DTO;
                d.pixelData = obj.dataAccessor.Dicomread(paths(i));
                d.dicomInfo = obj.dataAccessor.Dicominfo(paths(i));
                DICOM_files{i} = d;
                waitbar(i/length(paths),wbar);
            end 
            close(wbar);
            
            [DICOM_files_Sorted,dicomLocalizers] = obj.SortDicomFiles(DICOM_files);
        end
        
        function [SortedDicomFiles, localizers] = SortDicomFiles(obj,DICOMFiles)
            %SortDicomFiles This function returns the sorted dicomfiles.
            %   This function returns an array of sorted dicom file DTOs
            %   and localizers. First it separates the localizer images,
            %   then it determines which of the dicom-tags "description"
            %   that are most frequent. Afterwards it calls subfunctions to
            %   sort the frames and slices.
                
              locCounter = 1;
              
              for i=1:length(DICOMFiles)
                  currentDesc = DICOMFiles{i}.dicomInfo.SeriesDescription;
                  
                  if(contains(lower(currentDesc),'loc'))
                     localizers{locCounter} = DICOMFiles{i};
                     locCounter = locCounter + 1;
                     
                  else
                      if(exist('descriptions','var'))
                        index = 0;
                        for j = 1: length(descriptions)
                            if(strcmp(currentDesc,descriptions{j}.description{1}))
                                index = j;
                            end
                        end
                        
                            if(index ~= 0)
                               descriptions{index}.description{length(descriptions{index}.description)+1} = currentDesc;
                               descriptions{index}.idx(length(descriptions{index}.idx)+1) = i;
                            else
                               index = length(descriptions) + 1;
                               descriptions{index}.description{1} = currentDesc;
                               descriptions{index}.idx(1) = i;
                            end
                          
                      else
                          descriptions{1}.idx(1) = i;
                          descriptions{1}.description{1} = currentDesc;
                      end
                  end        
              end
              
              if(~exist('descriptions','var'))
                SortedDicomFiles = [];
                return; 
              end
              
              if(length(descriptions) > 1)
                  index = 1;
                 for k = 2: length(descriptions)
                      if(length(descriptions{k}.idx)>length(descriptions{index}.idx))
                         index = k;
                      end
                 end
              end
              
              bold = DICOMFiles(descriptions{index}.idx);
              
              if(~exist('localizers','var'))
                  localizers = [];
              end
              
              SortedDicomFiles = obj.SortSlices(bold);              
        end
        
        function SortedSlices = SortSlices(obj,SortedDicomFiles)
            %SortSlices This function returns the sorted slices.
            c = 0;
            sliceLocs(1) = SortedDicomFiles{1}.dicomInfo.SliceLocation;

            for i=1: length(SortedDicomFiles)
                curSliceLoc = SortedDicomFiles{i}.dicomInfo.SliceLocation;

                boolean = 0;
                for ii=1: length(sliceLocs)
                    if(curSliceLoc==sliceLocs(ii))
                        c = ii;
                        boolean = 1;
                    end
                end

                if(boolean == 0)
                    sliceLocs(length(sliceLocs)+1) = curSliceLoc;
                    
                    index = length(slicesDto)+1;
                    slicesDto{index}.DTO{1} = SortedDicomFiles{i};
                else
                    if(exist('slicesDto','var'))
                        if(isfield(slicesDto{c}, 'DTO'))
                            slicesDto{c}.DTO{length(slicesDto{c}.DTO)+1} = SortedDicomFiles{i};
                        end
                    else
                        slicesDto{1}.DTO{1} = SortedDicomFiles{i};
                    end
                end
            end
            
            [sortedSlice, idx] = sort(sliceLocs);
            SortedDicomFiles = slicesDto(idx);
            SortedSlices = obj.SortFrames(SortedDicomFiles);
            
        end
        
        function SortedFrames = SortFrames(obj,FramesToSort)
            %SortFrames This function returns the sorted frames.
            
            for i=1: length(FramesToSort)
                % tempNumbers nulstilles da der i testscenariet ikke
                % nødvendigvis er samme antal billeder i hvert slice.
                tempNumbers = [];
                for j=1:length(FramesToSort{i}.DTO)
                    tempNumbers(j) = FramesToSort{i}.DTO{j}.dicomInfo.TemporalPositionIdentifier;
                end
                [~,idx] = sort(tempNumbers);
                FramesToSort{i}.DTO = FramesToSort{i}.DTO(idx);
            end
            SortedFrames = FramesToSort;
        end
    end
end

