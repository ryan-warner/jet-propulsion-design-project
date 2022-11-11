# Jet and Rocket Propulsion Design Project

## How it Works

### Inputs:
- Ambient temperature
- Ambient pressure
- Fuel storage pressure
- Flight Mach
- Compressor stagnation pressure ratio
- Fan stagnation pressure ratio
- Fuel/air mixtures for the main burner and the afterburner
- Bypass ratio
- Bleed ratio

### Flow Properties:
- Average specific heat ratios and gas molecular weights across each component
- Adiabatic efficiencies for the nozzles, diffuser, and fuel pump; in addition to ram pressure recovery for the diffuser
- Polytropic efficiencies for the fan, compressor, and turbines
- Combusiton efficiencies and stagnation pressure ratios for the main burner and the afterburner
- Fuel heating value and fuel density
    - Same fuel for ALL combustors
- Specific drag loss of the bypass fan
- Pressure loss function of the virtual nozzle mixer

### Constraints:
- Temperature limits
    - Main burner
    - Afterburner
- Maxmimum allowed bleed fraction

### Outputs:
- Air speed
- Exit temperature
- Exit pressure
    - required for each component
- Fuel rump exit pressure
- Power per unit mass core air flowrate
    - Fan 
    - Compressor
    - Main turbine
    - Fan turbine
    - Fuel pump
- Exhaust Velocity
    - Core nozzle
    - Fan nozzle
    - Combined nozzle
- Effective specific thrust
    - Must account for additional drag
- TSFC, based on above
- Efficiencies
    - Propulsive
    - Thermal
    - Overall
- Max Allowed FA ratios based on max temperature limits

## To Do

- [ ] Identify an engine configuration and design parameters for each of the four missions that achieves the desired ST levels, while maintaining high efficiency
- [ ] Choose a single engine for each vehicle type, taking into account both flight conditions and anything else you deem important
- [ ] Determine the maximim thrust and corresponding TSFC for the above engine, at both flight conditions

## Engine Stages

### Inlet/Diffuser
### Compressor
### Combustor
### Turbine
### Turbine Cooling
### Nozzle
#### Hot Nozzle
#### Cold Nozzle
#### Combined Nozzle
### Afterburner