function goalOneCruise

    %static parameters
    %Ta = 220   K;
    %pa = 29000 Pa;
    M = 0.86;
    fab = 0.02;
    pi_ab = .97;


    i=2;

    STarray = [];
    TSFCarray = [];

    turbofanInstance = turbofan(29000, 220);

    for f=.018 : .002 : .02
        for b=0.1 : 0.05 : 0.20
            for pi_c = 10 : 1 : 40
                for pi_f=1.1 : 0.05 : 1.5
                    for beta= 5 : 0.5 : 10


                    turbofanInstance = turbofanInstance.engineCalc(f, b, M, pi_f, beta, pi_c, fab, pi_ab);

                    

                    STarray(i) = turbofanInstance.specificThrust;
                    TSFCarray(i) = turbofanInstance.thrustSpecficFuelConsumption;

        
                    if(STarray(i) > 859 & STarray(i) < 861)

                        if(TSFCarray(i) < TSFCarray(i-1))
                            tsfcFinal = TSFCarray(i);
                            stFinal = STarray(i);
                            fFinal = f;
                            bFinal = b;
                            pi_cFinal = pi_c;
                            pi_fFinal = pi_f;
                            betaFinal = beta;

                            disp(fFinal)
                            disp(bFinal)
                            disp(pi_cFinal)
                            disp(pi_fFinal)
                            disp(betaFinal)
                            disp(tsfcFinal)

%                             if(eta(i+1) > eta(i))
%                                 etaFinal = eta(i+1);
%                             end

                        end

                    end

                    i=i+1;
                    
                    disp(i)

                    end

                end

            end

        end

    end

    disp('----------------------')
                            disp(fFinal)
                            disp(bFinal)
                            disp(pi_cFinal)
                            disp(pi_fFinal)
                            disp(betaFinal)
                            disp(tsfcFinal)
                            disp(stFinal)


%     disp('Fuel Air Ratio:' + fFinal)
%     disp('Bleed Ratio' + bFinal)
%     disp('Compresssion Ratio' + pi_cFinal)
%     disp('Fan Ratio' + pi_fFinal)
%     disp('Bypass Ratio' + betaFinal)
%     disp('Thrust Specific Fuel Consumption' + tsfcFinal)
%     disp('Specific Thrust' + stFinal)

end

