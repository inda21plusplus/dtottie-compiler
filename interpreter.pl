%implement the jumps and the interpreter is done.

translate(C) :-
    is_list(C),
    memory_zone(Memory),
    translate(C, C, Memory, 0).

translate(_,[],_,_).
translate(C,["FUCK"|T],Memory, X) :-
  change_mem_value(add, Memory, X, 1, Memory2),
  translate(C,T,Memory2,X), !.
translate(C,["SHIT"|T],Memory, X) :-
  change_mem_value(add, Memory, X, -1, Memory2),
  translate(C,T,Memory2,X), !.
translate(C,["AAAH"|T], Memory,X) :-
  memory_size(Size),
  X2 is X + 1,
  X3 is X2 mod Size,
  translate(C,T,Memory, X3), !.
translate(C,["AAAAGH"|T], Memory,X) :-
  memory_size(Size),
  X2 is X - 1,
  X3 is X2 mod Size,
  translate(C,T,Memory, X3), !.
translate(C,["OW"|_],Memory,X) :-
  nth0(X, Memory, N),
  N = 0,
  jump(C,1,C2),
  translate(C,C2,Memory,X), !.
translate(C,["OWIE"|_], Memory,X) :-
  nth0(X, Memory, N),
  N = 0,
  jump(C,-1,C2),
  translate(C,C2,Memory,X), !.
translate(C, ["!!!!!!"|T], Memory, X) :-
  nth0(X,Memory,Code),
  char_code(L,Code),
  write(L),
  translate(C,T,Memory,X), !.
translate(C, ["WHAT?!"|T], Memory, X) :-
  get_char(Character),
  char_code(Character,Code),
  change_mem_value(set, Memory, X, Code, Memory2),
  translate(C,T,Memory2,X), !.


%memory management
memory_size(30000).
cell_size(256).

memory_zone(Memory) :-
  memory_size(Size),
  length(Memory, Size),
  maplist(=(0), Memory).

%change memory locations
change_mem_value(add, [H|T], 0, Value, [NewValue|T2]) :-
  TempValue is H + Value,
  cell_size(CellSize),
  Max is CellSize - 1,
  NewValue is TempValue mod Max.
change_mem_value(set, [_|Tail],0, Value, [Value|Tail]).
change_mem_value(Type, [H|T], Index, Value, [H|R]) :-
  Index > 0,
  NewIndex is Index - 1,
  change_mem_value(Type, T, NewIndex, Value, R).

%jump in memory
jump(C, 0, C).
jump([_|T], I, R) :-
  I > 0,
  I2 is I - 1,
  jump(T,I2,R).
