open! Core

module Kind : sig
  type t =
    | Ap_Tchagui
    | Yop_Tchagui
  [@@deriving equal, compare, enumerate, hash, sexp_of]
end

type t =
  | Ap_Tchagui of
      { foot : Side.t
      ; level : Level.t
      }
  | Yop_Tchagui of
      { foot : Side.t
      ; level : Level.t
      }
[@@deriving equal, compare, enumerate, hash, sexp_of]

val kind : t -> Kind.t
