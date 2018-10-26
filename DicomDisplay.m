classdef DicomDisplay
    %UNTITLED Summary of this class goes here
    %   Detailed explanation goes here
    
    properties
        dicom_files;
        reader;
    end
    
    methods
        function obj = Constructor(obj)
            %UNTITLED Construct an instance of this class
            %   Detailed explanation goes here
            obj.reader = Reader;
            obj.reader = obj.reader.Constructor();
        end
        
        function dicomFile = ChangeDICOM_file(obj,sliceCounter,frameCounter)
            %METHOD1 Summary of this method goes here
            %   Detailed explanation goes here
            dicomFile = obj.dicom_files{sliceCounter}.DTO{frameCounter};
            dicomFile = obj.NormalizeFrame(dicomFile);
        end
        
        function [dicomFile, object, numberOfFrames, numberOfSlices] = ReadDicomFiles(obj, path)
            %METHOD1 Summary of this method goes here
            %   Detailed explanation goes here
            
            
            %Punktum-mapperne håndteres i Reader-klassen. Vi bør dog finde
            %en smartere måde til dette. Desuden skal der her være en
            %validering af filtypen i mappen, men de filer vi har fået
            %indtil videre har ikke nogen .dcm endelse.
            pathsWithDotFolders = dir(fullfile(path));
            Counter = 1;            
            for i=3: length(pathsWithDotFolders) 
                paths{Counter} = pathsWithDotFolders(i); 
                Counter = Counter+1; 
            end
            obj.dicom_files = obj.reader.ReadDicomFiles(paths);
            dicomFile = obj.dicom_files{1}.DTO{1};
            dicomFile = obj.NormalizeFrame(dicomFile);
            object = obj;
            
            numberOfFrames = length(obj.dicom_files{1}.DTO);
            numberOfSlices = length(obj.dicom_files);
        end
        
        function NormalizedDicom = NormalizeFrame(obj,DicomDTOFile)
            DicomDTOFile.pixelData= double(DicomDTOFile.pixelData);
            DicomDTOFile.pixelData = DicomDTOFile.pixelData/max(DicomDTOFile.pixelData(:));
            NormalizedDicom = DicomDTOFile;
        end
    end
end

