open! Base

module Kind = struct
  module T = struct
    type t =
      | Ap_Tchagui
      | Yop_Tchagui
      | Dolyeu_Tchagui
    [@@deriving equal, compare, enumerate, hash, sexp_of]
  end

  include T
  include Comparable.Make (T)
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
  | Dolyeu_Tchagui of
      { foot : Side.t
      ; level : Level.t
      }
[@@deriving equal, compare, enumerate, hash, sexp_of]

let kind : t -> Kind.t = function
  | Ap_Tchagui _ -> Ap_Tchagui
  | Yop_Tchagui _ -> Yop_Tchagui
  | Dolyeu_Tchagui _ -> Dolyeu_Tchagui
;;

let mirror = function
  | Ap_Tchagui { foot; level } -> Ap_Tchagui { foot = Side.mirror foot; level }
  | Yop_Tchagui { foot; level } -> Yop_Tchagui { foot = Side.mirror foot; level }
  | Dolyeu_Tchagui { foot; level } -> Dolyeu_Tchagui { foot = Side.mirror foot; level }
;;
