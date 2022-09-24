open! Core

(** When seen from above, the performer is moving within a 2
   dimensional space. These values are used to encode the main
   direction of the movements. *)

type t =
  | North
  | West
  | East
  | South
[@@deriving equal, compare, enumerate, hash, sexp_of]
