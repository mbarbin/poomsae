open! Core

let poomsae = Poomsae.poomsae_8

let%expect_test "name" =
  print_string (Poomsae.name poomsae);
  [%expect {| TAE GEUG PAL JANG |}]
;;

(* Some facts about this poomsae. *)

let%expect_test "elements" =
  print_s [%sexp (Poomsae.elements poomsae : Poomsae.Elements.t)];
  [%expect {| () |}]
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
  [%expect {| |}]
;;

let%expect_test "trigram" =
  let trigram = Poomsae.Trigram.compute (Poomsae.movements poomsae) in
  Or_error.iter trigram ~f:(fun t ->
    t |> fst |> Poomsae.Trigram.top_down_lines |> List.iter ~f:print_endline);
  [%expect {||}];
  print_s [%sexp (trigram : (Poomsae.Trigram.t * Sexp.t) Or_error.t)];
  [%expect {|
    (Error ("Unexpected displacements" ((lateral_displacements ())))) |}]
;;
