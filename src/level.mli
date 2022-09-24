open! Core

type t =
  | Ale
  | Momtong
  | Eulgoul
[@@deriving equal, compare, enumerate, hash, sexp_of]
