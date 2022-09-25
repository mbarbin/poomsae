open! Core

let poomsae = Poomsae.poomsae_2

let%expect_test "name" =
  print_string (Poomsae.name poomsae);
  [%expect {| TAE GEUG YI JANG |}]
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

let%expect_test "trigram" =
  let trigram = Poomsae.Trigram.compute (Poomsae.movements poomsae) in
  Or_error.iter trigram ~f:(fun t ->
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
