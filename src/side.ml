open! Core

type t =
  | Left
  | Right
[@@deriving equal, compare, enumerate, hash, sexp_of]
