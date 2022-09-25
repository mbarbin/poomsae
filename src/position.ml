open! Core

module Kind = struct
  type t =
    | Ap_Seugui
    | Ap_Koubi_Seugui
    | Dwitt_Koubi
  [@@deriving equal, compare, enumerate, hash, sexp_of]
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
