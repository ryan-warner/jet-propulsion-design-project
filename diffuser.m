classdef diffuser
    properties (Constant)
      station = "2"
   end
    properties
        diffuserEfficiency
        gamma
        flightMach
        ramDrag
        
        pressureInitial
        pressureFinal
        temperatureInitial
        temperatureFinal 
    end

    methods
        function obj = diffuser(diffuserEfficiency, gamma, flightMach)
            obj.diffuserEfficiency = diffuserEfficiency;
            obj.gamma = gamma;
            obj.flightMach = flightMach;
            if obj.flightMach < 1
                obj.ramDrag = 1;
            else
                obj.ramDrag = 1 - 0.075 .* ((flightMach - 1) .^1.35);
            end
        end

        function obj = temperatureChange(obj, temperatureAmb)
            obj.temperatureInitial = temperatureAmb;
            obj.temperatureFinal = obj.temperatureInitial .* (1 + (0.5 .* (obj.gamma - 1) .* (obj.flightMach .^2)));
        end

        function obj = pressureChange(obj, pressureAmb)
            obj.pressureInitial = pressureAmb;
            obj.pressureFinal = (obj.pressureInitial .* ((1 + (obj.diffuserEfficiency .* ((obj.temperatureFinal ./ obj.temperatureInitial) - 1))) .^ (obj.gamma ./ (obj.gamma - 1)))) * obj.ramDrag;
        end
    end

end
