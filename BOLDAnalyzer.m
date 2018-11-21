classdef BOLDAnalyzer<handle
    %UNTITLED Summary of this class goes here
    %   Detailed explanation goes here

    
    methods
        function [AbsValues, RelValues] = UpdateAnalysis(obj,DicomDisplay, ROIController, baseline)
            %UNTITLED Construct an instance of this class
            %   Detailed explanation goes here
            ROI = {};
            AbsValues(1) = 0;
            for i =1: length(ROIController.ROICollections)
                if(ROIController.ROICollections{i}.AnalysisStatus == 1)
                    for j = 1: length(ROIController.ROICollections{i}.ROIs{1}.Frames)
                        AbsValues(j)=0;
                        for k =1: length(ROIController.ROICollections{i}.ROIs)
                            counter = 1;
                            for l=1:length(ROIController.ROICollections{i}.ROIs{k}.Frames{j}.Position)
                                if(~isempty(ROIController.ROICollections{i}.ROIs{k}.Frames{j}.Position{l}))
                                   ROI{counter} = ROIController.ROICollections{i}.ROIs{k}.Frames{j}.Position{l};
                                   counter = counter+1;
                                end
                            end
                            if(~isempty(ROI))
                               mask = obj.SetMask(ROI,size(DicomDisplay.dicom_files{1}.DTO{1}.pixelData,1),size(DicomDisplay.dicom_files{1}.DTO{1}.pixelData,2));
                               AbsValues(j) = AbsValues(j) + obj.GetAbsoluteValue(mask,DicomDisplay.dicom_files{k}.DTO{j}.pixelData);
                               ROI = {};
                            end
                        end
                    end
                    
                end
                
            end
        end
        
        function finalMask = SetMask(obj,ROIs, imageDim1,imageDim2)
            %METHOD1 Summary of this method goes here
            %   Detailed explanation goes here
            finalMask = zeros(imageDim1,imageDim2);
            for i = 1: length(ROIs)
                ROI = ROIs{i};
                finalMask = finalMask + poly2mask(ROI(:,1),ROI(:,2),imageDim1,imageDim2);
            end
            [~,idx] = find(finalMask>0);
            finalMask(idx) = 1;
        end
        
        function meanValue = GetAbsoluteValue(obj,mask, image)
            %METHOD1 Summary of this method goes here
            %   Detailed explanation goes here
            idx = find(mask>0);
            meanValue = mean(image(idx));
        end
        
        function outputArg = GetRelativeValues(absoluteValues,baselinevalue)
            %METHOD1 Summary of this method goes here
            %   Detailed explanation goes here
            outputArg = obj.Property1 + inputArg;
        end
        
        function outputArg = SetBaseline(baselineValue)
            %METHOD1 Summary of this method goes here
            %   Detailed explanation goes here
            outputArg = obj.Property1 + inputArg;
        end
    end
end

