In this project, a built-in self-test is designed for BCD adder as the circuit under test(CUT). 
For generating patterns for testing, a pseudo-random pattern generator is designed which is known as Cellular Automata and it uses cell implementing rule 150 and cell 90 alternatively.
Random patterns from the Cellular Automata are fed in the BCD Adder and for analyzing the response Multiple Input Signature Register is designed (Output Analyser).
Output Analyser calculates the signature based on the results of the BCD adder and a good signature is stored. If a fault occurs in the circuit the value of the signature changes and the fault gets detected.
