open! Core

(** A type used to refer to a particular hand or foot in a technique. *)

type t =
  | Left
  | Right
[@@deriving equal, compare, enumerate, hash, sexp_of]

(** Return the opposite of the side supplied. *)
val mirror : t -> t
