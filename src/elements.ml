type t =
  { positions : Set.M(Position.Kind).t [@sexp_drop_if Set.is_empty]
  ; blocks : Set.M(Block.Kind).t [@sexp_drop_if Set.is_empty]
  ; hand_attacks : Set.M(Hand_attack.Kind).t [@sexp_drop_if Set.is_empty]
  ; kicks : Set.M(Kick.Kind).t [@sexp_drop_if Set.is_empty]
  ; misc_movements : Set.M(Misc_movement.Kind).t [@sexp_drop_if Set.is_empty]
  }
[@@deriving sexp_of]

let empty =
  { positions = Set.empty (module Position.Kind)
  ; blocks = Set.empty (module Block.Kind)
  ; hand_attacks = Set.empty (module Hand_attack.Kind)
  ; kicks = Set.empty (module Kick.Kind)
  ; misc_movements = Set.empty (module Misc_movement.Kind)
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
    | Misc_movement misc_movement ->
      { t with
        misc_movements = Set.add t.misc_movements (Misc_movement.kind misc_movement)
      }
    | Chained _ -> assert false)
;;

let union t1 t2 =
  { positions = Set.union t1.positions t2.positions
  ; blocks = Set.union t1.blocks t2.blocks
  ; hand_attacks = Set.union t1.hand_attacks t2.hand_attacks
  ; kicks = Set.union t1.kicks t2.kicks
  ; misc_movements = Set.union t1.misc_movements t2.misc_movements
  }
;;

let diff t1 t2 =
  { positions = Set.diff t1.positions t2.positions
  ; blocks = Set.diff t1.blocks t2.blocks
  ; hand_attacks = Set.diff t1.hand_attacks t2.hand_attacks
  ; kicks = Set.diff t1.kicks t2.kicks
  ; misc_movements = Set.diff t1.misc_movements t2.misc_movements
  }
;;
