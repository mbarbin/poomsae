open! Base

type t =
  | Ale
  | Montong
  | Eulgoul
[@@deriving equal, compare, enumerate, hash, sexp_of]
