################################################################################
# CONSTANTS.jl
# TYPE: (1) Model files - required
# DESCRIPTION: General constants. 
# 
# Eryn Cangi
# Created November 2021
# Currently tested for Julia: 1.8.5
################################################################################

#                              Universal constants
# ===============================================================================
const kB_MKS = 1.38e-23;        # J/K - needed for saturation vapor pressure empirical equation.
const kB = 1.38e-16;            # erg/K
const bigG = 6.67e-8;           # dyne-cm^2/g^2
const mH = 1.67e-24;            # g 
const q = -4.8032e-10            # statcoulomb (cm^1.5 g^0.5 s^-1)
const density_water_cgs = 0.997408  # used mostly for conversions
const s_per_yr = 3.154e7
const SMOW = 1.6e-4             # Standard mean ocean water

# Polarizability from NIST. Experimental values from: https://cccbdb.nist.gov/pollistx.asp
# Calculations for species not available in experiment from: https://cccbdb.nist.gov/polcalc2x.asp
# Deuterated species not listed in either are estimated by me to be the same as their H-bearing analogue.
# I used the calcualtions that use "Density functional", "aug-cc-PVDZ", and "mPW1PW91" 
# because that was the method that gave the closest answer for HD to the experimental value. 
# I have no idea what any of it means or whether it's reasonable. I'm not a quantum chemist.
# Values are given in cm^3
const polarizability = Dict(# Values available from experiment
                            :Ar=>1.664e-24, :C=>1.760e-24,  :CO=>1.953e-24,  :CO2=>2.507e-24, 
                            :H=>0.667e-24,  :H2=>0.8023e-24, # H2 source: Yoon 2010 <-- Kusakabe+ 2004, Phys. Rev. A
                            :H2O=>1.501e-24, :HCN=>2.593e-24, :HD=>0.7976e-24, # HD source: Yoon 2010 <-- Kusakabe+ 2004, Phys. Rev. A
                            :N=>1.1e-24,    :N2=>1.710e-24, :N2O=>2.998e-24, :NO=>1.698e-24, :NO2=>2.910e-24, 
                            :O=>0.802e-24,  :O2=>1.59e-24,  :O3=>3.079e-24, 

                            # Values from calculation
                            :CH=>2.108e-24,   :CN=>3.042e-24,   :D=>0.713e-24, 
                            :H2O2=>2.143e-24, :HCO=>2.505e-24,  :HDO=>1.358e-24, :HNO=>2.123e-24, 
                            :HO2=>1.858e-24,  :HOCO=>3.224e-24, :NH=>1.418e-24,  :NH2=>1.752e-24, 
                            :OH=>1.020e-24,   :OD=>1.020e-24,

                            #Chlorine species; ClO, DCl and ClCO are place holders
                            :HCl=> 2.515e-24, :Cl=> 2.180e-24, :ClO=> 2.108e-24, :ClCO=>2.108e-24, 
                            :Cl2=>4.610e-24, :DCl=>2.108e-24, 
    
                            #Sulfur species SO and H2SO4 are a place holder
                            :S=> 2.900e-24, :SO=> 2.108e-24, :SO2=> 3.882e-24, :SO3=>4.297e-24,:H2SO4=>4.297e-24, :HDSO4=>4.297e-24,

                            # Assumed same as hydrogen analogue
                            :DCO=>2.505e-24, :DO2=>1.858e-24, :DOCO=>3.224e-24, :HDO2=>2.143e-24, :O1D=>0.802e-24, 

                            # Assumed same as non-excited version
                            :Nup2D=>1.710e-24,

                            #Eb Species
                            #Hydrocarbons
                            :C2=>5.763e-24, :C2H=>3.33e-24, :C2H2=>3.487e-24, :C2H3=>2.948E-24, :C2H4=>4.188E-24, :C3H3=>4.310E-24, 
                            :CH=>1.428E-24, :CH2=>1.293E-24, :e3CH2=>1.212E-24, :CH3=>1.561E-24, :CH3O=>2.653E-24, :CH4=>2.448E-24,
                            
                            :C2N=>5.015E-24, :C2N2=>5.015E-24, :C3N=>5.015E-24, :CN2=>2.751E-24, :HNC=>2.034E-24, :H2CN=>2.243E-24,

                            :NH3=>2.103E-24, :N2H2=>1.949E-24, :N2D=>1.710e-24, :CHCN=>3.308E-24, :CH2CN=>3.308E-24, 

                            :CH2NH=>2.555E-24,
                            :H2CO=>2.770E-24

                            #Couldnt find values for C2N, C3N, CH2CN
                            #Treating CN2 as cyanoimogen (NCN)
                            #H2CN is the Dihydrogen Cyanide radical

                            # IONS! Because we should include sum over ions per Garcia Munoz 2007.
                            #:H2pl=>4.69e-25, 
                            )

