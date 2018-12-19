classdef UutBOLDAnalyzer < matlab.unittest.TestCase
    %UUTDATA Summary of this class goes here
    %   Detailed explanation goes here
    
    
     methods (Static)
       
       function [BoldAnalyzerObj DicomFiles pos1 pos2 pos3 pos4 stubROIController stubDicomDisplay] = Setup() %Arrange
           addpath ../
           
           DicomFilesPath = {
               '../TestData/ZZZBlackWhite1'
               '../TestData/ZZZBlackWhite2'
               };
           
            for i = 1: length(DicomFilesPath)
                d = DICOM_File_DTO;
                d.pixelData = dicomread(DicomFilesPath{i});
                d.dicomInfo = dicominfo(DicomFilesPath{i});
                DicomFiles{i} = d;
            end
            
%             Opretter polygon objekt med forskellige punkter
%             positions1{1} = {[0 0;1 0;1 1;0 1]};
            pos1{1} = [0 0;1 0;1 1;0 1]; %Mindst mulige ROI
            pos2{1} = [0 0;128 0;128 128;0 128]; %Størst mulige ROI
            pos3{1} = [0 0;64 0;64 128;0 128]; %ROI af hele venstre halvdel lodret
            pos4{1} = [65 0;128 0;128 128;65 128]; %ROI af hele højre halvdel lodret
