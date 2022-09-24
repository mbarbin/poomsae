open! Core

type t =
  { direction : Direction.t
  ; position : Position.t
  ; technique : Technique.t
  }
[@@deriving equal, compare, enumerate, hash, sexp_of]
