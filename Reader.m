classdef Reader < handle
    %UNTITLED Summary of this class goes here
    %   Detailed explanation goes here
    
    properties
        dataAccessor;
    end
    
    methods
        function obj = Constructor(obj)
            %UNTITLED Construct an instance of this class
            %   Detailed explanation goes here
            obj.dataAccessor = DataAccessor;
        end
        
        function DICOM_files_Sorted = ReadDicomFiles(obj,paths)
            %METHOD1 Summary of this method goes here
            %   Detailed explanation goes here
            
            %Præallokering for effektivitet
            wbar = waitbar(0, 'Reading images');
            for i = 1: length(paths)
                d = DICOM_File_DTO;
                d.pixelData = obj.dataAccessor.Dicomread(paths(i));
                d.dicomInfo = obj.dataAccessor.Dicominfo(paths(i));
                DICOM_files{i} = d;
                waitbar(i/length(paths),wbar);
            end
            
            DICOM_files_Sorted = obj.SortDicomFiles(DICOM_files);
        end
        
        function SortedDicomFiles = SortDicomFiles(obj,DICOMFiles)
            %METHOD1 Summary of this method goes here
            %   Detailed explanation goes here
                
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
              
              index = 1;
              for k = 2: length(descriptions)
                  if(length(descriptions{k}.idx)>length(descriptions{index}.idx))
                      index = k;
                  end
              end
              
              bold = DICOMFiles(descriptions{index}.idx);
              SortedDicomFiles = obj.SortSlices(bold);
              figure();
              
        end
        
        function SortedSlices = SortSlices(obj,SortedDicomFiles)
            
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
                        else
                            slicesDto{c}.DTO{1} = SortedDicomFiles{i};
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
        
        function SortedFrames = SortFrames(obj,SortedDicomFrames)
            for i=1: length(SortedDicomFrames)

                for j=1:length(SortedDicomFrames{i}.DTO)
                    tempNumbers(j) = SortedDicomFrames{i}.DTO{j}.dicomInfo.TemporalPositionIdentifier;
                end
                [~,idx] = sort(tempNumbers);
                SortedDicomFrames{i}.DTO = SortedDicomFrames{i}.DTO(idx);
            end
            SortedFrames = SortedDicomFrames;
        end
    end
end

