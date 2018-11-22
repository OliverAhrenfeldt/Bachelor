classdef UutReader < matlab.unittest.TestCase
    %UNTITLED Summary of this class goes here
    %   Detailed explanation goes here
    
    methods (Static)
       
       function [ReaderObj DicomFiles paths] = Setup() %Arrange
           addpath ../
           
           DicomFilesPath = {
               '../TestData/Z5795_Bold'
               '../TestData/Z5792_Bold'
               '../TestData/Z5793_Bold'
               '../TestData/Z01_Loc'
               };
           
            for i = 1: length(DicomFilesPath)
                d = DICOM_File_DTO;
                d.pixelData = dicomread(DicomFilesPath{i});
                d.dicomInfo = dicominfo(DicomFilesPath{i});
                DicomFiles{i} = d;
            end
            
            %Opretter Dicom filer med anderledes Series Description tag
            %Temporal position identifier
            DicomFiles{5} = DicomFiles{1};
            DicomFiles{5}.dicomInfo.SeriesDescription = '2D GE EPI SS 1 T';
            DicomFiles{6} = DicomFiles{2};
            DicomFiles{6}.dicomInfo.SeriesDescription = '2D GE EPI SS 1 T';
            DicomFiles{7} = DicomFiles{1};
            DicomFiles{7}.dicomInfo.TemporalPositionIdentifier = 2;
            
            %Indlæser Dicomfilerne indeks 2,3 og 4 i DicomFilesPath
            for i = 1: 3
                paths{i} = dir(fullfile(DicomFilesPath{i+1}));
            end
            
            ReaderObj = Reader; 
            ReaderObj.dataAccessor = StubDataAccess;
       end       
    end
    
   
    
    
    methods (Test)
        
        function SortDicomFiles1_1(testCase)
            [uut dto] = UutReader.Setup();
            
            %Filtrere unødvendige DICOM filer for testcasen
            dtoTest = dto(:,[1 2]);
              
            [Dicom_Sorted Dicom_Localizer] = uut.SortDicomFiles(dtoTest); %Act
            
            actSolution = length(Dicom_Sorted);
            expSolution = 2;
            testCase.verifyEqual(actSolution,expSolution); %Assert
            
            actSolution = length(Dicom_Localizer);
            expSolution = 0;
            testCase.verifyEqual(actSolution,expSolution); %Assert
        end 
        
         function SortDicomFiles1_2(testCase)
            [uut dto] = UutReader.Setup();
            
            %Filtrere unødvendige DICOM filer for testcasen
            dtoTest = dto(:,[1 2 3 5 6]);
              
            [Dicom_Sorted Dicom_Localizer] = uut.SortDicomFiles(dtoTest); %Act
            
            actSolution = length(Dicom_Sorted);
            expSolution = 3;
            testCase.verifyEqual(actSolution,expSolution); %Assert
            
            actSolution = length(Dicom_Localizer);
            expSolution = 0;
            testCase.verifyEqual(actSolution,expSolution); %Assert
         end
              
         
         function SortDicomFiles1_3(testCase)
            [uut dto] = UutReader.Setup();
            
            %Filtrere unødvendige DICOM filer for testcasen
            dtoTest = dto(:,[1 2 5 6]);
              
            [Dicom_Sorted Dicom_Localizer] = uut.SortDicomFiles(dtoTest); %Act
            
            actSolution = length(Dicom_Sorted);
            expSolution = 2;
            testCase.verifyEqual(actSolution,expSolution); %Assert
            
            actSolution = length(Dicom_Localizer);
            expSolution = 0;
            testCase.verifyEqual(actSolution,expSolution); %Assert
         end
        
         function SortDicomFiles1_4(testCase)
            [uut dto] = UutReader.Setup();
            
            %Filtrere unødvendige DICOM filer for testcasen
            dtoTest = dto(:,[1 2 4]);
              
            [Dicom_Sorted Dicom_Localizer] = uut.SortDicomFiles(dtoTest); %Act
            
            actSolution = length(Dicom_Sorted);
            expSolution = 2;
            testCase.verifyEqual(actSolution,expSolution); %Assert
            
            actSolution = length(Dicom_Localizer);
            expSolution = 1;
            testCase.verifyEqual(actSolution,expSolution); %Assert
         end
        
         function SortDicomFiles1_5(testCase)
            [uut dto] = UutReader.Setup();
            
            %Filtrere unødvendige DICOM filer for testcasen
            dtoTest = dto(:,[1 2 4 5 6]);
              
            [Dicom_Sorted Dicom_Localizer] = uut.SortDicomFiles(dtoTest); %Act
            
            actSolution = length(Dicom_Sorted);
            expSolution = 2;
            testCase.verifyEqual(actSolution,expSolution); %Assert
            
            actSolution = length(Dicom_Localizer);
            expSolution = 1;
            testCase.verifyEqual(actSolution,expSolution); %Assert
         end
        
         function SortDicomFiles1_6(testCase)
            [uut dto] = UutReader.Setup();
            
            %Filtrere unødvendige DICOM filer for testcasen
            dtoTest = dto(:,[1 2 3 4 5 6]);
              
            [Dicom_Sorted Dicom_Localizer] = uut.SortDicomFiles(dtoTest); %Act
            
            actSolution = length(Dicom_Sorted);
            expSolution = 3;
            testCase.verifyEqual(actSolution,expSolution); %Assert
            
            actSolution = length(Dicom_Localizer);
            expSolution = 1;
            testCase.verifyEqual(actSolution,expSolution); %Assert
         end
        
         
         function SortDicomFiles1_7(testCase)
            [uut dto] = UutReader.Setup();
            
            %Filtrere unødvendige DICOM filer for testcasen
            dtoTest = dto(:,4);
              
            [Dicom_Sorted Dicom_Localizer] = uut.SortDicomFiles(dtoTest); %Act
            
            actSolution = length(Dicom_Sorted);
            expSolution = 0;
            testCase.verifyEqual(actSolution,expSolution); %Assert
            
            actSolution = length(Dicom_Localizer);
            expSolution = 1;
            testCase.verifyEqual(actSolution,expSolution); %Assert
         end
        
         
         function SortDicomFiles1_8(testCase)
            [uut dto] = UutReader.Setup();
            
            %Filtrere unødvendige DICOM filer for testcasen
            dtoTest(1,1) = dto(:,5);
            dtoTest(1,2) = dto(:,6);
            dtoTest(1,3) = dto(:,1);
            dtoTest(1,4) = dto(:,2);
            dtoTest(1,5) = dto(:,3);
              
            [Dicom_Sorted Dicom_Localizer] = uut.SortDicomFiles(dtoTest); %Act
            
            actSolution = length(Dicom_Sorted);
            expSolution = 3;
            testCase.verifyEqual(actSolution,expSolution); %Assert
            
            actSolution = length(Dicom_Localizer);
            expSolution = 0;
            testCase.verifyEqual(actSolution,expSolution); %Assert
         end
         
         
         
          function SortSlices1_9(testCase)
            [uut dto] = UutReader.Setup();
            
            %Filtrere unødvendige DICOM filer for testcasen
            dtoTest(1,1) = dto(:,2);
            dtoTest(1,2) = dto(:,1);
             
            %SortDicomFiles funktionen kaldes, da den kalder SortSlices
            %sidste linje
            [Dicom_Sorted Dicom_Localizer] = uut.SortDicomFiles(dtoTest); %Act
                  
            actSolution = round(Dicom_Sorted{1}.DTO{1}.dicomInfo.SliceLocation,4);
            expSolution = -164.5106;
            testCase.verifyEqual(actSolution,expSolution); %Assert
            
            actSolution = round(Dicom_Sorted{2}.DTO{1}.dicomInfo.SliceLocation,4);
            expSolution = -158.6318;
            testCase.verifyEqual(actSolution,expSolution); %Assert
          end
          
          function SortSlices1_10(testCase)
            [uut dto] = UutReader.Setup();
            
            %Filtrere unødvendige DICOM filer for testcasen
            dtoTest(1,1) = dto(:,1);
            dtoTest(1,2) = dto(:,1);
             
            %SortDicomFiles funktionen kaldes, da den kalder SortSlices
            %sidste linje
            [Dicom_Sorted Dicom_Localizer] = uut.SortDicomFiles(dtoTest); %Act
                  
            actSolution = round(Dicom_Sorted{1}.DTO{1}.dicomInfo.SliceLocation,4);
            expSolution = -164.5106;
            testCase.verifyEqual(actSolution,expSolution); %Assert
            
            actSolution = round(Dicom_Sorted{1}.DTO{2}.dicomInfo.SliceLocation,4);
            expSolution = -164.5106;
            testCase.verifyEqual(actSolution,expSolution); %Assert
          end
          
        
          function SortFrames1_11(testCase)
            [uut dto] = UutReader.Setup();
            
            %Filtrere unødvendige DICOM filer for testcasen
            dtoTest(1,1) = dto(:,7);
            dtoTest(1,2) = dto(:,1);
             
            %SortDicomFiles funktionen kaldes, da den kalder SortSlices
            %sidste linje
            [Dicom_Sorted Dicom_Localizer] = uut.SortDicomFiles(dtoTest); %Act
                  
            actSolution = Dicom_Sorted{1}.DTO{1}.dicomInfo.TemporalPositionIdentifier;
            expSolution = 1;
            testCase.verifyEqual(actSolution,expSolution); %Assert
            
            actSolution = Dicom_Sorted{1}.DTO{2}.dicomInfo.TemporalPositionIdentifier;
            expSolution = 2;
            testCase.verifyEqual(actSolution,expSolution); %Assert
          end
          
          function SortFrames1_12(testCase)
            [uut dto] = UutReader.Setup();
            
            %Filtrere unødvendige DICOM filer for testcasen
            dtoTest(1,1) = dto(:,1);
            dtoTest(1,2) = dto(:,1);
             
            %SortDicomFiles funktionen kaldes, da den kalder SortSlices
            %sidste linje
            [Dicom_Sorted Dicom_Localizer] = uut.SortDicomFiles(dtoTest); %Act
                  
            actSolution = Dicom_Sorted{1}.DTO{1}.dicomInfo.TemporalPositionIdentifier;
            expSolution = 1;
            testCase.verifyEqual(actSolution,expSolution); %Assert
            
            actSolution = Dicom_Sorted{1}.DTO{2}.dicomInfo.TemporalPositionIdentifier;
            expSolution = 1;
            testCase.verifyEqual(actSolution,expSolution); %Assert
          end
        
        function ReadDicomFiles1_13(testCase)
            [uut dto path] = UutReader.Setup();
            
            
            %SortDicomFiles funktionen kaldes, da den kalder SortSlices
            %sidste linje
            [Dicom_Sorted Dicom_Localizer] = uut.ReadDicomFiles(path); %Act
                  
            actSolution = length(Dicom_Sorted);
            expSolution = 2;
            testCase.verifyEqual(actSolution,expSolution); %Assert
            
            actSolution = length(Dicom_Localizer);
            expSolution = 1;
            testCase.verifyEqual(actSolution,expSolution); %Assert
          end
          
          
    end
end

