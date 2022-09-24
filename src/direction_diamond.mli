open! Core

(** A container indexed by all 4 cardinal directions. *)

type 'a t =
  { north : 'a
  ; west : 'a
  ; east : 'a
  ; south : 'a
  }
[@@deriving equal, compare, enumerate, fields, hash, sexp_of]

include Container.S1 with type 'a t := 'a t
include Applicative with type 'a t := 'a t

val north : 'a t -> 'a
val west : 'a t -> 'a
val east : 'a t -> 'a
val south : 'a t -> 'a
val get : 'a t -> Direction.t -> 'a
val map_direction : 'a t -> f:(Direction.t -> 'a -> 'a) -> 'a t
