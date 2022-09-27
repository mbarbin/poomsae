open! Core

module Kind : sig
  type t =
    | Ap_Seugui
    | Ap_Koubi_Seugui
    | Dwitt_Koubi
  [@@deriving equal, compare, enumerate, hash, sexp_of]

  include Comparable.S_plain with type t := t
end

type t =
  | Ap_Seugui of { front_foot : Side.t }
  | Ap_Koubi_Seugui of { front_foot : Side.t }
  | Dwitt_Koubi of { front_foot : Side.t }
[@@deriving equal, compare, enumerate, hash, sexp_of]

val kind : t -> Kind.t

(** Changes the foot *)
val mirror : t -> t
