type t =
  | Left
  | Right
[@@deriving equal, compare, enumerate, hash, sexp_of]

let mirror = function
  | Left -> Right
  | Right -> Left
;;
