classdef ROIController < handle
    %UNTITLED Summary of this class goes here
    %   Detailed explanation goes here
    
    properties
        ROICollections;
        Autotracker;
    end
    
    methods
        function obj = Constructor(obj)
            %UNTITLED Construct an instance of this class
            %   Detailed explanation goes here
            obj.Autotracker = Autotrack();
        end
        
        function AddNewCollection(obj,name,totalFrameNumber, totalSliceNumber, color,framenumber,slicenumber,polygon, roiCollection)
            %METHOD1 Summary of this method goes here
            %   Detailed explanation goes here
            counter = 1;
            for i=2: size(polygon.Position,1)
                if((polygon.Position(i,1) == polygon.Position(i-1,1)) && (polygon.Position(i,2) == polygon.Position(i-1,2))) 
                    polyIndex(counter) = i;
                    counter = counter + 1;
                end
            end
            
            if(exist('polyIndex','var'))
                for i=1: length(polyIndex)
                 polygon.Position(polyIndex(i),:)= [];
                 polyIndex = polyIndex - 1;
                end 
            end
            
            RoiCollection = roiCollection;
            RoiCollection = RoiCollection.Constructor(name,totalFrameNumber, totalSliceNumber, color,framenumber,slicenumber,polygon);
            obj.ROICollections{length(obj.ROICollections)+1} = RoiCollection;
        end
        
        function AddROI(obj, idx, framenumber, slicenumber, polygon) 
           
             counter = 1;
            for i=2: size(polygon.Position,1)
                if((polygon.Position(i,1) == polygon.Position(i-1,1)) && (polygon.Position(i,2) == polygon.Position(i-1,2)))
                    
                    polyIndex(counter) = i;
                    counter = counter + 1;
                end
            end
            
            if(exist('polyIndex','var'))
                for i=1: length(polyIndex)
                 polygon.Position(polyIndex(i),:)= [];
                 polyIndex = polyIndex - 1;
                end 
            end
            
            obj.ROICollections{idx}.ROIs{slicenumber}.Frames{framenumber}.ROI{length(obj.ROICollections{idx}.ROIs{slicenumber}.Frames{framenumber}.ROI)+1} = polygon;
            obj.ROICollections{idx}.ROIs{slicenumber}.Frames{framenumber}.Position{length(obj.ROICollections{idx}.ROIs{slicenumber}.Frames{framenumber}.Position)+1} = polygon.Position;
        end
        
        function Names = getNames(obj)
            for i =1:length(obj.ROICollections)
%                 if (isempty(obj.ROICollections{i}) ~= 1)
                    Names{i} = obj.ROICollections{i}.Name; 
%                 end
            end
        end
        
        function AnalysisStatus = getAnalysisStatus(obj)
            for i =1:length(obj.ROICollections)
%                 if (isempty(obj.ROICollections{i}) ~= 1)
                    AnalysisStatus{i} = obj.ROICollections{i}.AnalysisStatus; 
%                 end
            end
        end
        
        function [cola, colb] = getROITable(obj)
            
            if (isempty(obj.ROICollections) == 0)
                cola = obj.getNames()';
                AnalysisStatus = obj.getAnalysisStatus()';
                for i=1: length(AnalysisStatus)
                    if(AnalysisStatus{i}==0)
                        colb{i} = false;
                    else
                        colb{i} = true;
                    end
                end
                colb = colb';
            else
                cola = {};
                colb = {};
            end
        end
        
        function setAnalysisStatus(obj,collectionIndex,status)
            obj.ROICollections{collectionIndex}.AnalysisStatus = status;
        end
        
        function DeleteROI(obj, idx, framenumber, slicenumber)
            for i=1:length(obj.ROICollections{idx}.ROIs{slicenumber}.Frames{framenumber}.Position)
                %Checks wether the field contianing the ROI polygon is
                %longer than i. If the user has used autotracking, ROIs
                %have been added and they are only added as arrays (in the
                %'Position' field. 
                if(length(obj.ROICollections{idx}.ROIs{slicenumber}.Frames{framenumber}.ROI)>=i)
                    delete(obj.ROICollections{idx}.ROIs{slicenumber}.Frames{framenumber}.ROI{i});
                    obj.ROICollections{idx}.ROIs{slicenumber}.Frames{framenumber}.ROI{i} = [];
                end
                obj.ROICollections{idx}.ROIs{slicenumber}.Frames{framenumber}.Position{i} = [];
            end
        end
        
        function DeleteROICollection(obj, idx, framenumber, slicenumber)
            for i=1:length(obj.ROICollections{idx}.ROIs{slicenumber}.Frames{framenumber}.ROI)
                delete(obj.ROICollections{idx}.ROIs{slicenumber}.Frames{framenumber}.ROI{i});
            end
            
            obj.ROICollections{idx} = [];
            for i=idx+1:length(obj.ROICollections)
                if (isempty(obj.ROICollections{i}) == 0)
                    obj.ROICollections{i-1} = obj.ROICollections{i};
                end
            end
            
            obj.ROICollections(length(obj.ROICollections)) = [];
        end
        
        function StartAutotracking(obj,dicomDisplay, slicenumber, framenumber, totalFrames, collectionIdx)
            obj.Autotracker = Autotrack();
            %counter = framenumber+1;
            for i=framenumber+1:totalFrames
                image = dicomDisplay.dicom_files{slicenumber}.DTO{framenumber+1}.pixelData;
                for j=1: length(obj.ROICollections{collectionIdx}.ROIs{slicenumber}.Frames{framenumber}.Position)
                    prevROI = obj.ROICollections{collectionIdx}.ROIs{slicenumber}.Frames{framenumber}.Position{j};
                    if(~isempty(prevROI))
                        mask = poly2mask(prevROI(:,1),prevROI(:,2),size(dicomDisplay.dicom_files{1}.DTO{1}.pixelData,1),size(dicomDisplay.dicom_files{1}.DTO{1}.pixelData,2));
                        idx = find(mask>0);
                        prevImage = dicomDisplay.dicom_files{slicenumber}.DTO{framenumber}.pixelData;
                        threshold = (std2(prevImage(idx)))/2;
                        newROI = obj.Autotracker.TrackImage(image,prevROI,threshold); %OBS threshold skal være relativt baseret på std
                        obj.ROICollections{collectionIdx}.ROIs{slicenumber}.Frames{framenumber+1}.Position{length(obj.ROICollections{collectionIdx}.ROIs{slicenumber}.Frames{framenumber+1}.Position)+1} = newROI;
                    end
                end
                framenumber = framenumber+1;
            end
        end
        
        function DrawROIsThrough(obj, slicenumber, framenumber, totalFrames, collectionIdx)
            for i=framenumber+1:totalFrames
                for j=1: length(obj.ROICollections{collectionIdx}.ROIs{slicenumber}.Frames{framenumber}.Position)
                    prevROI = obj.ROICollections{collectionIdx}.ROIs{slicenumber}.Frames{framenumber}.Position{j};
                    if(~isempty(prevROI))
                        obj.ROICollections{collectionIdx}.ROIs{slicenumber}.Frames{framenumber+1}.Position{length(obj.ROICollections{collectionIdx}.ROIs{slicenumber}.Frames{framenumber+1}.Position)+1} = prevROI;
                    end
                end
                framenumber = framenumber+1;
            end
        end
    end
end

