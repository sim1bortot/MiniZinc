%
% Latin squares in Minizinc
%
% http://en.wikipedia.org/wiki/Latin_square:
% """
% A Latin square is an n × n table filled with n different symbols in such 
% a way that each symbol occurs exactly once in each row and exactly once 
% in each column. 
%
% è una sorta di sudoku
% """
% 


include "globals.mzn";

int: n = 10;
array[1..n, 1..n] of var 1..n: x;

solve satisfy;
%solve :: int_search([ x[i, j] | i, j in 1..n], 
%        first_fail, indomain_min, complete) satisfy;

% assicura che ogni simbolo appaia una sola volta in ogni colonna, scorre ogni colonna k
constraint
 forall(i,j,k in 1..n where i < j)(
           x[i,k] != x[j,k]);
% assicura che ogni simbolo appaia una sola volta in ogni riga, scorre ogni riga k
constraint
  forall(i,j,k in 1..n where i < j)(
      x[k,i] != x[k,j]);
     

% modo moderno e più efficiente per scrivere i due vincoli precedenti
constraint
   forall(i in 1..n) (
       all_different([ x[i, j] | j in 1..n])      :: domain /\ %Per ogni riga i, crea un array con tutti gli elementi di quella riga e impone che siano tutti diversi (regola delle righe).
       all_different([ x[j, i] | j in 1..n])      :: domain % Per ogni colonna i, crea un array con tutti gli elementi di quella colonna e impone che siano tutti diversi (regola delle colonne).
   );
   
% vincoli non necessari ma utili per trovare una soluzione più velocemente, sono vincoli per "rompere la simmetria"
constraint x[1,1]=1; % è ridondante se c'è il vincolo sotto
constraint forall(i in 1.. n)(x[1,i]=i); % fissando la prima riga si riduce drasticamente il numero di soluzioni che il solver deve esplorare

%x[1,1] < x[1,n];
   
%   /\
%   x[1,1]=1
%    /\ % symmetry breaking: first row is 1..n and first column is 1..n
      % i.e. the "reduced latin square"
%constraint   
%  forall(i in 1..n) ( 
%      x[1,i] = i /\
%      x[i,1] = i
%   );
%);

output 
%[show(x)];
[
  if j = 1 then "\n" else " " endif ++
  show(x[i,j])
  | i,j in 1..n
] ++ ["\n"];
