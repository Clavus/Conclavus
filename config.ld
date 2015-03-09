project = 'Conclavus'
file = { '.', exclude = { 'engine/lib' } }
readme = 'readme'
format = 'markdown'
style = '.'
template = '.'
not_luadoc = true
backtick_references = true
alias("p","param")
alias("r","return")
new_type("cl","Classes",true)
new_type("mixin","Mixins",true)
new_type("util","Utility", true)
new_type("extend","Extensions", true)
new_type("lib","Libraries", true)
new_type("other","Other", true)
