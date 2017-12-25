module SomeModule
    class Configuration
        def initialize(parameters)
            @parameters=parameters
        end
        def method_first
            @parameters.first
        end
    end
    class DataObject
        def initialize(parameter1, parameter2)
            @parameter1=parameter1
            @parameter2=parameter2
        end
        def first
            @parameter1
        end
    end
end