const molmass = Dict(:H=>1, :Hpl=>1, 
                     :H2=>2, :H2pl=>2, :D=>2, :Dpl=>2, 
                     :HD=>3, :HDpl=>3, :H3pl=>3, 
                     :H2Dpl=>4, 
                     :HD2pl=>5, 
                     :C=>12, :C2=>24, :C2pl=>24,:C2H=>25, :C2H2=>26, :C2H3=>27, :C2H4=>28, :C3H3=>39, :Cpl=>12,  
                     :CH=>13, :CH2=>14, :e3CH2=>14, :CH3=>15, :CH3pl=>15, :CH3O=>31,:CH4=>16, :CH4pl=>16, :CHpl=>13, 
                     :N=>14, :N4S=>14, :N2D=>14, :O3P=>16,:N2=>28, :Npl=>14, :HNC=>27, :H2CN=>28,
                     :NH=>15, :NHpl=>15,
                     :NH2=>16, :NH3=>17,:NH2pl=>16, :N2H2=>30, :O=>16, :O1D=>16, :Opl=>16, 
                     :NH3pl=>17, :OH=>17, :OHpl=>17, 
                     :H2O=>18, :OD=>18, :ODpl=>18, :H2Opl=>18, 
                     :HDO=>19, :HDOpl=>19, :H3Opl=>19,
                     :H2DOpl=>20,
                     :CN=>26, :C2N=>38, :C3N=>50, :C2N2=>52, :CNpl=>26, :CN2=>40,
                     :HCN=>27, :HCNpl=>27, :CHCN=>39, :CH2CN=>40,
                     :CO=>28, :COpl=>28, :HCNHpl=>28, :CH2NH=>29, :N2=>28, :Nup2D=>28, :N2pl=>28, 
                     :H2CO=>30, :HCO=>29, :HCOpl=>29, :HOCpl=>29, :N2Hpl=>29, 
                     :DCO=>30, :DCOpl=>30, :DOCpl=>30, :NO=>30,  :NOpl=>30, :N2Dpl=>30, 
                     :HNO=>31, :NCO=>42, :HNCO=>43, :HNOpl=>31, 
                     :O2=>32, :O2pl=>32, 
                     :HO2=>33, :HO2pl=>33, 
                     :DO2=>34, :H2O2=>34, 
                     :HDO2=>35,
                     :Ar=>40, :Arpl=>40, 
                     :ArHpl=>41, 
                     :ArDpl=>42,
                     :O3P=>16, 
                     :CO2=>44, :CO2pl=>44, :N2O=>44, :N2Opl=>44, 
                     :HOCO=>45, :HCO2pl=>45, :HN2Opl=>45,  
                     :DOCO=>46, :DCO2pl=>46, :NO2=>46, :NO2pl=>46,
                     :O3=>48, :HCl=>36, :Cl=>35, :ClO=>51, :ClCO=>63, :Cl2=>71, :DCl=>37,
                     :S=>32, :SO=>48, :SO2=>64, :SO3=>80, :H2SO4=>98, :HDSO4=>99
                     )

const collision_xsect = Dict(:H=>4e-15, # Zhang 2009
                             :D=>4.5e-15, 
                             :H2=>4.5e-15, # assume same as D since they have the same mass...
                             :HD=>5e-15 # assumption that adding a proton or neutron adds 0.5e-15 to the cross section...
                            ) # Units of cm^2; Bohr radius 8.79e-17


#                                 Float types
# ===============================================================================
# This section was introduced by Mike to attempt to solve issues with convergence. 
# However, the model is now running without use of doubles, so this may be removable,
# but has been left just in case it's ever needed again. Use of Doubles increases
# model run time but potentially delivers higher stability in complex simulations. 
# This is probably NOT the best place for it, but is the minimally annoying thing to 
# do after a major reorganization April 2024 by Eryn. This way it can be shared between
# the photochemistry module and the converge_new_file.jl code. 

ftype_ncur = Float64  # used to store n_current values
    # OPTIONS: Float64, Double64   
ftype_chem = Float64 #Double64 #  used to compute chemical reaction rates and chemical jacobian
    # OPTIONS: Float64, Double64   