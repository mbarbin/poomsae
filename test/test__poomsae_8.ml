open! Core

let poomsae = Poomsae.poomsae_8

let%expect_test "name" =
  print_string (Poomsae.name poomsae);
  [%expect {| TAE GEUG PAL JANG |}]
;;

(* Some facts about this poomsae. *)

let%expect_test "displacement" =
  (* One returns at the point of origin at the end of the poomsae. *)
  print_s [%sexp (Poomsae.displacement_returns_to_origin poomsae : unit Or_error.t)];
  [%expect {| (Ok ()) |}]
;;
