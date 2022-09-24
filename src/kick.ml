open! Core

type t =
  | Ap_Tchagui of
      { foot : Side.t
      ; level : Level.t
      }
[@@deriving equal, compare, enumerate, hash, sexp_of]
