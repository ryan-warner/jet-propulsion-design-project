% A class to hold static methods to calculate various values related to
% oblique shocks, with the assumptions of thermally and calorically perfect
% gases.

classdef OSC
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
        
        function angle = shockAngle(machIn, gamma, alpha, delta)
            % Calculates the shock/wave angle based on the turn angle,
            % delta, the specific heat ratio, the Mach number before the
            % shock, and whether a strong (alpha = 0) or weak (alpha = 1)
            % shock solution is sought.
            % (V.C30 from slides)
            
            gammaMinusOneOverTwo = (gamma - 1)/2;
            gammaPlusOneOverTwo = (gamma + 1)/2;
            
            lambda = sqrt((machIn^2-1)^2 - 3*(1 + gammaMinusOneOverTwo...
                *machIn^2)*(1 + gammaPlusOneOverTwo*machIn^2)...
                *tand(delta)^2);
            
            chi = lambda^(-3)*((machIn^2 -1)^3 - 9*(1 + ...
                gammaMinusOneOverTwo*machIn^2)*(1 + gammaMinusOneOverTwo...
                *machIn^2 + (gammaPlusOneOverTwo/2)*machIn^4)...
                *tand(delta)^2);
            
            numerator = machIn^2 - 1 + 2*lambda*cos((4*pi*alpha +...
                acos(chi))/3);
            denominator = 3*(1 + gammaMinusOneOverTwo*machIn^2)...
                *tand(delta);
            
            angle = atand(numerator/denominator);
        end
        
        function angle = turningAngle(machIn, theta, gamma)
            % Calculates the turn angle of the flow, based on the Mach #
            % before the shock, the shock/wave angle, and the specific heat
            % ratio.
            % (V.C29a from slides)
            
            machInSinTheta = machIn .* sind(theta);
            
            numerator = (2/tand(theta)) * (machInSinTheta^2 - 1);
            denominator = machIn^2 * (gamma + cosd(2*theta)) + 2;
            angle = atand(numerator / denominator);
        end
        
        function ratio = pRatio(machIn, theta, gamma)
            % Calculates the pressure ratio based on the Mach # before the
            % shock, the shock/wave angle, and the specific heat ratio.
            % (V.C25 from slides)
            
            machInSinTheta = machIn .* sind(theta);
            
            ratio = ((2 .* gamma) ./ (gamma + 1)) .* machInSinTheta.^2 ...
                - ((gamma - 1) ./ (gamma + 1));
        end
        
        function ratio = vnRatio(machIn, theta, gamma)
            % Calculates the ratio between the normal components of the
            % velocity before the shock to after the shock.
            % NOTE: it's v1n / v1n2, NOT v2n / v1n
            % (V.C26 from slides)
            
            machInSinTheta = machIn .* sind(theta);
            
            numerator = (gamma + 1) .* machInSinTheta.^2;
            denominator = (gamma - 1) .* machInSinTheta.^2 + 2;
            
            ratio = numerator ./ denominator;
        end
        
        function ratio = rhoRatio(machIn, theta, gamma)
            % Calculates the ratio between the density across the oblique
            % shock based on the Mach # before the shock, the shock/wave
            % angle, and the specific heat ratio. This is equivalent to the
            % vnRatio.
            % (V.C26 from slides)
           
           ratio = OSC.vnRatio(machIn, theta, gamma);
        end
        
        function ratio = TRatio(machIn, theta, gamma)
            % Calculates the ratio between the static temperature across 
            % the oblique shock based on the Mach # before the shock, the
            % shock/wave angle, and the specific heat ratio.
            % (V.C27 from slides)
            
            machInSinTheta = machIn .* sind(theta);
            gammaMinusOneOverTwo = (gamma - 1) ./ 2;
            twoGammaOverGammaMinusOne = 2 .* gamma ./ (gamma - 1);
            
            numeratorFirstTerm = 1 + (gammaMinusOneOverTwo...
                .* machInSinTheta.^2);
            numeratorSecondTerm = (twoGammaOverGammaMinusOne...
                .* machInSinTheta.^2) - 1;
            
            numerator = numeratorFirstTerm .* numeratorSecondTerm;
            denominator = machInSinTheta.^2 .* (gamma + 1).^2 ...
                ./ (2.*(gamma - 1));
            
            ratio = numerator ./ denominator;
        end
        
        function ratio = P0Ratio(machIn, theta, gamma)
            % Calculates the ratio between the stangation pressures across
            % the oblique shock based on the Mach # before the shock, the
            % shock/wave angle, and the specific heat ratio.
            % (V.C28 from slides)
            
            machInSinTheta = machIn .* sind(theta);
            
            firstTermNumerator = ((gamma + 1) ./ 2) .* machInSinTheta.^2;
            firstTermDenominator = 1 + ((gamma - 1) ./ 2)...
                .* machInSinTheta.^2;
            firstTermExp = gamma ./ (gamma - 1);
            firstTerm = (firstTermNumerator ./ firstTermDenominator) ...
                .^ firstTermExp;
            
            twoGammaOverGammaPlusOne = (2 .* gamma) ./ (gamma + 1);
            gammaMinusOneOverGammaPlusOne = (gamma - 1) ./ (gamma + 1);
            secondTermArg = twoGammaOverGammaPlusOne.*machInSinTheta.^2 ...
                - gammaMinusOneOverGammaPlusOne;
            secondTermExp = 1 ./ (1 - gamma);
            secondTerm = secondTermArg .^ secondTermExp;
            
            ratio = firstTerm .* secondTerm;
        end
        
        function [machN,machT,vN,vT] = obliqueShockTransformInitial(...
                machIn,vIn,theta)
            % Calculates the normal and tangential components of the Mach #
            % and velocity before the oblique shock.
            
            machN = machIn*sind(theta);
            machT = machIn*cosd(theta);
            vN = vIn*sind(theta);
            vT = vIn*cosd(theta);
        end
        
        function [machN,machT,vN,vT] = obliqueShockTransformFinal(...
                machOut,vOut,theta,delta)
            % Calculates the normal and tangential components of the Mach #
            % and velocity after the oblique shock.
            
            machN = machOut*sind(theta - delta);
            machT = machOut*cosd(theta - delta);
            vN = vOut*sind(theta - delta);
            vT = vOut*cosd(theta - delta);
        end
        
        function M2 = machNumPostShock(machIn, gamma, theta, delta)
            % Calculates the Mach # After an oblique shock based on the
            % Mach # before, the specific heat ratio, the shock angle
            % (theta), and the turn angle (delta)
            % (V.C24 from slides)
            
            M1n = machIn .* sind(theta);
            
            % Plug in the M1 normal component and gamma to get the normal
            % component of M2. 
            M2n = NSC.machNumPostShock(M1n, gamma);
            
            % Get the overall Mach Number
            M2 = M2n ./ sind(theta - delta);
        end
        
    end
end