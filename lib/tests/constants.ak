use aiken/collection/list
use aiken/math/rational.{Rational}
use aiken/option
use config
use env
use modules/constants

test int() {
  trace @"NETWORK": config.network, env.magic
  and {
    config.price == 1_000_000,
    constants.the_ultimate_answer_of_everything == 42,
  }
}

test bytearray() {
  and {
    config.owner == #"0000111122223333",
    constants.pkh == #"00000000000000000000000000000000000000000000000000000056",
  }
}

test bool() {
  config.is_mainnet && env.read_only
}

test tuple() {
  expect
    when config.asset is {
      ("HOSKY", 42) -> True
      ("HOSKY", qty) -> qty == 24
      (asset_name, _) -> asset_name == "HOSKY"
    }

  expect
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
    list.at(config.quotas, 0) == Some(1),
    list.at(config.quotas, 1) == Some(2),
    list.at(config.quotas, 2) == Some(3),
    list.at(config.quotas, 3) == None,
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
