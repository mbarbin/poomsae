open! Base

module Kind : sig
  type t =
    | Ap_Tchagui
    | Yop_Tchagui
    | Dolyeu_Tchagui
  [@@deriving equal, compare, enumerate, hash, sexp_of]

  include Comparable.S with type t := t
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

val kind : t -> Kind.t

(** Changes the foot *)
val mirror : t -> t
