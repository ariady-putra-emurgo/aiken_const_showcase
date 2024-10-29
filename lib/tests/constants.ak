use aiken/collection/list
use aiken/math/rational.{Rational}
use aiken/option
use env
use modules/constants

test int() {
  trace @"NETWORK": env.magic
  constants.the_ultimate_answer_of_everything == 42
}

test bytearray() {
  constants.pkh == #"00000000000000000000000000000000000000000000000000000056"
}

test bool() {
  env.read_only
}

test tuple() {
  when constants.key_token is {
    ("PolicyId", "NFT", 1) -> True
    ("PolicyId", "NFT", qty) -> qty == 1
    ("PolicyId", asset_name, _) -> asset_name == "NFT"
    (policy_id, _asset_name, _qty) -> policy_id == "PolicyId"
  }
  // _ -> False // redundant
}

test list() {
  and {
    list.at(constants.direction, 0) == Some("NORTH"),
    list.at(constants.direction, 1) == Some("SOUTH"),
    list.at(constants.direction, 2) == Some("EAST"),
    list.at(constants.direction, 3) == Some("WEST"),
    list.at(constants.direction, 4) == None,
  }
}

test option() {
  option.is_none(env.maybe)
}

test function() {
  constants.function()
}

test custom_type() {
  trace @"constants.pi": constants.pi
  // Rational: https://aiken-lang.github.io/stdlib/aiken/math/rational.html
  expect Some(pi): Option<Rational> = constants.pi
  trace @"          pi": pi

  //   rational.reduce(rational.add(rational.negate(pi), pi)) == rational.zero
  // Pipe operator `|>`: https://aiken-lang.org/language-tour/control-flow#piping
  rational.zero == (
    pi
      |> rational.negate
      |> rational.add(pi)
      |> rational.reduce
  )
}
