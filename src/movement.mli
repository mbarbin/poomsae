open! Base

type t =
  { direction : Direction.t
  ; position : Position.t
  ; technique : Technique.t
  }
[@@deriving equal, compare, enumerate, hash, sexp_of]

(** Reverse the hands and the feet on the position and technique, but leave the
    direction unchanged. *)
val mirror : t -> t
