open! Base

type t =
  { direction : Direction.t
  ; position : Position.t
  ; technique : Technique.t
  }
[@@deriving equal, compare, enumerate, hash, sexp_of]

let mirror { direction; position; technique } =
  { direction
  ; position = Position.mirror position
  ; technique = Technique.mirror technique
  }
;;
