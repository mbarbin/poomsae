let poomsae = Poomsae.poomsae_6
let index = 1 + List.length (Poomsae.preceding_poomsaes poomsae)

let%expect_test "name" =
  print_string (Poomsae.name poomsae);
  [%expect {| TAE GEUG YOUK JANG |}];
  print_s [%sexp { index : int }];
  [%expect {| ((index 6)) |}]
;;

(* Some facts about this poomsae. *)

let%expect_test "elements" =
  print_s [%sexp (Poomsae.elements poomsae : Poomsae.Elements.t)];
  [%expect
    {|
    ((positions (Ap_Seugui Ap_Koubi_Seugui Dwitt_Koubi Naranhi_Seugui))
     (blocks (
       Maki
       Bakkat_Maki
       Sonnal_Maki
       Han_Sonnal_Pitreu_Maki
       Are_Hetcheu_Maki
       Batangson_Maki))
     (hand_attacks (Jileugui))
     (kicks (Ap_Tchagui Dolyeu_Tchagui))) |}]
;;

let%expect_test "new elements" =
  print_s [%sexp (Poomsae.new_elements poomsae : Poomsae.Elements.t)];
  [%expect
    {|
    ((positions (Naranhi_Seugui))
     (blocks (Han_Sonnal_Pitreu_Maki Are_Hetcheu_Maki Batangson_Maki))
     (kicks (Dolyeu_Tchagui))) |}]
;;

let%expect_test "displacement" =
  (* One returns at the point of origin at the end of the poomsae. *)
  print_s [%sexp (Poomsae.displacement_returns_to_origin poomsae : unit Or_error.t)];
  [%expect
    {|
    (Error (
      "Poomsae displacement does not return to origin"
      "TAE GEUG YOUK JANG"
      ((
        displacement (
          (north (
            (ap_seugui          2)
            (ap_koubi_seugui    4)
            (dwitt_koubi        2)
            (wen_or_oren_seugui 0)
            (dwitt_koa          0)
            (beum_seugui        0)))
          (west (
            (ap_seugui          0)
            (ap_koubi_seugui    4)
            (dwitt_koubi        2)
            (wen_or_oren_seugui 0)
            (dwitt_koa          0)
            (beum_seugui        0)))
          (east (
            (ap_seugui          0)
            (ap_koubi_seugui    4)
            (dwitt_koubi        2)
            (wen_or_oren_seugui 0)
            (dwitt_koa          0)
            (beum_seugui        0)))
          (south (
            (ap_seugui          0)
            (ap_koubi_seugui    0)
            (dwitt_koubi        0)
            (wen_or_oren_seugui 0)
            (dwitt_koa          0)
            (beum_seugui        0)))))))) |}]
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
    (North North North)
    (West West East East)
    (North North North North) |}]
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
    ((West a)
     (West b)
     (East a')
     (East b'))
    ((North c)
     (North d))
    ((West e)
     (West f)
     (East e')
     (East f'))
    ((North g)
     (North h)
     (North d'))
    ((West a')
     (West b')
     (East a)
     (East b))
    ((North i)
     (North i')
     (North j)
     (North j')) |}]
;;

let%expect_test "trigram" =
  let trigram = Poomsae.Trigram.compute (Poomsae.movements poomsae) in
  Or_error.iter trigram ~f:(fun t ->
    assert (index = Poomsae.Trigram.index (fst t));
    t |> fst |> Poomsae.Trigram.top_down_lines |> List.iter ~f:print_endline);
  [%expect
    {|
    --  --
    ------
    --  -- |}];
  print_s [%sexp (trigram : (Poomsae.Trigram.t * Sexp.t) Or_error.t)];
  [%expect
    {|
    (Ok (
      ((top_line    Two_parts)
       (middle_line Plain)
       (bottom_line Two_parts))
      ((
        lateral_displacements (
          (8 ((west 3) (east 2)))
          (4 ((west 6) (east 0)))
          (0 ((west 3) (east 2)))))))) |}]
;;
