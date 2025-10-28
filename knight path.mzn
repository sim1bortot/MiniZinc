% Knight Tour 
% (Finds (if it exists) a path for a knight that visit each square exactly once)

include "globals.mzn";

par int: n;

% Matrix for representing the board, n row and n colums of values from 1 to nxn
array [1..n, 1..n] of var 1..n*n: b;

% Visit each square exactly once
constraint
    all_different([b[i,j] | i in 1..n, j in 1..n]);
    
% Simmetry breaking
constraint
    b[1,1] = 1;

% Logic to do a knight's step
constraint
    forall(i in 1..n, j in 1..n, k in 2..n*n)(
    (b[i,j] = k) ->
        (
            (i+2 <= n /\ j+1 <= n /\ b[i+2,j+1] = k-1) \/
            (i+2 <= n /\ j-1 >= 1 /\ b[i+2,j-1] = k-1) \/
            (i+1 <= n /\ j+2 <= n /\ b[i+1,j+2] = k-1) \/
            (i+1 <= n /\ j-2 >= 1 /\ b[i+1,j-2] = k-1) \/
            (i-2 >= 1 /\ j+1 <= n /\ b[i-2,j+1] = k-1) \/
            (i-2 >= 1 /\ j-1 >= 1 /\ b[i-2,j-1] = k-1) \/
            (i-1 >= 1 /\ j+2 <= n /\ b[i-1,j+2] = k-1) \/
            (i-1 >= 1 /\ j-2 >= 1 /\ b[i-1,j-2] = k-1)
        )
    );

                   
solve :: int_search(b, 
% input_order, 
% first_fail,
 most_constrained,
 indomain_min, 
% complete
) satisfy;
%output [ show(b)];

output [
  show2d(b)
];