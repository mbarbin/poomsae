open! Core

let poomse = Poomse.poomse_1

let%expect_test "displacement" =
  print_s [%sexp (Poomse.displacement_returns_to_origin poomse : unit Or_error.t)];
  [%expect {| (Ok ()) |}]
;;
