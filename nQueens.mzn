% Use this editor as a MiniZinc scratch book
include "globals.mzn";
par int: n = 40;     % n x n board,  n = number of queens

array [1..n] of var 1..n: q;

constraint
  forall(i, j in 1..n where i < j) (
    q[i] != q[j] /\            % same line
    %j - i != abs(q[i] - q[j])
    q[i] + i != q[j] + j /\
    q[i] - i != q[j] - j
  );
  
% alldifferent constraint è più utile quando ci sono poche soluzioni, qua ce ne sono tante quindi non cambia molto 
  
% alternative ai vincoli sopra
%constraint alldifferent(q) ::domain;                   % ogni regina in una colonna diversa, sostituisce q[i] != q[j]
%constraint alldifferent(i in 1..n)(q[i] + i) ::domain; % ogni regina in una diagonale principale diversa
%constraint alldifferent(i in 1..n)(q[i] - i) ::domain; % ogni regina in una anti-diagonale principale diversa

%solve satisfy;     % lascia al solver totale libertà di scelta su come cercare una soluzione

% imponiamo una strategia di ricerca specifica e dettagliata su come cercare una soluzione
%solve :: int_search(q, input_order, indomain_min, complete);

solve :: int_search(q, first_fail, indomain_min, complete) satisfy;

%output [ show(q) ];

output [
  if fix(q[j]) == i then "Q" else "." endif ++
  if j == n then "\n" endif
  | i, j in 1..n
];