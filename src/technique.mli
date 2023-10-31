type t =
  | Block of Block.t
  | Hand_attack of Hand_attack.t
  | Kick of Kick.t
  | Misc_movement of Misc_movement.t
  | Chained of t list
[@@deriving equal, compare, enumerate, hash, sexp_of]

(** Iter on all [t]s, decomposing [Chained _] ts. *)
val iter : t -> f:(t -> unit) -> unit

(** Fold on all [t]s, decomposing [Chained _] ts. *)
val fold : t -> init:'a -> f:('a -> t -> 'a) -> 'a

(** Reverse the hand and the foot on the techniques. *)
val mirror : t -> t
