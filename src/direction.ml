open! Core

type t =
  | North
  | West
  | East
  | South
[@@deriving equal, compare, enumerate, hash, sexp_of]
