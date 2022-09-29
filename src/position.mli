open! Core

module Kind : sig
  type t =
    | Ap_Seugui
    | Ap_Koubi_Seugui
    | Dwitt_Koubi
    | Wen_Seugui
    | Oren_Seugui
    | Dwitt_Koa
    | Naranhi_Seugui
  [@@deriving equal, compare, enumerate, hash, sexp_of]

  include Comparable.S_plain with type t := t
end

type t =
  | Ap_Seugui of { front_foot : Side.t }
  | Ap_Koubi_Seugui of { front_foot : Side.t }
  | Dwitt_Koubi of { front_foot : Side.t }
  | Wen_Seugui
  | Oren_Seugui
  | Dwitt_Koa of { front_foot : Side.t }
  | Naranhi_Seugui
[@@deriving equal, compare, enumerate, hash, sexp_of]

val front_foot : t -> Side.t option
val kind : t -> Kind.t

(** Changes the foot *)
val mirror : t -> t
