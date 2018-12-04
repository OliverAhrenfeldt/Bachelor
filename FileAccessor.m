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
            
            % Let the user know the Excel file has been saved, and ask if they
            % want to open it right away.
            answer = questdlg({'File has been saved as a MAT file at:';path}, ...
                'Success', ...
                'OK','Open file','OK');
            % Handle user response
            switch answer
                case 'OK'
                    % Nothing happens here
                case 'Open file'
                    winopen(path)
            end
        end
        
        function MATSave(obj, path, outputStruct)
            %METHOD1 Summary of this method goes here
            %   Detailed explanation goes here
            save(path, 'outputStruct');
             msgbox({'File has been saved as a MAT file at:';path},'Success','help')
        end
        
        function inputCell = MATRead(obj, path)
            %METHOD1 Summary of this method goes here
            %   Detailed explanation goes here
            inputCell = load(path);
        end
        
        
    end
end

