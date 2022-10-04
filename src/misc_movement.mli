open! Core

(** A list of movements that appear in poomsae but are not classified
   as blocks, or attaks. *)

module Kind : sig
  type t = Bo_Joumok [@@deriving equal, compare, enumerate, hash, sexp_of]

  include Comparable.S_plain with type t := t
end

type t = Bo_Joumok [@@deriving equal, compare, enumerate, hash, sexp_of]

val kind : t -> Kind.t

(** Changes the hand *)
val mirror : t -> t
