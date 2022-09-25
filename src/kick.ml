open! Core

module Kind = struct
  module T = struct
    type t =
      | Ap_Tchagui
      | Yop_Tchagui
    [@@deriving equal, compare, enumerate, hash, sexp_of]
  end

  include T
  include Comparable.Make_plain (T)
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

let kind : t -> Kind.t = function
  | Ap_Tchagui _ -> Ap_Tchagui
  | Yop_Tchagui _ -> Yop_Tchagui
;;
