open! Core

let poomsae = Poomsae.poomsae_1

(* Some facts about this poomsae. *)

let%expect_test "displacement" =
  (* One returns at the point of origin at the end of the poomsae. *)
  print_s [%sexp (Poomsae.displacement_returns_to_origin poomsae : unit Or_error.t)];
  [%expect {| (Ok ()) |}]
;;

let%expect_test "positions" =
  (* On the West and East directions, all positions are [Ap_Seugui]
     and on the North and South they are [Ap_Koubi_Seugui], without
     exceptions. *)
  List.iter (Poomsae.movements poomsae) ~f:(fun movement ->
    match movement.direction, movement.position with
    | (North | South), Ap_Koubi_Seugui _ | (West | East), Ap_Seugui _ -> ()
    | _ ->
      raise_s [%sexp "Unexpected direction * position", (movement : Poomsae.Movement.t)]);
  [%expect {||}];
  (* When entering the North or South direction with the
     [Ap_Koubi_Seugui], it's always from an [Ap_Seugui] position, and
     the front_foot is the same as it was previously.

     When two [Ap_Koubi_Seugui] are consecutive, the foot changes.

     When going on an [Ap_Seugui] from and [Ap_Koubi_Seugui], it's
     always with the opposite foot.

     When going from an [Ap_Seugui] to an [Ap_Seugui], if the
     direction changes, the same foot is kept, otherwise the foot is
     the opposite. *)
  Poomsae.iter_consecutive_movements poomsae ~f:(fun m1 m2 ->
    match
      match m2.position with
      | Ap_Seugui { front_foot } ->
        (match m1.position with
         | Ap_Koubi_Seugui { front_foot = previous_foot } ->
           if Poomsae.Side.equal previous_foot front_foot then Error () else Ok ()
         | Ap_Seugui { front_foot = previous_foot } ->
           (match
              ( Poomsae.Direction.equal m1.direction m2.direction
              , Poomsae.Side.equal front_foot previous_foot )
            with
            | true, false | false, true -> Ok ()
            | true, true | false, false -> Error ()))
      | Ap_Koubi_Seugui { front_foot } ->
        (match m1.position with
         | Ap_Seugui { front_foot = previous_foot } ->
           if Poomsae.Side.equal previous_foot front_foot then Ok () else Error ()
         | Ap_Koubi_Seugui { front_foot = previous_foot } ->
           if Poomsae.Side.equal previous_foot front_foot then Error () else Ok ())
    with
    | Ok () -> ()
    | Error () ->
      raise_s
        [%sexp
          "Unexpected position sequence"
          , (m1 : Poomsae.Movement.t)
          , (m2 : Poomsae.Movement.t)]);
  [%expect {||}]
;;

let%expect_test "hand attacks levels" =
  (* All hand attacks are at mid level. *)
  List.iter (Poomsae.movements poomsae) ~f:(fun movement ->
    Poomsae.Technique.iter movement.technique ~f:(function
      | Block _ | Kick _ | Linked _ -> ()
      | Hand_attack (Jileugui { hand = Left | Right; level }) ->
        if not (Poomsae.Level.equal level Momtong)
        then raise_s [%sexp "Unexpected level", (movement : Poomsae.Movement.t)]));
  [%expect {||}]
;;

let%expect_test "kicks levels" =
  (* All kick attacks are at high level. *)
  List.iter (Poomsae.movements poomsae) ~f:(fun movement ->
    Poomsae.Technique.iter movement.technique ~f:(function
      | Block _ | Hand_attack _ | Linked _ -> ()
      | Kick (Ap_Tchagui { foot = Left | Right; level }) ->
        if not (Poomsae.Level.equal level Eulgoul)
        then raise_s [%sexp "Unexpected level", (movement : Poomsae.Movement.t)]));
  [%expect {||}]
;;

let%expect_test "Blocks level" =
  (* All blocks that happen on the West and East direction are in
     largely increasing levels throughout the poomsae, starting from
     the lower level and going up to the highest level. *)
  let level =
    List.fold
      (Poomsae.movements poomsae)
      ~init:Poomsae.Level.Ale
      ~f:(fun level movement ->
      match movement.direction with
      | North | South -> level
      | West | East ->
        Poomsae.Technique.fold movement.technique ~init:level ~f:(fun level technique ->
          match technique with
          | Hand_attack _ | Kick _ | Linked _ -> level
          | Block (Maki { hand = Left | Right; level = next_level }) ->
            (match Poomsae.Level.compare level next_level |> Ordering.of_int with
             | Less | Equal -> next_level
             | Greater ->
               raise_s
                 [%sexp
                   "Unexpected level"
                   , (movement : Poomsae.Movement.t)
                   , { previous_level = (level : Poomsae.Level.t)
                     ; next_level : Poomsae.Level.t
                     }])))
  in
  assert (Poomsae.Level.equal level Eulgoul);
  [%expect {||}];
  (* All blocks that are on the North and South are on Ap_Koubi_Seugui
     position and Ale level, with the same hand as the foot of the
     position. *)
  List.iter (Poomsae.movements poomsae) ~f:(fun movement ->
    match movement.direction with
    | West | East -> ()
    | North | South ->
      (match movement.position with
       | Ap_Seugui _ ->
         raise_s [%sexp "Unexpected position", (movement : Poomsae.Movement.t)]
       | Ap_Koubi_Seugui { front_foot } ->
         Poomsae.Technique.iter movement.technique ~f:(function
           | Hand_attack _ | Kick _ | Linked _ -> ()
           | Block (Maki { hand; level }) ->
             if not (Poomsae.Side.equal hand front_foot && Poomsae.Level.equal level Ale)
             then raise_s [%sexp "Unexpected position", (movement : Poomsae.Movement.t)])));
  [%expect {||}];
  ()
;;