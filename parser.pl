main(L) :- read_file('sourcefile.scream',X), length(X,N), clone(X,L), verifier(N,X,L), write(L).

read_file(File, List) :-
  open(File, read, Stream),
  read_line(Stream, List),
  close(Stream).

read_line(Stream, List) :-
  read_line_to_codes(Stream, Line),
  atom_codes(A, Line),
  atomic_list_concat(As, ' ', A),
  maplist(atom_string, As, List).


match("AAAH").
match("AAAGH").
match("FUCK").
match("SHIT").
match("!!!!!!").
match("WHAT?!").
match("OW").
match("OWIE").

verifier(0,[],_).
verifier(N,[H|List], L) :-
  N1 is N-1,
  write(List),
  (match(H) -> clone(L,X); delete(H,L,X), write('incorrect symbol encountered')),
  verifier(N1,List,X).

clone([],[]).
clone([H|T],[H|Z]):- clone(T,Z).
