NEURON {
  SUFFIX kdr
  NONSPECIFIC_CURRENT ik
  RANGE conductance
}

PARAMETER {
  conductance = 0.00001 (uS)
}

STATE { gates_n_q }

INITIAL {
  LOCAL gates_n_steadyState_x

  gates_n_steadyState_x = (1 + exp(-0.1 * (3 + v)))^-1
  gates_n_q = gates_n_steadyState_x
}

DERIVATIVE dstate {
  LOCAL gates_n_steadyState_x, gates_n_timeCourse_t

  gates_n_steadyState_x = (1 + exp(-0.1 * (3 + v)))^-1
  gates_n_timeCourse_t = 5 + 47 * exp(-0.0011111111111111111 * (-50 + -1 * v))
  gates_n_q' = (gates_n_steadyState_x + -1 * gates_n_q) * gates_n_timeCourse_t^-1
}

BREAKPOINT {
  SOLVE dstate METHOD cnexp
  LOCAL gates_n_fcond, g, ek

  ek = -75
  gates_n_fcond = gates_n_q * gates_n_q * gates_n_q * gates_n_q
  g = conductance * gates_n_fcond
  ik = 1000 * g * (v + -1 * ek)
}

