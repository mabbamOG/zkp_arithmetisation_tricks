# zkp_arithmetisation_tricks
tricks for polynomial arithmetisation, proven in Z3

each trick contains an efficient set of arithmetisation constraints for a computation.
a computation can be an arbitrarily complex set of operations defined on any given variable,
and the arithmetisation is the process of converting such computation into a sequence of constraints,
or relations, that only abide by * and + operations and equal 0. these constraints bind together
variables of the circuit. they are fundamental in the usage of zkps, such as zkEVMs.

each file is of the form `filename.z3` and is expressed in SMT-Lib syntax supported by the Z3 SAT Solver.
the constraints are expressed in simple lines, but if they are too complex usually i accompany them with a comment.
you may prove a set of constraints by installing the Z3 SAT Solver and running `z3 filename.z3`, and it should
output `unsat` to declare that it was not able to find a counterargument to our claim, meaning that our constraint
cannot be unsound.
