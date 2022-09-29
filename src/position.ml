open! Core

module Kind = struct
  module T = struct
    type t =
      | Ap_Seugui
      | Ap_Koubi_Seugui
      | Dwitt_Koubi
      | Wen_Seugui
      | Oren_Seugui
      | Dwitt_Koa
    [@@deriving equal, compare, enumerate, hash, sexp_of]
  end

  include T
  include Comparable.Make_plain (T)
end

type t =
  | Ap_Seugui of { front_foot : Side.t }
  | Ap_Koubi_Seugui of { front_foot : Side.t }
  | Dwitt_Koubi of { front_foot : Side.t }
  | Wen_Seugui
  | Oren_Seugui
  | Dwitt_Koa of { front_foot : Side.t }
[@@deriving equal, compare, enumerate, hash, sexp_of]

let front_foot : t -> Side.t = function
  | Ap_Seugui { front_foot }
  | Ap_Koubi_Seugui { front_foot }
  | Dwitt_Koubi { front_foot }
  | Dwitt_Koa { front_foot } -> front_foot
  | Wen_Seugui -> Left
  | Oren_Seugui -> Right
;;

let kind : t -> Kind.t = function
  | Ap_Seugui _ -> Ap_Seugui
  | Ap_Koubi_Seugui _ -> Ap_Koubi_Seugui
  | Dwitt_Koubi _ -> Dwitt_Koubi
  | Wen_Seugui -> Wen_Seugui
  | Oren_Seugui -> Oren_Seugui
  | Dwitt_Koa _ -> Dwitt_Koa
;;

let mirror = function
  | Ap_Seugui { front_foot = f } -> Ap_Seugui { front_foot = Side.mirror f }
  | Ap_Koubi_Seugui { front_foot = f } -> Ap_Koubi_Seugui { front_foot = Side.mirror f }
  | Dwitt_Koubi { front_foot = f } -> Dwitt_Koubi { front_foot = Side.mirror f }
  | Wen_Seugui -> Oren_Seugui
  | Oren_Seugui -> Wen_Seugui
  | Dwitt_Koa { front_foot = f } -> Dwitt_Koa { front_foot = Side.mirror f }
;;
