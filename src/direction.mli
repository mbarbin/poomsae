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

module Axis : sig
  type t =
    | West_East
    | North_South
  [@@deriving equal, compare, enumerate, hash, sexp_of]
end

val axis : t -> Axis.t
val group_by_axis : t list -> t list list
