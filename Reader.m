classdef Reader
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
            DICOM_files = repmat(DICOM_File_DTO(),1,length(paths));
            wbar = waitbar(0, 'Reading images');
            for i = 1: length(paths)
                d = DICOM_File_DTO;
                d.pixelData = obj.dataAccessor.Dicomread(paths(i));
                d.dicomInfo = obj.dataAccessor.Dicominfo(paths(i));
                DICOM_files(i) = d;
                DICOM_filess{i} = d;
                waitbar(i/length(paths),wbar);
            end
            
            DICOM_files_Sorted = obj.SortDicomFiles(DICOM_filess);
            figure()
        end
        
        function SortedDicomFiles = SortDicomFiles(obj,DICOMFiles)
            %METHOD1 Summary of this method goes here
            %   Detailed explanation goes here
            for p=1:length(DICOMFiles)
                information{p}=DICOMFiles{p}.dicomInfo;
            end
            
            imCounter = 1;
            locAndCalCounter = 1;
            
            %Måske vi kan finde en anden metode end i=3 til at komme af med
            %punktum-mapperne.
            for i=1: length(DICOMFiles)
                if(contains(lower(information{i}.SeriesDescription), '2d ge epi ss 1')==0) 
                    LocAndCal{locAndCalCounter} = information{i};
                    locAndCalCounter = locAndCalCounter+1;
                else
                    ims{imCounter} = information{i};
                    frame{imCounter} = DICOMFiles{i}.pixelData;
                    dto{imCounter} = DICOMFiles{i};
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
                    index = length(slices)+1;
                    slices{index}.images{1} = ims{i};
                    slices{index}.pixels{1} = frame{i};
                    slicesDto{index}.DTO{1} = dto{i};
                else
                    if(exist('slices','var'))
                        if(isfield(slices{c}, 'images'))
                            slices{c}.images{length(slices{c}.images)+1}= ims{i};
                            slices{c}.pixels{length(slices{c}.pixels)+1}= frame{i};
                            slicesDto{c}.DTO{length(slicesDto{c}.DTO)+1} = dto{i};
                        else
                            slices{c}.images{1}= ims{i};
                            slices{c}.pixels{1}= frame{i};
                            slicesDto{c}.DTO{1} = dto{i};
                        end
                    else
                        slices{1}.images{1}= ims{i}; 
                        slices{1}.pixels{1}= frame{i}; 
                        slicesDto{1}.DTO{1} = dto{i};
                    end
                end
            end
            
            [sortedSlice, idx] = sort(sliceLocs);
            %SortedDicomFiles = slices(idx);
            SortedDicomFiles = slicesDto(idx);
            SortedDicomFiles = obj.SortSlices(SortedDicomFiles);
        end
        
        function SortedSlices = SortSlices(obj,SortedDicomFrames)
            for i=1: length(SortedDicomFrames)
                %Nedenfor stod der images før hvor der nu står DTO
                for j=1:length(SortedDicomFrames{i}.DTO)
                   % tempNumbers(j) = SortedDicomFrames{i}.images{j}.TemporalPositionIdentifier;
                    tempNumbers(j) = SortedDicomFrames{i}.DTO{j}.dicomInfo.TemporalPositionIdentifier;
                end
                [~,idx] = sort(tempNumbers);
              %  SortedDicomFrames{i}.images = SortedDicomFrames{i}.images(idx);
                SortedDicomFrames{i}.DTO = SortedDicomFrames{i}.DTO(idx);
            end
            SortedSlices = SortedDicomFrames;
        end
    end
end

