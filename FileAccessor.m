classdef FileAccessor
    %UNTITLED3 Summary of this class goes here
    %   Detailed explanation goes here
    
    properties
        Property1
    end
    
    methods
        
        function XLSXSave(obj, path, outputCell)
            %METHOD1 Summary of this method goes here
            %   Detailed explanation goes here
            xlswrite(path,outputCell);
            msgbox({'File has been saved as an xlsx document at:';path},'Success','help')
        end
        
        function MATSave(obj, outputStruct, path)
            %METHOD1 Summary of this method goes here
            %   Detailed explanation goes here
            save(path, 'outputStruct');
            msgbox({'File has been saved as a MAT file at:';path},'Success','help')
        end
        
        function inputStruct = MATRead(obj, path)
            %METHOD1 Summary of this method goes here
            %   Detailed explanation goes here
            inputStruct = load(path);
        end
        
        
    end
end

