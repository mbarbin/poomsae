open! Core

type t =
  | Ap_Seugui of { front_foot : Side.t }
  | Ap_Koubi_Seugui of { front_foot : Side.t }
  | Dwitt_Koubi of { front_foot : Side.t }
[@@deriving equal, compare, enumerate, hash, sexp_of]
