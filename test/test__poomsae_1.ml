open! Core

let poomsae = Poomsae.poomsae_1
let index = 1 + List.length (Poomsae.preceding_poomsaes poomsae)

let%expect_test "name" =
  print_string (Poomsae.name poomsae);
  [%expect {| TAE GEUG IL JANG |}];
  print_s [%sexp { index : int }];
  [%expect {| ((index 1)) |}]
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
  [%expect
    {|
    ((positions (Ap_Seugui Ap_Koubi_Seugui)) (blocks (Maki))
     (hand_attacks (Jileugui)) (kicks (Ap_Tchagui))) |}]
;;

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
      | Dwitt_Koubi _ | Wen_Seugui | Oren_Seugui -> Error ()
      | Ap_Seugui { front_foot } ->
        (match m1.position with
         | Dwitt_Koubi _ | Wen_Seugui | Oren_Seugui -> Error ()
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
         | Dwitt_Koubi _ | Wen_Seugui | Oren_Seugui -> Error ()
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
  (* All hand attacks are Jileugui at mid level. *)
  List.iter (Poomsae.movements poomsae) ~f:(fun movement ->
    Poomsae.Technique.iter movement.technique ~f:(function
      | Block _ | Kick _ | Linked _ -> ()
      | Hand_attack
          ( Han_Sonnal_Mok_Tchigui { hand = Left | Right }
          | Jebipoum_Mok_Tchigui { hand = Left | Right }
          | Pyon_Sonn_Seo_Jileugui { hand = Left | Right }
          | Deung_Joumok_Ap_Tchigui { hand = Left | Right; level = _ }
          | Me_Jumok_Nelyeu_Tchigui { hand = Left | Right } ) ->
        raise_s [%sexp "Unexpected movement", (movement : Poomsae.Movement.t)]
      | Hand_attack (Jileugui { hand = Left | Right; level }) ->
        if not (Poomsae.Level.equal level Montong)
        then raise_s [%sexp "Unexpected level", (movement : Poomsae.Movement.t)]));
  [%expect {||}]
;;

let%expect_test "kicks levels" =
  (* All kick attacks are Ap_Tchagui at high level. *)
  List.iter (Poomsae.movements poomsae) ~f:(fun movement ->
    Poomsae.Technique.iter movement.technique ~f:(function
      | Block _ | Hand_attack _ | Linked _ -> ()
      | Kick (Yop_Tchagui { foot = Left | Right; level = _ }) ->
        raise_s [%sexp "Unexpected movement", (movement : Poomsae.Movement.t)]
      | Kick (Ap_Tchagui { foot = Left | Right; level }) ->
        if not (Poomsae.Level.equal level Eulgoul)
        then raise_s [%sexp "Unexpected level", (movement : Poomsae.Movement.t)]));
  [%expect {||}]
;;

let%expect_test "blocks level" =
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
          | Block (Han_Sonnal_Maki _ | Bakkat_Maki _ | Sonnal_Maki _) ->
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
  [%expect {||}];
  (* All blocks that are on the North and South are on Ap_Koubi_Seugui
     position and Ale level, with the same hand as the foot of the
     position. *)
  List.iter (Poomsae.movements poomsae) ~f:(fun movement ->
    match movement.direction with
    | West | East -> ()
    | North | South ->
      (match movement.position with
       | Ap_Seugui _ | Dwitt_Koubi _ | Wen_Seugui | Oren_Seugui ->
         raise_s [%sexp "Unexpected position", (movement : Poomsae.Movement.t)]
       | Ap_Koubi_Seugui { front_foot } ->
         Poomsae.Technique.iter movement.technique ~f:(function
           | Hand_attack _ | Kick _ | Linked _ -> ()
           | Block (Han_Sonnal_Maki _ | Bakkat_Maki _ | Sonnal_Maki _) ->
             raise_s [%sexp "Unexpected block", (movement : Poomsae.Movement.t)]
           | Block (Maki { hand; level }) ->
             if not (Poomsae.Side.equal hand front_foot && Poomsae.Level.equal level Ale)
             then raise_s [%sexp "Unexpected position", (movement : Poomsae.Movement.t)])));
  [%expect {||}];
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
    (North)
    (East East West West)
    (North)
    (West West East East)
    (South South) |}]
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
    ((North c))
    ((East d) (East e) (West d') (West e'))
    ((North c'))
    ((West f) (West g) (East f') (East g'))
    ((South h) (South i)) |}]
;;

let%expect_test "trigram" =
  let trigram = Poomsae.Trigram.compute (Poomsae.movements poomsae) in
  Or_error.iter trigram ~f:(fun t ->
    assert (index = Poomsae.Trigram.index (fst t));
    t |> fst |> Poomsae.Trigram.top_down_lines |> List.iter ~f:print_endline);
  [%expect {|
    ------
    ------
    ------
  |}];
  print_s [%sexp (trigram : (Poomsae.Trigram.t * Sexp.t) Or_error.t)];
  [%expect
    {|
    (Ok
     (((top_line Plain) (middle_line Plain) (bottom_line Plain))
      ((lateral_displacements
        ((6 ((west 2) (east 0))) (3 ((west 0) (east 2))) (0 ((west 2) (east 0)))))))) |}]
;;
