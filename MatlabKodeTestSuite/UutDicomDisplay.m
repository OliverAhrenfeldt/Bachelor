classdef UutDicomDisplay < matlab.unittest.TestCase
    %UUTDATA Summary of this class goes here
    %   Detailed explanation goes here
    
    
     methods (Static)
       
       function [DicomDisplayObj path DicomFiles] = Setup() %Arrange
            addpath ../
                  
           
           DicomFilesPath = {
               '../TestData/White.dcm'
               '../TestData/Z5795_Bold'
               '../TestData/Z5792_Bold'
               };
            
           for i = 1: length(DicomFilesPath)
                d = DICOM_File_DTO;
                d.pixelData = dicomread(DicomFilesPath{i});
                d.dicomInfo = dicominfo(DicomFilesPath{i});
                DicomFiles{i} = d;
           end
              
            DicomFiles{1}.pixelData(1,1) = 0;
            
            DicomDisplayObj = DicomDisplay;
            DicomDisplayObj.reader = StubReader;
            
            structPath = dir;
            charPath = structPath(1,1).folder;
            newCharPath = charPath(:,[1:69]);
            path = strcat(newCharPath,'TestData');
   
       
       end       
    end
    
    
    methods (Test)
        
        function NormalizedDicom3_1(testCase)
            [uut path dto] = UutDicomDisplay.Setup();
            
            dto = dto{1};
            
            NormalizedDicom = uut.NormalizeFrame(dto); %Act
            
            actSolution = max(NormalizedDicom.pixelData(:));
            expSolution = 1;
            testCase.verifyEqual(actSolution,expSolution); %Assert
            
            actSolution = min(NormalizedDicom.pixelData(:));
            expSolution = 0;
            testCase.verifyEqual(actSolution,expSolution); %Assert
        end 
        
          function CreateTable3_2(testCase)
            [uut path dto] = UutDicomDisplay.Setup();
          
            dto = dto{2} ;
            
            table = uut.CreateTable(dto.dicomInfo); %Act
            
            fileName = char(table.cola(1));
            pixelDataGroup = char(table.cola(338));
           
            actSolution = fileName;
            expSolution = 'Filename';
            testCase.verifyEqual(actSolution,expSolution); %Assert

            actSolution = pixelDataGroup;
            expSolution = 'PixelDataGroupLength';
            testCase.verifyEqual(actSolution,expSolution); %Assert   
        end  
        
        
        function CreateTable3_3(testCase)
            [uut path dto] = UutDicomDisplay.Setup();
          
            dto = dto{2} ;
            
            table = uut.CreateTable(dto.dicomInfo); %Act
            
            fileName = char(table.colb(1));
            pixelDataGroup = table.colb(338);
           
            
            actSolution = fileName;
            expSolution = strcat(path,'\Z5795_Bold');
            testCase.verifyEqual(actSolution,expSolution); %Assert

            actSolution = double(pixelDataGroup{1});
            expSolution = 32780;
            testCase.verifyEqual(actSolution,expSolution); %Assert   
        end
        
        
        function ReadDicomFiles3_4(testCase)
            [uut path] = UutDicomDisplay.Setup();
          
              
            [dicomFile, numberOfFrames, numberOfSlices] = uut.ReadDicomFiles(path); %Act
            
            %TemporalPosition Tag er på index 193
            %SliceLocation Tag er på index 197
            
            TemporalPosition = dicomFile.dicomInfo.colb{193};
            SliceLocation = dicomFile.dicomInfo.colb{197};
               
            actSolution = TemporalPosition;
            expSolution = 1;
            testCase.verifyEqual(actSolution,expSolution); %Assert
            
            actSolution = round(SliceLocation,4);
            expSolution = -164.5106;
            testCase.verifyEqual(actSolution,expSolution); %Assert
        end 
       
        function ReadDicomFiles3_5(testCase)
            [uut path] = UutDicomDisplay.Setup();
          
              
            [dicomFile, numberOfFrames, numberOfSlices] = uut.ReadDicomFiles(path); %Act
            

            actSolution = numberOfFrames;
            expSolution = 2;
            testCase.verifyEqual(actSolution,expSolution); %Assert
           
        end 
        
        function ReadDicomFiles3_6(testCase)
            [uut path] = UutDicomDisplay.Setup();
                        
            [dicomFile, numberOfFrames, numberOfSlices] = uut.ReadDicomFiles(path); %Act

            actSolution = numberOfSlices;
            expSolution = 2;
            testCase.verifyEqual(actSolution,expSolution); %Assert
           
        end  

        function ReadDicomFiles3_7(testCase)
            [uut path] = UutDicomDisplay.Setup();
          
              
            uut.ReadDicomFiles(path); %Act
            
            actSolution = length(uut.dicom_files);
            expSolution = 2;
            testCase.verifyEqual(actSolution,expSolution); %Assert
           
            actSolution = length(uut.dicom_files{1}.DTO);
            expSolution = 2;
            testCase.verifyEqual(actSolution,expSolution); %Assert 
        end  
        
        function ChangeDICOM_file3_8(testCase)
            [uut path dto] = UutDicomDisplay.Setup();
                     
            sliceCounter = 2;
            frameCounter = 1;
            
            uut.ReadDicomFiles(path);
            
            dicomFile = uut.ChangeDICOM_file(sliceCounter,frameCounter); %Act
            
            %TemporalPosition Tag er på index 193
            %SliceLocation Tag er på index 197
            
            TemporalPosition = dicomFile.dicomInfo.colb{193};
            SliceLocation = dicomFile.dicomInfo.colb{197};
           
            actSolution = TemporalPosition;
            expSolution = 1;
            testCase.verifyEqual(actSolution,expSolution); %Assert

            actSolution = round(SliceLocation,4);
            expSolution = -158.6318;
            testCase.verifyEqual(actSolution,expSolution); %Assert   
        end
        
        function ChangeDICOM_file3_9(testCase)
            [uut path dto] = UutDicomDisplay.Setup();
                     
            sliceCounter = 2;
            frameCounter = 1;
            
            uut.ReadDicomFiles(path);
            
            dicomFile = uut.ChangeDICOM_file(sliceCounter,frameCounter); 
            
            sliceCounter = 1;
 
            dicomFile = uut.ChangeDICOM_file(sliceCounter,frameCounter); %Act
            
            %TemporalPosition Tag er på index 193
            %SliceLocation Tag er på index 197
            
            TemporalPosition = dicomFile.dicomInfo.colb{193};
            SliceLocation = dicomFile.dicomInfo.colb{197};
           
            actSolution = TemporalPosition;
            expSolution = 1;
            testCase.verifyEqual(actSolution,expSolution); %Assert

            actSolution = round(SliceLocation,4);
            expSolution = -164.5106;
            testCase.verifyEqual(actSolution,expSolution); %Assert   
        end
        
        function ChangeDICOM_file3_10(testCase)
            [uut path dto] = UutDicomDisplay.Setup();
                     
            sliceCounter = 1;
            frameCounter = 2;
            
            uut.ReadDicomFiles(path);
            
            dicomFile = uut.ChangeDICOM_file(sliceCounter,frameCounter); %Act
            
            %TemporalPosition Tag er på index 193
            %SliceLocation Tag er på index 197
            
            TemporalPosition = dicomFile.dicomInfo.colb{193};
            SliceLocation = dicomFile.dicomInfo.colb{197};
           
            actSolution = TemporalPosition;
            expSolution = 2;
            testCase.verifyEqual(actSolution,expSolution); %Assert

            actSolution = round(SliceLocation,4);
            expSolution = -164.5106;
            testCase.verifyEqual(actSolution,expSolution); %Assert   
        end
        
        function ChangeDICOM_file3_11(testCase)
            [uut path dto] = UutDicomDisplay.Setup();
                     
            sliceCounter = 1;
            frameCounter = 2;
            
            uut.ReadDicomFiles(path);
            
            dicomFile = uut.ChangeDICOM_file(sliceCounter,frameCounter); %Act
            
            frameCounter = 1;
            
            dicomFile = uut.ChangeDICOM_file(sliceCounter,frameCounter); %Act
            
            %TemporalPosition Tag er på index 193
            %SliceLocation Tag er på index 197
            
            TemporalPosition = dicomFile.dicomInfo.colb{193};
            SliceLocation = dicomFile.dicomInfo.colb{197};
           
            actSolution = TemporalPosition;
            expSolution = 1;
            testCase.verifyEqual(actSolution,expSolution); %Assert

            actSolution = round(SliceLocation,4);
            expSolution = -164.5106;
            testCase.verifyEqual(actSolution,expSolution); %Assert   
        end
        
        
    end
end

