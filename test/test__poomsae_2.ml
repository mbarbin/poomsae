open! Core

let poomsae = Poomsae.poomsae_2
let index = 1 + List.length (Poomsae.preceding_poomsaes poomsae)

let%expect_test "name" =
  print_string (Poomsae.name poomsae);
  [%expect {| TAE GEUG YI JANG |}];
  print_s [%sexp { index : int }];
  [%expect {| ((index 2)) |}]
;;

(* Some facts about this poomsae. *)

let%expect_test "elements" =
  print_s [%sexp (Poomsae.elements poomsae : Poomsae.Elements.t)];
  [%expect
    {|
    ((positions (Ap_Seugui Ap_Koubi_Seugui)) (blocks (Maki))
     (hand_attacks (Jileugui)) (kicks (Ap_Tchagui))) |}]
;;

let%expect_test "new elements" =
  print_s [%sexp (Poomsae.new_elements poomsae : Poomsae.Elements.t)];
  [%expect {|
    () |}]
;;

let%expect_test "displacement" =
  (* One returns at the point of origin at the end of the poomsae. *)
  print_s [%sexp (Poomsae.displacement_returns_to_origin poomsae : unit Or_error.t)];
  [%expect {| (Ok ()) |}]
;;

let%expect_test "positions" =
  (* On the North and South, all positions are [Ap_Seugui]. On the
     West and East, the first is always an [Ap_Seugui], and if there's
     a second movement that follows, it is an [Ap_Koubi_Seugui]. *)
  let assert_ap_seugui (movement : Poomsae.Movement.t) =
    match movement.position with
    | Ap_Seugui _ -> ()
    | _ -> raise_s [%sexp "Unexpected position", (movement : Poomsae.Movement.t)]
  and assert_ap_koubi_seugui (movement : Poomsae.Movement.t) =
    match movement.position with
    | Ap_Koubi_Seugui _ -> ()
    | _ -> raise_s [%sexp "Unexpected position", (movement : Poomsae.Movement.t)]
  in
  List.iter (Poomsae.movements poomsae) ~f:(fun movement ->
    match movement.direction with
    | North | South -> assert_ap_seugui movement
    | West | East -> ());
  Poomsae.iter_consecutive_movements poomsae ~f:(fun m1 m2 ->
    match m1.direction, m2.direction with
    | East, East | West, West ->
      assert_ap_seugui m1;
      assert_ap_koubi_seugui m2
    | _ -> ());
  (* The front foot is characterized by position change between consecutive movements. *)
  Poomsae.iter_consecutive_movements poomsae ~f:(fun m1 m2 ->
    match
      match m1.position, m2.position with
      | ( Ap_Seugui { front_foot = f1 }
        , (Ap_Koubi_Seugui { front_foot = f2 } | Ap_Seugui { front_foot = f2 }) )
      | Ap_Koubi_Seugui { front_foot = f1 }, Ap_Koubi_Seugui { front_foot = f2 } ->
        not (Poomsae.Side.equal f1 f2)
      | Ap_Koubi_Seugui { front_foot = f1 }, Ap_Seugui { front_foot = f2 } ->
        Poomsae.Side.equal f1 f2
      | _ -> true
    with
    | true -> ()
    | false ->
      raise_s
        [%sexp
          "Unexpected position change"
          , { m1 : Poomsae.Movement.t; m2 : Poomsae.Movement.t }]);
  ()
;;

let%expect_test "blocks level" =
  (* All blocks that happen on the North direction are in largely
     increasing levels throughout the poomsae, starting from mid level
     going up to the highest level. *)
  let level =
    List.fold
      (Poomsae.movements poomsae)
      ~init:Poomsae.Level.Montong
      ~f:(fun level movement ->
      match movement.direction with
      | West | East | South -> level
      | North ->
        Poomsae.Technique.fold movement.technique ~init:level ~f:(fun level technique ->
          match technique with
          | Hand_attack _ | Kick _ | Chained _ -> level
          | Block
              ( Han_Sonnal_Maki _
              | Bakkat_Maki _
              | Sonnal_Maki _
              | Han_Sonnal_Pitreu_Maki _
              | Are_Hetcheu_Maki _
              | Batangson_Maki _ ) ->
            raise_s [%sexp "Unexpected block", (movement : Poomsae.Movement.t)]
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
  (* All blocks that happen on the West and East direction are in
     largely increasing levels throughout the poomsae, starting from
     low level going up to the mid level. *)
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
          | Hand_attack _ | Kick _ | Chained _ -> level
          | Block
              ( Han_Sonnal_Maki _
              | Bakkat_Maki _
              | Sonnal_Maki _
              | Han_Sonnal_Pitreu_Maki _
              | Are_Hetcheu_Maki _
              | Batangson_Maki _ ) ->
            raise_s [%sexp "Unexpected block", (movement : Poomsae.Movement.t)]
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
  assert (Poomsae.Level.equal level Montong);
  ()
;;

let%expect_test "directions" =
  List.map (Poomsae.movements poomsae) ~f:(fun t -> t.direction)
  |> Poomsae.Direction.group_by_axis
  |> List.iter ~f:(fun directions ->
       print_s [%sexp (directions : Poomsae.Direction.t list)]);
  [%expect
    {|
    (West West East East)
    (North North)
    (West West East East)
    (North North)
    (East West)
    (South South South South) |}]
;;

let%expect_test "mirror movements" =
  let movements = Poomsae.find_mirror_movements poomsae in
  let lines =
    List.group movements ~break:(fun (m1, _) (m2, _) ->
      not Poomsae.Direction.(Axis.equal (axis m1.direction) (axis m2.direction)))
  in
  List.iter lines ~f:(fun movements ->
    let movements =
      List.map movements ~f:(fun (m, maybe_mirror) -> m.direction, maybe_mirror)
    in
    print_s [%sexp (movements : (Poomsae.Direction.t * Poomsae.Maybe_mirror.t) list)]);
  [%expect
    {|
    ((West a) (West b) (East a') (East b'))
    ((North c) (North c'))
    ((West a) (West d) (East a') (East d'))
    ((North e) (North e'))
    ((East c) (West c'))
    ((South a) (South f) (South f') (South f)) |}]
;;

let%expect_test "trigram" =
  let trigram = Poomsae.Trigram.compute (Poomsae.movements poomsae) in
  Or_error.iter trigram ~f:(fun t ->
    assert (index = Poomsae.Trigram.index (fst t));
    t |> fst |> Poomsae.Trigram.top_down_lines |> List.iter ~f:print_endline);
  [%expect {|
    --  --
    ------
    ------
  |}];
  print_s [%sexp (trigram : (Poomsae.Trigram.t * Sexp.t) Or_error.t)];
  [%expect
    {|
    (Ok
     (((top_line Two_parts) (middle_line Plain) (bottom_line Plain))
      ((lateral_displacements
        ((4 ((west 0) (east 1))) (2 ((west 4) (east 0))) (0 ((west 4) (east 0)))))))) |}]
;;
