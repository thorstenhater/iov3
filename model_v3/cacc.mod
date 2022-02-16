TITLE Mod file for component: Component(id=cacc type=ionChannelHH)
COMMENT
    This NEURON file has been generated by org.neuroml.export (see https://github.com/NeuroML/org.neuroml.export)
         org.neuroml.export  v1.7.0
         org.neuroml.model   v1.7.0
         jLEMS               v0.10.2
ENDCOMMENT
NEURON {
    SUFFIX cacc
    NONSPECIFIC_CURRENT icl
    USEION ca READ cai,cao VALENCE 2
    : USEION cl WRITE icl VALENCE 1 ? Assuming valence = 1; TODO check this!!
    RANGE gion                           
    RANGE gmax                              : Will be changed when ion channel mechanism placed on cell!
    RANGE conductance                       : parameter
    RANGE g                                 : exposure
    RANGE fopen                             : exposure
    RANGE m_instances                       : parameter
    RANGE m_SEC                             : parameter
    RANGE m_tau                             : exposure
    RANGE m_inf                             : exposure
    RANGE m_fcond                           : exposure
    RANGE m_q                               : exposure
    RANGE m_steadyState_VOLT_SCALE          : parameter
    RANGE m_steadyState_CONC_SCALE          : parameter
    RANGE m_steadyState_x                   : exposure
    RANGE m_steadyState_V                   : derived variable
    RANGE m_steadyState_ca_conc             : derived variable
    RANGE conductanceScale                  : derived variable
    RANGE fopen0                            : derived variable
}
UNITS {
    (nA) = (nanoamp)
    (uA) = (microamp)
    (mA) = (milliamp)
    (A) = (amp)
    (mV) = (millivolt)
    (mS) = (millisiemens)
    (uS) = (microsiemens)
    (molar) = (1/liter)
    (kHz) = (kilohertz)
    (mM) = (millimolar)
    (um) = (micrometer)
    (umol) = (micromole)
    (S) = (siemens)
}
PARAMETER {
    gmax = 0  (S/cm2)                       : Will be changed when ion channel mechanism placed on cell!
    conductance = 1.0E-5 (uS)
    m_instances = 1 
    m_SEC = 1000 (ms)
    m_steadyState_VOLT_SCALE = 1 (mV)
    m_steadyState_CONC_SCALE = 1000000 (mM)
}
ASSIGNED {
    gion   (S/cm2)                          : Transient conductance density of the channel? Standard Assigned variables with ionChannel
    v (mV)
    celsius (degC)
    temperature (K)
    ecl (mV)
    m_steadyState_V                        : derived variable
    m_steadyState_ca_conc                  : derived variable
    m_steadyState_x                        : derived variable
    m_inf                                  : derived variable
    m_tau (ms)                             : derived variable
    m_q                                    : derived variable
    m_fcond                                : derived variable
    conductanceScale                       : derived variable
    fopen0                                 : derived variable
    fopen                                  : derived variable
    g (uS)                                 : derived variable
}
STATE {
}
INITIAL {
    ecl = -43.0
    temperature = celsius + 273.15
    rates(v, cai)
    rates(v, cai) ? To ensure correct initialisation.
}
BREAKPOINT {
    rates(v, cai)
    ? DerivedVariable is based on path: conductanceScaling[*]/factor, on: Component(id=cacc type=ionChannelHH), from conductanceScaling; null
    ? Path not present in component, using factor: 1
    conductanceScale = 1 
    ? DerivedVariable is based on path: gates[*]/fcond, on: Component(id=cacc type=ionChannelHH), from gates; Component(id=m type=gateHHInstantaneous)
    ? multiply applied to all instances of fcond in: <gates> ([Component(id=m type=gateHHInstantaneous)]))
    fopen0 = m_fcond ? path based, prefix = 
    fopen = conductanceScale  *  fopen0 ? evaluable
    g = conductance  *  fopen ? evaluable
    gion = gmax * fopen 
    icl = gion * (v - ecl)
}
PROCEDURE rates(v, cai) {
    LOCAL caConc
    caConc = cai
    m_steadyState_V = v / m_steadyState_VOLT_SCALE ? evaluable
    m_steadyState_ca_conc = caConc /  m_steadyState_CONC_SCALE ? evaluable
    m_steadyState_x = 1 / ( 1  +  exp((3.7 - ( m_steadyState_ca_conc *1e6))/0.9)) ? evaluable
    ? DerivedVariable is based on path: steadyState/x, on: Component(id=m type=gateHHInstantaneous), from steadyState; Component(id=null type=m_inf)
    m_inf = m_steadyState_x ? path based, prefix = m_
    m_tau = 0 *  m_SEC ? evaluable
    m_q = m_inf ? evaluable
    m_fcond = m_q ^ m_instances ? evaluable
}
