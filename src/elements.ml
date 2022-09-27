open! Core

type t =
  { positions : Set.M(Position.Kind).t [@sexp_drop_if Set.is_empty]
  ; blocks : Set.M(Block.Kind).t [@sexp_drop_if Set.is_empty]
  ; hand_attacks : Set.M(Hand_attack.Kind).t [@sexp_drop_if Set.is_empty]
  ; kicks : Set.M(Kick.Kind).t [@sexp_drop_if Set.is_empty]
  }
[@@deriving sexp_of]

let empty =
  { positions = Set.empty (module Position.Kind)
  ; blocks = Set.empty (module Block.Kind)
  ; hand_attacks = Set.empty (module Hand_attack.Kind)
  ; kicks = Set.empty (module Kick.Kind)
  }
;;

let add_movement t { Movement.direction = _; position; technique } =
  let t = { t with positions = Set.add t.positions (Position.kind position) } in
  Technique.fold technique ~init:t ~f:(fun t technique ->
    match technique with
    | Block block -> { t with blocks = Set.add t.blocks (Block.kind block) }
    | Hand_attack hand_attack ->
      { t with hand_attacks = Set.add t.hand_attacks (Hand_attack.kind hand_attack) }
    | Kick kick -> { t with kicks = Set.add t.kicks (Kick.kind kick) }
    | Chained _ -> assert false)
;;

let union t1 t2 =
  { positions = Set.union t1.positions t2.positions
  ; blocks = Set.union t1.blocks t2.blocks
  ; hand_attacks = Set.union t1.hand_attacks t2.hand_attacks
  ; kicks = Set.union t1.kicks t2.kicks
  }
;;

let diff t1 t2 =
  { positions = Set.diff t1.positions t2.positions
  ; blocks = Set.diff t1.blocks t2.blocks
  ; hand_attacks = Set.diff t1.hand_attacks t2.hand_attacks
  ; kicks = Set.diff t1.kicks t2.kicks
  }
;;
