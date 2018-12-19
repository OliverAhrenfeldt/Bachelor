classdef BOLDAnalyzer<handle
    %BOLDAnalyzer This class performs the BOLD analysis.
    %   This class contains functions for updating the analysis. Adding a
    %   frame to continuous updating the analysis. 

    properties
        absValues;
    end
    
    methods
        function obj = Constructor(obj)
            %Construct an instance of BOLDAnalyzer
            obj.absValues{1}.CollectionValues = [];
            obj.absValues{1}.XValues = [];
        end
    
        function UpdateAnalysis(obj,DicomDisplay, ROIController)
            %UpdateAnalysis This function is used for updating the BOLD
            %analysis. It computes the BOLD valus all over.
            %   This function reveives a DicomDisplay and ROIController
            %   object.
%             ROI = {};
%             AbsValues = zeros(1,length(DicomDisplay.dicom_files));
%             for i =1: length(ROIController.ROICollections)
%                 for j = 1: length(ROIController.ROICollections{i}.ROIs{1}.Frames)
%                     AbsValues(j)=0;
%                     for k =1: length(ROIController.ROICollections{i}.ROIs)
%                         counter = 1;
%                         for l=1:length(ROIController.ROICollections{i}.ROIs{k}.Frames{j}.Position)
%                             if(~isempty(ROIController.ROICollections{i}.ROIs{k}.Frames{j}.Position{l}))
%                                ROI{counter} = ROIController.ROICollections{i}.ROIs{k}.Frames{j}.Position{l};
%                                counter = counter+1;
%                             end
%                         end
%                         if(~isempty(ROI))
%                            mask = obj.SetMask(ROI,size(DicomDisplay.dicom_files{1}.DTO{1}.pixelData,1),size(DicomDisplay.dicom_files{1}.DTO{1}.pixelData,2));
%                            AbsValues(j) = AbsValues(j) + obj.GetAbsoluteValue(mask,DicomDisplay.dicom_files{k}.DTO{j}.pixelData);
%                            ROI = {};
%                         end
%                     end
%                 end
%                 Xtotal = (1:length(DicomDisplay.dicom_files{1}.DTO));
%                 idx = find(AbsValues>0);
%                 AbsValuesFound = AbsValues(idx);
%                 XFound = Xtotal(idx);
%                 obj.absValues{i}.CollectionValues = AbsValuesFound;
%                 obj.absValues{i}.XValues = XFound;
%             end
            ROI = {};
            
            %AbsCollectionValues= {};
            for i =1: length(ROIController.ROICollections)
                
                
                for j = 1: length(ROIController.ROICollections{i}.ROIs{1}.Frames)
                    AbsValues = zeros(1,length(DicomDisplay.dicom_files));
                    AbsValuesFrame(j)=0;
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
                           AbsValues(k) = AbsValues(k) + obj.GetAbsoluteValue(mask,DicomDisplay.dicom_files{k}.DTO{j}.pixelData);
                           ROI = {};
                        end
                    end
                    if(length(find(AbsValues>0))>0)
                        AbsVal = sum(AbsValues)/length(find(AbsValues>0));
                    else
                        AbsVal = 0;
                    end
                    AbsValuesFrame(j) = AbsVal;
                end
                Xtotal = (1:length(DicomDisplay.dicom_files{1}.DTO));
                idx = find(AbsValuesFrame>0);
                AbsValuesFound = AbsValuesFrame(idx);
                XFound = Xtotal(idx);
                %AbsCollectionValues{i}.CollectionValues = AbsValuesFound;
                obj.absValues{i}.CollectionValues = AbsValuesFound;
                %AbsCollectionValues{i}.XValues = XFound;
                obj.absValues{i}.XValues = XFound;
            end
        end
        
        function AddValueForFrame(obj, CollectionIndex, DicomDisplay, ROIController, sliceNumber, frameNumber)
            %AddValueForFrame This function is used for continuously 
            %updating the BOLDanalysis.
            %   The function is used when adding a ROI to a collection. It
            %   receives the collection index from the table, a
            %   DicomDisplay object, a ROIController object, the current
            %   sliceNumber and the current frameNumber.
            ROI = {};
            AbsValues = zeros(1,length(DicomDisplay.dicom_files));
            for h = 1: length(DicomDisplay.dicom_files)
                counter = 1;
                for i=1:length(ROIController.ROICollections{CollectionIndex}.ROIs{h}.Frames{frameNumber}.Position)
                    if(~isempty(ROIController.ROICollections{CollectionIndex}.ROIs{h}.Frames{frameNumber}.Position{i}))
                        ROI{counter} = ROIController.ROICollections{CollectionIndex}.ROIs{h}.Frames{frameNumber}.Position{i};
                        counter = counter+1;
                    end
                end
                if(~isempty(ROI))
                    mask = obj.SetMask(ROI,size(DicomDisplay.dicom_files{h}.DTO{frameNumber}.pixelData,1),size(DicomDisplay.dicom_files{1}.DTO{1}.pixelData,2));
                    AbsValues(h) = AbsValues(h) + obj.GetAbsoluteValue(mask,DicomDisplay.dicom_files{h}.DTO{frameNumber}.pixelData);
                    ROI = {};
                end
            end
            xValue = DicomDisplay.dicom_files{1}.DTO{frameNumber}.dicomInfo.TemporalPositionIdentifier;
            if(sum(AbsValues)~=0)
                if(length(obj.absValues)>=CollectionIndex)
                    valExist = find(obj.absValues{CollectionIndex}.XValues == xValue);
                    if(isempty(valExist))
                        obj.absValues{CollectionIndex}.XValues(length(obj.absValues{CollectionIndex}.XValues)+1) = xValue;
                        obj.absValues{CollectionIndex}.CollectionValues(length(obj.absValues{CollectionIndex}.CollectionValues)+1) = sum(AbsValues);
                        [~,idx] = sort(obj.absValues{CollectionIndex}.XValues);
                        obj.absValues{CollectionIndex}.XValues = obj.absValues{CollectionIndex}.XValues(idx);
                        obj.absValues{CollectionIndex}.CollectionValues = obj.absValues{CollectionIndex}.CollectionValues(idx);                
                    else
                        obj.absValues{CollectionIndex}.CollectionValues(valExist) = sum(AbsValues)/length(find(AbsValues>0));                
                    end
                else
                    obj.absValues{CollectionIndex}.XValues = xValue;
                    obj.absValues{CollectionIndex}.CollectionValues = sum(AbsValues) / length(find(AbsValues>0));
                end
            else
                valExist = find(obj.absValues{CollectionIndex}.XValues == xValue);
                if(~isempty(valExist))
                    obj.absValues{CollectionIndex}.CollectionValues(valExist) = [];
                    obj.absValues{CollectionIndex}.XValues(valExist) = [];
                end
            end
        end
        
        function finalMask = SetMask(obj,ROIs, imageDim1,imageDim2)
            %SetMask This function is used to create a mask for a ROI
            %   This function is needed to calculate the average pixelvalue
            %   in a ROI, used for the BOLDanalysis. It returns a mask. It
            %   receives one or more ROIs, and the dimensions of the image.
            finalMask = zeros(imageDim1,imageDim2);
            for i = 1: length(ROIs)
                ROI = ROIs{i};
                
                finalMask = finalMask + poly2mask(ROI(:,1),ROI(:,2),imageDim1,imageDim2);
            end
            idx = find(finalMask>0);
            finalMask(idx) = 1;
        end
        
        function meanValue = GetAbsoluteValue(obj,mask, image)
            %GetAbsoluteValue This function gets the mean absolute BOLD
            %value
            %   This function returns the mean BOLD value. It receives a
            %   mask and an image.
            idx = find(mask>0);
            meanValue = mean(image(idx));
        end
        
        function relativeValues = GetRelativeValues(obj,absoluteValues,baselinevalue)
            %GetRelativeValues This function gets the relative BOLD values.
            %   It returns the relativevalues, provided with the
            %   absolutevalues and a baseline to adjust the absolute values
            %   around.
            relativeValues = absoluteValues./baselinevalue;
        end
        
        function [averageVal, standardDev] = GetFrameMeanAndStd(obj,ROIController, collectionIndex, frameNumber, sliceNumber, dicomDisplay)
            %GetFrameMeanAndStd This function gets the mean value and
            %standard deviation of a ROI on a frame
            %   It returns the average value and standard deviation. It
            %   receives a ROIController object, the collectionIndex to
            %   indetify the correct ROI collection, the framenumber,
            %   sliceNumber and a dicomDisplay object.
            image = dicomDisplay.dicom_files{sliceNumber}.DTO{frameNumber}.pixelData;
            mask = zeros(size(image,1),size(image,2));
            for i= 1: length(ROIController.ROICollections{collectionIndex}.ROIs{sliceNumber}.Frames{frameNumber}.Position)
                if(~isempty(ROIController.ROICollections{collectionIndex}.ROIs{sliceNumber}.Frames{frameNumber}.Position{i}))
                    ROI = ROIController.ROICollections{collectionIndex}.ROIs{sliceNumber}.Frames{frameNumber}.Position{i};
                    mask = mask+ poly2mask(ROI(:,1),ROI(:,2),size(image,1),size(image,2));
                end
            end
            
            idx = find(mask>0);
            averageVal = mean(image(idx));
            standardDev = std2(image(idx));
        end
        
        function DeleteROICollection(obj,ROIRowIndex)
            %DeleteROICollection This makes sure to clear a deleted
            %collection from the analysis results.
            %   It receives the row index.
            obj.absValues{ROIRowIndex} = [];
            for i=ROIRowIndex+1:length(obj.absValues)
                if (isempty(obj.absValues{i}) == 0)
                    obj.absValues{i-1} = obj.absValues{i};
                end
            end
            obj.absValues(length(obj.absValues)) = [];
        end
    end
end

