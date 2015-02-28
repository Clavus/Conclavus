project = 'Conclavus'
file = { '../Conclavus', exclude = { '../Conclavus/engine/lib' } }
readme = 'readme.md'
format = 'markdown'
not_luadoc = true
backtick_references = true
alias("p","param")
alias("r","return")
new_type("util","Utility", true)
new_type("extend","Extensions", true)