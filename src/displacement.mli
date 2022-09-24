open! Core

type t [@@deriving equal, sexp_of]

val origin : t
val move : t -> Movement.t -> t
