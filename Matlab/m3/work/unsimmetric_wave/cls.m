classdef cls
    properties
        a;
    end
    
    methods
        function this = A()
            this.a = a;
        end        
        function B(this)
            a = a + 1;
        end
    end
end