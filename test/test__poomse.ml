open! Core

let%expect_test "hello" =
  print_s Poomse.hello_world;
  [%expect {| "Hello, World!" |}]
;;