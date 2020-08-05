{-
Welcome to a Spago project!
You can edit this file as you like.
-}
{ name = "my-project"
, dependencies =
  [ "console"
  , "contravariant"
  , "datetime"
  , "effect"
  , "js-date"
  , "now"
  , "psci-support"
  , "smolder"
  , "web-dom"
  ]
, packages = ./packages.dhall
, sources = [ "src/**/*.purs", "test/**/*.purs" ]
}
