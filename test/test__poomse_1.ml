open! Core

let poomse = Poomse.poomse_1

(* Some facts about this poomse. *)

let%expect_test "displacement" =
  (* One returns at the point of origin at the end of the poomse. *)
  print_s [%sexp (Poomse.displacement_returns_to_origin poomse : unit Or_error.t)];
  [%expect {| (Ok ()) |}]
;;

let%expect_test "positions" =
  (* On the West and East directions, all positions are [Ap_Seugui]
     and on the North and South they are [Ap_Koubi_Seugui], without
     exceptions. *)
  List.iter (Poomse.movements poomse) ~f:(fun movement ->
    match movement.direction, movement.position with
    | (North | South), Ap_Koubi_Seugui _ | (West | East), Ap_Seugui _ -> ()
    | _ ->
      raise_s [%sexp "Unexpected direction * position", (movement : Poomse.Movement.t)]);
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
  Poomse.iter_consecutive_movements poomse ~f:(fun m1 m2 ->
    match
      match m2.position with
      | Ap_Seugui { front_foot } ->
        (match m1.position with
         | Ap_Koubi_Seugui { front_foot = previous_foot } ->
           if Poomse.Side.equal previous_foot front_foot then Error () else Ok ()
         | Ap_Seugui { front_foot = previous_foot } ->
           (match
              ( Poomse.Direction.equal m1.direction m2.direction
              , Poomse.Side.equal front_foot previous_foot )
            with
            | true, false | false, true -> Ok ()
            | true, true | false, false -> Error ()))
      | Ap_Koubi_Seugui { front_foot } ->
        (match m1.position with
         | Ap_Seugui { front_foot = previous_foot } ->
           if Poomse.Side.equal previous_foot front_foot then Ok () else Error ()
         | Ap_Koubi_Seugui { front_foot = previous_foot } ->
           if Poomse.Side.equal previous_foot front_foot then Error () else Ok ())
    with
    | Ok () -> ()
    | Error () ->
      raise_s
        [%sexp
          "Unexpected position sequence"
          , (m1 : Poomse.Movement.t)
          , (m2 : Poomse.Movement.t)]);
  [%expect {||}]
;;

let%expect_test "hand attacks levels" =
  (* All hand attacks are at mid level. *)
  List.iter (Poomse.movements poomse) ~f:(fun movement ->
    Poomse.Technique.iter movement.technique ~f:(function
      | Block _ | Kick _ | Linked _ -> ()
      | Hand_attack (Jileugui { hand = Left | Right; level }) ->
        if not (Poomse.Level.equal level Momtong)
        then raise_s [%sexp "Unexpected level", (movement : Poomse.Movement.t)]));
  [%expect {||}]
;;

let%expect_test "kicks levels" =
  (* All kick attacks are at high level. *)
  List.iter (Poomse.movements poomse) ~f:(fun movement ->
    Poomse.Technique.iter movement.technique ~f:(function
      | Block _ | Hand_attack _ | Linked _ -> ()
      | Kick (Ap_Tchagui { foot = Left | Right; level }) ->
        if not (Poomse.Level.equal level Eulgoul)
        then raise_s [%sexp "Unexpected level", (movement : Poomse.Movement.t)]));
  [%expect {||}]
;;

let%expect_test "Blocks level" =
  (* All blocks that happen on the West and East direction are in
     largely increasing levels throughout the poomse, starting from
     the lower level and going up to the highest level. *)
  let level =
    List.fold (Poomse.movements poomse) ~init:Poomse.Level.Ale ~f:(fun level movement ->
      match movement.direction with
      | North | South -> level
      | West | East ->
        Poomse.Technique.fold movement.technique ~init:level ~f:(fun level technique ->
          match technique with
          | Hand_attack _ | Kick _ | Linked _ -> level
          | Block (Maki { hand = Left | Right; level = next_level }) ->
            (match Poomse.Level.compare level next_level |> Ordering.of_int with
             | Less | Equal -> next_level
             | Greater ->
               raise_s
                 [%sexp
                   "Unexpected level"
                   , (movement : Poomse.Movement.t)
                   , { previous_level = (level : Poomse.Level.t)
                     ; next_level : Poomse.Level.t
                     }])))
  in
  assert (Poomse.Level.equal level Eulgoul);
  [%expect {||}];
  (* All blocks that are on the North and South are on Ap_Koubi_Seugui
     position and Ale level, with the same hand as the foot of the
     position. *)
  List.iter (Poomse.movements poomse) ~f:(fun movement ->
    match movement.direction with
    | West | East -> ()
    | North | South ->
      (match movement.position with
       | Ap_Seugui _ ->
         raise_s [%sexp "Unexpected position", (movement : Poomse.Movement.t)]
       | Ap_Koubi_Seugui { front_foot } ->
         Poomse.Technique.iter movement.technique ~f:(function
           | Hand_attack _ | Kick _ | Linked _ -> ()
           | Block (Maki { hand; level }) ->
             if not (Poomse.Side.equal hand front_foot && Poomse.Level.equal level Ale)
             then raise_s [%sexp "Unexpected position", (movement : Poomse.Movement.t)])));
  [%expect {||}];
  ()
;;
