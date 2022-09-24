open! Core

type t =
  | Maki of
      { hand : Side.t
      ; level : Level.t
      }
[@@deriving equal, compare, enumerate, hash, sexp_of]
