% A class to hold static methods to calculate various values related to
% normal shocks, with the assumptions of thermally and calorically perfect
% gases.

classdef NSC
    methods(Static)
        
        function R = gasConstant(molecularWeight)
            % Calculates the mass specific gas constant based on the
            % universal gas constant and the gas molecular weight in units
            % of J/kgK.
            
            R = 8314.462 ./ molecularWeight;
        end
        
        function a = speedOfSound(gamma, R, temperature)
            % Calculates the speed of sound at the current temperature
            % given the specific ideal gas constant and the specific heat
            % ratio.
            
            a = sqrt(gamma * R * temperature);
        end
        
        function ratio = densityRatioGP(pRatio, gamma)
            % Calculates the density ratio across a normal shock given
            % gamma and the static pressure ratio across the shock
            % (V.C5 from slides)
            
            numerator = 1 + ((gamma + 1)./(gamma - 1) .* pRatio);
            denominator = (gamma + 1)./(gamma - 1) + pRatio;
            
            ratio = numerator ./ denominator;
        end
        
        function ratio = vRatio(machRatio,temperatureRatio)
            % Calculates the velocity ratio across a normal shock given
            % the Mach # ratio and the static Temperature ratio across the 
            % shock 
            % (V.C7 from slides)
            
            ratio = machRatio * sqrt(temperatureRatio);
        end
        
        function ratio = RhoRatioMT(machRatio, temperatureRatio)
            % Calculates the density ratio across a normal shock given
            % Mach # ratio and the static temperature ratio across the 
            % shock 
            % (V.C8 from slides)
            
            ratio = machRatio^-1 * sqrt(temperatureRatio^-1);
        end
        
        function ratio = TRatio(machIn, machOut, gamma)
            % Calculates the temperature ratio  across a normal shock given
            % the Mach #'s before and after and the specific heat ratio.
            % (V.C9 from slides)
            
            gammaMinusOneOverTwo = (gamma - 1)/2;
            numerator = 1 + gammaMinusOneOverTwo*machIn^2;
            denominator = 1 + gammaMinusOneOverTwo*machOut^2;
            
            ratio = numerator/denominator;
        end
        
        function ratio = pRatio(machIn, machOut, gamma)
            % Calculates the pressure ratio  across a normal shock given
            % the Mach #'s before and after and the specific heat ratio.
            % (V.C10 from slides)
            
            numerator = 1 + gamma*machIn^2;
            denominator = 1 + gamma*machOut^2;
            
            ratio = numerator/denominator;
        end
        
        function result = machNumPostShock(machIn, gamma)
            % Calculates the Mach # after a normal shock given the Mach #
            % before the shock and the specific heat ratio.
            % (V.C11 from slides)
            
            twoOverGammaMinusOne = 2/(gamma - 1);
            numerator = machIn^2 + twoOverGammaMinusOne;
            denominator = gamma*twoOverGammaMinusOne*machIn^2 -1;
            result = sqrt(numerator/denominator);
        end
        
        function ratio = P0RatioMG(machIn, gamma)
            % Calculates the stagnation pressure ratio across a normal
            % shock given the Mach # before the shock as well as the 
            % specific heat ratio.
            % (V.C13 from slides)
            
            firstTermNumerator = ((gamma + 1) ./ 2) .* machIn.^2;
            firstTermDenominator = 1 + ((gamma - 1) ./ 2)...
                .* machIn.^2;
            firstTermExp = gamma ./ (gamma - 1);
            firstTerm = (firstTermNumerator ./ firstTermDenominator) ...
                .^ firstTermExp;
            
            twoGammaOverGammaPlusOne = (2 .* gamma) ./ (gamma + 1);
            gammaMinusOneOverGammaPlusOne = (gamma - 1) ./ (gamma + 1);
            secondTermArg = twoGammaOverGammaPlusOne.*machIn.^2 ...
                - gammaMinusOneOverGammaPlusOne;
            secondTermExp = 1 ./ (1 - gamma);
            secondTerm = secondTermArg .^ secondTermExp;
            
            ratio = firstTerm .* secondTerm;
        end
        
        function ratio = P0RatioTP(tRatio, pRatio, gamma)
            % Calculates the stagnation pressure ratio across a normal
            % shock given the static temperature and pressure ratios across
            % the shock and the specific heat ratio.
            % (V.C14 from slides)
            
            gammaOverGammaMinusOne = gamma ./ (gamma - 1);
            ratio = (1 ./ tRatio).^(gammaOverGammaMinusOne) .* pRatio;
        end
        
        function ratio = P0PRatio(machOut, pRatio, gamma)
            % Calculates the ratio between the stagnation pressure after
            % the normal shock and the static pressure before, based on the
            % Mach # after the shock, the static pressure ratio, and the
            % specific heat ratio.
            % (V.C15 from slides)
            
            gammaMinusOneOverTwo = (gamma - 1) ./ 2;
            gammaOverGammaMinusOne = gamma ./ (gamma - 1);
            
            ratio = (1 + gammaMinusOneOverTwo .* machOut.^2).^...
                gammaOverGammaMinusOne .* pRatio;
        end
        
        function ratio = Rho0Ratio(p0Ratio)
            % Returns the stagnation density ratio as equivalent to the
            % stangation pressure ratio across a normal shock.
            % (V.C16)
            
            ratio = p0Ratio;
        end
        
        function ratio = sonicAreaRatio(p0Ratio)
            % Returns the sonic area ratio as equivalent to the inverse of
            % the stangation pressure ratio across a normal shock.
            % (V.C17)
            
            ratio = 1 ./ p0Ratio;
        end
        
    end
end