%             pos4{1} = [0 0;128 0;128 128;0 128];
%             poly = images.roi.Polygon;
%             poly.Position = positions1;
            
            stubROIController = StubROIController; 
            stubDicomDisplay = StubDicomDisplay;

            BoldAnalyzerObj = BOLDAnalyzer;
            BoldAnalyzerObj = BoldAnalyzerObj.Constructor();
            
       
       end       
    end
    
    
    methods (Test)
        
        
        function SetMask7_1(testCase)
            [uut, dicomFiles, positions1, ~] = UutBOLDAnalyzer.Setup();
            
            dicomFile = dicomFiles{1};
              
            pixelData = dicomFile.pixelData; %Act
            dim1 = size(pixelData,1);
            dim2 = size(pixelData,2);
            
            mask = uut.SetMask(positions1, dim1, dim2);
            
            actSolution = mask;
            expSolution = zeros(128,128);
            expSolution(1,1) = 1;
            
            testCase.verifyEqual(actSolution,expSolution); %Assert
        end 
        
        
        function SetMask7_2(testCase)
            [uut, dicomFiles, ~, positions2] = UutBOLDAnalyzer.Setup();
            
            dicomFile = dicomFiles{1};
              
            pixelData = dicomFile.pixelData; %Act
            dim1 = size(pixelData,1);
            dim2 = size(pixelData,2);
            
            mask = uut.SetMask(positions2, dim1, dim2);
            
            actSolution = mask;
            expSolution = ones(128,128);
            testCase.verifyEqual(actSolution,expSolution); %Assert
        end 
        
        function GetAbsoluteValue7_3(testCase)
            [uut, dicomFiles, ~, ~, positions3] = UutBOLDAnalyzer.Setup();
            
            dicomFile = dicomFiles{1};
              
            pixelData = dicomFile.pixelData; %Act
            dim1 = size(pixelData,1);
            dim2 = size(pixelData,2);
            
            mask = uut.SetMask(positions3, dim1, dim2);
            meanValue = uut.GetAbsoluteValue(mask, pixelData);
            
            
            actSolution = meanValue;
            expSolution = 0;
            testCase.verifyEqual(actSolution,expSolution); %Assert
        end 
        
        function GetAbsoluteValue7_4(testCase)
            [uut, dicomFiles, ~, ~, ~, positions4] = UutBOLDAnalyzer.Setup();
            
            dicomFile = dicomFiles{1};
              
            pixelData = dicomFile.pixelData; %Act
            dim1 = size(pixelData,1);
            dim2 = size(pixelData,2);
            
            mask = uut.SetMask(positions4, dim1, dim2);
            meanValue = uut.GetAbsoluteValue(mask, pixelData);
            
            
            actSolution = meanValue;
            expSolution = 65535;
            testCase.verifyEqual(actSolution,expSolution); %Assert
        end 
        
        function AddValueForFrame7_5(testCase)
            [uut, ~, ~, ~, ~, positions4, stubROI, stubDicom] = UutBOLDAnalyzer.Setup();
            
            sliceNumber = 1;
            frameNumber = 1;
            CollectionIndex = 1;
            
            StubROIController = stubROI.Constructor(positions4);
            StubDicomDisplay = stubDicom.Constructor();
            
            uut.AddValueForFrame(CollectionIndex, StubDicomDisplay, StubROIController, sliceNumber, frameNumber)
            
            actSolution = uut.absValues{1, 1}.CollectionValues;
            expSolution = 65535;
            testCase.verifyEqual(actSolution,expSolution); %Assert
        end 
        
          
        function AddValueForFrame7_6(testCase)
            [uut, ~, ~, ~, positions3, ~, stubROI, stubDicom] = UutBOLDAnalyzer.Setup();
            
            sliceNumber = 1;
            frameNumber = 1;
            CollectionIndex = 1;
            
            StubROIController = stubROI.Constructor(positions3);
            StubDicomDisplay = stubDicom.Constructor();
            
            
            uut.AddValueForFrame(CollectionIndex, StubDicomDisplay, StubROIController, sliceNumber, frameNumber);
             
            actSolution = uut.absValues{1, 1}.CollectionValues;
            expSolution = [];
            testCase.verifyEqual(actSolution,expSolution); %Assert
        end 
        
         function GetFrameMeanAndStd7_7(testCase)
            [uut, ~, ~, ~, positions3, ~, stubROI, stubDicom] = UutBOLDAnalyzer.Setup();
            
            sliceNumber = 1;
            frameNumber = 1;
            collectionIndex = 1;
            
            StubROIController = stubROI.Constructor(positions3);
            StubDicomDisplay = stubDicom.Constructor();
            
            [averageVal, standardDev] = uut.GetFrameMeanAndStd(StubROIController, collectionIndex, frameNumber, sliceNumber, StubDicomDisplay)
             
            actSolution = averageVal;
            expSolution = 0;
            testCase.verifyEqual(actSolution,expSolution); %Assert
            
            actSolution = standardDev;
            expSolution = 0;
            testCase.verifyEqual(actSolution,expSolution); %Assert
            
         end 
         
        function GetFrameMeanAndStd7_8(testCase)
            [uut, ~, ~, ~, ~, positions4, stubROI, stubDicom] = UutBOLDAnalyzer.Setup();
            
            sliceNumber = 1;
            frameNumber = 1;
            collectionIndex = 1;
            
            StubROIController = stubROI.Constructor(positions4);
            StubDicomDisplay = stubDicom.Constructor();
            
            [averageVal, standardDev] = uut.GetFrameMeanAndStd(StubROIController, collectionIndex, frameNumber, sliceNumber, StubDicomDisplay);
             
            actSolution = averageVal;
            expSolution = 65535;
            testCase.verifyEqual(actSolution,expSolution); %Assert
            
            actSolution = standardDev;
            expSolution = 0;
            testCase.verifyEqual(actSolution,expSolution); %Assert
            
        end 
        
         function GetFrameMeanAndStd7_9(testCase)
            [uut, ~, ~, positions2, ~, ~, stubROI, stubDicom] = UutBOLDAnalyzer.Setup();
            
            sliceNumber = 1;
            frameNumber = 1;
            collectionIndex = 1;
            
            StubROIController = stubROI.Constructor(positions2);
            StubDicomDisplay = stubDicom.Constructor();
            
            [averageVal, standardDev] = uut.GetFrameMeanAndStd(StubROIController, collectionIndex, frameNumber, sliceNumber, StubDicomDisplay);
             
            actSolution = round(averageVal);
            expSolution = 32768;
            testCase.verifyEqual(actSolution,expSolution); %Assert
            
            actSolution = round(standardDev);
            expSolution = 32769;
            testCase.verifyEqual(actSolution,expSolution); %Assert
         
         end  
        
         function GetFrameMeanAndStd7_10(testCase)
            [uut, ~, ~, positions2, ~, ~, stubROI, stubDicom] = UutBOLDAnalyzer.Setup();
            
            [uut, ~, ~, ~, ~, positions4, stubROI, stubDicom] = UutBOLDAnalyzer.Setup();
            
            sliceNumber = 1;
            frameNumber = 1;
            CollectionIndex = 1;
            
            StubROIController = stubROI.Constructor(positions4);
            StubDicomDisplay = stubDicom.Constructor();
            
            uut.AddValueForFrame(CollectionIndex, StubDicomDisplay, StubROIController, sliceNumber, frameNumber)
            
            baselinevalue = 65535;
            relative = uut.GetRelativeValues(uut.absValues{1, 1}.CollectionValues,baselinevalue)
            uut.absValues{1, 1}.CollectionValues
            actSolution = relative;
            expSolution = 1;
            testCase.verifyEqual(actSolution,expSolution); %Assert
            
         end  
        
         
          function AddValueForFrame7_11(testCase)
            [uut, ~, ~, ~, ~, positions4, stubROI, stubDicom] = UutBOLDAnalyzer.Setup();
            
            sliceNumber = 1;
            frameNumber = 1;
            CollectionIndex = 1;
            
            StubROIController = stubROI.Constructor(positions4);
            StubDicomDisplay = stubDicom.Constructor();
            
            uut.UpdateAnalysis(StubDicomDisplay, StubROIController);
            
            actSolution = uut.absValues{1, 1}.CollectionValues;
            expSolution = 65535;
            testCase.verifyEqual(actSolution,expSolution); %Assert
        end 
         
         
    end
end

