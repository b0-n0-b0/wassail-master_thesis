# Rules
Rules are used in order to flag functions—of—interest, namely those function that do satisfy the rules.

## Rules grammar
A rules file contains a list of at least one rule to be applied.

All the rules will be applied with an AND fashion and a constraint on sequence can be enforced
E.G.

`rule1 > rule2` means that rule2 only applies to instructions that are following the one instruction that verifies rule1
`rule1; rule2` means that both rules must be verified, but there's no constraint on the order

Every rule must contain: 
- the mnemonic of the instruction to which it is related (i.e. int32.div_s)
- the conditions on the parameters (if not present, the instruction just needs to be there)

The rule is specified in the following way:

`mnemonic | rule_on_param1, rule_on_param2, [...]`
each rule can be an arithmetic rule (>, >= ,==, ...) or, if not rule has to be applied to that specific parameter, a single `_`