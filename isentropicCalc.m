% A class to hold static methods to compute various compressible, 
% isentropic flow values.

classdef isentropicCalc
    methods(Static)
        
        function ratio = T_T0(gamma, machNum)
            % This function takes in gamma (fluid specific heat ratio) and
            % Mach # and computes and returns the quantity of T-naught / T
            % (or stagnation temperature divided by temperature)
            
            reciprocal = 1 + ((gamma - 1) ./ 2) .* machNum.^2;
            ratio = 1 ./ reciprocal;
        end
        
        function ratio = p_p0(gamma, machNum)
            % This function takes in gamma (fluid specific heat ratio) and
            % Mach # and computes and returns the quantity of p-naught / p
            % (or stagnation pressure divided by pressure)
            
            reciprocal = (1 ./ isentropicCalc.T_T0(...
                gamma, machNum)) .^ (gamma ./ (gamma - 1));
            ratio = 1 ./ reciprocal;
        end
        
        function ratio = rho_rho0(gamma, machNum)
            % This function takes in gamma (fluid specific heat ratio) and
            % Mach # and computes and returns the quantity of rho-naught /
            % rho(or stagnation density divided by density) 
            
            reciprocal = (1 ./ isentropicCalc.T_T0(...
                gamma, machNum)) .^ (1 ./ (gamma - 1));
            ratio = 1 ./ reciprocal;
        end
        
        function ratio = A_Astar(gamma, machNum)
            % This function takes in gamma (fluid specific heat ratio) and
            % Mach # and computes and returns A/A*, or the ratio between
            % the area at a chosen point and the area at the sonic
            % condition
            
            bracket = (2 ./ (gamma + 1)) .* ...
                (1 + ((gamma - 1) ./ 2) .* machNum.^2);
            exponent = (gamma + 1) ./ (2 .* (gamma - 1));
            
            ratio = (1 ./ machNum) .* bracket.^exponent;
        end
        
        function result = machNum(gamma, A_Astar, guess)
           % This function uses a numerical solver to find the Mach # given
           % the A/A* ratio, the specific heat ratio, and a parameter 
           % guess (0 to guess subsonic, 1 to guess supersonic).
           
           syms gammaVar
           syms M
           bracket = (2 ./ (gammaVar + 1)) .* ...
               (1 + ((gammaVar - 1) ./ 2) .* M.^2);
           exponent = (gammaVar + 1) ./ (2 .* (gammaVar - 1));
           
           A_AstarEquation = (1 ./ M) .* bracket.^exponent;
           
           mach_equation = A_AstarEquation == A_Astar;
           mach_eq_substituted = subs(mach_equation, gammaVar, gamma);
           
           result = double(vpasolve(mach_eq_substituted, M, guess));
        end
        
        function machAngle = mach_angle(machNum)
           % This function takes in the Mach # and returns the Mach Angle
           % in Degrees
           
           if machNum >= 1
               machAngle = asind(1 ./ machNum);
           else
               % Mach angle is only defined for flows that are at Mach 1 or
               % above. Subsonic flows don't have a Mach angle.
               machAngle = NaN;
           end
        end
        
        function calculated_MFP = MFP(gamma, machNum)
           % This function takes in gamma (fluid specific heat ratio) and 
           % Mach # and computes the mass flow parameter, equaivalent to 
           %             m-dot / A
           %    ---------------------------
           %    p-naught / sqrt(R*T-naught)
           
           numerator = sqrt(gamma) .* machNum;
           denom_exp = (gamma + 1) ./ (2 .* (gamma - 1));
           denom_main = (1 + ((gamma - 1) ./ 2) .* machNum.^2);
           
           calculated_MFP = numerator ./ (denom_main .^ denom_exp);
        end
        
    end
end