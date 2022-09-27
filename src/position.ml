open! Core

module Kind = struct
  module T = struct
    type t =
      | Ap_Seugui
      | Ap_Koubi_Seugui
      | Dwitt_Koubi
    [@@deriving equal, compare, enumerate, hash, sexp_of]
  end

  include T
  include Comparable.Make_plain (T)
end

type t =
  | Ap_Seugui of { front_foot : Side.t }
  | Ap_Koubi_Seugui of { front_foot : Side.t }
  | Dwitt_Koubi of { front_foot : Side.t }
[@@deriving equal, compare, enumerate, hash, sexp_of]

let kind : t -> Kind.t = function
  | Ap_Seugui _ -> Ap_Seugui
  | Ap_Koubi_Seugui _ -> Ap_Koubi_Seugui
  | Dwitt_Koubi _ -> Dwitt_Koubi
;;

let mirror = function
  | Ap_Seugui { front_foot = f } -> Ap_Seugui { front_foot = Side.mirror f }
  | Ap_Koubi_Seugui { front_foot = f } -> Ap_Koubi_Seugui { front_foot = Side.mirror f }
  | Dwitt_Koubi { front_foot = f } -> Dwitt_Koubi { front_foot = Side.mirror f }
;;
