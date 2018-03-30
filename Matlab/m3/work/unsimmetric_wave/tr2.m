syms R1 R2 M l A1 A2 fi
eqn1 = cos(A1) == (R1^2+M^2-l^2)/(2*R1*M);
AA1 = solve(eqn1, A1);
eqn2 = cos(A2) == (R2^2+M^2-l^2)/(2*R2*M);
AA2 = solve(eqn2, A2);
eqn3 = cos( AA1(1) + AA2(1) ) == (R1^2+R2^2-4*l^2)/(2*R1*R2);
AA = solve(eqn3, M);